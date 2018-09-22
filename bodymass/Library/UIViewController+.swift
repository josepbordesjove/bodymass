//
//  UIViewController+.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 22/9/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlert(title: String, message: String) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertVC.addAction(ok)
    
    DispatchQueue.main.async {
      self.present(alertVC, animated: true, completion: nil)
    }
  }
}
