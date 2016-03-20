//
//  DequableTableViewCell.swift
//  HDS Work Order
//
//  Created by Andrew J Wagner on 3/20/16.
//  Copyright © 2016 Housing Data Systems. All rights reserved.
//

import UIKit

extension UITableView {
    public func registerCellWithType(type: UITableViewCell.Type) {
        let nibName = self.nibNameFromType(type)
        let nib = UINib(nibName: nibName, bundle: nil)
        self.registerNib(nib, forCellReuseIdentifier: nibName)
    }

    public func dequeueCell<CellType: UITableViewCell>() -> CellType {
        let identifier = self.nibNameFromType(CellType.self)
        return self.dequeueReusableCellWithIdentifier(identifier) as! CellType
    }

    public func nibNameFromType(type: UITableViewCell.Type) -> String {
        let fullClassName = NSStringFromClass(type)
        return fullClassName.componentsSeparatedByString(".")[1]
    }
}
