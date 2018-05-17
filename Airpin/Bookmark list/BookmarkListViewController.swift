//
//  BookmarkViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 10/10/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit
import SafariServices
import RealmSwift

class BookmarkListViewController: BaseViewController {
    
    private let tableView = BLSTableView()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let refreshControl = UIRefreshControl()
    
    private let viewModel: BookmarkListViewModel
    private let dataProvider: BookmarkDataProviding = PinboardDataProvider()
    private var observerToken: NotificationToken?

    init(viewModel: BookmarkListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        observerToken = viewModel.bookmarks.observe { [weak self] change in
            guard let `self` = self else { return }

            switch change {
            case .initial(let bookmarks):
                self.updateLoadingState(bookmarkCount: bookmarks.count)
                self.tableView.reloadData()
            case .update(let bookmarks, let deletions, let insertions, let modifications):
                self.updateTableView(with: bookmarks, deletions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchBookmarks(dataProvider: dataProvider, completion: nil)
    }
    
    override func configureView() {
        super.configureView()
        
        title = "Bookmarks"

        view.backgroundColor = .white

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookmarkListTableViewCell.self, forCellReuseIdentifier: String(describing: BookmarkListTableViewCell.self))
        tableView.estimatedRowHeight = 120

        refreshControl.addTarget(self, action: #selector(refreshFromNetwork), for: .valueChanged)
        tableView.refreshControl = refreshControl

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
        viewModel.toggleReadState(at: indexPath.row, dataProvider: dataProvider)
    }
    
    private func delete(at indexPath: IndexPath) {
        viewModel.delete(at: indexPath.row, dataProvider: dataProvider)
    }

    private func showBookmarkList(for tag: String) {
        let viewModel = TagBookmarksViewModel(bookmarkTag: tag)
        let controller = BookmarkListViewController(viewModel: viewModel)
        show(controller, sender: nil)
    }

    private func updateLoadingState(bookmarkCount: Int) {
        tableView.isHidden = bookmarkCount < 1
        activityIndicator.stopAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "\(bookmarkCount)", style: .plain, target: nil, action: nil)
    }

    private func updateTableView(with bookmarks: Results<Bookmark>, deletions: [Int], insertions: [Int], modifications: [Int]) {
        updateLoadingState(bookmarkCount: bookmarks.count)

        tableView.beginUpdates()
        tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                             with: .automatic)
        tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                             with: .automatic)
        tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) },
                             with: .automatic)
        tableView.endUpdates()
    }

    @objc private func refreshFromNetwork() {
        viewModel.fetchBookmarks(dataProvider: dataProvider) { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }

    private func editBookmark(_ bookmark: Bookmark) {
        // TODO: Hook up output in MainTabBarCoordinator
//        let viewModel = BookmarkDetailsViewModel(mode: .edit(bookmark))
//        let controller = BookmarkDetailsViewController(viewModel: viewModel)
//        let nav = UINavigationController(rootViewController: controller)
//        present(nav, animated: true, completion: nil)
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
        let delete = UIContextualAction(style: .destructive, title: nil) { [unowned self] action, view, completion in
            self.delete(at: indexPath)
            completion(true)
        }

        let toggleRead = UIContextualAction(style: .normal, title: nil) { [unowned self] action, view, completion in
            self.toggleReadState(at: indexPath)
            completion(true)
        }

        let edit = UIContextualAction(style: .normal, title: nil) { [unowned self] action, view, completion in
            self.editBookmark(self.viewModel.bookmarks[indexPath.row])
            completion(true)
        }

        delete.image = Icon.garbage.image
        delete.backgroundColor = UIColor.primary.withAlphaComponent(0.8)
        toggleRead.image = Icon.markAsRead.image
        toggleRead.backgroundColor = UIColor.primary.withAlphaComponent(0.6)
        edit.image = Icon.edit.image
        edit.backgroundColor = UIColor.primary.withAlphaComponent(0.4)

        let actions = UISwipeActionsConfiguration(actions: [viewModel.canDeleteBookmarks ? delete : nil, toggleRead, viewModel.canEditBookmarks ? edit : nil].compactMap { $0 })
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
}
