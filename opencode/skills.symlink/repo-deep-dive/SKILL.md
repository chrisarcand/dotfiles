---
name: repo-deep-dive
description: Deeply explore a repository and explain what it literally is, how users use it, how it works, and what similar popular projects it resembles.
compatibility: opencode
metadata:
  domain: repository-analysis
  mode: research
---

## What I do

- Explore an unfamiliar repository and explain the project in plain English.
- Separate product language from code reality.
- Trace the main runtime path from user entrypoint to the core workload.
- Explain how a real user installs, configures, and uses the project.
- Classify what the project actually is: agent, runtime, framework, harness, CLI, server, library, app, or some combination.
- Compare it to familiar popular projects with specific reasons, not vague analogy.
- Produce a reusable markdown summary the user can save into a portfolio of project writeups.

## When to use me

Use this skill when you need to understand a repo at a high level, especially when the real question is:

- "What is this thing, literally?"
- "How does a user actually use it?"
- "What does the binary/app/server do at runtime?"
- "Is this an agent, a harness, a framework, a runtime, or just a wrapper?"
- "What other popular tools is it most similar to?"
- "What files should I read next if I want to go deeper?"

This skill is especially useful for:

- AI agent tools
- coding assistants
- CLIs with model/provider integrations
- MCP or tool-enabled systems
- server plus desktop plus CLI products
- SDKs and orchestration frameworks

## Default stance

- Start from the repository itself. Prefer the repo's README, docs, code, and tests over external marketing.
- Treat documentation as the product story and code as the ground truth.
- Do not speculate when the repo can answer the question.
- Explain both the user view and the implementation view.
- Distinguish carefully between:
  - what the project claims to be
  - what the user experiences
  - what the code structure shows it really is
- Use subagents early for parallel exploration unless the repo is tiny.
- Do research only. Do not edit code, change config, or commit unless the user explicitly asks.
- If the evidence is mixed, give the primary label and then note secondary labels.

## Core questions to answer

Every deep-dive should answer these if the repo contains enough evidence:

1. What is the project in one sentence?
2. What does it literally do when a user runs it?
3. What are the main user-facing interfaces: CLI, desktop, web app, API, library, daemon, extension, etc.?
4. How does a user install, configure, and operate it?
5. What is the main execution path from entrypoint to core work?
6. What abstractions define the system: sessions, agents, tools, providers, plugins, recipes, workflows, jobs, tasks, pipelines, etc.?
7. Is it best described as an agent, runtime, harness, framework, SDK, wrapper, or platform?
8. What similar popular projects is it closest to, and in what ways is it different?
9. What files are the best starting points for a deeper read?

## Required workflow

### 1. Establish the product surface

Read the most obvious high-level files first:

- top-level `README`
- docs landing pages
- quickstart or installation docs
- CLI command docs
- architecture or design docs if present
- package or crate structure that reveals the product shape

Answer early:

- What binaries or apps exist?
- Is there a library/runtime beneath the UI layer?
- What concepts appear repeatedly in docs and code?

### 2. Launch subagents in parallel

Use subagents to speed up exploration. Prefer launching at least three in parallel:

- `docs/product explorer`
  - focus on README, docs, website pages, quickstarts, user workflows, terminology
- `runtime/code-path explorer`
  - find entrypoints, core runtime modules, session/config/provider/tool execution flow
- `integration explorer`
  - focus on providers, plugins, extensions, MCP/tool calling, remote services, auth/config

When useful, add a fourth:

- `comparison/classification explorer`
  - identify what category the project belongs to and what popular tools it resembles

Each subagent should return:

- concise findings
- concrete file paths
- unresolved questions or ambiguity

### 3. Trace the main runtime path

Identify the path from user action to actual work. For example:

- binary or app entrypoint
- command parsing or startup
- config loading
- session/job/request creation
- runtime or orchestrator creation
- provider/service/tool initialization
- outbound calls or execution loop
- result handling and persistence

If there are multiple interfaces, map each to the same underlying core when possible.

### 4. Classify the project precisely

Do not settle for the repo's tagline alone. Decide which labels are accurate.

Examples of useful labels:

- agent runtime
- coding agent product
- model orchestration framework
- CLI wrapper around external tools
- MCP client with local tooling
- chat application over a shared backend
- evaluation harness
- SDK plus reference app
- workflow runner

Use this pattern:

- primary label: the best technical description
- secondary labels: true but less complete descriptions
- misleading labels: common descriptions that miss important parts

### 5. Compare to similar popular projects

Give 3 to 6 useful comparisons when possible.

Prefer comparisons that help a user build intuition, for example:

- "closer to Claude Code / Codex CLI than to LangChain"
- "partly like Continue or Cline because it exposes tools and coding workflows"
- "more of a runtime/platform than a simple chat UI"

For each comparison, state:

- why it is similar
- what the key difference is

Do not force comparisons if the fit is weak.

### 6. Synthesize for a human reader

Write a practical explanation, not a code dump.

Lead with the answer to "what is this thing?" Then cover:

- how users use it
- how it works internally
- what category it belongs to
- what makes it comparable to other tools
- what files to read next

## Heuristics for AI and agent repos

If the repo is AI-related, explicitly check for these concepts:

- providers or model backends
- prompts and system instructions
- sessions or conversation state
- tool calling or function calling
- MCP or plugin systems
- permission or approval modes
- memory, context, or retrieval
- recipes, workflows, schedules, or jobs
- subagents or delegation
- desktop/server/CLI split

For AI repos, always answer:

- Is the model call the product, or is there a runtime around it?
- Where is the agent loop, if there is one?
- What makes it autonomous or not?
- What work happens locally versus remotely?
- How much of the product is provider-agnostic?

## Output format

Default to a concise but rich markdown brief with these sections:

```md
# <Project Name>

## One-line definition

## What it literally is

## What the binary/app/server does

## How users actually use it

## Main architecture / execution path

## What category it belongs to

## Similar popular projects

## Best files to read next

## Bottom line
```

Where useful, include a short "what it is not" subsection.

## Good comparison dimensions

Use these dimensions when choosing analogs:

- interface: CLI, IDE, desktop, web, API, library
- runtime model: stateless client vs stateful runtime
- autonomy: chat assistant vs acting agent
- tool use: none, native, plugin-based, MCP-based
- scope: single-provider vs multi-provider
- target user: developer, operator, researcher, end user
- extension model: built-in tools, plugins, servers, SDK

## Research guardrails

- Do not confuse packaging with architecture.
- Do not call something a framework if the repo is mainly a product.
- Do not call something an agent just because it uses an LLM.
- Do not call something a wrapper if it has meaningful session, tool, or workflow orchestration.
- Do not overstate similarity to well-known tools; qualify the comparison.
- If the repo contains both a runtime and apps on top, say so directly.

## Suggested subagent prompts

When using the Task tool, prompts like these work well:

### Docs/Product Explorer

```text
Explore this repository to understand what the project is as a product, how users use it, and what terminology it uses for itself. Focus on README, docs, site content, quickstarts, install/config guides, and obvious user entrypoints. Return: product definition, primary user workflows, key terminology, and best files to read next.
```

### Runtime/Code-Path Explorer

```text
Explore the implementation to understand the execution path from user invocation to core work. Identify binaries, app entrypoints, config loading, session/request creation, runtime/orchestrator creation, integration points, and outbound execution. Return a concise architecture trace with specific file paths and a recommendation for how to classify the project.
```

### Integration Explorer

```text
Explore the repository from the perspective of integrations: providers, plugins, extensions, MCP/tool calling, auth, and configuration. Explain how a user request becomes an external model/service/tool request and what abstractions are involved. Return notable files and any user-facing setup flow.
```

### Comparison Explorer

```text
Based on the repository's structure and docs, determine what category of software this project belongs to and what popular developer or AI tools it most resembles. Provide grounded comparisons with reasons and differences. Avoid weak analogies.
```

## Example user requests

- "Use repo-deep-dive on this repository and tell me what it literally is."
- "Analyze this AI project and explain whether it's an agent, runtime, harness, or framework."
- "Give me a markdown brief on this repo, including similar tools and key entrypoints."
- "Deep-dive this codebase and write a saveable project summary for my notes."

## Final deliverable standard

A strong result should let the user answer, in plain English:

- what the project is
- what happens when someone runs it
- how someone would adopt it
- what makes it similar to and different from adjacent tools
- where to look in the repo to verify the claims

Always write the final deep-dive as a markdown file by default, even if the user only asked for an overview in chat.

Default save behavior:

- Save to `~/ai-exploration` by default.
- Use a stable name such as `<repo-name>-deep-dive.md`.
- Create `~/ai-exploration` if it does not exist.
- If a similarly named file already exists, overwrite it with the latest deep-dive unless the user asked for a separate version.
- If the user provides a path or filename, use that instead.
