local addonName, MSC = ...
local Rogue = {}
Rogue.Name = "ROGUE"
-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Rogue.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.1, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5,
        ["MSC_WEAPON_DPS"]=3.0 
    },

    -- [[ 1. COMBAT (Swords/Maces/Fists) ]]
    ["RAID_COMBAT"] = { 
        ["MSC_WEAPON_DPS"]                  = 6.0, -- King
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, -- Yellow Cap is #1
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.1, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.4, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.35,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.1, 
        -- POISON
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.02,
    },

    -- [[ 2. MUTILATE (Daggers) ]]
    ["RAID_MUTILATE"] = { 
        ["MSC_WEAPON_DPS"]                  = 5.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, -- Seal Fate
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.1, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.7, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.8, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.0,
        -- POISON
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },

    -- [[ 3. SUBTLETY (PvP) ]]
    ["PVP_SUBTLETY"] = { 
        ["MSC_WEAPON_DPS"]                  = 3.0, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.4, -- Sinister Calling
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.5, -- 5% Cap
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.3, 
        -- POISON
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Rogue.LevelingWeights = {
    -- [[ 1. STANDARD COMBAT ]]
    ["Leveling_1_20"]  = { 
        ["MSC_WEAPON_DPS"]=8.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.1, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=0.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=0.5,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_21_40"] = { 
        ["MSC_WEAPON_DPS"]=6.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.3, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.1, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_41_51"] = { 
        ["MSC_WEAPON_DPS"]=6.0,
        ["ITEM_MOD_AGILITY_SHORT"]=2.4, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_52_59"] = { 
        ["MSC_WEAPON_DPS"]=5.5,
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.5,
        ["ITEM_MOD_STAMINA_SHORT"]=1.2,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_60_70"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },

    -- [[ 2. DAGGERS ]]
    ["Leveling_Dagger_1_20"] = { 
        ["MSC_WEAPON_DPS"]=8.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.4, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Dagger_21_40"] = { 
        ["MSC_WEAPON_DPS"]=7.0,
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.8,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Dagger_41_51"] = { 
        ["MSC_WEAPON_DPS"]=6.0,
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Dagger_52_59"] = { 
        ["MSC_WEAPON_DPS"]=5.5,
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.8, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Dagger_60_70"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },

    -- [[ 3. HEMO ]]
    ["Leveling_Hemo_1_20"]    = { 
        ["MSC_WEAPON_DPS"]=6.0,
        ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Hemo_21_40"] = { 
        ["MSC_WEAPON_DPS"]=5.5,
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Hemo_41_51"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Hemo_52_59"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Hemo_60_70"] = { 
        ["MSC_WEAPON_DPS"]=4.5,
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Rogue.Specs = { [1]="Assassination", [2]="Combat", [3]="Subtlety" }

Rogue.PrettyNames = {
    ["RAID_COMBAT"]     = "Raid: Combat (Swords/Maces)",
    ["RAID_MUTILATE"]   = "Raid: Mutilate (Daggers)",
    ["PVP_SUBTLETY"]    = "PvP: Shadowstep / Hemo",
	
	-- Leveling Brackets
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
    
    ["Leveling_Dagger_1_20"]  = "Dagger/Ambush (1-20)",
    ["Leveling_Dagger_21_40"] = "Dagger/Ambush (21-40)",
    ["Leveling_Dagger_41_51"] = "Dagger/Ambush (41-51)",
    ["Leveling_Dagger_52_59"] = "Dagger/Ambush (52-59)",
    ["Leveling_Dagger_60_70"] = "Dagger/Ambush (Outland)",      
    
    ["Leveling_Hemo_1_20"]    = "Hemorrhage (1-20)",
    ["Leveling_Hemo_21_40"]   = "Hemorrhage (21-40)",
    ["Leveling_Hemo_41_51"]   = "Hemorrhage (41-51)",
    ["Leveling_Hemo_52_59"]   = "Hemorrhage (52-59)",
    ["Leveling_Hemo_60_70"]   = "Hemorrhage (Outland)",
}

Rogue.SpeedChecks = { 
    ["Default"]={ MH_Slow=true, OH_Fast=true } 
}

Rogue.ValidWeapons = {
    [4]=true,             -- 1H Maces
    [7]=true,             -- 1H Swords
    [13]=true, [15]=true, -- Fist, Dagger
    [2]=true, [3]=true, [18]=true, [16]=true -- Ranged
}

Rogue.StatToCritMatrix = { 
    Agi = { {1, 3.5}, {60, 29.0}, {70, 40.0} } 
}

Rogue.Talents = { 
    ["PRECISION"]       = "Precision",
    ["MUTILATE"]        = "Mutilate", 
    ["ADRENALINE_RUSH"] = "Adrenaline Rush", 
    ["SURPRISE_ATTACK"] = "Surprise Attack", 
    ["COMBAT_POTENCY"]  = "Combat Potency", 
    ["HEMORRHAGE"]      = "Hemorrhage", 
    ["SHADOWSTEP"]      = "Shadowstep", 
    ["CHEAT_DEATH"]     = "Cheat Death", 
    ["VITALITY"]        = "Vitality", 
    ["SINISTER_CALLING"]= "Sinister Calling",
    ["DAGGER_SPEC"]     = "Dagger Specialization",
    ["FIST_SPEC"]       = "Fist Weapon Specialization",
    ["SWORD_SPEC"]      = "Sword Specialization",
    ["MACE_SPEC"]       = "Mace Specialization",
    ["WEAPON_EXPERTISE"]= "Weapon Expertise" -- Added for Cap Check
}

-- =============================================================
-- LOGIC
-- =============================================================
function Rogue:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("SHADOWSTEP") > 0 or Rank("CHEAT_DEATH") > 0 then return "PVP_SUBTLETY" end
        if Rank("HEMORRHAGE") > 0 and Rank("ADRENALINE_RUSH") == 0 then return "PVP_SUBTLETY" end
        if Rank("MUTILATE") > 0 then return "RAID_MUTILATE" end
        if Rank("ADRENALINE_RUSH") > 0 or Rank("COMBAT_POTENCY") > 0 then return "RAID_COMBAT" end
        return "RAID_COMBAT"
    end

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("MUTILATE") > 0 then role = "Leveling_Dagger"
    elseif Rank("HEMORRHAGE") > 0 then role = "Leveling_Hemo"
    end

    local specificKey = role .. suffix
    if Rogue.LevelingWeights[specificKey] then return specificKey end
    
    return "Leveling" .. suffix
end

function Rogue:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- 1. TALENT: Vitality (Agility)
    local rVit = Rank("VITALITY")
    if rVit > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then 
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rVit * 0.01)) 
    end
    
    -- 2. TALENT: Sinister Calling (Agility)
    local rSin = Rank("SINISTER_CALLING")
    if rSin > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then 
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rSin * 0.03)) 
    end

    -- 3. HIT CAP (Yellow Hit: 9% / 142 Rating)
    if weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(6) 
        local baseCap = 142
        local talentBonus = Rank("PRECISION") * 15.8 
        
        if hitRating >= (baseCap - talentBonus + 5) then
            -- Yellow Cap Reached
            if currentSpec:find("COMBAT") or currentSpec:find("Default") then
                -- Combat: White Hit is still valuable
                weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.8 
                table.insert(activeCaps, "Yellow Hit")
            else
                -- PvP/Mutilate: White Hit is less valuable
                weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.5 
                table.insert(activeCaps, "Hit")
            end
        end
    end
    
    -- 4. EXPERTISE CAP (6.5% / ~103 Rating)
    if weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] and weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] > 0.1 then
        local expRating = GetCombatRating(24)
        local _, race = UnitRace("player")
        local humanBonus = (race == "Human") and 20 or 0 -- Approximate
        local talentBonus = Rank("WEAPON_EXPERTISE") * 20 -- 5 Skill per rank (~20 rating equiv)
        
        if (expRating + humanBonus + talentBonus) >= 103 then
             weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5
             table.insert(activeCaps, "Exp")
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Rogue:GetWeaponBonus(itemLink)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Racial: Human (Sword/Mace)
    if race == "Human" and (subClassID == 7 or subClassID == 8 or subClassID == 4 or subClassID == 5) then 
        bonus = bonus + 40 
    end
    -- Racial: Troll (Bow/Thrown)
    if race == "Troll" and (subClassID == 2 or subClassID == 16) then
        bonus = bonus + 35
    end
    -- Racial: Dwarf (Gun)
    if race == "Dwarf" and subClassID == 3 then
        bonus = bonus + 35
    end

    -- Talents
    local function Rank(k) return MSC:GetTalentRank(k) end
    
    if subClassID == 15 and Rank("DAGGER_SPEC") > 0 then bonus = bonus + (Rank("DAGGER_SPEC") * 35.0) end
    if subClassID == 13 and Rank("FIST_SPEC") > 0 then bonus = bonus + (Rank("FIST_SPEC") * 35.0) end
    if (subClassID == 7 or subClassID == 8) and Rank("SWORD_SPEC") > 0 then bonus = bonus + (Rank("SWORD_SPEC") * 35.0) end
    if (subClassID == 4 or subClassID == 5) and Rank("MACE_SPEC") > 0 then bonus = bonus + (Rank("MACE_SPEC") * 25.0) end

    return bonus
end

MSC.RegisterModule("ROGUE", Rogue)