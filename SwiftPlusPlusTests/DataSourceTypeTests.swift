//
//  DataSourceTypeTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/8/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import XCTest
import SwiftPlusPlus

extension Array: DataSourceType {
    public typealias ValueType = Element

    public func itemAtIndex(index: Int) -> ValueType {
        return self[index]
    }
}

class DataSourceTypeTests: XCTestCase {
    func testTableDataSource() {
        let items = ["First", "Second", "Third"]
        let tableCell = UITableViewCell()
        let tableView = UITableView()

        let dataSource: UITableViewDataSource = items.dataSourceWithCellCreation() { indexPath, value, tb in
            XCTAssertEqual(indexPath.row, 1)
            XCTAssertEqual(value, "Second")
            XCTAssertEqual(tb, tableView)
            return tableCell
        }

        XCTAssertEqual(dataSource.tableView(tableView, numberOfRowsInSection: 0), 3)
        XCTAssertEqual(dataSource.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)), tableCell)
    }

    func testCollectionDataSource() {
        let items = ["First", "Second", "Third"]
        let cell = UICollectionViewCell()
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())

        let dataSource: UICollectionViewDataSource = items.dataSourceWithCellCreation() { indexPath, value, cv in
            XCTAssertEqual(indexPath.row, 1)
            XCTAssertEqual(value, "Second")
            XCTAssertEqual(cv, collectionView)
            return cell
        }

        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), 3)
        XCTAssertEqual(dataSource.collectionView(collectionView, cellForItemAtIndexPath: NSIndexPath(forRow: 1, inSection: 0)), cell)
    }
}
