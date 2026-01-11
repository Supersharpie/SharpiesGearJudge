local addonName, MSC = ...
_G[addonName] = MSC

-- =============================================================
-- 1. INITIALIZATION & EVENTS
-- =============================================================
local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("PLAYER_TALENT_UPDATE") 
EventFrame:RegisterEvent("PLAYER_LEVEL_UP")

EventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        if not SGJ_Settings then SGJ_Settings = { Mode = "AUTO", MinimapPos = 45 } end
        if SGJ_Settings.EnchantMode == nil then SGJ_Settings.EnchantMode = 1 end
        if SGJ_Settings.GemMode == nil then SGJ_Settings.GemMode = 1 end
        print("|cff00ff00Sharpie's Gear Judge|r (TBC Edition) Loaded. Type /sgj for menu.")
        
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
        
    elseif event == "PLAYER_TALENT_UPDATE" then
        MSC.CachedWeights = nil
        if MSC.BuildTalentCache then MSC:BuildTalentCache() end
        
        local _, newSpecName = MSC.GetCurrentWeights()
        
        if MSC.LastActiveSpec and MSC.LastActiveSpec ~= newSpecName then
             local displayName = newSpecName
             if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[newSpecName] then
                 displayName = MSC.CurrentClass.PrettyNames[newSpecName]
             end
             print("|cff00ccffSharpie's Gear Judge:|r Spec change detected. Active Profile: " .. displayName)
        end
        MSC.LastActiveSpec = newSpecName
        
        if MSCLabFrame and MSCLabFrame:IsShown() and MSC.UpdateLabCalc then 
            MSC.UpdateLabCalc() 
        end
    end
end)

SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    if msg == "options" or msg == "config" then 
        if MSC.CreateOptionsFrame then MSC.CreateOptionsFrame() end 
    else 
        if MSC.ToggleMainMenu then MSC.ToggleMainMenu() end 
    end 
end

-- =============================================================
-- 2. WEIGHT DISPATCHER
-- =============================================================
MSC.CachedWeights = nil
MSC.CachedProfile = nil
MSC.CachedCapText = nil

function MSC.GetCurrentWeights()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" and MSC.ManualSpec ~= "Auto" then
        if MSC.CurrentClass then
            if MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[MSC.ManualSpec] then
                return MSC.CurrentClass.Weights[MSC.ManualSpec], MSC.ManualSpec, nil
            elseif MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[MSC.ManualSpec] then
                return MSC.CurrentClass.LevelingWeights[MSC.ManualSpec], MSC.ManualSpec, nil
            end
        end
    end

    if MSC.CachedWeights then return MSC.CachedWeights, MSC.CachedProfile, MSC.CachedCapText end

    if MSC.CurrentClass then
        local specKey = MSC.CurrentClass:GetSpec()
        local weights = nil
        
        if MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[specKey] then
            weights = MSC.CurrentClass.LevelingWeights[specKey]
        elseif MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[specKey] then
            weights = MSC.CurrentClass.Weights[specKey]
        end
        
        local capText = nil
        if weights and MSC.CurrentClass.ApplyScalers then
            weights = MSC:SafeCopy(weights) 
            weights, capText = MSC.CurrentClass:ApplyScalers(weights, specKey)
        end
        
        if weights then
            MSC.CachedWeights = weights
            MSC.CachedProfile = specKey
            MSC.CachedCapText = capText
            return weights, specKey, capText
        end
    end
    return {}, "Unknown", nil
end

-- =============================================================
-- 3. HELPER: CLEAN STAT NAMES
-- =============================================================
local function GetCleanStatName(key, expandedStats)
    local name = MSC.GetCleanStatName and MSC.GetCleanStatName(key) or key
    if key == "ITEM_MOD_HEALTH_SHORT" and (expandedStats["ITEM_MOD_STAMINA_SHORT"] or 0) > 0 then name = "Health (w/ Stam)" end
    if key == "ITEM_MOD_MANA_SHORT" and (expandedStats["ITEM_MOD_INTELLECT_SHORT"] or 0) > 0 then name = "Mana (w/ Int)" end
    if key == "ITEM_MOD_ATTACK_POWER_SHORT" and ((expandedStats["ITEM_MOD_STRENGTH_SHORT"] or 0) > 0 or (expandedStats["ITEM_MOD_AGILITY_SHORT"] or 0) > 0) then name = "Atk Power (Total)" end
    return name
end

-- =============================================================
-- 4. SMART SLOT LOGIC
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
-- 5. STAT CALCULATOR (The Complete Breakdown)
-- =============================================================
function MSC.ExpandDerivedStats(baseStats, itemLink, outTable)
    wipe(outTable or {})
    local dest = outTable or {}
    
    -- 1. Copy raw stats
    for k, v in pairs(baseStats) do dest[k] = v end

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

        -- 3. Spell Crit Rating (Approx TBC Conversion: 22.1 Rating = 1% Crit)
        -- Most Classes: 80 Int = 1% Crit. Warlock: 82 Int = 1%.
        local intPerPercent = 80
        if class == "WARLOCK" then intPerPercent = 82 end
        local critPerInt = 22.1 / intPerPercent
        dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] or 0) + (int * critPerInt)
    end

    -- === C. AGILITY -> CRIT, DODGE, ARMOR ===
    local agi = dest["ITEM_MOD_AGILITY_SHORT"] or 0
    if agi > 0 then
        -- 1. Crit Rating (Physical)
        -- Hunter/Rogue: 40 Agi = 1% Crit. Others: 25 Agi = 1% Crit.
        local agiPerPercent = 25
        if class == "HUNTER" or class == "ROGUE" then agiPerPercent = 40 end
        local critPerAgi = 22.1 / agiPerPercent
        dest["ITEM_MOD_CRIT_RATING_SHORT"] = (dest["ITEM_MOD_CRIT_RATING_SHORT"] or 0) + (agi * critPerAgi)

        -- 2. Dodge Rating (Approx TBC: 18.9 Rating = 1% Dodge)
        -- Hunter: 26 Agi=1%. Rogue: 20 Agi=1%. Druid: 14.7 Agi=1%. Pal/War: 25 Agi=1%.
        local dodgeDiv = 25
        if class == "HUNTER" then dodgeDiv = 26 elseif class == "ROGUE" then dodgeDiv = 20 elseif class == "DRUID" then dodgeDiv = 14.7 end
        local dodgePerAgi = 18.9 / dodgeDiv
        dest["ITEM_MOD_DODGE_RATING_SHORT"] = (dest["ITEM_MOD_DODGE_RATING_SHORT"] or 0) + (agi * dodgePerAgi)
    end

    -- === D. STRENGTH -> BLOCK VALUE ===
    local str = dest["ITEM_MOD_STRENGTH_SHORT"] or 0
    if str > 0 and (class == "WARRIOR" or class == "PALADIN") then
        -- 20 Str = 10 Block Value -> 0.5 per Str
        dest["ITEM_MOD_BLOCK_VALUE_SHORT"] = (dest["ITEM_MOD_BLOCK_VALUE_SHORT"] or 0) + (str * 0.5)
    end

    -- === E. SPIRIT -> SPELL POWER ===
    local spt = dest["ITEM_MOD_SPIRIT_SHORT"] or 0
    if spt > 0 then
        if class == "PRIEST" then local r=Rank("SPIRITUAL_GUIDANCE"); if r>0 then local b=spt*(0.05*r); dest["ITEM_MOD_SPELL_POWER_SHORT"]=(dest["ITEM_MOD_SPELL_POWER_SHORT"] or 0)+b; dest["ITEM_MOD_HEALING_POWER_SHORT"]=(dest["ITEM_MOD_HEALING_POWER_SHORT"] or 0)+b end end
    end

    return dest
end

-- =============================================================
-- 6. TOOLTIP ENGINE (Consolidated)
-- =============================================================
MSC.IsCalculating = false
local Scratch_Tooltip_New = {}
local Scratch_Tooltip_Old = {}
local Scratch_Tooltip_Diffs = {}
local TEX_UP = "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Upgrade.png:14:14:0:-2|t"
local TEX_DOWN = "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Downgrade.png:14:14:0:-2|t"

-- CONFIG: Which stats to hide because they are merged into others?
local STAT_CONSOLIDATION_MAP = {
    ["ITEM_MOD_STAMINA_SHORT"] = "ITEM_MOD_HEALTH_SHORT",
    ["ITEM_MOD_INTELLECT_SHORT"] = "ITEM_MOD_MANA_SHORT", 
    -- Note: We generally DON'T hide Str/Agi completely because they give multiple stats (Armor/AP/Crit).
    -- But we will merge them into AP for clean display if desired.
    ["ITEM_MOD_STRENGTH_SHORT"] = "ITEM_MOD_ATTACK_POWER_SHORT", 
    -- Agility is too complex to hide (gives Armor/Crit/Dodge/AP). We keep it visible usually.
    -- Uncomment below if you REALLY want to hide Agi and just show the breakdown.
    -- ["ITEM_MOD_AGILITY_SHORT"] = "ITEM_MOD_ATTACK_POWER_SHORT", 
}

local function OnTooltipSetItem(tooltip)
    if MSC.IsCalculating then return end
    if tooltip:GetName() and string.find(tooltip:GetName(), "MSC_ScannerTooltip") then return end
    if SGJ_Settings and SGJ_Settings.HideTooltips then return end
    local _, link = nil, nil
    if tooltip.GetItem then _, link = tooltip:GetItem() end
    if not link or not IsEquippableItem(link) then return end

    MSC.IsCalculating = true
    local _, playerClass = UnitClass("player")
    -- Class Load Safety
    if not MSC.CurrentClass or MSC.CurrentClass.Name ~= playerClass then
        if playerClass == "DRUID" then MSC.CurrentClass = Druid
        elseif playerClass == "HUNTER" then MSC.CurrentClass = Hunter
        elseif playerClass == "SHAMAN" then MSC.CurrentClass = Shaman
        elseif playerClass == "PALADIN" then MSC.CurrentClass = Paladin
        elseif playerClass == "MAGE" then MSC.CurrentClass = Mage
        elseif playerClass == "PRIEST" then MSC.CurrentClass = Priest
        elseif playerClass == "ROGUE" then MSC.CurrentClass = Rogue
        elseif playerClass == "WARRIOR" then MSC.CurrentClass = Warrior
        elseif playerClass == "WARLOCK" then MSC.CurrentClass = Warlock
        end
        MSC.CachedWeights = nil
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
        if newStats.Context then scoreLabel = scoreLabel .. " " .. newStats.Context end
        tooltip:AddDoubleLine(scoreLabel, string.format("|cffffffff%.1f|r", newScore), 1, 0.82, 0)
        local displayName = specName
        if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[specName] then displayName = MSC.CurrentClass.PrettyNames[specName] end
        local _, _, capInfo = MSC.GetCurrentWeights()
        if capInfo then displayName = displayName .. " |cff00ff00(" .. capInfo .. " Capped)|r" end
        tooltip:AddDoubleLine("Verdict Profile:", "|cff00ccff" .. displayName .. "|r", 1, 0.82, 0)

        if not isEquipped then
            if equipLoc == "INVTYPE_FINGER" or equipLoc == "INVTYPE_TRINKET" then
                local comparedItemLink = GetInventoryItemLink("player", slotId)
                if comparedItemLink then tooltip:AddDoubleLine("vs.", comparedItemLink, 0.6, 0.6, 0.6, 1, 1, 1) end
            end
            local percentDiff = 0; if oldScore > 0 then percentDiff = ((newScore - oldScore) / oldScore) * 100 end
            if delta > 0.1 then tooltip:AddLine(string.format("|cff00ff00%s Upgrade (+%.1f / +%.1f%%)|r", TEX_UP, delta, percentDiff))
            elseif delta < -0.1 then tooltip:AddLine(string.format("|cffff0000%s Downgrade (%.1f / %.1f%%)|r", TEX_DOWN, delta, percentDiff))
            else tooltip:AddLine("|cff888888= Sidegrade (0.0)|r") end
        else tooltip:AddLine("|cff00ffff*** CURRENTLY EQUIPPED ***|r") end

        -- Projections
        if newStats.IS_PROJECTED or newStats.GEMS_PROJECTED then
            tooltip:AddLine(" ")
            
            -- 1. ENCHANT NAME
            if newStats.ENCHANT_TEXT then 
                tooltip:AddDoubleLine("Projected Enchant:", "|cffffffff" .. newStats.ENCHANT_TEXT .. "|r", 0, 1, 1)
            elseif newStats.IS_PROJECTED then 
                tooltip:AddDoubleLine("Projected Enchant:", "|cffffffffBest Available|r", 0, 1, 1) 
            end
            
            -- 2. GEM NAMES (Shopping List - Fixed for IDs)
            if newStats.GEM_TEXT then
                local gemCounts = {}
                local gemOrder = {}
                local foundAny = false

                -- A. Try parsing the pre-filled text if valid (Fallback)
                for gemName in string.gmatch(newStats.GEM_TEXT, "([^,]+)") do
                    gemName = strtrim(gemName)
                    -- Filter out the generic "1x Stat" garbage we used to generate
                    if gemName and gemName ~= "" and not string.find(gemName, "1x") then
                        if not gemCounts[gemName] then
                            table.insert(gemOrder, gemName)
                            gemCounts[gemName] = 0
                        end
                        gemCounts[gemName] = gemCounts[gemName] + 1
                        foundAny = true
                    end
                end

                -- B. MAIN LOGIC: Look up the IDs exported by Helpers.lua
                if not foundAny and newStats.PROJECTED_GEM_IDS then 
                    for _, gemID in ipairs(newStats.PROJECTED_GEM_IDS) do
                         local name = GetItemInfo(gemID) -- Ask WoW for the real name
                         if name then
                             if not gemCounts[name] then
                                 table.insert(gemOrder, name)
                                 gemCounts[name] = 0
                             end
                             gemCounts[name] = gemCounts[name] + 1
                             foundAny = true
                         end
                    end
                end

                if foundAny then
                    local parts = {}
                    for _, name in ipairs(gemOrder) do
                        if gemCounts[name] > 1 then
                            table.insert(parts, string.format("%dx %s", gemCounts[name], name))
                        else
                            table.insert(parts, name)
                        end
                    end
                    local finalGemStr = table.concat(parts, ", ")
                    if string.len(finalGemStr) > 55 then finalGemStr = string.sub(finalGemStr, 1, 52) .. "..." end
                    
                    tooltip:AddDoubleLine("Projected Gems:", "|cffffffff" .. finalGemStr .. "|r", 0, 1, 1)
                end
            end

            -- 3. BONUSES
            if newStats.BONUS_PROJECTED then tooltip:AddLine("   + Socket Bonus Activated", 0, 1, 0) end
            if newStats.META_ID and MSC.CheckMetaRequirements and newTotalColors then 
                if MSC:CheckMetaRequirements(newStats.META_ID, newTotalColors) then 
                    tooltip:AddLine("   + Meta Gem Active", 0, 1, 0) 
                else 
                    tooltip:AddLine("   - Meta Gem Inactive (Reqs unmet)", 1, 0, 0) 
                end 
            end
        end

        -- STAT COMPARISON
        if not isEquipped then
            local newExpanded = MSC.ExpandDerivedStats(newStats, link, Scratch_Tooltip_New)
            local oldExpanded = MSC.ExpandDerivedStats(oldStats or {}, nil, Scratch_Tooltip_Old)
            local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded, Scratch_Tooltip_Diffs)

            -- [[ CONSOLIDATION PASS ]]
            local changedMap = {}; for i, d in ipairs(diffs) do changedMap[d.key] = i end
            for source, result in pairs(STAT_CONSOLIDATION_MAP) do
                local sIdx, rIdx = changedMap[source], changedMap[result]
                if sIdx and rIdx and math.abs(diffs[sIdx].val)>0.1 and math.abs(diffs[rIdx].val)>0.1 then
                    diffs[sIdx].val = 0 -- Hide Source
                    local sName = MSC.GetCleanStatName(source) or "Stat"
                    diffs[rIdx].nameSuffix = " |cff888888(inc. " .. sName .. ")|r"
                end
            end
            
            -- Special: Paladin SP/Int
            if playerClass == "PALADIN" then 
                local iIdx, sIdx = changedMap["ITEM_MOD_INTELLECT_SHORT"], changedMap["ITEM_MOD_SPELL_POWER_SHORT"]
                if iIdx and sIdx and math.abs(diffs[iIdx].val)>0.1 and math.abs(diffs[sIdx].val)>0.1 then diffs[iIdx].val = 0 end 
            end

            local gains, losses = {}, {}
            for _, d in ipairs(diffs) do
                if math.abs(d.val) > 0.1 then
                    local isRelevant = (weights[d.key] and weights[d.key] > 0) or (d.key == "ITEM_MOD_HEALTH_SHORT") or (d.key == "ITEM_MOD_MANA_SHORT") or (d.key == "ITEM_MOD_ATTACK_POWER_SHORT") or (d.key == "ITEM_MOD_SPELL_POWER_SHORT") or (d.key == "ITEM_MOD_HEALING_POWER_SHORT") or (d.key == "ITEM_MOD_CRIT_RATING_SHORT") or (d.key == "ITEM_MOD_SPELL_CRIT_RATING_SHORT") or (d.key == "ITEM_MOD_BLOCK_VALUE_SHORT")
                    if isRelevant then if d.val > 0 then table.insert(gains, d) else table.insert(losses, d) end end
                end
            end

            local function StableSort(a, b) local wA=(weights[a.key]or 0); local wB=(weights[b.key]or 0); if wA==wB then return a.key<b.key end; return wA>wB end
            table.sort(gains, StableSort); table.sort(losses, StableSort)

            local function PrintList(label, list, cR, cG, cB)
                local hp, lp = false, 0
                for _, d in ipairs(list) do
                    if lp < 5 then
                        if not hp then tooltip:AddLine(label, cR, cG, cB); hp = true end
                        local name = (MSC.GetCleanStatName(d.key) or d.key) .. (d.nameSuffix or "")
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
ShoppingTooltip1:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ShoppingTooltip2:HookScript("OnTooltipSetItem", OnTooltipSetItem)