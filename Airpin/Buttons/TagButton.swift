//
//  Tag.swift
//  Airpin
//
//  Created by Thomas Carey on 10/27/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class TagButton: UIButton {
    let bookmarkTag: BookmarkTag
    
    init(bookmarkTag: BookmarkTag) {
        self.bookmarkTag = bookmarkTag

        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        configureView()
        configureStyles()
    }
    
    func configureView() {
        contentEdgeInsets  = UIEdgeInsets(top: 3.0, left: 7.0, bottom: 4.0, right: 7.0)
        clipsToBounds      = true
        layer.cornerRadius = 2
        
        setAttributedTitle(bookmarkTag.tag(alignment: .center), for: [])
    }
    
    func configureStyles() {
        backgroundColor = .primary
    }
}
