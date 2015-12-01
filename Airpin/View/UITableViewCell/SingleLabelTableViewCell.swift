//
//  SingleLabelTableViewCell.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class SingleLabelTableViewCell: BLSTableViewCell {
  
  override class var ReuseIdentifier: String {
    return "SingleLabelTableViewCell"
  }
  
  lazy var key: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)
    return label
  }()
  
  override func configureConstraints() {
    super.configureConstraints()
    
    NSLayoutConstraint(item: key, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .TopMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: key, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: key, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .LeftMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: key, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .RightMargin, multiplier: 1.0, constant: 0.0).active = true
  }
  
  override func configureStyles() {
    super.configureStyles()
    
    key.font      = UIFont.headline
    key.textColor = UIColor.primaryTextColor()
  }
}
