---
name: structurizr-c4
description: Write, review, and explain C4 architecture diagrams in Structurizr DSL, including system context, container, component, dynamic, and deployment views.
compatibility: opencode
metadata:
  format: structurizr-dsl
  domain: software-architecture
---

## What I do

- Write or update Structurizr DSL workspaces for C4 diagrams.
- Read existing Structurizr DSL and explain what each view means.
- Keep diagrams idiomatic to the C4 model and Structurizr's actual DSL semantics.

## When to use me

Use this skill when you need to:

- create or edit `workspace.dsl` files
- add or refine C4 views in Structurizr DSL
- explain an existing system context, container, component, dynamic, or deployment view
- review whether a diagram matches the codebase or architecture description
- validate or export Structurizr workspaces

## Default stance

- Prefer explicit Structurizr DSL over pseudo-diagram text.
- Preserve existing identifiers, view keys, tags, themes, and layout-sensitive structure unless there is a clear reason to change them.
- Prefer explicit view definitions over relying on automatically generated default views.
- Prefer software-system-scoped workspaces by default; use landscape-scoped or unscoped workspaces only when that better matches the existing repo or the problem being modeled.
- Use `!identifiers hierarchical` for any non-trivial workspace, especially when child names like `api`, `web`, or `db` repeat under different parents.
- Keep the static model relationships general and stable; put scenario-specific wording in dynamic views.
- Add component views only when the internal responsibilities of a container matter to the reader.

## C4 to Structurizr mapping

- System context: one software system in scope, plus directly connected people and software systems.
- Container: one software system in scope, plus its containers and directly connected people and software systems.
- Component: one container in scope, plus its components and directly connected elements.
- Dynamic: ordered instances of static relationships for one scenario or use case.
- Deployment: instances of software systems or containers mapped onto deployment nodes for an environment.

When reading diagrams, separate:

- logical structure: people, software systems, containers, components
- runtime behavior: dynamic views
- physical topology: deployment views
- presentation overlays: tags, styles, themes, filtered views, groups, perspectives

Do not confuse styles, groups, or filtered views with additional architecture elements.

## Structurizr modeling rules that matter most

- The DSL is imperative. Line order matters and forward references do not work.
- Names must be unique at their level: people and software systems globally, containers within a software system, components within a container.
- Relationship descriptions from the same source to the same destination must be unique.
- View keys should be explicit when you care about stability or manual layout. Auto-generated keys are not stable.
- `include *` is view-type specific, not global.
- Defining one or more explicit views removes the default generated views.
- Implied relationships are enabled by default, so a relationship to a container or component can imply a higher-level relationship.
- Implied relationship behavior can be configured with `!impliedRelationships true`, `false`, or a fully qualified Java strategy class.
- Tags are comma-separated strings, and styling depends on tags.
- `group` boundaries can only group elements at the same abstraction level.

## Parser context matters

- Structurizr local, CLI commands such as `validate` and `export`, and related local tooling support the full DSL.
- Browser-based DSL editors in Structurizr playground and server do not support `!docs`, `!adrs`, `!plugin`, or `!script`.
- In browser-based DSL editors, `!include` and `workspace extends ...` only support HTTPS URLs, not local files or directories.
- Browser-based DSL editors only support HTTP(S) URLs or data URIs for image-view sources and element icons.
- If the workspace depends on local includes, ADRs, docs, scripts, plugins, or file-based assets, prefer local or CLI workflows over the browser editor.

## Reading workflow

When asked to read an existing Structurizr workspace or diagram:

1. Start with the model, not the rendered view. Identify people, systems, containers, components, environments, and relationships.
2. List the available views and note their scope.
3. For each system context view, identify the primary actors, neighboring systems, and the responsibility of the scoped system.
4. For each container view, identify applications, data stores, major technologies, and the main data or control flows.
5. For each component view, identify internal responsibilities, boundaries inside the container, and likely coupling hotspots.
6. For each dynamic view, narrate the scenario step by step using the ordered relationship instances.
7. For each deployment view, distinguish logical containers from deployed instances and call out environments, nodes, and infrastructure.
8. Note where implied relationships, groups, tags, filtered views, or themes affect what the reader sees.

When summarizing, answer these questions in order:

- What is in scope?
- Who uses it?
- What are the major building blocks?
- How do they collaborate?
- Where is it deployed, if shown?
- What is missing, ambiguous, or overly detailed?

## Authoring workflow

When asked to create or update diagrams:

1. Identify the main software system in scope and the audience for the diagram.
2. Model people and external software systems first.
3. Add containers inside the software system.
4. Add components only where extra internal detail is genuinely useful.
5. Define general static relationships.
6. Add views with explicit keys and clear titles.
7. Add groups, tags, styles, themes, filtered views, and deployment details only after the core model is correct.
8. Validate or export if the tooling is available.

Prefer the smallest useful set of views:

- Start with a system context view.
- Add a container view when the system has multiple runtime applications or data stores.
- Add component views only for containers that need deeper explanation.
- Add dynamic views for important scenarios and to avoid cluttering the static model with many similar relationships.
- Add deployment views when environment topology, scaling, networking, or infra ownership matters.

## Authoring heuristics

- Use canonical, human-readable names for elements and short stable identifiers for references.
- Prefer canonical keyword casing such as `softwareSystem`, `systemContext`, and `autoLayout` for readability even though keywords are case-insensitive.
- Use `this` inside nested element blocks when it makes relationships clearer.
- Use `!include` to split large workspaces into fragments, and `workspace extends ...` when layering additional views or model content onto a base workspace.
- Consider `configuration { scope softwaresystem }` for the common case of a single software-system workspace, or `scope landscape` for landscape-only workspaces.
- Keep styles minimal until the semantics are correct.
- Use `include *?` on system context, container, and component views when you want the default elements but only relationships that touch the scoped system, containers, or components.
- If the existing workspace depends on manual layout, avoid renaming view keys or restructuring scopes casually.
- The diagram editor changes layout only, not model content, and manual layout editing is unavailable while `autoLayout` is enabled.
- If a view is too noisy, refine it with `include` and `exclude` expressions rather than deleting useful model relationships.

## Good authoring template

```dsl
workspace "Acme Platform" "C4 model for the Acme platform" {

    !identifiers hierarchical

    model {
        customer = person "Customer" "Uses the platform"

        acme = softwareSystem "Acme Platform" "Customer-facing product" {
            web = container "Web App" "Delivers the user interface" "Next.js"
            api = container "API" "Handles business operations" "Kotlin + Spring Boot"
            db = container "Database" "Stores operational data" "PostgreSQL" {
                tags "Database"
            }
        }

        payment_gateway = softwareSystem "Payment Gateway" "External payment processor"

        customer -> acme.web "Uses"
        acme.web -> acme.api "Calls"
        acme.api -> acme.db "Reads from and writes to"
        acme.api -> payment_gateway "Processes payments via"
    }

    views {
        systemContext acme "acme-system-context" {
            include *
            autoLayout lr
        }

        container acme "acme-containers" {
            include *
            autoLayout lr
        }

        dynamic acme "checkout-flow" {
            title "Checkout flow"
            customer -> acme.web "Starts checkout"
            acme.web -> acme.api "Submits basket"
            acme.api -> payment_gateway "Authorizes payment"
            acme.api -> acme.db "Stores order"
            autoLayout lr
        }

        styles {
            element "Element" {
                background #1168bd
                color #ffffff
                shape RoundedBox
            }

            element "Person" {
                shape Person
            }

            element "Database" {
                shape Cylinder
            }
        }
    }
}
```

## Useful patterns

### Hierarchical identifiers

```dsl
workspace {

    !identifiers hierarchical

    model {
        platform = softwareSystem "Platform" {
            api = container "API"
        }

        admin = softwareSystem "Admin" {
            api = container "API"
        }

        platform.api -> admin.api "Publishes events to"
    }
}
```

### Avoid forward references

Good:

```dsl
workspace {
    model {
        a = softwareSystem "A"
        b = softwareSystem "B"

        a -> b "Uses"
    }
}
```

Bad:

```dsl
workspace {
    model {
        a = softwareSystem "A"
        a -> b "Uses"

        b = softwareSystem "B"
    }
}
```

### Use `this` inside nested scopes

```dsl
workspace {

    !identifiers hierarchical

    model {
        a = softwareSystem "A" {
            api = container "API"
        }

        b = softwareSystem "B" {
            worker = container "Worker" {
                a.api -> this "Sends jobs to"
            }
        }
    }
}
```

### Refine views with expressions

```dsl
container acme "acme-focused" {
    include "->acme.api->"
    exclude "relationship.tag==Async"
    autoLayout lr
}
```

### Reluctant wildcard

```dsl
container acme "acme-containers-reluctant" {
    include *?
    autoLayout lr
}
```

### Filtered view for a tag-based slice

```dsl
filtered "acme-containers" include "Element,Relationship,PCI" "acme-containers-pci"
```

### Deployment modeling

```dsl
workspace {

    !identifiers hierarchical

    model {
        acme = softwareSystem "Acme Platform" {
            api = container "API"
            db = container "Database"
        }

        prod = deploymentEnvironment "Production" {
            deploymentNode "Kubernetes" {
                containerInstance acme.api

                deploymentNode "PostgreSQL" {
                    containerInstance acme.db
                }
            }
        }
    }

    views {
        deployment acme prod "acme-production" {
            include *
            autoLayout lr
        }
    }
}
```

## How to write dynamic views correctly

- Dynamic views show ordered instances of relationships that already exist in the static model.
- Keep the static relationship description broad, then override the wording in the dynamic view for the scenario.
- Use dynamic views for important use cases instead of creating many nearly identical static relationships.
- You can explicitly order steps with `1:`, `2:`, and so on when the sequence needs to be controlled.
- Parallel sequences can be shown with nested `{}` blocks or by reusing the same step number for concurrent interactions.
- Remember that a dynamic view is about behavior, not a separate model.

```dsl
dynamic acme "parallel-checkout" {
    1: customer -> acme.web "Starts checkout"
    2: acme.api -> fraud_service "Checks fraud"
    2: acme.api -> pricing_service "Calculates price"
    3: acme.api -> acme.db "Stores order"
    autoLayout lr
}
```

## How to read deployment views correctly

- A deployment view shows instances, not the original logical containers.
- Deployment nodes and infrastructure nodes describe where things run, not what the software does.
- Look for deployment environments such as Development, Staging, or Production to understand scope.
- If deployment groups are used, they constrain which replicated relationships appear between instances.

## Common pitfalls

- Forgetting that line order matters.
- Using `include *` and assuming it means the same thing on every view type.
- Relying on generated view keys and then losing manual layout stability.
- Mixing logical design concerns into deployment views.
- Treating groups or styles as architecture elements.
- Overusing component views where a container view is enough.
- Putting scenario-specific messages in the static model instead of dynamic views.
- Forgetting that filtered views hide the base view in the Structurizr UI unless another filtered view is created to represent the full view.
- Expecting all Structurizr styling features to survive PlantUML or Mermaid export unchanged.
- Forgetting that CLI export may need Internet access when themes are loaded from URLs.

## Validation and workflow

Preferred workflow when tooling is available:

1. Keep `workspace.dsl` in version control.
2. If using Structurizr local and manual layout, keep the generated `workspace.json` in version control too.
3. Validate the workspace before handing it off.
4. Export only when needed for downstream docs.
5. Prefer local or CLI workflows when you need the full DSL rather than the reduced browser-based parser.

Use the installed Structurizr CLI wrapper available on the machine, commonly `structurizr` or `./structurizr.sh`. For example:

```bash
structurizr validate -workspace workspace.dsl
structurizr export -workspace workspace.dsl -format mermaid
structurizr export -workspace workspace.dsl -format plantuml/c4plantuml -output diagrams
```

For local interactive viewing and layout editing:

```bash
docker pull structurizr/structurizr
docker run -it --rm -p 8080:8080 -v PATH:/usr/local/structurizr structurizr/structurizr local
```

## Expected response style when using this skill

When writing diagrams:

- produce real Structurizr DSL
- state the scope and assumptions briefly
- explain why each view exists
- keep the model concise and only as detailed as the request needs

When reading diagrams:

- summarize by C4 level
- call out the scoped system or container for each view
- distinguish logical structure, behavior, and deployment
- identify omissions, ambiguity, or over-modeling only when it is meaningful

If key scope information is missing and cannot be inferred from the repo or prompt, ask for the minimum clarification needed. Otherwise, choose a reasonable default and note the assumption.
