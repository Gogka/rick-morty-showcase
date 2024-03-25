//
//  UIWindow+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit

extension UIWindow {
    func setRootController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        rootViewController = controller
        guard animated else {
            completion?()
            return
        }
        UIView.transition(with: self, duration: 0.3, animations: nil, completion: { _ in completion?() })
    }
}
