//
//  Icons.swift
//  Airpin
//
//  Created by Thomas Carey on 2/26/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import UIKit

enum Icon: String {
    case disclosure = "disclosure"
    case x = "x"

    var image: UIImage? {
        return UIImage(named: self.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
}
