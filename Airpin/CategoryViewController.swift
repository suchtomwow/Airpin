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
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue == Segue.BookmarkViewController {
      let indexPath = sender as! NSIndexPath
      let category = CategoryViewModel.Category(rawValue: indexPath.row)
      let controller = segue.destinationViewController as! BookmarkViewController
      controller.category = category
    }
  }
  
  
  // MARK: - Common -
  
  override func configureView() {
    super.configureView()
    
    title = viewModel.title
    
    print(SingleLabelTableViewCell.ReuseIdentifier)
    tableView.registerClass(SingleLabelTableViewCell.self, forCellReuseIdentifier: SingleLabelTableViewCell.ReuseIdentifier)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.rightBarButtonText, style: .Plain, target: self, action: "rightBarButtonItemTapped:")
  }
  
  
  // MARK: - Responders -
  
  func rightBarButtonItemTapped(sender: UIBarButtonItem) {
    if let _ = NetworkClient.sharedInstance.accessToken {
      // perform logout
      print("log out")
    } else {
      // perform sign in
      print("sign in")
    }
  }
}


// MARK: - Extensions

// MARK: - UITableViewDataSource -

extension CategoryViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CategoryViewModel.Category.allValues.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(SingleLabelTableViewCell.ReuseIdentifier, forIndexPath: indexPath) as! SingleLabelTableViewCell

    if !viewModel.isLoggedIn {
      cell.key.textColor = UIColor.secondaryTextColor()
    }
    
    cell.key.text = CategoryViewModel.Category.allValues[indexPath.row].description
    cell.accessoryType = .DisclosureIndicator
    
    return cell
  }
}


// MARK: - UITableViewDelegate -

extension CategoryViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier(Segue.BookmarkViewController.rawValue, sender: indexPath)
  }
}