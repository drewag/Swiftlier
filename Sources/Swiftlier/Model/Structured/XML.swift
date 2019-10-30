//
//  XML.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/15/17.
//
//

import Foundation
#if canImport(FoundationXML)
    import FoundationXML
#endif

public struct XML: NativeTypesStructured {
    public let object: Any

    class ParserDelegate: NSObject {
        fileprivate var workingValues = [(key: String, value: Any?)]()
        fileprivate var object: Any? {
            return self.workingValues.first?.value
        }
        fileprivate var error: Error?
    }

    class OldParserDelegate: NSObject {
        fileprivate var workingValues = [(key: String, value: Any?)]()
        fileprivate var object: Any? {
            return self.workingValues.first?.value
        }
        fileprivate var error: Error?
    }

    public init(_ data: Data) throws {
        let parser = XMLParser(data: data)
        let delegate = ParserDelegate()
        parser.delegate = delegate
        guard parser.parse(), let object = delegate.object else {
            if let error = parser.parserError {
                throw OtherSwiftlierError(error, while: "parsing xml")
            }
            else if let error = delegate.error {
                throw OtherSwiftlierError(error, while: "parsing xml")
            }
            else {
                throw GenericSwiftlierError("parsing xml", because: "of an unknown reason")
            }
        }
        self.object = object
    }

    public init(object: Any) {
        self.object = object
    }
}

extension XML.ParserDelegate: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if let last = self.workingValues.last, last.value is String {
            let _ = self.workingValues.popLast()
            self.workingValues.append((key: last.key, value: nil))
        }
        self.workingValues.append((key: elementName, value: nil))
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.error = parseError
    }

    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        self.error = validationError
    }

    func parserDidStartDocument(_ parser: XMLParser) {
        self.workingValues.append((key: "root", value: nil))
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let (finalKey, possibleFinalValue) = self.workingValues.popLast() else {
            return
        }

        guard let (key, value) = self.workingValues.popLast()
            else
        {
            self.workingValues.append((finalKey, possibleFinalValue))
            return
        }

        switch value {
        case nil:
            self.workingValues.append((key, [finalKey:possibleFinalValue]))
        case var dict as [String:Any]:
            if var existingArray = dict[finalKey] as? [Any] {
                existingArray.append(possibleFinalValue as Any)
                dict[finalKey] = existingArray
                self.workingValues.append((key: key, value: dict))
            }
            else if let existingValue = dict[finalKey] {
                dict[finalKey] = [existingValue, possibleFinalValue as Any]
                self.workingValues.append((key: key, value: dict))
            }
            else {
                dict[finalKey] = possibleFinalValue
                self.workingValues.append((key: key, value: dict))
            }
        case var array as [Any]:
            array.append(possibleFinalValue as Any)
            self.workingValues.append((key: key, value: array))
        case let string as String:
            self.workingValues.append((key: key, value: [string]))
        default:
            fatalError("Unexpected value: \(value ?? "nil")")
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let (_, value) = self.workingValues.last else {
            return
        }
        if let value = value {
            if let oldString = value as? String {
                self.workingValues[self.workingValues.count - 1].value = oldString + string
            }
            else {
                return
            }
        }
        else {
            self.workingValues[self.workingValues.count - 1].value = string
        }
    }

    #if os(Linux)
    func parserDidEndDocument(_ parser: XMLParser) {}
    func parser(_ parser: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {}
    func parser(_ parser: XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {}
    func parser(_ parser: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {}
    func parser(_ parser: XMLParser, foundElementDeclarationWithName elementName: String, model: String) {}
    func parser(_ parser: XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {}
    func parser(_ parser: XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {}
    func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {}
    func parser(_ parser: XMLParser, didEndMappingPrefix prefix: String) {}
    func parser(_ parser: XMLParser, foundIgnorableWhitespace whitespaceString: String) {}
    func parser(_ parser: XMLParser, foundProcessingInstructionWithTarget target: String, data: String?) {}
    func parser(_ parser: XMLParser, foundComment comment: String) {}
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Foundation.Data) {}
    func parser(_ parser: XMLParser, resolveExternalEntityName name: String, systemID: String?) -> Foundation.Data? { return nil }
    #endif
}

extension XML.OldParserDelegate: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if let last = self.workingValues.last, last.value is String {
            let _ = self.workingValues.popLast()
            self.workingValues.append((key: last.key, value: nil))
        }
        self.workingValues.append((key: elementName, value: nil))
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.error = parseError
    }

    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        self.error = validationError
    }

    func parserDidStartDocument(_ parser: XMLParser) {
        self.workingValues.append((key: "root", value: nil))
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let (finalKey, possibleFinalValue) = self.workingValues.popLast() else {
            return
        }

        guard let (key, value) = self.workingValues.popLast()
            else
        {
            self.workingValues.append((finalKey, possibleFinalValue))
            return
        }

        switch value {
        case nil:
            self.workingValues.append((key, [finalKey:possibleFinalValue]))
        case var dict as [String:Any]:
            if let existingValue = dict[finalKey] {
                self.workingValues.append((key: key, value: [existingValue, possibleFinalValue as Any]))
            }
            else {
                dict[finalKey] = possibleFinalValue
                self.workingValues.append((key: key, value: dict))
            }
        case var array as [Any]:
            array.append(possibleFinalValue as Any)
            self.workingValues.append((key: key, value: array))
        case let string as String:
            self.workingValues.append((key: key, value: [string]))
        default:
            fatalError("Unexpected value: \(value ?? "nil")")
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let (_, value) = self.workingValues.last else {
            return
        }
        if let value = value {
            if let oldString = value as? String {
                self.workingValues[self.workingValues.count - 1].value = oldString + string
            }
            else {
                return
            }
        }
        else {
            self.workingValues[self.workingValues.count - 1].value = string
        }
    }

    #if os(Linux)
    func parserDidEndDocument(_ parser: XMLParser) {}
    func parser(_ parser: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {}
    func parser(_ parser: XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {}
    func parser(_ parser: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {}
    func parser(_ parser: XMLParser, foundElementDeclarationWithName elementName: String, model: String) {}
    func parser(_ parser: XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {}
    func parser(_ parser: XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {}
    func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {}
    func parser(_ parser: XMLParser, didEndMappingPrefix prefix: String) {}
    func parser(_ parser: XMLParser, foundIgnorableWhitespace whitespaceString: String) {}
    func parser(_ parser: XMLParser, foundProcessingInstructionWithTarget target: String, data: String?) {}
    func parser(_ parser: XMLParser, foundComment comment: String) {}
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Foundation.Data) {}
    func parser(_ parser: XMLParser, resolveExternalEntityName name: String, systemID: String?) -> Foundation.Data? { return nil }
    #endif
}
