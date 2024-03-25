//
//  SwiftUIImage+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import SwiftUI

extension SwiftUI.Image {
    static func fromPalette(_ palette: ImagesPalette = .default, image: KeyPath<ImagesPalette, Image>) -> Self {
        palette[keyPath: image].getImage()
    }
}
