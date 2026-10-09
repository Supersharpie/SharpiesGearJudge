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
    -- v3.2.2: add a line here for each change logged under v3.2.2 in CHANGELOG.md.
    { forever = true, text = "Level-60 profiles re-run on the current wowsims Forever simulator: Rogue, Hunter, Mage, Shaman and Druid raid weights moved (Arcane now edges Frost, Enhancement and Beast Mastery run short of mana, the Cat no longer powershifts); Warrior, Warlock, Priest and Paladin stayed the same. The Paladin dungeon tank and healer rows were rebuilt too." },
    { forever = true, text = "Talents plugin: no talent changes, but eight build notes now quote the current simulator. Frost stays the Mage raid build, with Arcane within a few percent." },
    { forever = true, text = "Ready for Dual Specialization: each spec keeps its own scoring profile, Gear for PvP setting and remembered gear, tooltips show if an item is an upgrade for your other spec, and the Talents plugin keeps a build per spec." },
    { forever = true, text = "New: Gear for PvP. Scores gear for fighting other players at every level, for open-world PvP while leveling and battlegrounds at 60: Stamina, armor and burst count for more, and hit stops at the player-vs-player caps. Turn it on with the checkbox at the top of the /sgj window or with /sgj pvp." },
    { forever = true, text = "On a PvP realm, Gear Judge offers to turn Gear for PvP on (once per realm)." },
    { forever = true, text = "Level-60 PvP profiles are rebuilt from the simulated raid profiles, with new PvP profiles for Warriors, Retribution Paladins, Druids and Priest and Shaman healers." },
    { forever = true, text = "Talents plugin: a new PvP group with 16 builds, each a full talent order from 10 to 60. Picking one turns on PvP weights for that character." },
    { text = "Gear is now judged without buffs: food, elixirs and party buffs no longer move hit caps, tank caps or scores, and an active Shield Block or Holy Shield no longer counts twice toward uncrushable." },
    { text = "Buff Assumptions work on every game version, with a full-raid, 5-player group and world buff preset. Percent buffs such as Blessing of Kings now raise the value of stats on gear instead of lowering it." },
    { forever = true, text = "Updated for beta patch 1.60.1.70291: Warriors lost Precision, Toughness and Boundless Rage and gained Furious Precision, and Predatory Instincts is now Natural Instinct. Warrior and Druid weights and the Talents plugin's Warrior builds follow the new trees." },
    { forever = true, text = "Re-checked everything else the patch changed: Warrior level-60 profiles, Discipline Priest (Penance), Restoration Shaman (Water Shield), Protection Paladin (Reckoning and Retribution Aura) and the early ranks of caster spells." },
    { classic = true, text = "Fixed: on Classic Era and Season of Discovery a weapon's damage per second counted for nothing, so weapons were judged on their stats alone. Racial weapon skill no longer adds a fixed 20 to 60 points at every level." },
    { text = "One-handed weapons for dual-wielders are judged in the hand where they gain the most, and the tooltip shows the other hand as well." },
    { text = "Tooltips show the item's own Item Score under Judge's Score (your whole character's score), with the worn item's score when comparing. With Enchant Mode on Project Best, the worn item shows its projected enchant too." },
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
