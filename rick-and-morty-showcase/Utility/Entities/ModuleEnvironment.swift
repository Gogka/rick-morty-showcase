//
//  ModuleEnvironment.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit

protocol ModuleEnvironment {
    var scene: UIWindowScene { get }
    var appEnvironment: AppEnvironment { get }
}

extension ModuleEnvironment {
    var loader: Loader { appEnvironment.loader }
    var favouritesCharactersService: FavouritesCharactersService { appEnvironment.favouritesCharactersService }
}

final class DefaultModuleEnvironment: ModuleEnvironment {
    let scene: UIWindowScene
    let appEnvironment: AppEnvironment
    init(scene: UIWindowScene, appEnvironment: AppEnvironment) {
        self.scene = scene
        self.appEnvironment = appEnvironment
    }
}
