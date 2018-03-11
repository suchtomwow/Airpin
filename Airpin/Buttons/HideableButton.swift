//
//  HideableButton.swift
//  Airpin
//
//  Created by Thomas Carey on 1/1/17.
//  Copyright © 2017 Thomas Carey. All rights reserved.
//

import UIKit

@objc protocol HideableButtonDelegate: class {
    @objc optional func buttonTapped(button: UIView)
    @objc optional func buttonDidHide(button: UIView)
}

class HideableButton: UIView {

    /*
     ---------------------------------
     | Paste link from clipboard | X |
     ---------------------------------
     */

    private let leftButton = UIButton(type: .custom)
    private let div = UIView()
    private let hideButton = UIButton(type: .custom)

    weak var delegate: HideableButtonDelegate?

    init(title: String) {
        super.init(frame: .zero)

        commonInit(with: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    final private func commonInit(with title: String?) {
        configureView()
        configureLeftButton(with: title)
        configureDiv()
        configureHideButton()
    }

    final private func configureView() {
        layer.cornerRadius = 4
        backgroundColor = .primary

        leftButton.addTarget(self, action: #selector(HideableButton.leftButtonTapped(sender:)), for: .touchUpInside)
        hideButton.addTarget(self, action: #selector(HideableButton.hideButtonTapped(sender:)), for: .touchUpInside)
    }

    final private func configureLeftButton(with title: String?) {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftButton)

        leftButton.backgroundColor = .clear
        leftButton.setTitleColor(.white, for: .normal)
        leftButton.setTitle(title, for: .normal)

        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            leftButton.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }

    final private func configureDiv() {
        div.translatesAutoresizingMaskIntoConstraints = false
        addSubview(div)

        div.backgroundColor = .white

        NSLayoutConstraint.activate([
            div.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 10),
            div.topAnchor.constraint(equalTo: leftButton.topAnchor, constant: 4),
            div.bottomAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: -4),
            div.widthAnchor.constraint(equalToConstant: 1)
        ])
    }

    final private func configureHideButton() {
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hideButton)

        hideButton.backgroundColor = .clear
        hideButton.setImage(Icon.x.image, for: .normal)
        hideButton.tintColor = .primary

        NSLayoutConstraint.activate([
            hideButton.topAnchor.constraint(equalTo: leftButton.topAnchor),
            hideButton.leadingAnchor.constraint(equalTo: div.leadingAnchor, constant: 10),
            hideButton.bottomAnchor.constraint(equalTo: leftButton.bottomAnchor),
            hideButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    @objc func leftButtonTapped(sender: UIButton) {
        delegate?.buttonTapped?(button: self)
    }

    @objc func hideButtonTapped(sender: UIButton) {
        UIView.animate(withDuration: 0.33, animations: { 
            self.alpha = 0.0
        }) { completed in
            self.delegate?.buttonDidHide?(button: self)
        }
    }
}
