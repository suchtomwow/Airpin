//
//  UnreadBookmarksViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 3/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import RealmSwift

class UnreadBookmarksListViewModel: BaseViewModel, BookmarkListViewModel {
    var bookmarks: Results<Bookmark> = try! Realm().objects(Bookmark.self).filter(NSPredicate(format: "toRead == true")).sorted(byKeyPath: "datetime", ascending: false)
    let title: String = "Unread"
}
