//
//  GenderSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class GenderSelector: UIView {
  
  weak var delegate: GenderSelectorDelegate?
  var gender: Gender {
    didSet {
      self.rotateNeddleForGender(value: gender)
      delegate?.genderChanged(value: gender)
      updateViews()
    }
  }
  
  lazy var unitSelector = UnitSelector(title: "GENDER")
  lazy var genderImageBackgroundView = CustomImageView(image: #imageLiteral(resourceName: "gender-bkg"), contentMode: .scaleAspectFit)
  lazy var genderUndefined = CustomImageView(image: #imageLiteral(resourceName: "undefined"), contentMode: .scaleAspectFit)
  lazy var genderMale = CustomImageView(image: #imageLiteral(resourceName: "male"), contentMode: .scaleAspectFit)
  lazy var genderFemale = CustomImageView(image: #imageLiteral(resourceName: "female"), contentMode: .scaleAspectFit)
  lazy var selectionNeedle = CustomImageView(image: #imageLiteral(resourceName: "needle"), contentMode: .scaleAspectFit, anchorPoint: CGPoint(x: 0.5, y: 0.85))
  
  lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.numberOfTouchesRequired = 1
    
    return tapGestureRecognizer
  }()
  
  init(gender: Gender) {
    self.gender = gender
    super.init(frame: CGRect())
    
    setupView()
    setupConstraints()
    setupInitial()
    addGestureRecognizer(tapGestureRecognizer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupInitial() {
    print(gender)
    updateViews()
    rotateNeddleForGender(value: gender)
  }
  
  private func setupView() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 5
    layer.cornerRadius = 8
    backgroundColor = .white
    translatesAutoresizingMaskIntoConstraints = false
    [unitSelector, genderImageBackgroundView, selectionNeedle, genderUndefined, genderMale, genderFemale].forEach { addSubview($0) }
    
    guard let genderFemaleImage = genderFemale.image else { return }
    let tintedGenderFemale = genderFemaleImage.withRenderingMode(.alwaysTemplate)
    genderFemale.image = tintedGenderFemale
    
    guard let genderMaleImage = genderMale.image else { return }
    let tintedGenderMale = genderMaleImage.withRenderingMode(.alwaysTemplate)
    genderMale.image = tintedGenderMale
    
    guard let genderUndefinedImage = genderUndefined.image else { return }
    let tintedGenderUndefined = genderUndefinedImage.withRenderingMode(.alwaysTemplate)
    genderUndefined.image = tintedGenderUndefined
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      unitSelector.topAnchor.constraint(equalTo: topAnchor),
      unitSelector.leftAnchor.constraint(equalTo: leftAnchor),
      unitSelector.rightAnchor.constraint(equalTo: rightAnchor),
      unitSelector.heightAnchor.constraint(equalToConstant: 31),
      
      genderUndefined.centerXAnchor.constraint(equalTo: centerXAnchor),
      genderUndefined.topAnchor.constraint(equalTo: unitSelector.bottomAnchor, constant: 5),
      genderUndefined.heightAnchor.constraint(equalToConstant: 23),
      genderUndefined.widthAnchor.constraint(equalToConstant: 23),
      
      genderMale.leftAnchor.constraint(equalTo: genderUndefined.rightAnchor, constant: UIScreen.main.bounds.width * 0.07),
      genderMale.topAnchor.constraint(equalTo: genderUndefined.bottomAnchor),
      genderMale.heightAnchor.constraint(equalToConstant: 18),
      genderMale.widthAnchor.constraint(equalToConstant: 18),
      
      genderFemale.rightAnchor.constraint(equalTo: genderUndefined.leftAnchor, constant: -UIScreen.main.bounds.width * 0.07),
      genderFemale.topAnchor.constraint(equalTo: genderUndefined.bottomAnchor),
      genderFemale.heightAnchor.constraint(equalToConstant: 18),
      genderFemale.widthAnchor.constraint(equalToConstant: 18),
      
      genderImageBackgroundView.topAnchor.constraint(equalTo: genderUndefined.bottomAnchor, constant: 15),
      genderImageBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
      genderImageBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      genderImageBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
      
      selectionNeedle.centerXAnchor.constraint(equalTo: genderImageBackgroundView.centerXAnchor),
      selectionNeedle.centerYAnchor.constraint(equalTo: genderImageBackgroundView.centerYAnchor),
      selectionNeedle.widthAnchor.constraint(equalToConstant: 16),
      selectionNeedle.heightAnchor.constraint(equalTo: genderImageBackgroundView.heightAnchor, multiplier: 0.5),
      ])
  }
  
  func updateViews() {
    switch gender {
    case .female:
      genderFemale.tintColor = .lightishBlue
      genderMale.tintColor = .lightPeriwinkle
      genderUndefined.tintColor = .lightPeriwinkle
    case .male:
      genderFemale.tintColor = .lightPeriwinkle
      genderMale.tintColor = .lightishBlue
      genderUndefined.tintColor = .lightPeriwinkle
    case .undefined:
      genderFemale.tintColor = .lightPeriwinkle
      genderMale.tintColor = .lightPeriwinkle
      genderUndefined.tintColor = .lightishBlue
    }
  }
  
  // MARK: - Gesture recognizers functions
  
  @objc
  private func tapGestureHandler(sender: UITapGestureRecognizer) {
    let tappedPoint = sender.location(in: self)
    let center = CGPoint(
      x: selectionNeedle.layer.anchorPoint.x * selectionNeedle.frame.width + selectionNeedle.frame.minX,
      y: selectionNeedle.layer.anchorPoint.y * selectionNeedle.frame.height + selectionNeedle.frame.minY
    )
    
    if tappedPoint.y > center.y {
      return
    }
    
    let tappedZone = tappedPoint.x / self.frame.width
    
    UISelectionFeedbackGenerator().selectionChanged()
    
    if tappedZone > 0 && tappedZone <= 0.33 {
      self.gender = .female
    } else if tappedZone > 0.33 && tappedZone <= 0.66 {
      self.gender = .undefined
    } else if tappedZone > 0.66 && tappedZone <= 1 {
      self.gender = .male
    }
  }
  
  // MARK: - Animation functions
  
  private func rotateNeddleForGender(value: Gender) {
    var animationAngle: CGFloat = 0
    
    switch gender {
    case .male:
      animationAngle = 0.6
    case .female:
      animationAngle = -0.6
    default:
      break
    }
    
    UIView.animate(withDuration: 1.5, delay: 0.05, usingSpringWithDamping: 14, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
      self.selectionNeedle.transform = CGAffineTransform(rotationAngle: animationAngle)
    }, completion: nil)
  }
}
