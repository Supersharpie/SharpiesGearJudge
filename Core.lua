local _, MSC = ... 

-- =============================================================
-- 1. INITIALIZATION
-- =============================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "SharpiesGearJudge" then
        if not SGJ_Settings then SGJ_Settings = { Mode = "Auto", MinimapPos = 45, IncludeEnchants = false, ProjectEnchants = true } end
        if MSC.UpdateMinimapPosition then MSC.UpdateMinimapPosition() end
        print("|cff00ccffSharpie's Gear Judge|r loaded! Type |cff00ff00/sgj|r to open the lab.")
    end
end)

-- =============================================================
-- 2. SLASH COMMANDS
-- =============================================================
SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    if msg == "options" or msg == "config" then MSC.CreateOptionsFrame() else MSC.CreateLabFrame() end 
end

-- =============================================================
-- 3. TOOLTIP LOGIC 
-- =============================================================
local function MergeStats(t1, t2)
    local out = {}
    if t1 then for k,v in pairs(t1) do out[k] = v end end
    if t2 then for k,v in pairs(t2) do out[k] = (out[k] or 0) + v end end
    return out
end

function MSC.UpdateTooltip(tooltip)
    if SGJ_Settings.HideTooltips then return end 
    if not tooltip.GetItem then return end

    local _, link = tooltip:GetItem()
    if not link then return end
    
    -- CHECK 1: Class Usable
    if not MSC.IsItemUsable(link) then 
        tooltip:AddLine(" "); tooltip:AddLine("|cffff0000Sharpie's Verdict: CLASS UNUSABLE|r"); tooltip:Show(); return 
    end

    -- CHECK 2: Future Upgrade Logic
    local _, _, _, _, dbMinLevel = GetItemInfo(link)
    local myLevel = UnitLevel("player")
    local isFutureItem = false
    local finalMinLevel = 0

    if dbMinLevel and dbMinLevel > myLevel then
        isFutureItem = true; finalMinLevel = dbMinLevel
    end

    if not isFutureItem then
        local lineCount = tooltip:NumLines()
        for i = 2, math.min(lineCount, 10) do
            local lineObj = _G[tooltip:GetName() .. "TextLeft" .. i]
            if lineObj then
                local text = lineObj:GetText()
                if text and text:find(ITEM_MIN_LEVEL:gsub("%%d", "")) then
                    local levelFound = text:match("(%d+)")
                    if levelFound and tonumber(levelFound) > myLevel then
                        isFutureItem = true; finalMinLevel = tonumber(levelFound); break
                    end
                end
            end
        end
    end

    local itemEquipLoc = select(9, GetItemInfo(link))
    local slotId = MSC.SlotMap[itemEquipLoc] 
    if not slotId then return end
    
    local currentWeights, specName = MSC.GetCurrentWeights()
    local equippedMH = GetInventoryItemLink("player", 16)
    local equippedOH = GetInventoryItemLink("player", 17)
    local equippedMHLoc = equippedMH and select(9, GetItemInfo(equippedMH))
    
    local oldScore, newScore = 0, 0
    local oldStats, newStats = {}, {}
    local noteText, partnerItemLink = nil, nil
    local isBestInBag, isEquipped = false, false

    -- [COMPARISON LOGIC]
    if itemEquipLoc == "INVTYPE_2HWEAPON" then
        newStats = MSC.SafeGetItemStats(link, 16)
        newScore = MSC.GetItemScore(newStats, currentWeights, specName, 16)
        local mhLink, ohLink = equippedMH, equippedOH
        local filledFromBag = false
        if equippedMHLoc ~= "INVTYPE_2HWEAPON" then
            if not mhLink then mhLink = MSC.FindBestMainHand(currentWeights, specName); filledFromBag = true end
            if not ohLink then ohLink = MSC.FindBestOffhand(currentWeights, specName); filledFromBag = true end
        end
        local mhStats = MSC.SafeGetItemStats(mhLink, 16); local ohStats = MSC.SafeGetItemStats(ohLink, 17)
        oldStats = MergeStats(mhStats, ohStats)
        oldScore = MSC.GetItemScore(mhStats, currentWeights, specName, 16) + MSC.GetItemScore(ohStats, currentWeights, specName, 17)
        if filledFromBag or (equippedMHLoc ~= "INVTYPE_2HWEAPON" and equippedOH) then noteText = "Comparing vs: " .. (mhLink or "Empty") .. " + " .. (ohLink or "Empty") end
        if link == equippedMH then isEquipped = true end

    elseif (itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestOHLink, bestOHScore, bestOHStats = MSC.FindBestOffhand(currentWeights, specName)
        local mhStats = MSC.SafeGetItemStats(link, 16)
        local mhScore = MSC.GetItemScore(mhStats, currentWeights, specName, 16)
        if bestOHLink then newStats = MergeStats(mhStats, bestOHStats); newScore = mhScore + bestOHScore; partnerItemLink = bestOHLink
        else newStats = mhStats; newScore = mhScore; noteText = "|cffff0000(No Offhand found)|r" end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, 16)

    elseif (itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestMHLink, bestMHScore, bestMHStats = MSC.FindBestMainHand(currentWeights, specName)
        local ohStats = MSC.SafeGetItemStats(link, 17); local ohScore = MSC.GetItemScore(ohStats, currentWeights, specName, 17)
        if bestMHLink then newStats = MergeStats(bestMHStats, ohStats); newScore = bestMHScore + ohScore; partnerItemLink = bestMHLink
        else newStats = ohStats; newScore = ohScore; noteText = "|cffff0000(No Mainhand found)|r" end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, 16)

    elseif itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" then
        local s1, s2 = 11, 12; if itemEquipLoc == "INVTYPE_TRINKET" then s1, s2 = 13, 14 end
        local l1, l2 = GetInventoryItemLink("player", s1), GetInventoryItemLink("player", s2)
        local st1, st2 = MSC.SafeGetItemStats(l1, s1), MSC.SafeGetItemStats(l2, s2)
        local sc1, sc2 = MSC.GetItemScore(st1, currentWeights, specName, s1), MSC.GetItemScore(st2, currentWeights, specName, s2)
        local targetSlot, targetLink, otherLink = s1, l1, l2
        if (not l1) then targetSlot = s1; targetLink = nil; otherLink = l2
        elseif (not l2) then targetSlot = s2; targetLink = nil; otherLink = l1
        elseif sc2 < sc1 then targetSlot = s2; targetLink = l2; otherLink = l1 end
        if link == l1 then isEquipped = true; targetSlot = s1; targetLink = l1; otherLink = l2
        elseif link == l2 then isEquipped = true; targetSlot = s2; targetLink = l2; otherLink = l1 end
        partnerItemLink = otherLink 
        if not targetLink and not isEquipped then tooltip:AddLine(" "); tooltip:AddLine("|cff00ff00++ NEW ITEM (Slot Empty)|r"); tooltip:Show(); return end
        oldStats = MSC.SafeGetItemStats(targetLink, targetSlot); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, targetSlot)
        newStats = MSC.SafeGetItemStats(link, targetSlot); newScore = MSC.GetItemScore(newStats, currentWeights, specName, targetSlot)
        if not isEquipped then noteText = "Comparing vs: " .. (targetLink or "Empty") .. " (Weakest)" end

    else
        local compLink = GetInventoryItemLink("player", slotId)
        if link == compLink then isEquipped = true end
        if not compLink then
            if slotId == 17 then local bag = MSC.FindBestOffhand(currentWeights, specName); if bag then compLink = bag; noteText = "Comparing vs: " .. compLink; if link == bag then isBestInBag = true end end
            elseif slotId == 16 then local bag = MSC.FindBestMainHand(currentWeights, specName); if bag then compLink = bag; noteText = "Comparing vs: " .. compLink; if link == bag then isBestInBag = true end end end
        end
        if slotId == 16 then partnerItemLink = GetInventoryItemLink("player", 17) elseif slotId == 17 then partnerItemLink = GetInventoryItemLink("player", 16) end
        if not compLink then tooltip:AddLine(" "); tooltip:AddLine("|cff00ff00++ NEW ITEM (Slot Empty)|r"); tooltip:Show(); return end
        oldStats = MSC.SafeGetItemStats(compLink, slotId); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, slotId)
        newStats = MSC.SafeGetItemStats(link, slotId); newScore = MSC.GetItemScore(newStats, currentWeights, specName, slotId)
    end

    -- [RENDER UI]
    local scoreDiff = newScore - oldScore
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine("|cff00ccffSharpie's Verdict:|r", "|cffffffff" .. specName .. "|r")
    
    if noteText and not isBestInBag then tooltip:AddLine(noteText, 0.7, 0.7, 0.7) end
    if newStats.IS_PROJECTED then local enchantText = MSC.GetEnchantString(slotId); if enchantText and enchantText ~= "" then tooltip:AddLine("(Projecting: " .. enchantText .. ")", 0, 1, 1) end end

    if isEquipped then
        if partnerItemLink then tooltip:AddLine("|cff00ffff*** EQUIPPED WITH: " .. partnerItemLink .. " ***|r")
        else tooltip:AddLine("|cff00ffff*** CURRENTLY EQUIPPED ***|r") end
    else
        if partnerItemLink then tooltip:AddLine("|cff00ff00*** BEST PAIR WITH: " .. partnerItemLink .. " ***|r") end
        local bestText = isBestInBag and " (Best in Bag)" or ""
        
        if scoreDiff > 0 then
            if isFutureItem then
                 tooltip:AddLine("|cffFF55FF*** FUTURE UPGRADE (+" .. string.format("%.1f", scoreDiff) .. ")" .. bestText .. " ***|r")
                 tooltip:AddLine("|cffFF55FF(Requires Level " .. finalMinLevel .. ")|r")
            else
                 tooltip:AddLine("|cff00ff00*** UPGRADE (+" .. string.format("%.1f", scoreDiff) .. ")" .. bestText .. " ***|r")
            end
        elseif scoreDiff < 0 then tooltip:AddLine("|cffff0000*** DOWNGRADE (" .. string.format("%.1f", scoreDiff) .. ") ***|r")
        else tooltip:AddLine("|cffffffff*** EQUAL STATS ***|r") end
    end

    -- [STAT BREAKDOWN - EDUCATIONAL MODE]
    local oldExpanded = MSC.ExpandDerivedStats(oldStats, (isEquipped and link or nil)) 
    local newExpanded = MSC.ExpandDerivedStats(newStats, link)
    local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded)
    local sortedDiffs = MSC.SortStatDiffs(diffs)
    
    -- Check sources for educational labeling
    local itemHasStam   = (newExpanded["ITEM_MOD_STAMINA_SHORT"] or 0) > 0
    local itemHasInt    = (newExpanded["ITEM_MOD_INTELLECT_SHORT"] or 0) > 0
    local itemHasSpirit = (newExpanded["ITEM_MOD_SPIRIT_SHORT"] or 0) > 0
    local itemHasAgi    = (newExpanded["ITEM_MOD_AGILITY_SHORT"] or 0) > 0
    local itemHasStr    = (newExpanded["ITEM_MOD_STRENGTH_SHORT"] or 0) > 0

    for _, entry in ipairs(sortedDiffs) do
        if entry.key ~= "IS_PROJECTED" then
            local isRelevant = (currentWeights and currentWeights[entry.key] and currentWeights[entry.key] > 0)
            
            -- Whitelist Display
            if entry.key == "ITEM_MOD_HEALTH_SHORT" or entry.key == "ITEM_MOD_MANA_SHORT" 
            or entry.key == "ITEM_MOD_ATTACK_POWER_SHORT" or entry.key == "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" 
            or entry.key == "ITEM_MOD_CRIT_RATING_SHORT" or entry.key == "ITEM_MOD_HIT_RATING_SHORT" 
            or entry.key == "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" or entry.key == "ITEM_MOD_SPELL_CRIT_RATING_SHORT" 
            or entry.key == "ITEM_MOD_MANA_REGENERATION_SHORT" or entry.key == "ITEM_MOD_BLOCK_VALUE_SHORT"
            or entry.key == "ITEM_MOD_ARMOR_SHORT" or entry.key == "ITEM_MOD_DODGE_RATING_SHORT" 
			or entry.key == "ITEM_MOD_CRIT_FROM_STATS_SHORT" or entry.key == "ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT" 
			then isRelevant = true end
			
            if isRelevant then
                local cleanName = MSC.GetCleanStatName(entry.key)
                
                -- CASTER OVERRIDES:
                if entry.key == "ITEM_MOD_HEALTH_SHORT" and itemHasStam then cleanName = "Health (from Stam)" end
                if entry.key == "ITEM_MOD_MANA_SHORT" and itemHasInt then cleanName = "Mana (from Int)" end
               -- if entry.key == "ITEM_MOD_SPELL_CRIT_RATING_SHORT" and itemHasInt then cleanName = "Spell Crit (from Int)" end
                if entry.key == "ITEM_MOD_MANA_REGENERATION_SHORT" and itemHasSpirit then cleanName = "Mana Regen (from Spt)" end

                -- PHYSICAL OVERRIDES:
                if entry.key == "ITEM_MOD_ATTACK_POWER_SHORT" and itemHasStr then cleanName = "Atk Power (from Str)" end
                if entry.key == "ITEM_MOD_BLOCK_VALUE_SHORT" and itemHasStr then cleanName = "Block Val (from Str)" end
                if entry.key == "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" and itemHasAgi then cleanName = "Ranged AP (from Agi)" end
                if entry.key == "ITEM_MOD_DODGE_RATING_SHORT" and itemHasAgi then cleanName = "Dodge (from Agi)" end
               -- if entry.key == "ITEM_MOD_CRIT_RATING_SHORT" and itemHasAgi then cleanName = "Crit (from Agi)" end
                if entry.key == "ITEM_MOD_ARMOR_SHORT" and itemHasAgi then cleanName = "Armor (from Agi)" end

                if cleanName and cleanName ~= "" then
                    local newVal = newExpanded[entry.key] or 0
                    local diffVal = entry.val
                    local newStr = (newVal % 1 == 0) and string.format("%d", newVal) or string.format("%.1f", newVal)
                    local diffStr = (diffVal % 1 == 0) and string.format("%d", diffVal) or string.format("%.1f", diffVal)
                    if diffVal > 0 then diffStr = "+" .. diffStr end
                    
                    if diffVal > 0 then tooltip:AddDoubleLine(cleanName, "|cffffffff" .. newStr .. "|r |cff00ff00(" .. diffStr .. ")|r", 1, 0.82, 0) 
                    elseif diffVal < 0 then tooltip:AddDoubleLine(cleanName, "|cffffffff" .. newStr .. "|r |cffff0000(" .. diffStr .. ")|r", 1, 0.82, 0)
                    elseif newVal > 0 then tooltip:AddDoubleLine(cleanName, "|cffffffff" .. newStr .. "|r |cff777777(+0)|r", 1, 0.82, 0) end
                end
            end
        end
    end
    tooltip:Show()
end

-- =============================================================
-- 4. APPLY HOOKS
-- =============================================================
GameTooltip:HookScript("OnTooltipSetItem", MSC.UpdateTooltip)
if ItemRefTooltip then ItemRefTooltip:HookScript("OnTooltipSetItem", MSC.UpdateTooltip) end
if ShoppingTooltip1 then ShoppingTooltip1:HookScript("OnTooltipSetItem", MSC.UpdateTooltip) end
if ShoppingTooltip2 then ShoppingTooltip2:HookScript("OnTooltipSetItem", MSC.UpdateTooltip) end