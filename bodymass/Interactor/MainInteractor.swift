//
//  MainInteractor.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 16/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

enum MainViewControllerInteractorError: String, Error {
  case couldNotGenerateDataPointFromManaged = "Could not generate a data point unwrapping the received managed data point"
}

protocol MainInteractorType {
  func fetchLastDataPoint(completion: @escaping (MainViewController.VM?, Swift.Error?) -> Void)
  func addDataViewController(observer: DataPointObserver, weight: Double?, height: Double?, gender: Gender?) -> UIViewController
  func fetchUserGender() -> Gender?
  func deleteLastDataPoint(completion: @escaping ((Bool) -> Void))
  func getBmiComparison(completion: @escaping (Double?) -> Void)
  func fetchAllDataPoints(completion: @escaping (([ManagedDataPoint]?) -> Void))
  func getTitle() -> String
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
    
    func fetchLastDataPoint(completion: @escaping (MainViewController.VM?, Error?) -> Void) {
      dataStore.loadAndMigrateIfNeeded { (result) in
        switch result {
        case .success:
          self.dataStore.fetchLastDataPoint(completion: { (result) in
            switch result {
            case .success(let mdp):
              let (dataPoint, error) = self.unwrapManagedDataPoint(mdp)
              completion(dataPoint, error)
            case .failure(let error):
              completion(nil, error)
            }
          })
        case .failure(let error):
          completion(nil, error)
        }
      }
    }
    
    func fetchAllDataPoints(completion: @escaping (([ManagedDataPoint]?) -> Void)) {
      dataStore.fetchAllDataPoint { result in
        switch result {
        case .success(let dataPoints):
          completion(dataPoints)
        case .failure(let error):
          print(error)
          completion(nil)
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
    
    func getBmiComparison(completion: @escaping (Double?) -> Void) {
      dataStore.getBmiComparison { comparison in
        completion(comparison)
      }
    }
    
    func getTitle() -> String {
      let defaultTitle = "Your health"
      guard let name = UserDefaults.standard.value(forKey: UserDefaultKeys.name.rawValue)as? String else { return defaultTitle }
      
      return "Hello \(name)"
    }
    
    private func unwrapManagedDataPoint(_ managedDataPoint: ManagedDataPoint?) -> (MainViewController.VM?, Error?) {
      if let id = managedDataPoint?.id, let weight = managedDataPoint?.weight, let height = managedDataPoint?.height, let gender = dataStore.fetchUserGender() {
        let dataPoint = MainViewController.VM(id: id, weight: weight, height: height, gender: gender)
        return (dataPoint, nil)
      } else {
        return (nil, MainViewControllerInteractorError.couldNotGenerateDataPointFromManaged)
      }
    }
    
  }
}
