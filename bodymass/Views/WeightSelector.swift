//
//  WeightSelector.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class WeightSelector: UIView {
  
  let weightRange: [Int] = Array(40...100)
  weak var delegate: WeightSelectorDelegate?
  var savedWeight: Int = 45 {
    didSet {
     delegate?.weightChanged(value: Double(savedWeight))
    }
  }
  
  lazy var title: UILabel = {
    let label = UILabel()
    label.text = "WEIGHT"
    label.font = UIFont.systemFont(ofSize: 17)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  lazy var units: UILabel = {
    let label = UILabel()
    label.text = "(kg)"
    label.font = UIFont.systemFont(ofSize: 8)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    weightNumbers.delegate = self
    weightNumbers.dataSource = self
    
    setupView()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 5
    layer.cornerRadius = 8
    backgroundColor = .white
    translatesAutoresizingMaskIntoConstraints = false
    [title, units, weightImageBackgroundView, weightNumbers].forEach { addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      title.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -units.bounds.width),
      title.topAnchor.constraint(equalTo: topAnchor, constant: 31),
      
      units.bottomAnchor.constraint(equalTo: title.bottomAnchor),
      units.leftAnchor.constraint(equalTo: title.rightAnchor),
      
      weightImageBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36),
      weightImageBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
      weightImageBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
      weightImageBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
      
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
    
    if indexPath.row == 1 {
      UIView.animate(withDuration: 0.5) {
        cell.numberLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
      }
    } else {
      UIView.animate(withDuration: 0.5) {
        cell.numberLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
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
        }
        if customCell.assignedWeight != savedWeight {
          savedWeight = customCell.assignedWeight!
        }
      } else {
        UIView.animate(withDuration: 0.1) {
          customCell.numberLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
      }
    }
  }
}

extension WeightSelector {
  class NumberCell: UICollectionViewCell {
    static let identifier = "NumberCell"
    
    var assignedWeight: Int? {
      didSet {
        guard let textValue = assignedWeight else { return }
        numberLabel.text = "\(textValue)"
      }
    }
    
    lazy var numberLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 25)
      label.translatesAutoresizingMaskIntoConstraints = false
      
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
    
    func setupCell() {
      addSubview(numberLabel)
    }
    
    func setupCellConstraints() {
      NSLayoutConstraint.activate([
        numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
    }
  }
}

