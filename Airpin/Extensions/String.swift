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
        let characterSet = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: characterSet)
    }
    
    func condense() -> String {
        let noNewLines = replacingOccurrences(of: "\n", with: " ")
        
        let pattern = "^\\s+|\\s+$|\\s+(?=\\s)"
        let trimmed = noNewLines.replacingOccurrences(of: pattern, with: " ", options: .regularExpression)
        
        return trimmed
    }
    
    func title(alignment: NSTextAlignment, color: UIColor = UIColor.primaryTextColor()) -> AttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.title1().bold, color: color)
    }
    
    func headline(alignment: NSTextAlignment, color: UIColor = UIColor.primaryTextColor()) -> AttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.headline().medium, color: color)
    }
    
    func subheadline(alignment: NSTextAlignment) -> AttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.subheadline(), color: UIColor.secondaryTextColor())
    }
    
    func body(alignment: NSTextAlignment, color: UIColor = UIColor.primaryTextColor()) -> AttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.body(), color: color)
    }
    
    func footnote(alignment: NSTextAlignment) -> AttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.footnote(), color: UIColor.primaryTextColor())
    }
    
    func caption(alignment: NSTextAlignment, color: UIColor = UIColor.primaryTextColor()) -> AttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.caption1().ultraLight, color: UIColor.secondaryTextColor())
    }
    
    func tag(alignment: NSTextAlignment) -> AttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.caption1(), color: UIColor.white())
    }
    
    func primaryButton(color: UIColor = UIColor.white()) -> AttributedString {
        return attributedStringWithAlignment(.center, font: UIFont.callout().heavy, color: color)
    }
    
    func secondaryButton() -> AttributedString {
        return attributedStringWithAlignment(.center, font: UIFont.callout().medium, color: UIColor.white())
    }
    
    private func attributedStringWithAlignment(_ alignment: NSTextAlignment, font: UIFont, color: UIColor) -> AttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = alignment
        
        let attributes = [NSParagraphStyleAttributeName: paragraphStyle,
                          NSFontAttributeName: font,
                          NSForegroundColorAttributeName: color]
        
        let attributedString = AttributedString(string: self, attributes: attributes)
        
        return attributedString
    }
}
