//
//  Constant.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

enum UserDefault: String {
    case updateTime = "com.bls.airpin.updateTime"
    case hasDismissedTokenPrompt = "com.bls.airpin.hasDismissedTokenPrompt"
    case pinboardUsername = "com.bls.pinboardUsername"
}

enum Segue: String {
    case bookmarkViewController
    case tokenEntryViewController
}

var DefaultInset: Double {
    return 15.0
}

func ==(lhs: UIStoryboardSegue, rhs: Segue) -> Bool {
    return lhs.identifier! == rhs.rawValue
}
