//
//  UIView.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

extension UIView {

  func pinToSuperview(inset inset: Double) {
    pinToSuperview(inset: inset, axis: .Horizontal)
    pinToSuperview(inset: inset, axis: .Vertical)
  }
  
  func pinToSuperview(inset inset: Double, axis: UILayoutConstraintAxis) {
    let layoutAxis: String
    switch axis {
    case .Horizontal:
      layoutAxis = "H"
    case .Vertical:
      layoutAxis = "V"
    }
    
    let visualFormat = "\(layoutAxis):|-inset-[self]-inset-|"
    let metrics = ["inset": inset]
    let views = ["self": self]
    
    superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: [], metrics: metrics, views: views))
  }
  
  func constrainToSuperview(attribute: NSLayoutAttribute, multiplier: Double = 1.0, constant: Double = 0.0) {
    NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: superview!, attribute: attribute, multiplier: CGFloat(multiplier), constant: CGFloat(constant)).active = true
  }
  
  func addSize(size: Double, axis: UILayoutConstraintAxis) {
    let attribute: NSLayoutAttribute
    switch axis {
    case .Horizontal:
      attribute = .Width
    case .Vertical:
      attribute = .Height
    }
    
    NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: CGFloat(size)).active = true
  }
  
  func centerWithSuperview(alongAxis axis: UILayoutConstraintAxis) {
    guard let superview = superview else { fatalError("View must be contained in superview") }
    
    let layoutAttribute: NSLayoutAttribute
    if axis == .Horizontal {
      layoutAttribute = .CenterX
    } else {
      layoutAttribute = .CenterY
    }
    
    let constraint = NSLayoutConstraint(item: self, attribute: layoutAttribute, relatedBy: .Equal, toItem: superview, attribute: layoutAttribute, multiplier: 1.0, constant: 0.0)
    
    superview.addConstraint(constraint)
  }
}