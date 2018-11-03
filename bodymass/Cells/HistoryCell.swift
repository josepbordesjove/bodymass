//
//  HistoryCell.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 02/11/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class HistoryCell: UITableViewCell {
  private struct Constants {
    static let bmiSize: CGFloat = UIScreen.main.bounds.width * 0.12
    static let textSize: CGFloat = UIScreen.main.bounds.width * 0.04
  }
  
  static let identifier = "HistoryCell"
  
  var vm: History.VM? {
    didSet {
      prepareCellFor(vm: self.vm)
    }
  }
  
  lazy var descriptionLabel = CustomLabel(fontType: .SFBold, size: Constants.textSize, color: .blueGrey)
  lazy var bmiSummary = CustomLabel(fontType: .circularMedium, size: Constants.bmiSize, color: .charcoalGrey)
  lazy var dateLabel = CustomLabel(fontType: .SFBold, size: Constants.textSize, color: .blueGrey)
  lazy var weightDescriptor = InfoView(size: Constants.textSize, description: "W:")
  lazy var heightDescriptor = InfoView(size: Constants.textSize, description: "H:")
  lazy var genderDescriptor = InfoView(size: Constants.textSize, description: "G:")
  
  lazy var backgroundCard: UIView = {
    let view = UIView()
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.4
    view.layer.shadowOffset = CGSize.zero
    view.layer.shadowRadius = 5
    view.layer.cornerRadius = 8
    view.backgroundColor = .white
    view.clipsToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  lazy var statusIndicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .overweightRed
    view.clipsToBounds = true
    view.layer.cornerRadius = 8
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  lazy var distribuitionView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [weightDescriptor, heightDescriptor, genderDescriptor])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .firstBaseline
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupCell()
    setupCellConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupCell() {
    selectionStyle = .none
    backgroundColor = .clear
    [backgroundCard, statusIndicatorView, bmiSummary, descriptionLabel, dateLabel, distribuitionView].forEach { addSubview($0) }
  }
  
  private func setupCellConstraints() {
    NSLayoutConstraint.activate([
      backgroundCard.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
      backgroundCard.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
      backgroundCard.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      backgroundCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      
      statusIndicatorView.leftAnchor.constraint(equalTo: backgroundCard.leftAnchor),
      statusIndicatorView.topAnchor.constraint(equalTo: backgroundCard.topAnchor),
      statusIndicatorView.bottomAnchor.constraint(equalTo: backgroundCard.bottomAnchor),
      statusIndicatorView.widthAnchor.constraint(equalToConstant: 16),
      
      bmiSummary.centerYAnchor.constraint(equalTo: statusIndicatorView.centerYAnchor),
      bmiSummary.leftAnchor.constraint(equalTo: statusIndicatorView.rightAnchor, constant: 10),
      
      descriptionLabel.leftAnchor.constraint(equalTo: bmiSummary.rightAnchor, constant: 10),
      descriptionLabel.topAnchor.constraint(equalTo: backgroundCard.topAnchor, constant: 25),
      
      dateLabel.rightAnchor.constraint(equalTo: backgroundCard.rightAnchor, constant: -15),
      dateLabel.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
      
      distribuitionView.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor),
      distribuitionView.rightAnchor.constraint(equalTo: backgroundCard.rightAnchor),
      distribuitionView.bottomAnchor.constraint(equalTo: backgroundCard.bottomAnchor, constant: -30),
      ])
  }
  
  private func prepareCellFor(vm: History.VM?) {
    guard let vm = vm else { return }
    guard let height = vm.height else { return }
    guard let weight = vm.weight else { return }
    guard let gender = vm.gender else { return }
    guard let date = vm.date else { return }
    guard let bmi = BodyMassIndex.calculateBMI(weight: weight, height: height) else { return }
    
    descriptionLabel.text = BodyMassIndex.getDescriptionForBMI(bmi: bmi).uppercased()
    bmiSummary.text = String(format: "%.1f", bmi)
    statusIndicatorView.backgroundColor = BodyMassIndex.getColorIndicatorFor(bmi: bmi)
    dateLabel.text = date.toString()
    weightDescriptor.valueLabel.text = FormatHelper.value(weight, ofType: .weight, appendDescription: true)
    heightDescriptor.valueLabel.text = FormatHelper.value(height, ofType: .height)
    genderDescriptor.valueLabel.text = gender.shortDescription()
    
    layoutIfNeeded()
  }
}
