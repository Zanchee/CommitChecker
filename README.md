# CommitChecker

A description of this package.

```
{
    "cli": "/bin/sh",
    "git": {
        "path": null,
        "delimiter": ";:;",
        "issueRegex": "(?<=\\[).+?(?=\\])",
        "startBranch": "3.28",
        "endBranch": "develop"
    },
    "jira": {
        "resolvedKeywords": ["done", "resolved", "completed", "approved", "fixed", "implemented"],
        "fixVersion": "3.29",
        "projects": ["App"],
        "username": null,
        "password": null,
        "url": null
    },
    "report": {
        "output": "./",
        "format": "html",
        "openWhenComplete": true
    }
}
```
