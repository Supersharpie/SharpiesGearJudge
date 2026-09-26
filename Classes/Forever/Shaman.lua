local addonName, MSC = ...
local Shaman = {}
Shaman.Name = "SHAMAN"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
-- Strength/Attack Power/Weapon DPS/Agility calibrated to real conversion
-- math (see Paladin.lua for the base derivation). Enhancement Shaman uses
-- the same 1x Strength + 1x Agility melee-AP formula as Rogue/Hunter (not
-- Warrior/Paladin's Strength-only 2:1), so both are weighted near AP's own
-- value, with Agility carrying an added Crit/Dodge premium. Weapon DPS =
-- 14x AP's weight. Also restoring ELE_PVE/ENH_STORMSTRIKE/RESTO_DEEP's Spell
-- Crit (and ELE_PVE's Spell Power) to match their own sibling profiles --
-- these still carried the old "unknown crit math" hedge values that a prior
-- pass intended to fix but never actually landed in this file.
Shaman.Weights = {
    ["Default"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    -- ELE_PVE: Spell Hit 187.5 / Spell Crit 30 at Spell Power 15 -- 1% Hit =
    -- 12.5 Spell Power (the raid standard) and 1% Crit = 2 Spell Power before
    -- Elemental Fury.
    ["ELE_PVE"] = {  ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=187.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0  },
    ["ELE_PVP"] = {  ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["ENH_STORMSTRIKE"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["RESTO_DEEP"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8  },
    -- Healer Spell Crit 48 at Healing 20: 1% crit is worth ~2.4 Healing.
    ["RESTO_TOTEM_SUPPORT"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0, ["ITEM_MOD_SPIRIT_SHORT"]=5.0  },
    ["HYBRID_ELE_RESTO"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["HYBRID_ENH_RESTO"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=5.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Shaman.LevelingWeights = {
    -- Band ladder (Spirit/Mp5/Armor/Defense/school damage by level): see Warrior.lua's LevelingWeights.
    -- Strength/Agility/Weapon DPS corrected to the confirmed 1:1 Shaman
    -- melee-AP formula and 14:1 Weapon DPS:AP ratio (see comment above
    -- Shaman.Weights for the derivation).
    ["Leveling_1_10"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.7, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },
    ["Leveling_11_20"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.7, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },
    -- Brought up to match Leveling_1_10/11_20's convention (Hit/Crit/Attack
    -- Power were entirely absent -- zero weight, invisible to scoring; see
    -- Warrior.lua's leveling-bracket comment for the item-database evidence)
    ["Leveling_21_40"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.7, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },
    ["Leveling_41_51"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.7, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.25 },
    ["Leveling_52_59"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.1, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.7, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.1 },

    -- Caster/Healer: matched to ELE_PVP / RESTO_DEEP's own conventions (Spell
    -- Hit/Crit/Healing were absent or negligible -- a healer profile with no
    -- Spell Healing weight at all is a clear-cut gap regardless of scale).
    -- 11-20 healer adds Mp5 at RESTO_DEEP's Mp5:Healing ratio.
    ["Leveling_Healer_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0 },
    ["Leveling_Caster_11_20"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0 },
    ["Leveling_Caster_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0 },
    ["Leveling_Caster_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.75, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=40.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0 },
    ["Leveling_Caster_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=45.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_Healer_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0 },
    ["Leveling_Healer_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=4.8 },
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=4.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5 },

    -- Tank Shaman (no endgame tank profile exists to copy from -- added Hit
    -- and raised Weapon Skill to match the class's general DPS convention,
    -- since both were absent/low). Armor, Defense and Weapon DPS follow the
    -- band ladder in Warrior.lua's LevelingWeights; Intellect covers Earth
    -- Shock threat and self-heals.
    -- 11-20 adds Weapon DPS at half the DPS brackets' 14.0, since low-level
    -- threat comes almost entirely from weapon damage, and a low Defense
    -- weight (see Warrior.lua's Leveling_Tank_11_20 comment).
    ["Leveling_Tank_11_20"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.045, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=7.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.5 },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.06, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.6 },
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
    
    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_21_40"]      = "Leveling: Enhancement (21-40)",
    ["Leveling_41_51"]      = "Leveling: Enhancement (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Enh (52-59)",
    
    ["Leveling_Caster_11_20"] = "Leveling: Elemental (11-20)",
    ["Leveling_Caster_21_40"] = "Leveling: Elemental (21-40)",
    ["Leveling_Caster_41_51"] = "Leveling: Elemental (41-51)",
    ["Leveling_Caster_52_59"] = "Leveling: Elemental (52-59)",
    ["Leveling_Healer_11_20"] = "Leveling: Resto Dungeon (11-20)",
    ["Leveling_Healer_21_40"] = "Leveling: Resto Dungeon (21-40)",
    ["Leveling_Healer_41_51"] = "Leveling: Resto Dungeon (41-51)",
    ["Leveling_Healer_52_59"] = "Leveling: Resto Dungeon (52-59)",

    ["Leveling_Tank_11_20"]   = "Leveling: Tank Shaman (11-20)",
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
    ["ELEMENTAL_ALACRITY"]= "Elemental Alacrity", -- Elemental t3 (swapped with Elemental Fury, beta 2026-09-24)
    ["FLURRY"]            = "Flurry",
    ["RESTORATIVE_TOTEMS"]= "Restorative Totems",
    ["EYE_OF_STORM"]      = "Eye of the Storm",
    ["ANCESTRAL_KNOW"]    = "Ancestral Knowledge",
    ["TIDAL_FOCUS"]       = "Tidal Focus",
    ["ELEMENTAL_FURY"]    = "Elemental Fury", -- Elemental t6 (was t3 before the 2026-09-24 beta build)
    ["SPIRIT_WEAPONS"]    = "Spirit Weapons",
    ["ANTICIPATION"]      = "Anticipation",
    ["TIDAL_MASTERY"]     = "Tidal Mastery",
    ["TOUGHNESS"]         = "Toughness",
    ["MENTAL_DEXTERITY"]  = "Mental Dexterity",
    ["MENTAL_QUICKNESS"]  = "Mental Quickness",
    ["RAGE_FARSEER"]      = "Rage of the Farseer",
    ["WATER_SHIELD"]      = "Water Shield",
    ["CONCUSSION"]        = "Concussion", -- Elemental t1, 5 ranks, +1%/rank Lightning Bolt/Chain Lightning/Earth Shock damage
    ["PURIFICATION"]      = "Purification", -- Restoration t6, 5 ranks, +2%/rank universal healing (Same as Classic)
    ["HEALING_WAY"]       = "Healing Way", -- Restoration t5, 3 ranks, +8%/rank Healing Wave healing
    ["IMP_HEALING_WAVE"]  = "Improved Healing Wave", -- Restoration t1, 5 ranks
    ["MINDFULNESS"]       = "Mindfulness", -- New in Forever, Restoration t2, 3 ranks, mana regen while casting
    ["ANCESTRAL_HEALING"] = "Ancestral Healing", -- Restoration t3, 3 ranks
    ["HEALING_FOCUS"]     = "Healing Focus", -- Restoration t3, 3 ranks
    ["CONVECTION"]        = "Convection", -- Elemental t1, 5 ranks
    ["CALL_OF_FLAME"]     = "Call of Flame", -- Elemental t2, 3 ranks
    ["REVERBERATION"]     = "Reverberation", -- Elemental t2, 5 ranks
    ["ELEMENTAL_FOCUS"]   = "Elemental Focus", -- Elemental t3, 1 rank
}

-- Leveling role marker talents (see MSC:GetLowLevelRole). Anticipation (Enh
-- t3, +6% Dodge) is the only unambiguous tank talent (Toughness and Spirit
-- Weapons are Enhancement DPS picks too), so a tank Shaman is auto-detected
-- from level 19 -- pick the profile manually before that.
Shaman.LowLevelRoles = {
    Leveling_Tank   = { "ANTICIPATION" },
    Leveling_Healer = { "IMP_HEALING_WAVE", "TIDAL_MASTERY", "MINDFULNESS", "TIDAL_FOCUS", "ANCESTRAL_HEALING", "HEALING_FOCUS", "WATER_SHIELD" },
    Leveling_Caster = { "CONVECTION", "CONCUSSION", "CALL_OF_FLAME", "REVERBERATION", "ELEMENTAL_FOCUS", "ELEMENTAL_ALACRITY", "ELEMENTAL_FURY" },
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
        if level <= 10 then suffix = "_1_10"
        elseif level <= 20 then suffix = "_11_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        
        -- Detect Roles
        local role = "Leveling" -- Default Enh
        if Rank("SPIRIT_WEAPONS") > 0 then role = "Leveling_Tank"
        elseif Rank("ELEMENTAL_FURY") > 0 then role = "Leveling_Caster"
        elseif Rank("WATER_SHIELD") > 0 then role = "Leveling_Healer"
        elseif level > 10 then role = MSC:GetLowLevelRole(Shaman.LowLevelRoles) or role
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

    -- Elemental Fury (Elemental t6 since the 2026-09-24 beta build, 5 ranks): same phrasing/math as Mage's
    -- Arcane Mind -- relative growth of the crit damage bonus, 1+rank*0.20,
    -- reaching 2.0x at 5/5 (matches real Classic Elemental Fury exactly)
    local rEleFury = Rank("ELEMENTAL_FURY")
    if rEleFury > 0 and (currentSpec:find("ELE") or currentSpec:find("Caster")) and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rEleFury * 0.20))
    end

    -- Concussion (Elemental t1, 5 ranks): +1%/rank Lightning Bolt/Chain
    -- Lightning/Earth Shock damage -- the core Elemental rotation
    local rConcussion = Rank("CONCUSSION")
    if rConcussion > 0 and (currentSpec:find("ELE") or currentSpec:find("Caster")) and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
        weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rConcussion * 0.01))
    end

    -- Purification (Restoration t6, 5 ranks, Same as Classic): +2%/rank
    -- universal healing done
    local rPurify = Rank("PURIFICATION")
    if rPurify > 0 and (currentSpec:find("RESTO") or currentSpec:find("Healer")) and weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
        weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rPurify * 0.02))
    end

    -- Healing Way (Restoration t5, 3 ranks): +8%/rank Healing Wave healing --
    -- the dominant Resto heal, so treated like a broad healing-done scaler
    local rHealWay = Rank("HEALING_WAY")
    if rHealWay > 0 and (currentSpec:find("RESTO") or currentSpec:find("Healer")) and weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
        weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rHealWay * 0.08))
    end

    -- [[ 1. Nature's Guidance (Hit) ]]
    local hitBonus = Rank("TIDAL_FOCUS") -- 1% per rank
    
    -- Physical Hit Cap (Enhancement is dual-wield: taper toward the 28% white cap)
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use Shim
        local gearHit = MSC:GetPlayerStat("HIT")
        local newWeight, capped = MSC.ApplyForeverDualWieldHitTaper(weights["ITEM_MOD_HIT_RATING_SHORT"], gearHit + hitBonus, 9, 28)
        if capped then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = newWeight
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
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights)
end

function Shaman:GetRelicBonus(itemID, currentSpec)
    local bonus = {}
    if Shaman.Relics[itemID] then
        for k, v in pairs(Shaman.Relics[itemID]) do bonus[k] = v end
    end
    return bonus
end

-- =============================================================
-- TOTEMS
-- Wiped for the beta (2026-09-21): these were real TBC Totem item IDs. TBC
-- content isn't part of Forever, so this starts blank and repopulates
-- organically with confirmed Forever Totem IDs, same as the ProcDB/TrinketDB
-- cleanup above.
-- =============================================================
Shaman.Relics = {}

MSC.RegisterModule("SHAMAN", Shaman)


