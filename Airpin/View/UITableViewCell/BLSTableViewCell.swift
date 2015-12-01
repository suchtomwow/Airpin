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
    self.addSubview(separator)
    return separator
  }()
  
  class var ReuseIdentifier: String {
    return "BLSTableViewCell"
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    commonInit()
  }
  
  func commonInit() {
    configureView()
    configureConstraints()
    configureStyles()
  }
  
  func configureView() { }
  
  func configureConstraints() {
    NSLayoutConstraint(item: separator, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
    
    let separatorHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[separator]-0-|", options: [], metrics: nil, views: ["separator": separator])
    NSLayoutConstraint.activateConstraints(separatorHorizontal)
    
    NSLayoutConstraint(item: separator, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.5).active = true
  }
  
  func configureStyles() {
    selectionStyle = .None
    separator.backgroundColor = UIColor.tableViewCellSeparator()
  }
}