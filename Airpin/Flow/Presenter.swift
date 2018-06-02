//
//  Presenter.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

protocol Presenter: class {
    init(presenter: UIViewController)
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

class PresenterImplementation: Presenter {

    private let presenter: UIViewController

    required init(presenter: UIViewController) {
        self.presenter = presenter
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        assert(presenter.navigationController != nil)
        presenter.navigationController?.pushViewController(viewController, animated: animated)
    }

    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presenter.present(viewControllerToPresent, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        presenter.dismiss(animated: animated, completion: completion)
    }
}
