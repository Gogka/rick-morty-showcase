//
//  CharactersListModule+FullListInteractor.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation
import Combine

extension CharactersListModule {
    final class FullListInteractor: BaseInteractor, Interactor {
        private let loader: Loader
        @MainActor private var favouritesIds = Set<Int>()
        @MainActor private var page: Int? = 1
        
        init(loader: Loader, favouritesService: FavouritesCharactersService) {
            self.loader = loader
            super.init(favouritesService: favouritesService)
            Task { @MainActor in
                do {
                    favouritesIds = try await favouritesService.getAllFavouriteCharacters()
                        .reduce(into: Set<Int>()) { $0.insert($1.id) }
                } catch {
                    Logger.default.error("Couldn't get favourite ids. \(error)")
                }
            }
        }
        func reloadCharacters() async throws -> (characters: [CharactersListModule.Character], hasMore: Bool) {
            await MainActor.run { page = 1 }
            return try await processCharacters(page: await page!)
        }
        func getMoreCharacters() async throws -> (characters: [CharactersListModule.Character], hasMore: Bool) {
            guard let page = await page else { throw DevError("No more data") }
            return try await processCharacters(page: page)
        }
        
        override func didGetFavouritesChange(_ changes: FavouritesCharactersServiceChange) {
            super.didGetFavouritesChange(changes)
            Task { @MainActor in
                switch changes.action {
                case .add:
                    self.favouritesIds.insert(changes.character.id)
                case .delete:
                    self.favouritesIds.remove(changes.character.id)
                }
            }
        }
        // MARK: -
        private func processCharacters(page: Int) async throws -> (characters: [CharactersListModule.Character], hasMore: Bool) {
            let response = try await loader.execute(CharactersListRequest(page: page))
                .checkStatus()
                .getSuccessfullResponse()
            let characters = try await map(response.results)
            let nextPage = page + 1
            return await MainActor.run {
                self.page = nextPage <= response.info.pages ? nextPage : nil
                return (characters, self.page != nil)
            }
        }
        private func map(_ characters: [CharactersListRequest.SuccessfullResponse.Character]) async throws -> [Character] {
            let ids = await favouritesIds
            return characters.map {
                .init(character: $0, isFavourite: ids.contains($0.id))
            }
        }
    }
}
