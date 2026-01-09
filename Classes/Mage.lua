local addonName, MSC = ...
local Mage = {}
Mage.Name = "MAGE"
-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Mage.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
        ["MSC_WEAPON_DPS"]=0.02 -- Safe value
    },

    -- [[ 1. ARCANE (Mana Battery / Burst) ]]
    ["ARCANE_RAID"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.2, -- King Stat
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.7, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.6, -- Arcane Meditation
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 2. FIRE (Crit / Ignite) ]]
    ["FIRE_RAID"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.95, -- Ignite
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 3. FROST PVE (Safe DPS) ]]
    ["FROST_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]     = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.6, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.5, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 4. FROST PVP ]]
    ["FROST_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]     = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.6, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 5. FROST AOE ]]
    ["FROST_AOE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.5, -- Mana Pool
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]     = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.1, -- Blizzard doesn't crit
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.1, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Mage.LevelingWeights = {
    -- [[ 1. STANDARD FROST (Single Target) ]]
    ["Leveling_1_20"] = { 
        ["MSC_WEAPON_DPS"]=1.5, -- Wanding is vital
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_21_40"] = { 
        ["MSC_WEAPON_DPS"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_41_51"] = { 
        ["MSC_WEAPON_DPS"]=0.6, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.2,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.1, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },

    -- [[ 2. FIRE LEVELING ]]
    ["Leveling_Fire_21_40"] = { 
        ["MSC_WEAPON_DPS"]=1.0,
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Fire_41_51"] = { 
        ["MSC_WEAPON_DPS"]=0.5,
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Fire_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.2,
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.8, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Fire_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.1,
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },

    -- [[ 3. AOE BLIZZARD LEVELING ]]
    ["Leveling_AoE_21_40"] = { 
        ["MSC_WEAPON_DPS"]=0.1, 
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_AoE_41_51"] = { 
        ["MSC_WEAPON_DPS"]=0.1,
        ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_AoE_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.1,
        ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=2.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, 
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_AoE_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.1,
        ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=2.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Mage.Specs = { [1]="Arcane", [2]="Fire", [3]="Frost" }

Mage.PrettyNames = {
    ["FIRE_RAID"]       = "Raid: Deep Fire",
    ["ARCANE_RAID"]     = "Raid: Arcane (Mind Mastery)",
    ["FROST_PVE"]       = "Raid: Deep Frost",
    ["FROST_PVP"]       = "PvP: Frost",
    ["FROST_AOE"]       = "Farming: AoE Blizzard",
	-- Leveling Brackets
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
    
    ["Leveling_Fire_21_40"] = "Fire (21-40)",
    ["Leveling_Fire_41_51"] = "Fire (41-51)",
    ["Leveling_Fire_52_59"] = "Fire (52-59)",
    ["Leveling_Fire_60_70"] = "Fire (Outland)",
    
    ["Leveling_AoE_21_40"] = "Frost AoE Grind (21-40)",
    ["Leveling_AoE_41_51"] = "Frost AoE Grind (41-51)",
    ["Leveling_AoE_52_59"] = "Frost AoE Grind (52-59)",
    ["Leveling_AoE_60_70"] = "Frost AoE Grind (Outland)",
}

Mage.SpeedChecks = { 
    ["Default"]={} 
}

Mage.ValidWeapons = {
    [7]=true, [10]=true, [15]=true, [19]=true -- 1H Sword, Staff, Dagger, Wand
}

Mage.StatToCritMatrix = { 
    Agi = { {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 59.5}, {70, 80.0} } 
}

Mage.Talents = { 
    ["ELEMENTAL_PRECISION"] = "Elemental Precision",
    ["ARCANE_POWER"]    ="Arcane Power", 
    ["SLOW"]            ="Slow", 
    ["COMBUSTION"]      ="Combustion", 
    ["DRAGONS_BREATH"]  ="Dragon's Breath", 
    ["ICE_BARRIER"]     ="Ice Barrier", 
    ["SUMMON_WELE"]     ="Summon Water Elemental", 
    ["WINTERS_CHILL"]   ="Winter's Chill", 
    ["IMP_BLIZZARD"]    ="Improved Blizzard", 
    ["ARCANE_MIND"]     ="Arcane Mind", 
    ["MOLTEN_ARMOR"]    ="Molten Armor", 
    ["ICY_VEINS"]       ="Icy Veins",
    ["ARCANE_FOCUS"]    ="Arcane Focus" -- Added
}

-- =============================================================
-- LOGIC
-- =============================================================
function Mage:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("DRAGONS_BREATH") > 0 or Rank("COMBUSTION") > 0 then return "FIRE_RAID" end
        if Rank("SLOW") > 0 or Rank("ARCANE_POWER") > 0 then return "ARCANE_RAID" end
        if Rank("SUMMON_WELE") > 0 or Rank("ICE_BARRIER") > 0 then
            if Rank("IMP_BLIZZARD") > 0 and Rank("WINTERS_CHILL") == 0 then return "FROST_AOE" end
            if Rank("WINTERS_CHILL") > 0 then return "FROST_PVE" end
            return "FROST_PVP"
        end
        return "FROST_PVP"
    end

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("IMP_BLIZZARD") >= 2 then role = "Leveling_AoE"
    elseif Rank("DRAGONS_BREATH") > 0 or Rank("COMBUSTION") > 0 then role = "Leveling_Fire"
    end 

    local specificKey = role .. suffix
    if Mage.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Mage:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- 1. Arcane Mind (Int -> SP/Mana)
    local rMind = Rank("ARCANE_MIND")
    if rMind > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rMind * 0.03)) 
    end
    
    -- 2. Hit Cap (16% / 202 Rating)
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(8) -- Spell Hit
        local baseCap = 202 
        local talentBonus = 0
        
        if currentSpec:find("ARCANE") then
            -- Arcane Focus: 2% per rank (Max 10%)
            talentBonus = Rank("ARCANE_FOCUS") * 25.2 
        elseif currentSpec:find("FIRE") or currentSpec:find("FROST") then
            -- Elemental Precision: 1% per rank (Max 3%)
            talentBonus = Rank("ELEMENTAL_PRECISION") * 12.6
        end
        
        if hitRating >= (baseCap - talentBonus + 5) then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02
            table.insert(activeCaps, "Hit")
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Mage:GetWeaponBonus(itemLink) return 0 end

MSC.RegisterModule("MAGE", Mage)