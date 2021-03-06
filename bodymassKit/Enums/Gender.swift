//
//  Gender.swift
//  bodymassKit
//
//  Created by Josep Bordes Jové on 20/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import Foundation

public enum Gender: String {
  case male = "male"
  case female = "female"
  case undefined = "gender neutrality"
}

public extension Gender {
  public func shortDescription() -> String {
    switch self {
    case .female, .male:
      return String(self.rawValue.capitalized(with: Locale.current).first!)
    case .undefined:
      return "GN"
    }
  }
}
