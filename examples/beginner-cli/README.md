# Beginner CLI example

A small Haskell project demonstrating a conventional Cabal layout and a realistic starter test stack:

- reusable logic in `src/`;
- a small executable in `app/`;
- a Tasty test suite in `test/`;
- focused example assertions with `tasty-hunit`;
- one generated property with `tasty-quickcheck`.

## Build

From this directory:

```sh
cabal build all
```

## Run

```sh
cabal run hello-haskell
```

Expected output:

```text
Hello, Haskell!
```

Pass a name after `--`:

```sh
cabal run hello-haskell -- Ada Lovelace
```

Expected output:

```text
Hello, Ada Lovelace!
```

## Test

```sh
cabal test all --test-show-details=direct
```

The test suite contains two complementary forms of evidence:

1. concrete examples that document expected behavior;
2. a property that generates non-empty alphabetic name words and checks that every generated word is preserved in the rendered greeting.

## What to notice

1. `AwesomeHaskell.Greeting` contains pure logic that is easy to test.
2. `Main` performs the effectful work: reading arguments and printing output.
3. Tasty organizes example-based and property-based tests in one tree.
4. The property uses an explicit generator instead of arbitrary strings containing irrelevant control characters.
5. The executable and tests depend on the local library through the Cabal package.
6. Compiler warnings are enabled centrally through a Cabal `common` stanza.
7. CI builds and tests this example on GHC 9.12 and 9.14.

## Why these dependencies?

- `tasty` provides suite organization, filtering, and reporting;
- `tasty-hunit` provides direct example assertions;
- `tasty-quickcheck` integrates QuickCheck properties into the same runner.

The example deliberately does not add automatic test discovery or a large application framework. The goal is to make each layer visible.

## Next steps

Good small exercises:

- add a `--help` option and test it at the process boundary;
- reject an empty name explicitly;
- inspect QuickCheck output after intentionally breaking `greeting`;
- classify generated names by length;
- add punctuation as an option and define a property for it;
- replace the QuickCheck property with Hedgehog to compare generator and shrinking styles.

See [`../../guides/testing.md`](../../guides/testing.md) for the broader testing decision guide.
