//
//  BodymassKitTests.swift
//  BodymassKitTests
//
//  Created by Josep Bordes Jové on 17/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import XCTest
import bodymassKit

class bodymassKitTests: XCTestCase {
  
  struct Constants {
    static let id: String = UUID().uuidString
    static let height: Double = 189
    static let weight: Double = 79
  }
  
  var dataStore = DataStore()
  
  override func setUp() {
    dataStore.loadAndMigrateIfNeeded { (result) in
      switch result {
      case .success: XCTAssert(true)
      case .failure: XCTAssert(false)
      }
    }
  }
  
  func testSaveDataPoint() {
    self.dataStore.saveDataPoint(id: Constants.id, weight: Constants.weight, height: Constants.height) { (result) in
      switch result {
      case .success(let managedDataPoint):
        XCTAssertEqual(managedDataPoint.id, Constants.id)
        XCTAssertEqual(managedDataPoint.height, Constants.height)
        XCTAssertEqual(managedDataPoint.weight, Constants.weight)
      case .failure:
        XCTAssert(false)
      }
    }
  }
  
  func testFetchLastDataPoint() {
    self.dataStore.fetchLastDataPoint(completion: { (result) in
      switch result {
      case .success(let managedDataPoint):
//        XCTAssertEqual(managedDataPoint.id, Constants.id)
        XCTAssertEqual(managedDataPoint.height, Constants.height)
        XCTAssertEqual(managedDataPoint.weight, Constants.weight)
      case .failure:
        XCTAssert(false)
      }
    })
  }
  
}
