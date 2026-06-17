# AGENTS.md

Maintenance notes for this Homebrew tap. End-user usage lives in `README.md`;
keep that file user-facing.

## Layout

- `Formula/*.rb` — formulae (CLI tools)
- `Casks/*.rb` — casks (GUI apps)
- `projects.yaml` — single source of truth for the auto-bump
- `scripts/bump.rb` — the bump engine
- `.github/workflows/bump.yml` — runs the engine

Tap name is `listenai/tap` (the `homebrew-` prefix is implicit). Users install
with `brew install listenai/tap/<name>` or `brew install --cask listenai/tap/<name>`.

## Auto-bump

The managed `.rb` files are never hand-edited for releases. `projects.yaml`
lists each managed project; `scripts/bump.rb` reads it, fetches each upstream's
latest GitHub release, takes the sha256 straight from the release asset digests
(no download), rewrites `version` + `sha256` in the matching `.rb`, and commits
per project when something changed.

Dependencies: `ruby`, `gh` (authenticated via `GH_TOKEN`), `git` — all
preinstalled on macOS, Homebrew environments, and GitHub runners. No jq/perl/yq.

Run locally:

```sh
scripts/bump.rb            # all projects
scripts/bump.rb cskburn    # just one
```

### Types

`projects.yaml` `type:` selects the handler in `bump.rb`:

- `formula` — one universal asset; `version`, the `…/download/vX/…` URL segment,
  and the lone `sha256 "…"` line are rewritten.
- `formula-arch` — per-arch CLI. The URL interpolates `#{version}` (so it
  self-updates); only the `version` line and the two `sha256` lines are
  rewritten, each anchored on its arch's asset token in the URL above it.
- `cask` — per-arch GUI app; `version` and the `arm:`/`intel:` sha256 lines are
  rewritten, the URL uses `#{version}`/`#{arch}`.

`assets` values match release asset names by suffix (`end_with?`); pick a suffix
long enough to be unambiguous (e.g. `-x86_64.dmg`, not `.dmg`).

### Triggers

Same engine, three entry points in `bump.yml`:

- `schedule` — daily safety net; needs no secrets anywhere.
- `workflow_dispatch` — run by hand from the Actions tab.
- `repository_dispatch` (`event_type: bump`) — fired by an upstream repo right
  after it releases, e.g.:

  ```sh
  gh api repos/LISTENAI/homebrew-tap/dispatches \
    -f event_type=bump -f 'client_payload[project]=cskburn'
  ```

Auth model: the **commit** is always made by this repo's own `GITHUB_TOKEN` — no
personal access token is stored here. Only the optional `repository_dispatch`
trigger needs a token with `actions:write` on this repo, and it lives in the
upstream that fires it. The `schedule` path needs nothing, so relying on cron
alone is fully secret-free.

## Adding a project

1. Write its `Formula/<name>.rb` (CLI) or `Casks/<name>.rb` (GUI app) once.
2. Add one entry to `projects.yaml` with the matching `type` (above).

`README.md` stays generic on purpose — don't list individual packages there.
`bump.rb` and the workflow need no changes for a new project of an existing type.
A new asset **shape** (e.g. a universal-binary cask, or per-arch Linux assets)
needs a new `type` handler in `bump.rb`.

## Not auto-bumped

- **`*-toolchain`** — pinned Nuclei cross toolchains from
  `LISTENAI/riscv-gnu-toolchain`. Their tags (`listenai/nuclei-2025.02/r1`) and
  versions (`2025.02-r1`) don't follow `vX.Y.Z`, and toolchains are deliberately
  pinned, so these stay out of `projects.yaml` and are bumped by hand.

## Validate

```sh
brew style Formula/*.rb Casks/*.rb
brew audit --tap listenai/tap
ruby -c scripts/bump.rb
```

To dry-run the bump without touching this repo, copy it to a scratch dir, run
`git init`, then run `scripts/bump.rb` there.
