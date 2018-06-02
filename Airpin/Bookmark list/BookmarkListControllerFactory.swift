//
//  BookmarkListControllerFactory.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

class BookmarkListControllerFactory {

    let signInAlertFactory: SignInAlertFactory

    init(signInAlertFactory: SignInAlertFactory) {
        self.signInAlertFactory = signInAlertFactory
    }
    
    func makeAllBookmarkListController() -> BookmarkListViewController {
        let viewModel = AllBookmarksListViewModel()
        return BookmarkListViewController(viewModel: viewModel)
    }

    func makePopularBookmarkListController() -> BookmarkListViewController {
        let viewModel = PopularBookmarkListViewModel()
        return BookmarkListViewController(viewModel: viewModel)
    }

    func makeCategoryController(isLoggedIn: Bool) -> CategoryViewController {
        let viewModel = CategoryViewModel(isLoggedIn: isLoggedIn)
        return CategoryViewController(viewModel: viewModel)
    }

    func makeBookmarkListController(tag: String) -> BookmarkListViewController {
        let viewModel = TagBookmarksViewModel(bookmarkTag: tag)
        return BookmarkListViewController(viewModel: viewModel)
    }

    func makeBookmarkDetails(bookmark: Bookmark) -> BookmarkDetailsViewController {
        let viewModel = BookmarkDetailsViewModel(mode: .edit(bookmark))
        return BookmarkDetailsViewController(viewModel: viewModel)
    }

    func makeSignInModal(message: String) -> AlertController {
        return signInAlertFactory.makeSignInModal(message: message)
    }
}
