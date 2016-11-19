//
//  FormViewController.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/18/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import UIKit

public class FormViewController: UITableViewController {
    public var form: Form

    let nameLabelWidth: CGFloat

    public init(form: Form) {
        self.nameLabelWidth = FormViewController.calculateMaximumLabelWidth(for: form)
        self.form = form

        super.init(style: .Grouped)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(SimpleFieldTableViewCell.self, forCellReuseIdentifier: SimpleFieldTableViewCell.identifier)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(done))
    }

    public func submit() {
        fatalError("Must be overridden")
    }

    public func extraValidation() throws {}

    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func done() {
        do {
            try self.form.validate()
            self.submit()
        }
        catch let error as UserReportableError {
            self.showAlert(withError: error)
        }
        catch let error {
            fatalError("\(error)")
        }
    }

    func textFieldDidChange(textField: UITextField) {
        let field = self.form.fields.values[textField.superview!.tag].values[textField.tag]
        (field as! SimpleField).update(with: textField.text ?? "")
    }
}

extension FormViewController/*: UITableViewDataSource*/ {
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.form.fields.count
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.fields.values[section].count
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let field = self.form.fields.values[indexPath.section].values[indexPath.row]
        switch field {
        case let simpleField as SimpleField:
            let cell = tableView.dequeueReusableCellWithIdentifier(SimpleFieldTableViewCell.identifier, forIndexPath: indexPath) as! SimpleFieldTableViewCell

            cell.nameLabel.text = field.label
            cell.valueField.placeholder = simpleField.placeholder
            cell.valueField.keyboardType = simpleField.keyboard
            cell.valueField.autocapitalizationType = simpleField.autoCapitalize
            cell.valueField.secureTextEntry = simpleField.isSecureEntry
            cell.valueField.text = simpleField.displayValue
            cell.nameLabelWidthConstraint.constant = self.nameLabelWidth
            cell.valueField.superview!.tag = indexPath.section
            cell.valueField.tag = indexPath.row
            cell.valueField.removeTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: .AllEvents)
            cell.valueField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: .EditingChanged)


            return cell
        default:
            fatalError("Unreocgnized form type")
        }
    }
}

extension FormViewController/*: UITableViewDelegat*/ {
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.form.fields.keys[section]
    }
}

private extension FormViewController {
    static let font = UIFont.systemFontOfSize(16)

    static func calculateMaximumLabelWidth(for form: Form) -> CGFloat {
        var maxWidth: CGFloat = 0
        for fields in form.fields.values {
            for field in fields.values {
                let width = (field.label as NSString).sizeWithAttributes([NSFontAttributeName:self.font]).width
                maxWidth = max(maxWidth, width)
            }
        }
        return maxWidth + 16
    }
}

private class SimpleFieldTableViewCell: UITableViewCell {
    static let identifier = "SimpleField"

    let nameLabel = UILabel()
    let valueField = UITextField()
    var nameLabelWidthConstraint: NSLayoutConstraint!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.nameLabel.font = FormViewController.font
        self.valueField.font = FormViewController.font
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueField.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.valueField)

        self.nameLabelWidthConstraint = NSLayoutConstraint(item: self.nameLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100)

        self.contentView.addConstraints([
            self.nameLabelWidthConstraint,
            NSLayoutConstraint(leftOfView: self.nameLabel, toView: self.contentView, distance: 8),
            NSLayoutConstraint(topOfView: self.nameLabel, toView: self.contentView, distance: 2),
            NSLayoutConstraint(bottomOfView: self.nameLabel, toView: self.contentView, distance: 2),
            NSLayoutConstraint(rightOfView: self.nameLabel, toLeftOfView: self.valueField, distance: -8),
            NSLayoutConstraint(rightOfView: self.valueField, toView: self.contentView, distance: 8),
            NSLayoutConstraint(topOfView: self.valueField, toView: self.contentView, distance: 2),
            NSLayoutConstraint(bottomOfView: self.valueField, toView: self.contentView, distance: 2),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
