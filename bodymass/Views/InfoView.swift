//
//  InfoView.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 02/11/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class InfoView: UIView {
  
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .blueGrey
    label.alpha = 0.4
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var valueLabel: UILabel = {
    let label = UILabel()
    label.textColor = .charcoalGrey
    label.alpha = 0.4
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  init(size: CGFloat, description: String) {
    super.init(frame: CGRect())
    
    descriptionLabel.font = UIFont.boldSystemFont(ofSize: size)
    valueLabel.font = UIFont.boldSystemFont(ofSize: size)
    
    descriptionLabel.text = description
    
    setupView()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    [descriptionLabel, valueLabel].forEach { addSubview($0) }
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor),
      
      valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      valueLabel.leftAnchor.constraint(equalTo: descriptionLabel.rightAnchor, constant: 3)
      ])
  }
}
