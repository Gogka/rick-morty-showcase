//
//  CharacterDetailsModule+DefaultPresenter.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation

extension CharacterDetailsModule {
    final class DefaultPresenter: Presenter {
        private weak var view: View?
        private let interactor: Interactor
        private let router: Router
        private var characterViewModel: CharacterVM?
        private var favouriteChangingTask: Task<Void, Error>?
        init(interactor: Interactor, router: Router) {
            self.interactor = interactor
            self.router = router
            interactor.attach(output: self)
        }
        func attach(view: CharacterDetailsModule.View) {
            self.view = view
            reload()
        }
        func didTapReloadButton() {
            reload()
        }
        func didTapBackButton() {
            router.navigateBack()
        }
        func didTapChangeFavouriteStatus() {
            guard let characterViewModel, favouriteChangingTask == nil else { return }
            favouriteChangingTask = Task {
                let newStatus = !characterViewModel.isFavourite
                try await interactor.setFavouriteStatus(isFavourite: newStatus)
                characterViewModel.setFavouriteStatus(isFavourite: newStatus)
                favouriteChangingTask = nil
            }
        }
        // MARK: -
        private func reload() {
            Task {
                guard let view else { return }
                view.setCharacterState(.loading)
                do {
                    let character = try await interactor.getCharacter()
                    let viewModel = CharacterVM(character: character)
                    self.characterViewModel = viewModel
                    view.setCharacterState(.success(viewModel))
                } catch {
                    Logger.default.error("Error while getting character details. \(error, privacy: .public)")
                    view.setCharacterState(.failure(.fromPalette(string: \.defaultErrorText)))
                }
            }
        }
    }
}

extension CharacterDetailsModule.DefaultPresenter: CharacterDetailsModule.InteractorOutput {
    func characterFavouriteStatusWasChanged(isFavourite: Bool) {
        characterViewModel?.setFavouriteStatus(isFavourite: isFavourite)
    }
}
