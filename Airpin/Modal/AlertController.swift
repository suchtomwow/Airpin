//
//  AlertController.swift
//  Airpin
//
//  Created by Thomas Carey on 7/20/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import UIKit

class AlertController: BaseViewController {

    let headline = UILabel()
    let body = UILabel()
    let button = UIButton()
    
    let strongTransitioningDelegate = ModalTransitioningDelegate()
    
    let buttonTappedHandler: ((_: UIButton?) -> Void)?
    
    init(headline: String?, body: String?, buttonTitle: String?, buttonTappedHandler: ((_: UIButton?) -> Void)?) {
        self.buttonTappedHandler = buttonTappedHandler

        super.init(nibName: nil, bundle: nil)
        
        self.headline.attributedText = headline?.headline(alignment: .center)
        self.body.attributedText     = body?.body(alignment: .center)
        self.button.setAttributedTitle(buttonTitle?.primaryButton(), for: [])
        
        modalPresentationStyle = .custom
        transitioningDelegate = strongTransitioningDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureConstraints()
    }
    
    override func configureView() {
        super.configureView()
        
        headline.setContentHuggingPriority(1000, for: .vertical)
        body.setContentHuggingPriority(1000, for: .vertical)
        
        headline.translatesAutoresizingMaskIntoConstraints = false
        body.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headline)
        view.addSubview(body)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func configureStyles() {
        super.configureStyles()
        
        view.backgroundColor = .white
        headline.numberOfLines = 0
        body.numberOfLines = 0
        button.backgroundColor = .primary
        
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
    }
    
    final private func configureConstraints() {
        NSLayoutConstraint.activate([
            headline.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            headline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 20),
            body.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            body.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func dismissAlert() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func buttonTapped(sender: UIButton?) {
        presentingViewController?.dismiss(animated: true) {
            self.buttonTappedHandler?(sender)
        }
    }
}
