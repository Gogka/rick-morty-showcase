//
//  BaseUIKitScrollView.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import UIKit

class BaseUIKitScrollView: UIScrollView {
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
