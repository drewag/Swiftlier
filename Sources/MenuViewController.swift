//
//  MenuViewController.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 11/4/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit
import MessageUI

public class MenuViewController: UITableViewController {
    static let ReuseIdentifier = "Cell"
    static let font = UIFont.systemFont(ofSize: 17)

    let menu: Menu
    public var textColor = UIColor.black
    public var selectionColor: UIColor?

    public init(menu: Menu) {
        self.menu = menu

        let hasSingleUnnamedSection = (menu.sections.count == 1 && menu.sections[0].name == nil)
        super.init(style: hasSingleUnnamedSection ? .plain : .grouped)

        if hasSingleUnnamedSection {
            var textWidth: CGFloat = 50
            for item in menu.sections[0].items {
                var size = (item.displayText() as NSString).size(withAttributes: [.font: MenuViewController.font])
                if item.isSelected {
                    size.width += 20
                }
                textWidth = max(textWidth, size.width)
            }
            self.preferredContentSize = CGSize(
                width: textWidth + 81,
                height: CGFloat(menu.sections[0].items.count * 44)
            )
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: MenuViewController.ReuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.tableView.isScrollEnabled = size.height > self.tableView.bounds.height
    }

    // MARK: UITableViewDataSource

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return self.menu.sections.count
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.menu.sections[section]
        return section.name?.uppercased()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.sections[section].items.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuViewController.ReuseIdentifier, for: indexPath)

        let menuItem = self.menuItem(for: indexPath)
        cell.textLabel?.textColor = self.textColor
        cell.textLabel?.text = menuItem.displayText()
        cell.textLabel?.font = type(of: self).font
        cell.imageView?.image = menuItem.icon
        cell.backgroundColor = tableView.backgroundColor
        cell.accessoryType = menuItem.isSelected ? .checkmark : .none
        if let color = self.selectionColor {
            cell.selectedBackgroundView = UIView()
            cell.selectedBackgroundView?.backgroundColor = color
        }
        switch menuItem.action {
        case .html:
            cell.accessoryType = .disclosureIndicator
        case .email, .externalURL, .callback:
            break
        }

        return cell
    }

    // MARK: UITableViewDelegate

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = self.menuItem(for: indexPath)
        switch menuItem.action {
        case let .email(address, subject):
            let viewController = MFMailComposeViewController()
            viewController.setSubject(subject)
            viewController.setToRecipients([address])
            viewController.mailComposeDelegate = self
            self.transition(to: viewController, animated: true, embeddedInNavigationController: false)
        case let .externalURL(address):
            if let URL = URL(string: address) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL)
                }
            }
            else {
                self.showAlert(withTitle: "Invalid URL", message: "The URL was '\(address)'. Please contact support.", other: [
                    .action("OK", handler: {
                        tableView.deselectRow(at: indexPath, animated: true)
                    })
                ])
            }
            break
        case let .html(content):
            let viewController = WebViewController(HTML: content)
            viewController.title = menuItem.displayText()
            self.transition(
                to: viewController,
                animated: true,
                transition: NavigationPushTransition()
            )
            break
        case let .callback(callback):
            callback({ [weak self] completion in
                self?.dismiss(animated: true, completion: completion)
            })
        }
    }
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.transitionBack(animated: true, onComplete: nil)
    }
}

private extension MenuViewController {
    func menuItem(for indexPath: IndexPath) -> MenuItem {
        return self.menu.sections[indexPath.section].items[indexPath.row]
    }
}
#endif
