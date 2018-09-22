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
  
  lazy var pageTitle: UILabel = {
    let label = UILabel()
    label.text = "BMI Calculator"
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var genderSelector: GenderSelector = {
    let selector = GenderSelector(gender: self.vm.gender)
    selector.delegate = self
    
    return selector
  }()
  
  lazy var heightSelector: HeightSelector = {
    let selector = HeightSelector(initialHeight: vm.height)
    selector.delegate = self
    
    return selector
  }()
  
  lazy var weightSelector: WeightSelector = {
    let selector = WeightSelector()
    selector.delegate = self
    
    return selector
  }()
  
  lazy var pacmanToggle: PacmanToggle = {
    let toggle = PacmanToggle()
    toggle.delegate = self
    
    return toggle
  }()
  
  lazy var pacmanWidthConstraint = pacmanToggle.widthAnchor.constraint(equalToConstant: Constants.pacmanWidth)
  lazy var pacmanYConstraint = pacmanToggle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(view.frame.height / 2) - 30 - 36)
  
  private init(interactor: DataPointInteractorType, weight: Double?, height: Double?, gender: Gender?) {
    self.interactor = interactor
    self.vm = VM.create(weight: weight, height: height, gender: gender)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.transitioningDelegate = self
    
    setupView()
    setupConstraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let heightRounded = Int((heightSelector.savedHeight / 5).rounded(.up) * 5)
    if let heightViewLabel = heightSelector.viewWithTag(heightRounded) as? UILabel {
      let constant = heightViewLabel.frame.midY
      UIView.animate(withDuration: 0.5) {
        self.heightSelector.topAnchorHeightLineView.constant = constant
        self.heightSelector.layoutIfNeeded()
        heightViewLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        heightViewLabel.alpha = 1
      }
    }
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
    interactor.saveUserGender(value)
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
      let addDataViewController = AddDataViewController(interactor: interactor, weight: weight, height: height, gender: gender)
      addDataViewController.modalPresentationStyle = .overCurrentContext
      
      return addDataViewController
    }
  }
}
