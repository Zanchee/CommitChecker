//
//  Inputable.swift
//  
//
//  Created by Connor Ricks on 6/3/20.
//

import Foundation

// MARK: - Inputable

protocol Inputable {
    static func decode(from string: String) -> Self?
}

// MARK: - Conformance

extension String: Inputable {
    static func decode(from string: String) -> String? {
        return string
    }
}

extension Int: Inputable {
    static func decode(from string: String) -> Int? {
        return Int(string)
    }
}

extension Bool: Inputable {
    static func decode(from string: String) -> Bool? {
        switch string.lowercased() {
        case "true", "t", "yes", "y":
            return true
        case "false",  "f", "no", "n":
            return false
        default:
            return nil
        }
    }
}

extension Array: Inputable where Element: Inputable {
    static func decode(from string: String) -> Array<Element>? {
        let elements = string.components(separatedBy: ",")
        return elements.compactMap { Element.decode(from: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
    }
}
