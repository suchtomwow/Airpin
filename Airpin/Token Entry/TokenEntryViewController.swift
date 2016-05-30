//
//  TokenEntryViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 4/15/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import UIKit

protocol TokenEntryDelegate: class {
  func didFinishTokenEntry(didEnterToken didEnterToken: Bool)
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
      description1Label.attributedText = viewDetails.description1.title(alignment: .Center, color: UIColor.whiteColor())
      textField.placeholder            = viewDetails.tokenFieldPlaceholder
      
      affirmativeCTA.setAttributedTitle(viewDetails.affirmativeCTA.primaryButton(), forState: .Normal)
      
      negativeCTA.setAttributedTitle(viewDetails.negativeCTA.secondaryButton(), forState: .Normal)
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    textField.resignFirstResponder()
  }
  
  override func configureView() {
    super.configureView()
    
    textField.delegate = self
    configureTextFieldBottomBorder()
    
    viewDetails = viewModel.viewDetails
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TokenEntryViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
  }
  
  override func configureStyles() {
    super.configureStyles()
    
    view.backgroundColor = UIColor.primaryColor()
    
    textField.font = UIFont.title1()
    textField.textColor = UIColor.whiteColor()
    textField.tintColor = UIColor.complementaryColor()
    
    affirmativeCTA.backgroundColor = UIColor.complementaryColor()
  }
  
  func configureTextFieldBottomBorder() {
    let border = UIView()
    border.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(border)
    
    NSLayoutConstraint.activateConstraints([
      border.leadingAnchor.constraintEqualToAnchor(textField.leadingAnchor, constant: 0),
      border.trailingAnchor.constraintEqualToAnchor(textField.trailingAnchor, constant: 0),
      border.topAnchor.constraintEqualToAnchor(textField.bottomAnchor),
      border.heightAnchor.constraintEqualToConstant(1)
    ])
    
    border.backgroundColor = UIColor.whiteColor()
  }
  
  
  // MARK: - Internal -
  
  private func showErrorMessage() {
    let actionAlert = UIAlertController(title: "Could not store token", message: "Try again later.", preferredStyle: .Alert)

    actionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
      self.dismissViewControllerAnimated(true, completion: nil)
    }))
    
    presentViewController(actionAlert, animated: true, completion: nil)
  }
  
  private var hasSeenModal: Bool {
    get {
      return NSUserDefaults.standardUserDefaults().boolForKey(UserDefault.HasDismissedTokenPrompt.rawValue)
    }
    set {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: UserDefault.HasDismissedTokenPrompt.rawValue)
    }
  }
  
  
  // MARK: - Observers -
  
  func keyboardWillShow(sender: NSNotification) {
    if let userInfo = sender.userInfo,
       let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
       let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
       let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue  {
      
        let keyboardHeight = endFrame.height
      
      affirmativeCTABottomConstraint.constant = keyboardHeight
      
      let curve = UIViewAnimationOptions(rawValue: UInt((animationCurve).integerValue << 16))
      
      UIView.animateWithDuration(animationDuration, delay: 0.0, options: [curve], animations: { 
        self.view.layoutIfNeeded()
        }, completion: nil)
    }
  }
  
  
  // MARK: IBActions
  
  @IBAction func negativeCTATapped(sender: UIButton) {
    hasSeenModal = true
    
    delegate?.didFinishTokenEntry(didEnterToken: false)
  }
  
  @IBAction func affirmativeCTATapped(sender: UIButton) {
    hasSeenModal = true
    
    // TODO: Verify token format
    
    do {
      try viewModel.storeToken(textField.text)
      delegate?.didFinishTokenEntry(didEnterToken: true)
    } catch {
      print(error)
      
      delegate?.didFinishTokenEntry(didEnterToken: false)
    }
  }
}


// MARK: - UITextFieldDelegate -

extension TokenEntryViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    affirmativeCTATapped(affirmativeCTA)
    
    return true
  }
}
