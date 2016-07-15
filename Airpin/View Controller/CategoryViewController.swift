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

  override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue == Segue.BookmarkViewController {
      let indexPath = sender as! IndexPath
      let category = CategoryViewModel.Category(rawValue: indexPath.row)
      let controller = segue.destinationViewController as! BookmarkViewController
      controller.category = category
    } else if segue == Segue.TokenEntryViewController {
      if let controller = segue.destinationViewController as? TokenEntryViewController {
        controller.delegate = self
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if NetworkClient.sharedInstance.accessToken == nil && !UserDefaults.standard().bool(forKey: UserDefault.HasDismissedTokenPrompt.rawValue) {
      perform(#selector(CategoryViewController.showTokenEntry), with: nil, afterDelay: 1)
    }
  }
  
  
  // MARK: - Common -
  
  override func configureView() {
    super.configureView()
    
    title = viewModel.title
    
    tableView.register(SingleLabelTableViewCell.self, forCellReuseIdentifier: String(SingleLabelTableViewCell))
    tableView.rowHeight          = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 60
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.rightBarButtonText, style: .plain, target: self, action: #selector(CategoryViewController.rightBarButtonItemTapped(_:)))
    
    updateView()
  }
  
  func showTokenEntry() {
    performSegue(withIdentifier: Segue.TokenEntryViewController.rawValue, sender: nil)
  }
  
  private func updateView() {
    navigationItem.rightBarButtonItem?.title = viewModel.rightBarButtonText
    tableView.reloadData()
  }
  
  
  // MARK: - Responders -
  
  func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
    if let _ = NetworkClient.sharedInstance.accessToken {
      // perform logout
      NetworkClient.sharedInstance.signOut {
        self.updateView()
      }
    } else {
      // perform sign in
      performSegue(withIdentifier: Segue.TokenEntryViewController.rawValue, sender: nil)
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
    let cell = tableView.dequeueReusableCell(withIdentifier: String(SingleLabelTableViewCell), for: indexPath) as! SingleLabelTableViewCell

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
    performSegue(withIdentifier: Segue.BookmarkViewController.rawValue, sender: indexPath)
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
