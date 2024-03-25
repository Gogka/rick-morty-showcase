//
//  CharacterDetailsModule+DefaultInteractor.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation
import Combine

extension CharacterDetailsModule {
    final class DefaultInteractor: Interactor {
        private let loader: Loader
        private let characterId: Int
        private weak var output: InteractorOutput?
        private var favouriteSubscription: AnyCancellable?
        private let favouritesService: FavouritesCharactersService
        private var cachedCharacter: CharacterDetailsRequest.SuccessfullResponse?
        init(characterId: Int, loader: Loader, favouritesService: FavouritesCharactersService) {
            self.characterId = characterId
            self.loader = loader
            self.favouritesService = favouritesService
            subscribe()
        }
        func attach(output: CharacterDetailsModule.InteractorOutput) {
            self.output = output
        }
        func getCharacter() async throws -> CharacterDetailsModule.Character {
            let character = try await loader.execute(CharacterDetailsRequest(characterId: characterId))
                .checkStatus()
                .getSuccessfullResponse()
            cachedCharacter = character
            let isFavourite = try await favouritesService.isCharacterFavourite(id: characterId)
            return Character(character: character, isFavourite: isFavourite)
        }
        func setFavouriteStatus(isFavourite: Bool) async throws {
            guard let cachedCharacter else { throw DevError("Not enough data to save.") }
            if isFavourite {
                try await favouritesService.save(character: cachedCharacter, sender: self)
            } else {
                try await favouritesService.deleteCharacter(cachedCharacter, sender: self)
            }
        }
        // MARK: -
        private func subscribe() {
            favouriteSubscription = favouritesService.chagesPublisher.sink { [weak self] changes in
                guard let self,
                      let output,
                      changes.senderObject !== self,
                      changes.character.id == characterId
                else { return }
                output.characterFavouriteStatusWasChanged(isFavourite: changes.action == .add)
            }
        }
    }
}
