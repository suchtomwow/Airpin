//
//  BLSTableViewCell.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class BLSTableViewCell: UITableViewCell {
  
  let separator = UIView(frame: CGRectZero)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configureView()
    configureConstraints()
    configureStyles()
  }
  
  func configureView() {
    addSubview(separator)
    separator.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureConstraints() {
    contentView.removeConstraints(contentView.constraints)
    removeConstraints(constraints)
    
    separator.constrainToSuperview(.Bottom)
    separator.pinToSuperview(inset: 0.0, axis: .Horizontal)
    separator.addSize(0.5, axis: .Vertical)
  }
  
  func configureStyles() {
    separator.backgroundColor = UIColor.tableViewCellSeparator()
  }
}
