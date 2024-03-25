//
//  UIViewController+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit

extension UIViewController {
    func wrapToNavController() -> BaseNavigationController {
        BaseNavigationController(rootViewController: self)
    }
    func pop(animated: Bool) {
        ((self as? UINavigationController) ?? navigationController)?.popViewController(animated: animated)
    }
}
