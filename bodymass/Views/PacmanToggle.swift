//
//  PacmanToggle.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class PacmanToggle: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    backgroundColor = .brightGreen
    layer.cornerRadius = 30
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setupConstraints() {
    
  }
}

