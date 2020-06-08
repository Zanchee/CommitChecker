# ✅ CommitChecker

**CommitChecker** is a swift command line script that analyzes your application's commit history and a JIRA fix version to validate that all work for a fix version has been completed, and that no additional untracked work was completed.

After running the script, **CommitChecker** outputs a report that checks the following...
- All Commits without associated issues.
- Commits that contain issues not associated with the specified fix version.
- Issues for a JIRA fix version that are not resolved.
- Issues for a JIRA fix version that don't have any associated commits.

## Reporting
Reports can either be printed to the console or output to a file. They come two formats...
- TEXT Outputs a plain text report. Useful for continous integration builds.
- HTML Outputs a styled html report similar to Github's markdown. Useful for sharing and reporting.

## Configuration
**CommitChecker** looks for a configuration file called `commit_checker.json` in the current directory and uses it to configure both required and optional parameters.

### ROOT Configuration
| Key    | Description               | Optional | Default Value              |
| ------ | ------------------------- | -------- | -------------------------- |
| cli    | Your preferred cli        | `true`   | String(`/bin/sh`)          |
| git    | Your git configuration    | `true`   | See `GIT Configuration`    |
| jira   | Your jira configuration   | `false`  | See `JIRA Configuration`   |
| report | Your report configuration | `true`   | See `REPORT Configuration` |

### GIT Configuration
| Key         | Description                            | Optional | Default Value              |
| ----------- | -------------------------------------- | -------- | -------------------------- |
| path        | Path to your `.git` file               | `true`   | String(`./`)               |
| delimiter   | Delimiter used for `git log`           | `true`   | String(`;\|;`)              |
| issueRegex  | REGEX used to find tickets in commits. | `true`   | String(`(?<=\[).+?(?=\])`) |
| startBranch | Start branch for commit range          | `true`   | Prompted during execution  |
| endBranch   | End branch for commit range            | `true`   | Prompted during execution  |     

### JIRA Configuration
| Key              | Description                            | Optional | Default Value              |
| ---------------- | -------------------------------------- | -------- | -------------------------- |
| resolvedKeywords | List of resolved keywords              | `true`   | `done` `resolved` `completed` `approved` `fixed` `implemented` |
| fixVersion       | The JIRA fixVersion                    | `true`   | Prompted during execution  |
| projects         | The JIRA Projects to include           | `true`   | Prompted during execution  |
| username         | Your JIRA username                     | `true`   | Prompted during execution  |
| password         | Your JIRA password / token             | `true`   | Prompted during execution  |  
| url              | The base URL for your JIRA board.      | `false`  |                            |
    
### REPORT Configuration
| Key              | Description                                  | Optional | Default Value              |
| ---------------- | -------------------------------------------- | -------- | -------------------------- |
| output           | Report output directory path.                | `true`   | Prints to console          |
| format           | Style of report `html` or `text`             | `true`   | `text`                     |
| openWhenComplete | If the report should be opened automatically | `true`   | `true`                     |

### Example JSON
```
{
    "jira": {
        "url": <jira-url>
    },
    "report": {
        "output": "./commit_reports",
        "format": "html",
    }
}
```
