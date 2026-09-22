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
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=40.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=45.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=13.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },

    -- Fire
    ["Leveling_Fire_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=10.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
    ["Leveling_Fire_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=40.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=10.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 },
    ["Leveling_Fire_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=45.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=5.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=10.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },

    -- Demo
    ["Leveling_Demo_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
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
    
    ["Leveling_Fire_21_40"] = "Leveling: Destruction (21-40)",
    ["Leveling_Fire_41_51"] = "Leveling: Destruction (41-51)",
    ["Leveling_Fire_52_59"] = "Leveling: Destruction (52-59)",
    
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
        end 

        local key = prefix .. suffix
        if Warlock.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame Logic
    if Rank("DEMONIC_SACRIFICE") > 0 and Rank("RUIN") > 0 then return "RAID_DS_RUIN" end
    if Rank("SHADOW_MASTERY") > 0 and Rank("RUIN") > 0 then return "RAID_SM_RUIN" end
    if Rank("MASTER_DEMON") > 0 and Rank("RUIN") > 0 then return "PVE_MD_RUIN" end
    if Rank("DEMONIC_PACT") > 0 then return "PVP_SOUL_LINK" end
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
    local rRuin = Rank("RUIN")
    if rRuin > 0 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rRuin * 0.20))
    end

    -- Pandemic (New in Forever, Affliction t3, 3 ranks): same crit-damage-bonus
    -- phrasing, now extended to DoTs since Forever lets periodic damage crit --
    -- 1+rank*0.33, reaching ~2.0x at 3/3, consistent with every other
    -- crit-damage-bonus talent converging on a 2x cap at its own max rank
    local rPandemic = Rank("PANDEMIC")
    if rPandemic > 0 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rPandemic * 0.33))
    end

    -- Shadow Mastery (Affliction t6, 5 ranks): +1%/rank Shadow spell damage/drain
    local rShadowMastery = Rank("SHADOW_MASTERY")
    if rShadowMastery > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
        weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rShadowMastery * 0.01))
    end

    -- Malediction (New in Forever, Affliction t2, 5 ranks): +1%/rank periodic
    -- (DoT) damage from all Warlock spells
    local rMalediction = Rank("MALEDICTION")
    if rMalediction > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
        weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rMalediction * 0.01))
    end

    -- Agonizing Flames (New in Forever, Destruction t4, 3 ranks): +3%/rank
    -- damage on all Destruction spells (includes Shadow Bolt)
    local rAgonizing = Rank("AGONIZING_FLAMES")
    if rAgonizing > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
        weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rAgonizing * 0.03))
    end

    -- [[ 2. Hit Cap (16%) ]]
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        local currentHit = MSC:GetPlayerStat("SPELL_HIT")
        
        -- Suppression Logic (Now affects ALL spells, 1% per rank)
        local suppressionBonus = Rank("SUPPRESSION") * 1 
        local totalHit = currentHit + suppressionBonus
        local HIT_CAP = 16
        
        if totalHit >= HIT_CAP then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5 -- Cap reached
            table.insert(activeCaps, "Hit Cap")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Warlock:GetWeaponBonus(itemLink, weights)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights)
end

MSC.RegisterModule("WARLOCK", Warlock)



