# Awesome Haskell

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

**A structured map and evidence-based decision guide for the Haskell ecosystem.**

> This is a working draft for the next version of Awesome Haskell. The original ecosystem map remains available in [`README.md`](README.md) while the new structure is developed and reviewed.

Awesome Haskell helps people do three things:

1. **Discover** the shape of the Haskell ecosystem.
2. **Choose** tools for a concrete task with explicit trade-offs.
3. **Verify** that important recommendations are current and usable.

The project began as a broad, categorized collection of libraries, tools, Hackage categories, learning materials, and community resources. That taxonomy remains valuable—especially for newcomers. The next version keeps that map while adding clearer paths, human judgement, review dates, and reproducible evidence.

## Start with a goal

The guide lets readers enter through a task rather than requiring them to understand the whole taxonomy first.

- **[I am new to Haskell](guides/getting-started.md)** — installation, first project, editor setup, core tools, troubleshooting, and a recommended starter path. **Reviewed 2026-08-02.**
- **I want to build a web API** — major approaches, trade-offs, database options, deployment concerns, and runnable examples. _Planned._
- **I need to work with a database** — SQL-first and abstraction-first choices, migrations, pooling, and testing. _Planned._
- **[I want to test Haskell code](guides/testing.md)** — choosing a runner, example assertions, property testing, golden tests, and integration-test boundaries. **Reviewed 2026-08-02.**
- **I am evaluating Haskell for production** — real use cases, strengths, operational costs, hiring considerations, and primary sources. _Planned._
- **[I want to explore the ecosystem](README.md)** — the broad categorized map of projects, packages, resources, and Hackage indexes.

See [`VISION.md`](VISION.md) for the full direction and [`docs/README_AUDIT.md`](docs/README_AUDIT.md) for the migration plan.

## Verified examples

Recommendations become more trustworthy when readers can inspect and run the same code that CI verifies.

### [Beginner CLI](examples/beginner-cli)

A deliberately small Cabal project demonstrating:

- a reusable pure library module;
- a separate executable entry point;
- Tasty suite organization;
- focused assertions with tasty-hunit;
- a generated property with tasty-quickcheck;
- compiler warnings enabled centrally;
- command-line arguments;
- automated builds and tests on GHC 9.12 and 9.14.

Run it from `examples/beginner-cli`:

```sh
cabal build all
cabal test all --test-show-details=direct
cabal run hello-haskell -- Ada Lovelace
```

The workflow is defined in [`.github/workflows/verify-examples.yml`](.github/workflows/verify-examples.yml). More examples should only be added when they clarify a real decision or eliminate meaningful setup uncertainty.

## How entries will be organized

Important categories will have two complementary sections.

### Start here

A small number of reviewed choices with context:

- what the project is good for;
- who it is suitable for;
- when to consider an alternative;
- important limitations and trade-offs;
- maintenance or stability evidence;
- a visible review date;
- a runnable example where useful.

### Explore the ecosystem

Broader discovery material:

- relevant Hackage categories;
- official documentation;
- additional projects;
- tutorials and books;
- community resources;
- related ecosystem maps.

This preserves breadth without pretending that every link is an equal recommendation.

## Structured recommendations

The pilot format is documented in [`docs/ENTRY_FORMAT.md`](docs/ENTRY_FORMAT.md). It deliberately separates:

- discovery from recommendation;
- recommendation level from maintenance status;
- human review dates from automated metadata;
- advantages from explicit trade-offs.

Current pilot records include:

- [`data/toolchain-management/ghcup.yaml`](data/toolchain-management/ghcup.yaml);
- [`data/testing/tasty.yaml`](data/testing/tasty.yaml);
- [`data/testing/hspec.yaml`](data/testing/hspec.yaml);
- [`data/testing/quickcheck.yaml`](data/testing/quickcheck.yaml);
- [`data/testing/hedgehog.yaml`](data/testing/hedgehog.yaml).

The repository will not migrate the full legacy list into YAML until several pilot categories prove that the format is maintainable.

## Evidence, not rankings

Awesome Haskell will not rank projects using GitHub stars, download counts, or commit frequency alone. Those signals can provide context, but none of them proves that a tool is appropriate, maintained, or production-ready.

Where practical, highlighted recommendations should be supported by:

- upstream documentation and release information;
- compatibility with supported GHC versions;
- repository and package status;
- CI-tested examples;
- primary-source production reports;
- public review history;
- an explicit `last reviewed` date.

A mature project with few commits may be stable rather than abandoned. When the evidence is unclear, the guide should say so.

## Proposed project statuses

- **Recommended** — recommended for a defined use case.
- **Active** — meaningfully maintained.
- **Stable** — mature and usable, with little need for frequent change.
- **Experimental** — promising, but not a default recommendation.
- **Maintenance mode** — maintained conservatively, with limited new development.
- **Historical** — useful for context, but generally not for new projects.
- **Archived** — explicitly discontinued or archived upstream.
- **Unknown** — not recently reviewed or supported by enough evidence.

Statuses describe different things and may eventually be split into separate fields. For example, a project can be both stable and recommended.

## Why a shared guide still matters

Search engines and AI assistants can produce explanations and lists quickly. A maintained open-source guide can add things that a generated answer usually cannot guarantee:

- durable, inspectable evidence;
- recommendations reviewed by identifiable contributors;
- reproducible examples compiled in CI;
- visible compatibility and review dates;
- recorded disagreements and trade-offs;
- corrections that improve one shared public source;
- structured data reusable by documentation, tools, and AI systems.

The goal is not to compete on the amount of generated prose. The goal is to become a source people and tools can trust.

## Pilot areas

The new model is being tested on a small set of high-value sections:

1. **[Getting started](guides/getting-started.md)** — reviewed guide with a [CI-tested CLI example](examples/beginner-cli);
2. Web APIs;
3. Databases;
4. **[Testing](guides/testing.md)** — reviewed decision guide with example-based and property-based tests in CI;
5. Haskell in production.

A pilot section is complete only when it contains both a useful decision guide and broader discovery links. Runnable examples will be added where they materially reduce uncertainty.

## Contributing during the redesign

The redesign is intentionally incremental. Contributions are welcome in the form of:

- corrections to the existing taxonomy;
- evidence that a highlighted project is active, stable, deprecated, or archived;
- concrete trade-offs between nearby choices;
- primary-source production case studies;
- small reproducible examples;
- feedback from newcomers trying to navigate the guide.

A proposed highlighted recommendation should normally explain the use case, rationale, limitations, alternatives, evidence, and review date. Affiliation with a recommended project should be disclosed.

Please avoid adding unexplained promotional links. Broad ecosystem links remain welcome when they are relevant and correctly categorized, but highlighted recommendations use a higher standard.

See [`CONTRIBUTING.next.md`](CONTRIBUTING.next.md) for the redesign's contribution rules and review checklist.

## Current repository layout

During the transition:

- [`README.md`](README.md) contains the original broad ecosystem map;
- [`README.next.md`](README.next.md) is the proposed new entry point;
- [`VISION.md`](VISION.md) defines the mission and editorial principles;
- [`CONTRIBUTING.next.md`](CONTRIBUTING.next.md) defines contribution and evidence standards;
- [`docs/README_AUDIT.md`](docs/README_AUDIT.md) records what should be preserved, improved, or retired;
- [`docs/ENTRY_FORMAT.md`](docs/ENTRY_FORMAT.md) documents the pilot structured-data format;
- [`data/`](data) contains reviewed machine-readable recommendations;
- [`guides/getting-started.md`](guides/getting-started.md) provides the newcomer path;
- [`guides/testing.md`](guides/testing.md) provides the testing decision guide;
- [`examples/beginner-cli`](examples/beginner-cli) demonstrates a runnable application and mixed test suite;
- [`.github/workflows/verify-examples.yml`](.github/workflows/verify-examples.yml) verifies examples across supported compilers.

The original README will only be replaced after the new entry point is useful on its own. History and attribution will be preserved.

## Working principle

> **Discover broadly. Recommend carefully. Verify what we can. Be explicit about what we do not know.**

## License

[CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/)
