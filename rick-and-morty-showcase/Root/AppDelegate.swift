//
//  AppDelegate.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private(set) lazy var appManager: AppManager = DefaultAppManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appManager.applicationDidFinishLaunching(application, withOptions: launchOptions)
    }
}

