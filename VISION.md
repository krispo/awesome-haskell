# Awesome Haskell Next — Vision

> Status: initial working draft

## Why this project exists

Awesome Haskell started as a structured map of the Haskell ecosystem. It grouped libraries, tools, learning materials, communities, and broader Hackage categories so that people—especially newcomers—could understand what existed and where to continue exploring.

That original purpose remains useful. The problem is not that the project contains links; the problem is that a link collection alone no longer provides enough context, confidence, or evidence.

Search engines and AI assistants can quickly produce lists and explanations. Awesome Haskell should therefore not try to win by containing the most links or the most prose. It should become a trustworthy, maintained map that helps people:

1. discover the shape of the Haskell ecosystem;
2. choose an appropriate tool for a concrete task;
3. verify that the recommendation is current and usable.

## Mission

**Awesome Haskell is an evidence-based map and decision guide for the Haskell ecosystem.**

It combines broad discovery with human curation, explicit trade-offs, reproducible examples, and verifiable project-health information.

## Who it is for

### Newcomers

People who need a clear view of the ecosystem, sensible starting points, and protection from outdated advice.

### Working Haskell developers

People choosing libraries, comparing approaches, or looking for maintained examples and production-oriented guidance.

### Technical decision-makers

People evaluating whether Haskell and its ecosystem are appropriate for a project, team, or domain.

### Maintainers and contributors

People who need a neutral place to document project status, alternatives, migration paths, and ecosystem gaps.

## The three layers

### 1. Discover

Preserve and improve the original strength of Awesome Haskell: a structured map of the ecosystem.

Each area may include:

- important projects;
- relevant Hackage categories;
- official documentation;
- learning materials;
- community resources;
- related ecosystem maps.

Discovery can be broad, but it must remain organized and understandable.

### 2. Choose

Each important category should include a small, opinionated decision guide.

A recommendation should explain:

- what the project is good for;
- who it is suitable for;
- when to consider an alternative;
- its important trade-offs;
- how it differs from nearby options.

The goal is not to declare one universal winner. The goal is to make the decision legible.

### 3. Verify

Where practical, recommendations should be backed by current evidence.

Useful evidence may include:

- latest release or meaningful activity;
- repository status;
- compatibility with supported GHC versions;
- documentation availability;
- runnable examples;
- CI verification;
- primary-source production reports;
- a visible `checked on` date.

Automated signals must support human judgement, not replace it.

## What makes this more useful than an AI answer

Awesome Haskell should provide durable and inspectable evidence that a generated answer usually cannot guarantee:

- recommendations backed by public change history and discussion;
- reproducible examples that are compiled in CI;
- explicit dates and compatibility information;
- recorded disagreements and trade-offs;
- structured data reusable by humans, tools, and AI systems;
- corrections that improve one shared public source rather than one private conversation.

## Editorial principles

### Keep the map, add judgement

The project should not discard its broad taxonomy. It should add clearer paths through it.

### Prefer explanation over praise

Every highlighted project should say why it matters and where it does not fit.

### Prefer evidence over popularity

GitHub stars may be shown as context, but they are not a recommendation criterion.

### Stable is not the same as abandoned

A project with infrequent commits may be complete and reliable. Status labels must avoid simplistic activity rankings.

### Be honest about uncertainty

When maintainership, compatibility, or production readiness is unclear, say so.

### Make maintenance visible

Important claims should have a check date and, where possible, a source.

### Curate highlights, index the rest

A category may link to a comprehensive Hackage list while highlighting only a few projects with detailed guidance.

## Proposed project statuses

The exact vocabulary may change, but statuses should distinguish at least:

- **Recommended** — actively recommended for a defined use case;
- **Active** — meaningfully maintained;
- **Stable** — mature and usable, with little need for frequent change;
- **Experimental** — promising but not yet a default recommendation;
- **Maintenance mode** — maintained conservatively, with limited new development;
- **Historical** — important for context but generally not a new-project choice;
- **Archived** — explicitly discontinued or archived upstream;
- **Unknown** — not recently checked or insufficient evidence.

## Proposed entry model

A structured entry may eventually contain fields like:

```yaml
schema_version: 2
name: Servant
kind: package
category: web-api
url: https://docs.servant.dev/
summary: Type-level DSL for describing web APIs.
role: recommendation
recommendation: recommended
maintenance_status: active
recommended_for:
  - large typed APIs
  - shared server and client contracts
consider_alternatives_when:
  - the service has only a few endpoints
  - the team is new to type-level Haskell
tradeoffs:
  - expressive but conceptually demanding
  - compile-time cost can grow with API complexity
alternatives:
  - Scotty
  - Yesod
evidence:
  - type: official-documentation
    url: https://docs.servant.dev/
    supports: typed API descriptions and generated server and client interfaces
checked_on: YYYY-MM-DD
```

The schema must remain practical. We should not collect metadata that nobody can maintain.

## Initial scope

The first iteration should prove the model on a small number of high-value areas rather than rewriting the entire repository.

Suggested pilot areas:

1. Getting started;
2. Web APIs;
3. Databases;
4. Testing;
5. Haskell in production.

For each pilot area, aim to provide:

- a short ecosystem overview;
- a curated `Start here` section;
- comparisons and trade-offs;
- broader discovery links;
- project status and check dates;
- at least one runnable example where useful.

## First milestone

The first meaningful release of the new direction should include:

- [ ] a revised README explaining the new purpose;
- [ ] the existing taxonomy preserved as an ecosystem map;
- [ ] three categories converted to the new format;
- [ ] a minimal structured-data schema;
- [ ] automated link checking;
- [ ] detection of archived GitHub repositories;
- [ ] at least two CI-tested starter examples;
- [ ] contribution guidelines with evidence requirements;
- [ ] a migration plan for the remaining categories.

## Non-goals

Awesome Haskell should not become:

- a mirror of every Hackage package;
- a leaderboard based on stars, downloads, or commit frequency;
- an advertising directory accepting every submitted project;
- a claim that one tool is universally best;
- an automatically generated website without editorial responsibility;
- a replacement for official project documentation;
- an attempt to rewrite the whole ecosystem before publishing useful improvements.

## Contribution standard

A proposed highlighted recommendation should normally include:

1. the use case it addresses;
2. why it is being recommended;
3. at least one important trade-off;
4. nearby alternatives;
5. evidence for maintenance or stability claims;
6. a check date;
7. disclosure when the contributor is affiliated with the project.

Broad discovery links may use a lighter standard, but they must still be relevant and correctly categorized.

## Measures of success

The project succeeds when it helps users make better decisions, not when the list becomes longer.

Possible signals:

- a newcomer can find a viable starting stack without reading the entire repository;
- a developer can compare major options in a category;
- highlighted examples continue to build in CI;
- stale recommendations are detected and checked;
- maintainers contribute corrections and trade-offs;
- other documentation and AI tools can cite or consume the structured data;
- the number of unexplained links decreases even if the total coverage remains broad.

## Open questions

- Should the project keep the `awesome-haskell` name as the public identity or introduce a subtitle such as `Haskell Ecosystem Map`?
- Which GHC versions should verified examples support?
- Which metadata can be maintained reliably without creating excessive work?
- Should structured data become the source of truth immediately or only after the pilot categories are validated?
- How should disputed recommendations be documented?
- Who should be invited as additional maintainers or contributors?

## Working principle

**Discover broadly. Recommend carefully. Verify what we can. Be explicit about what we do not know.**
