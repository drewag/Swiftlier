//
//  NativeTypesStructured.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/15/17.
//
//

public protocol NativeTypesStructured: Structured, CustomStringConvertible, Equatable {
    var object: Any {get}
    init(object: Any)
}

extension NativeTypesStructured {
    public var string: String? {
        return self.object as? String
    }

    public var int: Int? {
        if let int = self.object as? Int {
            return int
        }
        else if let string = self.string {
            return Int(string)
        }
        return nil
    }

    public var double: Double? {
        if let double = self.object as? Double {
            return double
        }
        else if let int = self.object as? Int {
            return Double(int)
        }
        else if let string = self.string {
            return Double(string)
        }
        return nil
    }

    public var bool: Bool? {
        if let bool = self.object as? Bool {
            return bool
        }
        else if let string = self.string {
            if string == "true" {
                return true
            }
            else if string == "false" {
                return false
            }
        }
        return nil
    }

    public var array: [Self]? {
        if let array = self.object as? [Any] {
            return array.map {Self(object: $0)}
        }
        else if let dict = self.object as? [String:Any], dict.count == 1 {
            return Array(dict.values).map {Self(object: $0)}
        }
        return nil
    }

    public var dictionary: [String:Self]? {
        guard let dict = self.object as? [String:Any] else {
            return nil
        }
        var output = [String:Self]()
        for (key, element) in dict {
            output[key] = Self(object: element)
        }
        return output
    }

    public subscript(string: String) -> Self? {
        if let dict = self.object as? [String:Any],
            let foundValue = dict[string]
        {
            return Self(object: foundValue)
        }
        return nil
    }

    public subscript(int: Int) -> Self? {
        if let array = self.object as? [Any], int < array.count {
            return Self(object: array[int])
        }
        return nil
    }

    public var description: String {
        return "\(self.object)"
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return self.isOptionallyEqual(lhs.string, rhs.string)
            && self.isOptionallyEqual(lhs.int, rhs.int)
            && self.isOptionallyEqual(lhs.double, rhs.double)
            && self.isOptionallyEqual(lhs.bool, rhs.bool)
            && self.isOptionallyEqual(lhs.array, rhs.array)
            && self.isOptionallyEqual(lhs.dictionary, rhs.dictionary)
    }
}

private extension NativeTypesStructured {
    static func isOptionallyEqual<E: Equatable>(_ lhs: E?, _ rhs: E?) -> Bool {
        if let lhs = lhs {
            guard let rhs = rhs else {
                return false
            }
            return lhs == rhs
        }
        else {
            return rhs == nil
        }
    }
}
