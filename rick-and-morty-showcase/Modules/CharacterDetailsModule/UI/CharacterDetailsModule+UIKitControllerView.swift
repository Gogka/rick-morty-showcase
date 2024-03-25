//
//  CharacterDetailsModule+UIKitControllerView.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import UIKit
import Combine

extension CharacterDetailsModule.UIKitViewController {
    final class ControllerView: BaseUIKitView {
        private let contentView = VerticalScrollView<CharacterContentView>()
        private let errorView = CharacterErrorView()
        private let loadingView = CharacterLoadingView()
        // MARK: -
        func setCharacterState(_ state: UIState<CharacterDetailsModule.CharacterVM, String>) {
            switch state {
            case let .failure(error):
                errorView.setError(text: error)
                errorView.isHidden = false
                loadingView.isHidden = true
                loadingView.setAnimating(false)
                contentView.isHidden = true
            case .loading:
                errorView.isHidden = true
                loadingView.isHidden = false
                loadingView.setAnimating(true)
                contentView.isHidden = true
            case let .success(character):
                errorView.isHidden = true
                loadingView.isHidden = true
                loadingView.setAnimating(false)
                makeObject(contentView.contentView) {
                    $0.setNameView(text: character.name)
                    $0.setTypeView(text: character.type)
                    $0.setImageView(image: character.image)
                }
                contentView.isHidden = false
            }
        }
        func reloadButtonPublisher(forEvent event: UIControl.Event) -> AnyPublisher<UIButton, Never> {
            errorView.reloadButtonPublisher(forEvent: event)
        }
        // MARK: -
        override func setupStatic() {
            func install(view: UIView) {
                addSubview(view)
                view.snp.makeConstraints {
                    $0.left.right.top.bottom.equalTo(safeAreaLayoutGuide)
                }
            }
            install(view: errorView)
            install(view: loadingView)
            install(view: contentView)
            makeObject(contentView) {
                $0.contentView.setFavouriteButton(isHidden: true)
                $0.alwaysBounceVertical = true
                $0.showsVerticalScrollIndicator = false
            }
            backgroundColor = .fromPalette(color: \.backgroundColor)
        }
    }
}

private extension CharacterDetailsModule.UIKitViewController.ControllerView {
    typealias CharacterContentView = CharactersListModule.UIKitViewController.CharacterContentView
    typealias CharacterErrorView = CharactersListModule.UIKitViewController.CharacterErrorView
    typealias CharacterLoadingView = CharactersListModule.UIKitViewController.CharacterLoadingView
}
