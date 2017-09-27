[![Swift](https://img.shields.io/badge/swift-4-orange.svg?style=flat)](https://swift.org)
![platforms](https://img.shields.io/badge/platform-iOS%20macOS%20Linux-orange.svg?style=flat)
![SPM](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange.svg?style=flat)
[![MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](/LICENSE)
[![Build Status](https://travis-ci.org/drewag/Swiftlier.svg?branch=master)](https://travis-ci.org/drewag/Swiftlier)

Swiftlier
=============

Library for common enhancements to the Swift language as well as for Foundation and UIKit frameworks with
support for iOS, macOS, and Linux.

**Note:** Certain functionality is only available on specific platforms. For example, helpers on UIViewController
will only be available on iOS while the ability to run a shell command is only available on OS X and Linux.

Goals
=====

Create a common library of generic extensions and types that are useful across many
projects. This would allow developers to use more advanced features while maintaining
readability. You are encouraged to submit pull requests or issues with additional features
that we can discuss to see if they should be added.

Installation
========

iOS
--------------

### As git submodule

- Run `git submodle add https://github.com/drewag/Swiftlier.git external/Swiftlier`
- Drag 'SwiftlieriOS.xcodeproj' into your project
- Add `import Swiftlier` to the top of any file you would like to use this library in

Linux and macOS
----------------

### Using Swift Package Manager

    import PackageDescription

    let package = Package(
        name: "web",
        dependencies: [
            .Package(url: "https://github.com/drewag/Swiftlier.git", majorVersion: 3),
        ]
    )

High Level Tasks
=================

- [x] CI for macOS and Linux
- [ ] CI for iOS
- [ ] Comprehensive unit test coverage
- [ ] High level documentation to describe the major components
- [ ] In-line documentation for quick help in Xcode

Code Coverage
==============

- [x] Age
- [x] Alert
- [x] AlwaysEqual
- [x] Angle
- [x] Array+Sorting
- [x] Bool+Formatting
- [ ] BubbleView
- [ ] CGContext+ThreadSafe
- [x] CGMath
- [ ] CircleBorderView
- [ ] CommandLineDecoder
- [x] Data+Base64
- [x] Data+Processing
- [x] DataSourceType
- [ ] Date+Formatting
- [x] Date+Helpers
- [ ] DatePickerViewController
- [ ] DiagonalGradientView
- [x] Dictionary+Merging
- [ ] DispatchQueue+Helpers
- [x] Double+Formatting
- [ ] Email
- [x] EmailAddress
- [ ] EnergyFormatting
- [x] Enum+Convenience
- [ ] ErrorGenerating+ErrorFactory
- [x] EventCenter
- [ ] FileSystem
- [ ] Float+Factory
- [ ] Form
- [ ] FormViewController
- [x] HTML
- [x] HTTPStatus
- [ ] HeartRateFormatter
- [ ] Int+Random
- [ ] JSON+Encoding
- [ ] JSON
- [ ] KeyboardConstraintAdjuster
- [ ] LimitedSizeViewController
- [x] Mass
- [ ] Menu
- [ ] MenuViewController
- [ ] MonthAndYearPicker
- [x] MultiCallback
- [ ] NSLayoutConstraint+SwifPlusPlus
- [ ] NSLayoutContraint+Factory
- [ ] NativeTypesDecoder
- [ ] NativeTypesEncoder
- [ ] NativeTypesStructured
- [ ] NetworkUserReportableError
- [x] Observable
- [ ] ObservableArray
- [ ] ObservableDictionary
- [ ] ObservableReference
- [ ] OrderedDictionary
- [ ] PassThroughTouchView
- [x] PatchyRange
- [x] Path+Coding
- [x] Path
- [ ] PercentEncodable
- [x] PersistenceService
- [ ] PlaceholderTextView
- [ ] Price
- [ ] PrioritizedOperationQueue
- [ ] ReferenceTypePersistenceService
- [ ] ReportableError+Coding
- [ ] ReportableError
- [ ] RoundedBorderButton
- [ ] RoundedBorderView
- [ ] SelectListViewController
- [ ] SelectableValue
- [ ] SequenceType+Helpers
- [ ] ShadowView
- [ ] ShellCommand
- [ ] SpecDecoder
- [x] String+Helpers
- [ ] String+Random
- [ ] Structured
- [ ] Syncable
- [ ] TaskService
- [ ] ThinLayoutConstraint
- [ ] TimeInterval+Formatting
- [ ] Transformation
- [ ] UIBarButtonItem+BlockTarget
- [ ] UIButton+BlockTarget
- [ ] UICollectionView+EasyRegister
- [ ] UIColor+Encodable
- [x] UIColor+Factory
- [ ] UIDevice+AppIdioms
- [ ] UIImage+Editing
- [ ] UITableView+EasyRegister
- [ ] UIView+Helpers
- [ ] UIView+ImageCapture
- [ ] UIView+Layout
- [ ] UIView+Video
- [ ] UIViewController+Helpers
- [ ] UIViewController+PhotoViewing
- [ ] UIViewController+Transitions
- [ ] URL+Helpers
- [ ] ValueTypePersistenceService
- [ ] WeakWrapper
- [ ] WebViewController
- [ ] XML
- [ ] ZipFilePath
- [ ] ZoomThroughTransition
