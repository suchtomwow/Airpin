//
//  BLSTableView.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

protocol BLSTableViewDataSource {
    var Identifier: String { get }
}

class BLSTableView: UITableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorStyle     = .none
        rowHeight          = UITableViewAutomaticDimension
        estimatedRowHeight = 100.0
    }
}
