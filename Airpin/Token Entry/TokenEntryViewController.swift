//
//  TokenEntryViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 4/15/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import UIKit

protocol TokenEntryDelegate: class {
  func didFinishTokenEntry(didEnterToken: Bool)
}

struct TokenEntryViewDetails {
  let description1 = "Enjoy all the great features of Airpin by entering your Pinboard token."
  let tokenFieldPlaceholder = "token"
  let affirmativeCTA = "Let's go"
  let negativeCTA = "No, thanks"
}

class TokenEntryViewController: BaseViewController {
  @IBOutlet weak var description1Label: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var affirmativeCTA: UIButton!
  @IBOutlet weak var negativeCTA: UIButton!
  
  @IBOutlet weak var affirmativeCTABottomConstraint: NSLayoutConstraint!
  
  weak var delegate: TokenEntryDelegate?
  
  let viewModel = TokenEntryViewModel()
  
  
  // MARK: - Configuration -
  var viewDetails: TokenEntryViewDetails! {
    didSet {
      description1Label.attributedText = viewDetails.description1.title(alignment: .center, color: UIColor.white())
      textField.placeholder            = viewDetails.tokenFieldPlaceholder
      
      affirmativeCTA.setAttributedTitle(viewDetails.affirmativeCTA.primaryButton(), for: [])
      
      negativeCTA.setAttributedTitle(viewDetails.negativeCTA.secondaryButton(), for: [])
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
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
    
    viewDetails = viewModel.viewDetails
    
    NotificationCenter.default().addObserver(self, selector: #selector(TokenEntryViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
  }
  
  override func configureStyles() {
    super.configureStyles()
    
    view.backgroundColor = UIColor.primaryColor()
    
    textField.font = UIFont.title1()
    textField.textColor = UIColor.white()
    textField.tintColor = UIColor.complementaryColor()
    
    affirmativeCTA.backgroundColor = UIColor.complementaryColor()
  }
  
  func configureTextFieldBottomBorder() {
    let border = UIView()
    border.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(border)
    
    NSLayoutConstraint.activate([
      border.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 0),
      border.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 0),
      border.topAnchor.constraint(equalTo: textField.bottomAnchor),
      border.heightAnchor.constraint(equalToConstant: 1)
    ])
    
    border.backgroundColor = UIColor.white()
  }
  
  
  // MARK: - Internal -
  
  private func showErrorMessage() {
    let actionAlert = UIAlertController(title: "Could not store token", message: "Try again later.", preferredStyle: .alert)

    actionAlert.addAction(UIAlertAction(title: "OK", style: .default) { action in
      self.dismiss(animated: true, completion: nil)
    })
    
    present(actionAlert, animated: true, completion: nil)
  }
  
  private var hasSeenModal: Bool {
    get {
      let hasSeen = UserDefaults.standard().bool(forKey: UserDefault.HasDismissedTokenPrompt.rawValue)
      return hasSeen
    }
    set {
      UserDefaults.standard().set(true, forKey: UserDefault.HasDismissedTokenPrompt.rawValue)
      UserDefaults.standard().synchronize()
    }
  }
  
  
  // MARK: - Observers -
  
  func keyboardWillShow(_ sender: Notification) {
    if let userInfo = sender.userInfo,
       let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
       let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
       let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  {
      
        let keyboardHeight = endFrame().height
      
      affirmativeCTABottomConstraint.constant = keyboardHeight
      
      let curve = UIViewAnimationOptions(rawValue: UInt((animationCurve).intValue << 16))
      
      UIView.animate(withDuration: animationDuration, delay: 0.0, options: [curve], animations: { 
        self.view.layoutIfNeeded()
        }, completion: nil)
    }
  }
  
  
  // MARK: IBActions
  
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
    } catch {
      print(error)
      
      delegate?.didFinishTokenEntry(didEnterToken: false)
    }
  }
}


// MARK: - UITextFieldDelegate -

extension TokenEntryViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    affirmativeCTATapped(affirmativeCTA)
    
    return true
  }
}
