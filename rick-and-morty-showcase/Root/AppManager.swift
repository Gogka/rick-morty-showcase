//
//  AppManager.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit
import os

protocol AppManager {
    typealias LaunchingOptions = [UIApplication.LaunchOptionsKey: Any]?
    
    func applicationDidFinishLaunching(_ application: UIApplication, withOptions options: LaunchingOptions) -> Bool
    func makeNewWindow(forScene scene: UIScene) throws -> UIWindow
}

final class DefaultAppManager: AppManager {
    private var appEnvironment: AppEnvironment!
    // MARK: -
    init() {
        self.appEnvironment = makeAppEnvironment()
    }
    // MARK: - AppDelegate
    func applicationDidFinishLaunching(_ application: UIApplication, withOptions options: LaunchingOptions) -> Bool {
        true
    }
    // MARK: -
    func makeNewWindow(forScene scene: UIScene) throws -> UIWindow {
        guard let windowScene = scene as? UIWindowScene else {
            throw DevError("The scene is \(type(of: scene)), but UIWindowScene expected.")
        }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = TabsHostModule
            .Resolver(environment: makeModuleEnvironment(forScene: windowScene))
            .common()
            .controller
        return window
    }
    // MARK: - Private
    private func makeAppEnvironment() -> AppEnvironment {
        let listeners: [RMLoaderListener]
        #if DEBUG
            listeners = [RMLoaderLogger(logger: .default)]
        #else
            listeners = []
        #endif
        let coreDataManager = CoreDataManager()
        let favouritesCharactersService: FavouritesCharactersService = CoreDataFavouritesCharactersService(manager: coreDataManager)
        let loader = RMLoader(listeners: listeners)
        return DefaultAppEnvironment(
            loader: loader,
            favouritesCharactersService: favouritesCharactersService
        )
    }
    private func makeModuleEnvironment(forScene scene: UIWindowScene) -> ModuleEnvironment {
        DefaultModuleEnvironment(scene: scene, appEnvironment: appEnvironment)
    }
}

