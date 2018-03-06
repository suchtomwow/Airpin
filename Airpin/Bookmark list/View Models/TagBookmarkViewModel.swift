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
    var bookmarks: [Bookmark] = []
    let filter: ((Bookmark) -> Bool)?

    init(bookmarkTag: String) {
        self.bookmarkTag = bookmarkTag
        self.title = bookmarkTag

        filter = { bookmark in
            bookmark.tags.contains(bookmarkTag)
        }
    }
}
