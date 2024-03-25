//
//  SceneDelegate.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appManager: AppManager { UIApplication.shared.appDelegate.appManager }
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        do {
            window = try appManager.makeNewWindow(forScene: scene)
            window?.makeKeyAndVisible()
        } catch {
            Logger.default.fault(error)
        }
    }
}

