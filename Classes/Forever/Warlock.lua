local addonName, MSC = ...
local Warlock = {}
Warlock.Name = "WARLOCK"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
-- NOTE: In Era Helpers.lua, 1.0 Rating = 1% Hit/Crit. 
-- We use standard keys so the Evaluator can match them.

Warlock.Weights = {
    ["Default"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.1, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0  },
    -- Raid Spell Crit: 1% crit is worth 2 Spell Power before Ruin doubles it
    -- in ApplyScalers -- 4.0 on the Spell Power 2.0 profiles below, 30.0 on
    -- PVE_MD_RUIN's Spell Power 15.0 scale (the old 1.5 / 12.0 made it
    -- 0.75-0.8 Spell Power). PVE_MD_RUIN's Spell Hit 187.5 matches the raid
    -- profiles' 1% Hit = 12.5 Spell Power.
    ["RAID_DS_RUIN"] = {  ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=4.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0  },
    ["RAID_SM_RUIN"] = {  ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=4.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0  },
    ["PVE_MD_RUIN"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=187.5, ["ITEM_MOD_STAMINA_SHORT"]=0.3, ["ITEM_MOD_INTELLECT_SHORT"]=5.0  },
    ["PVP_NF_CONFLAG"] = {  ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["PVP_SOUL_LINK"] = {  ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0  },
    ["PVP_DEEP_DESTRO"] = {  ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=5.0  },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Warlock.LevelingWeights = {
    -- Band ladder (Spirit/Mp5/Armor/Defense/school damage by level): see Warrior.lua's LevelingWeights.
    -- Unlike every other class's file, Warlock's own Leveling_1_10/11_20 never
    -- had Spell Power/Hit/Crit weighted at all -- so there's no established
    -- leveling convention in this file to copy. All brackets below are fixed
    -- to match the endgame Default profile's convention instead (SPELL_POWER
    -- 15.0, HIT_SPELL 20.0, SPELL_CRIT 12.0); see Warrior.lua's leveling-
    -- bracket comment for the item-database evidence on why this can't wait
    -- until higher levels.
    ["Leveling_1_10"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
    ["Leveling_21_40"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=40.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=45.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },

    -- Fire. 11-20 rows: the Affliction 11-20 row with each spec's
    -- school-damage split from its 21-40 row.
    ["Leveling_Fire_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=10.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
    ["Leveling_Fire_21_40"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=10.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
    ["Leveling_Fire_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=40.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=10.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_Fire_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=45.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=10.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },

    -- Demo
    ["Leveling_Demo_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
    ["Leveling_Demo_21_40"] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
    ["Leveling_Demo_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=40.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_Demo_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=45.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Warlock.PrettyNames = {
    ["RAID_DS_RUIN"]    = "Raid: Destruction (DS/Ruin)",
    ["RAID_SM_RUIN"]    = "Raid: Affliction (SM/Ruin)",
    ["PVE_MD_RUIN"]     = "Raid: Master Demonologist",
    ["PVP_NF_CONFLAG"]  = "PvP: Nightfall / Conflagrate",
    ["PVP_SOUL_LINK"]   = "PvP: Soul Link (Tank)",
    ["PVP_DEEP_DESTRO"] = "PvP: Destruction (Conflag)",
    
    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_21_40"]      = "Leveling: Affliction (21-40)",
    ["Leveling_41_51"]      = "Leveling: Affliction (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Affliction (52-59)",
    
    ["Leveling_Fire_11_20"] = "Leveling: Destruction (11-20)",
    ["Leveling_Fire_21_40"] = "Leveling: Destruction (21-40)",
    ["Leveling_Fire_41_51"] = "Leveling: Destruction (41-51)",
    ["Leveling_Fire_52_59"] = "Leveling: Destruction (52-59)",
    
    ["Leveling_Demo_11_20"] = "Leveling: Demonology (11-20)",
    ["Leveling_Demo_21_40"] = "Leveling: Demonology (21-40)",
    ["Leveling_Demo_41_51"] = "Leveling: Demonology (41-51)",
    ["Leveling_Demo_52_59"] = "Leveling: Demonology (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Warlock.Talents = { 
    ["DEMONIC_SACRIFICE"] = "Demonic Sacrifice",
    ["SHADOW_MASTERY"]    = "Shadow Mastery",
    ["RUIN"]              = "Ruin",
    ["SOUL_LINK"]         = "Soul Link",
    ["CONFLAGRATE"]       = "Conflagrate",
    ["INCINERATE"]        = "Incinerate",
    ["DEMONIC_PACT"]      = "Demonic Pact",
    ["FEL_CONCENTRATION"] = "Fel Concentration",
    ["NIGHTFALL"]         = "Nightfall",
    ["INTENSITY"]         = "Intensity",
    ["MASTER_DEMON"]      = "Master Demonologist",
    ["SUPPRESSION"]       = "Suppression",
    ["DEMONIC_EMBRACE"]   = "Demonic Embrace",
    ["MALEDICTION"]       = "Malediction", -- New in Forever, Affliction t2, 5 ranks, +1%/rank periodic damage
    ["PANDEMIC"]          = "Pandemic", -- New in Forever, Affliction t3, 3 ranks, +33%/rank crit damage bonus on DoTs (now that DoTs crit)
    ["AGONIZING_FLAMES"]  = "Agonizing Flames", -- New in Forever, Destruction t4, 3 ranks, +3%/rank Destruction spell damage
    -- Leveling role markers (tiers 1-3, see Warlock.LowLevelRoles)
    ["IMP_CORRUPTION"]    = "Improved Corruption", -- Affliction t1
    ["SOUL_HARVESTING"]   = "Soul Harvest", -- Affliction t2 (renamed from Soul Harvesting in the 2 Oct patch)
    ["IMP_DRAINS"]        = "Improved Drains", -- Affliction t2
    ["IMP_BANE_AGONY"]    = "Improved Bane of Agony", -- Affliction t3
    ["AMPLIFY_CURSE"]     = "Amplify Curse", -- Affliction t3
    ["IMP_HEALTH_FUNNEL"] = "Improved Health Funnel", -- Demonology t1
    ["IMP_IMP"]           = "Improved Imp", -- Demonology t1
    ["UNHOLY_POWER"]      = "Unholy Power", -- Demonology t1
    ["DEMONIC_AEGIS"]     = "Demonic Aegis", -- Demonology t2
    ["IMP_VOIDWALKER"]    = "Improved Voidwalker", -- Demonology t2
    ["FEL_VITALITY"]      = "Fel Vitality", -- Demonology t2
    ["DEMONIC_ENERGIES"]  = "Demonic Energies", -- Demonology t2
    ["IMP_SAYAAD"]        = "Improved Sayaad", -- Demonology t3
    ["MASTER_SUMMONER"]   = "Master Summoner", -- Demonology t3
    ["DESTRUCTIVE_REACH"] = "Destructive Reach", -- Destruction t1
    ["IMP_SHADOW_BOLT"]   = "Improved Shadow Bolt", -- Destruction t1
    ["BANE"]              = "Bane", -- Destruction t1
    ["MOLTEN_SKIN"]       = "Molten Skin", -- Destruction t2
    ["CATACLYSM"]         = "Cataclysm", -- Destruction t2
    ["AFTERMATH"]         = "Aftermath", -- Destruction t2
    ["SHADOWBURN"]        = "Shadowburn", -- Destruction t3
}

-- =============================================================
-- LOGIC
-- =============================================================
Warlock.ValidWeapons = {
    [7]=true,             -- 1H Swords
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

-- Leveling role marker talents (see MSC:GetLowLevelRole): each tree's
-- tier 1-3 picks, so the tree with the most points wins. "Leveling" is the
-- Affliction default. Improved Life Tap marks nothing (every tree takes it).
Warlock.LowLevelRoles = {
    Leveling      = { "SUPPRESSION", "IMP_CORRUPTION", "MALEDICTION", "SOUL_HARVESTING", "IMP_DRAINS", "IMP_BANE_AGONY", "FEL_CONCENTRATION", "AMPLIFY_CURSE", "PANDEMIC" },
    Leveling_Demo = { "IMP_HEALTH_FUNNEL", "IMP_IMP", "DEMONIC_EMBRACE", "UNHOLY_POWER", "DEMONIC_AEGIS", "IMP_VOIDWALKER", "FEL_VITALITY", "DEMONIC_ENERGIES", "IMP_SAYAAD", "DEMONIC_SACRIFICE", "MASTER_SUMMONER" },
    Leveling_Fire = { "DESTRUCTIVE_REACH", "IMP_SHADOW_BOLT", "BANE", "MOLTEN_SKIN", "CATACLYSM", "AFTERMATH", "RUIN", "SHADOWBURN" },
}

function Warlock:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Logic
    if level < 60 then 
        local suffix = ""
        if level <= 10 then suffix = "_1_10"
        elseif level <= 20 then suffix = "_11_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end 

        local prefix = "Leveling" -- Default Affliction
        
        if Rank("INCINERATE") > 0 or Rank("CONFLAGRATE") > 0 then 
            prefix = "Leveling_Fire"
        elseif Rank("SOUL_LINK") > 0 or Rank("MASTER_DEMON") > 0 then
            prefix = "Leveling_Demo"
        elseif level >= 10 then
            prefix = MSC:GetLowLevelRole(Warlock.LowLevelRoles) or prefix
        end

        -- Level 10 brings the first talent point: a role it marks uses that
        -- role's 11-20 row (the 1-10 band only has the default row).
        if level == 10 and prefix ~= "Leveling" then suffix = "_11_20" end
        local key = prefix .. suffix
        if Warlock.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame Logic
    if Rank("DEMONIC_SACRIFICE") > 0 and Rank("RUIN") > 0 then return "RAID_DS_RUIN" end
    if Rank("SHADOW_MASTERY") > 0 and Rank("RUIN") > 0 then return "RAID_SM_RUIN" end
    if Rank("MASTER_DEMON") > 0 and Rank("RUIN") > 0 then return "PVE_MD_RUIN" end
    -- Demonic Pact keeps the Demonic Sacrifice buff while another demon is
    -- out, so it's a damage build: Sacrifice + Master Demonologist stacked,
    -- or Sacrifice on its own. (It used to fall through to the PvP Soul Link
    -- tank profile.) Soul Link without Pact is still the PvP tank build.
    if Rank("DEMONIC_PACT") > 0 then
        if Rank("MASTER_DEMON") > 0 then return "PVE_MD_RUIN" end
        return "RAID_DS_RUIN"
    end
    if Rank("SOUL_LINK") > 0 then return "PVP_SOUL_LINK" end
    if Rank("INCINERATE") > 0 then return "PVP_DEEP_DESTRO" end
    if Rank("CONFLAGRATE") > 0 then 
        if Rank("NIGHTFALL") > 0 then return "PVP_NF_CONFLAG" end
        return "PVP_DEEP_DESTRO" 
    end
    
    return "Default"
end

function Warlock:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 1. Demonic Embrace (Stamina) ]]
    local rEmb = Rank("DEMONIC_EMBRACE")
    if rEmb > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03))
    end

    -- Ruin (Destruction t3, 5 ranks): "Increases the critical strike damage
    -- bonus of your Destruction spells by 20%" -- same phrasing/math as Mage's
    -- Arcane Mind/Ice Shards -- 1+rank*0.20, reaching 2.0x at 5/5 (matches
    -- real Classic Ruin's known doubling effect exactly). Shadow Bolt itself
    -- is a Destruction spell and the primary nuke for every non-Fire build
    -- too, and Ruin is a prerequisite for all 3 raid spec detections, so this
    -- applies unconditionally by rank rather than gating on spec name.
    local isLeveling = type(currentSpec) == "string" and currentSpec:find("^Leveling") ~= nil
    local rRuin = Rank("RUIN")
    if not isLeveling and rRuin > 0 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rRuin * 0.20))
    end

    -- Pandemic (New in Forever, Affliction t3, 3 ranks): same crit-damage-bonus
    -- phrasing, now extended to DoTs since Forever lets periodic damage crit --
    -- 1+rank*0.33, reaching ~2.0x at 3/3, consistent with every other
    -- crit-damage-bonus talent converging on a 2x cap at its own max rank
    local rPandemic = Rank("PANDEMIC")
    local rShadowMastery = Rank("SHADOW_MASTERY")
    local rMalediction = Rank("MALEDICTION")
    local rAgonizing = Rank("AGONIZING_FLAMES")

    if isLeveling then
        local level = UnitLevel("player")

        -- Leveling rows: Pandemic only touches DoT crits and Ruin only
        -- Destruction crits, so each applies to its share of the rotation's
        -- crit-able damage (Pandemic's dotShare rises with level as Corruption/
        -- Agony/Immolate ticks grow; Ruin's destroShare depends on the spec),
        -- and the two add into ONE multiplier instead of stacking to x2-4.
        local destroShare = 0.5 -- Leveling (Affliction)
        if currentSpec:find("^Leveling_Fire") then destroShare = 0.85
        elseif currentSpec:find("^Leveling_Demo") then destroShare = 0.3 end
        local dotShare = MSC.ForeverLevelLerp({ {15, 0.45}, {20, 0.50}, {25, 0.50}, {30, 0.55}, {35, 0.60}, {40, 0.60}, {45, 0.65}, {50, 0.70}, {59, 0.70} }, level)
        local critMult = 1 + (0.20 * rRuin * destroShare) + (0.33 * rPandemic * dotShare)
        MSC.ScaleForeverSpellCrit(weights, critMult, level)

        -- Malediction (+1% periodic, about 0.8 of Affliction damage), Shadow
        -- Mastery (+1% Shadow) and Agonizing Flames (+3% Destruction, Fire
        -- rows) raise everything expressed in spell damage -- Spell Power,
        -- school damage, hit and crit -- but not wand, Int, Spirit, Mp5 or Stamina.
        local dmgMult = (1 + 0.008 * rMalediction) * (1 + 0.01 * rShadowMastery)
        local dmgKeys = { "ITEM_MOD_SPELL_POWER_SHORT", "ITEM_MOD_SHADOW_DAMAGE_SHORT", "ITEM_MOD_HIT_SPELL_RATING_SHORT", "ITEM_MOD_SPELL_CRIT_RATING_SHORT" }
        if currentSpec:find("^Leveling_Fire") and rAgonizing > 0 then
            dmgMult = dmgMult * (1 + 0.03 * rAgonizing)
            dmgKeys[#dmgKeys + 1] = "ITEM_MOD_FIRE_DAMAGE_SHORT"
        end
        MSC.ScaleForeverKeys(weights, dmgKeys, dmgMult)

        -- Soul Harvest (Affliction t2, 2 ranks): the regen buff is
        -- conditional on a Drain Soul kill (level 10+), so about +6%/rank.
        local rSoulHarvest = Rank("SOUL_HARVESTING")
        if rSoulHarvest > 0 and level >= 10 then
            MSC.ScaleForeverKeys(weights, { "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT" }, 1 + 0.06 * rSoulHarvest)
        end

        -- Fel Vitality (Demonology t2, 3 ranks, +5% max mana/rank): scales the
        -- mana part of Int (about 0.85 of it) and flat +Mana.
        if currentSpec:find("^Leveling_Demo") then
            local rFelVit = Rank("FEL_VITALITY")
            if rFelVit > 0 then
                MSC.ScaleForeverKeys(weights, { "ITEM_MOD_MANA_SHORT" }, 1 + 0.05 * rFelVit)
                MSC.ScaleForeverKeys(weights, { "ITEM_MOD_INTELLECT_SHORT" }, 1 + 0.04 * rFelVit)
            end
        end
    else
        if rPandemic > 0 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rPandemic * 0.33))
        end

        -- Shadow Mastery (Affliction t6, 5 ranks): +1%/rank Shadow spell damage/drain
        if rShadowMastery > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rShadowMastery * 0.01))
        end

        -- Malediction (New in Forever, Affliction t2, 5 ranks): +1%/rank periodic
        -- (DoT) damage from all Warlock spells
        if rMalediction > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rMalediction * 0.01))
        end

        -- Agonizing Flames (New in Forever, Destruction t4, 3 ranks): +3%/rank
        -- damage on all Destruction spells (includes Shadow Bolt)
        if rAgonizing > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rAgonizing * 0.03))
        end
    end

    -- [[ 2. Hit Cap ]]
    -- Suppression is +1% hit on all spells in Forever, so it's already in the
    -- game's spell-hit number (MSC:GetForeverHitPercent). Target is the
    -- level's cap, sliding to the raid cap from 50.
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_SPELL_RATING_SHORT", "SPELL", 0.1, "Spell Hit", activeCaps)

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Warlock:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
end

MSC.RegisterModule("WARLOCK", Warlock)



