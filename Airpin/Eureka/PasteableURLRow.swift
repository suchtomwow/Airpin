//
//  PasteableURLRow.swift
//  Airpin
//
//  Created by Thomas Carey on 1/1/17.
//  Copyright © 2017 Thomas Carey. All rights reserved.
//

import UIKit
import Eureka

class PasteableURLCell: URLCell, HideableButtonDelegate {

    private let hideableButton = HideableButton(title: "Paste link from clipboard")

    var showHideableButton: Bool {
        set {
            hideableButton.isHidden = !newValue
        }

        get {
            return !hideableButton.isHidden
        }
    }

    open override func setup() {
        super.setup()

        NotificationCenter.default.addObserver(self, selector: #selector(PasteableURLCell.pasteboardDidChange(sender:)), name: .UIPasteboardChanged, object: nil)

        configureHideableButton()
        pasteboardDidChange(sender: nil)
    }

    final private func configureHideableButton() {
        if let row = baseRow as? HideableButtonDelegate {
            hideableButton.delegate = row
        }

        contentView.addSubview(hideableButton)
        hideableButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hideableButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hideableButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            hideableButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            hideableButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    @objc func pasteboardDidChange(sender: Notification?) {
        guard let pasteboardString = UIPasteboard.general.string else {
            showHideableButton = false
            return
        }

        showHideableButton = pasteboardString.hasLink
    }
}

final class PasteableURLRow: FieldRow<PasteableURLCell>, RowType, HideableButtonDelegate {

    var callbackOnPaste: (() -> Void)?

    func onPaste(_ callback: @escaping (PasteableURLRow) -> ()) -> Self {
        callbackOnPaste = { [unowned self] in callback(self) }
        return self
    }

    // MARK: - HideableButtonDelegate -

    func buttonTapped(button: UIView) {
        let pasteboardString = UIPasteboard.general.string ?? ""

        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

            let matches = detector.matches(in: pasteboardString, options: [], range: NSRange(location: 0, length: pasteboardString.characters.count))

            if let firstMatch = matches.first?.url {
                value = firstMatch
                updateCell()

                callbackOnPaste?()
            }

            cell.showHideableButton = false // do this even if there wasn't actually a link on the clipboard, which should, in practice, be impossible.
        } catch {
            print(error)
        }
    }
}
