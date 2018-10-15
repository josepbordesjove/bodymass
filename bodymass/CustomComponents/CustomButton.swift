//
//  RoundButton.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 14/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
  
  var associatedValues: [Any]? = nil
  
  init(image: UIImage, size: CGFloat, round: Bool = true, color: UIColor? = nil, shadow: Bool = false) {
    let frame = CGRect()
    super.init(frame: frame)
    
    // Image properties
    setImage(image, for: .normal)
    
    // Size
    let widthAnchor = self.widthAnchor.constraint(equalToConstant: size)
    let heightAnchor = self.heightAnchor.constraint(equalToConstant: size)
    
    NSLayoutConstraint.activate([widthAnchor, heightAnchor])
    
    // Style properties
    if color != nil {
      backgroundColor = color
    }
    
    // Border properties
    if round {
      layer.cornerRadius = size / 2
    }
    
    // Shadow properties
    if shadow {
      layer.shadowColor = UIColor.gray.cgColor
      layer.shadowOpacity = 0.5
      layer.shadowOffset = CGSize.zero
      layer.shadowRadius = 10
    }
    
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
