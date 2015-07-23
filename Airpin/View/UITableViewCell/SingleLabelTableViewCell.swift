//
//  SingleLabelTableViewCell.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class SingleLabelTableViewCell: BLSTableViewCell {

  @IBOutlet weak var key: UILabel!
  
  override func configureStyles() {
    super.configureStyles()
    
    key.font      = UIFont.h1()
    key.textColor = UIColor.primaryTextColor()
  }
}
