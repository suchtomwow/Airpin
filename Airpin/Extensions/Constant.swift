//
//  Constant.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

enum UserDefault {
    static let updateTime = "com.bls.airpin.updateTime"
    static let hasDismissedTokenPrompt = "com.bls.airpin.hasDismissedTokenPrompt"
    static let pinboardUsername = "com.bls.pinboardUsername"
}

enum Segue: String {
    case bookmarkListViewController
    case tokenEntryViewController
}

var DefaultInset: Double {
    return 15.0
}

func ==(lhs: UIStoryboardSegue, rhs: Segue) -> Bool {
    return lhs.identifier! == rhs.rawValue
}
