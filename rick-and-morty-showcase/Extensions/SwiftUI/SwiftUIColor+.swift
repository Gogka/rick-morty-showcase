//
//  SwiftUIColor+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import SwiftUI

extension SwiftUI.Color {
    static func fromPalette(_ palette: ColorsPalette = .default, color: KeyPath<ColorsPalette, Color>) -> SwiftUI.Color {
        palette[keyPath: color].getColor()
    }
}
