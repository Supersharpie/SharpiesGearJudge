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
    ["Leveling_Dagger_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Dagger_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Dagger_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    ["Leveling_Dagger_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },

    -- Hemo Leveling (same convention fix as above)
    ["Leveling_Hemo_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
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
    
    ["Leveling_Dagger_11_20"] = "Leveling: Daggers (11-20)",
    ["Leveling_Dagger_21_40"] = "Leveling: Daggers (21-40)",
    ["Leveling_Dagger_41_51"] = "Leveling: Daggers (41-51)",
    ["Leveling_Dagger_52_59"] = "Leveling: Daggers (52-59)",
    
    ["Leveling_Hemo_11_20"]    = "Leveling: Hemo (11-20)",
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
    -- Leveling role markers (tiers 1-3, see Rogue.LowLevelRoles)
    ["IMP_SINISTER_STRIKE"] = "Improved Sinister Strike", -- Combat t1
    ["LIGHTNING_REFLEXES"]  = "Lightning Reflexes", -- Combat t1
    ["DEFLECTION"]          = "Deflection", -- Combat t2
    ["OPPORTUNITY"]         = "Opportunity", -- Subtlety t1, Backstab damage
    ["IMP_AMBUSH"]          = "Improved Ambush", -- Subtlety t2
    ["CAMOUFLAGE"]          = "Camouflage", -- Subtlety t1
    ["MASTER_OF_DECEPTION"] = "Master of Deception", -- Subtlety t1
    ["SETUP"]               = "Setup", -- Subtlety t2
    ["ELUSIVENESS"]         = "Elusiveness", -- Subtlety t2
    ["DIRTY_TRICKS"]        = "Dirty Tricks", -- Subtlety t2
    ["INITIATIVE"]          = "Initiative", -- Subtlety t3
    ["GHOSTLY_STRIKE"]      = "Ghostly Strike", -- Subtlety t3
    ["DW_SPEC"]             = "Dual Wield Specialization", -- Combat t4
}

-- =============================================================
-- LOGIC
-- =============================================================
Rogue.ValidWeapons = {
    [0]=true,             -- 1H Axes (Forever: SkillRaceClassInfo gives Rogues Axes)
    [4]=true,             -- 1H Maces
    [7]=true,             -- 1H Swords
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
}

-- Leveling role marker talents (see MSC:GetLowLevelRole). "Leveling" is the
-- Combat (Swords/Maces) default. Assassination picks and generic Combat picks
-- (Improved Eviscerate, Precision, Endurance, Improved Sprint) mark nothing.
Rogue.LowLevelRoles = {
    Leveling        = { "IMP_SINISTER_STRIKE", "LIGHTNING_REFLEXES", "DEFLECTION", "RIPOSTE" },
    -- (Opportunity and Improved Ambush aren't markers: every Subtlety rogue
    -- takes them, which tied pure-Subtlety builds 3-3 and sent them to Combat.)
    Leveling_Dagger = { "PUNCTURING_WOUNDS", "MUTILATE" },
    Leveling_Hemo   = { "CAMOUFLAGE", "MASTER_OF_DECEPTION", "SETUP", "ELUSIVENESS", "DIRTY_TRICKS", "INITIATIVE", "GHOSTLY_STRIKE" },
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
        local subPts = MSC.GetTabPointsSpent and MSC.GetTabPointsSpent(3) or 0
        local otherPts = MSC.GetTabPointsSpent and (MSC.GetTabPointsSpent(1) + MSC.GetTabPointsSpent(2)) or 0
        if Rank("HEMORRHAGE") > 0 then role = "Leveling_Hemo"
        elseif Rank("PUNCTURING_WOUNDS") > 0 or Rank("MUTILATE") > 0 then role = "Leveling_Dagger"
        -- Ghostly Strike, or mostly-Subtlety points, is a Hemo leveler
        elseif level >= 10 and (Rank("GHOSTLY_STRIKE") > 0 or (subPts >= 5 and subPts > otherPts)) then role = "Leveling_Hemo"
        elseif level >= 10 then role = MSC:GetLowLevelRole(Rogue.LowLevelRoles) or role
        end
        
        -- Level 10 brings the first talent point: a role it marks uses that
        -- role's 11-20 row (the 1-10 band only has the default row).
        if level == 10 and role ~= "Leveling" then suffix = "_11_20" end
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

    local spec = currentSpec or ""
    local isLeveling = spec:find("^Leveling") ~= nil
    local level = UnitLevel("player")

    -- Lethality (Assassination t3, 5 ranks): +4%/rank crit damage bonus on
    -- Sinister Strike/Gouge/Backstab/Mutilate/Ghostly Strike/Hemorrhage only.
    -- Melee crits already deal 2.0x, so 5/5 lifts that bonus from 1.00 to 1.20
    -- on those yellow hits alone (not white hits, Ambush, Eviscerate or
    -- poison). Leveling rows scale by how much of the damage those hits carry;
    -- endgame keeps the flat 0.08/rank.
    local rLethal = Rank("LETHALITY")
    if rLethal > 0 then
        local perRank = 0.08
        if spec:find("^Leveling_Dagger") then perRank = 0.010
        elseif spec:find("^Leveling_Hemo") then perRank = 0.008
        elseif isLeveling then perRank = 0.016 end
        MSC.ScaleForeverMeleeCrit(weights, 1 + (rLethal * perRank), level)
    end

    if isLeveling then
        -- Dual Wield Specialization (Combat t4, 5 ranks): +5% off-hand damage
        -- per rank; only the white part scales, poison does not (0.045/rank)
        local rDW = Rank("DW_SPEC")
        if rDW > 0 then
            MSC.ScaleForeverKeys(weights, { "MSC_WEAPON_DPS_OH" }, 1 + (rDW * 0.045))
        end

        -- Mutilate (Assassination t5): the off-hand lands a 75% yellow hit per
        -- cast, so off-hand weapon DPS is worth 1.5x and main hand 1.05x
        if spec:find("^Leveling_Dagger") and Rank("MUTILATE") > 0 then
            MSC.ScaleForeverKeys(weights, { "MSC_WEAPON_DPS_OH" }, 1.5)
            MSC.ScaleForeverKeys(weights, { "MSC_WEAPON_DPS_MELEE" }, 1.05)
        end
    end

    -- [[ 1. Yellow Hit Cap, tapered to the DW white cap ]]
    -- Hit % in percent with Precision counted once (MSC:GetForeverHitPercent);
    -- caps follow the level and slide to the raid caps from 50.
    MSC.ApplyForeverHitKnees(weights, "ITEM_MOD_HIT_RATING_SHORT", "MELEE", {
        { cap = MSC.GetForeverCapTarget("MELEE"), mult = 0.6 },
        { cap = MSC.GetForeverCapTarget("DW_WHITE"), mult = 0.05 },
    }, "Yellow Hit", activeCaps)

    -- [[ 2. Weapon Skill Cap (Removed in Forever) ]]

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

-- Hack and Slash (New in Forever, Combat t5, 5 ranks): per-weapon-type bonus.
-- Only the Dagger/Fist branch (+1%/rank Crit) converts cleanly into a score
-- value -- same math as the racial weapon-crit bonuses. The Axe/Sword
-- (extra-attack proc chance) and Mace (armor ignore) branches aren't scored
-- for the same reason Warrior's Weaponmaster's non-crit branches aren't.
-- The +1%/rank crit only helps that hand's swings: the main hand carries all
-- yellow hits plus its white swings (~75% of damage), the off hand only its
-- own white swings (~20%); 0.5 when the hand isn't known.
local function GetHackAndSlashCritBonus(itemLink, weights, slotId)
    local rHS = MSC:GetTalentRank("HACK_AND_SLASH")
    if rHS <= 0 or not itemLink or not weights then return 0 end

    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 or not subClassID then return 0 end
    if subClassID ~= 13 and subClassID ~= 15 then return 0 end -- Fist (13), Dagger (15)

    local slotFactor = (slotId == 16 and 0.75) or (slotId == 17 and 0.2) or 0.5
    -- Crit weight is already "per 1%" (see MSC.GetForeverWeaponRacialBonus)
    return rHS * (weights["ITEM_MOD_CRIT_RATING_SHORT"] or 0) * slotFactor -- +1%/rank Crit
end

-- Backstab and Ambush need a dagger in the main hand, and Ghostly Strike
-- (180%) and Hemorrhage (145%) hit much harder with one, but the weights
-- have no weapon-type term: without this a slightly faster sword outscores
-- the dagger. Flat AP-equivalent bonus for a main-hand dagger, by level.
local DAGGER_MAIN_HAND = {
    Leveling_Dagger = { { 15, 15 }, { 20, 20 }, { 25, 23 }, { 30, 26 }, { 35, 29 }, { 40, 32 }, { 45, 37 }, { 50, 42 }, { 55, 45 }, { 59, 48 } },
    Leveling_Hemo   = { { 17, 0 }, { 18, 27 }, { 20, 29 }, { 25, 28 }, { 30, 26 }, { 35, 28 }, { 40, 29 }, { 45, 33 }, { 50, 39 }, { 55, 42 }, { 59, 45 } },
}
local function GetDaggerMainHandBonus(itemLink, weights, slotId, specName)
    if slotId ~= 16 or not itemLink or not weights then return 0 end
    local spec = specName or MSC.CachedSpecKey or ""
    local points
    for prefix, pts in pairs(DAGGER_MAIN_HAND) do
        if spec:find("^" .. prefix) then points = pts end
    end
    if not points then return 0 end
    local _, _, _, _, _, classID, subClassID = GetItemInfoInstant(itemLink)
    if classID ~= 2 or subClassID ~= 15 then return 0 end
    local level = UnitLevel("player")
    local ap = points[#points][2]
    if level <= points[1][1] then ap = points[1][2]
    else
        for i = 1, #points - 1 do
            local a, b = points[i], points[i + 1]
            if level <= b[1] then ap = a[2] + (b[2] - a[2]) * (level - a[1]) / (b[1] - a[1]); break end
        end
    end
    return ap * (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 1)
end

-- Hack and Slash sword (extra-attack chance) and mace (armor ignore)
-- branches, Leveling rows only. D is total damage in AP units by level.
-- Sword: 1%/rank extra attack, worth 0.0105 x rank x D AP on the main hand.
-- Mace: 3%/rank armor ignore = gain(level) x 0.85 (non-poison share) x D x
-- rank/5. The off hand gets half of either.
local HS_TOTAL_DAMAGE = { { 30, 610 }, { 40, 930 }, { 59, 1590 } }
local HS_MACE_GAIN = { { 35, 0.046 }, { 40, 0.056 }, { 45, 0.063 } }
local function GetHackAndSlashProcBonus(itemLink, weights, slotId, specName)
    local rHS = MSC:GetTalentRank("HACK_AND_SLASH")
    if rHS <= 0 or not itemLink or not weights then return 0 end
    local spec = specName or MSC.CachedSpecKey or ""
    if not spec:find("^Leveling") then return 0 end
    if slotId ~= 16 and slotId ~= 17 then return 0 end

    local _, _, _, _, _, classID, subClassID = GetItemInfoInstant(itemLink)
    if classID ~= 2 or (subClassID ~= 7 and subClassID ~= 4) then return 0 end

    local level = UnitLevel("player")
    if level < 30 then return 0 end
    local D = MSC.ForeverLevelLerp(HS_TOTAL_DAMAGE, level)
    local ap
    if subClassID == 7 then
        ap = 0.0105 * rHS * D
    else
        ap = MSC.ForeverLevelLerp(HS_MACE_GAIN, level) * 0.85 * D * rHS / 5
    end
    if slotId == 17 then ap = ap * 0.5 end
    return ap * (weights["ITEM_MOD_ATTACK_POWER_SHORT"] or 1)
end

function Rogue:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
        + GetHackAndSlashCritBonus(itemLink, weights, slotId)
        + GetHackAndSlashProcBonus(itemLink, weights, slotId, specName)
        + GetDaggerMainHandBonus(itemLink, weights, slotId, specName)
end

MSC.RegisterModule("ROGUE", Rogue)


