//
//  CharacterDetailsModule+SwiftUIViewController.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 25.03.24.
//

import Foundation
import Combine
import UIKit
import SwiftUI
import Kingfisher

extension CharacterDetailsModule {
    final class SwiftUIViewController: BaseHostingController<SwiftUIViewController.ControllerView> {
        private var cancellable = Set<AnyCancellable>()
        private lazy var favouriteButton = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: self,
            action: #selector(didTapFavouriteButton)
        )
        private let viewModel: ViewModel
        private(set) var favouriteSubscription: AnyCancellable?
        var presenter: Presenter?
        
        init() {
            let viewModel = ViewModel()
            self.viewModel = viewModel
            super.init(rootView: ControllerView(viewModel: viewModel))
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            preconditionFailure("Init with decoder is unavaialble")
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
            viewModel.reloadSubject
                .sink { [weak self] in
                    self?.presenter?.didTapReloadButton()
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

extension CharacterDetailsModule.SwiftUIViewController: CharacterDetailsModule.View {
    func setCharacterState(_ state: UIState<CharacterDetailsModule.CharacterVM, String>) {
        Task { @MainActor in
            viewModel.state = state
            switch state {
            case .failure:
                navigationItem.rightBarButtonItem = nil
            case .loading:
                navigationItem.rightBarButtonItem = nil
            case let .success(characterViewModel):
                navigationItem.title = characterViewModel.name
                navigationItem.rightBarButtonItem = favouriteButton
                favouriteSubscription = characterViewModel.$isFavourite
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

extension CharacterDetailsModule.SwiftUIViewController {
    fileprivate final class ViewModel: ObservableObject {
        @Published var state = UIState<CharacterDetailsModule.CharacterVM, String>.failure("")
        let reloadSubject = PassthroughSubject<Void, Never>()
    }
    
    struct ControllerView: SwiftUI.View {
        @ObservedObject fileprivate var viewModel: ViewModel
        var body: some View {
            VStack {
                switch viewModel.state {
                case let .failure(error):
                    ErrorView(error: error, subject: viewModel.reloadSubject)
                case .loading:
                    LoadingView()
                case let .success(character):
                    CharacterView(character: character)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarBackButtonHidden()
            .background(SwiftUI.Color.fromPalette(color: \.backgroundColor))
        }
    }
    
    private struct ErrorView: SwiftUI.View {
        let error: String
        let subject: PassthroughSubject<Void, Never>
        
        var body: some View {
            VStack {
                Spacer()
                Text(error)
                    .font(.fromPalette(font: \.body))
                    .foregroundStyle(SwiftUI.Color.fromPalette(color: \.bodyTextColor))
                    .multilineTextAlignment(.center)
                Button(String.fromPalette(string: \.tryAgainTitle), action: subject.send)
                    .foregroundStyle(SwiftUI.Color.fromPalette(color: \.bodyTextColor))
                Spacer()
            }
        }
    }
    
    private struct LoadingView: SwiftUI.View {
        var body: some View {
            VStack {
                Spacer()
                ProgressView()
                    .scaleEffect(2.0)
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
        }
    }
    
    private struct CharacterView: SwiftUI.View {
        let character: CharacterDetailsModule.CharacterVM
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    ImageSourceView(source: character.image)
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                    Group {
                        Text(character.name)
                            .foregroundStyle(SwiftUI.Color.fromPalette(color: \.headerTextColor))
                            .font(.fromPalette(font: \.header))
                        Text(character.type)
                            .foregroundStyle(SwiftUI.Color.fromPalette(color: \.bodyTextColor))
                            .font(.fromPalette(font: \.body))
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                }
            }
        }
    }
}
