//
//  BaseViewController.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit
import SwiftUI

class BaseViewController: UIViewController, HelpedController {
    private(set) lazy var helper = ViewControllerHelper()
}

class BaseNavigationController: UINavigationController, HelpedController {
    private(set) lazy var helper = ViewControllerHelper()
}

class BaseTabController: UITabBarController, HelpedController {
    private(set) lazy var helper = ViewControllerHelper()
}

class BaseHostingController<ContentView: View>: UIHostingController<ContentView>, HelpedController {
    private(set) lazy var helper = ViewControllerHelper()
}
