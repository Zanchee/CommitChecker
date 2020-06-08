//
//  Messenger.swift
//  
//
//  Created by Connor Ricks on 6/3/20.
//

import Foundation

enum Messenger {
    static func success(_ string: String) {
        print("✅", string)
    }
    
    static func warn(_ string: String) {
        print("⚠️  \(string)") /// Warning emoji acts weird with spacing...
    }
    
    static func github(_ string: String) {
        print("🐙", string)
    }
    
    static func `import`(_ string: String) {
        print("📥", string)
    }
    
    static func analyze(_ string: String) {
        print("📋", string)
    }
    
    static func info(_ string: String) {
        print(string)
    }
    
    static func input(_ string: String) {
        print("💬", string, terminator: "")
    }
    
    static func error(_ string: String) -> Never {
        print("💣", string)
        exit(1)
    }
}
