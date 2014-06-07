SwiftPlusPlus
=============

Library for common enhancements to the Swift language developed by Apple

Goals
=====

I would love to have a common library of helpful extensions and classes that many
developers use. This would allow us to use more advanced features while maintaining
readability. I encourage you to submit pull requests or issues with additional features
that we can discuss to see if they should be added.

Functionality Added to Swift
=============================

## Default Value For Optionals

A short hand for unwrapping any Optional by providing a default value in the case that the optional is nil

    var optionalString: String?
    var unwrappedString = optionalString.or("Default Value")


Commit Style
=======

My commit messages follow these guidlines: [http://drewag.me/posts/changes-at-a-glance?source=github](CAAG Commit Style)
