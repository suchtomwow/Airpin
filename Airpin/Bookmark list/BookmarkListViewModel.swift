//
//  BookmarkViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 10/10/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class BookmarkListViewModel: BaseViewModel {
    
    let category: CategoryViewModel.Category
    
    var bookmarks: [Bookmark]?
    
    let dataProvider = PinboardDataProvider()
    
    var title: String {
        return category.description
    }
    
    init(category: CategoryViewModel.Category) {
        self.category = category
    }
    
    func fetchBookmarks(completion: @escaping () -> Void) {
        switch category {
        case .all:
            fetchAllBookmarks(completion: completion)
        case .unread:
            fetchUnreadBookmarks(completion: completion)
        case .untagged:
            fetchUntaggedBookmarks(completion: completion)
        case .public:
            fetchPublicBookmarks(completion: completion)
        case .private:
            fetchPrivateBookmarks(completion: completion)
        }
    }
    
    private func fetchBookmarks(filter: ((_ bookmark: Bookmark) -> Bool)?, completion: @escaping () -> Void) {
        dataProvider.fetchAllBookmarks {
            DispatchQueue.main.async {
                // Need to map these to a regular [Bookmark] because the default value is Results<Bookmark>, which is auto-updating.
                // Because it is auto-updating, rows are removed from the tableView when I still want to be able to display them to the user.
                var bookmarks = try! Realm().objects(Bookmark.self).map { $0 } as [Bookmark]
                
                if let filter = filter {
                    
                    bookmarks = bookmarks.filter(filter)
                }
                
                self.bookmarks = bookmarks
                completion()
            }
        }
    }
    
    private func fetchAllBookmarks(completion: @escaping () -> Void) {
        fetchBookmarks(filter: nil, completion: completion)
    }
    
    private func fetchUnreadBookmarks(completion: @escaping () -> Void) {
        fetchBookmarks(filter: { $0.toRead }, completion: completion)
    }
    
    private func fetchUntaggedBookmarks(completion: @escaping () -> Void) {
        fetchBookmarks(filter: { $0.tags.count == 0 }, completion: completion)
    }
    
    private func fetchPublicBookmarks(completion: @escaping () -> Void) {
        fetchBookmarks(filter: { $0.shared }, completion: completion)
    }
    
    private func fetchPrivateBookmarks(completion: @escaping () -> Void) {
        fetchBookmarks(filter: { !$0.shared }, completion: completion)
    }
    
    func toggleReadState(at index: Int) {
        dataProvider.toggleReadState(bookmark: bookmarks![index])
    }
    
    func delete(at index: Int) {
        dataProvider.delete(bookmark: bookmarks![index])
    }
}