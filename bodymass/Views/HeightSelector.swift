//
//  HeightSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class HeightSelector: UIView {
  
  private struct constants {
    static let minHeight: CGFloat = 0.1
    static let maxHeight: CGFloat = 0.7
  }
  
  let heightRange = 150...200
  var savedHeight = 165
  weak var delegate: HeightSelectorDelegate?
  
  lazy var title: UILabel = {
    let label = UILabel()
    label.text = "HEIGHT"
    label.font = UIFont.systemFont(ofSize: 17)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var units: UILabel = {
    let label = UILabel()
    label.text = "(cm)"
    label.font = UIFont.systemFont(ofSize: 8)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var bodyView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "body")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  lazy var heightLineView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "height-line")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
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
    label.text = "165"
    label.textColor = .sunriseYellow
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var topAnchorHeightLineView = heightLineView.topAnchor.constraint(equalTo: topAnchor, constant: 200)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    setupConstraints()
    setupNumbersView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 5
    layer.cornerRadius = 8
    backgroundColor = .white
    [title, units, bodyView, heightLineView, realHeight].forEach { addSubview($0) }
    [panGestureRecognizer, tapGestureRecognizer].forEach{ addGestureRecognizer($0) }
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      title.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -units.bounds.width),
      title.topAnchor.constraint(equalTo: topAnchor, constant: 31),
      
      units.bottomAnchor.constraint(equalTo: title.bottomAnchor),
      units.leftAnchor.constraint(equalTo: title.rightAnchor),
      
      topAnchorHeightLineView,
      heightLineView.centerXAnchor.constraint(equalTo: centerXAnchor),
      heightLineView.widthAnchor.constraint(equalTo: widthAnchor),
      heightLineView.heightAnchor.constraint(equalToConstant: 10),
      
      realHeight.leftAnchor.constraint(equalTo: heightLineView.leftAnchor),
      realHeight.bottomAnchor.constraint(equalTo: heightLineView.topAnchor),
      
      bodyView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -43),
      bodyView.topAnchor.constraint(equalTo: heightLineView.bottomAnchor, constant: 5),
      bodyView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
      bodyView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -20),
      ])
  }
  
  func setupNumbersView() {
    let step = 5
    let numberOfElements = (heightRange.upperBound - heightRange.lowerBound) / step
    let distanceMultiplier: CGFloat = 0.75 / CGFloat(numberOfElements)
    
    for i in stride(from: heightRange.lowerBound, to: heightRange.upperBound, by: step) {
      let label = HeightLabel(labelText: i, isSelected: i == savedHeight)
      addSubview(label)
      
      let previousHeightLabel = self.viewWithTag(i - step) ?? nil
      let rightConstraint = label.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
      let heightConstraint = label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: distanceMultiplier)
      let bottomConstraint = previousHeightLabel == nil ?
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60) :
        label.bottomAnchor.constraint(equalTo: previousHeightLabel!.topAnchor)
      
     NSLayoutConstraint.activate([rightConstraint, heightConstraint, bottomConstraint])
    }
  }
  
  // MARK: - Gesture helper methods
  
  @objc
  func tapGestureHandler(sender: UITapGestureRecognizer) {
    let tappedPointY = sender.location(in: self).y
    
    if tappedPointY < self.frame.height *  constants.minHeight || tappedPointY > self.frame.height * constants.maxHeight { return }
    
    evaluateGesturePositionChangeFor(tappedPointY)
    animateHeightViewTopConstraintTo(tappedPointY)
  }
  
  @objc
  func panGestureHandler(sender: UIPanGestureRecognizer) {
    let translationY = sender.translation(in: self).y
    let absolutePositionY = topAnchorHeightLineView.constant + translationY
    if absolutePositionY < self.frame.height * constants.minHeight || absolutePositionY > self.frame.height *  constants.maxHeight { return }
    
    if sender.state == .changed {
      topAnchorHeightLineView.constant = absolutePositionY
      let heightLineViewCenter = heightLineView.frame.minY + heightLineView.frame.height / 2
      _ = evaluateGesturePositionChangeFor(heightLineViewCenter)
      sender.setTranslation(.zero, in: self)
    }
  }
  
  // MARK: - Helper methods
  
  func evaluateGesturePositionChangeFor(_ newPoint: CGFloat) {
    var newActiveHeightFound = false
    
    for i in stride(from: heightRange.lowerBound, to: heightRange.upperBound, by: 5) {
      guard let heightLabel = self.viewWithTag(i) as? UILabel else { continue }
      let isInsideRange = isPointInsideHeightsRange(pointY: newPoint, frame: heightLabel.frame)
      animate(view: heightLabel, if: isInsideRange && !newActiveHeightFound)
      
      if i == savedHeight {
        let percentage = 5 * ((heightLineView.frame.midY - heightLineView.frame.minY) / (heightLabel.frame.maxY - heightLineView.frame.minY))
        let height = CGFloat(i) - percentage
        realHeight.text =  String(format: "%.1f", height)
        delegate?.heightChanged(value: Float(height))
      }
      
      if isInsideRange && i != savedHeight && !newActiveHeightFound {
        UISelectionFeedbackGenerator().selectionChanged()
        savedHeight = i
        newActiveHeightFound = true
      }
    }
  }
  
  func isPointInsideHeightsRange(pointY: CGFloat, frame: CGRect) -> Bool {
    let tolerance: CGFloat = pointY == CGFloat(savedHeight) ? 2 : 5
    return frame.maxY + tolerance > pointY && frame.minY - tolerance < pointY
  }
  
  func animate(view: UIView, if isInsideRange: Bool = true) {
    UIView.animate(withDuration: 0.2) {
      view.transform = isInsideRange ? CGAffineTransform(scaleX: 1, y: 1) : CGAffineTransform(scaleX: 0.6, y: 0.6)
      view.alpha = isInsideRange ? 1 : 0.6
    }
  }
  
  func animateHeightViewTopConstraintTo(_ pointY: CGFloat) {
    UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 8, initialSpringVelocity: 12, options: .beginFromCurrentState, animations: {
      self.topAnchorHeightLineView.constant = pointY
      self.layoutIfNeeded()
    }, completion: nil)
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
