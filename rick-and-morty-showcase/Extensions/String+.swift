//
//  String+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation

extension String {
    static func fromPalette(_ palette: StringsPalette = .default, string: KeyPath<StringsPalette, PaletteString>) -> String {
        palette[keyPath: string].getString()
    }
}
