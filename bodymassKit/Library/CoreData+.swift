//
//  CoreData+.swift
//  bodymassKit
//
//  Created by Josep Bordes Jové on 16/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import CoreData

extension NSPredicate {
  convenience init(property: String, value: String) {
    self.init(format: "\(property) == %@", value)
  }
}
