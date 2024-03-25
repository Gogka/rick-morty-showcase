//
//  UIColor+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit

extension UIColor {
    static func fromPalette(_ palette: ColorsPalette = .default, color: KeyPath<ColorsPalette, Color>) -> UIColor {
        palette[keyPath: color].getColor()
    }
}
