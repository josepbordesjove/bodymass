//
//  Summary.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 12/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class Summary: UIView {
  
  var gender: Gender {
    didSet {
      genderLabel.text = gender.rawValue.capitalized(with: Locale.current)
    }
  }
  
  var height: Double {
    didSet {
      heightLabel.text = FormatHelper.value(height, ofType: .height, appendDescription: true)
    }
  }
  
  var weight: Double {
    didSet {
      weightLabel.text = FormatHelper.value(weight, ofType: .weight, appendDescription: true)
    }
  }
  
  lazy var separatorOne = Separator()
  lazy var separatorTwo = Separator()
  
  lazy var genderLabel = CustomLabel(fontType: .SFRegular, size: 15, color: .blueGrey)
  lazy var heightLabel = CustomLabel(fontType: .SFRegular, size: 15, color: .blueGrey)
  lazy var weightLabel = CustomLabel(fontType: .SFRegular, size: 15, color: .blueGrey)
  
  lazy var labels: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [genderLabel, heightLabel, weightLabel])
    stackView.axis = .horizontal
    stackView.distribution = .equalSpacing
    stackView.alignment = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    return stackView
  }()
  
  init(gender: Gender, height: Double, weight: Double) {
    self.gender = gender
    self.height = height
    self.weight = weight
    super.init(frame: CGRect())
    
    setupView()
    setupConstraint()
    updateViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    [separatorOne, separatorTwo, labels].forEach { addSubview($0) }
    
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 5
    layer.cornerRadius = 8
    backgroundColor = .white
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setupConstraint() {
    NSLayoutConstraint.activate([
      separatorOne.topAnchor.constraint(equalTo: topAnchor),
      separatorOne.bottomAnchor.constraint(equalTo: bottomAnchor),
      separatorOne.widthAnchor.constraint(equalToConstant: 0.5),
      separatorOne.leftAnchor.constraint(equalTo: leftAnchor, constant: UIScreen.main.bounds.width / 3),
      
      separatorTwo.topAnchor.constraint(equalTo: topAnchor),
      separatorTwo.bottomAnchor.constraint(equalTo: bottomAnchor),
      separatorTwo.widthAnchor.constraint(equalToConstant: 0.5),
      separatorTwo.rightAnchor.constraint(equalTo: rightAnchor, constant: -UIScreen.main.bounds.width / 3),
      
      labels.widthAnchor.constraint(equalTo: widthAnchor),
      labels.heightAnchor.constraint(equalTo: heightAnchor),
      labels.centerXAnchor.constraint(equalTo: centerXAnchor),
      labels.centerYAnchor.constraint(equalTo: centerYAnchor),
      ])
  }
  
  public func updateViews() {
    heightLabel.text = FormatHelper.value(height, ofType: .height, appendDescription: true)
    weightLabel.text = FormatHelper.value(weight, ofType: .weight, appendDescription: true)
    genderLabel.text = gender.rawValue.capitalized(with: Locale.current)
  }
}
