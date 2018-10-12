//
//  MainVCToAddDataVCTransition.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 20/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class MainVCToAddDataVCTransition: NSObject {
  fileprivate func prepare(_ viewController: MainViewController) {
    viewController.view.subviews.forEach({ (view) in
      if view == viewController.reloadButton {
        guard let reloadButton = view as? CustomButton else { return }
        reloadButton.imageView?.isHidden = true
      } else {
        view.alpha = 0
      }
    })
  }
  
  fileprivate func reset(_ viewController: MainViewController) {
    viewController.view.backgroundColor = .lightGrey
    viewController.view.subviews.forEach({ (view) in
      if view == viewController.reloadButton {
        guard let reloadButton = view as? CustomButton else { return }
        reloadButton.imageView?.isHidden = false
        reloadButton.backgroundColor = .clear
        reloadButton.transform = CGAffineTransform(scaleX: 1, y: 1)
      } else {
        view.alpha = 1
      }
    })
  }
}

extension MainVCToAddDataVCTransition: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.75
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let originViewController = transitionContext.viewController(forKey: .from) as? MainViewController else { return }
    guard let toViewController = transitionContext.viewController(forKey: .to) as? AddDataViewController else { return }
    
    let containerView = transitionContext.containerView
    
    containerView.addSubview(toViewController.view)
    toViewController.view.isHidden = false
    toViewController.view.transform = CGAffineTransform(translationX: 0, y: toViewController.view.frame.height)
    toViewController.weightSelector.weightNumbers.alpha = 0
    toViewController.weightSelector.transform = CGAffineTransform(translationX: 0, y: 10)
    toViewController.heightSelector.transform = CGAffineTransform(translationX: 0, y: 10)
    toViewController.genderSelector.transform = CGAffineTransform(translationX: 0, y: 10)
    
    let duration = transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: .beginFromCurrentState,
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/10) {
          self.prepare(originViewController)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/4) {
          originViewController.reloadButton.backgroundColor = .lightGrey
          originViewController.view.backgroundColor = UIColor.mateGreen
        }
        
        UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/4) {
          originViewController.reloadButton.transform = CGAffineTransform(scaleX: 25, y: 25)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 2.3/3, relativeDuration: 4/4) {
          toViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    },
      completion: { _ in
        toViewController.weightSelector.flowLayout.itemSize = CGSize(
          width: toViewController.weightSelector.weightImageBackgroundView.frame.width/3,
          height: toViewController.weightSelector.weightImageBackgroundView.frame.height
        )
        
        self.reset(originViewController)
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        
        UIView.animate(withDuration: 0.2, animations: {
          toViewController.weightSelector.weightNumbers.alpha = 1
        })
    })
  }
}
