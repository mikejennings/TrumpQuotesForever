# CurseForge readiness assessment

Checked October 28, 2026 against the current main pool of 1,013 quotes and the
v0.8.0 install package. This document is research and preparation, not a claim of
moderator approval. No project has been submitted, account created, license
applied, upload token installed, or CurseForge publishing enabled.

## Recommendation

Do not submit the current unfiltered, unattended-public-chat edition as-is.
Prepare a curated edition whose random timer offers a local reminder/preview and
whose channel message requires the user's deliberate send action. Preserve the
current GitHub addon until the user chooses a product change. This is my risk
assessment, not a finding that every current feature or flagged quote violates a
rule. The technical package is ready; content and user-facing behavior need work.

There is no WoW-specific blanket prohibition on Trump material established by the
sources reviewed. Other games have additional rules, which must not be imported
as if they applied to WoW. CurseForge currently hosts a
[Trump voice pack](https://www.curseforge.com/wow/addons/miniauras-trump-voice-pack)
and a [Forever copypasta addon](https://www.curseforge.com/wow/addons/chinese-copypasta/files/9047396).
These are examples of published projects, not approval precedents, legal opinions,
or evidence that our exact quote collection and timer would be accepted.

## Requirements and current result

| Item | Current result | Recommended action |
| --- | --- | --- |
| Install ZIP | Pass: one `TrumpQuotesForever` root, matching TOC, valid archive and checksum | Reuse the package layout |
| Forever compatibility | TOC 16001 and release metadata flavor `forever`; simulator checks passed | Confirm against the actual installed Forever build and test in game |
| Attribution/privacy | TQ Maintainers credit; inspected ZIP has no owner's name or personal paths/email | Use a separate public pseudonym/profile; do not link the private personal repo from the listing |
| Code visibility/free access | ZIP contains plain Lua and no paid feature gate | Keep the public distribution free and inspectable; a public GitHub repo is not required just to expose the packaged code |
| Quote content | A conservative keyword screen flags 42 entries for contextual review | Curate the shipped pool and manually review the rest; no automatic removals |
| Public-chat behavior | Current optional random timer attempts channel sends without user confirmation | For the proposed public edition, make the timer local and require an explicit send action |
| Project listing | Not created | Chat & Communication category; clear English summary and description |
| Icon | Missing | Original 400×400 PNG, no copied portrait, platform logo, or NSFW imagery |
| License | No LICENSE file or explicit code license is present | Recommend MIT for our code only, with a separate third-party quote/source notice; not applied here |
| Upload automation | GitHub publishing only | Keep it that way until the project/build is approved for submission |

[CurseForge's submission guide](https://support.curseforge.com/support/solutions/articles/9000197241-creating-and-submitting-a-project)
requires the listing fields, license selection, actual ZIP, game version selection,
and moderator review. Its [known-issues guidance](https://support.curseforge.com/support/solutions/articles/9000196615)
requires the WoW package's root folder to match its TOC name.

## The material concerns

Blizzard's [UI Add-On Development Policy](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534)
requires free, visible code, prohibits offensive/objectionable content, and bars
negative impact on players, including excessive chat use. A sourced real quote
can still be objectionable when shipped in an addon. Source attribution and an
entertainment disclaimer do not override those rules. Keeping the timer off at
login and imposing a cooldown are useful safeguards, but do not establish that
unattended public-channel posting complies or works on a live client.

CurseForge's [general moderation policies](https://support.curseforge.com/support/solutions/articles/9000197279-moderation-policies)
also require compliance with the game's rules and prohibit content used to harass,
discriminate, or negatively affect players. They impose content, image and
third-party-rights requirements. Do not claim the current collection is approved,
free of policy concerns, or permitted simply because it is satire.

A relevant comparison is
[xeR's Forever Chat Scheduler](https://www.curseforge.com/wow/addons/xers-forever-chat-scheduler),
whose listing describes a user-confirmed public-channel fallback. Its
[0.3.2 file notes](https://www.curseforge.com/wow/addons/xers-forever-chat-scheduler/files/9012192)
document removal of unsupported background sending. This supports manual sending
as a practical design direction, but is not an authoritative API guarantee or
proof of how our code behaves inside the live client.

## Quote-screen results

The complete index is [CURSEFORGE_CONTENT_REVIEW.csv](CURSEFORGE_CONTENT_REVIEW.csv).
It references catalog entry numbers and existing source ledgers rather than
reproducing the excerpts. Flags are screening aids, not decisions about violations.

| Screening category | Flagged entries |
| --- | ---: |
| Explicit/vulgar terms or possible sexual context | 7 |
| Violence/threat-related words | 7 |
| Identity or mental-health insult language | 22 |
| Appearance/dehumanizing insult language | 8 |
| Distinct entries flagged across categories | 42 |

Some entries have multiple flags. Known false positives include entry 81's water
pressure/shower discussion, entry 217's jobs metaphor, entry 300's shooting idiom,
entry 304's use of fat to describe a lie, and entry 574's financial idiom. Entry
34 needs its actual anecdote context, not just its shower keyword. Entry 10's
reference to dogs is an allegation about immigrants, not a direct animal-name
insult. These examples show why automatic filtering is not a compliance review.

The other 971 entries are **unflagged, not cleared**. Broad personal attacks,
unsubstantiated accusations, context-dependent language, and material not covered
by the patterns need human review too. Obvious first-pass candidates to exclude
from a public curated edition include entries 31–35 and 59, but the final selection
is a product/editorial decision, not an automatic outcome of this assessment.

A default-off explicit-content toggle would not resolve a rule against including
objectionable material in the addon. A genuinely curated ZIP must also exclude
removed excerpts from its catalogs, JSON ledgers, source notes, and unused Lua
files. Our current packager ships those documents, so filtering only the active
Lua table is insufficient. Do not assume the 25-word research limit itself grants
redistribution rights: [the Copyright Office](https://www.copyright.gov/fair-use/)
describes a contextual, multi-factor fair-use inquiry. Attribution is not a
substitute for permissions where required. The
[MIT license](https://opensource.org/license/mit) proposed for our own code must
not purport to relicense third-party quotes or archive text.

## Proposed public edition

Keep quote selection local until a user chooses to share. Keep Preview and
Prepare quote, channel selection, anonymous credits, source notes, and daily
GitHub review. Change random Start/Stop into local reminder controls for the
public edition. Let the user inspect the message and explicitly send through
the chat editor; no claim that background General/Trade posting is guaranteed.
Do not silently modify the current GitHub release or submit a different product
under misleading listing copy.

Use the draft in [CURSEFORGE_LISTING_DRAFT.md](CURSEFORGE_LISTING_DRAFT.md) only
after its stated prerequisites are implemented and verified. A simple original
speech-bubble/quotation-mark icon is a suitable art direction. A settings-window
screenshot is useful evidence; check it for account, character and desktop
identifiers before including it. Keep the author profile and support contact
pseudonymous. The platform still knows its account/SSO information.

## Submission and future automation

After the curated build, real-client checks, license/rights review, icon and
listing are ready, create the WoW project and tag the supported Forever version.
Use an alpha/beta while testing; a normal Release file is needed for standard
app availability. Both project/file approval remain CurseForge decisions.
No defensible approval probability or moderation ETA can be inferred here.

If the user later authorizes automated uploads, a separate manual GitHub Action
can upload the reviewed ZIP to the assigned project ID with a CurseForge upload
API token stored as a GitHub secret. The [official upload API](https://support.curseforge.com/support/solutions/articles/9000197321-curseforge-api)
accepts a file, changelog, release type, supported version IDs and an option to
hold an approved upload for manual release. Resolve game-version IDs from the
API instead of hard-coding guessed IDs; keep the token out of URLs/logs and use
the documented header. Do not give the daily research automation publishing
permission. No new workflow or secret is created by this assessment.

## What this assessment did not do

It did not contact CurseForge or Blizzard, accept terms, create an account, upload
files, change permissions, make the repo public, enable chat sending, remove any
quotes, change existing addon behavior, choose a binding license, or create a
new release. The current GitHub edition is unchanged.
