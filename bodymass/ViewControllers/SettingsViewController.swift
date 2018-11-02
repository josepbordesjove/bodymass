//
//  SettingsViewController.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 02/11/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import StoreKit
import bodymassKit

class SettingsViewController: UIAlertController {
  
  private let interactor: SettingsViewController.Interactor
  
  let shareImage: UIImage
  let height: Double
  let weight: Double
  
  enum Option: String {
    case rateApp = "Rate the app"
    case changeName = "Change the user name"
    case shareApp = "Share the app"
  }
  
  let options: [Option] = [Option.rateApp, Option.changeName, Option.shareApp]
  
  init(height: Double, weight: Double, shareImageView: UIImage, observer: UserNameObserver) {
    self.shareImage = shareImageView
    self.height = height
    self.weight = weight
    self.interactor = SettingsViewController.Interactor(observer: observer)
    super.init(nibName: nil, bundle: nil)
    
    
    let shareAction = UIAlertAction(title: Option.shareApp.rawValue, style: .default) { (alertAction) in
      self.presentShareViewController()
    }
    
    let changeNameAction = UIAlertAction(title: Option.changeName.rawValue, style: .default) { (alertAction) in
      self.presentChangeNameAlertView()
    }
    
    let rateAppAction = UIAlertAction(title: Option.rateApp.rawValue, style: .default) { (alertAction) in
      self.rateApp()
    }
    
    var actions: [UIAlertAction] = [shareAction, changeNameAction, rateAppAction]
    actions.append(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    actions.forEach { addAction($0) }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func presentShareViewController() {
    let text = BodyMassIndex.getTextToShare(weight: self.weight, height: self.height)
    let screenshot = self.shareImage as Any
    
    let textToShare: [Any] = [ text, screenshot ]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook ]
    
    guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
    rootViewController.present(activityViewController, animated: true, completion: nil)
  }
  
  @objc func presentChangeNameAlertView() {
    let alertVC = UIAlertController(title: "Enter your name:", message: "This name will be only used inside the app", preferredStyle: .alert)
    
    alertVC.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) in
      guard let name = alertVC.textFields?.first?.text else { return }
      self.interactor.save(name: name)
    }))
    
    alertVC.addTextField(configurationHandler: { (textField) in
      textField.placeholder = "Enter First Name"
    })
    
    DispatchQueue.main.async {
      guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
      rootViewController.present(alertVC, animated: true, completion: nil)
    }
  }
  
  @objc func rateApp() {
    SKStoreReviewController.requestReview()
  }
  
}
