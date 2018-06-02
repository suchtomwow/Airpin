//
//  CategoryViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 4/7/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit
import SafariServices

class CategoryViewController: BaseViewController {

    enum Output {
        case selectedCategory(CategoryViewModel.Category), canceled
    }

    var output: ((Output) -> Void)?
    
    let tableView = BLSTableView()
    
    let viewModel: CategoryViewModel

    let strongTransitioningDelegate = CategoryTransitioningDelegate()

    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        transitioningDelegate = strongTransitioningDelegate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Common -
    
    override func configureView() {
        super.configureView()

        title = viewModel.title
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: String(describing: SingleLabelTableViewCell.self))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func tappedOutsideTransition() {
        output?(.canceled)
    }
}


// MARK: - Extensions

// MARK: - UITableViewDataSource -

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryViewModel.Category.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SingleLabelTableViewCell.self), for: indexPath) as! SingleLabelTableViewCell

        let category = CategoryViewModel.Category(rawValue: indexPath.row) ?? .all

        if viewModel.isLoggedIn || CategoryViewModel.Category.loggedOutEnabled.contains(category) {
            cell.headline.alpha = 1.0
        } else {
            cell.headline.alpha = 0.5
        }
        
        cell.headline.attributedText = CategoryViewModel.Category.allValues[indexPath.row].description.headline(alignment: .left)
        
        return cell
    }
}


// MARK: - UITableViewDelegate -

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = CategoryViewModel.Category(rawValue: indexPath.row) else { return }
        output?(.selectedCategory(category))
    }
}
