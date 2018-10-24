//
//  UnitSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 12/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class UnitSelector: UIView {
  
  let availableUnits: [Units]?
  var currentUnits: Units? {
    didSet {
      if let units = currentUnits {
        unitSelectorButton.setTitle("(\(units.abbreviation()))", for: .normal)
      }
    }
  }
  
  lazy var title = CustomLabel(fontType: .SFSemibold, size: 14, color: .dark)
  lazy var separator = Separator()
  
  lazy var unitSelectorButton: CustomButton = {
    let button = CustomButton()
    button.setImage(#imageLiteral(resourceName: "arrow-down"), for: .normal)
    button.setTitleColor(.blueGrey, for: .normal)
    button.titleLabel?.font = UIFont(name: FontTypes.SFRegular.rawValue, size: 11)
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    button.associatedValues = availableUnits
    button.translatesAutoresizingMaskIntoConstraints = false
    
    if let units = currentUnits {
      button.setTitle("(\(units.abbreviation()))", for: .normal)
    }
    
    return button
  }()
  
  init(title: String, currentUnits: Units? = nil, availableUnits: [Units]? = nil) {
    self.currentUnits = currentUnits
    self.availableUnits = availableUnits
    super.init(frame: CGRect())
    
    self.title.text = title
    setupView(withSelector: currentUnits != nil)
    setupConstraints(withSelector: currentUnits != nil)
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
