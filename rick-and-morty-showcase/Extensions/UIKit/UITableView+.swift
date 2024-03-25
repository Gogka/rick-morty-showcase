//
//  UITableView+.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import UIKit

extension UITableView {
    func register<Cell: UITableViewCell>(_ cell: Cell.Type) {
        register(cell, forCellReuseIdentifier: "\(cell)")
    }
    func dequeCell<Cell: UITableViewCell>(_ cell: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: "\(cell)", for: indexPath) as? Cell else {
            assertionFailure("Unregistered cell \(cell).")
            return Cell()
        }
        return cell
    }
    
    func setHandler(_ handler: (UITableViewDataSource & UITableViewDelegate)?) {
        dataSource = handler
        delegate = handler
    }
}
