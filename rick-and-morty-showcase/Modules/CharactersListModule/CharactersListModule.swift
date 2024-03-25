//
//  CharactersListModule.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit

enum CharactersListModule {
    final class Resolver {
        typealias ModulePackage = UIViewController
        private let environment: ModuleEnvironment
        init(environment: ModuleEnvironment) {
            self.environment = environment
        }
        
        func fullList() -> ModulePackage {
            let controller = makeObject(UIKitViewController()) {
                $0.title = .fromPalette(string: \.fullListTabTitle)
                $0.tabBarItem.map {
                    $0.image = .fromPalette(image: \.fullListNotSelectedTabIcon)
                    $0.selectedImage = .fromPalette(image: \.fullListSelectedTabIcon)
                }
            }
            let navController = controller.wrapToNavController()
            let interactor = FullListInteractor(
                loader: environment.loader,
                favouritesService: environment.favouritesCharactersService
            )
            let router = DefaultRouter(environment: environment, controller: navController)
            let presenter = DefaultPresenter(interactor: interactor, router: router)
            controller.presenter = presenter
            return navController
        }
        
        func favouritesList() -> ModulePackage {
            let controller = makeObject(UIKitViewController()) {
                $0.title = .fromPalette(string: \.favouritesListTabTitle)
                $0.tabBarItem.map {
                    $0.image = .fromPalette(image: \.heartIcon)
                    $0.selectedImage = .fromPalette(image: \.heartFilledIcon)
                }
            }
            let navController = controller.wrapToNavController()
            let interactor = FavouritesInteractor(favouritesService: environment.favouritesCharactersService)
            let router = DefaultRouter(environment: environment, controller: navController)
            let presenter = DefaultPresenter(interactor: interactor, router: router)
            controller.presenter = presenter
            return navController
        }
    }
}

extension CharactersListModule {
    typealias View = CharactersListModuleView
    typealias Presenter = CharactersListModulePresenter
    typealias Router = CharactersListModuleRouter
    typealias Interactor = CharactersListModuleInteractor
    typealias InteractorOutput = CharactersListModuleInteractorOutput
    
    final class Character {
        let character: CharactersListRequest.SuccessfullResponse.Character
        var isFavourite: Bool
        var id: Int { character.id }
        var name: String { character.name }
        var type: String { character.type }
        var image: URL { character.image }
        init(
            character: CharactersListRequest.SuccessfullResponse.Character,
            isFavourite: Bool
        ) {
            self.character = character
            self.isFavourite = isFavourite
        }
    }
    
    final class CharacterVM: ObservableObject {
        private let character: Character
        private let onFavouriteTap: (CharacterVM) -> Void
        var id: Int { character.id }
        @Published private(set) var isFavourite: Bool
        var name: String { character.name }
        var type: String { character.type }
        var image: ImageSource { .remote(character.image) }
        let onTap: () -> Void
        init(
            character: Character,
            onTap: @escaping () -> Void,
            onFavouriteTap: @escaping (CharacterVM) -> Void
        ) {
            self.character = character
            self.onTap = onTap
            self.onFavouriteTap = onFavouriteTap
            isFavourite = character.isFavourite
        }
        func didTapFavouriteButton() {
            onFavouriteTap(self)
        }
        func setFavouriteStatus(isFavourite: Bool) {
            character.isFavourite = isFavourite
            self.isFavourite = isFavourite
        }
    }
}
