//
//  TagBookmarkListViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 3/5/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import RealmSwift
import Foundation

class TagBookmarksViewModel: BaseViewModel, BookmarkListViewModel {
    let bookmarkTag: String
    let title: String
    var bookmarks: Results<Bookmark>

    init(bookmarkTag: String) {
        self.bookmarkTag = bookmarkTag
        self.title = bookmarkTag
        self.bookmarks = try! Realm().objects(Bookmark.self).filter(NSPredicate(format: "tags CONTAINS %@", bookmarkTag)).sorted(byKeyPath: "datetime", ascending: false)
    }
}
