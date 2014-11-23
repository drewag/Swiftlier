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

- Run `git submodle add https://github.com/drewag/SwiftPlusPlus.git external/SwiftPlusPlus`
- Drag 'SwiftPlusPlus.xcodeproj' into your project
- Add `import SwiftPlusPlus` to the top of any file you would like to use this library in

Note: With this installation you will not be able to access extensions to Array and Dictionary
as there is a limitation in Swift that will not allow extensions to generic types from frameworks.
To get around this, you can link SwiftPlusPlus files directly into your main target.


Functionality Added to Swift
=============================

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

## merge

Merge two dictionaries together of the same type

    var dict1 = ["Apples": 2, "Oranges": 3]
    var dict2 = ["Apples": 3, "Cantaloupe": 1]
    dict1.merge(with: dict2, by: +) // ["Oranges": 3, "Cantaloupe": 1, "Apples": 5]

Array
---------

### containsObjectPassingTest:

Checks if the array contains a value that passes the given test

    var numbers = [1,2,3,4,5]
    numbers.containsObjectPassingTest({$0 > 3}) // true

### indexOfObjectPassingTest

Returns the index of the first element passing the given test or nil if not found

    var numbers = [1,2,3,4,5]
    numbers.containsObjectPassingTest({$0 > 3}) // 3
    numbers.containsObjectPassingTest({$0 > 5}) // nil

Commit Style
=======

My commit messages follow these guidlines: [CAAG Commit Style](http://drewag.me/posts/changes-at-a-glance?source=github)
