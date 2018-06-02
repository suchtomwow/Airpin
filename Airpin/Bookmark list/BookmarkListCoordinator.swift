//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

enum BookmarkListCoordinatorOutput {
    case tappedGoToSettings
}

class BookmarkListCoordinator {

    var output: ((BookmarkListCoordinatorOutput) -> Void)?

    var presenter: Presenter?
    let interactor = BookmarkListInteractor()
    let controllerFactory: BookmarkListControllerFactory

    var rootController: BookmarkListViewController?

    init(controllerFactory: BookmarkListControllerFactory) {
        self.controllerFactory = controllerFactory
    }

    func start() -> UIViewController {
        rootController = controllerFactory.makePopularBookmarkListController()

        rootController?.output = { [unowned self] output in
            self.outputForBookmarkListController(output)
        }

        presenter = PresenterImplementation(presenter: rootController!)
        return UINavigationController(rootViewController: rootController!)
    }

    func showCategoryController() {
        interactor.getAccountStatus { [weak self] status in
            let controller = controllerFactory.makeCategoryController(isLoggedIn: status == .signedIn)

            controller.output = { output in
                switch output {
                case .selectedCategory(let category):
                    self?.handleSelectedCategory(category: category, accountStatus: status)
                case .canceled:
                    self?.presenter?.dismiss(animated: true, completion: nil)
                }
            }

            self?.presenter?.present(controller, animated: true, completion: nil)
        }
    }

    func handleSelectedCategory(category: CategoryViewModel.Category, accountStatus: AccountStatusOutput) {
        let shouldUpdateCategory = accountStatus == .notSignedIn &&
                                   CategoryViewModel.Category.loggedOutEnabled.contains(category)

        if shouldUpdateCategory {
            updateBookmarkListViewModel(with: category)
        }

        presenter?.dismiss(animated: true) {
            if !shouldUpdateCategory {
                self.showTokenEntryAlert()
            }
        }
    }

    func updateBookmarkListViewModel(with category: CategoryViewModel.Category) {
        let viewModel: BookmarkListViewModel
        switch category {
        case .popular:
            viewModel = PopularBookmarkListViewModel()
        case .all:
            viewModel = AllBookmarksListViewModel()
        case .unread:
            viewModel = UnreadBookmarksListViewModel()
        case .untagged:
            viewModel = UntaggedBookmarksListViewModel()
        case .public:
            viewModel = PublicBookmarkListViewModel()
        case .private:
            viewModel = PrivateBookmarksListViewModel()
        }

        rootController?.updateViewModel(viewModel)
    }

    func showTagController(tag: String) {
        let controller = controllerFactory.makeBookmarkListController(tag: tag)
        controller.output = { [unowned self] output in
            self.outputForBookmarkListController(output)
        }
        presenter?.pushViewController(controller, animated: true)
    }

    func showBookmarkDetails(for bookmark: Bookmark) {
        let controller = controllerFactory.makeBookmarkDetails(bookmark: bookmark)
        controller.output = { [unowned self] output in
            switch output {
            case .bookmarkAdded:
                self.presenter?.dismiss(animated: true, completion: nil)
            }
        }
        let nav = UINavigationController(rootViewController: controller)
        presenter?.present(nav, animated: true, completion: nil)
    }

    func outputForBookmarkListController(_ output: BookmarkListViewController.Output) {
        switch output {
        case .selectedLeftNavItem:
            showCategoryController()
        case .selectedTag(let tag):
            showTagController(tag: tag)
        case .selectedEdit(let bookmark):
            showBookmarkDetails(for: bookmark)
        }
    }

    func showTokenEntryAlert() {
        let controller = controllerFactory.makeSignInModal(message: "To view your bookmarks, enter your Pinboard token in settings.")
        controller.output = { [unowned self] output in
            switch output {
            case .tappedButton:
                self.output?(.tappedGoToSettings)
            }
        }
        presenter?.present(controller, animated: true, completion: nil)
    }
}
