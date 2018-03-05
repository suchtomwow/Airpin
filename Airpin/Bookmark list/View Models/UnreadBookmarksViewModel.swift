//
//  UnreadBookmarksViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 3/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

class UnreadBookmarksListViewModel: BaseViewModel, BookmarkListViewModel {
    var bookmarks: [Bookmark] = []
    let title: String = "Unread"
    let filter: ((Bookmark) -> Bool)? = { bookmark in bookmark.toRead }
}
