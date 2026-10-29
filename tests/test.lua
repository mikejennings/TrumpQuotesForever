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
local widgets = {}
local function Widget(name)
    local w = {scripts = {}, shown = true, text = "", enabled = true}
    if name then widgets[name] = w end
    for _, method in ipairs({"SetPoint", "SetSize", "SetWidth", "SetJustifyH", "SetAutoFocus",
        "SetMaxLetters", "SetFrameStrata", "RegisterEvent"}) do w[method] = function() end end
    function w:SetScript(event, fn) self.scripts[event] = fn end
    function w:SetText(text) self.text = text end
    function w:GetText() return self.text end
    function w:SetEnabled(value) self.enabled = value end
    function w:ClearFocus() self.focus = false end
    function w:SetFocus() self.focus = true end
    function w:IsShown() return self.shown end
    function w:Hide() self.shown = false end
    function w:Show()
        local wasShown = self.shown
        self.shown = true
        if not wasShown and self.scripts.OnShow then self.scripts.OnShow(self) end
    end
    function w:CreateFontString() return Widget() end
    return w
end
function CreateFrame(kind, name)
    local w = Widget(name)
    if not name and not kind then error("missing frame type") end
    -- The first frame is the addon's event dispatcher.
    if not events.frame then events.frame = w end
    return w
end
UIParent, Minimap = Widget(), Widget()
local openedCategory
Settings = {
    RegisterCanvasLayoutCategory = function(panel)
        return {GetID = function() return 42 end, panel = panel}
    end,
    RegisterAddOnCategory = function(category) Settings.category = category end,
    OpenToCategory = function(id)
        openedCategory = id
        Settings.category.panel:Show()
    end,
}
local menu = {}
function UIDropDownMenu_SetWidth() end
function UIDropDownMenu_SetText(w, text) w.text = text end
function UIDropDownMenu_Initialize(w, fn) w.initialize = fn; fn(w, 1) end
function UIDropDownMenu_CreateInfo() return {} end
function UIDropDownMenu_AddButton(info) menu[#menu + 1] = info end
DEFAULT_CHAT_FRAME = {AddMessage = function() end}
SlashCmdList = {}
local tradeJoined = false
function GetChannelList()
    if tradeJoined then return channelID, "General", false, 2, "Trade", false, 9, "Disabled", true end
    return channelID, "General", false
end
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
load("Settings")
load("TrumpQuotesForever")
events.handler = events.frame.scripts.OnEvent
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
-- Exercise real settings handlers with mocked native widgets and the real controller.
local panel = ns.SettingsPanel
assert(panel and not panel:IsShown())
ns.SettingsLauncher.scripts.OnClick()
assert(openedCategory == 42 and panel:IsShown())
assert(tonumber(panel.minimum:GetText()) == 2 and tonumber(panel.maximum:GetText()) == 3)
assert(panel.start.enabled and panel.stop.enabled)
tradeJoined = true
menu = {}; panel.channel.initialize(panel.channel, 1)
assert(#menu == 2 and menu[2].text == "Trade") -- disabled channels excluded; fresh list
menu[2].func()
panel.minimum:SetText("9"); panel.maximum:SetText("4")
local beforeInvalid = jobs[#jobs]
assert(panel.apply.scripts.OnClick() == false)
assert(TrumpQuotesForeverDB.channel == "General" and TrumpQuotesForeverDB.minimum == 120)
assert(jobs[#jobs] == beforeInvalid and not beforeInvalid.cancelled)
panel.minimum:SetText("1.5"); panel.maximum:SetText("2.5")
assert(panel.apply.scripts.OnClick())
assert(TrumpQuotesForeverDB.channel == "Trade" and TrumpQuotesForeverDB.minimum == 90)
assert(beforeInvalid.cancelled and jobs[#jobs].delay >= 90 and jobs[#jobs].delay <= 150)
assert(panel.status:GetText():find("Trade %(joined%)"))
-- Stop must work even while the fields contain invalid unsaved edits.
panel.minimum:SetText("bad"); panel.stop.scripts.OnClick()
assert(not ns.Controller.GetState().running and not panel.stop.enabled)
panel.start.scripts.OnClick(); assert(not ns.Controller.GetState().running)
-- Closing/reopening restores saved values; opening never posts or starts the timer.
panel:Hide(); command("settings")
assert(tonumber(panel.minimum:GetText()) == 1.5 and not ns.Controller.GetState().running)
assert(#sends == 2)
-- Start applies the visible settings and schedules a delayed first attempt.
panel.minimum:SetText("2"); panel.maximum:SetText("3")
panel.start.scripts.OnClick(); assert(ns.Controller.GetState().running)
assert(jobs[#jobs].delay >= 120 and jobs[#jobs].delay <= 180 and #sends == 2)
-- Restore General for the existing zone-change/AFK tests.
assert(ns.Controller.Apply("General", 2, 3))
tradeJoined = false
panel.scripts.OnEvent(panel, "CHANNEL_UI_UPDATE")
assert(panel.status:GetText():find("General %(joined%)"))

local stale = jobs[#jobs]
command("stop"); stale.callback(); assert(#sends == 2 and stale.cancelled)
command("start"); afk = true; jobs[#jobs].callback(); assert(#sends == 2)
afk, instance = false, true; jobs[#jobs].callback(); assert(#sends == 2)
instance, now, reject = false, 200, true
local count = #jobs
jobs[#jobs].callback(); assert(#jobs == count) -- errors stop rather than retry
command("start"); assert(#jobs == count)
assert(not panel.start.enabled and panel.status:GetText():find("Blocked by client"))
reject = false
events.handler(nil, "ADDON_LOADED", "TrumpQuotesForever")
assert(#jobs == count) -- reload still stopped
print("PASS: quote selection, channel changes, cooldown, timers, AFK/instance skips, restrictions, prepare, settings validation and UI controls")
