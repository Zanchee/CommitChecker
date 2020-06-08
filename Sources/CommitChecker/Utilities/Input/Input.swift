//
//  Input.swift
//  
//
//  Created by Connor Ricks on 6/3/20.
//

import Foundation

enum Input {
    private static func get<T: Inputable>(type: T.Type) -> T? {
        guard let input = readLine(strippingNewline: true), !input.isEmpty else {
            return nil
        }
        
        return T.decode(from: input)
    }
    
    static func required<T: Inputable>(message: String, type: T.Type, defaultValue: T? = nil) -> T {
        var message = message + ":"
        if let defaultValue = defaultValue {
            message += " (\("\(defaultValue)".trimmingCharacters(in: .newlines)))"
        }
        
        while true { // 🤪
            Messenger.input(message + " ")
            if let input = Input.get(type: type) ?? defaultValue {
                return input
            } else {
                Messenger.warn("Unable to parse response. Please try again.")
            }
        }
    }
    
    static func optional<T: Inputable>(message: String, type: T.Type) -> T? {
        Messenger.input(message + " ")
        return Input.get(type: type)
    }
    
    static func username(message: String) -> String {
        Messenger.input("\(message): ")
        return Input.get(type: String.self) ?? ""
    }
    
    static func password(message: String) -> String {
        return String(cString: getpass("🔐 \(message): "))
    }
}
