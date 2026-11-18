local addonName, ns = ...
local Core = ns.Core
local frame = CreateFrame("Frame")
local db, timer, running, previous, lastAttempt, blocked, promptPending, nextPromptAt
local generation = 0
local COOLDOWN = 60

local function Print(text)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Trump Quotes Forever:|r " .. text)
end

local function Stop()
    running = false
    promptPending = false
    nextPromptAt = nil
    if db then db.enabled = false end
    generation = generation + 1
    if timer then timer:Cancel(); timer = nil end
    ns.HideQuotePrompt()
    if ns.RefreshSettings then ns.RefreshSettings() end
end

local function Channel()
    return Core.Channel(db.channel, GetChannelList())
end

local function Quote()
    local index = Core.Pick(ns.quotes, previous, math.random)
    local message = index and Core.Message(ns.quotes[index])
    if not message then Print("No valid quote available."); return end
    previous = index
    return message
end

local function Post()
    if blocked then
        Print("Client blocked sending. Use /tq prepare, then Enter to send.")
        return false
    end
    local channelID = Channel()
    if not channelID then
        Print("Not joined to " .. db.channel .. ". Check /chatlist or /tq channel <name>.")
        return false
    end
    if lastAttempt and GetTime() - lastAttempt < COOLDOWN then
        Print("Wait " .. math.ceil(COOLDOWN - (GetTime() - lastAttempt)) .. " seconds.")
        return false
    end
    local message = Quote()
    if not message then return false end
    local send = C_ChatInfo and C_ChatInfo.SendChatMessage
    if not send then Print("Chat API unavailable on this client."); return false end
    lastAttempt = GetTime()
    local ok, err = pcall(send, message, "CHANNEL", nil, tostring(channelID))
    if not ok or blocked then
        blocked = true
        Stop()
        Print("Send blocked; timer stopped. Use /tq prepare. " .. (ok and "" or tostring(err)))
        return false
    end
    -- The API has no delivery receipt; a successful call is only an attempt.
    return true
end

local function Schedule()
    if not running then return end
    local token = generation
    local seconds = math.random(db.minimum, db.maximum)
    nextPromptAt = GetTime() + seconds
    timer = C_Timer.NewTimer(seconds, function()
        if not running or token ~= generation then return end
        timer = nil
        nextPromptAt = nil
        -- Keep one prompt open and wait for the player before scheduling again.
        if not UnitIsAFK("player") and not IsInInstance() and Channel() then
            promptPending = true
            ns.ShowQuotePrompt(db.channel)
            if ns.RefreshSettings then ns.RefreshSettings() end
        else
            Schedule()
        end
    end)
end

local function ResolvePrompt(post)
    if not promptPending then return end
    -- Send from the actual button click so the client sees player input.
    if post and not Post() then return end
    promptPending = false
    ns.HideQuotePrompt()
    Schedule()
    if ns.RefreshSettings then ns.RefreshSettings() end
end

local function Prepare()
    local channelID = Channel()
    if not channelID then Print("Not joined to " .. db.channel .. "."); return end
    local editBox = ChatFrameUtil and ChatFrameUtil.ChooseBoxForSend(DEFAULT_CHAT_FRAME)
    if not editBox or not editBox.SetChatType or not editBox.SetChannelTarget then
        Print("Chat editor unavailable on this build."); return
    end
    if editBox:GetText() ~= "" and editBox:IsShown() then
        Print("Finish or clear your existing chat draft first."); return
    end
    local message = Quote()
    if not message then return end
    ChatFrameUtil.ActivateChat(editBox)
    editBox:SetChatType("CHANNEL")
    editBox:SetChannelTarget(channelID)
    editBox:SetText(message)
    editBox:UpdateHeader()
    editBox:SetCursorPosition(#message)
end

local function Start()
    if blocked then Print("Sending was blocked; use Prepare quote or /reload to retry."); return false end
    Stop()
    running = true
    db.enabled = true
    Schedule()
    if ns.RefreshSettings then ns.RefreshSettings() end
    Print("Timer started: a Post quote button will appear in "
        .. db.minimum / 60 .. "-" .. db.maximum / 60 .. " minutes when your channel is available.")
    return true
end

local function ApplySettings(channel, low, high)
    if type(channel) ~= "string" then return false, "Choose a chat channel." end
    channel = channel:match("^%s*(.-)%s*$")
    if channel == "" or tonumber(channel) or channel:find("[%c|]") then
        return false, "Choose a channel by name."
    end
    local minimum, maximum = Core.Range(low, high)
    if not minimum then return false, maximum end
    local changed = channel ~= db.channel or minimum ~= db.minimum or maximum ~= db.maximum
    -- Validate everything before changing saved settings or the active timer.
    db.channel, db.minimum, db.maximum = channel, minimum, maximum
    if running and changed then Start() end
    if ns.RefreshSettings then ns.RefreshSettings() end
    return true
end

ns.Controller = {
    GetState = function()
        return {channel = db.channel, minimum = db.minimum / 60, maximum = db.maximum / 60,
            running = not not running, blocked = not not blocked, joined = not not Channel(),
            promptPending = not not promptPending,
            remaining = nextPromptAt and math.max(0, math.ceil(nextPromptAt - GetTime()))}
    end,
    GetChannels = function()
        local result, channels = {}, {GetChannelList()}
        for i = 1, #channels, 3 do
            if type(channels[i + 1]) == "string" and not channels[i + 2] then
                result[#result + 1] = {id = channels[i], name = channels[i + 1]}
            end
        end
        return result
    end,
    Apply = ApplySettings, Start = Start, Stop = Stop, Prepare = Prepare,
    ResolvePrompt = ResolvePrompt,
    Preview = function() local message = Quote(); if message then Print(message) end end,
}

local function Command(input)
    if not db then return end
    local command, args = input:match("^%s*(%S*)%s*(.-)%s*$")
    command = command:lower()
    if (command == "" or command == "settings" or command == "options") and ns.OpenSettings then
        ns.OpenSettings()
    elseif command == "start" then
        Start()
    elseif command == "stop" then
        Stop(); Print("Timer stopped.")
    elseif command == "post" then
        Post()
    elseif command == "prepare" then
        Prepare()
    elseif command == "preview" then
        local message = Quote()
        if message then Print(message) end
    elseif command == "channel" and args ~= "" then
        if tonumber(args) then Print("Use the channel name, such as General, not its number."); return end
        local ok, err = ApplySettings(args, db.minimum / 60, db.maximum / 60)
        Print(ok and ("Channel: " .. db.channel) or err)
    elseif command == "interval" then
        local low, high = args:match("^(%S+)%s+(%S+)$")
        local ok, err = ApplySettings(db.channel, low, high)
        if not ok then Print(err); return end
        Print("Random interval: " .. db.minimum / 60 .. "-" .. db.maximum / 60 .. " minutes.")
    elseif command == "status" then
        local id = Channel()
        Print((promptPending and "Quote ready" or running and "Running" or "Stopped") .. "; " .. db.channel
            .. (id and " (joined)" or " (not joined)") .. "; "
            .. db.minimum / 60 .. "-" .. db.maximum / 60 .. " minutes.")
    else
        Print("/tq settings | preview | post | prepare | start | stop | status | interval <min> <max> | channel <name>")
    end
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("ADDON_ACTION_BLOCKED")
frame:RegisterEvent("ADDON_ACTION_FORBIDDEN")
frame:SetScript("OnEvent", function(_, event, name)
    if event ~= "ADDON_LOADED" then
        if name == addonName then
            blocked = true
            Stop()
            Print("Client blocked an addon action; timer stopped. Try /tq prepare.")
        end
        return
    end
    if name ~= addonName then return end
    if type(TrumpQuotesForeverDB) ~= "table" then TrumpQuotesForeverDB = {} end
    db = TrumpQuotesForeverDB
    local resume = db.enabled == true
    if type(db.channel) ~= "string" or db.channel == "" then db.channel = "General" end
    local low, high = Core.Range(tonumber(db.minimum) and db.minimum / 60,
        tonumber(db.maximum) and db.maximum / 60)
    db.minimum, db.maximum = low or 600, low and high or 1200
    Stop()
    blocked = false
    SLASH_TRUMPQUOTESFOREVER1 = "/tq"
    SLASH_TRUMPQUOTESFOREVER2 = "/trumpquotes"
    SlashCmdList.TRUMPQUOTESFOREVER = Command
    if ns.InitSettings then ns.InitSettings() end
    if resume then Start() end
    Print("Loaded for Forever. Timer is " .. (running and "on" or "off")
        .. ". Click the TQ minimap button for settings.")
end)
