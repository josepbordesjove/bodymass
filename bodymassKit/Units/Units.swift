//
//  Units.swift
//  bodymassKit
//
//  Created by Josep Bordes Jové on 15/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import Foundation

public enum Units: String {
  case meters = "m"
  case centimeters = "cm"
  case inches = "in"
  case kilograms = "kg"
  case pounds = "lb"
  
  public static let heightUnitsAvailable: [Units] = [.meters, .inches, .centimeters]
  public static let weighthUnitsAvailable: [Units] = [.kilograms, .pounds]
}

extension Units {
  public func description() -> String {
    switch self {
    case .inches:
      return "Inches"
    case .centimeters:
      return "Centimeters"
    case .kilograms:
      return "Kilograms"
    case .pounds:
      return "Pounds"
    case .meters:
      return "Meters"
    }
  }
  
  public static func fromStringDescriptionToUnits(_ string: String) -> Units? {
    switch string {
    case "Inches":
      return Units.inches
    case "Kilograms":
      return Units.kilograms
    case "Pounds":
      return Units.pounds
    case "Meters":
      return Units.meters
    case "Centimeters":
      return Units.centimeters
    default:
      return nil
    }
  }
  
  public static func saveCurrentHeightUnits(_ units: Units) {
     UserDefaults.standard.set(units.rawValue, forKey: UserDefaultKeys.heightUnits.rawValue)
  }
  
  public static func retrieveCurrentHeightUnits() -> Units {
    guard let unitsRawValue = UserDefaults.standard.value(forKey: UserDefaultKeys.heightUnits.rawValue)as? String else { return Units.centimeters }
    return Units(rawValue: unitsRawValue) ?? Units.centimeters
  }
  
  public static func saveCurrentWeightUnits(_ units: Units) {
     UserDefaults.standard.set(units.rawValue, forKey: UserDefaultKeys.weightUnits.rawValue)
  }
  
  public static func retrieveCurrentWeightUnits() -> Units {
    guard let unitsRawValue = UserDefaults.standard.value(forKey: UserDefaultKeys.weightUnits.rawValue)as? String else { return Units.kilograms }
    return Units(rawValue: unitsRawValue) ?? Units.kilograms
  }
}
