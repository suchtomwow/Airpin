//
//  BookmarksDataProvider.swift
//  Airpin
//
//  Created by Thomas Carey on 4/17/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import RealmSwift

protocol BookmarkDataProviding: class {
    func updateFromNetworkIfNecessary(completion: (() -> Void)?)
    func fetchPopularBookmarks()
    func toggleReadState(bookmark: Bookmark, realmConfiguration: Realm.Configuration)
    func delete(bookmark: Bookmark)
}

class PinboardDataProvider: BookmarkDataProviding {
    private let networkOperations = PinboardNetworkOperations()
    private let diskOperations = PinboardDiskOperations()
    
    func updateFromNetworkIfNecessary(completion: (() -> Void)?) {
        networkOperations.getLastUpdated { [weak self] lastUpdatedNetwork in
            guard let lastUpdatedDisk = self?.diskOperations.lastUpdated else {
                self?.fetchAllBookmarksFromNetwork(andStore: lastUpdatedNetwork, completion: completion)
                return
            }

            if lastUpdatedDisk != lastUpdatedNetwork {
                self?.fetchAllBookmarksFromNetwork(andStore: lastUpdatedNetwork, completion: completion)
            }
        }
    }

    func fetchPopularBookmarks() {
        networkOperations.fetchPopularBookmarks(completion: nil)
    }
    
    private func fetchAllBookmarksFromNetwork(andStore lastUpdatedTime: Date, completion: (() -> Void)?) {
        networkOperations.fetchAllBookmarks { [weak self] in
            self?.diskOperations.lastUpdated = lastUpdatedTime
            completion?()
        }
    }
    
    func toggleReadState(bookmark: Bookmark, realmConfiguration: Realm.Configuration) {
        networkOperations.toggleReadState(toRead: !bookmark.toRead, for: bookmark, completion: nil)
        
        do {
            try Realm(configuration: realmConfiguration).write {
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
    
    func add(_ bookmark: Bookmark, completion: @escaping (Result<Bool>, _ username: String?) -> ()) {
        let url = bookmark.url
        let title = bookmark.title
        let extended = bookmark.extended
        let isPrivate = !bookmark.shared
        let toRead = bookmark.toRead
        let tags = bookmark.tags.reduce("") { $0 + "+" + $1.name }

        networkOperations.addBookmark(with: url, title: title, extended: extended, isPrivate: isPrivate, toRead: toRead, tags: tags, completion: completion)
    }
}
