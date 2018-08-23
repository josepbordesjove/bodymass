//
//  WeightSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class WeightSelector: UIView {
  
  lazy var title: UILabel = {
    let label = UILabel()
    label.text = "WEIGHT"
    label.font = UIFont.systemFont(ofSize: 17)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var units: UILabel = {
    let label = UILabel()
    label.text = "(kg)"
    label.font = UIFont.systemFont(ofSize: 8)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var weightImageBackgroundView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "weight-bkg")
    imageView.contentMode = .scaleToFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
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
    translatesAutoresizingMaskIntoConstraints = false
    [title, units, weightImageBackgroundView].forEach { addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      title.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -units.bounds.width),
      title.topAnchor.constraint(equalTo: topAnchor, constant: 31),
      
      units.bottomAnchor.constraint(equalTo: title.bottomAnchor),
      units.leftAnchor.constraint(equalTo: title.rightAnchor),
      
      weightImageBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36),
      weightImageBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
      weightImageBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
      weightImageBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
      ])
  }
}

