//
//  BookmarkTableViewCell.swift
//  Airpin
//
//  Created by Thomas Carey on 10/27/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: BLSTableViewCell {
  override class var ReuseIdentifier: String {
    return "BookmarkTableViewCell"
  }
  
  let title    = UILabel()
  let date     = UILabel()
  let subtitle = UILabel()
  let URL      = UILabel()
  
  lazy var contentStackView: UIStackView = {
    let view = UIStackView()
    view.axis = .Vertical
    view.spacing = 3.0
    view.alignment = .Top
    view.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(view)
    
    return view
  }()
  
  lazy var tagStackView: UIStackView = {
    let view = UIStackView()
    view.axis = .Horizontal
    view.spacing = 8.0
    view.alignment = .Fill
    view.distribution = .Fill
    return view
  }()
  
  lazy var topRowStackView: UIStackView = {
    let view          = UIStackView()
    view.axis         = .Horizontal
    view.spacing      = 2.0
    view.alignment    = .Top
//    view.alignment    = .Fill
    view.distribution = .EqualCentering
    
    return view
  }()
  
  override func configureView() {
    super.configureView()
    
    contentStackView.addArrangedSubview(topRowStackView)
    contentStackView.addArrangedSubview(subtitle)
    contentStackView.addArrangedSubview(URL)
    contentStackView.addArrangedSubview(tagStackView)
    
    topRowStackView.addArrangedSubview(title)
    topRowStackView.addArrangedSubview(date)
  }
  
  override func configureConstraints() {
    super.configureConstraints()
    
    
    NSLayoutConstraint(item: contentStackView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .TopMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: contentStackView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: contentStackView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .LeftMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: contentStackView, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .RightMargin, multiplier: 1.0, constant: 0.0).active = true
  }
  
  override func configureStyles() {
    super.configureStyles()
    
    title.numberOfLines    = 2
    date.numberOfLines     = 1
    subtitle.numberOfLines = 3

    title.font             = UIFont.headline.medium
    date.font              = UIFont.caption1.light
    subtitle.font          = UIFont.caption1
    URL.font               = UIFont.caption1.ultraLight

    title.textAlignment    = .Left
    subtitle.textAlignment = .Left
    URL.textAlignment      = .Left
    date.textAlignment     = .Right

    date.textColor         = UIColor.secondaryTextColor()
    subtitle.textColor     = UIColor.primaryTextColor()
    URL.textColor          = UIColor.secondaryTextColor()
    
    accessoryType          = .DisclosureIndicator
    
    topRowStackView.backgroundColor = .redColor()
    title.backgroundColor = .greenColor()
    date.backgroundColor = .purpleColor()
  }
  
  private func resetContent() {
    tagStackView.subviews.forEach { $0.removeFromSuperview() }
  }
  
  func configureWithBookmark(bookmark: Bookmark) {
    resetContent() // According to docs, tableView(:cellForRowAtIndexPath:) should ALWAYS reset content. prepareForReuse() is not for this purpose.

    switch bookmark.readState {
    case .Read:
      title.textColor = UIColor.tertiaryTextColor()
    case .Unread:
      title.textColor = UIColor.primaryTextColor()
    }

    let link = NSURL(string: bookmark.url/*.trim()*/)!
    let displayURL = link.host!
    
    let datetime  = Formatter.humanTime.stringFromDate(bookmark.datetime)
    
    for tag in bookmark.tagsArray {
      let tagButton = Tag(data: tag)
      tagStackView.addArrangedSubview(tagButton)
    }
    
    title.text    = bookmark.title.trim()
    date.text     = datetime
    subtitle.text = bookmark.desc.condense().trim()
    URL.text      = displayURL
    tagStackView.addArrangedSubview(UIView())
  }
}