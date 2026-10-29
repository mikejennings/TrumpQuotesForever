local _, ns = ...
local panel, category, selectedChannel

local function Label(parent, text, x, y, font, width)
    local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontNormal")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    label:SetJustifyH("LEFT")
    if width then label:SetWidth(width) end
    label:SetText(text)
    return label
end

local function Button(parent, text, x, y, width, onClick)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    button:SetSize(width, 26)
    button:SetText(text)
    button:SetScript("OnClick", onClick)
    return button
end

local function Minutes(parent, x, y)
    local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    box:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    box:SetSize(100, 26)
    box:SetAutoFocus(false)
    box:SetMaxLetters(8)
    box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    box:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    return box
end

function ns.RefreshSettings()
    if not panel then return end
    local state = ns.Controller.GetState()
    local text = state.blocked and "Blocked by client - timer stopped. Use Prepare quote."
        or (state.running and "Timer running" or "Timer stopped")
    panel.status:SetText(text .. "\nSaved: " .. state.channel
        .. (state.joined and " (joined)" or " (not joined)") .. " | "
        .. state.minimum .. "-" .. state.maximum .. " minutes")
    panel.start:SetEnabled(not state.blocked)
    panel.stop:SetEnabled(state.running)
end

local function Fill()
    local state = ns.Controller.GetState()
    selectedChannel = state.channel
    UIDropDownMenu_SetText(panel.channel, selectedChannel)
    panel.minimum:SetText(tostring(state.minimum))
    panel.maximum:SetText(tostring(state.maximum))
    panel.feedback:SetText("")
    ns.RefreshSettings()
end

local function Apply()
    local ok, err = ns.Controller.Apply(selectedChannel, panel.minimum:GetText(), panel.maximum:GetText())
    panel.minimum:ClearFocus()
    panel.maximum:ClearFocus()
    if not ok then
        panel.feedback:SetText("|cffff5555" .. err .. "|r")
        return false
    end
    Fill()
    panel.feedback:SetText("Settings saved.")
    return true
end

function ns.OpenSettings()
    if category then Settings.OpenToCategory(category:GetID()) end
end

function ns.InitSettings()
    if panel then return end
    panel = CreateFrame("Frame", "TrumpQuotesForeverSettingsPanel", UIParent)
    panel:Hide()
    ns.SettingsPanel = panel
    Label(panel, "Trump Quotes Forever", 20, -20, "GameFontNormalLarge")
    Label(panel, "Choose a joined chat channel and a random delay between posting attempts.",
        20, -52, "GameFontHighlight", 500)
    Label(panel, "Chat channel", 20, -94)
    panel.channel = CreateFrame("Frame", "TrumpQuotesForeverChannelPicker", panel, "UIDropDownMenuTemplate")
    panel.channel:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -114)
    UIDropDownMenu_SetWidth(panel.channel, 280)
    UIDropDownMenu_Initialize(panel.channel, function(_, level)
        local channels = ns.Controller.GetChannels()
        for _, entry in ipairs(channels) do
            local name = entry.name
            local info = UIDropDownMenu_CreateInfo()
            info.text, info.value = name, name
            info.checked = name == selectedChannel
            info.func = function()
                selectedChannel = name
                UIDropDownMenu_SetText(panel.channel, name)
                panel.feedback:SetText("Click Apply or Start to save changes.")
            end
            UIDropDownMenu_AddButton(info, level)
        end
        if #channels == 0 then
            local info = UIDropDownMenu_CreateInfo()
            info.text, info.disabled, info.notCheckable = "No joined channels", true, true
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    Label(panel, "Only channels you have joined are listed. The list updates when opened.",
        20, -158, "GameFontHighlightSmall", 500)
    Label(panel, "Minimum minutes", 20, -202)
    Label(panel, "Maximum minutes", 180, -202)
    panel.minimum = Minutes(panel, 26, -226)
    panel.maximum = Minutes(panel, 186, -226)
    panel.minimum:SetScript("OnTabPressed", function() panel.maximum:SetFocus() end)
    panel.maximum:SetScript("OnTabPressed", function() panel.minimum:SetFocus() end)
    Label(panel, "Use 1-1440 minutes, minimum no greater than maximum. Decimals are allowed.",
        20, -264, "GameFontHighlightSmall", 500)
    panel.apply = Button(panel, "Apply", 20, -300, 100, Apply)
    panel.start = Button(panel, "Start timer", 132, -300, 110, function()
        if Apply() and ns.Controller.Start() then
            panel.feedback:SetText("Timer started. First attempt after a random delay.")
        end
    end)
    panel.stop = Button(panel, "Stop timer", 254, -300, 110, function()
        ns.Controller.Stop()
        panel.feedback:SetText("Timer stopped.")
    end)
    panel.feedback = Label(panel, "", 20, -338, "GameFontHighlight", 500)
    panel.status = Label(panel, "", 20, -380, "GameFontHighlight", 500)
    panel.preview = Button(panel, "Preview quote", 20, -438, 130, function() ns.Controller.Preview() end)
    panel.prepare = Button(panel, "Prepare quote", 162, -438, 130, function() ns.Controller.Prepare() end)
    Label(panel, "Settings are saved with Apply or Start. Closing discards unsaved edits.\nTimer starts off after login/reload. If sending is blocked, Prepare quote fills chat; press Enter to send.",
        20, -480, "GameFontHighlightSmall", 500)
    panel:SetScript("OnShow", Fill)
    panel:RegisterEvent("CHANNEL_UI_UPDATE")
    panel:RegisterEvent("PLAYER_ENTERING_WORLD")
    panel:SetScript("OnEvent", ns.RefreshSettings)
    category = Settings.RegisterCanvasLayoutCategory(panel, "Trump Quotes Forever")
    Settings.RegisterAddOnCategory(category)

    -- A small launcher gives access without typing a slash command.
    local launcher = CreateFrame("Button", "TrumpQuotesForeverMinimapButton", Minimap or UIParent,
        "UIPanelButtonTemplate")
    launcher:SetSize(32, 24)
    launcher:SetPoint("TOPLEFT", Minimap or UIParent, "TOPLEFT", -12, 0)
    launcher:SetText("TQ")
    launcher:SetFrameStrata("MEDIUM")
    launcher:SetScript("OnClick", ns.OpenSettings)
    launcher:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("Trump Quotes Forever")
        GameTooltip:AddLine("Click to choose a channel and timer.", 1, 1, 1)
        GameTooltip:Show()
    end)
    launcher:SetScript("OnLeave", function() GameTooltip:Hide() end)
    ns.SettingsLauncher = launcher
end
