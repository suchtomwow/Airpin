//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

enum AccountStatusOutput {
    case signedIn, notSignedIn
}

class AccountStatusUseCase {
    func getAccountStatus(statusCallback: (AccountStatusOutput) -> Void) {
        if NetworkClient.shared.pinboardAccount != nil {
            statusCallback(.signedIn)
        } else {
            statusCallback(.notSignedIn)
        }
    }
}
