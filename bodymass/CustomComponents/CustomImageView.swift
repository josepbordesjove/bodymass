//
//  CustomImageView.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 23/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
  init(image: UIImage) {
    super.init(frame: CGRect())
    
    self.image = image
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  init(image: UIImage, contentMode: ContentMode, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
    super.init(frame: CGRect())
    
    self.layer.anchorPoint = anchorPoint
    self.contentMode = .scaleAspectFit
    self.image = image
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
