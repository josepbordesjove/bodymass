//
//  HeightSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit
import bodymassKit

class HeightSelector: UIView {
  
  private struct Constants {
    static let stepBetweenNumbers: Int = 5
    static let maxMenHeight: Int = 205
    static let minMenHeight: Int = 150
    static let maxWomenHeight: Int = 190
    static let minWomenHeight: Int = 135
  }
  
  weak var delegate: HeightSelectorDelegate?
  
  var heightRange: [Int]
  
  var gender: Gender {
    didSet {
      
    }
  }
  
  var savedHeight: Double {
    didSet {
      self.realHeight.text = FormatHelper.value(savedHeight, ofType: .height)
      delegate?.heightChanged(value: Double(savedHeight))
    }
  }
  
  lazy var unitSelector = UnitSelector(title: "HEIGHT", currentUnits: Units.retrieveCurrentHeightUnits(), availableUnits: Units.heightUnitsAvailable)
  lazy var bodyView = CustomImageView(image: #imageLiteral(resourceName: "body"), contentMode: .scaleAspectFit)
  lazy var heightLineView = CustomImageView(image: #imageLiteral(resourceName: "height-line"), contentMode: .scaleAspectFit)
  lazy var heightRoundedSelector = CustomImageView(image: #imageLiteral(resourceName: "height-selector"), contentMode: .scaleAspectFit)
  
  lazy var heightNumbers: UITableView = {
    let tableView = UITableView()
    tableView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
    tableView.backgroundColor = .clear
    tableView.showsHorizontalScrollIndicator = false
    tableView.isScrollEnabled = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.register(NumberCell.self, forCellReuseIdentifier: NumberCell.identifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    return tableView
  }()
  
  lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
    panGesture.maximumNumberOfTouches = 1
    panGesture.minimumNumberOfTouches = 1
    
    return panGesture
  }()
  
  lazy var realHeight: UILabel = {
    let label = UILabel()
    label.textColor = .lightishBlue
    label.alpha = 0
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var topAnchorHeightLineView = heightLineView.centerYAnchor.constraint(equalTo: topAnchor, constant: 200)
  
  init(initialHeight: Double, gender: Gender) {
    self.savedHeight = initialHeight
    self.gender = gender
    self.heightRange = HeightSelector.getRangeFor(gender: gender)
    super.init(frame: CGRect())
    
    setupView()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 5
    layer.cornerRadius = 8
    backgroundColor = .white
    
    self.realHeight.text = FormatHelper.value(savedHeight, ofType: .height)
    
    [unitSelector, bodyView, heightLineView, realHeight, heightRoundedSelector, heightNumbers].forEach { addSubview($0) }
    addGestureRecognizer(panGestureRecognizer)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      unitSelector.topAnchor.constraint(equalTo: topAnchor),
      unitSelector.leftAnchor.constraint(equalTo: leftAnchor),
      unitSelector.rightAnchor.constraint(equalTo: rightAnchor),
      unitSelector.heightAnchor.constraint(equalToConstant: 31),
      
      topAnchorHeightLineView,
      heightLineView.centerXAnchor.constraint(equalTo: centerXAnchor),
      heightLineView.widthAnchor.constraint(equalTo: widthAnchor),
      heightLineView.heightAnchor.constraint(equalToConstant: 10),
      
      bodyView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIScreen.main.bounds.height * 0.05),
      bodyView.topAnchor.constraint(equalTo: heightLineView.bottomAnchor, constant: 5),
      bodyView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
      bodyView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
      
      heightRoundedSelector.centerYAnchor.constraint(equalTo: heightLineView.centerYAnchor),
      heightRoundedSelector.leftAnchor.constraint(equalTo: leftAnchor),
      heightRoundedSelector.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.07),
      heightRoundedSelector.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.07),
      
      realHeight.leftAnchor.constraint(equalTo: heightLineView.leftAnchor),
      realHeight.topAnchor.constraint(equalTo: heightRoundedSelector.bottomAnchor, constant: 5),
      
      heightNumbers.topAnchor.constraint(equalTo: unitSelector.bottomAnchor, constant: UIScreen.main.bounds.width * 0.04),
      heightNumbers.leftAnchor.constraint(equalTo: leftAnchor),
      heightNumbers.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIScreen.main.bounds.width * -0.04),
      heightNumbers.rightAnchor.constraint(equalTo: rightAnchor)
      ])
  }
  
  private static func getRangeFor(gender: Gender) -> [Int] {
    switch gender {
    case .male, .undefined:
      return [Int](Constants.minMenHeight...Constants.maxMenHeight).filter { $0 % Constants.stepBetweenNumbers == 0 }.reversed()
    case .female:
      return [Int](Constants.minWomenHeight...Constants.maxWomenHeight).filter { $0 % Constants.stepBetweenNumbers == 0 }.reversed()
    }
  }
  
  public func setupInitialPosition() {
    heightNumbers.visibleCells.forEach { cell in
      guard let numberCell = cell as? NumberCell else { return }
      guard let assignedHeight = numberCell.assignedHeight else { return }
      
      if Double(assignedHeight) <= savedHeight && Double(assignedHeight) + Double(Constants.stepBetweenNumbers) > savedHeight {
        moveHeightViewTopConstraintTo(pointY: numberCell.frame.midY + heightNumbers.frame.minY, animated: true)
        numberCell.setSelectedStyle()
        return
      }
    }
  }
  
  public func updateViews() {
    unitSelector.currentUnits = Units.retrieveCurrentHeightUnits()
    heightNumbers.reloadData()
  }
  
  // MARK: - Gesture helper methods
  
  @objc private func tapGestureHandler(sender: UITapGestureRecognizer) {
    let tappedPointY = sender.location(in: self).y
    
    evaluateGesturePositionChangeFor(pointY: tappedPointY, animated: true)
  }
  
  @objc private func panGestureHandler(sender: UIPanGestureRecognizer) {
    let translationY = sender.translation(in: self).y
    let absolutePositionY = topAnchorHeightLineView.constant + translationY
    let relativePositionY = absolutePositionY - heightNumbers.frame.minY
    
    guard let minY = heightNumbers.visibleCells.first?.frame.minY else { return }
    guard let maxY = heightNumbers.visibleCells.last?.frame.maxY else { return }
    
    if relativePositionY <= minY || relativePositionY >= (maxY - self.frame.height * 0.2) {
      return
    }
    
    if sender.state == .changed {
      evaluateGesturePositionChangeFor(pointY: absolutePositionY, animated: false)
    } else if sender.state == .began {
      dragBegin()
    } else if sender.state == .ended {
      dragEnded()
    }
    
    sender.setTranslation(.zero, in: self)
  }
  
  // MARK: - Helper methods
  
  private func evaluateGesturePositionChangeFor(pointY: CGFloat, animated: Bool) {
    let correctedPosition = pointY - heightNumbers.frame.minY
    
    heightNumbers.visibleCells.forEach { cell  in
      guard let numberCell = cell as? NumberCell else { return }
      
      if numberCell.frame.maxY >= correctedPosition && numberCell.frame.minY <= correctedPosition {
        let percentage = (correctedPosition - numberCell.frame.minY) / (numberCell.frame.maxY - numberCell.frame.minY)
        
        if let roundedHeight = numberCell.assignedHeight {
          let realHeight = Double(roundedHeight) + (Double(Constants.stepBetweenNumbers) * Double(1 - percentage))
          
          if Int(savedHeight) != Int(realHeight) {
            self.savedHeight = realHeight
            UISelectionFeedbackGenerator().selectionChanged()
          }
        }
        
        numberCell.setSelectedStyle()
      } else {
        numberCell.setUnselectedStyle()
      }
    }
    
    moveHeightViewTopConstraintTo(pointY: pointY, animated: animated)
  }
  
  // MARK: - Animation methods
  
  private func dragBegin() {
    UIView.animate(withDuration: 0.5) {
      self.realHeight.alpha = 1
    }
  }
  
 private func dragEnded() {
    UIView.animate(withDuration: 0.5) {
      self.realHeight.alpha = 0
    }
  }
  
  private func moveHeightViewTopConstraintTo(pointY: CGFloat, animated: Bool) {
    if (!animated) {
      topAnchorHeightLineView.constant = pointY
      return
    }
    
    UIView.animate(withDuration: 0.9, delay: 0.1, usingSpringWithDamping: 8, initialSpringVelocity: 12, options: .beginFromCurrentState, animations: {
      self.realHeight.alpha = 1
      self.topAnchorHeightLineView.constant = pointY
      self.layoutIfNeeded()
    }) { _ in
      UIView.animate(withDuration: 1, delay: 0.6, options: .curveEaseOut, animations: {
        self.realHeight.alpha = 0
      }, completion: nil)
    }
  }
}

// MARK: - Collection View Data Source

extension HeightSelector: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return heightRange.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NumberCell.identifier, for: indexPath) as? NumberCell else { return UITableViewCell() }
    cell.assignedHeight = heightRange[indexPath.row]
    
    return cell
  }
}

// MARK: - Collection View Delegate

extension HeightSelector: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return (self.frame.height - UIScreen.main.bounds.width * 0.08) / CGFloat(heightRange.count + 1)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    heightNumbers.visibleCells.forEach { cell in
      guard let numberCell = cell as? NumberCell else { return }
      numberCell.setUnselectedStyle()
    }
    
    guard let numberCell = tableView.cellForRow(at: indexPath) as? NumberCell else { return }
    numberCell.setSelectedStyle()
    savedHeight = Double(heightRange[indexPath.row])
    UISelectionFeedbackGenerator().selectionChanged()
    moveHeightViewTopConstraintTo(pointY: numberCell.frame.midY + heightNumbers.frame.minY, animated: true)
  }
}

// MARK: - Extends the class to create the default label for the heights

extension HeightSelector {
  class NumberCell: UITableViewCell {
    
    struct Constants {
      static let textSize: CGFloat = UIScreen.main.bounds.width * 0.055
    }
    
    static let identifier = "NumberCell"
    
    var assignedHeight: Int? {
      didSet {
        guard let textValue = assignedHeight else { return }
        numberLabel.text = FormatHelper.value(textValue, ofType: .height)
      }
    }
    
    lazy var numberLabel: CustomLabel = {
      let label = CustomLabel(fontType: .SFBold, size: Constants.textSize, color: .lightPeriwinkle)
      label.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
      
      return label
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
      backgroundColor = .clear
      selectionStyle = .none
      addSubview(numberLabel)
    }
    
    private func setupCellConstraints() {
      NSLayoutConstraint.activate([
        numberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func setSelectedStyle() {
      numberLabel.textColor = .lightishBlue
      numberLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    public func setUnselectedStyle() {
      numberLabel.textColor = .lightPeriwinkle
      numberLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    }
  }
}
