//
//  FormViewController.swift
//  Swiftlier
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
    let isEditable: Bool

    public init(form: Form, isEditable: Bool = true) {
        self.nameLabelWidth = FormViewController.calculateMaximumLabelWidth(for: form)
        self.form = form
        self.isEditable = isEditable

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
        self.tableView.register(TextViewFieldTableViewCell.self, forCellReuseIdentifier: TextViewFieldTableViewCell.identifier)
        self.tableView.register(SliderTableViewCell.self, forCellReuseIdentifier: SliderTableViewCell.identifier)

        if self.isEditable {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancel))
        }
    }

    open func submit() {
        fatalError("Must be overridden")
    }

    open func extraValidation() -> ValidationResult { return .passed }

    open func didEndEditing(field: Field) {}

    open func style(sectionHeader: UILabel) {}
    open func style(nameLabel: UILabel) {}
    open func style(valueField: UITextField) {}
    open func style(valueTextView: PlaceholderTextView) {}
    open func style(cell: UITableViewCell) {}

    @objc func cancel() {
        self.onBack?(true)
    }

    @objc public func done() {
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

    @objc func didChange(textField: UITextField) {
        let field = self.form.sections.values[textField.superview!.tag].fields.values[textField.tag]
        (field as! SimpleField).update(with: textField.text ?? "")
    }

    @objc func didStartEditing(textField: UITextField) {
        let field = self.form.sections.values[textField.superview!.tag].fields.values[textField.tag]
        switch field {
        case let numberField as AnyNumberField:
            textField.text = numberField.text
        default:
            break
        }
    }

    @objc func didEndEditing(textField: UITextField) {
        let field = self.form.sections.values[textField.superview!.tag].fields.values[textField.tag]
        switch field {
        case let numberField as AnyNumberField:
            textField.text = numberField.displayValue
        default:
            break
        }
        self.didEndEditing(field: field)
    }

    @objc func didChange(valueSwitch: UISwitch) {
        let field = self.form.sections.values[valueSwitch.superview!.tag].fields.values[valueSwitch.tag]
        (field as! BoolField).value = valueSwitch.isOn
        self.didEndEditing(field: field)
    }

    @objc func didChange(segmentedControl: UISegmentedControl) {
        let field = self.form.sections.values[segmentedControl.superview!.tag].fields.values[segmentedControl.tag]
        (field as! SelectField).value = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        self.didEndEditing(field: field)
    }

    @objc func didTap(helpButton: UIButton) {
        let formSection = self.form.sections.values[helpButton.tag]
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(formSection.helpURL!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(formSection.helpURL!)
        }
    }
    @objc func didChange(slider: UISlider) {
        let indexPath = IndexPath(row: slider.tag, section: slider.superview!.tag)

        let field = self.form.sections.values[indexPath.section].fields.values[indexPath.row] as! PercentField
        field.value = slider.value

        if let cell = self.tableView.cellForRow(at: indexPath) as? SliderTableViewCell {
            cell.valueLabel.text = "\(Int((slider.value * 100).rounded()))%"
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
        case let percentField as PercentField:
            let cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier, for: indexPath) as! SliderTableViewCell

            cell.selectionStyle = .none
            cell.nameLabel.text = field.label
            cell.accessoryType = .none
            cell.nameLabelWidth = self.nameLabelWidth
            cell.slider.minimumValue = percentField.minimumValue
            cell.slider.maximumValue = percentField.maximumValue
            cell.slider.value = percentField.value ?? 0
            cell.slider.superview!.tag = indexPath.section
            cell.slider.tag = indexPath.row
            cell.valueLabel.text = "\(Int(round((percentField.value ?? 0) * 100)))%"
            cell.slider.addTarget(self, action: #selector(didChange(slider:)), for: .valueChanged)

            return cell
        case let multilineField as MultilineField:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewFieldTableViewCell.identifier, for: indexPath) as! TextViewFieldTableViewCell

            cell.selectionStyle = .none
            cell.nameLabel.text = field.label
            cell.textView.placeholder = multilineField.placeholder
            cell.textView.keyboardType = multilineField.keyboard
            cell.textView.autocapitalizationType = multilineField.autoCapitalize
            cell.textView.isSecureTextEntry = multilineField.isSecureEntry
            cell.textView.text = field.displayValue
            cell.nameLabelWidth = self.nameLabelWidth
            cell.textView.superview!.tag = indexPath.section
            cell.textView.tag = indexPath.row
            cell.textView.delegate = self
            cell.accessoryType = .none

            if !self.isEditable {
                cell.isUserInteractionEnabled = false
            }

            self.style(nameLabel: cell.nameLabel)
            self.style(valueTextView: cell.textView)
            self.style(cell: cell)

            return cell
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
            if simpleField is AnyNumberField {
                cell.valueField.addTarget(self, action: #selector(didStartEditing(textField:)), for: .editingDidBegin)
            }
            cell.accessoryType = .none

            if !self.isEditable {
                cell.isUserInteractionEnabled = false
            }

            self.style(nameLabel: cell.nameLabel)
            self.style(valueField: cell.valueField)
            self.style(cell: cell)

            return cell
        case let boolField as BoolField:
            let cell = tableView.dequeueReusableCell(withIdentifier: BoolFieldTableViewCell.identifier, for: indexPath) as! BoolFieldTableViewCell

            cell.selectionStyle = .none
            cell.nameLabel.text = field.label
            cell.valueSwitch.isOn = boolField.value
            cell.valueSwitch.isEnabled = boolField.isEditable
            cell.nameLabelWidth = self.nameLabelWidth
            cell.messageLabel.text = boolField.message
            cell.valueSwitch.superview!.tag = indexPath.section
            cell.valueSwitch.tag = indexPath.row
            cell.valueSwitch.removeTarget(self, action: #selector(didChange(valueSwitch:)), for: .allEvents)
            cell.valueSwitch.addTarget(self, action: #selector(didChange(valueSwitch:)), for: .valueChanged)

            if !self.isEditable {
                cell.isUserInteractionEnabled = false
            }

            self.style(nameLabel: cell.nameLabel)
            self.style(cell: cell)

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

            if !self.isEditable {
                cell.isUserInteractionEnabled = false
            }

            self.style(nameLabel: cell.nameLabel)
            self.style(valueField: cell.valueField)
            self.style(cell: cell)

            return cell
        case let actionField as ActionField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Action")
                ?? UITableViewCell(style: .default, reuseIdentifier: "Action")

            cell.textLabel?.text = actionField.label

            if !self.isEditable {
                cell.isUserInteractionEnabled = false
            }

            if let label = cell.textLabel {
                self.style(nameLabel: label)
            }
            self.style(cell: cell)

            return cell
        case let selectField as SelectField where selectField.options.count <= 3:
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

            if !self.isEditable {
                cell.isUserInteractionEnabled = false
            }

            self.style(nameLabel: cell.nameLabel)
            self.style(cell: cell)

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SimpleFieldTableViewCell.identifier, for: indexPath) as! SimpleFieldTableViewCell

            cell.valueField.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            cell.nameLabel.text = field.label
            if field is SelectField {
                cell.valueField.placeholder = "Select..."
            }
            else {
                cell.valueField.placeholder = ""
            }
            cell.valueField.keyboardType = .default
            cell.valueField.autocapitalizationType = .none
            cell.valueField.isSecureTextEntry = false
            cell.valueField.text = field.displayValue
            cell.nameLabelWidth = self.nameLabelWidth
            cell.valueField.superview!.tag = indexPath.section
            cell.valueField.tag = indexPath.row
            cell.valueField.removeTarget(self, action: #selector(didChange(textField:)), for: .allEvents)
            cell.accessoryType = .none

            if !self.isEditable {
                cell.isUserInteractionEnabled = false
            }

            self.style(nameLabel: cell.nameLabel)
            self.style(valueField: cell.valueField)
            self.style(cell: cell)

            return cell
        }
    }
}

extension FormViewController/*: UITableViewDelegate*/ {
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.form.sections.values[section].name
    }

    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.form.sections.values[section].name.isEmpty ? 0 : 40
    }

    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let formSection = self.form.sections.values[section]
        let container = UITableViewHeaderFooterView()
        container.textLabel?.isHidden = true
        let view = container.contentView

        let label = UILabel()
        label.text = formSection.name.uppercased()
        label.textColor = UIColor(hex: 0x6d6d72)
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.style(sectionHeader: label)

        view.addSubview(label)

        view.constrain(.left, of: label, plus: 16)
        view.constrain(.top, of: label, plus: 10)
        view.constrain(.bottom, of: label)

        if let _ = formSection.helpURL {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Help", for: .normal)
            button.tag = section
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(UIColor(hex: 0x007aff), for: .normal)
            button.addTarget(self, action: #selector(didTap(helpButton:)), for: .touchUpInside)
            view.addSubview(button)

            NSLayoutConstraint(.left, of: button, to: .right, of: label, plus: 12)
            NSLayoutConstraint(.top, of: button, to: .top, of: label, plus: 6)
            NSLayoutConstraint(.bottom, of: button, to: .bottom, of: label)
            view.constrain(.right, of: button, plus: -16)
        }
        else {
            view.constrain(.right, of: label, plus: -16)
        }

        return container
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

            self.view.endEditing(true)

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
        case let selectField as SelectField where selectField.options.count > 3:
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

extension FormViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        let field = self.form.sections.values[textView.superview!.tag].fields.values[textView.tag]
        (field as! MultilineField).update(with: textView.text ?? "")
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
                let width = (field.label as NSString).size(withAttributes: [NSAttributedStringKey.font:self.font]).width
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

    let nameLabel: UILabel
    let valueField = UITextField()

    private var customConstraints = [NSLayoutConstraint]()
    private(set) var clearButton: RoundedBorderButton? {
        didSet {
            if let button = clearButton {
                 button.translatesAutoresizingMaskIntoConstraints = false
                self.contentView.addSubview(button)
            }
            self.resetConstraints()
        }
    }
    private let nameLabelWidthConstraint: NSLayoutConstraint

    var nameLabelWidth: CGFloat {
        get {
            return self.nameLabelWidthConstraint.constant
        }

        set {
            self.nameLabelWidthConstraint.constant = newValue
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let nameLabel = UILabel()
        self.nameLabel = nameLabel
        self.nameLabelWidthConstraint = NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.nameLabel.font = FormViewController.font
        self.valueField.font = FormViewController.font
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueField.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.valueField)

        self.nameLabel.addConstraint(self.nameLabelWidthConstraint)
        self.nameLabel.constrain(.height, to: 50)
        self.resetConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(clearCallback: @escaping (UIButton) -> ()) {
        let button = self.clearButton ?? RoundedBorderButton()
        button.setImage(UIImage(named: "clear-icon"), for: .normal)
        button.setBlock { [unowned button] in
            clearCallback(button)
        }
        button.constrain(.height, to: 44)
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 1, constant: 0))
        self.contentView.addSubview(button)
        self.clearButton = button
    }

    func resetClearCallback() {
        self.clearButton?.removeFromSuperview()
        self.clearButton = nil
    }

    func resetConstraints() {
        self.contentView.removeConstraints(self.customConstraints)

        self.customConstraints = []
        let leftConstraint = self.contentView.readableContentGuide.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor)
        leftConstraint.isActive = true
        self.customConstraints += [
            self.contentView.constrain(.top, of: self.nameLabel, plus: 2),
            self.contentView.constrain(.centerY, of: self.nameLabel),
            leftConstraint,

            NSLayoutConstraint(.right, of: self.nameLabel, to: .left, of: self.valueField, plus: -8),
            NSLayoutConstraint(.top, of: self.nameLabel, to: .top, of: self.valueField),
            NSLayoutConstraint(.bottom, of: self.nameLabel, to: .bottom, of: self.valueField),
        ]

        if let button = self.clearButton {
            let rightConstraint = self.contentView.readableContentGuide.rightAnchor.constraint(equalTo: button.rightAnchor)
            rightConstraint.isActive = true
            self.customConstraints += [
                NSLayoutConstraint(.right, of: self.valueField, to: .left, of: button, plus: -8),
                NSLayoutConstraint(.centerY, of: button, to: .centerY, of: self.nameLabel),
                rightConstraint,
            ]
        }
        else {
            let rightConstraint = self.contentView.readableContentGuide.rightAnchor.constraint(equalTo: self.valueField.rightAnchor)
            rightConstraint.isActive = true
            self.customConstraints += [
                rightConstraint,
            ]
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.resetClearCallback()
    }
}

private class BoolFieldTableViewCell: UITableViewCell {
    static let identifier = "BoolField"

    let nameLabel: UILabel
    let valueSwitch = UISwitch()
    let messageLabel = UILabel()
    private let nameLabelWidthConstraint: NSLayoutConstraint

    var nameLabelWidth: CGFloat {
        get {
            return self.nameLabelWidthConstraint.constant
        }

        set {
            self.nameLabelWidthConstraint.constant = newValue
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let nameLabel = UILabel()
        self.nameLabel = nameLabel
        self.nameLabelWidthConstraint = NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.nameLabel.font = FormViewController.font
        self.messageLabel.font = FormViewController.font
        self.messageLabel.textColor = UIColor.darkGray

        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.valueSwitch)
        self.contentView.addSubview(self.messageLabel)

        self.nameLabel.addConstraint(self.nameLabelWidthConstraint)
        self.nameLabel.constrain(.height, to: 50)
        self.messageLabel.constrain(.height, to: 50)

        self.contentView.constrain(.top, of: self.nameLabel, plus: 2)
        self.contentView.constrain(.centerY, of: self.nameLabel)
        self.contentView.readableContentGuide.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor).isActive = true

        self.contentView.constrain(.centerY, of: self.valueSwitch)
        NSLayoutConstraint(.right, of: self.nameLabel, to: .left, of: self.valueSwitch, plus: -8)

        self.contentView.constrain(.centerY, of: self.messageLabel)
        NSLayoutConstraint(.right, of: self.valueSwitch, to: .left, of: self.messageLabel, plus: -8)
        self.contentView.readableContentGuide.rightAnchor.constraint(equalTo: self.messageLabel.rightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class TextViewFieldTableViewCell: UITableViewCell {
    static let identifier = "TextViewField"

    let nameLabel: UILabel
    let textView = PlaceholderTextView()
    private let nameLabelWidthConstraint: NSLayoutConstraint

    var nameLabelWidth: CGFloat {
        get {
            return self.nameLabelWidthConstraint.constant
        }

        set {
            self.nameLabelWidthConstraint.constant = newValue
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let nameLabel = UILabel()
        self.nameLabel = nameLabel
        self.nameLabelWidthConstraint = NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.nameLabel.font = FormViewController.font
        self.textView.font = FormViewController.font
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textView.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.textView)

        self.nameLabel.addConstraint(self.nameLabelWidthConstraint)
        self.nameLabel.constrain(.height, to: 50)
        self.textView.constrain(.height, to: 120)

        self.contentView.constrain(.top, of: self.nameLabel, plus: 2)
        self.contentView.readableContentGuide.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor).isActive = true

        NSLayoutConstraint(.right, of: self.nameLabel, to: .left, of: self.textView, plus: -8)
        self.contentView.constrain(.top, of: self.textView, plus: 4)
        self.contentView.readableContentGuide.rightAnchor.constraint(equalTo: self.textView.rightAnchor).isActive = true
        self.contentView.constrain(.centerY, of: self.textView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class SegmentedControlTableViewCell: UITableViewCell {
    static let identifier = "SegmentedField"

    let nameLabel: UILabel
    let segmentedControl = UISegmentedControl()
    private let nameLabelWidthConstraint: NSLayoutConstraint

    var nameLabelWidth: CGFloat {
        get {
            return self.nameLabelWidthConstraint.constant
        }

        set {
            self.nameLabelWidthConstraint.constant = newValue
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let nameLabel = UILabel()
        self.nameLabel = nameLabel
        self.nameLabelWidthConstraint = NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.nameLabel.font = FormViewController.font
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.segmentedControl)

        self.nameLabel.addConstraint(self.nameLabelWidthConstraint)
        self.nameLabel.constrain(.height, to: 50)
        self.segmentedControl.constrain(.height, to: 30)

        self.contentView.constrain(.top, of: self.nameLabel, plus: 2)
        self.contentView.constrain(.centerY, of: self.nameLabel)
        self.contentView.readableContentGuide.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor).isActive = true

        NSLayoutConstraint(.right, of: self.nameLabel, to: .left, of: self.segmentedControl, plus: -8)
        NSLayoutConstraint(.centerY, of: self.segmentedControl, to: .centerY, of: self.nameLabel)
        self.contentView.readableContentGuide.rightAnchor.constraint(equalTo: self.segmentedControl.rightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class SliderTableViewCell: UITableViewCell {
    static let identifier = "SliderField"

    let nameLabel: UILabel
    let slider = UISlider()
    let valueLabel = UILabel()
    private let nameLabelWidthConstraint: NSLayoutConstraint

    var nameLabelWidth: CGFloat {
        get {
            return self.nameLabelWidthConstraint.constant
        }

        set {
            self.nameLabelWidthConstraint.constant = newValue
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let nameLabel = UILabel()
        self.nameLabel = nameLabel
        self.nameLabelWidthConstraint = NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.nameLabel.font = FormViewController.font
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueLabel.textAlignment = .center

        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.slider)
        self.contentView.addSubview(self.valueLabel)

        self.nameLabel.addConstraint(self.nameLabelWidthConstraint)
        self.nameLabel.constrain(.height, to: 50)
        self.valueLabel.constrain(.width, to: 56)
        NSLayoutConstraint(.height, of: self.nameLabel, to: .height, of: self.valueLabel)
        NSLayoutConstraint(.centerY, of: self.nameLabel, to: .centerY, of: self.valueLabel)

        self.contentView.constrain(.top, of: self.nameLabel, plus: 2)
        self.contentView.constrain(.centerY, of: self.nameLabel)
        self.contentView.readableContentGuide.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor).isActive = true

        NSLayoutConstraint(.right, of: self.nameLabel, to: .left, of: self.slider, plus: -8)
        NSLayoutConstraint(.right, of: self.slider, to: .left, of: self.valueLabel, plus: -8)
        NSLayoutConstraint(.centerY, of: self.slider, to: .centerY, of: self.nameLabel)
        self.contentView.readableContentGuide.rightAnchor.constraint(equalTo: self.valueLabel.rightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
