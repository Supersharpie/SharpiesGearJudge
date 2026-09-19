local addonName, MSC = ...
local Shaman = {}
Shaman.Name = "SHAMAN"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
Shaman.Weights = {
    ["Default"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=10.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["ELE_PVE"] = {  ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0  },
    ["ELE_PVP"] = {  ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["ENH_STORMSTRIKE"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["RESTO_DEEP"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8  },
    ["RESTO_TOTEM_SUPPORT"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=5.0  },
    ["HYBRID_ELE_RESTO"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["HYBRID_ENH_RESTO"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=5.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Shaman.LevelingWeights = {
    ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=15.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=10.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=13.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    
    ["Leveling_Caster_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0  },
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05,  ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8  },
    
    -- Tank Shaman
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Shaman.PrettyNames = {
    ["ELE_PVE"]             = "DPS: Elemental (PvE)",
    ["ELE_PVP"]             = "PvP: Elemental (Burst)",
    ["RESTO_DEEP"]          = "Healer: Deep Restoration",
    ["RESTO_TOTEM_SUPPORT"] = "Healer: Totem Twisting",
    ["ENH_STORMSTRIKE"]     = "DPS: Enhancement",
    ["HYBRID_ELE_RESTO"]    = "Hybrid: Ele / Resto (NS)",
    ["HYBRID_ENH_RESTO"]    = "Hybrid: Enh / Resto (PvP)",
    
    ["Leveling_1_20"]       = "Leveling (1-20)",
    ["Leveling_21_40"]      = "Leveling: Enhancement (21-40)",
    ["Leveling_41_51"]      = "Leveling: Enhancement (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Enh (52-59)",
    
    ["Leveling_Caster_52_59"] = "Leveling: Elemental (52-59)",
    ["Leveling_Healer_52_59"] = "Leveling: Resto Dungeon (52-59)",
    
    ["Leveling_Tank_21_40"]   = "Leveling: Tank Shaman (21-40)",
    ["Leveling_Tank_41_51"]   = "Leveling: Tank Shaman (41-51)",
    ["Leveling_Tank_52_59"]   = "Leveling: Tank Shaman (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Shaman.Talents = { 
    ["LAVA_BURST"]        = "Lava Burst",
    ["STORMSTRIKE"]       = "Stormstrike",
    ["RIPTIDE"]           = "Riptide",
    ["NATURES_SWIFTNESS"] = "Nature's Swiftness",
    ["ELEMENTAL_ALACRITY"]= "Elemental Alacrity",
    ["FLURRY"]            = "Flurry",
    ["RESTORATIVE_TOTEMS"]= "Restorative Totems",
    ["EYE_OF_STORM"]      = "Eye of the Storm",
    ["ANCESTRAL_KNOW"]    = "Ancestral Knowledge",
    ["TIDAL_FOCUS"]       = "Tidal Focus",
    ["ELEMENTAL_FURY"]    = "Elemental Fury",
    ["SPIRIT_WEAPONS"]    = "Spirit Weapons",
    ["ANTICIPATION"]      = "Anticipation",
    ["TIDAL_MASTERY"]     = "Tidal Mastery",
    ["TOUGHNESS"]         = "Toughness",
    ["MENTAL_DEXTERITY"]  = "Mental Dexterity",
    ["MENTAL_QUICKNESS"]  = "Mental Quickness",
    ["RAGE_FARSEER"]      = "Rage of the Farseer",
    ["WATER_SHIELD"]      = "Water Shield",
}

-- =============================================================
-- LOGIC
-- =============================================================
Shaman.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes (2H via Talent)
    [4]=true, [5]=true,   -- 1H/2H Maces (2H via Talent)
    [10]=true,            -- Staves
    [13]=true, [15]=true, -- Fists, Daggers
    [6]=true              -- Shields (Technically Armor, but useful to track context)
}

function Shaman:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        
        -- Detect Roles
        local role = "Leveling" -- Default Enh
        if Rank("SPIRIT_WEAPONS") > 0 then role = "Leveling_Tank"
        elseif Rank("ELEMENTAL_FURY") > 0 then role = "Leveling_Caster"
        elseif Rank("WATER_SHIELD") > 0 then role = "Leveling_Healer"
        end
        
        local key = role .. suffix
        if Shaman.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("LAVA_BURST") > 0 then 
        if Rank("EYE_OF_STORM") > 0 then return "ELE_PVP" end
        return "ELE_PVE" 
    end
    if Rank("RIPTIDE") > 0 then return "RESTO_DEEP" end
    if Rank("RAGE_FARSEER") > 0 then return "ENH_STORMSTRIKE" end
    if Rank("NATURES_SWIFTNESS") > 0 and Rank("ELEMENTAL_ALACRITY") > 0 then return "HYBRID_ELE_RESTO" end
    if Rank("NATURES_SWIFTNESS") > 0 and Rank("FLURRY") > 0 then return "HYBRID_ENH_RESTO" end
    if Rank("RESTORATIVE_TOTEMS") > 0 and Rank("TIDAL_MASTERY") > 0 then return "RESTO_TOTEM_SUPPORT" end
    return "RESTO_DEEP"
end

function Shaman:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    local rAK = Rank("ANCESTRAL_KNOW")
    if rAK > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAK * 0.02))
    end

    local rTough = Rank("TOUGHNESS")
    if rTough > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rTough * 0.02))
    end

    local rMD = Rank("MENTAL_DEXTERITY")
    if rMD > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 0) > 0 then
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (rMD * 0.11))
    end

    local rMQ = Rank("MENTAL_QUICKNESS")
    if rMQ > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then
        local spWeight = weights["ITEM_MOD_SPELL_POWER_SHORT"] or weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] or weights["ITEM_MOD_SPELL_DAMAGE_DONE_SHORT"] or 0
        if spWeight > 0 then
            weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (spWeight * (rMQ * 0.075))
        end
    end

    -- [[ 1. Nature's Guidance (Hit) ]]
    local hitBonus = Rank("TIDAL_FOCUS") -- 1% per rank
    
    -- Physical Hit Cap
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use Shim
        local gearHit = MSC:GetPlayerStat("HIT")
        if (gearHit + hitBonus) >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 
            table.insert(activeCaps, "Phys Hit (9%)")
        end
    end

    -- Spell Hit Cap
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        -- FIX: Use Shim
        local gearSpellHit = MSC:GetPlayerStat("SPELL_HIT")
        if (gearSpellHit + hitBonus) >= 16 then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0
            table.insert(activeCaps, "Spell Hit (16%)")
        end
    end

    -- [[ 2. Weapon Skill Cap (Removed in Forever) ]]
    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Shaman:GetWeaponBonus(itemLink, weights)
    return 0
end

-- =============================================================
-- CLASS SPECIFIC ITEMS (ERA TOTEMS)
-- =============================================================
Shaman.Relics = {
    [22395] = { ITEM_MOD_SPELL_POWER_SHORT = 30 }, -- Totem of Iskar
    [23200] = { ITEM_MOD_MANA_REGENERATION_SHORT = 4 }, -- Totem of Sustaining
    [22394] = { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 80 }, -- Totem of Rebirth
    [23199] = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 33, estimate = true }, -- Totem of the Storm
    [22397] = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 20, estimate = true }, -- Totem of Rage
}

MSC.RegisterModule("SHAMAN", Shaman)
