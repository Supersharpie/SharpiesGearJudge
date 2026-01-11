local addonName, MSC = ...
local Rogue = {}
Rogue.Name = "ROGUE"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Rogue.Weights = {
        ["Default"] = {
			["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0 },
        ["RAID_COMBAT_SWORDS"] = {
			["ITEM_MOD_HIT_RATING_SHORT"]=22.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=28.0 },
        ["RAID_COMBAT_DAGGERS"] = {
			["ITEM_MOD_CRIT_RATING_SHORT"]=28.0, ["ITEM_MOD_AGILITY_SHORT"]=2.4, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0 },
        ["RAID_SEAL_FATE"] = {
			["ITEM_MOD_CRIT_RATING_SHORT"]=32.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_HIT_RATING_SHORT"]=18.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
        ["PVP_HEMO"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0 },
        ["PVP_CB_DAGGER"] = {
			["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["PVP_MACE"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_AGILITY_SHORT"]=1.8 },
    }

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Rogue.LevelingWeights = {
        -- Combat Swords/Maces
        ["Leveling_1_20"]  = { ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.3, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.4, ["ITEM_MOD_HIT_RATING_SHORT"]=12.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 },
        ["Leveling_52_59"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=10.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },

        -- [NEW] Dagger Leveling (Ambush/Backstab) - Needs Crit & Dagger Skill
        ["Leveling_Dagger_21_40"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Leveling_Dagger_41_51"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=8.0 },
        ["Leveling_Dagger_52_59"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.8, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },

        -- [NEW] Hemo Leveling (Subtlety) - Needs Stamina & AP
        ["Leveling_Hemo_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 },
        ["Leveling_Hemo_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0 },
        ["Leveling_Hemo_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },
    }

-- =============================================================
-- DISPLAY NAMES (For Options Menu)
-- =============================================================
Rogue.PrettyNames = {
        -- Endgame
        ["RAID_COMBAT_SWORDS"]  = "Raid: Combat Swords",
        ["RAID_COMBAT_DAGGERS"] = "Raid: Combat Daggers",
        ["RAID_SEAL_FATE"]      = "Raid: Seal Fate (Crit)",
        ["PVP_MACE"]            = "PvP: Mace Specialization",
        ["PVP_HEMO"]            = "PvP: Hemo Control",
        ["PVP_CB_DAGGER"]       = "PvP: Cold Blood Burst",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Combat (21-40)",
        ["Leveling_41_51"]      = "Leveling: Combat (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Combat (52-59)",
        
        ["Leveling_Dagger_21_40"] = "Leveling: Daggers (21-40)",
        ["Leveling_Dagger_41_51"] = "Leveling: Daggers (41-51)",
        ["Leveling_Dagger_52_59"] = "Leveling: Daggers (52-59)",
        
        ["Leveling_Hemo_21_40"]   = "Leveling: Hemo (21-40)",
        ["Leveling_Hemo_41_51"]   = "Leveling: Hemo (41-51)",
        ["Leveling_Hemo_52_59"]   = "Leveling: Hemo (52-59)",
    }

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Rogue.Talents = { 
        ["SEAL_FATE"]       = "Seal Fate",
        ["COLD_BLOOD"]      = "Cold Blood",
        ["ADRENALINE_RUSH"] = "Adrenaline Rush",
        ["SWORD_SPEC"]      = "Sword Specialization",
        ["DAGGER_SPEC"]     = "Dagger Specialization",
        ["MACE_SPEC"]       = "Mace Specialization",
        ["RIPOSTE"]         = "Riposte",
        ["HEMORRHAGE"]      = "Hemorrhage",
        ["PREPARATION"]     = "Preparation",
        ["LETHALITY"]       = "Lethality",
        ["PRECISION"]       = "Precision",
        ["WEAP_EXPERTISE"]  = "Weapon Expertise",
    }

-- =============================================================
-- LOGIC
-- =============================================================
function Rogue:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        return "Leveling" .. suffix
    end

    if Rank("HEMORRHAGE") > 0 and Rank("PREPARATION") > 0 then return "PVP_HEMO" end
    if Rank("COLD_BLOOD") > 0 and Rank("PREPARATION") > 0 and Rank("HEMORRHAGE") == 0 then return "PVP_CB_DAGGER" end
    if Rank("MACE_SPEC") > 0 then return "PVP_MACE" end
    if Rank("SEAL_FATE") > 0 then return "RAID_SEAL_FATE" end
    if Rank("ADRENALINE_RUSH") > 0 and Rank("SWORD_SPEC") > 0 then return "RAID_COMBAT_SWORDS" end
    if Rank("DAGGER_SPEC") > 0 then return "RAID_COMBAT_DAGGERS" end
    return "RAID_COMBAT_SWORDS"
end

function Rogue:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Yellow Hit Cap (9% base, 6% with +5 Skill)
    -- FIX: Changed MSC_HIT_PERCENT -> ITEM_MOD_HIT_RATING_SHORT
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        local currentHit = MSC.PlayerStats.Hit or 0
        local talentHit = Rank("PRECISION") -- 1% per rank
        local totalHit = currentHit + talentHit
        
        local weaponSkillBonus = Rank("WEAP_EXPERTISE") * 2.5
        local _, race = UnitRace("player")
        if race == "Human" then weaponSkillBonus = weaponSkillBonus + 5 end

        local yellowCap = (weaponSkillBonus >= 5) and 6 or 9
        
        if totalHit >= yellowCap then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "Yellow Hit (" .. yellowCap .. "%)")
        end
    end

    -- 2. Weapon Skill Cap (+5)
    if weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] then
        local raceBonus = 0
        local _, race = UnitRace("player")
        if race == "Human" then raceBonus = 5 end
        
        local skillFromTalents = Rank("WEAP_EXPERTISE") * 2.5
        local totalSkillExtra = raceBonus + skillFromTalents
        
        if totalSkillExtra >= 5 then
            weights["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 5.0
            table.insert(activeCaps, "Skill (+5)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Rogue:GetWeaponBonus(itemLink)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Racial: Human (Sword/Mace) +5 Skill is massive in Era
    if race == "Human" and (subClassID == 7 or subClassID == 4) then 
        bonus = bonus + 50 -- Heavy weight to push Humans toward Swords/Maces
    end
    
    return bonus
end

MSC.RegisterModule("ROGUE", Rogue)