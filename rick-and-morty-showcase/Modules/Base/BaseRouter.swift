//
//  BaseRouter.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation

class BaseRouter {
    let environment: ModuleEnvironment
    private(set) weak var controller: HelpedViewController?
    
    init(environment: ModuleEnvironment, controller: HelpedViewController) {
        self.environment = environment
        self.controller = controller
    }
    
    func show(_ package: ModulePackage, animated: Bool, completion: (() -> Void)? = nil) throws {
        guard let controller else {
            throw DevError("Undefined router controller.")
        }
        switch package.navigation {
        case .present:
            controller.presentAfterTransition(package.controller, animated: animated, completion: completion)
        case .push:
            try controller.push(package.controller, animated: animated)
            completion?()
        case .root:
            guard let window = environment.scene.keyWindow else {
                throw DevError("Undefined key window for the root transition.")
            }
            window.setRootController(controller, animated: animated, completion: completion)
        }
    }
    
    func tryShow(_ package: ModulePackage, animated: Bool) {
        do {
            try show(package, animated: animated)
        } catch {
            Logger.default.fault(error)
        }
    }
}
