//
//  HeightSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class HeightSelector: UIView {
  
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
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
    panGesture.maximumNumberOfTouches = 1
    panGesture.minimumNumberOfTouches = 1
    
    return panGesture
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    setupConstraints()
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
      
      heightLineView.leftAnchor.constraint(equalTo: leftAnchor),
      heightLineView.rightAnchor.constraint(equalTo: rightAnchor),
      heightLineView.topAnchor.constraint(equalTo: topAnchor, constant: 200),
      heightLineView.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      bodyView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -43),
      bodyView.topAnchor.constraint(equalTo: heightLineView.bottomAnchor, constant: 5),
      bodyView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
      bodyView.centerXAnchor.constraint(equalTo: centerXAnchor),
      ])
  }
  
  // MARK: - Pan gesture helper methods
  
  @objc
  func panGestureHandler(sender: UIPanGestureRecognizer) {
    let translationY = sender.translation(in: self).y + heightLineView.center.y
    
    switch sender.state {
    case .changed:
      print("Drag changed \(translationY)")
      heightLineView.center = CGPoint(x: heightLineView.center.y, y: translationY)
      sender.setTranslation(.zero, in: self)
    default:
      print("Drag default")
    }
  }
}

