//
//  BookmarkDetailsViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 11/28/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift

typealias BookmarkTag = String

class BookmarkDetailsViewModel: BaseViewModel {
    
    enum Mode {
        case create, edit(Bookmark)
    }
    
    var addButtonTitle: String {
        switch mode {
        case .edit:
            return "Edit"
        case .create:
            return "Add"
        }
    }
    let tagsDirections = "Separate tags with spaces"
    
    let mode: Mode
    
    var url: URL?
    var bookmarkTitle: String?
    var extended: String?
    var makePrivate = true
    var readLater = true
    var tags = List<Tag>()
    
    var title: String {
        if case .create = mode {
            return "Add bookmark"
        } else {
            return "Edit bookmark"
        }
    }
    
    init(mode: Mode) {
        self.mode = mode

        if case .edit(let bookmark) = mode {
            self.url = bookmark.url
            self.bookmarkTitle = bookmark.title
            self.extended = bookmark.extended
            self.makePrivate = !bookmark.shared
            self.readLater = bookmark.toRead
            self.tags = bookmark.tags
        }
    }
    
    func addBookmark(completion: @escaping (Result<Bookmark>) -> ()) {
        guard let url = url else { return }
        
        let bookmark = Bookmark()
        bookmark.url = url
        bookmark.title = bookmarkTitle ?? url.absoluteString
        bookmark.extended = extended ?? ""
        bookmark.shared = !makePrivate
        bookmark.toRead = readLater
        tags.forEach { bookmark.tags.append($0) }

        let dp = PinboardDataProvider()
        
        dp.add(bookmark) { result, username in
            switch result {
            case .success:
                DispatchQueue.global(qos: .default).async {
                    bookmark.user = username ?? ""

                    bookmark.persist(in: .defaultConfiguration)

                    DispatchQueue.main.async {
                        completion(Result.success(bookmark))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }
}
