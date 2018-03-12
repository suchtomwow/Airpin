//
//  BookmarkViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 10/10/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift

protocol BookmarkListViewModel: class {
    var bookmarks: Results<Bookmark> { get }
    var title: String { get }
}

extension BookmarkListViewModel {
    func fetchBookmarks(dataProvider: BookmarkDataProviding, completion: (() -> Void)?) {
        dataProvider.updateFromNetworkIfNecessary(completion: completion)
    }

    func toggleReadState(at index: Int, dataProvider: BookmarkDataProviding) {
        dataProvider.toggleReadState(bookmark: bookmarks[index])
    }

    func delete(at index: Int, dataProvider: BookmarkDataProviding) {
        dataProvider.delete(bookmark: bookmarks[index])
    }
}
