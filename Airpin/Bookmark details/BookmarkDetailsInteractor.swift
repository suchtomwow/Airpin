//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

class BookmarkDetailsInteractor {
    let accountStatusUseCase = AccountStatusUseCase()

    func getAccountStatus(statusCallback: (AccountStatusOutput) -> Void) {
        accountStatusUseCase.getAccountStatus(statusCallback: statusCallback)
    }
}
