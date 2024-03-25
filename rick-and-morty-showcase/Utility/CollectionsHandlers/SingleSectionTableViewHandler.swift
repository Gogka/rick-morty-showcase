//
//  SingleSectionTableViewHandler.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import UIKit

final class SingleSectionTableViewHandler<Item>: TableViewHandler {
    var items = [Item]()
    override init() {
        super.init()
        setOnNumberOfSections { _ in 1 }
        setOnNumberOfRowsInSection { [weak self] _, _ in
            self?.items.count ?? 0
        }
    }
    
    @discardableResult
    func setOnConfigureCell<Cell: UITableViewCell>(_ cell: Cell.Type, _ action: @escaping (Cell, Item) -> Void) -> Self {
        setOnCellForRowAt { [weak self] table, indexPath in
            guard let self else { return .init() }
            let cell = table.dequeCell(cell, for: indexPath)
            action(cell, items[indexPath.row])
            return cell
        }
    }
    
    @discardableResult
    func setOnSelectRowAt(_ action: @escaping ((Item) -> Void)) -> Self {
        setOnSelectRowAt { [weak self] _, indexPath in
            guard let self else { return }
            action(items[indexPath.row])
        }
    }
}
