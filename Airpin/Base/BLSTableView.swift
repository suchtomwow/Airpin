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
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        common()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        common()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        common()
    }

    private func common() {
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 100.0
        separatorColor = .clear
    }
}
