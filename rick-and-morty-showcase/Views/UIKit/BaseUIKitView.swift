//
//  BaseUIKitView.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit

class BaseUIKitView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
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
