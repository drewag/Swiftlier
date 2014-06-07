SwiftPlusPlus
=============

Library for common enhancements to the Swift language developed by Apple

Goals
=====

Create a common library of helpful extensions and classes that many
developers use. This would allow us to use more advanced features while maintaining
readability. You are encouraged to submit pull requests or issues with additional features
that we can discuss to see if they should be added.

Functionality Added to Swift
=============================

Optional
----------

### or

A short hand for unwrapping any Optional by providing a default value in the case that the optional is nil

    var optionalString: String?
    var unwrappedString = optionalString.or("Default Value")
    println(unwrappedString) // "Default Value"

    optionalString = "Other Value"
    println(optionalString.or("Default Value")) // "Other Value"

String
----------

### repeat

Repeat a given string x number of times

    var aString = "Hello ".repeat(3)
    println(aString) // "Hello Hello Hello "

Dictionary
-----------

### map

Return a new dictionary with mapped values for each key

    var foods = [
        "fruit": ["Apple", "Cantelope", "Strawberry"],
        "meat": ["Steak", "Chicken"],
    ]

    var foodsStartingWithC = foods.map { $1.filter { $0.hasPrefix("C") } }
    println(foodsStartingWithC) // ["meat": ["Chicken"], "fruit": ["Cantelope"]]

Commit Style
=======

My commit messages follow these guidlines: [CAAG Commit Style](http://drewag.me/posts/changes-at-a-glance?source=github)
