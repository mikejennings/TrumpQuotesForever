# Automatic quote updates and five-day publication

The maintainer authorized automatic acceptance of quote additions and publication
to GitHub and CurseForge. Earlier requirements for per-quote/per-release human
approval are superseded for this pipeline. Code changes remain outside automatic
quote acceptance. The repository remains private and credits stay TQ Maintainers.

## Daily collection and acceptance

`Collect and accept quote additions` runs daily at 14:23 UTC (9:23 AM Chicago in
daylight time, 8:23 AM in standard time). It collects attributed quotes from public X web pages, Guardian/PBS news,
Roll Call speeches, interviews and press gaggles, plus the Truth archive. See
QUOTE_SOURCE_COVERAGE.md for exact sources, limits and matching rules. No paid X
API is used. At most ten new excerpts are accepted per run, with one excerpt per
source/evidence page. Coverage failures and readable-source counts are recorded
in the run summary and quote-source-coverage.json. Source matching does not prove
an allegation true; the broader desktop research automation remains paused.

The bot uses one PR on `automation/feed-quotes` as an audit trail. Before merging,
it validates provenance/schema, duplicates, source budget, dates and chat length;
runs Python, Lua and LuaJIT tests; builds an anonymous review ZIP; and verifies an
append-only ledger plus byte-exact generated outputs reconstructed from main.
Existing entries cannot change. Edits to runtime code, workflows, documentation
beyond generated quote counts, or other files prevent automatic acceptance.
The tested head must still match and main must not have changed during testing.
No force-push or automatic acceptance of conflicts is used. Separate PR-triggered
checks may require GitHub approval; the collector runs the required checks itself
before merging so it does not depend on those extra runs. Review ZIPs remain for
30 days. A rejected/closed-without-merge feed PR stops the queue for attention.

## Five-day publication

`Publish five-day releases` checks daily at 15:43 UTC. It releases only after at
least 120 hours since the latest published stable release, only when addon/ledger
content on main changed, and when no earlier draft is pending. GitHub schedules
may be delayed; this is approximately every five days. No changes means no empty
release. Cron day-of-month `*/5` is deliberately not used because it resets at
month boundaries.

A version-only branch `automation/release-vX.Y.Z` records the patch-version bump
and matching generated labels from main. Main itself is not version-bumped by the
release job. The job tests and builds the install ZIP, checksum and Forever
release.json, creates a temporary GitHub draft, and uploads that exact ZIP to
CurseForge project 1771665 as a normal Release. It resolves Forever 1.60.1 to a
unique actual game-version ID and sets isMarkedForManualRelease=false. GitHub is
published only after the upload API returns a file ID and a matching upload
receipt is attached. CurseForge publication remains subject to its moderation.

The initial v0.8.0 CurseForge file is still Under Review. It has been changed from
Beta to Release; approval and availability are not claimed. Its original manual
hold is separate from the automatic-release flag used for future uploads.

## Required secret and failure handling

Add `CF_API_TOKEN` as a repository Actions secret, using an upload token belonging
to the pseudonymous CurseForge author with access to this project. Token settings:
https://authors.curseforge.com/#/settings/api-tokens . Do not paste tokens in chat,
commit them, use them in URLs, or print them. The API credential is sent only in
X-Api-Token to the fixed upload endpoint; redirects are refused. Missing access
fails before creating a scheduled release. No new release is claimed without a
successful response. The repository's Actions create/approve-PR toggle is enabled
because GitHub uses one toggle for creation too; default token permissions stay
read-only and the bot never submits a PR approval review.

`Publish release to CurseForge` can also be dispatched on main with an existing
numeric release tag, or runs for human-published GitHub releases. The manual
release Action uses the same upload-before-publication path. There is no in-game
updater; players update through a supported addon manager or install the ZIP.

An upload-started marker is attached before the POST; a matching receipt prevents
duplicate uploads on reruns. If upload status is ambiguous, automation stops for
inspection rather than retrying blindly. A receipt allows the manual uploader to
resume GitHub publication without another CurseForge upload. A pending draft
blocks new releases; resolve that failure rather than deleting/overwriting assets.
Existing branches, tags and assets are never overwritten.

Sources: [archive feed documentation](https://www.trumpstruth.org/faq),
[GitHub scheduling](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#schedule),
[CurseForge upload API](https://support.curseforge.com/support/solutions/articles/9000197321-curseforge-api).
