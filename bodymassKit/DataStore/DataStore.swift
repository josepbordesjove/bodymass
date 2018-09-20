//
//  DataStore.swift
//  bodymassKit
//
//  Created by Josep Bordes Jové on 16/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import CoreData

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
  
  public func loadAndMigrateIfNeeded(completion: @escaping () -> Void) {
    guard !self.storeIsReady else {
      completion()
      return
    }
    
    persistentStore.loadPersistentStores { (description, error) in
      if let error = error {
        print("JBJ error: \(error)")
      } else {
        self.storeIsReady = true
        completion()
      }
    }
  }
  
  public func saveDataPoint(id: String, weight: Double, height: Double, completion: @escaping () -> Void) {
     assert(self.storeIsReady)
    
    self.persistentStore.performBackgroundTask { (moc) in
      let managedDataPoint = self.fetchDataPoint(id: id, moc: moc) ?? ManagedDataPoint(entity: ManagedDataPoint.entity(), insertInto: moc)
      managedDataPoint.id = id
      managedDataPoint.height = height
      managedDataPoint.weight = weight
      managedDataPoint.creationDate = Date()
      
      do {
        try moc.save()
        completion()
      } catch(let error) {
        print("Some error happened: \(error) ")
      }
    }
  }
  
  public func fetchLastDataPoint(completion: @escaping ((ManagedDataPoint?) -> Void)) {
    assert(self.storeIsReady)
    
    fetchLastDataPoint(moc: self.persistentStore.viewContext) { (managedDataPoint) in
      completion(managedDataPoint)
    }
  }
  
  public func saveUserGender(_ gender: Gender) {
    UserDefaults.standard.set(gender.rawValue, forKey: UserDefaultKeys.gender.rawValue)
  }
  
  public func fetchUserGender() -> Gender? {
    guard let genderRawValue = UserDefaults.standard.value(forKey: UserDefaultKeys.gender.rawValue)as? String else { return nil }
    return Gender(rawValue: genderRawValue)
  }
  
  //MARK: Private
  
  private func fetchDataPoint(id: String, moc: NSManagedObjectContext) -> ManagedDataPoint? {
    let fetchRequest: NSFetchRequest<ManagedDataPoint> = ManagedDataPoint.fetchRequest()
    fetchRequest.predicate = NSPredicate(property: #keyPath(ManagedDataPoint.id), value: id)
    let managedDataPoints = try? moc.fetch(fetchRequest)
    return managedDataPoints?.first
  }
  
  private func fetchLastDataPoint(moc: NSManagedObjectContext, completion: @escaping ((ManagedDataPoint?) -> Void)) {
    let fetchRequest: NSFetchRequest<ManagedDataPoint> = ManagedDataPoint.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: #keyPath(ManagedDataPoint.creationDate), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
      guard let managedDataPoints = result.finalResult else { return }
      completion(managedDataPoints.last)
    }
    
    do {
      try moc.execute(asyncFetchRequest)
    } catch (let error) {
      print("Some error happened: \(error) ")
    }
  }
  
  
}
