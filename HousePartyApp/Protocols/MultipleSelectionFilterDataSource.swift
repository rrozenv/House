//
//  MultipleSelectionFilterDataSource.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

protocol Queryable {
    var uniqueId: String { get }
    var filterById: String { get }
    var isSelected: Bool { get set }
}

final class MultipleSelectionFilterDataSource<Model: Queryable, Cell: UITableViewCell & ValueCell>: ValueCellDataSource where Cell.Value == Model {
    
    private var selectedItems: [Model] = []
    private var storedItems: [Model] = []
    private var latestFilteredItems: [Model] = []
    private var isFiltering: Bool = false
    private var allSelected: Bool = false
    private var isSingleSelection: Bool
    
    init(isSingleSelection: Bool) {
        self.isSingleSelection = isSingleSelection
        super.init()
    }
    
    func load(items: [Model]) {
        self.storedItems = items
        self.set(values: items,
                 cellClass: Cell.self,
                 inSection: 0)
    }
    
    func filterItemsFor(query: String) {
        self.isFiltering = true
        let updatedModels = self.storedItems.filter { $0.filterById.contains(query) }
        self.latestFilteredItems = updatedModels
        self.set(values: updatedModels,
                 cellClass: Cell.self,
                 inSection: 0)
    }
    
    func resetSearchFilter() {
        self.isFiltering = false
        self.latestFilteredItems = []
        self.set(values: storedItems,
                 cellClass: Cell.self,
                 inSection: 0)
    }
    
    func selectedCount() -> Int { return selectedItems.count }
    
    func totalCount() -> Int { return isFiltering ? self.numberOfItems() : storedItems.count }
    
    func toggleSelectedStatus(of item: Queryable) {
        let index = storedItems.index { $0.uniqueId == item.uniqueId }
        guard let mainIndex = index else { fatalError() }
        
        // 1. Toggle UI State in main array
        storedItems[mainIndex].isSelected = !storedItems[mainIndex].isSelected
        
        // 2. Add/Remove item from selected array
        if storedItems[mainIndex].isSelected {
            if isSingleSelection && !selectedItems.isEmpty { selectedItems.removeAll() }
            selectedItems.append(storedItems[mainIndex])
        } else {
            if isSingleSelection { selectedItems.removeAll() }
            else {
                if let selectedIndex = selectedItems.index(where: { $0.uniqueId == item.uniqueId }) {
                    selectedItems.remove(at: selectedIndex)
                }
            }
        }
        
        if isFiltering {
            if let filteredIndex = latestFilteredItems.index(where: { $0.uniqueId == item.uniqueId }) {
                // 3. Toggle UI State in filter state
                latestFilteredItems[filteredIndex].isSelected = !latestFilteredItems[filteredIndex].isSelected
                self.set(value: latestFilteredItems[filteredIndex],
                         cellClass: Cell.self,
                         inSection: 0,
                         row: Int(filteredIndex))
            }
        } else {
            self.set(value: storedItems[mainIndex],
                     cellClass: Cell.self,
                     inSection: 0,
                     row: Int(mainIndex))
        }
    }
    
    func toggleAll() {
        let shouldSelect = shouldSelectAll()
        var mutatedItems = [Model]()
        self.selectedItems = []
        for var item in storedItems {
            item.isSelected = shouldSelect
            mutatedItems.append(item)
            if shouldSelect { selectedItems.append(item) }
        }
        if !shouldSelect { selectedItems.removeAll() }
        
        self.storedItems = mutatedItems
        self.set(values: storedItems,
                 cellClass: Cell.self,
                 inSection: 0)
    }
    
    func getItem(at indexPath: IndexPath) -> Model? {
        if isFiltering {
            guard latestFilteredItems.count > indexPath.row else { return nil }
            return latestFilteredItems[indexPath.row]
        } else {
            guard storedItems.count > indexPath.row else { return nil }
            return storedItems[indexPath.row]
        }
    }
    
    func getAllSelectedItems() -> [Model] {
        return selectedItems
    }
    
    private func shouldSelectAll() -> Bool {
        return selectedItems.count != storedItems.count
    }
    
    //MARK: - Configure Cell
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as Cell, value as Model):
            cell.configureWith(value: value)
        default:
            assertionFailure("Unrecognized combo: \(cell), \(value)")
        }
    }
}
