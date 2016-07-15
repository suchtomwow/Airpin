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
    stackView.axis                                      = .horizontal
    stackView.spacing                                   = 10.0
    stackView.alignment                                 = .fill
    stackView.distribution                              = .fill

    return stackView
  }()
  
  lazy var verticalStackView: UIStackView = {
    let stackView                                       = UIStackView()

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis                                      = .vertical
    stackView.spacing                                   = 10.0
    stackView.alignment                                 = .fill
    stackView.distribution                              = .fill

    return stackView
  }()
  
  lazy var URLDateStackView: UIStackView = {
    let stackView  = UIStackView()
    stackView.axis = .horizontal
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
    
    verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
    verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
    verticalStackView.trailingAnchor.constraint(equalTo: disclosure.leadingAnchor, constant: -8).isActive = true
    verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    
    disclosure.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    disclosure.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    disclosure.widthAnchor.constraint(equalToConstant: 8).isActive = true
    disclosure.heightAnchor.constraint(equalToConstant: 13).isActive = true
  }
  
  override func configureStyles() {
    super.configureStyles()
    
    backgroundColor          = UIColor.white()
    title.backgroundColor    = UIColor.white()
    date.backgroundColor     = UIColor.white()
    subtitle.backgroundColor = UIColor.white()
    URL.backgroundColor      = UIColor.white()
    
    title.numberOfLines      = 2
    date.numberOfLines       = 1
    subtitle.numberOfLines   = 3

    disclosure.tintColor     = UIColor.tableViewAccent()
    disclosure.image         = Icon.Disclosure.image
  }
  
  private func resetContent() {
    tagStackView.subviews.forEach { $0.removeFromSuperview() }
  }
  
  func configureWithBookmark(_ bookmark: Bookmark) {
    resetContent() // According to docs, tableView(:cellForRowAtIndexPath:) should ALWAYS reset content. prepareForReuse() is not for this purpose.

    switch bookmark.readState {
    case .read:
      title.alpha    = 0.5
      subtitle.alpha = 0.5
    case .unread:
      title.alpha    = 1.0
      subtitle.alpha = 1.0
    }

    let titleString = bookmark.title.trim()
    let description = bookmark.desc.condense().trim()
    
    let datetime  = Formatter.humanTime.string(from: bookmark.datetime)
    
    for tag in bookmark.tagsArray {
      let tagButton = Tag(label: tag)
      tagStackView.addArrangedSubview(tagButton)
    }
    
    URL.attributedText      = bookmark.displayURL.caption(alignment: .left)
    date.attributedText     = datetime.caption(alignment: .right, color: UIColor.secondaryTextColor())
    title.attributedText    = titleString.headline(alignment: .left)
    subtitle.attributedText = description.subheadline(alignment: .left)
    tagStackView.addArrangedSubview(UIView())
    
    title.isHidden        = titleString.characters.count == 0
    subtitle.isHidden     = description.characters.count == 0
    tagStackView.isHidden = bookmark.tagsArray.count == 0
  }
}
