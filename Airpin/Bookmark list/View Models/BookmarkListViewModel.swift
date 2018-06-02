//
//  BookmarkListViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 10/10/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift

protocol BookmarkListViewModel: class {
    var title: String { get }
    var bookmarks: Results<Bookmark> { get }
    var canDeleteBookmarks: Bool { get }
    var canEditBookmarks: Bool { get }
    var canSelectTags: Bool { get }
    func fetchBookmarks(dataProvider: BookmarkDataProviding, completion: (() -> Void)?)
    func toggleReadState(at index: Int, dataProvider: BookmarkDataProviding)
}

extension BookmarkListViewModel {
    var canDeleteBookmarks: Bool { return true }
    var canEditBookmarks: Bool { return true }

    func fetchBookmarks(dataProvider: BookmarkDataProviding, completion: (() -> Void)?) {
        dataProvider.updateFromNetworkIfNecessary(completion: completion)
    }

    func toggleReadState(at index: Int, dataProvider: BookmarkDataProviding) {
        dataProvider.toggleReadState(bookmark: bookmarks[index], realmConfiguration: .defaultConfiguration)
    }

    func delete(at index: Int, dataProvider: BookmarkDataProviding) {
        dataProvider.delete(bookmark: bookmarks[index])
    }
}
