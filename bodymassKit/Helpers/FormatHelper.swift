//
//  FormatHelper.swift
//  bodymassKit
//
//  Created by Josep Bordes Jové on 16/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import Foundation

public class FormatHelper {
  public static func value(_ value: Double, withDecimals decimals: Int = 0, ofType unitsType: UnitType, appendDescription: Bool = false) -> String {
    let currentUnits = unitsType == .height ? Units.retrieveCurrentHeightUnits() : Units.retrieveCurrentWeightUnits()
    
    return "\(String(format: "%.\(decimals)f", Units.convert(value: value, to: currentUnits)))\(appendDescription ? currentUnits.abbreviation() : "")"
  }
  
  public static func value(_ value: Int, withDecimals decimals: Int = 0, ofType unitsType: UnitType, appendDescription: Bool = false) -> String {
    let currentUnits = unitsType == .height ? Units.retrieveCurrentHeightUnits() : Units.retrieveCurrentWeightUnits()
    
    return "\(String(format: "%.\(decimals)f", Units.convert(value: Double(value), to: currentUnits)))\(appendDescription ? currentUnits.abbreviation() : "")"
  }
}
