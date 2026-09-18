function MSC_GetTooltipItem(tooltip)
    if not tooltip then return nil, nil end
    if tooltip.GetItem then return tooltip:GetItem() end
    if TooltipUtil and TooltipUtil.GetDisplayedItem then return TooltipUtil.GetDisplayedItem(tooltip) end
    if tooltip.processingInfo and tooltip.processingInfo.tooltipData and tooltip.processingInfo.tooltipData.hyperlink then
        return nil, tooltip.processingInfo.tooltipData.hyperlink
    end
    return nil, nil
end
-- Polyfill for WoW 11.0+ engine API removals
if C_Item then
    if not GetItemInfoInstant and C_Item.GetItemInfoInstant then _G.GetItemInfoInstant = function(id) return C_Item.GetItemInfoInstant(id) end end
    if not IsEquippableItem and C_Item.IsEquippableItem then _G.IsEquippableItem = function(id) return C_Item.IsEquippableItem(id) end end
    if not GetItemInfo and C_Item.GetItemInfo then _G.GetItemInfo = function(id) return C_Item.GetItemInfo(id) end end
    if not GetItemIcon and C_Item.GetItemIconByID then _G.GetItemIcon = function(id) return C_Item.GetItemIconByID(id) end end
end
local addonName, MSC = ...
_G[addonName] = MSC 

-- =============================================================
-- 0. GAME VERSION DETECTION
-- =============================================================
local _, _, _, interfaceVersion = GetBuildInfo()
local GetMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local addonTitle = GetMetadata(addonName, "Title") or ""
MSC.IsForever = (string.find(addonTitle, "Forever Edition") ~= nil)
MSC.IsEra   = (interfaceVersion < 20000) and not MSC.IsForever
MSC.IsVanillaRules = MSC.IsEra or MSC.IsForever
MSC.IsTBC   = (interfaceVersion >= 20000 and interfaceVersion < 30000)
MSC.IsWrath = (interfaceVersion >= 30000)

-- =============================================================
-- 1. Initialize the Namespace
-- =============================================================
MSC.CurrentClass = nil
MSC.ClassProfiles = {}
MSC.PrettyNames = {} 
MSC.PendingModules = {} -- Storage for modules waiting for player login

-- =============================================================
-- 2. Define the Module Registration Function
-- =============================================================
function MSC.RegisterModule(className, classTable)
    -- Store them all. We don't know who we are yet.
    MSC.PendingModules[className] = classTable
end

-- =============================================================
-- 3. THE FORCE INIT FUNCTION
-- =============================================================
function MSC:ForceInit()
    if MSC.CurrentClass then return end
    
    local _, playerClass = UnitClass("player")
    if not playerClass then return end

    -- Find the correct module
    for className, classTable in pairs(MSC.PendingModules) do
        if className:upper() == playerClass:upper() then
            MSC.CurrentClass = classTable
            
            if classTable.Profiles then
                for name, weights in pairs(classTable.Profiles) do
                    MSC.ClassProfiles[name] = weights
                end
            end

            if classTable.PrettyNames and MSC.PrettyNames then
                for key, niceName in pairs(classTable.PrettyNames) do
                    MSC.PrettyNames[key] = niceName
                end
            end
            
            print(string.format(MSC.L["|cff00ff00Sharpie's Gear Judge:|r Loaded %s"], className))
            break 
        end
    end
    
    -- If we found it, clear the pending list to save RAM
    if MSC.CurrentClass then
        MSC.PendingModules = nil 
    end
end

-- =============================================================
-- 4. Auto-Loader (Safe Fallback)
-- =============================================================
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
    MSC:ForceInit()
end)
