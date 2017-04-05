//
//  URL.swift
//  Airpin
//
//  Created by Thomas Carey on 1/6/17.
//  Copyright © 2017 Thomas Carey. All rights reserved.
//

import Foundation

extension URL {
    var isLink: Bool {
        do {
            let string = absoluteString
            let checkingRange = NSRange(location: 0, length: string.characters.count)

            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let rangeOfFirstMatch = detector.rangeOfFirstMatch(in: string, options: [], range: checkingRange)

            return rangeOfFirstMatch.location == checkingRange.location &&
                    rangeOfFirstMatch.length == checkingRange.length
        } catch {
            return false
        }
    }
}
