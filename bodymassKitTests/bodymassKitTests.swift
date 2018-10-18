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
    static let height: Double = 189
    static let weight: Double = 79
  }
  
  var dataStore: DataStore!
  
  override func setUp() {
    dataStore = DataStore()
  }
  
  func testSaveDataPoint() {
    dataStore.loadAndMigrateIfNeeded { (result) in
      switch result {
      case .success:
        self.dataStore.saveDataPoint(id: UUID().uuidString, weight: Constants.weight, height: Constants.height, completion: {
          XCTAssert(true)
        })
      case .failure:
        XCTAssert(false)
      }
    }
  }
  
}
