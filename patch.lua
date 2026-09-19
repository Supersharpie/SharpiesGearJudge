local f = io.open("Interface.lua", "r")
local content = f:read("*all")
f:close()

local newFunc = [[
local function CreateLootSideTooltip(parent)
    local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    f:SetSize(320, 80)
    f:SetPoint("LEFT", parent, "RIGHT", 5, 0)
    f:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    f:SetBackdropColor(0, 0, 0, 0.9)
    f:SetBackdropBorderColor(1, 0.82, 0, 1)

    f.TopText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.TopText:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -12)
    f.TopText:SetText(MSC.L["Click to compare with your items."])
    f.TopText:SetTextColor(1, 1, 1)

    f.SpecText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.SpecText:SetPoint("TOPLEFT", f.TopText, "BOTTOMLEFT", 0, -8)

    f.CompareText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.CompareText:SetPoint("TOPLEFT", f.SpecText, "BOTTOMLEFT", 15, -6)
    f.CompareText:SetWidth(280)
    f.CompareText:SetJustifyH("LEFT")
    f.CompareText:SetWordWrap(true)
    
    local arrow = f:CreateTexture(nil, "OVERLAY")
    arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
    arrow:SetPoint("RIGHT", f, "LEFT", 8, 0)
    arrow:SetSize(24, 24)
    arrow:SetVertexColor(1, 0.82, 0)
    if arrow.SetRotation then arrow:SetRotation(math.pi) end
    
    return f
end

function MSC.UpdateLootRollOverlays()
    if SGJ_Settings and SGJ_Settings.ShowLootArrows == false then 
        for i = 1, NUM_GROUP_LOOT_FRAMES or 4 do
            local frame = _G["GroupLootFrame" .. i]
            if frame and frame.SGJ_SideTooltip then frame.SGJ_SideTooltip:Hide() end
            local iconFrame = _G["GroupLootFrame" .. i .. "IconFrame"]
            if iconFrame and iconFrame.SGJ_OverlayFrame then iconFrame.SGJ_OverlayFrame:Hide() end
        end
        return 
    end

    local weights, specName = MSC.GetCurrentWeights()
    if not weights then return end

    for i = 1, NUM_GROUP_LOOT_FRAMES or 4 do
        local frame = _G["GroupLootFrame" .. i]
        
        if frame and frame:IsShown() then
            local rollID = frame.rollID
            local iconFrame = _G["GroupLootFrame" .. i .. "IconFrame"]

            if rollID and iconFrame then
                if frame.SGJ_SideTooltip then frame.SGJ_SideTooltip:Hide() end
                if iconFrame.SGJ_OverlayFrame then iconFrame.SGJ_OverlayFrame:Hide() end

                local link = GetLootRollItemLink(rollID)
                if link then
                    local overlayType = nil
                    local itemName, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
                    
                    local finalWeights, finalSpec, finalSlot, finalOldLink, finalNewScore, finalOldScore = weights, specName, nil, nil, 0, 0
                    local isOffSpec = false
                    
                    if itemName and equipLoc and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP" then
                        if MSC.IsItemUsable(link) then
                            -- Check Main Spec
                            local slotID = MSC.GetComparisonSlot(link, equipLoc, weights, specName)
                            if slotID then
                                local newScore, oldScore = MSC:EvaluateUpgrade(link, slotID, weights, specName)
                                finalSlot = slotID
                                finalNewScore = newScore or 0
                                finalOldScore = oldScore or 0
                                finalOldLink = GetInventoryItemLink("player", slotID)
                                
                                if (finalNewScore > (finalOldScore + 0.01)) then
                                    overlayType = "UP"
                                elseif (finalOldScore > (finalNewScore + 0.01)) then
                                    overlayType = "DOWN"
                                end
                                
                                -- If not an upgrade for Main Spec, check Tracked Off-Specs
                                if overlayType ~= "UP" and SGJ_Settings.TrackedSpecs then
                                    local playerKey = MSC:GetPlayerKey()
                                    for tSpec, isActive in pairs(SGJ_Settings.TrackedSpecs) do
                                        if isActive and tSpec ~= specName then
                                            local tWeights = MSC.GetWeightsByName(tSpec)
                                            if tWeights then
                                                local baselineGear = nil
                                                if SGJ_Settings.GearProfiles and SGJ_Settings.GearProfiles[playerKey] then
                                                    baselineGear = SGJ_Settings.GearProfiles[playerKey][tSpec]
                                                end
                                                
                                                local tSlotID = MSC.GetComparisonSlot(link, equipLoc, tWeights, tSpec, baselineGear)
                                                if tSlotID then
                                                    local tNew, tOld = MSC:EvaluateUpgrade(link, tSlotID, tWeights, tSpec, baselineGear)
                                                    if tNew and tOld and (tNew > (tOld + 0.01)) then
                                                        -- We found an off-spec upgrade! Override everything.
                                                        overlayType = "UP"
                                                        isOffSpec = true
                                                        finalSpec = tSpec
                                                        finalNewScore = tNew
                                                        finalOldScore = tOld
                                                        finalWeights = tWeights
                                                        finalSlot = tSlotID
                                                        finalOldLink = baselineGear and baselineGear[tSlotID] or GetInventoryItemLink("player", tSlotID)
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    if overlayType then
                        if not frame.SGJ_SideTooltip then
                            frame.SGJ_SideTooltip = CreateLootSideTooltip(frame)
                        end
                        
                        local percentDiff = 0
                        if finalOldScore > 0 then percentDiff = ((finalNewScore - finalOldScore) / finalOldScore) * 100 end
                        
                        local prettySpec = (MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[finalSpec]) or finalSpec
                        local tex = overlayType == "UP" and "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Upgrade.png:14:14:0:-2|t" or "|TInterface\\AddOns\\SharpiesGearJudge\\Textures\\Downgrade.png:14:14:0:-2|t"
                        local colorHex = overlayType == "UP" and "00ff00" or "ff0000"
                        local sign = overlayType == "UP" and "+" or ""
                        local word = overlayType == "UP" and "upgrade" or "downgrade"
                        
                        if overlayType == "UP" then
                            if isOffSpec then
                                frame.SGJ_SideTooltip.TopText:SetText(MSC.L["Recommended Roll: |cff00ccffGREED (Off-Spec)|r"])
                            else
                                frame.SGJ_SideTooltip.TopText:SetText(MSC.L["Recommended Roll: |cff00ff00NEED|r"])
                            end
                        else
                            frame.SGJ_SideTooltip.TopText:SetText(MSC.L["Recommended Roll: |cff888888GREED / PASS|r"])
                        end

                        if finalOldScore > 0 then
                            frame.SGJ_SideTooltip.SpecText:SetText(string.format("|cffcc88ff%s:|r %s |cff%s%s%.0f%% %s|r", prettySpec, tex, colorHex, sign, percentDiff, word))
                        else
                            frame.SGJ_SideTooltip.SpecText:SetText(string.format("|cffcc88ff%s:|r %s |cff%s%s (New)|r", prettySpec, tex, colorHex, word))
                        end
                        
                        frame.SGJ_SideTooltip.CompareText:SetText(string.format("|cffffffffvs.|r %s", finalOldLink or MSC.L["Empty Slot"]))
                        
                        frame.SGJ_SideTooltip:Show()
                    end
                end
            end
        end
    end
end
]]

local pattern = "function MSC%.UpdateLootRollOverlays%(%).-end\r?\nend\r?\n"
local count
content, count = string.gsub(content, "function MSC%.UpdateLootRollOverlays%(%).-end%s*end%s*end%s*end", newFunc, 1)

f = io.open("Interface.lua", "w")
f:write(content)
f:close()
