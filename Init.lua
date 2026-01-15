local addonName, MSC = ...
_G[addonName] = MSC -- Expose to global if needed for debugging

-- =============================================================
-- 0. GAME VERSION DETECTION (The "Shim" Foundation)
-- =============================================================
local _, _, _, interfaceVersion = GetBuildInfo()

-- Classic Era is 1.x.x (Interface < 20000)
-- TBC Classic is 2.x.x (Interface 20000 - 29999)
-- Wrath Classic is 3.x.x (Interface 30000+)
MSC.IsEra   = (interfaceVersion < 20000)
MSC.IsTBC   = (interfaceVersion >= 20000 and interfaceVersion < 30000)
MSC.IsWrath = (interfaceVersion >= 30000)

-- =============================================================
-- 1. Initialize the Namespace
-- =============================================================
MSC.CurrentClass = nil
MSC.ClassProfiles = {}
MSC.PrettyNames = {} -- Ensure this table exists before RegisterModule tries to add to it

-- =============================================================
-- 2. Define the Module Registration Function
-- =============================================================
function MSC.RegisterModule(className, classTable)
    local _, playerClass = UnitClass("player")
    
    -- Force uppercase comparison to be safe
    if className:upper() == playerClass:upper() then
        MSC.CurrentClass = classTable
        
        -- Copy Profiles
        if classTable.Profiles then
            for name, weights in pairs(classTable.Profiles) do
                MSC.ClassProfiles[name] = weights
            end
        end

        -- This ensures the UI shows "Raid: Beast Mastery" instead of "RAID_BM"
        if classTable.PrettyNames and MSC.PrettyNames then
            for key, niceName in pairs(classTable.PrettyNames) do
                MSC.PrettyNames[key] = niceName
            end
        end
        
       
        print("|cff00ff00Sharpie's Gear Judge:|r Loaded " .. className)
    end
end