//
//  DequableTableViewCell.swift
//  HDS Work Order
//
//  Created by Andrew J Wagner on 3/20/16.
//  Copyright © 2016 Housing Data Systems. All rights reserved.
//

#if os(iOS)
import UIKit

extension UITableView {
    @available(*, deprecated, message: "Use registerNibCell instead")
    public func registerCell(withType type: UITableViewCell.Type) {
        self.registerNibCell(withType: type)
    }
    
    public func registerNibCell(withType type: UITableViewCell.Type) {
        let nibName = self.nibName(fromType: type)
        let bundle = Bundle(for: type)
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: nibName)
    }

    public func registerClassCell(withType type: UITableViewCell.Type) {
        let nibName = self.nibName(fromType: type)
        self.register(type, forCellReuseIdentifier: nibName)
    }

    public func dequeueCell<CellType: UITableViewCell>() -> CellType {
        let identifier = self.nibName(fromType: CellType.self)
        return self.dequeueReusableCell(withIdentifier: identifier) as! CellType
    }

    public func nibName(fromType type: UITableViewCell.Type) -> String {
        let fullClassName = NSStringFromClass(type)
        return fullClassName.components(separatedBy: ".")[1]
    }
}
#endif
