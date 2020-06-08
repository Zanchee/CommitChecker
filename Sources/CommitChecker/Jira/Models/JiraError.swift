//
//  JiraError.swift
//  
//
//  Created by Connor Ricks on 6/4/20.
//

import Foundation

struct JiraError: Decodable {
    let errorMessages: [String]
}
