---
name: deck
description: Generate a beautiful, interactive single-file HTML presentation deck. Use when you want to create a shareable, interactive document for pitching a project, explaining a technical system, reviewing an architecture, presenting an incident post-mortem, or showcasing a product wireframe.
---

# /deck — Interactive HTML Presentation Generator

Use this command to create a polished, self-contained HTML deck file with:
- Sidebar navigation
- Named state variants per section
- Annotation panel for each section/state
- No build step required

## Interaction Pattern

When invoked, ask these questions in a **single message**:

1. **Topic** — What is this deck about? Give a working title and one-sentence description.
2. **Type** — Which type fits best? (`tech-explainer` / `product-wireframe` / `incident-report` / `project-pitch` / `architecture-review`)
3. **Audience** — Who will read this and what do you want them to understand or do?
4. **Sections** — What are the 3–6 main areas, components, screens, or phases?
5. **Key content** — Any specific data, numbers, decisions, or diagrams to include?
6. **Output filename** — Where should the file be written? (default: `~/Desktop/<slug>.html`)

After collecting answers:
1. Generate the full HTML in one shot.
2. Write the file to disk.
3. Return:
   - Final output path
   - One short summary paragraph

---

## Deck Types

### `tech-explainer`
Use for explaining technical projects: what it is, why it exists, how it works, where it’s headed.

- Preamble: problem/approach story, key numbers, topology/flow diagram, major decisions, milestones
- Section states: `Overview`, `Deep Dive`, `Trade-offs`
- Annotation labels:
  - What this component does
  - Why it exists
  - Key design decisions
  - Trade-offs & risks

### `product-wireframe`
Use for multi-screen UX flow reviews.

- Preamble: user/job story, principles, key numbers, stage timeline
- Section states: `Empty State`, `Loaded`, `Error`, `Confirmation` (or equivalent)
- Annotation labels:
  - User intent
  - Screen breakdown
  - Key interactions
  - Design decisions

### `incident-report`
Use for incident postmortems.

- Preamble: impact numbers, event timeline, mitigation path
- Sections: Detection, Diagnosis, Mitigation, Resolution, Prevention
- Annotation labels:
  - What happened
  - What was visible
  - Decisions made
  - What we’d do differently

### `project-pitch`
Use for stakeholder proposal decks.

- Preamble: problem/opportunity story, key impact numbers, principles/hypotheses
- Sections: Problem, Solution, Evidence, Execution Plan, Ask
- Annotation labels:
  - Core claim
  - Supporting evidence
  - Assumptions
  - Open questions

### `architecture-review`
Use for architecture decision reviews.

- Preamble: context, options matrix, evaluation criteria
- Sections: Current State, Option A, Option B, Recommendation, Migration
- Annotation labels:
  - Approach
  - Why this works
  - Trade-offs
  - Open questions

---

## HTML Skeleton (required structure)

Use this exact top-level structure:

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>[Title]</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@300;400;500&family=Instrument+Serif:ital@0;1&family=DM+Sans:ital,wght@0,300;0,400;0,500;0,600;1,400&display=swap" rel="stylesheet" />
  <style>
    /* full CSS here */
  </style>
</head>
<body>
  <div id="app">
    <nav id="sidebar"></nav>
    <main id="content">
      <div id="slide-area"></div>
      <div id="annotation-area"></div>
    </main>
  </div>
  <script>
    const config = {/* deck data */};
    /* renderer logic */
  </script>
</body>
</html>

---

## Design System (use as defaults)

- Background: soft neutral
- Surface cards: white with subtle border
- Typography:
  - Display headings: serif
  - Labels/meta: mono uppercase with letter spacing
  - Body text: sans, light to medium weights
- Accent classes:
  - `interactive` → blue
  - `execution` → green
  - `gate` → amber
  - `neutral` → muted gray

---

## Sidebar & State Behavior

Sidebar should include:
- Deck title + subtitle + metadata
- “Overview” selector
- Sections list with phase dot and stage label
- Per-section states nested under each section

Behavior:
- Selecting a section shows section default state.
- Selecting a state updates content + annotation panel.
- Active section/state visually highlighted.
- Smooth transitions; no heavy animations.

---

## Preamble Components (recommended)

Use a mix of:
- Story block (problem + approach)
- Key numbers grid (3–6 stats)
- Principles/decision cards (typically 3)
- Timeline (phases/stages)
- Optional system/flow diagram (simple semantic HTML/CSS blocks)

---

## Output Quality Bar

Generated deck should be:
- Visually clean and readable
- Mobile-tolerant (responsive enough for laptop + projector use)
- Self-contained (single HTML file; no local assets)
- High signal (concise copy, meaningful section names, practical annotations)

Avoid:
- Placeholder lorem ipsum
- Excessive animation
- Needing external JS libraries for core behavior

---

## Final Response Contract

After creating the file, return:

1. `Saved: <absolute-or-user-provided path>`
2. A concise summary of:
   - Deck type chosen
   - Number of sections
   - Notable visual/interaction choices