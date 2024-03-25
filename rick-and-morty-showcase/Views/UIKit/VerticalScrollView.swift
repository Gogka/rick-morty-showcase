//
//  VerticalScrollView.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import UIKit

final class VerticalScrollView<ContentView: UIView>: BaseUIKitScrollView {
    let contentView = ContentView()
    override func setupStatic() {
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
