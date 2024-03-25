//
//  Logger.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import os
import Foundation

typealias Logger = os.Logger

extension Logger {
    static let `default` = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Undefined", category: "Default")
    
    func fault(_ error: Error) {
        fault("\(error, privacy: .public)")
    }
}
