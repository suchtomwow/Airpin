//
// Created by Thomas Carey on 6/2/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

class SignInAlertFactory {
    func makeSignInModal(message: String) -> AlertController {
        let body = message
        let buttonTitle = "Go to Settings"
        return AlertController(headline: nil, body: body, buttonTitle: buttonTitle)
    }
}
