![Swiftlier - Enhanced SwiftLang](https://github.com/drewag/Swiftlier/raw/master/Assets/Header.jpg)

[![Swift](https://img.shields.io/badge/Swift-5.1-lightgrey.svg?colorA=28a745&colorB=4E4E4E)](https://swift.org)
![platforms](https://img.shields.io/badge/Platforms-iOS%208%20%7C%20macOS%2010.10%20%7C%20Linux-lightgrey.svg?colorA=28a745&colorB=4E4E4E)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/apple/swift-package-manager)
[![MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](/LICENSE)
[![Build Status](https://dev.azure.com/accounts-microsoft/Drewag/_apis/build/status/drewag.Swiftlier?branchName=master)](https://dev.azure.com/accounts-microsoft/Drewag/_build/latest?definitionId=3&branchName=master)

[![Twitter @drewag](https://img.shields.io/badge/Twitter-@drewag-blue.svg?style=flat)](http://twitter.com/drewag)
[![Blog drewag.me](https://img.shields.io/badge/Blog-drewag.me-blue.svg?style=flat)](http://drewag.me)

Library for common enhancements to the Swift language.

For additional enhancments to more specific platforms see these other repositories:
- [SwiftlierUIKit](https://github.com/drewag/SwiftlierUIKit) – UIKit helpers and improvements
- [SwiftlierCLI](https://github.com/drewag/SwiftlierCLI) – Command-Line Enhancements for macOS and Linux 

Goals
=====

Create a common library of generic extensions and types that are useful across many
projects. This would allow developers to use more advanced features while maintaining
readability. You are encouraged to submit pull requests or issues with additional features
that we can discuss to see if they should be added.

Installation
========

### Using Swift Package Manager
```swift
import PackageDescription

let package = Package(
    name: "web",
    dependencies: [
        .package(url: "https://github.com/drewag/Swiftlier.git", from: "5.0.0"),
    ]
)
```

Code Coverage
==============

Coding
-----------
- [x] Coding+Helpers
- [x] CodingKeys
- [x] NativeTypesDecoder
- [x] NativeTypesEncoder
- [x] PercentEncodable
- [x] SpecDecoder

Enhancements
----------------
- [x] Array+Sorting
- [x] Data+Processing
- [x] Date+Helpers
- [ ] DispatchQueue+Helpers
- [ ] SequenceType+Helpers
- [x] String+Helpers
- [ ] String+Random
- [ ] URL+Helpers

Errors
---------
- [ ] AnySwiftlierError
- [ ] GenericSwiftlierError
- [ ] OperationBasedError
- [ ] OtherSwiftlierError
- [ ] SwiftlierError
- [ ] SwiftlierResult

FileSystem
------------
- [ ] FileSystem+iOSDirectories
- [ ] FileSystem
- [x] Path+Coding
- [x] Path
- [x] PersistenceService
- [ ] ReferenceTypePersistenceService
- [ ] ValueTypePersistenceService

Formatting
----------
- [x] Bool+Formatting
- [x] Data+Base64
- [ ] Date+Formatting
- [x] Double+Formatting
- [x] HeartRateFormatter
- [ ] TimeInterval+Formatting

Model
--------------

### Containers
- [ ] BinarySearchTree
- [ ] LimitedQueue
- [ ] OrderedDictionary
- [x] PatchyRange
- [ ] SelectableValue
- [ ] Syncable
- [ ] WeakWrapper

### Observable
- [x] EventCenter
- [x] MultiCallback
- [x] Observable
- [ ] ObservableArray
- [ ] ObservableDictionary
- [ ] ObservableReference

### Structured
- [x] JSON
- [x] NativeTypesStructured
- [x] Structured
- [x] XML

### Types
- [x] Age
- [x] AlwaysEqual
- [x] Angle
- [x] Day
- [x] EmailAddress
- [x] HTML
- [x] Mass
- [ ] Price
- [ ] UniquelyIdentifiable

Streams
------------
- [ ] CSVStreamReader
- [ ] DelimiterStreamReader
- [ ] StreamReader

Testing
------------
- [ ] Date+Testable
- [ ] URLSession+Testing
