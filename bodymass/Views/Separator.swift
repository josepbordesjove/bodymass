//
//  Separator.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class Separator: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .blueGreyTranslucid
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
