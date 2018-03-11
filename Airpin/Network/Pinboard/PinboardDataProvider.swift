//
//  BookmarksDataProvider.swift
//  Airpin
//
//  Created by Thomas Carey on 4/17/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import RealmSwift

protocol BookmarkDataProviding: class {
    func updateFromNetworkIfNecessary()
    func toggleReadState(bookmark: Bookmark)
    func delete(bookmark: Bookmark)
}

class PinboardDataProvider: BookmarkDataProviding {
    private let networkOperations = PinboardNetworkOperations()
    private let diskOperations = PinboardDiskOperations()
    
    func updateFromNetworkIfNecessary() {
        networkOperations.getLastUpdated { [weak self] lastUpdatedNetwork in
            guard let lastUpdatedDisk = self?.diskOperations.lastUpdated else {
                self?.fetchAllBookmarksFromNetwork(andStore: lastUpdatedNetwork)
                return
            }

            if lastUpdatedDisk != lastUpdatedNetwork {
                self?.fetchAllBookmarksFromNetwork(andStore: lastUpdatedNetwork)
            }
        }
    }
    
    private func fetchAllBookmarksFromNetwork(andStore lastUpdatedTime: Date) {
        networkOperations.fetchAllBookmarks { [weak self] in
            self?.diskOperations.lastUpdated = lastUpdatedTime
        }
    }
    
    func toggleReadState(bookmark: Bookmark) {
        networkOperations.toggleReadState(toRead: !bookmark.toRead, for: bookmark, completion: nil)
        
        do {
            try Realm().write {
                bookmark.toRead = !bookmark.toRead
            }
        } catch {
            print(error)
        }
    }
    
    func delete(bookmark: Bookmark) {
        networkOperations.delete(with: bookmark.url)
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.delete(bookmark)
            }
        } catch {
            print(error)
        }
    }
    
    func add(_ bookmark: Bookmark, completion: @escaping (Result<Bool>) -> ()) {
        let url = bookmark.url
        let title = bookmark.title
        let description = bookmark.desc
        let isPrivate = !bookmark.shared
        let toRead = bookmark.toRead
        let tags = bookmark.tags.reduce("") { $0 + "+" + $1.name }

        networkOperations.addBookmark(with: url, title: title, description: description, isPrivate: isPrivate, toRead: toRead, tags: tags, completion: completion)
    }
}
