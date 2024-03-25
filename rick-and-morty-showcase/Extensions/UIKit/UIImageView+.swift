//
//  UIImageView+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(from source: ImageSource?) {
        guard let source else {
            image = nil
            return
        }
        switch source {
        case let .remote(url):
            kf.setImage(with: url)
        }
    }
}
