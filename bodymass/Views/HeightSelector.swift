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
    static let maxSelectableHeight: Int = 195
    static let minSelectableHeight: Int = 160
    static let stepBetweenNumbers: Int = 5
    static let maxHeight: Int = 210
    static let minHeight: Int = 150
  }
  
  let heightRange: [Int] = {
    return [Int](Constants.minHeight...Constants.maxHeight).filter { $0 % 5 == 0 }.reversed()
  }()
  
  weak var delegate: HeightSelectorDelegate?
  var savedHeight: Double {
    didSet {
      self.realHeight.text = FormatHelper.value(savedHeight, ofType: .height)
      delegate?.heightChanged(value: Double(savedHeight))
    }
  }
  
  lazy var unitSelector = UnitSelector(title: "HEIGHT", currentUnits: Units.retrieveCurrentHeightUnits(), availableUnits: Units.heightUnitsAvailable)
  lazy var bodyView = CustomImageView(image: #imageLiteral(resourceName: "body"), contentMode: .scaleAspectFit)
  lazy var heightLineView = CustomImageView(image: #imageLiteral(resourceName: "height-line"), contentMode: .scaleAspectFill)
  lazy var heightRoundedSelector = CustomImageView(image: #imageLiteral(resourceName: "height-selector"), contentMode: .scaleAspectFill)
  
  lazy var heightNumbers: UITableView = {
    let tableView = UITableView()
    tableView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
    tableView.backgroundColor = .clear
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
  
  init(initialHeight: Double) {
    self.savedHeight = initialHeight
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
      
      bodyView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      bodyView.topAnchor.constraint(equalTo: heightLineView.bottomAnchor, constant: 5),
      bodyView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
      bodyView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -20),
      
      heightRoundedSelector.centerYAnchor.constraint(equalTo: heightLineView.centerYAnchor),
      heightRoundedSelector.leftAnchor.constraint(equalTo: leftAnchor),
      heightRoundedSelector.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.07),
      heightRoundedSelector.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.07),
      
      realHeight.leftAnchor.constraint(equalTo: heightLineView.leftAnchor),
      realHeight.topAnchor.constraint(equalTo: heightRoundedSelector.bottomAnchor, constant: 5),
      
      heightNumbers.topAnchor.constraint(equalTo: unitSelector.bottomAnchor, constant: UIScreen.main.bounds.width * 0.03),
      heightNumbers.leftAnchor.constraint(equalTo: leftAnchor),
      heightNumbers.bottomAnchor.constraint(equalTo: bottomAnchor),
      heightNumbers.rightAnchor.constraint(equalTo: rightAnchor)
      ])
  }
  
  func setupInitialPosition() {
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
    
    if relativePositionY <= minY || relativePositionY >= maxY {
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
  
  private func isPointInsideHeightsRange(pointY: CGFloat, frame: CGRect) -> Bool {
    let tolerance: CGFloat = pointY == CGFloat(savedHeight) ? 2 : 5
    return frame.maxY + tolerance > pointY && frame.minY - tolerance < pointY
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
    return UIScreen.main.bounds.height * 0.03
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    heightNumbers.visibleCells.forEach { cell in
      guard let numberCell = cell as? NumberCell else { return }
      numberCell.setUnselectedStyle()
    }
    
    guard let numberCell = tableView.cellForRow(at: indexPath) as? NumberCell else { return }
    numberCell.setSelectedStyle()
    moveHeightViewTopConstraintTo(pointY: numberCell.frame.midY + heightNumbers.frame.minY, animated: true)
  }
}

// MARK: - Extends the class to create the default label for the heights

extension HeightSelector {
  class NumberCell: UITableViewCell {
    
    struct Constants {
      static let textSize: CGFloat = UIScreen.main.bounds.width * 0.07
    }
    
    static let identifier = "NumberCell"
    
    var assignedHeight: Int? {
      didSet {
        guard let textValue = assignedHeight else { return }
        numberLabel.text = FormatHelper.value(textValue, ofType: .weight)
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
        numberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
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
