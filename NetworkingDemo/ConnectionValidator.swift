//
//  ConnectionValidator.swift
//  NetworkingDemo
//
//  Created by Daniel Martínez on 13/05/22.
//

import Foundation

import Foundation
import Network

class ConnectionValidator {
  static let shared: ConnectionValidator = ConnectionValidator()
  var hasInternetCollection: Bool = false
  var connectionType: NWInterface.InterfaceType = .other
  private init() {
    validateConnection()
  }
  
  private func validateConnection() {
    let monitor = NWPathMonitor()
    monitor.pathUpdateHandler = { path in
      if path.status != .satisfied {
        self.hasInternetCollection = false
        if path.usesInterfaceType(.wifi){
          self.connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
          self.connectionType = .cellular
        }
      } else {
        self.hasInternetCollection = true
      }
    }
    monitor.start(queue: DispatchQueue.global())
  }
}
