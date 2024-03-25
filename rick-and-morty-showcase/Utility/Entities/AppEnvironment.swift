//
//  AppEnvironment.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation

protocol AppEnvironment {
    var loader: Loader { get }
    var favouritesCharactersService: FavouritesCharactersService { get }
}

final class DefaultAppEnvironment: AppEnvironment {
    let loader: Loader
    let favouritesCharactersService: FavouritesCharactersService
    init(loader: Loader, favouritesCharactersService: FavouritesCharactersService) {
        self.loader = loader
        self.favouritesCharactersService = favouritesCharactersService
    }
}
