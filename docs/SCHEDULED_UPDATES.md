# Daily quote updates and GitHub releases

The maintainer authorized automatic acceptance of tested quote-only additions and
public GitHub releases. As of November 18, 2026, GitHub is the sole publishing
destination. CurseForge uploads and the approval-follow-up automation are retired.
Credits remain TQ Maintainers; GitHub account ownership is publicly visible.

## Daily collection

`Collect and accept quote additions` runs daily at 14:23 UTC (08:23 Chicago during
standard time, 09:23 during daylight time), and can be run manually. It checks
public X pages, Guardian/PBS news, Roll Call transcripts and the Truth archive.
No paid X API is used. Public X pages may be inaccessible; every run records actual
coverage and warnings in its summary and `quote-source-coverage.json` artifact.
Source matching establishes attribution in the source, not truth of allegations.
See QUOTE_SOURCE_COVERAGE.md for source and extraction limits.

At most ten new excerpts are added per run, one per evidence/source page. The bot
uses `automation/feed-quotes` and a PR audit trail. Before merging it validates
provenance, dates, duplicates, source budgets and chat length; runs Python, Lua
and LuaJIT tests; builds a review ZIP; and reconstructs generated outputs from
trusted main. Existing quotes cannot change and code edits cannot auto-merge.
Both the tested head and main base must still match at merge time. A rejected
proposal or conflicting branch stops for attention. Review artifacts last 30 days.
The same renderer updates QUOTES.txt in the repo whenever quotes are accepted.

## Five-day GitHub publication

`Publish five-day releases` checks daily at 15:43 UTC and publishes changed content
after at least 120 hours since the latest stable release. GitHub schedules can be
delayed. No changes means no empty release; a pending draft blocks new releases.

A version-only `automation/release-vX.Y.Z` branch records the patch bump and
matching generated labels. Main stays on its development version. The workflow
runs Python/Lua/LuaJIT tests and packages an install ZIP, SHA-256 checksum and
Forever `release.json`. It creates a GitHub draft, downloads and verifies its
actual assets, checks the archive layout/version/interface/privacy and metadata,
then publishes it. Existing tags and assets are never overwritten. A failed
verification leaves the draft for inspection rather than publishing bad assets.

`Publish WoW Forever addon` is the optional explicit manual release path; its
version input must match main's TOC and must use an unused tag. Both workflows use
GitHub's short-lived workflow token. No external publishing token, paid AI API or
running desktop is required. There is no CurseForge upload or in-game updater.
Users download the install ZIP from GitHub Releases or a compatible addon manager.

Workflow permissions default to read-only, with write permissions limited to
quote acceptance and release jobs. Untrusted PR validation has no write token or
publication access. No `pull_request_target` execution is used.
