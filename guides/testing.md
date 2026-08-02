# Testing Haskell code

> **Audience:** Haskell developers choosing a test stack for a library or application  
> **Goal:** choose a practical combination of example-based, property-based, golden, and integration tests  
> **Last reviewed:** 2026-08-02  
> **Review scope:** core test runners and property-testing libraries; specialized domain packages are discovery-only unless stated otherwise

## Recommended starting stack

For a new general-purpose project, start with:

- **Tasty** as the test runner and suite organizer;
- **tasty-hunit** for focused example-based assertions;
- **tasty-quickcheck** for property-based tests;
- plain Cabal test suites executed with `cabal test`;
- explicit integration or golden tests only when they protect behavior that unit and property tests cannot express clearly.

This is a default path, not a claim that every project should use the same framework.

Choose **Hspec** instead when the team strongly prefers nested, behavior-oriented specifications and its expectation syntax. Choose **Hedgehog** instead of QuickCheck when integrated shrinking, explicit generator composition, or state-machine testing is central to the project.

## Start with the kind of confidence you need

A testing tool is only useful in relation to the failure it is meant to catch.

| Need | Useful test type | Typical tools |
| --- | --- | --- |
| One input should produce one expected result | Example-based unit test | tasty-hunit, HUnit, Hspec |
| A rule should hold across many generated inputs | Property test | QuickCheck, Hedgehog |
| Rendered text or serialized output must remain stable | Golden test | tasty-golden |
| Several modules or an external service must work together | Integration test | Tasty/Hspec plus resource setup |
| A command-line program must start and return correctly | Process-level test | tasty-program or a custom process test |
| Stateful commands must preserve invariants | State-machine property test | Hedgehog, QuickCheck state-machine libraries |

Do not replace clear example tests with generated tests merely because property testing is fashionable. Do not write hundreds of narrow examples when one well-chosen property captures the real rule.

## Tasty: a composable test runner

Tasty organizes tests into a `TestTree` and delegates actual assertions to provider packages. Its ecosystem includes providers for HUnit, QuickCheck, Hedgehog, golden tests, external programs, and other styles.

Use Tasty when:

- a project needs more than one kind of test;
- command-line filtering and deterministic reporting are valuable;
- tests need shared resource acquisition and cleanup;
- the team prefers explicit suite composition;
- the project may grow from simple unit tests into a mixed suite.

Important trade-offs:

- Tasty itself does not provide most assertion styles; provider packages are separate dependencies;
- explicit `TestTree` construction can feel verbose;
- automatic discovery is available through additional packages, but explicit lists are easier to understand in small projects;
- choosing Tasty does not choose between QuickCheck and Hedgehog.

A small suite looks like:

```haskell
module Main (main) where

import Test.Tasty (defaultMain, testGroup)
import Test.Tasty.HUnit (testCase, (@?=))
import Test.Tasty.QuickCheck (testProperty)

main :: IO ()
main =
  defaultMain $
    testGroup
      "tests"
      [ testCase "example" (reverse [1, 2, 3] @?= [3, 2, 1])
      , testProperty "reverse twice" $ \xs -> reverse (reverse xs :: [Int]) == xs
      ]
```

## Hspec: a spec-oriented runner

Hspec provides nested descriptions and expectation-focused syntax. It supports parallel execution, automatic spec discovery, QuickCheck integration, and interoperability with HUnit.

Use Hspec when:

- readable behavior descriptions are a strong team preference;
- tests are naturally discussed as contexts and expected outcomes;
- automatic discovery fits the repository's conventions;
- the team already has an established Hspec suite.

Important trade-offs:

- deeply nested prose can hide the actual setup and values involved;
- spec descriptions can become redundant when function names and types already communicate the behavior;
- mixing many testing styles may require integration packages or conventions;
- migrating between Hspec and Tasty is possible, but the suite structure is different.

A small suite looks like:

```haskell
module Main (main) where

import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "reverse" $ do
    it "reverses a concrete list" $
      reverse [1, 2, 3 :: Int] `shouldBe` [3, 2, 1]

    it "is its own inverse" $
      property $ \xs -> reverse (reverse xs :: [Int]) == xs
```

Neither Tasty nor Hspec makes tests better automatically. Prefer the runner whose suite structure the team can maintain consistently.

## HUnit: assertions and small unit suites

HUnit is a direct unit-testing framework inspired by JUnit. It provides assertions, named test cases, grouping, and a text runner.

Use HUnit directly when:

- the test suite is very small;
- another framework exposes HUnit-style assertions;
- a library wants minimal, familiar assertion primitives.

For a growing mixed suite, use HUnit through **tasty-hunit** or Hspec interoperability rather than building a custom runner around `runTestTT`.

HUnit's infrequent release history should not by itself be interpreted as abandonment: the API is small and mature. Review compatibility and maintainer evidence rather than using commit frequency as the only signal.

## QuickCheck: established property-based testing

QuickCheck tests properties against many randomly generated values. It supports custom generators, shrinking, classification and coverage of generated data, function generation, and monadic properties.

Use QuickCheck when:

- the project wants the most established Haskell property-testing ecosystem;
- existing types already have useful `Arbitrary` instances;
- integration with Tasty or Hspec is desired;
- the team wants a gradual path from simple Boolean properties to custom generators and shrinkers.

Important trade-offs:

- default `Arbitrary` instances may generate values that are technically valid but irrelevant to the domain;
- custom shrinking can be subtle, and a bad shrinker may violate generator invariants;
- a property that passes on poorly distributed data can create false confidence;
- random generation does not replace explicit boundary examples.

A useful property should state a domain rule, not merely restate the implementation.

Weak:

```haskell
prop_greeting words = greeting words == "Hello, " <> unwords words <> "!"
```

This mostly copies the implementation.

Stronger:

```haskell
prop_greeting_preserves_words words =
  all (`isInfixOf` greeting words) words
```

Even then, constrain the generator so the property describes meaningful names rather than arbitrary control characters and empty strings.

## Hedgehog: integrated generation and shrinking

Hedgehog integrates shrinking into generators so reduced counterexamples continue to respect generator structure. It also provides monadic generators, range combinators, useful diffs, concurrent property execution, and state-machine testing support.

Use Hedgehog when:

- generator invariants are complex and shrinking quality matters greatly;
- state-machine testing is a first-class requirement;
- the team prefers explicit generators over widespread `Arbitrary` instances;
- monadic generator composition makes the domain model clearer.

Important trade-offs:

- its ecosystem and number of ready-made instances are smaller than QuickCheck's;
- teams familiar with QuickCheck must learn a different generator style;
- integration with a common runner may require `tasty-hedgehog` or `hspec-hedgehog`;
- explicit generator design is valuable but can add up-front work.

## QuickCheck or Hedgehog?

| Question | QuickCheck | Hedgehog |
| --- | --- | --- |
| Existing ecosystem and integrations | Strongest | Good but smaller |
| Ready-made typeclass instances | Broad | More explicit generator style |
| Shrinking model | Separate `shrink` logic | Integrated with generators |
| Beginner familiarity in Haskell material | More common | Less common |
| Stateful model testing | Available through libraries | A prominent built-in use case |
| Best default for this guide | Yes | Alternative for specific needs |

Do not run both in the same project without a concrete reason. The conceptual overlap creates maintenance cost, and most teams benefit from one primary property-testing style.

## Golden tests

Golden tests compare current output with an approved reference file. They are useful for:

- pretty printers;
- generated source code;
- command-line output;
- serialization fixtures;
- compiler diagnostics;
- document conversion.

`tasty-golden` integrates this style with Tasty and provides an `--accept` workflow for updating expected outputs.

Important rules:

- review golden-file changes as code changes;
- never run automatic acceptance in CI;
- keep outputs deterministic;
- normalize platform-specific paths, timestamps, encodings, and line endings;
- prefer semantic assertions when a large snapshot obscures the actual requirement.

Golden tests are regression detectors. They do not prove that the approved output is correct.

## Integration tests

Integration tests should exercise a meaningful boundary:

- a real database schema and queries;
- a network protocol implementation;
- filesystem behavior;
- an executable process;
- interaction between independently configured components.

Keep these tests separate from fast pure tests when they require expensive setup or external services. A practical structure is:

```text
test/
  unit/
  property/
  integration/
  golden/
```

The exact directories matter less than being able to run focused subsets locally and in CI.

With Tasty, resource acquisition can be shared across groups. With Hspec, use hooks such as `beforeAll`, `around`, or explicit bracketed setup. Regardless of runner:

- isolate test data;
- clean up resources even after failure;
- avoid depending on test execution order;
- make timeouts explicit;
- report enough context to reproduce a failure.

## What to test in pure Haskell code

Pure functions make testing easier, but not every pure function deserves a test.

Prioritize:

- business rules and invariants;
- parsers and renderers;
- round trips such as `decode . encode`;
- normalization and idempotence;
- boundary conditions;
- transformations where information must not be lost;
- bug regressions.

Avoid tests that only verify language behavior or restate a trivial definition.

## A practical progression

For a new project:

1. add one Cabal test suite;
2. choose Tasty or Hspec as the primary runner;
3. write a few concrete examples for core behavior;
4. identify one real invariant and express it with QuickCheck or Hedgehog;
5. inspect generated-data distribution and counterexamples;
6. add integration tests at actual system boundaries;
7. add golden tests only for stable, reviewable output;
8. keep all test commands reproducible in CI.

## Runnable example

The repository's [`examples/beginner-cli`](../examples/beginner-cli) demonstrates the recommended starter combination:

- Tasty for suite organization;
- tasty-hunit for concrete examples;
- tasty-quickcheck for a property;
- CI execution on GHC 9.12 and 9.14.

Run it with:

```sh
cd examples/beginner-cli
cabal test all --test-show-details=direct
```

## Decision record

| Decision | Default recommendation | Consider an alternative when |
| --- | --- | --- |
| General test runner | Tasty | The team strongly prefers Hspec's spec syntax |
| Example assertions | tasty-hunit | Existing Hspec conventions are established |
| Property testing | QuickCheck | Integrated shrinking or state-machine testing makes Hedgehog a better fit |
| Golden testing | tasty-golden | Semantic assertions express the requirement more clearly |
| Tiny dependency-free teaching example | Manual assertions | The example is meant to demonstrate a realistic project test stack |

## Explore the ecosystem

### Core runners and assertions

- [Tasty](https://hackage.haskell.org/package/tasty)
- [Hspec](https://hspec.github.io/)
- [HUnit](https://hackage.haskell.org/package/HUnit)
- [tasty-hunit](https://hackage.haskell.org/package/tasty-hunit)

### Property testing

- [QuickCheck](https://hackage.haskell.org/package/QuickCheck)
- [Hedgehog](https://hackage.haskell.org/package/hedgehog)
- [tasty-quickcheck](https://hackage.haskell.org/package/tasty-quickcheck)
- [tasty-hedgehog](https://hackage.haskell.org/package/tasty-hedgehog)
- [hspec-hedgehog](https://hackage.haskell.org/package/hspec-hedgehog)

### Golden and process testing

- [tasty-golden](https://hackage.haskell.org/package/tasty-golden)
- [tasty-program](https://hackage.haskell.org/package/tasty-program)

### Broader discovery

- [Hackage Testing category](https://hackage.haskell.org/packages/#cat:Testing)
- [Legacy Awesome Haskell development tools](../README.md#development-tools)

## Evidence used for this review

- [Tasty package documentation](https://hackage.haskell.org/package/tasty)
- [Hspec documentation](https://hspec.github.io/)
- [HUnit package documentation](https://hackage.haskell.org/package/HUnit)
- [QuickCheck package documentation](https://hackage.haskell.org/package/QuickCheck)
- [Hedgehog package documentation](https://hackage.haskell.org/package/hedgehog)
- [tasty-golden package documentation](https://hackage.haskell.org/package/tasty-golden)

## Review notes

This guide intentionally recommends a small default stack while preserving credible alternatives. It should be reviewed when major runner APIs, property-testing models, or compiler compatibility change. Specialized packages should not become highlighted recommendations without a defined use case, trade-offs, and current evidence.
