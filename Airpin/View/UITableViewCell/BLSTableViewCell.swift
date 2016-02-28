//
//  BLSTableViewCell.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class BLSTableViewCell: UITableViewCell {
  
  lazy var separator: UIView = {
    let separator = UIView()
    separator.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(separator)
    return separator
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    commonInit()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    commonInit()
  }
  
  func commonInit() {
    configureView()
    configureConstraints()
    configureCellSeparator()
    configureStyles()
  }
  
  func configureView() { }
  
  func configureConstraints() { }
  
  func configureCellSeparator() {
    separator.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
    separator.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
    separator.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor).active = true
    separator.heightAnchor.constraintEqualToConstant(2.0).active = true
  }
  
  func configureStyles() {
    selectionStyle            = .None
    separator.backgroundColor = UIColor.tableViewAccent()
  }
}