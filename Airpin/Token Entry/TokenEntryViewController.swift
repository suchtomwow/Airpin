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
      description1Label.attributedText = viewDetails.description1.body(alignment: .Center)
      textField.placeholder            = viewDetails.tokenFieldPlaceholder
      
      affirmativeCTA.setAttributedTitle(viewDetails.affirmativeCTA.primaryButton(), forState: .Normal)
      negativeCTA.setAttributedTitle(viewDetails.negativeCTA.secondaryButton(), forState: .Normal)
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    textField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    textField.resignFirstResponder()
  }
  
  override func configureView() {
    super.configureView()
    
    configureTextFieldBottomBorder()
    
    viewDetails = viewModel.viewDetails
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TokenEntryViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
  }
  
  override func configureStyles() {
    super.configureStyles()
    
    textField.font = UIFont.title1()
    textField.textColor = UIColor.primaryTextColor()
    
    affirmativeCTA.backgroundColor = UIColor.mintGreen()
  }
  
  func configureTextFieldBottomBorder() {
    let border = UIView()
    border.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(border)
    
    NSLayoutConstraint.activateConstraints([
      border.leadingAnchor.constraintEqualToAnchor(textField.leadingAnchor, constant: 20),
      border.trailingAnchor.constraintEqualToAnchor(textField.trailingAnchor, constant: -20),
      border.topAnchor.constraintEqualToAnchor(textField.bottomAnchor),
      border.heightAnchor.constraintEqualToConstant(1)
    ])
    
    border.backgroundColor = UIColor.secondaryTextColor()
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
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: UserDefault.HasDismissedTokenPrompt.rawValue)
    
    delegate?.didFinishTokenEntry(didEnterToken: false)
  }
  
  @IBAction func affirmativeCTATapped(sender: UIButton) {
    // TODO: Verify token format
    
    // TODO: If valid token, store in keychain
    
    delegate?.didFinishTokenEntry(didEnterToken: true)
  }
}
