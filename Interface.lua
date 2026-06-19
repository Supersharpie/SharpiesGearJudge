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
eventFrame:RegisterEvent("QUEST_COMPLETE")         
eventFrame:RegisterEvent("QUEST_DETAIL")         
eventFrame:RegisterEvent("QUEST_PROGRESS")         
eventFrame:RegisterEvent("QUEST_ITEM_UPDATE")
eventFrame:RegisterEvent("START_LOOT_ROLL")         
eventFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
eventFrame:RegisterEvent("TRADE_SKILL_SHOW")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, arg1) 
    if event == "BAG_UPDATE" then 
        MSC.BagCache.Dirty = true
        if RequestUpdate then RequestUpdate() end

    elseif event == "QUEST_COMPLETE" or event == "QUEST_DETAIL" or event == "QUEST_PROGRESS" or event == "QUEST_ITEM_UPDATE" then
        -- We use a 0.15s delay to ensure the server has populated the item links to the UI
        C_Timer.After(0.15, function()
            if MSC.UpdateAllQuestOverlays then MSC.UpdateAllQuestOverlays() end
        end)
		
	elseif event == "START_LOOT_ROLL" then
        -- A tiny 0.1s delay ensures the Blizzard UI has finished creating the frame and assigning the rollID
        C_Timer.After(0.1, function()
            if MSC.UpdateLootRollOverlays then MSC.UpdateLootRollOverlays() end
        end)
        
    elseif event == "ADDON_LOADED" and arg1 == "Blizzard_TradeSkillUI" then
            if not MSC.TradeSkillHooked then
                hooksecurefunc("TradeSkillFrame_Update", function()
                    if MSC.UpdateTradeSkillOverlays then MSC.UpdateTradeSkillOverlays() end
                end)
                hooksecurefunc("TradeSkillFrame_SetSelection", function()
                    C_Timer.After(0.05, function()
                        if MSC.UpdateTradeSkillOverlays then MSC.UpdateTradeSkillOverlays() end
                    end)
                end)
                MSC.TradeSkillHooked = true
            end
            
		elseif event == "TRADE_SKILL_SHOW" then
            if MSC.UpdateTradeSkillOverlays then MSC.UpdateTradeSkillOverlays() end
            
            -- Fetch Cache
            local numRecipes = GetNumTradeSkills()
            if numRecipes and numRecipes > 0 then
                for i = 1, numRecipes do
                    local link = GetTradeSkillItemLink(i)
                    if link then GetItemInfo(link) end
                end
            end
        
		elseif event == "GET_ITEM_INFO_RECEIVED" then
        local itemID = arg1
        
        -- Wipe caches so the newly loaded item gets a fresh scan
        if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
        if MSC.StatCache then wipe(MSC.StatCache) end

        C_Timer.After(0.15, function()
            -- NPC Windows
            if QuestInfoFrame and QuestInfoFrame:IsVisible() then 
                if MSC.UpdateQuestOverlays then MSC.UpdateQuestOverlays() end 
                if MSC.UpdateQuestAcceptOverlays then MSC.UpdateQuestAcceptOverlays() end
            end
            
            -- Quest Log Window
            if QuestLogFrame and QuestLogFrame:IsVisible() then 
                if MSC.UpdateQuestLogOverlays then MSC.UpdateQuestLogOverlays() end 
            end
            
            -- Merchant Window
            if MerchantFrame and MerchantFrame:IsVisible() then 
                if MSC.UpdateMerchantOverlays then MSC.UpdateMerchantOverlays() end 
            end
        end)

        -- [[ CRAFTING/TRADE SKILL CHECK ]]
        if TradeSkillFrame and TradeSkillFrame:IsShown() then
            -- Small defer ensures the Blizzard UI is ready to provide the link
            C_Timer.After(0.1, function()
                if MSC.UpdateTradeSkillOverlays then MSC.UpdateTradeSkillOverlays() end
            end)
        end

        -- [[ TSM COMPATIBILITY ]]
        if TSM_API and TSM_API.IsWindowVisible and TSM_API.IsWindowVisible("CRAFTING") then
            if MSC.UpdateTSMOverlays then MSC.UpdateTSMOverlays() end
        end
        
        for i = 1, 13 do
            local container = _G["ContainerFrame"..i]
            if container and container:IsVisible() and MSC.UpdateBagOverlays then
                MSC.UpdateBagOverlays(container)
            end
        end
		
        if GameTooltip:IsVisible() then
            local _, link = GameTooltip:GetItem()
            if not link and MSC.HoveredQuestLink then link = MSC.HoveredQuestLink end
            
            if link and string.find(link, "item:" .. itemID) then
                 if RequestUpdate then RequestUpdate() end
                 if MSC.EvaluateAndDrawTooltip then 
                     MSC.EvaluateAndDrawTooltip(GameTooltip) 
                 end
            end
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
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                if self.link then 
                    GameTooltip:SetHyperlink(self.link) 
                else 
                    GameTooltip:SetText(title, 1, 1, 1) 
                end 
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
    
    local c = CreateFrame("Frame", nil, f); c:SetSize(400, 340); c:SetPoint("TOP", 0, -50) 
    
    local function CreatePanel(name, w, h, point, relTo, relPoint, x, y)
        local p = CreateFrame("Frame", nil, c, "BackdropTemplate"); p:SetSize(w, h); p:SetPoint(point, relTo, relPoint, x, y)
        p:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1}); p:SetBackdropColor(unpack(MSC.Colors.BgPanel)); p:SetBackdropBorderColor(0,0,0,0.5)
        local lbl = p:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); lbl:SetPoint("BOTTOMLEFT", p, "TOPLEFT", 0, 4); lbl:SetText(name); lbl:SetTextColor(0.7, 0.7, 0.7); return p
    end
    
    local pArmor = CreatePanel(MSC.L["ARMOR"], 220, 240, "TOPLEFT", c, "TOPLEFT", 0, 0)
    local pJewel = CreatePanel(MSC.L["ACCESSORIES"], 130, 240, "TOPLEFT", pArmor, "TOPRIGHT", 20, 0)
    
    local pWeap  = CreatePanel(MSC.L["WEAPONS"], 465, 75, "TOP", c, "TOP", 0, -250)

    local function CreateSlot(id, parentPanel, x, y, label)
        local btn = CreateFrame("Button", nil, f, "ItemButtonTemplate"); btn:SetSize(30, 30); btn:SetPoint("TOPLEFT", parentPanel, "TOPLEFT", x, y)
        btn.ScoreFrame = CreateFrame("Frame", nil, btn, "BackdropTemplate"); btn.ScoreFrame:SetPoint("LEFT", btn, "RIGHT", 2, 0); btn.ScoreFrame:SetSize(40, 20)
        btn.ScoreFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8"}); btn.ScoreFrame:SetBackdropColor(0,0,0,0.5)
        btn.ScoreText = btn.ScoreFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); btn.ScoreText:SetPoint("CENTER"); btn.ScoreText:SetTextColor(1, 0.9, 0)
        btn.Alert = btn:CreateTexture(nil, "OVERLAY"); btn.Alert:SetSize(16, 16); btn.Alert:SetPoint("LEFT", btn.ScoreFrame, "RIGHT", 2, 0); btn.Alert:Hide()
		btn:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); if self.link then GameTooltip:SetHyperlink(self.link) else GameTooltip:SetText(label, 1, 1, 1) end if self.AlertMode then GameTooltip:AddLine(" "); GameTooltip:AddLine(self.AlertText or MSC.L["Alert"], 1, 0, 0) end GameTooltip:Show() end); btn:SetScript("OnLeave", GameTooltip_Hide)
        
        btn:RegisterForClicks("AnyUp")
        btn:SetScript("OnClick", function(self) if self.link then MSC:ShowScoreBreakdown(self.link, self.SlotID) end end)
        
        btn.SlotID = id; table_insert(MSC.ReceiptSlots, btn)
    end

    CreateSlot(1, pArmor, 10, -10, MSC.L["Head"]); CreateSlot(3, pArmor, 10, -55, MSC.L["Shoulder"]); CreateSlot(15, pArmor, 10, -100, MSC.L["Back"]); CreateSlot(5, pArmor, 10, -145, MSC.L["Chest"]); CreateSlot(9, pArmor, 10, -190, MSC.L["Wrist"])
    CreateSlot(10, pArmor, 115, -10, MSC.L["Hands"]); CreateSlot(6, pArmor, 115, -55, MSC.L["Waist"]); CreateSlot(7, pArmor, 115, -100, MSC.L["Legs"]); CreateSlot(8, pArmor, 115, -145, MSC.L["Feet"])
    CreateSlot(2, pJewel, 10, -10, MSC.L["Neck"]); CreateSlot(11, pJewel, 10, -55, MSC.L["Ring 1"]); CreateSlot(12, pJewel, 10, -100, MSC.L["Ring 2"]); CreateSlot(13, pJewel, 10, -145, MSC.L["Trinket 1"]); CreateSlot(14, pJewel, 10, -190, MSC.L["Trinket 2"])
    CreateSlot(16, pWeap, 30, -20, MSC.L["Main Hand"]); CreateSlot(17, pWeap, 160, -20, MSC.L["Off Hand"]); CreateSlot(18, pWeap, 290, -20, MSC.L["Ranged"])
    
    f.SummaryBox = CreateFrame("Frame", nil, f, "BackdropTemplate")
    f.SummaryBox:SetPoint("TOP", pWeap, "BOTTOM", 0, -15) 
    f.SummaryBox:SetSize(450, 120)
    
    f.SummaryBox.Title = f.SummaryBox:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.SummaryBox.Title:SetPoint("TOP", 0, 0); f.SummaryBox.Title:SetText(MSC.L["COMBINED GEAR STAT TOTALS"]); f.SummaryBox.Title:SetTextColor(1, 0.82, 0)
    MSC.SummaryRows = {}
    
    for i=1, 14 do
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
-- UNIFIED QUEST OVERLAYS (Log, Accept, and Turn-In)
-- =============================================================
function MSC.UpdateAllQuestOverlays()
    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return end

    local buttonsToScan = {}
    local seenButtons = {} -- FIX 1: Local tracking prevents permanent button lockouts

    -- Aggressive grab function that checks every possible WoW link type
    local function AddButton(btn)
        if not btn or not btn:IsVisible() then return end
        if seenButtons[btn] then return end 
        seenButtons[btn] = true

        -- SILENCE ELVUI & BLIZZARD NATIVE ARROWS
        if btn.UpgradeIcon then btn.UpgradeIcon:SetAlpha(0); btn.UpgradeIcon:Hide() end
        if btn.IconOverlay then btn.IconOverlay:SetAlpha(0); btn.IconOverlay:Hide() end

        local id = btn:GetID()
        local name = btn:GetName()
        if not id or id == 0 then
            if name then id = tonumber(name:match("%d+")) end
        end
        if not id then return end

        local bType = btn.type
        if not bType and name then
            if name:find("Choice") then bType = "choice"
            else bType = "reward" end
        end

        local link = nil
        
        -- The foolproof way to know if the UI is looking at the Log or an NPC
        if QuestInfoFrame and QuestInfoFrame.questLog then
            link = GetQuestLogItemLink(bType, id)
        else
            link = GetQuestItemLink(bType, id)
        end
        
        -- Fallback safety net
        if not link then
            link = GetQuestItemLink(bType, id) or GetQuestLogItemLink(bType, id)
        end
        
        if link then table_insert(buttonsToScan, {btn = btn, link = link}) end
    end

    -- 1. Scan global named buttons
    for i = 1, 15 do
        AddButton(_G["QuestLogItem"..i])
        AddButton(_G["QuestRewardItem"..i])
        AddButton(_G["QuestChoiceItem"..i])
        AddButton(_G["QuestDetailItem"..i])
        AddButton(_G["QuestProgressItem"..i])
        AddButton(_G["QuestInfoItem"..i])
    end

    -- 2. Scan dynamically pooled buttons safely WITHOUT triggering Blizzard's frame creation
    if QuestInfoRewardsFrame and QuestInfoRewardsFrame.RewardButtons then
        for i = 1, #QuestInfoRewardsFrame.RewardButtons do
            -- rawget prevents the UI from accidentally generating missing buttons
            local rewardBtn = rawget(QuestInfoRewardsFrame.RewardButtons, i)
            
            -- STRICT CHECK: Ensure the button exists, is shown, AND has its Blizzard item link populated
            if rewardBtn and rewardBtn:IsVisible() and rewardBtn.type then
                AddButton(rewardBtn)
            end
        end
    end

    -- 3. Evaluate and Draw
    for _, data in ipairs(buttonsToScan) do
        local btn = data.btn
        local link = data.link
        
        if btn.SGJ_OverlayFrame then btn.SGJ_OverlayFrame:Hide() end
        
        local overlayType = nil
        local itemName, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
        
        if itemName and equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP" then
            if MSC.IsItemUsable(link) then
                local slotID = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
                if slotID then
                    local newScore, oldScore = MSC:EvaluateUpgrade(link, slotID, weights, specName)
                    if newScore and oldScore then
                        if (newScore > (oldScore + 0.1)) then overlayType = "UP"
                        elseif (oldScore > (newScore + 0.1)) then overlayType = "DOWN" end
                    end
                end
            end
        end

        if overlayType then
            if not btn.SGJ_OverlayFrame then
                btn.SGJ_OverlayFrame = CreateFrame("Frame", nil, btn)
                
                -- Anchor safely to the Icon bounds to prevent ElvUI clipping later
                local icon = (btn.GetName and btn:GetName() and _G[btn:GetName() .. "IconTexture"]) or btn.Icon or btn.icon
                if icon then
                    btn.SGJ_OverlayFrame:SetAllPoints(icon)
                else
                    btn.SGJ_OverlayFrame:SetAllPoints(btn)
                end
                
                btn.SGJ_Overlay = btn.SGJ_OverlayFrame:CreateTexture(nil, "OVERLAY")
                btn.SGJ_Overlay:SetSize(22, 22)
                btn.SGJ_Overlay:SetPoint("TOPRIGHT", btn.SGJ_OverlayFrame, "TOPRIGHT", 2, 2)
            end
            
            -- Set Z-Index high enough to sit safely above backgrounds
            btn.SGJ_OverlayFrame:SetFrameLevel(btn:GetFrameLevel() + 10)
            btn.SGJ_Overlay:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. (overlayType == "UP" and "Upgrade.png" or "Downgrade.png"))
            btn.SGJ_OverlayFrame:Show()
        end
    end
end

MSC.UpdateQuestAcceptOverlays = MSC.UpdateAllQuestOverlays
MSC.UpdateQuestOverlays       = MSC.UpdateAllQuestOverlays
MSC.UpdateQuestLogOverlays    = MSC.UpdateAllQuestOverlays
-- =============================================================
-- MERCHANT REWARD OVERLAYS
-- =============================================================
function MSC.UpdateMerchantOverlays()
    if not MerchantFrame or not MerchantFrame:IsShown() then return end

    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return end

    for i = 1, MERCHANT_ITEMS_PER_PAGE do
        local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
        local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
        
        if itemButton then
            if itemButton.SGJ_Overlay then itemButton.SGJ_Overlay:Hide() end
            
            if itemButton:IsShown() and index <= GetMerchantNumItems() then
                local link = GetMerchantItemLink(index)
                local overlayType = nil

                if link then
                    -- GATEKEEPER: Ensure item is fully cached
                    local itemName, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                    
                    if not itemName then
                        -- Await GET_ITEM_INFO_RECEIVED
                    elseif equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP" then
                        if MSC.IsItemUsable(link) then 
                            local slotID = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
                            if slotID then
                                 local newScore, oldScore = MSC:EvaluateUpgrade(link, slotID, weights, specName)
                                 if newScore and oldScore then
                                     if (newScore > (oldScore + 0.1)) then
                                         overlayType = "UP"
                                     elseif (oldScore > (newScore + 0.1)) then
                                         overlayType = "DOWN"
                                     end
                                 end
                            end
                        end
                    end
                end

                if overlayType then
                    if not itemButton.SGJ_Overlay then
                        itemButton.SGJ_Overlay = itemButton:CreateTexture(nil, "OVERLAY", nil, 7)
                        itemButton.SGJ_Overlay:SetSize(22, 22) 
                        itemButton.SGJ_Overlay:SetPoint("TOPRIGHT", 2, 2)
                    end
                    itemButton.SGJ_Overlay:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. (overlayType == "UP" and "Upgrade.png" or "Downgrade.png"))
                    itemButton.SGJ_Overlay:Show()
                end
            end
        end
    end
end

-- =============================================================
-- GROUP LOOT / ROLL OVERLAYS
-- =============================================================
function MSC.UpdateLootRollOverlays()
    if SGJ_Settings and SGJ_Settings.ShowLootArrows == false then 
        for i = 1, NUM_GROUP_LOOT_FRAMES or 4 do
            local iconFrame = _G["GroupLootFrame" .. i .. "IconFrame"]
            if iconFrame and iconFrame.SGJ_OverlayFrame then iconFrame.SGJ_OverlayFrame:Hide() end
        end
        return 
    end

    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return end

    -- WoW Classic defaults to a maximum of 4 concurrent loot roll frames
    for i = 1, NUM_GROUP_LOOT_FRAMES or 4 do
        local frame = _G["GroupLootFrame" .. i]
        
        if frame and frame:IsShown() then
            local rollID = frame.rollID
            local iconFrame = _G["GroupLootFrame" .. i .. "IconFrame"]

            if rollID and iconFrame then
                if iconFrame.SGJ_OverlayFrame then iconFrame.SGJ_OverlayFrame:Hide() end

                local link = GetLootRollItemLink(rollID)
                if link then
                    local overlayType = nil
                    local itemName, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                    
                    if itemName and equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP" then
                        if MSC.IsItemUsable(link) then
                            local slotID = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
                            if slotID then
                                local newScore, oldScore = MSC:EvaluateUpgrade(link, slotID, weights, specName)
                                if newScore and oldScore then
                                    if (newScore > (oldScore + 0.1)) then
                                        overlayType = "UP"
                                    elseif (oldScore > (newScore + 0.1)) then
                                        overlayType = "DOWN"
                                    end
                                end
                            end
                        end
                    end

                    if overlayType then
                        if not iconFrame.SGJ_OverlayFrame then
                            iconFrame.SGJ_OverlayFrame = CreateFrame("Frame", nil, iconFrame)
                            iconFrame.SGJ_OverlayFrame:SetAllPoints(iconFrame)
                            iconFrame.SGJ_OverlayFrame:SetFrameLevel(iconFrame:GetFrameLevel() + 5)
                            
                            iconFrame.SGJ_Overlay = iconFrame.SGJ_OverlayFrame:CreateTexture(nil, "OVERLAY")
                            iconFrame.SGJ_Overlay:SetSize(20, 20)
                            iconFrame.SGJ_Overlay:SetPoint("TOPRIGHT", iconFrame.SGJ_OverlayFrame, "TOPRIGHT", 4, 4)
                        end
                        
                        iconFrame.SGJ_Overlay:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. (overlayType == "UP" and "Upgrade.png" or "Downgrade.png"))
                        iconFrame.SGJ_OverlayFrame:Show()
                    end
                end
            end
        end
    end
end

-- =============================================================
-- TRADE SKILL / CRAFTING OVERLAYS
-- =============================================================
function MSC.UpdateTradeSkillOverlays()
    if not TradeSkillFrame or not TradeSkillFrame:IsShown() then return end

    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return end

    local numTradeSkills = GetNumTradeSkills()
    local skillOffset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame)
    
    -- 1. List Buttons
    for i = 1, TRADE_SKILLS_DISPLAYED or 8 do
        local skillIndex = i + skillOffset
        local skillButton = _G["TradeSkillSkill" .. i]
        
        if skillButton then
            if skillButton.SGJ_Overlay then skillButton.SGJ_Overlay:Hide() end
            
            if skillIndex <= numTradeSkills and skillButton:IsShown() then
                local skillName, skillType = GetTradeSkillInfo(skillIndex)
                if skillType ~= "header" then 
                    local link = GetTradeSkillItemLink(skillIndex)
                    if link then
                        local itemName = GetItemInfo(link)
                        if not itemName then
                            MSC_ScannerTooltip:SetHyperlink(link) 
                        else
                            -- GATEKEEPER
                            local itemName, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                            if itemName and equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP" then
                                if MSC.IsItemUsable(link) then
                                    local compSlot = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
                                    if compSlot then
                                        local newScore, oldScore = MSC:EvaluateUpgrade(link, compSlot, weights, specName)
                                        if newScore and oldScore and (newScore > (oldScore + 0.1)) then
                                            if not skillButton.SGJ_Overlay then
                                                skillButton.SGJ_Overlay = skillButton:CreateTexture(nil, "OVERLAY", nil, 7)
                                                skillButton.SGJ_Overlay:SetSize(16, 16)
                                                skillButton.SGJ_Overlay:SetPoint("RIGHT", skillButton, "RIGHT", -2, 0)
                                                skillButton.SGJ_Overlay:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Upgrade.png")
                                            end
                                            skillButton.SGJ_Overlay:Show()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- 2. Selected Icon at Top
    local selectedIcon = _G["TradeSkillSkillIcon"]
    if selectedIcon and selectedIcon:IsShown() then
        if selectedIcon.SGJ_Overlay then selectedIcon.SGJ_Overlay:Hide() end
        
        local currentIndex = GetTradeSkillSelectionIndex()
        if currentIndex and currentIndex > 0 then
            local link = GetTradeSkillItemLink(currentIndex)
            if link then
                -- GATEKEEPER
                local itemName, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                if itemName and equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP" then
                    if MSC.IsItemUsable(link) then
                        local compSlot = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
                        if compSlot then
                            local newScore, oldScore = MSC:EvaluateUpgrade(link, compSlot, weights, specName)
                            if newScore and oldScore and (newScore > (oldScore + 0.1)) then
                                if not selectedIcon.SGJ_Overlay then
                                    selectedIcon.SGJ_Overlay = selectedIcon:CreateTexture(nil, "OVERLAY", nil, 7)
                                    selectedIcon.SGJ_Overlay:SetSize(22, 22)
                                    selectedIcon.SGJ_Overlay:SetPoint("TOPRIGHT", selectedIcon, "TOPRIGHT", 4, 4)
                                    selectedIcon.SGJ_Overlay:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Upgrade.png")
                                end
                                selectedIcon.SGJ_Overlay:Show()
                            end
                        end
                    end
                end
            end
        end
    end
end

-- =============================================================
-- BAG / INVENTORY UPGRADE OVERLAYS
-- =============================================================
function MSC.UpdateBagOverlays(frame)
    if not frame or not frame:IsShown() then return end
    
    local name = frame:GetName()
    if not name or not string.find(name, "ContainerFrame") then return end

    if SGJ_Settings and SGJ_Settings.ShowBagArrows == false then
        for i = 1, 36 do
            local btn = _G[name .. "Item" .. i]
            if btn and btn.SGJ_Overlay then btn.SGJ_Overlay:Hide() end
        end
        return 
    end

    local bagID = frame:GetID()
    local numSlots = GetContainerNumSlots(bagID)
    
    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return end

    for i = 1, 36 do
        local button = _G[name .. "Item" .. i]
        
        if button and button:IsShown() then
            if button.SGJ_Overlay then button.SGJ_Overlay:Hide() end

            local slotID = button:GetID()
            if slotID and slotID > 0 and slotID <= numSlots then
                local link = GetContainerItemLink(bagID, slotID)
                
                if link then
                    -- GATEKEEPER
                    local itemName, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                    
                    if itemName and equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP" then
                        if MSC.IsItemUsable(link) then
                            local compSlot = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
                            if compSlot then
                                local newScore, oldScore = MSC:EvaluateUpgrade(link, compSlot, weights, specName)
                                
                                if newScore and oldScore then
                                    local overlayType = nil
                                    if (newScore > (oldScore + 0.1)) then overlayType = "UP"
                                    elseif (oldScore > (newScore + 0.1)) then overlayType = "DOWN" end
                                    
                                    if overlayType then
                                        if not button.SGJ_Overlay then
                                            button.SGJ_Overlay = button:CreateTexture(nil, "OVERLAY", nil, 7)
                                            button.SGJ_Overlay:SetSize(18, 18)
                                            button.SGJ_Overlay:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -2) 
                                        end
                                        button.SGJ_Overlay:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. (overlayType == "UP" and "Upgrade.png" or "Downgrade.png"))
                                        button.SGJ_Overlay:Show()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- =============================================================
-- THIRD-PARTY BAG INTEGRATION (ElvUI, Bagnon, Baganator)
-- =============================================================
local BagHookFrame = CreateFrame("Frame")
BagHookFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
BagHookFrame:SetScript("OnEvent", function(self, event)
    if self.Loaded then return end
    self.Loaded = true
    
    local CheckAddOnLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded

-- [[ HELPER: THE DRAWING ENGINE ]]
    local function EvaluateAndDraw(button, link)
        -- We wait 0.05 seconds so ElvUI finishes drawing its custom rarity borders first
        C_Timer.After(0.05, function()
            if button.SGJ_OverlayFrame then button.SGJ_OverlayFrame:Hide() end
            
            -- [[ CHECK THE SETTING ]]
            if SGJ_Settings and SGJ_Settings.ShowBagArrows == false then return end
            
            if not link then return end
            
            local weights, specName = MSC.GetCurrentWeights()
            if not weights then return end

            local _, _, _, equipLoc = GetItemInfo(link)
            if equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP" then
                if MSC.IsItemUsable(link) then
                    local compSlot = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
                    if compSlot then
                        local newScore, oldScore = MSC:EvaluateUpgrade(link, compSlot, weights, specName)
                        
                        if newScore and oldScore then
                            local overlayType = nil
                            if (newScore > (oldScore + 0.1)) then overlayType = "UP"
                            elseif (oldScore > (newScore + 0.1)) then overlayType = "DOWN" end
                            
                            if overlayType then
                                if not button.SGJ_OverlayFrame then
                                    -- Dedicated child frame to force a high Z-index
                                    button.SGJ_OverlayFrame = CreateFrame("Frame", nil, button)
                                    button.SGJ_OverlayFrame:SetAllPoints(button)
                                    
                                    button.SGJ_Overlay = button.SGJ_OverlayFrame:CreateTexture(nil, "OVERLAY", nil, 7)
                                    button.SGJ_Overlay:SetSize(18, 18)
                                    button.SGJ_Overlay:SetPoint("TOPRIGHT", button.SGJ_OverlayFrame, "TOPRIGHT", -2, -2)
                                end
                                button.SGJ_Overlay:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. (overlayType == "UP" and "Upgrade.png" or "Downgrade.png"))
                                
                                -- Guarantee it sits above ElvUI's strict layering system
                                button.SGJ_OverlayFrame:SetFrameLevel(math.max(10, button:GetFrameLevel() + 5))
                                button.SGJ_OverlayFrame:Show()
                            end
                        end
                    end
                end
            end
        end)
    end

    -- [[ 1. ELVUI SUPPORT (FIXED) ]]
    if CheckAddOnLoaded("ElvUI") then
        local E = unpack(ElvUI)
        if E then
            -- ElvUI Bags Hook (Existing)
            local B = E:GetModule('Bags')
            if B and B.UpdateSlot then
                hooksecurefunc(B, "UpdateSlot", function(self, frame, bagID, slotID)
                    if frame and frame.Bags and frame.Bags[bagID] and frame.Bags[bagID][slotID] then 
                        local itemButton = frame.Bags[bagID][slotID]
                        local link = GetContainerItemLink(bagID, slotID)
                        EvaluateAndDraw(itemButton, link) 
                    end
                end)
            end

            -- ElvUI Loot Roll Hook
            local M = E:GetModule('Misc')
            if M and M.START_LOOT_ROLL then
                hooksecurefunc(M, "START_LOOT_ROLL", function(self, event, rollID, rollTime)
                    -- Wait 0.05s to ensure ElvUI has fully shown the frame and populated the link
                    C_Timer.After(0.05, function()
                        -- ElvUI stores its custom loot frames in M.RollBars
                        if self.RollBars then
                            for _, bar in ipairs(self.RollBars) do
                                -- Ensure the frame is actively showing a roll
                                if bar:IsShown() and bar.rollID == rollID and bar.button and bar.button.link then
                                -- CHECK THE NEW SETTING FIRST
                                if SGJ_Settings and SGJ_Settings.ShowLootArrows == false then 
                                    if bar.button.SGJ_OverlayFrame then bar.button.SGJ_OverlayFrame:Hide() end
                                    return 
                                end
                                
                                local btn = bar.button
                                    EvaluateAndDraw(bar.button, bar.button.link)
                                end
                            end
                        end
                    end)
                end)
            end
        end
    end
	
	-- [[ 2. XLOOT GROUP SUPPORT ]]
    if CheckAddOnLoaded("XLoot_Group") and _G.XLootGroup then
        local XLG = _G.XLootGroup
        if XLG.START_LOOT_ROLL then
            hooksecurefunc(XLG, "START_LOOT_ROLL", function(self, id)
                -- Wait 0.05s to ensure XLoot has fully built the frame and assigned the link
                C_Timer.After(0.05, function()
                    -- XLoot stores active roll frames inside its anchor's children table
                    if self.anchor and self.anchor.children then
                        for _, frame in pairs(self.anchor.children) do
                            -- Match the frame to the roll ID that triggered the event
                            if frame:IsShown() and frame.rollid == id and frame.link and frame.icon_frame then
                                -- frame.icon_frame is the square icon container
                                EvaluateAndDraw(frame.icon_frame, frame.link)
                            end
                        end
                    end
                end)
            end)
        end
    end

    -- [[ 3. BAGNON SUPPORT ]]
    if CheckAddOnLoaded("Bagnon") and Bagnon and Bagnon.ItemSlot then
        hooksecurefunc(Bagnon.ItemSlot, "Update", function(self)
            if self:IsShown() then
                -- Backup link retrieval methods just in case Bagnon API changes
                local link = self.GetItem and self:GetItem()
                if not link and self.bag and self.slot then link = GetContainerItemLink(self.bag, self.slot) end
                EvaluateAndDraw(self, link)
            end
        end)
    end

    -- [[ 4. BAGANATOR SUPPORT ]]
    if CheckAddOnLoaded("Baganator") and Baganator then
        if Baganator.ItemButtonUtil and Baganator.ItemButtonUtil.UpdateItemButton then
            hooksecurefunc(Baganator.ItemButtonUtil, "UpdateItemButton", function(self)
                if self and self:IsShown() then
                    local bagID = self.bagID or self.bag
                    local slotID = self.slotID or self.slotIndex
                    if bagID and slotID then
                        local link = GetContainerItemLink(bagID, slotID)
                        EvaluateAndDraw(self, link)
                    end
                end
            end)
        end
    end
end)

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
	f.cooldown.noCooldownCount = true -- Ignores Blizzard's default cooldown text
    f.cooldown.noOCC = true           -- Ignores OmniCC and TullaCC
	f.cooldown:SetHideCountdownNumbers(true) -- Ignores Blizzard's native UI text
    return f
end

function MSC.ApplyRingArt(f, statType)
    -- 1. IDENTIFY THE TARGET TEXTURE
    local targetTexture
    if statType == "Current Defense" or statType == "Crush Cap" or statType == "Defense" then
        targetTexture = "Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Rune.tga"
    elseif string_find(statType, "Hit") or string_find(statType, "Haste") or string_find(statType, "Power") then
        targetTexture = "Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Swirl.tga"
    elseif string_find(statType, "Crit") or statType == "Expertise" then
        targetTexture = "Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Sun.tga"
    else
        targetTexture = "Interface\\Common\\RingBorder"
    end

    -- 2. ONLY APPLY IF DIFFERENT (Prevents Stutter)
    if f.CurrentArt == targetTexture then return end
    f.CurrentArt = targetTexture

    -- 3. RESET & STOP ONLY ON ACTUAL CHANGE
    if f.AnimGroup:IsPlaying() then f.AnimGroup:Stop() end
    f.Spin:SetDuration(0)
    f.Pulse:SetDuration(0)
    f.Energy:SetRotation(0)
    f.Energy:SetTexture(targetTexture)

    -- 4. APPLY SPECIFIC STYLE LOGIC
    if targetTexture:find("Ring_Rune") then
        f.Spin:SetDegrees(360); f.Spin:SetDuration(60)
        if statType == "Crush Cap" then f.Energy:SetVertexColor(1.0, 0.8, 0.2, 1) end
    elseif targetTexture:find("Ring_Swirl") then
        f.Spin:SetDegrees(-360); f.Spin:SetDuration(30)
        if statType == "Spell Power" then f.Energy:SetVertexColor(0.2, 0.7, 1.0, 1)
        elseif statType:find("Haste") then f.Energy:SetVertexColor(1.0, 0.8, 0.0, 1)
        elseif statType == "Spell Hit" then f.Energy:SetVertexColor(0.2, 1.0, 0.8, 1)
        else f.Energy:SetVertexColor(0.2, 1.0, 0.2, 1) end
    elseif targetTexture:find("Ring_Sun") then
        f.Pulse:SetScaleFrom(1, 1); f.Pulse:SetScaleTo(1.1, 1.1)
        f.Pulse:SetDuration(0.5); f.Pulse:SetSmoothing("IN_OUT")
        if statType:find("Spell") then f.Energy:SetVertexColor(0.8, 0.2, 1.0, 1)
        elseif statType:find("Crit") then f.Energy:SetVertexColor(1.0, 0.0, 0.0, 1)
        else f.Energy:SetVertexColor(1.0, 0.5, 0.0, 1) end
    end

    if (f.Spin:GetDuration() > 0 or f.Pulse:GetDuration() > 0) then
        f.AnimGroup:Play()
    end
end

local function GetClassRings(class, stats, weights)
    local playerLevel = UnitLevel("player")
	local rings = {}
    local CAP_HIT_MELEE = 9
    local CAP_HIT_SPELL = 16
    local CAP_EXP = 26
	local maxBaseDef = playerLevel * 5
	local CAP_DEF = maxBaseDef + 140
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

    -- NEW: Tracking table for Tooltips
    local modifiers = {}
    local function AddMod(ringLabel, sourceName, value, isPercent)
        if value and (type(value) == "string" or value > 0) then
            if not modifiers[ringLabel] then modifiers[ringLabel] = {} end
            table_insert(modifiers[ringLabel], { source = sourceName, val = value, isPct = isPercent })
        end
    end

    if class == "MAGE" then
        local arcane = GetTalentRank(1, "Arcane Focus") * 2
        local frost = GetTalentRank(3, "Elemental Precision") * (isTBC and 1 or 2)
        spellHitBonus = math_max(arcane, frost)
        if arcane >= frost and arcane > 0 then AddMod("Spell Hit", "Arcane Focus", arcane, true)
        elseif frost > arcane then AddMod("Spell Hit", "Elemental Precision", frost, true) end
    elseif class == "WARLOCK" then
        spellHitBonus = GetTalentRank(1, "Suppression") * 2
        AddMod("Spell Hit", "Suppression", spellHitBonus, true)
    elseif class == "PRIEST" then
        spellHitBonus = GetTalentRank(3, "Shadow Focus") * 2
        AddMod("Spell Hit", "Shadow Focus", spellHitBonus, true)
    elseif class == "SHAMAN" then
        local elePrec = GetTalentRank(1, "Elemental Precision") * 2
        local natGuid = GetTalentRank(3, "Nature's Guidance") * 1
        spellHitBonus = elePrec + natGuid
        meleeHitBonus = natGuid
        AddMod("Spell Hit", "Elemental Precision", elePrec, true)
        AddMod("Spell Hit", "Nature's Guidance", natGuid, true)
        AddMod("Hit Cap", "Nature's Guidance", natGuid, true)
    elseif class == "DRUID" then
        if isTBC then 
            spellHitBonus = GetTalentRank(1, "Balance of Power") * 2 
            AddMod("Spell Hit", "Balance of Power", spellHitBonus, true)
            local sotf = GetTalentRank(2, "Survival of the Fittest")
            if sotf > 0 then
                local reduction = (sotf == 3 and 75) or (sotf == 2 and 50) or (sotf == 1 and 25) or 0
                AddMod("Current Defense", "Survival of the Fittest", "Cap reduced by " .. reduction, false)
            end
            if sotf == 3 then CAP_DEF = maxBaseDef + 65
            elseif sotf == 2 then CAP_DEF = maxBaseDef + 90
            elseif sotf == 1 then CAP_DEF = maxBaseDef + 115 
            end
        end
    elseif class == "ROGUE" then
        meleeHitBonus = GetTalentRank(2, "Precision") * 1
        AddMod("Hit Cap", "Precision", meleeHitBonus, true)
        local wepExp = GetTalentRank(2, "Weapon Expertise")
        expertBonus = expertBonus + (wepExp * 5)
        AddMod("Expertise", "Weapon Expertise", wepExp * 5, false)
    elseif class == "HUNTER" then
        meleeHitBonus = GetTalentRank(3, "Surefooted") * 1
        AddMod("Hit Cap", "Surefooted", meleeHitBonus, true)
    elseif class == "PALADIN" or class == "WARRIOR" then
        meleeHitBonus = GetTalentRank(2, "Precision") * 1
        AddMod("Hit Cap", "Precision", meleeHitBonus, true)
        if class == "PALADIN" then 
            spellHitBonus = meleeHitBonus 
            AddMod("Spell Hit", "Precision", spellHitBonus, true)
            if isTBC then 
                local cbExp = GetTalentRank(2, "Combat Expertise")
                expertBonus = expertBonus + cbExp 
                AddMod("Expertise", "Combat Expertise", cbExp, false)
            end
        end
        if class == "WARRIOR" and isTBC then 
            local def = GetTalentRank(3, "Defiance") * 2
            expertBonus = expertBonus + def
            AddMod("Expertise", "Defiance", def, false)
        end
    end

    local mhLink = GetInventoryItemLink("player", 16)
    if mhLink then
        local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(mhLink)
        if playerRace == "Human" then
            if subClassID == 7 or subClassID == 8 or subClassID == 4 or subClassID == 5 then
                expertBonus = expertBonus + 5
                AddMod("Expertise", "Mace/Sword Spec (Human)", 5, false)
            end
        elseif playerRace == "Orc" then
            if subClassID == 0 or subClassID == 1 then
                expertBonus = expertBonus + 5
                AddMod("Expertise", "Axe Spec (Orc)", 5, false)
            end
        end
    end

    local rangedLink = GetInventoryItemLink("player", 18)
    if rangedLink then
        local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(rangedLink)
        if playerRace == "Dwarf" then
            if subClassID == 3 then 
                critBonus = critBonus + 1 
                AddMod("Crit", "Gun Spec (Dwarf)", 1, true)
            end 
        elseif playerRace == "Troll" then
            if subClassID == 2 then 
                critBonus = critBonus + 1 
                AddMod("Crit", "Bow Spec (Troll)", 1, true)
            end 
        end
    end

    if isTBC and playerRace == "Draenei" then
        spellHitBonus = spellHitBonus + 1
        meleeHitBonus = meleeHitBonus + 1
        AddMod("Hit Cap", "Heroic Presence (Draenei)", 1, true)
        AddMod("Spell Hit", "Inspiring Presence (Draenei)", 1, true)
    end

    local function AddRing(label, statKey, capTarget, formatStr, isSkill)
        local val = stats[statKey] or 0
        local currentDisplay = 0; local capRating = 0; local scalar = 0
        local isCustomCap = false
        local isRating = false

        if statKey == "CRUSH_CAP" then
			isCustomCap = true
			local buffBonus = 0
			
			if class == "PALADIN" and GetTalentRank(2, "Holy Shield") > 0 then
				buffBonus = 30.0
                AddMod("Crush Cap", "Holy Shield", 30.0, true)
			elseif class == "WARRIOR" and UnitLevel("player") >= 10 then
				buffBonus = 75.0
                AddMod("Crush Cap", "Shield Block", 75.0, true)
			end
			
			-- 5% Base Miss + Avoidance Stats + Active Buff
			val = 5.0 + GetDodgeChance() + GetParryChance() + GetBlockChance() + buffBonus
			currentDisplay = val
			capRating = capTarget
            
        elseif statKey == "ITEM_MOD_HIT_RATING_SHORT" then val = GetCombatRating(6); isRating = true
        elseif statKey == "ITEM_MOD_HIT_SPELL_RATING_SHORT" then val = GetCombatRating(8); isRating = true
        elseif statKey == "ITEM_MOD_EXPERTISE_RATING_SHORT" then val = GetCombatRating(24); isRating = true
        elseif statKey == "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" then val = GetCombatRating(2); isRating = true
        elseif statKey == "ITEM_MOD_CRIT_RATING_SHORT" then val = GetCombatRating(9); isRating = true
        elseif statKey == "ITEM_MOD_SPELL_CRIT_RATING_SHORT" then val = GetCombatRating(11); isRating = true
        elseif statKey == "ITEM_MOD_HASTE_RATING_SHORT" then val = GetCombatRating(18); isRating = true
        elseif statKey == "ITEM_MOD_SPELL_HASTE_RATING_SHORT" then val = GetCombatRating(20); isRating = true
        elseif statKey == "ITEM_MOD_DODGE_RATING_SHORT" then val = GetCombatRating(3); isRating = true
        elseif statKey == "ITEM_MOD_SPELL_POWER_SHORT" then 
            local maxSP = 0
            for i=2, 7 do maxSP = math_max(maxSP, GetSpellBonusDamage(i)) end
            val = maxSP
            currentDisplay = val
            capRating = capTarget
        end

        if not isCustomCap then
            local level = UnitLevel("player"); if level > 70 then level = 70 end
            if label == "Expertise" then
                scalar = (MSC.CombatRatingScalars and MSC.CombatRatingScalars[level]) and MSC.CombatRatingScalars[level][1] or 3.94
            elseif label == "Current Defense" then
                scalar = (MSC.CombatRatingScalars and MSC.CombatRatingScalars[level]) and MSC.CombatRatingScalars[level][2] or 2.37
            else
                local idx = MSC.RatingIndexMap and MSC.RatingIndexMap[statKey]
                if idx and MSC.CombatRatingScalars and MSC.CombatRatingScalars[level] then scalar = MSC.CombatRatingScalars[level][idx] else scalar = 15.8 end
            end
    
            if isSkill then
				if label == "Current Defense" then
					-- 1. Safely grab ONLY the base leveled skill
					local baseDef = UnitDefense("player")
					
					-- Fallback in case the API fires before the player is fully loaded
					if not baseDef or baseDef == 0 then
						baseDef = UnitLevel("player") * 5
					end
					
					-- 2. Add your true base skill to the addon's evaluated gear skill
					local skillAdded = math_floor(val / scalar)
					currentDisplay = baseDef + skillAdded
					
					-- 3. Calculate the shortfall gap based on your true total
					local skillShortfall = math_max(0, capTarget - currentDisplay)
					
					-- 4. Set the visual target cap
					capRating = val + (skillShortfall * scalar)
				else
					local skillAdded = math_floor(val / scalar)
					currentDisplay = skillAdded + expertBonus
					local skillShortfall = math_max(0, capTarget - currentDisplay)
					capRating = capTarget > 0 and (val + (skillShortfall * scalar)) or 0
				end
            elseif isRating then
                if label == "Dodge" then
                    currentDisplay = GetDodgeChance()
                elseif string_find(label, "Spell Crit") then
                    currentDisplay = GetSpellCritChance(2)
                elseif string_find(label, "Crit") then
                    if class == "HUNTER" and GetRangedCritChance then
                        currentDisplay = GetRangedCritChance() + critBonus
                    else
                        currentDisplay = GetCritChance() + critBonus
                    end
                else
                    currentDisplay = val / scalar
                    if label == "Hit Cap" then
                        currentDisplay = currentDisplay + meleeHitBonus
                    elseif label == "Spell Hit" then
                        currentDisplay = currentDisplay + spellHitBonus
                    end
                end
                
                -- Safely map out Rating shortfalls for tooltips 
                local shortfall = math_max(0, capTarget - currentDisplay)
                capRating = capTarget > 0 and (val + (shortfall * scalar)) or 0
            end
        end

        table_insert(rings, { l=label, v=currentDisplay, m=capTarget, fmt=formatStr, rawVal = val, rawCap = capRating, scalar = scalar, isCustom = isCustomCap, mods = modifiers[label] })
    end

   -- [[ ROLE SELECTOR ]]
    if class == "WARRIOR" or class == "ROGUE" or class == "HUNTER" then
        if class == "WARRIOR" and (weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0) > 0.5 then
            AddRing("Current Defense", "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", CAP_DEF, "%d", true)
            AddRing("Crush Cap", "CRUSH_CAP", 102.4, "%.2f%%")
            AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%")
            AddRing("Expertise", "ITEM_MOD_EXPERTISE_RATING_SHORT", CAP_EXP, "%d", true)
        else
            AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%")
            AddRing("Crit", "ITEM_MOD_CRIT_RATING_SHORT", 35, "%.1f%%") 
            AddRing("Haste", "ITEM_MOD_HASTE_RATING_SHORT", 20, "%.1f%%")
            -- Hunters don't use Expertise, so they just get 3 clean rings!
            if class ~= "HUNTER" then AddRing("Expertise", "ITEM_MOD_EXPERTISE_RATING_SHORT", CAP_EXP, "%d", true) end
        end
    elseif class == "MAGE" or class == "WARLOCK" or class == "PRIEST" then
        AddRing("Spell Hit", "ITEM_MOD_HIT_SPELL_RATING_SHORT", CAP_HIT_SPELL, "%.1f%%")
        AddRing("Spell Crit", "ITEM_MOD_SPELL_CRIT_RATING_SHORT", 30, "%.1f%%") 
        AddRing("Haste", "ITEM_MOD_SPELL_HASTE_RATING_SHORT", 20, "%.1f%%")  
        AddRing("Spell Power", "ITEM_MOD_SPELL_POWER_SHORT", 0, "%d")    
   elseif class == "PALADIN" or class == "SHAMAN" or class == "DRUID" then
        local isTank = (weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0) > 0.5
        local isCaster = (weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0) > (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 0)
        
        if isTank then
            AddRing("Current Defense", "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", CAP_DEF, "%d", true)
            -- Druids can't block/parry, so give them Dodge instead of a broken Crush Cap!
            if class == "DRUID" then AddRing("Dodge", "ITEM_MOD_DODGE_RATING_SHORT", 40, "%.1f%%") else AddRing("Crush Cap", "CRUSH_CAP", 102.4, "%.2f%%") end
            AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%") 
            AddRing("Expertise", "ITEM_MOD_EXPERTISE_RATING_SHORT", CAP_EXP, "%d", true)
        elseif isCaster then
            AddRing("Spell Hit", "ITEM_MOD_HIT_SPELL_RATING_SHORT", CAP_HIT_SPELL, "%.1f%%")
            AddRing("Spell Crit", "ITEM_MOD_SPELL_CRIT_RATING_SHORT", 30, "%.1f%%")
            AddRing("Haste", "ITEM_MOD_SPELL_HASTE_RATING_SHORT", 20, "%.1f%%")
            AddRing("Spell Power", "ITEM_MOD_SPELL_POWER_SHORT", 0, "%d")
        else
            AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%")
            AddRing("Crit", "ITEM_MOD_CRIT_RATING_SHORT", 35, "%.1f%%")
            AddRing("Haste", "ITEM_MOD_HASTE_RATING_SHORT", 20, "%.1f%%")
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
        if i <= 4 then -- Allow 4 rings for tanks!
            local xPos = 25 + ((i-1) * 110) -- Tighter spacing to fit perfectly
            local f = MSC.GetFromPool("Rings", content, function(p) return CreateStatRing(p, 0, 0, 80, "TEMP") end)
            f:ClearAllPoints(); f:SetPoint("TOPLEFT", xPos, -20)
            local locLabel = MSC.L[ring.l] or ring.l
            f.lbl:SetText(locLabel:upper())
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
                local locLabel = MSC.L[ring.l] or ring.l
                GameTooltip:SetText(locLabel, 1, 1, 1)
                GameTooltip:AddLine(" ")
                
                -- Custom Tooltip logic for Crush Cap
                if ring.isCustom and ring.l == "Crush Cap" then
                    GameTooltip:AddDoubleLine(MSC.L["Current Avoidance:"], string_format("%.2f%%", ring.v), 1, 0.82, 0, 1, 1, 1)
                    local diff = ring.m - ring.v
                    if diff > 0 then 
                        GameTooltip:AddLine(string_format(MSC.L["Need %.2f%% more to cap."], diff), 1, 0.5, 0.5) 
                    else 
                        GameTooltip:AddLine(MSC.L["Uncrushable!"], 0, 1, 0) 
                    end
                elseif ring.rawVal and ring.rawCap and ring.rawCap > 0 then
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
                if ring.scalar and ring.scalar > 1 then 
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(string_format(MSC.L["1%% requires %.2f Rating"], ring.scalar), 0.6, 0.6, 0.6) 
                end

                -- NEW: Draw Modifiers if they exist
                if ring.mods and #ring.mods > 0 then
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine(MSC.L["Active Modifiers:"], 0.2, 1, 0.8) -- Distinct Teal Color
                    for _, mod in ipairs(ring.mods) do
                        local modValStr = ""
                        if type(mod.val) == "string" then
                            modValStr = mod.val
                        else
                            modValStr = string_format(mod.isPct and "+%.0f%%" or "+%d", mod.val)
                        end
                        GameTooltip:AddDoubleLine(mod.source, modValStr, 0.8, 0.8, 0.8, 0, 1, 0)
                    end
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
    for k, v in pairs(weights) do 
        if type(v) == "number" and v > 0 then 
            table_insert(sorted, {k=k, v=v})
            if v > maxW then maxW = v end 
        end 
    end
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
    
    -- [[ FIXED ACTION BUTTONS (Always visible at the bottom) ]]
    local bImp = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    bImp:SetSize(140, 30); bImp:SetPoint("BOTTOMRIGHT", -40, 40)
    bImp:SetText(MSC.L["Import Pawn String"])
    bImp:SetScript("OnClick", function() MSC.ShowImportWindow() end)

    local bExport = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    bExport:SetSize(140, 30); bExport:SetPoint("BOTTOMRIGHT", -190, 40)
    bExport:SetText(MSC.L["Export Data"])
    bExport:SetScript("OnClick", function() MSC.ShowHistory() end)

    -- [[ MASTER SCROLL FRAME ]]
    local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 10, -10)
    scroll:SetPoint("BOTTOMRIGHT", -40, 80) -- Leaves 80px of room at the bottom for the buttons
    
    local sChild = CreateFrame("Frame", nil, scroll)
    sChild:SetSize(500, 1000) -- Height expands dynamically below
    scroll:SetScrollChild(sChild)

    -- [[ UI HELPERS (Now parented to sChild) ]]
    local function CreateHeader(text, relTo, yOff, xOverride, yOverride, tooltip)
        local h = sChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); h:SetText(text); h:SetTextColor(1, 0.82, 0)
        if xOverride then h:SetPoint("TOPLEFT", xOverride, yOverride) 
        elseif relTo then h:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", 0, yOff) 
        else h:SetPoint("TOPLEFT", 30, -20) end
        if tooltip then
            local hitRect = CreateFrame("Frame", nil, sChild)
            hitRect:SetPoint("TOPLEFT", h, "TOPLEFT", -10, 10); hitRect:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT", 50, -10)
            hitRect:EnableMouse(true)
            hitRect:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(text, 1, 1, 1); GameTooltip:AddLine(tooltip, nil, nil, nil, true); GameTooltip:Show() end)
            hitRect:SetScript("OnLeave", GameTooltip_Hide)
        end
        return h
    end

    local function CreateDropdown(label, key, options, relTo, yOff, tooltip)
        local frame = CreateFrame("Frame", nil, sChild); frame:SetSize(200, 50); frame:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", 0, yOff); frame:EnableMouse(true)
        if tooltip then
            frame:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(label, 1, 1, 1); GameTooltip:AddLine(tooltip, nil, nil, nil, true); GameTooltip:Show() end)
            frame:SetScript("OnLeave", GameTooltip_Hide)
        end
        local lbl = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); lbl:SetPoint("TOPLEFT", 0, 0); lbl:SetText(label); lbl:SetTextColor(0.6, 0.6, 0.6)
        local dd = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate"); dd:SetPoint("TOPLEFT", -15, -15); UIDropDownMenu_SetWidth(dd, 180)
        local function OnClick(self) 
            UIDropDownMenu_SetSelectedID(dd, self:GetID()); SGJ_Settings[key] = self.value
            if key == "Mode" then MSC.ManualSpec = self.value; MSC.CachedWeights = nil end 
            if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
            MSC.BagCacheDirty = true; if RequestUpdate then RequestUpdate() end
        end
        local function Init(self, level) for _, opt in ipairs(options) do local info = UIDropDownMenu_CreateInfo(); info.text = opt.text; info.value = opt.val; info.func = OnClick; info.checked = (SGJ_Settings[key] == opt.val); UIDropDownMenu_AddButton(info, level) end end
        UIDropDownMenu_Initialize(dd, Init)
        local currentText = MSC.L["Select..."]; for _, opt in ipairs(options) do if SGJ_Settings[key] == opt.val then currentText = opt.text end end
        UIDropDownMenu_SetText(dd, currentText); if key == "Mode" then f.ProfileDD = dd end
        return frame
    end

    local function CreateCheck(label, key, tooltip, relTo, xOff, yOff)
        local cb = CreateFrame("CheckButton", nil, sChild, "ChatConfigCheckButtonTemplate"); cb:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", xOff, yOff); cb.Text:SetText(label); cb.Text:SetTextColor(0.9, 0.9, 0.9); cb:SetChecked(SGJ_Settings[key])
        cb:SetScript("OnClick", function(self) SGJ_Settings[key] = self:GetChecked(); if key == "HideMinimap" then MSC.UpdateMinimapPosition() end end)
        if tooltip then cb:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(tooltip, nil, nil, nil, nil, true); GameTooltip:Show() end); cb:SetScript("OnLeave", GameTooltip_Hide) end
        return cb
    end
    
    -- ==========================================
    -- SECTION 1: INTERFACE OPTIONS
    -- ==========================================
    local hInterface = CreateHeader(MSC.L["Interface Options"], nil, 0)    
    local cb1 = CreateCheck(MSC.L["Hide Minimap Button"], "HideMinimap", MSC.L["Hides the circular button on your minimap."], hInterface, 0, -10)  
    local cb2 = CreateCheck(MSC.L["Hide Tooltip Verdict"], "HideTooltips", MSC.L["Stops the addon from adding scores to item tooltips."], cb1, 0, -5)   
    local cbShift = CreateCheck(MSC.L["Show Only via Shift Key"], "ShiftOnlyTooltip", MSC.L["Only shows the Judge score in tooltips while holding the SHIFT key."], cb2, 20, -5)
    cb2:HookScript("OnClick", function(self) if self:GetChecked() then cbShift:SetAlpha(0.5); cbShift:Disable() else cbShift:SetAlpha(1); cbShift:Enable() end end)
    local cb3 = CreateCheck(MSC.L["Mute Error Sounds"], "MuteSounds", MSC.L["Stops the error sound when clicking invalid items."], cbShift, -20, -5)
    local cb4 = CreateCheck(MSC.L["Disable Conflict Check"], "DisableConflictCheck", MSC.L["Stops the chat warning about Pawn/Zygor."], cb3, 0, -5)
    local cbBagArrows = CreateCheck(MSC.L["Show Bag Upgrade Arrows"], "ShowBagArrows", MSC.L["Shows green upgrade arrows on items in your bags."], cb4, 0, -5)
    cbBagArrows:HookScript("OnClick", function() MSC.BagCacheDirty = true; if RequestUpdate then RequestUpdate() end end)
    local cbLootArrows = CreateCheck(MSC.L["Show Loot Roll Arrows"], "ShowLootArrows", MSC.L["Shows green upgrade arrows on group loot popups."], cbBagArrows, 0, -5)
    
    -- ==========================================
    -- SECTION 2: TOOLTIP VISUALS
    -- ==========================================
    local hVisuals = CreateHeader(MSC.L["Tooltip Visuals"], cbLootArrows, -25)
    local cbCompact = CreateCheck(MSC.L["Compact Equip Text"], "CompactEquip", MSC.L["Makes the text smaller and cleaner."], hVisuals, 0, -10)
    local cbSimple = CreateCheck(MSC.L["Shorten Stat Names"], "SimplifyStats", MSC.L["Changes 'Spell Power' to 'SP', etc."], cbCompact, 0, -5)
    local cbColor = CreateCheck(MSC.L["Colorize Stats"], "ColorizeStats", MSC.L["Applies class/role colors to text."], cbSimple, 0, -5)

    -- ==========================================
    -- SECTION 3: COMPARISON LOGIC
    -- ==========================================
    local hLogic = CreateHeader(MSC.L["Comparison Logic"], cbColor, -25)
    local enchantTip = MSC.L["Controls how item enchantments affect the score.\n\n|cffffffffOff:|r Scores items based on base stats only.\n|cffffffffCurrent:|r Includes the value of the enchant currently on the item.\n|cffffffffProject:|r Simulates the best possible enchant for that item level."]
    local ddEnchant = CreateDropdown(MSC.L["Enchant Mode"], "EnchantMode", {{ text = MSC.L["Off (Raw Stats)"], val = 1 }, { text = MSC.L["Current Only"], val = 2 }, { text = MSC.L["Project Best"], val = 3 }}, hLogic, -10, enchantTip)
    local gemTip = MSC.L["Controls how empty sockets are scored.\n\n|cffffffffThe Skeptic:|r Empty sockets are worth 0. Socket bonuses are ignored unless fully met.\n|cffffffffThe Casual:|r Simple gemming logic, usually respects socket colors.\n|cffffffffThe Pro:|r Min-max gemming logic, prioritizes absolute highest score."]
    local ddGem = CreateDropdown(MSC.L["Gemming Logic"], "GemMode", {{ text = MSC.L["The Skeptic"], val = 1 }, { text = MSC.L["The Casual"], val = 2 }, { text = MSC.L["The Pro"], val = 3 }}, ddEnchant, -5, gemTip)
    local gemQualTip = MSC.L["Selects the quality tier of gems the Judge will use when projecting empty sockets."]
    local ddGemQuality = CreateDropdown(MSC.L["Gem Quality"], "GemQuality", {{ text = MSC.L["Common (White/Vendor)"], val = 1 }, { text = MSC.L["Uncommon (Green)"], val = 2 }, { text = MSC.L["Rare (Blue)"], val = 3 }, { text = MSC.L["Epic (Purple)"], val = 4 }}, ddGem, -5, gemQualTip)

    -- ==========================================
    -- SECTION 4: CHARACTER PROFILE
    -- ==========================================
    local hProfile = CreateHeader(MSC.L["Character Profile"], ddGemQuality, -25)
    local specOptions = { { text = MSC.L["Auto-Detect"], val = "AUTO" } }; local seen = { ["AUTO"] = true }; local profileList = {}
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
        AddList(MSC.CurrentClass.Weights); AddList(MSC.CurrentClass.LevelingWeights); AddList(MSC.CurrentClass.Profiles)
    end 
    local profileTip = MSC.L["Manually override the scoring profile.\n\n|cffffffffAuto-Detect:|r Automatically selects a profile based on your talents and recent gameplay.\n\nSelecting a specific profile forces the addon to judge all gear for that spec, regardless of your current talents."]
    local ddProfile = CreateDropdown(MSC.L["Active Scoring Profile"], "Mode", specOptions, hProfile, -10, profileTip)
    
    local bDeleteProfile = CreateFrame("Button", nil, sChild, "UIPanelButtonTemplate")
    bDeleteProfile:SetSize(80, 22); bDeleteProfile:SetPoint("LEFT", ddProfile, "RIGHT", 0, -7); bDeleteProfile:SetText(MSC.L["Delete"])
    bDeleteProfile:SetScript("OnClick", function()
        local selected = SGJ_Settings.Mode
        if selected and SharpiesGearJudgeDB and SharpiesGearJudgeDB.customWeights and SharpiesGearJudgeDB.customWeights[selected] then
            SharpiesGearJudgeDB.customWeights[selected] = nil
            if MSC.CurrentClass and MSC.CurrentClass.Weights then MSC.CurrentClass.Weights[selected] = nil end
            SGJ_Settings.Mode = "AUTO"; MSC.ManualSpec = "AUTO"; MSC.CachedWeights = nil
            print(string.format(MSC.L["|cff00ff00SGJ:|r Deleted custom profile: %s"], selected))
            StaticPopup_Show("SGJ_RELOAD_REQUIRED")
        else print(MSC.L["|cffff0000SGJ:|r You can only delete custom imported profiles."]) end
    end)

	-- ==========================================
    -- SECTION 5: MULTI-SPEC TRACKING & BASELINES
    -- ==========================================
    local specTip = MSC.L["Select additional profiles to track in tooltips.\n\nYou can also lock in your current gear and talents as the 'Baseline' for that spec. This ensures the addon compares new drops against your actual off-spec setup, rather than your live paper doll."]
    local hSpec = CreateHeader(MSC.L["Secondary Specs & Baselines"], ddProfile, -25, nil, nil, specTip)
    
    local lastAnchor = hSpec
    for _, p in ipairs(profileList) do
        -- 1. The Tracking Checkbox
        local cb = CreateFrame("CheckButton", nil, sChild, "ChatConfigCheckButtonTemplate")
        if lastAnchor == hSpec then cb:SetPoint("TOPLEFT", lastAnchor, "BOTTOMLEFT", 0, -10) else cb:SetPoint("TOPLEFT", lastAnchor, "BOTTOMLEFT", 0, -5) end
        cb.Text:SetText(p.text); cb.Text:SetTextColor(0.8, 0.8, 0.8)
        cb:SetChecked(SGJ_Settings.TrackedSpecs and SGJ_Settings.TrackedSpecs[p.val])
        cb:SetScript("OnClick", function(self) 
            if not SGJ_Settings.TrackedSpecs then SGJ_Settings.TrackedSpecs = {} end
            SGJ_Settings.TrackedSpecs[p.val] = self:GetChecked()
        end)
        
        -- 2. The "Save Profile" Button
        local btnSave = CreateFrame("Button", nil, sChild, "UIPanelButtonTemplate")
        btnSave:SetSize(90, 22)
        btnSave:SetPoint("LEFT", cb, "LEFT", 220, 0) 
        btnSave:SetText(MSC.L["Save Profile"])
        btnSave:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(MSC.L["Lock Baseline Profile"], 1, 1, 1)
            GameTooltip:AddLine(MSC.L["Saves your currently equipped gear AND active talents as the baseline for this spec.\n\nMake sure you are actively in this spec and wearing its gear before clicking this!"], nil, nil, nil, true)
            GameTooltip:Show()
        end)
        btnSave:SetScript("OnLeave", GameTooltip_Hide)

        -- 3. The "Clear Baseline" Button (NEW)
        local btnClear = CreateFrame("Button", nil, sChild, "UIPanelButtonTemplate")
        btnClear:SetSize(60, 22)
        btnClear:SetPoint("LEFT", btnSave, "RIGHT", 5, 0)
        btnClear:SetText(MSC.L["Clear"])
        
        -- 4. The Status Label
        local statusLbl = sChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        statusLbl:SetPoint("LEFT", btnClear, "RIGHT", 10, 0)
        
        local function UpdateStatusLabel()
            local pk = MSC:GetPlayerKey()
            if SGJ_Settings.GearProfiles and SGJ_Settings.GearProfiles[pk] and SGJ_Settings.GearProfiles[pk][p.val] then
                local savedGear = SGJ_Settings.GearProfiles[pk][p.val]
                local weights = MSC.GetWeightsByName(p.val)
                if weights then
                    local score = MSC:GetTotalCharacterScore(savedGear, weights, p.val)
                    statusLbl:SetText(string.format("|cff00ff00" .. MSC.L["Saved:"] .. "|r %.1f", score))
                else
                    statusLbl:SetText("|cff00ff00" .. MSC.L["Saved"] .. "|r")
                end
                btnClear:Enable()
            else
                statusLbl:SetText("|cff888888" .. MSC.L["Not Set"] .. "|r")
                btnClear:Disable()
            end
        end
        
        -- Link the clear button
        btnClear:SetScript("OnClick", function()
            local pk = MSC:GetPlayerKey()
            if SGJ_Settings.GearProfiles and SGJ_Settings.GearProfiles[pk] then
                SGJ_Settings.GearProfiles[pk][p.val] = nil
            end
            if SGJ_Settings.TalentProfiles and SGJ_Settings.TalentProfiles[pk] then
                SGJ_Settings.TalentProfiles[pk][p.val] = nil
            end
            if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
            UpdateStatusLabel()
        end)
        
        UpdateStatusLabel() -- Initialize the text when the menu opens
        
        -- Link the button click to the save function and refresh the label
        btnSave:SetScript("OnClick", function()
            MSC:SaveBaselineProfile(p.val)
            if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
            UpdateStatusLabel() 
        end)

        lastAnchor = cb
    end

    -- Dynamically set the height of the scroll child so it perfectly fits all content
    sChild:SetScript("OnUpdate", function(self)
        if lastAnchor then
            local bottom = lastAnchor:GetBottom()
            local top = self:GetTop()
            if top and bottom then self:SetHeight(top - bottom + 20) end
            self:SetScript("OnUpdate", nil) -- Only run once
        end
    end)
    
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
    f:SetSize(650, 650); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    
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

    local cleanX = math.floor(xOfs + 0.5)
    local cleanY = math.floor(yOfs + 0.5)
    
    SGJ_Settings.MinimapPos = { point, relativePoint, cleanX, cleanY }
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

if hooksecurefunc then
    local function TriggerQuestUpdate()
        C_Timer.After(0.15, function()
            if MSC.UpdateAllQuestOverlays then MSC.UpdateAllQuestOverlays() end
        end)
    end

    if QuestInfo_Display then hooksecurefunc("QuestInfo_Display", TriggerQuestUpdate) end
    if QuestLog_Update then hooksecurefunc("QuestLog_Update", TriggerQuestUpdate) end
    if QuestFrameItems_Update then hooksecurefunc("QuestFrameItems_Update", TriggerQuestUpdate) end
    
    if MerchantFrame_UpdateMerchantInfo then
        hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
            C_Timer.After(0.05, function()
                if MSC.UpdateMerchantOverlays then MSC.UpdateMerchantOverlays() end
            end)
        end)
    end

    if ContainerFrame_Update then
        hooksecurefunc("ContainerFrame_Update", function(frame)
            C_Timer.After(0.01, function()
                if MSC.UpdateBagOverlays then MSC.UpdateBagOverlays(frame) end
            end)
        end)
    end
end

if hooksecurefunc and MerchantFrame_UpdateMerchantInfo then
    hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
        C_Timer.After(0.05, function()
            if MSC.UpdateMerchantOverlays then MSC.UpdateMerchantOverlays() end
        end)
    end)
end

if hooksecurefunc and ContainerFrame_Update then
    hooksecurefunc("ContainerFrame_Update", function(frame)
        C_Timer.After(0.01, function()
            if MSC.UpdateBagOverlays then MSC.UpdateBagOverlays(frame) end
        end)
    end)
end

if GroupLootFrame_OpenNewFrame then
        hooksecurefunc("GroupLootFrame_OpenNewFrame", function()
            C_Timer.After(0.1, function()
                if MSC.UpdateLootRollOverlays then MSC.UpdateLootRollOverlays() end
            end)
        end)
    end

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
    
    -- [ FIX FOR STATIC WINDOW ] --
    eb:EnableMouse(true)
    eb:SetScript("OnMouseDown", function(self) self:SetFocus() end)
    eb:SetScript("OnEscapePressed", function(self) self:ClearFocus() f:Hide() end) 
    
    -- Let clicking the empty space in the ScrollFrame also focus the EditBox
    sf:EnableMouse(true)
    sf:SetScript("OnMouseDown", function() eb:SetFocus() end)
    -------------------------------
    
    sf:SetScrollChild(eb)
    
    f.EditBox = eb
    return f
end

function MSC.ShowImportWindow()
    if MSC.ImportFrame then MSC.ImportFrame:Show(); return end
    local f = MSC.CreatePopupFrame(MSC.L["Import Pawn/Sixty Upgrades String"])
    f.EditBox:SetText(MSC.L["Paste Pawn or Sixty Upgrades string here..."])
    f.EditBox:HighlightText()
    local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    b:SetSize(120, 25); b:SetPoint("BOTTOM", 0, 15); b:SetText(MSC.L["Import"])
	b:SetScript("OnClick", function()
		local text = f.EditBox:GetText()
		if MSC.ImportAndSavePawnString then
			-- We only call the function; the messages are handled in SavePawnProfile
			MSC:ImportAndSavePawnString(text)
		else 
			print(MSC.L["|cffff0000SGJ Error:|r ImportAndSavePawnString missing."]) 
		end
		f:Hide() -- Hide the paste window immediately
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
        -- 1. INITIALIZE SAVED VARIABLES
        SGJ_Settings = SGJ_Settings or {}
        SharpiesGearJudgeDB = SharpiesGearJudgeDB or { customWeights = {} }
        
        -- 2. DEFINE DEFAULTS (These only apply if the setting doesn't exist yet)
        local defaults = {
            EnchantMode = 1,       -- Off
            GemMode = 1,           -- Skeptic
            GemQuality = 3,        -- NEW: Rare (Blue) Default
            Mode = "AUTO",         -- Auto-Detect
            HideMinimap = false,
            HideTooltips = false,
            MuteSounds = false,
            CompactEquip = false,
            ColorizeStats = true,
            SimplifyStats = false,
            TrackedSpecs = {},
            ShowBagArrows = false,
            ShowLootArrows = false,
        }

        -- 3. FILL MISSING SETTINGS ONLY
        -- This loop preserves existing user choices during updates
        for key, value in pairs(defaults) do
            if SGJ_Settings[key] == nil then
                SGJ_Settings[key] = value
            end
        end

        -- NEW: Ensure the manual spec override is actually loaded into the engine!
        MSC.ManualSpec = SGJ_Settings.Mode

        -- Clean up the loader
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

-- =============================================================
-- TITAN PANEL / LIBDATABROKER COMPATIBILITY
-- =============================================================
local ldb = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)
if ldb then
    ldb:NewDataObject("SharpiesGearJudge", {
        type = "launcher",
        text = "Gear Judge",
        icon = "Interface\\Icons\\INV_Misc_Spyglass_02",
        OnClick = function(self, button)
            MSC.ToggleMainMenu()
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("|cffffd100Sharpie's Gear Judge|r")
            tooltip:AddLine(MSC.L["Click to open the interface."], 1, 1, 1)
        end,
    })
end

-- [[ CATCH-ALL FOR UI RELOADS ]]
local IsLoaded = (C_AddOns and C_AddOns.IsAddOnLoaded) or IsAddOnLoaded
if IsLoaded("Blizzard_TradeSkillUI") and not MSC.TradeSkillHooked then
    if TradeSkillFrame_Update then
        hooksecurefunc("TradeSkillFrame_Update", function()
            if MSC.UpdateTradeSkillOverlays then MSC.UpdateTradeSkillOverlays() end
        end)
        hooksecurefunc("TradeSkillFrame_SetSelection", function()
            C_Timer.After(0.05, function()
                if MSC.UpdateTradeSkillOverlays then MSC.UpdateTradeSkillOverlays() end
            end)
        end)
        MSC.TradeSkillHooked = true
    end
end

-- =============================================================
-- BLIZZARD UI HOTFIX
-- PREVENTS 3RD PARTY ADDONS FROM CRASHING THE QUEST REWARD FRAME (MAINLY WEAKAURAS)
-- =============================================================
if QuestInfo_ShowRewards then
    local original_QuestInfo_ShowRewards = QuestInfo_ShowRewards
    
    QuestInfo_ShowRewards = function(...)
        local rewardsFrame = QuestInfoFrame.rewardsFrame or QuestInfoRewardsFrame
        
        if rewardsFrame and rewardsFrame.RewardButtons then
            -- 1. Prevent the "Button Height" crash by ensuring Button 1 always exists
            if not rewardsFrame.RewardButtons[1] then
                QuestInfo_GetRewardButton(rewardsFrame, 1)
            end
            
            -- 2. Find if the mystery addon left any "holes" in the table
            local maxIndex = 0
            for k, v in pairs(rewardsFrame.RewardButtons) do
                if type(k) == "number" and k > maxIndex then
                    maxIndex = k
                end
            end
            
            -- 3. Fill the holes with real buttons so Blizzard's loop doesn't hit a nil value
            for i = 1, maxIndex do
                if not rewardsFrame.RewardButtons[i] then
                    QuestInfo_GetRewardButton(rewardsFrame, i)
                end
            end
        end
        
        -- Safely resume the original Blizzard function
        return original_QuestInfo_ShowRewards(...)
    end
end