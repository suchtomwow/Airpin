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
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

class PresenterImplementation: Presenter {

    private let presenter: UIViewController

    required init(presenter: UIViewController) {
        self.presenter = presenter
    }

    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presenter.present(viewControllerToPresent, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        presenter.dismiss(animated: animated, completion: completion)
    }
}
