//
//  BookmarkDetailsViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 11/28/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

// To do...
// ✅ Paste link from clipboard
// ✅ Unfurl URL details
// 🚫 Tag suggestions
// ✅ Tags
// 🚫 Lowercase tags


import UIKit
import Eureka
import SwiftyJSON
import RealmSwift

enum BookmarkDetailsPresentableOutput {
    case bookmarkAdded
}

protocol BookmarkDetailsPresentable {
    var output: ((BookmarkDetailsPresentableOutput) -> Void)? { get set }
}

class BookmarkDetailsViewController: FormViewController {
    
    var output: ((BookmarkDetailsPresentableOutput) -> Void)?

    private let viewModel: BookmarkDetailsViewModel

    private var urlRow: PasteableURLRow!
    private var titleRow: TextRow!
    private var descriptionRow: TextAreaRow!
    private var privacyRow: SwitchRow!
    private var readLaterRow: SwitchRow!
    private var tagsRow: TextRow!

    init(viewModel: BookmarkDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)

        urlRow = PasteableURLRow(String(describing: PasteableURLRow.self)) { row in
            row.placeholder = "URL"
            row.value = viewModel.url
        }.onChange { [unowned self] row in
            viewModel.url = row.value
            self.getMetadata(for: row.value)
        }
        
        titleRow = TextRow { row in
            row.placeholder = "Title"
            row.value = viewModel.bookmarkTitle
        }.onChange { row in
            viewModel.bookmarkTitle = row.value
        }
        
        descriptionRow = TextAreaRow { row in
            row.placeholder = "Description"
            row.value = viewModel.extended
        }.onChange { row in
            viewModel.extended = row.value
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
            row.value = viewModel.tags.reduce("") { $0 + " " + $1.name }
        }.onChange { row in
            if let value = row.value {
                viewModel.tags = List<Tag>()
                value.components(separatedBy: " ").forEach { viewModel.tags.append(Tag(value: [$0])) }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureForm()
    }
    
    final private func configureView() {
        title = viewModel.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelTapped(sender:)))
        
        configureAddButton()
    }
    
    final private func configureForm() {
        var detailsSection = Section()
        detailsSection += [titleRow, descriptionRow, privacyRow, readLaterRow, tagsRow]

        detailsSection.hidden = true
        detailsSection.hidden = Condition.function([String(describing: PasteableURLRow.self)]) { form -> Bool in
            let row = form.rowBy(tag: String(describing: PasteableURLRow.self)) as? PasteableURLRow
            return row?.value == nil
        }

        form +++ urlRow
             +++ detailsSection
    }
    
    override func insertAnimation(forSections sections: [Section]) -> UITableViewRowAnimation {
        return .fade
    }

    override func deleteAnimation(forSections sections: [Section]) -> UITableViewRowAnimation {
        return .fade
    }

    final private func configureAddButton() {
        let button = CTAButton()
        
        button.title = viewModel.addButtonTitle
        button.addTarget(self, action: #selector(self.addButtonTapped(sender:)), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func addButtonTapped(sender: UIButton) {
        viewModel.addBookmark { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success:
                strongSelf.output?(.bookmarkAdded)
            case .failure(let error):
                strongSelf.show(error)
            }
        }
    }
    
    @objc private func cancelTapped(sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    final private func show(_ error: NSError) {
        let alert = AlertController(error: error)
        present(alert, animated: true)
    }

    private func getMetadata(for url: URL?) {
        guard let url = url else { return }

        let metadata = MetaDataGetter(url: url) { [weak self] title, description in
            DispatchQueue.main.async { [weak self] in
                self?.titleRow.value = title
                self?.descriptionRow.value = description
                self?.titleRow.updateCell()
                self?.descriptionRow.updateCell()
            }
        }

        metadata.resume()
    }
}
