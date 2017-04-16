//
//  XML.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/15/17.
//
//

import Foundation

public struct XML: NativeTypesStructured {
    public let object: Any

    class ParserDelegate: NSObject {
        fileprivate var workingValues = [(key: String, value: Any?)]()
        fileprivate var object: Any? {
            return self.workingValues.first?.value
        }
    }

    public init(data: Data) throws {
        let parser = XMLParser(data: data)
        let delegate = ParserDelegate()
        parser.delegate = delegate
        guard parser.parse(), let object = delegate.object else {
            throw XML.error("parsing xml", because: "of an unknown reason")
        }
        self.object = object
    }

    public init(object: Any) {
        self.object = object
    }

    public func toData() throws -> Data {
        return try JSON.encode(self.object)
    }
}

extension XML.ParserDelegate: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.workingValues.append((key: elementName, value: nil))
    }

    func parserDidStartDocument(_ parser: XMLParser) {
        self.workingValues.append((key: "root", value: nil))
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let (finalKey, possibleFinalValue) = self.workingValues.popLast()!
        guard let finalValue = possibleFinalValue else {
            return
        }

        let (key, value) = self.workingValues.popLast()!
        switch value {
        case nil:
            self.workingValues.append((key, [finalKey:finalValue]))
        case var dict as [String:Any]:
            if let existingValue = dict[finalKey] {
                self.workingValues.append((key: key, value: [existingValue, finalValue]))
            }
            else {
                dict[finalKey] = finalValue
                self.workingValues.append((key: key, value: dict))
            }
        case var array as [Any]:
            array.append(finalValue)
            self.workingValues.append((key: key, value: array))
        default:
            fatalError("Unexpected value")
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let (_, value) = self.workingValues.last!
        if let value = value as? String {
            self.workingValues[self.workingValues.count - 1].value = value + string
        }
        else {
            self.workingValues[self.workingValues.count - 1].value = string
        }
    }

    #if os(Linux)
    func parserDidEndDocument(_ parser: XMLParser) {}
    func parser(_ parser: Foundation.XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {}
    func parser(_ parser: Foundation.XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {}
    func parser(_ parser: Foundation.XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {}
    func parser(_ parser: Foundation.XMLParser, foundElementDeclarationWithName elementName: String, model: String) {}
    func parser(_ parser: Foundation.XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {}
    func parser(_ parser: Foundation.XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {}
    func parser(_ parser: Foundation.XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {}
    func parser(_ parser: Foundation.XMLParser, didEndMappingPrefix prefix: String) {}
    func parser(_ parser: Foundation.XMLParser, foundIgnorableWhitespace whitespaceString: String) {}
    func parser(_ parser: Foundation.XMLParser, foundProcessingInstructionWithTarget target: String, data: String?) {}
    func parser(_ parser: Foundation.XMLParser, foundComment comment: String) {}
    func parser(_ parser: Foundation.XMLParser, foundCDATA CDATABlock: Foundation.Data) {}
    func parser(_ parser: Foundation.XMLParser, resolveExternalEntityName name: String, systemID: String?) -> Foundation.Data? { return nil }
    func parser(_ parser: Foundation.XMLParser, parseErrorOccurred parseError: Foundation.NSError) {}
    func parser(_ parser: Foundation.XMLParser, validationErrorOccurred validationError: Foundation.NSError) {}
    #endif
}
