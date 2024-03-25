//
//  Palette.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit
import SwiftUI

struct ColorsPalette {
    let backgroundColor: Color
    let bodyTextColor: Color
    let headerTextColor: Color
    let shadowColor: Color
    let borderColor: Color
    let favouriteColor: Color
}

extension ColorsPalette {
    static let `default` = ColorsPalette(
        backgroundColor: AssetColor(name: "Colors/backgroundColor"),
        bodyTextColor: AssetColor(name: "Colors/bodyTextColor"),
        headerTextColor: AssetColor(name: "Colors/headerTextColor"),
        shadowColor: AssetColor(name: "Colors/shadowColor"),
        borderColor: AssetColor(name: "Colors/borderColor"),
        favouriteColor: AssetColor(name: "Colors/favouriteColor")
    )
}
// MARK: -
protocol Color {
    func getColor() -> UIColor
    func getColor() -> SwiftUI.Color
}

struct AssetColor: Color {
    private let name: String
    private let bundle: Bundle
    
    fileprivate init(name: String, bundle: Bundle = .main) {
        self.name = name
        self.bundle = bundle
    }
    func getColor() -> UIColor {
        if let color = UIColor(named: name, in: bundle, compatibleWith: nil) {
            return color
        } else {
            Logger.default.fault("Undefined color \(name, privacy: .public) in bundle \(bundle.bundleIdentifier ?? "", privacy: .public)")
            assertionFailure()
            return .clear
        }
    }
    func getColor() -> SwiftUI.Color {
        SwiftUI.Color(name, bundle: bundle)
    }
}
