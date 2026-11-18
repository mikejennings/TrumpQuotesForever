# Quote updates

This addon loads its quote pool from shipped files. The daily GitHub Action
collects attributed text from public X/Twitter web pages, accessible news articles,
speech/interview/press transcripts and original Truth Social posts. It requires
no paid X API or running Mac. Other speakers, reposts and ambiguous attributions
are excluded. Public pages can be limited or unavailable; coverage is reported
and is not exhaustive. The older desktop research automation remains paused.

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

Changed main content is published exclusively on GitHub approximately every five
days, as a tested install ZIP, checksum and Forever addon-manager metadata. No
CurseForge upload or external token is required. There is no in-game download code.

`DailyQuotes.lua` and `DAILY_SOURCES.md` contain the newer entries; their editable
source ledger and maintenance tools live in the development repository. The full
research procedure is in `docs/DAILY_REVIEW.md` there. The addon catalog lists all
entries in load order. Apply starts the random Post quote prompt timer; its enabled state survives login/reload.

Distributed builds use generic author credits. Do not include personal account,
filesystem, screenshot or Git metadata when distributing a build.
