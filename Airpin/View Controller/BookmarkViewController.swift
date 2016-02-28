//
//  BookmarkViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 10/10/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit
import SafariServices

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
    
    title = viewModel.title
    
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()

    tableView.registerClass(BookmarkTableViewCell.self, forCellReuseIdentifier: String(BookmarkTableViewCell))
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 120.0
  }
  
  func setTitleForViewController(viewController: UIViewController, withBookmark bookmark: Bookmark) {
    viewController.title = bookmark.title.characters.count > 0 ? bookmark.title : bookmark.displayURL
  }
  
  func toggleBookmarkReadStateAtIndexPath(indexPath: NSIndexPath) {
    viewModel.toggleBookmarkReadStateAtIndex(indexPath.row)
    
    tableView.beginUpdates()
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    tableView.endUpdates()
  }
  
  func deleteBookmarkAtIndexPath(indexPath: NSIndexPath) {
    viewModel.deleteBookmarkAtIndex(indexPath.row)

    tableView.beginUpdates()
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    tableView.endUpdates()
  }
}

extension BookmarkViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.bookmarks?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(String(BookmarkTableViewCell), forIndexPath: indexPath) as! BookmarkTableViewCell
    
    let bookmark = viewModel.bookmarks![indexPath.row]
    cell.configureWithBookmark(bookmark)
    
    return cell
  }
}

extension BookmarkViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let bookmark = viewModel.bookmarks![indexPath.row]
    
    if bookmark.toRead {
      toggleBookmarkReadStateAtIndexPath(indexPath)
    }
    
    let svc = SFSafariViewController(URL: bookmark.URL)
    setTitleForViewController(svc, withBookmark: bookmark)
    
    showViewController(svc, sender: nil)
  }
  
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    let bookmark = viewModel.bookmarks![indexPath.row]
    
    let toggleReadState = UITableViewRowAction(style: .Default, title: bookmark.toRead ? "Mark as\nread" : "Mark as\nunread") { action, indexPath in
      self.toggleBookmarkReadStateAtIndexPath(indexPath)
    }
    
    let deleteBookmark = UITableViewRowAction(style: .Destructive, title: "Delete") { action, indexPath in
      self.deleteBookmarkAtIndexPath(indexPath)
    }
    
    toggleReadState.backgroundColor = UIColor.blueRowAction()
    
    return [deleteBookmark, toggleReadState]
  }
}