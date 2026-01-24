local addonName, MSC = ...
_G.MSC = MSC 

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
    STAMINA = {0.6, 0.2, 0.2},      -- Dark Red
    AGILITY = {0.2, 1.0, 0.6},      -- Mint Green
    STRENGTH = {1.0, 0.2, 0.2},     -- Bright Red
    ATTACK_POWER = {1.0, 0.2, 0.2}, -- Red
    HIT = {0.2, 1.0, 0.2},          -- Green
    CRIT = {1.0, 0.2, 0.4},         -- Red/Pink
    HASTE = {1.0, 0.8, 0.0},        -- Gold
    DEFENSE = {0.2, 0.4, 0.8},      -- Tank Blue
    DODGE = {0.4, 0.4, 0.8},        -- Tank Blue
    PARRY = {0.4, 0.4, 0.8},        -- Tank Blue
    BLOCK = {0.5, 0.3, 0.1},        -- Shield Brown
    RESILIENCE = {0.5, 0.5, 0.5},   -- Grey
    ARMOR = {0.8, 0.6, 0.4},        -- Leather/Tan
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
    table.insert(MSC.Pools[poolType], newFrame)
    return newFrame
end

-- [[ TAB REGISTRY ]]
MSC.RegisteredTabs = {
    { id=1, icon="Interface\\Icons\\INV_Sword_04", name="Weapon Thunderdome", funcName="InitLabView", view="ViewLab", update="UpdateLabCalc" },
    { id=2, icon="Interface\\Icons\\INV_Misc_Note_02", name="Receipt", funcName="InitReceiptView", view="ViewReceipt", update="UpdateReceipt" },
    { id=3, icon="Interface\\Icons\\Spell_Holy_MindVision", name="Stat Logic", funcName="InitLogicView", view="ViewLogic", update="UpdateLogic" },
    { id=4, icon="Interface\\Icons\\INV_Gizmo_02", name="Protocol", funcName="InitSettingsView", view="ViewSettings" }
}

if not MSC.GetInspectSpec then function MSC.GetInspectSpec(unit) return "Default" end end

-- [[ HELPER: Safe Table Copy ]]
local function CopyTable(src)
    if not src then return {} end
    local dest = {}
    for k, v in pairs(src) do dest[k] = v end
    return dest
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:SetScript("OnEvent", function(self, event, arg1) 
    if event == "BAG_UPDATE" then MSC.BagCacheDirty = true end
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

-- [[ VIEW 1: THE LABORATORY ]]
function MSC.InitLabView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    local help = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); help:SetPoint("TOP", 0, -20); help:SetText("Drag (Shift/Ctrl+Click) items to compare. 6 Sets Enter, 1 Set Wins!"); help:SetTextColor(0.6, 0.6, 0.6)

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
            table.insert(frame.Slots, btn)
        end
        MSC.LabBlocks[id] = frame
    end

    CreateBlock(1, "Option A1: Two-Hander", 1, 10, -50)
    CreateBlock(2, "Option B1: 1H + Shield/OH", 2, 10, -150)
    CreateBlock(3, "Option C1: Dual Wield", 2, 10, -250)
    CreateBlock(4, "Option A2: Two-Hander", 1, 300, -50)
    CreateBlock(5, "Option B2: 1H + Shield/OH", 2, 300, -150)
    CreateBlock(6, "Option C2: Dual Wield", 2, 300, -250)

    f.ResultText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); f.ResultText:SetPoint("BOTTOM", 0, 60); f.ResultText:SetText("Waiting for Items...")
    
    -- CLEAR BUTTON
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
        "Option A1 (2H)", "Option B1 (1H+OH)", "Option C1 (DW)",
        "Option A2 (2H)", "Option B2 (1H+OH)", "Option C2 (DW)"
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
            block.Score:SetText(string.format("%.1f", blockScore))
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
            MSC.ViewLab.ResultText:SetText("Waiting for Items...")
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
        
        MSC.ViewLab.ResultText:SetText(names[winnerIndex] .. " Wins! (+" .. string.format("%.1f", delta) .. ")")
        MSC.ViewLab.ResultText:SetTextColor(0, 1, 0)
        
        -- Stat Logic is now decoupled, so we don't call UpdateLogic here anymore.
    end
end

-- [[ VIEW 2: RECEIPT ]]
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
    local pArmor = CreatePanel("ARMOR", 220, 240, "TOPLEFT", c, "TOPLEFT", 0, 0)
    local pJewel = CreatePanel("ACCESSORIES", 130, 240, "TOPLEFT", pArmor, "TOPRIGHT", 20, 0)
    local pWeap  = CreatePanel("WEAPONS", 465, 75, "TOP", c, "TOP", 0, -260)

    local function CreateSlot(id, parentPanel, x, y, label)
        local btn = CreateFrame("Button", nil, f, "ItemButtonTemplate"); btn:SetSize(30, 30); btn:SetPoint("TOPLEFT", parentPanel, "TOPLEFT", x, y)
        btn.ScoreFrame = CreateFrame("Frame", nil, btn, "BackdropTemplate"); btn.ScoreFrame:SetPoint("LEFT", btn, "RIGHT", 2, 0); btn.ScoreFrame:SetSize(40, 20)
        btn.ScoreFrame:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8"}); btn.ScoreFrame:SetBackdropColor(0,0,0,0.5)
        btn.ScoreText = btn.ScoreFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); btn.ScoreText:SetPoint("CENTER"); btn.ScoreText:SetTextColor(1, 0.9, 0)
        btn.Alert = btn:CreateTexture(nil, "OVERLAY"); btn.Alert:SetSize(16, 16); btn.Alert:SetPoint("LEFT", btn.ScoreFrame, "RIGHT", 2, 0); btn.Alert:Hide()
        btn:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); if self.link then GameTooltip:SetHyperlink(self.link) else GameTooltip:SetText(label, 1, 1, 1) end if self.AlertMode then GameTooltip:AddLine(" "); GameTooltip:AddLine(self.AlertText or "Alert", 1, 0, 0) end GameTooltip:Show() end); btn:SetScript("OnLeave", GameTooltip_Hide)
        
        -- Click to Analyze
        btn:RegisterForClicks("AnyUp")
        btn:SetScript("OnClick", function(self) if self.link then MSC.ShowScoreBreakdown(self.link, self.SlotID) end end)
        
        btn.SlotID = id; table.insert(MSC.ReceiptSlots, btn)
    end

    CreateSlot(1, pArmor, 10, -10, "Head"); CreateSlot(3, pArmor, 10, -55, "Shoulder"); CreateSlot(15, pArmor, 10, -100, "Back"); CreateSlot(5, pArmor, 10, -145, "Chest"); CreateSlot(9, pArmor, 10, -190, "Wrist")
    CreateSlot(10, pArmor, 115, -10, "Hands"); CreateSlot(6, pArmor, 115, -55, "Waist"); CreateSlot(7, pArmor, 115, -100, "Legs"); CreateSlot(8, pArmor, 115, -145, "Feet")
    CreateSlot(2, pJewel, 10, -10, "Neck"); CreateSlot(11, pJewel, 10, -55, "Ring 1"); CreateSlot(12, pJewel, 10, -100, "Ring 2"); CreateSlot(13, pJewel, 10, -145, "Trinket 1"); CreateSlot(14, pJewel, 10, -190, "Trinket 2")
    CreateSlot(16, pWeap, 30, -20, "Main Hand"); CreateSlot(17, pWeap, 160, -20, "Off Hand"); CreateSlot(18, pWeap, 290, -20, "Ranged")
    
    f.SummaryBox = CreateFrame("Frame", nil, f, "BackdropTemplate"); f.SummaryBox:SetPoint("TOP", pWeap, "BOTTOM", 0, -20); f.SummaryBox:SetSize(450, 100)
    f.SummaryBox.Title = f.SummaryBox:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.SummaryBox.Title:SetPoint("TOP", 0, 0); f.SummaryBox.Title:SetText("COMBINED GEAR STAT TOTALS"); f.SummaryBox.Title:SetTextColor(1, 0.82, 0)
    MSC.SummaryRows = {}
    for i=1, 12 do
        local row = CreateFrame("Frame", nil, f.SummaryBox); row:SetSize(200, 16)
        row.Label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); row.Label:SetPoint("LEFT", 0, 0)
        row.Value = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row.Value:SetPoint("RIGHT", 0, 0)
        table.insert(MSC.SummaryRows, row)
    end
    
    -- [[ FORCE UPDATE ON SHOW ]]
    f:SetScript("OnShow", function() MSC.UpdateReceipt() end)
    MSC.ViewReceipt = f
end

function MSC.UpdateReceipt()
    if not MSC.ViewReceipt or not MSC.ViewReceipt:IsShown() then return end
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
    MSC.ViewReceipt.Score:SetText("Score: " .. string.format("|cff00ff00%.1f|r", totalScore))
    
    MSC.BagCache = {}
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local link = C_Container.GetContainerItemLink(bag, slot)
            if link and MSC.IsItemUsable(link) then
                 local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                 local slotId = MSC.SlotMap and MSC.SlotMap[equipLoc]
                 if slotId then
                        local stats = MSC.SafeGetItemStats(link, slotId, weights, specName)
                        local score = MSC.GetItemScore(stats, weights, specName, slotId)
                        table.insert(MSC.BagCache, { link = link, slotId = slotId, score = score, equipLoc = equipLoc })
                 end
            end
        end
    end

    for _, btn in ipairs(MSC.ReceiptSlots) do
        local link = GetInventoryItemLink(unit, btn.SlotID)
        btn.link = link; btn.Alert:Hide(); btn.AlertMode = nil
        if link then
            SetItemButtonTexture(btn, GetInventoryItemTexture(unit, btn.SlotID))
            local stats = MSC.SafeGetItemStats(link, btn.SlotID, weights, specName)
            local score = MSC.GetItemScore(stats, weights, specName, btn.SlotID)
            if score > 0 then btn.ScoreText:SetText(math.floor(score)) else btn.ScoreText:SetText("") end
            
            local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
            if equipLoc ~= "INVTYPE_HOLDABLE" and equipLoc ~= "INVTYPE_TABARD" and equipLoc ~= "INVTYPE_BODY" then
                 local enchantID = link:match("item:%d+:(%d+)")
                 local validSlots = {[1]=true,[3]=true,[5]=true,[7]=true,[8]=true,[9]=true,[10]=true,[15]=true,[16]=true,[17]=true}
                 if validSlots[btn.SlotID] and (not enchantID or enchantID == "0") then 
                    btn.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertOther"); btn.Alert:Show()
                    btn.AlertMode = "Enchant"; btn.AlertText = "Missing Enchant!" 
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
                btn.AlertMode = "Upgrade"; btn.AlertText = "Better item in bags!" 
            end
        else
            SetItemButtonTexture(btn, "Interface\\PaperDoll\\UI-Backpack-EmptySlot"); btn.ScoreText:SetText("")
        end
    end
    
    local sortedStats = {}
    for k, v in pairs(combinedStats) do
        if k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and v > 0 then
            local weight = weights[k] or 0; if weight > 0 then table.insert(sortedStats, { key=k, val=v, weight=weight }) end
        end
    end
    table.sort(sortedStats, function(a,b) return a.weight > b.weight end)
    for i, row in ipairs(MSC.SummaryRows) do
        if sortedStats[i] then
            row:Show(); local clean = MSC.GetCleanStatName(sortedStats[i].key)
            row.Label:SetText("|cff00ff00" .. clean .. ":|r"); row.Value:SetText(string.format("%.1f", sortedStats[i].val))
            local isLeft = (i % 2 ~= 0); local rIdx = math.ceil(i/2)
            if isLeft then row:SetPoint("TOPLEFT", MSC.ViewReceipt.SummaryBox, "TOPLEFT", 10, -20 - (rIdx*16))
            else row:SetPoint("TOPLEFT", MSC.ViewReceipt.SummaryBox, "TOPLEFT", 230, -20 - (rIdx*16)) end
        else row:Hide() end
    end
end

-- [[ VIEW 3: STAT LOGIC ]]
local function GetStatReason(stat, class, profileName)
    if not profileName then profileName = "" end
    if stat:find("STRENGTH") then return "Increases Attack Power and Block Value" end
    if stat:find("AGILITY") then return "Increases Crit Chance, Dodge, and Armor" end
    if stat:find("STAMINA") then return "Increases total Health Pool" end
    if stat:find("INTELLECT") then return "Increases Mana Pool and Spell Crit" end
    if stat:find("SPIRIT") then return "Increases Out-of-Combat and Spell5 Regen" end
    if stat:find("ATTACK_POWER") then return "Increases Raw Physical Damage Output" end
    if stat:find("EXPERTISE") then return "Reduces chance Target Parries or Dodges" end
    if stat:find("ARMOR_PENETRATION") then return "Ignores a portion of Target's Armor" end
    if stat:find("MELEE_HIT") or stat:find("RANGED_HIT") or (stat:find("HIT") and not stat:find("SPELL")) then return "Reduces chance to Miss Physical attacks" end
    if stat:find("SPELL_POWER") then return "Increases Scaling Damage of Spells" end
    if stat:find("HEALING") then return "Increases Potency of Healing spells" end
    if stat:find("SPELL_HIT") then return "Reduces chance for Spells to Resist/Miss" end
    if stat:find("MANA_REG") or stat:find("MP5") then return "Constant Mana Sustain (Mp5)" end
    if stat:find("CRIT") and not stat:find("FROM_STATS") then return "Chance for Extra Critical Damage/Healing" end
    if stat:find("HASTE") then return "Increases Attack/Casting Speed" end
    if stat:find("DEFENSE") then return "Reduces chance to be Crit and Hit" end
    if stat:find("DODGE") then return "Chance to completely Avoid Physical attacks" end
    if stat:find("PARRY") then return "Chance to Deflect front-facing attacks" end
    if stat:find("BLOCK_VALUE") then return "Increases Damage mitigated by Shield" end
    if stat:find("BLOCK_RATING") then return "Chance to Mitigate damage with Shield" end
    if stat:find("RESILIENCE") then return "Reduces Crit Damage and Chance (PvP)" end
    if stat:find("ARMOR") and not stat:find("PENETRATION") then return "Reduces Incoming Physical Damage" end
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
    
    -- 1. Dark Background (Stationary)
    f.bg = f:CreateTexture(nil, "BACKGROUND", nil, -1)
	  f.bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
	f.bg:SetVertexColor(0.1, 0.1, 0.1, 0.6) -- Dark semi-transparent circle

    -- 2. SPIN FRAME
    f.SpinFrame = CreateFrame("Frame", nil, f)
    f.SpinFrame:SetAllPoints(f)
    
    -- The Glowing Art Layer
    f.Energy = f.SpinFrame:CreateTexture(nil, "ARTWORK")
    f.Energy:SetAllPoints()
    f.Energy:SetBlendMode("ADD")
    f.Energy:SetAlpha(1.0)
    
    -- [[ FIX 1: ZOOM IN ]]
    -- Cut off the outer 10% of the image edges so the "box" lines are gone.
    f.Energy:SetTexCoord(0.1, 0.9, 0.1, 0.9) 

    -- [[ FIX 2: THE MASK ]]
    -- Force the remaining image into a perfect circle.
    local mask = f.SpinFrame:CreateMaskTexture()
    mask:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    mask:SetSize(size * 0.9, size * 0.9) -- Mask is slightly smaller than the frame to hide edges
    mask:SetPoint("CENTER")
    f.Energy:AddMaskTexture(mask)

    -- 3. ANIMATION 
    f.AnimGroup = f.SpinFrame:CreateAnimationGroup()
    f.AnimGroup:SetLooping("REPEAT")
    f.Spin = f.AnimGroup:CreateAnimation("Rotation")
    f.Spin:SetOrder(1)
    
    -- 4. TEXT FRAME
    f.TextFrame = CreateFrame("Frame", nil, f)
    f.TextFrame:SetAllPoints()
    f.TextFrame:SetFrameLevel(f.SpinFrame:GetFrameLevel() + 10) 

    f.val = f.TextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); f.val:SetPoint("CENTER", 0, 0); f.val:SetTextColor(1, 1, 1)
    f.lbl = f.TextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); f.lbl:SetPoint("TOP", f, "BOTTOM", 0, -5); f.lbl:SetText(label:upper()); f.lbl:SetTextColor(0.6, 0.6, 0.6)
    
    -- 5. Cooldown Swipe
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
    
    -- Default brightness
    f.Energy:SetVertexColor(0.8, 0.8, 0.8, 1) 

    if statType == "Def Cap" or statType == "Defense" then
         f.Energy:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Rune.tga") 
         f.Spin:SetDegrees(360); f.Spin:SetDuration(60); f.AnimGroup:Play()

    elseif statType:find("Hit") then
         -- BOTH SPELL AND MELEE HIT USE SWIRLS
         f.Energy:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Swirl.tga")
         f.Spin:SetDegrees(-360); f.Spin:SetDuration(30); f.AnimGroup:Play()
         
         -- IF SPELL HIT: Tint it slightly Teal/Blue to differentiate from Melee Green
         if statType:find("Spell") then 
            f.Energy:SetVertexColor(0.2, 1.0, 0.8, 1) 
         else
            f.Energy:SetVertexColor(0.2, 1.0, 0.2, 1)
         end

    elseif statType == "Expertise" then
         f.Energy:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Sun.tga")
         f.Energy:SetVertexColor(1.0, 0.5, 0.0, 1)

    elseif statType:find("Crit") then
         -- USE SPIKES FOR CRIT
         f.Energy:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_Sun.tga")
         f.Pulse:SetScaleFrom(1, 1); f.Pulse:SetScaleTo(1.1, 1.1)
         f.Pulse:SetDuration(0.5); f.Pulse:SetSmoothing("IN_OUT")
         f.AnimGroup:Play()
         
         -- IF SPELL CRIT: Make it Purple/Pink
         if statType:find("Spell") then
             f.Energy:SetVertexColor(0.8, 0.2, 1.0, 1) 
         else
             -- MELEE CRIT: Make it Red
             f.Energy:SetVertexColor(1.0, 0.0, 0.0, 1) 
         end
    else
         f.Energy:SetTexture("Interface\\Common\\RingBorder")
    end
end

local function GetClassRings(class, stats, weights)
    local rings = {}
    local CAP_HIT_MELEE = 9; local CAP_HIT_SPELL = 16; local CAP_EXP = 26; local CAP_DEF = 490
    
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
                local skillAdded = math.floor(val / scalar); currentDisplay = 350 + skillAdded; capRating = (capTarget - 350) * scalar
            else
                currentDisplay = math.floor(val / scalar); capRating = capTarget * scalar
            end
        else
            currentDisplay = val / scalar; capRating = capTarget * scalar
        end
        table.insert(rings, { l=label, v=currentDisplay, m=capTarget, fmt=formatStr, rawVal = val, rawCap = capRating, scalar = scalar })
    end

    if class == "WARRIOR" or class == "ROGUE" or class == "HUNTER" then
        if class == "WARRIOR" and (weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0) > 0.5 then
            AddRing("Def Cap", "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", CAP_DEF, "%d", true)
            AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%")
            AddRing("Expertise", "ITEM_MOD_EXPERTISE_RATING_SHORT", CAP_EXP, "%d", true)
        else
            AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%")
            AddRing("Crit", "ITEM_MOD_CRIT_RATING_SHORT", 35, "%.1f%%") 
            AddRing("Expertise", "ITEM_MOD_EXPERTISE_RATING_SHORT", CAP_EXP, "%d", true)
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
            if isCaster and class == "PALADIN" then AddRing("Spell Hit", "ITEM_MOD_HIT_SPELL_RATING_SHORT", CAP_HIT_SPELL, "%.1f%%") else AddRing("Hit Cap", "ITEM_MOD_HIT_RATING_SHORT", CAP_HIT_MELEE, "%.1f%%") end
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
    
    -- [[ FORCE UPDATE ON SHOW ]]
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
    
    -- [[ 1. FETCH PLAYER GEAR DIRECTLY (Ignoring Lab Simulation) ]]
    local currentGear = {}
    for i=1, 18 do currentGear[i] = GetInventoryItemLink("player", i) end
    
    -- Note: Removed Lab Projection logic block here.
    
    local _, stats = MSC:GetTotalCharacterScore(currentGear, weights, detectedKey)
    local rings = GetClassRings(select(2, UnitClass("player")), stats, weights)
    
    for i, ring in ipairs(rings) do
        if i <= 3 then
            local xPos = 60 + ((i-1) * 140)
            local f = MSC.GetFromPool("Rings", content, function(p) return CreateStatRing(p, 0, 0, 80, "TEMP") end)
            f:ClearAllPoints(); f:SetPoint("TOPLEFT", xPos, -20)
            f.lbl:SetText(ring.l:upper())
            f.val:SetText(string.format(ring.fmt, ring.v))
            
            -- [[ APPLY THE NEW ART ]]
            MSC.ApplyRingArt(f, ring.l) 
            -- [[ END NEW ART ]]

            local fillPct = 0
            if ring.m > 0 then fillPct = math.min(100, (ring.v / ring.m) * 100) end
            
            -- We just tint the cooldown swipe green if capped, but let the ring glow its own color
            local r,g,b = 0, 0, 0
            if ring.l:find("Cap") or ring.l:find("Hit") or ring.l:find("Expertise") or ring.l:find("Def") then
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
                    GameTooltip:AddDoubleLine("Rating:", string.format("%d / %d", ring.rawVal, ring.rawCap), 1, 0.82, 0, 1, 1, 1)
                    local diff = ring.rawCap - ring.rawVal
                    if diff > 0 then GameTooltip:AddLine(string.format("Need %d more rating to cap.", diff), 1, 0.5, 0.5) else GameTooltip:AddLine("Cap reached!", 0, 1, 0) end
                else
                    GameTooltip:AddDoubleLine("Current Rating:", string.format("%d", ring.rawVal), 1, 0.82, 0, 1, 1, 1)
                end
                if ring.scalar then GameTooltip:AddLine(" "); GameTooltip:AddLine(string.format("1%% requires %.2f Rating", ring.scalar), 0.6, 0.6, 0.6) end
                GameTooltip:Show(); self:SetAlpha(1)
            end)
            f:SetScript("OnLeave", function(self) GameTooltip:Hide(); self:SetAlpha(1) end)
            table.insert(content.children, f)
        end
    end

    local yOff = -135
    local sorted = {}
    local maxW = 0
    for k, v in pairs(weights) do if v > 0 then table.insert(sorted, {k=k, v=v}); if v > maxW then maxW = v end end end
    table.sort(sorted, function(a,b) return a.v > b.v end)

    for _, s in ipairs(sorted) do
        local bar = MSC.GetFromPool("Bars", content, function(p)
             local b = CreateFrame("StatusBar", nil, p, "BackdropTemplate")
             b:SetSize(450, 32)
             b:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8"})
             b:SetBackdropColor(0, 0, 0, 0.5) -- Darker background
             
             -- [[ NEW TEXTURE ]] Use a smooth raid bar texture for the "Glass" look
             b:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
             
             b:EnableMouse(true)
             -- (Keep your existing tooltip OnEnter/OnLeave scripts here...)
             b:SetScript("OnEnter", function(self)
                 -- ... (Copy your existing tooltip code here if you want to keep it) ...
                 GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                 GameTooltip:SetText(self.StatName, 1, 1, 1)
                 GameTooltip:Show()
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
        local realTotal = 0 -- (Add back your RealTotal logic here if needed)

        bar.StatName = name; bar.Weight = s.v; bar.Reason = reason; bar.CurrentVal = currentVal

        bar:ClearAllPoints(); bar:SetPoint("TOPLEFT", 15, yOff)
        bar:SetMinMaxValues(0, maxW); bar:SetValue(s.v); bar:SetAlpha(0.9)
        
		-- [[ NEW COLOR LOGIC: PRIORITY SYSTEM ]]
        local statKey = s.k:upper()
        local r, g, b = 0.5, 0.5, 0.5 -- Default Grey
        
        -- Check for specific "SPELL" overrides first!
        if statKey:find("SPELL_HIT") then r,g,b = unpack(MSC.StatColors.SPELL_HIT)
        elseif statKey:find("SPELL_CRIT") then r,g,b = unpack(MSC.StatColors.SPELL_CRIT)
        elseif statKey:find("SPELL_POWER") then r,g,b = unpack(MSC.StatColors.SPELL_POWER)
        else
            -- If no specific Spell match, look for generic matches
            for key, color in pairs(MSC.StatColors) do
                if statKey:find(key) and not key:find("SPELL") then 
                    r,g,b = unpack(color); break 
                end
            end
        end
        
        -- Create a gradient from Dark -> Bright
        bar:GetStatusBarTexture():SetGradient("HORIZONTAL", CreateColor(r*0.4, g*0.4, b*0.4, 1), CreateColor(r, g, b, 1))

        bar.leftT:SetText(name:gsub("Rating", "")); bar.rightT:SetText(string.format("%.2f", s.v))
        if reason then bar.sub:SetText(reason); bar.sub:SetTextColor(r+0.2, g+0.2, b+0.2, 0.8) else bar.sub:Hide() end
        
        yOff = yOff - 38
        table.insert(content.children, bar)
    end
    content:SetHeight(math.abs(yOff) + 50)
end

-- [[ VIEW 4: SETTINGS ]]
function MSC.InitSettingsView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    local function CreateHeader(text, relTo, yOff)
        local h = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); h:SetText(text); h:SetTextColor(1, 0.82, 0)
        if relTo then h:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", 0, yOff) else h:SetPoint("TOPLEFT", 40, -30) end
        return h
    end
    local function CreateDropdown(label, key, options, relTo, yOff)
        local frame = CreateFrame("Frame", nil, f); frame:SetSize(200, 50); frame:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", 0, yOff)
        local lbl = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); lbl:SetPoint("TOPLEFT", 0, 0); lbl:SetText(label); lbl:SetTextColor(0.6, 0.6, 0.6)
        local dd = CreateFrame("Frame", nil, frame, "UIDropDownMenuTemplate"); dd:SetPoint("TOPLEFT", -15, -15); UIDropDownMenu_SetWidth(dd, 180)
        local function OnClick(self) 
            UIDropDownMenu_SetSelectedID(dd, self:GetID()); SGJ_Settings[key] = self.value
            if key == "Mode" then 
                MSC.ManualSpec = self.value; MSC.CachedWeights = nil
                if MSC.UpdateReceipt then MSC.UpdateReceipt() end; if MSC.UpdateLabCalc then MSC.UpdateLabCalc() end; if MSC.UpdateLogic then MSC.UpdateLogic() end 
            end 
        end
        local function Init(self, level) 
            for _, opt in ipairs(options) do 
                local info = UIDropDownMenu_CreateInfo(); info.text = opt.text; info.value = opt.val; info.func = OnClick; info.checked = (SGJ_Settings[key] == opt.val); UIDropDownMenu_AddButton(info, level) 
            end 
        end
        UIDropDownMenu_Initialize(dd, Init)
        local currentText = "Select..."; for _, opt in ipairs(options) do if SGJ_Settings[key] == opt.val then currentText = opt.text end end
        UIDropDownMenu_SetText(dd, currentText); if key == "Mode" then f.ProfileDD = dd end
        return frame
    end
    local function CreateCheck(label, key, tooltip, relTo, xOff, yOff)
        local cb = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate"); cb:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", xOff, yOff); cb.Text:SetText(label); cb.Text:SetTextColor(0.9, 0.9, 0.9); cb:SetChecked(SGJ_Settings[key])
        cb:SetScript("OnClick", function(self) SGJ_Settings[key] = self:GetChecked(); if key == "HideMinimap" then MSC.UpdateMinimapPosition() end end)
        if tooltip then cb:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(tooltip, nil, nil, nil, nil, true); GameTooltip:Show() end); cb:SetScript("OnLeave", GameTooltip_Hide) end
        return cb
    end
    
    local h1 = CreateHeader("Comparison Logic", nil, 0)
    local ddEnchant = CreateDropdown("Enchant Mode", "EnchantMode", {{ text = "Off (Raw Stats)", val = 1 }, { text = "Current Only", val = 2 }, { text = "Project Best", val = 3 }}, h1, -10)
    local ddGem = CreateDropdown("Gemming Logic", "GemMode", {{ text = "The Skeptic", val = 1 }, { text = "The Casual", val = 2 }, { text = "The Pro", val = 3 }}, ddEnchant, -5)

    local h2 = CreateHeader("Character Profile", ddGem, -20)
    local specOptions = { { text = "Auto-Detect", val = "AUTO" } }; local seen = { ["AUTO"] = true }
    if MSC.CurrentClass then
        local function AddList(listSource)
            if not listSource then return end
            local sorted = {}; for k in pairs(listSource) do table.insert(sorted, k) end; table.sort(sorted)
            for _, k in ipairs(sorted) do if not seen[k] then local name = (MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[k]) or k; table.insert(specOptions, { text = name, val = k }); seen[k] = true end end
        end
        AddList(MSC.CurrentClass.Weights); AddList(MSC.CurrentClass.LevelingWeights); AddList(MSC.CurrentClass.Profiles)
    end
    local ddProfile = CreateDropdown("Active Scoring Profile", "Mode", specOptions, h2, -10)
    
    local h3 = CreateHeader("Interface Options", ddProfile, -20)
    local cb1 = CreateCheck("Hide Minimap Button", "HideMinimap", "Hides the circular button on your minimap.", h3, 0, -10)
    local cb2 = CreateCheck("Hide Tooltip Verdict", "HideTooltips", "Stops the addon from adding scores to item tooltips.", cb1, 0, -5)
    local cb3 = CreateCheck("Mute Error Sounds", "MuteSounds", "Stops the error sound when clicking invalid items.", cb2, 0, -5)
    local cb4 = CreateCheck("Disable Conflict Check", "DisableConflictCheck", "Stops the chat warning about Pawn/Zygor.", cb3, 0, -5)

    local bImp = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); bImp:SetSize(140, 30); bImp:SetPoint("BOTTOMRIGHT", -40, 40); bImp:SetText("Import Pawn String")
    bImp:SetScript("OnClick", function() MSC.ShowImportWindow() end)
    local bExport = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); bExport:SetSize(140, 30); bExport:SetPoint("BOTTOMRIGHT", -190, 40); bExport:SetText("Export Data")
    bExport:SetScript("OnClick", function() MSC.ShowHistory() end)
    
    MSC.ViewSettings = f
end

function MSC.RegisterPluginTab(name, icon, initFunc, viewKey, updateFuncKey)
    local newID = #MSC.RegisteredTabs + 1
    table.insert(MSC.RegisteredTabs, {
        id = newID, name = name, icon = icon,
        directFunc = initFunc, view = viewKey, update = updateFuncKey
    })
    if MSC.MainFrame and MSC.MainFrame:IsShown() then MSC.RenderSidebarButtons() end
    return newID
end

-- =============================================================
-- 3. MAIN DASHBOARD FRAME
-- =============================================================
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
        btn.ID = idx; table.insert(MSC.NavButtons, btn)
    end
    if MSC.ActiveTab then MSC.SwitchTab(MSC.ActiveTab) end
end

function MSC.ToggleMainMenu()
    if MSC.MainFrame then if MSC.MainFrame:IsShown() then MSC.MainFrame:Hide() else MSC.MainFrame:Show() end return end
    local f = CreateFrame("Frame", "SGJ_MainFrame", UIParent, "BackdropTemplate")
    f:SetSize(650, 600); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    
    f:SetScript("OnHide", function() 
        if MSC.BreakdownFrame then MSC.BreakdownFrame:Hide() end 
    end)
    
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing); f:SetFrameStrata("HIGH")
    MSC.CreateModernBorder(f, 1)
    
    f.Header = CreateFrame("Frame", nil, f); f.Header:SetPoint("TOPLEFT", 70, 0); f.Header:SetPoint("TOPRIGHT", 0, 0); f.Header:SetHeight(60); f.Header:EnableMouse(true)
    f.Header:SetScript("OnMouseWheel", function(self, delta) local cur = f:GetScale(); if delta > 0 then cur = cur + 0.05 else cur = cur - 0.05 end; if cur < 0.6 then cur = 0.6 end; if cur > 1.4 then cur = 1.4 end; f:SetScale(cur) end)
    f.Bg = f:CreateTexture(nil, "BACKGROUND", nil, -8); f.Bg:SetAllPoints(); local _, class = UnitClass("player"); local fixedClass = class:sub(1,1)..class:sub(2):lower()
    pcall(function() f.Bg:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. fixedClass .. ".tga") end)
    f.Bg:SetTexCoord(0, 1, 0.1, 0.9); f.Bg:SetColorTexture(0.1, 0.1, 0.1, 1) 
    f.Overlay = f:CreateTexture(nil, "BACKGROUND", nil, -7); f.Overlay:SetAllPoints(); f.Overlay:SetColorTexture(0.08, 0.08, 0.10, 0.90) 
    f.Header.Grad = f.Header:CreateTexture(nil, "BACKGROUND"); f.Header.Grad:SetAllPoints(); f.Header.Grad:SetColorTexture(0, 0, 0, 0.5); f.Header.Grad:SetGradient("VERTICAL", CreateColor(0,0,0,0), CreateColor(0,0,0,0.8))
    f.Title = f.Header:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); f.Title:SetPoint("LEFT", 20, -5); f.Title:SetText("Sharpie's Gear Judge"); f.Title:SetTextColor(1, 1, 1); f.Title:SetShadowOffset(1, -1)
    f.SubTitle = f.Header:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.SubTitle:SetPoint("BOTTOMLEFT", f.Title, "BOTTOMRIGHT", 10, 2); f.SubTitle:SetText("v2.2.3 Laboratory"); f.SubTitle:SetTextColor(MSC.GetClassColor())
    f.Close = CreateFrame("Button", nil, f.Header, "UIPanelCloseButton"); f.Close:SetPoint("TOPRIGHT", -5, -5); f.Close:SetScript("OnClick", function() f:Hide() end)
    
    f.ScaleHint = f.Header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    f.ScaleHint:SetPoint("RIGHT", f.Close, "LEFT", -5, 0)
    f.ScaleHint:SetText("Scroll to Scale")
    f.ScaleHint:SetTextColor(0.5, 0.5, 0.5)

    f.Sidebar = CreateFrame("Frame", nil, f); f.Sidebar:SetPoint("TOPLEFT", 0, 0); f.Sidebar:SetPoint("BOTTOMLEFT", 0, 0); f.Sidebar:SetWidth(70)
    f.Sidebar.Bg = f.Sidebar:CreateTexture(nil, "BACKGROUND"); f.Sidebar.Bg:SetAllPoints(); f.Sidebar.Bg:SetColorTexture(unpack(MSC.Colors.BgSidebar))
    f.Sidebar.Line = f.Sidebar:CreateTexture(nil, "OVERLAY"); f.Sidebar.Line:SetColorTexture(0, 0, 0, 1); f.Sidebar.Line:SetWidth(1); f.Sidebar.Line:SetPoint("TOPRIGHT", 0, 0); f.Sidebar.Line:SetPoint("BOTTOMRIGHT", 0, 0)
    
    f.MoveHint = f.Sidebar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    f.MoveHint:SetPoint("BOTTOM", 0, 15)
    f.MoveHint:SetText("Hold\nto Move")
    f.MoveHint:SetTextColor(0.3, 0.3, 0.3)
    
    f.Content = CreateFrame("Frame", nil, f); f.Content:SetPoint("TOPLEFT", f.Sidebar, "TOPRIGHT", 0, -60); f.Content:SetPoint("BOTTOMRIGHT", 0, 0)
    MSC.MainFrame = f
    
    -- [[ INIT ALL VIEWS HERE ]]
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

-- =============================================================
-- 4. EVENTS & HOOKS
-- =============================================================
local mb = CreateFrame("Button", "MSC_Minimap", Minimap); mb:SetSize(32,32); mb:SetFrameLevel(8); mb:SetPoint("CENTER", -60, -60)
mb.icon = mb:CreateTexture(nil,"BACKGROUND"); mb.icon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_02"); mb.icon:SetSize(20,20); mb.icon:SetPoint("CENTER")
mb.border = mb:CreateTexture(nil,"OVERLAY"); mb.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder"); mb.border:SetSize(54,54); mb.border:SetPoint("TOPLEFT")
mb:RegisterForClicks("AnyUp"); mb:SetScript("OnClick", MSC.ToggleMainMenu)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("PLAYER_TALENT_UPDATE")

f:SetScript("OnEvent", function(self, event) 
    if event == "PLAYER_LOGIN" then 
        MSC.UpdateMinimapPosition() 
    else
        -- Force update on EnterWorld, Equip change, or Talent change
        if MSC.UpdateReceipt then MSC.UpdateReceipt() end
        if MSC.UpdateLogic then MSC.UpdateLogic() end
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

-- =============================================================
-- 5. POPUP WINDOWS
-- =============================================================
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
    
    local f = MSC.CreatePopupFrame("Import Pawn String")
    f.EditBox:SetText("Paste Pawn string here...")
    f.EditBox:HighlightText()
    
    local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    b:SetSize(120, 25); b:SetPoint("BOTTOM", 0, 15); b:SetText("Import")
    b:SetScript("OnClick", function()
        local text = f.EditBox:GetText()
        print("|cff00ff00SGJ:|r Import received: " .. string.sub(text, 1, 20) .. "...")
        f:Hide()
    end)
    
    MSC.ImportFrame = f
end

function MSC.ShowHistory()
    if MSC.ExportFrame then MSC.ExportFrame:Show(); MSC.ExportFrame.EditBox:HighlightText(); return end
    
    local f = MSC.CreatePopupFrame("Export Data (Discord Ready)")
    local unit = "player"
    local name = UnitName(unit)
    local realm = GetRealmName()
    local lvl = UnitLevel(unit)
    local _, class = UnitClass(unit)
    
    local weights, specName = MSC.GetCurrentWeights()
    if not weights and MSC.CurrentClass and MSC.CurrentClass.Weights then 
        specName, weights = next(MSC.CurrentClass.Weights) 
    end
    local profileName = (MSC.PrettyNames and MSC.PrettyNames[specName]) or specName or "Unknown"

    local gearTable = {}
    for i=1, 18 do gearTable[i] = GetInventoryItemLink(unit, i) end
    local totalScore = MSC:GetTotalCharacterScore(gearTable, weights, specName)

    local exportStr = string.format("```ini\n[ %s - %s (Lvl %d %s) ]\n", name, realm, lvl, class)
    exportStr = exportStr .. string.format("Profile    = %s\n", profileName)
    exportStr = exportStr .. string.format("TotalScore = %.1f\n\n", totalScore)
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
            local itemName = GetItemInfo(link) or "Unknown Item"
            local stats = MSC.SafeGetItemStats(link, slotID, weights, specName)
            local score = MSC.GetItemScore(stats, weights, specName, slotID)
            exportStr = exportStr .. string.format("%-10s = %s (%.1f)\n", label, itemName, score)
        else
            exportStr = exportStr .. string.format("%-10s = (Empty)\n", label)
        end
    end
    exportStr = exportStr .. "```"

    f.EditBox:SetText(exportStr)
    f.EditBox:HighlightText()
    f.EditBox:SetScript("OnEscapePressed", function() f:Hide() end)
    
    MSC.ExportFrame = f
end