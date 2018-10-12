//
//  Summary.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 12/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class Summary: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    setupConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 5
    layer.cornerRadius = 8
    backgroundColor = .white
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setupConstraint() {
    
  }
}
