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
    }
  }
  
  lazy var title: UILabel = {
    let label = UILabel()
    label.text = "GENDER"
    label.font = UIFont.systemFont(ofSize: 17)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var genderImageBackgroundView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "gender-bkg")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  lazy var selectionNeedle: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "needle")
    imageView.contentMode = .scaleAspectFit
    imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.85)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
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
    rotateNeddleForGender(value: gender)
    addGestureRecognizer(tapGestureRecognizer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 5
    layer.cornerRadius = 8
    backgroundColor = .white
    translatesAutoresizingMaskIntoConstraints = false
    [title, genderImageBackgroundView, selectionNeedle].forEach { addSubview($0) }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      title.centerXAnchor.constraint(equalTo: centerXAnchor),
      title.topAnchor.constraint(equalTo: topAnchor, constant: 31),
      
      genderImageBackgroundView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 15),
      genderImageBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
      genderImageBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      genderImageBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
      
      selectionNeedle.centerXAnchor.constraint(equalTo: genderImageBackgroundView.centerXAnchor),
      selectionNeedle.centerYAnchor.constraint(equalTo: genderImageBackgroundView.bottomAnchor, constant: -30),
      selectionNeedle.widthAnchor.constraint(equalToConstant: 16),
      selectionNeedle.heightAnchor.constraint(equalToConstant: 56)
      ])
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
