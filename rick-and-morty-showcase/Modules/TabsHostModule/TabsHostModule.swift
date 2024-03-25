//
//  TabsHostModule.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation

enum TabsHostModule {
    final class Resolver {
        private let environment: ModuleEnvironment
        
        init(environment: ModuleEnvironment) {
            self.environment = environment
        }
        
        func common() -> ModulePackage {
            let listsResolver = CharactersListModule.Resolver(environment: environment)
            let tabsController = makeObject(UIKitViewController()) {
                $0.viewControllers = [
                    listsResolver.fullList(),
                    listsResolver.favouritesList()
                ]
            }
            return ModulePackage(controller: tabsController, navigation: .root)
        }
    }
    typealias UIKitViewController = BaseTabController
}
