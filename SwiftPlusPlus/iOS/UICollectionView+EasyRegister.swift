//
//  UICollectionView+EasyRegister.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 10/16/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func registerCellWithType(type: UICollectionViewCell.Type) {
        let nibName = self.nibNameFromType(type)
        let bundle = NSBundle(forClass: type)
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.registerNib(nib, forCellWithReuseIdentifier: nibName)
    }

    public func dequeueCell<CellType: UICollectionViewCell>(for indexPath: NSIndexPath) -> CellType {
        let identifier = self.nibNameFromType(CellType.self)
        return self.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CellType
    }

    public func nibNameFromType(type: UICollectionViewCell.Type) -> String {
        let fullClassName = NSStringFromClass(type)
        return fullClassName.componentsSeparatedByString(".")[1]
    }
}
