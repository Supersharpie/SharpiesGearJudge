local addonName, MSC = ...
local L = MSC.L

-- =============================================================
-- WHAT'S NEW POPUP
-- =============================================================
-- Shown once after each update (and on a fresh install), a few seconds after
-- login: a short rundown of the release plus the Discord invite. The last
-- version seen is stored per account in SGJ_Settings.LastSeenVersion.
-- Reopen any time with /sgj whatsnew.
--
-- Update WHATS_NEW for each release. forever = true lines only show on the
-- Forever client; classic = true lines only show on Era and TBC. Keep it
-- short: the full list lives in CHANGELOG.md.

local DISCORD_URL = "https://discord.gg/aYmhmtGxYs"

local WHATS_NEW = {
    -- v3.2.1: add a line here for each change logged under v3.2.1 in CHANGELOG.md.
    { text = "New plugin: Sharpie's Gear Judge - Roster (Alt Upgrades). Item tooltips show which of your other characters an item upgrades, and a grid lists every character's gear. Your bags, bank and mail count too." },
    { text = "Item sets rebuilt from the Forever client: all 532 sets, including the new Forever sets, now score their real Forever bonuses.", forever = true },
    { text = "Set bonus hit and crit no longer count many times over, and healers get credit for spell power set bonuses." },
    { text = "Item sets rebuilt from your game's own data: every set counts its real bonuses, including many TBC sets that never counted before.", classic = true },
    { text = "Proc and use-effect trinkets now add their effect on top of their stats instead of a fixed score that ignored them." },
    { text = "Enchant suggestions rebuilt from your game's own data: only enchants your game really has, with their real stats, suited to your level and class." },
    { text = "Mana and health per 5 on gear now count, random-suffix items (\"of the Bear\") keep their bonus stats, and feral attack power is read as feral.", classic = true },
    { text = "Leveling weights fixed: some specs and levels scored every item 0. TBC leveling now counts armor and favours fast off-hand weapons where it should.", classic = true },
    { text = "Worn rings, trinkets and dual-wield weapons now show as Equipped, and scores refresh as soon as you level up." },
    { text = "Characters that share a first name no longer share saved specs, gear sets or talent builds.", forever = true },
    { text = "The window title now shows the name of the open tab." },
    { text = "Roadmap 3.1.0: quest rewards for every Forever zone, filtered to your faction and class.", forever = true },
    { text = "Roadmap 3.1.0: new checkboxes choose dungeon loot, dungeon quests and world quests, and scans run more smoothly." },
    { text = "Weapon swaps now show any weapon racial you gain or lose in the tooltip, for example Sword Specialization for Humans.", forever = true },
    { text = "New option Shield Tanks: No Two-Handers (on by default): two-handers no longer show as upgrades for shield tanks, in tooltips and the Roadmap." },
    { text = "Fully translated into every language WoW Forever ships in, now including Korean, Traditional Chinese and Latin American Spanish." },
    { text = "Faster: far fewer needless updates when your bags, vendors or item data change, and lighter tooltips." },
    { text = "The beta dataminer is gone; anything it recorded is cleared from your saved data.", forever = true },
}

-- "3.1.0-Forever" -> "3.1.0", so every edition shares one "last seen" value.
local function BaseVersion(v)
    return (tostring(v or ""):gsub("%-%a+$", ""))
end

local function CurrentVersion()
    local GetMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    local v = (GetMetadata and GetMetadata(addonName, "Version")) or MSC.Version
    return BaseVersion(v)
end

local frame

local function BuildFrame()
    local f = CreateFrame("Frame", "SGJ_WhatsNewFrame", UIParent, "BackdropTemplate")
    f:SetWidth(470)
    f:SetPoint("CENTER", 0, 60)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true); f:SetMovable(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    tinsert(UISpecialFrames, "SGJ_WhatsNewFrame") -- Escape closes it

    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -5, -5)

    f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    f.Title:SetPoint("TOP", 0, -20)

    local newHeader = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    newHeader:SetPoint("TOPLEFT", 26, -52)
    newHeader:SetText(L["What's new"])

    f.Notes = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.Notes:SetPoint("TOPLEFT", newHeader, "BOTTOMLEFT", 0, -8)
    f.Notes:SetWidth(418)
    f.Notes:SetJustifyH("LEFT")
    f.Notes:SetSpacing(3)

    local discordHeader = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    discordHeader:SetPoint("TOPLEFT", f.Notes, "BOTTOMLEFT", 0, -16)
    discordHeader:SetText(L["Discord"])

    local discordText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    discordText:SetPoint("TOPLEFT", discordHeader, "BOTTOMLEFT", 0, -6)
    discordText:SetWidth(418)
    discordText:SetJustifyH("LEFT")
    discordText:SetText(L["Join the Sharpie's Gear Judge Discord to request features, report bugs, and tell us when a stat weight feels off for your spec. Click the link and press Ctrl+C to copy it."])

    -- WoW can't open web links, so the invite sits in a box to copy from.
    local link = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
    link:SetPoint("TOPLEFT", discordText, "BOTTOMLEFT", 6, -8)
    link:SetSize(300, 22)
    link:SetAutoFocus(false)
    link:SetText(DISCORD_URL)
    link:SetCursorPosition(0)
    link:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
    link:SetScript("OnMouseUp", function(self) self:SetFocus(); self:HighlightText() end)
    link:SetScript("OnTextChanged", function(self, userInput)
        if userInput then self:SetText(DISCORD_URL); self:HighlightText() end -- keep it read-only
    end)
    link:SetScript("OnEscapePressed", function(self) self:ClearFocus(); f:Hide() end)
    link:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

    local ok = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    ok:SetSize(110, 24)
    ok:SetPoint("BOTTOM", 0, 18)
    ok:SetText(L["Got it"])
    ok:SetScript("OnClick", function() f:Hide() end)

    f.Link = link
    f.Measure = function(self)
        -- Height follows the text so nothing is clipped at any font size.
        local h = 52 + newHeader:GetStringHeight() + 8 + self.Notes:GetStringHeight()
            + 16 + discordHeader:GetStringHeight() + 6 + discordText:GetStringHeight()
            + 8 + 22 + 18 + 24 + 22
        self:SetHeight(h)
    end
    return f
end

function MSC.ShowWhatsNew()
    if not frame then frame = BuildFrame() end
    local lines = {}
    for _, entry in ipairs(WHATS_NEW) do
        if (not entry.forever or MSC.IsForever) and (not entry.classic or not MSC.IsForever) then
            lines[#lines + 1] = "|cffffd100-|r " .. L[entry.text]
        end
    end
    -- A release can be all Forever-only lines; don't show an empty list elsewhere.
    if #lines == 0 then
        lines[1] = "|cffffd100-|r " .. L["Fixes and improvements for WoW Forever; nothing changed for your game version."]
    end
    frame.Title:SetText(string.format(L["Sharpie's Gear Judge v%s"], CurrentVersion()))
    frame.Notes:SetText(table.concat(lines, "\n"))
    frame:Measure()
    frame:Show()
end

-- On login: show once per new version. Waits a few seconds so it doesn't land
-- in the middle of the loading screen, and waits out combat.
local watcher = CreateFrame("Frame")
watcher:RegisterEvent("PLAYER_LOGIN")
watcher:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")
        if type(SGJ_Settings) ~= "table" then return end
        local current = CurrentVersion()
        if current == "" or SGJ_Settings.LastSeenVersion == current then return end
        local function show()
            if InCombatLockdown and InCombatLockdown() then
                self:RegisterEvent("PLAYER_REGEN_ENABLED")
                return
            end
            SGJ_Settings.LastSeenVersion = current
            MSC.ShowWhatsNew()
        end
        self.Show = show
        if C_Timer and C_Timer.After then C_Timer.After(4, show) else show() end
    elseif event == "PLAYER_REGEN_ENABLED" then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        if self.Show then self.Show() end
    end
end)
