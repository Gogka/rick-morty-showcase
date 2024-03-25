//
//  CharactersListModule+DefaultPresenter.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation

extension CharactersListModule {
    final class DefaultPresenter: Presenter {
        private weak var view: View?
        private let interactor: Interactor
        private let router: Router
        init(interactor: Interactor, router: Router) {
            self.interactor = interactor
            self.router = router
            interactor.attach(output: self)
        }
        func attach(view: CharactersListModule.View) {
            self.view = view
            reload()
        }
        func didPullToRefresh() {
            Task {
                do {
                    let (characters, hasMore) = try await interactor.reloadCharacters()
                    view?.setReloadCharactersState(.success((map(characters), hasMore)))
                } catch {
                    Logger.default.error("Error while reloading characters. \(error)")
                }
            }
        }
        func tailWasDisplayed() {
            Task {
                guard let view else { return }
                do {
                    view.setMoreCharactersState(.loading)
                    let (characters, hasMore) = try await interactor.getMoreCharacters()
                    view.setMoreCharactersState(.success((map(characters), hasMore)))
                } catch {
                    Logger.default.error("Error while getting more characters. \(error)")
                    view.setMoreCharactersState(.failure(.fromPalette(string: \.defaultErrorText)))
                }
            }
        }
        func didTapReloadButton() {
            reload()
        }
        // MARK: -
        private func reload() {
            Task {
                guard let view else { return }
                do {
                    view.setReloadCharactersState(.loading)
                    let (characters, hasMore) = try await interactor.reloadCharacters()
                    view.setReloadCharactersState(.success((map(characters), hasMore)))
                } catch {
                    Logger.default.error("Error while loading characters.")
                    view.setReloadCharactersState(.failure(.fromPalette(string: \.defaultErrorText)))
                }
            }
        }
        private func map(_ characters: [Character]) -> [CharacterVM] {
            characters.map { character in
                CharacterVM(
                    character: character,
                    onTap: { [weak self] in
                        guard let self else { return }
                        router.navigateToCharacterDetails(characterId: character.id)
                    },
                    onFavouriteTap: { [weak self] viewModel in
                        guard let self else { return }
                        setFavouriteStatus(!viewModel.isFavourite, viewModel: viewModel, character: character)
                    }
                )
            }
        }
        private func setFavouriteStatus(_ isFavourite: Bool, viewModel: CharacterVM, character: Character) {
            Task {
                do {
                    try await interactor.setCharacterStatus(isFavourite: isFavourite, forCharacter: character)
                    viewModel.setFavouriteStatus(isFavourite: isFavourite)
                } catch {
                    Logger.default.error("Error while changing status for \(character.name).")
                }
            }
        }
    }
}

extension CharactersListModule.DefaultPresenter: CharactersListModule.InteractorOutput {
    func characterFavouriteStatusWasChanged(isFavourite: Bool, forCharacterId id: Int) {
        view?.setCharacterStatus(isFavourite: isFavourite, forCharacterId: id)
    }
    func charactersListWasUpdated() {
        reload()
    }
}
