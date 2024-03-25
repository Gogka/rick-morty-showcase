//
//  FontsPalette.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import UIKit
import SwiftUI

struct FontsPalette {
    let header: Font
    let body: Font
}

extension FontsPalette {
    static let `default` = FontsPalette(
        header: SystemFont(size: 18),
        body: SystemFont(size: 16)
    )
}

// MARK: -
protocol Font {
    func getFont() -> UIFont
    func getFont() -> SwiftUI.Font
}

struct SystemFont: Font {
    let size: CGFloat
    
    func getFont() -> UIFont {
        UIFont.systemFont(ofSize: size)
    }
    func getFont() -> SwiftUI.Font {
        SwiftUI.Font.system(size: size)
    }
}
