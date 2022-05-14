//
//  ViewController.swift
//  NetworkingDemo
//
//  Created by Daniel Martínez on 13/05/22.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var charactersTableView: UITableView!
  var characters: [[String:Any]] = [[String:Any]]()
  override func viewDidLoad() {
    super.viewDidLoad()
    charactersTableView.delegate = self
    charactersTableView.dataSource = self
    // Do any additional setup after loading the view. ejemplos
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if ConnectionValidator.shared.connectionType == .wifi {
      let alert = UIAlertController(title: "ERRRORRRRRR!!!", message: "no hay conexión a internet!!!!!!", preferredStyle: .alert)
      let boton = UIAlertAction(title: "Ok", style: .default) { alert in
        // se cierra el app (es como provocar un crash)
        exit(666)
      }
      alert.addAction(boton)
      self.present(alert, animated:true)
    } else if ConnectionValidator.shared.connectionType == .cellular{
      let alert = UIAlertController(title: "Confirme", message: "Solo hay conexión a internet por datos celulares", preferredStyle: .alert)
      let boton1 = UIAlertAction(title: "Continuar", style: .default) { alert in
        self.fetchCharacters()
      }
      let boton2 = UIAlertAction(title: "Cancelar", style: .cancel)
      alert.addAction(boton1)
      alert.addAction(boton2)
      self.present(alert, animated:true)
    } else {
      fetchCharacters()
    }
  }
  
  private func fetchCharacters() {
    guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return }
    let request = URLRequest(url: url)
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { data, response, error in
      if error != nil {
        print(error?.localizedDescription)
      } else {
        guard let data = data else { return }
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! [String : Any]
          self.characters = json["results"] as! [[String : Any]]
          print(self.characters)
          DispatchQueue.main.async {
            self.charactersTableView.reloadData()
          }
        }
        catch {
          print ("There was an error while parsing the JSON \(error.localizedDescription)")
        }
      }
    }.resume()
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return characters.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = characters[indexPath.row]["name"] as? String ?? "hola"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController else { return }
    detailVC.currentCharacter = SeriesCharacter(name: characters[indexPath.row]["name"] as? String ?? "hola",
                                                status: characters[indexPath.row]["status"] as? String ?? "hola",
                                                species: characters[indexPath.row]["species"] as? String ?? "hola",
                                                gender: characters[indexPath.row]["gender"] as? String ?? "hola",
                                                url: characters[indexPath.row]["image"] as? String ?? "hola")
    self.show(detailVC, sender: self)
  }
  
  
}

