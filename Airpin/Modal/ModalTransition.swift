//
//  ModalTransitioningDelegate.swift
//  Airpin
//
//  Created by Thomas Carey on 7/20/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import UIKit

private let DefaultModalTransitionDuration = 0.33

class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalTransitionPresentAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalTransitionDismissAnimation()
    }
}

class ModalTransitionPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return DefaultModalTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to) else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        
        toView.translatesAutoresizingMaskIntoConstraints = false
        
        let hiddenConstraint = toView.bottomAnchor.constraint(equalTo: containerView.topAnchor)
        NSLayoutConstraint.activate([
            toView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            toView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            toView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            toView.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor, constant: -45),
            hiddenConstraint
        ])
        
        let overlay = configureOverlay()
        let tgr = UITapGestureRecognizer(target: toVC, action: #selector(AlertController.dismissAlert))
        overlay.addGestureRecognizer(tgr)
        
        containerView.insertSubview(overlay, belowSubview: toView)
        
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: containerView.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overlay.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            overlay.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        let shownConstraint = toView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -15)
        
        containerView.layoutIfNeeded()

        hiddenConstraint.isActive = false
        shownConstraint.isActive = true

        UIView.animate(withDuration: DefaultModalTransitionDuration, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 5, options: [], animations: {
            containerView.layoutIfNeeded()
            overlay.alpha = 0.45
        }, completion: { complete in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    final private func configureOverlay() -> UIView {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .black
        overlay.alpha = 0.0
        
        return overlay
    }
}

class ModalTransitionDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return DefaultModalTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                return
        }

        let containerView = transitionContext.containerView

        let overlay = containerView.subviews.filter { $0 != fromView }.first
        let constraint = fromView.constraintsAffectingLayout(for: UILayoutConstraintAxis.vertical).filter { $0.firstAttribute == .centerY }.first
        
        constraint?.isActive = false
        fromView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        UIView.animate(withDuration: DefaultModalTransitionDuration, delay: 0.0, usingSpringWithDamping: 0.85, initialSpringVelocity: 5, options: [], animations: {
            containerView.layoutIfNeeded()
            overlay?.alpha = 0.0
        }, completion: { complete in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
