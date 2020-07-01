//
//  Configuration.swift
//  
//
//  Created by Connor Ricks on 6/4/20.
//

import Foundation

// MARK: - Configuration

struct Configuration {
    let cli: String
    let git: GitConfiguration
    let jira: JiraConfiguration
    let report: ReportConfiguration
    
    static let current: Configuration = {
        #if DEBUG
        let optionalData = DEBUG_CONFIGURATION
        #else
        let path = "\(FileManager.default.currentDirectoryPath)/commit_checker.json"
        let optionalData = FileManager.default.contents(atPath: path)
        #endif
        
        guard let data = optionalData else {
            Messenger.error("Unable to find commit_checker.json.")
        }

        guard let configuration = try? JSONDecoder().decode(Self.self, from: data) else {
            Messenger.error("Unable parse commit_checker.json.")
        }
        
        return configuration
    }()
}

extension Configuration: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cli = try container.decodeIfPresent(String.self, forKey: .cli) ?? "/bin/sh"
        self.git = try container.decodeIfPresent(GitConfiguration.self, forKey: .git) ?? GitConfiguration.default
        self.report = try container.decodeIfPresent(ReportConfiguration.self, forKey: .report) ?? ReportConfiguration.default
        
        if let jira = try container.decodeIfPresent(JiraConfiguration.self, forKey: .jira) {
            self.jira = jira
        } else {
            Messenger.error("JIRA Configuration is missing.")
        }
    }

    private enum CodingKeys: String, CodingKey {
        case cli
        case git
        case jira
        case report
    }
}

// MARK: - GitConfiguration

struct GitConfiguration {
    let path: String
    let delimiter: String
    let issueRegex: String
    let startBranch: String?
    let endBranch: String?
    
    static let `default` = GitConfiguration(path: "./.git",
                                            delimiter: ";|;",
                                            issueRegex: #"(?<=\[).+?(?=\])"#,
                                            startBranch: nil,
                                            endBranch: nil)
}

extension GitConfiguration: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.path = try container.decodeIfPresent(String.self, forKey: .path) ?? Self.default.path
        self.delimiter = try container.decodeIfPresent(String.self, forKey: .delimiter) ?? Self.default.delimiter
        self.issueRegex = try container.decodeIfPresent(String.self, forKey: .issueRegex) ?? Self.default.issueRegex
        self.startBranch = try container.decodeIfPresent(String.self, forKey: .startBranch)
        self.endBranch = try container.decodeIfPresent(String.self, forKey: .endBranch)
    }

    private enum CodingKeys: String, CodingKey {
        case path
        case delimiter
        case issueRegex
        case startBranch
        case endBranch
    }
}

// MARK: - JiraConfiguration

struct JiraConfiguration {
    let resolvedKeywords: [String]
    let fixVersion: String?
    let projects: [String]?
    let username: String?
    let password: String?
    let url: String
    
    static let defaultResolvedKeywords = ["done", "resolved", "completed", "approved", "fixed", "implemented"]
}

extension JiraConfiguration: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resolvedKeywords = try container.decodeIfPresent([String].self, forKey: .resolvedKeywords) ?? Self.defaultResolvedKeywords
        self.fixVersion = try container.decodeIfPresent(String.self, forKey: .fixVersion)
        self.projects = try container.decodeIfPresent([String].self, forKey: .projects)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.password = try container.decodeIfPresent(String.self, forKey: .password)
        
        if let url = try container.decodeIfPresent(String.self, forKey: .url) {
            self.url = url
        } else {
            Messenger.error("JIRA Configuration is missing the url key.")
        }
    }

    private enum CodingKeys: String, CodingKey {
        case resolvedKeywords
        case fixVersion
        case projects
        case username
        case password
        case url
    }
}

// MARK: - ReportConfiguration

struct ReportConfiguration {
    enum Format: String, Decodable {
        case html
        case text
    }
    
    let output: String?
    let format: Format
    let openWhenComplete: Bool
}

extension ReportConfiguration: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.output = try container.decodeIfPresent(String.self, forKey: .output)
        self.openWhenComplete =  try container.decodeIfPresent(Bool.self, forKey: .openWhenComplete) ?? true
        
        if let format = try? container.decode(Format.self, forKey: .format) {
            self.format = format
        } else {
            Messenger.warn("Report Configuration is missing a format value, or it's invalid. Defaulting to html.")
            self.format = .html
        }
    }

    private enum CodingKeys: String, CodingKey {
        case output
        case format
        case openWhenComplete
    }
    
    static let `default` = ReportConfiguration(output: nil, format: .text, openWhenComplete: true)
}

// MARK: - DEBUG Configuration

#if DEBUG
let DEBUG_CONFIGURATION = """
{
    "cli": "/bin/sh",
    "git": {
        "path": null,
        "delimiter": ";:;",
        "startBranch": "3.28",
        "endBranch": "develop"
    },
    "jira": {
        "resolvedKeywords": ["done", "resolved", "completed", "approved", "fixed", "implemented"],
        "fixVersion": "3.29",
        "projects": ["TVOS"],
        "username": null,
        "password": null,
        "url": "https://fng-jira.fox.com"
    },
    "report": {
        "output": "./",
        "format": "html",
        "openWhenComplete": true
    }
}
""".data(using: .utf8)
#endif
