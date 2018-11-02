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
    backgroundColor = .lightGrey
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
    cell.vm = historyDataPoints[indexPath.row]
    
    return cell
  }  
}

extension History: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
}
