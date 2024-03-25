//
//  ViewControllerHelper.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation
import UIKit
import Combine

protocol HelpedController: AnyObject {
    var helper: ViewControllerHelper { get }
}

typealias HelpedViewController = HelpedController & UIViewController

final class ViewControllerHelper {
    private(set) lazy var backButton = UIBarButtonItem(
        image: .fromPalette(image: \.arrowLeft).alwaysTemplate,
        style: .plain,
        target: self,
        action: #selector(didTapBackButton)
    )
    private lazy var tapSubject = PassthroughSubject<Void, Never>()
    
    func backButtonTapPublisher() -> AnyPublisher<Void, Never> {
        tapSubject.eraseToAnyPublisher()
    }
    
    func present(
        _ controller: UIViewController,
        afterTransitionIn rootController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        if let coordinator = rootController.transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { [weak self] _ in
                guard let self else { return }
                self.present(controller, afterTransitionIn: rootController, animated: animated, completion: completion)
            }
        } else {
            rootController.present(controller, animated: animated, completion: completion)
        }
    }
    
    func push(_ controller: UIViewController, navigationControllerHolder: UIViewController, animated: Bool) throws {
        guard let navController = (navigationControllerHolder as? UINavigationController) ?? navigationControllerHolder.navigationController else {
            throw DevError("No associated navigation controller for \(type(of: controller))")
        }
        navController.pushViewController(controller, animated: animated)
    }
    
    @objc
    private func didTapBackButton() {
        tapSubject.send(())
    }
}

extension HelpedController where Self: UIViewController {
    func presentAfterTransition(_ controller: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        helper.present(controller, afterTransitionIn: self, animated: animated, completion: completion)
    }
    func push(_ controller: UIViewController, animated: Bool) throws {
        try helper.push(controller, navigationControllerHolder: self, animated: animated)
    }
}
extension HelpedController {
    var backButton: UIBarButtonItem { helper.backButton }
    func backButtonTapPublisher() -> AnyPublisher<Void, Never> {
        helper.backButtonTapPublisher()
    }
}
