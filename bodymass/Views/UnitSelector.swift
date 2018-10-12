//
//  UnitSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 12/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

enum Units: String {
  case meters = "m"
  case inches = "in"
  case kilograms = "kg"
  case pounds = "lb"
}

class UnitSelector: UIView {
  
  let unitsAvailable: [Units]
  
  lazy var title = CustomLabel(fontType: .SFSemibold, size: 16, color: .dark)
  lazy var separator: UIView = {
    let view = UIView()
    view.backgroundColor = .blueGreyTranslucid
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  lazy var unitSelectorButton: UIButton = {
    let button = UIButton()
    button.setTitle("(kg)", for: .normal)
    button.setImage(#imageLiteral(resourceName: "arrow-down"), for: .normal)
    button.setTitleColor(.blueGrey, for: .normal)
    button.titleLabel?.font = UIFont(name: FontTypes.SFRegular.rawValue, size: 11)
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  init(title: String, unitsAvailable: [Units] = []) {
    self.unitsAvailable = unitsAvailable
    super.init(frame: CGRect())
    
    self.title.text = title
    setupView(withSelector: unitsAvailable.count > 0)
    setupConstraints(withSelector: unitsAvailable.count > 0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView(withSelector: Bool) {
    if withSelector {
      addSubview(unitSelectorButton)
    }
    
    [title, separator].forEach { addSubview($0) }
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setupConstraints(withSelector: Bool) {
    NSLayoutConstraint.activate([
      title.centerYAnchor.constraint(equalTo: centerYAnchor),
      title.leftAnchor.constraint(equalTo: leftAnchor, constant: 13),
      
      separator.leftAnchor.constraint(equalTo: leftAnchor),
      separator.rightAnchor.constraint(equalTo: rightAnchor),
      separator.heightAnchor.constraint(equalToConstant: 0.5),
      separator.bottomAnchor.constraint(equalTo: bottomAnchor),
      ])
    
    if withSelector {
      NSLayoutConstraint.activate([
        unitSelectorButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        unitSelectorButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -11.2),
        unitSelectorButton.heightAnchor.constraint(equalToConstant: 15),
        unitSelectorButton.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
  }
}
