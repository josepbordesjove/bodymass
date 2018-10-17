//
//  AddDataToMainViewController.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 22/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class AddDataVCToMainVCTransition: NSObject {
  fileprivate func prepare(_ viewController: AddDataViewController) {
    
  }
  
  fileprivate func reset(_ viewController: AddDataViewController) {
    
  }
}

extension AddDataVCToMainVCTransition: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let originViewController = transitionContext.viewController(forKey: .from) as? AddDataViewController else { return }
    guard let toViewController = transitionContext.viewController(forKey: .to) as? MainViewController else { return }
    toViewController.balanceImage.transform = CGAffineTransform(translationX: 0, y: 30)
    toViewController.bmiSummary.transform = CGAffineTransform(translationX: 0, y: 30)
    toViewController.bmiRecommendationDescription.transform = CGAffineTransform(translationX: 0, y: 30)
    toViewController.bmiRecommendation.transform = CGAffineTransform(translationX: 0, y: 30)
    toViewController.reloadButton.transform = CGAffineTransform(translationX: 0, y: 30)
    toViewController.trashButton.transform = CGAffineTransform(translationX: 0, y: 30)
    toViewController.shareButton.transform = CGAffineTransform(translationX: 0, y: 30)
    toViewController.infoEmoji.transform = CGAffineTransform(translationX: 0, y: 30)
    
    guard let snapshot = toViewController.view.snapshotView(afterScreenUpdates: true) else { return }
    
    let duration = transitionDuration(using: transitionContext)
    let containerView = transitionContext.containerView
    
    [snapshot, toViewController.view].forEach { containerView.addSubview($0) }
    snapshot.alpha = 0
    snapshot.transform = CGAffineTransform(translationX: 0, y: snapshot.frame.height)
    containerView.bringSubviewToFront(toViewController.view)
    
    toViewController.view.isHidden = true
    
    UIApplication.shared.keyWindow?.addSubview(toViewController.view)
    
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: .beginFromCurrentState,
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5/25) {
          originViewController.pacmanToggle.pacmanWidth.constant = 0
          originViewController.pacmanToggle.pacmanHeight.constant = 0
          originViewController.pacmanToggle.pacmanView.transform = CGAffineTransform(scaleX: 0, y: 0)
          originViewController.genderSelector.alpha = 0
          originViewController.heightSelector.alpha = 0
          originViewController.weightSelector.alpha = 0
          originViewController.header.alpha = 0
          originViewController.summary.alpha = 0
          originViewController.pacmanToggle.dotsView.arrangedSubviews.forEach { $0.alpha = 0 }
        }
        
        UIView.addKeyframe(withRelativeStartTime: 1.5/25, relativeDuration: 2/25) {
          originViewController.pacmanWidthConstraint.constant = 60
          originViewController.pacmanToggle.layer.cornerRadius = originViewController.pacmanToggle.frame.height / 2
          originViewController.pacmanYConstraint.constant = 0
          originViewController.view.layoutIfNeeded()
        }
        
        UIView.addKeyframe(withRelativeStartTime: 4/25, relativeDuration: 2/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 5/25, relativeDuration: 3/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 7/25, relativeDuration: 2/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 8/25, relativeDuration: 3/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 10/25, relativeDuration: 2/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 11/25, relativeDuration: 3/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 13/25, relativeDuration: 2/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 14/25, relativeDuration: 3/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 16/25, relativeDuration: 2/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 17/25, relativeDuration: 3/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 19/25, relativeDuration: 6/25) {
          originViewController.pacmanToggle.transform = CGAffineTransform(scaleX: 120, y: 120)
          originViewController.pacmanToggle.alpha = 0
        }
        
        UIView.addKeyframe(withRelativeStartTime: 24.7/25, relativeDuration: 0.3/25) {
          snapshot.transform = CGAffineTransform(translationX: 0, y: 0)
          snapshot.alpha = 1
        }
    },
      completion: { _ in
        toViewController.view.isHidden = false
        
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 15, options: .curveEaseIn, animations: {
          toViewController.balanceImage.transform = CGAffineTransform(translationX: 0, y: 0)
          toViewController.bmiSummary.transform = CGAffineTransform(translationX: 0, y: 0)
          toViewController.bmiRecommendationDescription.transform = CGAffineTransform(translationX: 0, y: 0)
          toViewController.bmiRecommendation.transform = CGAffineTransform(translationX: 0, y: 0)
          toViewController.reloadButton.transform = CGAffineTransform(translationX: 0, y: 0)
          toViewController.trashButton.transform = CGAffineTransform(translationX: 0, y: 0)
          toViewController.shareButton.transform = CGAffineTransform(translationX: 0, y: 0)
          toViewController.infoEmoji.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { (_) in
          transitionContext.completeTransition(true)
        })
    })
  }
}
