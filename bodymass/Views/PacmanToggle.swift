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
  var animateDots = true
  
  lazy var pacmanView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "pacman")
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  lazy var dotsView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [Dot(), Dot(), Dot(), Dot(), Dot(), Dot()])
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution = UIStackView.Distribution.equalSpacing
    stackView.alignment = UIStackView.Alignment.center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    return stackView
  }()
  
  lazy var panGestureRecognizer: UIPanGestureRecognizer = {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
    panGesture.maximumNumberOfTouches = 1
    panGesture.minimumNumberOfTouches = 1
    
    return panGesture
  }()
  
  lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
    tapGestureRecognizer.numberOfTapsRequired = 1
    tapGestureRecognizer.numberOfTouchesRequired = 1
    
    return tapGestureRecognizer
  }()
  
  lazy var pacmanHeight = pacmanView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05)
  lazy var pacmanWidth = pacmanView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05)
  
  init() {
    super.init(frame: CGRect())
    
    setupView()
    setupConstraints()
    animateDotsFadeInFadeOut()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    backgroundColor = .lightishBlue
    layer.cornerRadius = 7
    translatesAutoresizingMaskIntoConstraints = false
    
    [tapGestureRecognizer, panGestureRecognizer].forEach { addGestureRecognizer($0) }
    [pacmanView, dotsView].forEach { addSubview($0) }
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      pacmanView.centerYAnchor.constraint(equalTo: centerYAnchor),
      pacmanHeight,
      pacmanWidth,
      pacmanView.leftAnchor.constraint(equalTo: leftAnchor, constant: constants.pacmanMargin),
      
      dotsView.leftAnchor.constraint(equalTo: pacmanView.rightAnchor, constant: 10),
      dotsView.rightAnchor.constraint(equalTo: rightAnchor, constant: -constants.pacmanMargin),
      dotsView.centerYAnchor.constraint(equalTo: centerYAnchor),
      dotsView.heightAnchor.constraint(equalToConstant: 10)
      ])
  }
  
  // MARK: - Pan gesture helper methods
  
  @objc func tapGestureHandler(sender: UITapGestureRecognizer) {
    UISelectionFeedbackGenerator().selectionChanged()
    
    animateDotsOpacityToZero {
      UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 8, initialSpringVelocity: 10, options: .beginFromCurrentState, animations: {
        let rightTranslationLimit = self.layer.bounds.width - constants.pacmanMargin - self.pacmanView.bounds.width / 2
        self.pacmanView.center = CGPoint(x: rightTranslationLimit, y: self.pacmanView.center.y)
      }, completion: { _ in
        self.delegate?.shouldDismissViewController()
      })
    }
  }
  
  @objc func panGestureHandler(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: pacmanView)
    let currentPositionX = pacmanView.center.x + translation.x
    let rightTranslationLimit = self.layer.bounds.width - constants.pacmanMargin - pacmanView.bounds.width / 2
    let leftTranslationLimit = constants.pacmanMargin + pacmanView.bounds.width / 2
    
    if sender.state == .changed && currentPositionX < rightTranslationLimit && currentPositionX > leftTranslationLimit {
      if animateDots {
        animateDots = false
      }
      
      bringSubviewToFront(self.pacmanView)
      pacmanView.center = CGPoint(x: currentPositionX, y: pacmanView.center.y)
      sender.setTranslation(.zero, in: self)
      
      dotsView.arrangedSubviews.forEach { (view) in
        if (currentPositionX - 20) >= view.frame.minX {
          view.alpha = 0
        }
      }
      
    } else if sender.state == .ended && currentPositionX > rightTranslationLimit - 10 {
      UINotificationFeedbackGenerator().notificationOccurred(.success)
      delegate?.shouldDismissViewController()
    } else if sender.state == .ended{
      UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 8, initialSpringVelocity: 10, options: .beginFromCurrentState, animations: {
        self.pacmanView.center = CGPoint(x: leftTranslationLimit, y: self.pacmanView.center.y)
        self.dotsView.arrangedSubviews.forEach { (view) in
          UIView.animate(withDuration: 0.05, animations: {
            view.alpha = 0.54
          })
        }
      }, completion: nil)
    } else if sender.state == .began {
      UISelectionFeedbackGenerator().selectionChanged()
    }
  }
  
  // MARK: - Animations
  
  func animateDotsOpacityToZero(completion: @escaping (() -> Void)) {
    animateDots = false
    
    self.dotsView.arrangedSubviews.forEach { arrangedSubView in
      UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
        arrangedSubView.alpha = 0
      }, completion: { _ in
        if arrangedSubView == self.dotsView.arrangedSubviews.last {
          completion()
        }
      })
    }
  }
  
  func animateDotsFadeInFadeOut() {
    
    for (index, arrangedSubView) in dotsView.arrangedSubviews.enumerated() {
      self.animateFadeIn(arrangedSubView: arrangedSubView, index: index) {
        self.animateFadeOut(arrangedSubView: arrangedSubView, completion: {
          self.animateDotsFadeInFadeOut()
        })
      }
    }
    
  }
  
  func animateFadeIn(arrangedSubView: UIView, index: Int, completion: @escaping (() -> Void)) {
    if !animateDots {
      return
    }
    
    UIView.animate(withDuration: 0.2, delay: 0.1 * Double(index), options: .curveEaseInOut, animations: {
      arrangedSubView.alpha = 0.1
    }, completion: { _ in
      completion()
    })
  }
  
  func animateFadeOut(arrangedSubView: UIView, completion: @escaping (() -> Void)) {
    if !self.animateDots {
      return
    }
    
    UIView.animate(withDuration: 0.5, animations: {
      arrangedSubView.alpha = 0.54
    }, completion: { _ in
      if arrangedSubView == self.dotsView.arrangedSubviews.last && self.animateDots {
        completion()
      }
    })
  }
}

extension PacmanToggle {
  class Dot: UIImageView {
    
    init() {
      super.init(frame: CGRect(x: 0, y: 0, width: 9, height: 9))
      
      image = UIImage(named: "dot")
      layer.cornerRadius = 4.5
      backgroundColor = .white
      alpha = 0.54
      translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
}
