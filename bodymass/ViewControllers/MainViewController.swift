//
//  ViewController.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 5/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  lazy var pageTitle: UILabel = {
    let label = UILabel()
    label.text = "Your health"
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var imcSummary: UILabel = {
    let label = UILabel()
    label.text = "21.2"
    label.font = .boldSystemFont(ofSize: 120)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var balanceImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "balance")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  lazy var bmiRecommendation: UILabel = {
    let label = UILabel()
    label.text = "BMI = 22.96 kg/m2"
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var bmiRecommendationDescription: UILabel = {
    let label = UILabel()
    label.text = "Normal BMI weight range for the height: 128.9lbs - 174.2 lbs"
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.textColor = .gray
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var reloadButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "update"), size: 49)
  lazy var trashButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "trash"), size: 25)
  lazy var shareButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "share"), size: 25)
  lazy var profileButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "profile"), size: 123)
  lazy var homeButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "home"), size: 161)
  lazy var historyButton: CustomButton = CustomButton(image: #imageLiteral(resourceName: "history"), size: 123)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
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
      bmiRecommendationDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      bmiRecommendationDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
      
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
}

