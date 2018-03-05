//
//  UntaggedBookmarksViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 3/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift

class UntaggedBookmarksListViewModel: BaseViewModel, BookmarkListViewModel {
    var bookmarks: [Bookmark] = []
    let title: String = "Untagged"
    var filter: ((Bookmark) -> Bool)? = { bookmark in bookmark.tags.count == 0 }
}
