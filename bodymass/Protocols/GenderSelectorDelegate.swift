//
//  GenderSelectorDelegate.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 29/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import Foundation
import bodymassKit

protocol GenderSelectorDelegate: class {
  func genderChanged(value: Gender)
}
