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
    -- v3.2.4
    { forever = true, text = "WoW Forever: the 2026-10-15 patch removed the Human, Orc and Dwarf weapon racials, so swords, axes and maces no longer score higher for those races. Their new racials (Ruthless, Savage, Earth Fury) work with any weapon." },
    { text = "Fixed for WoW Forever and Classic Era in other languages: your talents now adjust the weights and pick your leveling profile in every language. Before, this only worked in English." },
    { forever = true, text = "WoW Forever: Feral Druids now value Weapon DPS. Cat and Bear Form swing your equipped weapon, so a better staff or mace is a real upgrade, from Bear Form at 10 up to the raid profiles." },
    { forever = true, text = "WoW Forever: Rake now gains from Attack Power, so the Cat raid profile is re-simulated (about 7% more damage). Attack Power counts a little more next to Crit, Hit and Weapon DPS." },
    { forever = true, text = "WoW Forever: leveling weights checked against the current models. Feral Cat Crit and Hit count less from 25, Frost Mage and Enhancement Shaman Crit count more, and dual-wield Warriors value Weapon DPS more, also after level 40 without Bloodthirst." },
    { forever = true, text = "WoW Forever: more leveling weights rebuilt on the models for the 2026-10-15 patch: Fire Mage, Protection Paladin (Spell Power counts about twice as much), Priest (damage over time can crit, the wand counts far less, and the Discipline and Holy solo builds now get their own weights), Elemental Shaman, Balance Druid and the healers' solo weights (Intellect counts less, since drinks restore a flat amount). Survival Hunters get their own dungeon weights." },
    { forever = true, text = "WoW Forever: Hunter weights checked against beta combat logs. Arcane Shot and Serpent Sting grow with Attack Power, so solo leveling Crit and Hit count less from 25; in dungeons they count more, with the better bows players wear. With Summon Hawk they count about a fifth less from 30, since the hawks ignore your crit and hit." },
    { forever = true, text = "WoW Forever: Frost Mage dungeon weights checked against beta combat logs: Arcane Explosion reaches the whole pack, and you start each boss with a full mana bar. Blizzard gains little from Spell Power, so Crit counts up to about twice as much in dungeons." },
    { forever = true, text = "WoW Forever: Enhancement Shaman dungeon weights checked against beta combat logs: Windfury Weapon from 30, Fire Nova on packs, Searing Totem and Stormstrike's real mana cost. Hit counts more in dungeons, and Crit a little less from 30." },
    { forever = true, text = "WoW Forever: Affliction Warlock dungeon weights checked against beta combat logs: between DoTs players mostly use the wand on trash, not Shadow Bolt, so Crit counts a little more from 25." },
    { forever = true, text = "WoW Forever: the Shadow Priest raid profile is re-simulated now that Twin Disciplines boosts Mind Flay and Shadow Word: Death. Crit counts a little more." },
    { forever = true, text = "WoW Forever: Rogue poisons now scale with Attack Power in the raid profiles, so Attack Power counts a little more next to Crit, Hit and weapon DPS." },
    { forever = true, text = "WoW Forever: Warrior leveling weights use the corrected Unbridled Wrath (1 rage, from white hits only), and the dungeon tank weights follow the current talent tree." },
    { forever = true, text = "WoW Forever: the Warrior and Paladin dungeon tank weights count Dodge, Parry, Block, Defense and Armor far less. Beta combat logs show the healing they save barely slows a run, so Hit, threat and Stamina come first." },
    { forever = true, text = "WoW Forever: Restoration Shaman dungeon healing counts Healing Stream Totem before Mana Spring arrives." },
    { forever = true, text = "WoW Forever: the Druid, Priest, Shaman and Paladin dungeon healer weights are rebuilt and checked against beta combat logs: low spell ranks lose bonus healing, trash hits the tank less and healers drink while the group loots. Crit counts more and Intellect less." },
    { forever = true, text = "WoW Forever: in the beta logs dungeon bosses are half as common and half as long as the dungeon weights assumed, and Retribution Paladins use Consecration far less than the model did. Retribution dungeon Spell Power counts about a third less (Judgement of the Crusader is assumed on bosses only); the other dungeon damage weights barely move." },
    { forever = true, text = "WoW Forever: the dungeon damage weights now assume the gear players actually wear in dungeons (from beta logs): better weapons and more Attack Power, so Crit and Hit count more for Arms, Daggers, Beast Mastery and Enhancement. Solo leveling keeps questing gear." },
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
