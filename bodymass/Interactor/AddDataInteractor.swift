//
//  AddDataInteractor.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 16/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import bodymassKit

protocol DataPointObserver: class {
  func didCreateDataPoint()
}

protocol DataPointInteractorType {
  init(observer: DataPointObserver)
  func createDataPoint(id: String, weight: Double, height: Double)
  func saveUserGender(_ gender: Gender)
}

extension AddDataViewController {
  class Interactor: DataPointInteractorType {
    var observer: DataPointObserver?
    var dataStore: DataStore!
    
    required init(observer: DataPointObserver) {
      self.observer = observer
    }
    
    func createDataPoint(id: String, weight: Double, height: Double) {
      dataStore.loadAndMigrateIfNeeded {
        self.dataStore.saveDataPoint(id: id, weight: weight, height: height) {
          self.observer?.didCreateDataPoint()
        }
      }
    }
    
    func saveUserGender(_ gender: Gender) {
      dataStore.saveUserGender(gender)
    }
  }
}
