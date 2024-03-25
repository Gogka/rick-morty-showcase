//
//  SingleCellTableViewHandler.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import UIKit

final class SingleCellTableViewHandler<Cell: UITableViewCell>: TableViewHandler {
    private(set) lazy var cell = Cell(style: .default, reuseIdentifier: nil)
    override init() {
        super.init()
        setNumberOfSections(1)
        setNumberOfRowsInSection(1)
        setOnCellForRowAt { [weak self] _, _ in
            guard let self else { return .init() }
            return cell
        }
    }
    @discardableResult
    func makeCell(_ action: (Cell) -> Void) -> Self {
        action(cell)
        return self
    }
}
