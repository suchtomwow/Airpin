//
// Created by Thomas Carey on 6/2/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

class CategoryTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var toViewTrailingToContainerLeading: NSLayoutConstraint!
    var toViewLeadingToContainerLeading: NSLayoutConstraint!

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = CategoryPresentationAnimation()

        animation.finishedTransitioning = { [unowned self] toViewTrailingToContainerLeading, toViewLeadingToContainerLeading in
            self.toViewTrailingToContainerLeading = toViewTrailingToContainerLeading
            self.toViewLeadingToContainerLeading = toViewLeadingToContainerLeading
        }

        return animation
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CategoryDismissalAnimation(toViewTrailingToContainerLeading: toViewTrailingToContainerLeading, toViewLeadingToContainerLeading: toViewLeadingToContainerLeading)
    }
}
