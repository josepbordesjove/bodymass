//
//  PacmanToggle.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 15/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class PacmanToggle: UIView {
  
  private struct constants {
    static let pacmanMargin: CGFloat = 14
  }
  
  weak var delegate: PacmanToggleDelegate?
  
  lazy var pacmanView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "pacman")
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(panGestureRecognizer)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
    panGesture.maximumNumberOfTouches = 1
    panGesture.minimumNumberOfTouches = 1
    
    return panGesture
  }()
  
  let feedbackGenerator = UINotificationFeedbackGenerator()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    backgroundColor = .brightGreen
    layer.cornerRadius = 30
    translatesAutoresizingMaskIntoConstraints = false
    [pacmanView].forEach { addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      pacmanView.centerYAnchor.constraint(equalTo: centerYAnchor),
      pacmanView.topAnchor.constraint(equalTo: topAnchor, constant: constants.pacmanMargin),
      pacmanView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constants.pacmanMargin),
      pacmanView.leftAnchor.constraint(equalTo: leftAnchor, constant: constants.pacmanMargin)
      ])
  }
  
  // MARK: - Pan gesture helper methods
  
  @objc
  func panGestureHandler(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: pacmanView)
    let currentPositionX = pacmanView.center.x + translation.x
    let rightTranslationLimit = self.layer.bounds.width - constants.pacmanMargin - pacmanView.bounds.width / 2
    let leftTranslationLimit = constants.pacmanMargin + pacmanView.bounds.width / 2
    
    if sender.state == .changed && currentPositionX < rightTranslationLimit && currentPositionX > leftTranslationLimit {
      bringSubview(toFront: self.pacmanView)
      pacmanView.center = CGPoint(x: currentPositionX, y: pacmanView.center.y)
      sender.setTranslation(.zero, in: self)
    } else if sender.state == .ended && currentPositionX > rightTranslationLimit - 10 {
      feedbackGenerator.notificationOccurred(.success)
      delegate?.shouldDismissViewController()
    }
  }
}
