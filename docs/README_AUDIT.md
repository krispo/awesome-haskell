# README Audit and Migration Plan

> Status: initial audit for the `awesome-haskell-next` branch

## Executive summary

The existing README is not merely a random list of links. Its primary contribution is a broad taxonomy of the Haskell ecosystem: it identifies important areas, connects readers to concrete projects, and links those areas to larger Hackage and Haskell Wiki indexes. That work is especially useful to newcomers who do not yet know which concepts or categories exist.

The redesign should preserve that strength. The main opportunity is to make different kinds of links legible, add decision support, and establish a maintainable way to show whether highlighted information is current.

The migration strategy is therefore:

> **Keep the ecosystem map, distinguish recommendations from indexes, and add evidence gradually.**

## What the current README does well

### 1. It provides an ecosystem taxonomy

The README groups the ecosystem into recognizable areas such as compilers, concurrency, configuration, cryptography, data access, databases, web development, messaging, science, and streaming.

For a newcomer, naming these areas is already useful: it turns an unfamiliar ecosystem into a navigable map.

### 2. It connects several levels of discovery

The list combines:

- foundational tools such as GHC, Cabal, Stack, Hackage, and Hoogle;
- individual libraries and applications;
- Hackage category indexes;
- Haskell Wiki overview pages;
- tutorials, courses, videos, conferences, and community links.

This combination helps readers move from a broad topic to either a concrete project or a more comprehensive source.

### 3. It covers more than packages

The resources section acknowledges that an ecosystem includes learning materials, communities, conferences, applications, and development practices—not only libraries.

### 4. It has accumulated community knowledge

The repository history and contributions represent years of discovery and classification work. The redesign should retain attribution and avoid a destructive rewrite that discards useful context.

## Where the current README becomes difficult to use

### 1. Different link types look equivalent

A direct project recommendation, a Hackage category, a Wiki overview, an old tutorial, and a historical project all appear as similar bullet points.

Readers cannot easily tell whether an item means:

- start here;
- one possible option;
- comprehensive external index;
- background reading;
- historical context;
- unreviewed legacy entry.

### 2. The list offers discovery but little decision support

The current structure often answers “what exists?” but not:

- which option fits a particular task;
- what the major alternatives are;
- what trade-offs matter;
- whether a project is suitable for newcomers or production;
- when the information was last reviewed.

### 3. Category granularity is uneven

Some sections list individual projects, some mostly forward to Hackage categories, and others point to Wiki pages. Some categories are highly specific while others cover broad domains.

This is not inherently wrong, but the intended role of each section is not stated.

### 4. Current and historical resources are mixed

The README contains entries that may be active, stable, obsolete, moved, or historical. Without status or review metadata, a newcomer has to independently investigate each item.

### 5. Descriptions are inconsistent

Descriptions vary in tone, detail, capitalization, punctuation, and specificity. Some explain a use case; others restate the link title or use promotional language.

### 6. The table of contents exposes implementation structure, not user goals

The existing contents list is useful when a reader already knows the relevant category. It is less helpful to someone asking:

- How do I start?
- How do I build an API?
- What should I use with PostgreSQL?
- How is Haskell used in production?

Goal-oriented entry points should complement, not replace, the taxonomy.

### 7. A single large Markdown file limits maintainability

As the project adds comparisons, sources, review dates, and examples, one README will become increasingly difficult to review and update. Structured data and focused guides should eventually become the source material for generated summaries.

## Content model: distinguish the role of each item

Each existing entry should eventually be classified into one of these roles.

| Role | Purpose | Review standard |
| --- | --- | --- |
| Highlighted choice | Helps the reader choose a tool for a defined use case | Rationale, trade-offs, alternatives, evidence, review date |
| Ecosystem project | Broad discovery without an explicit recommendation | Correct categorization and current destination |
| Comprehensive index | Links to Hackage or another broad catalog | Relevance and accessibility |
| Official resource | Primary documentation or official ecosystem page | Correct destination and scope |
| Learning resource | Tutorial, book, course, or video | Audience, level, currency, and accessibility |
| Production case | Evidence of real-world Haskell usage | Primary source, date, scope, and current-status caveat |
| Historical resource | Important context but not a default current choice | Clearly labeled as historical |

The immediate migration does not require assigning every item at once. The model should first be tested in pilot sections.

## What should be preserved

- The broad category map.
- Links to relevant Hackage categories.
- Links to official Haskell and project documentation.
- Useful applications written in Haskell, not only libraries.
- Learning and community resources.
- Repository history, contributors, and attribution.
- The ability to browse beyond a small curated shortlist.

## What should be added

- Goal-oriented entry paths.
- A concise `Start here` block in important categories.
- Explicit trade-offs and nearby alternatives.
- Clear separation between recommendation and discovery.
- Project and resource statuses where useful.
- `Last reviewed` dates for important claims.
- Primary sources for production-readiness statements.
- CI-tested starter examples.
- Automated link and repository-status checks.
- A practical structured-data schema.

## What should be retired or reduced

- Empty or broken links.
- Duplicate category links that add no distinct value.
- Unexplained promotional submissions.
- Claims such as “best” without criteria or evidence.
- Historical resources presented as current defaults.
- Repeated boilerplate such as “a collaborative Hackage list” when one category index can represent the same information more clearly.
- Metadata that cannot be maintained reliably.

Retiring an item does not always mean deleting its history. Important obsolete projects may move to a clearly labeled historical section.

## Proposed migration phases

### Phase 0 — establish the direction

- Keep the original README unchanged.
- Add `VISION.md`.
- Add a draft next-generation entry point.
- Record this audit and migration plan.

### Phase 1 — create one complete newcomer path

Build a `Getting started` guide that includes:

- a minimal installation path;
- editor and language-server setup;
- one small starter project;
- an explanation of Cabal, GHCup, Hackage, Hoogle, and optional Stack usage;
- a learning path with audience and currency notes;
- a CI-tested example.

This guide should be useful independently of the rest of the redesign.

### Phase 2 — test the decision-guide format

Convert three high-value categories:

1. Web APIs;
2. Databases;
3. Testing.

Each should contain:

- a short overview;
- several highlighted choices, not an exhaustive ranking;
- use cases and trade-offs;
- broader Hackage and documentation links;
- statuses and review dates;
- at least one runnable example where appropriate.

### Phase 3 — introduce structured data and automation

After the pilot format proves useful:

- define the minimal YAML schema;
- move pilot entries into structured files;
- generate summary tables or README sections;
- check links automatically;
- detect archived GitHub repositories;
- expose review dates and verification results.

Structured data should follow the editorial model, not determine it prematurely.

### Phase 4 — migrate the remaining map incrementally

Review categories in manageable groups. For each category:

- preserve useful discovery coverage;
- remove duplicate or broken entries;
- classify historical resources;
- add a small curated layer only when contributors can defend it;
- avoid blocking publication on complete migration.

### Phase 5 — replace the public entry point

Replace the root README only when the new version:

- explains the project clearly;
- contains at least one complete newcomer path;
- demonstrates the new category format;
- links to the preserved broad map;
- has contribution rules suitable for the new model.

## Proposed repository shape

```text
README.md                      # eventual generated or concise entry point
VISION.md                      # mission and editorial principles
CONTRIBUTING.md                # evidence and review requirements

data/
  projects/                    # structured project records after pilot validation
  resources/                   # structured learning and ecosystem resources

guides/
  getting-started.md
  choosing-a-web-api-stack.md
  choosing-a-database-library.md
  testing.md
  haskell-in-production.md

examples/
  beginner-cli/
  web-api/
  postgres/

scripts/
  check-links
  check-repositories
  generate-readme

docs/
  README_AUDIT.md
  schema.md
  migration.md
```

This is a direction, not a requirement to create every directory immediately.

## Pilot acceptance criteria

A pilot guide should not be considered complete merely because it contains prose. It should allow a reader to make or validate a decision.

Minimum criteria:

- the audience and task are explicit;
- highlighted options have distinct use cases;
- at least one meaningful disadvantage is documented for each highlighted option;
- nearby alternatives are named;
- important status claims have sources;
- a review date is visible;
- broad discovery links remain available;
- examples build in CI when an example is part of the recommendation.

## Editorial risks to manage

### Maintainer bias

Recommendations inevitably contain judgement. The project should make the reasoning inspectable and record material disagreements rather than claiming false objectivity.

### Activity-score bias

Recent commits do not automatically mean quality, and infrequent commits do not automatically mean abandonment. Automated activity data must remain supporting evidence.

### Scope explosion

The project can become unmaintainable if every entry requires extensive bespoke research. Detailed review should focus on highlighted choices; broad discovery entries use a lighter standard.

### Premature automation

Generating a polished website from weak or unreviewed data would not improve the underlying guide. Editorial usefulness should precede infrastructure complexity.

### Destructive cleanup

Removing old links without recording why may erase useful history. Migration commits should be small and explain whether entries were moved, merged, marked historical, or removed as broken.

## Recommended next implementation step

Create `guides/getting-started.md` as the first complete vertical slice. It should establish:

- the writing style;
- the distinction between recommendation and exploration;
- the evidence format;
- the review-date convention;
- the first runnable example requirements.

Only after that guide is reviewed should the project settle the final YAML schema.

## Decisions still needed

- Keep `Awesome Haskell` as the sole name, or add a subtitle such as `Haskell Ecosystem Map`?
- Should the original broad map remain in the root README, move to `ecosystem-map.md`, or be generated from data?
- Which GHC releases should examples test?
- How should multiple maintainers approve a `Recommended` status?
- Should recommendation disputes be documented inline, in issues, or in decision records?
- Which parts of project health can be automated without creating misleading scores?

## Working conclusion

The original README performed useful information-architecture work. The redesign should not apologize for that work or discard it. Its purpose is to make the taxonomy more actionable, transparent, and verifiable for the next generation of users.
