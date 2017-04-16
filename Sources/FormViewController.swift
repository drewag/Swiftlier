//
//  FormViewController.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/18/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

open class FormViewController: UITableViewController, ErrorGenerating {
    public var form: Form
    public var onBack: ((_ canceled: Bool) -> ())?

    let nameLabelWidth: CGFloat

    public init(form: Form) {
        self.nameLabelWidth = FormViewController.calculateMaximumLabelWidth(for: form)
        self.form = form

        super.init(style: .grouped)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.register(SimpleFieldTableViewCell.self, forCellReuseIdentifier: SimpleFieldTableViewCell.identifier)
        self.tableView.register(BoolFieldTableViewCell.self, forCellReuseIdentifier: BoolFieldTableViewCell.identifier)
        self.tableView.register(SegmentedControlTableViewCell.self, forCellReuseIdentifier: SegmentedControlTableViewCell.identifier)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }

    open func submit() {
        fatalError("Must be overridden")
    }

    open func extraValidation() -> ValidationResult { return .passed }

    open func didEndEditing(field: Field) {}

    func cancel() {
        self.onBack?(true)
    }

    func done() {
        do {
            try self.form.validate()
            switch self.extraValidation() {
            case .passed:
                break
            case .failed:
                throw self.userError("saving", because: "of an unknown reason")
            case .failedWithReason(let reason):
                throw self.userError("saving", because: reason)
            }
            self.submit()
        }
        catch let error {
            let error = self.error("saving", from: error)
            self.showAlert(withError: error)
        }
    }

    func didChange(textField: UITextField) {
        let field = self.form.sections.values[textField.superview!.tag].fields.values[textField.tag]
        (field as! SimpleField).update(with: textField.text ?? "")
    }

    func didStartEditing(textField: UITextField) {
        let field = self.form.sections.values[textField.superview!.tag].fields.values[textField.tag]
        switch field {
        case let integerField as IntegerField:
            textField.text = integerField.value?.description ?? ""
        default:
            break
        }
    }

    func didEndEditing(textField: UITextField) {
        let field = self.form.sections.values[textField.superview!.tag].fields.values[textField.tag]
        switch field {
        case let integerField as IntegerField:
            textField.text = integerField.displayValue
        default:
            break
        }
        self.didEndEditing(field: field)
    }

    func didChange(valueSwitch: UISwitch) {
        let field = self.form.sections.values[valueSwitch.superview!.tag].fields.values[valueSwitch.tag]
        (field as! BoolField).value = valueSwitch.isOn
    }

    func didChange(segmentedControl: UISegmentedControl) {
        let field = self.form.sections.values[segmentedControl.superview!.tag].fields.values[segmentedControl.tag]
        (field as! SelectField).value = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
    }

    func didTap(helpButton: UIButton) {
        let formSection = self.form.sections.values[helpButton.tag]
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(formSection.helpURL!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(formSection.helpURL!)
        }
    }
}

extension FormViewController/*: UITableViewDataSource*/ {
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return self.form.sections.count
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.sections.values[section].fields.count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = self.form.sections.values[indexPath.section].fields.values[indexPath.row]
        switch field {
        case let simpleField as SimpleField:
            let cell = tableView.dequeueReusableCell(withIdentifier: SimpleFieldTableViewCell.identifier, for: indexPath) as! SimpleFieldTableViewCell

            cell.valueField.isUserInteractionEnabled = true
            cell.selectionStyle = .none
            cell.nameLabel.text = field.label
            cell.valueField.placeholder = simpleField.placeholder
            cell.valueField.keyboardType = simpleField.keyboard
            cell.valueField.autocapitalizationType = simpleField.autoCapitalize
            cell.valueField.autocorrectionType = simpleField.autoCorrect ? .yes : .no
            cell.valueField.isSecureTextEntry = simpleField.isSecureEntry
            cell.valueField.text = simpleField.displayValue
            cell.nameLabelWidth = self.nameLabelWidth
            cell.valueField.superview!.tag = indexPath.section
            cell.valueField.tag = indexPath.row
            cell.valueField.removeTarget(self, action: #selector(didChange(textField:)), for: .allEvents)
            cell.valueField.addTarget(self, action: #selector(didChange(textField:)), for: .editingChanged)
            cell.valueField.addTarget(self, action: #selector(didEndEditing(textField:)), for: .editingDidEnd)
            cell.valueField.delegate = self
            if simpleField is IntegerField {
                cell.valueField.addTarget(self, action: #selector(didStartEditing(textField:)), for: .editingDidBegin)
            }
            cell.accessoryType = .none

            return cell
        case let boolField as BoolField:
            let cell = tableView.dequeueReusableCell(withIdentifier: BoolFieldTableViewCell.identifier, for: indexPath) as! BoolFieldTableViewCell

            cell.selectionStyle = .none
            cell.nameLabel.text = field.label
            cell.valueSwitch.isOn = boolField.value
            cell.nameLabelWidth = self.nameLabelWidth
            cell.valueSwitch.superview!.tag = indexPath.section
            cell.valueSwitch.tag = indexPath.row
            cell.valueSwitch.removeTarget(self, action: #selector(didChange(valueSwitch:)), for: .allEvents)
            cell.valueSwitch.addTarget(self, action: #selector(didChange(valueSwitch:)), for: .valueChanged)

            return cell
        case let customField as CustomViewControllerField:
            let cell = tableView.dequeueReusableCell(withIdentifier: SimpleFieldTableViewCell.identifier, for: indexPath) as! SimpleFieldTableViewCell

            cell.valueField.isUserInteractionEnabled = false
            cell.selectionStyle = customField.isEditable ? .default : .none
            cell.nameLabel.text = field.label
            cell.valueField.placeholder = ""
            cell.valueField.keyboardType = .default
            cell.valueField.autocapitalizationType = .none
            cell.valueField.autocorrectionType = .no
            cell.valueField.isSecureTextEntry = false
            cell.valueField.text = field.displayValue
            cell.nameLabelWidth = self.nameLabelWidth
            cell.valueField.superview!.tag = indexPath.section
            cell.valueField.tag = indexPath.row
            cell.valueField.removeTarget(self, action: #selector(didChange(textField:)), for: .allEvents)
            cell.accessoryType = customField.isEditable ? .disclosureIndicator : .none
            if customField.canBeCleared {
                cell.set(clearCallback: { [weak self] button in
                    guard button.tag == indexPath.row && button.superview!.tag == indexPath.section else { return }

                    customField.value = nil
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                })
                cell.clearButton!.tag = indexPath.row
            }

            return cell
        case let actionField as ActionField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Action")
                ?? UITableViewCell(style: .default, reuseIdentifier: "Action")

            cell.textLabel?.text = actionField.label

            return cell
        case let selectField as SelectField where selectField.options.count <= 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlTableViewCell.identifier, for: indexPath) as! SegmentedControlTableViewCell

            cell.selectionStyle = .none
            cell.nameLabel.text = field.label
            cell.segmentedControl.removeAllSegments()
            for (i, option) in selectField.options.enumerated() {
                cell.segmentedControl.insertSegment(withTitle: option, at: i, animated: false)
                if selectField.value == option {
                    cell.segmentedControl.selectedSegmentIndex = i
                }
            }
            cell.segmentedControl.superview!.tag = indexPath.section
            cell.segmentedControl.tag = indexPath.row
            cell.segmentedControl.removeTarget(self, action: #selector(didChange(segmentedControl:)), for: .allEvents)
            cell.segmentedControl.addTarget(self, action: #selector(didChange(segmentedControl:)), for: .valueChanged)
            cell.nameLabelWidth = self.nameLabelWidth

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SimpleFieldTableViewCell.identifier, for: indexPath) as! SimpleFieldTableViewCell

            cell.valueField.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            cell.nameLabel.text = field.label
            cell.valueField.placeholder = ""
            cell.valueField.keyboardType = .default
            cell.valueField.autocapitalizationType = .none
            cell.valueField.isSecureTextEntry = false
            cell.valueField.text = field.displayValue
            cell.nameLabelWidth = self.nameLabelWidth
            cell.valueField.superview!.tag = indexPath.section
            cell.valueField.tag = indexPath.row
            cell.valueField.removeTarget(self, action: #selector(didChange(textField:)), for: .allEvents)
            cell.accessoryType = .none

            return cell
        }
    }
}

extension FormViewController/*: UITableViewDelegate*/ {
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.form.sections.values[section].name
    }

    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let formSection = self.form.sections.values[section]
        let view = UIView()

        let label = UILabel()
        label.text = formSection.name.uppercased()
        label.textColor = UIColor(hex: 0x6d6d72)
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addConstraints([
            NSLayoutConstraint(leftOf: label, to: view, distance: 8),
            NSLayoutConstraint(topOf: label, to: view, distance: -10),
            NSLayoutConstraint(bottomOf: label, to: view, distance: 0),
        ])

        if let _ = formSection.helpURL {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Help", for: .normal)
            button.tag = section
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(UIColor(hex: 0x007aff), for: .normal)
            button.addTarget(self, action: #selector(didTap(helpButton:)), for: .touchUpInside)
            view.addSubview(button)

            view.addConstraints([
                NSLayoutConstraint(rightOf: label, toLeftOf: button, distance: 8),
                NSLayoutConstraint(topOf: button, to: view, distance: -6),
                NSLayoutConstraint(bottomOf: label, to: button, distance: 0),
                NSLayoutConstraint(rightOf: button, to: view, distance: 8),
            ])
        }
        else {
            view.addConstraint(NSLayoutConstraint(rightOf: label, to: view, distance: 8))
        }

        return view
    }

    open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.form.sections.values[section].help
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let field = self.form.sections.values[indexPath.section].fields.values[indexPath.row]
        switch field {
        case let customField as CustomViewControllerField:
            guard customField.isEditable else {
                return
            }

            let viewController = customField.buildViewController() { [unowned customField, unowned self] newValue in
                customField.value = newValue
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        case let actionField as ActionField:
            actionField.block()
            tableView.deselectRow(at: indexPath, animated: true)
        case let dateField as DateField:
            let viewController = ChooseDateViewController(date: dateField.value, includesDay: dateField.includesDay)
            let navController = UINavigationController(rootViewController: viewController)
            viewController.title = "Choose Date"
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: { [unowned viewController] in
                viewController.dismiss(animated: true, completion: nil)
            })
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: { [unowned viewController] in
                dateField.value = viewController.datePicker.date
                viewController.dismiss(animated: true, completion: nil)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                self.didEndEditing(field: dateField)
            })
            self.present(
                popoverViewController: navController,
                fromSourceView: tableView.cellForRow(at: indexPath)?.contentView ?? tableView,
                permittedArrowDirections: UIPopoverArrowDirection.down.union(.up),
                position: .middle
            ).delegate = self
        case let selectField as SelectField where selectField.options.count > 2:
            let viewController = SelectListViewController(options: selectField.options, onOptionChosen: { [weak self] option in
                selectField.value = option
                self?.dismiss(animated: true, completion: nil)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                self?.didEndEditing(field: selectField)
            })
            let navController = UINavigationController(rootViewController: viewController)
            viewController.title = "Choose Option"
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: { [unowned viewController] in
                viewController.dismiss(animated: true, completion: nil)
            })
            self.present(
                popoverViewController: navController,
                fromSourceView: tableView.cellForRow(at: indexPath)?.contentView ?? tableView,
                permittedArrowDirections: UIPopoverArrowDirection.down.union(.up),
                position: .middle
            )

        default:
            break
        }
    }
}

extension FormViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        let nextRowIndexPath = IndexPath(row: textField.tag + 1, section: textField.superview!.tag)
        let nextSectionIndexPath = IndexPath(row: 0, section: textField.superview!.tag + 1)
        guard let cell = self.tableView.cellForRow(at: nextRowIndexPath)
            ?? self.tableView.cellForRow(at: nextSectionIndexPath)
            else
        {
            return true
        }

        guard let simpleCell = cell as? SimpleFieldTableViewCell else {
            return true
        }

        simpleCell.valueField.becomeFirstResponder()
        return true
    }
}

extension FormViewController: UIPopoverPresentationControllerDelegate {
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        guard let nav = popoverPresentationController.presentedViewController as? UINavigationController
            , let button = nav.topViewController?.navigationItem.rightBarButtonItem
            , let action = button.action
            else
        {
            return true
        }
        button.target?.performSelector(onMainThread: action, with: nil, waitUntilDone: true)
        return true
    }
}

private extension FormViewController {
    static let font = UIFont.systemFont(ofSize: 16)

    static func calculateMaximumLabelWidth(for form: Form) -> CGFloat {
        var maxWidth: CGFloat = 0
        for section in form.sections.values {
            for field in section.fields.values {
                guard !(field is ActionField) else {
                    continue
                }
                let width = (field.label as NSString).size(attributes: [NSFontAttributeName:self.font]).width
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
    var buttonSize: CGFloat {
        return self.contentView.bounds.height
    }

    let nameLabel = UILabel()
    let valueField = UITextField()
    private(set) var clearButton: RoundedBorderButton?
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate override func layoutSubviews() {
        super.layoutSubviews()

        self.nameLabel.frame = CGRect(x: 8, y: 2, width: self.nameLabelWidth, height: self.contentView.bounds.height - 4)
        var valueFieldWidth = self.contentView.bounds.width - self.nameLabel.frame.maxX - 16

        if let button = self.clearButton {
            valueFieldWidth -= self.contentView.bounds.height + self.buttonSize

            button.frame = CGRect(
                x: self.contentView.bounds.width - 44,
                y: (self.contentView.bounds.height - self.buttonSize) / 2,
                width: self.buttonSize,
                height: self.buttonSize
            )
        }

        self.valueField.frame = CGRect(
            x: self.nameLabel.frame.maxX + 8,
            y: self.nameLabel.frame.minY,
            width: valueFieldWidth,
            height: self.nameLabel.frame.height
        )
    }

    func set(clearCallback: @escaping (UIButton) -> ()) {
        let button = self.clearButton ?? RoundedBorderButton()
        button.setImage(UIImage(named: "clear-icon"), for: .normal)
        button.setBlock { [unowned button] in
            clearCallback(button)
        }
        self.contentView.addSubview(button)
        self.clearButton = button
    }

    func resetClearCallback() {
        self.clearButton?.removeFromSuperview()
        self.clearButton = nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.resetClearCallback()
    }
}

private class BoolFieldTableViewCell: UITableViewCell {
    static let identifier = "BoolField"

    let nameLabel = UILabel()
    let valueSwitch = UISwitch()
    var nameLabelWidth: CGFloat = 100

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.nameLabel.font = FormViewController.font
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueSwitch.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.valueSwitch)
    }

    fileprivate override func layoutSubviews() {
        super.layoutSubviews()

        self.nameLabel.frame = CGRect(x: 8, y: 2, width: self.nameLabelWidth, height: self.contentView.bounds.height - 4)
        self.valueSwitch.frame = CGRect(
            x: self.nameLabel.frame.maxX + 8,
            y: (self.contentView.bounds.height - self.valueSwitch.bounds.height) / 2,
            width: self.contentView.bounds.width - self.nameLabel.frame.maxX - 16,
            height: self.valueSwitch.bounds.height
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class SegmentedControlTableViewCell: UITableViewCell {
    static let identifier = "SegmentedField"

    let nameLabel = UILabel()
    let segmentedControl = UISegmentedControl()
    var nameLabelWidth: CGFloat = 100

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.nameLabel.font = FormViewController.font
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.segmentedControl)
    }

    fileprivate override func layoutSubviews() {
        super.layoutSubviews()

        self.nameLabel.frame = CGRect(x: 8, y: 2, width: self.nameLabelWidth, height: self.contentView.bounds.height - 4)
        self.segmentedControl.frame = CGRect(
            x: self.nameLabel.frame.maxX + 8,
            y: (self.contentView.bounds.height - 30) / 2,
            width: self.contentView.bounds.width - self.nameLabel.frame.maxX - 16,
            height: 30
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
