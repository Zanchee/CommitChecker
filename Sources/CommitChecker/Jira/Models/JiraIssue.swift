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
    let resolution: JiraResolution?
    let assignee: JiraAssignee?
    let labels: [String]?
    let summary: String
}

// MARK: - JiraResolution

struct JiraResolution: Decodable, Equatable {
    let name: String

    var isResolved: Bool {
        return  Configuration.current.jira.resolvedKeywords.contains(name.lowercased())
    }
}

// MARK: - JiraAssignee

struct JiraAssignee: Decodable, Equatable {
    let displayName: String
}
