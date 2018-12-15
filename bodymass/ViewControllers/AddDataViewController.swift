//
//  AddDataViewController.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit
import Firebase

class AddDataViewController: UIViewController, PacmanToggleDelegate {
  
  private var vm: VM
  private let interactor: DataPointInteractorType
  
  private struct Constants {
    static let defaultHeight: Double = 170
    static let defaultWeight: Double = 65
    static let defaultGender = Gender.undefined
    static let pacmanWidth: CGFloat = 200
    static let pacmanHeight: CGFloat = UIScreen.main.bounds.height * 0.07
  }
  
  lazy var header = Header(title: "BMI Calculator")
  lazy var genderSelector = GenderSelector(gender: vm.gender)
  lazy var heightSelector = HeightSelector(initialHeight: vm.height, gender: vm.gender)
  lazy var weightSelector = WeightSelector(initialWeight: vm.weight)
  lazy var pacmanToggle = PacmanToggle()
  lazy var summary = Summary(gender: self.vm.gender, height: self.vm.height, weight: self.vm.weight)
  lazy var pacmanWidthConstraint = pacmanToggle.widthAnchor.constraint(equalToConstant: Constants.pacmanWidth)
  lazy var pacmanYConstraint = pacmanToggle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(view.frame.height / 2) - Constants.pacmanHeight)
  
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
    
    Analytics.logEvent("add_data_view_controller_appeared", parameters: nil)
    
    genderSelector.delegate = self
    heightSelector.delegate = self
    weightSelector.delegate = self
    pacmanToggle.delegate = self
    
    setupView()
    setupConstraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.weightSelector.setupInitialPosition()
    
    animate(viewToCorrectPosition: self.weightSelector, withDamping: 0.7, andInitialSpringVelocity: 0)
    animate(viewToCorrectPosition: self.heightSelector, withDamping: 0.8, andInitialSpringVelocity: 10)
    animate(viewToCorrectPosition: self.genderSelector, withDamping: 0.65, andInitialSpringVelocity: 30)
  }
  
  private func setupView() {
    view.backgroundColor = .lightGrey
    header.closeButton.isHidden = false
    header.closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    heightSelector.unitSelector.unitSelectorButton.addTarget(self, action: #selector(presentUnitSelector), for: .touchUpInside)
    weightSelector.unitSelector.unitSelectorButton.addTarget(self, action: #selector(presentUnitSelector), for: .touchUpInside)
    [header, genderSelector, heightSelector, weightSelector, pacmanToggle, summary].forEach{ view.addSubview($0) }
  }
  
  private func setupConstraints() {
    let margin: CGFloat = 6
    
    NSLayoutConstraint.activate([
      header.topAnchor.constraint(equalTo: view.topAnchor),
      header.leftAnchor.constraint(equalTo: view.leftAnchor),
      header.rightAnchor.constraint(equalTo: view.rightAnchor),
      header.heightAnchor.constraint(equalToConstant: 40 + UIScreen.main.bounds.height * 0.095),
      
      summary.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
      summary.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
      summary.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 15),
      summary.heightAnchor.constraint(equalToConstant: 33),
      
      heightSelector.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
      heightSelector.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: margin/2),
      heightSelector.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: 15),
      heightSelector.bottomAnchor.constraint(equalTo: pacmanToggle.topAnchor, constant: -20),

      genderSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
      genderSelector.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -margin/2),
      genderSelector.bottomAnchor.constraint(equalTo: heightSelector.centerYAnchor, constant: -margin/margin),
      genderSelector.topAnchor.constraint(equalTo: heightSelector.topAnchor),

      weightSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
      weightSelector.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -margin/2),
      weightSelector.topAnchor.constraint(equalTo: heightSelector.centerYAnchor, constant: margin/2),
      weightSelector.bottomAnchor.constraint(equalTo: heightSelector.bottomAnchor),
      
      pacmanToggle.heightAnchor.constraint(equalToConstant: Constants.pacmanHeight),
      pacmanToggle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pacmanYConstraint,
      pacmanWidthConstraint,
      ])
  }
  
  func animate(viewToCorrectPosition view: UIView, withDamping damping: CGFloat, andInitialSpringVelocity velocity: CGFloat) {
    UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .curveEaseIn, animations: {
      view.transform = CGAffineTransform(translationX: 0, y: 0)
    }, completion: nil)
  }
  
  func shouldDismissViewController() {
    interactor.createDataPoint(id: vm.id, weight: vm.weight, height: vm.height)
    interactor.saveUserGender(vm.gender)
    Analytics.logEvent("did_create_data_point", parameters: [
      "weight": vm.weight as NSObject,
      "height": vm.height as NSObject
      ])
    transitioningDelegate = self
    
    dismiss(animated: true, completion: nil)
  }
  
  @objc func presentUnitSelector(selector: CustomButton) {
    guard let availableUnits = selector.associatedValues as? [Units] else { return }
    let pickerInteractor = PickerViewController.Interactor()
    let alertView = PickerViewController(units: availableUnits, interactor: pickerInteractor)
    alertView.delegate = self
    
    present(alertView, animated: true, completion: nil)
  }
  
  @objc func dismissViewController() {
    Analytics.logEvent("did_exit_without_saving", parameters: nil)
    dismiss(animated: true, completion: nil)
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
    self.summary.height = value
  }
}

extension AddDataViewController: GenderSelectorDelegate {
  func genderChanged(value: Gender) {
    self.vm.gender = value
    self.summary.gender = value
    self.heightSelector.gender = value
  }
}

extension AddDataViewController: WeightSelectorDelegate {
  func weightChanged(value: Double) {
    self.vm.weight = value
    self.summary.weight = value
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

extension AddDataViewController: PickerViewControllerDelegate {
  func unitsChanged(ofType type: UnitType) {
    summary.updateViews()
    
    switch type {
    case .height:
       heightSelector.updateViews()
    case .weight:
      weightSelector.updateViews()
    }
  }
}
