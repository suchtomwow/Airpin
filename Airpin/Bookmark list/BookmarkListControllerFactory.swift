//
//  BookmarkListControllerFactory.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

class BookmarkListControllerFactory {
    func makeAllBookmarkListController() -> BookmarkListViewController {
        let viewModel = AllBookmarksListViewModel()
        return BookmarkListViewController(viewModel: viewModel)
    }

    func makePopularBookmarkListController() -> BookmarkListViewController {
        let viewModel = PopularBookmarkListViewModel()
        return BookmarkListViewController(viewModel: viewModel)
    }
}
