//
//  History.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 28/10/2018.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class History: UIView {
  
  var historyDataPoints: [VM] {
    didSet {
      historyDataPointsTable.reloadData()
    }
  }
  
  lazy var historyDataPointsTable: UITableView = {
    let tableView = UITableView()
    tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    tableView.showsVerticalScrollIndicator = false
    tableView.isScrollEnabled = true
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    return tableView
  }()
  
  init(historyDataPoints: [ManagedDataPoint], gender: Gender?) {
    self.historyDataPoints = historyDataPoints.map { VM(id: $0.id, weight: $0.weight, height: $0.height, gender: gender, date: $0.creationDate) }
    super.init(frame: CGRect())
    
    setupView()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    [historyDataPointsTable].forEach { addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      historyDataPointsTable.topAnchor.constraint(equalTo: topAnchor),
      historyDataPointsTable.leftAnchor.constraint(equalTo: leftAnchor),
      historyDataPointsTable.bottomAnchor.constraint(equalTo: bottomAnchor),
      historyDataPointsTable.rightAnchor.constraint(equalTo: rightAnchor),
      ])
  }
}

extension History {
  struct VM {
    let id: String?
    let weight: Double?
    let height: Double?
    let gender: Gender?
    let date: Date?
  }
}

extension History: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return historyDataPoints.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else { return UITableViewCell() }
    let dataPoint = historyDataPoints[indexPath.row]
    guard let bmi = BodyMassIndex.calculateBMI(weight: dataPoint.weight, height: dataPoint.height) else { return cell }
    
    cell.descriptionLabel.text = BodyMassIndex.getDescriptionForBMI(bmi: bmi).uppercased()
    cell.bmiSummary.text = String(format: "%.1f", bmi)
    cell.statusIndicatorView.backgroundColor = BodyMassIndex.getColorIndicatorFor(bmi: bmi)
    
    return cell
  }  
}

extension History: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
}

class HistoryCell: UITableViewCell {
  static let identifier = "HistoryCell"
  
  lazy var descriptionLabel = CustomLabel(fontType: .SFBold, size: 16, color: .lightPeriwinkle)
  lazy var bmiSummary = CustomLabel(fontType: .SFHeavy, size: 40, color: .charcoalGrey)
  
  lazy var backgroundCard: UIView = {
    let view = UIView()
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.1
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
    [backgroundCard, statusIndicatorView, bmiSummary, descriptionLabel].forEach { addSubview($0) }
  }
  
  private func setupCellConstraints() {
    NSLayoutConstraint.activate([
      backgroundCard.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
      backgroundCard.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
      backgroundCard.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      backgroundCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      
      statusIndicatorView.leftAnchor.constraint(equalTo: backgroundCard.leftAnchor),
      statusIndicatorView.topAnchor.constraint(equalTo: backgroundCard.topAnchor),
      statusIndicatorView.bottomAnchor.constraint(equalTo: backgroundCard.bottomAnchor),
      statusIndicatorView.widthAnchor.constraint(equalToConstant: 20),
      
      bmiSummary.centerYAnchor.constraint(equalTo: statusIndicatorView.centerYAnchor),
      bmiSummary.leftAnchor.constraint(equalTo: statusIndicatorView.rightAnchor, constant: 10),
      
      descriptionLabel.leftAnchor.constraint(equalTo: bmiSummary.rightAnchor, constant: 20),
      descriptionLabel.topAnchor.constraint(equalTo: bmiSummary.topAnchor),
      ])
  }
}
