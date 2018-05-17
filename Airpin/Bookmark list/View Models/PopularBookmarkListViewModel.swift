//
//  PopularBookmarkListViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 5/5/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import RealmSwift

class PopularBookmarkListViewModel: BaseViewModel, BookmarkListViewModel {
    var title: String = "Popular"

    let canDeleteBookmarks: Bool = false
    let canEditBookmarks: Bool = false

    private let inMemoryConfig = Realm.Configuration.inMemoryRealmConfiguration
    private var realm: Realm
    var bookmarks: Results<Bookmark>

    init() {
        realm = try! Realm(configuration: inMemoryConfig)
        bookmarks = realm.objects(Bookmark.self)
    }

    func fetchBookmarks(dataProvider: BookmarkDataProviding, completion: (() -> Void)?) {
        dataProvider.fetchPopularBookmarks()
    }

    func toggleReadState(at index: Int, dataProvider: BookmarkDataProviding) {
        let bookmark = bookmarks[index]

        do {
            try Realm(configuration: inMemoryConfig).write {
                bookmark.toRead = !bookmark.toRead
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}
