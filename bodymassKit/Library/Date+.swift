//
//  Date+.swift
//  bodymassKit
//
//  Created by Josep Bordes Jové on 29/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import Foundation

public extension Date {
  public func toString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd"
    
    dateFormatter.locale = Locale(identifier: "en_US")
    return dateFormatter.string(from: self)
  }
}
