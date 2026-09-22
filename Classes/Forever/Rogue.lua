local addonName, MSC = ...
local Rogue = {}
Rogue.Name = "ROGUE"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
-- Strength/Attack Power/Weapon DPS/Agility calibrated to real conversion
-- math (see Paladin.lua for the base derivation). Rogues, like Hunters, get
-- melee Attack Power = 1x Strength + 1x Agility (not Warrior/Paladin's
-- Strength-only 2:1), so both are weighted near AP's own value, with
-- Agility carrying an added Crit/Dodge premium Strength doesn't get. Weapon
-- DPS = 14x AP's weight (same universal /14 divisor derivation).
Rogue.Weights = {
    ["Default"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["RAID_COMBAT_SWORDS"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["RAID_COMBAT_DAGGERS"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["RAID_SEAL_FATE"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=21.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["PVP_HEMO"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["PVP_CB_DAGGER"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["PVP_MACE"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Rogue.LevelingWeights = {
    -- Band ladder (Spirit/Mp5/Armor/Defense/school damage by level): see Warrior.lua's LevelingWeights.
    -- Combat Swords/Maces. Strength/Agility/Weapon DPS corrected to the
    -- confirmed 1:1 Rogue melee-AP formula and 14:1 Weapon DPS:AP ratio (see
    -- comment above Rogue.Weights for the derivation).
    ["Leveling_1_10"]  = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    -- Brought up to match Leveling_1_10/11_20's convention (Hit/Crit/Attack
    -- Power were entirely absent -- zero weight, invisible to scoring; see
    -- Warrior.lua's leveling-bracket comment for the item-database evidence)
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },

    -- Dagger Leveling (same convention fix as above)
    ["Leveling_Dagger_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Dagger_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Dagger_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },

    -- Hemo Leveling (same convention fix as above)
    ["Leveling_Hemo_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Hemo_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Hemo_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Rogue.PrettyNames = {
    ["RAID_COMBAT_SWORDS"]  = "Raid: Combat Swords",
    ["RAID_COMBAT_DAGGERS"] = "Raid: Combat Daggers",
    ["RAID_SEAL_FATE"]      = "Raid: Seal Fate (Crit)",
    ["PVP_MACE"]            = "PvP: Mace Specialization",
    ["PVP_HEMO"]            = "PvP: Hemo Control",
    ["PVP_CB_DAGGER"]       = "PvP: Cold Blood Burst",
    
    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling (11-20)",
    ["Leveling_21_40"]      = "Leveling: Combat (21-40)",
    ["Leveling_41_51"]      = "Leveling: Combat (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Combat (52-59)",
    
    ["Leveling_Dagger_21_40"] = "Leveling: Daggers (21-40)",
    ["Leveling_Dagger_41_51"] = "Leveling: Daggers (41-51)",
    ["Leveling_Dagger_52_59"] = "Leveling: Daggers (52-59)",
    
    ["Leveling_Hemo_21_40"]    = "Leveling: Hemo (21-40)",
    ["Leveling_Hemo_41_51"]    = "Leveling: Hemo (41-51)",
    ["Leveling_Hemo_52_59"]    = "Leveling: Hemo (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Rogue.Talents = { 
    ["SEAL_FATE"]       = "Seal Fate",
    ["COLD_BLOOD"]      = "Cold Blood",
    ["ADRENALINE_RUSH"] = "Adrenaline Rush",
    ["HACK_AND_SLASH"]  = "Hack and Slash",
    ["PUNCTURING_WOUNDS"]= "Puncturing Wounds",
    ["RIPOSTE"]         = "Riposte",
    ["HEMORRHAGE"]      = "Hemorrhage",
    ["PREPARATION"]     = "Preparation",
    ["LETHALITY"]       = "Lethality",
    ["PRECISION"]       = "Precision",
    ["WEAP_EXPERTISE"]  = "Weapon Expertise",
    ["MUTILATE"]        = "Mutilate",
    ["VENOM"]           = "Venom",
    ["THOUSAND_CUTS"]   = "Thousand Cuts",
}

-- =============================================================
-- LOGIC
-- =============================================================
Rogue.ValidWeapons = {
    [4]=true,             -- 1H Maces
    [7]=true,             -- 1H Swords
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
}

function Rogue:GetSpec()
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
        
        -- Detect Leveling Spec Type
        local role = "Leveling" -- Default Combat
        if Rank("HEMORRHAGE") > 0 then role = "Leveling_Hemo"
        elseif Rank("PUNCTURING_WOUNDS") > 0 then role = "Leveling_Dagger"
        end
        
        local key = role .. suffix
        if Rogue.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("HEMORRHAGE") > 0 and Rank("PREPARATION") > 0 then return "PVP_HEMO" end
    if Rank("COLD_BLOOD") > 0 and Rank("PREPARATION") > 0 and Rank("HEMORRHAGE") == 0 then return "PVP_CB_DAGGER" end
    if Rank("SEAL_FATE") > 0 then return "RAID_SEAL_FATE" end
    if Rank("ADRENALINE_RUSH") > 0 and Rank("PUNCTURING_WOUNDS") == 0 then return "RAID_COMBAT_SWORDS" end
    if Rank("ADRENALINE_RUSH") > 0 and Rank("PUNCTURING_WOUNDS") > 0 then return "RAID_COMBAT_DAGGERS" end
    if Rank("PUNCTURING_WOUNDS") > 0 then return "RAID_COMBAT_DAGGERS" end
    return "RAID_COMBAT_SWORDS"
end

function Rogue:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- Lethality (Assassination t3, 5 ranks): +4%/rank crit damage bonus on
    -- Sinister Strike/Gouge/Backstab/Mutilate/Ghostly Strike/Hemorrhage --
    -- base crit bonus is +50%, so 5/5 = +20% -> 70% bonus, a 1.4x multiplier
    local rLethal = Rank("LETHALITY")
    if rLethal > 0 and weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rLethal * 0.08))
    end

    -- [[ 1. Yellow Hit Cap (9%), tapered to the 28% DW white cap ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        local currentHit = MSC:GetPlayerStat("HIT")
        local talentHit = Rank("PRECISION") -- 1% per rank in Era
        local totalHit = currentHit + talentHit

        local yellowCap = 9
        local newWeight, capped = MSC.ApplyForeverDualWieldHitTaper(weights["ITEM_MOD_HIT_RATING_SHORT"], totalHit, yellowCap, 28)
        if capped then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = newWeight
            table.insert(activeCaps, "Yellow Hit (" .. yellowCap .. "%)")
        end
    end

    -- [[ 2. Weapon Skill Cap (Removed in Forever) ]]

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

-- Hack and Slash (New in Forever, Combat t5, 5 ranks): per-weapon-type bonus.
-- Only the Dagger/Fist branch (+1%/rank Crit) converts cleanly into a score
-- value -- same math as the racial weapon-crit bonuses. The Axe/Sword
-- (extra-attack proc chance) and Mace (armor ignore) branches aren't scored
-- for the same reason Warrior's Weaponmaster's non-crit branches aren't.
local function GetHackAndSlashCritBonus(itemLink, weights)
    local rHS = MSC:GetTalentRank("HACK_AND_SLASH")
    if rHS <= 0 or not itemLink or not weights then return 0 end

    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 or not subClassID then return 0 end
    if subClassID ~= 13 and subClassID ~= 15 then return 0 end -- Fist (13), Dagger (15)

    -- Crit weight is already "per 1%" (see MSC.GetForeverWeaponRacialBonus)
    return rHS * (weights["ITEM_MOD_CRIT_RATING_SHORT"] or 0) -- +1%/rank Crit
end

function Rogue:GetWeaponBonus(itemLink, weights)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights) + GetHackAndSlashCritBonus(itemLink, weights)
end

MSC.RegisterModule("ROGUE", Rogue)


