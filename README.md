SwiftPlusPlus
=============

Library for common enhancements to the Swift language developed by Apple

Goals
=====

Create a common library of helpful extensions and classes that many
developers use. This would allow us to use more advanced features while maintaining
readability. You are encouraged to submit pull requests or issues with additional features
that we can discuss to see if they should be added.

Installation
========

As git submodule
--------------

Run `git submodule add https://github.com/drewag/SwiftPlusPlus.git external/SwiftPlusPlus`
Drag 'SwiftPlusPlus.xcodeproj' into your project
Add `import SwiftPlusPlus` to the top of any file you would like to use this library in


Functionality Added to Swift
=============================

Optional
----------

### or

Unwrap the value returning 'defaultValue' if the value is currently nil

    var optionalString: String?
    var unwrappedString = optionalString.or("Default Value")
    println(unwrappedString) // "Default Value"

    optionalString = "Other Value"
    println(optionalString.or("Default Value")) // "Other Value"

String
----------

### repeat

Returns a string by repeating it 'times' times

    var aString = "Hello ".repeat(3)
    println(aString) // "Hello Hello Hello "

Dictionary
-----------

### map

Return a new dictionary with mapped values for each key and value

    var foods = [
        "fruit": ["Apple", "Cantelope", "Strawberry"],
        "meat": ["Steak", "Chicken"],
    ]

    var foodsStartingWithC = foods.map { $1.filter { $0.hasPrefix("C") } }
    println(foodsStartingWithC) // ["meat": ["Chicken"], "fruit": ["Cantelope"]]

Commit Style
=======

My commit messages follow these guidlines: [CAAG Commit Style](http://drewag.me/posts/changes-at-a-glance?source=github)
