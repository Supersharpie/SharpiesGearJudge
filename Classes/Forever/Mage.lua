local addonName, MSC = ...
local Mage = {}
Mage.Name = "MAGE"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
Mage.Weights = {
    ["Default"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_MANA_SHORT"]=0.02, ["ITEM_MOD_STAMINA_SHORT"]=0.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0  },
    ["FIRE_RAID"] = {  ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0  },
    ["FROST_AP"] = {  ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0  },
    ["FROST_WC"] = {  ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0  },
    ["FROST_AOE"] = {  ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0  },
    ["POM_PYRO"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["ELEMENTAL"] = {  ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["FROST_PVP"] = {  ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0  },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Mage.LevelingWeights = {
    -- Frost (ST)
    ["Leveling_1_10"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0  },
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0  },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },

    -- Fire Leveling
    ["Leveling_Fire_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },
    ["Leveling_Fire_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },
    ["Leveling_Fire_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },

    -- AoE Grinding
    ["Leveling_AoE_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },
    ["Leveling_AoE_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },
    ["Leveling_AoE_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Mage.PrettyNames = {
    ["FIRE_RAID"]       = "Raid: Deep Fire (Combustion)",
    ["FROST_AP"]        = "Raid: Frost (Arcane Power)",
    ["FROST_WC"]        = "Raid: Frost (Winter's Chill)",
    ["POM_PYRO"]        = "PvP: PoM Pyro (3-Min Mage)",
    ["ELEMENTAL"]       = "PvP: Elemental (Shatter)",
    ["FROST_PVP"]       = "PvP: Deep Frost",
    ["FROST_AOE"]       = "Farming: Frost AoE",
    
    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_21_40"]      = "Leveling: Frost/Fire ST (21-40)",
    ["Leveling_41_51"]      = "Leveling: Frost/Fire ST (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Mage (52-59)",
    
    ["Leveling_AoE_21_40"]  = "Leveling: AoE Grinding (21-40)",
    ["Leveling_AoE_41_51"]  = "Leveling: AoE Grinding (41-51)",
    ["Leveling_AoE_52_59"]  = "Leveling: AoE Grinding (52-59)",
    
    ["Leveling_Fire_21_40"] = "Leveling: Fire (21-40)",
    ["Leveling_Fire_41_51"] = "Leveling: Fire (41-51)",
    ["Leveling_Fire_52_59"] = "Leveling: Fire (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Mage.Talents = { 
    ["ARCANE_POWER"]    = "Arcane Power",
    ["PRESENCE_OF_MIND"]= "Presence of Mind",
    ["COMBUSTION"]      = "Combustion",
    ["BLAST_WAVE"]      = "Blast Wave",
    ["PYROBLAST"]       = "Pyroblast",
    ["ICE_BARRIER"]     = "Ice Barrier",
    ["WINTERS_CHILL"]   = "Winter's Chill",
    ["IMP_BLIZZARD"]    = "Improved Blizzard",
    ["PERMAFROST"]      = "Permafrost",
    ["ARCANE_MIND"]     = "Arcane Mind",
    ["IGNITE"]          = "Ignite",
    ["ICE_SHARDS"]      = "Ice Shards",
    ["ELE_PRECISION"]   = "Elemental Precision",
    ["ARCANE_FOCUS"]    = "Arcane Focus",
}

-- =============================================================
-- LOGIC
-- =============================================================
Mage.ValidWeapons = {
    [7]=true,             -- 1H Swords
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

function Mage:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 10 then suffix = "_1_10"
        elseif level <= 20 then suffix = "_11_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        
        local role = "Leveling" -- Default
        if Rank("IMP_BLIZZARD") >= 2 then role = "Leveling_AoE"
        elseif Rank("IGNITE") >= 3 then role = "Leveling_Fire"
        end

        local key = role .. suffix
        if Mage.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("COMBUSTION") > 0 then return "FIRE_RAID" end
    if Rank("ARCANE_POWER") > 0 and Rank("ICE_SHARDS") > 0 then return "FROST_AP" end
    if Rank("WINTERS_CHILL") > 0 then return "FROST_WC" end
    if Rank("PRESENCE_OF_MIND") > 0 and Rank("PYROBLAST") > 0 then return "POM_PYRO" end
    if Rank("BLAST_WAVE") > 0 and Rank("ICE_SHARDS") > 0 then return "ELEMENTAL" end
    if Rank("IMP_BLIZZARD") == 3 and Rank("PERMAFROST") > 0 then return "FROST_AOE" end
    if Rank("ICE_BARRIER") > 0 then return "FROST_PVP" end
    return "FROST_AP"
end

function Mage:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. Arcane Mind (+10% Int) ]]
    local rAR = Rank("ARCANE_RESILIENCE")
    if rAR > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_ARMOR_SHORT"] or 0) > 0 then
        -- Assume 25% per rank
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (weights["ITEM_MOD_ARMOR_SHORT"] * (rAR * 0.25))
    end
    
    local rAM = Rank("ARCANE_MIND")
    if rAM > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAM * 0.02)) 
    end
    
    -- [[ 2. Covariance (SP -> Crit) ]]
    if weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        -- FIX: Use MSC.SanitizeStat(GetSpellBonusDamage(2)) via shim ideally, but for now we shim via manual GetSpellBonusDamage call if needed
        -- Note: Era API returns number directly.
        local sp = MSC.SanitizeStat(GetSpellBonusDamage(3)) -- 3=Frost
        if sp > 400 then
            local spScaler = 1 + ((sp - 400) / 4000)
            weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * spScaler
        end
    end

    -- [[ 3. Hit Cap ]]
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        -- FIX: Use Shim
        local currentHit = MSC:GetPlayerStat("SPELL_HIT") 
        local talentHit = 0
        if currentSpec:find("FIRE") or currentSpec:find("FROST") then
            talentHit = Rank("ELE_PRECISION") * 1
        end
        
        local totalHit = currentHit + talentHit
        if totalHit >= 16 then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0 
            table.insert(activeCaps, "Hit (16%)")
        end
    end
    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Mage:GetWeaponBonus(itemLink, weights)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights)
end

MSC.RegisterModule("MAGE", Mage)



