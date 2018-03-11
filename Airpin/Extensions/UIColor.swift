//
//  UIColor.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    
    // MARK: - Text -
    
    class var primaryText: UIColor {
        return UIColor(hex: 0x4F4F5A)
    }
    
    class var secondaryText: UIColor {
        return UIColor(hex: 0x929292)
    }
    
    class var tertiaryText: UIColor {
        return UIColor(hex: 0x979797)
    }
    
    class var tableViewAccent: UIColor {
        return UIColor(hex: 0xEDF0F4)
    }
    
    class var primary: UIColor {
        return UIColor(hex: 0x444444)
    }
    
    class var complementary: UIColor {
        return UIColor(hex: 0xFF7C36)
    }
    
    class var lightGrey: UIColor {
        return UIColor(hex: 0xF6F6F7)
    }
    
    class var blueRowAction: UIColor {
        return UIColor(hex: 0x6283A6)
    }
}
