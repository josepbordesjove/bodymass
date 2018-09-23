//
//  AddDataViewController.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class AddDataViewController: UIViewController, PacmanToggleDelegate {
  
  private var vm: VM
  private let interactor: DataPointInteractorType
  
  private struct Constants {
    static let defaultHeight: Double = 170
    static let defaultWeight: Double = 65
    static let defaultGender = Gender.undefined
    static let pacmanWidth: CGFloat = 113
    static let pacmanHeight: CGFloat = 60
  }
  
  lazy var pageTitle = CustomLabel(text: "BMI Calculator", fontType: FontTypes.moderneSans, size: 24, color: .birdBlue)
  lazy var genderSelector = GenderSelector(gender: vm.gender)
  lazy var heightSelector = HeightSelector(initialHeight: vm.height)
  lazy var weightSelector = WeightSelector(initialWeight: vm.weight)
  lazy var pacmanToggle = PacmanToggle()
  lazy var pacmanWidthConstraint = pacmanToggle.widthAnchor.constraint(equalToConstant: Constants.pacmanWidth)
  lazy var pacmanYConstraint = pacmanToggle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(view.frame.height / 2) - 30 - 36)
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  private init(interactor: DataPointInteractorType, weight: Double?, height: Double?, gender: Gender?) {
    self.interactor = interactor
    self.vm = VM.create(weight: weight, height: height, gender: gender)
    super.init(nibName: nil, bundle: nil)
    
    self.modalPresentationStyle = .overCurrentContext
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    transitioningDelegate = self
    genderSelector.delegate = self
    heightSelector.delegate = self
    weightSelector.delegate = self
    pacmanToggle.delegate = self
    
    setupView()
    setupConstraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.weightSelector.setupInitialPosition()
    
    UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
      self.weightSelector.transform = CGAffineTransform(translationX: 0, y: 0)
    }, completion: nil)
    
    UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
      self.heightSelector.transform = CGAffineTransform(translationX: 0, y: 0)
    }, completion: nil)
    
    UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 30, options: .curveEaseIn, animations: {
      self.genderSelector.transform = CGAffineTransform(translationX: 0, y: 0)
    }, completion: { (_) in
      self.heightSelector.setupInitialPosition()
    })
  }
  
  private func setupView() {
    view.backgroundColor = .lightGrey
    [pageTitle, genderSelector, heightSelector, weightSelector, pacmanToggle].forEach{ view.addSubview($0) }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      pageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
      pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pageTitle.heightAnchor.constraint(equalToConstant: 30),
      
      pacmanToggle.heightAnchor.constraint(equalToConstant: Constants.pacmanHeight),
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
    interactor.createDataPoint(id: vm.id, weight: vm.weight, height: vm.height)
    interactor.saveUserGender(vm.gender)
    self.dismiss(animated: true, completion: nil)
  }
}

extension AddDataViewController: UIViewControllerTransitioningDelegate {
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return AddDataVCToMainVCTransition()
  }
}

extension AddDataViewController: HeightSelectorDelegate {
  func heightChanged(value: Double) {
    self.vm.height = value
  }
}

extension AddDataViewController: GenderSelectorDelegate {
  func genderChanged(value: Gender) {
    self.vm.gender = value
  }
}

extension AddDataViewController: WeightSelectorDelegate {
  func weightChanged(value: Double) {
    self.vm.weight = value
  }
}

extension AddDataViewController {
  struct VM {
    let id: String
    var weight: Double
    var height: Double
    var gender: Gender
    
    static func create(weight: Double?, height: Double?, gender: Gender?) -> VM {
      return VM(
        id: UUID().uuidString,
        weight: weight ?? Constants.defaultWeight,
        height: height ?? Constants.defaultHeight,
        gender: gender ?? Gender.undefined
      )
    }
  }
}

extension AddDataViewController {
  enum Factory {
    static func viewController(interactor: DataPointInteractorType, weight: Double?, height: Double?, gender: Gender?) -> UIViewController {
      return AddDataViewController(interactor: interactor, weight: weight, height: height, gender: gender)
    }
  }
}
