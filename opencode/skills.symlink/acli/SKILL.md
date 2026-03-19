---
name: acli
description: Work with Jira and Confluence using the Atlassian CLI (`acli`). Use this skill for authentication, Jira work items, projects, boards, sprints, filters, Confluence spaces, and Atlassian API-oriented CLI workflows.
compatibility: opencode
metadata:
  domain: atlassian
  interface: cli
  tool: acli
---

# Atlassian CLI (`acli`)

Use this skill when you need to work with Atlassian products from the command line, especially Jira and Confluence. Prefer `acli` for Atlassian operations instead of manual browser workflows when the CLI can do the job clearly and safely.

## What I do

- Authenticate to Atlassian Cloud with OAuth or API tokens
- Search, view, create, edit, assign, transition, and comment on Jira work items
- Inspect and manage Jira projects
- Inspect boards, sprints, and filters
- Work with Confluence spaces where supported
- Use structured output and narrow field selection to keep responses concise
- Help discover exact subcommands and flags when the CLI surface is unfamiliar

## When to use me

Use this skill when the task involves Atlassian CLI workflows such as:

- logging into Atlassian CLI
- checking current auth/account context
- finding Jira issues assigned to someone
- viewing a Jira work item without pulling unnecessary fields
- creating or editing Jira work items
- transitioning issue status
- assigning work items or adding comments
- listing or inspecting Jira projects
- inspecting boards or sprints
- working with saved filters
- checking Confluence space information

## Default stance

- Prefer `acli` over manual browser steps for Jira and Confluence tasks when the CLI supports the operation.
- Read before write: inspect the current state before editing, transitioning, deleting, or bulk-updating anything.
- Prefer structured output with `--json`, `--csv`, and precise field selection.
- Minimize output aggressively because Jira payloads, especially descriptions, can be extremely verbose.
- Prefer narrow, explicit targeting with `--key`, IDs, or precise JQL rather than broad bulk operations.
- Use command help early when exact flags are uncertain.

## Authentication

There are two main authentication patterns.

### OAuth

Use OAuth when the organization supports it:

```/dev/null/acli-auth-oauth.sh#L1-4
acli auth login
acli auth status
acli jira auth login --web
acli jira auth status
```

### API token

For organizations where OAuth is not available, use an API token:

```/dev/null/acli-auth-token.sh#L1-2
echo "your-api-token" | acli jira auth login --site "mysite.atlassian.net" --email "user@example.com" --token
acli auth switch
```

To create an API token, generate one from your Atlassian account security settings and pass it via stdin rather than embedding it in shell history where possible.

## Core Jira workflows

### Search for work items

Use JQL and ask only for fields you actually need:

```/dev/null/acli-search.sh#L1-5
acli jira workitem search --jql "assignee = currentUser() AND status != Done"
acli jira workitem search --jql "project = PROJ AND status = 'In Progress'"
acli jira workitem search --jql "project = PROJ AND created >= -7d" --fields "key,summary,assignee" --csv
acli jira workitem search --jql "project = PROJ" --limit 50 --json
acli jira workitem search --jql "project = PROJ" --count
```

### View a work item

Prefer narrow field selection:

```/dev/null/acli-view.sh#L1-4
acli jira workitem view PROJ-123
acli jira workitem view PROJ-123 --fields "summary,status"
acli jira workitem view PROJ-123 --fields "-description"
acli jira workitem view PROJ-123 --fields "summary,comment" --json
```

### Create a work item

```/dev/null/acli-create.sh#L1-5
acli jira workitem create --project PROJ --type Task --summary "Implement feature flag checks"
acli jira workitem create --project PROJ --type Bug --summary "Fix auth regression" --description "Repro and expected behavior" --assignee "@me"
acli jira workitem create --project PROJ --type Task --summary "Follow-up task" --parent PROJ-100
acli jira workitem create --from-json "workitem.json"
acli jira workitem create --project PROJ --type Task --summary "Triage production incident" --label "incident,urgent"
```

### Edit a work item

```/dev/null/acli-edit.sh#L1-3
acli jira workitem edit --key "PROJ-123" --summary "Updated summary"
acli jira workitem edit --key "PROJ-123" --assignee "user@example.com"
acli jira workitem edit --key "PROJ-1,PROJ-2" --assignee "@me"
```

### Transition status

```/dev/null/acli-transition.sh#L1-3
acli jira workitem transition --key "PROJ-123" --status "In Progress"
acli jira workitem transition --key "PROJ-123" --status "Done"
acli jira workitem transition --key "PROJ-1,PROJ-2" --status "In Review"
```

### Assign work items

```/dev/null/acli-assign.sh#L1-3
acli jira workitem assign --key "PROJ-123" --assignee "@me"
acli jira workitem assign --key "PROJ-123" --assignee "user@example.com"
acli jira workitem assign --key "PROJ-123" --remove-assignee
```

### Comments

```/dev/null/acli-comments.sh#L1-4
acli jira workitem comment list --key PROJ-123
acli jira workitem comment create --key PROJ-123 --body "Implementation is complete and ready for review."
acli jira workitem comment update --key PROJ-123 --comment-id 12345 --body "Updated comment"
acli jira workitem comment delete --key PROJ-123 --comment-id 12345
```

### Links, clone, and delete

```/dev/null/acli-links-clone-delete.sh#L1-6
acli jira workitem link create --out PROJ-123 --in PROJ-456 --type Blocks
acli jira workitem link list --key PROJ-123
acli jira workitem clone --key "PROJ-123"
acli jira workitem clone --key "PROJ-123" --to-project "OTHER"
acli jira workitem delete --key "PROJ-123"
acli jira workitem delete --jql "project = PROJ AND status = Done" --yes
```

## Jira project workflows

```/dev/null/acli-projects.sh#L1-8
acli jira project list
acli jira project list --paginate
acli jira project list --recent
acli jira project list --limit 50 --json
acli jira project view --key "PROJ"
acli jira project create --from-project "EXISTING" --key "NEWPROJ" --name "New Project"
acli jira project update --project-key "PROJ" --description "Updated description"
acli jira project archive --key "PROJ"
```

Additional project operations:

```/dev/null/acli-project-extra.sh#L1-2
acli jira project restore --key "PROJ"
acli jira project delete --key "PROJ"
```

## Boards, sprints, and filters

### Boards

```/dev/null/acli-boards.sh#L1-3
acli jira board search --project PROJ
acli jira board search --name "My Board"
acli jira board search --type scrum
```

### Sprints

```/dev/null/acli-sprints.sh#L1-5
acli jira board list-sprints --id 123
acli jira board list-sprints --id 123 --state active,closed
acli jira sprint view --id 456
acli jira sprint list-workitems --sprint 456 --board 123
acli jira sprint create -h
```

### Filters

```/dev/null/acli-filters.sh#L1-6
acli jira filter list --my
acli jira filter list --favourite
acli jira filter search --name "My Filter"
acli jira filter search --owner "user@example.com"
acli jira filter add-favourite --filter-id 10001
acli jira filter get --id 10001
```

## Confluence workflows

```/dev/null/acli-confluence.sh#L1-6
acli confluence auth login --web
acli confluence space list
acli confluence space view --key "SPACE"
acli confluence space create -h
acli confluence space update -h
acli confluence space archive --key "SPACE"
```

Additional space operation:

```/dev/null/acli-confluence-restore.sh#L1-1
acli confluence space restore --key "SPACE"
```

## Discovery pattern

When exact commands or flags are unclear, use help before guessing:

```/dev/null/acli-help.sh#L1-5
acli -h
acli jira -h
acli jira workitem -h
acli jira workitem create -h
acli confluence -h
```

## Output minimization

Atlassian CLI responses can be large because Jira returns raw API payloads, especially for descriptions and comments.

### Prefer `--fields`

Exclude noisy fields unless the user specifically needs them:

```/dev/null/acli-fields.sh#L1-4
acli jira workitem view PROJ-123 --fields "summary,status"
acli jira workitem view PROJ-123 --fields "-description"
acli jira workitem search --jql "project = PROJ" --fields "key,summary,assignee,status"
acli jira workitem search --jql "assignee = currentUser()" --fields "key,summary,status" --csv
```

### Prefer `--json` with `jq`

Use structured extraction when you need very specific data:

```/dev/null/acli-json-jq.sh#L1-3
acli jira workitem view PROJ-123 --json | jq '{key: .key, summary: .fields.summary, status: .fields.status.name}'
acli jira workitem search --jql "assignee = currentUser()" --json | jq '[.[] | {key: .key, summary: .fields.summary, status: .fields.status.name}]'
acli jira workitem view PROJ-123 --fields "comment" --json | jq '.fields.comment.comments | length'
```

### Prefer `--csv` for scan-friendly summaries

```/dev/null/acli-csv.sh#L1-1
acli jira workitem search --jql "project = PROJ AND status != Done" --fields "key,summary,status,assignee" --csv
```

### Use `--count` when you only need a number

```/dev/null/acli-count.sh#L1-1
acli jira workitem search --jql "project = PROJ AND sprint in openSprints()" --count
```

## ADF description handling

Jira descriptions are often stored in Atlassian Document Format, which is deeply nested JSON rather than plain text.

When the user does not need the description, exclude it:

```/dev/null/acli-no-description.sh#L1-1
acli jira workitem view PROJ-123 --fields "-description"
```

When the user does need description content, extract text nodes:

```/dev/null/acli-adf-extract.sh#L1-1
acli jira workitem view PROJ-123 --fields "description" --json | jq '[recurse(.content[]?) | select(.type == "text") | .text] | join("")'
```

## Status guidance

Jira statuses often map to the broader categories `To Do`, `In Progress`, and `Done`, but the exact status names still matter.

- Use exact status names in JQL when the workflow is specific
- Use `statusCategory` when broader matching is enough
- Confirm the valid transition names before attempting transitions if the workflow is custom

Example:

```/dev/null/acli-status-jql.sh#L1-2
acli jira workitem search --jql 'status = "In Review"'
acli jira workitem search --jql 'statusCategory = "In Progress"'
```

## Common task patterns

### Summarize a Jira work item

1. View only the needed fields
2. Avoid description unless specifically needed
3. Report key, summary, status, assignee, and recent comment activity

```/dev/null/acli-summarize-item.sh#L1-1
acli jira workitem view PROJ-123 --fields "summary,status,assignee,comment" --json
```

### Find your active work

1. Search using JQL for current user
2. Ask for a compact field set
3. Prefer CSV or filtered JSON for concise reporting

```/dev/null/acli-my-work.sh#L1-1
acli jira workitem search --jql "assignee = currentUser() AND statusCategory = 'In Progress'" --fields "key,summary,status" --csv
```

### Transition and comment safely

1. View the work item first
2. Transition to the new status
3. Add a short team-visible comment if useful

```/dev/null/acli-transition-and-comment.sh#L1-2
acli jira workitem transition --key "PROJ-123" --status "In Review"
acli jira workitem comment create --key PROJ-123 --body "Implementation is ready for review."
```

## Safety checklist

Before making changes:

1. Confirm auth/account context with `acli auth status` or `acli jira auth status`
2. Confirm the target site, project key, and work item keys
3. Preview with `search` or `view` before editing, transitioning, or deleting
4. Prefer single-item operations before bulk operations
5. Use `--yes` only when you are certain the selection is correct
6. Avoid broad JQL for destructive actions unless the user explicitly wants bulk changes

## Notes

- `acli` works with Atlassian Cloud products.
- Work items are Jira issues under newer naming.
- Many commands support `--json` and `--csv`.
- Output can be much larger than expected if you request descriptions or comments without filtering.
- OAuth availability depends on the organization.
- Product-specific auth commands may differ from global auth behavior.
- For unfamiliar subcommands, discover first with `-h` instead of guessing flags.