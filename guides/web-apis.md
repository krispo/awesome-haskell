# Building web APIs in Haskell

> **Audience:** Haskell developers choosing an HTTP stack for a new service or web application  
> **Goal:** choose an appropriate level of abstraction and understand the trade-offs before committing to a framework  
> **Last reviewed:** 2026-08-02  
> **Review scope:** Scotty, Servant, Yesod, IHP, and the WAI/Warp foundation; database libraries and deployment platforms are covered only where they affect the framework choice

## Start with the shape of the application

There is no single best Haskell web framework. The useful first question is not “Which framework is most popular?” but “What kind of application are we building?”

| Need | Starting point | Why |
| --- | --- | --- |
| A small JSON service, webhook receiver, prototype, or first Haskell API | **Scotty** | Direct routing model, low ceremony, standard WAI application underneath |
| A contract-heavy API with many typed endpoints or shared client/server definitions | **Servant** | API structure is represented at the type level and interpreted by server/client tooling |
| A server-rendered application with routing, forms, sessions, authentication, and database integration | **Yesod** | Cohesive full-stack framework with typed routes and established application structure |
| A rapid full-stack product built around PostgreSQL, Nix, generated code, and integrated tooling | **IHP** | Opinionated development environment and framework designed as one platform |
| Custom middleware, framework internals, gateways, or a deliberately minimal HTTP layer | **WAI + Warp** | Maximum control over the common Haskell web application interface |

The default runnable example in this repository uses **Scotty** because it exposes the HTTP concepts clearly without requiring type-level API definitions or a full application platform. That is a teaching default, not a recommendation to replace Servant, Yesod, or IHP in their stronger use cases.

## The shared foundation: WAI and Warp

**WAI** is the common application interface used by much of the Haskell web ecosystem. A WAI `Application` receives a request and produces a response. Middleware can wrap an application to provide logging, authentication, compression, request limits, metrics, or other cross-cutting behavior.

**Warp** is a production-oriented HTTP server for WAI applications. Frameworks such as Scotty and Yesod commonly produce WAI applications and run them with Warp.

This shared layer matters because choosing a framework does not necessarily isolate a project from the rest of the ecosystem. WAI middleware and WAI testing tools can often be reused across frameworks.

Use WAI directly when:

- building middleware or infrastructure rather than ordinary business routes;
- exact control over request and response handling is important;
- integrating several independently produced WAI applications;
- framework abstractions would hide the behavior being implemented.

Trade-offs:

- routing, parameter decoding, error conventions, JSON handling, and application structure become the project's responsibility;
- low-level flexibility can turn into locally invented framework code;
- teams must establish conventions that a higher-level framework would otherwise provide.

Direct WAI is a foundation, not an automatic badge of performance or simplicity.

## Scotty: direct routes with low ceremony

Scotty is inspired by Sinatra and runs on WAI and Warp. Routes are written directly using HTTP verbs and path patterns.

A small API can look like:

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
- route behavior is easier to read directly than through a type-level contract;
- the team wants to introduce Haskell HTTP development incrementally;
- the application mainly exposes JSON endpoints, webhooks, health checks, or small internal services;
- WAI middleware will provide cross-cutting concerns.

Trade-offs:

- endpoint contracts are not represented once as a type-level API shared by servers and clients;
- large route files require deliberate module structure and conventions;
- request validation, domain errors, authentication policy, and API documentation need explicit design;
- the concise routing style can encourage handlers to accumulate business logic;
- default development settings should be reviewed before production deployment.

Scotty is small, but production responsibility is not small. Keep handlers thin, move domain logic into ordinary modules, define a consistent error format, and test the generated WAI application without binding a real port.

## Servant: an API described by types

Servant represents an API using type-level combinators. The same API description can drive server routing and, through ecosystem packages, clients, documentation, links, or other interpretations.

A simplified API type looks like:

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
- typed captures, query parameters, request bodies, response types, and status codes reduce meaningful ambiguity;
- the team is comfortable diagnosing type errors involving API combinators.

Trade-offs:

- type-level APIs have a real learning and error-message cost;
- authentication, versioning, custom errors, streaming, and unusual protocol behavior can require advanced combinators or context machinery;
- generated clients and documentation depend on additional packages whose compatibility must be reviewed;
- a large API type can become difficult to navigate without named sub-APIs and module boundaries;
- representing something in the type does not guarantee that the business semantics are correct.

Do not choose Servant merely to make an API “more typed.” Choose it when a reusable, inspectable endpoint contract provides concrete value.

## Yesod: a cohesive full-stack framework

Yesod is designed for type-safe, RESTful web applications and includes established approaches to routing, handlers, templates, forms, sessions, authentication, authorization, persistence, and deployment.

Use Yesod when:

- the product is a complete web application rather than only a small JSON service;
- server-rendered HTML, forms, sessions, and authentication are first-class requirements;
- typed routes should be used throughout templates and application code;
- the team values a cohesive application architecture;
- the existing Yesod and Persistent ecosystem fits the domain.

Trade-offs:

- Template Haskell, quasiquoters, generated routes, and Yesod-specific monads increase the conceptual surface;
- the application structure is more framework-shaped than a small WAI or Scotty service;
- using only a narrow subset of the framework may not justify adopting the whole stack;
- teams building API-only services may prefer the smaller mental model of Scotty or the explicit contract model of Servant.

Yesod remains relevant for full applications even when it is not the default recommendation for a minimal JSON API.

## IHP: an integrated product-development platform

IHP combines a Haskell web framework with a managed Nix development environment, PostgreSQL tooling, schema and code generation, routing, controllers, views, authentication, live reload, deployment guidance, and other product-oriented features.

Use IHP when:

- rapid development of a database-backed web product is the primary goal;
- the team accepts PostgreSQL and Nix as central parts of the development model;
- integrated generators, conventions, live reload, and framework tooling reduce more work than they introduce;
- HTML applications and JSON APIs are both required;
- a cohesive platform is preferred over assembling independent libraries.

Trade-offs:

- IHP is substantially more opinionated than a library-oriented stack;
- Nix, generated code, framework conventions, and the IHP development server become part of the team's operating model;
- adopting only one isolated component is less natural than adopting the platform;
- migration away from integrated framework conventions may cost more than migration from a small routing library.

IHP should be evaluated as a platform decision, not as another interchangeable routing package.

## Framework choice by pressure

### Choose Scotty when clarity and iteration speed dominate

Typical examples:

- webhook receiver;
- internal JSON service;
- small public API;
- health and administration service;
- prototype whose domain logic already lives in ordinary Haskell modules.

### Choose Servant when contract reuse dominates

Typical examples:

- many endpoints with shared request and response types;
- generated internal clients;
- APIs maintained by multiple teams;
- services where endpoint changes should cause compile-time work in dependent code;
- a public API with carefully modeled status codes and content types.

### Choose Yesod or IHP when application features dominate

Typical examples:

- server-rendered product;
- authentication-heavy business application;
- forms, sessions, user-facing pages, and database-backed workflows;
- a team that benefits from framework conventions more than from independent package choice.

### Choose WAI directly when infrastructure behavior dominates

Typical examples:

- middleware;
- reverse proxy or gateway components;
- protocol adapters;
- custom routing experiments;
- framework or server integration code.

## Production concerns the framework does not remove

Every stack still needs explicit decisions about:

- configuration and secrets;
- structured logging and request identifiers;
- metrics and tracing;
- timeouts and request-size limits;
- graceful shutdown;
- authentication and authorization;
- CORS and proxy headers;
- error response shape;
- database pool sizing and migrations;
- dependency updates and security review;
- deployment, health checks, and rollback.

A framework may provide hooks or packages for these concerns, but installing a framework does not settle the policy.

## Keep handlers thin

Regardless of framework, prefer this direction:

```text
HTTP request
    ↓
parse and validate transport data
    ↓
call domain/application function
    ↓
translate domain result into HTTP response
```

Avoid placing database queries, authorization rules, serialization details, and domain transitions in one route handler. Thin boundaries make framework migration less important and tests more focused.

## Testing web applications

Prefer testing the generated WAI application directly before relying on process-level tests.

A useful test stack includes:

- route tests that issue requests to a WAI `Application`;
- JSON body and status assertions;
- unit and property tests for pure domain logic;
- integration tests for real database behavior;
- a small number of process-level smoke tests when startup configuration matters.

The repository example uses `Network.Wai.Test` from `wai-extra`, so CI can exercise routes without opening a network port.

## Runnable example

[`examples/web-api-scotty`](../examples/web-api-scotty) demonstrates:

- a small Scotty route definition;
- JSON responses with Aeson;
- a health endpoint and path capture;
- conversion to a WAI `Application`;
- in-process route tests with Tasty and `Network.Wai.Test`;
- CI builds and tests on GHC 9.12 and 9.14.

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
| First small JSON API | Scotty | Contract reuse or full-stack features dominate |
| Contract-heavy service | Servant | Direct route readability is more valuable than type-level interpretation |
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

## Review notes

This guide intentionally recommends frameworks only for defined application shapes. It should be reviewed when framework APIs, compiler compatibility, platform assumptions, or maintenance status change. Database-library choices will be handled in the separate database pilot rather than being inferred from the web framework alone.
