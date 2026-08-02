# Entry format

> Status: pilot format; expected to change after the first three checked categories

The structured format exists to make claims inspectable and reusable. It should remain small enough for contributors to maintain by hand.

## Design goals

The format should:

- distinguish discovery from recommendation;
- separate maintenance status from recommendation level;
- record important trade-offs;
- link claims to evidence;
- expose when the entry's claims and sources were last checked;
- remain readable without a custom application.

The format should not attempt to mirror every field available from GitHub or Hackage. Contributor identity and responsibility already live in Git history and Pull Request discussion, so they are not duplicated in each entry.

## Minimal discovery entry

```yaml
schema_version: 2
name: Hoogle
kind: project
category: api-search
url: https://hoogle.haskell.org/
summary: Search Haskell APIs by name or approximate type signature.
role: discovery
checked_on: 2026-08-02
```

Required fields for discovery entries:

- `schema_version`;
- `name`;
- `kind`;
- `category`;
- `url`;
- `summary`;
- `role`;
- `checked_on`.

## Recommendation entry

```yaml
schema_version: 2
name: GHCup
kind: project
category: toolchain-management
url: https://www.haskell.org/ghcup/
summary: Installer and version manager for GHC, Cabal, HLS, and Stack.
role: recommendation
recommendation: recommended
maintenance_status: active
recommended_for:
  - newcomers installing the standard Haskell toolchain
  - developers switching between supported compiler versions
consider_alternatives_when:
  - the project standardizes on Nix or another reproducible environment manager
tradeoffs:
  - adds a toolchain-management layer that developers must understand
alternatives:
  - Nix
  - system packages
  - manually managed installations
evidence:
  - type: official-documentation
    url: https://www.haskell.org/ghcup/
    supports: canonical installation and tool-management role
checked_on: 2026-08-02
```

## Fields

### `schema_version`

Integer identifying the entry format. The current pilot format uses `2`.

Version 2 replaces `last_reviewed` with `checked_on` and removes contributor-specific `reviewers` and `affiliation` metadata from entries.

### `name`

Canonical human-readable name.

### `kind`

Working values:

- `project`;
- `package`;
- `documentation`;
- `course`;
- `book`;
- `article`;
- `community`;
- `index`;
- `production-case-study`.

The vocabulary should only expand when a real entry cannot be represented clearly.

### `category`

Stable machine-readable category identifier. Use lowercase kebab-case.

Examples:

```text
toolchain-management
web-api
database
property-testing
compiler-tools
```

### `url`

Canonical public URL. Prefer the official project site when it provides the primary documentation; otherwise use the canonical repository or publication page.

### `summary`

One neutral sentence describing what the entry is. Do not put recommendation claims in this field.

### `role`

Either:

- `discovery` — indexed for exploration;
- `recommendation` — presented as a choice for a defined use case.

### `recommendation`

Used only when `role` is `recommendation`.

Working values:

- `recommended` — a default choice for a defined use case;
- `alternative` — a credible choice with a different set of trade-offs;
- `experimental` — worth evaluating, but not a default;
- `historical` — important context, generally not a new-project choice.

### `maintenance_status`

Working values:

- `active`;
- `stable`;
- `experimental`;
- `maintenance-mode`;
- `historical`;
- `archived`;
- `unknown`.

This field must not be assigned solely from commit frequency.

### `recommended_for`

Concrete situations in which the option is a good fit.

Avoid broad entries such as “Haskell developers.” Prefer statements such as “small services that benefit from a minimal routing API.”

### `consider_alternatives_when`

Situations where another option may fit better. This field prevents recommendations from becoming promotional profiles.

### `tradeoffs`

Important costs, limitations, complexity, operational considerations, or compatibility concerns.

At least one trade-off is required for a recommendation.

### `alternatives`

Names of nearby options readers should compare. These names may later become references to other structured entries.

### `evidence`

A list of sources supporting current claims.

Each evidence item contains:

- `type`;
- `url`;
- `supports` — a short explanation of which claim the source supports.

Working evidence types:

- `official-documentation`;
- `release-notes`;
- `repository`;
- `compatibility`;
- `maintainer-statement`;
- `production-report`;
- `ci`;
- `other`.

### `checked_on`

ISO date in `YYYY-MM-DD` format. It records when the entry's claims and cited evidence were last checked. It is not an automated refresh timestamp and does not guarantee future compatibility.

## Contributor identity and affiliation

Authorship and responsibility are recorded by Git history and Pull Request discussion rather than repeated in every YAML entry.

Contributors should still disclose relevant project affiliations in the Pull Request description or discussion when an inclusion could create a conflict of interest.

## What should remain automated

Automation may collect or check:

- whether a URL resolves;
- whether a GitHub repository is archived;
- release timestamps;
- CI results for repository examples;
- package availability;
- basic compiler compatibility signals.

Automation must not independently decide:

- whether a project is recommended;
- whether infrequent activity means abandonment;
- whether one framework is better than another;
- whether a production claim is credible without checking its source.

## Pilot policy

Do not migrate the entire legacy README into YAML yet.

First create structured entries only for projects discussed in the pilot guides. After three categories have been checked, evaluate:

- which fields contributors actually use;
- which fields create maintenance burden;
- whether a JSON Schema validator is worthwhile;
- whether generated Markdown improves or harms readability;
- whether the structured data should become the source of truth.
