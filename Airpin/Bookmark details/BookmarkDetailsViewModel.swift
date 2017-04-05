//
//  BookmarkDetailsViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 11/28/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import Foundation

typealias BookmarkTag = String

class BookmarkDetailsViewModel: BaseViewModel {
    
    enum Mode {
        case create, edit(bookmark: Bookmark)
    }
    
    let addButtonTitle = "Add"
    let tagsDirections = "Separate tags with spaces"
    
    let mode: Mode
    
    var url: URL?
    var bookmarkTitle: String?
    var description: String?
    var makePrivate = true
    var readLater = true
    var tags: [BookmarkTag] = []
    
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
            self.url = bookmark.url// bookmark.url
            self.bookmarkTitle = bookmark.title //bookmark.title
            self.description = bookmark.desc //bookmark.desc
            self.tags = bookmark.tags
        }
    }
    
    func addBookmark(completion: @escaping (Result<Bookmark>) -> ()) {
        guard let url = url else { return }
        
        let bookmark = Bookmark()
        bookmark.url = url
        bookmark.title = bookmarkTitle ?? url.absoluteString
        bookmark.desc = description ?? ""
        bookmark.shared = !makePrivate
        bookmark.toRead = readLater
        bookmark.userTags = tags.joined(separator: " ")
        
        let dp = PinboardDataProvider()
        
        dp.add(bookmark) { result in
            switch result {
            case .success:
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    bookmark.persist()
                    
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
