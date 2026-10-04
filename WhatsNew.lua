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
-- Forever client. Keep it short: the full list lives in CHANGELOG.md.

local DISCORD_URL = "https://discord.gg/aYmhmtGxYs"

local WHATS_NEW = {
    { forever = true, text = "Every class: level-60 weights rebuilt from the wowsims Forever simulator (healers from our healing model), profiles named after the Talents plugin's builds in five languages, new Dungeon Leveling profiles, and more of your talents adjust the leveling weights." },
    { forever = true, text = "Warriors: Arms: Raid, Fury and Protection: Raid weights from the simulator, plus a Protection: AoE Farming profile and Arms and Protection Dungeon Leveling. Level-60 Warriors are scored by the tree they spent the most points in, so a Fury or Arms Warrior with a few Protection talents no longer gets tank weights." },
    { forever = true, text = "Paladins: Retribution: Raid weights from the simulator with Twist of Light seal-twisting (Hit and Crit now lead), Protection: Raid from the simulator's tank test, Holy: Raid from our healing model, and the leveling weights checked against the simulator at the top end. Retribution and Holy builds no longer get the healer or PvP Shockadin weights by mistake." },
    { forever = true, text = "Rogues: Combat weights from the simulator (Crit now counts as much as Hit), a Combat: Dungeon Leveling profile for daggers, and level-60 Rogues are scored by their main tree and main-hand weapon." },
    { forever = true, text = "Hunters: a new Beast Mastery: Raid profile (the strongest Hunter spec; Intellect and Mp5 count more than Agility), a Beast Mastery: Dungeon Leveling profile, and level-60 Hunters are scored by their main tree." },
    { forever = true, text = "Mages: Frost, Fire and a new Arcane: Raid from the simulator (Crit counts several times more), Frost: AoE Farming and Frost: Dungeon Leveling, and level-60 Mages are scored by their main tree." },
    { forever = true, text = "Priests: Shadow: Raid from the simulator, separate Holy: Raid and Discipline: Raid from our healing model (Mp5 and Intellect worth far more), Shadow farming and Dungeon Leveling profiles, and Shadow Priests without Shadow Weaving no longer get healer weights." },
    { forever = true, text = "Warlocks: Demonology (Demonic Pact), Affliction and Destruction raid weights from the simulator (Crit worth about four times more, Hit about half), a Demonology AoE farming profile and Affliction: Dungeon Leveling." },
    { forever = true, text = "Shamans: Enhancement and Elemental raid weights from the simulator, Restoration from our healing model, a Tank: AoE Farming profile and Enhancement and Restoration Dungeon Leveling. Elemental raid builds no longer get the PvP weights." },
    { forever = true, text = "Druids: Cat, Balance and Bear raid weights from the simulator, Restoration from our healing model, and Cat and Restoration Dungeon Leveling profiles." },
    { forever = true, text = "Fixed a Lua error on Druid idols such as Windcharged Leaf. Librams, idols and totems are no longer counted twice when scored." },
    { forever = true, text = "Talents plugin 1.1.0: builds for every class (raid, dungeon leveling and farming), sorted by Max Level, Leveling or Farming and by role. New: Twist of Light Retribution, Vanguard as the recommended Paladin raid tank, Shaman and Druid tanks, and a no-respec Affliction Warlock." },
    { forever = true, text = "Roadmap plugin: loot for every Forever dungeon with a known loot table, over 1,100 drops with the boss that drops each one, now including Excavation Site: Wetlands, Razorfen Downs and Uldaman from the 2 October patch, up through Scholomance and Stratholme." },
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
        if not entry.forever or MSC.IsForever then
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
