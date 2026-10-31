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

Daily account-post additions are automatically accepted after source/schema,
duplicate, chat-length, date, privacy, Python/Lua/LuaJIT, append-only and exact
generated-output checks. The PR is an audit trail. Existing quote edits and code
changes are not automatically accepted. Test ZIPs contain REVIEW_ONLY.txt and are
retained for 30 days; release ZIPs do not contain that marker.

Changed main content is published approximately every five days. The same tested
ZIP goes to GitHub and CurseForge, with automatic CurseForge publication after
moderator approval. Uploads require a configured repository secret; the initial
CurseForge project remains under review. There is no in-game download code.

`DailyQuotes.lua` and `DAILY_SOURCES.md` contain the newer entries; their editable
source ledger and maintenance tools live in the development repository. The full
research procedure is in `docs/DAILY_REVIEW.md` there. The addon catalog lists all
entries in load order. The posting timer still starts off after login/reload.

Distributed builds use generic author credits. Do not include personal account,
filesystem, screenshot or Git metadata when distributing a build.
