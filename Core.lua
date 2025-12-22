local _, MSC = ... 

-- =============================================================
-- 1. INITIALIZATION
-- =============================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE") 
eventFrame:RegisterEvent("PLAYER_LEVEL_UP") 

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    
    -- LOAD LOGIC
    if event == "ADDON_LOADED" and arg1 == "SharpiesGearJudge" then
        if not SGJ_Settings then SGJ_Settings = { Mode = "Auto", MinimapPos = 45, IncludeEnchants = false, ProjectEnchants = true } end
        if not SGJ_History then SGJ_History = {} end 
        if MSC.UpdateMinimapPosition then MSC.UpdateMinimapPosition() end
        print("|cff00ccffSharpie's Gear Judge|r loaded!")
    end

    -- SPEC SWAP LOGIC
    if event == "PLAYER_TALENT_UPDATE" then
        local _, newSpecName = MSC.GetCurrentWeights()
        if MSC.LastActiveSpec and MSC.LastActiveSpec ~= newSpecName then
             print("|cff00ccffSharpie's Gear Judge:|r Spec change detected. Active Profile: |cff00ff00" .. newSpecName .. "|r")
        end
        MSC.LastActiveSpec = newSpecName
        if MSCLabFrame and MSCLabFrame:IsShown() then MSC.UpdateLabCalc() end
    end

    -- [[ LEVEL UP SNAPSHOT ]] --
    if event == "PLAYER_LEVEL_UP" then
        local newLevel = arg1
        C_Timer.After(2, function() -- Wait 2s for stats to update
            MSC.RecordSnapshot("Level " .. newLevel)
        end)
    end
end)

-- =============================================================
-- 2. SLASH COMMANDS
-- =============================================================
SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg) 
    if msg == "options" or msg == "config" then MSC.CreateOptionsFrame() 
    elseif msg == "history" then MSC.ShowHistory()
    else MSC.CreateLabFrame() end 
end

-- =============================================================
-- 3. TOOLTIP LOGIC 
-- =============================================================
function MSC.MergeStats(t1, t2)
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
    
    if not MSC.IsItemUsable(link) then 
        tooltip:AddLine(" "); tooltip:AddLine("|cffff0000Sharpie's Verdict: CLASS UNUSABLE|r"); tooltip:Show(); return 
    end

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
        oldStats = MSC.MergeStats(mhStats, ohStats)
        oldScore = MSC.GetItemScore(mhStats, currentWeights, specName, 16) + MSC.GetItemScore(ohStats, currentWeights, specName, 17)
        if filledFromBag or (equippedMHLoc ~= "INVTYPE_2HWEAPON" and equippedOH) then noteText = "Comparing vs: " .. (mhLink or "Empty") .. " + " .. (ohLink or "Empty") end
        if link == equippedMH then isEquipped = true end

    elseif (itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestOHLink, bestOHScore, bestOHStats = MSC.FindBestOffhand(currentWeights, specName)
        local mhStats = MSC.SafeGetItemStats(link, 16)
        local mhScore = MSC.GetItemScore(mhStats, currentWeights, specName, 16)
        if bestOHLink then newStats = MSC.MergeStats(mhStats, bestOHStats); newScore = mhScore + bestOHScore; partnerItemLink = bestOHLink
        else newStats = mhStats; newScore = mhScore; noteText = "|cffff0000(No Offhand found)|r" end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, 16)

    elseif (itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND") and equippedMHLoc == "INVTYPE_2HWEAPON" then
        local bestMHLink, bestMHScore, bestMHStats = MSC.FindBestMainHand(currentWeights, specName)
        local ohStats = MSC.SafeGetItemStats(link, 17); local ohScore = MSC.GetItemScore(ohStats, currentWeights, specName, 17)
        if bestMHLink then newStats = MSC.MergeStats(bestMHStats, ohStats); newScore = bestMHScore + ohScore; partnerItemLink = bestMHLink
        else newStats = ohStats; newScore = ohScore; noteText = "|cffff0000(No Mainhand found)|r" end
        oldStats = MSC.SafeGetItemStats(equippedMH, 16); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, 16)

    elseif itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" then
        local s1, s2 = 11, 12; if itemEquipLoc == "INVTYPE_TRINKET" then s1, s2 = 13, 14 end
        local l1, l2 = GetInventoryItemLink("player", s1), GetInventoryItemLink("player", s2)
        local st1 = l1 and MSC.SafeGetItemStats(l1, s1) or {}
        local st2 = l2 and MSC.SafeGetItemStats(l2, s2) or {}
        local sc1 = MSC.GetItemScore(st1, currentWeights, specName, s1)
        local sc2 = MSC.GetItemScore(st2, currentWeights, specName, s2)
        local targetSlot, targetLink, otherLink = s1, l1, l2
        if (not l1) then targetSlot = s1; targetLink = nil; otherLink = l2
        elseif (not l2) then targetSlot = s2; targetLink = nil; otherLink = l1
        elseif sc2 < sc1 then targetSlot = s2; targetLink = l2; otherLink = l1 end
        if link == l1 then isEquipped = true; targetSlot = s1; targetLink = l1; otherLink = l2
        elseif link == l2 then isEquipped = true; targetSlot = s2; targetLink = l2; otherLink = l1 end
        partnerItemLink = otherLink 
        if not targetLink and not isEquipped then oldStats = {}; oldScore = 0; noteText = "|cff00ff00++ FILLING EMPTY SLOT ++|r"
        else oldStats = MSC.SafeGetItemStats(targetLink, targetSlot); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, targetSlot) end
        newStats = MSC.SafeGetItemStats(link, targetSlot); newScore = MSC.GetItemScore(newStats, currentWeights, specName, targetSlot)
        if not isEquipped and targetLink then noteText = "Comparing vs: " .. targetLink .. " (Weakest)" end

    else
        local compLink = GetInventoryItemLink("player", slotId)
        if link == compLink then isEquipped = true end
        if not compLink then
            if slotId == 17 then local bag = MSC.FindBestOffhand(currentWeights, specName); if bag then compLink = bag; noteText = "Comparing vs: " .. compLink; if link == bag then isBestInBag = true end end
            elseif slotId == 16 then local bag = MSC.FindBestMainHand(currentWeights, specName); if bag then compLink = bag; noteText = "Comparing vs: " .. compLink; if link == bag then isBestInBag = true end end end
        end
        if slotId == 16 then partnerItemLink = GetInventoryItemLink("player", 17) elseif slotId == 17 then partnerItemLink = GetInventoryItemLink("player", 16) end
        if not compLink then oldStats = {}; oldScore = 0; noteText = "|cff00ff00++ FILLING EMPTY SLOT ++|r"
        else oldStats = MSC.SafeGetItemStats(compLink, slotId); oldScore = MSC.GetItemScore(oldStats, currentWeights, specName, slotId) end
        newStats = MSC.SafeGetItemStats(link, slotId); newScore = MSC.GetItemScore(newStats, currentWeights, specName, slotId)
    end

    local scoreDiff = newScore - oldScore
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine("|cff00ccffSharpie's Verdict:|r", "|cffffffff" .. specName .. "|r")
    
    if noteText and not isBestInBag then tooltip:AddLine(noteText, 0.7, 0.7, 0.7) end
    if newStats.IS_PROJECTED then 
        local enchantText = MSC.GetEnchantString(slotId)
        if enchantText and enchantText ~= "" then tooltip:AddLine("(Projecting: " .. enchantText .. ")", 0, 1, 1) end 
    end

    if isEquipped then
        if partnerItemLink then tooltip:AddLine("|cff777777(Baseline | w/ " .. partnerItemLink .. ")|r")
        else tooltip:AddLine("|cff777777(Baseline)|r") end
    else
        if partnerItemLink then tooltip:AddLine("|cff00ff00*** BEST PAIR WITH: " .. partnerItemLink .. " ***|r") end
        local bestText = isBestInBag and " (Best in Bag)" or ""
        local capNote = ""
        if specName and specName:find("Capped") then capNote = " (Cap Adjusted)" end
        if scoreDiff > 0 then
            if isFutureItem then tooltip:AddLine("|cffFF55FF*** FUTURE UPGRADE (+" .. string.format("%.1f", scoreDiff) .. ")" .. bestText .. capNote .. " ***|r"); tooltip:AddLine("|cffFF55FF(Requires Level " .. finalMinLevel .. ")|r")
            else tooltip:AddLine("|cff00ff00*** UPGRADE (+" .. string.format("%.1f", scoreDiff) .. ")" .. bestText .. capNote .. " ***|r") end
        elseif scoreDiff < 0 then 
            tooltip:AddLine("|cffff0000*** DOWNGRADE (" .. string.format("%.1f", scoreDiff) .. ")" .. capNote .. " ***|r")
        else 
            tooltip:AddLine("|cffffffff*** EQUAL STATS ***|r") 
        end
    end

    local oldExpanded = MSC.ExpandDerivedStats(oldStats, (isEquipped and link or nil)) 
    local newExpanded = MSC.ExpandDerivedStats(newStats, link)
    local diffs = MSC.GetStatDifferences(newExpanded, oldExpanded)
    local sortedDiffs = MSC.SortStatDiffs(diffs)
    local diffMap = {}
    for _, d in ipairs(diffs) do diffMap[d.key] = d.val end
    local handledStats = {}

    local function GetFormattedStatValue(statKey)
        local newVal = newExpanded[statKey] or 0
        local diffVal = diffMap[statKey] or 0
        if newVal == 0 and diffVal == 0 then return nil, 1, 1, 1 end 
        local newStr = (newVal % 1 == 0) and string.format("%d", newVal) or string.format("%.1f", newVal)
        local diffStr = (diffVal % 1 == 0) and string.format("%d", diffVal) or string.format("%.1f", diffVal)
        if diffVal > 0 then diffStr = "+" .. diffStr end
        local finalStr = ""
        local r, g, b = 1, 1, 1 
        if diffVal > 0 then finalStr = "|cffffffff" .. newStr .. "|r |cff00ff00(" .. diffStr .. ")|r"; r, g, b = 0, 1, 0 
        elseif diffVal < 0 then finalStr = "|cffffffff" .. newStr .. "|r |cffff0000(" .. diffStr .. ")|r"; r, g, b = 1, 0.2, 0.2 
        else if isEquipped then finalStr = "|cff00ff00" .. newStr .. "|r"; r, g, b = 1, 0.82, 0 else finalStr = "|cffffffff" .. newStr .. "|r |cff777777(+0)|r" end end
        return finalStr, r, g, b
    end

    local statPairs = {
        { prim = "ITEM_MOD_STAMINA_SHORT", der = "ITEM_MOD_HEALTH_SHORT", primLabel = "Stamina", derLabel = "Health (from Stam)" },
        { prim = "ITEM_MOD_INTELLECT_SHORT", der = "ITEM_MOD_MANA_SHORT", primLabel = "Intellect", derLabel = "Mana (from Int)" },
        { prim = "ITEM_MOD_SPIRIT_SHORT", der = "ITEM_MOD_MANA_REGENERATION_SHORT", primLabel = "Spirit", derLabel = "Mana Regen (from Spt)" },
        { prim = "ITEM_MOD_STRENGTH_SHORT", der = "ITEM_MOD_ATTACK_POWER_SHORT", primLabel = "Strength", derLabel = "Atk Power (from Str)" },
        { prim = "ITEM_MOD_STRENGTH_SHORT", der = "ITEM_MOD_BLOCK_VALUE_SHORT", primLabel = "Strength", derLabel = "Block Val (from Str)" },
        { prim = "ITEM_MOD_AGILITY_SHORT", der = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT", primLabel = "Agility", derLabel = "Ranged AP (from Agi)" },
        { prim = "ITEM_MOD_AGILITY_SHORT", der = "ITEM_MOD_DODGE_RATING_SHORT", primLabel = "Agility", derLabel = "Dodge (from Agi)" },
        { prim = "ITEM_MOD_AGILITY_SHORT", der = "ITEM_MOD_CRIT_FROM_STATS_SHORT", primLabel = "Agility", derLabel = "Crit (from Agi)" },
        { prim = "ITEM_MOD_AGILITY_SHORT", der = "ITEM_MOD_ARMOR_SHORT", primLabel = "Agility", derLabel = "Armor (from Agi)" },
    }
    for _, pair in ipairs(statPairs) do
        local isDerRelevant = (currentWeights and currentWeights[pair.der] and currentWeights[pair.der] > 0)
        if pair.der == "ITEM_MOD_HEALTH_SHORT" or pair.der == "ITEM_MOD_MANA_SHORT" then isDerRelevant = true end
        if isDerRelevant and not handledStats[pair.prim] and not handledStats[pair.der] then
            local primStr, pr, pg, pb = GetFormattedStatValue(pair.prim)
            local derStr, dr, dg, db = GetFormattedStatValue(pair.der)
            if primStr and derStr then
                local combinedRight = primStr .. "   |cffcccccc" .. pair.derLabel .. "|r " .. derStr
                tooltip:AddDoubleLine(pair.primLabel, combinedRight, pr, pg, pb)
                handledStats[pair.prim] = true; handledStats[pair.der] = true
            end
        end
    end
    for _, entry in ipairs(sortedDiffs) do
        if not handledStats[entry.key] and entry.key ~= "IS_PROJECTED" then
            local isRelevant = (currentWeights and currentWeights[entry.key] and currentWeights[entry.key] > 0)
            if entry.key == "ITEM_MOD_HEALTH_SHORT" or entry.key == "ITEM_MOD_MANA_SHORT" then isRelevant = true end
            if isRelevant then
                local valStr, r, g, b = GetFormattedStatValue(entry.key)
                if valStr then
                    local cleanName = MSC.GetCleanStatName(entry.key)
                    if entry.key == "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" then
                        local rawVal = newStats["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] or 0
                        if rawVal == 0 then cleanName = "Wpn Skill (Racial)" end
                    end
                    tooltip:AddDoubleLine(cleanName, valStr, r, g, b)
                    handledStats[entry.key] = true
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

-- =============================================================
-- DEBUGGER TOOL
-- =============================================================
SLASH_SGJDEBUG1 = "/sgjdebug"
SlashCmdList["SGJDEBUG"] = function(msg)
    local itemLink = msg:match("(|c.+|r)")
    if not itemLink then print("|cffff0000SGJ Debug:|r Please link an item."); return end
    print(" "); print("|cff00ff00=== DEBUGGING: " .. itemLink .. " ===|r")
    local tip = CreateFrame("GameTooltip", "MSC_DebugTooltip", nil, "GameTooltipTemplate")
    tip:SetOwner(WorldFrame, "ANCHOR_NONE"); tip:SetHyperlink(itemLink)
    for i = 1, tip:NumLines() do
        local line = _G["MSC_DebugTooltipTextLeft" .. i]
        if line then
            local text = line:GetText()
            if text then
                local statKey, statVal = MSC.ParseTooltipLine(text)
                if statKey then print("|cff00ffff[Line " .. i .. "]|r '" .. text .. "' -> |cff00ff00MATCH:|r " .. (MSC.ShortNames[statKey] or statKey) .. " = " .. statVal)
                else print("|cffaaaaaa[Line " .. i .. "]|r '" .. text .. "' -> |cffff0000No Match|r") end
            end
        end
    end
    print("|cff00ff00================================|r")
end

-- =============================================================
-- DIAGNOSTIC TOOL
-- =============================================================
SLASH_SGJDIAG1 = "/sgjdiag"
SlashCmdList["SGJDIAG"] = function(msg)
    local itemLink = nil
    if GameTooltip:IsVisible() then _, itemLink = GameTooltip:GetItem() end
    if not itemLink then print("|cffff0000SGJ Diag:|r Please hover over an item."); return end

    local slotId = MSC.SlotMap[select(9, GetItemInfo(itemLink))]
    local _, englishClass = UnitClass("player")
    
    print("|cff00ff00=== POTENTIAL MODE DIAGNOSIS ===|r")
    print("Item: " .. itemLink)
    print("SlotID: " .. (slotId or "N/A"))
    print("Setting (ProjectEnchants): " .. (SGJ_Settings.ProjectEnchants and "|cff00ff00ON|r" or "|cffff0000OFF|r"))
    
    local _, _, _, existingEnchantID = string.find(itemLink, "item:(%d+):(%d+)")
    local hasEnchant = (existingEnchantID and tonumber(existingEnchantID) > 0)
    print("Has Existing Enchant: " .. (hasEnchant and "|cffff0000YES|r" or "|cff00ff00NO|r"))
    
    local dbExists = (MSC.EnchantDB and MSC.EnchantDB[englishClass] and MSC.EnchantDB[englishClass][slotId])
    print("Enchant DB Entry Found: " .. (dbExists and "|cff00ff00YES|r" or "|cffff0000NO|r"))
    
    if dbExists then
        print("Enchant Name: " .. (MSC.EnchantDB[englishClass][slotId].name or "Unknown"))
    end
    print("|cff00ff00================================|r")
end

-- =============================================================
-- GEAR RECEIPT WINDOW (V7.3 - Final Layout)
-- =============================================================

-- [[ HELPER: PHASE 2 BAG SCANNER ]] --
local function CheckBagsForUpgrade(slotId, currentScore, weights, specName)
    local bestBagItem, bestBagScore = nil, currentScore
    
    -- Iterate Bags
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local link = C_Container.GetContainerItemLink(bag, slot)
            if link then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                local itemSlotId = MSC.SlotMap[equipLoc]
                
                -- Check matching slot (including Ring/Weapon overlaps)
                local isMatch = false
                if itemSlotId == slotId then isMatch = true end
                if (slotId == 12 and itemSlotId == 11) then isMatch = true end
                if (slotId == 14 and itemSlotId == 13) then isMatch = true end
                if slotId == 16 and (equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_2HWEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND") then isMatch = true end
                if slotId == 17 and (equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND") then isMatch = true end
                
                if isMatch and MSC.IsItemUsable(link) then
                    local stats = MSC.SafeGetItemStats(link, slotId)
                    if stats then
                        local score = MSC.GetItemScore(stats, weights, specName, slotId)
                        if score > bestBagScore + 0.1 then -- Must be strictly better
                            bestBagScore = score
                            bestBagItem = link
                        end
                    end
                end
            end
        end
    end
    return bestBagItem, bestBagScore
end

-- [[ HELPER: PHASE 3 ENCHANT CHECKER (FIXED) ]] --
local function IsMissingEnchant(itemLink, slotId)
    if not itemLink then return false end
    
    local validSlots = { [15]=true, [5]=true, [9]=true, [10]=true, [8]=true, [16]=true, [17]=true }
    if not validSlots[slotId] then return false end

    if slotId == 17 then
        local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
        if equipLoc == "INVTYPE_HOLDABLE" then return false end
    end
    
    local itemString = string.match(itemLink, "item[%-?%d:]+")
    if not itemString then return false end
    
    local _, _, enchantID = strsplit(":", itemString)
    if not enchantID or enchantID == "" or enchantID == "0" then return true end
    
    return false
end

-- [[ PHASE 6: EXPORT FUNCTION ]] --
function MSC.ExportData(dataRows, score, unitName)
    if not MSC.ExportFrame then
        local f = CreateFrame("Frame", "MSC_ExportFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(400, 300); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG"); f:EnableMouse(true); f.TitleText:SetText("Export Data")
        local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -30); scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        local editBox = CreateFrame("EditBox", nil, scroll)
        editBox:SetMultiLine(true); editBox:SetFontObject("ChatFontNormal"); editBox:SetWidth(360)
        scroll:SetScrollChild(editBox); f.EditBox = editBox
        MSC.ExportFrame = f
    end
    
    local dateStr = date("%Y-%m-%d")
    local export = "**Sharpie's Gear Receipt** (" .. dateStr .. ")\n"
    export = export .. "Judge: " .. unitName .. "\n"
    export = export .. "Score: **" .. score .. "**\n"
    export = export .. "----------------------------------\n"
    
    for _, row in ipairs(dataRows) do
        export = export .. "*" .. row.slot .. "*: " .. row.link .. " (" .. row.score .. ")\n"
    end
    
    MSC.ExportFrame.EditBox:SetText(export)
    MSC.ExportFrame.EditBox:HighlightText()
    MSC.ExportFrame:Show()
end

-- [[ PHASE 4: RECORD HISTORY (Hidden Logic) ]] --
function MSC.RecordSnapshot(eventLabel)
    if not SGJ_History then SGJ_History = {} end
    
    local slots = {{id=1},{id=2},{id=3},{id=15},{id=5},{id=9},{id=10},{id=6},{id=7},{id=8},{id=11},{id=12},{id=13},{id=14},{id=16},{id=17},{id=18}}
    local currentWeights, specName = MSC.GetCurrentWeights()
    local totalScore = 0
    
    for i, slot in ipairs(slots) do
        local link = GetInventoryItemLink("player", slot.id)
        if link then
            local stats = MSC.SafeGetItemStats(link, slot.id)
            if stats then totalScore = totalScore + MSC.GetItemScore(stats, currentWeights, specName, slot.id) end
        end
    end
    
    local entry = {
        date = date("%Y-%m-%d"),
        label = eventLabel or "Snapshot",
        score = string.format("%.1f", totalScore),
        spec = specName
    }
    
    table.insert(SGJ_History, 1, entry) -- Insert at top
    
    -- Keep only last 20 entries
    if #SGJ_History > 20 then table.remove(SGJ_History, #SGJ_History) end
    
    print("|cff00ccffSharpie's Gear Judge:|r " .. eventLabel .. " recorded! (Score: " .. entry.score .. ")")
end

-- [[ PHASE 4: SHOW HISTORY UI (Fixed) ]] --
function MSC.ShowHistory()
    if not MSC.HistoryFrame then
        local f = CreateFrame("Frame", "MSC_HistoryFrame", UIParent, "BasicFrameTemplateWithInset")
        
        -- [[ FIX ADDED: Make it movable ]] --
        f:SetSize(350, 400); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleBg:SetHeight(30); f.TitleText:SetText("Transaction History")
        
        f.Scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        f.Scroll:SetPoint("TOPLEFT", 10, -30); f.Scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        f.Content = CreateFrame("Frame", nil, f.Scroll); f.Content:SetSize(310, 380)
        f.Scroll:SetScrollChild(f.Content)
        
        f.Rows = {}
        MSC.HistoryFrame = f
    end
    
    if not SGJ_History or #SGJ_History == 0 then
        print("|cffff0000SGJ:|r No history recorded yet.")
        return
    end
    
    local yOffset = 0
    for i, entry in ipairs(SGJ_History) do
        if not MSC.HistoryFrame.Rows[i] then
            local row = MSC.HistoryFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            row:SetPoint("TOPLEFT", 10, yOffset)
            row:SetWidth(300)
            row:SetJustifyH("LEFT")
            MSC.HistoryFrame.Rows[i] = row
        end
        
        local color = "|cffffffff"
        if entry.label:find("Level") then color = "|cff00ff00" end -- Green for level ups
        
        local text = color .. entry.date .. "|r - " .. entry.label .. ": |cff00ccff" .. entry.score .. "|r"
        MSC.HistoryFrame.Rows[i]:SetText(text)
        
        yOffset = yOffset - 20
    end
    
    MSC.HistoryFrame:Show()
end

-- [[ UPDATED: INSPECT-CAPABLE RECEIPT ]] --
function MSC.ShowReceipt(unitOverride)
    local unit = unitOverride or "player"
    local isPlayer = (unit == "player")
    local unitName = UnitName(unit)
    local _, unitClass = UnitClass(unit)
    
    local currentWeights, specName
    if isPlayer then
        currentWeights, specName = MSC.GetCurrentWeights()
    else
        if MSC.WeightDB[unitClass] and MSC.WeightDB[unitClass]["Default"] then
            currentWeights = MSC.WeightDB[unitClass]["Default"]
            specName = unitClass .. " (Default)"
        else
            print("|cffff0000SGJ:|r Unsupported Class for Inspection.")
            return
        end
    end

    if not MSC.ReceiptFrame then
        local f = CreateFrame("Frame", "MSC_ReceiptFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(420, 600); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleBg:SetHeight(30); f.TitleText:SetText("Sharpie's Gear Receipt")
        local _, classFilename = UnitClass("player"); local color = RAID_CLASS_COLORS[classFilename]
        if f.SetBorderColor then f:SetBorderColor(color.r, color.g, color.b) end 
        MSC.ReceiptFrame = f
        f.Scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate"); f.Scroll:SetPoint("TOPLEFT", 10, -30); f.Scroll:SetPoint("BOTTOMRIGHT", -30, 160)
        f.Content = CreateFrame("Frame", nil, f.Scroll); f.Content:SetSize(380, 480); f.Scroll:SetScrollChild(f.Content)
        
        -- [[ VISUAL ADJUSTMENT 1: Raise Content Container to avoid new footer ]]
        f.SummaryBox = CreateFrame("Frame", nil, f); f.SummaryBox:SetPoint("TOPLEFT", f.Scroll, "BOTTOMLEFT", 0, -5); f.SummaryBox:SetPoint("BOTTOMRIGHT", -10, 70) 
        
        f.Separator = f.SummaryBox:CreateTexture(nil, "ARTWORK"); f.Separator:SetHeight(1); f.Separator:SetPoint("TOPLEFT", 10, 0); f.Separator:SetPoint("TOPRIGHT", -10, 0); f.Separator:SetColorTexture(1, 0.82, 0, 0.5) 
        f.SummaryBg = f.SummaryBox:CreateTexture(nil, "BACKGROUND"); f.SummaryBg:SetPoint("TOPLEFT", 0, -5); f.SummaryBg:SetPoint("BOTTOMRIGHT", 0, 0); f.SummaryBg:SetColorTexture(0, 0, 0, 0.3)
        f.SummaryTitle = f.SummaryBox:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.SummaryTitle:SetPoint("TOP", 0, -12); f.SummaryTitle:SetText("COMBINED STATS FROM GEAR"); f.SummaryTitle:SetTextColor(1, 0.82, 0) 
        
        -- [[ VISUAL ADJUSTMENT 2: Taller Footer ]]
        f.FooterBg = f:CreateTexture(nil, "BACKGROUND"); f.FooterBg:SetPoint("BOTTOMLEFT", 4, 4); f.FooterBg:SetPoint("BOTTOMRIGHT", -4, 4); f.FooterBg:SetHeight(60); f.FooterBg:SetColorTexture(0, 0, 0, 0.5) 
        
        -- [[ VISUAL ADJUSTMENT 3: Score moved to Top Row of Footer ]]
        f.TotalText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); f.TotalText:SetPoint("BOTTOM", f, "BOTTOM", 0, 40); f.TotalText:SetTextColor(color.r, color.g, color.b) 
        
        -- [[ BUTTON 1: PRINT (RIGHT) ]] --
        local printBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        printBtn:SetSize(80, 24)
        printBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -20, 10) -- [[ NEW ANCHOR ]]
        printBtn:SetText("Print")
        printBtn:SetScript("OnClick", function()
            local data = f.printData; if not data then return end
            
            local owner = f.unitName or "Sharpie"
            local msg1 = "[" .. owner .. "'s Gear]: Score " .. data.score
            if data.topLink then msg1 = msg1 .. " - MVP: " .. data.topLink end
            
            local chatType = "SAY"
            if IsInRaid() then chatType = "RAID" elseif IsInGroup() then chatType = "PARTY" end
            
            SendChatMessage(msg1, chatType)

            if #data.missing > 0 then
                local mStr = ""
                if #data.missing > 4 then mStr = data.missing[1] .. ", " .. data.missing[2] .. ", " .. data.missing[3] .. "..."
                else mStr = table.concat(data.missing, ", ") end
                local msg2 = "[" .. owner .. "'s Gear]: Missing: " .. mStr
                SendChatMessage(msg2, chatType)
            end
        end)
        
        -- [[ BUTTON 2: JUDGE TARGET (LEFT) ]] --
        local targetBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        targetBtn:SetSize(100, 24)
        targetBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 20, 10) -- [[ NEW ANCHOR ]]
        targetBtn:SetText("Judge Target")
        targetBtn:SetScript("OnClick", function()
            if UnitExists("target") and UnitIsPlayer("target") then
                MSC.ShowReceipt("target")
            else
                print("|cffff0000SGJ:|r Invalid Target.")
            end
        end)
        
        -- [[ BUTTON 3: EXPORT (CENTER) ]] --
        local exportBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        exportBtn:SetSize(80, 24)
        exportBtn:SetPoint("BOTTOM", f, "BOTTOM", 0, 10) -- [[ NEW ANCHOR ]]
        exportBtn:SetText("Export")
        exportBtn:SetScript("OnClick", function()
            local data = f.printData; if not data then return end
            MSC.ExportData(data.rows, data.score, f.unitName or "Player")
        end)

        MSC.ReceiptRows = {}; MSC.SummaryRows = {}
    end
    
    MSC.ReceiptFrame.unitName = unitName
    if isPlayer then MSC.ReceiptFrame.TitleText:SetText("Sharpie's Gear Receipt")
    else MSC.ReceiptFrame.TitleText:SetText("Judge: " .. unitName) end
    MSC.ReceiptFrame:Show()
    
    local slots = {{name="Head",id=1},{name="Neck",id=2},{name="Shoulder",id=3},{name="Back",id=15},{name="Chest",id=5},{name="Wrist",id=9},{name="Hands",id=10},{name="Waist",id=6},{name="Legs",id=7},{name="Feet",id=8},{name="Finger 1",id=11},{name="Finger 2",id=12},{name="Trinket 1",id=13},{name="Trinket 2",id=14},{name="Main Hand",id=16},{name="Off Hand",id=17},{name="Ranged",id=18}}
    local totalScore = 0; local combinedStats = {}; local yOffset = 0
    local maxItemScore = -1; local maxItemLink = nil; local missingSlots = {}
    
    local exportRows = {} 

    for i, slot in ipairs(slots) do
        if not MSC.ReceiptRows[i] then
            local row = CreateFrame("Frame", nil, MSC.ReceiptFrame.Content); row:SetSize(380, 24); row.BG = row:CreateTexture(nil, "BACKGROUND"); row.BG:SetAllPoints()
            row.Icon = row:CreateTexture(nil, "ARTWORK"); row.Icon:SetSize(20, 20); row.Icon:SetPoint("LEFT", 4, 0); row.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) 
            row.Label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); row.Label:SetPoint("LEFT", row.Icon, "RIGHT", 8, 0); row.Label:SetWidth(65); row.Label:SetJustifyH("LEFT"); row.Label:SetTextColor(0.6, 0.6, 0.6) 
            row.Score = row:CreateFontString(nil, "OVERLAY", "GameFontNormal"); row.Score:SetPoint("RIGHT", -5, 0); row.Score:SetWidth(60); row.Score:SetJustifyH("RIGHT"); row.Score:SetTextColor(0, 1, 0) 
            row.Item = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row.Item:SetPoint("LEFT", row.Label, "RIGHT", 5, 0); row.Item:SetPoint("RIGHT", row.Score, "LEFT", -5, 0); row.Item:SetJustifyH("LEFT")
            
            row.Alert = row:CreateTexture(nil, "OVERLAY")
            row.Alert:SetSize(16, 16)
            row.Alert:SetPoint("RIGHT", row.Score, "LEFT", -5, 0)
            row.Alert:Hide() 
            
            row.AlertFrame = CreateFrame("Frame", nil, row)
            row.AlertFrame:SetAllPoints(row.Alert)
            row.AlertFrame:SetScript("OnEnter", function(self) 
                if self.mode == "UPGRADE" and self.link then 
                   GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                   GameTooltip:SetHyperlink(self.link)
                   GameTooltip:AddLine(" ")
                   GameTooltip:AddLine("|cff00ff00BETTER ITEM IN BAGS!|r")
                   GameTooltip:Show()
                elseif self.mode == "ENCHANT" then
                   GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                   GameTooltip:SetText("|cffff0000MISSING ENCHANT!|r")
                   GameTooltip:AddLine("You are losing potential stats.", 1, 1, 1)
                   GameTooltip:Show()
                end 
            end)
            row.AlertFrame:SetScript("OnLeave", GameTooltip_Hide)
            
            MSC.ReceiptRows[i] = row
        end
        local row = MSC.ReceiptRows[i]; row:SetPoint("TOPLEFT", 0, yOffset)
        local link = GetInventoryItemLink(unit, slot.id); local texture = GetInventoryItemTexture(unit, slot.id); local itemScore = 0; local itemText = "|cff444444(Empty)|r"
        
        row.Alert:Hide()
        row.AlertFrame.mode = nil; row.AlertFrame.link = nil

        if link then
            itemText = link; local stats = MSC.SafeGetItemStats(link, slot.id)
            if stats then 
                itemScore = MSC.GetItemScore(stats, currentWeights, specName, slot.id); 
                for k, v in pairs(stats) do combinedStats[k] = (combinedStats[k] or 0) + v end 
                if itemScore > maxItemScore then maxItemScore = itemScore; maxItemLink = link end
            end
            
            if IsMissingEnchant(link, slot.id) then
                row.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertOther") -- Red Exclamation
                row.Alert:Show()
                row.AlertFrame.mode = "ENCHANT"
            end
        else
            table.insert(missingSlots, slot.name)
        end
        
        if isPlayer then
            local upgradeLink, upgradeScore = CheckBagsForUpgrade(slot.id, itemScore, currentWeights, specName)
            if upgradeLink then
                row.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew") -- Yellow Triangle
                row.Alert:Show()
                row.AlertFrame.mode = "UPGRADE"
                row.AlertFrame.link = upgradeLink
            end
        end
        
        totalScore = totalScore + itemScore; row.Label:SetText(slot.name); row.Item:SetText(itemText); row.Score:SetText(string.format("%.1f", itemScore))
        if texture then row.Icon:SetTexture(texture); row.Icon:SetDesaturated(false) else row.Icon:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot"); row.Icon:SetDesaturated(true) end
        if i % 2 == 0 then row.BG:SetColorTexture(1, 1, 1, 0.03) else row.BG:SetColorTexture(0, 0, 0, 0) end; yOffset = yOffset - 24
        
        table.insert(exportRows, { slot = slot.name, link = (link or "(Empty)"), score = string.format("%.1f", itemScore) })
    end
    
    MSC.ReceiptFrame.printData = { score = string.format("%.1f", totalScore), topLink = maxItemLink, missing = missingSlots, rows = exportRows }
    
    for _, line in pairs(MSC.SummaryRows) do line:Hide() end
    local sortedStats = {}
    for k, v in pairs(combinedStats) do
        local weight = currentWeights[k] or 0; local alwaysShow = (k == "ITEM_MOD_STAMINA_SHORT") 
        if (weight > 0 or alwaysShow) then local sortWeight = (weight > 0) and weight or 0.001; table.insert(sortedStats, { key=k, val=v, weight=sortWeight, realWeight=weight }) end
    end
    table.sort(sortedStats, function(a,b) return a.weight > b.weight end)
    local col1X, col2X = 20, 210; local startY = -35
    for i, data in ipairs(sortedStats) do
        if i > 12 then break end 
        if not MSC.SummaryRows[i] then
            local f = CreateFrame("Frame", nil, MSC.ReceiptFrame.SummaryBox); f:SetSize(160, 16)
            f.Label = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); f.Label:SetPoint("LEFT", 0, 0)
            f.Value = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.Value:SetPoint("RIGHT", 0, 0); MSC.SummaryRows[i] = f
        end
        local row = MSC.SummaryRows[i]; row:Show()
        local cleanName = MSC.GetCleanStatName(data.key); local labelColor = "|cff888888" 
        if data.realWeight > 0 then labelColor = "|cff00ff00" end 
        row.Label:SetText(labelColor .. cleanName .. ":|r"); row.Value:SetText(string.format("%.1f", data.val))
        local isLeft = (i % 2 ~= 0); local rowIdx = math.ceil(i / 2) - 1; local yPos = startY - (rowIdx * 16)
        if isLeft then row:SetPoint("TOPLEFT", col1X, yPos) else row:SetPoint("TOPLEFT", col2X, yPos) end
    end
    MSC.ReceiptFrame.TotalText:SetText("SCORE: " .. string.format("%.1f", totalScore))
end

-- Slash Command
SLASH_SGJRECEIPT1 = "/sgjreceipt"
SlashCmdList["SGJRECEIPT"] = function() MSC.ShowReceipt() end