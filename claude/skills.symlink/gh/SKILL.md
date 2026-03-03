---
name: gh
description: Work with GitHub using the GitHub CLI (gh). Use for all GitHub operations including pull requests, issues, repositories, workflows, releases, and API access.
---

# GitHub CLI (gh)

Use the GitHub CLI via the Bash tool for ALL GitHub-related operations. Never use WebFetch for GitHub URLs.

## Authentication

```bash
gh auth login              # Interactive login
gh auth status             # Check auth status
gh auth logout             # Logout
```

## Pull Requests

```bash
# View and list
gh pr view [number]                    # View PR details
gh pr view [number] --json             # JSON output
gh pr view [number] --web              # Open in browser
gh pr list                             # List PRs
gh pr list --state merged              # Filter by state
gh pr status                           # Show relevant PRs
gh pr checks [number]                  # Show CI status
gh pr diff [number]                    # View changes

# Create and edit
gh pr create                           # Interactive create
gh pr create --title "..." --body "..." # Direct create
gh pr create --fill                    # Use commit info
gh pr edit [number]                    # Edit PR

# Actions
gh pr checkout [number]                # Checkout PR branch
gh pr merge [number]                   # Merge PR
gh pr close [number]                   # Close PR
gh pr reopen [number]                  # Reopen PR
gh pr ready [number]                   # Mark ready for review
gh pr review [number]                  # Review PR
gh pr comment [number] -b "..."        # Add comment
```

## Issues

```bash
# View and list
gh issue view [number]                 # View issue
gh issue view [number] --json          # JSON output
gh issue list                          # List issues
gh issue list --label bug              # Filter by label
gh issue status                        # Show relevant issues

# Create and edit
gh issue create                        # Interactive create
gh issue create --title "..." --body "..." # Direct create
gh issue edit [number]                 # Edit issue

# Actions
gh issue close [number]                # Close issue
gh issue reopen [number]               # Reopen issue
gh issue comment [number] -b "..."     # Add comment
gh issue delete [number]               # Delete issue
gh issue transfer [number] OWNER/REPO  # Transfer issue
```

## Repositories

```bash
gh repo view [OWNER/REPO]              # View repo details
gh repo view --web                     # Open in browser
gh repo list OWNER                     # List repos
gh repo clone OWNER/REPO               # Clone repo
gh repo create                         # Create repo
gh repo fork OWNER/REPO                # Fork repo
gh repo edit                           # Edit repo settings
gh repo delete OWNER/REPO              # Delete repo
```

## Workflows & Actions

```bash
# Workflow runs
gh run list                            # List recent runs
gh run list --workflow workflow.yml    # Filter by workflow
gh run view [run-id]                   # View run details
gh run view [run-id] --log             # View logs
gh run watch [run-id]                  # Watch run progress
gh run rerun [run-id]                  # Rerun workflow
gh run cancel [run-id]                 # Cancel run
gh run download [run-id]               # Download artifacts

# Workflows
gh workflow list                       # List workflows
gh workflow view workflow.yml          # View workflow
gh workflow run workflow.yml           # Trigger workflow
gh workflow enable workflow.yml        # Enable workflow
gh workflow disable workflow.yml       # Disable workflow
```

## Releases

```bash
gh release list                        # List releases
gh release view [tag]                  # View release
gh release create [tag]                # Create release
gh release delete [tag]                # Delete release
gh release download [tag]              # Download assets
```

## API Access

Use `gh api` for any GitHub API operation not covered by standard commands:

```bash
gh api repos/OWNER/REPO/pulls/123/comments
gh api repos/OWNER/REPO/issues/123/comments
gh api /user
```

## Output Formats

Most commands support structured output:

```bash
--json               # JSON output
--jq 'expression'    # Filter with jq
--template 'tmpl'    # Go template
```

Examples:
```bash
gh pr view 123 --json title,state,author
gh pr list --json number,title --jq '.[] | select(.title | contains("bug"))'
gh issue list --json number,title,labels --template '{{range .}}{{.number}}: {{.title}}{{"\n"}}{{end}}'
```

## Common Flags

```bash
-R, --repo OWNER/REPO    # Specify repository
--help                   # Show help
--web                    # Open in browser
```

## Search

```bash
gh search repos QUERY            # Search repositories
gh search issues QUERY           # Search issues
gh search prs QUERY              # Search PRs
```

## Other Commands

```bash
gh gist create file.txt          # Create gist
gh gist list                     # List gists
gh gist view [id]                # View gist
gh label list                    # List labels
gh alias set <name> <command>    # Create alias
gh browse                        # Open repo in browser
```

## Best Practices

1. **Use --json for programmatic access** - Parse structured output instead of text
2. **Use --repo flag** - Work with any repo without cd'ing
3. **Use --jq for filtering** - Extract specific fields efficiently
4. **Use gh api** - For operations not covered by standard commands
5. **Check --help** - Commands have many flags; use `gh <cmd> --help` to discover

## Notes

- Arguments accept numbers, URLs, or branch names
- Most commands work on current repo by default
- Use `-R OWNER/REPO` to target other repos
- Authentication persists across sessions
