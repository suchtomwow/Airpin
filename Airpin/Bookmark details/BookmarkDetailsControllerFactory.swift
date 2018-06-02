//
//  BookmarkDetailsControllerFactory.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

class BookmarkDetailsControllerFactory {

    private let signInAlertFactory: SignInAlertFactory

    init(signInAlertFactory: SignInAlertFactory) {
        self.signInAlertFactory = signInAlertFactory
    }

    func makeStubAddBookmarkController() -> UIViewController {
        return UIViewController()
    }

    func makeAddBookmarkController() -> BookmarkDetailsViewController {
        let viewModel = BookmarkDetailsViewModel(mode: .create)
        return BookmarkDetailsViewController(viewModel: viewModel)
    }

    func makeSignInModal(message: String) -> AlertController {
        return signInAlertFactory.makeSignInModal(message: message)
    }
}
