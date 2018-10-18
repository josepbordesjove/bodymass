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
  func addDataViewController(observer: DataPointObserver, weight: Double?, height: Double?, gender: Gender?) -> UIViewController
  func fetchUserGender() -> Gender?
  func deleteLastDataPoint(completion: @escaping ((Bool) -> Void))
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
      dataStore.loadAndMigrateIfNeeded { (result) in
        switch result {
        case .success:
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
            
            guard let gender = self.fetchUserGender() else {
              handler(nil, MainViewControllerErrors.pointNotFetched)
              return
            }
            
            let dataPoint = MainViewController.VM(id: id, weight: weight, height: height, gender: gender)
            handler(dataPoint, nil)
            })
        case .failure(let error):
           handler(nil, error)
        }
      }
    }
    
    func deleteLastDataPoint(completion: @escaping ((Bool) -> Void)) {
      dataStore.deleteLastDataPoint { (deleted) in
        completion(deleted)
      }
    }
    
    func addDataViewController(observer: DataPointObserver, weight: Double?, height: Double?, gender: Gender?) -> UIViewController {
      let interactor = AddDataViewController.Interactor.init(observer: observer)
      interactor.dataStore = dataStore
      return AddDataViewController.Factory.viewController(interactor: interactor, weight: weight, height: height, gender: gender)
    }
    
    func fetchUserGender() -> Gender? {
      return dataStore.fetchUserGender()
    }
    
  }
}
