# Getting started with Haskell

> **Audience:** people installing Haskell for the first time or returning after several years  
> **Goal:** create, edit, build, and run a small Cabal project with a working language server  
> **Last reviewed:** 2026-08-02  
> **Review scope:** installation path and core tools; learning-resource review is still incomplete

## Recommended path

For most newcomers, start with this toolchain:

- **GHCup** to install and manage Haskell tools;
- the GHCup **recommended** GHC version rather than automatically choosing the newest release;
- **Cabal** as the first build tool to learn;
- **Haskell Language Server (HLS)** for editor support;
- an editor with an HLS integration, with VS Code offering the lowest-friction documented path for many beginners.

This is not the only valid setup. Nix, Stack, system packages, containers, and manually managed compilers can all be appropriate. They introduce additional choices, however, and are better treated as alternative paths rather than requirements for a first program.

## 1. Install the toolchain

GHCup is the main installer recommended by the Haskell project. It manages GHC, Cabal, HLS, and Stack and can switch between installed versions.

Follow the platform-specific instructions on the official [GHCup installation page](https://www.haskell.org/ghcup/install/).

For Linux, macOS, FreeBSD, or WSL2, the documented installer command is:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Run the installer as a normal user, not as root. Select at least:

- GHC;
- cabal-install;
- Haskell Language Server.

Installing Stack as well is reasonable because some existing projects and learning materials use it. You do not need to learn both build tools at the same time.

### Why use the recommended version?

GHCup distinguishes `recommended` from `latest`. Its recommended selection considers ecosystem adoption, tool compatibility, and known bugs. A newcomer generally benefits more from broad compatibility than from using a newly released compiler immediately.

You can inspect and manage installed tools with:

```sh
ghcup list
ghcup tui
```

## 2. Verify the installation

Open a new terminal and run:

```sh
ghc --version
cabal --version
haskell-language-server-wrapper --version
```

Each command should print version information. When a command is not found, first restart the terminal and confirm that the GHCup binary directory is on `PATH`.

Do not debug editor integration before these commands work in a terminal.

## 3. Configure an editor

### Lowest-friction starting point

Install:

1. [Visual Studio Code](https://code.visualstudio.com/);
2. the [Haskell extension](https://marketplace.visualstudio.com/items?itemName=haskell.haskell).

The extension communicates with HLS to provide diagnostics, hover information, navigation, formatting integrations, and other language features.

The important compatibility rule is that HLS must support the GHC version used by the project. Installing both through GHCup reduces this source of mismatch.

### Other editors

HLS implements the Language Server Protocol, so it can also work with editors such as Neovim, Emacs, Helix, and others. Those setups are valuable, but editor-specific configuration is outside this minimal path.

See the official [HLS installation documentation](https://haskell-language-server.readthedocs.io/en/stable/installation.html) when the editor cannot find the language server.

## 4. Create a project

Create a minimal Cabal application:

```sh
cabal init hello-haskell --non-interactive
cd hello-haskell
cabal run
```

Cabal creates a package description and an application entry point, resolves dependencies, builds the project, and runs the executable.

The generated layout may change between Cabal versions, but a small application will usually contain files serving these roles:

```text
hello-haskell/
├── app/
│   └── Main.hs
└── hello-haskell.cabal
```

Open the directory—not only `Main.hs`—in the editor so HLS can discover the project configuration.

Change the program to:

```haskell
module Main where

main :: IO ()
main = putStrLn "Hello, Haskell!"
```

Then run:

```sh
cabal build
cabal run
```

## 5. Use GHCi for small experiments

For quick exploration, start the interactive environment:

```sh
ghci
```

Useful commands include:

```text
:t expression    show the type of an expression
:i name          show information about a name
:r               reload the current modules
:q               exit
```

Inside a Cabal project, prefer:

```sh
cabal repl
```

This starts GHCi with the project's modules and dependencies available.

## 6. Understand the core tools

### GHC

The compiler and interactive runtime. You will occasionally call `ghc` or `ghci` directly, but project builds are normally managed through Cabal or Stack.

### Cabal

Two related things share this name:

- the Cabal package format and library;
- `cabal-install`, whose command is `cabal`.

Cabal describes packages, resolves dependencies, builds components, runs programs, starts REPL sessions, and executes tests.

The official [Cabal getting-started guide](https://cabal.readthedocs.io/en/stable/getting-started.html) is the primary reference for the workflow used here.

### Hackage

The central Haskell package archive. Use it to find package versions, dependency bounds, module documentation, and source distributions.

- [Hackage](https://hackage.haskell.org/)

### Hoogle

A search engine for Haskell APIs. It can search by function name or approximate type signature.

- [Hoogle](https://hoogle.haskell.org/)

For example, searching for a type such as:

```haskell
(a -> b) -> [a] -> [b]
```

can help discover `map` and related functions.

### Stack

An alternative project and build tool used by many existing repositories and tutorials. Install it when you need to work with a Stack project or when a chosen learning resource uses it.

For a first project, learning Cabal alone keeps the number of new concepts smaller.

## Cabal or Stack?

Use this practical rule:

- **Starting a new learning project:** begin with Cabal.
- **Joining an existing repository:** use the tool selected by that repository.
- **Following a course or book:** use the tool assumed by the material unless you are comfortable translating the setup.
- **Needing both installed:** let GHCup manage both.

This guide does not claim that Cabal is universally better. It chooses one default to reduce beginner decision fatigue.

## What to learn next

A productive early sequence is:

1. expressions, functions, and types;
2. algebraic data types and pattern matching;
3. lists, `Maybe`, and `Either`;
4. modules and package dependencies;
5. basic `IO`;
6. tests, including property-based tests;
7. one small complete application.

Do not treat advanced topics as entry requirements. Type families, effect-system comparisons, lenses, free monads, category-theory terminology, and elaborate abstraction libraries can be valuable later, but they are not necessary to write useful Haskell programs.

## Explore further

### Official starting material

- [Haskell.org: Get Started](https://www.haskell.org/get-started/) — official setup and first-program path.
- [GHCup first steps](https://www.haskell.org/ghcup/steps/) — GHC, GHCi, and a small Cabal project.
- [Cabal getting started](https://cabal.readthedocs.io/en/stable/getting-started.html) — project creation and dependency management.
- [HLS documentation](https://haskell-language-server.readthedocs.io/en/stable/) — editor tooling and troubleshooting.

### Broader learning resources

The project will review courses, books, exercises, and videos separately. Until that review is complete, inclusion in the legacy ecosystem map should be interpreted as discovery, not as a current recommendation.

See the existing [Tutorials](../README.md#tutorials), [Video Tutorials](../README.md#video-tutorials), and [Courses](../README.md#courses) sections for broader exploration.

## Common problems

### The editor reports a cradle or GHC-version error

First confirm that the project builds in a terminal:

```sh
cabal build
```

Then check which compiler the project uses and whether GHCup has a compatible HLS installation. Consult the HLS installation documentation rather than repeatedly reinstalling editor extensions.

### Cabal cannot build a dependency

Read the complete solver error. Common causes include:

- unsupported GHC or dependency versions;
- missing system libraries;
- stale package metadata;
- dependency bounds that do not overlap.

Start with:

```sh
cabal update
cabal build
```

Do not immediately add `--allow-newer` or edit version bounds without understanding which constraint is failing.

### A tutorial uses old commands

Haskell learning material can remain conceptually useful while its setup instructions age. Prefer current installation and project commands from official documentation, then adapt the tutorial's code.

### HLS works for one project but not another

Different projects may use different GHC versions or build configurations. HLS compatibility is project-specific; a globally installed editor extension does not remove that requirement.

## Recommendation record

| Decision | Recommendation | Important trade-off |
| --- | --- | --- |
| Toolchain manager | GHCup | Another layer to learn, but it reduces manual version management |
| Initial compiler selection | GHCup `recommended` | May not be the newest GHC release |
| First build tool | Cabal | Existing Stack projects still require Stack conventions |
| Beginner editor path | VS Code + Haskell extension | Not a claim that VS Code is the best editor for every user |
| Interactive exploration | `cabal repl` inside projects | Slightly slower startup than invoking bare `ghci` |

## Evidence used for this review

- [Haskell.org Get Started](https://www.haskell.org/get-started/)
- [GHCup installation documentation](https://www.haskell.org/ghcup/install/)
- [GHCup user guide](https://www.haskell.org/ghcup/guide/)
- [Cabal getting-started documentation](https://cabal.readthedocs.io/en/stable/getting-started.html)
- [Haskell Language Server installation documentation](https://haskell-language-server.readthedocs.io/en/stable/installation.html)

## Review notes

This guide deliberately avoids hard-coding a GHC version. GHCup's recommended version can change as compiler releases and ecosystem compatibility evolve. The guide should be reviewed when the official installation path, Cabal project workflow, or HLS distribution model changes.
