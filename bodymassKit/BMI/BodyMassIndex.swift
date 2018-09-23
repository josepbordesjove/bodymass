//
//  BodyMassIndex.swift
//  bodymassKit
//
//  Created by Josep Bordes Jové on 23/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import Foundation

public class BodyMassIndex {
  private struct Constants {
    static let minAllowedBMI = 18.5
    static let maxAllowedBMI = 24.9
    static let heightUnits = "cm"
    static let weightUnits = "kg"
  }
  
  public static func calculateBMI(weight: Double?, height: Double?) -> Double? {
    guard let weight = weight else { return nil }
    guard let height = height else { return nil }
    
    let squaredHeight = (height / 100) * (height / 100)
    return weight / squaredHeight
  }
  
  public static func getDescriptionForBMI(bmi: Double?) -> String {
    guard let bmi = bmi else { return "" }
    return "BMI = \(String(format: "%.2f", bmi)) \(Constants.weightUnits)/\(Constants.heightUnits)2"
  }
  
  public static func getWeightRangeFor(height: Double?) -> String {
    guard let height = height else { return "No data available" }
    let minAllowedWeight = Constants.minAllowedBMI * height * height / 10000
    let maxAllowedWeight = Constants.maxAllowedBMI * height * height / 10000
    
    return "Normal BMI weight range for the height: \(String(format: "%.2f", minAllowedWeight))\(Constants.weightUnits) - \(String(format: "%.2f", maxAllowedWeight))\(Constants.weightUnits)"
  }
  
  public static func getTextToShare(weight: Double?, height: Double?) -> String {
    guard let bmi = calculateBMI(weight: weight, height: height) else { return "Do you know about BodyMass? Try to download it on the AppStore" }
    return  "Hey! My BMI is \(String(format: "%.1f", bmi)), I been tracking it using the app BodyMass that you can find on the AppStore"
  }
}
