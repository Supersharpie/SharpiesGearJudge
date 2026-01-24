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
-- 2. VIEW DEFINITIONS (Must be defined BEFORE Dashboard)
-- =============================================================

-- [[ VIEW 1: THE LABORATORY (6-BLOCK THUNDERDOME) ]]
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

    -- SET 1 (LEFT COLUMN)
    CreateBlock(1, "Option A1: Two-Hander", 1, 10, -50)
    CreateBlock(2, "Option B1: 1H + Shield/OH", 2, 10, -150)
    CreateBlock(3, "Option C1: Dual Wield", 2, 10, -250)

    -- SET 2 (RIGHT COLUMN)
    CreateBlock(4, "Option A2: Two-Hander", 1, 300, -50)
    CreateBlock(5, "Option B2: 1H + Shield/OH", 2, 300, -150)
    CreateBlock(6, "Option C2: Dual Wield", 2, 300, -250)

    f.ResultText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); f.ResultText:SetPoint("BOTTOM", 0, 60); f.ResultText:SetText("Waiting for Items...")
    
    MSC.ViewLab = f
end

function MSC.UpdateLabCalc()
    if not MSC.ViewLab or not MSC.ViewLab:IsShown() then return end
    
    local weights, profileName = MSC.GetCurrentWeights()
    if not weights then return end 
    
    local bestScore = -1
    local winnerIndex = 0
    local hasItems = false

    -- Calculate Scores
    for id, block in pairs(MSC.LabBlocks) do
        local blockScore = 0
        local itemsFound = false
        
        for i, btn in ipairs(block.Slots) do
            if btn.link then
                itemsFound = true
                -- Slot 1 is always Main Hand (16), Slot 2 is always Off Hand (17)
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
    
    -- Visual Feedback
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
        local names = {
            "Option A1 (2H)", "Option B1 (1H+OH)", "Option C1 (DW)",
            "Option A2 (2H)", "Option B2 (1H+OH)", "Option C2 (DW)"
        }
        MSC.ViewLab.ResultText:SetText(names[winnerIndex] .. " Wins!")
        MSC.ViewLab.ResultText:SetTextColor(0, 1, 0)
        
        if MSC.UpdateLogic then MSC.UpdateLogic() end
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
                 local enchantID = link:match("item:%d+:(%d+)"); local validSlots = {[1]=true,[3]=true,[5]=true,[7]=true,[8]=true,[9]=true,[10]=true,[15]=true,[16]=true,[17]=true}
                 if validSlots[btn.SlotID] and (not enchantID or enchantID == "0") then btn.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertOther"); btn.Alert:Show(); btn.AlertMode = "Enchant"; btn.AlertText = "Missing Enchant!" end
            end
            local bestBagScore = score; local foundUpgrade = false
            for _, cachedItem in ipairs(MSC.BagCache) do
               local isMatch = (cachedItem.slotId == btn.SlotID)
               if btn.SlotID == 11 or btn.SlotID == 12 then if cachedItem.slotId == 11 then isMatch = true end end
               if btn.SlotID == 13 or btn.SlotID == 14 then if cachedItem.slotId == 13 then isMatch = true end end
               if isMatch and cachedItem.score > bestBagScore + 0.1 then foundUpgrade = true end
            end
            if foundUpgrade then btn.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew"); btn.Alert:Show(); btn.AlertMode = "Upgrade"; btn.AlertText = "Better item in bags!" end
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

-- [[ VIEW 3: STAT LOGIC (FINAL VISUAL POLISH) ]]
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

-- [[ FIXED ANIMATION RENDERER: TEXT ON TOP + CIRCLE TEXTURE + BRIGHT TRACK + GLOW ]]
local function CreateStatRing(parent, x, y, size, label)
    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(size, size); f:SetPoint("TOPLEFT", x, y)
    local mask = f:CreateMaskTexture()
    mask:SetTexture("Interface\\Minimap\\UI-Minimap-Background"); mask:SetAllPoints(f)
    
    -- Background Track (BRIGHT GRAY)
    f.bg = f:CreateTexture(nil, "BACKGROUND")
    f.bg:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\Ring_BG.tga") 
    f.bg:SetAllPoints(); f.bg:SetVertexColor(0.6, 0.6, 0.6, 1); f.bg:SetBlendMode("BLEND"); f.bg:AddMaskTexture(mask)
    
    -- Swipe (Perfect Circle + GLOW MODE)
    f.cooldown = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
    f.cooldown:SetAllPoints()
    f.cooldown:SetSwipeTexture("Interface\\Minimap\\UI-Minimap-Background")
    f.cooldown:SetHideCountdownNumbers(true); f.cooldown:SetDrawEdge(false); f.cooldown:SetReverse(true)
    f.cooldown:SetUseCircularEdge(true) 
    if f.cooldown.AddMaskTexture then f.cooldown:AddMaskTexture(mask) end
    
    -- Hole Punch (Donut)
    f.hole = f:CreateTexture(nil, "OVERLAY", nil, 1)
    f.hole:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    f.hole:SetSize(size * 0.70, size * 0.70); f.hole:SetPoint("CENTER"); f.hole:SetVertexColor(0, 0, 0, 1)
    
    -- Text Frame (HIGHEST LAYER)
    f.TextFrame = CreateFrame("Frame", nil, f)
    f.TextFrame:SetAllPoints(); f.TextFrame:SetFrameLevel(f:GetFrameLevel() + 10)

    f.val = f.TextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); f.val:SetPoint("CENTER", 0, 0); f.val:SetTextColor(1, 1, 1)
    f.lbl = f.TextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); f.lbl:SetPoint("TOP", f, "BOTTOM", 0, -5); f.lbl:SetText(label:upper()); f.lbl:SetTextColor(0.6, 0.6, 0.6)
    
    return f
end

local function GetClassRings(class, stats, weights)
    local rings = {}; local hit = stats["ITEM_MOD_HIT_SPELL_RATING_SHORT"] or stats["ITEM_MOD_HIT_RATING_SHORT"] or 0
    local def = stats["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0; local exp = stats["ITEM_MOD_EXPERTISE_RATING_SHORT"] or 0
    local crit = stats["ITEM_MOD_CRIT_SPELL_RATING_SHORT"] or stats["ITEM_MOD_CRIT_MELEE_RATING_SHORT"] or 0
    local haste = stats["ITEM_MOD_HASTE_SPELL_RATING_SHORT"] or stats["ITEM_MOD_HASTE_MELEE_RATING_SHORT"] or 0
    local caps = { MeleeHit=142, SpellHit=202, Def=140, Exp=103, CritGoal=660, HasteGoal=315 }

    if class == "WARRIOR" or class == "PALADIN" or class == "DRUID" then
        if (weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] or 0) > 1 then
             table.insert(rings, { l="Def Cap", v=def, m=caps.Def }); table.insert(rings, { l="Hit Cap", v=hit, m=caps.MeleeHit }); table.insert(rings, { l="Expertise", v=exp, m=caps.Exp })
        else
             table.insert(rings, { l="Hit Cap", v=hit, m=caps.MeleeHit }); table.insert(rings, { l="Crit", v=crit, m=caps.CritGoal }); table.insert(rings, { l="Expertise", v=exp, m=caps.Exp })
        end
    elseif class == "MAGE" or class == "WARLOCK" or class == "PRIEST" or class == "SHAMAN" then
        table.insert(rings, { l="Spell Hit", v=hit, m=caps.SpellHit }); table.insert(rings, { l="Spell Crit", v=crit, m=caps.CritGoal }); table.insert(rings, { l="Haste", v=haste, m=caps.HasteGoal })
    else
        table.insert(rings, { l="Hit Cap", v=hit, m=caps.MeleeHit }); table.insert(rings, { l="Crit", v=crit, m=caps.CritGoal }); table.insert(rings, { l="Haste", v=haste, m=caps.HasteGoal })
    end
    return rings
end

function MSC.InitLogicView(parent)
    local f = CreateFrame("Frame", nil, parent); f:SetAllPoints(); f:Hide()
    local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 20, -20); scroll:SetPoint("BOTTOMRIGHT", -40, 20)
    local content = CreateFrame("Frame", nil, scroll); content:SetSize(400, 800); scroll:SetScrollChild(content)
    f.Content = content
    MSC.ViewLogic = f
end

function MSC.UpdateLogic()
    if not MSC.ViewLogic or not MSC.ViewLogic:IsShown() then return end
    local content = MSC.ViewLogic.Content
    if content.children then for _, c in ipairs(content.children) do c:Hide(); c:SetParent(nil) end end
    content.children = {}
    
    local weights, detectedKey = MSC.GetCurrentWeights()
    if not weights and MSC.CurrentClass and MSC.CurrentClass.Weights then detectedKey, weights = next(MSC.CurrentClass.Weights) end
    if not weights then return end

    local roleColor = MSC.RoleColors.DEFAULT
    local spec = detectedKey:upper()
    if spec:find("PROT") or spec:find("DEF") or spec:find("TANK") then roleColor = MSC.RoleColors.TANK
    elseif spec:find("HOLY") or spec:find("RESTO") or spec:find("HEAL") then roleColor = MSC.RoleColors.HEALER
    elseif spec:find("MAGE") or spec:find("WARLOCK") or spec:find("SHADOW") or spec:find("ELE") or spec:find("BAL") then roleColor = MSC.RoleColors.CASTER
    elseif spec:find("RET") or spec:find("ROGUE") or spec:find("WARRIOR") or spec:find("HUNTER") or spec:find("ENH") or spec:find("CAT") then roleColor = MSC.RoleColors.MELEE
    end

    local _, class = UnitClass("player")
    local currentGear = MSC:GetEquippedGear() or {}
    
    -- [[ LOGIC 3 UPDATE: PROJECTION ]]
    -- If Lab is active and has a winner, visualize the stats of the WINNING SET
    if MSC.LabBlocks then
        local winnerScore = -1
        local winnerIndex = 0
        for id, block in pairs(MSC.LabBlocks) do
            if block.finalScore and block.finalScore > winnerScore then
                winnerScore = block.finalScore
                winnerIndex = id
            end
        end
        
        if winnerIndex > 0 then
            -- Simulate the winning set
            local block = MSC.LabBlocks[winnerIndex]
            if winnerIndex == 1 then -- Set 1: 2H
                currentGear[16] = block.Slots[1].link; currentGear[17] = nil
            elseif winnerIndex == 2 then -- Set 1: 1H+OH
                if block.Slots[1].link then currentGear[16] = block.Slots[1].link end
                if block.Slots[2].link then currentGear[17] = block.Slots[2].link end
            elseif winnerIndex == 3 then -- Set 1: DW
                if block.Slots[1].link then currentGear[16] = block.Slots[1].link end
                if block.Slots[2].link then currentGear[17] = block.Slots[2].link end
            elseif winnerIndex == 4 then -- Set 2: 2H
                currentGear[16] = block.Slots[1].link; currentGear[17] = nil
            elseif winnerIndex == 5 then -- Set 2: 1H+OH
                if block.Slots[1].link then currentGear[16] = block.Slots[1].link end
                if block.Slots[2].link then currentGear[17] = block.Slots[2].link end
            elseif winnerIndex == 6 then -- Set 2: DW
                if block.Slots[1].link then currentGear[16] = block.Slots[1].link end
                if block.Slots[2].link then currentGear[17] = block.Slots[2].link end
            end
        end
    end
    
    local _, stats = MSC:GetTotalCharacterScore(currentGear, weights, detectedKey)
    local rings = GetClassRings(class, stats, weights)
    
    for i, ring in ipairs(rings) do
        local xPos = 60 + ((i-1) * 140)
        local f = CreateStatRing(content, xPos, -20, 80, ring.l)
        table.insert(content.children, f)
        
        local pct = 0; if ring.m > 0 then pct = math.min(100, (ring.v / ring.m) * 100) end
        
        local useRole = true
        if ring.l:find("Cap") or ring.l:find("Hit") or ring.l:find("Def") then useRole = false end
        local r, g, b = GetProgressColor(pct, useRole and roleColor or nil)
        
        -- [[ ANIMATION RENDERER: GLOW MODE RESTORED ]]
        f.cooldown:SetSwipeColor(r, g, b)
        f.val:SetText(math.floor(pct) .. "%"); f.val:SetTextColor(r, g, b)
        
        local now = GetTime()
        if pct >= 100 then f.cooldown:SetCooldown(now - 10000, 10000) 
        elseif pct <= 0 then f.cooldown:SetCooldown(0, 0)
        else 
            local dur = 100000
            f.cooldown:SetCooldown(now - (dur * (pct/100)), dur)
            f.cooldown:Pause()
        end
    end

    local yOff = -135
    local header = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    header:SetPoint("TOPLEFT", 15, yOff); header:SetText("Stat Priority"); header:SetTextColor(1, 0.82, 0)
    table.insert(content.children, header)
    yOff = yOff - 35
    
    local maxW = 0; local sorted = {}
    for k, v in pairs(weights) do if v > 0 then table.insert(sorted, {k=k, v=v}); if v > maxW then maxW = v end end end
    table.sort(sorted, function(a,b) return a.v > b.v end)
    
    for _, s in ipairs(sorted) do
        local name = s.k
        if MSC.GetCleanStatName then
            local clean = MSC.GetCleanStatName(s.k)
            if clean then name = clean end
        end
        
        -- [[ BARS HALVED IN HEIGHT & TIGHTENED ]]
        local reason = GetStatReason(tostring(s.k):upper(), class, detectedKey)
        local bar = CreateFrame("StatusBar", nil, content, "BackdropTemplate")
        bar:SetSize(450, 24); -- Height changed from 42 to 24
        bar:SetPoint("TOPLEFT", 15, yOff)
        bar:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8"}); bar:SetBackdropColor(0, 0, 0, 0.4)
        bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar"); bar:SetMinMaxValues(0, maxW); bar:SetValue(s.v)
        bar:GetStatusBarTexture():SetGradient("HORIZONTAL", CreateColor(roleColor.r*0.5, roleColor.g*0.5, roleColor.b*0.5, 0.8), CreateColor(roleColor.r, roleColor.g, roleColor.b, 0.9))
        
        -- Adjusted text anchors for tighter space
        local leftT = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); leftT:SetPoint("TOPLEFT", 10, -2); leftT:SetText(name:gsub("Rating", ""))
        local rightT = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); rightT:SetPoint("TOPRIGHT", -10, -2); rightT:SetText(string.format("%.2f", s.v))
        
        if reason then
            local sub = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            sub:SetPoint("BOTTOMLEFT", 10, 2) -- Tighter anchor
            sub:SetText(reason)
            sub:SetTextColor(0.6, 0.6, 0.6)
        end
        
        yOff = yOff - 30; -- Reduced spacing from 48 to 30
        table.insert(content.children, bar)
    end
    content:SetHeight(math.abs(yOff) + 50)
end

-- [[ VIEW 4: SETTINGS (NO RELOAD BUTTON) ]]
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
-- 3. MAIN DASHBOARD FRAME (Must be defined AFTER Views)
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
    f.SubTitle = f.Header:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.SubTitle:SetPoint("BOTTOMLEFT", f.Title, "BOTTOMRIGHT", 10, 2); f.SubTitle:SetText("v2.2.2 Laboratory"); f.SubTitle:SetTextColor(MSC.GetClassColor())
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
-- 4. EVENTS & HOOKS (Bottom of File)
-- =============================================================
local mb = CreateFrame("Button", "MSC_Minimap", Minimap); mb:SetSize(32,32); mb:SetFrameLevel(8); mb:SetPoint("CENTER", -60, -60)
mb.icon = mb:CreateTexture(nil,"BACKGROUND"); mb.icon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_02"); mb.icon:SetSize(20,20); mb.icon:SetPoint("CENTER")
mb.border = mb:CreateTexture(nil,"OVERLAY"); mb.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder"); mb.border:SetSize(54,54); mb.border:SetPoint("TOPLEFT")
mb:RegisterForClicks("AnyUp"); mb:SetScript("OnClick", MSC.ToggleMainMenu)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function() MSC.UpdateMinimapPosition() end)

-- [[ FINAL FIX: UNIVERSAL LINK CATCHER (SMART DUAL WIELD NO SYNC) ]]
function MSC.OnItemLinkClick(link)
    if not MSC.ViewLab or not MSC.ViewLab:IsShown() then return end
    
    local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
    
    -- Smart Sorting
    if equipLoc == "INVTYPE_2HWEAPON" or equipLoc == "INVTYPE_STAFF" or equipLoc == "INVTYPE_POLEARM" then
        -- Check Set 1 -> Set 2
        local btn1 = MSC.LabBlocks[1].Slots[1]
        local btn2 = MSC.LabBlocks[4].Slots[1]
        if not btn1.link then 
            btn1.link = link; SetItemButtonTexture(btn1, GetItemIcon(link))
        else
            btn2.link = link; SetItemButtonTexture(btn2, GetItemIcon(link))
        end
        
    elseif equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND" then
        -- Check Set 1 OH -> Set 2 OH
        local btn1 = MSC.LabBlocks[2].Slots[2]
        local btn2 = MSC.LabBlocks[5].Slots[2]
        if not btn1.link then
            btn1.link = link; SetItemButtonTexture(btn1, GetItemIcon(link))
        else
            btn2.link = link; SetItemButtonTexture(btn2, GetItemIcon(link))
        end
        
    elseif equipLoc == "INVTYPE_WEAPON" or equipLoc == "INVTYPE_WEAPONMAINHAND" then
        -- FIXED DUAL WIELD LOGIC: NO SYNCING, FILL FIRST EMPTY SLOT IN PRIORITY ORDER
        
        local targets = {
            MSC.LabBlocks[2].Slots[1], -- Set 1: 1H+Shield MH
            MSC.LabBlocks[3].Slots[1], -- Set 1: DW MH
            MSC.LabBlocks[3].Slots[2], -- Set 1: DW OH (Conditional)
            MSC.LabBlocks[5].Slots[1], -- Set 2: 1H+Shield MH
            MSC.LabBlocks[6].Slots[1], -- Set 2: DW MH
            MSC.LabBlocks[6].Slots[2]  -- Set 2: DW OH (Conditional)
        }
        
        for i, btn in ipairs(targets) do
            -- Skip OH slots if item is Main-Hand only
            local isOHSlot = (i == 3 or i == 6)
            local canEquip = true
            if isOHSlot and equipLoc == "INVTYPE_WEAPONMAINHAND" then canEquip = false end
            
            if canEquip and not btn.link then
                btn.link = link; SetItemButtonTexture(btn, GetItemIcon(link))
                break -- Found a home, stop looking
            end
        end
    end
    
    MSC.UpdateLabCalc()
end

-- Hook Shift-Click
hooksecurefunc("HandleModifiedItemClick", function(link)
    if link and IsShiftKeyDown() and MSC.ViewLab and MSC.ViewLab:IsShown() then MSC.OnItemLinkClick(link) end
end)

-- Hook Chat Links (Shift-Click for AtlasLoot when Chat Open)
hooksecurefunc("ChatEdit_InsertLink", function(link)
    if link and MSC.ViewLab and MSC.ViewLab:IsShown() then MSC.OnItemLinkClick(link) end
end)

-- Hook Ctrl-Click (Dressing Room - For AtlasLoot when Chat Closed)
hooksecurefunc("DressUpItemLink", function(link)
    if link and MSC.ViewLab and MSC.ViewLab:IsShown() then MSC.OnItemLinkClick(link) end
end)