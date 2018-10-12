//
//  AnimationHelper.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 20/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

struct AnimationHelper {
  static func yRotation(_ angle: Double) -> CATransform3D {
    return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
  }
}
