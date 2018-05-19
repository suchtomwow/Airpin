//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

class SettingsCoordinatorFactory {
    func makeSettingsCoordinator() -> SettingsCoordinator {
        return SettingsCoordinator(settingsControllerFactory: SettingsControllerFactory())
    }
}
