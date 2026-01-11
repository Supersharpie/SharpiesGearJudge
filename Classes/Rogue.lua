local addonName, MSC = ...
local Rogue = {}
Rogue.Name = "ROGUE"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Rogue.Weights = {
    ["Default"] = {
        ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["MSC_HIT_PERCENT"]=18.0, ["MSC_CRIT_PERCENT"]=25.0
    },
    ["RAID_COMBAT"] = {
        ["MSC_WEAPON_SKILL"]=40.0, -- Massive weight until +5 skill
        ["MSC_HIT_PERCENT"]=22.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.1, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["MSC_CRIT_PERCENT"]=28.0 
    },
    ["RAID_DAGGER"] = {
        ["MSC_WEAPON_SKILL"]=35.0, 
        ["MSC_CRIT_PERCENT"]=30.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.4, 
        ["MSC_HIT_PERCENT"]=20.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 
    },
    ["PVP_ERA"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
        ["MSC_CRIT_PERCENT"]=20.0, 
        ["MSC_HIT_PERCENT"]=12.0 
    }
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Rogue.LevelingWeights = {
    ["Leveling_1_20"]  = { ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
    ["Leveling_21_40"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["MSC_CRIT_PERCENT"]=10.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.4, ["MSC_HIT_PERCENT"]=15.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_52_59"] = { ["MSC_HIT_PERCENT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["MSC_WEAPON_SKILL"]=20.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 }
}

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Rogue.Talents = { 
    ["PRECISION"]       = "Precision",        -- 5% Hit
    ["ADRENALINE_RUSH"] = "Adrenaline Rush",  -- Combat 31
    ["COLD_BLOOD"]      = "Cold Blood",       -- Assa 21
    ["PREPARATION"]     = "Preparation",      -- Sub 21
    ["HEMORRHAGE"]      = "Hemorrhage",       -- Sub 31
    ["WEAP_EXPERTISE"]  = "Weapon Expertise", -- +5 Skill
    ["SWORD_SPEC"]      = "Sword Specialization"
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

    -- Endgame detection
    if Rank("ADRENALINE_RUSH") > 0 then return "RAID_COMBAT" end
    if Rank("HEMORRHAGE") > 0 or Rank("PREPARATION") > 0 then return "PVP_ERA" end
    
    return "Default"
end

function Rogue:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Yellow Hit Cap Logic (Classic Era: 9% vs 63 bosses, 6% with +5 Skill)
    if weights["MSC_HIT_PERCENT"] then
        local currentHit = MSC.PlayerStats.Hit or 0
        local talentHit = Rank("PRECISION") -- 1% per rank
        local totalHit = currentHit + talentHit
        
        -- Determine cap based on weapon skill
        local weaponSkillBonus = Rank("WEAP_EXPERTISE") * 2.5 -- +5 skill at rank 2
        local _, race = UnitRace("player")
        if race == "Human" then weaponSkillBonus = weaponSkillBonus + 5 end

        local yellowCap = (weaponSkillBonus >= 5) and 6 or 9
        
        if totalHit >= yellowCap then
            -- We are yellow capped. White hits still benefit, but less so.
            weights["MSC_HIT_PERCENT"] = weights["MSC_HIT_PERCENT"] * 0.4
            table.insert(activeCaps, "Yellow Hit (" .. yellowCap .. "%)")
        end
    end

    -- 2. Weapon Skill Cap (Soft Cap at +5)
    if weights["MSC_WEAPON_SKILL"] then
        local raceBonus = 0
        local _, race = UnitRace("player")
        if race == "Human" then raceBonus = 5 end
        
        local skillFromTalents = Rank("WEAP_EXPERTISE") * 2.5
        local totalSkillExtra = raceBonus + skillFromTalents
        
        if totalSkillExtra >= 5 then
            weights["MSC_WEAPON_SKILL"] = 5.0 -- Significantly lower weight after Glancing penalty is minimized
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