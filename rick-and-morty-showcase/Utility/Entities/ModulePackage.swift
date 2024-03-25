//
//  ModulePackage.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation
import UIKit

final class ModulePackage {
    enum Navigation {
        case present
        case push
        case root
    }
    let controller: UIViewController
    let navigation: Navigation
    init(controller: UIViewController, navigation: Navigation) {
        self.controller = controller
        self.navigation = navigation
    }
}
