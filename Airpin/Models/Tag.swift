//
//  Tag.swift
//  Airpin
//
//  Created by Thomas Carey on 3/9/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import RealmSwift

class Tag: Object {
    override static func primaryKey() -> String? {
        return "name"
    }
    
    @objc dynamic var name: String = ""
}
