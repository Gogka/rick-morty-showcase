//
//  CharacterDetailsModule+Protocols.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import Foundation

protocol CharacterDetailsModuleInteractor {
    func getCharacter() async throws -> CharacterDetailsModule.Character
    func attach(output: CharacterDetailsModule.InteractorOutput)
    func setFavouriteStatus(isFavourite: Bool) async throws
}

protocol CharacterDetailsModuleInteractorOutput: AnyObject {
    func characterFavouriteStatusWasChanged(isFavourite: Bool)
}

protocol CharacterDetailsModulePresenter {
    func attach(view: CharacterDetailsModule.View)
    func didTapReloadButton()
    func didTapBackButton()
    func didTapChangeFavouriteStatus()
}

protocol CharacterDetailsModuleRouter {
    func navigateBack()
}

protocol CharacterDetailsModuleView: AnyObject {
    func setCharacterState(_ state: UIState<CharacterDetailsModule.CharacterVM, String>)
}
