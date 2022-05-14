//
//  DetailViewController.swift
//  NetworkingDemo
//
//  Created by Daniel Martínez on 14/05/22.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet weak var characterImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var speciesLabel: UILabel!
  
  var currentCharacter: SeriesCharacter?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchImage()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    if let currentCharacter = currentCharacter {
      nameLabel.text = currentCharacter.name
      statusLabel.text = currentCharacter.status
      genderLabel.text = currentCharacter.gender
      speciesLabel.text = currentCharacter.species
    }
  }
  
  private func fetchImage() {
    guard let url = URL(string: currentCharacter?.url ?? "") else { return }
    let request = URLRequest(url: url)
    let session = URLSession(configuration: .default)
    session.dataTask(with: request) { data, response, error in
      if error != nil {
        print(error?.localizedDescription)
      } else {
        guard let data = data else { return }
        do {
          DispatchQueue.main.async {
            self.characterImage.image = UIImage(data: data)
          }
        }
        catch {
          print ("There was an error while parsing the JSON \(error.localizedDescription)")
        }
      }
    }.resume()
  }
}


