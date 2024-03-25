//
//  CharactersListModule+UIKitControllerView.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 21.03.24.
//

import UIKit
import SnapKit

extension CharactersListModule.UIKitViewController {
    final class ControllerView: BaseUIKitView {
        let tableView = UITableView()
        
        override func setupStatic() {
            addSubview(tableView)
            tableView.snp.makeConstraints {
                $0.left.right.top.bottom.equalTo(safeAreaLayoutGuide)
            }
            backgroundColor = .fromPalette(color: \.backgroundColor)
            makeObject(tableView) {
                $0.separatorStyle = .none
                $0.backgroundColor = .fromPalette(color: \.backgroundColor)
            }
        }
    }
}
