//
//  Tag.swift
//  Airpin
//
//  Created by Thomas Carey on 10/27/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

public typealias BookmarkTag = String

public class TagButton: UIButton {
    public var bookmarkTag: BookmarkTag {
      didSet {
        updateTitle()
      }
    }
    
    public init(bookmarkTag: BookmarkTag) {
        self.bookmarkTag = bookmarkTag

        super.init(frame: CGRect.zero)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func commonInit() {
        configureView()
        configureStyles()
    }
    
    fileprivate func configureView() {
        contentEdgeInsets  = UIEdgeInsets(top: 3.0, left: 7.0, bottom: 4.0, right: 7.0)
        clipsToBounds      = true
        layer.cornerRadius = 2

        updateTitle()
    }
    
    fileprivate func configureStyles() {
        backgroundColor = .primary
    }


    final fileprivate func updateTitle() {
      setAttributedTitle(bookmarkTag.tag(alignment: .center), for: [])
    }
}
