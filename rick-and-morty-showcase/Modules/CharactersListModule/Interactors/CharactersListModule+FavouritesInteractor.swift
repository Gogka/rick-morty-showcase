//
//  CharactersListModule+FavouritesInteractor.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import Foundation
import Combine

extension CharactersListModule {
    final class FavouritesInteractor: BaseInteractor, Interactor {
        func reloadCharacters() async throws -> (characters: [CharactersListModule.Character], hasMore: Bool) {
            let characters = try await favouritesService.getAllFavouriteCharacters().map {
                Character(character: $0, isFavourite: true)
            }
            return (characters, false)
        }
        func getMoreCharacters() async throws -> (characters: [CharactersListModule.Character], hasMore: Bool) {
            throw DevError("No more data.")
        }
        override func didGetFavouritesChange(_ changes: FavouritesCharactersServiceChange) {
            if changes.action == .add {
                output?.charactersListWasUpdated()
            } else {
                super.didGetFavouritesChange(changes)
            }
        }
    }
}
