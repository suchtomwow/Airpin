//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation

protocol UserDefaultsManager: class {
    func set(_ value: Any?, forKey defaultName: String)
    @discardableResult func synchronize() -> Bool
    func string(forKey defaultName: String) -> String?
}

extension UserDefaults: UserDefaultsManager {}
