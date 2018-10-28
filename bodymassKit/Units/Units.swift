//
//  Units.swift
//  bodymassKit
//
//  Created by Josep Bordes Jové on 15/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import Foundation

public enum Units {
  case centimeters
  case inches
  case kilograms
  case pounds
  case feets
  
  public static let heightUnitsAvailable: [Units] = [.feets, .centimeters]
  public static let weighthUnitsAvailable: [Units] = [.kilograms, .pounds]
}

extension Units {
  private struct Unit {
    let shortName: String
    let longName: String
  }
  
  private struct Constants {
    static let centimeters = Unit(shortName: "cm", longName: "Centimeters")
    static let inches = Unit(shortName: "in", longName: "Inches")
    static let kilograms = Unit(shortName: "kg", longName: "Kilograms")
    static let pounds = Unit(shortName: "lb", longName: "Pounds")
    static let feets = Unit(shortName: "ft", longName: "Feets")
  }
  
  private struct HeightConstants {
    static let centimeterToInches = 0.393701
    static let centimeterToFeet = 0.0328084
  }
  
  private struct WeightConstants {
    static let kilogramToPound = 2.20462
  }
  
  public func description() -> String {
    return fromUnitsToConstant().longName
  }
  
  public func abbreviation() -> String {
    return fromUnitsToConstant().shortName
  }
  
  public static func convert(value: Double, to units: Units) -> Double {
    switch units {
    case .centimeters:
      return value
    case .inches:
      return value * HeightConstants.centimeterToInches
    case .kilograms:
      return value
    case .pounds:
      return value * WeightConstants.kilogramToPound
    case .feets:
      return value * HeightConstants.centimeterToFeet
    }
  }
  
  public static func fromStringLongNameToUnits(_ string: String) -> Units? {
    switch string {
    case Constants.inches.longName:
      return Units.inches
    case Constants.kilograms.longName:
      return Units.kilograms
    case Constants.pounds.longName:
      return Units.pounds
    case Constants.centimeters.longName:
      return Units.centimeters
    case Constants.feets.longName:
      return Units.feets
    default:
      return nil
    }
  }
  
  public static func fromStringShortNameToUnits(_ string: String) -> Units? {
    switch string {
    case Constants.inches.shortName:
      return Units.inches
    case Constants.kilograms.shortName:
      return Units.kilograms
    case Constants.pounds.shortName:
      return Units.pounds
    case Constants.centimeters.shortName:
      return Units.centimeters
    case Constants.feets.shortName:
      return Units.feets
    default:
      return nil
    }
  }
  
  private func fromUnitsToConstant() -> Unit {
    switch self {
    case .inches:
      return Constants.inches
    case .centimeters:
      return Constants.centimeters
    case .kilograms:
      return Constants.kilograms
    case .pounds:
      return Constants.pounds
    case .feets:
      return Constants.feets
    }
  }
  
  public static func saveCurrentHeightUnits(_ units: Units) {
     UserDefaults.standard.set(units.abbreviation(), forKey: UserDefaultKeys.heightUnits.rawValue)
  }
  
  public static func retrieveCurrentHeightUnits() -> Units {
    guard let unitsRawValue = UserDefaults.standard.value(forKey: UserDefaultKeys.heightUnits.rawValue) as? String else { return Units.centimeters }
    return fromStringShortNameToUnits(unitsRawValue) ?? Units.centimeters
  }
  
  public static func saveCurrentWeightUnits(_ units: Units) {
     UserDefaults.standard.set(units.abbreviation(), forKey: UserDefaultKeys.weightUnits.rawValue)
  }
  
  public static func retrieveCurrentWeightUnits() -> Units {
    guard let unitsRawValue = UserDefaults.standard.value(forKey: UserDefaultKeys.weightUnits.rawValue) as? String else { return Units.kilograms }
     return fromStringShortNameToUnits(unitsRawValue) ?? Units.kilograms
  }
}
