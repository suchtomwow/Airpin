//
//  CategoriesViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 4/7/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit
import SafariServices

class CategoriesViewController: BLSViewController {

  @IBOutlet weak var tableView: BLSTableView!
  
  let viewModel = CategoriesViewModel()
  
  var signedIn: Bool {
    return false
  }
  
  
  // MARK: - Common -
  
  override func configureView() {
    super.configureView()
    
    title = viewModel.title
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.rightBarButtonText, style: .Plain, target: self, action: "signIn")
    tableView.registerNib(UINib(nibName: CellIdentifier.SingleLabel.rawValue, bundle: nil), forCellReuseIdentifier: CellIdentifier.SingleLabel.rawValue)
  }
  
  override func configureConstraints() {
    super.configureConstraints()
    
    tableView.pinToSuperview(inset: 0.0, axis: .Horizontal)
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: [], metrics: nil, views: ["tableView": tableView]))
    
    NSLayoutFormatOptions.AlignAllCenterX
  }
  
  override func configureStyles() {
    super.configureStyles()
    
  }
  
  
  // MARK: - Responders -
  
  func signIn() {
    print("Show sign in controller")
  }
}


// MARK: - Extensions -

// MARK: - UITableViewDataSource -

extension CategoriesViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CategoriesViewModel.Category.allValues.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.SingleLabel.rawValue, forIndexPath: indexPath) as! SingleLabelTableViewCell

    if !signedIn {
      cell.key.textColor = UIColor.secondaryTextColor()
    }
    
    cell.key.text      = CategoriesViewModel.Category.allValues[indexPath.row].rawValue
    cell.accessoryType = .DisclosureIndicator
    
    return cell
  }
}


// MARK: - UITableViewDelegate -

extension CategoriesViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.row {
    case CategoriesViewModel.Category.All.hashValue:
      PinboardDataProvider().fetchAllBookmarks { bookmarks in
        return
      }
      // Get all bookmarks. Completion closure: segue to BookmarksViewController
      print("all selected")
    case CategoriesViewModel.Category.Private.hashValue:
      print("private selected")
    case CategoriesViewModel.Category.Public.hashValue:
      print("public selected")
    case CategoriesViewModel.Category.Starred.hashValue:
      print("starred selected")
    case CategoriesViewModel.Category.Unread.hashValue:
      print("unread selected")
    case CategoriesViewModel.Category.Untagged.hashValue:
      print("untagged selected")
    default:
      fatalError("CategoriesViewController: Unexpected indexPath")
    }
  }
}