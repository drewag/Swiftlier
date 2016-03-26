//
//  DataSource.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/8/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

public protocol DataSourceType {
    associatedtype ValueType
    var count: Int {get}
    func itemAtIndex(index: Int) -> ValueType
}

class TableDataSource<D: DataSourceType>: NSObject, UITableViewDataSource {
    typealias TableViewCellCreation = (indexPath: NSIndexPath, value: D.ValueType, tableView: UITableView) -> (UITableViewCell)

    let source: D
    let tableCellCreation: TableViewCellCreation

    init(source: D, tableCellCreation: TableViewCellCreation) {
        self.source = source
        self.tableCellCreation = tableCellCreation
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = self.source.itemAtIndex(indexPath.row)
        return self.tableCellCreation(indexPath: indexPath, value: item, tableView: tableView)
    }
}

class CollectionDataSource<D: DataSourceType>: NSObject, UICollectionViewDataSource {
    typealias CollectionViewCellCreation = (indexPath: NSIndexPath, value: D.ValueType, collectionView: UICollectionView) -> (UICollectionViewCell)

    let source: D
    let collectionCellCreation: CollectionViewCellCreation

    init(source: D, collectionCellCreation: CollectionViewCellCreation) {
        self.source = source
        self.collectionCellCreation = collectionCellCreation
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.source.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = self.source.itemAtIndex(indexPath.row)
        return self.collectionCellCreation(indexPath: indexPath, value: item, collectionView: collectionView)
    }
}

extension DataSourceType {
    public func dataSourceWithCellCreation(cellCreation: (indexPath: NSIndexPath, value: ValueType, tableView: UITableView) -> UITableViewCell) -> UITableViewDataSource {
        return TableDataSource(source: self, tableCellCreation: cellCreation)
    }

    public func dataSourceWithCellCreation(cellCreation: (indexPath: NSIndexPath, value: ValueType, collectionView: UICollectionView) -> UICollectionViewCell) -> UICollectionViewDataSource {
        return CollectionDataSource(source: self, collectionCellCreation: cellCreation)
    }
}