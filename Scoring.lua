local _, MSC = ...

-- =============================================================
-- 1. SCORE CALCULATOR
-- =============================================================
function MSC.GetItemScore(stats, weights, specName, slotId)
    if not stats or not weights then return 0 end
    local score = 0
    for stat, val in pairs(stats) do
        if weights[stat] then score = score + (val * weights[stat]) end
    end
    
    -- Speed Logic
    if stats.MSC_WEAPON_SPEED and MSC.SpeedChecks then
        local _, class = UnitClass("player")
        local cleanSpec = specName:gsub(" %(.*%)", "") 
        local pref = MSC.SpeedChecks[class] and (MSC.SpeedChecks[class][cleanSpec] or MSC.SpeedChecks[class]["Default"])
        if pref then
            local speed = stats.MSC_WEAPON_SPEED
            local bonus = 20
            if slotId == 16 then
                if pref.MH_Slow and speed >= 2.6 then score = score + bonus end
                if pref.MH_Fast and speed <= 1.6 then score = score + bonus end
            end
            if slotId == 17 then
                if pref.OH_Fast and speed <= 1.7 then score = score + bonus end
                if pref.OH_Slow and speed >= 2.4 then score = score + bonus end
            end
            if slotId == 18 and pref.Ranged_Slow and speed >= 2.8 then score = score + bonus end
        end
    end
    return score
end

-- =============================================================
-- 2. DERIVED STATS (Racial Logic Fixed with IDs)
-- =============================================================
function MSC.ExpandDerivedStats(stats, itemLink)
    if not stats then return {} end
    local out = {}
    for k, v in pairs(stats) do out[k] = v end
    local _, class = UnitClass("player")
    local _, race = UnitRace("player")
    local powerType = UnitPowerType("player") 
    
    -- RACIAL WEAPON SKILL (Now checks numeric ID)
    if itemLink and MSC.RacialTraits and MSC.RacialTraits[race] then
        -- GetItemInfo returns: name, link, quality, ilvl, minLevel, type, subType, stackCount, equipLoc, texture, sellPrice, classID, subclassID
        local _, _, _, _, _, _, _, _, _, _, _, _, subclassID = GetItemInfo(itemLink)
        
        if subclassID and MSC.RacialTraits[race][subclassID] then
            local bonus = MSC.RacialTraits[race][subclassID]
            out["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = (out["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] or 0) + bonus
        end
    end

    if out["ITEM_MOD_STAMINA_SHORT"] then out["ITEM_MOD_HEALTH_SHORT"] = (out["ITEM_MOD_HEALTH_SHORT"] or 0) + (out["ITEM_MOD_STAMINA_SHORT"] * 10) end
    if powerType == 0 and out["ITEM_MOD_INTELLECT_SHORT"] then out["ITEM_MOD_MANA_SHORT"] = (out["ITEM_MOD_MANA_SHORT"] or 0) + (out["ITEM_MOD_INTELLECT_SHORT"] * 15) end
    
    local isPhysical = (class == "WARRIOR" or class == "PALADIN" or class == "SHAMAN" or class == "DRUID" or class == "HUNTER" or class == "ROGUE")
    if isPhysical then
        local str, agi, ap = out["ITEM_MOD_STRENGTH_SHORT"] or 0, out["ITEM_MOD_AGILITY_SHORT"] or 0, out["ITEM_MOD_ATTACK_POWER_SHORT"] or 0
        if class == "HUNTER" or class == "ROGUE" then ap = ap + str + agi else ap = ap + (str * 2) end
        if ap > 0 then out["ITEM_MOD_ATTACK_POWER_SHORT"] = ap end
    end
    if class == "HUNTER" then
        local rap, agi = out["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] or 0, out["ITEM_MOD_AGILITY_SHORT"] or 0
        rap = rap + (agi * 2); if rap > 0 then out["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = rap end
    end
    return out
end