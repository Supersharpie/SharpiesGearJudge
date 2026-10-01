local addonName, MSC = ...
local Paladin = {}
Paladin.Name = "PALADIN"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
Paladin.Weights = {
    -- Strength/Attack Power/Weapon DPS below are calibrated to real conversion
    -- math, not picked to "feel" right: 1 Strength = 2 Attack Power for a
    -- plate melee class (so Strength weight = 2x AP weight), and 14 Attack
    -- Power = 1 point of weapon DPS (bonus dmg/swing = AP/14*speed, so
    -- DPS = AP/14 once speed cancels out -- so DPS weight = 14x AP weight).
    -- Agility grants Paladins 0 Attack Power and only a very weak Crit
    -- conversion (~0.05%/point vs Crit Rating's ~1%/14), so it's subordinated
    -- to Strength/Crit here instead of matching their old, copied-from-a-
    -- melee-Agility-class magnitude.
    ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["HOLY_RAID"] = {  ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=10.0  },
    ["HOLY_DEEP"] = {  ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=10.0  },
    -- PROT_DEEP/PROT_AOE never weighted Strength or AP at all -- added at the
    -- same 2:1 ratio (2.5 instead of 2.2 to credit Strength's extra Block
    -- Value contribution for a shield-equipped Prot spec). Hit stays at 25.0
    -- unchanged -- its pre-cap front-loading is a deliberate threshold-based
    -- design, not part of this linear-conversion fix.
    -- Armor 0.075 (was 0.5): same raid armor math as Warrior's DEEP_PROT
    -- (see Warrior.lua).
    ["PROT_DEEP"] = {  ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0  },
    ["PROT_AOE"]  = {  ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0  },
    -- RET_STANDARD: AP sits at 1.5 here (not the 1.0 anchor), so Strength
    -- scales to 3.0 (2x) and Weapon DPS -- entirely missing before -- to 21.0
    -- (14x) to keep both ratios correct at this profile's own AP scale.
    ["RET_STANDARD"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=3.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["SHOCKADIN"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["RECK_BOMB"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=5.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
}

-- =============================================================
-- LEVELING LOGIC
-- =============================================================
Paladin.LevelingWeights = {
    -- Band ladder (Spirit/Mp5/Armor/Defense/school damage by level): see Warrior.lua's LevelingWeights.
    -- Strength/AP/Weapon DPS/Agility recalibrated to the real conversion math
    -- (2:1 Strength:AP, 14:1 DPS:AP, Agility subordinated -- see the Weights
    -- table comment above for the full derivation). Spirit/Intellect are left
    -- untouched on purpose: this file's own "Spirit is King" leveling
    -- philosophy (out-of-combat regen speed while soloing) is a deliberate
    -- design choice, not a math error, so it doesn't get the same treatment.
    -- Spirit still steps down at 41 and 52 with the band ladder (Warrior.lua's
    -- LevelingWeights), once mounts and longer fights cut solo downtime; Hit/
    -- Crit/Spell Power converge on RET_STANDARD by 52-59.
    ["Leveling_1_10"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.25, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.25, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.25, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=3.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.25, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=4.0, ["ITEM_MOD_HIT_RATING_SHORT"]=9.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=5.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.75 },
    ["Leveling_Ret_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.25, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=17.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0 },

    -- Healer/Tank leveling brackets have no early-level sibling to copy, so
    -- these add the stats that were entirely absent (Spell Healing for the
    -- healer; Hit and Defense Skill for the tank) at the same value their own
    -- endgame profile (HOLY_RAID / PROT_DEEP) already uses.
    -- 11-20 healer/tank: same shape as the 52-59 brackets below. The tank adds
    -- Weapon DPS at half the DPS brackets' 14.0 (low-level threat comes almost
    -- entirely from weapon damage) and weights Defense low -- see Warrior.lua's
    -- Leveling_Tank_11_20 comment. The healer adds Mp5 at HOLY_RAID's
    -- Mp5:Healing ratio.
    ["Leveling_Healer_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.9, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Tank_11_20"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.045, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=7.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },

    ["Leveling_Healer_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.9, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Healer_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.9, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.9, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0 },
    ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=6.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.3, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.6, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.06, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
    ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.3, ["ITEM_MOD_ARMOR_SHORT"]=0.075, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.6, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.6, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0 },
}

-- The Ret chain changes name at 52 (see MSC:GetLevelingRow's blend)
Paladin.LevelingNext = { ["Leveling_41_51"] = "Leveling_Ret_52_59" }

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Paladin.PrettyNames = {
    ["HOLY_RAID"]       = "Healer: Holy (Illumination)",
    ["HOLY_DEEP"]       = "Healer: Deep Holy (Buffs)",
    ["PROT_DEEP"]       = "Tank: Deep Protection",
    ["PROT_AOE"]        = "Farming: Protection AoE",
    ["RET_STANDARD"]    = "DPS: Retribution",
    ["SHOCKADIN"]       = "PvP: Shockadin (Burst)",
    ["RECK_BOMB"]       = "PvP: Reck-Bomb (One-Shot)",
    -- "RET_UTILITY" removed: GetSpec() used to route here but Paladin.Weights
    -- never defined a matching entry, so selecting it would have resolved to
    -- no weights at all. Folded into RET_STANDARD instead.

    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_Tank_11_20"] = "Leveling: Prot Tank (11-20)",
    ["Leveling_Healer_11_20"] = "Leveling: Holy Healer (11-20)",
    ["Leveling_21_40"]      = "Leveling: Retribution (21-40)",
    ["Leveling_41_51"]      = "Leveling: Retribution (41-51)",
    ["Leveling_Ret_52_59"]  = "Leveling: Pre-BiS Ret (52-59)",
    ["Leveling_Tank_21_40"] = "Leveling: Prot Tank (21-40)",
    ["Leveling_Tank_41_51"] = "Leveling: Prot Tank (41-51)",
    ["Leveling_Tank_52_59"] = "Leveling: Pre-BiS Prot (52-59)",
    ["Leveling_Healer_21_40"] = "Leveling: Holy Healer (21-40)",
    ["Leveling_Healer_41_51"] = "Leveling: Holy Healer (41-51)",
    ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Holy (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Paladin.Talents = {
    ["DIVINE_STR"]      = "Divine Strength",
    ["DIVINE_INT"]      = "Divine Intellect",
    ["HOLY_SHOCK"]      = "Holy Shock",
    ["ILLUMINATION"]    = "Illumination",
    ["HOLY_SHIELD"]     = "Holy Shield",
    ["RECKONING"]       = "Reckoning",
    ["SACRED_DUTY"]     = "Sacred Duty",
    ["REPENTANCE"]      = "Repentance",
    ["VENGEANCE"]       = "Vengeance",
    ["TOUGHNESS"]       = "Toughness",
    ["CHAMPION_LIGHT"]  = "Champion of the Light",
    ["PRECISION"]       = "Precision", -- Protection t2, 3 ranks, +1%/rank Hit
    ["HEALING_LIGHT"]   = "Healing Light", -- Holy t2, 3 ranks, +4%/rank Holy Light/FoL/Holy Shock healing
    ["REDOUBT"]         = "Redoubt", -- Protection t1, 5 ranks, block chance after being hit
    ["ANTICIPATION"]    = "Anticipation", -- Protection t2, 5 ranks, +20 Defense Skill
    ["IMP_RIGHTEOUS_FURY"] = "Improved Righteous Fury", -- Protection t3, 3 ranks
    ["SHIELD_SPEC"]     = "Shield Specialization", -- Protection t3, 3 ranks
    ["SPIRITUAL_FOCUS"] = "Spiritual Focus", -- Holy t2, 2 ranks, pushback protection on heals
    ["REVERENCE"]       = "Reverence", -- New in Forever, Holy t3, 3 ranks, mana regen while casting
    ["SEAL_OF_COMMAND"] = "Seal of Command", -- Retribution t3 (level 20), 1 rank
    ["TWOH_SPEC"]       = "Two-Handed Weapon Specialization", -- Retribution t5, 3 ranks, +2%/rank 2H damage
    ["ONE_HAND_SPEC"]   = "One-Handed Weapon Specialization", -- Protection t4, 3 ranks, +3%/rank 1H damage
    -- "Improved Blessing of Might" doesn't exist anywhere in Forever's Paladin
    -- talent/ability list (confirmed via wowforevertools.com/changes/paladin,
    -- direct search, all status filters). Its only use was a GetSpec() branch
    -- for HOLY_DEEP, whose weights are already identical to HOLY_RAID's, so
    -- removing it doesn't change any actual scoring -- just drops an unreachable
    -- profile-name distinction.
}

-- =============================================================
-- LOGIC
-- =============================================================
Paladin.ValidWeapons = {
    [0]=true, [1]=true,   -- 1H/2H Axes
    [4]=true, [5]=true,   -- 1H/2H Maces
    [7]=true, [8]=true,   -- 1H/2H Swords
    [6]=true              -- Polearms
}

-- Leveling role marker talents (see MSC:GetLowLevelRole). Divine Strength is
-- deliberately not a Holy marker -- it's the standard Ret leveling opener.
Paladin.LowLevelRoles = {
    Leveling_Tank   = { "TOUGHNESS", "REDOUBT", "ANTICIPATION", "IMP_RIGHTEOUS_FURY", "SHIELD_SPEC", "SACRED_DUTY" },
    Leveling_Healer = { "DIVINE_INT", "HEALING_LIGHT", "SPIRITUAL_FOCUS", "REVERENCE" },
}

function Paladin:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")

    -- Leveling Check First
    if level < 60 then
        -- Level 10 has its first talent point, so let roles apply from 10.
        if level < 10 then return "Leveling_1_10" end
        local suffix = (level <= 20 and "_11_20") or (level <= 40 and "_21_40") or (level <= 51 and "_41_51") or "_52_59"

        local role = MSC:GetLowLevelRole(Paladin.LowLevelRoles)
        if role and Paladin.LevelingWeights[role .. suffix] then return role .. suffix end
        if level == 10 then return "Leveling_1_10" end
        if suffix == "_52_59" then return "Leveling_Ret_52_59" end
        return "Leveling" .. suffix
    end

    -- Endgame Spec Detection
    if Rank("RECKONING") > 0 and Rank("VENGEANCE") > 0 then return "RECK_BOMB" end
    if Rank("REPENTANCE") > 0 then return "RET_STANDARD" end
    if Rank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
    if Rank("HOLY_SHOCK") > 0 and Rank("SACRED_DUTY") == 0 then return "SHOCKADIN" end
    if Rank("ILLUMINATION") > 0 and Rank("SACRED_DUTY") > 0 then return "HOLY_RAID" end
    return "HOLY_RAID"
end

function Paladin:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. Divine Strength (+10% Str) ]]
    local rStr = Rank("DIVINE_STR")
    if rStr > 0 and weights["ITEM_MOD_STRENGTH_SHORT"] then 
        weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) 
    end

    local rInt = Rank("DIVINE_INT")
    if rInt > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rInt * 0.02)) 
    end

    local rTough = Rank("TOUGHNESS")
    if rTough > 0 and weights["ITEM_MOD_ARMOR_SHORT"] then
        weights["ITEM_MOD_ARMOR_SHORT"] = weights["ITEM_MOD_ARMOR_SHORT"] * (1 + (rTough * 0.02))
    end

    local rSacred = Rank("SACRED_DUTY")
    if rSacred > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rSacred * 0.02))
    end

    local rChamp = Rank("CHAMPION_LIGHT")
    if rChamp > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] and (weights["ITEM_MOD_SPELL_POWER_SHORT"] or 0) > 0 then
        local spWeight = weights["ITEM_MOD_SPELL_POWER_SHORT"]
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + (spWeight * (rChamp * 0.11))
    end

    -- Healing Light (Holy t2, 3 ranks): +4%/rank healing from Holy Light /
    -- Flash of Light / Holy Shock -- raises Spell Healing's value for Holy specs
    -- (endgame HOLY_* and the Leveling_Healer_* brackets)
    local rHealLight = Rank("HEALING_LIGHT")
    if rHealLight > 0 and (currentSpec:find("HOLY") or currentSpec:find("Healer")) and weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
        weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rHealLight * 0.04))
    end

    -- [[ 1b. Leveling talent hooks (study: Paladin.txt) ]]
    local level = UnitLevel("player")
    local isLeveling = currentSpec:find("^Leveling") ~= nil
    local isHealerRow = currentSpec:find("^Leveling_Healer") ~= nil
    local isTankRow = currentSpec:find("^Leveling_Tank") ~= nil
    local isRetRow = isLeveling and not isHealerRow and not isTankRow

    -- Multiply a key when present; a weight left in (0, 0.02) is zeroed.
    local function Mul(k, m)
        local v = weights[k]
        if not v or m == 1 then return end
        v = v * m
        if v > 0 and v < 0.02 then v = 0 end
        weights[k] = v
    end
    local function MulAll(keys, m) for _, k in ipairs(keys) do Mul(k, m) end end

    if isRetRow then
        -- Seal of Command (Ret t3, level 20): without it the player stays on
        -- Seal of Righteousness, whose Holy damage is worth more than the
        -- anchor's Seal of Command model, and procs no longer crit.
        if level >= 20 and Rank("SEAL_OF_COMMAND") == 0 then
            MulAll({ "ITEM_MOD_SPELL_POWER_SHORT", "ITEM_MOD_SPELL_DAMAGE_DONE_SHORT", "ITEM_MOD_HOLY_DAMAGE_SHORT" }, 1.25)
            Mul("ITEM_MOD_CRIT_RATING_SHORT", 0.95)
            Mul("ITEM_MOD_AGILITY_SHORT", 0.96)
            Mul("ITEM_MOD_HIT_RATING_SHORT", 0.98)
        end

        -- Vengeance (Ret t5, level 30): +1%/rank damage per stack for 30 s after
        -- a crit, about +2.25% average per rank. A crit also starts the buff, so
        -- crit gains a further 2%/rank; Agility gets the crit part by its share.
        local rVeng = Rank("VENGEANCE")
        if rVeng > 0 and level >= 30 then
            local dmg = 1 + 0.0225 * rVeng
            MulAll({ "ITEM_MOD_ATTACK_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
                     "MSC_WEAPON_DPS_MELEE", "ITEM_MOD_SPELL_POWER_SHORT", "ITEM_MOD_SPELL_DAMAGE_DONE_SHORT",
                     "ITEM_MOD_HOLY_DAMAGE_SHORT", "MSC_WEAPON_SPEED" }, dmg)
            Mul("ITEM_MOD_CRIT_RATING_SHORT", dmg * (1 + 0.02 * rVeng))
            local critShare = (level >= 45) and 0.90 or 0.85
            Mul("ITEM_MOD_AGILITY_SHORT", 1 + 0.0225 * rVeng + 0.02 * rVeng * critShare)
        end

        -- Two-Handed Weapon Specialization (Ret t5, level 30): +2%/rank damage
        -- with a two-hander, about 1.3%/rank of total damage.
        local rTwoH = Rank("TWOH_SPEC")
        if rTwoH > 0 then
            local link = GetInventoryItemLink("player", 16)
            local equipLoc = link and select(9, GetItemInfo(link))
            if equipLoc == "INVTYPE_2HWEAPON" then
                MulAll({ "ITEM_MOD_ATTACK_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
                         "MSC_WEAPON_DPS_MELEE", "MSC_WEAPON_SPEED" }, 1 + 0.013 * rTwoH)
            end
        end
    end

    if isHealerRow then
        -- Healing Light also raises the value of mana, regen and crit equally
        -- with healing power: scale their group-side share to match.
        local rHL = Rank("HEALING_LIGHT")
        if rHL > 0 then
            MulAll({ "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT",
                     "ITEM_MOD_SPELL_CRIT_RATING_SHORT" }, 1 + 0.032 * rHL)
        end

        -- Illumination (Holy t4, 5 ranks), relative to the ranks baked into the
        -- anchors: 0 at 20, 1 at 25, 5 from 30.
        local bIll = MSC.ForeverLevelLerp({ {20, 0}, {25, 1}, {30, 5} }, level)
        local rIll = Rank("ILLUMINATION")
        Mul("ITEM_MOD_SPELL_CRIT_RATING_SHORT", (0.61 + 0.39 * rIll / 5) / (0.61 + 0.39 * bIll / 5))
        Mul("ITEM_MOD_INTELLECT_SHORT", (0.91 + 0.09 * rIll / 5) / (0.91 + 0.09 * bIll / 5))

        -- Reverence (Holy t3, 3 ranks): Spirit regenerates in combat only through
        -- it. Baked ranks: 0 at 15, 1 at 20, 3 from 25. Intellect's mana part is
        -- worth about 4% more per missing rank from 40.
        local bRev = MSC.ForeverLevelLerp({ {15, 0}, {20, 1}, {25, 3} }, level)
        local rRev = Rank("REVERENCE")
        Mul("ITEM_MOD_SPIRIT_SHORT", (0.30 + 0.07 * rRev) / (0.30 + 0.07 * bRev))
        if level >= 40 then Mul("ITEM_MOD_INTELLECT_SHORT", 1 + 0.04 * (bRev - rRev)) end
    end

    if isTankRow then
        -- Shield Specialization (Prot t3, 3 ranks): anchors bake rank 1 at 20 and
        -- rank 3 from 25; scale by the real rank. Block Value is the absorb part,
        -- Intellect and Mp5 the mana-proc part. The block-rating part is handled
        -- in section 2b.
        local rSS = Rank("SHIELD_SPEC")
        if level >= 20 then
            Mul("ITEM_MOD_BLOCK_VALUE_SHORT", (1 + 0.10 * rSS) / 1.3)
            local intLow, intHigh = 0.74 + 0.086 * rSS, 0.66 + 0.113 * rSS
            Mul("ITEM_MOD_INTELLECT_SHORT", MSC.ForeverLevelLerp({ {35, intLow}, {40, intHigh} }, level))
            if level >= 25 and level <= 35 then
                Mul("ITEM_MOD_MANA_REGENERATION_SHORT", 1.2 - 0.067 * rSS)
            end
        end

        -- Holy Shield (Prot t7, level 40): without it Block Value is worth far
        -- less and mana use is lower.
        if level >= 40 and Rank("HOLY_SHIELD") == 0 then
            Mul("ITEM_MOD_BLOCK_VALUE_SHORT", 0.42)
            Mul("ITEM_MOD_INTELLECT_SHORT", 0.62)
            MulAll({ "ITEM_MOD_DODGE_RATING_SHORT", "ITEM_MOD_PARRY_RATING_SHORT", "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
                     "ITEM_MOD_BLOCK_RATING_SHORT" }, 0.94)
        end

        -- Redoubt (Prot t1, 5 ranks): +2.34% block chance per rank, against a
        -- baked Block Value base of 0.05 below 40 and 0.11 from 40.
        local rRed = Rank("REDOUBT")
        if rRed > 0 then
            Mul("ITEM_MOD_BLOCK_VALUE_SHORT", 1 + ((level >= 40) and 0.21 or 0.47) * rRed)
        end

        -- One-Handed Weapon Specialization (Prot t4, level 25): +3%/rank 1H
        -- damage on the physical share of tank damage.
        local rOneH = Rank("ONE_HAND_SPEC")
        if rOneH > 0 then
            local per = MSC.ForeverLevelLerp({ {40, 0.017}, {45, 0.012} }, level)
            MulAll({ "ITEM_MOD_ATTACK_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
                     "MSC_WEAPON_DPS_MELEE" }, 1 + per * rOneH)
        end
    end

    -- [[ 2. Hit Cap ]]
    -- Hit % includes Precision once (MSC:GetForeverHitPercent); the target is
    -- the level's cap, sliding to the raid cap from 50. Past it Hit keeps 10%
    -- of its value, the same as every other class.
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_RATING_SHORT", "MELEE", 0.1, "Hit", activeCaps)

    -- [[ 2b. Block for leveling tanks: Shield Specialization ]]
    -- Client data: only rank 3 of Shield Specialization makes blocks restore
    -- 6% of max mana, at a 100% chance (once per 3 sec). The talent text's
    -- "33%" is a third per rank. The leveling tank rows priced block as its
    -- survival value (about 0.6 x Dodge, like other tanks) plus a mana part
    -- hedged to two-thirds for that "33%". So with 3/3 the mana part counts in
    -- full (x1.5), and without rank 3 block is worth its survival value only.
    if currentSpec:find("^Leveling_Tank") then
        local block = weights["ITEM_MOD_BLOCK_RATING_SHORT"]
        local dodge = weights["ITEM_MOD_DODGE_RATING_SHORT"] or 0
        if block and block > 0 and dodge > 0 then
            local survival = math.min(block, 0.6 * dodge)
            if Rank("SHIELD_SPEC") >= 3 then
                weights["ITEM_MOD_BLOCK_RATING_SHORT"] = survival + (block - survival) * 1.5
            else
                weights["ITEM_MOD_BLOCK_RATING_SHORT"] = survival
            end
        end
    end

    -- [[ 3. Tank caps: defense toward 440, uncrushable (from 50) ]]
    if currentSpec:find("PROT") or currentSpec:find("Tank") then
        MSC.ApplyForeverDefenseTarget(weights, activeCaps)
        -- Holy Shield (talent): +20% block chance while active
        MSC.ApplyForeverUncrushable(weights, (Rank("HOLY_SHIELD") > 0) and 20 or 0, activeCaps)
    end
    
    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Paladin:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
end

function Paladin:GetRelicBonus(itemID, currentSpec)
    return MSC.GetForeverRelicBonus(Paladin.Relics, itemID, currentSpec)
end

-- =============================================================
-- LIBRAMS
-- Wiped for the beta (2026-09-21): these were real TBC Libram item IDs. TBC
-- content isn't part of Forever, so this starts blank and repopulates
-- organically with confirmed Forever Libram IDs, same as the ProcDB/TrinketDB
-- cleanup above.
-- =============================================================
-- Forever librams as equivalent stats per spec (MSC.GetForeverRelicBonus).
-- role: "melee" (Retribution), "tank", "healer". Small cooldown/damage
-- effects are estimates for the spec that uses them.
Paladin.Relics = {
    -- Tenets of the Silver Hand: +1% damage vs Undead. About a quarter of
    -- leveling kills are Undead, and weapon damage is about 2x AP-worth for
    -- a leveling Ret: ~0.25% of damage = 0.0075 x AP.
    [249397] = function(role, ctx) return (role ~= "healer") and { ITEM_MOD_ATTACK_POWER_SHORT = 0.0075 * ctx.ap } or {} end,
    -- Libram of Invocation: Seal mana cost -5% (a Seal every ~30 sec)
    [249442] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "healer") and 0.3 or 0.7 } end,
    -- Sentinel's Libram: Swift Judgement cooldown -10 sec
    [272434] = function(role) return (role == "melee") and { ITEM_MOD_ATTACK_POWER_SHORT = 6 } or {} end,
    -- Libram of Law: Judgement damage +4% (~10% of a Ret's damage; half
    -- that value as threat for a tank)
    [272435] = function(role, ctx)
        if role == "melee" then return { ITEM_MOD_ATTACK_POWER_SHORT = 0.012 * ctx.ap } end
        if role == "tank" then return { ITEM_MOD_ATTACK_POWER_SHORT = 0.006 * ctx.ap } end
        return {}
    end,
    -- Libram of Economy: Holy Light mana cost -5%
    [272436] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "healer") and 10 or 1 } end,
    -- Steadfast Libram: shield Block Value +30% while Holy Shield is up (~80%)
    [279247] = function(role, ctx)
        if role ~= "tank" or MSC:GetTalentRank("HOLY_SHIELD") <= 0 then return {} end
        return { ITEM_MOD_BLOCK_VALUE_SHORT = 0.24 * ctx.shieldBlock }
    end,
    -- Libram of Infusion: Holy Shock crit +6%
    [279248] = function(role)
        if MSC:GetTalentRank("HOLY_SHOCK") <= 0 then return {} end
        if role == "healer" then return { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 12 } end
        return { ITEM_MOD_SPELL_POWER_SHORT = 10 }
    end,

    -- Unchanged Classic librams (Wowhead Classic data). Single-spell bonuses
    -- count at that spell's share of the spec's healing/damage/mana use.
    -- Libram of Truth: Devotion Aura +55 armor (tanks run it; others often don't)
    [22400] = function(role) return { ITEM_MOD_ARMOR_SHORT = (role == "tank") and 55 or 25 } end,
    -- Libram of Hope: Seal spells cost 20 less (a Seal every ~30 sec)
    [22401] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "healer") and 1 or 3.3 } end,
    -- Libram of Grace: Cleanse costs 25 less
    [22402] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "healer") and 1 or 0.3 } end,
    -- Libram of Light: Flash of Light heals up to 83 more (~60% of healing)
    [23006] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 50 } or {} end,
    -- Libram of Divinity (both IDs): Flash of Light heals up to 53 more
    [23201] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 32 } or {} end,
    [23202] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 32 } or {} end,
    -- Libram of Fervor: Seal of the Crusader +48 AP and Judgement of the
    -- Crusader +33 Holy damage (only while running that Seal)
    [23203] = function(role)
        if role == "melee" then return { ITEM_MOD_ATTACK_POWER_SHORT = 30 } end
        if role == "tank" then return { ITEM_MOD_ATTACK_POWER_SHORT = 10 } end
        return {}
    end,
}

-- Register Profiles for UI
Paladin.Profiles = {}
for k, v in pairs(Paladin.Weights) do Paladin.Profiles[k] = v end
for k, v in pairs(Paladin.LevelingWeights) do Paladin.Profiles[k] = v end

MSC.RegisterModule("PALADIN", Paladin)



