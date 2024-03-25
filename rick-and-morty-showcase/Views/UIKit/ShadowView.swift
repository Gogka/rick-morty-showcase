//
//  ShadowView.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import UIKit

final class ShadowView<Content: UIView>: BaseUIKitView {
    let contentView = Content()
    
    override func setupStatic() {
        addSubview(contentView)
        contentView.snp.makeConstraints { $0.left.right.top.bottom.equalToSuperview() }
        contentView.clipsToBounds = true
    }
    override func layoutSubviews() {
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
