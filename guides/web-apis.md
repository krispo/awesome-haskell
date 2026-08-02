# Building web APIs in Haskell

> **Audience:** Haskell developers choosing an HTTP stack for a new service or web application  
> **Goal:** choose the right level of abstraction and understand the trade-offs before committing to a framework  
> **Last reviewed:** 2026-08-02  
> **Review scope:** Scotty, Servant, Yesod, IHP, and the WAI/Warp foundation

## Start with the application shape

There is no single best Haskell web framework. Start with the kind of application being built.

| Need | Starting point | Why |
| --- | --- | --- |
| Small JSON service, webhook receiver, prototype, or first Haskell API | **Scotty** | Direct routes, low ceremony, and a standard WAI application underneath |
| Contract-heavy API with many typed endpoints or shared client/server definitions | **Servant** | The API structure is represented at the type level and interpreted by tooling |
| Server-rendered application with forms, sessions, authentication, and database integration | **Yesod** | Cohesive full-stack framework with typed routes and an established application structure |
| Rapid full-stack product built around PostgreSQL, Nix, generated code, and integrated tooling | **IHP** | Opinionated framework and development environment designed as one platform |
| Middleware, gateways, framework internals, or a deliberately minimal HTTP layer | **WAI + Warp** | Direct control over the common Haskell web application interface |

The runnable example in this repository uses Scotty because it exposes HTTP concepts without requiring type-level API definitions or a full application platform. That is a teaching default, not a universal ranking.

## The shared foundation: WAI and Warp

**WAI** is the application interface used by much of the Haskell web ecosystem. A WAI `Application` receives a request and produces a response. Middleware can wrap it to provide logging, authentication, compression, request limits, metrics, or other cross-cutting behavior.

**Warp** is an HTTP server for WAI applications. Scotty and Yesod can produce WAI applications and commonly run them with Warp.

Use WAI directly when:

- building middleware or infrastructure rather than ordinary business routes;
- exact request and response control is important;
- combining several independently produced WAI applications;
- a framework abstraction would hide the behavior being implemented.

Trade-offs:

- routing, parameter decoding, errors, JSON conventions, and structure become project responsibilities;
- flexibility can turn into a locally invented framework;
- teams must establish conventions that a higher-level framework would otherwise supply.

Direct WAI is a foundation, not an automatic badge of performance or simplicity.

## Scotty: direct routes with low ceremony

Scotty is inspired by Sinatra and runs on WAI and Warp. Routes are written directly using HTTP verbs and path patterns.

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson (object, (.=))
import Data.Text (Text)
import Web.Scotty (get, json, pathParam, scotty)

main :: IO ()
main = scotty 3000 $ do
  get "/health" $
    json (object ["status" .= ("ok" :: Text)])

  get "/hello/:name" $ do
    name <- pathParam "name"
    json (object ["message" .= ("Hello, " <> (name :: Text) <> "!")])
```

Use Scotty when:

- the service has a small or medium number of straightforward routes;
- direct route readability matters more than a reusable type-level contract;
- the team wants to introduce Haskell HTTP development incrementally;
- the application mainly exposes JSON endpoints, webhooks, or small internal services;
- WAI middleware will provide cross-cutting concerns.

Trade-offs:

- endpoint contracts are not represented once and shared by server and client tooling;
- large route sets require deliberate module boundaries;
- request validation, domain errors, authentication policy, and API documentation need explicit design;
- concise handlers can accumulate business logic unless the project keeps them thin;
- development defaults must be reviewed before production deployment.

### Verified compiler compatibility

The repository example uses the released `scotty-0.30` package.

As reviewed on 2026-08-02:

- **GHC 9.12:** dependency resolution, build, and route tests are verified in CI;
- **GHC 9.14.1:** the released dependency graph does not resolve because Scotty requires `http-api-data < 0.7`, while the matching `http-api-data-0.6.3` declares `base < 4.22`; GHC 9.14.1 provides `base-4.22`.

The project intentionally does not use `allow-newer` to hide this mismatch. A bound override may happen to compile, but it would no longer demonstrate the officially declared package compatibility. This should be reviewed when Scotty or `http-api-data` releases change.

This limitation is evidence about the current released dependency graph, not proof that Scotty's route implementation is fundamentally incompatible with GHC 9.14.

## Servant: an API described by types

Servant represents an API with type-level combinators. The same description can drive server routing and, through additional packages, clients, documentation, links, or other interpretations.

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

import Servant

type API =
       "health" :> Get '[JSON] Health
  :<|> "hello" :> Capture "name" Text :> Get '[JSON] Greeting
```

Use Servant when:

- the API contract is a central design artifact;
- many endpoints must stay consistent;
- server and client definitions should share one description;
- typed captures, query parameters, request bodies, response types, and status codes remove meaningful ambiguity;
- the team accepts the cost of type-level API errors and abstractions.

Trade-offs:

- type-level APIs have a real learning and diagnostic cost;
- authentication, custom errors, streaming, and unusual protocol behavior can require advanced machinery;
- clients and documentation require additional packages whose compatibility must be reviewed;
- a large API type becomes difficult to navigate without named sub-APIs and modules;
- compile-time endpoint structure does not prove that business semantics are correct.

Choose Servant when contract reuse creates concrete value, not merely because it is “more typed.”

## Yesod: a cohesive full-stack framework

Yesod provides established approaches to typed routing, handlers, templates, forms, sessions, authentication, authorization, persistence, and deployment.

Use Yesod when:

- the product is a complete web application rather than only a small JSON service;
- server-rendered HTML, forms, sessions, and authentication are first-class requirements;
- typed routes should be used across templates and application code;
- the team values a cohesive framework architecture;
- the Yesod and Persistent ecosystem fits the project.

Trade-offs:

- Template Haskell, quasiquoters, generated routes, and framework-specific monads increase the conceptual surface;
- the application is more framework-shaped than a small WAI or Scotty service;
- adopting the whole stack may be excessive for an API-only service;
- teams may prefer Scotty's direct routes or Servant's explicit contract model.

## IHP: an integrated product platform

IHP combines a web framework with a managed Nix environment, PostgreSQL tooling, schema and code generation, routing, controllers, views, authentication, live reload, and deployment guidance.

Use IHP when:

- rapid development of a database-backed web product is the primary goal;
- PostgreSQL and Nix fit the team's operating model;
- integrated generators and conventions remove more work than they introduce;
- HTML applications and JSON endpoints are both required;
- a cohesive platform is preferred over assembling independent libraries.

Trade-offs:

- IHP is substantially more opinionated than a routing library;
- Nix, generated code, and IHP conventions become part of the development model;
- adopting one isolated component is less natural than adopting the platform;
- migration away from integrated conventions may cost more than migration from a small library stack.

Evaluate IHP as a platform decision, not as an interchangeable router.

## Choose by the dominant pressure

### Choose Scotty when clarity and iteration speed dominate

Typical cases:

- webhook receiver;
- internal JSON service;
- small public API;
- health or administration service;
- prototype whose domain logic already lives in ordinary Haskell modules.

### Choose Servant when contract reuse dominates

Typical cases:

- many endpoints with shared request and response types;
- generated internal clients;
- APIs maintained by several teams;
- services where endpoint changes should force dependent code to adapt;
- public APIs with carefully modeled content types and status codes.

### Choose Yesod or IHP when application features dominate

Typical cases:

- server-rendered products;
- authentication-heavy business applications;
- forms, sessions, user pages, and database-backed workflows;
- teams that benefit from framework conventions more than independent package choice.

### Choose WAI directly when infrastructure behavior dominates

Typical cases:

- middleware;
- gateways and protocol adapters;
- framework integration code;
- custom routing experiments;
- server infrastructure.

## Production concerns the framework does not remove

Every stack still needs explicit decisions about:

- configuration and secrets;
- structured logging and request identifiers;
- metrics and tracing;
- timeouts and request-size limits;
- graceful shutdown;
- authentication and authorization;
- CORS and trusted proxy headers;
- error response shape;
- database pooling and migrations;
- dependency and security updates;
- deployment, health checks, and rollback.

A framework may provide hooks or packages, but installing it does not define the policy.

## Keep handlers thin

Prefer this direction in every framework:

```text
HTTP request
    ↓
parse and validate transport data
    ↓
call a domain or application function
    ↓
translate the result into an HTTP response
```

Avoid combining database access, authorization rules, serialization, and domain transitions in one route handler. Thin boundaries make tests clearer and framework migration less important.

## Testing web applications

Test the generated WAI application directly before relying on process-level tests.

A useful stack includes:

- route tests issuing requests to a WAI `Application`;
- body, header, and status assertions;
- unit and property tests for domain logic;
- integration tests for real database behavior;
- a small number of process-level smoke tests when startup configuration matters.

The repository example uses `Network.Wai.Test`, allowing CI to exercise routes without opening a port.

## Runnable example

[`examples/web-api-scotty`](../examples/web-api-scotty) demonstrates:

- Scotty route definitions;
- JSON responses with Aeson;
- a health endpoint and path capture;
- conversion to a WAI `Application`;
- in-process route tests with Tasty and `Network.Wai.Test`;
- verified builds and tests on GHC 9.12.

Run it with:

```sh
cd examples/web-api-scotty
cabal test all --test-show-details=direct
cabal run web-api-scotty
```

Then, in another terminal:

```sh
curl http://localhost:3000/health
curl http://localhost:3000/hello/Ada
```

## Decision record

| Decision | Starting recommendation | Consider an alternative when |
| --- | --- | --- |
| First small JSON API | Scotty | Contract reuse, current compiler compatibility, or full-stack features dominate |
| Contract-heavy service | Servant | Direct route readability matters more than type-level interpretation |
| Full-stack server-rendered application | Yesod | The team wants IHP's integrated platform or a smaller library stack |
| Integrated PostgreSQL product platform | IHP | Nix, code generation, and strong conventions do not fit the team |
| HTTP foundation or middleware | WAI + Warp | Ordinary application routing would benefit from a framework |

## Explore the ecosystem

### Frameworks and API libraries

- [Scotty](https://hackage.haskell.org/package/scotty)
- [Servant documentation](https://docs.servant.dev/)
- [servant-server](https://hackage.haskell.org/package/servant-server)
- [Yesod](https://www.yesodweb.com/)
- [Yesod book](https://www.yesodweb.com/book)
- [IHP guide](https://ihp.digitallyinduced.com/Guide/)

### Foundation and middleware

- [WAI](https://hackage.haskell.org/package/wai)
- [Warp](https://hackage.haskell.org/package/warp)
- [wai-extra](https://hackage.haskell.org/package/wai-extra)

### Broader discovery

- [Hackage Web category](https://hackage.haskell.org/packages/#cat:Web)
- [Legacy Awesome Haskell Web section](../README.md#web)

## Evidence used for this review

- [Scotty package documentation](https://hackage.haskell.org/package/scotty)
- [Servant server package documentation](https://hackage.haskell.org/package/servant-server)
- [Servant tutorial](https://docs.servant.dev/en/stable/tutorial/index.html)
- [Yesod book](https://www.yesodweb.com/book)
- [yesod-core package documentation](https://hackage.haskell.org/package/yesod-core)
- [IHP guide](https://ihp.digitallyinduced.com/Guide/)
- [WAI package documentation](https://hackage.haskell.org/package/wai)
- [Warp package documentation](https://hackage.haskell.org/package/warp)
- [wai-extra package documentation](https://hackage.haskell.org/package/wai-extra)
- [Awesome Haskell example CI](https://github.com/krispo/awesome-haskell/actions)

## Review notes

This guide recommends frameworks only for defined application shapes. Review it when framework APIs, compiler compatibility, platform assumptions, or maintenance status change. Database-library choices belong in the separate database pilot rather than being inferred from the web framework alone.
