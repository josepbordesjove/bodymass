//
//  WeightSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class WeightSelector: UIView {
  
  private struct Constants {
    static let maxWeight: Int = 120
    static let minWeight: Int = 40
  }
  
  let weightRange: [Int] = Array(Constants.minWeight...Constants.maxWeight)
  weak var delegate: WeightSelectorDelegate?
  var savedWeight: Double {
    didSet {
     delegate?.weightChanged(value: savedWeight)
    }
  }
  
  lazy var unitSelector = UnitSelector(title: "WEIGHT", unitsAvailable: [.kilograms, .pounds])
  
  lazy var weightImageBackgroundView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "weight-bkg")
    imageView.contentMode = .scaleToFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  lazy var flowLayout: UICollectionViewFlowLayout = {
    var flow = UICollectionViewFlowLayout()
    flow.minimumInteritemSpacing = 0
    flow.minimumLineSpacing = 0
    flow.scrollDirection = .horizontal
    
    return flow
  }()
  
  lazy var weightNumbers: UICollectionView = {
    let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
    collectionView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
    collectionView.backgroundColor = .white
    collectionView.bounces = true
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.alwaysBounceHorizontal = true
    collectionView.register(NumberCell.self, forCellWithReuseIdentifier: NumberCell.identifier)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    return collectionView
  }()
  
  init(initialWeight: Double) {
    self.savedWeight = initialWeight
    super.init(frame: CGRect())
    
    weightNumbers.delegate = self
    weightNumbers.dataSource = self
    
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
    translatesAutoresizingMaskIntoConstraints = false
    [unitSelector, weightImageBackgroundView, weightNumbers].forEach { addSubview($0) }
  }
  
  public func setupInitialPosition() {
    if let savedHeightIndex = weightRange.firstIndex(of: Int(savedWeight)) {
      weightNumbers.scrollToItem(at: IndexPath(item: savedHeightIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      unitSelector.topAnchor.constraint(equalTo: topAnchor),
      unitSelector.leftAnchor.constraint(equalTo: leftAnchor),
      unitSelector.rightAnchor.constraint(equalTo: rightAnchor),
      unitSelector.heightAnchor.constraint(equalToConstant: 31),
      
      weightImageBackgroundView.topAnchor.constraint(equalTo: unitSelector.bottomAnchor, constant: 10),
      weightImageBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
      weightImageBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
      weightImageBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      
      weightNumbers.leftAnchor.constraint(equalTo: weightImageBackgroundView.leftAnchor),
      weightNumbers.rightAnchor.constraint(equalTo: weightImageBackgroundView.rightAnchor),
      weightNumbers.topAnchor.constraint(equalTo: weightImageBackgroundView.topAnchor),
      weightNumbers.bottomAnchor.constraint(equalTo: weightImageBackgroundView.bottomAnchor)
      ])
  }
}

extension WeightSelector: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return weightRange.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCell.identifier, for: indexPath) as? NumberCell else { return UICollectionViewCell() }
    cell.assignedWeight = weightRange[indexPath.row]
    
    if let savedHeightIndex = weightRange.firstIndex(of: Int(savedWeight)) {
      if savedHeightIndex == indexPath.row {
        cell.numberLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
         cell.numberLabel.textColor = .lightishBlue
      }
    }

    return cell
  }
}

extension WeightSelector: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    weightNumbers.visibleCells.forEach { (cell) in
      guard let customCell = cell as? NumberCell else { return }
      let center = weightImageBackgroundView.frame.minX + weightImageBackgroundView.frame.width / 2
      let min = cell.frame.minX + weightNumbers.frame.minX - weightNumbers.contentOffset.x
      let max = cell.frame.maxX + weightNumbers.frame.minX - weightNumbers.contentOffset.x
      
      if center > min && center < max {
        UIView.animate(withDuration: 0.1) {
          customCell.numberLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
          customCell.numberLabel.textColor = .lightishBlue
        }
        if customCell.assignedWeight != nil && customCell.assignedWeight != Int(savedWeight) {
          savedWeight = Double(customCell.assignedWeight!)
          UISelectionFeedbackGenerator().selectionChanged()
        }
      } else {
        UIView.animate(withDuration: 0.1) {
          customCell.numberLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
          customCell.numberLabel.textColor = .lightPeriwinkle
        }
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    weightNumbers.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }

}

extension WeightSelector {
  class NumberCell: UICollectionViewCell {
    
    struct Constants {
      static let textSize: CGFloat = UIScreen.main.bounds.width * 0.08
    }
    
    static let identifier = "NumberCell"
    
    var assignedWeight: Int? {
      didSet {
        guard let textValue = assignedWeight else { return }
        numberLabel.text = "\(textValue)"
      }
    }
    
    lazy var numberLabel: CustomLabel = {
      let label = CustomLabel(fontType: .SFBold, size: Constants.textSize, color: .lightPeriwinkle)
      label.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
      
      return label
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      setupCell()
      setupCellConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
      addSubview(numberLabel)
    }
    
    private func setupCellConstraints() {
      NSLayoutConstraint.activate([
        numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
    }
  }
}

