//
//  BookmarkDetailsViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 11/28/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

// To do...
// ✅ Paste link from clipboard
// 🚫 Unfurl URL details
// 🚫 Tag suggestions
// ✅ Tags
// 🚫 Lowercase tags


import UIKit
import Eureka
import SwiftyJSON

protocol BookmarkDetailsViewControllerDelegate: class {
    func didAdd(_ bookmark: Bookmark)
}

class BookmarkDetailsViewController: FormViewController {
    
    class func presentable(mode: BookmarkDetailsViewModel.Mode, delegate: BookmarkDetailsViewControllerDelegate) -> UINavigationController {
        let viewModel = BookmarkDetailsViewModel(mode: mode)
        let controller = BookmarkDetailsViewController(viewModel: viewModel, delegate: delegate)
        
        let nav = UINavigationController(rootViewController: controller)
        
        return nav
    }
    
    var viewModel: BookmarkDetailsViewModel
    unowned let delegate: BookmarkDetailsViewControllerDelegate

    let urlRow: PasteableURLRow
    let titleRow: TextRow
    let descriptionRow: TextAreaRow
    let privacyRow: SwitchRow
    let readLaterRow: SwitchRow
    let tagsRow: TextRow
    
    init(viewModel: BookmarkDetailsViewModel, delegate: BookmarkDetailsViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        urlRow = PasteableURLRow { row in
            row.placeholder = "URL"
            row.value = viewModel.url
        }.onChange { row in
            viewModel.url = row.value
        }
        
        titleRow = TextRow { row in
            row.placeholder = "Title"
            row.value = viewModel.bookmarkTitle
        }.onChange { row in
            viewModel.bookmarkTitle = row.value
        }
        
        descriptionRow = TextAreaRow { row in
            row.placeholder = "Description"
            row.value = viewModel.description
        }.onChange { row in
            viewModel.description = row.value
        }
        
        privacyRow = SwitchRow { row in
            row.title = "Private"
            row.value = viewModel.makePrivate
        }.onChange { row in
            viewModel.makePrivate = row.value!
        }
        
        readLaterRow = SwitchRow { row in
            row.title = "Read later"
            row.value = viewModel.readLater
        }.onChange { row in
            viewModel.readLater = row.value!
        }

        tagsRow = TextRow { row in
            row.placeholder = "Tags (separated by spaces)"
            row.cell.textField.autocapitalizationType = .none
            row.value = viewModel.tags.joined(separator: " ")
        }.onChange { row in
            if let value = row.value {
                viewModel.tags = value.components(separatedBy: " ")
            }
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureForm()
    }
    
    final fileprivate func configureView() {
        title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelTapped(sender:)))
        
        configureAddButton()
    }
    
    final fileprivate func configureForm() {
        var section = Section()
        section += [urlRow, titleRow, descriptionRow, privacyRow, readLaterRow, tagsRow]
        form +++ section
    }

    final fileprivate func configureAddButton() {
        let button = CTAButton()
        
        button.title = viewModel.addButtonTitle
        button.addTarget(self, action: #selector(self.addButtonTapped(sender:)), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        viewModel.addBookmark { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let bookmark):
                strongSelf.delegate.didAdd(bookmark)
            case .failure(let error):
                strongSelf.show(error)
            }
        }
    }
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    final fileprivate func show(_ error: NSError) {
        let alert = AlertController(error: error)
        present(alert, animated: true)
    }
}

extension BookmarkDetailsViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let string = String(data: data, encoding: .utf8)
        print(string ?? "")
    }
}
