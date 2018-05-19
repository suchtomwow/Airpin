//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

class BookmarkDetailsInteractor {
    enum Output {
        case signedIn, notSignedIn
    }

    func getAccountStatus(statusCallback: (BookmarkDetailsInteractor.Output) -> Void) {
        if NetworkClient.shared.pinboardAccount != nil {
            statusCallback(.signedIn)
        } else {
            statusCallback(.notSignedIn)
        }
    }
}
