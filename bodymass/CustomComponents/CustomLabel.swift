//
//  CustomLabel.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 22/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

enum FontTypes: String {
  case SFRegular = "SFProText-Regular"
  case SFHeavy = "SFProText-Heavy"
  case SFSemibold = "SFProText-Semibold"
  case SFBold = "SFProText-Bold"
  case circularBold = "CircularStd-Bold"
  case circularMedium = "CircularStd-Medium"
}

class CustomLabel: UILabel {
  init(text: String = "", fontType: FontTypes, size: CGFloat, color: UIColor = .black) {
    super.init(frame: CGRect())
    
    self.text = text
    textColor = color
    font = UIFont(name: fontType.rawValue, size: size)
    numberOfLines = 0
    lineBreakMode = .byWordWrapping
    textColor = color
    textAlignment = .center
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  init(text: String = "", size: CGFloat, bold: Bool = false, color: UIColor = .black) {
    super.init(frame: CGRect())
    
    if bold {
      font = UIFont.boldSystemFont(ofSize: size)
    } else {
      font = UIFont.systemFont(ofSize: size)
    }
    
    self.text = text
    numberOfLines = 0
    lineBreakMode = .byWordWrapping
    textColor = color
    textAlignment = .center
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
