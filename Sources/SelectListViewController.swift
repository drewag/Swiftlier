//
//  SelectListViewController.swift
//  Swiftlier
//
//  Created by Andrew Wagner on 2/22/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

open class SelectListViewController: UITableViewController {
    static let Font: UIFont = UIFont.systemFont(ofSize: 16)

    let onOptionChosen: (String) -> ()
    let options: [String]

    public init(options: [String], onOptionChosen: @escaping (String) -> ()) {
        self.onOptionChosen = onOptionChosen
        self.options = options

        super.init(style: .plain)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.reloadData()

        var width: CGFloat = 200
        for option in self.options {
            width = max(width, (option as NSString).size(attributes: [
                NSFontAttributeName: SelectListViewController.Font
            ]).width + 32)
        }

        self.preferredContentSize = CGSize(
            width: width,
            height: self.tableView.contentSize.height
        )
    }
}

extension SelectListViewController/*: UITableViewDataSource*/ {
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
            ?? UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")

        cell.textLabel!.text = self.options[indexPath.row]
        cell.textLabel!.font = SelectListViewController.Font
        cell.textLabel!.textColor = UIColor(hex: 0x666666)

        return cell
    }
}

extension SelectListViewController/*: UITableViewDelegate*/ {
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onOptionChosen(self.options[indexPath.row])
    }
}
#endif
