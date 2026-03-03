---
name: deck
description: Generate a beautiful, interactive single-file HTML presentation deck. Use when the user wants to create a shareable, interactive document for pitching a project, explaining a technical system, reviewing an architecture, presenting an incident post-mortem, or showcasing a product wireframe. The output is a self-contained HTML file with sidebar navigation, named state variants per section, and annotation panels — no build step required.
---

# /deck — Interactive HTML Presentation Generator

## Interaction Pattern

When invoked, ask the user these questions **in a single message**:

1. **Topic** — What is this deck about? Give a working title and one-sentence description.
2. **Type** — Which type fits best? (tech-explainer / product-wireframe / incident-report / project-pitch / architecture-review)
3. **Audience** — Who will read this and what do you want them to understand or do?
4. **Sections** — What are the 3–6 main areas, components, screens, or phases?
5. **Key content** — Any specific data, numbers, decisions, or diagrams to include?
6. **Output filename** — Where should the file be written? (default: `~/Desktop/<slug>.html`)

After collecting answers, generate the complete HTML file in one shot and write it to disk. Report the output path and a one-paragraph summary.

---

## Deck Types

### `tech-explainer` — Principal Engineer project explanation

For explaining what a technical project *is*, why it exists, how it works, and where it's headed. Audience: engineers, PMs, leadership unfamiliar with the internals.

**Preamble primitives to use:** story blocks (the problem + the approach), key-numbers grid (scope stats), system topology diagram, design-decisions cards (3 key architectural choices), milestone timeline.

**Section structure:** Each section covers a major component or system layer.
**Per-section states:** "Overview", "Deep Dive", "Trade-offs" (or similar meaningful variants)
**Annotation labels:** "What this component does", "Why it exists", "Key design decisions", "Trade-offs & risks"

### `product-wireframe` — UI/UX flow showcase

For reviewing multi-screen product flows with annotated wireframe states.

**Preamble:** story (the job to be done), principles grid, key-numbers, timeline of stages, execution flow diagram.
**Section structure:** Each section is a screen or stage in the flow.
**Per-section states:** Named UI variants (e.g., "Empty State", "Loaded", "Error", "Confirmation")
**Annotation labels:** "What the user is doing", "Screen breakdown", "Key interactions", "Design decisions"

### `incident-report` — Post-mortem / incident debrief

For explaining what happened, timeline, impact, and prevention.

**Preamble:** key-numbers (impact stats: affected users, duration, error rate), event timeline, resolution options.
**Sections:** Detection, Diagnosis, Mitigation, Resolution, Prevention
**Per-section states:** Timeline views, metric snapshots, action states
**Annotation labels:** "What happened", "What was visible", "Decisions made", "What we'd do differently"

### `project-pitch` — Project proposal / funding request

For pitching a project to stakeholders.

**Preamble:** story (the problem + the opportunity), key-numbers (scope/impact/timeline), principles (3 bets or hypotheses).
**Sections:** Problem, Solution, Evidence/Research, Execution Plan, Ask
**Per-section states:** Different evidence views, comparison states
**Annotation labels:** "The core claim", "Supporting evidence", "Assumptions", "Open questions"

### `architecture-review` — Technical architecture decision

For presenting an architectural decision with options and recommendation.

**Preamble:** story (the context + the decision), principles (evaluation criteria), state-grid (options matrix).
**Sections:** Current state, Option A, Option B, Recommendation, Migration path
**Per-section states:** Different angles on the same option (overview, trade-offs, implementation)
**Annotation labels:** "The approach", "Why this works", "Trade-offs", "Open questions"

---

## HTML File Structure

Every generated deck uses this exact structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Title]</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@300;400;500&family=Instrument+Serif:ital@0;1&family=DM+Sans:ital,wght@0,300;0,400;0,500;0,600;1,400&display=swap" rel="stylesheet">
  <style>/* full CSS — see design system below */</style>
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
    const config = { /* data object */ };
    /* renderer — see template below */
  </script>
</body>
</html>
```

---

## Design System

Use these exact CSS custom properties and class conventions. They must appear on `:root`.

```css
:root {
  --bg: #FAFBFC;
  --bg-surface: #FFFFFF;
  --bg-surface-raised: #F0F2F5;
  --border: #D0D5DD;
  --border-subtle: #E2E6EB;
  --text-primary: #1A1A2E;
  --text-secondary: #4A5568;
  --text-muted: #7A8599;
  --accent-blue: #2B6CB0;
  --accent-blue-dim: #BEE3F8;
  --accent-green: #25855A;
  --accent-green-dim: #C6F6D5;
  --accent-amber: #B7791F;
  --accent-amber-dim: #FEFCBF;
  --serif: 'Instrument Serif', Georgia, serif;
  --mono: 'DM Mono', 'SF Mono', monospace;
  --sans: 'DM Sans', -apple-system, sans-serif;
  --ease: cubic-bezier(0.16, 1, 0.3, 1);
}
```

**Phase → color mapping** (used for sidebar accent dots and timeline nodes):
- `interactive` → `--accent-blue`
- `execution` → `--accent-green`
- `gate` → `--accent-amber`
- `neutral` → `--text-muted`

**Typography rules:**
- Headings/display: `var(--serif)`, `font-weight: 400` (the serif is the elegance)
- Labels/metadata/code: `var(--mono)`, uppercase, `letter-spacing: 0.1em`
- Body/UI text: `var(--sans)`, `font-weight: 300` for paragraphs, `500-600` for UI labels

---

## Layout CSS

```css
* { box-sizing: border-box; margin: 0; padding: 0; }
body { background: var(--bg); font-family: var(--sans); color: var(--text-primary); height: 100vh; overflow: hidden; }

#app { display: flex; height: 100vh; }

#sidebar {
  width: 240px; min-width: 240px; height: 100vh;
  background: var(--bg-surface); border-right: 1px solid var(--border-subtle);
  overflow-y: auto; padding: 1.5rem 0; display: flex; flex-direction: column; gap: 0;
}

#content {
  flex: 1; height: 100vh; overflow-y: auto;
  display: flex; flex-direction: column;
}

#slide-area {
  flex: 1; padding: 2.5rem 3rem; min-height: 0; overflow-y: auto;
}

#annotation-area {
  border-top: 1px solid var(--border-subtle);
  padding: 2rem 3rem; background: var(--bg-surface);
}
```

---

## Sidebar CSS & HTML Pattern

```css
.sb-header { padding: 0 1.25rem 1.25rem; border-bottom: 1px solid var(--border-subtle); margin-bottom: 0.75rem; }
.sb-title { font-family: var(--sans); font-size: 0.9rem; font-weight: 600; color: var(--text-primary); line-height: 1.3; }
.sb-subtitle { font-family: var(--mono); font-size: 0.68rem; color: var(--text-muted); margin-top: 0.3rem; letter-spacing: 0.05em; }
.sb-meta { font-family: var(--mono); font-size: 0.65rem; color: var(--text-muted); margin-top: 0.5rem; }

.sb-section { cursor: pointer; padding: 0.5rem 1.25rem; transition: background 150ms; }
.sb-section:hover { background: var(--bg-surface-raised); }
.sb-section.active { background: var(--bg-surface-raised); }
.sb-section-inner { display: flex; align-items: center; gap: 0.6rem; }
.sb-dot { width: 7px; height: 7px; border-radius: 50%; flex-shrink: 0; }
.sb-dot.interactive { background: var(--accent-blue); }
.sb-dot.execution { background: var(--accent-green); }
.sb-dot.gate { background: var(--accent-amber); }
.sb-dot.neutral { background: var(--text-muted); }
.sb-section-title { font-size: 0.82rem; font-weight: 500; color: var(--text-secondary); }
.sb-section.active .sb-section-title { color: var(--text-primary); }
.sb-stage { font-family: var(--mono); font-size: 0.65rem; color: var(--text-muted); margin-left: auto; }

.sb-states { padding: 0.25rem 1.25rem 0.5rem 2.75rem; display: flex; flex-direction: column; gap: 2px; }
.sb-state { font-size: 0.78rem; color: var(--text-muted); padding: 0.2rem 0.5rem; border-radius: 3px; cursor: pointer; transition: all 120ms; }
.sb-state:hover { color: var(--text-secondary); background: var(--bg-surface-raised); }
.sb-state.active { color: var(--text-primary); background: var(--accent-blue-dim); font-weight: 500; }

.sb-overview { padding: 0.5rem 1.25rem; margin-bottom: 0.25rem; }
.sb-overview-btn { font-family: var(--mono); font-size: 0.72rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--text-muted); cursor: pointer; padding: 0.3rem 0; }
.sb-overview-btn:hover, .sb-overview-btn.active { color: var(--text-primary); }
```

---

## Preamble Component Library

The preamble is a raw HTML string with an embedded `<style>` tag, scoped to `.deck-preamble`. All components below live inside `.deck-preamble`.

### Story block
```html
<div class="story">
  <div class="story-label">The Problem</div>
  <div class="story-body">
    <p>Lead paragraph — slightly larger, primary color.</p>
    <p>Supporting paragraph — secondary color, light weight.</p>
  </div>
</div>
```
CSS: `.story { display:grid; grid-template-columns:200px 1fr; gap:2rem; padding:2rem 0; max-width:1100px; }` `.story-label { font-family:var(--mono); font-size:0.75rem; color:var(--text-muted); letter-spacing:0.15em; text-transform:uppercase; padding-top:0.35rem; }` `.story-body p { font-size:1.05rem; line-height:1.8; color:var(--text-secondary); font-weight:300; margin-bottom:1rem; }` `.story-body p:first-child { font-size:1.1rem; color:var(--text-primary); font-weight:400; }`

### Key numbers
```html
<div class="key-numbers">
  <div class="key-number"><div class="num">8</div><div class="label">Repositories</div></div>
</div>
```
CSS: `.key-numbers { display:grid; grid-template-columns:repeat(4,1fr); gap:1px; background:var(--border-subtle); border:1px solid var(--border-subtle); border-radius:8px; overflow:hidden; margin-bottom:2.5rem; }` `.key-number { background:var(--bg-surface); padding:1.2rem; text-align:center; }` `.num { font-family:var(--serif); font-size:2rem; color:var(--text-primary); line-height:1.1; }` `.label { font-family:var(--mono); font-size:0.72rem; color:var(--text-muted); letter-spacing:0.12em; text-transform:uppercase; margin-top:0.4rem; }`

### Principles / decision cards
```html
<div class="principles-grid">
  <div class="principle-card">
    <div class="principle-num">01</div>
    <div class="principle-title">Dual API Strategy</div>
    <div class="principle-body">HTTP for backward-compatible agents; gRPC for Atlas. Staged migration without forced upgrades.</div>
  </div>
</div>
```
Cards get blue/amber/green top borders via `:nth-child(1/2/3)::before`. CSS: `.principles-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:1rem; }` `.principle-card { background:var(--bg-surface); border:1px solid var(--border-subtle); border-radius:6px; padding:1.3rem; position:relative; overflow:hidden; }` `.principle-card::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; }` `.principle-card:nth-child(1)::before { background:var(--accent-blue); }` `.principle-card:nth-child(2)::before { background:var(--accent-amber); }` `.principle-card:nth-child(3)::before { background:var(--accent-green); }`

### Timeline
```html
<div class="timeline-container"><div class="timeline">
  <div class="tl-node interactive">
    <div class="tl-dot"></div>
    <div class="tl-num">01</div>
    <div class="tl-name">Intent</div>
    <div class="tl-time">30s–2m</div>
  </div>
</div></div>
```
Node classes: `interactive`, `execution`, `gate`. CSS: `.timeline { display:flex; align-items:flex-start; padding:1.5rem 0; position:relative; }` `.timeline::before { content:''; position:absolute; top:20px; left:20px; right:20px; height:2px; background:var(--border); }` `.tl-node { display:flex; flex-direction:column; align-items:center; flex:1; min-width:80px; position:relative; z-index:1; }` `.tl-dot { width:12px; height:12px; border-radius:50%; border:2px solid var(--border); background:var(--bg); }` `.tl-node.interactive .tl-dot { border-color:var(--accent-blue); background:var(--accent-blue-dim); }` `.tl-node.execution .tl-dot { border-color:var(--accent-green); background:var(--accent-green-dim); }` `.tl-node.gate .tl-dot { border-color:var(--accent-amber); background:var(--accent-amber-dim); }`

### Flow phases (execution diagram)
```html
<div class="flow-phases">
  <div class="flow-phase-label phase-1">Phase 1</div>
  <div class="flow-row">
    <div class="flow-box"><div class="flow-title">Step</div><div class="flow-sub">detail</div></div>
    <div class="flow-arrow">→</div>
    <div class="flow-box"><div class="flow-title">Step</div><div class="flow-sub">detail</div></div>
  </div>
  <div class="flow-gate-divider">
    <div class="flow-gate-line"></div>
    <div class="flow-gate-badge">Gate</div>
    <div class="flow-gate-line"></div>
  </div>
  <div class="flow-phase-label phase-2">Phase 2</div>
</div>
```

### System topology (for tech-explainer)
```html
<div class="topology">
  <div class="topo-node">
    <div class="topo-label">Atlas (Rails)</div>
    <div class="topo-sub">Port 3000</div>
  </div>
  <div class="topo-connector">
    <div class="topo-line"></div>
    <div class="topo-edge-label">gRPC :9091</div>
    <div class="topo-line"></div>
  </div>
  <div class="topo-node primary">
    <div class="topo-label">Janus (Go)</div>
    <div class="topo-sub">Agent Registry</div>
  </div>
  <div class="topo-connector">...</div>
  <div class="topo-node">...</div>
</div>
```
CSS: `.topology { display:flex; align-items:center; gap:0; padding:2rem 0; }` `.topo-node { background:var(--bg-surface); border:1px solid var(--border); border-radius:8px; padding:1.25rem 1.5rem; text-align:center; min-width:160px; }` `.topo-node.primary { border-color:var(--accent-blue); background:var(--accent-blue-dim); }` `.topo-label { font-family:var(--sans); font-size:0.95rem; font-weight:600; color:var(--text-primary); }` `.topo-sub { font-family:var(--mono); font-size:0.7rem; color:var(--text-muted); margin-top:0.3rem; }` `.topo-connector { flex:1; display:flex; flex-direction:column; align-items:center; gap:0.3rem; }` `.topo-line { width:100%; height:1px; background:var(--border); }` `.topo-edge-label { font-family:var(--mono); font-size:0.68rem; color:var(--text-muted); white-space:nowrap; }`

### State machine grid
```html
<div class="state-grid">
  <div class="state-cell"><div class="state-name">Draft</div><div class="state-desc">Initial</div></div>
  <div class="state-cell active-state"><div class="state-name">Validated</div><div class="state-desc">Checks pass</div></div>
</div>
```
CSS: `.state-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(120px,1fr)); gap:1px; background:var(--border-subtle); border:1px solid var(--border-subtle); border-radius:6px; overflow:hidden; }` `.state-cell { background:var(--bg-surface); padding:0.8rem; text-align:center; }` `.state-cell.active-state { background:var(--bg-surface-raised); }` `.state-name { font-family:var(--mono); font-size:0.78rem; font-weight:500; }` `.state-desc { font-size:0.72rem; color:var(--text-muted); margin-top:0.2rem; }`

### Option cards (3-col)
```html
<div class="option-cards">
  <div class="option-card">
    <div class="tag-recommended">Recommended</div>
    <h4>Option Title</h4>
    <p>Description of this option.</p>
  </div>
</div>
```
CSS: `.option-cards { display:grid; grid-template-columns:repeat(3,1fr); gap:1rem; }` `.option-card { background:var(--bg-surface); border:1px solid var(--border-subtle); border-radius:6px; padding:1.1rem; }` `.option-card h4 { font-size:0.9rem; font-weight:600; margin-bottom:0.4rem; }` `.option-card p { font-size:0.85rem; color:var(--text-secondary); line-height:1.55; font-weight:300; }` `.tag-recommended { display:inline-block; font-family:var(--mono); font-size:0.68rem; letter-spacing:0.08em; text-transform:uppercase; color:var(--accent-green); background:rgba(37,133,90,0.06); border:1px solid rgba(37,133,90,0.2); border-radius:3px; padding:0.1rem 0.4rem; margin-bottom:0.5rem; }`

---

## Section Wireframe Patterns

The `states` object maps state names to HTML strings rendered in `#slide-area`. Wire these to look like real UI screens using the design system. Don't use gray placeholder boxes — use actual structure.

**Section heading (always at top of each state):**
```html
<div class="section-header">
  <div class="section-meta">STAGE 02 · INTERACTIVE</div>
  <h1 class="section-title">Agent API</h1>
  <p class="section-sub">Backward-compatible HTTP interface for existing Terraform agents.</p>
</div>
```
CSS: `.section-header { margin-bottom:2rem; }` `.section-meta { font-family:var(--mono); font-size:0.72rem; color:var(--text-muted); letter-spacing:0.15em; text-transform:uppercase; margin-bottom:0.4rem; }` `.section-title { font-family:var(--serif); font-size:2rem; font-weight:400; color:var(--text-primary); margin-bottom:0.5rem; }` `.section-sub { font-size:1rem; color:var(--text-secondary); font-weight:300; max-width:600px; line-height:1.6; }`

**Endpoint table (for API documentation):**
```html
<div class="endpoint-table">
  <div class="endpoint-row">
    <span class="method post">POST</span>
    <span class="path">/api/agent/register</span>
    <span class="endpoint-desc">Agent registration — returns agent ID and heartbeat interval</span>
  </div>
</div>
```

**Service card grid (for gRPC services, subsystems):**
```html
<div class="service-grid">
  <div class="service-card">
    <div class="service-name">TokenService</div>
    <div class="service-methods">
      <div class="method-item">CreateToken</div>
      <div class="method-item">RevokeToken</div>
    </div>
  </div>
</div>
```

**Data model table:**
```html
<div class="data-table">
  <div class="dt-row header">
    <div class="dt-cell">Table</div>
    <div class="dt-cell">Key Fields</div>
    <div class="dt-cell">Notes</div>
  </div>
  <div class="dt-row">
    <div class="dt-cell mono">agents</div>
    <div class="dt-cell">id, pool_id, status, last_seen_at</div>
    <div class="dt-cell muted">UUID prefix: agent-</div>
  </div>
</div>
```

**Before/after comparison:**
```html
<div class="compare-grid">
  <div class="compare-col before">
    <div class="compare-label">Before</div>
    <div class="compare-content">...</div>
  </div>
  <div class="compare-col after">
    <div class="compare-label">After</div>
    <div class="compare-content">...</div>
  </div>
</div>
```

---

## Annotation Panel

Always rendered below the slide area. Use the type-appropriate labels.

```html
<div class="ann-grid">
  <div class="ann-block">
    <h3>What this component does</h3>
    <p>Specific, substantive description. Never generic filler.</p>
  </div>
  <div class="ann-block">
    <h3>Why it exists</h3>
    <ul>
      <li><strong>Reason one:</strong> explanation.</li>
      <li><strong>Reason two:</strong> explanation.</li>
    </ul>
  </div>
  <div class="ann-block">
    <h3>Key design decisions</h3>
    <ul><li>Decision + rationale.</li></ul>
  </div>
  <div class="ann-block">
    <h3>Trade-offs &amp; risks</h3>
    <ul><li>Trade-off + mitigation.</li></ul>
  </div>
</div>
```

CSS:
```css
.ann-grid { display:grid; grid-template-columns:1fr 1fr; gap:1.5rem 2.5rem; padding:2rem 0; }
.ann-block h3 { font-family:var(--mono); font-size:0.72rem; text-transform:uppercase; letter-spacing:0.12em; color:var(--text-muted); margin-bottom:0.6rem; }
.ann-block p, .ann-block li { font-size:0.85rem; line-height:1.65; color:var(--text-secondary); font-weight:300; }
.ann-block ul { list-style:none; padding:0; }
.ann-block li { padding-left:12px; position:relative; margin-bottom:4px; }
.ann-block li::before { content:''; position:absolute; left:0; top:0.55em; width:4px; height:4px; border-radius:50%; background:var(--text-muted); }
.ann-block li strong { font-weight:500; color:var(--text-primary); }
```

---

## Config Object & JS Renderer

```javascript
const config = {
  title: "Project Title",
  subtitle: "One-liner subtitle",
  meta: { id: "PROJ-001", date: "2026-02-26" },
  preamble: `<style>.deck-preamble { ... }</style><div class="deck-preamble">...</div>`,
  preambleNav: [
    { id: "anchor-id", label: "Section Label" }
  ],
  sections: [
    {
      id: "unique-id",
      title: "Section Title",
      subtitle: "One-liner",
      stageNumber: "01",
      phase: "neutral",  // interactive | execution | gate | neutral
      states: {
        "State Name": `<div class="section-header">...</div>...`,
      },
      annotation: `<div class="ann-grid">...</div>`
    }
  ]
};

// --- Renderer ---
let currentSection = null;
let currentState = null;
let showingPreamble = true;

function buildSidebar() {
  const sb = document.getElementById('sidebar');
  sb.innerHTML = `
    <div class="sb-header">
      <div class="sb-title">${config.title}</div>
      <div class="sb-subtitle">${config.subtitle}</div>
      <div class="sb-meta">${config.meta.id} · ${config.meta.date}</div>
    </div>
    <div class="sb-overview">
      <div class="sb-overview-btn active" id="btn-overview" onclick="showPreamble()">Overview</div>
    </div>
    ${config.sections.map((sec, si) => `
      <div class="sb-section" id="sec-${sec.id}" onclick="showSection('${sec.id}')">
        <div class="sb-section-inner">
          <div class="sb-dot ${sec.phase}"></div>
          <div class="sb-section-title">${sec.title}</div>
          <div class="sb-stage">${sec.stageNumber}</div>
        </div>
      </div>
      <div class="sb-states" id="states-${sec.id}" style="display:none">
        ${Object.keys(sec.states).map(name => `
          <div class="sb-state" id="state-${sec.id}-${slugify(name)}" onclick="showState('${sec.id}','${name}')">${name}</div>
        `).join('')}
      </div>
    `).join('')}
  `;
}

function slugify(s) { return s.toLowerCase().replace(/[^a-z0-9]+/g,'-'); }

function showPreamble() {
  showingPreamble = true;
  document.getElementById('btn-overview').classList.add('active');
  config.sections.forEach(sec => {
    document.getElementById('sec-'+sec.id)?.classList.remove('active');
    document.getElementById('states-'+sec.id).style.display = 'none';
  });
  document.getElementById('slide-area').innerHTML = config.preamble;
  document.getElementById('annotation-area').innerHTML = '';
  buildPreambleSubNav();
}

function buildPreambleSubNav() {
  if (!config.preambleNav?.length) return;
  // Optionally wire anchor links in preamble
}

function showSection(sectionId) {
  const sec = config.sections.find(s => s.id === sectionId);
  if (!sec) return;
  showingPreamble = false;
  document.getElementById('btn-overview').classList.remove('active');
  config.sections.forEach(s => {
    document.getElementById('sec-'+s.id)?.classList.remove('active');
    document.getElementById('states-'+s.id).style.display = 'none';
  });
  document.getElementById('sec-'+sectionId).classList.add('active');
  document.getElementById('states-'+sectionId).style.display = 'flex';
  currentSection = sectionId;
  const firstState = Object.keys(sec.states)[0];
  showState(sectionId, firstState);
}

function showState(sectionId, stateName) {
  const sec = config.sections.find(s => s.id === sectionId);
  if (!sec || !sec.states[stateName]) return;
  currentState = stateName;
  // Clear active states
  document.querySelectorAll('.sb-state').forEach(el => el.classList.remove('active'));
  document.getElementById('state-'+sectionId+'-'+slugify(stateName))?.classList.add('active');
  document.getElementById('slide-area').innerHTML = sec.states[stateName];
  document.getElementById('annotation-area').innerHTML = sec.annotation || '';
}

// Keyboard navigation
document.addEventListener('keydown', e => {
  if (e.key === 'ArrowRight' || e.key === 'ArrowDown') navigateForward();
  if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') navigateBack();
});

function navigateForward() {
  if (showingPreamble) { showSection(config.sections[0].id); return; }
  const sec = config.sections.find(s => s.id === currentSection);
  const stateNames = Object.keys(sec.states);
  const idx = stateNames.indexOf(currentState);
  if (idx < stateNames.length - 1) {
    showState(currentSection, stateNames[idx + 1]);
  } else {
    const secIdx = config.sections.findIndex(s => s.id === currentSection);
    if (secIdx < config.sections.length - 1) showSection(config.sections[secIdx+1].id);
  }
}

function navigateBack() {
  if (showingPreamble) return;
  const sec = config.sections.find(s => s.id === currentSection);
  const stateNames = Object.keys(sec.states);
  const idx = stateNames.indexOf(currentState);
  if (idx > 0) {
    showState(currentSection, stateNames[idx - 1]);
  } else {
    const secIdx = config.sections.findIndex(s => s.id === currentSection);
    if (secIdx === 0) showPreamble();
    else showSection(config.sections[secIdx-1].id);
  }
}

buildSidebar();
showPreamble();
```

---

## Quality Bar

- **Every annotation is specific to the topic.** No "this component handles X" generic filler. Write like you understand the system.
- **States show real structure.** Use actual endpoint names, real field names, real service names from what the user provided. No `FooBar` placeholders.
- **Numbers matter.** If the user gave you stats, put them in key-numbers. If they didn't, ask or omit — don't invent.
- **Preamble earns its weight.** Every preamble component (topology, timeline, flow diagram) should convey something a reader couldn't get from the sections alone.
- **Annotations drive understanding.** The annotation panel is where the *why* lives. Don't repeat the UI — explain the decisions behind it.
- **Transitions.** Add `transition: all 200ms var(--ease)` on interactive elements. Sidebar state changes should feel smooth.
- **Print styles.** Add `@media print { #sidebar { display:none; } #content { overflow:visible; } }` so the deck is printable.
