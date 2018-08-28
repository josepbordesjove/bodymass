//
//  AddDataViewController.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class AddDataViewController: UIViewController, PacmanToggleDelegate {
  
  lazy var pageTitle: UILabel = {
    let label = UILabel()
    label.text = "BMI Calculator"
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var genderSelector: GenderSelector = GenderSelector()
  lazy var heightSelector: HeightSelector = {
    let selector = HeightSelector()
    selector.delegate = self
    
    return selector
  }()
  lazy var weightSelector: WeightSelector = WeightSelector()
  
  lazy var pacmanToggle: PacmanToggle = {
    let toggle = PacmanToggle()
    toggle.delegate = self
    
    return toggle
  }()
  
  lazy var pacmanWidthConstraint = pacmanToggle.widthAnchor.constraint(equalToConstant: 113)
  lazy var pacmanYConstraint = pacmanToggle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(view.frame.height / 2) - 30 - 36)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.transitioningDelegate = self
    
    setupView()
    setupConstraints()
  }

  func setupView() {
    view.backgroundColor = .lightGrey
    [pageTitle, genderSelector, heightSelector, weightSelector, pacmanToggle].forEach{ view.addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      pageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
      pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pageTitle.heightAnchor.constraint(equalToConstant: 30),
      
      pacmanToggle.heightAnchor.constraint(equalToConstant: 60),
      pacmanToggle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pacmanYConstraint,
      pacmanWidthConstraint,
      
      heightSelector.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6),
      heightSelector.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 3),
      heightSelector.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 30),
      heightSelector.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),

      genderSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6),
      genderSelector.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -3),
      genderSelector.bottomAnchor.constraint(equalTo: heightSelector.centerYAnchor, constant: -3),
      genderSelector.topAnchor.constraint(equalTo: heightSelector.topAnchor),

      weightSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6),
      weightSelector.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -3),
      weightSelector.topAnchor.constraint(equalTo: heightSelector.centerYAnchor, constant: 3),
      weightSelector.bottomAnchor.constraint(equalTo: heightSelector.bottomAnchor),
      ])
  }
  
  func shouldDismissViewController() {
    self.dismiss(animated: true, completion: nil)
  }
}

extension AddDataViewController: UIViewControllerTransitioningDelegate {
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return AddDataVCToMainVCTransition()
  }
}

extension AddDataViewController: HeightSelectorDelegate {
  func heightChanged(value: Float) {
    print("Selected height: \(value)")
  }
  
  
}
