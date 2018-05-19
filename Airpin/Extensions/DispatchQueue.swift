//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static let realmQueue = DispatchQueue.init(label: "com.airpin.realm", qos: .default)
}
