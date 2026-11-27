local _, MSC = ...

-- RestedXP keeps its settings in an AceDB (RXPSettings). AceDB keys the character as "Name - Realm" with the realm read
-- when AceDB loaded; on Forever GetRealmName() can be "" then and filled later (or the reverse), so match on the name
-- part too. A missing profile entry means AceDB's "Default" profile; a missing value means RXP's default (on).
local function RXPProfile()
    local sv = RXPSettings
    if type(sv) ~= "table" or type(sv.profileKeys) ~= "table" then return nil end
    local name = UnitName("player")
    local realm = GetRealmName() or ""
    local key = sv.profileKeys[name .. " - " .. realm]
    if not key then
        local prefix = name .. " - "
        for k, v in pairs(sv.profileKeys) do
            if k:sub(1, #prefix) == prefix and (realm == "" or k == prefix or k:sub(#prefix + 1) == realm) then key = v; break end
        end
        if not key then
            for k, v in pairs(sv.profileKeys) do if k:sub(1, #prefix) == prefix then key = v; break end end
        end
    end
    key = key or "Default"
    sv.profiles = sv.profiles or {}
    return sv.profiles[key], key
end

local function RXPItemUpgradesOn()
    local p = RXPProfile()
    if not p then return true end -- no saved changes: RXP defaults have Tips and Item Upgrade on
    return p.enableItemUpgrades ~= false and p.enableTips ~= false
end

StaticPopupDialogs["SGJ_DISABLE_RXP_GEAR"] = {
    text = MSC.L["|cff00FF00Sharpie's Gear Judge|r\n\nI see RestedXP is active.\n\nIt is currently showing its own gear tips.\n\nDo you want me to disable their **Item Upgrade** setting?"],
    button1 = MSC.L["Yes, Disable & Reload"],
    button2 = MSC.L["No, Keep Both"],

    OnAccept = function()
        local p, key = RXPProfile()
        if key then
            if not p then p = {}; RXPSettings.profiles[key] = p end
            p.enableItemUpgrades = false; ReloadUI()
        end
    end, timeout = 0, whileDead = true, hideOnEscape = false, preferredIndex = 3,
}

StaticPopupDialogs["SGJ_DISABLE_ZYGOR_GEAR"] = {
    text = MSC.L["|cff00FF00Sharpie's Gear Judge|r\n\nI see Zygor Guides is active.\n\nIt adds its own 'Gear Score' to tooltips.\n\nDo you want me to disable their **Auto Gear** system?"],
    button1 = MSC.L["Yes, Disable & Reload"], 
    button2 = MSC.L["No, Keep Both"],
    
    OnAccept = function()
        local Zygor = ZGV or ZygorGuidesViewer
        if Zygor and Zygor.db and Zygor.db.profile then
            Zygor.db.profile.autogear = false; Zygor.db.profile.itemscore_tooltips = false; ReloadUI()
        end
    end, timeout = 0, whileDead = true, hideOnEscape = false, preferredIndex = 3,
}

StaticPopupDialogs["SGJ_DISABLE_PAWN_TIPS"] = {
    text = MSC.L["|cff00FF00Sharpie's Gear Judge|r\n\nI see Pawn is active.\n\nFor conflict-free use, we recommend disabling **Pawn's Tooltip Upgrades** so they don't overlap with our Verdict.\n\nDisable Pawn tooltip info?"],
    button1 = MSC.L["Yes, Disable & Reload"], 
    button2 = MSC.L["No, Keep Both"],
    
    OnAccept = function()
        if PawnCommon then 
            PawnCommon.ShowUpgradesOnTooltips = false; ReloadUI() 
        else 
            print(MSC.L["|cff00FF00[SGJ]|r: Pawn settings not found yet."]) 
        end
    end, timeout = 0, whileDead = true, hideOnEscape = false, preferredIndex = 3,
}

local function CheckForConflicts()
    if SGJ_Settings and SGJ_Settings.DisableConflictCheck then return end

    if C_AddOns.IsAddOnLoaded("RestedXP") or C_AddOns.IsAddOnLoaded("RXPGuides") then
        if type(RXPSettings) == "table" and type(RXPSettings.profileKeys) == "table" then
            if RXPItemUpgradesOn() then StaticPopup_Show("SGJ_DISABLE_RXP_GEAR"); return end
        end
    end
    local Zygor = ZGV or ZygorGuidesViewer
    if Zygor and Zygor.db and Zygor.db.profile and (Zygor.db.profile.autogear ~= false or Zygor.db.profile.itemscore_tooltips ~= false) then
         StaticPopup_Show("SGJ_DISABLE_ZYGOR_GEAR"); return
    end
    if C_AddOns.IsAddOnLoaded("Pawn") and PawnCommon and PawnCommon.ShowUpgradesOnTooltips ~= false then
        StaticPopup_Show("SGJ_DISABLE_PAWN_TIPS")
    end
end

local loginFrame = CreateFrame("Frame")
loginFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
loginFrame:SetScript("OnEvent", function(self, event) 
    C_Timer.After(4, CheckForConflicts)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD") 
end)