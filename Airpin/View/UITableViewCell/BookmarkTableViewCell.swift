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
  
  var vConstraints: [NSLayoutConstraint]!
  
  lazy var tagStackView: UIStackView = {
    let view                                       = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis                                      = .Horizontal
    view.spacing                                   = 8.0
    view.alignment                                 = .Fill
    view.distribution                              = .Fill
    return view
  }()
  
  override func configureView() {
    super.configureView()
    
    title.translatesAutoresizingMaskIntoConstraints    = false
    date.translatesAutoresizingMaskIntoConstraints     = false
    subtitle.translatesAutoresizingMaskIntoConstraints = false
    URL.translatesAutoresizingMaskIntoConstraints      = false
    
    contentView.addSubview(title)
    contentView.addSubview(date)
    contentView.addSubview(subtitle)
    contentView.addSubview(URL)
    contentView.addSubview(tagStackView)
  }
  
  override func configureConstraints() {
    super.configureConstraints()
    
    NSLayoutConstraint(item: URL, attribute: .Leading, relatedBy: .Equal, toItem: contentView, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: URL, attribute: .Trailing, relatedBy: .Equal, toItem: date, attribute: .Leading, multiplier: 1.0, constant: -3.0).active = true
    NSLayoutConstraint(item: title, attribute: .Leading, relatedBy: .Equal, toItem: contentView, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: title, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .TrailingMargin, multiplier: 1.0, constant: -3.0).active = true
    NSLayoutConstraint(item: date, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: date, attribute: .Baseline, relatedBy: .Equal, toItem: URL, attribute: .Baseline, multiplier: 1.0, constant: 0.0).active = true
    
    NSLayoutConstraint(item: subtitle, attribute: .Leading, relatedBy: .Equal, toItem: contentView, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: subtitle, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: tagStackView, attribute: .Leading, relatedBy: .Equal, toItem: contentView, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: tagStackView, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0).active = true
    
    date.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
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
    
//    title.backgroundColor = .greenColor()
//    date.backgroundColor = .purpleColor()
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

    let link = NSURL(string: bookmark.url.trim())!
    let displayURL = link.host!

    let titleString = bookmark.title.trim()
    let description = bookmark.desc.condense().trim()
    
    let datetime  = Formatter.humanTime.stringFromDate(bookmark.datetime)
    
    for tag in bookmark.tagsArray {
      let tagButton = Tag(data: tag)
      tagStackView.addArrangedSubview(tagButton)
    }
    
    URL.text      = displayURL
    date.text     = datetime
    title.text    = titleString
    subtitle.text = description
    tagStackView.addArrangedSubview(UIView())
    
    refreshVerticalConstraints(hasTitle: titleString.characters.count > 0, hasDescription: description.characters.count > 0, hasTags: bookmark.tagsArray.count > 0)
  }
  
  private func refreshVerticalConstraints(hasTitle hasTitle: Bool, hasDescription: Bool, hasTags: Bool) {
    if let vConstraints = vConstraints {
      NSLayoutConstraint.deactivateConstraints(vConstraints)
    }
    
    let metrics = ["vSpace": 8.0, "interItem": 6.0]
    let views = ["URL": URL, "title": title, "description": subtitle, "tags": tagStackView]
    var constraints = "V:|-vSpace-[URL]"
    
    if hasTitle {
      constraints += "-interItem-[title]"
    }
    
    if hasDescription {
      constraints += "-interItem-[description]"
    }
    
    if hasTags {
      constraints += "-interItem-[tags]"
    }
    
    constraints += "-vSpace-|"
    
    vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(constraints, options: [], metrics: metrics, views: views)
    
    NSLayoutConstraint.activateConstraints(vConstraints)
  }
}