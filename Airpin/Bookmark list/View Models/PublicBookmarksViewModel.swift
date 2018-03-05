//
//  PublicBookmarksViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 3/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift

class PublicBookmarksListViewModel: BaseViewModel, BookmarkListViewModel {
    var bookmarks: [Bookmark] = []
    let title: String = "Public"
    let filter: ((Bookmark) -> Bool)? = { bookmark in bookmark.shared }
}

