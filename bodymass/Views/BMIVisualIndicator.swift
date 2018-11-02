//
//  BMIVisualIndicator.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 02/11/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class BMIVisualIndicator: UIView {
  
  private struct Constants {
    static let allowedValuesRange = BodyMassIndex.Constants.maxAllowedBMI - BodyMassIndex.Constants.minAllowedBMI
    static let minAllowed = BodyMassIndex.Constants.minAllowedBMI - Constants.allowedValuesRange
    static let maxAllowed = BodyMassIndex.Constants.maxAllowedBMI + Constants.allowedValuesRange
  }
  
  lazy var underweightView: UIView = {
    let view = UIView()
    view.backgroundColor = .underweightBlue
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  lazy var normalView: UIView = {
    let view = UIView()
    view.backgroundColor = .correctGreen
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  lazy var overweightView: UIView = {
    let view = UIView()
    view.backgroundColor = .overweightRed
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  lazy var indicatorView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 2
    view.backgroundColor = .charcoalGrey
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  lazy var indicatorLeftAnchor = indicatorView.leftAnchor.constraint(equalTo: leftAnchor)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    [underweightView, normalView, overweightView, indicatorView].forEach { addSubview($0) }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: 50),
    
      underweightView.leftAnchor.constraint(equalTo: leftAnchor),
      underweightView.centerYAnchor.constraint(equalTo: centerYAnchor),
      underweightView.heightAnchor.constraint(equalToConstant: 5),
      underweightView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
      
      normalView.centerXAnchor.constraint(equalTo: centerXAnchor),
      normalView.centerYAnchor.constraint(equalTo: centerYAnchor),
      normalView.heightAnchor.constraint(equalToConstant: 5),
      normalView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
      
      overweightView.rightAnchor.constraint(equalTo: rightAnchor),
      overweightView.centerYAnchor.constraint(equalTo: centerYAnchor),
      overweightView.heightAnchor.constraint(equalToConstant: 5),
      overweightView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
      
      indicatorView.heightAnchor.constraint(equalToConstant: 18),
      indicatorView.widthAnchor.constraint(equalToConstant: 4),
      indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
      indicatorLeftAnchor,
      ])
  }
  
  public func updateIndicatorViewConstraint(bmi: Double) {
    let indicatorPercentageOffset: CGFloat = CGFloat((bmi - Constants.minAllowed) / (Constants.maxAllowed - Constants.minAllowed))
    let barSize = UIScreen.main.bounds.width - 40
    var indicatorOffset = barSize * indicatorPercentageOffset
    
    if bmi < BodyMassIndex.Constants.minAllowedBMI - Constants.allowedValuesRange {
      indicatorOffset = 0
    } else if bmi > BodyMassIndex.Constants.maxAllowedBMI + Constants.allowedValuesRange {
      indicatorOffset = barSize - 4
    }
    
    UIView.animate(withDuration: 1) {
      self.indicatorLeftAnchor.constant = indicatorOffset
    }
  }
}
