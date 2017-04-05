//
//  TokenEntryViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 4/15/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import UIKit
import Locksmith
import SafariServices

protocol TokenEntryDelegate: class {
    func didFinishTokenEntry(didEnterToken: Bool)
}

struct TokenEntryViewDetails {
    let description1 = "Enjoy all the great features of Airpin by entering your Pinboard token."
    let tokenFieldPlaceholder = "token"
    let affirmativeCTA = "Let's go"
    let negativeCTA = "No, thanks"
    let helpButton = "?"
}

class TokenEntryViewController: BaseViewController {
    
    @IBOutlet weak var description1Label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var affirmativeCTA: CTAButton!
    @IBOutlet weak var negativeCTA: UIButton!

    private var helpButton = UIButton()
    
    weak var delegate: TokenEntryDelegate?
    
    let viewModel = TokenEntryViewModel()
    
    // MARK: Configuration
    
    var viewDetails: TokenEntryViewDetails! {
        didSet {
            description1Label.attributedText = viewDetails.description1.title(alignment: .center, color: .white)
            textField.placeholder            = viewDetails.tokenFieldPlaceholder
            
            helpButton.setTitle(viewDetails.helpButton, for: .normal)
            
            affirmativeCTA.title = viewDetails.affirmativeCTA
            
            negativeCTA.setAttributedTitle(viewDetails.negativeCTA.secondaryButton(), for: [])
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textField.resignFirstResponder()
    }
    
    override func configureView() {
        super.configureView()
        
        textField.delegate = self
        configureTextFieldBottomBorder()
        configureHelpButton()
        
        viewDetails = viewModel.viewDetails
        
        textField.rightView = helpButton
        textField.rightViewMode = .unlessEditing
        textField.clearButtonMode = .whileEditing
    }
    
    override func configureStyles() {
        super.configureStyles()
        
        view.backgroundColor = .primary
        
        textField.font = UIFont.title1()
        textField.textColor = .white
        textField.tintColor = .white
        
        helpButton.layer.cornerRadius = 8
        helpButton.backgroundColor = UIColor.white
        helpButton.setTitleColor(.tertiaryText, for: .normal)
        helpButton.alpha = 0.5
    }
    
    private func configureTextFieldBottomBorder() {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(border)
        
        NSLayoutConstraint.activate([
            border.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            border.topAnchor.constraint(equalTo: textField.bottomAnchor),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        border.backgroundColor = .white
    }
    
    final private func configureHelpButton() {
        helpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            helpButton.widthAnchor.constraint(equalToConstant: 30),
            helpButton.heightAnchor.constraint(equalTo: helpButton.widthAnchor)
        ])
        
        helpButton.addTarget(self, action: #selector(TokenEntryViewController.helpButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: Internal
    
    private func showErrorMessage() {
        let alert = AlertController(headline: "Could not store token", body: "Try again later", buttonTitle: "OK", buttonTappedHandler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    private var hasSeenModal: Bool {
        get {
            let hasSeen = UserDefaults.standard.bool(forKey: UserDefault.hasDismissedTokenPrompt)
            return hasSeen
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefault.hasDismissedTokenPrompt)
        }
    }
    
    private func loadAccount() {
        do {
            try viewModel.loadAccount(token: textField.text)
            delegate?.didFinishTokenEntry(didEnterToken: true)
        } catch {
            print(error)
            delegate?.didFinishTokenEntry(didEnterToken: false)
        }
    }
    
    final private func goToPinboardWebsiteSettings() {
        guard let url = URL(string: "https://pinboard.in/settings/password") else {
            return
        }
        
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    
    // MARK: IBActions
    
    func helpButtonTapped(_ sender: Any) {
        let headline = "What's my token?"
        let body = "Your token is what gives you access to your bookmarks. Enter it on this screen to create, read, and share your bookmarks. You can find your token in your settings on the Pinboard website.\n\nAirpin stores your token securely in your device's keychain. It cannot be accessed by or shared with anyone other than you."
        let buttonTitle = "Go to Pinboard settings"
        
        let alert = AlertController(headline: headline, body: body, buttonTitle: buttonTitle) { [unowned self] sender in
            self.goToPinboardWebsiteSettings()
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func negativeCTATapped(_ sender: UIButton) {
        hasSeenModal = true
        
        delegate?.didFinishTokenEntry(didEnterToken: false)
    }
    
    @IBAction func affirmativeCTATapped(_ sender: UIButton) {
        hasSeenModal = true
        
        // TODO: Verify token format
        
        do {
            try viewModel.store(token: textField.text)
            delegate?.didFinishTokenEntry(didEnterToken: true)
        } catch LocksmithError.duplicate {
            loadAccount()
        } catch {
            print(error)
            delegate?.didFinishTokenEntry(didEnterToken: false)
        }
    }
}


// MARK: UITextFieldDelegate

extension TokenEntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        affirmativeCTATapped(affirmativeCTA)
        
        return true
    }
}
