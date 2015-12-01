//
//  String.swift
//  Airpin
//
//  Created by Thomas Carey on 11/1/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

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
}