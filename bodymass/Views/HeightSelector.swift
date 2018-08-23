//
//  HeightSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class HeightSelector: UIView {
  
  let heightRange = 145...190
  var savedHeight = 175
  
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
    [title, units, bodyView, heightLineView].forEach { addSubview($0) }
    addGestureRecognizer(panGestureRecognizer)
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
      let button = UIButton()
      button.setTitle("\(i)", for: .normal)
      button.setTitleColor(.specialBlue, for: .normal)
      button.alpha = i == 165 ? 1 : 0.6
      button.titleLabel?.font = UIFont.systemFont(ofSize: i == 165 ? 40 : 18)
      button.tag = i
      button.translatesAutoresizingMaskIntoConstraints = false
      addSubview(button)
      
      let rightConstraint = button.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
      let heightConstraint = button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: distanceMultiplier)
      let bottomConstraint = i == heightRange.lowerBound ?
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60) :
        button.bottomAnchor.constraint(equalTo: self.viewWithTag(i - 5)!.topAnchor)
      
     NSLayoutConstraint.activate([rightConstraint, heightConstraint, bottomConstraint])
    }
  }
  
  // MARK: - Pan gesture helper methods
  
  @objc
  func panGestureHandler(sender: UIPanGestureRecognizer) {
    let translationY = sender.translation(in: self).y
    
    if sender.state == .changed {
      topAnchorHeightLineView.constant = topAnchorHeightLineView.constant + translationY
      let heightLineViewCenter = heightLineView.frame.minY + heightLineView.frame.height / 2
      
      for i in stride(from: heightRange.lowerBound, to: heightRange.upperBound, by: 5) {
        guard let heightButton = self.viewWithTag(i) as? UIButton else { continue }
        let isInsideRange = heightButton.frame.maxY > heightLineViewCenter && heightButton.frame.minY < heightLineViewCenter
        
        heightButton.titleLabel?.font = UIFont.systemFont(ofSize: isInsideRange  ? 40 : 18)
        heightButton.alpha = isInsideRange ? 1 : 0.6
        
        if isInsideRange && i != savedHeight {
          UISelectionFeedbackGenerator().selectionChanged()
          savedHeight = i
        }
      }
      
      sender.setTranslation(.zero, in: self)
    }
  }
}

