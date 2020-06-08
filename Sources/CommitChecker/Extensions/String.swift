//
//  String.swift
//  
//
//  Created by Connor Ricks on 6/5/20.
//

import Foundation

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map { String(self[Range($0.range, in: self)!]) }
        } catch {
            Messenger.error("Programmer Error: Invalid REGEX")
        }
    }
}
