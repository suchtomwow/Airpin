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
    let title: String
    var bookmarks: Results<Bookmark>

    init(bookmarkTag: String) {
        title = bookmarkTag
        bookmarks = try! Realm().objects(Bookmark.self).filter(NSPredicate(format: "ANY tags.name == %@", bookmarkTag))
    }
}
