![Swiftlier - Enhanced SwiftLang](https://github.com/drewag/Swiftlier/raw/master/Assets/Header.jpg)

[![Swift](https://img.shields.io/badge/Swift-5.1-lightgrey.svg?colorA=28a745&colorB=4E4E4E)](https://swift.org)
![platforms](https://img.shields.io/badge/Platforms-iOS%208%20%7C%20macOS%2010.10%20%7C%20Linux-lightgrey.svg?colorA=28a745&colorB=4E4E4E)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/apple/swift-package-manager)
[![MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](/LICENSE)

[![Twitter @drewag](https://img.shields.io/badge/Twitter-@drewag-blue.svg?style=flat)](http://twitter.com/drewag)
[![Blog drewag.me](https://img.shields.io/badge/Blog-drewag.me-blue.svg?style=flat)](http://drewag.me)

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
```swift
import PackageDescription

let package = Package(
    name: "web",
    dependencies: [
        .package(url: "https://github.com/drewag/Swiftlier.git", from: "4.0.0"),
    ]
)
```
High Level Tasks
=================

- [x] CI for macOS and Linux
- [ ] CI for iOS
- [ ] Comprehensive unit test coverage
- [ ] High level documentation to describe the major components
- [ ] In-line documentation for quick help in Xcode

Code Coverage
==============

All Platforms
-----------

- [x] Age
- [x] Alert
- [x] AlwaysEqual
- [x] Angle
- [x] Array+Sorting
- [ ] BinarySearchTree
- [x] Bool+Formatting
- [x] CGMath
- [x] Coding+Helpers
- [ ] CommandLineDecoder
- [x] Data+Base64
- [x] Data+Processing
- [x] DataSourceType
- [ ] Date+Formatting
- [x] Date+Helpers
- [x] Day
- [x] Dictionary+Merging
- [x] Double+Formatting
- [x] EmailAddress
- [x] Enum+Convenience
- [ ] ErrorGenerating+ErrorFactory
- [x] EventCenter
- [ ] FileSystem
- [x] HTML
- [x] HTTPStatus
- [x] HeartRateFormatter
- [x] Int+Random
- [x] JSON
- [x] Mass
- [x] MultiCallback
- [x] NativeTypesDecoder
- [x] NativeTypesEncoder
- [x] NativeTypesStructured
- [ ] NetworkUserReportableError
- [x] Observable
- [ ] ObservableArray
- [ ] ObservableDictionary
- [ ] ObservableReference
- [ ] OrderedDictionary
- [x] PatchyRange
- [x] Path+Coding
- [x] Path
- [ ] PercentEncodable
- [x] PersistenceService
- [ ] Price
- [ ] PrioritizedOperationQueue
- [ ] ReferenceTypePersistenceService
- [ ] ReportableError+Coding
- [ ] ReportableError
- [ ] SelectableValue
- [ ] SequenceType+Helpers
- [ ] SpecDecoder
- [x] String+Helpers
- [ ] String+Random
- [x] Structured
- [ ] Syncable
- [ ] TimeInterval+Formatting
- [ ] Transformation
- [ ] URL+Helpers
- [ ] ValueTypePersistenceService
- [ ] WeakWrapper
- [x] XML

macOS and Linux only
-----------

- [ ] Email
- [ ] ShellCommand
- [ ] ZipFilePath

iOS Only
-----------

- [ ] BubbleView
- [ ] CGContext+ThreadSafe
- [ ] CircleBorderView
- [ ] DatePickerViewController
- [ ] DiagonalGradientView
- [ ] DispatchQueue+Helpers
- [ ] EnergyFormatting
- [ ] Float+Factory
- [ ] Form
- [ ] FormViewController
- [ ] KeyboardConstraintAdjuster
- [ ] LimitedSizeViewController
- [ ] Menu
- [ ] MenuViewController
- [ ] MonthAndYearPicker
- [ ] NSLayoutConstraint+SwifPlusPlus
- [ ] NSLayoutContraint+Factory
- [ ] PassThroughTouchView
- [ ] PlaceholderTextView
- [ ] RoundedBorderButton
- [ ] RoundedBorderView
- [ ] SelectListViewController
- [ ] ShadowView
- [ ] TaskService
- [ ] ThinLayoutConstraint
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
- [ ] WebViewController
- [ ] ZoomThroughTransition
