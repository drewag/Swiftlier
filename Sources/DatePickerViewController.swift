//
//  ChooseDateViewController.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/22/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

public class ChooseDateViewController: UIViewController {
    public let datePicker = UIDatePicker()

    public convenience init(date: Date) {
        self.init()

        self.datePicker.date = date
        self.datePicker.datePickerMode = .date
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.datePicker)
        self.view.addConstraints([
            NSLayoutConstraint(leftOf: self.datePicker, to: self.view),
            NSLayoutConstraint(rightOf: self.datePicker, to: self.view),
            NSLayoutConstraint(topOf: self.datePicker, to: self.view, distance: -44),
        ])

        self.preferredContentSize = self.datePicker.frame.size
    }
}
#endif
