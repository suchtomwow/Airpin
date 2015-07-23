//
//  BLSTableView.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class BLSTableView: UITableView {
  override func awakeFromNib() {
    super.awakeFromNib()
    
    separatorStyle     = .None
    estimatedRowHeight = 50.0
    rowHeight          = UITableViewAutomaticDimension
  }
}
