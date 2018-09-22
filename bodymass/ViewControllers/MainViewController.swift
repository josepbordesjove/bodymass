//
//  ViewController.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 5/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class MainViewController: UIViewController {
  
  private var interactor: MainInteractorType
  private var vm: VM? {
    didSet {
      if let bmi = calculateBMI() {
        DispatchQueue.main.async {
          self.imcSummary.text = String(format: "%.1f", bmi)
          self.bmiRecommendation.text = "BMI = \(String(format: "%.2f", bmi)) kg/m2"
        }
      }
    }
  }
  
  lazy var pageTitle = CustomLabel(text: "YOUR HEALTH", fontType: FontTypes.moderneSans, size: 24, color: .birdBlue)
  lazy var imcSummary = CustomLabel(text: "--.-", size: 120, bold: true, color: .ropeBlue)
  lazy var bmiRecommendation = CustomLabel(text: "No data available", size: 20, color: .birdBlue)
  lazy var bmiRecommendationDescription = CustomLabel(text: bmiDescriptionText(), size: 16, color: .snowWhite)
  lazy var balanceImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "balance")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  lazy var reloadButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "update"), size: 49)
  lazy var trashButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "trash"), size: 25)
  lazy var shareButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "share"), size: 25)
  lazy var profileButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "profile"), size: 123)
  lazy var homeButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "home"), size: 161)
  lazy var historyButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "history"), size: 123)
  
  init(interactor: MainInteractorType) {
    self.interactor = interactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupConstraints()
    setupButtonTargets()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    reloadDataPoint()
  }
  
  func setupButtonTargets() {
    reloadButton.addTarget(self, action: #selector(presentAddDataViewController), for: .touchUpInside)
    shareButton.addTarget(self, action: #selector(presentActivityViewController), for: .touchUpInside)
    trashButton.addTarget(self, action: #selector(deleteLastDataPoint), for: .touchUpInside)
  }
  
  func setupView() {
    view.backgroundColor = .white
    [pageTitle, imcSummary, balanceImage,bmiRecommendation, bmiRecommendationDescription, reloadButton,
     trashButton, shareButton, profileButton, historyButton, homeButton].forEach{ view.addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      pageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
      pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      imcSummary.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 40),
      imcSummary.centerXAnchor.constraint(equalTo: pageTitle.centerXAnchor),
      
      balanceImage.topAnchor.constraint(equalTo: imcSummary.bottomAnchor, constant: 10),
      balanceImage.centerXAnchor.constraint(equalTo: imcSummary.centerXAnchor),
      balanceImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
      
      bmiRecommendation.topAnchor.constraint(equalTo: balanceImage.bottomAnchor, constant: 13),
      bmiRecommendation.centerXAnchor.constraint(equalTo: balanceImage.centerXAnchor),
      
      bmiRecommendationDescription.topAnchor.constraint(equalTo: bmiRecommendation.bottomAnchor, constant: 8),
      bmiRecommendationDescription.centerXAnchor.constraint(equalTo: bmiRecommendation.centerXAnchor),
      bmiRecommendationDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
      bmiRecommendationDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
      
      reloadButton.topAnchor.constraint(equalTo: bmiRecommendationDescription.bottomAnchor, constant: 14),
      reloadButton.centerXAnchor.constraint(equalTo: bmiRecommendationDescription.centerXAnchor),
      
      trashButton.rightAnchor.constraint(equalTo: reloadButton.leftAnchor, constant: -60),
      trashButton.centerYAnchor.constraint(equalTo: reloadButton.centerYAnchor),
      
      shareButton.leftAnchor.constraint(equalTo: reloadButton.rightAnchor, constant: 60),
      shareButton.centerYAnchor.constraint(equalTo: reloadButton.centerYAnchor),
      
      homeButton.centerYAnchor.constraint(equalTo: view.bottomAnchor),
      homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      profileButton.centerYAnchor.constraint(equalTo: view.bottomAnchor),
      profileButton.centerXAnchor.constraint(equalTo: homeButton.centerXAnchor, constant: -100),
      
      historyButton.centerYAnchor.constraint(equalTo: view.bottomAnchor),
      historyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
      ])
  }
  
  //  MARK: Helper methods
  
  @objc
  func presentAddDataViewController() {
    let addDataViewController = self.interactor.addDataViewController(observer: self, weight: vm?.weight, height: vm?.height, gender: vm?.gender)
    addDataViewController.transitioningDelegate = self
    
    present(addDataViewController, animated: true)
  }
  
  @objc
  func presentActivityViewController() {
    guard let bmi = calculateBMI() else { return }
    let text = "Hey! My BMI is \(String(format: "%.1f", bmi)), I been tracking it using the app BodyMass that you can find on the AppStore"
    
    let textToShare = [ text ]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook ]
    
    self.present(activityViewController, animated: true, completion: nil)
  }
  
  @objc
  func deleteLastDataPoint() {
    interactor.deleteLastDataPoint { (deleted) in
      if deleted {
        self.showAlert(title: "Deleted", message: "Your last introduced data point has been deleted, no body will know about it")
        self.reloadDataPoint()
      } else {
        self.showAlert(title: "Oooops...", message: "We were not able to delete your last data point, you can try it again later")
      }
    }
  }
  
  func reloadDataPoint() {
    interactor.fetchLastDataPoint { (vm, error) in
      if error == nil {
        self.vm = vm
      } else {
        self.imcSummary.text = "--.-"
        self.bmiRecommendation.text = "No data available"
      }
    }
    
    if let gender = interactor.fetchUserGender() {
      self.vm?.gender = gender
    }
  }
  
  func calculateBMI() -> Double? {
    guard let vm = vm else { return nil }
    let squaredHeight = (vm.height / 100) * (vm.height / 100)
    return vm.weight / squaredHeight
  }
  
  func bmiDescriptionText() -> String{
    return "Normal BMI weight range for the height: 128.9lbs - 174.2 lbs"
  }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return MainVCToAddDataVCTransition()
  }
}

extension MainViewController: DataPointObserver {
  func didCreateDataPoint() {
    self.reloadDataPoint()
  }
}

extension MainViewController {
  struct VM {
    let id: String
    var weight: Double
    var height: Double
    var gender: Gender
  }
}
