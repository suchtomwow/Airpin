//
//  Constant.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

enum UserDefault: String {
  case UpdateTime = "com.bls.airpin.updateTime"
  case HasDismissedTokenPrompt = "com.bls.airpin.hasDismissedTokenPrompt"
}

// TODO: Shouldn't need this
enum CellIdentifier: String {
  case SingleLabel = "SingleLabelTableViewCell"
}

enum Segue: String {
  case BookmarkViewController
  case TokenEntryViewController
}

var DefaultInset: Double {
  return 15.0
}

func ==(lhs: UIStoryboardSegue, rhs: Segue) -> Bool {
  return lhs.identifier! == rhs.rawValue
}