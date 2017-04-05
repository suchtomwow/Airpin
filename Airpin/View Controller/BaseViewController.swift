//
//  BaseViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var adjustableConstraintForKeyboardAppearance: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureStyles()
        configureObservers()
    }
    
    func configureView() {
        
    }
    
    func configureStyles() {
        
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillChangeAppearance(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillChangeAppearance(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

// MARK: - Keyboard observers -

extension BaseViewController {
    func keyboardWillChangeAppearance(notification: Notification) {
        guard let constraint = adjustableConstraintForKeyboardAppearance else { return }
        
        if let userInfo = notification.userInfo,
            let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  {
            
            let keyboardHeight = endFrame.height
            
            if endFrame.minY == UIScreen.main.bounds.maxY {
                constraint.constant = 0
            } else {
                constraint.constant = keyboardHeight
            }
            
            let curve = UIViewAnimationOptions(rawValue: UInt((animationCurve).intValue << 16))
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [curve], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
