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

    var hasLink: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            return detector.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count)) > 0
        } catch {
            return false
        }
    }

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
    
    func title(alignment: NSTextAlignment, color: UIColor = .primaryText) -> NSAttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.title1().bold, color: color)
    }
    
    func headline(alignment: NSTextAlignment, color: UIColor = .primaryText) -> NSAttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.headline().medium, color: color)
    }
    
    func subheadline(alignment: NSTextAlignment) -> NSAttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.subheadline(), color: .secondaryText)
    }
    
    func body(alignment: NSTextAlignment, color: UIColor = .primaryText) -> NSAttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.body(), color: color)
    }
    
    func footnote(alignment: NSTextAlignment) -> NSAttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.footnote(), color: .primaryText)
    }
    
    func caption(alignment: NSTextAlignment, color: UIColor = .primaryText) -> NSAttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.caption1().ultraLight, color: .secondaryText)
    }
    
    func tag(alignment: NSTextAlignment) -> NSAttributedString {
        return attributedStringWithAlignment(alignment, font: UIFont.caption1(), color: .white)
    }
    
    func primaryButton(color: UIColor = .white) -> NSAttributedString {
        return attributedStringWithAlignment(.center, font: UIFont.callout().heavy, color: color)
    }
    
    func secondaryButton() -> NSAttributedString {
        return attributedStringWithAlignment(.center, font: UIFont.callout().medium, color: .white)
    }
    
    private func attributedStringWithAlignment(_ alignment: NSTextAlignment, font: UIFont, color: UIColor) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedStringKey: AnyObject] = [.paragraphStyle: paragraphStyle,
                                                              .font: font,
                                                              .foregroundColor: color]
        
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        
        return attributedString
    }
}
