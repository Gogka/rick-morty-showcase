//
//  ImageSourceView.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 25.03.24.
//

import SwiftUI
import Kingfisher

struct ImageSourceView: View {
    let source: ImageSource
    var body: some View {
        switch source {
        case let .remote(url):
            KFImage(url)
                .resizable()
        }
    }
}
