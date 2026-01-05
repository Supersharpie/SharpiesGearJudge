local _, MSC = ...

-- =============================================================
-- PART 1: THE LABORATORY (Now Smart & Clean)
-- =============================================================

local LabFrame = nil
local LabMH, LabOH, Lab2H = nil, nil, nil

-- [[ NEW SMART CALCULATOR ]]
function MSC.UpdateLabCalc()
    if not LabFrame or not LabFrame:IsShown() then return end
    
    -- 1. GET ENGINE DATA
    local weights, profileName = MSC.GetCurrentWeights()
    
    -- Pretty Name Fix
    local _, class = UnitClass("player")
    if MSC.PrettyNames and MSC.PrettyNames[class] and MSC.PrettyNames[class][profileName] then
        profileName = MSC.PrettyNames[class][profileName]
    end
    LabFrame.ProfileText:SetText("Profile: " .. profileName)
    
    -- Reset if empty
    if not LabMH.link and not LabOH.link and not Lab2H.link then
        LabFrame.ScoreCurrent:SetText(""); LabFrame.ScoreNew:SetText("")
        LabFrame.Result:SetText("Shift+Click items to add"); LabFrame.Details:SetText("")
        return
    end

    -- 2. SNAPSHOT CURRENT CHARACTER (The Baseline)
    -- We use the Evaluator to get the TRUE score (Sets, Hit Cap, etc included)
    local currentGear = MSC:GetEquippedGear() 
    local currentScore, currentStats = MSC:GetTotalCharacterScore(currentGear, weights)

    -- 3. DEFINE SCENARIOS
    local scoreA, statsA = 0, {}
    local scoreB, statsB = 0, {}
    local mode = "NORMAL" -- 'NORMAL' or 'COMPARE'

    -- Scenario A: 2H vs Dual Wield (Internal Lab Comparison)
    if (LabMH.link or LabOH.link) and Lab2H.link then
        mode = "COMPARE"
        
        -- Build Virtual DW Set
        local setDW = MSC:SafeCopy(currentGear)
        setDW[16] = LabMH.link
        setDW[17] = LabOH.link 
        
        -- Build Virtual 2H Set
        local set2H = MSC:SafeCopy(currentGear)
        set2H[16] = Lab2H.link
        set2H[17] = nil -- Must unequip OH for 2H
        
        scoreA, statsA = MSC:GetTotalCharacterScore(setDW, weights)
        scoreB, statsB = MSC:GetTotalCharacterScore(set2H, weights)

        LabFrame.ScoreCurrent:SetText(string.format("Dual Wield: %.1f", scoreA))
        LabFrame.ScoreNew:SetText(string.format("2-Hander: %.1f", scoreB))
        
        local diff = scoreB - scoreA
        if diff > 0.1 then LabFrame.Result:SetText("|cff00ff002H WINS (+"..string.format("%.1f", diff)..")|r")
        elseif diff < -0.1 then LabFrame.Result:SetText("|cffff00002H LOSES ("..string.format("%.1f", diff)..")|r")
        else LabFrame.Result:SetText("|cffaaaaaaEven (0.0)|r") end

    -- Scenario B: Lab Item(s) vs Currently Equipped
    else
        -- Build Virtual Custom Set
        local setCustom = MSC:SafeCopy(currentGear)
        if Lab2H.link then
            setCustom[16] = Lab2H.link
            setCustom[17] = nil
        else
            if LabMH.link then setCustom[16] = LabMH.link end
            if LabOH.link then setCustom[17] = LabOH.link end
        end
        
        scoreA, statsA = currentScore, currentStats
        scoreB, statsB = MSC:GetTotalCharacterScore(setCustom, weights)
        
        LabFrame.ScoreCurrent:SetText(string.format("Current: %.1f", scoreA))
        LabFrame.ScoreNew:SetText(string.format("Custom: %.1f", scoreB))
        
        local diff = scoreB - scoreA
        if diff > 0.1 then LabFrame.Result:SetText("|cff00ff00UPGRADE (+"..string.format("%.1f", diff)..")|r")
        elseif diff < -0.1 then LabFrame.Result:SetText("|cffff0000DOWNGRADE ("..string.format("%.1f", diff)..")|r")
        else LabFrame.Result:SetText("|cffaaaaaaSidegrade (0.0)|r") end
    end

    -- 4. CLEAN STAT BREAKDOWN (New UI Logic)
    -- Define keys to hide
    local hiddenKeys = {
        ["IS_PROJECTED"] = true, ["GEMS_PROJECTED"] = true, ["BONUS_PROJECTED"] = true,
        ["GEM_TEXT"] = true, ["ENCHANT_TEXT"] = true, ["estimate"] = true
    }
    
    -- Calculate difference
    local statDiffs = MSC.GetStatDifferences(statsB, statsA)
    local sorted = MSC.SortStatDiffs(statDiffs)
    local lines = ""
    local c = 0
    
    for _, e in ipairs(sorted) do
        if c >= 10 then break end
        
        -- Filter out hidden keys and tiny numbers
        if not hiddenKeys[e.key] and math.abs(e.val) > 0.05 then
            local name = MSC.GetCleanStatName(e.key)
            local valStr = string.format("%.1f", e.val)
            local color = (e.val > 0) and "|cff00ff00" or "|cffff0000"
            local sign = (e.val > 0) and "+" or ""
            
            lines = lines .. "|cffffd100" .. name .. ":|r " .. color .. sign .. valStr .. "|r\n"
            c = c + 1
        end
    end
    LabFrame.Details:SetText(lines)
end

-- =============================================================
-- FRAME CREATION
-- =============================================================
local function CreateItemButton(name, parent, x, y, iconType, labelText)
    local btn = CreateFrame("Button", name, parent, "ItemButtonTemplate")
    btn:SetPoint("CENTER", parent, "CENTER", x, y)
    btn:RegisterForClicks("AnyUp")
    
    if MSC.ApplyElvUISkin then MSC.ApplyElvUISkin(btn) end
    
    btn.empty = btn:CreateTexture(nil, "BACKGROUND")
    btn.empty:SetAllPoints(btn)
    btn.empty:SetTexture(iconType == "OH" and "Interface\\Paperdoll\\UI-PaperDoll-Slot-SecondaryHand" or "Interface\\Paperdoll\\UI-PaperDoll-Slot-MainHand")
    btn.empty:SetAlpha(0.5)
    
    local r, g, b, a = 0.2, 0.8, 1.0, 0.6; local thick = 2
    btn.bT = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bT:SetColorTexture(r, g, b, a); btn.bT:SetPoint("TOPLEFT"); btn.bT:SetPoint("TOPRIGHT"); btn.bT:SetHeight(thick)
    btn.bB = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bB:SetColorTexture(r, g, b, a); btn.bB:SetPoint("BOTTOMLEFT"); btn.bB:SetPoint("BOTTOMRIGHT"); btn.bB:SetHeight(thick)
    btn.bL = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bL:SetColorTexture(r, g, b, a); btn.bL:SetPoint("TOPLEFT"); btn.bL:SetPoint("BOTTOMLEFT"); btn.bL:SetWidth(thick)
    btn.bR = btn:CreateTexture(nil, "OVERLAY", nil, 7); btn.bR:SetColorTexture(r, g, b, a); btn.bR:SetPoint("TOPRIGHT"); btn.bR:SetPoint("BOTTOMRIGHT"); btn.bR:SetWidth(thick)

    btn.Label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); btn.Label:SetPoint("BOTTOM", btn, "TOP", 0, 3); btn.Label:SetText(labelText); btn.Label:SetTextColor(0.8, 0.8, 0.8, 1)

    if not btn.icon then btn.icon = _G[name.."Icon"] end

    -- TOOLTIP
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if self.link then 
            if GetItemInfo(self.link) then GameTooltip:SetHyperlink(self.link) 
            else GameTooltip:SetText(labelText); GameTooltip:AddLine("|cffaaaaaa(Loading...)|r") end
        else 
            GameTooltip:SetText(labelText); GameTooltip:AddLine("|cffaaaaaaShift+Click to link|r") 
        end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", GameTooltip_Hide)

    btn:SetScript("OnClick", function(self)
        local type, _, link = GetCursorInfo()
        if type == "item" then
            if not MSC.IsItemUsable(link) then
                if not SGJ_Settings.MuteSounds then PlaySound(847, "Master") end
                print("|cffff0000Sharpie:|r You cannot use this!")
                ClearCursor(); return
            end
            self.link = link; 
            if self.icon then 
                local texture = select(10, GetItemInfo(link))
                self.icon:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark") 
            end
            self.empty:Hide(); ClearCursor(); MSC.UpdateLabCalc()
        elseif IsShiftKeyDown() then 
            self.link = nil; 
            if self.icon then self.icon:SetTexture(nil) end
            self.empty:Show(); MSC.UpdateLabCalc() 
        end
    end)
    return btn
end

function MSC.CreateLabFrame()
    if MSCLabFrame then 
        if MSCLabFrame:IsShown() then MSCLabFrame:Hide() else MSCLabFrame:Show() end
        return 
    end
    
    local f = CreateFrame("Frame", "MSCLabFrame", UIParent)
    f:SetSize(360, 420); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    
    f.bg = f:CreateTexture(nil, "BACKGROUND"); f.bg:SetAllPoints(f); f.bg:SetColorTexture(0, 0, 0, 0.9) 
    if MSC.ApplyElvUISkin then MSC.ApplyElvUISkin(f) end

    local _, class = UnitClass("player")
    if class then
        local fixed = class:sub(1,1) .. class:sub(2):lower()
        f.crest = f:CreateTexture(nil, "ARTWORK"); f.crest:SetAllPoints(f)
        pcall(function() f.crest:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. fixed .. ".tga") end)
        f.crest:SetVertexColor(0.6, 0.6, 0.6, 0.6)
    end
    
    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"); f.title:SetPoint("TOP", f, "TOP", 0, -10); f.title:SetText("Sharpie's Gear Judge")
    
    LabFrame = f -- Assign global reference
    LabMH = CreateItemButton("MSCLabMH", f, -65, 120, "MH", "Main Hand")
    LabOH = CreateItemButton("MSCLabOH", f, 65, 120, "OH", "Off Hand")
    Lab2H = CreateItemButton("MSCLab2H", f, 0, 50, "2H", "Two-Hand")

    f.Instruction = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); f.Instruction:SetPoint("TOP", Lab2H, "BOTTOM", 0, -5); f.Instruction:SetText("(Shift+Click to clear)"); f.Instruction:SetTextColor(0.5, 0.5, 0.5, 1)
    
    f.ProfileText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); f.ProfileText:SetPoint("TOP", f, "TOP", 0, -30)
    f.ScoreCurrent = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.ScoreCurrent:SetPoint("CENTER", f, "CENTER", 0, -10)
    f.ScoreNew = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.ScoreNew:SetPoint("CENTER", f, "CENTER", 0, -30)
    f.Result = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"); f.Result:SetPoint("CENTER", f, "CENTER", 0, -50)
    f.Details = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); f.Details:SetPoint("TOP", f.Result, "BOTTOM", 0, -10); f.Details:SetJustifyH("CENTER")
    
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
    
    MSC.UpdateLabCalc()
end

-- =============================================================
-- ATLASLOOT / CHAT LINK SUPPORT
-- =============================================================
local function LoadLabItem(btn, link)
    if not btn or not link then return end
    btn.link = link
    if btn.icon then btn.icon:SetTexture(select(10, GetItemInfo(link))) end
    btn.empty:Hide()
end

hooksecurefunc("ChatEdit_InsertLink", function(text)
    if LabMH and LabMH:IsMouseOver() then return end
    if LabOH and LabOH:IsMouseOver() then return end
    if Lab2H and Lab2H:IsMouseOver() then return end

    if text and LabFrame and LabFrame:IsShown() and string.find(text, "item:", 1, true) then
        local equipLoc = select(9, GetItemInfo(text))
        
        if equipLoc == "INVTYPE_2HWEAPON" then
            LoadLabItem(Lab2H, text)
        elseif equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND" then
            LoadLabItem(LabOH, text)
        elseif equipLoc == "INVTYPE_WEAPON" then
             local _, class = UnitClass("player")
             local canDW = (class == "ROGUE" or class == "WARRIOR" or class == "HUNTER" or class == "SHAMAN")
             if canDW and LabMH.link and not LabOH.link then
                  LoadLabItem(LabOH, text)
             else
                  LoadLabItem(LabMH, text)
             end
        elseif equipLoc == "INVTYPE_WEAPONMAINHAND" then
            LoadLabItem(LabMH, text)
        else
            return 
        end
        MSC.UpdateLabCalc()
        
        local editBox = ChatEdit_GetActiveWindow()
        if editBox and editBox:GetText() == text then
            editBox:SetText("")
            editBox:Hide()
        end
    end
end)

-- =============================================================
-- PART 2: THE RECEIPT (Kept Intact)
-- =============================================================
local function CheckBagsForUpgrade(slotId, currentScore, weights, specName)
    local bestBagItem, bestBagScore = nil, currentScore
    for bag = 4, 0, -1 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local link = C_Container.GetContainerItemLink(bag, slot)
            if link then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                local itemSlotId = MSC.SlotMap[equipLoc]
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
                        if score > bestBagScore + 0.1 then 
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

local function IsMissingEnchant(itemLink, slotId)
    if not itemLink then return false end
    local validSlots = { [15]=true, [5]=true, [9]=true, [10]=true, [8]=true, [16]=true, [17]=true }
    if not validSlots[slotId] then return false end
    if slotId == 17 then local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink); if equipLoc == "INVTYPE_HOLDABLE" then return false end end
    local itemString = string.match(itemLink, "item[%-?%d:]+")
    if not itemString then return false end
    local _, _, enchantID = strsplit(":", itemString)
    if not enchantID or enchantID == "" or enchantID == "0" then return true end
    return false
end

function MSC.ShowReceipt(unitOverride, skipInspect)
    local unit = unitOverride or "player"
    local isPlayer = (unit == "player")
    local unitName = UnitName(unit)
    local _, unitClass = UnitClass(unit)
    
    local currentWeights, specName
    if isPlayer then
        currentWeights, specName = MSC.GetCurrentWeights()
    else
        local detectedSpec = MSC.GetInspectSpec(unit)
        local profileName = detectedSpec
        if not profileName or profileName == "Default" then profileName = "Default"; specName = unitClass .. " (Default)"
        else specName = unitClass .. " (" .. profileName .. ")" end
        if unitClass and MSC.WeightDB[unitClass] and MSC.WeightDB[unitClass][profileName] then currentWeights = MSC.WeightDB[unitClass][profileName]
        elseif unitClass and MSC.WeightDB[unitClass] and MSC.WeightDB[unitClass]["Default"] then currentWeights = MSC.WeightDB[unitClass]["Default"]
        else print("|cffff0000SGJ:|r Unsupported Class for Inspection."); return end
    end

    if not MSC.ReceiptFrame then
        local f = CreateFrame("Frame", "SGJ_ReceiptFrame_v19", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(420, 600); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleBg:SetHeight(30); f.TitleText:SetText("Sharpie's Gear Receipt")
        local _, classFilename = UnitClass("player"); local color = RAID_CLASS_COLORS[classFilename]
        if f.SetBorderColor then f:SetBorderColor(color.r, color.g, color.b) end 
        if MSC.ApplyElvUISkin then MSC.ApplyElvUISkin(f) end

        f:RegisterEvent("GET_ITEM_INFO_RECEIVED"); f:RegisterEvent("INSPECT_READY")
        f:SetScript("OnEvent", function(self, event, ...)
            local guid = ...
            if event == "INSPECT_READY" and self.unitGUID and guid ~= self.unitGUID then return end
            if self:IsVisible() and self.unitID then 
                if not self.updatePending then
                    self.updatePending = true
                    C_Timer.After(0.2, function() if self:IsVisible() then MSC.ShowReceipt(self.unitID, true) end; self.updatePending = false end)
                end
            end
        end)
        MSC.ReceiptFrame = f
        
        f.Scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        f.Scroll:SetPoint("TOPLEFT", 10, -30); f.Scroll:SetPoint("BOTTOMRIGHT", -30, 185) 
        f.Content = CreateFrame("Frame", nil, f.Scroll); f.Content:SetSize(380, 480); f.Scroll:SetScrollChild(f.Content)
        
        f.SummaryBox = CreateFrame("Frame", nil, f); f.SummaryBox:SetPoint("TOPLEFT", f.Scroll, "BOTTOMLEFT", 0, -5); f.SummaryBox:SetPoint("BOTTOMRIGHT", -10, 100) 
        f.Separator = f.SummaryBox:CreateTexture(nil, "ARTWORK"); f.Separator:SetHeight(1); f.Separator:SetPoint("TOPLEFT", 10, 0); f.Separator:SetPoint("TOPRIGHT", -10, 0); f.Separator:SetColorTexture(1, 0.82, 0, 0.5) 
        f.SummaryBg = f.SummaryBox:CreateTexture(nil, "BACKGROUND"); f.SummaryBg:SetPoint("TOPLEFT", 0, -5); f.SummaryBg:SetPoint("BOTTOMRIGHT", 0, 0); f.SummaryBg:SetColorTexture(0, 0, 0, 0.3)
        
        f.SummaryTitle = f.SummaryBox:CreateFontString(nil, "OVERLAY", "GameFontNormal"); 
        f.SummaryTitle:SetPoint("TOPLEFT", 10, -12); 
        f.SummaryTitle:SetText("COMBINED STATS FROM GEAR"); 
        f.SummaryTitle:SetTextColor(1, 0.82, 0) 
        
        f.TotalText = f.SummaryBox:CreateFontString(nil, "OVERLAY", "GameFontNormal"); 
        f.TotalText:SetPoint("TOPRIGHT", -10, -12); 
        f.TotalText:SetTextColor(color.r, color.g, color.b) 
        
        f.FooterBg = f:CreateTexture(nil, "BACKGROUND"); f.FooterBg:SetPoint("BOTTOMLEFT", 4, 4); f.FooterBg:SetPoint("BOTTOMRIGHT", -4, 4); f.FooterBg:SetHeight(90); f.FooterBg:SetColorTexture(0, 0, 0, 0.5) 
        
        f.SaveBox = CreateFrame("EditBox", nil, f, "InputBoxTemplate"); f.SaveBox:SetSize(160, 24); f.SaveBox:SetPoint("BOTTOMLEFT", 30, 38); f.SaveBox:SetAutoFocus(false); f.SaveBox:SetText("< set name here >"); f.SaveBox:SetCursorPosition(0)
        f.SaveBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate"); f.SaveBtn:SetSize(80, 24); f.SaveBtn:SetPoint("LEFT", f.SaveBox, "RIGHT", 10, 0); f.SaveBtn:SetText("Save")
        f.SaveBtn:SetScript("OnClick", function() local txt = f.SaveBox:GetText(); local label = (txt and txt ~= "" and txt ~= "< set name here >") and txt or "Manual Save"; MSC.RecordSnapshot(label); MSC.ShowHistory(); f.SaveBox:ClearFocus(); f.SaveBox:SetText("< set name here >") end)

        local mathBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        mathBtn:SetSize(100, 24)
        mathBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -20, 10) 
        mathBtn:SetText("MATH MODE")
        mathBtn:SetScript("OnClick", function() 
            if MSC.ShowMathBreakdown then MSC.ShowMathBreakdown() else print("|cffff0000Error:|r Breakdown module missing.") end
        end)

        local targetBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate"); targetBtn:SetSize(100, 24); targetBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 20, 10); targetBtn:SetText("Judge Target"); targetBtn:SetScript("OnClick", function() if UnitExists("target") and UnitIsPlayer("target") then MSC.ShowReceipt("target") else print("|cffff0000SGJ:|r Invalid Target.") end end)
        local exportBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate"); exportBtn:SetSize(80, 24); exportBtn:SetPoint("BOTTOM", f, "BOTTOM", 0, 10); exportBtn:SetText("Export"); exportBtn:SetScript("OnClick", function() local data = f.printData; if not data then return end; MSC.ExportData(data.rows, data.score, f.unitName or "Player") end)

        MSC.ReceiptRows = {}; MSC.SummaryRows = {}
    end
    
    MSC.ReceiptFrame.unitName = unitName; MSC.ReceiptFrame.unitID = unit 
    if not isPlayer then MSC.ReceiptFrame.unitGUID = UnitGUID(unit); if not skipInspect then NotifyInspect(unit) end; MSC.ReceiptFrame.SaveBox:Hide(); MSC.ReceiptFrame.SaveBtn:Hide() else MSC.ReceiptFrame.unitGUID = nil; MSC.ReceiptFrame.SaveBox:Show(); MSC.ReceiptFrame.SaveBtn:Show() end
    if isPlayer then MSC.ReceiptFrame.TitleText:SetText("Sharpie's Gear Receipt") else MSC.ReceiptFrame.TitleText:SetText("Judge: " .. unitName .. " (" .. (MSC.GetInspectSpec(unit) or "?") .. ")") end
    MSC.ReceiptFrame:Show()
    
    local slots = {{name="Head",id=1},{name="Neck",id=2},{name="Shoulder",id=3},{name="Back",id=15},{name="Chest",id=5},{name="Wrist",id=9},{name="Hands",id=10},{name="Waist",id=6},{name="Legs",id=7},{name="Feet",id=8},{name="Finger 1",id=11},{name="Finger 2",id=12},{name="Trinket 1",id=13},{name="Trinket 2",id=14},{name="Main Hand",id=16},{name="Off Hand",id=17},{name="Ranged",id=18}}
    
    local gearTable = {}
    for _, slot in ipairs(slots) do
        local link = GetInventoryItemLink(unit, slot.id)
        if link then gearTable[slot.id] = link end
    end
    
    local trueTotalScore = MSC:GetTotalCharacterScore(gearTable, currentWeights)
    
    local combinedStats = {}; local yOffset = 0; local maxItemScore = -1; local maxItemLink = nil; local missingSlots = {}; local exportRows = {} 
    
    for i, slot in ipairs(slots) do
        if not MSC.ReceiptRows[i] then
             local row = CreateFrame("Frame", nil, MSC.ReceiptFrame.Content); row:SetSize(380, 24); row.BG = row:CreateTexture(nil, "BACKGROUND"); row.BG:SetAllPoints(); row.Icon = row:CreateTexture(nil, "ARTWORK"); row.Icon:SetSize(20, 20); row.Icon:SetPoint("LEFT", 4, 0); row.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92); row.Label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); row.Label:SetPoint("LEFT", row.Icon, "RIGHT", 8, 0); row.Label:SetWidth(65); row.Label:SetJustifyH("LEFT"); row.Label:SetTextColor(0.6, 0.6, 0.6); row.Score = row:CreateFontString(nil, "OVERLAY", "GameFontNormal"); row.Score:SetPoint("RIGHT", -5, 0); row.Score:SetWidth(60); row.Score:SetJustifyH("RIGHT"); row.Score:SetTextColor(0, 1, 0); row.Item = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row.Item:SetPoint("LEFT", row.Label, "RIGHT", 5, 0); row.Item:SetPoint("RIGHT", row.Score, "LEFT", -5, 0); row.Item:SetJustifyH("LEFT"); row.Alert = row:CreateTexture(nil, "OVERLAY"); row.Alert:SetSize(16, 16); row.Alert:SetPoint("RIGHT", row.Score, "LEFT", -5, 0); row.Alert:Hide(); 
             
             row.AlertFrame = CreateFrame("Frame", nil, row); row.AlertFrame:SetAllPoints(row.Alert); 
             row.AlertFrame:SetScript("OnEnter", function(self) 
                if self.mode == "UPGRADE" and self.link then 
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); 
                    if GetItemInfo(self.link) then
                        GameTooltip:SetHyperlink(self.link); 
                        GameTooltip:AddLine(" "); 
                        local diffText = self.diff and string.format("%.1f", self.diff) or "?"
                        GameTooltip:AddLine("|cff00ff00THE BETTER ITEM (+" .. diffText .. ")|r"); 
                        GameTooltip:AddLine("|cff888888Shift-Click to Link|r");
                    else
                        GameTooltip:SetText("Loading Item Data...")
                    end
                    GameTooltip:Show() 
                elseif self.mode == "ENCHANT" then 
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); 
                    GameTooltip:SetText("|cffff0000MISSING ENCHANT!|r"); 
                    GameTooltip:AddLine("You are losing potential stats.", 1, 1, 1); 
                    GameTooltip:Show() 
                end 
             end); 
             row.AlertFrame:SetScript("OnLeave", GameTooltip_Hide);
             row.AlertFrame:SetScript("OnMouseUp", function(self)
                 if self.mode == "UPGRADE" and self.link then
                    if IsShiftKeyDown() then ChatEdit_InsertLink(self.link)
                    else HandleModifiedItemClick(self.link) end
                 end
             end)
             MSC.ReceiptRows[i] = row
        end
        local row = MSC.ReceiptRows[i]; row:SetPoint("TOPLEFT", 0, yOffset)
        local link = GetInventoryItemLink(unit, slot.id); local texture = GetInventoryItemTexture(unit, slot.id); local itemScore = 0; local itemText = "|cff444444(Empty)|r"
        row.Alert:Hide(); row.AlertFrame.mode = nil; row.AlertFrame.link = nil; row.AlertFrame.diff = nil

        if link then
            itemText = link; local stats = MSC.SafeGetItemStats(link, slot.id)
            if stats then 
                itemScore = MSC.GetItemScore(stats, currentWeights, specName, slot.id); 
                for k, v in pairs(stats) do if type(v) == "number" then combinedStats[k] = (combinedStats[k] or 0) + v end end 
                if itemScore > maxItemScore then maxItemScore = itemScore; maxItemLink = link end
            end
            if IsMissingEnchant(link, slot.id) then row.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertOther"); row.Alert:Show(); row.AlertFrame.mode = "ENCHANT" end
        else table.insert(missingSlots, slot.name) end
        
        if isPlayer then
            local upgradeLink, upgradeScore = CheckBagsForUpgrade(slot.id, itemScore, currentWeights, specName)
            if upgradeLink then 
                row.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew"); 
                row.Alert:Show(); 
                row.AlertFrame.mode = "UPGRADE"; 
                row.AlertFrame.link = upgradeLink
                row.AlertFrame.diff = upgradeScore - itemScore
            end
        end
        
        row.Label:SetText(slot.name); row.Item:SetText(itemText); row.Score:SetText(string.format("%.1f", itemScore))
        if texture then row.Icon:SetTexture(texture); row.Icon:SetDesaturated(false) else row.Icon:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot"); row.Icon:SetDesaturated(true) end
        if i % 2 == 0 then row.BG:SetColorTexture(1, 1, 1, 0.03) else row.BG:SetColorTexture(0, 0, 0, 0) end; yOffset = yOffset - 24
        table.insert(exportRows, { slot = slot.name, link = (link or "(Empty)"), score = string.format("%.1f", itemScore) })
    end
    
    MSC.ReceiptFrame.printData = { score = string.format("%.1f", trueTotalScore), topLink = maxItemLink, missing = missingSlots, rows = exportRows }
    
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
            local f = CreateFrame("Frame", nil, MSC.ReceiptFrame.SummaryBox); f:SetSize(160, 16); f.Label = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); f.Label:SetPoint("LEFT", 0, 0); f.Value = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.Value:SetPoint("RIGHT", 0, 0); MSC.SummaryRows[i] = f
        end
        local row = MSC.SummaryRows[i]; row:Show()
        local cleanName = MSC.GetCleanStatName(data.key); local labelColor = "|cff888888" 
        if data.realWeight > 0 then labelColor = "|cff00ff00" end 
        row.Label:SetText(labelColor .. cleanName .. ":|r"); row.Value:SetText(string.format("%.1f", data.val))
        local isLeft = (i % 2 ~= 0); local rowIdx = math.ceil(i / 2) - 1; local yPos = startY - (rowIdx * 16)
        if isLeft then row:SetPoint("TOPLEFT", col1X, yPos) else row:SetPoint("TOPLEFT", col2X, yPos) end
    end
    
    MSC.ReceiptFrame.TotalText:SetText("SCORE: " .. string.format("%.1f", trueTotalScore))
end

-- =============================================================
-- PART 3: MATH BREAKDOWN WINDOW (Kept Intact)
-- =============================================================
local function GetStatReason(stat, class, profileName)
        if not profileName then profileName = "" end
        if stat:find("HIT") then return "Reduces Chance to Miss" end
        if stat:find("HASTE") then return "Increases Casting/Attack Speed" end
        if stat:find("CRIT") and not stat:find("FROM_STATS") then 
            if profileName:find("HOLY") or profileName:find("RESTO") then return "Crit Heals & Mana Refund" end
            return "Higher Critical Strike Chance" 
        end
        if stat:find("EXPERTISE") then return "Reduces Enemy Dodge/Parry" end
        if stat:find("RESILIENCE") then return "Reduces Crit Chance & DMG Taken" end
        if stat:find("ARMOR_PENETRATION") then return "Ignores Portion of Enemy Armor" end
        if stat:find("DEFENSE_SKILL") then return "Increases Avoidance & Crit Cap" end
        if stat:find("SHADOW") then return "Shadow Spell Scaling" end
        if stat:find("FIRE") then return "Fire Spell Scaling" end
        if stat:find("FROST") then return "Frost Spell Scaling" end
        if stat:find("ARCANE") then return "Arcane Spell Scaling" end
        if stat:find("NATURE") then return "Nature Spell Scaling" end
        if stat:find("HOLY") and not profileName:find("HOLY") then return "Holy Spell Scaling" end
        if stat == "ITEM_MOD_INTELLECT_SHORT" then 
            if class == "SHAMAN" and profileName:find("ENH") then return "Mental Dexterity (Int -> AP)" end
            if class == "HUNTER" then return "Mana Pool (Viper Scaling)" end
            if class == "MAGE" or class == "WARLOCK" then return "Mana Pool & Spell Crit" end
            return "Mana Pool & Intellect"
        end
        if stat == "ITEM_MOD_STRENGTH_SHORT" then 
            if class == "WARRIOR" or class == "PALADIN" then return "Attack Power & Block Value" end
            return "Melee Attack Power"
        end
        if stat == "ITEM_MOD_AGILITY_SHORT" then 
            if class == "ROGUE" or class == "HUNTER" then return "AP, Crit, and Armor" end
            return "Crit, Dodge, and Armor"
        end
        if stat == "ITEM_MOD_SPIRIT_SHORT" then 
            if profileName:find("Shadow") then return "Spirit Tap Efficiency" end
            if class == "PRIEST" or class == "DRUID" then return "Spiritual Guidance / Regen" end
            return "Out-of-Combat Regeneration"
        end
        if stat == "ITEM_MOD_STAMINA_SHORT" then 
            if profileName:find("Demo") then return "Demonic Knowledge (Stam -> SP)" end
            return "Increases Total Health" 
        end
        if stat == "ITEM_MOD_SPELL_POWER_SHORT" then return "Raw Spell Scaling" end
        if stat == "ITEM_MOD_HEALING_POWER_SHORT" then return "Raw Healing Output" end
        if stat == "ITEM_MOD_ATTACK_POWER_SHORT" or stat == "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" then return "Direct Damage Increase" end
        if stat == "ITEM_MOD_MANA_REGENERATION_SHORT" then return "Mana per 5 Sec (Sustain)" end
        if stat == "ITEM_MOD_HEALTH_REGENERATION_SHORT" then return "Health per 5 Sec" end
        if stat == "MSC_WEAPON_DPS" or stat == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" then return "Weapon Damage (Priority)" end
        if stat == "MSC_WAND_DPS" then return "Wand DPS (Leveling Speed)" end
        if stat == "ITEM_MOD_BLOCK_VALUE_SHORT" then return "DMG Blocked / Shield Slam" end
        if stat == "ITEM_MOD_BLOCK_RATING_SHORT" then return "Chance to Block" end
        if stat == "ITEM_MOD_DODGE_RATING_SHORT" then return "Chance to Dodge" end
        if stat == "ITEM_MOD_PARRY_RATING_SHORT" then return "Chance to Parry" end
        if profileName:find("Leveling") and stat == "ITEM_MOD_SPIRIT_SHORT" then return "Less Downtime (Eating/Drinking)" end
        return nil
    end

function MSC.ShowMathBreakdown()
    if not MSC.MathFrame then
        local f = CreateFrame("Frame", "SGJ_MathFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(400, 500); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleBg:SetHeight(30); f.TitleText:SetText("Stat Weight Breakdown")
        
        f.Scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        f.Scroll:SetPoint("TOPLEFT", 10, -30); f.Scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        f.Content = CreateFrame("Frame", nil, f.Scroll); f.Content:SetSize(360, 1000); f.Scroll:SetScrollChild(f.Content)
        
        f.text = f.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); 
        f.text:SetPoint("TOPLEFT", 10, -10); f.text:SetWidth(340); f.text:SetJustifyH("LEFT")
        
        MSC.MathFrame = f
    end
    
    MSC.MathFrame:Show()
    
    local weights, detectedKey = MSC.GetCurrentWeights()
    local _, class = UnitClass("player")
    local log = {}
    
    local function add(text, isHeader)
        if isHeader then table.insert(log, "\n|cffffd100" .. text .. "|r") else table.insert(log, text) end
    end

    add("=== CURRENT PROFILE ===", true)
    add("Class: " .. class); add("Spec/Key: " .. detectedKey)
    
    add("=== FINAL EP VALUES (1 Point = ...) ===", true)
    local sorted = {}
    for k,v in pairs(weights) do table.insert(sorted, {k=k, v=v}) end
    table.sort(sorted, function(a,b) return a.v > b.v end)
    
    for _, data in ipairs(sorted) do
        local stat, finalVal = data.k, data.v
        local prettyName = MSC.ShortNames[stat] or stat
        local note, reason = "", GetStatReason(stat, class, detectedKey)
        
        if finalVal < 0.02 and (stat:find("HIT") or stat:find("EXPERTISE")) then note = "|cffff0000(Capped)|r" 
        elseif reason then note = "|cff888888[" .. reason .. "]|r" 
        else note = "|cff888888(Profile Base)|r" end
        
        if finalVal > 0.01 then add(format("%s: |cff00ccff%.2f|r %s", prettyName, finalVal, note)) end
    end

    add("=== HOW TO READ THIS RECEIPT ===", true)
    add("• The Score is calculated using 'Equivalence Points' (EP).")
    add("• 1.0 EP is roughly equal to 1 Attack Power or Spell Power.")
    add("• Example: If Intellect is 0.8, then 10 Int = 8 Score.")
    add("• Hit Cap: If you are over the cap, Hit Rating becomes worth 0.01.")

    MSC.MathFrame.text:SetText(table.concat(log, "\n"))
end