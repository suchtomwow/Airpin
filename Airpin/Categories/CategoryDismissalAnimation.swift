//
// Created by Thomas Carey on 6/2/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation
import UIKit

class CategoryDismissalAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private let toViewTrailingToContainerLeading: NSLayoutConstraint
    private let toViewLeadingToContainerLeading: NSLayoutConstraint

    init(toViewTrailingToContainerLeading: NSLayoutConstraint, toViewLeadingToContainerLeading: NSLayoutConstraint) {
        self.toViewTrailingToContainerLeading = toViewTrailingToContainerLeading
        self.toViewLeadingToContainerLeading = toViewLeadingToContainerLeading
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Making a ton of assumptions in here, but ok for now since it's very tightly coupled to the presentation animation. Also I hate working on custom animations.

        let containerView = transitionContext.containerView

        let overlayView = containerView.subviews.filter { $0.alpha < 1 }.first
        containerView.layoutIfNeeded()

        toViewLeadingToContainerLeading.isActive = false
        toViewTrailingToContainerLeading.isActive = true

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, animations: {
            overlayView?.alpha = 0.0
            containerView.layoutIfNeeded()
        }, completion: { complete in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}


