# AGENTS.md

This file provides guidance to coding agents when working with code in this repository.

## What this is

Rails 8 app on Ruby 4.0 that powers https://proscenium.rocks: the marketing site and docs (`PagesController`, root route).

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

Dev uses `proscenium.localhost` (not `.test`), whitelisted in `config/environments/development.rb`.

## Test environment quirks

- No Mocha. Minitest is `6.0.6` and **does not provide `Object#stub` or `Minitest::Mock`** (they were removed). Don't `require 'minitest/mock'` — it doesn't exist.

## Style rules worth remembering

From `.rubocop.yml`:

- `TargetRubyVersion: 4.0` and `StringLiteralsFrozenByDefault: true` — every file needs `# frozen_string_literal: true`.
- `Style/DisableSyntax` forbids `unless`, `and`/`or`/`not`, and numbered block parameters. Use `if !x`, `&&`/`||`/`!`, and named block params.
- Line length 100.
- `Metrics` cop is disabled — don't worry about method/class size.
