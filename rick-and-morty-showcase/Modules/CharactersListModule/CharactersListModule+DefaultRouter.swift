//
//  CharactersListModule+DefaultRouter.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation

extension CharactersListModule {
    final class DefaultRouter: BaseRouter, Router {
        func navigateToCharacterDetails(characterId: Int) {
            let package = CharacterDetailsModule.Resolver(environment: environment).common(characterId: characterId)
            tryShow(package, animated: true)
        }
    }
}
