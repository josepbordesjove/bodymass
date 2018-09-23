//
//  AppDelegate.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 5/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    defer { self.window?.makeKeyAndVisible() }
    
    guard NSClassFromString("XCTest") == nil else {
      self.window?.rootViewController = UIViewController()
      return true
    }
    
    let dataStore = DataStore()
    let interactor = MainViewController.Interactor(dataStore: dataStore)
    self.window?.rootViewController = MainViewController(interactor: interactor)
    
    return true
  }
}
