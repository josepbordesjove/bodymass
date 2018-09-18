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
  func createDataPoint(id: String, weight: Float, height: Float)
}

extension AddDataViewController {
  class Interactor: DataPointInteractorType {
    var observer: DataPointObserver?
    var dataStore: DataStore!
    
    required init(observer: DataPointObserver) {
      self.observer = observer
    }
    
    func createDataPoint(id: String, weight: Float, height: Float) {
      dataStore.loadAndMigrateIfNeeded {
        print("JBJ data point to be saved \(id) \(weight) \(height)")
        self.dataStore.saveDataPoint(id: id, weight: weight, height: height) {
          self.observer?.didCreateDataPoint()
        }
      }
    }
  }
}
