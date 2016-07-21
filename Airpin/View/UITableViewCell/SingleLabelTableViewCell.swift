//
//  SingleLabelTableViewCell.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class SingleLabelTableViewCell: BLSTableViewCell {
    
    lazy var headline: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        
        return label
    }()
    
    lazy var disclosure: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        
        return imageView
    }()
    
    override func configureConstraints() {
        super.configureConstraints()
        
        headline.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        headline.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        headline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        headline.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        disclosure.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        disclosure.centerYAnchor.constraint(equalTo: headline.centerYAnchor).isActive = true
        disclosure.widthAnchor.constraint(equalToConstant: 8).isActive = true
        disclosure.heightAnchor.constraint(equalToConstant: 13).isActive = true
    }
    
    override func configureStyles() {
        super.configureStyles()
        
        disclosure.tintColor = .tableViewAccent()
        disclosure.image = Icon.Disclosure.image
    }
}
