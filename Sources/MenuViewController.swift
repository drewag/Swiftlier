//
//  MenuViewController.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/4/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit
import MessageUI

class MenuViewController: UITableViewController {
    static let ReuseIdentifier = "Cell"

    let menu: Menu

    init(menu: Menu) {
        self.menu = menu
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: MenuViewController.ReuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.menu.section.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.menu.section[section]
        return section.name.uppercased()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.section[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuViewController.ReuseIdentifier, for: indexPath)

        let menuItem = self.menuItem(for: indexPath)
        cell.textLabel?.text = menuItem.displayText()
        cell.imageView?.image = menuItem.icon
        switch menuItem.type {
        case .html(_):
            cell.accessoryType = .disclosureIndicator
        case .email(_), .externalURL(_):
            break
        }

        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = self.menuItem(for: indexPath)
        switch menuItem.type {
        case let .email(address, subject):
            let viewController = MFMailComposeViewController()
            viewController.setSubject(subject)
            viewController.setToRecipients([address])
            viewController.mailComposeDelegate = self
            self.transition(to: viewController, animated: true, embeddedInNavigationController: false)
        case let .externalURL(address):
            if let URL = URL(string: address) {
                UIApplication.shared.open(URL, options: [:], completionHandler: nil)
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
        }
    }
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.transitionBack(animated: true, onComplete: nil)
    }
}

private extension MenuViewController {
    func menuItem(for indexPath: IndexPath) -> MenuItem {
        return self.menu.section[indexPath.section].items[indexPath.row]
    }
}
#endif
