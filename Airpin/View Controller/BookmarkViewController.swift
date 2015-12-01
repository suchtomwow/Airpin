//
//  BookmarkViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 10/10/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class BookmarkViewController: BaseViewController {
  
  @IBOutlet weak var tableView: BLSTableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  var viewModel: BookmarkViewModel!
  
  var category: CategoryViewModel.Category! {
    didSet {
      viewModel = BookmarkViewModel(category: category)
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
    
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()

    tableView.registerClass(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.ReuseIdentifier)
  }
}

extension BookmarkViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.bookmarks?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(BookmarkTableViewCell.ReuseIdentifier, forIndexPath: indexPath) as! BookmarkTableViewCell
    
    let bookmark = viewModel.bookmarks![indexPath.row]
    cell.configureWithBookmark(bookmark)
    
    cell.setNeedsUpdateConstraints()
    cell.updateConstraintsIfNeeded()
    
    return cell
  }
}

extension BookmarkViewController: UITableViewDelegate {
}