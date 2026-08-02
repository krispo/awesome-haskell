# Awesome Haskell

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

**A structured map and evidence-based decision guide for the Haskell ecosystem.**

> This is the staged entry point for the next version of Awesome Haskell. The original ecosystem map remains available in [`README.md`](README.md) while the new structure is developed and reviewed.

Awesome Haskell helps readers:

1. **Discover** the shape of the ecosystem.
2. **Choose** tools for a concrete task with explicit trade-offs.
3. **Verify** important recommendations with review dates, sources, and runnable examples.

## Start with a goal

- **[I am new to Haskell](guides/getting-started.md)** — installation, editor setup, first Cabal project, troubleshooting, and a recommended starter path. **Reviewed 2026-08-02.**
- **[I want to build a web API](guides/web-apis.md)** — choosing between Scotty, Servant, Yesod, IHP, and WAI/Warp. Includes a tested Scotty example and an explicit compiler-compatibility finding. **Evidence collected 2026-08-02; human review pending.**
- **I need to work with a database** — SQL-first and abstraction-first choices, migrations, pooling, transactions, and testing. _Planned._
- **[I want to test Haskell code](guides/testing.md)** — choosing a runner, example assertions, property testing, golden tests, and integration-test boundaries. **Reviewed 2026-08-02.**
- **I am evaluating Haskell for production** — real use cases, operational costs, hiring considerations, and primary sources. _Planned._
- **[I want to explore the ecosystem](README.md)** — the broad categorized map of projects, packages, learning materials, communities, and Hackage indexes.

See [`VISION.md`](VISION.md) for the project direction and [`docs/README_AUDIT.md`](docs/README_AUDIT.md) for the migration plan.

## Verified examples

Recommendations become more useful when readers can inspect and run code verified by CI.

### [Beginner CLI](examples/beginner-cli)

A conventional Cabal project demonstrating:

- pure logic in a library module;
- a separate executable;
- Tasty suite organization;
- example assertions with `tasty-hunit`;
- a generated property with `tasty-quickcheck`;
- strict compiler warnings;
- CI on GHC 9.12 and GHC 9.14.

```sh
cd examples/beginner-cli
cabal build all
cabal test all --test-show-details=direct
cabal run hello-haskell -- Ada Lovelace
```

### [Scotty web API](examples/web-api-scotty)

A small JSON service demonstrating:

- direct Scotty routes;
- JSON responses with Aeson;
- a reusable WAI `Application`;
- in-process route tests through `Network.Wai.Test`;
- a verified build and test suite on GHC 9.12.

```sh
cd examples/web-api-scotty
cabal build all
cabal test all --test-show-details=direct
cabal run web-api-scotty
```

As checked on 2026-08-02, the released Scotty dependency graph does not resolve on GHC 9.14.1 because the compatible `http-api-data` release declares `base < 4.22`. The example does not hide this with `allow-newer`; details are recorded in the [web API guide](guides/web-apis.md#verified-compiler-compatibility).

Example verification is defined in [`.github/workflows/verify-examples.yml`](.github/workflows/verify-examples.yml).

## How a category is organized

Important categories have two complementary layers.

### Start here

A small number of reviewed choices explaining:

- the use case;
- who the option fits;
- when to choose an alternative;
- limitations and trade-offs;
- maintenance or compatibility evidence;
- the review date;
- a runnable example where it reduces uncertainty.

### Explore the ecosystem

Broader discovery material:

- relevant Hackage categories;
- official documentation;
- additional projects;
- tutorials, books, and talks;
- community resources;
- historical context.

This preserves breadth without pretending that every link is an equal recommendation.

## Structured recommendations

The experimental machine-readable format is documented in [`docs/ENTRY_FORMAT.md`](docs/ENTRY_FORMAT.md) and validated by [`schema/entry.schema.json`](schema/entry.schema.json).

Current reviewed records include:

- [`data/toolchain-management/ghcup.yaml`](data/toolchain-management/ghcup.yaml);
- [`data/testing/tasty.yaml`](data/testing/tasty.yaml);
- [`data/testing/hspec.yaml`](data/testing/hspec.yaml);
- [`data/testing/quickcheck.yaml`](data/testing/quickcheck.yaml);
- [`data/testing/hedgehog.yaml`](data/testing/hedgehog.yaml).

The format separates:

- discovery from recommendation;
- recommendation level from maintenance status;
- advantages from trade-offs;
- human review from automated checks.

New web API records will be added only after a human reviews the guide. A contributor or tool must not record someone as a reviewer before that review happens.

The repository will not migrate the full legacy map into YAML until several pilot categories demonstrate that the format provides more value than maintenance cost.

## Evidence, not automatic rankings

Awesome Haskell does not rank projects using stars, downloads, or commit frequency alone. Those signals may provide context, but none proves that a tool fits a use case or is production-ready.

Highlighted recommendations should use evidence such as:

- official documentation and release notes;
- declared compiler compatibility;
- repository and package status;
- CI-tested examples;
- primary-source production reports;
- public review history;
- an explicit review date.

A mature project with few commits may be stable rather than abandoned. When evidence is unclear, the guide should say so.

## Working status vocabulary

- **Recommended** — a default for a defined use case.
- **Alternative** — a credible choice with different trade-offs.
- **Active** — meaningfully maintained.
- **Stable** — mature and usable with little need for frequent change.
- **Experimental** — worth evaluating, but not a default.
- **Maintenance mode** — maintained conservatively with limited new development.
- **Historical** — useful context, generally not a new-project choice.
- **Archived** — explicitly discontinued or archived upstream.
- **Unknown** — not recently reviewed or supported by enough evidence.

Recommendation level and maintenance status are separate. A project can be stable without being the recommended default for a particular task.

## Why a shared guide still matters

Search engines and AI assistants can produce lists quickly. A maintained public guide can additionally provide:

- durable and inspectable evidence;
- recommendations reviewed by identifiable contributors;
- reproducible examples compiled in CI;
- visible compatibility and review dates;
- recorded disagreement and trade-offs;
- corrections that improve one shared source;
- structured data reusable by documentation and tools.

The goal is not to produce the most prose. The goal is to become a source people and tools can verify.

## Pilot progress

1. **[Getting started](guides/getting-started.md)** — reviewed guide and CI-tested CLI example.
2. **[Testing](guides/testing.md)** — reviewed decision guide and mixed example/property test suite.
3. **[Web APIs](guides/web-apis.md)** — decision guide and tested Scotty/WAI example; awaiting human review before structured recommendation records are added.
4. **Databases** — planned.
5. **Haskell in production** — planned.

The original `README.md` will only be replaced after the staged entry point is useful on its own. The ecosystem map and its history will be preserved.

## Contributing during the redesign

Useful contributions include:

- corrections to the existing taxonomy;
- evidence that a project is active, stable, deprecated, or archived;
- concrete trade-offs between nearby choices;
- primary-source production case studies;
- small reproducible examples;
- reports from newcomers using the guides.

A highlighted recommendation should define its use case, rationale, limitations, alternatives, evidence, and review date. Affiliation with a recommended project must be disclosed.

Avoid unexplained promotional links. Broad discovery links remain welcome when relevant and correctly categorized, but recommendations use a higher standard.

See [`CONTRIBUTING.next.md`](CONTRIBUTING.next.md) for the review checklist.

## Repository layout during the transition

- [`README.md`](README.md) — original broad ecosystem map;
- [`README.next.md`](README.next.md) — staged task-oriented entry point;
- [`VISION.md`](VISION.md) — mission and editorial principles;
- [`CONTRIBUTING.next.md`](CONTRIBUTING.next.md) — contribution and evidence standards;
- [`guides/`](guides) — reviewed decision guides;
- [`examples/`](examples) — runnable examples verified in CI;
- [`data/`](data) — experimental structured recommendations;
- [`schema/`](schema) — structured-data contract;
- [`docs/README_AUDIT.md`](docs/README_AUDIT.md) — migration audit;
- [`.github/workflows/verify-examples.yml`](.github/workflows/verify-examples.yml) — example verification;
- [`.github/workflows/validate-data.yml`](.github/workflows/validate-data.yml) — YAML validation.

## Working principle

> **Discover broadly. Recommend carefully. Verify what we can. Be explicit about what we do not know.**

## License

[CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/)
