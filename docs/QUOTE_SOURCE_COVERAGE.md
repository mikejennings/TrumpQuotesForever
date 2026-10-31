# Daily quote-source coverage

The daily GitHub Action now checks multiple sources, not only Truth Social.
No paid X API, AI API, login credentials, browser-session export or bypass is used.

## Sources

- **Public X/Twitter profile:** fetch the public realDonaldTrump web page and
  parse visible post article markup. Match the author and original status URL,
  derive creation time from its Snowflake ID and exclude reposts, nested quoted
  posts, stale posts and truncated Show more text. Inspect at most 30 visible
  posts; a live check exposed five. X's guest view is limited and may change or
  become inaccessible. This is not an exhaustive authenticated timeline.
- **News:** Guardian's Trump feed and PBS NewsHour's politics feed discover
  recent articles. Read at most ten relevant article bodies per publisher per
  run. Accept direct quoted text only with an adjacent explicit Trump attribution.
  Skip headlines, scripts, opinion/live-blog titles, ambiguous pronouns, named
  relatives, speculative attribution and obvious retrospective years. Other
  speakers' comments are not assigned to Trump. Article publication is recorded
  as the source date; it is not represented as a verified utterance date.
- **Speeches, interviews and press gaggles:** discover recent pages through
  Roll Call's public Factba.se transcript sitemap. Read at most 24 recent unused
  pages per run. Extract only turns explicitly labeled Donald Trump; skip
  reporters, other guests, metadata and script payloads.
- **X posts embedded in news:** require an official-account embed footer and an
  original realDonaldTrump status link. Exclude old Snowflake dates and retain
  the article as attribution evidence. The normal per-source budget still applies.
- **Truth Social:** retain the original archive RSS collector and its exclusions
  for reposts, quote-posts, removed entries and generated media text.

All sources look back seven days. A source match is not independent verification
of a recording/account or of the truth of a claim. The automatic attribution
rules are deliberately conservative and can miss genuine quotes. Coverage is
bounded and does not mean every news outlet, post or spoken remark was collected.

## Selection, safeguards and reporting

Distinctive insults and unusual claims rank ahead of routine praise. A source
may yield several candidate alternatives, but **only one excerpt of at most 25
words is accepted per source/evidence page**. Existing source budgets, exact and
near-duplicate checks and the 255-byte chat limit remain enforced. Sources take
turns filling at most ten new additions per run, so the Truth feed cannot fill
every slot. A final full-ledger validation runs before any write.

`news_report` is a provenance kind for an explicitly attributed news quotation;
it does not claim the article is an original full transcript. All automated
entries remain `unverified-claim`, with context explaining how text was matched.

Each run writes `dist/quote-source-coverage.json` and a GitHub run summary with
sources checked, readable article/post/transcript counts, candidate counts and
failures. An inaccessible page is not counted as an article checked with no
quotes. Public-X failures and publisher errors appear as coverage gaps; all
sources failing causes the collector to fail. No source is bypassed when blocked.

Quote-only automatic acceptance, anonymous packaging and five-day GitHub plus
CurseForge publication remain as documented in SCHEDULED_UPDATES.md. Code changes
and edits to existing quotes still cannot pass the quote-only merge gate.

## Source references

- Public X profile: https://x.com/realDonaldTrump
- Guardian feed: https://www.theguardian.com/us-news/donaldtrump/rss
- PBS RSS documentation: https://www.pbs.org/newshour/about/pbs-news-rss-feeds
- PBS politics feed: https://www.pbs.org/newshour/feeds/rss/politics
- Roll Call sitemap, linked from its public sitemap index:
  https://rollcall.com/factbase-trump-transcripts-1-sitemap.xml
- Truth archive feed documentation: https://www.trumpstruth.org/faq
