//
//  CharacterDetailsModule+UIKitViewController.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import Foundation
import Combine
import UIKit

extension CharacterDetailsModule {
    final class UIKitViewController: BaseViewController {
        private lazy var controllerView = ControllerView()
        private var cancellable = Set<AnyCancellable>()
        private lazy var favouriteButton = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: self,
            action: #selector(didTapFavouriteButton)
        )
        private(set) var favouriteSubscription: AnyCancellable?
        var presenter: Presenter?
        
        override func loadView() {
            view = controllerView
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            assert(presenter != nil, "You need to specify presenter.")
            makeObject(backButton) {
                $0.tintColor = .fromPalette(color: \.bodyTextColor)
                navigationItem.leftBarButtonItem = $0
            }
            backButtonTapPublisher()
                .sink { [weak self] in
                    self?.presenter?.didTapBackButton()
                }
                .store(in: &cancellable)
            controllerView.reloadButtonPublisher(forEvent: .touchUpInside)
                .sink { [weak self] _ in
                    guard let self else { return }
                    presenter?.didTapReloadButton()
                }
                .store(in: &cancellable)
            favouriteButton.tintColor = .fromPalette(color: \.favouriteColor)
            presenter?.attach(view: self)
        }
        @objc
        private func didTapFavouriteButton() {
            presenter?.didTapChangeFavouriteStatus()
        }
    }
}

extension CharacterDetailsModule.UIKitViewController: CharacterDetailsModule.View {
    func setCharacterState(_ state: UIState<CharacterDetailsModule.CharacterVM, String>) {
        Task { @MainActor in
            controllerView.setCharacterState(state)
            switch state {
            case .failure:
                navigationItem.rightBarButtonItem = nil
            case .loading:
                navigationItem.rightBarButtonItem = nil
            case let .success(characterViewModel):
                navigationItem.title = characterViewModel.name
                navigationItem.rightBarButtonItem = favouriteButton
                favouriteSubscription = characterViewModel
                    .$isFavourite
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] isFavourite in
                    guard let self else { return }
                    favouriteButton.image = .fromPalette(
                        image: isFavourite ? \.heartFilledIcon : \.heartIcon
                    ).alwaysTemplate
                }
            }
        }
    }
}
