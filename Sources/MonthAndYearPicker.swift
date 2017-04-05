//
//  MonthAndYearPicker.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/4/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

//#if os(iOS)
import UIKit

public protocol DatePicker: class {
    var date: Date {get set}
}

extension UIDatePicker: DatePicker {}

public class MonthAndYearPicker: UIPickerView, DatePicker {
    fileprivate let dateFormatter = DateFormatter()
    fileprivate let currentYear: Int

    fileprivate enum Component: Int {
        case month
        case year
    }

    public var date: Date {
        set {
            let dateComponents = Calendar.current.dateComponents([.year, .month], from: newValue)
            self.selectRow(dateComponents.month! - 1, inComponent: Component.month.rawValue, animated: true)
            let yearRow = self.currentYear - dateComponents.year!
            self.selectRow(min(currentYear, yearRow), inComponent: Component.year.rawValue, animated: true)
        }
        get {
            var dateComponents = DateComponents()
            dateComponents.day = 1
            dateComponents.month = self.selectedRow(inComponent: Component.month.rawValue) + 1
            dateComponents.year = self.currentYear - self.selectedRow(inComponent: Component.year.rawValue)
            return Calendar.current.date(from: dateComponents) ?? Date()
        }
    }

    public override init(frame: CGRect) {
        self.currentYear = Int(Date().year) ?? 2000

        super.init(frame: frame)

        self.dataSource = self
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MonthAndYearPicker: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Component.count
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch Component(rawValue: component)! {
        case .month:
            return self.dateFormatter.monthSymbols.count
        case .year:
            return 100
        }
    }
}

extension MonthAndYearPicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch Component(rawValue: component)! {
        case .month:
            return self.dateFormatter.monthSymbols[row]
        case .year:
            return "\(self.currentYear - row)"
        }
    }
}

//#endif
