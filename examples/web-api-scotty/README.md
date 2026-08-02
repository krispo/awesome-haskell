# Scotty web API example

A deliberately small JSON service demonstrating a low-ceremony Haskell HTTP stack:

- Scotty for routes and responses;
- Aeson for JSON values;
- WAI as the testable application boundary;
- Warp, used by Scotty, as the HTTP server;
- Tasty and `Network.Wai.Test` for in-process route tests.

The example keeps route definitions separate from the executable entry point. Tests build the same WAI application as the server without opening a network port.

## Build

From this directory:

```sh
cabal build all
```

## Test

```sh
cabal test all --test-show-details=direct
```

The tests cover:

- `GET /health`;
- a captured path parameter at `GET /hello/:name`;
- an unknown route returning `404`.

## Run

```sh
cabal run web-api-scotty
```

The server listens on port `3000`.

In another terminal:

```sh
curl http://localhost:3000/health
curl http://localhost:3000/hello/Ada
```

Expected responses:

```json
{"status":"ok"}
```

```json
{"message":"Hello, Ada!"}
```

## What this example demonstrates

1. Route declarations can remain small and readable.
2. JSON responses do not require a template layer.
3. A Scotty application can be converted into a standard WAI `Application`.
4. Route tests can run in process without coordinating ports or server startup.
5. HTTP handlers should remain transport boundaries rather than containers for domain logic.

## What it deliberately omits

This is not a production template. It does not yet include:

- configuration or environment parsing;
- structured logging;
- authentication or authorization;
- database access;
- a stable error-response type;
- request-size limits and timeouts;
- metrics or tracing;
- graceful shutdown configuration;
- container or deployment files.

Those concerns should be added deliberately for a real service rather than hidden in a teaching example.

## Next exercises

- validate a query parameter and return a structured `400` response;
- move greeting construction into a pure domain module;
- add request logging as WAI middleware;
- add a POST endpoint with `jsonData`;
- define a consistent API error type;
- compare the same API expressed with Servant.
