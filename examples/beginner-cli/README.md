# Beginner CLI example

A minimal Haskell project that demonstrates a conventional Cabal layout:

- reusable logic in `src/`;
- a small executable in `app/`;
- a test suite in `test/`;
- no third-party dependencies, so the first build remains easy to understand.

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

## What to notice

1. `AwesomeHaskell.Greeting` contains pure logic that is easy to test.
2. `Main` performs the effectful work: reading arguments and printing output.
3. The executable and tests depend on the local library through the Cabal package.
4. Compiler warnings are enabled centrally through a Cabal `common` stanza.
5. CI builds and tests this example on more than one recent GHC release.

## Next steps

Good small exercises:

- add a `--help` option;
- reject an empty name explicitly;
- add punctuation as an option;
- replace the manual argument handling with `optparse-applicative`;
- replace the manual test helper with a testing library after understanding the basic structure.
