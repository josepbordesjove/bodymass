//
//  MainSummary.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 28/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class MainSummary: UIView {
  private struct Constants {
    static let defaultBmiSummary = "--.-"
    static let defaultbmiRecommendation = "No data available"
    static let emojiSize = UIScreen.main.bounds.width * 0.2
    static let bmiSize = UIScreen.main.bounds.width * 0.22
  }
  
  lazy var infoEmoji = CustomLabel(text: "🦁", size: Constants.emojiSize)
  lazy var bmiSummary = CustomLabel(fontType: .SFHeavy, size: Constants.bmiSize, color: .charcoalGrey)
  lazy var bmiRecommendation = CustomLabel(fontType: .circularMedium, size: 17.3, color: .charcoalGrey)
  lazy var bmiRecommendationDescription = CustomLabel(fontType: .circularMedium, size: 13.4, color: .lightPeriwinkle)
  lazy var balanceImage = CustomImageView(image: #imageLiteral(resourceName: "balance"))
  lazy var bmiVisualIndicator = BMIVisualIndicator()
  
  lazy var distribuitionView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [infoEmoji, bmiSummary, balanceImage, bmiRecommendation, bmiVisualIndicator, bmiRecommendationDescription])
    stackView.axis = .vertical
    stackView.distribution = .equalCentering
    stackView.alignment = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    return stackView
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
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(distribuitionView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      bmiSummary.heightAnchor.constraint(equalToConstant: 80),
      
      distribuitionView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
      distribuitionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
      distribuitionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
      distribuitionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
      ])
  }
}
