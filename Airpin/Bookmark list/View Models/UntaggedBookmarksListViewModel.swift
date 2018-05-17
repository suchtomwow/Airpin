//
//  UntaggedBookmarksListViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 3/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift

class UntaggedBookmarksListViewModel: BaseViewModel, BookmarkListViewModel {
    var bookmarks: Results<Bookmark> = try! Realm().objects(Bookmark.self).filter(NSPredicate(format: "tags.@count == 0")).sorted(byKeyPath: "datetime", ascending: false)
    let title: String = "Untagged"
}