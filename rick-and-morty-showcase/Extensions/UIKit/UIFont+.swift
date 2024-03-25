//
//  UIFont+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import UIKit

extension UIFont {
    static func fromPalette(_ palette: FontsPalette = .default, font: KeyPath<FontsPalette, Font>) -> UIFont {
        palette[keyPath: font].getFont()
    }
}
