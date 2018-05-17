//
//  Created by Thomas Carey on 5/16/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import RealmSwift

extension Realm.Configuration {
    static let inMemoryRealmConfiguration: Realm.Configuration = Realm.Configuration(inMemoryIdentifier: "InMemoryRealm")
}
