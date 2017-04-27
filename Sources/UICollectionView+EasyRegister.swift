//
//  UICollectionView+EasyRegister.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 10/16/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

extension UICollectionView {
    public func registerCell(with type: UICollectionViewCell.Type) {
        let nibName = self.nibName(from: type)
        let bundle = Bundle(for: type)
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: nibName)
    }

    public func dequeueCell<CellType: UICollectionViewCell>(for indexPath: IndexPath) -> CellType {
        let identifier = self.nibName(from: CellType.self)
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CellType
    }

    public func nibName(from type: UICollectionViewCell.Type) -> String {
        let fullClassName = NSStringFromClass(type)
        return fullClassName.components(separatedBy: ".")[1]
    }
}
#endif
