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
    return UIColor(hex: 0x333333)
  }
  
  class func secondaryTextColor() -> UIColor {
    return UIColor(hex: 0xAAAAAA)
  }
  
  class func tableViewCellSeparator() -> UIColor {
    return UIColor(hex: 0xC8C8C8)
  }
  
  class func tintColor() -> UIColor {
    return UIColor(hex: 0x55E18F)
  }
}