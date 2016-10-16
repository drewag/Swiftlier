//
//  DataSource.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/8/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol DataSourceType {
    associatedtype ValueType
    var count: Int {get}
    func item(at index: Int) -> ValueType
}

class TableDataSource<D: DataSourceType>: NSObject, UITableViewDataSource {
    typealias TableViewCellCreation = (_ indexPath: IndexPath, _ value: D.ValueType, _ tableView: UITableView) -> (UITableViewCell)

    let source: D
    let tableCellCreation: TableViewCellCreation

    init(source: D, tableCellCreation: @escaping TableViewCellCreation) {
        self.source = source
        self.tableCellCreation = tableCellCreation
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.source.item(at: indexPath.row)
        return self.tableCellCreation(indexPath, item, tableView)
    }
}

class CollectionDataSource<D: DataSourceType>: NSObject, UICollectionViewDataSource {
    typealias CollectionViewCellCreation = (_ indexPath: IndexPath, _ value: D.ValueType, _ collectionView: UICollectionView) -> (UICollectionViewCell)

    let source: D
    let collectionCellCreation: CollectionViewCellCreation

    init(source: D, collectionCellCreation: @escaping CollectionViewCellCreation) {
        self.source = source
        self.collectionCellCreation = collectionCellCreation
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.source.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.source.item(at: indexPath.row)
        return self.collectionCellCreation(indexPath, item, collectionView)
    }
}

extension DataSourceType {
    public func dataSourceWithCellCreation(_ cellCreation: @escaping (_ indexPath: IndexPath, _ value: ValueType, _ tableView: UITableView) -> UITableViewCell) -> UITableViewDataSource {
        return TableDataSource(source: self, tableCellCreation: cellCreation)
    }

    public func dataSourceWithCellCreation(_ cellCreation: @escaping (_ indexPath: IndexPath, _ value: ValueType, _ collectionView: UICollectionView) -> UICollectionViewCell) -> UICollectionViewDataSource {
        return CollectionDataSource(source: self, collectionCellCreation: cellCreation)
    }
}
#endif
