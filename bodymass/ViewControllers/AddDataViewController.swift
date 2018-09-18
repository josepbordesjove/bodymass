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
  
  private var vm: VM?
  private let interactor: DataPointInteractorType
  
  lazy var pageTitle: UILabel = {
    let label = UILabel()
    label.text = "BMI Calculator"
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var genderSelector: GenderSelector = {
    let selector = GenderSelector()
    selector.delegate = self
    
    return selector
  }()
  lazy var heightSelector: HeightSelector = {
    let selector = HeightSelector()
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
  
  lazy var pacmanWidthConstraint = pacmanToggle.widthAnchor.constraint(equalToConstant: 113)
  lazy var pacmanYConstraint = pacmanToggle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(view.frame.height / 2) - 30 - 36)
  
  private init(interactor: DataPointInteractorType) {
    self.interactor = interactor
    vm = VM(id: UUID().uuidString, weight: 55, height: 189)
    print("JBJ created vm: \(vm)")
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
    if let vm = vm {
     interactor.createDataPoint(id: vm.id, weight: vm.weight, height: vm.height)
    }
    
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
    self.vm?.height = value
  }
}

extension AddDataViewController: GenderSelectorDelegate {
  func genderChanged(value: Gender) {
    print("Selected gender: \(value)")
  }
}

extension AddDataViewController: WeightSelectorDelegate {
  func weightChanged(value: Float) {
    print("Selected weight: \(value)")
    self.vm?.weight = value
  }
}

extension AddDataViewController {
  struct VM {
    let id: String
    var weight: Float
    var height: Float
  }
}

extension AddDataViewController {
  enum Factory {
    static func viewController(interactor: DataPointInteractorType) -> UIViewController {
      let addDataViewController = AddDataViewController(interactor: interactor)
      addDataViewController.modalPresentationStyle = .overCurrentContext
      
      return addDataViewController
    }
  }
}
