//
//  ProcessInfo+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 25.03.24.
//

import Foundation

extension ProcessInfo {
    var isSwiftUIEnabled: Bool {
        arguments.contains("SwiftUI")
    }
}
