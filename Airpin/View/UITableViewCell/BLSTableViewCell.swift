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
        separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    
    func configureStyles() {
        selectionStyle            = .none
        separator.backgroundColor = .tableViewAccent()
    }
}
