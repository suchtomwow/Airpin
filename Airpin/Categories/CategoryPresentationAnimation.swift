//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation
import UIKit

class CategoryPresentationAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to), let fromVC = transitionContext.viewController(forKey: .from) else { return }

        let containerView = transitionContext.containerView

        let toView: UIView = toVC.view
        let fromView: UIView = fromVC.view
        containerView.addSubview(toView)

        NSLayoutConstraint.activate([
            toView.topAnchor.constraint(equalTo: containerView.topAnchor),
            toView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            toView.trailingAnchor.constraint(equalTo: fromView.leadingAnchor),
            toView.widthAnchor.constraint(equalTo: fromView.widthAnchor, multiplier: 0.7)
        ])

        
    }
}
