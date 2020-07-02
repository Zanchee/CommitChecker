//
//  JiraIssue.swift
//  
//
//  Created by Connor Ricks on 6/4/20.
//

import Foundation

// MARK: - JiraIssue

struct JiraIssue: Decodable, Equatable {
    let id: String
    let key: String
    let fields: JiraFields
    
    var url: String {
        return "\(Configuration.current.jira.url)/browse/\(key)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case key
        case fields
    }
}

// MARK: - JiraFields

struct JiraFields: Decodable, Equatable {
    let status: JiraStatus?
    let assignee: JiraAssignee?
    let labels: [String]?
    let summary: String
}

// MARK: JiraStatus

struct JiraStatus: Decodable, Equatable {
    let name: String
    
    var isComplete: Bool {
       Configuration.current.jira.completeKeywords.contains(name.lowercased())
    }
}

// MARK: - JiraAssignee

struct JiraAssignee: Decodable, Equatable {
    let displayName: String
}
