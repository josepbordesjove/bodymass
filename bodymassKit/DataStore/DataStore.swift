//
//  DataStore.swift
//  bodymassKit
//
//  Created by Josep Bordes Jové on 16/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import CoreData

public enum DataStoreResult<T> {
  case success(T)
  case failure(Error)
}

public enum DataStoreError: String, Error {
  case couldNotRetrieveDataPoint = "The last data point couldn't be fetched"
  case couldNotRetrieveAllDataPoints = "The data points couldn't be fetched"
}

public class DataStore: NSObject {

  private let persistentStore: NSPersistentContainer
  public static let shared = DataStore()
  public var storeIsReady: Bool = false
  
  public override init() {
    guard
      let path = Bundle(for: DataStore.self).path(forResource: "Model", ofType: "momd"),
      let model = NSManagedObjectModel(contentsOf: URL(fileURLWithPath: path)) else {
        fatalError()
    }
    
    persistentStore = NSPersistentContainer(
      name: "bodymass",
      managedObjectModel: model
    )
    
    let storeDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let url = storeDirectory.appendingPathComponent("bodymass.sqlite")
    let description = NSPersistentStoreDescription(url: url)
    description.type = NSSQLiteStoreType
    description.shouldAddStoreAsynchronously = false
    persistentStore.persistentStoreDescriptions = [description]
  }
  
  public func loadAndMigrateIfNeeded(completion: @escaping (DataStoreResult<Void>) -> Void) {
    guard !self.storeIsReady else {
      completion(.success(()))
      return
    }
    
    persistentStore.loadPersistentStores { (description, error) in
      if let error = error {
        completion(.failure(error))
      } else {
        self.storeIsReady = true
         completion(.success(()))
      }
    }
  }
  
  public func saveDataPoint(id: String, weight: Double, height: Double, completion: @escaping (DataStoreResult<ManagedDataPoint>) -> Void) {
     assert(self.storeIsReady)
    
    self.persistentStore.performBackgroundTask { (moc) in
      let managedDataPoint = self.fetchDataPoint(id: id, moc: moc) ?? ManagedDataPoint(entity: ManagedDataPoint.entity(), insertInto: moc)
      managedDataPoint.id = id
      managedDataPoint.height = height
      managedDataPoint.weight = weight
      managedDataPoint.creationDate = Date()
      
      do {
        try moc.save()
        completion(.success(managedDataPoint))
      } catch(let error) {
        completion(.failure(error))
      }
    }
  }
  
  public func fetchLastDataPoint(completion: @escaping ((DataStoreResult<ManagedDataPoint>) -> Void)) {
    assert(self.storeIsReady)
    
    fetchLastDataPoint(moc: self.persistentStore.viewContext) { (managedDataPoint) in
      if let managedDataPoint = managedDataPoint {
        completion(.success(managedDataPoint))
      } else {
        completion(.failure(DataStoreError.couldNotRetrieveDataPoint))
      }
    }
  }
  
  public func fetchAllDataPoint(completion: @escaping ((DataStoreResult<[ManagedDataPoint]>) -> Void)) {
    assert(self.storeIsReady)
    
    fetchAllDataPoints(moc: self.persistentStore.viewContext) { (managedDataPoints) in
      if let managedDataPoints = managedDataPoints {
        completion(.success(managedDataPoints.reversed()
          ))
      } else {
        completion(.failure(DataStoreError.couldNotRetrieveAllDataPoints))
      }
    }
  }
  
  public func deleteLastDataPoint(completion: @escaping ((Bool) -> Void)) {
    assert(self.storeIsReady)
    
    deleteLastDataPoint(moc: self.persistentStore.viewContext, completion: { (deleted) in
      completion(deleted)
    })
  }
  
  public func saveUserGender(_ gender: Gender) {
    UserDefaults.standard.set(gender.rawValue, forKey: UserDefaultKeys.gender.rawValue)
  }
  
  public func fetchUserGender() -> Gender? {
    guard let genderRawValue = UserDefaults.standard.value(forKey: UserDefaultKeys.gender.rawValue)as? String else { return nil }
    return Gender(rawValue: genderRawValue)
  }
  
  public func getBmiComparison(completion: @escaping ((Double?) -> Void)) {
    assert(self.storeIsReady)
    
    getLastTwoDataDifference(moc: self.persistentStore.viewContext) { comparison in
      completion(comparison)
    }
  }
  
  //MARK: Private
  
  private func fetchDataPoint(id: String, moc: NSManagedObjectContext) -> ManagedDataPoint? {
    let fetchRequest: NSFetchRequest<ManagedDataPoint> = ManagedDataPoint.fetchRequest()
    fetchRequest.predicate = NSPredicate(property: #keyPath(ManagedDataPoint.id), value: id)
    let managedDataPoints = try? moc.fetch(fetchRequest)
    return managedDataPoints?.first
  }
  
  private func fetchLastDataPoint(moc: NSManagedObjectContext, completion: @escaping ((ManagedDataPoint?) -> Void)) {
    fetchAllDataPoints(moc: moc) { (managedDataPoints) in
      completion(managedDataPoints?.last)
    }
  }
  
  private func getLastTwoDataDifference(moc: NSManagedObjectContext, completion: @escaping ((Double?) -> Void)) {
    let fetchRequest: NSFetchRequest<ManagedDataPoint> = ManagedDataPoint.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: #keyPath(ManagedDataPoint.creationDate), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
      guard let managedDataPoints = result.finalResult, let lastDataPoint = managedDataPoints.last else {
        completion(nil)
        return
      }
      
      if managedDataPoints.count > 2 {
        let penultimateDataPoint = managedDataPoints[managedDataPoints.count - 2]
        
        guard let lastBmi = BodyMassIndex.calculateBMI(weight: lastDataPoint.weight, height: lastDataPoint.height),
          let penultimateBmi = BodyMassIndex.calculateBMI(weight: penultimateDataPoint.weight, height: penultimateDataPoint.height) else {
            completion(nil)
            return
        }
        
        completion(lastBmi - penultimateBmi)
      } else {
        completion(nil)
      }
    }
    
    do {
      try moc.execute(asyncFetchRequest)
    } catch (let error) {
      print("Some error happened: \(error) ")
    }
  }
  
  private func deleteLastDataPoint(moc: NSManagedObjectContext, completion: @escaping ((Bool) -> Void)) {
    fetchLastDataPoint { (result) in
      switch result {
      case .success(let managedDataPoint):
        do {
          moc.delete(managedDataPoint)
          try moc.save()
          completion(true)
        } catch {
          completion(false)
        }
      case .failure:
        completion(false)
      }
    }
  }
  
  private func fetchAllDataPoints(moc: NSManagedObjectContext, completion: @escaping (([ManagedDataPoint]?) -> Void)) {
    let fetchRequest: NSFetchRequest<ManagedDataPoint> = ManagedDataPoint.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: #keyPath(ManagedDataPoint.creationDate), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
      guard let managedDataPoints = result.finalResult else { return }
      completion(managedDataPoints)
    }
    
    do {
      try moc.execute(asyncFetchRequest)
    } catch (let error) {
      print("Some error happened: \(error) ")
    }
  }
}
