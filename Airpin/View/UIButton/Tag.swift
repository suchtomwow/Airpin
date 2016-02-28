//
//  Tag.swift
//  Airpin
//
//  Created by Thomas Carey on 10/27/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class Tag: UIButton {
  let data: String
  
  init(data: String) {
    self.data = data
    
    super.init(frame: CGRectZero)
    
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func commonInit() {
    configureView()
    configureStyles()
  }
  
  func configureView() {
    contentEdgeInsets  = UIEdgeInsets(top: 3.0, left: 7.0, bottom: 4.0, right: 7.0)
    clipsToBounds      = true
    layer.cornerRadius = 2
    
    setTitle(data, forState: .Normal)
  }
  
  func configureStyles() {
    titleLabel?.textColor = UIColor.whiteColor()
    titleLabel?.font = UIFont.caption1
    backgroundColor = UIColor.tintColor()
  }
}