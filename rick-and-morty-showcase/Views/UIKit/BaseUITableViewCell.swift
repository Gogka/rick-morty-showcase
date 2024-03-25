//
//  BaseUITableViewCell.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 23.03.24.
//

import UIKit

class BaseUITableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("Init with decoder is unavaialble")
    }
    // MARK: - For children
    final func setup() {
        setupStatic()
        updateDynamicColors()
    }
    
    func updateDynamicColors() {}
    func setupStatic() {}
    // MARK: -
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            updateDynamicColors()
        }
    }
}
