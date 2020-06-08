//
//  Git.swift
//  
//
//  Created by Connor Ricks on 6/3/20.
//

import Foundation

enum Git {
    
    private typealias GitLogCommitComponents = (hash: String?, author: String?, date: String?, message: String?)
    
    // MARK: Properties
    
    private static let delimiter = Configuration.current.git.delimiter
    private static let git = "git --git-dir \(Configuration.current.git.path)"
    
    // MARK: Methods
    
    static func fetch() {
        Messenger.github("Fetching...")
        sh("\(git) fetch")
    }
    
    static func currentBranch() -> String? {
        return sh("\(git) rev-parse --abbrev-ref HEAD").trimmingCharacters(in: .newlines)
    }
    
    static func commits(between startBranch: String, and endBranch: String) -> [GitCommit] {
        let commitsString = sh("\(git) log '\(startBranch)'..'\(endBranch)' --oneline --pretty=format:'%h\(delimiter)%an\(delimiter)%ad\(delimiter)%s'").components(separatedBy: "\n")
        let commits = commitsString.map { commitString -> GitCommit in
            let components = commitString.components(separatedBy: Git.delimiter)
            return GitCommit(hash: components[safe: 0],
                             author: components[safe: 1],
                             date: components[safe: 2],
                             message: components[safe: 3])
        }
        
        return commits
    }
    
    static func isMerge(commit: GitCommit) -> Bool {
        guard let hash = commit.hash else {
            return false
        }
        
        let parents = sh("\(git) show --no-patch --format=\"%P\" \(hash)")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: " ")

        return  parents.count > 1
    }
}
