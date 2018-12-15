//
//  Header.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 11/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class Header: UIView {
  
  private struct Constants {
    static let textSize = UIScreen.main.bounds.width * 0.09
    static let margin = UIScreen.main.bounds.width * 0.05
  }
  
  lazy var pageTitle = CustomLabel(fontType: FontTypes.SFBold, size: Constants.textSize, color: .black)
  
  lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFill
    button.isHidden = true
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  init(title: String) {
    super.init(frame: CGRect())
    
    pageTitle.text = title
    setupView()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    backgroundColor = .white
    translatesAutoresizingMaskIntoConstraints = false
    [pageTitle, closeButton].forEach { addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      pageTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.margin),
      pageTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.margin),
      
      closeButton.centerYAnchor.constraint(equalTo: pageTitle.centerYAnchor),
      closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.margin),
      closeButton.widthAnchor.constraint(equalToConstant: 30),
      closeButton.heightAnchor.constraint(equalToConstant: 30)
      ])
  }
}
