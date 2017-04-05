//
//  CTAButton.swift
//  Airpin
//
//  Created by Thomas Carey on 12/3/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import UIKit

class CTAButton: UIButton {
    
    var title: String? {
        set {
            setAttributedTitle(newValue?.primaryButton(), for: [])
        }
        
        get {
            return attributedTitle(for: [])?.string
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    final fileprivate func commonInit() {
        backgroundColor = .complementary
    }
}
