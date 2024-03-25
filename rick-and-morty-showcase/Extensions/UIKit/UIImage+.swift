//
//  UIImage+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit

extension UIImage {
    static func fromPalette(_ palette: ImagesPalette = .default, image: KeyPath<ImagesPalette, Image>) -> UIImage {
        palette[keyPath: image].getImage()
    }
    var alwaysTemplate: UIImage {
        withRenderingMode(.alwaysTemplate)
    }
}
