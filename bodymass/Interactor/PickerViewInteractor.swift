//
//  PickerViewControllerInteractor.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import Foundation
import bodymassKit

protocol PickerInteractorType {
  func saveSelectedUnits(_ units: Units)
  func retrieveHeightUnits() -> Units?
  func retrieveWeightUnits() -> Units?
}

extension PickerViewController {
  class Interactor: PickerInteractorType {
    
    func saveSelectedUnits(_ units: Units) {
      if Units.heightUnitsAvailable.contains(units) {
        Units.saveCurrentHeightUnits(units)
      } else if Units.weighthUnitsAvailable.contains(units) {
        Units.saveCurrentWeightUnits(units)
      }
    }
    
    func retrieveHeightUnits() -> Units? {
      return Units.retrieveCurrentHeightUnits()
    }
    
    func retrieveWeightUnits() -> Units? {
      return Units.retrieveCurrentWeightUnits()
    }
    
  }
}
