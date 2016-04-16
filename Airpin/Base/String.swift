//
//  String.swift
//  Airpin
//
//  Created by Thomas Carey on 11/1/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit
import Foundation

extension String {
  func trim() -> String {
    let characterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
    return self.stringByTrimmingCharactersInSet(characterSet)
  }
  
  func condense() -> String {
    let noNewLines = stringByReplacingOccurrencesOfString("\n", withString: " ")
    
    let pattern = "^\\s+|\\s+$|\\s+(?=\\s)"
    let trimmed = noNewLines.stringByReplacingOccurrencesOfString(pattern, withString: " ", options: .RegularExpressionSearch)
    
    return trimmed
  }
  
  func headline(alignment alignment: NSTextAlignment) -> NSAttributedString {
    return attributedStringWithAlignment(alignment, font: UIFont.headline().medium, color: UIColor.primaryTextColor())
  }
  
  func subheadline(alignment alignment: NSTextAlignment) -> NSAttributedString {
    return attributedStringWithAlignment(alignment, font: UIFont.subheadline(), color: UIColor.secondaryTextColor())
  }
  
  func body(alignment alignment: NSTextAlignment) -> NSAttributedString {
    return attributedStringWithAlignment(alignment, font: UIFont.body(), color: UIColor.primaryTextColor())
  }
  
  func footnote(alignment alignment: NSTextAlignment) -> NSAttributedString {
    return attributedStringWithAlignment(alignment, font: UIFont.footnote(), color: UIColor.primaryTextColor())
  }
  
  func caption(alignment alignment: NSTextAlignment, color: UIColor = UIColor.primaryTextColor()) -> NSAttributedString {
    return attributedStringWithAlignment(alignment, font: UIFont.caption1().ultraLight, color: UIColor.secondaryTextColor())
  }
  
  func tag(alignment alignment: NSTextAlignment) -> NSAttributedString {
    return attributedStringWithAlignment(alignment, font: UIFont.caption1(), color: UIColor.whiteColor())
  }
  
  func primaryButton() -> NSAttributedString {
    return attributedStringWithAlignment(.Center, font: UIFont.callout().heavy, color: UIColor.whiteColor())
  }
  
  func secondaryButton() -> NSAttributedString {
    return attributedStringWithAlignment(.Center, font: UIFont.callout().medium, color: UIColor.secondaryTextColor())
  }
  
  private func attributedStringWithAlignment(alignment: NSTextAlignment, font: UIFont, color: UIColor) -> NSAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 2
    paragraphStyle.alignment = alignment
    
    let attributes = [NSParagraphStyleAttributeName: paragraphStyle,
                      NSFontAttributeName: font,
                      NSForegroundColorAttributeName: color]
    
    let attributedString = NSAttributedString(string: self, attributes: attributes)
    
    return attributedString
  }
}