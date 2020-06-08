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
    startBranch = Input.required(message: "Please enter a start branch",
                                 type: String.self,
                                 defaultValue: Git.currentBranch())
}

let endBranch: String
if let configEndBranch = Configuration.current.git.endBranch {
    endBranch = configEndBranch
    Messenger.import("Pulled end branch \(endBranch) from configuration file")
} else {
    endBranch = Input.required(message: "Please enter an end branch",
                               type: String.self,
                               defaultValue: Git.currentBranch())
}

let commits = Git.commits(between: startBranch, and: endBranch)
Messenger.analyze("Found \(commits.count) commits between \(startBranch) and \(endBranch)")

// MARK: - JIRA

let projects: [String]
if let configProjects = Configuration.current.jira.projects {
    projects = configProjects
    Messenger.import("Pulled projects \(projects) from configuration file")
} else {
    projects = Input.required(message: "Please enter a comma delimited list of projects", type: [String].self)
}

let version: String
if let configVersion = Configuration.current.jira.fixVersion {
    version = configVersion
    Messenger.import("Pulled JIRA version \(version) from configuration file")
} else {
    version = Input.required(message: "Please enter a JIRA fix version", type: String.self)
}

let username: String
if let configUsername = Configuration.current.jira.username {
    username = configUsername
    Messenger.import("Pulled JIRA username \(username) from configuration file")
} else {
    username = Input.username(message: "JIRA Username")
}

let password: String
if let configPassword = Configuration.current.jira.password {
    password = configPassword
    Messenger.import("Pulled JIRA password ••••••••• from configuration file")
} else {
    password = Input.password(message: "JIRA Password")
}

guard let authentication = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else {
    Messenger.error("Unable to encode username and password!")
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
