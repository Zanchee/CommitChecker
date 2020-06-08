//
//  Error.swift
//  
//
//  Created by Connor Ricks on 6/4/20.
//

import Foundation

struct Error: Swift.Error {
    let message: String
    
    static let noData = Error(message: "No Data")
    static let noResponse = Error(message: "No Response")
}
