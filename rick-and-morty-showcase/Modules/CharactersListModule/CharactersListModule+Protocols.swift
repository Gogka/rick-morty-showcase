//
//  CharactersListModule+Protocols.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation

protocol CharactersListModuleInteractor {
    func reloadCharacters() async throws -> (characters: [CharactersListModule.Character], hasMore: Bool)
    func getMoreCharacters() async throws -> (characters: [CharactersListModule.Character], hasMore: Bool)
    func attach(output: CharactersListModule.InteractorOutput)
    func setCharacterStatus(isFavourite: Bool, forCharacter character: CharactersListModule.Character) async throws
}

protocol CharactersListModuleInteractorOutput: AnyObject {
    func characterFavouriteStatusWasChanged(isFavourite: Bool, forCharacterId id: Int)
    func charactersListWasUpdated()
}

protocol CharactersListModulePresenter {
    func attach(view: CharactersListModule.View)
    func didPullToRefresh()
    func tailWasDisplayed()
    func didTapReloadButton()
}

protocol CharactersListModuleRouter {
    func navigateToCharacterDetails(characterId: Int)
}

protocol CharactersListModuleView: AnyObject {
    func setReloadCharactersState(_ state: UIState<(characters: [CharactersListModule.CharacterVM], hasMore: Bool), String>)
    func setMoreCharactersState(_ state: UIState<(characters: [CharactersListModule.CharacterVM], hasMore: Bool), String>)
    func setCharacterStatus(isFavourite: Bool, forCharacterId id: Int)
}
