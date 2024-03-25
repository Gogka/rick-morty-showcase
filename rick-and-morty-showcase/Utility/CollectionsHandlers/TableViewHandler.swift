//
//  TableViewHandler.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import UIKit

class TableViewHandler: NSObject {
    private var onNumberOfSections: ((UITableView) -> Int)?
    private var onNumberOfRowsInSection: ((UITableView, _ section: Int) -> Int)?
    private var onCellForRowAt: ((UITableView, IndexPath) -> UITableViewCell)?
    private var onDidSelectRowAt: ((UITableView, IndexPath) -> Void)?
    private var onEstimatedHeightForRowAt: ((UITableView, IndexPath) -> CGFloat)?
    private var onHeightForRowAt: ((UITableView, IndexPath) -> CGFloat)?
    private var onWilLDisplayCellForRowAt: ((UITableView, UITableViewCell, IndexPath) -> Void)?
    
    @discardableResult
    func setOnNumberOfSections(_ action: ((UITableView) -> Int)?) -> Self {
        onNumberOfSections = action
        return self
    }
    @discardableResult
    func setNumberOfSections(_ number: Int) -> Self {
        setOnNumberOfSections { _ in number }
    }
    @discardableResult
    func setOnNumberOfRowsInSection(_ action: ((UITableView, _ section: Int) -> Int)?) -> Self {
        onNumberOfRowsInSection = action
        return self
    }
    @discardableResult
    func setNumberOfRowsInSection(_ number: Int) -> Self {
        setOnNumberOfRowsInSection { _, _ in number }
    }
    @discardableResult
    func setOnCellForRowAt(_ action: ((UITableView, IndexPath) -> UITableViewCell)?) -> Self {
        onCellForRowAt = action
        return self
    }
    @discardableResult
    func setOnSelectRowAt(_ action: ((UITableView, IndexPath) -> Void)?) -> Self {
        onDidSelectRowAt = action
        return self
    }
    @discardableResult
    func setOnEstimatedHeightForRowAt(_ action: ((UITableView, IndexPath) -> CGFloat)?) -> Self {
        onEstimatedHeightForRowAt = action
        return self
    }
    @discardableResult
    func setEstimatedHeight(_ height: CGFloat) -> Self {
        setOnEstimatedHeightForRowAt { _, _ in height }
    }
    @discardableResult
    func setOnHeightForRowAt(_ action: ((UITableView, IndexPath) -> CGFloat)?) -> Self {
        onHeightForRowAt = action
        return self
    }
    @discardableResult
    func setAutomaticHeightDimension() -> Self {
        setOnHeightForRowAt { _, _ in UITableView.automaticDimension }
    }
    @discardableResult
    func setTableViewHeight() -> Self {
        setOnHeightForRowAt { table, _ in table.bounds.size.height }
    }
    @discardableResult
    func setOnWilLDisplayCellForRowAt(_ action: ((UITableView, UITableViewCell, IndexPath) -> Void)?) -> Self {
        onWilLDisplayCellForRowAt = action
        return self
    }
    @discardableResult
    func setOnWilLDisplayTail(
        sectionOffset: Int = 1,
        itemsOffset: Int = 1,
        _ action: @escaping (UITableView, UITableViewCell, IndexPath) -> Void
    ) -> Self {
        setOnWilLDisplayCellForRowAt { [weak self] table, cell, indexPath in
            guard let self,
                  indexPath.section == numberOfSections(in: table) - sectionOffset,
                  indexPath.row == tableView(table, numberOfRowsInSection: indexPath.section) - itemsOffset 
            else { return }
            action(table, cell, indexPath)
        }
    }
}

extension TableViewHandler: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        onNumberOfSections?(tableView) ?? 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let onNumberOfRowsInSection {
            return onNumberOfRowsInSection(tableView, section)
        } else {
            assertionFailure("You should specify setOnNumberOfRowsSections.")
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let onCellForRowAt else {
            assertionFailure("You should specify setOnNumberOfRowsSections.")
            return UITableViewCell()
        }
        return onCellForRowAt(tableView, indexPath)
    }
}

extension TableViewHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelectRowAt?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        onEstimatedHeightForRowAt?(tableView, indexPath) ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        onHeightForRowAt?(tableView, indexPath) ?? 0
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        onWilLDisplayCellForRowAt?(tableView, cell, indexPath)
    }
}
