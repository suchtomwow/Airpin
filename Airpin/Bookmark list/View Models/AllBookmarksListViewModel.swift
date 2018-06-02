//
//  AllBookmarksListViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 3/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import RealmSwift

class AllBookmarksListViewModel: BaseViewModel, BookmarkListViewModel {
    var bookmarks: Results<Bookmark> = try! Realm().objects(Bookmark.self).sorted(byKeyPath: "datetime", ascending: false)
    let title: String = "All"
    let canSelectTags = true
}
