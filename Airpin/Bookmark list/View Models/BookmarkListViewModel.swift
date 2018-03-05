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
    var bookmarks: [Bookmark] { get set }
    var title: String { get }
    var filter: ((Bookmark) -> Bool)? { get }
}

extension BookmarkListViewModel {
    func fetchBookmarks(dataProvider: BookmarkDataProviding, completion: @escaping () -> Void) {
        dataProvider.fetchAllBookmarks { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.bookmarks = (try! Realm().objects(Bookmark.self)
                    .map { $0 } as [Bookmark])
                    .filter(strongSelf.filter ?? { _ in true })
                completion()
            }
        }
    }

    func toggleReadState(at index: Int, dataProvider: BookmarkDataProviding) {
        dataProvider.toggleReadState(bookmark: bookmarks[index])
    }

    func delete(at index: Int, dataProvider: BookmarkDataProviding) {
        dataProvider.delete(bookmark: bookmarks[index])
    }
}
