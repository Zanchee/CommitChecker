//
//  JiraSearch.swift
//  
//
//  Created by Connor Ricks on 6/4/20.
//

import Foundation

struct JiraSearch: Decodable {
    let total: Int
    let startAt: Int
    let maxResults: Int
    let issues: [JiraIssue]
}
