local addonName, MSC = ...
_G.MSC = MSC 

-- [[ SPEED OPTIMIZATION: LOCALIZED FUNCTIONS ]]
local pairs, ipairs, next, type, tostring, unpack, select = pairs, ipairs, next, type, tostring, unpack, select
local table_insert, table_sort = table.insert, table.sort
local math_floor, math_ceil, math_max, math_min, math_abs = math.floor, math.ceil, math.max, math.min, math.abs
local string_format, string_find = string.format, string.find
local GetTime = GetTime

-- WoW APIs (UI & Data)
local CreateFrame = CreateFrame
local UIParent = UIParent
local GameTooltip = GameTooltip
local GetItemInfo = GetItemInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemTexture = GetInventoryItemTexture
local GetItemIcon = GetItemIcon
local SetItemButtonTexture = SetItemButtonTexture
local UnitClass = UnitClass
local UnitRace = UnitRace
local UnitLevel = UnitLevel
local UnitName = UnitName
local GetRealmName = GetRealmName
local GetCursorInfo = GetCursorInfo
local ClearCursor = ClearCursor
local IsShiftKeyDown = IsShiftKeyDown
local CreateColor = CreateColor
local GetItemInfoInstant = GetItemInfoInstant

-- Container API Wrapper
local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink


local version = C_AddOns and C_AddOns.GetAddOnMetadata(addonName, "Version") 
               or GetAddOnMetadata(addonName, "Version") 
               or "2.x"

MSC.Version = version


-- =============================================================
-- 1. THEME, COLORS & HELPERS
-- =============================================================
MSC.Colors = { 
    BgSidebar = {0.05, 0.05, 0.05, 1.00}, 
    BgPanel   = {0.00, 0.00, 0.00, 0.50},
    BarHigh   = {0.0, 0.8, 1.0, 1.0} 
}

-- [[ STAT COLORS ]]
MSC.StatColors = {
    -- [[ MAGIC STATS ]]
    SPELL_HIT   = {0.0, 1.0, 0.8},   -- Teal/Cyan (Distinct from Melee Green)
    SPELL_CRIT  = {0.8, 0.2, 1.0},   -- Bright Purple/Pink (Distinct from Melee Red)
    SPELL_POWER = {0.6, 0.4, 1.0},   -- Deep Purple
    MANA        = {0.0, 0.5, 1.0},   -- Mana Blue
    INTELLECT   = {0.2, 0.6, 1.0},   -- Cyan
    SPIRIT      = {0.6, 0.6, 1.0},   -- Lavender
    -- [[ PHYSICAL STATS ]]
    STAMINA = {0.6, 0.2, 0.2},       -- Dark Red
    AGILITY = {0.2, 1.0, 0.6},       -- Mint Green
    STRENGTH = {1.0, 0.2, 0.2},      -- Bright Red
    ATTACK_POWER = {1.0, 0.2, 0.2}, -- Red
    HIT = {0.2, 1.0, 0.2},           -- Green
    CRIT = {1.0, 0.2, 0.4},          -- Red/Pink
    HASTE = {1.0, 0.8, 0.0},         -- Gold
    DEFENSE = {0.2, 0.4, 0.8},       -- Tank Blue
    DODGE = {0.4, 0.4, 0.8},         -- Tank Blue
    PARRY = {0.4, 0.4, 0.8},         -- Tank Blue
    BLOCK = {0.5, 0.3, 0.1},         -- Shield Brown
    RESILIENCE = {0.5, 0.5, 0.5},    -- Grey
    ARMOR = {0.8, 0.6, 0.4},         -- Leather/Tan
}

-- [[ ROLE COLORS (NEON BRIGHT) ]]
MSC.RoleColors = {
    TANK   = {r=0.0, g=0.8, b=1.0}, -- Neon Blue
    HEALER = {r=0.0, g=1.0, b=0.4}, -- Neon Green
    CASTER = {r=0.8, g=0.4, b=1.0}, -- Neon Purple
    MELEE  = {r=1.0, g=0.3, b=0.1}, -- Neon Orange
    DEFAULT= {r=0.0, g=0.9, b=1.0}  -- Cyan
}

MSC.ReceiptSlots = {} 
MSC.BagCache = {}
MSC.BagCacheDirty = true
MSC.SummaryRows = {} 
MSC.LabBlocks = {} 
-- [[ FRAME POOL REGISTRY ]]
MSC.Pools = {
    Bars = {},
    Rings = {},
    Headers = {}
}

-- [[ NEW THROTTLE SYSTEM (C_Timer based) ]]
local updateTimer = nil
local function TriggerFullUpdate()
    if MSC.UpdateReceipt then MSC.UpdateReceipt() end
    if MSC.UpdateLogic then MSC.UpdateLogic() end
    updateTimer = nil
end

local function RequestUpdate()
    if not updateTimer then
        updateTimer = C_Timer.After(0.5, TriggerFullUpdate)
    end
end

function MSC.GetFromPool(poolType, parent, creatorFunc)
    if not MSC.Pools[poolType] then MSC.Pools[poolType] = {} end
    for _, frame in ipairs(MSC.Pools[poolType]) do
        if not frame:IsShown() then
            frame:SetParent(parent)
            frame:Show()
            return frame
        end
    end
    local newFrame = creatorFunc(parent)
    table_insert(MSC.Pools[poolType], newFrame)
    return newFrame
end

MSC.RegisteredTabs = {
    { id=1, icon="Interface\\Icons\\INV_Sword_04", name=MSC.L["Weapon Thunderdome"], funcName="InitLabView", view="ViewLab", update="UpdateLabCalc" },
    { id=2, icon="Interface\\Icons\\INV_Misc_Note_02", name=MSC.L["Receipt"], funcName="InitReceiptView", view="ViewReceipt", update="UpdateReceipt" },
    { id=3, icon="Interface\\Icons\\Spell_Holy_MindVision", name=MSC.L["Stat Logic"], funcName="InitLogicView", view="ViewLogic", update="UpdateLogic" },
    { id=4, icon="Interface\\Icons\\INV_Gizmo_02", name=MSC.L["Protocol"], funcName="InitSettingsView", view="ViewSettings" }
}

if not MSC.GetInspectSpec then function MSC.GetInspectSpec(unit) return "Default" end end

local function CopyTable(src)
    if not src then return {} end
    local dest = {}
    for k, v in pairs(src) do dest[k] = v end
    return dest
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("QUEST_COMPLETE")         -- Fires when the quest window opens
eventFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED") -- Fires when item data arrives

eventFrame:SetScript("OnEvent", function(self, event, arg1) 
    if event == "BAG_UPDATE" then 
        MSC.BagCacheDirty = true 
        RequestUpdate()
    elseif event == "QUEST_COMPLETE" or event == "GET_ITEM_INFO_RECEIVED" then
        if MSC.UpdateQuestOverlays then MSC.UpdateQuestOverlays() end
        
        if event == "GET_ITEM_INFO_RECEIVED" then
             RequestUpdate()
        end
    end
end)

function MSC.GetClassColor()
    local _, class = UnitClass("player")
    local c = (class and RAID_CLASS_COLORS[class]) or {r=1, g=0.82, b=0}
    return c.r, c.g, c.b, 1
end

function MSC.CreateModernBorder(f, thickness)
    if not f.border then
        f.border = CreateFrame("Frame", nil, f, "BackdropTemplate")
        f.border:SetPoint("TOPLEFT", -1, 1); f.border:SetPoint("BOTTOMRIGHT", 1, -1)
        f.border:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = thickness or 1, bgFile = "Interface\\Buttons\\WHITE8X8"})
        f.border:SetBackdropBorderColor(0,0,0,1); f.border:SetBackdropColor(0,0,0,0)
        f.border:SetFrameLevel(f:GetFrameLevel() + 10)
    end
end

-- =============================================================
-- 2. VIEW DEFINITIONS
-- =============================================================

function MSC.InitLabView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    local help = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); help:SetPoint("TOP", 0, -20); help:SetText(MSC.L["Drag (Shift/Ctrl+Click) items to compare. 6 Sets Enter, 1 Set Wins!"]); help:SetTextColor(0.6, 0.6, 0.6)

    MSC.LabBlocks = {}

    local function CreateBlock(id, title, numSlots, x, y)
        local frame = CreateFrame("Frame", nil, f, "BackdropTemplate")
        frame:SetSize(275, 90); frame:SetPoint("TOPLEFT", x, y)
        frame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
        frame:SetBackdropColor(0, 0, 0, 0.3); frame:SetBackdropBorderColor(0, 0, 0, 1)
        
        frame.Title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal"); frame.Title:SetPoint("TOPLEFT", 10, -5); frame.Title:SetText(title)
        frame.Score = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); frame.Score:SetPoint("TOPRIGHT", -10, -5); frame.Score:SetText("")
        
        frame.Slots = {}
        for i=1, numSlots do
            local btn = CreateFrame("Button", nil, frame, "ItemButtonTemplate")
            btn:SetSize(35, 35)
            local totalW = (numSlots * 40)
            local startX = (275 - totalW) / 2
            btn:SetPoint("LEFT", startX + ((i-1)*45), -10)
            
            btn:RegisterForClicks("AnyUp")
            btn:SetScript("OnClick", function(self)
                local type, _, link = GetCursorInfo()
                if type == "item" then 
                    self.link = link; SetItemButtonTexture(self, GetItemIcon(link)); ClearCursor()
                elseif IsShiftKeyDown() then 
                    self.link = nil; SetItemButtonTexture(self, nil)
                end
                MSC.UpdateLabCalc()
            end)
            btn:SetScript("OnEnter", function(self) 
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); 
                if self.link then GameTooltip:SetHyperlink(self.link) else GameTooltip:SetText("Empty Slot", 1,1,1) end 
                GameTooltip:Show() 
            end)
            btn:SetScript("OnLeave", GameTooltip_Hide)
            table_insert(frame.Slots, btn)
        end
        MSC.LabBlocks[id] = frame
    end

    CreateBlock(1, MSC.L["Option A1: Two-Hander"], 1, 10, -50)
    CreateBlock(2, MSC.L["Option B1: 1H + Shield/OH"], 2, 10, -150)
    CreateBlock(3, MSC.L["Option C1: Dual Wield"], 2, 10, -250)
    CreateBlock(4, MSC.L["Option A2: Two-Hander"], 1, 300, -50)
    CreateBlock(5, MSC.L["Option B2: 1H + Shield/OH"], 2, 300, -150)
    CreateBlock(6, MSC.L["Option C2: Dual Wield"], 2, 300, -250)

    f.ResultText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); f.ResultText:SetPoint("BOTTOM", 0, 60); f.ResultText:SetText(MSC.L["Waiting for Items..."])
    
    local bClear = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    bClear:SetSize(24, 24)
    bClear:SetPoint("TOPRIGHT", -5, -5)
    bClear:SetScript("OnClick", function()
        for _, block in pairs(MSC.LabBlocks) do
            for _, btn in ipairs(block.Slots) do
                btn.link = nil
                SetItemButtonTexture(btn, nil)
            end
        end
        MSC.UpdateLabCalc()
    end)
    bClear:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
    bClear:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Highlight")
    bClear:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Down")
    
    MSC.ViewLab = f
end

function MSC.UpdateLabCalc()
    if not MSC.ViewLab or not MSC.ViewLab:IsShown() then return end
    
    local weights, profileName = MSC.GetCurrentWeights()
    if not weights then return end 
    
    local bestScore = -1
    local winnerIndex = 0
    local hasItems = false

    local names = {
        MSC.L["Option A1 (2H)"], MSC.L["Option B1 (1H+OH)"], MSC.L["Option C1 (DW)"],
        MSC.L["Option A2 (2H)"], MSC.L["Option B2 (1H+OH)"], MSC.L["Option C2 (DW)"]
    }

    for id, block in pairs(MSC.LabBlocks) do
        local blockScore = 0
        local itemsFound = false
        
        for i, btn in ipairs(block.Slots) do
            if btn.link then
                itemsFound = true
                local slotID = (i == 1) and 16 or 17
                local stats = MSC.SafeGetItemStats(btn.link, slotID, weights, profileName)
                local score = MSC.GetItemScore(stats, weights, profileName, slotID)
                blockScore = blockScore + score
            end
        end
        
        if itemsFound then
            hasItems = true
            block.Score:SetText(string_format("%.1f", blockScore))
            block.finalScore = blockScore
            if blockScore > bestScore then
                bestScore = blockScore
                winnerIndex = id
            end
        else
            block.Score:SetText("")
            block.finalScore = -1
        end
    end
    
    for id, block in pairs(MSC.LabBlocks) do
        if not hasItems then
            block:SetBackdropBorderColor(0,0,0,1); block:SetAlpha(1)
            MSC.ViewLab.ResultText:SetText(MSC.L["Waiting for Items..."])
            MSC.ViewLab.ResultText:SetTextColor(1, 0.82, 0)
        elseif id == winnerIndex then
            block:SetBackdropBorderColor(0, 1, 0, 1); block:SetAlpha(1)
            block.Score:SetTextColor(0, 1, 0)
        else
            block:SetBackdropBorderColor(0,0,0,1); block:SetAlpha(0.4)
            block.Score:SetTextColor(0.5, 0.5, 0.5)
        end
    end
    
    if hasItems then
        local delta = bestScore
        local runnerUpScore = 0
        for id, block in pairs(MSC.LabBlocks) do
            if id ~= winnerIndex and block.finalScore > runnerUpScore then runnerUpScore = block.finalScore end
        end
        if runnerUpScore > 0 then delta = bestScore - runnerUpScore end
        
        MSC.ViewLab.ResultText:SetText(string_format(MSC.L["%s Wins! (+%s)"], names[winnerIndex], string_format("%.1f", delta)))
        MSC.ViewLab.ResultText:SetTextColor(0, 1, 0)
    end
end

function MSC.InitReceiptView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    f.Info = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"); f.Info:SetPoint("TOPLEFT", 40, -10)
    f.Score = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); f.Score:SetPoint("TOPRIGHT", -40, -10)
    local c = CreateFrame("Frame", nil, f); c:SetSize(400, 340); c:SetPoint("TOP", 0, -60)
    local function CreatePanel(name, w, h, point, relTo, relPoint, x, y)
        local p = CreateFrame("Frame", nil, c, "BackdropTemplate"); p:SetSize(w, h); p:SetPoint(point, relTo, relPoint, x, y)
        p:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1}); p:SetBackdropColor(unpack(MSC.Colors.BgPanel)); p:SetBackdropBorderColor(0,0,0,0.5)
        local lbl = p:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); lbl:SetPoint("BOTTOMLEFT", p, "TOPLEFT", 0, 4); lbl:SetText(name); lbl:SetTextColor(0.7, 0.7, 0.7); return p
    end
    local pArmor = CreatePanel(MSC.L["ARMOR"], 220, 240, "TOPLEFT", c, "TOPLEFT", 0, 0)
    local pJewel = CreatePanel(MSC.L["ACCESSORIES"], 130, 240, "TOPLEFT", pArmor, "TOPRIGHT", 20, 0)
    local pWeap  = CreatePanel(MSC.L["WEAPONS"], 465, 75, "TOP", c, "TOP", 0, -260)

    local function CreateSlot(id, parentPanel, x, y, label)
        local btn = CreateFrame("Button", nil, f, "ItemButtonTemplate"); btn:SetSize(30, 30); btn:SetPoint("TOPLEFT", parentPanel, "TOPLEFT", x, y)
        btn.ScoreFrame = CreateFrame("Frame", nil, btn, "BackdropTemplate"); btn.ScoreFrame:SetPoint("LEFT", btn, "RIGHT", 2, 0); btn.ScoreFrame:SetSize(40, 20)
        btn.ScoreFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8"}); btn.ScoreFrame:SetBackdropColor(0,0,0,0.5)
        btn.ScoreText = btn.ScoreFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); btn.ScoreText:SetPoint("CENTER"); btn.ScoreText:SetTextColor(1, 0.9, 0)
        btn.Alert = btn:CreateTexture(nil, "OVERLAY"); btn.Alert:SetSize(16, 16); btn.Alert:SetPoint("LEFT", btn.ScoreFrame, "RIGHT", 2, 0); btn.Alert:Hide()
        btn:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); if self.link then GameTooltip:SetHyperlink(self.link) else GameTooltip:SetText(label, 1, 1, 1) end if self.AlertMode then GameTooltip:AddLine(" "); GameTooltip:AddLine(self.AlertText or "Alert", 1, 0, 0) end GameTooltip:Show() end); btn:SetScript("OnLeave", GameTooltip_Hide)
        
        btn:RegisterForClicks("AnyUp")
        btn:SetScript("OnClick", function(self) if self.link then MSC:ShowScoreBreakdown(self.link, self.SlotID) end end)
        
        btn.SlotID = id; table_insert(MSC.ReceiptSlots, btn)
    end

    CreateSlot(1, pArmor, 10, -10, MSC.L["Head"]); CreateSlot(3, pArmor, 10, -55, MSC.L["Shoulder"]); CreateSlot(15, pArmor, 10, -100, MSC.L["Back"]); CreateSlot(5, pArmor, 10, -145, MSC.L["Chest"]); CreateSlot(9, pArmor, 10, -190, MSC.L["Wrist"])
    CreateSlot(10, pArmor, 115, -10, MSC.L["Hands"]); CreateSlot(6, pArmor, 115, -55, MSC.L["Waist"]); CreateSlot(7, pArmor, 115, -100, MSC.L["Legs"]); CreateSlot(8, pArmor, 115, -145, MSC.L["Feet"])
    CreateSlot(2, pJewel, 10, -10, MSC.L["Neck"]); CreateSlot(11, pJewel, 10, -55, MSC.L["Ring 1"]); CreateSlot(12, pJewel, 10, -100, MSC.L["Ring 2"]); CreateSlot(13, pJewel, 10, -145, MSC.L["Trinket 1"]); CreateSlot(14, pJewel, 10, -190, MSC.L["Trinket 2"])
    CreateSlot(16, pWeap, 30, -20, MSC.L["Main Hand"]); CreateSlot(17, pWeap, 160, -20, MSC.L["Off Hand"]); CreateSlot(18, pWeap, 290, -20, MSC.L["Ranged"])
    
    f.SummaryBox = CreateFrame("Frame", nil, f, "BackdropTemplate"); f.SummaryBox:SetPoint("TOP", pWeap, "BOTTOM", 0, -20); f.SummaryBox:SetSize(450, 100)
    f.SummaryBox.Title = f.SummaryBox:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.SummaryBox.Title:SetPoint("TOP", 0, 0); f.SummaryBox.Title:SetText(MSC.L["COMBINED GEAR STAT TOTALS"]); f.SummaryBox.Title:SetTextColor(1, 0.82, 0)
    MSC.SummaryRows = {}
    for i=1, 12 do
        local row = CreateFrame("Frame", nil, f.SummaryBox); row:SetSize(200, 16)
        row.Label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); row.Label:SetPoint("LEFT", 0, 0)
        row.Value = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row.Value:SetPoint("RIGHT", 0, 0)
        table_insert(MSC.SummaryRows, row)
    end
    
    f:SetScript("OnShow", function() MSC.UpdateReceipt() end)
    MSC.ViewReceipt = f
end

function MSC.UpdateReceipt()
    -- [[ LAZY LOADING OPTIMIZATION ]]
    if not MSC.ViewReceipt or not MSC.ViewReceipt:IsShown() then 
        MSC.BagCacheDirty = true 
        return 
    end

    local unit = "player"; local weights, specName = MSC.GetCurrentWeights()
    if not weights and MSC.CurrentClass and MSC.CurrentClass.Weights then specName, weights = next(MSC.CurrentClass.Weights) end
    if not weights then return end

    local displayName = (MSC.PrettyNames and MSC.PrettyNames[specName]) or specName
    MSC.ViewReceipt.Info:SetText(displayName)
    
    local gearTable = {}; local combinedStats = {}
    for i=1, 18 do 
        local link = GetInventoryItemLink(unit, i)
        if link then 
            gearTable[i] = link; local s = MSC.SafeGetItemStats(link, i, weights, specName)
            if s then for k, v in pairs(s) do if type(v)=="number" then combinedStats[k] = (combinedStats[k] or 0) + v end end end
        end
    end
    local totalScore = MSC:GetTotalCharacterScore(gearTable, weights, specName)
    MSC.ViewReceipt.Score:SetText(MSC.L["Score: "] .. string_format("|cff00ff00%.1f|r", totalScore))
    
    if MSC.BagCacheDirty then
        MSC.BagCache = {}
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local link = GetContainerItemLink(bag, slot)
                if link and MSC.IsItemUsable(link) then
                      local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                      local slotId = MSC.SlotMap and MSC.SlotMap[equipLoc]
                      if slotId then
                            local stats = MSC.SafeGetItemStats(link, slotId, weights, specName)
                            local score = MSC.GetItemScore(stats, weights, specName, slotId)
                            table_insert(MSC.BagCache, { link = link, slotId = slotId, score = score, equipLoc = equipLoc })
                      end
                end
            end
        end
        MSC.BagCacheDirty = false 
    end

    for _, btn in ipairs(MSC.ReceiptSlots) do
        local link = GetInventoryItemLink(unit, btn.SlotID)
        btn.link = link; btn.Alert:Hide(); btn.AlertMode = nil
        if link then
            SetItemButtonTexture(btn, GetInventoryItemTexture(unit, btn.SlotID))
            local stats = MSC.SafeGetItemStats(link, btn.SlotID, weights, specName)
            local score = MSC.GetItemScore(stats, weights, specName, btn.SlotID)
            if score > 0 then btn.ScoreText:SetText(math_floor(score)) else btn.ScoreText:SetText("") end
            
            local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
            if equipLoc ~= "INVTYPE_HOLDABLE" and equipLoc ~= "INVTYPE_TABARD" and equipLoc ~= "INVTYPE_BODY" then
                 local enchantID = link:match("item:%d+:(%d+)")
                 local validSlots = {[1]=true,[3]=true,[5]=true,[7]=true,[8]=true,[9]=true,[10]=true,[15]=true,[16]=true,[17]=true}
                 if validSlots[btn.SlotID] and (not enchantID or enchantID == "0") then 
                    btn.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertOther"); btn.Alert:Show()
                    btn.AlertMode = "Enchant"; btn.AlertText = MSC.L["Missing Enchant!"] 
                 end
            end
            local bestBagScore = score; local foundUpgrade = false
            for _, cachedItem in ipairs(MSC.BagCache) do
               local isMatch = (cachedItem.slotId == btn.SlotID)
               if btn.SlotID == 11 or btn.SlotID == 12 then if cachedItem.slotId == 11 then isMatch = true end end
               if btn.SlotID == 13 or btn.SlotID == 14 then if cachedItem.slotId == 13 then isMatch = true end end
               if isMatch and cachedItem.score > bestBagScore + 0.1 then foundUpgrade = true end
            end
            if foundUpgrade then 
                btn.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew"); btn.Alert:Show()
                btn.AlertMode = "Upgrade"; btn.AlertText = MSC.L["Better item in bags!"] 
            end
        else
            SetItemButtonTexture(btn, "Interface\\PaperDoll\\UI-Backpack-EmptySlot"); btn.ScoreText:SetText("")
        end
    end
    
    local sortedStats = {}
    for k, v in pairs(combinedStats) do
        if k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and v > 0 then
            local weight = weights[k] or 0; if weight > 0 then table_insert(sortedStats, { key=k, val=v, weight=weight }) end
        end
    end
    table_sort(sortedStats, function(a,b) return a.weight > b.weight end)
    for i, row in ipairs(MSC.SummaryRows) do
        if sortedStats[i] then
            row:Show(); local clean = MSC.GetCleanStatName(sortedStats[i].key)
            row.Label:SetText("|cff00ff00" .. clean .. ":|r"); row.Value:SetText(string_format("%.1f", sortedStats[i].val))
            local isLeft = (i % 2 ~= 0); local rIdx = math_ceil(i/2)
            if isLeft then row:SetPoint("TOPLEFT", MSC.ViewReceipt.SummaryBox, "TOPLEFT", 10, -20 - (rIdx*16))
            else row:SetPoint("TOPLEFT", MSC.ViewReceipt.SummaryBox, "TOPLEFT", 230, -20 - (rIdx*16)) end
        else row:Hide() end
    end
end

-- =============================================================
-- QUEST REWARD OVERLAYS
-- =============================================================
function MSC.UpdateQuestOverlays()
    -- Helper: Finds buttons in both Classic (Global) and Modern (Table) environments
    local function GetRewardButton(index)
        local btn = _G["QuestInfoItem"..index]
        if btn then return btn end

        if QuestInfoRewardsFrame and QuestInfoRewardsFrame.RewardButtons then
            return QuestInfoRewardsFrame.RewardButtons[index]
        end
        return nil
    end

    local numChoices = GetNumQuestChoices()
    if numChoices <= 0 then return end

    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return end

    for i = 1, numChoices do
        local btn = GetRewardButton(i)
        local link = GetQuestItemLink("choice", i)

        if btn and btn:IsVisible() then
            if not btn.SGJ_Overlay then
                -- Draw Layer: OVERLAY (SubLevel 7) to ensure visibility over UI skins (ElvUI, etc)
                btn.SGJ_Overlay = btn:CreateTexture(nil, "OVERLAY", nil, 7)
                btn.SGJ_Overlay:SetSize(26, 26)
                btn.SGJ_Overlay:SetPoint("TOPRIGHT", 0, 0)
                btn.SGJ_Overlay:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Upgrade.png")
                btn.SGJ_Overlay:Hide()
            end

            local showOverlay = false

            if link then
                local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                if equipLoc then
                    local slotID = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
                    if slotID then
                        local newScore, oldScore = MSC:EvaluateUpgrade(link, slotID, weights, specName)
                        if newScore and oldScore and (newScore > oldScore) then
                            showOverlay = true
                        end
                    end
                end
            end

            if showOverlay then 
                btn.SGJ_Overlay:Show() 
            else 
                btn.SGJ_Overlay:Hide() 
            end
        end
    end
end

local function GetStatReason(stat, class, profileName)
    if not profileName then profileName = "" end
    if string_find(stat, "STRENGTH") then return MSC.L["Increases Attack Power and Block Value"] end
    if string_find(stat, "AGILITY") then return MSC.L["Increases Crit Chance, Dodge, and Armor"] end
    if string_find(stat, "STAMINA") then return MSC.L["Increases total Health Pool"] end
    if string_find(stat, "INTELLECT") then return MSC.L["Increases Mana Pool and Spell Crit"] end
    if string_find(stat, "SPIRIT") then return MSC.L["Increases Out-of-Combat and Spell5 Regen"] end
    if string_find(stat, "ATTACK_POWER") then return MSC.L["Increases Raw Physical Damage Output"] end
    if string_find(stat, "EXPERTISE") then return MSC.L["Reduces chance Target Parries or Dodges"] end
    if string_find(stat, "ARMOR_PENETRATION") then return MSC.L["Ignores a portion of Target's Armor"] end
    if string_find(stat, "MELEE_HIT") or string_find(stat, "RANGED_HIT") or (string_find(stat, "HIT") and not string_find(stat, "SPELL")) then return MSC.L["Reduces chance to Miss Physical attacks"] end
    if string_find(stat, "SPELL_POWER") then return MSC.L["Increases Scaling Damage of Spells"] end
    if string_find(stat, "HEALING") then return MSC.L["Increases Potency of Healing spells"] end
    if string_find(stat, "SPELL_HIT") then return MSC.L["Reduces chance for Spells to Resist/Miss"] end
    if string_find(stat, "MANA_REG") or string_find(stat, "MP5") then return MSC.L["Constant Mana Sustain (Mp5)"] end
    if string_find(stat, "CRIT") and not string_find(stat, "FROM_STATS") then return MSC.L["Chance for Extra Critical Damage/Healing"] end
    if string_find(stat, "HASTE") then return MSC.L["Increases Attack/Casting Speed"] end
    if string_find(stat, "DEFENSE") then return MSC.L["Reduces chance to be Crit and Hit"] end
    if string_find(stat, "DODGE") then return MSC.L["Chance to completely Avoid Physical attacks"] end
    if string_find(stat, "PARRY") then return MSC.L["Chance to Deflect front-facing attacks"] end
    if string_find(stat, "BLOCK_VALUE") then return MSC.L["Increases Damage mitigated by Shield"] end
    if string_find(stat, "BLOCK_RATING") then return MSC.L["Chance to Mitigate damage with Shield"] end
    if string_find(stat, "RESILIENCE") then return MSC.L["Reduces Crit Damage and Chance (PvP)"] end
    if string_find(stat, "ARMOR") and not string_find(stat, "PENETRATION") then return MSC.L["Reduces Incoming Physical Damage"] end
    return nil
end

local function GetProgressColor(percent, roleColor)
    if percent >= 100 then return 0, 1, 1 
    else 
        if roleColor then return roleColor.r, roleColor.g, roleColor.b 
        else local p = percent / 100; return 1, p, 0 end
    end
end

local function CreateStatRing(parent, x, y, size, label)
    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(size, size); f:SetPoint("TOPLEFT", x, y)
    
    f.bg = f:CreateTexture(nil, "BACKGROUND", nil, -1)
    f.bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    f.bg:SetAllPoints(); f.bg:SetVertexColor(0.1, 0.1, 0.1, 0.6)

    f.SpinFrame = CreateFrame("Frame", nil, f)
    f.SpinFrame:SetAllPoints(f)
    
    f.Energy = f.SpinFrame:CreateTexture(nil, "ARTWORK")
    f.Energy:SetAllPoints()
    f.Energy:SetBlendMode("ADD")
    f.Energy:SetAlpha(1.0)
    
    f.Energy:SetTexCoord(0.1, 0.9, 0.1, 0.9) 

    local mask = f.SpinFrame:CreateMaskTexture()
    mask:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    mask:SetSize(size * 0.9, size * 0.9) 
    mask:SetPoint("CENTER")
    f.Energy:AddMaskTexture(mask)

    f.AnimGroup = f.SpinFrame:CreateAnimationGroup()
    f.AnimGroup:SetLooping("REPEAT")
    
    f.Spin = f.AnimGroup:CreateAnimation("Rotation")
    f.Spin:SetOrder(1)

    f.Pulse = f.AnimGroup:CreateAnimation("Scale")
    f.Pulse:SetOrder(1)
    
    f.TextFrame = CreateFrame("Frame", nil, f)
    f.TextFrame:SetAllPoints()
    f.TextFrame:SetFrameLevel(f.SpinFrame:GetFrameLevel() + 10) 

    f.val = f.TextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); f.val:SetPoint("CENTER", 0, 0); f.val:SetTextColor(1, 1, 1)
    f.lbl = f.TextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); f.lbl:SetPoint("TOP", f, "BOTTOM", 0, -5); f.lbl:SetText(label:upper()); f.lbl:SetTextColor(0.6, 0.6, 0.6)
    
    f.cooldown = CreateFrame("Cooldown", nil, f.TextFrame, "CooldownFrameTemplate")
    f.cooldown:SetAllPoints(f)
    f.cooldown:SetSwipeTexture("Interface\\Minimap\\UI-Minimap-Background")
    f.cooldown:SetHideCountdownNumbers(true); f.cooldown:SetDrawEdge(false); f.cooldown:SetReverse(true)
    f.cooldown:SetUseCircularEdge(true)
    f.cooldown:SetAlpha(0.2) 

    return f
end

function MSC.ApplyRingArt(f, statType)
    f.AnimGroup:Stop()
    f.Spin:SetDuration(0)
    f.Energy:SetRotation(0)
    
    f.Energy:SetVertexColor(0.8, 0.8, 0.8, 1) 

    if statType == "Def Cap" or statType == "Defense" then
         f.Energy:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Rune.tga") 
         f.Spin:SetDegrees(360); f.Spin:SetDuration(60); f.AnimGroup:Play()

    elseif string_find(statType, "Hit") or string_find(statType, "Haste") then
         f.Energy:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Swirl.tga")
         f.Spin:SetDegrees(-360); f.Spin:SetDuration(30); f.AnimGroup:Play()
         
         if string_find(statType, "Haste") then
            f.Energy:SetVertexColor(1.0, 0.8, 0.0, 1)
         elseif string_find(statType, "Spell") then 
            f.Energy:SetVertexColor(0.2, 1.0, 0.8, 1) 
         else
            f.Energy:SetVertexColor(0.2, 1.0, 0.2, 1)
         end

    elseif statType == "Expertise" then
         f.Energy:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Sun.tga")
         f.Energy:SetVertexColor(1.0, 0.5, 0.0, 1) 

    elseif string_find(statType, "Crit") then
         f.Energy:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Sun.tga")
         f.Pulse:SetScaleFrom(1, 1); f.Pulse:SetScaleTo(1.1, 1.1)
         f.Pulse:SetDuration(0.5); f.Pulse:SetSmoothing("IN_OUT")
         f.AnimGroup:Play()
         
         if string_find(statType, "Spell") then
             f.Energy:SetVertexColor(0.8, 0.2, 1.0, 1) 
         else
             f.Energy:SetVertexColor(1.0, 0.0, 0.0, 1) 
         end
    else
         f.Energy:SetTexture("Interface\\Common\\RingBorder")
    end
end

local function GetClassRings(class, stats, weights)
    local rings = {}
    local CAP_HIT_MELEE = 9
    local CAP_HIT_SPELL = 16
    local CAP_EXP = 26
    local CAP_DEF = 490
    
    local spellHitBonus = 0
    local meleeHitBonus = 0
    local expertBonus = 0
    local critBonus = 0
    
    local isTBC = (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC)
    local _, playerRace = UnitRace("player")

    local function GetTalentRank(tab, talentName)
        local numTalents = GetNumTalents(tab)
        for i=1, numTalents do
            local name, _, _, _, rank = GetTalentInfo(tab, i)
            if name == MSC.L[talentName] then return rank end
        end
        return 0
    end

    if class == "MAGE" then
        local arcane = GetTalentRank(1, "Arcane Focus") * 2
        local frost = GetTalentRank(3, "Elemental Precision") * (isTBC and 1 or 2)
        spellHitBonus = math_max(arcane, frost)
    elseif class == "WARLOCK" then
        spellHitBonus = GetTalentRank(1, "Suppression") * 2
    elseif class == "PRIEST" then
        spellHitBonus = GetTalentRank(3, "Shadow Focus") * 2
    elseif class == "SHAMAN" then
        local elePrec = GetTalentRank(1, "Elemental Precision") * 2
        local natGuid = GetTalentRank(3, "Nature's Guidance") * 1
        spellHitBonus = elePrec + natGuid
        meleeHitBonus = natGuid
    elseif class == "DRUID" then
        if isTBC then 
            spellHitBonus = GetTalentRank(1, "Balance of Power") * 2 
            local sotf = GetTalentRank(2, "Survival of the Fittest")
            if sotf == 3 then CAP_DEF = 415
            elseif sotf == 2 then CAP_DEF = 440
            elseif sotf == 1 then CAP_DEF = 465 
            end
        end
    elseif class == "ROGUE" then
        meleeHitBonus = GetTalentRank(2, "Precision") * 1
        local wepExp = GetTalentRank(2, "Weapon Expertise")
        expertBonus = expertBonus + (wepExp * 5)
    elseif class == "HUNTER" then
        meleeHitBonus = GetTalentRank(3, "Surefooted") * 1
    elseif class == "PALADIN" then
        local prec = GetTalentRank(2, "Precision") * 1
        meleeHitBonus = prec; spellHitBonus = prec
        local ant = GetTalentRank(2, "Anticipation") * 4
        CAP_DEF = math_max(350, CAP_DEF - ant)
    elseif class == "WARRIOR" then
        meleeHitBonus = GetTalentRank(2, "Precision") * 1
        local ant = GetTalentRank(3, "Anticipation") * 4
        CAP_DEF = math_max(350, CAP_DEF - ant)
        if isTBC then
            local def = GetTalentRank(3, "Defiance") 
            expertBonus = expertBonus + (def * 2) 
        end
    end

    local mhLink = GetInventoryItemLink("player", 16)
    if mhLink then
        local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(mhLink)
        if playerRace == "Human" then
            if subClassID == 7 or subClassID == 8 or subClassID == 4 or subClassID == 5 then
                expertBonus = expertBonus + 5
            end
        elseif playerRace == "Orc" then
            if subClassID == 0 or subClassID == 1 then
                expertBonus = expertBonus + 5
            end
        end
    end

    local rangedLink = GetInventoryItemLink("player", 18)
    if rangedLink then
        local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(rangedLink)
        if playerRace == "Dwarf" then
            if subClassID == 3 then critBonus = critBonus + 1 end 
        elseif playerRace == "Troll" then
            if subClassID == 2 then critBonus = critBonus + 1 end 
        end
    end

    if isTBC and playerRace == "Draenei" then
        spellHitBonus = spellHitBonus + 1
        meleeHitBonus = meleeHitBonus + 1
    end

    CAP_HIT_MELEE = math_max(0, CAP_HIT_MELEE - meleeHitBonus)
    CAP_HIT_SPELL = math_max(0, CAP_HIT_SPELL - spellHitBonus)
    CAP_EXP       = math_max(0, CAP_EXP - expertBonus)

    local function AddRing(label, statKey, capTarget, formatStr, isSkill)
        local val = stats[statKey] or 0
        local level = UnitLevel("player"); if level > 70 then level = 70 end
        local scalar = 0
        if label == "Expertise" then
            scalar = (MSC.CombatRatingScalars and MSC.CombatRatingScalars[level]) and MSC.CombatRatingScalars[level][1] or 3.94
        elseif label == "Def Cap" then
            scalar = (MSC.CombatRatingScalars and MSC.CombatRatingScalars[level]) and MSC.CombatRatingScalars[level][2] or 2.37
        else
            local idx = MSC.RatingIndexMap and MSC.RatingIndexMap[statKey]
            if idx and MSC.CombatRatingScalars and MSC.CombatRatingScalars[level] then scalar = MSC.CombatRatingScalars[level][idx] else scalar = 15.8 end
        end

        local currentDisplay = 0; local capRating = 0
        if isSkill then
            if label == "Def Cap" then
                local skillAdded = math_floor(val / scalar)
                currentDisplay = 350 + skillAdded
                capRating = (capTarget - 350) * scalar
            else
                currentDisplay = math_floor(val / scalar)
                capRating = capTarget * scalar
            end
        else
            currentDisplay = val / scalar; capRating = capTarget * scalar
        end
        
        if label == "Crit" or string_find(label, "Crit") then
            currentDisplay = currentDisplay + critBonus
        end

        table_insert(rings, { l=label, v=currentDisplay, m=capTarget, fmt=formatStr, rawVal = val, rawCap = capRating, scalar = scalar })
    end

    if class == "WARRIOR" or class == "ROGUE" or class == "HUNTER" then
        if class == "WARRIOR" and (weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0) > 0.5 then
            AddRing("Def Cap", "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", CAP_DEF, "%d", true)
            AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%")
            AddRing("Expertise", "ITEM_MOD_EXPERTISE_RATING_SHORT", CAP_EXP, "%d", true)
        else
            AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%")
            AddRing("Crit", "ITEM_MOD_CRIT_RATING_SHORT", 35, "%.1f%%") 
            local wantsExpertise = (weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] or 0) > 0
            if class ~= "HUNTER" or wantsExpertise then
                AddRing("Expertise", "ITEM_MOD_EXPERTISE_RATING_SHORT", CAP_EXP, "%d", true)
            end
        end
    elseif class == "MAGE" or class == "WARLOCK" or class == "PRIEST" then
        AddRing("Spell Hit", "ITEM_MOD_HIT_SPELL_RATING_SHORT", CAP_HIT_SPELL, "%.1f%%")
        AddRing("Spell Crit", "ITEM_MOD_SPELL_CRIT_RATING_SHORT", 30, "%.1f%%") 
        AddRing("Haste", "ITEM_MOD_SPELL_HASTE_RATING_SHORT", 20, "%.1f%%")      
    elseif class == "PALADIN" or class == "SHAMAN" or class == "DRUID" then
        local isTank = (weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0) > 0.5
        local isCaster = (weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0) > (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 0)
        
        if isTank then
            AddRing("Def Cap", "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", CAP_DEF, "%d", true)
            if isCaster and class == "PALADIN" then 
                AddRing("Spell Hit", "ITEM_MOD_HIT_SPELL_RATING_SHORT", CAP_HIT_SPELL, "%.1f%%") 
            else 
                AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%") 
            end
            AddRing("Expertise", "ITEM_MOD_EXPERTISE_RATING_SHORT", CAP_EXP, "%d", true)
        elseif isCaster then
            AddRing("Spell Hit", "ITEM_MOD_HIT_SPELL_RATING_SHORT", CAP_HIT_SPELL, "%.1f%%")
            AddRing("Spell Crit", "ITEM_MOD_SPELL_CRIT_RATING_SHORT", 30, "%.1f%%")
        else
            AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%")
            AddRing("Crit", "ITEM_MOD_CRIT_RATING_SHORT", 35, "%.1f%%")
            AddRing("Expertise", "ITEM_MOD_EXPERTISE_RATING_SHORT", CAP_EXP, "%d", true)
        end
    end
    return rings
end

function MSC.InitLogicView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 20, -20); scroll:SetPoint("BOTTOMRIGHT", -40, 20)
    local content = CreateFrame("Frame", nil, scroll); content:SetSize(400, 800); scroll:SetScrollChild(content)
    f.Content = content
    f:SetScript("OnShow", function() MSC.UpdateLogic() end)
    MSC.ViewLogic = f
end

function MSC.UpdateLogic()
    if not MSC.ViewLogic or not MSC.ViewLogic:IsShown() then return end
    local content = MSC.ViewLogic.Content
    
    if content.children then for _, c in ipairs(content.children) do c:Hide() end end
    content.children = {}

    local weights, detectedKey = MSC.GetCurrentWeights()
    if not weights and MSC.CurrentClass then detectedKey, weights = next(MSC.CurrentClass.Weights) end
    if not weights then return end
    
    local currentGear = {}
    for i=1, 18 do currentGear[i] = GetInventoryItemLink("player", i) end
    
    local _, stats = MSC:GetTotalCharacterScore(currentGear, weights, detectedKey)
    local rings = GetClassRings(select(2, UnitClass("player")), stats, weights)
    
    for i, ring in ipairs(rings) do
        if i <= 3 then
            local xPos = 60 + ((i-1) * 140)
            local f = MSC.GetFromPool("Rings", content, function(p) return CreateStatRing(p, 0, 0, 80, "TEMP") end)
            f:ClearAllPoints(); f:SetPoint("TOPLEFT", xPos, -20)
            f.lbl:SetText(ring.l:upper())
            f.val:SetText(string_format(ring.fmt, ring.v))
            MSC.ApplyRingArt(f, ring.l) 
            local fillPct = 0
            if ring.m > 0 then fillPct = math_min(100, (ring.v / ring.m) * 100) end
            local r,g,b = 0, 0, 0
            if string_find(ring.l, "Cap") or string_find(ring.l, "Hit") or string_find(ring.l, "Expertise") or string_find(ring.l, "Def") then
                if fillPct >= 100 then r,g,b = 0, 1, 0 end
            end
            f.cooldown:SetSwipeColor(r,g,b)
            local dur = 100000
            f.cooldown:SetCooldown(GetTime() - (dur * (fillPct/100)), dur)
            f.cooldown:Pause()
            f:EnableMouse(true)
            f:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(ring.l, 1, 1, 1)
                GameTooltip:AddLine(" ")
                if ring.rawVal and ring.rawCap and ring.rawCap > 0 then
                    GameTooltip:AddDoubleLine(MSC.L["Rating:"], string_format("%d / %d", ring.rawVal, ring.rawCap), 1, 0.82, 0, 1, 1, 1)
                    local diff = ring.rawCap - ring.rawVal
                    if diff > 0 then 
                        GameTooltip:AddLine(string_format(MSC.L["Need %d more rating to cap."], diff), 1, 0.5, 0.5) 
                    else 
                        GameTooltip:AddLine(MSC.L["Cap reached!"], 0, 1, 0) 
                    end
                else
                    GameTooltip:AddDoubleLine(MSC.L["Current Rating:"], string_format("%d", ring.rawVal), 1, 0.82, 0, 1, 1, 1)
                end
                if ring.scalar then 
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(string_format(MSC.L["1%% requires %.2f Rating"], ring.scalar), 0.6, 0.6, 0.6) 
                end
                GameTooltip:Show(); self:SetAlpha(1)
            end)
            f:SetScript("OnLeave", function(self) GameTooltip:Hide(); self:SetAlpha(1) end)
            table_insert(content.children, f)
        end
    end

    local yOff = -135
    local sorted = {}
    local maxW = 0
    for k, v in pairs(weights) do if v > 0 then table_insert(sorted, {k=k, v=v}); if v > maxW then maxW = v end end end
    table_sort(sorted, function(a,b) return a.v > b.v end)

    for _, s in ipairs(sorted) do
        local bar = MSC.GetFromPool("Bars", content, function(p)
             local b = CreateFrame("StatusBar", nil, p, "BackdropTemplate")
             b:SetSize(450, 32)
             b:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8"})
             b:SetBackdropColor(0, 0, 0, 0.5)
             b:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
             b:EnableMouse(true)
             b:SetScript("OnEnter", function(self)
                 GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                 GameTooltip:SetText(self.StatName, 1, 1, 1)
                 if self.CurrentVal and self.CurrentVal > 0 then
                     GameTooltip:AddLine(" ")
                     local scoreContrib = (self.Weight or 0) * self.CurrentVal
                     GameTooltip:AddDoubleLine(MSC.L["Gear Contribution:"], string_format("%.1f", self.CurrentVal), 1, 1, 1, 1, 1, 1)
                     if self.RealTotal and self.RealTotal > 0 then
                         if math_abs(self.RealTotal - self.CurrentVal) > 1 then
                             GameTooltip:AddDoubleLine(MSC.L["Character Sheet:"], string_format(MSC.L["%d (Includes Base/Enchants)"], self.RealTotal), 0.6, 0.6, 0.6, 0.6, 0.6, 0.6)
                         end
                     end
                     GameTooltip:AddLine(" ")
                     GameTooltip:AddDoubleLine(MSC.L["Score Calculation:"], " ", 1, 0.82, 0)
                     GameTooltip:AddLine(string_format(MSC.L["%.2f (Weight) x %.1f (Gear)"], self.Weight, self.CurrentVal), 1, 1, 1)
                     GameTooltip:AddDoubleLine(MSC.L["= Score:"], string_format("%.1f", scoreContrib), nil, nil, nil, 0, 1, 0)
                 else
                     GameTooltip:AddDoubleLine(MSC.L["Stat Weight:"], string_format("%.2f", self.Weight or 0), nil,nil,nil, 0, 1, 0)
                     GameTooltip:AddLine(MSC.L["You currently have 0 of this stat from gear."], 0.6, 0.6, 0.6)
                 end
                 if self.Reason then 
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(self.Reason, 0.6, 0.6, 0.6, true) 
                 end
                 GameTooltip:Show()
                 self:SetAlpha(1)
             end)
             b:SetScript("OnLeave", function(self) GameTooltip:Hide(); self:SetAlpha(0.8) end)
             b.leftT = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); b.leftT:SetPoint("TOPLEFT", 10, -8)
             b.rightT = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); b.rightT:SetPoint("TOPRIGHT", -10, -8)
             b.sub = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); b.sub:SetPoint("BOTTOMLEFT", 10, 5)
             return b
        end)
        
        local name = (MSC.GetCleanStatName and MSC.GetCleanStatName(s.k)) or s.k
        local reason = GetStatReason(tostring(s.k):upper(), class, detectedKey)
        local currentVal = stats[s.k] or 0
        local realTotal = 0 

        bar.StatName = name; bar.Weight = s.v; bar.Reason = reason; bar.CurrentVal = currentVal

        bar:ClearAllPoints(); bar:SetPoint("TOPLEFT", 15, yOff)
        bar:SetMinMaxValues(0, maxW); bar:SetValue(s.v); bar:SetAlpha(0.9)
        
        local statKey = s.k:upper()
        local r, g, b = 0.5, 0.5, 0.5 
        
        if string_find(statKey, "SPELL_HIT") then r,g,b = unpack(MSC.StatColors.SPELL_HIT)
        elseif string_find(statKey, "SPELL_CRIT") then r,g,b = unpack(MSC.StatColors.SPELL_CRIT)
        elseif string_find(statKey, "SPELL_POWER") then r,g,b = unpack(MSC.StatColors.SPELL_POWER)
        else
            for key, color in pairs(MSC.StatColors) do
                if string_find(statKey, key) and not string_find(key, "SPELL") then 
                    r,g,b = unpack(color); break 
                end
            end
        end
        bar:GetStatusBarTexture():SetGradient("HORIZONTAL", CreateColor(r*0.4, g*0.4, b*0.4, 1), CreateColor(r, g, b, 1))
        bar.leftT:SetText(name:gsub("Rating", "")); bar.rightT:SetText(string_format("%.2f", s.v))
        if reason then bar.sub:SetText(reason); bar.sub:SetTextColor(r+0.2, g+0.2, b+0.2, 0.8) else bar.sub:Hide() end
        yOff = yOff - 38
        table_insert(content.children, bar)
    end
    content:SetHeight(math_abs(yOff) + 50)
end

function MSC.InitSettingsView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    local function CreateHeader(text, relTo, yOff, xOverride, yOverride, tooltip)
        local h = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); h:SetText(text); h:SetTextColor(1, 0.82, 0)
        if xOverride then h:SetPoint("TOPLEFT", xOverride, yOverride) 
        elseif relTo then h:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", 0, yOff) 
        else h:SetPoint("TOPLEFT", 40, -30) end
        if tooltip then
            local hitRect = CreateFrame("Frame", nil, f)
            hitRect:SetPoint("TOPLEFT", h, "TOPLEFT", -10, 10)
            hitRect:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT", 50, -10)
            hitRect:EnableMouse(true)
            hitRect:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(text, 1, 1, 1)
                GameTooltip:AddLine(tooltip, nil, nil, nil, true)
                GameTooltip:Show()
            end)
            hitRect:SetScript("OnLeave", GameTooltip_Hide)
        end
        return h
    end

    local function CreateDropdown(label, key, options, relTo, yOff, tooltip)
        local frame = CreateFrame("Frame", nil, f); frame:SetSize(200, 50); frame:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", 0, yOff)
        frame:EnableMouse(true)
        if tooltip then
            frame:SetScript("OnEnter", function(self) 
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(label, 1, 1, 1)
                GameTooltip:AddLine(tooltip, nil, nil, nil, true); GameTooltip:Show() 
            end)
            frame:SetScript("OnLeave", GameTooltip_Hide)
        end
        local lbl = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); lbl:SetPoint("TOPLEFT", 0, 0); lbl:SetText(label); lbl:SetTextColor(0.6, 0.6, 0.6)
        local dd = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate"); dd:SetPoint("TOPLEFT", -15, -15); UIDropDownMenu_SetWidth(dd, 180)
        local function OnClick(self) 
            UIDropDownMenu_SetSelectedID(dd, self:GetID()); SGJ_Settings[key] = self.value
            if key == "Mode" then 
                MSC.ManualSpec = self.value; MSC.CachedWeights = nil
                RequestUpdate()
            end 
        end
        local function Init(self, level) 
            for _, opt in ipairs(options) do 
                local info = UIDropDownMenu_CreateInfo(); info.text = opt.text; info.value = opt.val; info.func = OnClick; info.checked = (SGJ_Settings[key] == opt.val); UIDropDownMenu_AddButton(info, level) 
            end 
        end
        UIDropDownMenu_Initialize(dd, Init)
        local currentText = MSC.L["Select..."]; for _, opt in ipairs(options) do if SGJ_Settings[key] == opt.val then currentText = opt.text end end
        UIDropDownMenu_SetText(dd, currentText); if key == "Mode" then f.ProfileDD = dd end
        return frame
    end

    local function CreateCheck(label, key, tooltip, relTo, xOff, yOff)
        local cb = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate"); cb:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", xOff, yOff); cb.Text:SetText(label); cb.Text:SetTextColor(0.9, 0.9, 0.9); cb:SetChecked(SGJ_Settings[key])
        cb:SetScript("OnClick", function(self) SGJ_Settings[key] = self:GetChecked(); if key == "HideMinimap" then MSC.UpdateMinimapPosition() end end)
        if tooltip then cb:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(tooltip, nil, nil, nil, nil, true); GameTooltip:Show() end); cb:SetScript("OnLeave", GameTooltip_Hide) end
        return cb
    end
    
    local h1 = CreateHeader(MSC.L["Comparison Logic"], nil, 0)
    local enchantTip = MSC.L["Controls how item enchantments affect the score.\n\n|cffffffffOff:|r Scores items based on base stats only.\n|cffffffffCurrent:|r Includes the value of the enchant currently on the item.\n|cffffffffProject:|r Simulates the best possible enchant for that item level."]
    local ddEnchant = CreateDropdown(MSC.L["Enchant Mode"], "EnchantMode", {{ text = MSC.L["Off (Raw Stats)"], val = 1 }, { text = MSC.L["Current Only"], val = 2 }, { text = MSC.L["Project Best"], val = 3 }}, h1, -10, enchantTip)
    local gemTip = MSC.L["Controls how empty sockets are scored.\n\n|cffffffffSkeptic:|r Empty sockets are worth 0. Socket bonuses are ignored unless fully met.\n|cffffffffCasual:|r Assumes empty sockets are filled with Rare (Blue) quality gems.\n|cffffffffPro:|r Assumes empty sockets are filled with Epic/Best-in-Slot gems."]
    local ddGem = CreateDropdown(MSC.L["Gemming Logic"], "GemMode", {{ text = MSC.L["The Skeptic"], val = 1 }, { text = MSC.L["The Casual"], val = 2 }, { text = MSC.L["The Pro"], val = 3 }}, ddEnchant, -5, gemTip)

    local h2 = CreateHeader(MSC.L["Character Profile"], ddGem, -20)
    local specOptions = { { text = MSC.L["Auto-Detect"], val = "AUTO" } }; local seen = { ["AUTO"] = true }
    
    local profileList = {}
    if MSC.CurrentClass then
        local function AddList(listSource)
            if not listSource then return end
            local sorted = {}; for k in pairs(listSource) do table_insert(sorted, k) end; table_sort(sorted)
            for _, k in ipairs(sorted) do 
                if not seen[k] then 
                    local name = (MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[k]) or k; 
                    table_insert(specOptions, { text = name, val = k })
                    table_insert(profileList, { text = name, val = k }) 
                    seen[k] = true 
                end 
            end
        end
        if SharpiesGearJudgeDB and SharpiesGearJudgeDB.customWeights then AddList(SharpiesGearJudgeDB.customWeights) end
        AddList(MSC.CurrentClass.Weights)
        AddList(MSC.CurrentClass.LevelingWeights)
        AddList(MSC.CurrentClass.Profiles)
    end 

    local profileTip = MSC.L["Manually override the scoring profile.\n\n|cffffffffAuto-Detect:|r Automatically selects a profile based on your talents and recent gameplay.\n\nSelecting a specific profile forces the addon to judge all gear for that spec, regardless of your current talents."]
    local ddProfile = CreateDropdown(MSC.L["Active Scoring Profile"], "Mode", specOptions, h2, -10, profileTip)
    local h3 = CreateHeader(MSC.L["Interface Options"], ddProfile, -20)    
    local cb1 = CreateCheck(MSC.L["Hide Minimap Button"], "HideMinimap", MSC.L["Hides the circular button on your minimap."], h3, 0, -10)  
    local cb2 = CreateCheck(MSC.L["Hide Tooltip Verdict"], "HideTooltips", MSC.L["Stops the addon from adding scores to item tooltips."], cb1, 0, -5)   
    local cbShift = CreateCheck(MSC.L["Show Only via Shift Key"], "ShiftOnlyTooltip", MSC.L["Only shows the Judge score in tooltips while holding the SHIFT key."], cb2, 20, -5)
    local cb3 = CreateCheck(MSC.L["Mute Error Sounds"], "MuteSounds", MSC.L["Stops the error sound when clicking invalid items."], cbShift, -20, -5)
    local cb4 = CreateCheck(MSC.L["Disable Conflict Check"], "DisableConflictCheck", MSC.L["Stops the chat warning about Pawn/Zygor."], cb3, 0, -5)
    cb2:HookScript("OnClick", function(self)
        if self:GetChecked() then cbShift:SetAlpha(0.5); cbShift:Disable() else cbShift:SetAlpha(1); cbShift:Enable() end
    end)

    local specTip = MSC.L["Select additional profiles to track in tooltips.\n\nIf an item is an upgrade for a checked profile, a small notification will appear at the bottom of the item tooltip."]
    local hSpec = CreateHeader(MSC.L["Secondary Spec Tracking"], nil, nil, 320, -30, specTip)
    
    local trackFrame = CreateFrame("Frame", nil, f, "BackdropTemplate")
    trackFrame:SetSize(230, 280)
    trackFrame:SetPoint("TOPLEFT", hSpec, "BOTTOMLEFT", 0, -10)
    trackFrame:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1})
    trackFrame:SetBackdropColor(0,0,0,0.3); trackFrame:SetBackdropBorderColor(0,0,0,0.5)
    
    local scroll = CreateFrame("ScrollFrame", nil, trackFrame, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 5, -5); scroll:SetPoint("BOTTOMRIGHT", -25, 5)
    local sChild = CreateFrame("Frame", nil, scroll); sChild:SetSize(200, 400); scroll:SetScrollChild(sChild)
    
    local ty = 0
    for _, p in ipairs(profileList) do
        local cb = CreateFrame("CheckButton", nil, sChild, "ChatConfigCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 5, ty)
        cb.Text:SetText(p.text); cb.Text:SetTextColor(0.8, 0.8, 0.8)
        cb:SetChecked(SGJ_Settings.TrackedSpecs and SGJ_Settings.TrackedSpecs[p.val])
        cb:SetScript("OnClick", function(self) 
            if not SGJ_Settings.TrackedSpecs then SGJ_Settings.TrackedSpecs = {} end
            SGJ_Settings.TrackedSpecs[p.val] = self:GetChecked()
        end)
        ty = ty - 20
    end
    sChild:SetHeight(math_abs(ty) + 20)

    local bImp = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); bImp:SetSize(140, 30); bImp:SetPoint("BOTTOMRIGHT", -40, 40); bImp:SetText(MSC.L["Import Pawn String"])
    bImp:SetScript("OnClick", function() MSC.ShowImportWindow() end)
    local bExport = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); bExport:SetSize(140, 30); bExport:SetPoint("BOTTOMRIGHT", -190, 40); bExport:SetText(MSC.L["Export Data"])
    bExport:SetScript("OnClick", function() MSC.ShowHistory() end)
    
    MSC.ViewSettings = f
end

function MSC.RegisterPluginTab(name, icon, initFunc, viewKey, updateFuncKey)
    local newID = #MSC.RegisteredTabs + 1
    table_insert(MSC.RegisteredTabs, {
        id = newID, name = name, icon = icon,
        directFunc = initFunc, view = viewKey, update = updateFuncKey
    })
    if MSC.MainFrame and MSC.MainFrame:IsShown() then MSC.RenderSidebarButtons() end
    return newID
end

function MSC.RenderSidebarButtons()
    if not MSC.MainFrame then return end
    if MSC.NavButtons then for _, btn in ipairs(MSC.NavButtons) do btn:Hide() end end
    MSC.NavButtons = {}

    for idx, tab in ipairs(MSC.RegisteredTabs) do
        local btn = CreateFrame("Button", nil, MSC.MainFrame.Sidebar)
        btn:SetSize(50, 50); btn:SetPoint("TOP", 0, -20 - ((idx-1)*65))
        btn.Bg = btn:CreateTexture(nil, "BACKGROUND"); btn.Bg:SetAllPoints(); btn.Bg:SetColorTexture(1, 1, 1, 0.05); btn.Bg:SetAlpha(0)
        btn.Icon = btn:CreateTexture(nil, "ARTWORK"); btn.Icon:SetSize(32, 32); btn.Icon:SetPoint("CENTER"); btn.Icon:SetTexture(tab.icon); btn.Icon:SetDesaturated(true); btn.Icon:SetVertexColor(0.6, 0.6, 0.6)
        btn.SelectBar = btn:CreateTexture(nil, "OVERLAY"); btn.SelectBar:SetColorTexture(0, 0.8, 1, 1); btn.SelectBar:SetSize(4, 50); btn.SelectBar:SetPoint("LEFT", 0, 0); btn.SelectBar:Hide()
        btn:SetScript("OnEnter", function(self) self.Icon:SetVertexColor(1,1,1); self.Bg:SetAlpha(0.1); GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(tab.name); GameTooltip:Show() end)
        btn:SetScript("OnLeave", function(self) self.Bg:SetAlpha(0); if self.ID ~= MSC.ActiveTab then self.Icon:SetVertexColor(0.6, 0.6, 0.6) end GameTooltip:Hide() end)
        btn:SetScript("OnClick", function(self) MSC.SwitchTab(self.ID) end)
        btn.ID = idx; table_insert(MSC.NavButtons, btn)
    end
    if MSC.ActiveTab then MSC.SwitchTab(MSC.ActiveTab) end
end

function MSC.ToggleMainMenu()
    if MSC.MainFrame then 
        if MSC.MainFrame:IsShown() then MSC.MainFrame:Hide() else MSC.MainFrame:Show() end 
        return 
    end

    local f = CreateFrame("Frame", "SGJ_MainFrame", UIParent, "BackdropTemplate")
    f:SetSize(650, 600); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    
    f:SetScript("OnHide", function() 
        if MSC.BreakdownFrame then MSC.BreakdownFrame:Hide() end 
    end)
    
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing); f:SetFrameStrata("HIGH")
    MSC.CreateModernBorder(f, 1)
    
    f.Header = CreateFrame("Frame", nil, f); f.Header:SetPoint("TOPLEFT", 70, 0); f.Header:SetPoint("TOPRIGHT", 0, 0); f.Header:SetHeight(60); f.Header:EnableMouse(true)
    f.Header:SetScript("OnMouseWheel", function(self, delta) 
        local cur = f:GetScale(); if delta > 0 then cur = cur + 0.05 else cur = cur - 0.05 end
        if cur < 0.6 then cur = 0.6 end; if cur > 1.4 then cur = 1.4 end; f:SetScale(cur) 
    end)

    f.Bg = f:CreateTexture(nil, "BACKGROUND", nil, -8)
    local _, class = UnitClass("player")
    local fixedClass = class:sub(1,1):upper() .. class:sub(2):lower()
    local texPath = "Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. fixedClass .. ".tga"
    f.Bg:SetTexture(texPath)
    f.Bg:SetPoint("CENTER", f, "CENTER", 0, 0)
    f.Bg:SetSize(512, 512)
    f.Bg:SetAlpha(0.7)
    f.Bg:SetTexCoord(0, 1, 0, 1) 
    
    f.Overlay = f:CreateTexture(nil, "BACKGROUND", nil, -7)
    f.Overlay:SetAllPoints()
    f.Overlay:SetColorTexture(0.05, 0.05, 0.07, 0.88)

    f.Header.Grad = f.Header:CreateTexture(nil, "BACKGROUND")
    f.Header.Grad:SetAllPoints()
    f.Header.Grad:SetColorTexture(0, 0, 0, 0.5)
    f.Header.Grad:SetGradient("VERTICAL", CreateColor(0,0,0,0), CreateColor(0,0,0,0.8))

    f.Title = f.Header:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); f.Title:SetPoint("LEFT", 20, -5); f.Title:SetText("Sharpie's Gear Judge"); f.Title:SetTextColor(1, 1, 1); f.Title:SetShadowOffset(1, -1)
    f.SubTitle = f.Header:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.SubTitle:SetPoint("BOTTOMLEFT", f.Title, "BOTTOMRIGHT", 10, 2); f.SubTitle:SetText(string.format("v%s %s", MSC.Version, MSC.L["Laboratory"])); f.SubTitle:SetTextColor(MSC.GetClassColor())
    f.Close = CreateFrame("Button", nil, f.Header, "UIPanelCloseButton"); f.Close:SetPoint("TOPRIGHT", -5, -5); f.Close:SetScript("OnClick", function() f:Hide() end)
    f.ScaleHint = f.Header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    f.ScaleHint:SetPoint("RIGHT", f.Close, "LEFT", -5, 0); f.ScaleHint:SetText(MSC.L["Scroll to Scale"]); f.ScaleHint:SetTextColor(0.5, 0.5, 0.5)

    f.Sidebar = CreateFrame("Frame", nil, f); f.Sidebar:SetPoint("TOPLEFT", 0, 0); f.Sidebar:SetPoint("BOTTOMLEFT", 0, 0); f.Sidebar:SetWidth(70)
    f.Sidebar.Bg = f.Sidebar:CreateTexture(nil, "BACKGROUND"); f.Sidebar.Bg:SetAllPoints(); f.Sidebar.Bg:SetColorTexture(unpack(MSC.Colors.BgSidebar))
    f.Sidebar.Line = f.Sidebar:CreateTexture(nil, "OVERLAY"); f.Sidebar.Line:SetColorTexture(0, 0, 0, 1); f.Sidebar.Line:SetWidth(1); f.Sidebar.Line:SetPoint("TOPRIGHT", 0, 0); f.Sidebar.Line:SetPoint("BOTTOMRIGHT", 0, 0)
    f.MoveHint = f.Sidebar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    f.MoveHint:SetPoint("BOTTOM", 0, 15); f.MoveHint:SetText(MSC.L["Hold\nto Move"]); f.MoveHint:SetTextColor(0.3, 0.3, 0.3)
    
    f.Content = CreateFrame("Frame", nil, f); f.Content:SetPoint("TOPLEFT", f.Sidebar, "TOPRIGHT", 0, -60); f.Content:SetPoint("BOTTOMRIGHT", 0, 0)
    MSC.MainFrame = f
    
    MSC.InitLabView(f.Content)
    MSC.InitReceiptView(f.Content)
    MSC.InitLogicView(f.Content)
    MSC.InitSettingsView(f.Content)
    MSC.RenderSidebarButtons()
    MSC.SwitchTab(1)
    f:Show()
end

function MSC.SwitchTab(id)
    MSC.ActiveTab = id
    if MSC.BreakdownFrame then MSC.BreakdownFrame:Hide() end
    if MSC.NavButtons then
        for i, btn in ipairs(MSC.NavButtons) do
            if i == id then btn.Icon:SetDesaturated(false); btn.Icon:SetVertexColor(1, 1, 1); btn.SelectBar:Show(); btn.Bg:SetAlpha(0.05)
            else btn.Icon:SetDesaturated(true); btn.Icon:SetVertexColor(0.6, 0.6, 0.6); btn.SelectBar:Hide(); btn.Bg:SetAlpha(0.05) end
        end
    end
    for _, tab in ipairs(MSC.RegisteredTabs) do if MSC[tab.view] then MSC[tab.view]:Hide() end end
    local tab = MSC.RegisteredTabs[id]
    if tab then
        local init = tab.directFunc or (tab.funcName and MSC[tab.funcName])
        if not MSC[tab.view] and init then init(MSC.MainFrame.Content) end
        if MSC[tab.view] then 
            MSC[tab.view]:Show()
            if tab.update and MSC[tab.update] then MSC[tab.update]() end
        end
    end
end

function MSC.UpdateMinimapPosition()
    if not MSC_Minimap then return end
    if SGJ_Settings and SGJ_Settings.HideMinimap then MSC_Minimap:Hide() else MSC_Minimap:Show() end
end

local mb = CreateFrame("Button", "MSC_Minimap", Minimap)
mb:SetSize(32,32)
mb:SetFrameLevel(Minimap:GetFrameLevel() + 10) 
mb:SetPoint("CENTER", -60, -60) 

mb.icon = mb:CreateTexture(nil,"BACKGROUND")
mb.icon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_02")
mb.icon:SetSize(20,20)
mb.icon:SetPoint("CENTER")

mb.border = mb:CreateTexture(nil,"OVERLAY")
mb.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
mb.border:SetSize(54,54)
mb.border:SetPoint("TOPLEFT")

mb:SetMovable(true)
mb:EnableMouse(true)
mb:RegisterForDrag("LeftButton")
mb:SetClampedToScreen(true) 

mb:SetScript("OnDragStart", function(self) self:StartMoving() end)
mb:SetScript("OnDragStop", function(self) 
    self:StopMovingOrSizing()
    if not SGJ_Settings then SGJ_Settings = {} end
    local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
    SGJ_Settings.MinimapPos = { point, relativePoint, xOfs, yOfs }
end)
mb:RegisterForClicks("AnyUp")
mb:SetScript("OnClick", function(self) MSC.ToggleMainMenu() end)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("PLAYER_TALENT_UPDATE")
f:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
f:RegisterEvent("GET_ITEM_INFO_RECEIVED")

f:SetScript("OnEvent", function(self, event, arg1) 
    if event == "PLAYER_LOGIN" then 
        SharpiesGearJudgeDB = SharpiesGearJudgeDB or { customWeights = {} }
        if SGJ_Settings and SGJ_Settings.MinimapPos then
            local p = SGJ_Settings.MinimapPos
            if type(p) == "table" then
                MSC_Minimap:ClearAllPoints()
                MSC_Minimap:SetPoint(p[1], Minimap, p[2], p[3], p[4])
            else
                SGJ_Settings.MinimapPos = nil
                MSC_Minimap:ClearAllPoints()
                MSC_Minimap:SetPoint("CENTER", Minimap, "CENTER", -60, -60)
            end
        end
        if MSC.WeightDB then
            for name, weights in pairs(SharpiesGearJudgeDB.customWeights) do
                MSC.WeightDB[name] = weights
            end
        end
        MSC.UpdateMinimapPosition() 
    elseif event == "PLAYER_ENTERING_WORLD" then
        RequestUpdate()
    elseif event == "GET_ITEM_INFO_RECEIVED" then
        if MSC.StatCache then wipe(MSC.StatCache) end
        MSC.BagCacheDirty = true
        RequestUpdate()      
    else
        RequestUpdate()
    end
end)

function MSC.OnItemLinkClick(link)
    if not MSC.ViewLab or not MSC.ViewLab:IsShown() then return end
    
    local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
    if equipLoc == "INVTYPE_2HWEAPON" or equipLoc == "INVTYPE_STAFF" or equipLoc == "INVTYPE_POLEARM" then
        local btn1 = MSC.LabBlocks[1].Slots[1]; local btn2 = MSC.LabBlocks[4].Slots[1]
        if not btn1.link then btn1.link = link; SetItemButtonTexture(btn1, GetItemIcon(link))
        else btn2.link = link; SetItemButtonTexture(btn2, GetItemIcon(link)) end
    elseif equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND" then
        local btn1 = MSC.LabBlocks[2].Slots[2]; local btn2 = MSC.LabBlocks[5].Slots[2]
        if not btn1.link then btn1.link = link; SetItemButtonTexture(btn1, GetItemIcon(link))
        else btn2.link = link; SetItemButtonTexture(btn2, GetItemIcon(link)) end
    elseif equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND" then
        local targets = { MSC.LabBlocks[2].Slots[1], MSC.LabBlocks[3].Slots[1], MSC.LabBlocks[3].Slots[2], MSC.LabBlocks[5].Slots[1], MSC.LabBlocks[6].Slots[1], MSC.LabBlocks[6].Slots[2] }
        for i, btn in ipairs(targets) do
            local isOHSlot = (i == 3 or i == 6); local canEquip = true
            if isOHSlot and equipLoc == "INVTYPE_WEAPONMAINHAND" then canEquip = false end
            if canEquip and not btn.link then btn.link = link; SetItemButtonTexture(btn, GetItemIcon(link)); break end
        end
    end
    MSC.UpdateLabCalc()
end

hooksecurefunc("HandleModifiedItemClick", function(link) if link and IsShiftKeyDown() and MSC.ViewLab and MSC.ViewLab:IsShown() then MSC.OnItemLinkClick(link) end end)
hooksecurefunc("ChatEdit_InsertLink", function(link) if link and MSC.ViewLab and MSC.ViewLab:IsShown() then MSC.OnItemLinkClick(link) end end)
hooksecurefunc("DressUpItemLink", function(link) if link and MSC.ViewLab and MSC.ViewLab:IsShown() then MSC.OnItemLinkClick(link) end end)

function MSC.CreatePopupFrame(title)
    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    f:SetSize(500, 400); f:SetPoint("CENTER"); f:SetFrameStrata("DIALOG")
    f:EnableMouse(true); f:SetMovable(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    
    f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.Title:SetPoint("TOP", 0, -15); f.Title:SetText(title)
    
    f.Close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    f.Close:SetPoint("TOPRIGHT", -5, -5)
    
    local sf = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT", 20, -40); sf:SetPoint("BOTTOMRIGHT", -40, 50)
    
    local eb = CreateFrame("EditBox", nil, sf)
    eb:SetMultiLine(true); eb:SetSize(440, 350); eb:SetFontObject("ChatFontNormal")
    eb:SetAutoFocus(false)
    sf:SetScrollChild(eb)
    
    f.EditBox = eb
    return f
end

function MSC.ShowImportWindow()
    if MSC.ImportFrame then MSC.ImportFrame:Show(); return end
    local f = MSC.CreatePopupFrame(MSC.L["Import Pawn String"])
    f.EditBox:SetText(MSC.L["Paste Pawn string here..."])
    f.EditBox:HighlightText()
    local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    b:SetSize(120, 25); b:SetPoint("BOTTOM", 0, 15); b:SetText(MSC.L["Import"])
    b:SetScript("OnClick", function()
        local text = f.EditBox:GetText()
        if MSC.ImportAndSavePawnString then
            local success, name = MSC:ImportAndSavePawnString(text)
            if success then print("|cff00ff00SGJ:|r Successfully imported " .. name) end
        else print("|cffff0000SGJ Error:|r ImportAndSavePawnString missing in helpers.lua") end
        f:Hide()
    end)
    MSC.ImportFrame = f
end

function MSC.ShowHistory()
    if MSC.ExportFrame then MSC.ExportFrame:Show(); MSC.ExportFrame.EditBox:HighlightText(); return end
    local f = MSC.CreatePopupFrame(MSC.L["Export Data (Discord Ready)"])
    local unit = "player"
    local name = UnitName(unit)
    local realm = GetRealmName()
    local lvl = UnitLevel(unit)
    local _, class = UnitClass(unit)
    
    local weights, specName = MSC.GetCurrentWeights()
    if not weights and MSC.CurrentClass and MSC.CurrentClass.Weights then 
        specName, weights = next(MSC.CurrentClass.Weights) 
    end
    local profileName = (MSC.PrettyNames and MSC.PrettyNames[specName]) or specName or MSC.L["Unknown"]

    local gearTable = {}
    for i=1, 18 do gearTable[i] = GetInventoryItemLink(unit, i) end
    local totalScore = MSC:GetTotalCharacterScore(gearTable, weights, specName)

    local exportStr = string_format("```ini\n[ %s - %s (Lvl %d %s) ]\n", name, realm, lvl, class)
    exportStr = exportStr .. string_format("Profile    = %s\n", profileName)
    exportStr = exportStr .. string_format("TotalScore = %.1f\n\n", totalScore)
    exportStr = exportStr .. "[ Equipment ]\n"

    local slots = {
        {1, "Head"}, {2, "Neck"}, {3, "Shoulder"}, {15, "Back"}, {5, "Chest"}, 
        {9, "Wrist"}, {10, "Hands"}, {6, "Waist"}, {7, "Legs"}, {8, "Feet"}, 
        {11, "Ring1"}, {12, "Ring2"}, {13, "Trinket1"}, {14, "Trinket2"}, 
        {16, "MainHand"}, {17, "OffHand"}, {18, "Ranged"}
    }
    
    for _, info in ipairs(slots) do
        local slotID, label = unpack(info)
        local link = gearTable[slotID]
        if link then
            local itemName = GetItemInfo(link) or MSC.L["Unknown Item"]
            local stats = MSC.SafeGetItemStats(link, slotID, weights, specName)
            local score = MSC.GetItemScore(stats, weights, specName, slotID)
            exportStr = exportStr .. string_format("%-10s = %s (%.1f)\n", label, itemName, score)
        else
            exportStr = exportStr .. string_format("%-10s = %s\n", label, MSC.L["(Empty)"])
        end
    end
    exportStr = exportStr .. "```"
    f.EditBox:SetText(exportStr)
    f.EditBox:HighlightText()
    f.EditBox:SetScript("OnEscapePressed", function() f:Hide() end)
    MSC.ExportFrame = f
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, event, name)
    if name == addonName then
        SharpiesGearJudgeDB = SharpiesGearJudgeDB or { customWeights = {} }
        if SharpiesGearJudgeDB.customWeights and MSC.CurrentClass then
            MSC.CurrentClass.Weights = MSC.CurrentClass.Weights or {}
            for profileName, weights in pairs(SharpiesGearJudgeDB.customWeights) do
                MSC.CurrentClass.Weights[profileName] = weights
            end
        end
        if MSC.MainFrame and MSC.MainFrame:IsShown() and MSC.InitSettingsView then
             MSC.InitSettingsView(MSC.MainFrame.Content)
        end
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

function MSC:ShowScoreBreakdown(itemLink, slotID)
    if not itemLink then return end
    if not MSC.BreakdownFrame then
        local f = CreateFrame("Frame", "SGJ_BreakdownFrame", UIParent, "BackdropTemplate")
        f:SetSize(300, 300)
        f:SetFrameStrata("DIALOG")
        f:EnableMouse(true)
        f:SetMovable(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left = 11, right = 12, top = 12, bottom = 11 }
        })
        f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        f.Title:SetPoint("TOP", 0, -15)
        f.Title:SetTextColor(1, 0.82, 0)
        f.Close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
        f.Close:SetPoint("TOPRIGHT", -5, -5)
        f.Content = CreateFrame("Frame", nil, f)
        f.Content:SetPoint("TOPLEFT", 25, -50)
        f.Content:SetPoint("BOTTOMRIGHT", -25, 25)
        MSC.BreakdownFrame = f
    end
    
    local f = MSC.BreakdownFrame
    f:Show()
    f:SetPoint("CENTER") 
    
    local weights, specName = MSC.GetCurrentWeights()
    if not weights and MSC.CurrentClass then 
        specName, weights = next(MSC.CurrentClass.Weights) 
    end
    if not weights then f.Title:SetText(MSC.L["No Weights Loaded"]) return end

    local stats = MSC.SafeGetItemStats(itemLink, slotID, weights, specName)
    local sorted = {}
    local totalScore = 0
    
    for k, v in pairs(stats) do
        if type(v) == "number" then
            local w = weights[k] or 0
            if w > 0 then
                local subScore = v * w
                totalScore = totalScore + subScore
                table_insert(sorted, { k=k, v=v, w=w, s=subScore })
            end
        end
    end
    if stats._AUTO_PROC then
        local p = stats._AUTO_PROC
        local w = weights[p.stat] or 0
        if w > 0 then
            local subScore = p.val * w
            totalScore = totalScore + subScore
            table_insert(sorted, { k=p.stat, v=p.val, w=w, s=subScore })
        end
    end

    table_sort(sorted, function(a,b) return a.s > b.s end)
    
    if f.lines then for _, l in ipairs(f.lines) do l:Hide() end end
    f.lines = f.lines or {}
    
    local itemName = GetItemInfo(itemLink) or MSC.L["Unknown Item"]
    f.Title:SetText(itemName)
    
    local yOff = 0
    for i, data in ipairs(sorted) do
        local line = f.lines[i]
        if not line then
            line = f.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            line:SetJustifyH("LEFT")
            f.lines[i] = line
        end
        line:ClearAllPoints()
        line:SetPoint("TOPLEFT", 0, yOff)
        local cleanName = MSC.GetCleanStatName(data.k)
        line:SetText(string_format("|cffffffff%.1f %s|r  x %.2f  =  |cff00ff00%.1f|r", data.v, cleanName, data.w, data.s))
        line:Show()
        yOff = yOff - 20
    end
    
    local totalIdx = #sorted + 1
    local totalLine = f.lines[totalIdx]
    if not totalLine then
        totalLine = f.Content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        totalLine:SetJustifyH("RIGHT")
        f.lines[totalIdx] = totalLine
    end
    totalLine:ClearAllPoints()
    totalLine:SetPoint("TOPRIGHT", 0, yOff - 10)
    totalLine:SetText(MSC.L["Total Score: "] .. string_format("|cff00ff00%.1f|r", totalScore))
    totalLine:Show()
    f:SetHeight(math_abs(yOff) + 100)
end