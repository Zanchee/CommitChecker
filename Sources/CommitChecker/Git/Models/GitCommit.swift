//
//  GitCommit.swift
//  
//
//  Created by Connor Ricks on 6/3/20.
//

import Foundation

struct GitCommit: Equatable {
    
    // MARK: Properties
    
    let hash: String?
    let date: String?
    let author: String
    let message: String
    let issues: [String]
    
    var isMerge: Bool {
        return Git.isMerge(commit: self)
    }
    
    // MARK: Initailizers

    init(hash: String?, author: String?, date: String?, message: String?) {
        self.hash = hash
        self.date = date
        self.author = author ?? "No Author"
        self.message = message ?? "No Message"

        if let message = message {
            self.issues = message.matches(for: Configuration.current.git.issueRegex)
        } else {
            self.issues = []
        }
    }
}
