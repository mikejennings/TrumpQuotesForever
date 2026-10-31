# GitHub quote collection and five-day releases

Two scheduled GitHub Actions run independently of the desktop app. Neither merges
quote proposals, publishes a release, or uploads anything to CurseForge.

## Daily collection

`Collect daily quote proposals` runs at 14:23 UTC daily (9:23 AM Chicago during
daylight time, 8:23 AM during standard time), and can be dispatched manually.
It fetches up to 500 archive RSS items from the preceding seven days, selecting
at most ten new original-post sentences per run. It skips reposts, quote-posts,
removed entries, other authors, links, quoted text, generated image/video material,
unfinished/oversized sentences, boilerplate endorsements and duplicates. A small
keyword list favors distinctive remarks but does not guarantee relevance or full
coverage. The archive's attribution and text are not independent authentication.
Every proposal is conservatively labeled `unverified-claim` until human review.

Proposals accumulate on `automation/feed-quotes` in one draft PR. Tests and review
ZIP packaging run inside the collecting workflow itself, so they do not depend on
whether GitHub starts a separate bot-created PR check. Existing reviewer edits are
preserved, pushes are never forced, and conflicts fail for manual attention. If a
feed PR is closed without merging, collection stops rather than re-proposing
rejected sources. A maintainer must resolve/reset that review queue deliberately.
An unavailable/invalid/empty feed fails the run; it is not reported as no news.
No raw full posts, credentials, personal maintainer identity or remote text-as-code
are written into the addon.

This collector covers account text only. It does not search news or authenticate
live speeches and reporter exchanges. Those still use the source-checking process
in DAILY_REVIEW.md. The older desktop automation is paused and stays paused unless
the user requests resuming it. It is not required for these GitHub schedules.

GitHub must allow Actions to create pull requests. The workflows request only the
repository-scoped permissions they need; no personal access token or paid API key
is needed. They contain no approval or merge operation. A bot-created PR may still
need a maintainer to approve separate PR-triggered workflows in GitHub's UI.

## Five-day release preparation

`Prepare five-day release draft` checks daily at 15:43 UTC. It prepares a draft
only after **at least 120 hours since the latest published stable release**, and
only if the addon or quote ledger on main differs from that release. A pending
draft blocks additional drafts. No updates means no empty release. Daily GitHub
schedules can be delayed; this is approximately every five days, not a guaranteed
wall-clock publication interval. Cron `*/5` in the day-of-month field would reset
at month boundaries, so this workflow uses actual elapsed time instead.

The job starts from reviewed main, never a pending quote PR. It increments the
last published patch version (or retains a higher main TOC version), regenerates
matching labels, runs Python/Lua/LuaJIT checks and builds the anonymous install ZIP,
SHA-256 checksum and Forever `release.json`. Its version-only source commit is
saved on `automation/release-vX.Y.Z`, and the draft targets that exact commit.
Main is not changed. Existing branches, tags, drafts and published assets are
never overwritten; a partial creation failure requires manual inspection.

Review and publish the draft in GitHub Releases when ready. Publishing sets the
next five-day clock. The source version branch remains available and can later be
merged back deliberately; future drafts choose their version from the latest
published release even if main's TOC is older. The existing manual release Action
remains available for versions already on main, but must not be used to overwrite
a tag reserved by a pending draft.

Sources: [archive RSS documentation](https://www.trumpstruth.org/faq),
[GitHub schedule behavior](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#schedule),
[workflow token behavior](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow).
