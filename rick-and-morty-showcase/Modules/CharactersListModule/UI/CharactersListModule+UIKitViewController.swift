//
//  CharactersListModule+UIKitViewController.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit
import Combine

extension CharactersListModule {
    final class UIKitViewController: BaseViewController {
        private lazy var controllerView = ControllerView()
        private lazy var handler = SingleSectionTableViewHandler<CharacterVM>()
            .setOnConfigureCell(CellView.self) { cell, item in
                cell.setNameView(text: item.name)
                cell.setTypeView(text: item.type)
                cell.setImageView(image: item.image)
                cell.setFavouritePublisher(item.$isFavourite.eraseToAnyPublisher())
                cell.setOnFavouriteButtonTap { [weak item] in
                    item?.didTapFavouriteButton()
                }
            }
            .setOnSelectRowAt { $0.onTap() }
            .setEstimatedHeight(100)
            .setAutomaticHeightDimension()
        private lazy var loadingHandler = SingleCellTableViewHandler<LoadingCellView>()
            .setTableViewHeight()
        private lazy var errorHandler = SingleCellTableViewHandler<ErrorCellView>()
            .setTableViewHeight()
        private lazy var noDataHandler = SingleCellTableViewHandler<NoDataView>()
            .setTableViewHeight()
        private var cancellable = Set<AnyCancellable>()
        private let refreshControl = UIRefreshControl()
        
        var presenter: Presenter?
        
        override func loadView() {
            view = controllerView
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            assert(presenter != nil, "You need to specify presenter.")
            makeObject(controllerView.tableView) {
                $0.register(CellView.self)
            }
            refreshControl
                .publisher(forEvent: .valueChanged)
                .sink { [weak self] _ in
                    guard let self else { return }
                    presenter?.didPullToRefresh()
                }
                .store(in: &cancellable)
            errorHandler.makeCell {
                $0.reloadButtonPublisher(forEvent: .touchUpInside)
                    .sink { [weak self] _ in
                        guard let self else { return }
                        presenter?.didTapReloadButton()
                    }
                    .store(in: &cancellable)
            }
            presenter?.attach(view: self)
        }
        private func setLastItemSubscribtion(isOn: Bool) {
            if isOn {
                handler.setOnWilLDisplayTail { [weak self] _, _, _ in
                    guard let self else { return }
                    presenter?.tailWasDisplayed()
                }
            } else {
                handler.setOnWilLDisplayCellForRowAt(nil)
            }
        }
    }
}

extension CharactersListModule.UIKitViewController: CharactersListModule.View {
    func setReloadCharactersState(_ state: UIState<(characters: [CharactersListModule.CharacterVM], hasMore: Bool), String>) {
        Task { @MainActor in
            switch state {
            case let .failure(error):
                errorHandler.makeCell { $0.setError(text: error) }
                setLastItemSubscribtion(isOn: false)
                controllerView.tableView.setHandler(errorHandler)
                controllerView.tableView.refreshControl = nil
            case .loading:
                setLastItemSubscribtion(isOn: false)
                controllerView.tableView.setHandler(loadingHandler)
                controllerView.tableView.refreshControl = nil
            case let .success((characters, hasMore)):
                handler.items = characters
                setLastItemSubscribtion(isOn: hasMore)
                if characters.isEmpty {
                    controllerView.tableView.setHandler(noDataHandler)
                } else {
                    controllerView.tableView.setHandler(handler)
                }
                controllerView.tableView.refreshControl = refreshControl
            }
            refreshControl.endRefreshing()
            controllerView.tableView.reloadData()
        }
    }
    
    func setMoreCharactersState(_ state: UIState<(characters: [CharactersListModule.CharacterVM], hasMore: Bool), String>) {
        Task { @MainActor in
            switch state {
            case .failure:
                setLastItemSubscribtion(isOn: false)
            case .loading:
                setLastItemSubscribtion(isOn: false)
            case let .success((characters, hasMore)):
                handler.items += characters
                setLastItemSubscribtion(isOn: hasMore)
                controllerView.tableView.setHandler(handler)
            }
            controllerView.tableView.reloadData()
        }
    }
    func setCharacterStatus(isFavourite: Bool, forCharacterId id: Int) {
        Task { @MainActor in
            handler.items.first { $0.id == id }?.setFavouriteStatus(isFavourite: isFavourite)
        }
    }
}

extension CharactersListModule.UIKitViewController {
    final class CharacterLoadingView: BaseUIKitView {
        private let activityIndicator = UIActivityIndicatorView(style: .large)
        func setAnimating(_ isOn: Bool) {
            isOn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
        
        override func setupStatic() {
            addSubview(activityIndicator)
            activityIndicator.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            backgroundColor = .fromPalette(color: \.backgroundColor)
        }
    }
    
    final class CharacterErrorView: BaseUIKitView {
        private let errorLabel = UILabel()
        private let reloadButton = UIButton()
        func setError(text: String) {
            errorLabel.text = text
        }
        func reloadButtonPublisher(forEvent event: UIControl.Event) -> AnyPublisher<UIButton, Never> {
            reloadButton.publisher(forEvent: event).eraseToAnyPublisher()
        }
        override func setupStatic() {
            let stackView = makeObject(UIStackView(arrangedSubviews: [errorLabel, reloadButton])) {
                $0.axis = .vertical
                $0.alignment = .center
            }
            addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(16).priority(999)
                $0.center.equalToSuperview()
            }
            makeObject(errorLabel) {
                $0.textColor = .fromPalette(color: \.bodyTextColor)
                $0.numberOfLines = 0
                $0.font = .fromPalette(font: \.body)
                $0.textAlignment = .center
            }
            makeObject(reloadButton) {
                $0.setTitle(.fromPalette(string: \.tryAgainTitle), for: .normal)
                $0.setTitleColor(.fromPalette(color: \.bodyTextColor), for: .normal)
            }
            backgroundColor = .fromPalette(color: \.backgroundColor)
        }
    }
    
    final class CharacterContentView: BaseUIKitView {
        private let nameView = UILabel()
        private let typeView = UILabel()
        private let imageView = UIImageView()
        private let favouriteButton = UIButton()
        private var favouriteButtonTapSubscription: AnyCancellable?
        private var favouriteChangesSubscription: AnyCancellable?
        private var onFavouriteTapAction: (() -> Void)?
        // MARK: -
        func setNameView(text: String) {
            nameView.text = text
        }
        func setTypeView(text: String) {
            typeView.text = text
        }
        func setImageView(image: ImageSource) {
            imageView.setImage(from: image)
        }
        func setFavouriteButton(isHidden: Bool) {
            favouriteButton.isHidden = isHidden
        }
        func setFavouritePublisher(_ publisher: AnyPublisher<Bool, Never>) {
            favouriteChangesSubscription = publisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isFavourite in
                    self?.favouriteButton.isSelected = isFavourite
            }
        }
        func setOnFavouriteButtonTap(_ action: @escaping () -> Void) {
            onFavouriteTapAction = action
        }
        override func setupStatic() {
            let labelsStackView = makeObject(UIStackView(arrangedSubviews: [nameView, typeView])) {
                $0.alignment = .leading
                $0.axis = .vertical
            }
            let bottomStackView = makeObject(UIStackView(arrangedSubviews: [labelsStackView, favouriteButton])) {
                $0.spacing = 8
                $0.alignment = .center
                $0.setContentHuggingPriority(.required, for: .vertical)
            }
            addSubview(imageView)
            addSubview(bottomStackView)
            imageView.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.height.equalTo(200).priority(999)
                $0.bottom.equalTo(bottomStackView.snp.top).offset(-8).priority(999)
            }
            bottomStackView.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(16).priority(999)
                $0.bottom.equalToSuperview().inset(8).priority(999)
            }
            makeObject(imageView) {
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
            }
            makeObject(nameView) {
                $0.font = .fromPalette(font: \.header)
                $0.textColor = .fromPalette(color: \.headerTextColor)
            }
            makeObject(typeView) {
                $0.font = .fromPalette(font: \.body)
                $0.textColor = .fromPalette(color: \.bodyTextColor)
            }
            makeObject(favouriteButton) {
                $0.setImage(.fromPalette(image: \.heartIcon), for: .normal)
                $0.setImage(.fromPalette(image: \.heartFilledIcon), for: .selected)
                $0.tintColor = .fromPalette(color: \.favouriteColor)
                favouriteButtonTapSubscription = $0.publisher(forEvent: .touchUpInside).sink { [weak self] _ in
                    self?.onFavouriteTapAction?()
                }
            }
            clipsToBounds = true
            backgroundColor = .fromPalette(color: \.backgroundColor)
        }
    }
}

private extension CharactersListModule.UIKitViewController {
    final class CellView: BaseUITableViewCell {
        private let innerContentView = ShadowView<CharacterContentView>()
        
        func setNameView(text: String) {
            innerContentView.contentView.setNameView(text: text)
        }
        func setTypeView(text: String) {
            innerContentView.contentView.setTypeView(text: text)
        }
        func setImageView(image: ImageSource) {
            innerContentView.contentView.setImageView(image: image)
        }
        func setFavouritePublisher(_ publisher: AnyPublisher<Bool, Never>) {
            innerContentView.contentView.setFavouritePublisher(publisher)
        }
        func setOnFavouriteButtonTap(_ action: @escaping () -> Void) {
            innerContentView.contentView.setOnFavouriteButtonTap(action)
        }
        override func setupStatic() {
            contentView.addSubview(innerContentView)
            innerContentView.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(16).priority(999)
                $0.top.bottom.equalToSuperview().inset(8).priority(999)
            }
            makeObject(innerContentView.contentView.layer) {
                $0.cornerRadius = 10
                $0.borderWidth = 1
            }
            makeObject(innerContentView.layer) {
                $0.shadowOpacity = 0.6
                $0.shadowOffset = .zero
                $0.shadowRadius = 5
            }
            contentView.backgroundColor = .fromPalette(color: \.backgroundColor)
            selectionStyle = .none
        }
        override func updateDynamicColors() {
            innerContentView.contentView.layer.borderColor = .fromPalette(color: \.borderColor)
            innerContentView.layer.shadowColor = .fromPalette(color: \.shadowColor)
        }
    }
    final class LoadingCellView: BaseUITableViewCell {
        private let loadingView = CharacterLoadingView()
        override func setupStatic() {
            contentView.addSubview(loadingView)
            loadingView.snp.makeConstraints {
                $0.left.right.bottom.top.equalToSuperview()
            }
            selectionStyle = .none
        }
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            loadingView.setAnimating(superview != nil)
        }
    }
    final class ErrorCellView: BaseUITableViewCell {
        private let errorView = CharacterErrorView()
        func setError(text: String) {
            errorView.setError(text: text)
        }
        func reloadButtonPublisher(forEvent event: UIControl.Event) -> AnyPublisher<UIButton, Never> {
            errorView.reloadButtonPublisher(forEvent: event)
        }
        override func setupStatic() {
            contentView.addSubview(errorView)
            errorView.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
            contentView.backgroundColor = .fromPalette(color: \.backgroundColor)
            selectionStyle = .none
        }
    }
    final class NoDataView: BaseUITableViewCell {
        private let noDataLabel = UILabel()
        override func setupStatic() {
            contentView.addSubview(noDataLabel)
            noDataLabel.snp.makeConstraints {
                $0.left.right.equalToSuperview().inset(16).priority(999)
                $0.center.equalToSuperview()
            }
            makeObject(noDataLabel) {
                $0.textColor = .fromPalette(color: \.bodyTextColor)
                $0.numberOfLines = 0
                $0.font = .fromPalette(font: \.body)
                $0.textAlignment = .center
                $0.text = .fromPalette(string: \.noDataTitle)
            }
            contentView.backgroundColor = .fromPalette(color: \.backgroundColor)
        }
    }
}
