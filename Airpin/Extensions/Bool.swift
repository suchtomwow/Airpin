//
//  Bool.swift
//  Airpin
//
//  Created by Thomas Carey on 7/21/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

extension Bool {
    init(string: String) {
        assert(string == "yes" || string == "no", "Bool(string:) accepts \"yes\" or \"no\" arguments.")
        
        if string == "yes" {
            self = true
        } else {
            self = false
        }
    }
}
