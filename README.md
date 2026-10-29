# Trump Quotes Forever — 0.8.0

Targets **WoW: Forever 1.60.1, Interface 16001**, not Retail or Classic Era.
No libraries required. 1,013 sourced Trump quotes and nickname fragments, selected randomly without
immediate repeats. The optional timer waits a random 10–20 minutes between attempts.

## GitHub download and manual releases

The **Publish WoW Forever addon** Action creates a GitHub Release containing an
install-ready `TrumpQuotesForever-VERSION.zip`, its SHA-256 checksum, and
`release.json` identifying the package as the **Forever** flavor (Interface 16001).
Download that ZIP from the release Assets. GitHub's automatic source ZIP/tar.gz
archives are development snapshots, not the install package.

The repository remains private: GitHub downloads and addon managers need access
to it, or you can share the install ZIP directly. Forever metadata does not make
an inaccessible private repository discoverable publicly.

To publish an approved version, open **Actions → Publish WoW Forever addon →
Run workflow**, choose **main**, enter the TOC version, and explicitly confirm
publication. Tests and package checks run before a separate publishing job gets
write permission. Existing release assets are not overwritten. Other branches,
ordinary pushes, daily research, and PR merges do not trigger publication.
There is no CurseForge integration.

## Install

Copy the `TrumpQuotesForever` folder directly into your **Forever client's**
`Interface/AddOns` folder. The resulting path must be
`Interface/AddOns/TrumpQuotesForever/TrumpQuotesForever.toc`.
Restart the client if it was running, then enable the addon on character selection.

## Settings window

Click the **TQ button beside the minimap**, or open **Settings → AddOns →
Trump Quotes Forever**. You can also type `/tq` or `/tq settings` to open it.

- Pick a channel from the list of channels you have joined. The list refreshes
  whenever you open the picker; stored channel names follow zone changes.
- Enter minimum and maximum minutes, from 1 to 1440. Decimals are allowed.
- Click **Apply** to save, or **Start timer** to save and begin random attempts.
  Changing the interval while running cancels the old wait and starts a new one.
- **Stop timer** stops immediately, even if the fields contain invalid edits.
- **Preview quote** shows a quote locally. **Prepare quote** uses your saved
  destination and fills the chat editor so you can press Enter yourself.

Closing the window discards unapplied edits. Opening settings never starts the
timer or posts a quote. The status shows the saved channel, whether you have
joined it, and whether the timer is running or blocked by the client.

## Commands

- `/tq` or `/tq settings`: open settings.
- `/tq preview`: show a random quote only to you.
- `/tq post`: attempt one quote to the saved channel.
- `/tq prepare`: fill the saved channel’s chat editor; review and press Enter yourself.
- `/tq start`: start random timed send attempts, with the first one after a delay.
- `/tq stop`: stop immediately.
- `/tq interval 10 20`: set the random interval in minutes (1–1440).
- `/tq channel General`: choose a joined channel by its exact base name, including
  localized names on non-English clients. Use `/chatlist` to check names.
- `/tq status`: show timer, channel, and interval settings.

Settings persist; the timer always starts **off** after login or `/reload`.
There is a 60-second cooldown between API send attempts. Timed attempts skip AFK,
instances, and missing channels. The channel ID is looked up for every attempt so
the addon follows General as you change zones. It never auto-joins channels.

## Client restrictions and current limits

Forever's generated API marks `C_ChatInfo.SendChatMessage` as restricted, including
macro chat restrictions. This starter cannot guarantee unattended public-channel
posting. Check `/tq post` in game before enabling the timer. An API error or an
addon blocked/forbidden event stops the timer for the session. No successful API
return proves delivery: server throttles, chat permissions, or silent rejection
may still prevent messages. `/tq prepare` is the manual-send fallback and also
needs an in-game check on your build. No restriction bypass is included.

Verified locally with Lua 5.1-compatible code and mocked WoW APIs; **not yet tested
inside Forever**. Check loading, the minimap launcher, Settings → AddOns, the channel picker,
Apply/Start/Stop, `/tq post`, `/tq prepare`, and zone changes in the client. If the addon is marked out of date, compare
its interface number with `/dump select(4, GetBuildInfo())`.

## Daily quote updates and review

New quotes are prepared through a daily Codex research automation and proposed
in a private GitHub draft pull request. The automation depends on the Mac hosting
Codex being available; it is not a collector running continuously inside WoW or
on GitHub. It looks back seven days to catch delayed sources and missed runs.

Nothing merges or publishes automatically. Each PR includes source/context notes;
GitHub Actions validates the proposal and creates an anonymous review ZIP with a
checksum. There is no CurseForge integration. Open a PR's Actions run to download
its review artifact. Artifacts are retained for 30 days.

See [the daily research and reviewer guide](TrumpQuotesForever/UPDATE_GUIDE.md) for the source
policy, limitations, record schema, commands, and human approval steps.
The JSON ledger is `data/daily_quotes.json`; `DailyQuotes.lua` and the complete
catalog are generated. [Daily source notes](TrumpQuotesForever/DAILY_SOURCES.md)
identify newer entries. Historical source files remain separate.

Distributed builds use anonymous credits. Existing private Git history is kept;
no claim is made that GitHub account ownership or previous shared ZIPs are anonymous.

## Development

Edit `TrumpQuotesForever/Quotes.lua`, `TrumpQuotesForever/MoreQuotes.lua`, or
`TrumpQuotesForever/InsultQuotes.lua`, or `TrumpQuotesForever/ArchiveQuotes.lua` to change the quote pool. Keep complete
messages below 256 bytes. The pool includes false or unsupported claims, unusual
phrasing, jokes, and boasts; inclusion does not mean every entry is a lie.
Read [all 1,013 entries](TrumpQuotesForever/QUOTE_CATALOG.md).
See [QUOTE_SOURCES.md](TrumpQuotesForever/QUOTE_SOURCES.md) for the dates, sources,
and context for every entry. Excerpts preserve words, with normalized typography
and punctuation; some deliberately begin or end mid-sentence.

Entries 121–200 have their own [insult source ledger](TrumpQuotesForever/INSULT_SOURCES.md)
and machine-readable `INSULT_SOURCES.json`, including original post URLs and IDs.
Twenty of these are standalone nickname fragments. Heidi Cruz's entry quotes
Trump's own threat; the source notes describe the separate photo comparison he
reposted. This is an expanding collection, not an exhaustive archive of his remarks.

The archive expansion adds 812 short post excerpts, documented individually in
[ARCHIVE_SOURCES.md](TrumpQuotesForever/ARCHIVE_SOURCES.md) and `ARCHIVE_SOURCES.json`.
The full pool now has 1,013 entries. These are sourced remarks and accusations;
the source ledger describes archive coverage and verification limits.

Run `lua tests/test.lua` from this directory. The tests cover behavior under mocked
APIs, not actual permissions or delivery inside the game.

API references checked October 28, 2026:

- [Forever client API notes and tested interface number](https://github.com/xIGBClutchIx/ForeverPlusPlus/blob/main/docs/forever-api.md)
- [Forever generated chat API](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/ChatInfoDocumentation.lua)
- [Forever chat editor methods](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_ChatFrameBase/Shared/ChatFrameEditBox.lua)
- [Forever chat utility functions](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_ChatFrameBase/Shared/ChatFrameUtil.lua)

Settings UI references checked October 28, 2026 against the Forever branch:

- [Settings category registration and opening](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_Settings_Shared/Blizzard_Settings.lua)
- [Channel dropdown API](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_SharedXML/Mainline/UIDropDownMenu.lua)
- [Native input templates](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_SharedXML/Shared/InputBox/InputBoxTemplates.xml)
