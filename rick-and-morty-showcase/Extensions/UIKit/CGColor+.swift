//
//  CGColor+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import CoreGraphics

extension CGColor {
    static func fromPalette(_ palette: ColorsPalette = .default, color: KeyPath<ColorsPalette, Color>) -> CGColor {
        palette[keyPath: color].getColor().cgColor
    }
}
