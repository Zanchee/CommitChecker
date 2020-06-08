//
//  Jira.swift
//  
//
//  Created by Connor Ricks on 6/4/20.
//

import Foundation

enum Jira: API {
    
    typealias ServerErrorType = JiraError
    
    // MARK: Properties
    
    static var credentials: String = ""
    
    static var headers: [String : String]? = [
        "Authorization": "Basic \(credentials)"
    ]
    
    // MARK: Helpers
    
    static func clientError(from serverError: JiraError) -> Error {
        let message = serverError.errorMessages.reduce("", {  result, error in
            return result.isEmpty ? error : "\n\(error)"
        })
        
        return Error(message: message)
    }
    
    // MARK: Fetchers
    
    static func getIssues(for projects: [String], fixVersion: String) -> [JiraIssue] {
        Messenger.import("Fetching JIRA issues for \(projects) with fix version \(version)...")
        guard let query = """
        project in (\(projects.joined(separator: ", "))) AND fixVersion = \(fixVersion) ORDER BY id
        """.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            Messenger.error("Unable to URL encode JIRA search query")
        }
        
        var result: Result<[JiraIssue], Error>?
        let semaphore = DispatchSemaphore(value: 0)
        getIssuesFor(query: query) { response in
            result = response
            semaphore.signal()
        }
        semaphore.wait()

        switch result {
        case .success(let issues):
            return issues
        case .failure(let error):
            Messenger.error(error.message)
        default:
            Messenger.error("Programmer Error: Result never set.")
        }
    }
    
    private static func getIssuesFor(query: String,
                                     start: Int = 0,
                                     issues: [JiraIssue] = [],
                                     completion: @escaping RequestCompletion<[JiraIssue]>) {
        guard let url = URL(string: "\(Configuration.current.jira.url)/rest/api/2/search?jql=\(query)&startAt=\(start)") else {
            completion(.failure(Error(message: "Unable to construct search query URL")))
            return
        }

        var issues = issues
        fetch(url: url, responseType: JiraSearch.self) { result in
            switch result {
            case .success(let jiraSearch):
                issues.append(contentsOf: jiraSearch.issues)
                Messenger.import("Received \(issues.count) of \(jiraSearch.total) issues.")
                if issues.count + start < jiraSearch.total {
                    getIssuesFor(query: query,
                                 start: issues.count + start,
                                 issues: issues,
                                 completion: completion)
                } else {
                    completion(.success(issues))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
