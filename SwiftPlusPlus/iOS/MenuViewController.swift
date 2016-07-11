//
//  MenuViewController.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/4/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import UIKit
import MessageUI

class MenuViewController: UITableViewController {
    static let ReuseIdentifier = "Cell"

    let menu: Menu

    init(menu: Menu) {
        self.menu = menu
        super.init(style: .Grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: MenuViewController.ReuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.menu.section.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.menu.section[section].name.uppercaseString
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.section[section].items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MenuViewController.ReuseIdentifier, forIndexPath: indexPath)

        let menuItem = self.menuItemWithIndexPath(indexPath)
        cell.textLabel?.text = menuItem.displayText()
        cell.imageView?.image = menuItem.icon
        switch menuItem.type {
        case .HTML(_):
            cell.accessoryType = .DisclosureIndicator
        case .Email(_), .ExternalURL(_):
            break
        }

        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuItem = self.menuItemWithIndexPath(indexPath)
        switch menuItem.type {
        case let .Email(address, subject):
            let viewController = MFMailComposeViewController()
            viewController.setSubject(subject)
            viewController.setToRecipients([address])
            viewController.mailComposeDelegate = self
            self.transitionToViewController(viewController, animated: true, embeddedInNavigationController: false)
        case let .ExternalURL(address):
            if let URL = NSURL(string: address) {
                UIApplication.sharedApplication().openURL(URL)
            }
            else {
                self.showAlert(withTitle: "Invalid URL", message: "The URL was '\(address)'. Please contact support.", other: [
                    .action("OK", handler: {
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    })
                ])
            }
            break
        case let .HTML(content):
            let viewController = WebViewController(HTML: content)
            viewController.title = menuItem.displayText()
            self.transitionToViewController(
                viewController,
                animated: true,
                transition: NavigationPushTransition()
            )
            break
        }
    }
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.transitionBackAnimated(true, onComplete: nil)
    }
}

private extension MenuViewController {
    func menuItemWithIndexPath(indexPath: NSIndexPath) -> MenuItem {
        return self.menu.section[indexPath.section].items[indexPath.row]
    }
}