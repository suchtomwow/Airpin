//
//  BLSTableView.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class BLSTextField: UITextField {
  
  let infoButton = UIButton()
  let actionButton = UIButton()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configureView()
    configureConstraints()
    configureStyles()
  }
  
  func configureView() {
    infoButton.translatesAutoresizingMaskIntoConstraints = false
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(infoButton)
    addSubview(actionButton)
  }
  
  func configureConstraints() {
    actionButton.constrainToSuperview(.Right)
    actionButton.centerWithSuperview(alongAxis: .Vertical)
  }
  
  func configureStyles() {
    
  }
}
