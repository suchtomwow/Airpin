//
//  BookmarkViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 10/10/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit
import SafariServices

class BookmarkListViewController: BaseViewController {
    
    private let tableView = BLSTableView()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    private let viewModel: BookmarkListViewModel

    init(viewModel: BookmarkListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchBookmarks(dataProvider: PinboardDataProvider()) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isHidden = strongSelf.viewModel.bookmarks.isEmpty
            strongSelf.tableView.reloadData()
            strongSelf.activityIndicator.stopAnimating()
        }
    }
    
    override func configureView() {
        super.configureView()
        
        title = viewModel.title

        view.backgroundColor = .white

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookmarkListTableViewCell.self, forCellReuseIdentifier: String(describing: BookmarkListTableViewCell.self))
        tableView.estimatedRowHeight = 120

        configureConstraints()
    }

    private func configureConstraints() {
        for subview in [tableView, activityIndicator] {
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: view.topAnchor),
                subview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                subview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                subview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
        }
    }
    
    private func toggleReadState(at indexPath: IndexPath) {
        viewModel.toggleReadState(at: indexPath.row, dataProvider: PinboardDataProvider())
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    private func delete(at indexPath: IndexPath) {
        viewModel.delete(at: indexPath.row, dataProvider: PinboardDataProvider())
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }

    private func showBookmarkList(for tag: String) {
        let viewModel = TagBookmarksViewModel(bookmarkTag: tag)
        let controller = BookmarkListViewController(viewModel: viewModel)
        show(controller, sender: nil)
    }
}

extension BookmarkListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookmarkListTableViewCell.self), for: indexPath) as! BookmarkListTableViewCell
        
        let bookmark = viewModel.bookmarks[indexPath.row]
        cell.configureWithBookmark(bookmark)
        cell.tagTapped = { [unowned self] tag in
            self.showBookmarkList(for: tag)
        }
        
        return cell
    }
}

extension BookmarkListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmark = viewModel.bookmarks[indexPath.row]
        
        if bookmark.toRead {
            toggleReadState(at: indexPath)
        }
        
        let svc = SFSafariViewController(url: bookmark.url)
        present(svc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] action, view, completion in
            self.delete(at: indexPath)
            completion(true)
        } // Trash can icon

        let toggleRead = UIContextualAction(style: .normal, title: "Mark as \(viewModel.bookmarks[indexPath.row].toRead ? "" : "un")read") { [unowned self] action, view, completion in
            self.toggleReadState(at: indexPath)
            completion(true)
        } // Filled icon if read, unfilled if not

        toggleRead.backgroundColor = .blueRowAction

        let actions = UISwipeActionsConfiguration(actions: [delete, toggleRead])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
}
