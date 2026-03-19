---
name: gh
description: Work with GitHub using the GitHub CLI (`gh`). Use this skill for pull requests, issues, repositories, Actions workflows, releases, search, and GitHub API operations.
compatibility: opencode
metadata:
  domain: github
  interface: cli
  tool: gh
---

# GitHub CLI (`gh`)

Use this skill when you need to work with GitHub from the command line. Prefer `gh` for GitHub operations instead of using raw web pages.

## What I do

- Inspect, create, and update pull requests
- Inspect, create, and update issues
- Work with repositories, forks, and clones
- Check GitHub Actions workflow runs and logs
- Create and inspect releases
- Search GitHub for repos, issues, and PRs
- Use `gh api` for operations not covered by top-level commands
- Prefer structured output for reliable parsing and concise results

## When to use me

Use this skill when the task involves GitHub and the GitHub CLI is available, especially for:

- reviewing or summarizing a PR
- opening, editing, or merging a PR
- checking CI status or workflow failures
- creating or updating an issue
- inspecting repository metadata
- creating a release
- searching across GitHub
- calling GitHub REST endpoints through `gh api`

## Default stance

- Prefer `gh` over manual browser workflows for GitHub tasks.
- Prefer structured output with `--json`, `--jq`, or `--template`.
- Scope commands explicitly with `-R OWNER/REPO` when there is any ambiguity.
- Use `gh api` only when a first-class `gh` subcommand does not cover the task well.
- Read before write: inspect the current state before changing PRs, issues, labels, workflows, or releases.
- For destructive actions, confirm the target repo and object before proceeding.

## Authentication

Check auth first when GitHub behavior looks surprising.

```/dev/null/gh-auth.sh#L1-3
gh auth login
gh auth status
gh auth logout
```

## Core workflows

### Pull requests

Use these commands for common PR tasks:

```/dev/null/gh-pr.sh#L1-12
gh pr view 123
gh pr view 123 --json number,title,state,author,files,reviews
gh pr view 123 --web
gh pr list
gh pr list --state merged
gh pr status
gh pr checks 123
gh pr diff 123
gh pr create
gh pr create --title "Fix login redirect" --body "## Summary\n- Fix redirect loop"
gh pr create --fill
gh pr edit 123
```

PR actions:

```/dev/null/gh-pr-actions.sh#L1-7
gh pr checkout 123
gh pr review 123 --approve
gh pr review 123 --comment -b "Looks good overall; one small question."
gh pr comment 123 -b "CI is green now."
gh pr ready 123
gh pr merge 123
gh pr close 123
```

### Issues

```/dev/null/gh-issue.sh#L1-10
gh issue view 456
gh issue view 456 --json number,title,state,author,labels,assignees
gh issue list
gh issue list --label bug
gh issue status
gh issue create
gh issue create --title "Add retry logic" --body "We should retry transient failures."
gh issue edit 456
gh issue comment 456 -b "I can take this."
gh issue close 456
```

Additional issue actions:

```/dev/null/gh-issue-extra.sh#L1-3
gh issue reopen 456
gh issue delete 456
gh issue transfer 456 OWNER/REPO
```

### Repositories

```/dev/null/gh-repo.sh#L1-8
gh repo view OWNER/REPO
gh repo view --web
gh repo list OWNER
gh repo clone OWNER/REPO
gh repo create
gh repo fork OWNER/REPO
gh repo edit
gh repo delete OWNER/REPO
```

### GitHub Actions and workflows

Inspect runs, logs, and workflow definitions:

```/dev/null/gh-actions.sh#L1-11
gh run list
gh run list --workflow ci.yml
gh run view 789
gh run view 789 --log
gh run watch 789
gh run rerun 789
gh run cancel 789
gh run download 789
gh workflow list
gh workflow view ci.yml
gh workflow run ci.yml
```

Additional workflow controls:

```/dev/null/gh-workflow-controls.sh#L1-2
gh workflow enable ci.yml
gh workflow disable ci.yml
```

### Releases

```/dev/null/gh-release.sh#L1-5
gh release list
gh release view v1.2.3
gh release create v1.2.3
gh release delete v1.2.3
gh release download v1.2.3
```

### Search

```/dev/null/gh-search.sh#L1-3
gh search repos QUERY
gh search issues QUERY
gh search prs QUERY
```

### API access

Use `gh api` when a GitHub capability is not covered by a higher-level command:

```/dev/null/gh-api.sh#L1-4
gh api /user
gh api repos/OWNER/REPO/pulls/123/comments
gh api repos/OWNER/REPO/issues/123/comments
gh api graphql -f query='query { viewer { login } }'
```

## Structured output

Prefer machine-readable output for precise summaries and smaller result sets.

Common flags:

```/dev/null/gh-output-flags.sh#L1-3
--json
--jq '...'
--template '...'
```

Examples:

```/dev/null/gh-output-examples.sh#L1-3
gh pr view 123 --json title,state,author
gh pr list --json number,title --jq '.[] | select(.title | contains("bug"))'
gh issue list --json number,title,labels --template '{{range .}}{{.number}}: {{.title}}{{"\n"}}{{end}}'
```

## High-value habits

### Always scope the repository when needed

When you are not clearly inside the target repository, use:

```/dev/null/gh-repo-flag.sh#L1-1
gh pr list -R OWNER/REPO
```

### Prefer summary fields over full payloads

Ask only for the fields you need:

```/dev/null/gh-minimal-json.sh#L1-2
gh pr view 123 --json number,title,state,mergeStateStatus
gh issue view 456 --json number,title,state,labels,assignees
```

### Check help before assuming flags

```/dev/null/gh-help.sh#L1-3
gh --help
gh pr --help
gh pr create --help
```

## Common task patterns

### Summarize a PR

1. View PR metadata with `--json`
2. Inspect checks
3. Inspect diff if needed
4. Summarize title, status, reviewers, checks, and notable file changes

Example:

```/dev/null/gh-pr-summary.sh#L1-2
gh pr view 123 --json number,title,state,author,reviewDecision,files
gh pr checks 123
```

### Check why CI failed

1. List or view recent runs
2. Inspect the specific run
3. Read logs for failing jobs
4. Report the failing step and likely cause

Example:

```/dev/null/gh-ci-debug.sh#L1-2
gh run list --workflow ci.yml
gh run view 789 --log
```

### Create a PR from local work

1. Confirm branch and diff locally
2. Use `gh pr create`
3. Prefer `--fill` when commit messages are already clean
4. Add explicit title/body when context is missing

```/dev/null/gh-create-pr.sh#L1-2
gh pr create --fill
gh pr create --title "Add retry handling" --body "## Summary\n- retry transient API failures"
```

## Safety checklist

Before making changes:

1. Confirm authentication state with `gh auth status`
2. Confirm the target repository, especially when using `-R`
3. Inspect the current object before editing or deleting it
4. Prefer non-destructive reads before write operations
5. For merges, confirm checks and review state first

## Notes

- Most commands default to the current repository.
- Many commands accept numbers, URLs, or branch names.
- Authentication usually persists across sessions.
- `gh api` is the fallback for advanced or less common GitHub operations.
- Prefer concise, structured output over large raw text dumps.