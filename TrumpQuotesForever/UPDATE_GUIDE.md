# Quote updates

This addon loads its quote pool from the files shipped with it. Newer quotes
are prepared by a daily research automation outside the game and proposed in
GitHub draft pull requests. The automation needs its host Mac and Codex available;
it is not a GitHub-hosted daily collector. It checks a seven-day window to catch
missed runs and delayed transcripts. Coverage is not guaranteed to be exhaustive.

Each proposal records the original source, attribution evidence, date, and
context. Source matching means the excerpt appears as Trump's words in the
recorded source; it does not establish that accusations or claims are true.
Researchers must check speaker identity and surrounding context. Duplicate,
source-budget, chat-length, date, and package checks are automated.

Open a draft pull request to review proposed quotes. Its **Validate and package
review build** Actions run contains a test ZIP and checksum, retained for 30 days.
Review ZIPs contain `REVIEW_ONLY.txt` and must not be presented as approved releases.
Human review and merge are required before proposals become part of the main pool.
Merging does not automatically publish a GitHub Release or upload to CurseForge.
A separate, manually confirmed GitHub Action can publish an approved main version
as an install ZIP with a checksum and Forever addon-manager metadata.
There is no CurseForge integration and no in-game download code.

`DailyQuotes.lua` and `DAILY_SOURCES.md` contain the newer entries; their editable
source ledger and maintenance tools live in the development repository. The full
research procedure is in `docs/DAILY_REVIEW.md` there. The addon catalog lists all
entries in load order. The posting timer still starts off after login/reload.

Distributed builds use generic author credits. Do not include personal account,
filesystem, screenshot or Git metadata when distributing a build.
