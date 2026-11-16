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
-- Forever client; classic = true lines only show on Era and TBC; era = true
-- lines only on Era (not Season of Discovery). Keep it
-- short: the full list lives in CHANGELOG.md.

local DISCORD_URL = "https://discord.gg/aYmhmtGxYs"

local WHATS_NEW = {
    -- v3.4.4
    { text = "Dungeon tanks: every tank is now measured in its own tank gear, with deaths and damage on other mobs in a pack matched to real Forever logs. The Paladin tank note says when to cast Consecration.", forever = true },
    { text = "Talents, Warlock dungeon builds: re-searched with a mana budget in groups (Life Tap between pulls, eaten back). Affliction and Destruction take Improved Life Tap and Cataclysm early for about 5% more damage.", forever = true },
    { text = "Dungeon weights: mana stats for Mage, Warlock, Shadow Priest, Hunters and Cat, and the Bear and Shaman tank weights, are now priced by the group models like the other classes'.", forever = true },
    { text = "Talents, Mage dungeon builds: re-checked in real leveling gear. All three keep their orders.", forever = true },
    { text = "Separate dungeon weights: Fury dual wield, the Rogue sword builds, Bear and the Shaman tank now have their own dungeon weights, so solo, PvP and farming weights stay as they were.", forever = true },
    { text = "Talents, Hunter dungeon builds: re-searched in real leveling gear. Beast Mastery and Survival got slightly faster orders; Marksmanship keeps its own.", forever = true },
    { text = "Talents, Rogue dungeon builds: re-searched in real leveling gear. Assassination and Combat with swords and Subtlety with daggers got slightly faster orders; the rest keep theirs.", forever = true },
    { text = "Talents, Warrior dungeon builds: re-searched in real leveling gear. Protection takes 16 points in Arms and gets Shield Slam at 49, about 2.5% faster; Arms and Fury keep their orders. The notes add Battle Shout.", forever = true },
    { text = "Warrior dungeon weights: measured on real leveling gear with Battle Shout. Protection tanks value block, dodge and Defense more from 40, and hit less.", forever = true },
    { text = "Talents, Priest dungeon builds: re-searched in real leveling gear with Divine Spirit. Discipline heals about 3% more; Shadow and Holy keep their orders.", forever = true },
    { text = "Priest dungeon weights: measured on real leveling gear with Fortitude and Divine Spirit. Healers value Spirit and Mp5 a little less.", forever = true },
    { text = "Talents, Shaman dungeon builds: re-searched in real leveling gear. Enhancement takes Improved Stormstrike at 30 for about 4% more damage, Restoration heals about 2% more, and Elemental keeps its order. The tank build now ends at 30. The notes name your totems.", forever = true },
    { text = "Shaman dungeon weights: measured on real leveling gear with your own totems. Enhancement values Mp5 and Spirit more in the 20s.", forever = true },
    { text = "Talents, Druid dungeon builds: re-searched in real leveling gear. Restoration takes Swiftmend at 40 (was 52) for about 1% more healing, and Bear got a slightly faster order; Cat and Balance keep theirs. The notes add Mark of the Wild, and Tiger's Fury for Cat.", forever = true },
    { text = "Druid dungeon weights: measured on real leveling gear with Mark of the Wild. Restoration healers value Intellect, crit and Mp5 more around 40.", forever = true },
    { text = "Talents, Paladin dungeon builds: re-searched in real leveling gear. Protection takes Retribution talents after 30 for about 3% more pulls per hour; Retribution and Holy keep their orders. Every note says which blessing to keep on yourself.", forever = true },
    { text = "Paladin dungeon weights: measured on real leveling gear with your own blessing. Protection tanks value Stamina, block and spell power more, and mana stats much less from 30.", forever = true },
    { text = "Progress: dungeon builds done for all 9 classes. PvP leveling builds come next. The full tracker is on the CurseForge page.", forever = true },
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
        if (not entry.forever or MSC.IsForever) and (not entry.classic or not MSC.IsForever)
            and (not entry.era or (MSC.IsEra and not MSC.IsSoD)) then
            lines[#lines + 1] = "|cffffd100-|r " .. L[entry.text]
        end
    end
    -- A release can be all Forever-only lines; don't show an empty list elsewhere. An empty
    -- WHATS_NEW (a version still being worked on, opened with /sgj whatsnew) says nothing about Forever.
    if #lines == 0 then
        local text = (#WHATS_NEW == 0) and L["Small fixes and improvements."]
            or L["Fixes and improvements for WoW Forever; nothing changed for your game version."]
        lines[1] = "|cffffd100-|r " .. text
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
        -- Nothing written yet for this version: don't pop up, and don't mark it seen, so it
        -- still opens once its list is filled in.
        if #WHATS_NEW == 0 then return end
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
