//
//  CharacterDetailsModule.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import UIKit

enum CharacterDetailsModule {
    final class Resolver {
        private let environment: ModuleEnvironment
        init(environment: ModuleEnvironment) {
            self.environment = environment
        }
        func common(characterId: Int) -> ModulePackage {
            if ProcessInfo.processInfo.isSwiftUIEnabled {
                return swiftui(characterId: characterId)
            } else {
                return uikit(characterId: characterId)
            }
        }
        private func swiftui(characterId: Int) -> ModulePackage {
            let controller = SwiftUIViewController()
            let interactor = DefaultInteractor(
                characterId: characterId,
                loader: environment.loader,
                favouritesService: environment.favouritesCharactersService
            )
            let router = DefaultRouter(environment: environment, controller: controller)
            let presenter = DefaultPresenter(interactor: interactor, router: router)
            controller.presenter = presenter
            return ModulePackage(controller: controller, navigation: .push)
        }
        private func uikit(characterId: Int) -> ModulePackage {
            let controller = UIKitViewController()
            let interactor = DefaultInteractor(
                characterId: characterId,
                loader: environment.loader,
                favouritesService: environment.favouritesCharactersService
            )
            let router = DefaultRouter(environment: environment, controller: controller)
            let presenter = DefaultPresenter(interactor: interactor, router: router)
            controller.presenter = presenter
            return ModulePackage(controller: controller, navigation: .push)
        }
    }
}

extension CharacterDetailsModule {
    typealias View = CharacterDetailsModuleView
    typealias Presenter = CharacterDetailsModulePresenter
    typealias Router = CharacterDetailsModuleRouter
    typealias Interactor = CharacterDetailsModuleInteractor
    typealias InteractorOutput = CharacterDetailsModuleInteractorOutput
    typealias Character = CharactersListModule.Character
    
    final class CharacterVM {
        private var character: Character
        @Published private(set) var isFavourite: Bool
        var name: String { character.name }
        var type: String { character.type }
        var image: ImageSource { .remote(character.image) }
        init(character: Character) {
            self.character = character
            self.isFavourite = character.isFavourite
        }
        func setFavouriteStatus(isFavourite: Bool) {
            character.isFavourite = isFavourite
            self.isFavourite = isFavourite
        }
    }
}
