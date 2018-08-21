//
//  MainVCToAddDataVCTransition.swift
//  bodymass
//
//  Created by Josep Bordes Jové on 20/8/18.
//  Copyright © 2018 Josep Bordes Jové. All rights reserved.
//

import UIKit

class MainVCToAddDataVCTransition: NSObject, UIViewControllerAnimatedTransitioning {
  private let originFrame: CGRect
  
  init(originFrame: CGRect) {
    self.originFrame = originFrame
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1.25
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let originViewController = transitionContext.viewController(forKey: .from) as? MainViewController else { return }
    guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
    guard let snapshot = toViewController.view.snapshotView(afterScreenUpdates: true) else { return }
    
    let containerView = transitionContext.containerView
    let finalFrame = transitionContext.finalFrame(for: toViewController)
    
    snapshot.frame = originFrame
    snapshot.layer.cornerRadius = 100
    snapshot.layer.masksToBounds = true
    
    containerView.addSubview(toViewController.view)
    containerView.addSubview(snapshot)
    toViewController.view.isHidden = false
    toViewController.view.transform = CGAffineTransform(translationX: 0, y: toViewController.view.frame.height)
    
    AnimationHelper.perspectiveTransform(for: containerView)
    snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
    
    let duration = transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: .calculationModeCubic,
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/10) {
          originViewController.pageTitle.alpha = 0
          originViewController.imcSummary.alpha = 0
          originViewController.balanceImage.alpha = 0
          originViewController.bmiRecommendation.alpha = 0
          originViewController.bmiRecommendationDescription.alpha = 0
          originViewController.trashButton.alpha = 0
          originViewController.shareButton.alpha = 0
          originViewController.profileButton.alpha = 0
          originViewController.historyButton.alpha = 0
          originViewController.homeButton.alpha = 0
          originViewController.reloadButton.imageView?.isHidden = true
          originViewController.reloadButton.backgroundColor = .lightGrey
        }
        
        UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/10) {
          originViewController.view.backgroundColor = UIColor.mateGreen
        }
        
        UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 3/10) {
          originViewController.reloadButton.transform = CGAffineTransform(scaleX: 25, y: 25)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 2/10) {
          toViewController.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }

        UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/10) {
          snapshot.frame = finalFrame
        }
    },
      completion: { _ in
        originViewController.pageTitle.alpha = 1
        originViewController.imcSummary.alpha = 1
        originViewController.balanceImage.alpha = 1
        originViewController.bmiRecommendation.alpha = 1
        originViewController.bmiRecommendationDescription.alpha = 1
        originViewController.trashButton.alpha = 1
        originViewController.shareButton.alpha = 1
        originViewController.profileButton.alpha = 1
        originViewController.historyButton.alpha = 1
        originViewController.homeButton.alpha = 1
        originViewController.reloadButton.imageView?.isHidden = false
        originViewController.reloadButton.backgroundColor = .clear
        originViewController.reloadButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        originViewController.view.backgroundColor = .white
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
