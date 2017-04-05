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
    
    @IBOutlet weak var tableView: BLSTableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: BookmarkListViewModel!
    
    var category: CategoryViewModel.Category! {
        didSet {
            viewModel = BookmarkListViewModel(category: category)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchBookmarks {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func configureView() {
        super.configureView()
        
        title = viewModel.title
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        tableView.register(BookmarkListTableViewCell.self, forCellReuseIdentifier: String(describing: BookmarkListTableViewCell.self))
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    func toggleReadState(at indexPath: IndexPath) {
        viewModel.toggleReadState(at: indexPath.row)
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func delete(at indexPath: IndexPath) {
        viewModel.delete(at: indexPath.row)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

extension BookmarkListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookmarks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookmarkListTableViewCell.self), for: indexPath) as! BookmarkListTableViewCell
        
        let bookmark = viewModel.bookmarks![indexPath.row]
        cell.configureWithBookmark(bookmark)
        
        return cell
    }
}

extension BookmarkListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmark = viewModel.bookmarks![indexPath.row]
        
        if bookmark.toRead {
            toggleReadState(at: indexPath)
        }
        
        let svc = SFSafariViewController(url: bookmark.url)
        
        present(svc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let bookmark = viewModel.bookmarks![indexPath.row]
        
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
