//
//  AlertTests.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 4/29/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import XCTest
@testable import Swiftlier

class TestViewController: UIViewController {
    var didPresent: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.didPresent = viewControllerToPresent
        completion?()
    }
}

class MockAlertAction : UIAlertAction {
    typealias Handler = ((UIAlertAction) -> Void)
    var handler: Handler?
    var mockTitle: String?
    var mockStyle: UIAlertActionStyle

    override var title: String? {
        return mockTitle
    }

    override var style: UIAlertActionStyle {
        return mockStyle
    }

    convenience init(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) {
        self.init()

        self.mockTitle = title
        self.mockStyle = style

        self.handler = handler
    }
    
    override init() {
        self.mockStyle = .default
        
        super.init()
    }
}

final class AlertTests: XCTestCase, ErrorGenerating {
    override func setUp() {
        MakeAlertAction =  MockAlertAction.init
    }

    override func tearDown() {
        MakeAlertAction = UIAlertAction.init
    }

    func testAlertWithNoParameters() {
        let viewController = TestViewController()
        viewController.showAlert(withTitle: "Some Title", message: "Some Message")

        if let alert = viewController.didPresent as? UIAlertController {
            XCTAssertEqual(alert.title, "Some Title")
            XCTAssertEqual(alert.preferredStyle, .alert)
            XCTAssertEqual(alert.message, "Some Message")
            XCTAssertEqual(alert.actions.count, 1)
            XCTAssertEqual(alert.actions[0].title, "OK")
            XCTAssertEqual(alert.actions[0].style, .default)
            XCTAssertNil(alert.preferredAction)
            XCTAssertEqual((alert.textFields ?? []).count, 0)
        }
        else {
            XCTFail("Did not present an alert")
            return
        }
    }

    func testAlertWithError() {
        let viewController = TestViewController()
        let error = self.userError("making alert", because: "this was done on purpose")
        viewController.showAlert(withError: error)

        if let alert = viewController.didPresent as? UIAlertController {
            XCTAssertEqual(alert.title, error.alertDescription.title)
            XCTAssertEqual(alert.preferredStyle, .alert)
            XCTAssertEqual(alert.message, error.alertDescription.message)
            XCTAssertEqual(alert.actions.count, 1)
            XCTAssertEqual(alert.actions[0].title, "OK")
            XCTAssertEqual(alert.actions[0].style, .default)
            XCTAssertNil(alert.preferredAction)
            XCTAssertEqual((alert.textFields ?? []).count, 0)
        }
        else {
            XCTFail("Did not present an alert")
            return
        }
    }

    func testActionSheetWithNoParameters() {
        let viewController = TestViewController()
        viewController.showActionSheet(withTitle: "Some Title")

        if let alert = viewController.didPresent as? UIAlertController {
            XCTAssertEqual(alert.title, "Some Title")
            XCTAssertEqual(alert.preferredStyle, .actionSheet)
            XCTAssertNil(alert.message)
            XCTAssertEqual(alert.actions.count, 1)
            XCTAssertEqual(alert.actions[0].title, "OK")
            XCTAssertEqual(alert.actions[0].style, .default)
            XCTAssertNil(alert.preferredAction)
            XCTAssertEqual((alert.textFields ?? []).count, 0)
        }
        else {
            XCTFail("Did not present an alert")
            return
        }
    }

    func testActionSheetWithParameters() {
        var didCancel = false
        var didPrefer = false
        var didOther = false
        var didDestroy = false

        let viewController = TestViewController()
        viewController.showActionSheet(
            withTitle: "Different Title",
            message: "Different Message",
            cancel: .action("Cancel", handler: { didCancel = true }),
            preferred: .action("Prefered", handler: { didPrefer = true}),
            other: [
                .action("Other", handler: { didOther = true}),
                .action("Destroy", isDestructive: true, handler: { didDestroy = true}),
            ]
        )
        if let alert = viewController.didPresent as? UIAlertController {
            XCTAssertEqual(alert.title, "Different Title")
            XCTAssertEqual(alert.preferredStyle, .actionSheet)
            XCTAssertEqual(alert.message, "Different Message")
            XCTAssertEqual(alert.actions.count, 4)

            XCTAssertEqual(alert.actions[0].title, "Cancel")
            XCTAssertEqual(alert.actions[0].style, .cancel)

            XCTAssertEqual(alert.actions[1].title, "Prefered")
            XCTAssertEqual(alert.actions[1].style, .default)

            XCTAssertEqual(alert.actions[2].title, "Other")
            XCTAssertEqual(alert.actions[2].style, .default)

            XCTAssertEqual(alert.actions[3].title, "Destroy")
            XCTAssertEqual(alert.actions[3].style, .destructive)

            XCTAssertEqual(alert.preferredAction?.title, "Prefered")
            XCTAssertEqual(alert.preferredAction?.style, .default)

            XCTAssertEqual(alert.textFields ?? [], [])

            XCTAssertFalse(didCancel)
            XCTAssertFalse(didPrefer)
            XCTAssertFalse(didOther)
            XCTAssertFalse(didDestroy)

            (alert.actions[0] as! MockAlertAction).handler?(alert.actions[0])
            XCTAssertTrue(didCancel)
            XCTAssertFalse(didPrefer)
            XCTAssertFalse(didOther)
            XCTAssertFalse(didDestroy)

            (alert.actions[1] as! MockAlertAction).handler?(alert.actions[1])
            XCTAssertTrue(didCancel)
            XCTAssertTrue(didPrefer)
            XCTAssertFalse(didOther)
            XCTAssertFalse(didDestroy)

            (alert.actions[2] as! MockAlertAction).handler?(alert.actions[2])
            XCTAssertTrue(didCancel)
            XCTAssertTrue(didPrefer)
            XCTAssertTrue(didOther)
            XCTAssertFalse(didDestroy)

            (alert.actions[3] as! MockAlertAction).handler?(alert.actions[3])
            XCTAssertTrue(didCancel)
            XCTAssertTrue(didPrefer)
            XCTAssertTrue(didOther)
            XCTAssertTrue(didDestroy)
        }
        else {
            XCTFail("Did not present an alert")
            return
        }
    }

    func testAlertWithParameters() {
        var didCancel = false
        var didPrefer = false
        var didOther = false
        var didDestroy = false

        let viewController = TestViewController()
        viewController.showAlert(
            withTitle: "Different Title",
            message: "Different Message",
            cancel: .action("Cancel", handler: { didCancel = true }),
            preferred: .action("Prefered", handler: { didPrefer = true}),
            other: [
                .action("Other", handler: { didOther = true}),
                .action("Destroy", isDestructive: true, handler: { didDestroy = true}),
            ]
        )
        if let alert = viewController.didPresent as? UIAlertController {
            XCTAssertEqual(alert.title, "Different Title")
            XCTAssertEqual(alert.preferredStyle, .alert)
            XCTAssertEqual(alert.message, "Different Message")
            XCTAssertEqual(alert.actions.count, 4)

            XCTAssertEqual(alert.actions[0].title, "Cancel")
            XCTAssertEqual(alert.actions[0].style, .cancel)

            XCTAssertEqual(alert.actions[1].title, "Prefered")
            XCTAssertEqual(alert.actions[1].style, .default)

            XCTAssertEqual(alert.actions[2].title, "Other")
            XCTAssertEqual(alert.actions[2].style, .default)

            XCTAssertEqual(alert.actions[3].title, "Destroy")
            XCTAssertEqual(alert.actions[3].style, .destructive)

            XCTAssertEqual(alert.preferredAction?.title, "Prefered")
            XCTAssertEqual(alert.preferredAction?.style, .default)

            XCTAssertEqual(alert.textFields ?? [], [])

            XCTAssertFalse(didCancel)
            XCTAssertFalse(didPrefer)
            XCTAssertFalse(didOther)
            XCTAssertFalse(didDestroy)

            (alert.actions[0] as! MockAlertAction).handler?(alert.actions[0])
            XCTAssertTrue(didCancel)
            XCTAssertFalse(didPrefer)
            XCTAssertFalse(didOther)
            XCTAssertFalse(didDestroy)

            (alert.actions[1] as! MockAlertAction).handler?(alert.actions[1])
            XCTAssertTrue(didCancel)
            XCTAssertTrue(didPrefer)
            XCTAssertFalse(didOther)
            XCTAssertFalse(didDestroy)

            (alert.actions[2] as! MockAlertAction).handler?(alert.actions[2])
            XCTAssertTrue(didCancel)
            XCTAssertTrue(didPrefer)
            XCTAssertTrue(didOther)
            XCTAssertFalse(didDestroy)

            (alert.actions[3] as! MockAlertAction).handler?(alert.actions[3])
            XCTAssertTrue(didCancel)
            XCTAssertTrue(didPrefer)
            XCTAssertTrue(didOther)
            XCTAssertTrue(didDestroy)
        }
        else {
            XCTFail("Did not present an alert")
            return
        }
    }

    func testTestInputWithNoParameters() {
        let viewController = TestViewController()
        viewController.showTextInput(withTitle: "Some Title", message: "Some Message")

        if let alert = viewController.didPresent as? UIAlertController {
            XCTAssertEqual(alert.title, "Some Title")
            XCTAssertEqual(alert.preferredStyle, .alert)
            XCTAssertEqual(alert.message, "Some Message")
            XCTAssertEqual(alert.actions.count, 1)
            XCTAssertEqual(alert.actions[0].title, "OK")
            XCTAssertEqual(alert.actions[0].style, .default)
            XCTAssertNil(alert.preferredAction)
            XCTAssertEqual((alert.textFields ?? []).count, 1)
        }
        else {
            XCTFail("Did not present an alert")
            return
        }
    }

    func testTestInputWithParameters() {
        var canceledText: String?
        var preferredText: String?
        var otherText: String?
        var destroyedText: String?

        let viewController = TestViewController()
        viewController.showTextInput(
            withTitle: "Different Title",
            message: "Different Message",
            cancel: .action("Cancel", handler: { t in canceledText = t }),
            preferred: .action("Prefered", handler: { t in preferredText = t }),
            other: [
                .action("Other", handler: { t in otherText = t }),
                .action("Destroy", isDestructive: true, handler: { t in destroyedText = t }),
            ]
        )
        if let alert = viewController.didPresent as? UIAlertController {
            XCTAssertEqual(alert.title, "Different Title")
            XCTAssertEqual(alert.preferredStyle, .alert)
            XCTAssertEqual(alert.message, "Different Message")
            XCTAssertEqual(alert.actions.count, 4)

            XCTAssertEqual(alert.actions[0].title, "Cancel")
            XCTAssertEqual(alert.actions[0].style, .cancel)

            XCTAssertEqual(alert.actions[1].title, "Prefered")
            XCTAssertEqual(alert.actions[1].style, .default)

            XCTAssertEqual(alert.actions[2].title, "Other")
            XCTAssertEqual(alert.actions[2].style, .default)

            XCTAssertEqual(alert.actions[3].title, "Destroy")
            XCTAssertEqual(alert.actions[3].style, .destructive)

            XCTAssertEqual(alert.preferredAction?.title, "Prefered")
            XCTAssertEqual(alert.preferredAction?.style, .default)

            XCTAssertEqual(alert.textFields?.count, 1)

            XCTAssertNil(canceledText)
            XCTAssertNil(preferredText)
            XCTAssertNil(otherText)
            XCTAssertNil(destroyedText)

            alert.textFields![0].text = "Canceled"
            (alert.actions[0] as! MockAlertAction).handler?(alert.actions[0])
            XCTAssertEqual(canceledText, "Canceled")
            XCTAssertNil(preferredText)
            XCTAssertNil(otherText)
            XCTAssertNil(destroyedText)

            alert.textFields![0].text = "Preferred"
            (alert.actions[1] as! MockAlertAction).handler?(alert.actions[1])
            XCTAssertEqual(canceledText, "Canceled")
            XCTAssertEqual(preferredText, "Preferred")
            XCTAssertNil(otherText)
            XCTAssertNil(destroyedText)

            alert.textFields![0].text = "Other"
            (alert.actions[2] as! MockAlertAction).handler?(alert.actions[2])
            XCTAssertEqual(canceledText, "Canceled")
            XCTAssertEqual(preferredText, "Preferred")
            XCTAssertEqual(otherText, "Other")
            XCTAssertNil(destroyedText)

            alert.textFields![0].text = "Destroyed"
            (alert.actions[3] as! MockAlertAction).handler?(alert.actions[3])
            XCTAssertEqual(canceledText, "Canceled")
            XCTAssertEqual(preferredText, "Preferred")
            XCTAssertEqual(otherText, "Other")
            XCTAssertEqual(destroyedText, "Destroyed")
        }
        else {
            XCTFail("Did not present an alert")
            return
        }
    }
}
#endif
