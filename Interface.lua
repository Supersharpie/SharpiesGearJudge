local addonName, MSC = ...

-- =============================================================
-- 0. VISUAL THEME ENGINE (Dark Mode + Class Colors)
-- =============================================================
function MSC.SkinFrame(f)
    if not f then return end
    
    -- 1. Dark Background
    if not f.bg then 
        f.bg = f:CreateTexture(nil, "BACKGROUND")
        f.bg:SetAllPoints(f)
        f.bg:SetColorTexture(0.05, 0.05, 0.05, 0.9) -- Sleek dark tint
    end
    
    -- 2. Class-Colored Border
    if not f.border then
        f.border = CreateFrame("Frame", nil, f, "BackdropTemplate")
        f.border:SetPoint("TOPLEFT", -2, 2)
        f.border:SetPoint("BOTTOMRIGHT", 2, -2)
        f.border:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 16,
        })
        local _, class = UnitClass("player")
        local c = (class and RAID_CLASS_COLORS[class]) or {r=0.5, g=0.5, b=0.5}
        f.border:SetBackdropBorderColor(c.r, c.g, c.b, 1)
    end

    -- 3. Header Texture (Small Watermark for most windows)
    if not f.headerArt then
        local _, class = UnitClass("player")
        if class then
            f.headerArt = f:CreateTexture(nil, "ARTWORK")
            f.headerArt:SetSize(64, 64)
            f.headerArt:SetPoint("TOPRIGHT", f, "TOPRIGHT", -18, -25)
            
            -- Try Custom Texture First
            local fixed = class:sub(1,1) .. class:sub(2):lower() 
            local success = pcall(function() 
                f.headerArt:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. fixed .. ".tga") 
            end)
            
            -- Fallback 
            if not success or not f.headerArt:GetTexture() then
                f.headerArt:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
                local coords = CLASS_ICON_TCOORDS[class]
                if coords then
                    f.headerArt:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
                end
            end
            f.headerArt:SetVertexColor(1, 1, 1, 0.3)
        end
    end
    
    -- 4. Clean up Title Text
    if f.TitleText then
        -- UPGRADED FONT SIZE: NormalLarge -> NormalHuge
        f.TitleText:SetFontObject("GameFontNormalLarge") 
        f.TitleText:SetTextColor(1, 0.82, 0) -- Gold Text
        f.TitleText:ClearAllPoints()
        f.TitleText:SetPoint("TOP", 5, -5)
    end
end

-- =============================================================
-- 1. MINIMAP BUTTON
-- =============================================================
local MinimapButton = CreateFrame("Button", "MSC_MinimapButton", Minimap)
MinimapButton:SetSize(32, 32)
MinimapButton:SetFrameStrata("MEDIUM")
MinimapButton:SetFrameLevel(8) 
MinimapButton.icon = MinimapButton:CreateTexture(nil, "BACKGROUND")
MinimapButton.icon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_02")
MinimapButton.icon:SetSize(20, 20)
MinimapButton.icon:SetPoint("CENTER")
MinimapButton.border = MinimapButton:CreateTexture(nil, "OVERLAY")
MinimapButton.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
MinimapButton.border:SetSize(54, 54)
MinimapButton.border:SetPoint("TOPLEFT")
MinimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

function MSC.UpdateMinimapPosition()
    if not SGJ_Settings then return end
    if SGJ_Settings.HideMinimap then MinimapButton:Hide() else MinimapButton:Show() end
    local angle = math.rad(SGJ_Settings.MinimapPos or 45)
    local x, y = math.cos(angle), math.sin(angle)
    MinimapButton:SetPoint("CENTER", Minimap, "CENTER", x * 80, y * 80)
end

local InitFrame = CreateFrame("Frame")
InitFrame:RegisterEvent("PLAYER_LOGIN")
InitFrame:SetScript("OnEvent", function() MSC.UpdateMinimapPosition() end)

MinimapButton:RegisterForClicks("AnyUp")
MinimapButton:RegisterForDrag("LeftButton")
MinimapButton:SetScript("OnDragStart", function(self) 
    self:SetScript("OnUpdate", function(self) 
        local x, y = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        local cx, cy = Minimap:GetCenter()
        local dx, dy = (x / scale) - cx, (y / scale) - cy
        SGJ_Settings.MinimapPos = math.deg(math.atan2(dy, dx))
        MSC.UpdateMinimapPosition() 
    end) 
end)
MinimapButton:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
MinimapButton:SetScript("OnClick", function(self, button) 
    if button == "RightButton" then MSC.CreateOptionsFrame() else MSC.ToggleMainMenu() end
end)
MinimapButton:SetScript("OnEnter", function(self) 
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("Sharpie's Gear Judge")
    GameTooltip:AddLine("Left-Click: Main Menu", 1, 1, 1)
    GameTooltip:AddLine("Right-Click: Options", 0.7, 0.7, 0.7)
    GameTooltip:Show() 
end)
MinimapButton:SetScript("OnLeave", GameTooltip_Hide)


-- =============================================================
-- 2. MAIN MENU HUB
-- =============================================================
function MSC.ToggleMainMenu()
    if MSC.MainMenuFrame then
        if MSC.MainMenuFrame:IsShown() then MSC.MainMenuFrame:Hide() else MSC.MainMenuFrame:Show() end
        return
    end

    local f = CreateFrame("Frame", "SGJ_MainMenu", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(225, 315); f:SetPoint("CENTER")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f.TitleText:SetText("Sharpie's Gear Judge")

    local function CreateMenuButton(text, icon, yOffset, func, desc)
        local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        btn:SetSize(170, 40); btn:SetPoint("TOP", f, "TOP", 0, yOffset); btn:SetText(text)
        btn.ico = btn:CreateTexture(nil, "ARTWORK"); btn.ico:SetSize(24, 24); btn.ico:SetPoint("LEFT", 10, 0); btn.ico:SetTexture(icon)
        
        btn:SetScript("OnClick", function() f:Hide(); func() end)
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(text); GameTooltip:AddLine(desc, 1, 1, 1); GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", GameTooltip_Hide)
        return btn
    end

    CreateMenuButton("The Laboratory", "Interface\\Icons\\INV_Misc_EngGizmos_17", -40, function() MSC.CreateLabFrame() end, "Compare items side-by-side.")
    CreateMenuButton("Gear Receipt", "Interface\\Icons\\INV_Scroll_03", -90, function() MSC.ShowReceipt() end, "Inspect current gear score.")
    CreateMenuButton("Stat Logic", "Interface\\Icons\\INV_Misc_Book_09", -140, function() MSC.ShowMathBreakdown() end, "See stat weights and caps.")
    CreateMenuButton("History & Export", "Interface\\Icons\\INV_Letter_15", -190, function() MSC.ShowHistory() end, "View snapshots and export to Discord.")
    CreateMenuButton("Settings", "Interface\\Icons\\INV_Gizmo_02", -240, function() MSC.CreateOptionsFrame() end, "Configure modes and display.")

    local footer = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    footer:SetPoint("BOTTOM", f, "BOTTOM", 0, 15); footer:SetText("v2.1.0 - TBC Edition"); footer:SetTextColor(0.5, 0.5, 0.5)
    
    MSC.SkinFrame(f)
    MSC.MainMenuFrame = f; f:Show()
end


-- =============================================================
-- 3. SETTINGS WINDOW & QUICK DROP SLOT
-- =============================================================
function MSC.CreateOptionsFrame()
    if MyStatCompareFrame then 
        if MyStatCompareFrame:IsShown() then MyStatCompareFrame:Hide() else MyStatCompareFrame:Show() end
        return 
    end
    
    local f = CreateFrame("Frame", "MyStatCompareFrame", UIParent, "BasicFrameTemplateWithInset")
    -- UPDATED SIZE: Narrower width (380 instead of 450)
    f:SetSize(380, 480) 
    f:SetPoint("CENTER")
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f.TitleText:SetText("Configuration")

    local function GetDisplayName(specKey)
        if specKey == "AUTO" or specKey == "Auto" then return "Auto-Detect" end
        if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[specKey] then return MSC.CurrentClass.PrettyNames[specKey] end
        if MSC.PrettyNames and MSC.PrettyNames[specKey] then return MSC.PrettyNames[specKey] end
        return specKey 
    end

    local function CreateHeader(text, relativeTo, yOffset)
        -- UPGRADED FONT: NormalLarge -> NormalHuge
        local h = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
        h:SetText(text)
        if relativeTo then h:SetPoint("TOP", relativeTo, "BOTTOM", 0, yOffset or -20)
        else h:SetPoint("TOP", f, "TOP", 0, yOffset or -40) end
        return h
    end
    
    local function CreateDropdown(label, key, options, parentObj, yOffset)
        local container = CreateFrame("Frame", nil, f)
        container:SetSize(220, 50)
        container:SetPoint("TOP", parentObj, "BOTTOM", 0, yOffset or -10)

        local title = container:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        title:SetText(label); title:SetPoint("TOP", container, "TOP", 0, 0)
        
        local dd = CreateFrame("Frame", nil, container, "UIDropDownMenuTemplate")
        dd:SetPoint("TOP", title, "BOTTOM", 0, -2) 
        UIDropDownMenu_SetWidth(dd, 200) 
        dd:SetPoint("LEFT", container, "LEFT", -15, 0) 
        
        local function OnClick(self) 
            UIDropDownMenu_SetSelectedID(dd, self:GetID())
            SGJ_Settings[key] = self.value 
            if key == "Mode" then 
                MSC.ManualSpec = self.value 
                MSC.CachedWeights = nil 
                if MSC.UpdateLabCalc then MSC.UpdateLabCalc() end
            end
        end
        
        local function Init(self, level)
            for _, opt in ipairs(options) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = opt.text; info.value = opt.val; info.func = OnClick; 
                info.checked = (SGJ_Settings[key] == opt.val)
                UIDropDownMenu_AddButton(info, level)
            end
        end
        
        UIDropDownMenu_Initialize(dd, Init)
        local currentText = "Select..."
        for _, opt in ipairs(options) do if SGJ_Settings[key] == opt.val then currentText = opt.text end end
        UIDropDownMenu_SetText(dd, currentText)
        if key == "Mode" then f.ProfileDD = dd end 
        return container
    end

    local function CreateCheck(label, key, tooltip, parentAnchor, xPos, yPos)
        local cb = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate")
        cb.Text:SetText(label); cb.Text:ClearAllPoints(); cb.Text:SetPoint("LEFT", cb, "RIGHT", 5, 0) 
        cb:SetChecked(SGJ_Settings[key])
        cb:SetPoint("TOPLEFT", parentAnchor, "BOTTOMLEFT", xPos, yPos)
        
        cb:SetScript("OnClick", function(self) 
            SGJ_Settings[key] = self:GetChecked()
            if key == "HideMinimap" then MSC.UpdateMinimapPosition() end
        end)
        
        if tooltip then
            cb:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(tooltip, nil, nil, nil, nil, true); GameTooltip:Show() end)
            cb:SetScript("OnLeave", GameTooltip_Hide)
        end
        return cb
    end

    -- SECTION 1: PROJECTION
    local header1 = CreateHeader("Comparison Logic", nil, -40)
    
    local dd1 = CreateDropdown("Enchant Comparisons:", "EnchantMode", { 
        { text = "Off", val = 1 }, 
        { text = "Current Only", val = 2 }, 
        { text = "Project Best (Sim)", val = 3 } 
    }, header1, -10)
    
    local dd2 = CreateDropdown("Gem Socket Logic:", "GemMode", { 
        { text = "The Skeptic (Current Stats)", val = 1 }, 
        { text = "The Casual (Fill Empty)", val = 2 }, 
        { text = "The Pro (Perfect Setup)", val = 3 } 
    }, dd1, -15) 

    local metaWarn = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    metaWarn:SetPoint("TOP", dd2, "BOTTOM", 0, -2)
    metaWarn:SetWidth(240); metaWarn:SetJustifyH("CENTER")
    metaWarn:SetText("|cff888888(Note: Meta Gem activation depends\non your total equipped colors.)|r")

    -- SECTION 2: PROFILE
    local header2 = CreateHeader("Character Profile", metaWarn, -20)
    local specOptions = {}; table.insert(specOptions, { text = "Auto-Detect", val = "AUTO" })
    if MSC.CurrentClass then
        if MSC.CurrentClass.Weights then
            local sorted = {}; for k in pairs(MSC.CurrentClass.Weights) do table.insert(sorted, k) end; table.sort(sorted)
            for _, k in ipairs(sorted) do table.insert(specOptions, { text = GetDisplayName(k), val = k }) end
        end
        if MSC.CurrentClass.LevelingWeights then
            local sorted = {}; for k in pairs(MSC.CurrentClass.LevelingWeights) do table.insert(sorted, k) end; table.sort(sorted)
            for _, k in ipairs(sorted) do table.insert(specOptions, { text = GetDisplayName(k), val = k }) end
        end
    end

    local function UpdateDropDownText()
        if not f.ProfileDD then return end
        if SGJ_Settings.Mode == "AUTO" or SGJ_Settings.Mode == "Auto" then
             local _, detectedKey = MSC.GetCurrentWeights()
             UIDropDownMenu_SetText(f.ProfileDD, "Auto: " .. GetDisplayName(detectedKey))
        else
             UIDropDownMenu_SetText(f.ProfileDD, "Manual: " .. GetDisplayName(SGJ_Settings.Mode))
        end
    end
    local dd3 = CreateDropdown("Scoring Profile:", "Mode", specOptions, header2, -10)

    -- SECTION 3: INTERFACE
    -- Offsets adjusted for narrower window
    local header3 = CreateHeader("Interface Settings", dd3, -25)
    local cb1 = CreateCheck("Hide Minimap Button", "HideMinimap", "Hides the button around your minimap.", header3, -100, -20) 
    local cb2 = CreateCheck("Hide Tooltip Verdict", "HideTooltips", "Stops the addon from adding scores to tooltips.", header3, 80, -20)
    local cb3 = CreateCheck("Mute Lab Errors", "MuteSounds", "Stops the error sound when clicking invalid items.", header3, -100, -50)
    local cb4 = CreateCheck("Disable Conflict Check", "DisableConflictCheck", "Stops the chat warning about Pawn/Zygor.", header3, 80, -50)
    
    -- QUICK TEST DROP SLOT
    local dropBtn = CreateFrame("Button", "SGJ_DropSlot", f, "ItemButtonTemplate")
    dropBtn:SetPoint("BOTTOMLEFT", 40, 40)
    
    dropBtn.bg = dropBtn:CreateTexture(nil, "BACKGROUND")
    dropBtn.bg:SetAllPoints()
    dropBtn.bg:SetTexture("Interface\\Paperdoll\\UI-Backpack-EmptySlot")
    dropBtn.bg:SetAlpha(0.6)

    dropBtn.lbl = dropBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dropBtn.lbl:SetPoint("BOTTOM", dropBtn, "TOP", 0, 4)
    dropBtn.lbl:SetText("Check Settings")

    f.res1 = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.res1:SetPoint("LEFT", dropBtn, "RIGHT", 15, 10)
    f.res2 = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); f.res2:SetPoint("LEFT", dropBtn, "RIGHT", 15, -5)
    f.res3 = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); f.res3:SetPoint("LEFT", dropBtn, "RIGHT", 15, -20)
    
    dropBtn:SetScript("OnClick", function()
        local type, _, link = GetCursorInfo()
        if type == "item" then
            ClearCursor()
            local weights, spec = MSC.GetCurrentWeights()
            local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
            local slotId = MSC.SlotMap and MSC.SlotMap[equipLoc] or 1
            
            local nScore, oScore, nStats, oStats, nColors = MSC:EvaluateUpgrade(link, slotId, weights, spec)
            
            f.res1:SetText("Score: " .. nScore)
            if nStats.GEM_TEXT then f.res2:SetText(nStats.GEM_TEXT) else f.res2:SetText("") end
            
            if nStats.META_ID and MSC.CheckMetaRequirements and nColors then
                if MSC:CheckMetaRequirements(nStats.META_ID, nColors) then
                    f.res3:SetText("|cff00ff00Meta Active|r")
                else
                    f.res3:SetText("|cffff0000Meta Inactive|r")
                end
            else
                f.res3:SetText("")
            end
            SetItemButtonTexture(dropBtn, GetItemIcon(link))
        end
    end)

    f:SetScript("OnShow", function(self)
        if MSC.BuildTalentCache then MSC:BuildTalentCache() end
        UpdateDropDownText()
    end)
    
    MSC.SkinFrame(f)
    MSC.OptionsFrame = f
end

-- =============================================================
-- 4. THE LABORATORY
-- =============================================================
local LabFrame = nil
local LabMH, LabOH, Lab2H = nil, nil, nil

function MSC.UpdateLabCalc()
    if not LabFrame or not LabFrame:IsShown() then return end
    if not LabMH then return end 

    local weights, profileName = MSC.GetCurrentWeights()
    local rawProfileName = profileName 
    
    local _, class = UnitClass("player")
    if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[profileName] then
        profileName = MSC.CurrentClass.PrettyNames[profileName]
    elseif MSC.PrettyNames and MSC.PrettyNames[profileName] then
        profileName = MSC.PrettyNames[profileName]
    end
    
    LabFrame.ProfileText:SetText("Profile: " .. profileName)
    
    if not LabMH.link and not LabOH.link and not Lab2H.link then
        LabFrame.ScoreCurrent:SetText(""); LabFrame.ScoreNew:SetText("")
        LabFrame.Result:SetText("Shift+Click items to add"); LabFrame.Details:SetText("")
        return
    end

    local currentGear = MSC:GetEquippedGear() 
    local currentScore, currentStats, currentColors = MSC:GetTotalCharacterScore(currentGear, weights, rawProfileName)

    local scoreA, statsA = 0, {}
    local scoreB, statsB, colorsB = 0, {}, {}

    if (LabMH.link or LabOH.link) and Lab2H.link then
        local setDW = MSC:SafeCopy(currentGear); setDW[16] = LabMH.link; setDW[17] = LabOH.link 
        local set2H = MSC:SafeCopy(currentGear); set2H[16] = Lab2H.link; set2H[17] = nil 
        scoreA, statsA, _ = MSC:GetTotalCharacterScore(setDW, weights, rawProfileName)
        scoreB, statsB, colorsB = MSC:GetTotalCharacterScore(set2H, weights, rawProfileName) 

        LabFrame.ScoreCurrent:SetText(string.format("Dual Wield: %.1f", scoreA))
        LabFrame.ScoreNew:SetText(string.format("2-Hander: %.1f", scoreB))
        
        local diff = scoreB - scoreA
        if diff > 0.1 then LabFrame.Result:SetText("|cff00ff002H WINS (+"..string.format("%.1f", diff)..")|r")
        elseif diff < -0.1 then LabFrame.Result:SetText("|cffff00002H LOSES ("..string.format("%.1f", diff)..")|r")
        else LabFrame.Result:SetText("|cffaaaaaaEven (0.0)|r") end
    else
        local setCustom = MSC:SafeCopy(currentGear)
        if Lab2H.link then setCustom[16] = Lab2H.link; setCustom[17] = nil
        else if LabMH.link then setCustom[16] = LabMH.link end; if LabOH.link then setCustom[17] = LabOH.link end end
        
        scoreA, statsA = currentScore, currentStats
        scoreB, statsB, colorsB = MSC:GetTotalCharacterScore(setCustom, weights, rawProfileName)
        
        LabFrame.ScoreCurrent:SetText(string.format("Current: %.1f", scoreA))
        LabFrame.ScoreNew:SetText(string.format("Custom: %.1f", scoreB))
        
        local diff = scoreB - scoreA
        if diff > 0.1 then LabFrame.Result:SetText("|cff00ff00UPGRADE (+"..string.format("%.1f", diff)..")|r")
        elseif diff < -0.1 then LabFrame.Result:SetText("|cffff0000DOWNGRADE ("..string.format("%.1f", diff)..")|r")
        else LabFrame.Result:SetText("|cffaaaaaaSidegrade (0.0)|r") end
    end

    local hiddenKeys = { ["IS_PROJECTED"] = true, ["GEMS_PROJECTED"] = true, ["BONUS_PROJECTED"] = true, ["GEM_TEXT"] = true, ["ENCHANT_TEXT"] = true, ["estimate"] = true }
    
    local diffs = MSC.GetStatDifferences(statsB, statsA, nil)
    local sorted = MSC.SortStatDiffs(diffs)
    local lines = ""
    
    if statsB.META_ID and MSC.CheckMetaRequirements and colorsB then
        if MSC:CheckMetaRequirements(statsB.META_ID, colorsB) then
            lines = lines .. "|cff00ff00[Meta Gem Active]|r\n"
        else
            lines = lines .. "|cffff0000[Meta Gem Inactive]|r\n"
        end
    end

    local c = 0
    for _, e in ipairs(sorted) do
        if c >= 10 then break end
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

local function CreateItemButton(name, parent, x, y, iconType, labelText)
    local btn = CreateFrame("Button", name, parent, "ItemButtonTemplate")
    btn:SetPoint("CENTER", parent, "CENTER", x, y)
    btn:RegisterForClicks("AnyUp")
    
    btn.empty = btn:CreateTexture(nil, "BACKGROUND")
    btn.empty:SetAllPoints(btn)
    btn.empty:SetTexture(iconType == "OH" and "Interface\\Paperdoll\\UI-PaperDoll-Slot-SecondaryHand" or "Interface\\Paperdoll\\UI-PaperDoll-Slot-MainHand")
    btn.empty:SetAlpha(0.5)
    
    btn.Label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); btn.Label:SetPoint("BOTTOM", btn, "TOP", 0, 3); btn.Label:SetText(labelText); btn.Label:SetTextColor(0.8, 0.8, 0.8, 1)
    if not btn.icon then btn.icon = _G[name.."Icon"] end

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if self.link then 
            if GetItemInfo(self.link) then GameTooltip:SetHyperlink(self.link) 
            else GameTooltip:SetText(labelText); GameTooltip:AddLine("|cffaaaaaa(Loading...)|r") end
        else GameTooltip:SetText(labelText); GameTooltip:AddLine("|cffaaaaaaShift+Click to link|r") end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", GameTooltip_Hide)

    btn:SetScript("OnClick", function(self)
        local type, _, link = GetCursorInfo()
        if type == "item" then
            if not MSC.IsItemUsable(link) then return end
            self.link = link; 
            if self.icon then self.icon:SetTexture(select(10, GetItemInfo(link)) or "Interface\\Icons\\INV_Misc_QuestionMark") end
            self.empty:Hide(); ClearCursor(); MSC.UpdateLabCalc()
        elseif IsShiftKeyDown() then 
            self.link = nil; if self.icon then self.icon:SetTexture(nil) end
            self.empty:Show(); MSC.UpdateLabCalc() 
        end
    end)
    return btn
end

function MSC.CreateLabFrame()
    if MSCLabFrame then if MSCLabFrame:IsShown() then MSCLabFrame:Hide() else MSCLabFrame:Show() end return end
    
    local f = CreateFrame("Frame", "MSCLabFrame", UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(360, 420); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    
    f.TitleText:SetText("The Laboratory")
    
    LabFrame = f 
    LabMH = CreateItemButton("MSCLabMH", f, -65, 120, "MH", "Main Hand")
    LabOH = CreateItemButton("MSCLabOH", f, 65, 120, "OH", "Off Hand")
    Lab2H = CreateItemButton("MSCLab2H", f, 0, 50, "2H", "Two-Hand")

    f.ProfileText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); f.ProfileText:SetPoint("TOP", f, "TOP", 0, -30)
    f.ScoreCurrent = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.ScoreCurrent:SetPoint("CENTER", f, "CENTER", 0, -10)
    f.ScoreNew = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.ScoreNew:SetPoint("CENTER", f, "CENTER", 0, -30)
    f.Result = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"); f.Result:SetPoint("CENTER", f, "CENTER", 0, -50)
    f.Details = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); f.Details:SetPoint("TOP", f.Result, "BOTTOM", 0, -10); f.Details:SetJustifyH("CENTER")
    
    MSC.SkinFrame(f)
    
    -- FIX: Restore Original Lab Crest (Big Center) and Hide Small Watermark
    if f.headerArt then f.headerArt:Hide() end
    local _, class = UnitClass("player")
    if class then
        local fixed = class:sub(1,1) .. class:sub(2):lower()
        f.crest = f:CreateTexture(nil, "ARTWORK")
        f.crest:SetAllPoints(f)
        pcall(function() f.crest:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. fixed .. ".tga") end)
        f.crest:SetVertexColor(0.6, 0.6, 0.6, 0.6)
    end
    
    MSC.UpdateLabCalc()
    f:Show()
end

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
        if equipLoc == "INVTYPE_2HWEAPON" then LoadLabItem(Lab2H, text)
        elseif equipLoc == "INVTYPE_SHIELD" or equipLoc == "INVTYPE_HOLDABLE" or equipLoc == "INVTYPE_WEAPONOFFHAND" then LoadLabItem(LabOH, text)
        elseif equipLoc == "INVTYPE_WEAPON" then
             local _, class = UnitClass("player")
             local canDW = (class == "ROGUE" or class == "WARRIOR" or class == "HUNTER" or class == "SHAMAN")
             if canDW and LabMH.link and not LabOH.link then LoadLabItem(LabOH, text) else LoadLabItem(LabMH, text) end
        elseif equipLoc == "INVTYPE_WEAPONMAINHAND" then LoadLabItem(LabMH, text)
        else return end
        MSC.UpdateLabCalc()
        local editBox = ChatEdit_GetActiveWindow()
        if editBox and editBox:GetText() == text then editBox:SetText(""); editBox:Hide() end
    end
end)

-- =============================================================
-- 5. CACHE & RECEIPT INSPECTOR
-- =============================================================
MSC.BagCache = {}
MSC.BagCacheDirty = true
local bagEventFrame = CreateFrame("Frame"); bagEventFrame:RegisterEvent("BAG_UPDATE"); bagEventFrame:SetScript("OnEvent", function() MSC.BagCacheDirty = true end)

function MSC.PopulateBagCache(weights, specName)
    if not MSC.BagCacheDirty then return end
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
    MSC.BagCacheDirty = false
end

local function IsMissingEnchant(itemLink, slotId)
    if not itemLink then return false end
    local validSlots = { [1]=true, [3]=true, [5]=true, [7]=true, [8]=true, [9]=true, [10]=true, [15]=true, [16]=true, [17]=true }
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
        local profileName = detectedSpec or "Default"
        specName = unitClass .. " (" .. profileName .. ")"
        if MSC.CurrentClass and MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[profileName] then
            currentWeights = MSC.CurrentClass.Weights[profileName]
        elseif MSC.WeightDB and MSC.WeightDB[unitClass] then
            currentWeights = MSC.WeightDB[unitClass][profileName] or MSC.WeightDB[unitClass]["Default"]
        end
        if not currentWeights then print("|cffff0000SGJ:|r Unsupported Class/Spec."); return end
    end

    if not MSC.ReceiptFrame then
        local f = CreateFrame("Frame", "SGJ_ReceiptFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(420, 600); f:SetPoint("CENTER")
        f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleText:SetText("Sharpie's Gear Receipt")

        f:RegisterEvent("INSPECT_READY")
        f:SetScript("OnEvent", function(self, event, guid)
            if event == "INSPECT_READY" and self.unitGUID and guid == self.unitGUID then
                C_Timer.After(0.2, function() if self:IsVisible() then MSC.ShowReceipt(self.unitID, true) end end)
            end
        end)
        MSC.ReceiptFrame = f
        
        f.Scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        f.Scroll:SetPoint("TOPLEFT", 10, -30); f.Scroll:SetPoint("BOTTOMRIGHT", -30, 185) 
        f.Content = CreateFrame("Frame", nil, f.Scroll); f.Content:SetSize(380, 480); f.Scroll:SetScrollChild(f.Content)
        
        f.SummaryBox = CreateFrame("Frame", nil, f)
        f.SummaryBox:SetPoint("TOPLEFT", f.Scroll, "BOTTOMLEFT", 0, -5); f.SummaryBox:SetPoint("BOTTOMRIGHT", -10, 40)
        f.Separator = f.SummaryBox:CreateTexture(nil, "ARTWORK"); f.Separator:SetHeight(1); f.Separator:SetPoint("TOPLEFT", 10, 0); f.Separator:SetPoint("TOPRIGHT", -10, 0); f.Separator:SetColorTexture(1, 0.82, 0, 0.5) 
        f.SummaryBg = f.SummaryBox:CreateTexture(nil, "BACKGROUND"); f.SummaryBg:SetPoint("TOPLEFT", 0, -5); f.SummaryBg:SetPoint("BOTTOMRIGHT", 0, 0); f.SummaryBg:SetColorTexture(0, 0, 0, 0.3)
        f.SummaryTitle = f.SummaryBox:CreateFontString(nil, "OVERLAY", "GameFontNormal"); f.SummaryTitle:SetPoint("TOPLEFT", 10, -12); f.SummaryTitle:SetText("COMBINED GEAR STAT TOTALS"); f.SummaryTitle:SetTextColor(1, 0.82, 0)
        f.TotalText = f.SummaryBox:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); f.TotalText:SetPoint("BOTTOM", f, "BOTTOM", 0, 15)
        
        MSC.SkinFrame(f)
        
        MSC.ReceiptRows = {}; MSC.SummaryRows = {} 
    end
    
    MSC.ReceiptFrame.unitName = unitName; MSC.ReceiptFrame.unitID = unit 
    if not isPlayer then MSC.ReceiptFrame.unitGUID = UnitGUID(unit); if not skipInspect then NotifyInspect(unit) end end
    MSC.ReceiptFrame:Show()
    
    local slots = {{name="Head",id=1},{name="Neck",id=2},{name="Shoulder",id=3},{name="Back",id=15},{name="Chest",id=5},{name="Wrist",id=9},{name="Hands",id=10},{name="Waist",id=6},{name="Legs",id=7},{name="Feet",id=8},{name="Finger 1",id=11},{name="Finger 2",id=12},{name="Trinket 1",id=13},{name="Trinket 2",id=14},{name="Main Hand",id=16},{name="Off Hand",id=17},{name="Ranged",id=18}}
    local gearTable = {}; for _, slot in ipairs(slots) do local link = GetInventoryItemLink(unit, slot.id); if link then gearTable[slot.id] = link end end
    local trueTotalScore = MSC:GetTotalCharacterScore(gearTable, currentWeights, specName)
    if unit == "player" then MSC.PopulateBagCache(currentWeights, specName) end

    local combinedStats = {}; local yOffset = 0
    for i, slot in ipairs(slots) do
        if not MSC.ReceiptRows[i] then
             local row = CreateFrame("Frame", nil, MSC.ReceiptFrame.Content); row:SetSize(380, 24)
             row.BG = row:CreateTexture(nil, "BACKGROUND"); row.BG:SetAllPoints(); row.BG:SetColorTexture(1, 1, 1, 0.05)
             row.Icon = row:CreateTexture(nil, "ARTWORK"); row.Icon:SetSize(20, 20); row.Icon:SetPoint("LEFT", 2, 0); row.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
             row.Label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); row.Label:SetPoint("LEFT", row.Icon, "RIGHT", 5, 0); row.Label:SetWidth(60); row.Label:SetJustifyH("LEFT"); row.Label:SetTextColor(0.6, 0.6, 0.6)
             row.Score = row:CreateFontString(nil, "OVERLAY", "GameFontNormal"); row.Score:SetPoint("RIGHT", -5, 0); row.Score:SetWidth(50); row.Score:SetJustifyH("RIGHT"); row.Score:SetTextColor(0, 1, 0)
             row.Item = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); row.Item:SetPoint("LEFT", row.Label, "RIGHT", 5, 0); row.Item:SetPoint("RIGHT", row.Score, "LEFT", -5, 0); row.Item:SetJustifyH("LEFT")
             
             row.Alert = row:CreateTexture(nil, "OVERLAY"); row.Alert:SetSize(16, 16); row.Alert:SetPoint("RIGHT", row.Score, "LEFT", -5, 0); row.Alert:Hide()
             row.AlertFrame = CreateFrame("Frame", nil, row); row.AlertFrame:SetAllPoints(row.Alert)
             
             row.AlertFrame:SetScript("OnEnter", function(self)
                 GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                 if self.mode == "UPGRADE" and self.link then
                     if GetItemInfo(self.link) then GameTooltip:SetHyperlink(self.link) end
                     GameTooltip:AddLine(" ")
                     local diffText = self.diff and string.format("%.1f", self.diff) or "?"
                     GameTooltip:AddLine("|cff00ff00BETTER ITEM IN BAGS (+" .. diffText .. ")|r")
                     GameTooltip:AddLine("|cff888888Shift-Click to Link|r")
                 elseif self.mode == "ENCHANT" then
                     GameTooltip:SetText("|cffff0000MISSING ENCHANT!|r")
                     GameTooltip:AddLine("You are losing potential stats.", 1, 1, 1)
                 end
                 GameTooltip:Show()
             end)
             row.AlertFrame:SetScript("OnLeave", GameTooltip_Hide)
             
             row:SetScript("OnEnter", function(self)
                 if self.link then 
                     GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetHyperlink(self.link); GameTooltip:Show()
                 end
             end)
             row:SetScript("OnLeave", GameTooltip_Hide)
             
             MSC.ReceiptRows[i] = row
        end
        local row = MSC.ReceiptRows[i]; row:SetPoint("TOPLEFT", 0, yOffset)
        if i % 2 == 0 then row.BG:Show() else row.BG:Hide() end
        
        local link = GetInventoryItemLink(unit, slot.id)
        local itemScore = 0
        local texture = GetInventoryItemTexture(unit, slot.id)
        row.Alert:Hide(); row.link = link; row.AlertFrame.mode = nil

        if link then
            local stats = MSC.SafeGetItemStats(link, slot.id, currentWeights, specName)
            if stats then 
                itemScore = MSC.GetItemScore(stats, currentWeights, specName, slot.id)
                for k, v in pairs(stats) do if type(v) == "number" then combinedStats[k] = (combinedStats[k] or 0) + v end end
            end
            row.Item:SetText(link)
            if texture then row.Icon:SetTexture(texture) else row.Icon:SetTexture(GetItemIcon(link)) end
            
            if IsMissingEnchant(link, slot.id) then
                row.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertOther")
                row.Alert:Show(); row.AlertFrame.mode = "ENCHANT"
            end
        else
            row.Item:SetText("|cff444444(Empty)|r")
            row.Icon:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
        end
        
        if isPlayer and link then
             local bestBagScore = itemScore; local foundUpgrade = false; local upLink = nil
             for _, cachedItem in ipairs(MSC.BagCache) do
                 local isMatch = (cachedItem.slotId == slot.id)
                 if slot.id == 11 or slot.id == 12 then if cachedItem.slotId == 11 then isMatch = true end end
                 if slot.id == 13 or slot.id == 14 then if cachedItem.slotId == 13 then isMatch = true end end
                 if isMatch and cachedItem.score > bestBagScore + 0.1 then foundUpgrade = true; bestBagScore = cachedItem.score; upLink = cachedItem.link end
             end
			 -- NEW: Check for PvP Tax Visual
        if link then
             local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(link)
             -- If it has resilience and we are in PvE mode
             local resVal = stats["ITEM_MOD_RESILIENCE_RATING_SHORT"] or 0
             if resVal > 0 and (currentWeights["ITEM_MOD_RESILIENCE_RATING_SHORT"] or 0) <= 0.05 then
                 -- Mark it as PvP gear so the user knows why the score is low
                 row.Label:SetText("|cffcc0000PvP|r " .. slot.name)
             end
        end
             if foundUpgrade then 
                 row.Alert:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
                 row.Alert:Show(); row.AlertFrame.mode = "UPGRADE"; row.AlertFrame.link = upLink; row.AlertFrame.diff = bestBagScore - itemScore
             end
        end
        
        row.Label:SetText(slot.name); row.Score:SetText(string.format("%.1f", itemScore))
        yOffset = yOffset - 24
    end
    
    MSC.ReceiptFrame.TotalText:SetText("SCORE: " .. string.format("%.1f", trueTotalScore))

    for _, line in pairs(MSC.SummaryRows) do line:Hide() end
    local sortedStats = {}
    for k, v in pairs(combinedStats) do
        if k ~= "IS_PROJECTED" and k ~= "GEMS_PROJECTED" and k ~= "BONUS_PROJECTED" and v > 0 then
            local weight = currentWeights[k] or 0
            if weight > 0 then table.insert(sortedStats, { key=k, val=v, weight=weight, realWeight=weight }) end
        end
    end
    table.sort(sortedStats, function(a,b) return a.weight > b.weight end)

    local col1X, col2X = 20, 210; local startY = -35
    for i, data in ipairs(sortedStats) do
        if i > 12 then break end 
        if not MSC.SummaryRows[i] then
            local f = CreateFrame("Frame", nil, MSC.ReceiptFrame.SummaryBox); f:SetSize(160, 16)
            f.Label = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); f.Label:SetPoint("LEFT", 0, 0)
            f.Value = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.Value:SetPoint("RIGHT", 0, 0)
            MSC.SummaryRows[i] = f
        end
        local row = MSC.SummaryRows[i]; row:Show()
        local cleanName = MSC.GetCleanStatName(data.key)
        row.Label:SetText("|cff00ff00" .. cleanName .. ":|r"); row.Value:SetText(string.format("%.1f", data.val))
        local isLeft = (i % 2 ~= 0); local rowIdx = math.ceil(i / 2) - 1; local yPos = startY - (rowIdx * 16)
        if isLeft then row:SetPoint("TOPLEFT", col1X, yPos) else row:SetPoint("TOPLEFT", col2X, yPos) end
    end
end

-- =============================================================
-- 6. MATH BREAKDOWN (Optimized Padding)
-- =============================================================
local function GetStatReason(stat, class, profileName)
    if not profileName then profileName = "" end
    if stat:find("HIT") then return "Reduces Chance to Miss" end
    if stat:find("HASTE") then return "Increases Speed" end
    if stat:find("CRIT") and not stat:find("FROM_STATS") then 
        if profileName:find("HOLY") or profileName:find("RESTO") then return "Crit Heals & Mana Refund" end
        return "Higher Critical Strike Chance" 
    end
    if stat:find("EXPERTISE") then return "Reduces Dodge/Parry" end
    if stat:find("RESILIENCE") then return "Crit Immunity & DMG Reduction" end
    if stat:find("ARMOR_PEN") then return "Ignores Enemy Armor" end
    if stat:find("DEFENSE") then return "Avoidance & Crit Immunity" end
    if stat:find("SPELL_POWER") then return "Raw Spell Scaling" end
    if stat:find("HEALING") then return "Raw Healing Output" end
    if stat:find("ATTACK_POWER") then return "Direct Damage Increase" end
    if stat:find("MANA_REG") then return "Mana per 5 Sec (Sustain)" end
    if stat:find("BLOCK_VALUE") then return "DMG Blocked / Shield Slam" end
    if stat:find("BLOCK_RATING") then return "Chance to Block" end
    if stat:find("DODGE") then return "Chance to Dodge" end
    if stat:find("PARRY") then return "Chance to Parry" end
    
    if stat == "ITEM_MOD_INTELLECT_SHORT" then 
        if class == "SHAMAN" and profileName:find("ENH") then return "Mental Dexterity (Int -> AP)" end
        if class == "HUNTER" then return "Mana Pool (Viper)" end
        if class == "PALADIN" and profileName:find("RET") then return "Mana & Spell Crit" end
        return "Mana Pool & Crit"
    end
    if stat == "ITEM_MOD_STRENGTH_SHORT" then 
        if class == "WARRIOR" or class == "PALADIN" then return "AP & Block Value" end
        return "Melee Attack Power"
    end
    if stat == "ITEM_MOD_AGILITY_SHORT" then 
        if class == "ROGUE" or class == "HUNTER" then return "AP, Crit, Armor" end
        return "Crit, Dodge, Armor"
    end
    if stat == "ITEM_MOD_STAMINA_SHORT" then 
        if profileName:find("PROT") or profileName:find("TANK") then return "Effective Health (Survival)" end
        return "Total Health" 
    end
    return nil
end

function MSC.ShowMathBreakdown()
    if not MSC.MathFrame then
        local f = CreateFrame("Frame", "SGJ_MathFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(420, 550); f:SetPoint("CENTER"); f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleText:SetText("Stat Logic (The Receipt)")
        
        MSC.SkinFrame(f)

        f.Scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        f.Scroll:SetPoint("TOPLEFT", 10, -30); f.Scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        f.Content = CreateFrame("Frame", nil, f.Scroll); f.Content:SetSize(380, 1); f.Scroll:SetScrollChild(f.Content)
        
        f.text = f.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); 
        f.text:SetPoint("TOPLEFT", 10, -10); f.text:SetWidth(360); f.text:SetJustifyH("LEFT")
        
        -- VISUAL FIX: 6 pixels of padding between lines.
        -- This is cleaner than double spacing (which adds a whole empty line).
        f.text:SetSpacing(6)
        
        MSC.MathFrame = f
    end
    
    MSC.MathFrame:Show()
    
    local weights, detectedKey = MSC.GetCurrentWeights()
    local _, class = UnitClass("player")
    local level = UnitLevel("player")
    local log = {}
    
    local function add(text, isHeader) 
        if isHeader then 
            table.insert(log, "\n|cffffd100" .. text .. "|r") 
        else 
            table.insert(log, text) 
        end
    end

    -- 1. HEADER
    add("=== CUSTOMER INFORMATION ===", true)
    local prettyProfile = (MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[detectedKey]) or detectedKey
    add("Class: " .. class .. " | Level: " .. level)
    add("Active Profile: |cff00ff00" .. prettyProfile .. "|r")

    -- 2. CALCULATE
    local currentGear = MSC:GetEquippedGear() 
    local totalScore, playerStats = MSC:GetTotalCharacterScore(currentGear, weights, detectedKey)
    
    add("=== HIT CAP ANALYSIS ===", true)
    local isSpell = (detectedKey:find("MAGE") or detectedKey:find("WARLOCK") or detectedKey:find("PRIEST") or detectedKey:find("ELE") or detectedKey:find("BALANCE"))
    local hitRating = isSpell and (playerStats["ITEM_MOD_HIT_SPELL_RATING_SHORT"] or 0) or (playerStats["ITEM_MOD_HIT_RATING_SHORT"] or 0)
    
    local conversion = isSpell and 12.6 or 15.8
    local curHitPct = hitRating / conversion
    local capPct = isSpell and 16 or 9 
    
    add(string.format("Current Hit: %d Rating (%.1f%%) | Cap: %d%%", hitRating, curHitPct, capPct))
    
    local hitWeight = isSpell and (weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] or 0) or (weights["ITEM_MOD_HIT_RATING_SHORT"] or 0)
    if hitWeight > 0.1 then
        add(" Status: Under Cap (|cff00ff00Full Value|r)")
    else
        add(" Status: |cffff0000HIT CAPPED|r (Value reduced)")
    end

    -- 3. TANK LOGIC
    if detectedKey:find("PROT") or detectedKey:find("TANK") or detectedKey:find("BEAR") then
        add("=== TANK SURVIVABILITY ===", true)
        
        local baseDef, posBuff = UnitDefense("player")
        local totalDef = (baseDef or 0) + (posBuff or 0)
        local resil = GetCombatRating(15) or 0
        
        local defCritReduc = math.max(0, (totalDef - 350) * 0.04)
        local resilCritReduc = resil / 39.423
        local talentReduc = (detectedKey:find("BEAR")) and 3.0 or 0.0
        local totalReduc = defCritReduc + resilCritReduc + talentReduc
        local critGap = 5.6 - totalReduc

        if critGap <= 0.01 then 
             add("Crit Immunity: |cff00ff00YES|r (Over by " .. string.format("%.2f%%", math.abs(critGap)) .. ")")
        else
             add("Crit Immunity: |cffff0000NO|r (Need " .. string.format("%.2f%%", critGap) .. " more)")
        end
        add(string.format("   Def: %.2f%% | Resil: %.2f%% | Talents: %.1f%%", defCritReduc, resilCritReduc, talentReduc))

        if not detectedKey:find("BEAR") then
            local dodge = GetDodgeChance()
            local parry = GetParryChance()
            local block = GetBlockChance()
            local miss = 5 + (totalDef - 350) * 0.04
            local activeBlock = (class == "PALADIN") and 30 or 0
            local avoid = dodge + parry + block + miss + activeBlock
            local crushGap = 102.4 - avoid
            
            if crushGap <= 0.01 then
                add("Uncrushable (w/ Active): |cff00ff00YES|r")
            else
                add("Uncrushable (w/ Active): |cffff0000NO|r (Need " .. string.format("%.2f%%", crushGap) .. " more)")
            end
             add(string.format("   Total Avoidance: %.2f%%", avoid))
        end
    end

    -- 4. SCORING BREAKDOWN (Single Spaced with Padding)
    add("=== SCORING BREAKDOWN ===", true)
    add("|cff888888(Total Amount x Weight = Contribution)|r")
    
    local sorted = {}
    for k, weight in pairs(weights) do 
        if weight > 0 then
            local myAmount = playerStats[k] or 0
            local contrib = myAmount * weight
            table.insert(sorted, {k=k, w=weight, amt=myAmount, score=contrib}) 
        end
    end
    table.sort(sorted, function(a,b) return a.score > b.score end)
    
    for _, data in ipairs(sorted) do
        if data.score > 0.1 then
            local prettyName = MSC.GetCleanStatName(data.k)
            local reason = GetStatReason(data.k, class, detectedKey)
            
            local line = string.format("%s: |cffffffff%.0f|r x |cff00ccff%.2f|r = |cff00ff00%.1f|r", 
                prettyName, data.amt, data.w, data.score)
                
            if reason then
                line = line .. " |cff888888(" .. reason .. ")|r"
            end
            add(line)
        end
    end
    
    add("\n|cff00ff00TOTAL JUDGE'S SCORE: " .. string.format("%.1f", totalScore) .. "|r")

    MSC.MathFrame.text:SetText(table.concat(log, "\n"))
    local textHeight = MSC.MathFrame.text:GetStringHeight()
    MSC.MathFrame.Content:SetHeight(textHeight + 40)
end

-- =============================================================
-- 7. EXPORT WINDOW (Discord Pro Format)
-- =============================================================
function MSC.ShowHistory()
    if not MSC.ExportFrame then
        local f = CreateFrame("Frame", "SGJ_ExportFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(500, 400)
        f:SetPoint("CENTER")
        f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.TitleText:SetText("Export Data (Ctrl+C to Copy)")
        
        MSC.SkinFrame(f)
        
        f.Scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        f.Scroll:SetPoint("TOPLEFT", 10, -30)
        f.Scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        
        f.EditBox = CreateFrame("EditBox", nil, f.Scroll)
        f.EditBox:SetMultiLine(true)
        f.EditBox:SetFontObject(ChatFontNormal)
        f.EditBox:SetWidth(450)
        f.EditBox:SetScript("OnEscapePressed", function() f:Hide() end)
        f.Scroll:SetScrollChild(f.EditBox)
        
        MSC.ExportFrame = f
    end
    
    local unit = "player"
    local weights, profileName = MSC.GetCurrentWeights()
    local currentGear = MSC:GetEquippedGear() 
    local totalScore = MSC:GetTotalCharacterScore(currentGear, weights, profileName)
    local dateStr = date("%Y-%m-%d")
    local _, class = UnitClass("player")
    
    if MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[profileName] then
        profileName = MSC.CurrentClass.PrettyNames[profileName]
    end
    profileName = profileName:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")

    local text = "```yaml\n"
    text = text .. "Sharpies_Gear_Judge_Report:\n"
    text = text .. "  Player: " .. UnitName("player") .. " (" .. class .. ")\n"
    text = text .. "  Spec:   " .. profileName .. "\n"
    text = text .. "  Date:   " .. dateStr .. "\n"
    text = text .. "  Total_Score: " .. string.format("%.1f", totalScore) .. "\n"
    text = text .. "========================================\n"

    local slots = {
        {name="Head",id=1}, {name="Neck",id=2}, {name="Shoulder",id=3}, {name="Back",id=15},
        {name="Chest",id=5}, {name="Wrist",id=9}, {name="Hands",id=10}, {name="Waist",id=6},
        {name="Legs",id=7}, {name="Feet",id=8}, {name="Finger 1",id=11}, {name="Finger 2",id=12},
        {name="Trinket 1",id=13}, {name="Trinket 2",id=14}, {name="Main Hand",id=16}, 
        {name="Off Hand",id=17}, {name="Ranged",id=18}
    }

    for _, slot in ipairs(slots) do
        local link = GetInventoryItemLink(unit, slot.id)
        local itemName = "[Empty]"
        local itemScore = 0
        local scoreStr = "   -"
        
        if link then
            itemName = GetItemInfo(link) or "Unknown Item"
            local stats = MSC.SafeGetItemStats(link, slot.id, weights, profileName)
            if stats then 
                itemScore = MSC.GetItemScore(stats, weights, profileName, slot.id)
                scoreStr = string.format("%4.1f", itemScore)
            end
        end
        
        local slotPadding = 10 - string.len(slot.name)
        local space1 = string.rep(" ", slotPadding > 0 and slotPadding or 1)
        
        text = text .. slot.name .. ":" .. space1 .. "[" .. itemName .. "] " .. scoreStr .. "\n"
    end
    
    text = text .. "```"
    
    MSC.ExportFrame:Show()
    MSC.ExportFrame.EditBox:SetText(text)
    MSC.ExportFrame.EditBox:HighlightText()
    MSC.ExportFrame.EditBox:SetFocus()
end