//
//  BookmarkTableViewCell.swift
//  Airpin
//
//  Created by Thomas Carey on 10/27/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: BLSTableViewCell {
  let title    = UILabel()
  let date     = UILabel()
  let subtitle = UILabel()
  let URL      = UILabel()
  
  lazy var tagStackView: UIStackView = {
    let stackView                                       = UIStackView()

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis                                      = .Horizontal
    stackView.spacing                                   = 10.0
    stackView.alignment                                 = .Fill
    stackView.distribution                              = .Fill

    return stackView
  }()
  
  lazy var verticalStackView: UIStackView = {
    let stackView                                       = UIStackView()

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis                                      = .Vertical
    stackView.spacing                                   = 10.0
    stackView.alignment                                 = .Fill
    stackView.distribution                              = .Fill

    return stackView
  }()
  
  lazy var URLDateStackView: UIStackView = {
    let stackView  = UIStackView()
    stackView.axis = .Horizontal
    return stackView
  }()

  lazy var disclosure: UIImageView = {
    let imageView = UIImageView()
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(imageView)
    
    return imageView
  }()
  
  override func configureView() {
    super.configureView()
    
    URLDateStackView.addArrangedSubview(URL)
    URLDateStackView.addArrangedSubview(date)
    
    contentView.addSubview(verticalStackView)
    
    verticalStackView.addArrangedSubview(URLDateStackView)
    verticalStackView.addArrangedSubview(title)
    verticalStackView.addArrangedSubview(subtitle)
    verticalStackView.addArrangedSubview(tagStackView)
  }
  
  override func configureConstraints() {
    super.configureConstraints()
    
    verticalStackView.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: 20).active = true
    verticalStackView.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: 20).active = true
    verticalStackView.trailingAnchor.constraintEqualToAnchor(disclosure.leadingAnchor, constant: -8).active = true
    verticalStackView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -20).active = true
    
    disclosure.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: -12).active = true
    disclosure.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
    disclosure.widthAnchor.constraintEqualToConstant(8).active = true
    disclosure.heightAnchor.constraintEqualToConstant(13).active = true
  }
  
  override func configureStyles() {
    super.configureStyles()
    
    backgroundColor          = UIColor.whiteColor()
    title.backgroundColor    = UIColor.whiteColor()
    date.backgroundColor     = UIColor.whiteColor()
    subtitle.backgroundColor = UIColor.whiteColor()
    URL.backgroundColor      = UIColor.whiteColor()
    
    title.numberOfLines      = 2
    date.numberOfLines       = 1
    subtitle.numberOfLines   = 3

    disclosure.tintColor     = UIColor.tableViewAccent()
    disclosure.image         = Icon.Disclosure.image
  }
  
  private func resetContent() {
    tagStackView.subviews.forEach { $0.removeFromSuperview() }
  }
  
  func configureWithBookmark(bookmark: Bookmark) {
    resetContent() // According to docs, tableView(:cellForRowAtIndexPath:) should ALWAYS reset content. prepareForReuse() is not for this purpose.

    switch bookmark.readState {
    case .Read:
      title.alpha    = 0.5
      subtitle.alpha = 0.5
    case .Unread:
      title.alpha    = 1.0
      subtitle.alpha = 1.0
    }

    let titleString = bookmark.title.trim()
    let description = bookmark.desc.condense().trim()
    
    let datetime  = Formatter.humanTime.stringFromDate(bookmark.datetime)
    
    for tag in bookmark.tagsArray {
      let tagButton = Tag(label: tag)
      tagStackView.addArrangedSubview(tagButton)
    }
    
    URL.attributedText      = bookmark.displayURL.caption(alignment: .Left)
    date.attributedText     = datetime.caption(alignment: .Right, color: UIColor.secondaryTextColor())
    title.attributedText    = titleString.headline(alignment: .Left)
    subtitle.attributedText = description.subheadline(alignment: .Left)
    tagStackView.addArrangedSubview(UIView())
    
    title.hidden        = titleString.characters.count == 0
    subtitle.hidden     = description.characters.count == 0
    tagStackView.hidden = bookmark.tagsArray.count == 0
  }
}