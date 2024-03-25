//
//  CharacterDetailsModule+DefaultRouter.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation

extension CharacterDetailsModule {
    final class DefaultRouter: BaseRouter, Router {
        func navigateBack() {
            controller?.pop(animated: true)
        }
    }
}
