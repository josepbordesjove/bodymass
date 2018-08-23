//
//  GenderSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class GenderSelector: UIView {
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
    [title, genderImageBackgroundView].forEach { addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      title.centerXAnchor.constraint(equalTo: centerXAnchor),
      title.topAnchor.constraint(equalTo: topAnchor, constant: 31),
      
      genderImageBackgroundView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 15),
      genderImageBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
      genderImageBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      genderImageBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15)
      ])
  }
}
