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

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
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
        let field = self.form.sections.values[textField.superview!.tag].fields.values[textField.tag]
        (field as! SimpleField).update(with: textField.text ?? "")
    }

    func didTap(helpButton helpButton: UIButton) {
        let formSection = self.form.sections.values[helpButton.tag]
        UIApplication.sharedApplication().openURL(formSection.helpURL!)
    }
}

extension FormViewController/*: UITableViewDataSource*/ {
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.form.sections.count
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.sections.values[section].fields.count
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let field = self.form.sections.values[indexPath.section].fields.values[indexPath.row]
        switch field {
        case let simpleField as SimpleField:
            let cell = tableView.dequeueReusableCellWithIdentifier(SimpleFieldTableViewCell.identifier, forIndexPath: indexPath) as! SimpleFieldTableViewCell

            cell.selectionStyle = .None
            cell.nameLabel.text = field.label
            cell.valueField.placeholder = simpleField.placeholder
            cell.valueField.keyboardType = simpleField.keyboard
            cell.valueField.autocapitalizationType = simpleField.autoCapitalize
            cell.valueField.secureTextEntry = simpleField.isSecureEntry
            cell.valueField.text = simpleField.displayValue
            cell.nameLabelWidth = self.nameLabelWidth
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
        return self.form.sections.values[section].name
    }

    public override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let formSection = self.form.sections.values[section]
        let view = UIView()

        let label = UILabel()
        label.text = formSection.name.uppercaseString
        label.textColor = UIColor(hex: 0x6d6d72)
        label.font = UIFont.systemFontOfSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addConstraints([
            NSLayoutConstraint(leftOfView: label, toView: view, distance: 8),
            NSLayoutConstraint(topOfView: label, toView: view, distance: -10),
            NSLayoutConstraint(bottomOfView: label, toView: view, distance: 0),
        ])

        if let _ = formSection.helpURL {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Help", forState: .Normal)
            button.tag = section
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
            button.setTitleColor(UIColor(hex: 0x007aff), forState: .Normal)
            button.addTarget(self, action: #selector(didTap(helpButton:)), forControlEvents: .TouchUpInside)
            view.addSubview(button)

            view.addConstraints([
                NSLayoutConstraint(rightOfView: label, toLeftOfView: button, distance: 8),
                NSLayoutConstraint(topOfView: button, toView: view, distance: -6),
                NSLayoutConstraint(bottomOfView: label, toView: button, distance: 0),
                NSLayoutConstraint(rightOfView: button, toView: view, distance: 8),
            ])
        }
        else {
            view.addConstraint(NSLayoutConstraint(rightOfView: label, toView: view, distance: 8))
        }

        return view
    }

    public override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.form.sections.values[section].help
    }
}

private extension FormViewController {
    static let font = UIFont.systemFontOfSize(16)

    static func calculateMaximumLabelWidth(for form: Form) -> CGFloat {
        var maxWidth: CGFloat = 0
        for section in form.sections.values {
            for field in section.fields.values {
                let width = (field.label as NSString).sizeWithAttributes([NSFontAttributeName:self.font]).width
                maxWidth = max(maxWidth, width)
            }
        }
        return maxWidth + 16
    }
}

private enum Cell {
    case field(Field)
    case help(String)
}

private class SimpleFieldTableViewCell: UITableViewCell {
    static let identifier = "SimpleField"

    let nameLabel = UILabel()
    let valueField = UITextField()
    var nameLabelWidth: CGFloat = 100

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.nameLabel.font = FormViewController.font
        self.valueField.font = FormViewController.font
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueField.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.valueField)
    }

    private override func layoutSubviews() {
        super.layoutSubviews()

        self.nameLabel.frame = CGRect(x: 8, y: 2, width: self.nameLabelWidth, height: self.contentView.bounds.height - 4)
        self.valueField.frame = CGRect(
            x: self.nameLabel.frame.maxX + 8,
            y: self.nameLabel.frame.minY,
            width: self.contentView.bounds.width - self.nameLabel.frame.maxX - 16,
            height: self.nameLabel.frame.height
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
