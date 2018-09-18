//
//  MainInteractor.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 16/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

protocol MainInteractorType {
  func fetchLastDataPoint(handler: @escaping (MainViewController.VM?, Swift.Error?) -> Void)
  func addDataViewController(observer: DataPointObserver) -> UIViewController
}

extension MainViewController {
  private enum MainViewControllerErrors: String, Error {
    case pointNotFetched = "The point couldn't be fetched"
  }
  
  class Interactor: MainInteractorType {
    let dataStore: DataStore
    
    init(dataStore: DataStore) {
      self.dataStore = dataStore
    }
    
    func fetchLastDataPoint(handler: @escaping (MainViewController.VM?, Error?) -> Void) {
      dataStore.loadAndMigrateIfNeeded {
        self.dataStore.fetchLastDataPoint(completion: { (mdp) in
          guard let id = mdp?.id else {
            handler(nil, MainViewControllerErrors.pointNotFetched)
            return
          }
          
          guard let weight = mdp?.weight else {
            handler(nil, MainViewControllerErrors.pointNotFetched)
            return
          }
          
          guard let height = mdp?.height else {
            handler(nil, MainViewControllerErrors.pointNotFetched)
            return
          }
          
          let dataPoint = MainViewController.VM(id: id, weight: weight, height: height, gender: Gender.male)
          
          handler(dataPoint, nil)
        })
      }
    }
    
    func addDataViewController(observer: DataPointObserver) -> UIViewController {
      let interactor = AddDataViewController.Interactor.init(observer: observer)
      interactor.dataStore = dataStore
      return AddDataViewController.Factory.viewController(interactor: interactor)
    }
    
  }
}
