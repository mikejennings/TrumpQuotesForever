local addonName, ns = ...
local Core = ns.Core
local frame = CreateFrame("Frame")
local db, timer, running, previous, lastAttempt, blocked
local generation = 0
local COOLDOWN = 60

local function Print(text)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Trump Quotes Forever:|r " .. text)
end

local function Stop()
    running = false
    generation = generation + 1
    if timer then timer:Cancel(); timer = nil end
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
    timer = C_Timer.NewTimer(seconds, function()
        if not running or token ~= generation then return end
        timer = nil
        -- No backlog or catch-up burst when AFK, zoning, or in an instance.
        if not UnitIsAFK("player") and not IsInInstance() and Channel() then
            Post()
        end
        if running then Schedule() end
    end)
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

local function Command(input)
    if not db then return end
    local command, args = input:match("^%s*(%S*)%s*(.-)%s*$")
    command = command:lower()
    if command == "start" then
        if blocked then Print("Sending was blocked; use /tq prepare or /reload to retry."); return end
        Stop()
        running = true
        Schedule()
        Print("Timer started: " .. db.minimum / 60 .. "-" .. db.maximum / 60 .. " minutes; first attempt after that delay.")
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
        db.channel = args
        Print("Channel: " .. args)
    elseif command == "interval" then
        local low, high = args:match("^(%S+)%s+(%S+)$")
        local minimum, maximum = Core.Range(low, high)
        if not minimum then Print(maximum); return end
        db.minimum, db.maximum = minimum, maximum
        if running then Stop(); running = true; Schedule() end
        Print("Random interval: " .. minimum / 60 .. "-" .. maximum / 60 .. " minutes.")
    elseif command == "status" then
        local id = Channel()
        Print((running and "Running" or "Stopped") .. "; " .. db.channel
            .. (id and " (joined)" or " (not joined)") .. "; "
            .. db.minimum / 60 .. "-" .. db.maximum / 60 .. " minutes.")
    else
        Print("/tq preview | post | prepare | start | stop | status | interval <min> <max> | channel <name>")
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
    if type(db.channel) ~= "string" or db.channel == "" then db.channel = "General" end
    local low, high = Core.Range(tonumber(db.minimum) and db.minimum / 60,
        tonumber(db.maximum) and db.maximum / 60)
    db.minimum, db.maximum = low or 600, low and high or 1200
    SLASH_TRUMPQUOTESFOREVER1 = "/tq"
    SLASH_TRUMPQUOTESFOREVER2 = "/trumpquotes"
    SlashCmdList.TRUMPQUOTESFOREVER = Command
    Print("Loaded for Forever. Timer is off. /tq for commands.")
end)
