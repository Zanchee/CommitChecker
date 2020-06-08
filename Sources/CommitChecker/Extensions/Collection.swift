//
//  Collection.swift
//  
//
//  Created by Connor Ricks on 6/3/20.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            assertionFailure("Index \(index) out of boundary")
            return nil
        }
    }
}
