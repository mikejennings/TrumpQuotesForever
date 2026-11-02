# Quote content review — November 1, 2026

This is a contingency assessment of the quote database, not a moderator decision,
legal opinion, new fact-check, or instruction to remove entries. All quotes and
addon behavior remain unchanged. The clarification ticket remains the current
response to the rejection; no additional message was sent for this analysis.

## Findings

I read all **1,034 current quote texts** in catalog order, using the repository's
recorded context where relevant. The strongest content concerns are concentrated
in explicit sexual/anatomical remarks, identity-related ridicule, degrading
personal attacks, violent imagery, and serious allegations about identifiable
people. Ordinary political criticism, boasts and odd phrasing do not all carry
that same concern. Political subject matter alone is not treated as a violation.

| Review priority | Entries | Meaning |
| --- | ---: | --- |
| Examine first | 48 | A specific strong content/context concern is explained below |
| Contextual review | 902 | Political/person/media commentary, insults, allegations or incomplete excerpts; this is **not** a count of violations |
| Lower specific concern | 84 | No specific strong concern identified in this bounded reading; **not cleared or approved** |

**46 of the 48 first-priority entries were already in the submitted v0.8.0 ZIP.**
Entries **1017 and 1032** were added later and cannot explain the initial
rejection. The submitted ZIP has 1,013 quotes; current main has 21 later additions.
The list of 48 is a non-exhaustive editorial shortlist, not an objective boundary
between acceptable and prohibited speech.

The [full CSV](CURSEFORGE_QUOTE_RISK_REVIEW.csv) contains all 1,034 exact texts,
entry numbers, SHA-256 text fingerprints, priority, reasons, source references,
and whether each was in the submitted ZIP. Search/sort tags are supplementary
keyword hints, not the basis for a compliance verdict.

## Practical priorities

| Topic | Examples by catalog entry | Assessment |
| --- | --- | --- |
| Sexual/anatomical remarks | 31, 32, 34–36 | Strongest candidates for an objectionable/adult-content concern. Entry 35 is explicit sexual grabbing; entry 34's shower anecdote needs its sexual source context. Entry 36 is less explicit alone but follows the grabbing remark. |
| Group-directed content | 10, 166, 196, 506, 573–576, 595, 623–625, 635, 765, 807, 909 | Pet-eating allegation, religion/border framing, and ancestry-based nickname ridicule need contextual review. These are not all equivalent statements, and an identity word alone is not a violation. |
| Degrading personal attacks | 101, 167, 179, 202, 234, 921, 1017, 1032 | Reporter/body/appearance insults or sexuality-related personal attacks can read as harassment when delivered randomly. A public-figure target does not settle the moderation question. |
| Violence and intimidation | 37, 159, 1013 | Shooting hypothetical, threat of personal disclosure, and electric-chair rhetoric. Do not mislabel these as direct instructions or threats without context. |
| Grave allegations | 320, 557, 698, 870, 923, 927, 975, 980, 981, 989, 999, 1003, 1013 | Specific accusations/insinuations of wrongdoing need source and context checks. The report makes no finding of truth, falsity, defamation or criminal liability. |
| Health and mental-health context | 27, 28, 338, 667, 982 | Internal disinfectant/light speculation and mental-health attacks merit careful review. Other health claims remain contextual; this is not medical advice or a medical assessment. |

The rows above are **examples**, not category totals; some example ranges include
contextual-priority entries and categories overlap. Every first-priority entry's
specific rationale is included individually below.

## Rules this could implicate

Blizzard's [UI Add-On Development Policy](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534)
prohibits offensive/objectionable material under rule 6, ties content to the game's
age ratings, and prohibits negative impact on other players, including excessive
chat use, under rule 3. Its free/readable-code requirements do not resolve content.

CurseForge's [Moderation Policies](https://support.curseforge.com/support/solutions/articles/9000197279-moderation-policies)
require adherence to game rules, prohibit discrimination and harassment/negative
impact, and allow rejection of inappropriate/adult content. They also impose
third-party-rights requirements. These broad rules leave judgment to moderators;
this report does not establish which rule they applied to any quote.

The project's actual rejection additionally alleges derivation from an unnamed
All Rights Reserved project. This content review cannot resolve that claim.
Having a source URL, being a president's exact words, or limiting an excerpt to
25 words does not itself establish platform permission or redistribution rights.

## Why context matters in this addon

Each posted message contains the excerpt and a Donald Trump attribution, but no
source date, surrounding question, correction or allegation label. The source
ledgers and catalog disclaimers are not delivered alongside that random chat
message. Thus a sourced quotation can lose essential context in use.

The optional timer starts off after login/reload, defaults to 10–20 minutes,
allows a one-minute minimum, has a 60-second cooldown, skips AFK/instances, and
stops on detected client blocking. These safeguards reduce some problems; they
are not approval or immunity from chat/content rules. Manual posting also remains
subject to the same content rules.

The existing daily collector checks attribution/structure, duplicates, source
budgets and byte limits; **it does not perform this contextual moderation review**.
Future additions can introduce new concerns. The five-day release and auto-accept
configuration were not changed by this analysis.

## Coverage and limits

- Full text reading covers the 1,034 quoted strings in the current snapshot.
- Every row maps to a recorded source reference. The original external source
  pages were **not individually reopened** for this review. Where context is
  discussed, it comes from the existing source ledgers and the wording read here.
- Facts, authenticity beyond the existing checks, permissions/copyright, and
  current policies of every relevant jurisdiction were **not independently
  adjudicated**. The CSV explicitly marks those limits for every row.
- No live-game behavior test, full ownership/similarity audit, or prediction of
  account enforcement is made here. CurseForge has not identified specific quotes.
- The older CURSEFORGE_CONTENT_REVIEW.csv is a historical keyword screen. Its
  42 flags are not comparable to these 48 editorial priorities and do not establish
  that everything else passed.
- Examples of misleading keyword hits: entry 81 concerns shower water pressure;
  217 concerns jobs; 300 uses a shooting idiom; 304 says a fat lie; 574 uses a
  financial killing idiom (it is prioritized here for its ethnic nickname, not
  violence); 732 describes a music-video gun scenario. Bare keyword matches must
  not be presented as verified offenses.

## Snapshot and use

Reviewed repository head: `02a647f60cb99f0b18b769681531a1609c8f23e4`.
Catalog SHA-256: `2bf28365d2b4f04051695901f693c448fb76105f61603b674392ec05a135c541`.
The CSV text fingerprints let future reviews identify the same wording even if
catalog numbering changes. New or changed strings require fresh review.

For now, retain this as internal preparation and await ticket 402898's specific
feedback. If the user later authorizes an alternative distribution, discuss the
identified excerpts and exact proposed behavior before making changes. Nothing
in this report authorizes editing the live pool, changing the upload, or sending
support another message. Moving excerpts only out of active Lua would still leave
them in bundled source/catalog documents; any future distribution decision must
account for the complete ZIP.

## Entries to examine first

These are review priorities, not established policy violations or removal decisions.

### Entry 10 — in submitted v0.8.0

> In Springfield, they're eating the dogs.

Pet-eating allegation about immigrants in the documented debate context; source notes identify the claim as baseless. A random chat excerpt loses that correction.

[Recorded source](https://politifact.com/factchecks/2024/sep/11/donald-trump/trump-repeats-baseless-claims-that-haitian-immigra/) · TrumpQuotesForever/QUOTE_SOURCES.md

### Entry 27 — in submitted v0.8.0

> And then I see the disinfectant, where it knocks it out in a minute. One minute. And is there a way we can do something like that, by injection inside or almost a cleaning.

Disinfectant-injection/internal-light speculation can be unsafe or misleading when stripped of questioning/context; flagged for context review, not presented here as medical advice.

[Recorded source](https://trumpwhitehouse.archives.gov/briefings-statements/remarks-president-trump-vice-president-pence-members-coronavirus-task-force-press-briefing-31/) · TrumpQuotesForever/QUOTE_SOURCES.md

### Entry 28 — in submitted v0.8.0

> And then I said, supposing you brought the light inside the body, which you can do either through the skin or in some other way, and I think you said you're going to test that too.

Disinfectant-injection/internal-light speculation can be unsafe or misleading when stripped of questioning/context; flagged for context review, not presented here as medical advice.

[Recorded source](https://trumpwhitehouse.archives.gov/briefings-statements/remarks-president-trump-vice-president-pence-members-coronavirus-task-force-press-briefing-31/) · TrumpQuotesForever/QUOTE_SOURCES.md

### Entry 31 — in submitted v0.8.0

> His ass is -- it's like a pile of muscle.

Anatomy-focused comments about a named person; avoid treating the word ass alone as the entire context.

[Recorded source](https://transcripts.cnn.com/show/arena/date/2026-10-24/segment/01) · TrumpQuotesForever/QUOTE_SOURCES.md

### Entry 32 — in submitted v0.8.0

> I looked at his ass, and I've never done that with a man before.

Anatomy-focused comments about a named person; avoid treating the word ass alone as the entire context.

[Recorded source](https://transcripts.cnn.com/show/ctw/date/2026-10-26/segment/02) · TrumpQuotesForever/QUOTE_SOURCES.md

### Entry 34 — in submitted v0.8.0

> when he took showers with the other pros, they came out there, they said, 'Oh my God, that's unbelievable.'

Shower anecdote implies genital size; the quoted text alone obscures the sexual context documented in the source notes.

[Recorded source](https://www.presidency.ucsb.edu/documents/remarks-campaign-rally-latrobe-pennsylvania) · TrumpQuotesForever/QUOTE_SOURCES.md

### Entry 35 — in submitted v0.8.0

> Grab them by the pussy. You can do anything.

Explicit sexual grabbing remark and adjacent celebrity/permission claim; review both the full recording and the standalone excerpt.

[Recorded source](https://rollcall.com/factbase/trump/transcript/donald-trump-interview-access-hollywood-september-13-2005/) · TrumpQuotesForever/QUOTE_SOURCES.md

### Entry 36 — in submitted v0.8.0

> And when you're a star, they let you do it.

Explicit sexual grabbing remark and adjacent celebrity/permission claim; review both the full recording and the standalone excerpt.

[Recorded source](https://rollcall.com/factbase/trump/transcript/donald-trump-interview-access-hollywood-september-13-2005/) · TrumpQuotesForever/QUOTE_SOURCES.md

### Entry 37 — in submitted v0.8.0

> I could stand in the middle of Fifth Avenue and shoot somebody, and I wouldn't lose any voters.

Hypothetical shooting of a person; the voter-loyalty boast is not a direct instruction, but the graphic violence still merits review.

[Recorded source](https://time.com/4197798/verbatim-18/) · TrumpQuotesForever/QUOTE_SOURCES.md

### Entry 101 — in submitted v0.8.0

> Quiet. Quiet, piggy.

Degrading, animalizing, face/body or fitness attack; strong harassment/objectionable-content concern when randomly delivered without the original exchange.

[Recorded source](https://www.govinfo.gov/content/pkg/DCPD-202501124/pdf/DCPD-202501124.pdf) · TrumpQuotesForever/QUOTE_SOURCES.md

### Entry 159 — in submitted v0.8.0

> Be careful, Lyin' Ted, or I will spill the beans on your wife!

Threat to reveal material about an opponent's wife; standalone public-chat reproduction can read as intimidation.

[Recorded source](https://twitter.com/realDonaldTrump/status/712457104515317764) · TrumpQuotesForever/INSULT_SOURCES.json

### Entry 166 — in submitted v0.8.0

> Pocahontas bombed last night!

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/757919034755076096) · TrumpQuotesForever/INSULT_SOURCES.json

### Entry 167 — in submitted v0.8.0

> Great, now I can go after Horseface and her 3rd rate lawyer in the Great State of Texas.

Degrading, animalizing, face/body or fitness attack; strong harassment/objectionable-content concern when randomly delivered without the original exchange.

[Recorded source](https://twitter.com/realDonaldTrump/status/1052213711295930368) · TrumpQuotesForever/INSULT_SOURCES.json

### Entry 179 — in submitted v0.8.0

> Look at that face. Would anyone vote for that?

Degrading, animalizing, face/body or fitness attack; strong harassment/objectionable-content concern when randomly delivered without the original exchange.

[Recorded source](https://fortune.com/2015/09/10/trump-on-fiorina-look-at-that-face-would-anyone-vote-for-that/) · TrumpQuotesForever/INSULT_SOURCES.json

### Entry 196 — in submitted v0.8.0

> Pocahontas

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/757919034755076096) · TrumpQuotesForever/INSULT_SOURCES.json

### Entry 202 — in submitted v0.8.0

> I feel sorry for Rosie 's new partner in love whose parents are devastated at the thought of their daughter being with @Rosie--a true loser.

Attacks a woman through her same-sex relationship and alleged family distress; sexuality-related context needs specific review.

[Recorded source](https://twitter.com/realDonaldTrump/status/146994336670822400) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 234 — in submitted v0.8.0

> .@BetteMidler talks about my hair but I'm not allowed to talk about her ugly face or body --- so I won't.

Degrading, animalizing, face/body or fitness attack; strong harassment/objectionable-content concern when randomly delivered without the original exchange.

[Recorded source](https://twitter.com/realDonaldTrump/status/262583859709882369) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 320 — in submitted v0.8.0

> Obama never consulted with Congress about a prisoner exchange. HE BROKE THE LAW AND SHOULD BE TRIED. OUR PRESIDENT IS A TOTAL DISASTER!

Specific criminal, fraudulent, bribery, treason or foreign-payment allegation about identifiable people; greater context/reputation concern than a generic political nickname. No legal or fact-check verdict is made.

[Recorded source](https://twitter.com/realDonaldTrump/status/474138053075038209) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 338 — in submitted v0.8.0

> Sorry, @Rosie is a mentally sick woman, a bully, a dummy and, above all, a loser.

Uses an alleged mental-health condition or need for observation to demean a named person; assess stigma and objectionable-content concerns.

[Recorded source](https://twitter.com/realDonaldTrump/status/542135034984284160) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 506 — in submitted v0.8.0

> Incompetent Hillary, despite the horrible attack in Brussels today, wants borders to be weak and open-and let the Muslims flow in.

Associates terrorism/border weakness with letting Muslims enter; a broad religious-group framing may be read as discriminatory in chat.

[Recorded source](https://twitter.com/realDonaldTrump/status/712473816614772736) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 557 — in submitted v0.8.0

> Paul Begala, the dopey @CNN flunky and head of the Pro-Hillary Clinton Super PAC, has knowingly committed fraud in his first ad against me.

Specific criminal, fraudulent, bribery, treason or foreign-payment allegation about identifiable people; greater context/reputation concern than a generic political nickname. No legal or fact-check verdict is made.

[Recorded source](https://twitter.com/realDonaldTrump/status/732788306237345794) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 573 — in submitted v0.8.0

> @elizabethforma Goofy Elizabeth Warren, sometimes referred to as Pocahontas because she faked the fact she is native American, is a lowlife!

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/735344013499326465) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 574 — in submitted v0.8.0

> @elizabethforma Goofy Elizabeth Warren, sometimes known as Pocahontas, bought foreclosed housing and made a quick killing.

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name. Keyword caution: shower/jobs-killed/shoot-straight/fat-lie/quick-killing/music-video references must not be treated as literal sexual or violent content without context.

[Recorded source](https://twitter.com/realDonaldTrump/status/735444721716199424) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 576 — in submitted v0.8.0

> I find it offensive that Goofy Elizabeth Warren, sometimes referred to as Pocahontas, pretended to be Native American to get in Harvard.

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/735942401165033477) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 595 — in submitted v0.8.0

> Goofy Elizabeth Warren, sometimes referred to as Pocahontas, pretended to be a Native American in order to advance her career.

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/741774067368402945) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 623 — in submitted v0.8.0

> I hope that Crooked Hillary picks Goofy Elizabeth Warren, sometimes referred to as Pocahontas, as her V.P. Then we can litigate her fraud!

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/754650547932758016) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 625 — in submitted v0.8.0

> Pocahontas wanted V.P. slot so badly but wasn't chosen because she has done nothing in the Senate.

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/756801575193042944) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 635 — in submitted v0.8.0

> Elizabeth Warren, often referred to as Pocahontas, just misrepresented me and spoke glowingly about Crooked Hillary, who she always hated!

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/757775689525309440) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 667 — in submitted v0.8.0

> Just heard that crazy and very dumb @morningmika had a mental breakdown while talking about me on the low ratings @Morning_Joe.

Uses an alleged mental-health condition or need for observation to demean a named person; assess stigma and objectionable-content concerns.

[Recorded source](https://twitter.com/realDonaldTrump/status/771686352438042624) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 684 — in submitted v0.8.0

> Did Crooked Hillary help disgusting (check out sex tape and past) Alicia M become a U.S. citizen so she could use her in the debate?

Calls attention to an alleged sex tape while attacking a named woman; sexual humiliation and allegation need careful review.

[Recorded source](https://twitter.com/realDonaldTrump/status/781788223055994880) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 698 — in submitted v0.8.0

> Crooked Hillary colluded w/FBI and DOJ and media is covering up to protect her.

Specific criminal, fraudulent, bribery, treason or foreign-payment allegation about identifiable people; greater context/reputation concern than a generic political nickname. No legal or fact-check verdict is made.

[Recorded source](https://twitter.com/realDonaldTrump/status/788123233442824192) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 765 — in submitted v0.8.0

> Pocahontas just stated that the Democrats, lead by the legendary Crooked Hillary Clinton, rigged the Primaries!

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/926417546038923264) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 807 — in submitted v0.8.0

> Thank you to the Cherokee Nation for revealing that Elizabeth Warren, sometimes referred to as Pocahontas, is a complete and total Fraud!

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/1052173526919196672) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 870 — in submitted v0.8.0

> Schiff is a corrupt politician and a criminal!

Specific criminal, fraudulent, bribery, treason or foreign-payment allegation about identifiable people; greater context/reputation concern than a generic political nickname. No legal or fact-check verdict is made.

[Recorded source](https://twitter.com/realDonaldTrump/status/1203809537653956611) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 909 — in submitted v0.8.0

> Pocahontas, working in conjunction with the Democrat Party, totally destroyed the campaign of Bernie Sanders.

Uses Pocahontas as a derisive nickname tied to Native American ancestry; review as identity-based ridicule rather than treating it as an ordinary name.

[Recorded source](https://twitter.com/realDonaldTrump/status/1237603152490147850) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 921 — in submitted v0.8.0

> I don't know what Kellyanne did to her deranged loser of a husband, Moonface, but it must have been really bad.

Degrading, animalizing, face/body or fitness attack; strong harassment/objectionable-content concern when randomly delivered without the original exchange.

[Recorded source](https://twitter.com/realDonaldTrump/status/1257532112233803782) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 923 — in submitted v0.8.0

> When will they open a Cold Case on the Psycho Joe Scarborough matter in Florida.

Scarborough cold-case/walking-the-streets insinuation can imply grave wrongdoing; requires underlying context and evidence review, not repetition as established fact.

[Recorded source](https://twitter.com/realDonaldTrump/status/1260161295019630592) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 927 — in submitted v0.8.0

> @FoxNews And guys like Low Ratings Psycho Joe Scarborough are allowed to walk the streets?

Scarborough cold-case/walking-the-streets insinuation can imply grave wrongdoing; requires underlying context and evidence review, not repetition as established fact.

[Recorded source](https://twitter.com/realDonaldTrump/status/1263081823812366338) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 975 — in submitted v0.8.0

> Wow, nobody realized how far Mini Mike Bloomberg went in bribing ex-prisoners to go out and vote for Sleepy Joe.

Specific criminal, fraudulent, bribery, treason or foreign-payment allegation about identifiable people; greater context/reputation concern than a generic political nickname. No legal or fact-check verdict is made.

[Recorded source](https://twitter.com/realDonaldTrump/status/1310217371307606024) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 980 — in submitted v0.8.0

> BIDEN, OBAMA AND CROOKED HILLARY LED THIS TREASONOUS PLOT!!!

Specific criminal, fraudulent, bribery, treason or foreign-payment allegation about identifiable people; greater context/reputation concern than a generic political nickname. No legal or fact-check verdict is made.

[Recorded source](https://twitter.com/realDonaldTrump/status/1313903112399261697) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 981 — in submitted v0.8.0

> Obama, Biden, Crooked Hillary and many others got caught in a Treasonous Act of Spying and Government Overthrow, a Criminal Act.

Specific criminal, fraudulent, bribery, treason or foreign-payment allegation about identifiable people; greater context/reputation concern than a generic political nickname. No legal or fact-check verdict is made.

[Recorded source](https://twitter.com/realDonaldTrump/status/1313996348694433792) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 982 — in submitted v0.8.0

> Crazy Nancy is the one who should be under observation.

Uses an alleged mental-health condition or need for observation to demean a named person; assess stigma and objectionable-content concerns.

[Recorded source](https://twitter.com/realDonaldTrump/status/1314287202935992320) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 989 — in submitted v0.8.0

> Joe Biden is a corrupt politician -- and the Biden family is a criminal enterprise.

Specific criminal, fraudulent, bribery, treason or foreign-payment allegation about identifiable people; greater context/reputation concern than a generic political nickname. No legal or fact-check verdict is made.

[Recorded source](https://twitter.com/realDonaldTrump/status/1317652898910674945) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 999 — in submitted v0.8.0

> Joe Biden is a corrupt politician--the Biden family is looking more & more like a crime family.

Specific criminal, fraudulent, bribery, treason or foreign-payment allegation about identifiable people; greater context/reputation concern than a generic political nickname. No legal or fact-check verdict is made.

[Recorded source](https://twitter.com/realDonaldTrump/status/1322254453156712448) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 1003 — in submitted v0.8.0

> Joe Biden is a corrupt politician who is bought and paid for by China!

Specific criminal, fraudulent, bribery, treason or foreign-payment allegation about identifiable people; greater context/reputation concern than a generic political nickname. No legal or fact-check verdict is made.

[Recorded source](https://twitter.com/realDonaldTrump/status/1323116444201164802) · TrumpQuotesForever/ARCHIVE_SOURCES.json

### Entry 1013 — in submitted v0.8.0

> Can you imagine if a Republican stole money like Governor Tim Walz stole from Minnesota? They’d give you the electric chair!

Accuses a named governor of theft; the ledger explicitly marks the claim unverified. Attribution is not a finding that the allegation is true. Invokes the electric chair as hypothetical punishment; distinguish violent rhetoric from a direct threat or instruction.

[Recorded source](https://truthsocial.com/@realDonaldTrump/117520691710779974) · data/daily_quotes.json#truth-117520691710779974

### Entry 1017 — added after submission

> You've been following me for two weeks. I feel perfect. You are disgusting. Put yourself in shape. You look like hell,

Degrading, animalizing, face/body or fitness attack; strong harassment/objectionable-content concern when randomly delivered without the original exchange. Added after the submitted v0.8.0 ZIP; cannot explain that ZIP's initial rejection.

[Recorded source](https://www.pbs.org/newshour/politics/watch-trump-calls-reporter-disgusting-when-questioned-about-not-traveling-to-kansas) · data/daily_quotes.json#public-a203ce215dfd84c29aef

### Entry 1032 — added after submission

> He's way out of shape.

Degrading, animalizing, face/body or fitness attack; strong harassment/objectionable-content concern when randomly delivered without the original exchange. Added after the submitted v0.8.0 ZIP; cannot explain that ZIP's initial rejection.

[Recorded source](https://rollcall.com/factbase/trump/transcript/donald-trump-press-gaggle-after-air-force-one-arrival-october-29-2026/) · data/daily_quotes.json#public-5afc5a572cf0b715e195
