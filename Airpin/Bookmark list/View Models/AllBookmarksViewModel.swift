//
//  AllBookmarksViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 3/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

class AllBookmarksListViewModel: BaseViewModel, BookmarkListViewModel {
    var bookmarks: [Bookmark] = []
    let title: String = "All"
    let filter: ((Bookmark) -> Bool)? = nil
}
