---
name: gh
description: Work with GitHub using the GitHub CLI (`gh`). Use this command guidance for pull requests, issues, repositories, workflows, releases, and API operations.
---

# GitHub CLI (gh) Command Guidance

Use the GitHub CLI via shell commands for all GitHub-related operations.

## Authentication

```bash
gh auth login              # Interactive login
gh auth status             # Check auth status
gh auth logout             # Logout
```

## Pull Requests

```bash
# View and list
gh pr view [number]                          # View PR details
gh pr view [number] --json number,title,state,author,files
gh pr view [number] --web                    # Open in browser
gh pr list                                   # List PRs
gh pr list --state merged                    # Filter by state
gh pr status                                 # Show relevant PRs
gh pr checks [number]                        # CI status
gh pr diff [number]                          # View patch

# Create and edit
gh pr create                                 # Interactive create
gh pr create --title "..." --body "..."     # Direct create
gh pr create --fill                          # Use commit metadata
gh pr edit [number]                          # Edit metadata

# Actions
gh pr checkout [number]                      # Checkout PR branch
gh pr merge [number]                         # Merge PR
gh pr close [number]                         # Close PR
gh pr reopen [number]                        # Reopen PR
gh pr ready [number]                         # Mark ready for review
gh pr review [number]                        # Review PR
gh pr comment [number] -b "..."              # Add comment
```

## Issues

```bash
# View and list
gh issue view [number]
gh issue view [number] --json number,title,state,author,labels
gh issue list
gh issue list --label bug
gh issue status

# Create and edit
gh issue create
gh issue create --title "..." --body "..."
gh issue edit [number]

# Actions
gh issue close [number]
gh issue reopen [number]
gh issue comment [number] -b "..."
gh issue delete [number]
gh issue transfer [number] OWNER/REPO
```

## Repositories

```bash
gh repo view [OWNER/REPO]
gh repo view --web
gh repo list OWNER
gh repo clone OWNER/REPO
gh repo create
gh repo fork OWNER/REPO
gh repo edit
gh repo delete OWNER/REPO
```

## Workflows and Actions

```bash
# Runs
gh run list
gh run list --workflow workflow.yml
gh run view [run-id]
gh run view [run-id] --log
gh run watch [run-id]
gh run rerun [run-id]
gh run cancel [run-id]
gh run download [run-id]

# Workflows
gh workflow list
gh workflow view workflow.yml
gh workflow run workflow.yml
gh workflow enable workflow.yml
gh workflow disable workflow.yml
```

## Releases

```bash
gh release list
gh release view [tag]
gh release create [tag]
gh release delete [tag]
gh release download [tag]
```

## API Access

Use `gh api` when a capability is not exposed as a top-level `gh` subcommand.

```bash
gh api repos/OWNER/REPO/pulls/123/comments
gh api repos/OWNER/REPO/issues/123/comments
gh api /user
```

## Structured Output

Prefer JSON for automation and reliable parsing.

```bash
gh pr view 123 --json title,state,author
gh pr list --json number,title --jq '.[] | select(.title | contains("bug"))'
gh issue list --json number,title,labels --template '{{range .}}{{.number}}: {{.title}}{{"\n"}}{{end}}'
```

## Common Flags

```bash
-R, --repo OWNER/REPO   # Target a specific repository
--web                   # Open result in browser
--help                  # Show command help
```

## Search

```bash
gh search repos QUERY
gh search issues QUERY
gh search prs QUERY
```

## Additional Useful Commands

```bash
gh gist create file.txt
gh gist list
gh gist view [id]
gh label list
gh alias set <name> <command>
gh browse
```

## Operational Best Practices

1. Prefer `--json` output for scriptable and deterministic behavior.
2. Use `-R OWNER/REPO` instead of changing directories when possible.
3. Use `--jq` to filter large responses.
4. Use `gh api` for edge cases.
5. Check `gh <command> --help` before assuming flags.

## Notes

- Most commands default to the current repository.
- Numeric arguments can often be issue/PR numbers, but URLs are frequently accepted.
- Authentication persists between sessions unless explicitly cleared.