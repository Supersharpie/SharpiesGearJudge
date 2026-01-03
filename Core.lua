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
        if not SGJ_Settings then 
            SGJ_Settings = { 
                Mode = "Auto", 
                MinimapPos = 45, 
                EnchantMode = 3, -- Default: 3 (Project Best Enchants)
                GemMode = 3,     -- Default: 3 (Project Best Gems - Match Colors)
                -- REMOVED: IncludeEnchants, ProjectEnchants (Dead variables)
            } 
        end
		if not SGJ_History then SGJ_History = {} end 
        if MSC.UpdateMinimapPosition then MSC.UpdateMinimapPosition() end
        if MSC.BuildDatabase then
            MSC:BuildDatabase() -- Maps the thousands of items in database
        end
        print("|cff00ccffSharpie's Gear Judge|r (TBC Edition) loaded!")
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
        -- TBC Logic: Cap is now 70
        if newLevel == 70 then
            print("|cff00ccffSharpie's Gear Judge:|r Congratulations on Level 70! Switching to Endgame Spec.")
        end
        C_Timer.After(2, function() 
            MSC.RecordSnapshot("Level " .. newLevel)
            if MSCLabFrame and MSCLabFrame:IsShown() then MSC.UpdateLabCalc() end
        end)
    end
end)

-- =============================================================
-- 2. SLASH COMMANDS
-- =============================================================
SLASH_SHARPIESGEARJUDGE1 = "/sgj"
SLASH_SHARPIESGEARJUDGE2 = "/judge"
SlashCmdList["SHARPIESGEARJUDGE"] = function(msg)
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()
    
    if cmd == "options" or cmd == "config" then 
        MSC.CreateOptionsFrame() 
    elseif cmd == "history" then 
        MSC.ShowHistory()
    elseif cmd == "save" or cmd == "snapshot" then
        local label = (arg and arg ~= "") and arg or "Manual Save"
        MSC.RecordSnapshot(label)
        MSC.ShowHistory()
    else 
        MSC.CreateLabFrame() 
    end 
end

-- =============================================================
-- 3. TOOLTIP LOGIC 
-- =============================================================
function MSC.MergeStats(t1, t2)
    local out = {}
    -- Copy first table
    if t1 then 
        for k,v in pairs(t1) do out[k] = v end 
    end
    
    -- Merge second table
    if t2 then 
        for k,v in pairs(t2) do 
            if type(v) == "number" then
                -- Only add if it is a number (Stats)
                out[k] = (out[k] or 0) + v 
            else
                -- If it is text (like ENCHANT_TEXT), just overwrite or keep existing
                -- For MH+OH, keeping the MH text is usually fine, or just ignore.
                if not out[k] then out[k] = v end
            end
        end 
    end
    return out
end

function MSC.UpdateTooltip(tooltip)
    if SGJ_Settings and SGJ_Settings.HideTooltips then return end 
    if not tooltip.GetItem then return end

    local _, link = tooltip:GetItem()
    if not link then return end
    
    if MSC.IsItemUsable and not MSC.IsItemUsable(link) then 
        tooltip:AddLine(" ")
        tooltip:AddLine("|cffff0000Sharpie's Verdict: CLASS UNUSABLE|r")
        tooltip:Show()
        return 
    end

    local itemEquipLoc = select(9, GetItemInfo(link))
    local slotId = MSC.SlotMap[itemEquipLoc] 
    if not slotId then return end
    
    -- 2. Get Spec & Weights
    local currentWeights, specName = MSC.GetCurrentWeights()
    local _, class = UnitClass("player")
    if MSC.PrettyNames and MSC.PrettyNames[class] and MSC.PrettyNames[class][specName] then
        specName = MSC.PrettyNames[class][specName]
    end

    -- [[ FIX 1: DYNAMIC POTENTIAL WEIGHTS ]] 
    -- Instead of guessing "20", find the user's actual highest stat weight (usually ~1.6 - 2.2)
    local potentialWeights = {}
    local maxWeight = 0
    for k,v in pairs(currentWeights) do 
        potentialWeights[k] = v 
        if v > maxWeight then maxWeight = v end
    end
    if maxWeight < 1.0 then maxWeight = 1.5 end -- Safety floor

    local function RestoreIfCapped(key)
        local val = potentialWeights[key] or 0
        -- Only boost if the weight is suppressed (<= 1.0)
        if val > 0 and val <= 1.0 then potentialWeights[key] = maxWeight end
    end
    RestoreIfCapped("ITEM_MOD_HIT_RATING_SHORT")
    RestoreIfCapped("ITEM_MOD_HIT_SPELL_RATING_SHORT")
    RestoreIfCapped("ITEM_MOD_EXPERTISE_RATING_SHORT")

    -- 3. DETERMINE COMPARISON SLOT (Standard Logic)
    local targetSlot = slotId
    if itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" then
        local s1, s2 = 11, 12
        if itemEquipLoc == "INVTYPE_TRINKET" then s1, s2 = 13, 14 end
        local l1 = GetInventoryItemLink("player", s1)
        local l2 = GetInventoryItemLink("player", s2)
        if not l1 then targetSlot = s1
        elseif not l2 then targetSlot = s2
        else
            local stats1 = MSC.SafeGetItemStats(l1, s1)
            local stats2 = MSC.SafeGetItemStats(l2, s2)
            local score1 = MSC.GetItemScore(stats1, potentialWeights, specName, s1)
            local score2 = MSC.GetItemScore(stats2, potentialWeights, specName, s2)
            if score2 < score1 then targetSlot = s2 else targetSlot = s1 end
        end
        if link == l1 then targetSlot = s1 elseif link == l2 then targetSlot = s2 end
    end
    if itemEquipLoc == "INVTYPE_WEAPON" then
        local canDW = (class == "WARRIOR" or class == "ROGUE" or class == "HUNTER" or class == "SHAMAN")
        if canDW then
            local l1 = GetInventoryItemLink("player", 16)
            local l2 = GetInventoryItemLink("player", 17)
            if l1 and l2 then
                 local _,_,_,_,_,_,_,_, loc2 = GetItemInfo(l2)
                 if loc2 == "INVTYPE_WEAPON" or loc2 == "INVTYPE_WEAPONOFFHAND" then
                     local stats1 = MSC.SafeGetItemStats(l1, 16)
                     local stats2 = MSC.SafeGetItemStats(l2, 17)
                     local score1 = MSC.GetItemScore(stats1, potentialWeights, specName, 16)
                     local score2 = MSC.GetItemScore(stats2, potentialWeights, specName, 17)
                     if score2 < score1 then targetSlot = 17 end
                 end
            end
        end
    end

    -- 4. PREDICTIVE CAP LOGIC
    local compLink = GetInventoryItemLink("player", targetSlot)
    local useWeights = currentWeights 
    local capWarning = nil
    
    local newStats = MSC.SafeGetItemStats(link, targetSlot)
    local compStats = {}
    if compLink then compStats = MSC.SafeGetItemStats(compLink, targetSlot) end

    -- [[ FIX 2: REALITY CHECK ]] --
    -- Check actual player stats. Are we REALLY capped?
    -- Hit Cap ~ 9% (Rating conversion varies, checking raw % from API)
    local currentHitPct = GetCombatRatingBonus(6) 
    local playerIsHitCapped = (currentHitPct >= 8.9) -- Tolerance
    
    -- Expertise Cap ~ 5.6% - 6.5% (Dodge)
    local currentExpPct = GetCombatRatingBonus(24) 
    local playerIsExpCapped = (currentExpPct >= 5.5)

    -- A. Hit Prediction
    if playerIsHitCapped then
        local newHit = newStats["ITEM_MOD_HIT_RATING_SHORT"] or 0
        local oldHit = compStats["ITEM_MOD_HIT_RATING_SHORT"] or 0
        local deltaHit = newHit - oldHit
        if deltaHit < 0 then
            local hitLossPct = math.abs(deltaHit) / 15.77 
            local futureHit = currentHitPct - hitLossPct
            if futureHit < 9.0 then
                useWeights = potentialWeights
                capWarning = string.format("|cffff0000(Warning: Drops Hit to %.2f%%)|r", futureHit)
            end
        end
    end

    -- B. Expertise Prediction
    if playerIsExpCapped and not capWarning then
        local newExp = newStats["ITEM_MOD_EXPERTISE_RATING_SHORT"] or 0
        local oldExp = compStats["ITEM_MOD_EXPERTISE_RATING_SHORT"] or 0
        local deltaExp = newExp - oldExp
        if deltaExp < 0 then
            local expLossPct = math.abs(deltaExp) / 15.77 
            local futureExp = currentExpPct - expLossPct
            if futureExp < 5.5 then
                useWeights = potentialWeights
                capWarning = string.format("|cffff0000(Warning: Drops Exp to %.2f%%)|r", futureExp)
            end
        end
    end

    -- 5. CALCULATE SCORES
    local activeScore = MSC.GetItemScore(newStats, useWeights, specName, targetSlot)
    local potentialScore = MSC.GetItemScore(newStats, potentialWeights, specName, targetSlot)

    if MSC.GetWeaponSpecBonus then
        local bonus = MSC:GetWeaponSpecBonus(link, class, specName)
        activeScore = activeScore + bonus
        potentialScore = potentialScore + bonus
    end

    local simDiff = 0
    local currentScore = 0
    
    if compLink then
        if itemEquipLoc == "INVTYPE_2HWEAPON" and slotId == 16 then
            local offHandLink = GetInventoryItemLink("player", 17)
            if offHandLink then
               local ohStats = MSC.SafeGetItemStats(offHandLink, 17)
               for k,v in pairs(ohStats) do if type(v)=="number" then compStats[k]=(compStats[k] or 0)+v end end
            end
        end
        currentScore = MSC.GetItemScore(compStats, useWeights, specName, targetSlot)
        if MSC.GetWeaponSpecBonus then
            local compBonus = MSC:GetWeaponSpecBonus(compLink, class, specName)
            currentScore = currentScore + compBonus
        end
    end
    simDiff = activeScore - currentScore

    -- 6. DISPLAY HEADER
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine("|cff00ccffSharpie's Verdict:|r", "|cffffffff" .. specName .. "|r")
    
    if itemEquipLoc == "INVTYPE_2HWEAPON" and slotId == 16 then
        local offHandLink = GetInventoryItemLink("player", 17)
        if offHandLink then tooltip:AddLine("Comparing vs: Main Hand + Off Hand", 0.6, 0.6, 0.6)
        elseif compLink then tooltip:AddLine("Comparing vs: " .. compLink .. " (No OH)", 0.6, 0.6, 0.6) end
    elseif compLink and compLink ~= link then
        tooltip:AddLine("Comparing vs: " .. compLink, 0.6, 0.6, 0.6)
    elseif not compLink then
        tooltip:AddLine("|cff00ff00(Filling Empty Slot)|r")
    end
    
    -- [[ FIX 3: DISPLAY LOGIC ]] -- 
    -- Only show the "Potential / Capped" split if:
    -- 1. We actually have a warning (dropping below cap)
    -- 2. OR The player IS capped AND the score difference is significant
    local isReleventCap = (playerIsHitCapped or playerIsExpCapped)
    local showPotential = capWarning or (isReleventCap and (potentialScore - activeScore) > 5.0)

    if showPotential then
        tooltip:AddDoubleLine("|cff00ccffPotential Score:|r", string.format("%.1f", potentialScore), 1, 1, 1, 1, 1, 1)
        if capWarning then
            tooltip:AddLine(capWarning)
        else
            tooltip:AddDoubleLine("|cffffaa00(Hit/Exp Capped Value):|r", "|cffffaa00" .. string.format("%.1f", activeScore) .. "|r")
        end
    else
        tooltip:AddDoubleLine("|cff00ccffGearScore:|r", string.format("%.1f", activeScore), 1, 1, 1, 1, 1, 1)
    end

    -- 7. UPGRADE VERDICT
    if simDiff > 0.1 then tooltip:AddLine("|cff00ff00>> Upgrade (+" .. string.format("%.1f", simDiff) .. ") <<|r")
    elseif simDiff < -0.1 then tooltip:AddLine("|cffff0000<< Downgrade (" .. string.format("%.1f", simDiff) .. ") >>|r")
    else tooltip:AddLine("|cffaaaaaa(Sidegrade / No Change)|r") end

    -- 8. STAT BREAKDOWN (Existing Code)
    local currentStats = {}
    if compLink then currentStats = MSC.SafeGetItemStats(compLink, targetSlot) end
    if itemEquipLoc == "INVTYPE_2HWEAPON" and slotId == 16 then
        local offHandLink = GetInventoryItemLink("player", 17)
        if offHandLink then
            local ohStats = MSC.SafeGetItemStats(offHandLink, 17)
            for k, v in pairs(ohStats) do if type(v) == "number" then currentStats[k] = (currentStats[k] or 0) + v end end
        end
    end
    local oldExp = MSC.ExpandDerivedStats(currentStats, compLink)
    local newExp = MSC.ExpandDerivedStats(newStats, link)
    local diffs = MSC.GetStatDifferences(newExp, oldExp)
    local sorted = MSC.SortStatDiffs(diffs)
    for i, d in ipairs(sorted) do
        if i > 12 then break end
        local k, v = d.key, d.val
        if k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and k ~= "GEM_TEXT" and k ~= "ENCHANT_TEXT" and k~= "estimate" then
             local name = MSC.GetCleanStatName(k)
             local color = (v > 0) and "|cff00ff00" or "|cffff0000"
             local sign = (v > 0) and "+" or ""
             if math.abs(v) > 0.1 then tooltip:AddDoubleLine(name, color .. sign .. string.format("%.1f", v) .. "|r") end
        end
    end
    if newStats.IS_PROJECTED and newStats.ENCHANT_TEXT then tooltip:AddLine("(Enchant: |cffffffff" .. newStats.ENCHANT_TEXT .. "|r)", 0, 1, 1) end
    if newStats.GEMS_PROJECTED and newStats.GEM_TEXT then tooltip:AddLine("(Gems: |cffffffff" .. newStats.GEM_TEXT .. "|r)", 0, 1, 1) end

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
-- 5. EXPORT & HISTORY UTILITIES
-- =============================================================
function MSC.ExportData(dataRows, score, unitName)
    if not MSC.ExportFrame then
        local f = CreateFrame("Frame", "MSC_ExportFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(400, 300); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG"); f:EnableMouse(true); 
        f:SetMovable(true); f:RegisterForDrag("LeftButton") 
        f:SetScript("OnDragStart", f.StartMoving)
        f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleText:SetText("Export Data")
        
        local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -30); scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        local editBox = CreateFrame("EditBox", nil, scroll)
        editBox:SetMultiLine(true); editBox:SetFontObject("ChatFontNormal"); editBox:SetWidth(360)
        scroll:SetScrollChild(editBox); f.EditBox = editBox
        MSC.ExportFrame = f
    end
    local dateStr = date("%Y-%m-%d")
    local export = "**Sharpie's Gear Receipt** (" .. dateStr .. ")\nJudge: " .. unitName .. "\nScore: **" .. score .. "**\n----------------------------------\n"
    for _, row in ipairs(dataRows) do export = export .. "*" .. row.slot .. "*: " .. row.link .. " (" .. row.score .. ")\n" end
    MSC.ExportFrame.EditBox:SetText(export); MSC.ExportFrame.EditBox:HighlightText(); MSC.ExportFrame:Show()
end

function MSC.RecordSnapshot(eventLabel)
    if not SGJ_History then SGJ_History = {} end
    local key = UnitName("player") .. " - " .. GetRealmName()
    if not SGJ_History[key] then SGJ_History[key] = {} end
    local slots = {{id=1},{id=2},{id=3},{id=15},{id=5},{id=9},{id=10},{id=6},{id=7},{id=8},{id=11},{id=12},{id=13},{id=14},{id=16},{id=17},{id=18}}
    local currentWeights, specName = MSC.GetCurrentWeights()
    local totalScore = 0
    for i, slot in ipairs(slots) do
        local link = GetInventoryItemLink("player", slot.id)
        if link then local stats = MSC.SafeGetItemStats(link, slot.id); if stats then totalScore = totalScore + MSC.GetItemScore(stats, currentWeights, specName, slot.id) end end
    end
    local entry = { date = date("%Y-%m-%d"), label = eventLabel or "Snapshot", score = string.format("%.1f", totalScore), spec = specName }
    table.insert(SGJ_History[key], 1, entry) 
    if #SGJ_History[key] > 20 then table.remove(SGJ_History[key], #SGJ_History[key]) end
    print("|cff00ccffSharpie's Gear Judge:|r Snapshot recorded: |cff00ff00" .. (eventLabel or "Manual") .. "|r")
end

function MSC.ShowHistory()
    local key = UnitName("player") .. " - " .. GetRealmName()
    local charHistory = SGJ_History and SGJ_History[key]
    if not charHistory or #charHistory == 0 then print("|cffff0000SGJ:|r No history recorded for " .. key); return end
    if not MSC.HistoryFrame then
        local f = CreateFrame("Frame", "MSC_HistoryFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(350, 400); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleBg:SetHeight(30); f.TitleText:SetText("History: " .. UnitName("player")) 
        f.Scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate"); f.Scroll:SetPoint("TOPLEFT", 10, -30); f.Scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        f.Content = CreateFrame("Frame", nil, f.Scroll); f.Content:SetSize(310, 380); f.Scroll:SetScrollChild(f.Content)
        f.Rows = {}; MSC.HistoryFrame = f
    else MSC.HistoryFrame.TitleText:SetText("History: " .. UnitName("player")) end
    for _, row in pairs(MSC.HistoryFrame.Rows) do row:SetText("") end
    local yOffset = 0
    for i, entry in ipairs(charHistory) do
        if not MSC.HistoryFrame.Rows[i] then
            local row = MSC.HistoryFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row:SetPoint("TOPLEFT", 10, yOffset); row:SetWidth(300); row:SetJustifyH("LEFT"); MSC.HistoryFrame.Rows[i] = row
        end
        local color = "|cffffffff"; if entry.label:find("Level") then color = "|cff00ff00" end 
        local text = color .. entry.date .. "|r - " .. entry.label .. ": |cff00ccff" .. entry.score .. "|r"
        MSC.HistoryFrame.Rows[i]:SetText(text); yOffset = yOffset - 20
    end
    MSC.HistoryFrame:Show()
end