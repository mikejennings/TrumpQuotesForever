local ns = {}
local function load(name) assert(loadfile("TrumpQuotesForever/" .. name .. ".lua"))("TrumpQuotesForever", ns) end
load("Quotes"); load("MoreQuotes"); load("InsultQuotes"); load("ArchiveQuotes"); load("Core")
local core = ns.Core
assert(core.Range(1, 2) == 60)
assert(not core.Range(0, 2))
assert(not core.Range(20, 10))
assert(not core.Range(1, math.huge))
assert(not core.Range("invalid", 10))
assert(core.Channel("General", 4, "General", false, 1, "Trade", false) == 4)
assert(not core.Channel("General", 1, "Trade", false))
assert(not core.Channel("General", 4, "General", true))
for previous = 1, #ns.quotes do
    for roll = 1, #ns.quotes - 1 do
        assert(core.Pick(ns.quotes, previous, function() return roll end) ~= previous)
    end
end
for _, quote in ipairs(ns.quotes) do assert(core.Message(quote)) end
assert(not core.Message(string.rep("a", 256)))
assert(not core.Message("bad\nline"))
assert(not core.Message("|Hlink"))

local events, jobs, sends, drafts = {}, {}, {}, {}
local channelID, now, afk, instance, reject = 4, 0, false, false, false
function CreateFrame()
    return {RegisterEvent = function() end, SetScript = function(_, _, fn) events.handler = fn end}
end
DEFAULT_CHAT_FRAME = {AddMessage = function() end}
SlashCmdList = {}
function GetChannelList() return channelID, "General", false end
function GetTime() return now end
function UnitIsAFK() return afk end
function IsInInstance() return instance end
C_Timer = {NewTimer = function(delay, callback)
    local job = {delay = delay, callback = callback, Cancel = function(self) self.cancelled = true end}
    jobs[#jobs + 1] = job
    return job
end}
C_ChatInfo = {SendChatMessage = function(message, kind, language, target)
    if reject then error("restricted") end
    sends[#sends + 1] = {message, kind, target}
end}
local editBox = {
    GetText = function() return "" end,
    IsShown = function() return false end,
    SetChatType = function(_, kind) drafts.kind = kind end,
    SetChannelTarget = function(_, id) drafts.target = id end,
    SetText = function(_, text) drafts.text = text end,
    UpdateHeader = function() end,
    SetCursorPosition = function() end,
}
ChatFrameUtil = {ChooseBoxForSend = function() return editBox end, ActivateChat = function() end}
load("TrumpQuotesForever")
events.handler(nil, "ADDON_LOADED", "TrumpQuotesForever")
local command = SlashCmdList.TRUMPQUOTESFOREVER
assert(#jobs == 0 and #sends == 0) -- login never starts posting
command("preview"); assert(#sends == 0)
command("post"); assert(#sends == 1 and sends[1][2] == "CHANNEL" and sends[1][3] == "4")
command("post"); assert(#sends == 1) -- cooldown
channelID, now = 7, 61
command("post"); assert(sends[2][3] == "7") -- zone/channel changes resolved each time
command("prepare"); assert(drafts.target == 7 and drafts.kind == "CHANNEL" and drafts.text)
assert(#sends == 2) -- prepare never sends
command("interval 2 3"); command("start")
assert(#sends == 2 and jobs[#jobs].delay >= 120 and jobs[#jobs].delay <= 180)
local stale = jobs[#jobs]
command("stop"); stale.callback(); assert(#sends == 2 and stale.cancelled)
command("start"); afk = true; jobs[#jobs].callback(); assert(#sends == 2)
afk, instance = false, true; jobs[#jobs].callback(); assert(#sends == 2)
instance, now, reject = false, 200, true
local count = #jobs
jobs[#jobs].callback(); assert(#jobs == count) -- errors stop rather than retry
command("start"); assert(#jobs == count)
reject = false
events.handler(nil, "ADDON_LOADED", "TrumpQuotesForever")
assert(#jobs == count) -- reload still stopped
print("PASS: quote selection, channel changes, cooldown, timers, AFK/instance skips, restrictions, prepare")
