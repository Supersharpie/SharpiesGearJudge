local addonName, MSC = ...
_G.MSC = MSC 

-- =============================================================
-- 1. INITIALIZATION & EVENTS
-- =============================================================
local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("PLAYER_LEVEL_UP")

EventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        
        -- [[ 1. INITIALIZE DATABASE ]]
        if MSC.BuildDatabase then MSC:BuildDatabase() end

        if not SGJ_Settings then SGJ_Settings = { Mode = "AUTO", MinimapPos = 45, TrackedSpecs = {} } end
        if SGJ_Settings.EnchantMode == nil then SGJ_Settings.EnchantMode = 1 end
        if SGJ_Settings.GemMode == nil then SGJ_Settings.GemMode = 1 end
        if not SGJ_Settings.TrackedSpecs then SGJ_Settings.TrackedSpecs = {} end
		
        -- [[ SYNC ENGINE WITH SAVED SETTING ]]
        MSC.ManualSpec = SGJ_Settings.Mode
		
        local version = MSC.IsEra and "Classic Era" or "TBC Edition"
        print("|cff00ff00Sharpie's Gear Judge|r ("..version..") Loaded. Type /sgj for menu.")
        
    elseif event == "PLAYER_LOGIN" then
        local IsLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
        if not SGJ_Settings.DisableConflictCheck and IsLoaded then
            if IsLoaded("Pawn") then print("|cffffd100SGJ Warning:|r 'Pawn' is loaded. Tooltips may look cluttered.") end
            if IsLoaded("ZygorGuidesViewer") then print("|cffffd100SGJ Warning:|r 'Zygor' detected. Ensure its item scoring is disabled.") end
        end
        
        local _, startSpec = MSC.GetCurrentWeights()
        MSC.LastActiveSpec = startSpec
        
    elseif event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LEVEL_UP" then
        MSC.CachedWeights = nil
        if MSCLabFrame and MSCLabFrame:IsShown() and MSC.UpdateLabCalc then 
            MSC.UpdateLabCalc() 
        end
    end
end)

SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    local cmd = msg:lower()
    
    if cmd == "debug" then
        MSC:DebugItem()
    elseif cmd == "options" or cmd == "config" then 
        if MSC.CreateOptionsFrame then MSC.CreateOptionsFrame() end 
    elseif cmd == "import" then
        if MSC.ShowImportWindow then MSC.ShowImportWindow() end
    else 
        if MSC.ToggleMainMenu then MSC.ToggleMainMenu() end 
    end 
end

-- =============================================================
-- 2. SMART SLOT LOGIC (Comparison)
-- =============================================================
function MSC.GetComparisonSlot(itemLink, equipLoc, weights, specName)
    local defaultSlot = MSC.SlotMap and MSC.SlotMap[equipLoc] or nil
    if not defaultSlot then return nil end

    if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" then
        local s1, s2 = 11, 12
        if equipLoc == "INVTYPE_TRINKET" then s1, s2 = 13, 14 end
        
        local l1 = GetInventoryItemLink("player", s1)
        local l2 = GetInventoryItemLink("player", s2)
        
        if not l1 then return s1 end
        if not l2 then return s2 end
        
        if itemLink == l1 then return s2 end
        if itemLink == l2 then return s1 end

        local stats1 = MSC.SafeGetItemStats(l1, s1, weights, specName)
        local stats2 = MSC.SafeGetItemStats(l2, s2, weights, specName)
        local score1 = MSC.GetItemScore(stats1, weights, specName, s1)
        local score2 = MSC.GetItemScore(stats2, weights, specName, s2)
        
        return (score2 < score1) and s2 or s1
    end

    if equipLoc == "INVTYPE_WEAPON" then
        local _, class = UnitClass("player")
        local canDW = (class == "WARRIOR" or class == "ROGUE" or class == "HUNTER" or class == "SHAMAN")
        
        if canDW then
            local l1 = GetInventoryItemLink("player", 16)
            local l2 = GetInventoryItemLink("player", 17)
            
            if l1 and l2 then
                local _,_,_,_,_,_,_,_, loc2 = GetItemInfo(l2)
                if loc2 == "INVTYPE_WEAPON" or loc2 == "INVTYPE_WEAPONOFFHAND" then
                    local stats1 = MSC.SafeGetItemStats(l1, 16, weights, specName)
                    local stats2 = MSC.SafeGetItemStats(l2, 17, weights, specName)
                    local score1 = MSC.GetItemScore(stats1, weights, specName, 16)
                    local score2 = MSC.GetItemScore(stats2, weights, specName, 17)
                    
                    return (score2 < score1) and 17 or 16
                end
            end
        end
    end

    return defaultSlot
end

-- =============================================================
-- HELPER: GET WEIGHTS BY NAME (FOR OFF-SPEC TRACKING)
-- =============================================================
function MSC.GetWeightsByName(profileName)
    if not MSC.CurrentClass then return nil end
    if MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[profileName] then return MSC.CurrentClass.Weights[profileName] end
    if MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[profileName] then return MSC.CurrentClass.LevelingWeights[profileName] end
    if MSC.CurrentClass.Profiles and MSC.CurrentClass.Profiles[profileName] then return MSC.CurrentClass.Profiles[profileName] end
    return nil
end

-- =============================================================
-- 3. STAT CALCULATOR (The Breakdown Display)
-- =============================================================
function MSC.ExpandDerivedStats(baseStats, itemLink, outTable)
    wipe(outTable or {})
    local dest = outTable or {}
    
    -- 1. Copy raw stats
    -- [FIX] Added safety check to prevent crash if baseStats is nil
    if baseStats then
        for k, v in pairs(baseStats) do dest[k] = v end
    end

    local _, class = UnitClass("player")
    local function Rank(name) return (MSC.GetTalentRank and MSC:GetTalentRank(name)) or 0 end

    -- === A. STAMINA -> HEALTH ===
    local stam = dest["ITEM_MOD_STAMINA_SHORT"] or 0
    if stam > 0 then
        local hpPerStam = 10; if class == "TAUREN" then hpPerStam = 10.5 end
        if class == "DRUID" then local r = Rank("HEART_OF_THE_WILD"); if r > 0 then hpPerStam = hpPerStam * (1 + (0.04 * r)) end end
        dest["ITEM_MOD_HEALTH_SHORT"] = (dest["ITEM_MOD_HEALTH_SHORT"] or 0) + (stam * hpPerStam)
    end

    -- === B. INTELLECT -> MANA, SP, SPELL CRIT ===
    local int = dest["ITEM_MOD_INTELLECT_SHORT"] or 0
    if int > 0 then
        -- 1. Mana
        local manaPerInt = 15; if class == "GNOME" then manaPerInt = 15.75 end
        dest["ITEM_MOD_MANA_SHORT"] = (dest["ITEM_MOD_MANA_SHORT"] or 0) + (int * manaPerInt)

        -- 2. Spell Power (Talents)
        if class == "PALADIN" then local r=Rank("HOLY_GUIDANCE"); if r>0 then dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+(int*(0.07*r)) end end
        if class == "SHAMAN" then local r=Rank("NATURES_BLESSING"); if r>0 then local b=int*(0.10*r); dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+b; dest["ITEM_MOD_HEALING_POWER_SHORT"]=(dest["ITEM_MOD_HEALING_POWER_SHORT"] or 0)+b end end
        if class == "DRUID" then local r=Rank("LUNAR_GUIDANCE"); if r>0 then dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+(int*(0.0833*r)) end end
        if class == "MAGE" then local r=Rank("MIND_MASTERY"); if r>0 then dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+(int*(0.05*r)) end end

        -- 3. Spell Crit (Version Branch)
        if MSC.IsEra then
            -- VANILLA: Roughly 59.5 Int = 1% Crit (Mage), others vary. Using ~60 as generic.
            local critPercent = int / 60
            dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] or 0) + critPercent
        else
            -- TBC: Returns RATING.
            local intPerPercent = (class == "WARLOCK") and 82 or 80
            local critPerInt = 22.1 / intPerPercent
            dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] or 0) + (int * critPerInt)
        end
    end

    -- === C. AGILITY -> CRIT, DODGE, ARMOR ===
    local agi = dest["ITEM_MOD_AGILITY_SHORT"] or 0
    if agi > 0 then
        -- 1. Crit Rating (Physical)
        if MSC.IsEra then
            -- VANILLA: Hunter/Rogue 29/20 Agi = 1%. War/Pal 20 Agi = 1%.
            local div = 20
            if class == "HUNTER" then div = 53 elseif class == "ROGUE" then div = 29 end
            local critPercent = agi / div
            dest["ITEM_MOD_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + critPercent
        else
            -- TBC: Returns RATING.
            local agiPerPercent = (class == "HUNTER" or class == "ROGUE") and 40 or 25
            local critPerAgi = 22.1 / agiPerPercent
            dest["ITEM_MOD_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + (agi * critPerAgi)
        end

        -- 2. Dodge Rating
        if not MSC.IsEra then
            -- TBC Only (Era handles Dodge% via API mostly)
            local dodgeDiv = 25
            if class == "HUNTER" then dodgeDiv = 26 elseif class == "ROGUE" then dodgeDiv = 20 elseif class == "DRUID" then dodgeDiv = 14.7 end
            local dodgePerAgi = 18.9 / dodgeDiv
            dest["ITEM_MOD_DODGE_RATING_SHORT"] = (dest["ITEM_MOD_DODGE_RATING_SHORT"] or 0) + (agi * dodgePerAgi)
        end
    end

    -- === D. STRENGTH -> BLOCK VALUE ===
    local str = dest["ITEM_MOD_STRENGTH_SHORT"] or 0
    if str > 0 and (class == "WARRIOR" or class == "PALADIN") then
        dest["ITEM_MOD_BLOCK_VALUE_SHORT"] = (dest["ITEM_MOD_BLOCK_VALUE_SHORT"] or 0) + (str * 0.5)
    end

    -- === E. SPIRIT -> SPELL POWER ===
    local spt = dest["ITEM_MOD_SPIRIT_SHORT"] or 0
    if spt > 0 then
        if class == "PRIEST" then local r=Rank("SPIRITUAL_GUIDANCE"); if r>0 then local b=spt*(0.05*r); dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+b; dest["ITEM_MOD_HEALING_POWER_SHORT"]=(dest["ITEM_MOD_HEALING_POWER_SHORT"] or 0)+b end end
    end
	
	-- === F. ATTACK POWER ===
    local apFromStr = 0
    local apFromAgi = 0
    
    -- 1. Strength -> AP
    if class == "WARRIOR" or class == "PALADIN" or class == "SHAMAN" or class == "DRUID" then
        apFromStr = str * 2 
    elseif class == "ROGUE" or class == "HUNTER" then
        apFromStr = str * 1
    end

    -- 2. Agility -> AP
    if class == "ROGUE" or class == "HUNTER" or class == "DRUID" then
        -- Note: Hunters get 1 Melee AP and 1 Ranged AP per Agi. 
        -- We effectively just display "Attack Power" here to keep it simple.
        apFromAgi = agi * 1
    end
    
    -- 3. Apply
    local totalAP = apFromStr + apFromAgi
    if totalAP > 0 then
        dest["ITEM_MOD_ATTACK_POWER_SHORT"] = (dest["ITEM_MOD_ATTACK_POWER_SHORT"] or 0) + totalAP
        
        -- Special Case: Hunters also get Ranged AP from Agi/Int (Careful Aim)
        if class == "HUNTER" then
            dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = (dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] or 0) + totalAP
            
            -- Careful Aim (Int -> RAP)
            local r = Rank("CAREFUL_AIM")
            if r > 0 then
                local int = dest["ITEM_MOD_INTELLECT_SHORT"] or 0
                if int > 0 then
                    local rapFromInt = int * (0.15 * r) -- 15/30/45%
                    dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = dest["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] + rapFromInt
                end
            end
        end
    end

    return dest
end

-- =============================================================
-- 4. TOOLTIP ENGINE (Consolidated)
-- =============================================================
MSC.IsCalculating = false
local Scratch_Tooltip_New = {}
local Scratch_Tooltip_Old = {}
local Scratch_Tooltip_Diffs = {}
local TEX_UP = "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Upgrade.png:14:14:0:-2|t"
local TEX_DOWN = "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Downgrade.png:14:14:0:-2|t"

-- [[ CONFIG: CONSOLIDATION DISABLED ]]
-- We purposefully empty this table so the Bouncer can see the raw stats
local STAT_CONSOLIDATION_MAP = {} 

local function OnTooltipSetItem(tooltip)
    if MSC.IsCalculating then return end
    if tooltip:GetName() and string.find(tooltip:GetName(), "MSC_ScannerTooltip") then return end
    if SGJ_Settings and SGJ_Settings.HideTooltips then return end
    
    local _, link = nil, nil
    if tooltip.GetItem then _, link = tooltip:GetItem() end
    if not link or not IsEquippableItem(link) then return end
    if link and not MSC.IsItemUsable(link) then return end

    MSC.IsCalculating = true
    local _, playerClass = UnitClass("player")
    
    -- Class Load Safety
    if not MSC.CurrentClass or MSC.CurrentClass.Name ~= playerClass then
        -- This logic assumes Classes are loaded. If not, we wait.
        MSC.IsCalculating = false
        return
    end

    local status, err = pcall(function()
        local weights, specName = MSC.GetCurrentWeights()
        if not weights or not next(weights) then return end
        local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
        
        local slotId = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
        if not slotId then return end

        local newScore, oldScore, newStats, oldStats, newTotalColors = MSC:EvaluateUpgrade(link, slotId, weights, specName)
        local delta = newScore - oldScore
        local isEquipped = (GetInventoryItemLink("player", slotId) == link)

        -- Header
        tooltip:AddLine(" ")
        local scoreLabel = "Judge's Score:"
        if newStats and newStats.Context then scoreLabel = scoreLabel .. " " .. newStats.Context end
        tooltip:AddDoubleLine(scoreLabel, string.format("|cffffffff%.1f|r", newScore), 1, 0.82, 0)
        
        local displayName = specName
        if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[specName] then displayName = MSC.CurrentClass.PrettyNames[specName] end
        
        -- Cap Info
        local _, _, capInfo = MSC.GetCurrentWeights()
        if capInfo then displayName = displayName .. " |cff00ff00(" .. capInfo .. " Capped)|r" end
        tooltip:AddDoubleLine("Verdict Profile:", "|cff00ccff" .. displayName .. "|r", 1, 0.82, 0)

        if not isEquipped then
            if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" then
                local comparedItemLink = GetInventoryItemLink("player", slotId)
                if comparedItemLink then tooltip:AddDoubleLine("vs.", comparedItemLink, 0.6, 0.6, 0.6, 1, 1, 1) end
            end
		if link then
                local itemID = tonumber(link:match("item:(%d+)"))
                local noteDisplayed = false

                -- 1. CLASS SPECIFIC CHECK (Relics/Totems/Idols)
                if MSC.CurrentClass then
                    local classDB = MSC.CurrentClass.Relics or MSC.CurrentClass.Totems or MSC.CurrentClass.Idols
                    
                    if classDB and classDB[itemID] then
                        local dbStats = classDB[itemID]
                        local statStr = ""
                        
                        -- A. PARSE STATS (Cyan Text)
                        for key, val in pairs(dbStats) do
                            if key ~= "note" and type(val) == "number" and val > 0 then
                                local name = (MSC.ShortNames and MSC.ShortNames[key]) 
                                if not name then
                                    name = key:gsub("ITEM_MOD_", ""):gsub("_SHORT", ""):gsub("_", " "):lower()
                                end
                                if statStr ~= "" then statStr = statStr .. ", " end
                                statStr = statStr .. string.format("+%d %s", val, name)
                            end
                        end
                        
                        if statStr ~= "" then
                            tooltip:AddLine(" ")
                            tooltip:AddLine("Class Bonus: " .. statStr, 0, 1, 1, true) 
                        end
                        
                        -- B. PARSE NOTE (Gradient: Light Purple -> Epic Purple)
                        if dbStats.note then
                            tooltip:AddDoubleLine("Judge's Note:", dbStats.note, 0.85, 0.6, 1.0, 0.64, 0.21, 0.93)
                            noteDisplayed = true
                        end
                    end
                end

                -- 2. GLOBAL DATABASE CHECKS (If no class note was shown)
                if not noteDisplayed then
                    local entry = nil
                    
                    -- Define Gradient Colors (Left RGB, Right RGB)
                    -- Default: Light Purple -> Epic Purple
                    local cL = {r=0.85, g=0.6, b=1.0}
                    local cR = {r=0.64, g=0.21, b=0.93}

                    if MSC.PvPDB and MSC.PvPDB[itemID] then
                        entry = MSC.PvPDB[itemID]
                        -- PvP: Pink -> Red
                        cL = {r=1.0, g=0.6, b=0.6}; cR = {r=1.0, g=0.2, b=0.2} 
                    elseif MSC.WeaponDB and MSC.WeaponDB[itemID] then
                        entry = MSC.WeaponDB[itemID]
                        -- Weapons: Light Orange -> Deep Orange
                        cL = {r=1.0, g=0.8, b=0.4}; cR = {r=1.0, g=0.5, b=0.0} 
                    elseif MSC.TrinketDB and MSC.TrinketDB[itemID] then
                        entry = MSC.TrinketDB[itemID]
                        -- Trinkets: Keep Purple Gradient
                    elseif MSC.ProcDB and MSC.ProcDB[itemID] then
                        entry = MSC.ProcDB[itemID]
                        -- Procs: Keep Purple Gradient
                    end

                    if entry and entry.note then
                        tooltip:AddLine(" ")
                        tooltip:AddDoubleLine("Judge's Note:", entry.note, cL.r, cL.g, cL.b, cR.r, cR.g, cR.b)
                    end
                end
			end
			
            local percentDiff = 0; if oldScore > 0 then percentDiff = ((newScore - oldScore) / oldScore) * 100 end
            if delta > 0.1 then tooltip:AddLine(string.format("|cff00ff00%s Upgrade (+%.1f / +%.1f%%)|r", TEX_UP, delta, percentDiff))
            elseif delta < -0.1 then tooltip:AddLine(string.format("|cffff0000%s Downgrade (%.1f / %.1f%%)|r", TEX_DOWN, delta, percentDiff))
            else tooltip:AddLine("|cff888888= Sidegrade (0.0)|r") end
        else tooltip:AddLine("|cff00ffff*** EQUIPPED ***|r") end

        -- [[ MULTI-SPEC TRACKING ]]
        if SGJ_Settings.TrackedSpecs and next(SGJ_Settings.TrackedSpecs) then
            for tSpec, isActive in pairs(SGJ_Settings.TrackedSpecs) do
                if isActive and tSpec ~= specName then
                    local tWeights = MSC.GetWeightsByName(tSpec)
                    if tWeights then
                        -- Check for comparison slot again for this specific spec (in case 1H vs 2H logic differs)
                        local tSlotId = MSC.GetComparisonSlot(link, equipLoc, tWeights, tSpec)
                        if tSlotId then
                            local tNewScore, tOldScore = MSC:EvaluateUpgrade(link, tSlotId, tWeights, tSpec)
                            local tDelta = tNewScore - tOldScore
                            
                            -- Only show UPGRADES to prevent clutter
                            if tDelta > 0.1 then
                                local prettySpec = (MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[tSpec]) or tSpec
                                tooltip:AddDoubleLine("|cff00ccff" .. prettySpec .. ":|r", string.format("|cff00ff00+%s (Upgrade)|r", math.floor(tDelta)), 1, 1, 1, 1, 1, 1)
                            end
                        end
                    end
                end
            end
        end

        -- Projections (TBC Only for Gems/Metas)
        if newStats and (newStats.IS_PROJECTED or newStats.GEMS_PROJECTED) then
            tooltip:AddLine(" ")
            
            -- 1. ENCHANT NAME
            if newStats.ENCHANT_TEXT then 
                tooltip:AddDoubleLine("Projected Enchant:", "|cffffffff" .. newStats.ENCHANT_TEXT .. "|r", 0, 1, 1)
            elseif newStats.IS_PROJECTED then 
                tooltip:AddDoubleLine("Projected Enchant:", "|cffffffffBest Available|r", 0, 1, 1) 
            end
            
            -- 2. GEM NAMES (TBC ONLY)
            if not MSC.IsEra and newStats.GEM_TEXT then
                tooltip:AddDoubleLine("Projected Gems:", "|cffffffff" .. newStats.GEM_TEXT .. "|r", 0, 1, 1)
            end

            -- 3. BONUSES
            if newStats.BONUS_PROJECTED then tooltip:AddLine("   + Socket Bonus Activated", 0, 1, 0) end
            
            if not MSC.IsEra and newStats.META_ID and MSC.CheckMetaRequirements and newTotalColors then 
                if MSC:CheckMetaRequirements(newStats.META_ID, newTotalColors) then 
                    tooltip:AddLine("   + Meta Gem Active", 0, 1, 0) 
                else 
                    tooltip:AddLine("   - Meta Gem Inactive (Reqs unmet)", 1, 0, 0) 
                end 
            end
        end

        -- STAT COMPARISON
        if not isEquipped then
            -- [FIX] Added 'or {}' to prevent crashes if Evaluator returns nil
            local newExpanded = MSC.ExpandDerivedStats(newStats or {}, link, Scratch_Tooltip_New)
            local oldExpanded = MSC.ExpandDerivedStats(oldStats or {}, nil, Scratch_Tooltip_Old)
            local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded, Scratch_Tooltip_Diffs)

            -- [[ CONSOLIDATION PASS SKIPPED ]]
            
            local gains, losses = {}, {}
            for _, d in ipairs(diffs) do
                if math.abs(d.val) > 0.1 then
                    -- [[ THE BOUNCER ]]
                    -- This ensures we only see stats that actually matter to our score
                    local w = weights[d.key] or 0
                    if w > 0.02 then
                        if d.val > 0 then table.insert(gains, d) else table.insert(losses, d) end 
                    end
                end
            end

            local function StableSort(a, b) local wA=(weights[a.key]or 0); local wB=(weights[b.key]or 0); if wA==wB then return a.key<b.key end; return wA>wB end
            table.sort(gains, StableSort); table.sort(losses, StableSort)

            local function PrintList(label, list, cR, cG, cB)
                local hp, lp = false, 0
                for _, d in ipairs(list) do
                    if lp < 8 then 
                        if not hp then tooltip:AddLine(label, cR, cG, cB); hp = true end
                        
                        -- [[ 1. CLEAN NAME ]]
                        local name = (MSC.GetCleanStatName(d.key) or d.key)
                        
                        -- [[ 2. APPEND PERCENTAGE ]]
                        local level = UnitLevel("player")
                        if MSC.GetRatingPercent then
                             local percentVal = MSC:GetRatingPercent(d.key, math.abs(d.val), level)
                             if percentVal and percentVal > 0.01 then
                                 name = name .. string.format(" |cff888888(%.2f%%)|r", percentVal)
                             end
                        end

                        -- [[ 3. APPEND SUFFIX ]]
                        name = name .. (d.nameSuffix or "")
                        
                        -- [[ 4. FORMAT VALUE ]]
                        local valStr = (d.val%1==0) and string.format("%d", math.abs(d.val)) or string.format("%.1f", math.abs(d.val))
                        if cR==0 then valStr="+"..valStr else valStr="-"..valStr end
                        
                        tooltip:AddDoubleLine("  " .. name, valStr, 1, 1, 1, cR, cG, cB)
                        lp = lp + 1
                    end
                end
            end

            PrintList("Gains:", gains, 0, 1, 0)
            PrintList("Losses:", losses, 1, 0, 0)

        end
		
        tooltip:Show()
    end)
    MSC.IsCalculating = false
    if not status then geterrorhandler()(err) end
end

-- Hooks
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
if ShoppingTooltip1 then ShoppingTooltip1:HookScript("OnTooltipSetItem", OnTooltipSetItem) end
if ShoppingTooltip2 then ShoppingTooltip2:HookScript("OnTooltipSetItem", OnTooltipSetItem) end