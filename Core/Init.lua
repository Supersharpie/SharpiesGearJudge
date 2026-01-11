local addonName, MSC = ...

-- 1. Initialize the Namespace
MSC.CurrentClass = nil
-- Do NOT initialize MSC.PrettyNames here if you want it to be class-specific

-- 2. Define the Module Registration Function
function MSC.RegisterModule(className, classTable)
    local _, playerClass = UnitClass("player")
    
    -- Force uppercase comparison to be safe
    if className:upper() == playerClass:upper() then
        MSC.CurrentClass = classTable
        -- This is the missing link! 
        -- We need to copy the class's profiles into the main list
        if classTable.Profiles then
            for name, weights in pairs(classTable.Profiles) do
                MSC.ClassProfiles[name] = weights
            end
        end
        print("|cff00ff00Sharpie's Gear Judge:|r Loaded " .. className)
    end
end