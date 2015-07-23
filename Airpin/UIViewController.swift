//
//  UIViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

extension UIViewController {
  func prepareForConstraints() {
    view.removeConstraints(view.constraints)
    (view.subviews as [UIView]).map { $0.removeConstraints($0.constraints) }
    view.constraintsAffectingLayoutForAxis(.Horizontal)
  }
}
