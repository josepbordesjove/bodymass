//
//  SettingsInteractor.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 02/11/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import Foundation
import bodymassKit

protocol UserNameObserver: class {
  func didChangeUserName()
}

protocol SettingsInteractorType {
  func save(name: String)
}

extension SettingsViewController {
  class Interactor: SettingsInteractorType {
    var observer: UserNameObserver?
    
    required init(observer: UserNameObserver) {
      self.observer = observer
    }
    
    func save(name: String) {
      UserDefaults.standard.set(name, forKey: UserDefaultKeys.name.rawValue)
      self.observer?.didChangeUserName()
    }
    
  }
}
