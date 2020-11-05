import Foundation
import Ink

// MARK: - Greeting

Messenger.success("Welcome to CommitChecker")

// MARK: -  Git

Git.fetch()

let startBranch: String
if let configStartBranch = Configuration.current.git.startBranch {
    startBranch = configStartBranch
    Messenger.import("Pulled start branch \(startBranch) from configuration file")
} else {
    guard let branch = ProcessInfo.processInfo.environment["START_BRANCH"] ?? Git.currentBranch() else {
        Messenger.error("No Start Branch Provided")
    }
    Messenger.import("Pulled start branch \(branch) from environment")
    startBranch = branch
}

let endBranch: String
if let configEndBranch = Configuration.current.git.endBranch {
    endBranch = configEndBranch
    Messenger.import("Pulled end branch \(endBranch) from configuration file")
} else {
    guard let branch = ProcessInfo.processInfo.environment["END_BRANCH"] ?? Git.currentBranch() else {
        Messenger.error("No End Branch Provided")
    }
    Messenger.import("Pulled end branch \(branch) from environment")
    endBranch = branch
}

let commits = Git.commits(between: startBranch, and: endBranch)
Messenger.analyze("Found \(commits.count) commits between \(startBranch) and \(endBranch)")

// MARK: - JIRA

let projects: [String]
if let configProjects = Configuration.current.jira.projects {
    projects = configProjects
    Messenger.import("Pulled projects \(projects) from configuration file")
} else {
    guard let definedProjects = ProcessInfo.processInfo.environment["PROJECTS"] else {
        Messenger.error("No Projects Provided")
    }
    Messenger.import("Pulled projects \(definedProjects) from environment")
    projects = definedProjects.split(separator: ",").map({String($0)})
}

let version: String
if let configVersion = Configuration.current.jira.fixVersion {
    version = configVersion
    Messenger.import("Pulled JIRA version \(version) from configuration file")
} else {
    guard let definedVersion = ProcessInfo.processInfo.environment["VERSION"] else {
        Messenger.error("No Version Provided")
    }
    Messenger.import("Pulled version \(definedVersion) from environment")
    version = definedVersion
}

let token: String
if let configToken = Configuration.current.jira.token {
    token = configToken
    Messenger.import("Pulled JIRA password ••••••••• from configuration file")
} else {
    guard let definedToken = ProcessInfo.processInfo.environment["JIRA_ACCESS"] else {
        Messenger.error("No JIRA Token Provided")
    }
    Messenger.import("Pulled token ••••••••• from environment")
    token = definedToken
}

guard let authentication = "\(token)".data(using: .utf8)?.base64EncodedString() else {
    Messenger.error("Unable to encode token!")
}

Jira.credentials = authentication

let issues = Jira.getIssues(for: projects, fixVersion: version)

// MARK: - Generate Report

let report = Report(version: version,
                    commits: commits,
                    issues: issues,
                    startBranch: startBranch,
                    endBranch: endBranch,
                    projects: projects)
report.output()

Messenger.success("Thanks for using CommitChecker!")
exit(0)
