//
//  Image.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit
import SwiftUI

struct ImagesPalette {
    let fullListSelectedTabIcon: Image
    let fullListNotSelectedTabIcon: Image
    let heartIcon: Image
    let heartFilledIcon: Image
    let arrowLeft: Image
}

extension ImagesPalette {
    static let `default` = ImagesPalette(
        fullListSelectedTabIcon: SymbolImage(name: "icloud.fill"),
        fullListNotSelectedTabIcon: SymbolImage(name: "icloud"),
        heartIcon: SymbolImage(name: "heart"),
        heartFilledIcon: SymbolImage(name: "heart.fill"),
        arrowLeft: SymbolImage(name: "arrow.left")
    )
}
// MARK: -
protocol Image {
    func getImage() -> UIImage
    func getImage() -> SwiftUI.Image
}

struct SymbolImage: Image {
    private let name: String
    
    fileprivate init(name: String) {
        self.name = name
    }
    func getImage() -> UIImage {
        if let image = UIImage(systemName: name) {
            return image
        } else {
            Logger.default.fault("Undefined system image \(name, privacy: .public)")
            assertionFailure()
            return UIImage()
        }
    }
    func getImage() -> SwiftUI.Image {
        SwiftUI.Image(systemName: name)
    }
}
