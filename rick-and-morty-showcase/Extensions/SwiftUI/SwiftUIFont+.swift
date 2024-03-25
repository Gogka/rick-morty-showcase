//
//  SwiftUIFont+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import SwiftUI

extension SwiftUI.Font {
    static func fromPalette(_ palette: FontsPalette = .default, font: KeyPath<FontsPalette, Font>) -> SwiftUI.Font {
        palette[keyPath: font].getFont()
    }
}
