//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

class BookmarkListCoordinatorFactory {
    func makeBookmarkListCoordinator() -> BookmarkListCoordinator {
        let controllerFactory = BookmarkListControllerFactory(signInAlertFactory: SignInAlertFactory())
        return BookmarkListCoordinator(controllerFactory: controllerFactory)
    }
}
