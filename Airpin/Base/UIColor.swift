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
  
  class func primaryTextColor() -> UIColor {
    return UIColor(hex: 0x4F4F5A)
  }
  
  class func secondaryTextColor() -> UIColor {
    return UIColor(hex: 0x929292)
  }
  
  class func tertiaryTextColor() -> UIColor {
    return UIColor(hex: 0x979797)
  }
  
  class func tableViewAccent() -> UIColor {
    return UIColor(hex: 0xEDF0F4)
  }
  
  class func tintColor() -> UIColor {
    return UIColor(hex: 0x2FE0AC)
  }
  
  class func lightGrey() -> UIColor {
    return UIColor(hex: 0xF6F6F7)
  }
}