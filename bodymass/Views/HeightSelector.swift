//
//  HeightSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class HeightSelector: UIView {
  
  private struct Constants {
    static let maxSelectableHeight: Int = 195
    static let minSelectableHeight: Int = 160
    static let stepBetweenNumbers: Int = 5
    static let maxHeight: Int = 200
    static let minHeight: Int = 150
  }
  
  let heightRange = Constants.minHeight...Constants.maxHeight
  weak var delegate: HeightSelectorDelegate?
  var savedHeight: Double {
    didSet {
      self.realHeight.text = String(format: "%.0f", savedHeight)
      delegate?.heightChanged(value: Double(savedHeight))
    }
  }
  
  lazy var unitSelector = UnitSelector(title: "HEIGHT", currentUnits: Units.retrieveCurrentHeightUnits(), availableUnits: Units.heightUnitsAvailable)
  lazy var bodyView = CustomImageView(image: #imageLiteral(resourceName: "body"), contentMode: .scaleAspectFit)
  lazy var heightLineView = CustomImageView(image: #imageLiteral(resourceName: "height-line"), contentMode: .scaleAspectFill)
  lazy var heightRoundedSelector = CustomImageView(image: #imageLiteral(resourceName: "height-selector"), contentMode: .scaleAspectFill)
  
  lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
    panGesture.maximumNumberOfTouches = 1
    panGesture.minimumNumberOfTouches = 1
    
    return panGesture
  }()
  
  lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.numberOfTouchesRequired = 1
    
    return tapGestureRecognizer
  }()
  
  lazy var realHeight: UILabel = {
    let label = UILabel()
    label.textColor = .lightishBlue
    label.alpha = 0
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var topAnchorHeightLineView = heightLineView.centerYAnchor.constraint(equalTo: topAnchor, constant: 200)
  
  init(initialHeight: Double) {
    self.savedHeight = initialHeight
    super.init(frame: CGRect())
    
    setupView()
    setupConstraints()
    setupNumbersView()
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
    
    self.realHeight.text = String(format: "%.0f", savedHeight)
    
    [unitSelector, bodyView, heightLineView, realHeight, heightRoundedSelector].forEach { addSubview($0) }
    [panGestureRecognizer, tapGestureRecognizer].forEach{ addGestureRecognizer($0) }
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      unitSelector.topAnchor.constraint(equalTo: topAnchor),
      unitSelector.leftAnchor.constraint(equalTo: leftAnchor),
      unitSelector.rightAnchor.constraint(equalTo: rightAnchor),
      unitSelector.heightAnchor.constraint(equalToConstant: 31),
      
      topAnchorHeightLineView,
      heightLineView.centerXAnchor.constraint(equalTo: centerXAnchor),
      heightLineView.widthAnchor.constraint(equalTo: widthAnchor),
      heightLineView.heightAnchor.constraint(equalToConstant: 10),
      
      bodyView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -43),
      bodyView.topAnchor.constraint(equalTo: heightLineView.bottomAnchor, constant: 5),
      bodyView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
      bodyView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -20),
      
      heightRoundedSelector.centerYAnchor.constraint(equalTo: heightLineView.centerYAnchor),
      heightRoundedSelector.leftAnchor.constraint(equalTo: leftAnchor),
      heightRoundedSelector.heightAnchor.constraint(equalToConstant: 31),
      heightRoundedSelector.widthAnchor.constraint(equalToConstant: 31),
      
      realHeight.leftAnchor.constraint(equalTo: heightLineView.leftAnchor),
      realHeight.bottomAnchor.constraint(equalTo: heightRoundedSelector.topAnchor, constant: -5),
      ])
  }
  
  private func setupNumbersView() {
    let numberOfElements = (heightRange.upperBound - heightRange.lowerBound) / Constants.stepBetweenNumbers
    let distanceMultiplier: CGFloat = 0.75 / CGFloat(numberOfElements)
    
    for i in stride(from: heightRange.lowerBound, to: heightRange.upperBound, by: Constants.stepBetweenNumbers) {
      let label = HeightLabel(labelText: i, isSelected: i == Int(savedHeight))
      addSubview(label)
      
      let previousHeightLabel = self.viewWithTag(i - Constants.stepBetweenNumbers) ?? nil
      let rightConstraint = label.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
      let heightConstraint = label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: distanceMultiplier)
      let bottomConstraint = previousHeightLabel == nil ?
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60) :
        label.bottomAnchor.constraint(equalTo: previousHeightLabel!.topAnchor)
      
     NSLayoutConstraint.activate([rightConstraint, heightConstraint, bottomConstraint])
    }
  }
  
  public func setupInitialPosition() {
    let heightRounded = Int((self.savedHeight / Double(Constants.stepBetweenNumbers)).rounded(.up) * Double(Constants.stepBetweenNumbers))
    if let heightViewLabel = self.viewWithTag(heightRounded) as? UILabel {
      let constant = heightViewLabel.frame.midY
      UIView.animate(withDuration: 0.25) {
        self.topAnchorHeightLineView.constant = constant
        self.layoutIfNeeded()
        heightViewLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        heightViewLabel.alpha = 1
      }
    }
  }
  
  // MARK: - Gesture helper methods
  
  @objc
  private func tapGestureHandler(sender: UITapGestureRecognizer) {
    let tappedPointY = sender.location(in: self).y
    
    evaluateGesturePositionChangeFor(pointY: tappedPointY, animated: true)
  }
  
  @objc
  private func panGestureHandler(sender: UIPanGestureRecognizer) {
    let translationY = sender.translation(in: self).y
    let absolutePositionY = topAnchorHeightLineView.constant + translationY
    
    if sender.state == .changed {
      evaluateGesturePositionChangeFor(pointY: absolutePositionY, animated: false)
    } else if sender.state == .began {
      dragBegin()
    } else if sender.state == .ended {
      dragEnded()
    }
    
    sender.setTranslation(.zero, in: self)
  }
  
  // MARK: - Helper methods
  
  private func evaluateGesturePositionChangeFor(pointY: CGFloat, animated: Bool) {
    guard let minPosition = viewWithTag(Constants.maxSelectableHeight)?.frame.minY else { return }
    guard let maxPosition = viewWithTag(Constants.minSelectableHeight)?.frame.maxY else { return }
    
    if pointY <= minPosition || pointY >= maxPosition { return }
    
    let percentage = (pointY - minPosition) / (maxPosition - minPosition)
    let height = Double(Constants.minSelectableHeight) + Double(1 - percentage) * Double((Constants.maxSelectableHeight - Constants.minSelectableHeight))
    
    if Int(savedHeight) != Int(height) {
      savedHeight = height
    }
    
    moveHeightViewTopConstraintTo(pointY: pointY, animated: animated)
    
    let heightLineViewCenter = heightLineView.frame.minY + heightLineView.frame.height / 2
    
    for i in stride(from: heightRange.lowerBound, to: heightRange.upperBound, by: Constants.stepBetweenNumbers) {
      guard let heightLabel = self.viewWithTag(i) as? UILabel else { continue }
      let isInsideRange = isPointInsideHeightsRange(pointY: heightLineViewCenter, frame: heightLabel.frame)
      animate(view: heightLabel, if: isInsideRange)
    }
  }
  
  private func isPointInsideHeightsRange(pointY: CGFloat, frame: CGRect) -> Bool {
    let tolerance: CGFloat = pointY == CGFloat(savedHeight) ? 2 : 5
    return frame.maxY + tolerance > pointY && frame.minY - tolerance < pointY
  }
  
  // MARK: - Animation methods
  
  private func dragBegin() {
    UIView.animate(withDuration: 0.5) {
      self.realHeight.alpha = 1
    }
  }
  
 private func dragEnded() {
    UIView.animate(withDuration: 0.5) {
      self.realHeight.alpha = 0
    }
  }
  
  private func animate(view: UIView, if isInsideRange: Bool = true) {
    if view.alpha == 0.6 && !isInsideRange || view.alpha == 1 && isInsideRange { return }
    
    if isInsideRange { UISelectionFeedbackGenerator().selectionChanged() }
      
    UIView.animate(withDuration: 0.1) {
      view.transform = isInsideRange ? CGAffineTransform(scaleX: 1, y: 1) : CGAffineTransform(scaleX: 0.6, y: 0.6)
      view.alpha = isInsideRange ? 1 : 0.6
    }
  }
  
  private func moveHeightViewTopConstraintTo(pointY: CGFloat, animated: Bool) {
    if (!animated) {
      topAnchorHeightLineView.constant = pointY
      return
    }
    
    UIView.animate(withDuration: 0.9, delay: 0.1, usingSpringWithDamping: 8, initialSpringVelocity: 12, options: .beginFromCurrentState, animations: {
      self.realHeight.alpha = 1
      self.topAnchorHeightLineView.constant = pointY
      self.layoutIfNeeded()
    }) { _ in
      UIView.animate(withDuration: 1, delay: 0.6, options: .curveEaseOut, animations: {
        self.realHeight.alpha = 0
      }, completion: nil)
    }
  }
}

// MARK: - Extends the class to create the default label for the heights

extension HeightSelector {
  class HeightLabel: UILabel {
    init(labelText: Int, isSelected:  Bool) {
      super.init(frame: CGRect())
      
      text = "\(labelText)"
      textColor = .specialBlue
      alpha = isSelected ? 1 : 0.6
      font = UIFont.systemFont(ofSize: 28)
      transform = isSelected ? CGAffineTransform(scaleX: 1, y: 1) : CGAffineTransform(scaleX: 0.6, y: 0.6)
      tag = labelText
      adjustsFontSizeToFitWidth = false
      isUserInteractionEnabled = false
      translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
