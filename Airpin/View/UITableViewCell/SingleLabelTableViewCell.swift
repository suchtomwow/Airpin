//
//  SingleLabelTableViewCell.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class SingleLabelTableViewCell: BLSTableViewCell {
  
  lazy var headline: UILabel = {
    let label = UILabel()
    
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)
    
    return label
  }()
  
  lazy var disclosure: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(imageView)
    
    return imageView
  }()
  
  override func configureConstraints() {
    super.configureConstraints()
    
    headline.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 20).active = true
    headline.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -20).active = true
    headline.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: 20).active = true
    headline.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: -20).active = true
    
    disclosure.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: -12).active = true
    disclosure.centerYAnchor.constraintEqualToAnchor(headline.centerYAnchor).active = true
    disclosure.widthAnchor.constraintEqualToConstant(8).active = true
    disclosure.heightAnchor.constraintEqualToConstant(13).active = true
  }
  
  override func configureStyles() {
    super.configureStyles()
    
    headline.font      = UIFont.headline.medium
    headline.textColor = UIColor.primaryTextColor()
    
    disclosure.tintColor = UIColor.tableViewAccent()
    disclosure.image = Icon.Disclosure.image
  }
}
