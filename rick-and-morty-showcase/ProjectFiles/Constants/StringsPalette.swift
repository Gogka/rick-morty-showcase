//
//  StringsPalette.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import Foundation

struct StringsPalette {
    let favouritesListTabTitle: PaletteString
    let fullListTabTitle: PaletteString
    let defaultErrorText: PaletteString
    let tryAgainTitle: PaletteString
    let noDataTitle: PaletteString
}

extension StringsPalette {
    static let `default` = StringsPalette(
        favouritesListTabTitle: LocalizableString(key: "favouritesListTabTitle"),
        fullListTabTitle: LocalizableString(key: "fullListTabTitle"),
        defaultErrorText: LocalizableString(key: "defaultErrorText"),
        tryAgainTitle: LocalizableString(key: "tryAgainTitle"),
        noDataTitle: LocalizableString(key: "noDataTitle")
    )
}

// MARK: -
protocol PaletteString {
    func getString() -> String
}

struct LocalizableString: PaletteString {
    let key: String
    var tableName: String?
    var bundle = Bundle.main
    var value: String?
    var comment = ""
    func getString() -> Swift.String {
        NSLocalizedString(
            key,
            tableName: tableName,
            bundle: bundle,
            value: value ?? key,
            comment: comment
        )
    }
}
