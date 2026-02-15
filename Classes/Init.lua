local addonName, MSC = ...
_G[addonName] = MSC 

-- =============================================================
-- 0. GAME VERSION DETECTION
-- =============================================================
local _, _, _, interfaceVersion = GetBuildInfo()
MSC.IsEra   = (interfaceVersion < 20000)
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