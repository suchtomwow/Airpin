//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation
import UIKit

class CategoryPresentationAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    var finishedTransitioning: ((_ toViewTrailingToContainerLeading: NSLayoutConstraint, _ toViewLeadingToContainerLeading: NSLayoutConstraint) -> Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to), let fromVC = transitionContext.viewController(forKey: .from) else { return }

        let containerView = transitionContext.containerView

        let toView: UIView = toVC.view
        let fromView: UIView = fromVC.view
        let fromSnapshot = fromView.snapshotView(afterScreenUpdates: false)!
        let snapshotOverlay = configureSnapshotOverlay()

        let tgr = UITapGestureRecognizer(target: toVC, action: #selector(CategoryViewController.tappedOutsideTransition))
        snapshotOverlay.addGestureRecognizer(tgr)

        toView.translatesAutoresizingMaskIntoConstraints = false
        fromSnapshot.translatesAutoresizingMaskIntoConstraints = false
        snapshotOverlay.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(fromSnapshot)
        containerView.addSubview(snapshotOverlay)
        containerView.addSubview(toView)

        let toViewTrailingToContainerLeading = toView.trailingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let toViewLeadingToContainerLeading = toView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)

        NSLayoutConstraint.activate(
            [fromSnapshot.topAnchor.constraint(equalTo: toView.topAnchor),
             fromSnapshot.leadingAnchor.constraint(equalTo: toView.trailingAnchor),
             fromSnapshot.heightAnchor.constraint(equalTo: fromView.heightAnchor),
             fromSnapshot.widthAnchor.constraint(equalTo: fromView.widthAnchor),
             snapshotOverlay.topAnchor.constraint(equalTo: fromSnapshot.topAnchor),
             snapshotOverlay.leadingAnchor.constraint(equalTo: fromSnapshot.leadingAnchor),
             snapshotOverlay.bottomAnchor.constraint(equalTo: fromSnapshot.bottomAnchor),
             snapshotOverlay.trailingAnchor.constraint(equalTo: fromSnapshot.trailingAnchor),
             toViewTrailingToContainerLeading,
             toView.topAnchor.constraint(equalTo: containerView.topAnchor),
             toView.heightAnchor.constraint(equalTo: fromView.heightAnchor),
             toView.widthAnchor.constraint(equalTo: fromView.widthAnchor, multiplier: 0.6)]
        )

        containerView.layoutIfNeeded()

        toViewTrailingToContainerLeading.isActive = false
        toViewLeadingToContainerLeading.isActive = true

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, animations: {
            containerView.layoutIfNeeded()
            snapshotOverlay.alpha = 0.5
        }, completion: { complete in
            self.finishedTransitioning?(toViewTrailingToContainerLeading, toViewLeadingToContainerLeading)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    private func configureSnapshotOverlay() -> UIView {
        let view = UIView()
        view.alpha = 0.0
        view.backgroundColor = .darkGray
        return view
    }
}
