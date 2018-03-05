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
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
    }
    
    override func configureView() {
        super.configureView()
        
        title = viewModel.title
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookmarkListTableViewCell.self, forCellReuseIdentifier: String(describing: BookmarkListTableViewCell.self))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0

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
}

extension BookmarkListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookmarkListTableViewCell.self), for: indexPath) as! BookmarkListTableViewCell
        
        let bookmark = viewModel.bookmarks[indexPath.row]
        cell.configureWithBookmark(bookmark)
        
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let bookmark = viewModel.bookmarks[indexPath.row]
        
        let toggleReadState = UITableViewRowAction(style: .default, title: bookmark.toRead ? "Mark as\nread" : "Mark as\nunread") { action, indexPath in
            self.toggleReadState(at: indexPath)
        }
        
        let deleteBookmark = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            self.delete(at: indexPath)
        }
        
        toggleReadState.backgroundColor = .blueRowAction
        
        return [deleteBookmark, toggleReadState]
    }
}
