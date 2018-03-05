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
    
    @IBOutlet weak var tableView: BLSTableView!
    
    let viewModel = CategoryViewModel()
    
    // MARK: - View lifecycle -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue == Segue.tokenEntryViewController, let controller = segue.destination as? TokenEntryViewController {
            controller.delegate = self
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let loggedIn = viewModel.isLoggedIn
        let hasSeen = UserDefaults.standard.bool(forKey: UserDefault.hasDismissedTokenPrompt)
        
        if !loggedIn && !hasSeen {
            perform(#selector(CategoryViewController.showTokenEntry), with: nil, afterDelay: 1)
        }
    }
    
    
    // MARK: - Common -
    
    override func configureView() {
        super.configureView()
        
        title = viewModel.title
        
        tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: String(describing: SingleLabelTableViewCell.self))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: viewModel.leftBarButtonText, style: .plain, target: self, action: #selector(CategoryViewController.leftBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(CategoryViewController.rightBarButtonItemTapped(_:)))
        
        updateView()
    }
    
    private func showBookmarkList(for row: Int) {
    }

    @objc private func showTokenEntry() {
        performSegue(withIdentifier: Segue.tokenEntryViewController.rawValue, sender: nil)
    }
    
    private func updateView() {
        navigationItem.leftBarButtonItem?.title = viewModel.leftBarButtonText
        tableView.reloadData()
    }
    
    private func segueToTokenEntry() {
        performSegue(withIdentifier: Segue.tokenEntryViewController.rawValue, sender: nil)
    }
    
    
    // MARK: - Responders -
    
    @objc private func leftBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if viewModel.isLoggedIn {
            // perform logout
            NetworkClient.shared.signOut { [unowned self] in
                self.updateView()
            }
        } else {
            // perform sign in
            segueToTokenEntry()
        }
    }
    
    @objc private func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        if viewModel.isLoggedIn {
            let detailsController = BookmarkDetailsViewController.presentable(mode: .create, delegate: self)
            present(detailsController, animated: true)
        } else {
            segueToTokenEntry()
        }
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
        
        if viewModel.isLoggedIn {
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
        showBookmarkList(for: indexPath.row)
    }
}


// MARK: - TokenEntryDelegate -

extension CategoryViewController: TokenEntryDelegate {
    func didFinishTokenEntry(didEnterToken: Bool) {
        if didEnterToken {
            updateView()
        }
        
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - BookmarkDetailsViewControllerDelegate -

extension CategoryViewController: BookmarkDetailsViewControllerDelegate {
    func didAdd(_ bookmark: Bookmark) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - UIViewControllerTransitioningDelegate -

extension CategoryViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalTransitionPresentAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalTransitionDismissAnimation()
    }
}
