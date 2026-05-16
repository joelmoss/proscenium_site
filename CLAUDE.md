# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Rails 8 app on Ruby 4.0 that powers https://proscenium.rocks. Two responsibilities live in the same codebase:

1. **The marketing site / docs** (`PagesController`, root route).
2. **The Proscenium Registry** — an npm-compatible registry exposed on the `registry` subdomain that lets npm/yarn/pnpm/bun install assets from any published Ruby gem under the `@rubygems` scope (e.g. `npm install @rubygems/proscenium-ui`).

The registry is the substantive part of the codebase. Everything in `lib/registry/`, `app/models/registry/`, `app/controllers/{packages,tarballs}_controller.rb`, and `app/models/registry/package.rb` is registry code.

## Commands

```sh
bin/setup                       # install gems + prepare DB
bin/dev                         # boot the dev server (puma, port 3000 by default)

bin/rails test                  # full suite
bin/rails test test/path/to/file.rb            # single file
bin/rails test test/path/to/file.rb:42         # single test (by line)

bin/rubocop                     # lint
bin/rubocop -A                  # autocorrect (incl. unsafe)
bin/brakeman --no-pager         # security scan
```

CI (`.github/workflows/ci.yml`) runs `brakeman`, `rubocop`, `bin/rails test`, then deploys to Hatchbox on every push to `master` via `hatchboxio/github-hatchbox-deploy-action@v2` (requires `HATCHBOX_DEPLOY_KEY` repo secret).

## Local hosts

Dev uses `.localhost` (not `.test`):

- `proscenium.localhost` — site
- `registry.proscenium.localhost` — registry subdomain

Both are whitelisted in `config/environments/development.rb`. When pointing local npm/bun clients at the registry, use **`http://`** — the dev server doesn't terminate TLS, and clients hit `UNABLE_TO_GET_ISSUER_CERT_LOCALLY` against `https://`.

## Registry architecture

The metadata flow for a request like `GET /@rubygems/<gem>/<version>` (on the registry subdomain):

1. `PackagesController#show` parses the package path and calls `Registry::Package.finreate!(name, version)`.
2. `finreate!` always hits `Gems::V2.info(name, version)` (or `Gems.info(name)` for latest) **even on a cache hit**. This is intentional — it's how the registry honors RubyGems yanks. If the upstream version is gone, the cached row is destroyed via `after_destroy_commit :delete_tarball` (which also deletes the R2 object), and `RecordNotFound` propagates to a 404.
3. On a cache miss, `before_create :fetch_package_json, :create_tarball` runs. `Registry::RubyGems.path_for` downloads + unpacks the gem to read `package.json`; `Registry::CreateTarball` builds a `.tgz` containing just `package/package.json` and uploads it to R2.
4. `Package#as_json(tarball_host: request.base_url)` returns the npm payload; `dist.tarball` points at the Rails `/tarballs/<name>/<version>.tgz` endpoint, **not** the R2 URL directly.

The tarball download flow:

1. `TarballsController#show` strips `.tgz`, calls `finreate!` again (re-verifies + yanks if needed), then 302-redirects to a 5-minute pre-signed R2 URL minted by `Registry::SignTarball`.
2. The R2 bucket is **private**. Direct R2 URLs do not work; every download is gated by the Rails re-verify.

Why the DB is still there: it caches `shasum`, `integrity`, the extracted `package.json` payload, and the "we've already uploaded this tarball" fact. Dropping it would mean replacing each cache hit with R2 round-trips (HEAD + sidecar JSON).

## `Registry::Package.finreate!`

Not a typo — it's "find or create" compressed. The entry point for both controllers; everything else hangs off it. Re-read it before changing cache behavior.

## R2 collaborators (`lib/registry/`)

Three classes wrap Cloudflare R2 via `Aws::S3::Client`. They each read credentials from `Rails.application.credentials.cloudflare_r2.{access_key_id,secret_access_key,account_id,bucket_name}` (bang accessors — will raise if missing). All three skip the actual R2 network call when `Rails.env.test?`:

- `CreateTarball` — uploads the built tarball; gated by `upload! if !Rails.env.test?`.
- `DeleteTarball` — `return if Rails.env.test?` then `delete_object`.
- `SignTarball` — returns a deterministic `https://signed.test/<key>` URL in test, real pre-signed URL otherwise.

If you add a fourth R2-touching class, follow the same test-env gate — there's no Mocha in this repo and Minitest 6 dropped `Object#stub`, so test-env gates are how R2 is "mocked."

## Test environment quirks

- **Stubbing**: WebMock for HTTP. No Mocha. Minitest is `6.0.6` and **does not provide `Object#stub` or `Minitest::Mock`** (they were removed). Don't `require 'minitest/mock'` — it doesn't exist. For collaborators that need to be inert in tests, use the `Rails.env.test?` gate pattern instead of mocking.
- **Sandbox**: any test that creates a new `Registry::Package` row triggers a real gem download to `~/.gem/...` via `Gem::RemoteFetcher`. Under restrictive sandboxes this fails with `is not writable`. Run those tests with the sandbox disabled.
- **Fixture**: `test/fixtures/registry/packages.yml` has one row (`rails7`). Its `tarball` column stores just the R2 key (e.g. `rails/rails-7.0.0.tgz`), not a URL.

## Style rules worth remembering

From `.rubocop.yml`:

- `TargetRubyVersion: 4.0` and `StringLiteralsFrozenByDefault: true` — every file needs `# frozen_string_literal: true`.
- `Style/DisableSyntax` forbids `unless`, `and`/`or`/`not`, and numbered block parameters. Use `if !x`, `&&`/`||`/`!`, and named block params.
- Line length 100.
- `Metrics` cop is disabled — don't worry about method/class size.

## What lives on the Cloudflare side

The R2 bucket must be private (public access disabled, no `r2.dev` subdomain, no public custom domain). Code assumes this — if the bucket becomes public, the security model collapses but nothing in Rails will tell you.
