# Quote updates

This addon loads its quote pool from shipped files. A daily GitHub Action checks
original account-post text through an archive RSS feed and proposes short excerpts
in a draft PR. Reposts, quote-posts and generated media text are skipped. It needs
neither a paid API key nor a running Mac. Live speeches and reporter exchanges
still need separate source review; coverage is not exhaustive. The older desktop
research automation is currently paused.

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
A scheduled Action prepares an unpublished release draft after at least five days
since the last published stable release, if approved main content changed and no
draft is waiting. It includes an install ZIP, checksum and Forever addon-manager
metadata; a maintainer reviews and publishes it manually. A separate manually
confirmed release Action also remains available for versions already on main.
There is no CurseForge integration and no in-game download code.

`DailyQuotes.lua` and `DAILY_SOURCES.md` contain the newer entries; their editable
source ledger and maintenance tools live in the development repository. The full
research procedure is in `docs/DAILY_REVIEW.md` there. The addon catalog lists all
entries in load order. The posting timer still starts off after login/reload.

Distributed builds use generic author credits. Do not include personal account,
filesystem, screenshot or Git metadata when distributing a build.
