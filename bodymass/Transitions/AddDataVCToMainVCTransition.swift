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
          originViewController.pacmanToggle.pacmanView.transform = CGAffineTransform(scaleX: 0, y: 0)
          originViewController.genderSelector.alpha = 0
          originViewController.heightSelector.alpha = 0
          originViewController.weightSelector.alpha = 0
          originViewController.pageTitle.alpha = 0
        }
        
        UIView.addKeyframe(withRelativeStartTime: 1.5/25, relativeDuration: 2/25) {
          originViewController.pacmanWidthConstraint.constant = 60
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
        transitionContext.completeTransition(true)
    })
  }
}
