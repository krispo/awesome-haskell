# Contributing to Awesome Haskell Next

This document applies to the staged redesign described in `README.next.md`. The existing contribution process remains unchanged until the new entry point is activated and this file replaces the main contribution guide.

## Before contributing

Awesome Haskell Next distinguishes between two kinds of entries:

1. **Discovery entries** help readers explore the ecosystem.
2. **Reviewed recommendations** help readers choose between concrete options.

A project may be useful as a discovery entry without being a recommended default. Please make the intended role explicit.

## Discovery entries

Discovery entries may include:

- projects and packages;
- Hackage categories;
- official documentation;
- books, courses, talks, and tutorials;
- community resources;
- historical projects that explain the ecosystem.

A discovery contribution should provide:

- the correct name and canonical URL;
- a neutral one-sentence description;
- the most appropriate category;
- disclosure of any affiliation with the linked project.

Discovery entries should not use promotional language such as “best,” “leading,” or “production-ready” without evidence.

## Reviewed recommendations

A reviewed recommendation uses a higher standard. It should answer:

- What problem does this option solve?
- Who is it appropriate for?
- When should a reader consider an alternative?
- What are its important trade-offs?
- Which nearby alternatives were considered?
- What current evidence supports the recommendation?
- When were the entry's claims and sources checked?

A recommendation should normally include at least one limitation. A contribution that only lists advantages is incomplete.

## Evidence

Prefer primary sources:

- official documentation;
- release notes;
- repository metadata;
- compatibility documentation;
- maintainer statements;
- technical reports written by production users;
- runnable examples and CI results.

Secondary articles and community discussions can add context, but they should not be the sole source for strong claims about maintenance, compatibility, security, or production use.

GitHub stars, download counts, and commit frequency may be mentioned as context. They are not sufficient evidence for a recommendation.

## Project status

Do not infer status from the date of the last commit alone.

A project with few commits may be stable and complete. A project with frequent commits may still be experimental or unsuitable for a particular use case.

When proposing a status, explain the evidence. When the evidence is insufficient, use `unknown` rather than guessing.

The working vocabulary is:

- `active`;
- `stable`;
- `experimental`;
- `maintenance-mode`;
- `historical`;
- `archived`;
- `unknown`.

Recommendation level is separate from maintenance status. For example, a stable project can be either recommended or discovery-only.

## Check dates

Structured entries must include a `checked_on` date in ISO format:

```text
YYYY-MM-DD
```

The date means that the entry's claims and cited evidence were inspected on that date. It does not guarantee future compatibility.

## Runnable examples

Add an example only when it removes meaningful uncertainty, such as:

- how several libraries fit together;
- whether a recommended setup compiles;
- how to structure a first project;
- how two approaches differ in practice.

Examples should be:

- intentionally small;
- documented with exact commands;
- tested in CI;
- free of unrelated abstractions;
- explicit about supported compiler versions.

Do not add a large showcase application merely to demonstrate that a library exists.

## Affiliation and conflicts of interest

Contributors must disclose when they are:

- a maintainer or contributor to the recommended project;
- employed by a company behind the project;
- selling services primarily based on the project;
- otherwise likely to benefit from its inclusion.

Affiliation does not disqualify a contribution. Hidden affiliation damages trust. Disclose it in the Pull Request description or discussion; contributor identity is not duplicated inside each YAML entry.

## Writing style

Use neutral, concrete language.

Prefer:

> Suitable for small HTTP services where a minimal API is more important than type-level API descriptions.

Avoid:

> The fastest and easiest framework for modern Haskell development.

Explain decisions rather than adding adjectives.

## Pull request checklist

For a discovery entry:

- [ ] The link is canonical and works.
- [ ] The description is neutral and specific.
- [ ] The category is appropriate.
- [ ] Affiliation is disclosed in the Pull Request when relevant.

For a reviewed recommendation:

- [ ] The target use case is defined.
- [ ] At least one trade-off is documented.
- [ ] Alternatives are named.
- [ ] Maintenance or stability claims have evidence.
- [ ] Primary sources are included where available.
- [ ] `checked_on` is present.
- [ ] Affiliation is disclosed in the Pull Request when relevant.
- [ ] Any runnable example builds and passes CI.

## Scope control

The redesign is incremental. A focused improvement to one category is preferable to a large automated rewrite of the entire repository.

When uncertain whether an entry belongs in the project, open an issue or discussion describing the user problem it would solve before preparing a large pull request.
