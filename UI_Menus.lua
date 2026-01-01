local _, MSC = ...

-- =============================================================
-- 1. MINIMAP BUTTON
-- =============================================================
local MinimapButton = CreateFrame("Button", "MSC_MinimapButton", Minimap)
MinimapButton:SetSize(32, 32); MinimapButton:SetFrameStrata("MEDIUM"); MinimapButton:SetFrameLevel(8) 
MinimapButton.icon = MinimapButton:CreateTexture(nil, "BACKGROUND")
MinimapButton.icon:SetTexture("Interface\\Icons\\INV_Misc_Spyglass_02"); MinimapButton.icon:SetSize(20, 20); MinimapButton.icon:SetPoint("CENTER")
MinimapButton.border = MinimapButton:CreateTexture(nil, "OVERLAY")
MinimapButton.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder"); MinimapButton.border:SetSize(54, 54); MinimapButton.border:SetPoint("TOPLEFT")
MinimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

function MSC.UpdateMinimapPosition()
    if not SGJ_Settings then return end
    if SGJ_Settings.HideMinimap then MinimapButton:Hide(); return else MinimapButton:Show() end
    local angle = math.rad(SGJ_Settings.MinimapPos or 45)
    local x, y = math.cos(angle), math.sin(angle)
    MinimapButton:SetPoint("CENTER", Minimap, "CENTER", x * 80, y * 80)
end

MinimapButton:RegisterForClicks("AnyUp"); MinimapButton:RegisterForDrag("LeftButton")
MinimapButton:SetScript("OnDragStart", function(self) self:SetScript("OnUpdate", function(self) 
    local x, y = GetCursorPosition(); local scale = Minimap:GetEffectiveScale()
    local cx, cy = Minimap:GetCenter(); local dx, dy = (x / scale) - cx, (y / scale) - cy
    SGJ_Settings.MinimapPos = math.deg(math.atan2(dy, dx)); MSC.UpdateMinimapPosition() 
end) end)
MinimapButton:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
MinimapButton:SetScript("OnClick", function(self, button) 
    if button == "LeftButton" then if MSC.CreateLabFrame then MSC.CreateLabFrame() end else MSC.CreateOptionsFrame() end 
end)
MinimapButton:SetScript("OnEnter", function(self) 
    GameTooltip:SetOwner(self, "ANCHOR_LEFT"); GameTooltip:SetText("Sharpie's Gear Judge (TBC)")
    GameTooltip:AddLine("|cffffffffLeft-Click:|r Toggle Judge's Lab", 1, 1, 1)
    GameTooltip:AddLine("|cffffffffRight-Click:|r Toggle Settings", 1, 1, 1); GameTooltip:Show() 
end)
MinimapButton:SetScript("OnLeave", GameTooltip_Hide)


-- =============================================================
-- 2. OPTIONS MENU (With Warning Text)
-- =============================================================
function MSC.CreateOptionsFrame()
    if MyStatCompareFrame then 
        if MyStatCompareFrame:IsShown() then MyStatCompareFrame:Hide() else MyStatCompareFrame:Show() end
        return 
    end
    
    -- Main Window Setup
    local f = CreateFrame("Frame", "MyStatCompareFrame", UIParent, "BasicFrameTemplateWithInset, BackdropTemplate")
    f:SetSize(450, 480); f:SetPoint("CENTER") -- Increased Height slightly for new text
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); f.title:SetPoint("LEFT", f.TitleBg, "LEFT", 5, 0); f.title:SetText("Sharpie's Gear Judge Configuration")

    f.bg = f:CreateTexture(nil, "BACKGROUND", nil, 1) 
    f.bg:SetAllPoints(f)
    f.bg:SetColorTexture(0, 0, 0, 0.85)

    local _, class = UnitClass("player")
    if class then
        local fixed = class:sub(1,1) .. class:sub(2):lower()
        f.crest = f:CreateTexture(nil, "ARTWORK")
        f.crest:SetAllPoints(f)
        f.crest:SetTexture("Interface\\AddOns\\SharpiesGearJudge\\Textures\\" .. fixed .. ".tga")
        f.crest:SetVertexColor(0.6, 0.6, 0.6, 0.6) 
    end

    local function GetDisplayName(specKey)
        if specKey == "AUTO" or specKey == "Auto" then return "Auto-Detect" end
        if MSC.PrettyNames and MSC.PrettyNames[class] and MSC.PrettyNames[class][specKey] then
            return MSC.PrettyNames[class][specKey]
        end
        return specKey 
    end

    -- [[ WIDGET CREATORS ]]
    local function CreateHeader(text, relativeTo, yOffset)
        local h = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        h:SetText(text)
        if relativeTo then
             h:SetPoint("TOP", relativeTo, "BOTTOM", 0, yOffset or -20)
        else
             h:SetPoint("TOP", f, "TOP", 0, yOffset or -40)
        end
        return h
    end
    
    local function CreateDropdown(label, key, options, parentObj, yOffset)
        local container = CreateFrame("Frame", nil, f)
        container:SetSize(220, 50)
        container:SetPoint("TOP", parentObj, "BOTTOM", 0, yOffset or -10)

        local title = container:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        title:SetText(label)
        title:SetPoint("TOP", container, "TOP", 0, 0)
        
        local dd = CreateFrame("Frame", nil, container, "UIDropDownMenuTemplate")
        dd:SetPoint("TOP", title, "BOTTOM", 0, -2) 
        UIDropDownMenu_SetWidth(dd, 200) 
        dd:SetPoint("LEFT", container, "LEFT", -15, 0) 
        
        local function OnClick(self) 
            UIDropDownMenu_SetSelectedID(dd, self:GetID())
            SGJ_Settings[key] = self.value 
            if key == "Mode" then MSC.ManualSpec = self.value end
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

    local function CreateCheck(label, key, tooltip, parentObj, xOffset, yOffset)
        local cb = CreateFrame("CheckButton", nil, f, "ChatConfigCheckButtonTemplate")
        cb.Text:SetText(label)
        if key:find("Hide") then cb:SetChecked(not SGJ_Settings[key]) else cb:SetChecked(SGJ_Settings[key]) end
        
        cb:SetPoint("TOP", parentObj, "BOTTOM", xOffset, yOffset)
        
        cb:SetScript("OnClick", function(self) 
            if key:find("Hide") then SGJ_Settings[key] = not self:GetChecked() else SGJ_Settings[key] = self:GetChecked() end
            if key == "HideMinimap" then MSC.UpdateMinimapPosition() end
        end)
        
        if tooltip then
            cb:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(tooltip, nil, nil, nil, nil, true); GameTooltip:Show() end)
            cb:SetScript("OnLeave", GameTooltip_Hide)
        end
        return cb
    end


    -- =========================================================
    -- LAYOUT CONSTRUCTION
    -- =========================================================
    
    -- SECTION 1: PROJECTION LOGIC
    local header1 = CreateHeader("Projection Logic (TBC Features)", nil, -40)
    
    local dd1 = CreateDropdown("Enchant Comparisons:", "EnchantMode", {
        { text = "Off (Raw Stats Only)", val = 1 },
        { text = "Compare Current Enchants", val = 2 },
        { text = "Project Best Enchants (Sim)", val = 3 },
    }, header1, -10)
    
    local dd2 = CreateDropdown("Gem Socket Logic:", "GemMode", {
        { text = "Off (Empty Sockets = 0)", val = 1 },
        { text = "Compare Current Gems Only", val = 2 },
        { text = "Project Best (Match Colors)", val = 3 },
        { text = "Project Best (Smart Match)", val = 4 },
    }, dd1, -15) 

    -- [[ WARNING TEXT ADDITION ]]
    local warn = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    warn:SetPoint("TOP", dd2, "BOTTOM", 0, 5) -- Just below the dropdown
    warn:SetText("(Note: Does not track Meta Gem requirements)")
    warn:SetTextColor(0.6, 0.6, 0.6) -- Light Grey

    -- SECTION 2: PROFILE
    -- Pushed down to -35 to clear the warning text
    local header2 = CreateHeader("Character Profile", dd2, -35)
    
    local specOptions = { { text = "Auto-Detect", val = "AUTO" } }
    local function UpdateDropDownText()
        if not f.ProfileDD then return end
        if SGJ_Settings.Mode == "AUTO" or SGJ_Settings.Mode == "Auto" then
             local _, detectedKey = MSC.GetCurrentWeights()
             UIDropDownMenu_SetText(f.ProfileDD, "Auto: " .. GetDisplayName(detectedKey))
        else
             UIDropDownMenu_SetText(f.ProfileDD, "Manual: " .. GetDisplayName(SGJ_Settings.Mode))
        end
    end

    if MSC.WeightDB and MSC.WeightDB[class] then
        for k in pairs(MSC.WeightDB[class]) do 
            if k ~= "Default" then table.insert(specOptions, { text = GetDisplayName(k), val = k }) end 
        end
    end
    
    if MSC.LevelingWeightDB and MSC.LevelingWeightDB[class] then
        for k in pairs(MSC.LevelingWeightDB[class]) do 
            if k ~= "Default" then table.insert(specOptions, { text = GetDisplayName(k), val = k }) end 
        end
    end
    
    local dd3 = CreateDropdown("Scoring Profile:", "Mode", specOptions, header2, -10)


    -- SECTION 3: INTERFACE
    local header3 = CreateHeader("Interface Settings", dd3, -25)
    
    local cb1 = CreateCheck("Minimap Button", "HideMinimap", nil, header3, -110, -10)
    local cb2 = CreateCheck("Verdict in Tooltips", "HideTooltips", nil, header3, 10, -10)
    
    -- SECTION 4: BUTTONS
    local receiptBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    receiptBtn:SetSize(180, 30)
    receiptBtn:SetPoint("TOP", header3, "BOTTOM", -100, -45) -- Left Button
    receiptBtn:SetText("Show Gear Receipt")
    receiptBtn:SetScript("OnClick", function() 
        f:Hide()
        if MSC.ShowReceipt then MSC.ShowReceipt() else print("Core module not ready.") end
    end)
    
    local historyBtn = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    historyBtn:SetSize(180, 30)
    historyBtn:SetPoint("TOP", header3, "BOTTOM", 100, -45) -- Right Button
    historyBtn:SetText("View History")
    historyBtn:SetScript("OnClick", function() 
        f:Hide()
        if MSC.ShowHistory then MSC.ShowHistory() else print("Core module not ready.") end
    end)

    -- SECTION 5: CREDITS
    local credits = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    credits:SetPoint("BOTTOM", f, "BOTTOM", 0, 15)
    credits:SetTextColor(0.5, 0.5, 0.5, 1)
    credits:SetText("Author: SuperSharpie (v2.0.0 - TBC)")

    -- [[ ON SHOW REFRESH ]] --
    f:SetScript("OnShow", function(self)
        if MSC.BuildTalentCache then MSC:BuildTalentCache() end
        UpdateDropDownText()
    end)
end