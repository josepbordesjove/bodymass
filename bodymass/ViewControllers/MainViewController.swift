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
  
  private struct Constants {
    static let defaultBmiSummary = "--.-"
    static let defaultbmiRecommendation = "No data available"
    static let emojiSize = UIScreen.main.bounds.width * 0.2
    static let bmiSize = UIScreen.main.bounds.width * 0.25
  }
  
  private var interactor: MainInteractorType
  private var vm: VM? {
    didSet {
      if let bmi = BodyMassIndex.calculateBMI(weight: vm?.weight, height: vm?.height) {
        DispatchQueue.main.async {
          self.bmiSummary.text = String(format: "%.1f", bmi)
          self.bmiRecommendation.text = BodyMassIndex.getDescriptionForBMI(bmi: bmi)
          self.bmiRecommendationDescription.text = BodyMassIndex.getWeightRangeFor(height: self.vm?.height)
        }
      }
    }
  }
  
  lazy var infoEmoji: UILabel = {
    let label = UILabel()
    label.text = "🦁"
    label.font = UIFont.systemFont(ofSize: Constants.emojiSize)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var header = Header(title: "Your health")
  lazy var bmiSummary = CustomLabel(fontType: .SFHeavy, size: Constants.bmiSize, color: .charcoalGrey)
  lazy var bmiRecommendation = CustomLabel(fontType: .circularMedium, size: 17.3, color: .charcoalGrey)
  lazy var bmiRecommendationDescription = CustomLabel(fontType: .circularMedium, size: 13.4, color: .lightPeriwinkle)
  lazy var balanceImage = CustomImageView(image: #imageLiteral(resourceName: "balance"))
  lazy var reloadButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "update"), size: 49)
  lazy var trashButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "trash"), size: 25)
  lazy var shareButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "share"), size: 25)
  
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
    view.insetsLayoutMarginsFromSafeArea = true
    bmiSummary.text = Constants.defaultBmiSummary
    bmiRecommendation.text = Constants.defaultbmiRecommendation
    bmiRecommendationDescription.text = BodyMassIndex.getWeightRangeFor(height: vm?.height)
    
    view.backgroundColor = .lightGrey
    [header, bmiSummary, balanceImage,bmiRecommendation, bmiRecommendationDescription, reloadButton,
     trashButton, shareButton, infoEmoji].forEach{ view.addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      header.topAnchor.constraint(equalTo: view.topAnchor),
      header.leftAnchor.constraint(equalTo: view.leftAnchor),
      header.rightAnchor.constraint(equalTo: view.rightAnchor),
      header.heightAnchor.constraint(equalToConstant: 60 + UIScreen.main.bounds.height * 0.095),
      
      infoEmoji.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      infoEmoji.topAnchor.constraint(equalTo: header.bottomAnchor, constant: UIScreen.main.bounds.height * 0.03),
      
      bmiSummary.topAnchor.constraint(equalTo: infoEmoji.bottomAnchor),
      bmiSummary.centerXAnchor.constraint(equalTo: header.centerXAnchor),
      
      balanceImage.topAnchor.constraint(equalTo: bmiSummary.bottomAnchor, constant: 10),
      balanceImage.centerXAnchor.constraint(equalTo: bmiSummary.centerXAnchor),
      balanceImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90),
      balanceImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
      
      bmiRecommendation.topAnchor.constraint(equalTo: balanceImage.bottomAnchor),
      bmiRecommendation.centerXAnchor.constraint(equalTo: balanceImage.centerXAnchor),
      
      bmiRecommendationDescription.topAnchor.constraint(equalTo: bmiRecommendation.bottomAnchor, constant: 8),
      bmiRecommendationDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
      bmiRecommendationDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
      
      reloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14),
      reloadButton.centerXAnchor.constraint(equalTo: bmiRecommendationDescription.centerXAnchor),
      
      trashButton.rightAnchor.constraint(equalTo: reloadButton.leftAnchor, constant: -60),
      trashButton.centerYAnchor.constraint(equalTo: reloadButton.centerYAnchor),
      
      shareButton.leftAnchor.constraint(equalTo: reloadButton.rightAnchor, constant: 60),
      shareButton.centerYAnchor.constraint(equalTo: reloadButton.centerYAnchor),
      ])
  }
  
  //  MARK: Helper methods
  
  @objc func presentAddDataViewController() {
    let addDataViewController = self.interactor.addDataViewController(observer: self, weight: vm?.weight, height: vm?.height, gender: vm?.gender)
    addDataViewController.transitioningDelegate = self
    
    present(addDataViewController, animated: true)
  }
  
  @objc func presentActivityViewController() {
    let text = BodyMassIndex.getTextToShare(weight: vm?.weight, height: vm?.height)
    let screenshot = infoEmoji.asImage() as Any
    
    let textToShare: [Any] = [ text, screenshot ]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook ]
    
    self.present(activityViewController, animated: true, completion: nil)
  }
  
  @objc func deleteLastDataPoint() {
    interactor.deleteLastDataPoint { (deleted) in
      if deleted {
        self.showAlert(title: "Deleted", message: "Your last introduced data point has been deleted, no body will know about it")
        self.reloadDataPoint()
      } else {
        self.showAlert(title: "Oooops...", message: "We were not able to delete your last data point, you can try it again later")
      }
    }
  }
  
  func getScreenshot() -> UIImage? {
    guard let keyWindow = UIApplication.shared.keyWindow else { return nil }
    UIGraphicsBeginImageContextWithOptions(keyWindow.layer.frame.size, false, UIScreen.main.scale)
    
    guard let graphicsCurrentContext = UIGraphicsGetCurrentContext() else { return nil }
    keyWindow.layer.render(in: graphicsCurrentContext)
    
    return UIGraphicsGetImageFromCurrentImageContext()
  }
  
  func reloadDataPoint() {
    interactor.getBmiComparison { difference in
      self.infoEmoji.text = BodyMassIndex.getEmojiForBMI(difference)
    }
    
    interactor.fetchLastDataPoint { (vm, error) in
      if error == nil {
        self.vm = vm
      } else {
        self.bmiSummary.text = Constants.defaultBmiSummary
        self.bmiRecommendation.text = Constants.defaultbmiRecommendation
      }
    }
    
    if let gender = interactor.fetchUserGender() {
      self.vm?.gender = gender
    }
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
