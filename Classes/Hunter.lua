local addonName, MSC = ...
local Hunter = {}
Hunter.Name = "HUNTER"

-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Hunter.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.3, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.9, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.4,
        ["MSC_WEAPON_DPS"]=1.5 
    },

    -- [[ 1. BEAST MASTERY ]]
    ["RAID_BM"] = { 
        ["MSC_WEAPON_DPS"]                  = 2.0, -- Pet scales off dmg
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, -- Cap #1
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.9, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]= 1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3, -- Go for the Throat
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.3, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 2. SURVIVAL ]]
    ["RAID_SURV"] = { 
        ["MSC_WEAPON_DPS"]                  = 1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 3.0, -- KING STAT (Expose Weakness)
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.1, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 0.6, 
        ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]= 0.6,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.6, -- Thrill of the Hunt
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.2,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },

    -- [[ 3. MARKSMANSHIP ]]
    ["RAID_MM"] = { 
        ["MSC_WEAPON_DPS"]                  = 2.2, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]= 1.0,
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.5, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.5, 
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },

    -- [[ 4. PVP ]]
    ["PVP_MM"] = { 
        ["MSC_WEAPON_DPS"]                  = 1.5,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.5, 
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Hunter.LevelingWeights = {
    -- [[ 1. STANDARD RANGED ]]
    ["Leveling_1_20"] = { 
        ["MSC_WEAPON_DPS"]=2.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_21_40"] = { 
        ["MSC_WEAPON_DPS"]=1.8,
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.3, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_41_51"] = { 
        ["MSC_WEAPON_DPS"]=1.8,
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.3,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02
    },
    ["Leveling_52_59"] = { 
        ["MSC_WEAPON_DPS"]=1.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.4, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02
    },
    ["Leveling_60_70"] = { 
        ["MSC_WEAPON_DPS"]=1.5,
        ["ITEM_MOD_AGILITY_SHORT"]=2.6, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=0.4,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02
    },

    -- [[ 2. MELEE HUNTER (For the brave) ]]
    ["Leveling_Melee_21_40"] = { 
        ["MSC_WEAPON_DPS"]=5.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_PARRY_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.2,
        ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=0.5
    },
    ["Leveling_Melee_41_51"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.2 
    },
    ["Leveling_Melee_52_59"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.2 
    },
    ["Leveling_Melee_60_70"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.2 
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Hunter.Specs = { [1]="BeastMastery", [2]="Marksmanship", [3]="Survival" }

Hunter.PrettyNames = {
    ["RAID_BM"]          = "Raid: Beast Mastery",
    ["RAID_SURV"]        = "Raid: Survival (Expose Weakness)",
    ["RAID_MM"]          = "Raid: Marksmanship",
    ["PVP_MM"]           = "PvP: Marksmanship",
    -- Leveling Brackets
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
    ["Leveling_Melee_21_40"] = "Survival Melee (21-40)",
    ["Leveling_Melee_41_51"] = "Survival Melee (41-51)",
    ["Leveling_Melee_52_59"] = "Survival Melee (52-59)",
    ["Leveling_Melee_60_70"] = "Survival Melee (Outland)",
}

Hunter.SpeedChecks = { 
    ["Default"]={ Ranged_Slow=true } 
}

Hunter.ValidWeapons = {
    [0]=true, [1]=true,   -- Axes
    [7]=true, [8]=true,   -- Swords
    [6]=true, [10]=true,  -- Polearm, Staff
    [13]=true, [15]=true, -- Fist, Dagger
    [2]=true, [3]=true, [18]=true, [16]=true, -- Bow, Gun, Xbow, Thrown
}

Hunter.StatToCritMatrix = { 
    Agi = { {1, 4.5}, {60, 53.0}, {70, 40.0} } 
}

Hunter.Talents = { 
    ["SUREFOOTED"] = "Surefooted",
    ["BESTIAL_WRATH"]="Bestial Wrath", 
    ["BEAST_WITHIN"]="The Beast Within", 
    ["TRUESHOT_AURA"]="Trueshot Aura", 
    ["SILENCING_SHOT"]="Silencing Shot", 
    ["SCATTER_SHOT"]="Scatter Shot", 
    ["WYVERN_STING"]="Wyvern Sting", 
    ["READYNESS"]="Readiness", 
    ["EXPOSE_WEAKNESS"]="Expose Weakness", 
    ["CAREFUL_AIM"]="Careful Aim", 
    ["SURVIVAL_INST"]="Survival Instincts" 
}

-- =============================================================
-- LOGIC
-- =============================================================
function Hunter:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("BEAST_WITHIN") > 0 or Rank("BESTIAL_WRATH") > 0 then return "RAID_BM" end
        if Rank("EXPOSE_WEAKNESS") > 0 or Rank("WYVERN_STING") > 0 then return "RAID_SURV" end
        if Rank("TRUESHOT_AURA") > 0 or Rank("SILENCING_SHOT") > 0 then
            if Rank("SURVIVAL_INST") > 0 then return "PVP_MM" end
            return "RAID_MM"
        end
        return "RAID_BM"
    end

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("SURVIVAL_INST") > 0 and Rank("WYVERN_STING") == 0 then role = "Leveling_Melee" end 

    local specificKey = role .. suffix
    if Hunter.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Hunter:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- [[ 1. EXISTING SCALERS ]]
    -- Expose Weakness (Agi Scaling)
    if Rank("EXPOSE_WEAKNESS") > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then 
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * 1.2 
    end
    
    -- Careful Aim (Int -> RAP)
    -- Converts 45% of Int to Ranged AP
    local rCare = Rank("CAREFUL_AIM")
    if rCare > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then
        -- 1 Int gives 1 RAP (approx value for this calculation)
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + 0.45
    end
    
   -- [[ 2. COVARIANCE (Crit scales with AP) ]]
    if weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        local base, pos, neg = UnitAttackPower("player")
        local totalAP = base + pos + neg
        
        -- Hunters scale well with AP.
        -- If AP > 1000, boost Crit value up to 15%
        if totalAP > 1000 then
            local apScaler = 1 + ((totalAP - 1000) / 20000)
            if apScaler > 1.15 then apScaler = 1.15 end
            weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * apScaler
        end
    end

    -- [[ 3. HIT CAP (FIXED: Uses Ranged Hit 7, not Melee 6) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        -- FIX: GetCombatRating(7) is Ranged Hit. (6 is Melee Hit)
        local hitRating = GetCombatRating(7) 
        local baseCap = 142 -- 9%
        
        -- Surefooted (Survival): 1% Hit per rank
        local talentBonus = Rank("SUREFOOTED") * 15.8 
        
        local finalCap = baseCap - talentBonus
        
        -- Check Draenei Racial
        local _, race = UnitRace("player")
        if race == "Draenei" then finalCap = finalCap - 15.8 end
        
        if finalCap < 0 then finalCap = 0 end

        -- Hysteresis Buffer
        if hitRating >= (finalCap + 15) then
            -- Safely Capped
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.5 
            table.insert(activeCaps, "Hit")
        elseif hitRating >= finalCap then
            -- Soft Cap Zone
            weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * 0.7
            table.insert(activeCaps, "Hit (Soft)")
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Hunter:GetWeaponBonus(itemLink) 
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Racial: Troll (Bow) / Dwarf (Gun) (+1% Crit ~ 35 rating score equivalent)
    if race == "Dwarf" and subClassID == 3 then bonus = bonus + 35 end
    if race == "Troll" and subClassID == 2 then bonus = bonus + 35 end
    
    return bonus
end

MSC.RegisterModule("HUNTER", Hunter)