---
name: acli
description: Work with Jira and Confluence using the Atlassian CLI (acli). Use for issues, projects, auth, and reporting.
---

# Atlassian CLI (acli) Command Guidance

Use this command guide when you need to work with Jira or Confluence through the Atlassian CLI.

## Scope

Use `acli` for:

- Jira work items (create, search, edit, transition, comment, assign)
- Jira projects (list/view/create)
- Atlassian authentication and account switching
- Confluence operations where supported by your installed CLI version

Prefer CLI-driven workflows and structured output (`--json`, `--csv`) when possible.

## Authentication

Use one of the following methods.

### OAuth (recommended when available)

```bash
acli auth login
acli auth status
```

Jira-specific OAuth:

```bash
acli jira auth login --web
acli jira auth status
```

### API token (for orgs without OAuth)

```bash
echo "your-api-token" | acli jira auth login --site "mysite.atlassian.net" --email "user@example.com" --token
```

You can switch accounts with:

```bash
acli auth switch
```

## Jira Work Item Workflows

### Search

```bash
acli jira workitem search --jql "assignee = currentUser() AND status != Done"
acli jira workitem search --jql "project = PROJ AND status = 'In Progress'" --fields "key,summary,assignee" --json
acli jira workitem search --jql "project = PROJ" --count
```

### View

```bash
acli jira workitem view PROJ-123
acli jira workitem view PROJ-123 --fields "summary,description,comment" --json
```

### Create

```bash
acli jira workitem create --project PROJ --type Task --summary "Implement feature flag checks"
acli jira workitem create --project PROJ --type Bug --summary "Fix auth regression" --description "Repro + expected behavior" --assignee "@me"
```

### Edit

```bash
acli jira workitem edit --key "PROJ-123" --summary "Updated summary"
acli jira workitem edit --key "PROJ-123" --assignee "user@example.com"
```

### Transition status

```bash
acli jira workitem transition --key "PROJ-123" --status "In Progress"
acli jira workitem transition --key "PROJ-123" --status "Done"
```

### Comments

```bash
acli jira workitem comment list --key PROJ-123
acli jira workitem comment create --key PROJ-123 --body "Implementation is complete and ready for review."
```

### Assign

```bash
acli jira workitem assign --key "PROJ-123" --assignee "@me"
acli jira workitem assign --key "PROJ-123" --assignee "user@example.com"
```

## Jira Project Workflows

```bash
acli jira project list
acli jira project list --paginate --json
acli jira project view --key "PROJ" --json
```

## Output and Automation Practices

- Prefer `--json` for machine-readable output.
- Use explicit JQL in scripts to keep behavior deterministic.
- For batch edits/transitions/deletes, use confirmation flags intentionally (`--yes`) and double-check filters.
- Keep destructive operations scoped (`--key` over broad `--jql` where possible).

## Safety and Quality Checklist

Before running impactful operations:

1. Confirm the target site/account (`acli auth status`).
2. Confirm project key and issue keys.
3. Preview with search/view before edit/transition/delete.
4. Prefer incremental changes over bulk operations unless specifically required.
5. Include concise, useful comments when updating status for team visibility.

## When asked to “use acli”

When following a user task:

1. Determine whether it is auth, search, create, update, transition, or reporting.
2. Build the minimal CLI command set to complete the task.
3. Use structured output where useful.
4. Report what changed (keys, statuses, assignees, links) clearly.
