//
//  PrivateBookmarksViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 3/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import RealmSwift

class PrivateBookmarksListViewModel: BaseViewModel, BookmarkListViewModel {
    var bookmarks: [Bookmark] = []
    let title: String = "Private"
    let filter: ((Bookmark) -> Bool)? = { bookmark in !bookmark.shared}
}
