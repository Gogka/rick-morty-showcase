//
//  CharactersListModule+BaseInteractor.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import Foundation
import Combine

extension CharactersListModule {
    class BaseInteractor {
        let favouritesService: FavouritesCharactersService
        private(set) weak var output: InteractorOutput?
        private var favouriteStateSubscription: AnyCancellable?
        init(favouritesService: FavouritesCharactersService) {
            self.favouritesService = favouritesService
            subscribe()
        }
        final func attach(output: CharactersListModule.InteractorOutput) {
            self.output = output
        }
        final func setCharacterStatus(isFavourite: Bool, forCharacter character: CharactersListModule.Character) async throws {
            if isFavourite {
                try await favouritesService.save(character: character.character, sender: self)
            } else {
                try await favouritesService.deleteCharacter(character.character, sender: self)
            }
        }
        func didGetFavouritesChange(_ changes: FavouritesCharactersServiceChange) {
            output?.characterFavouriteStatusWasChanged(isFavourite: changes.action == .add, forCharacterId: changes.character.id)
        }
        // MARK: -
        private func subscribe() {
            favouriteStateSubscription = favouritesService.chagesPublisher.sink { [weak self] changes in
                guard let self, changes.senderObject !== self else { return }
                didGetFavouritesChange(changes)
            }
        }
    }
}
