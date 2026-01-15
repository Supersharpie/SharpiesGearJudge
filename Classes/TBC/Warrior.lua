local addonName, MSC = ...
local Warrior = {}
Warrior.Name = "WARRIOR"

-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Warrior.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5,
        ["MSC_WEAPON_DPS"]=2.0 
    },
    
    -- [[ 1. FURY DW (Dual Wield) ]]
    ["FURY_DW"] = { 
        ["MSC_WEAPON_DPS"]                  = 6.0, -- King for Fury
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.35,
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.3, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.5,            
        -- POISON PROTECTION
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 2. FURY 2H (Slam Spec) ]]
    ["FURY_2H"] = { 
        ["MSC_WEAPON_DPS"]                  = 6.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.2, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.35, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.5,               
        -- POISON PROTECTION
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },    
    
    -- [[ 3. ARMS PVE ]]
    ["ARMS_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 5.0,
		["MSC_WEAPON_SPEED"]			  	= 15.0,		
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.3, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.5, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.4, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.0, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.1, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.4,
        -- POISON PROTECTION
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },      
    
    -- [[ 4. ARMS PVP ]]
    ["ARMS_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 4.5,
		["MSC_WEAPON_SPEED"] 				= 15.0,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.8,  
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.5, -- Cap is low (5%)
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.0,              
        -- POISON PROTECTION
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },      
    
    -- [[ 5. DEEP_PROT (Tank) ]]
    ["DEEP_PROT"] = { 
        ["MSC_WEAPON_DPS"]                  = 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.6, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 2.4, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]      = 0.7, -- Shield Slam scale
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 1.0, 
        ["ITEM_MOD_PARRY_RATING_SHORT"]     = 1.0, 
        ["ITEM_MOD_BLOCK_RATING_SHORT"]     = 0.9, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.6, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.6, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.5,              
        -- POISON PROTECTION
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02, 
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Warrior.LevelingWeights = {
    -- [[ 1. UNIVERSAL STARTER (1-20) ]]
    ["Leveling_1_20"] = { 
        ["MSC_WEAPON_DPS"]=10.0, 
        ["ITEM_MOD_ARMOR_SHORT"]=0.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=2.0, -- High regen value
        ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=3.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=0.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=0.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02 
    },
    -- [[ 2. ARMS / 2H LEVELING (Mortal Strike) ]]
    ["Leveling_2H_21_40"] = { 
        ["MSC_WEAPON_DPS"]=8.0, 
        ["MSC_WEAPON_SPEED"]=2.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_2H_41_51"] = { 
        ["MSC_WEAPON_DPS"]=6.0,
        ["MSC_WEAPON_SPEED"]=1.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.4, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_2H_52_59"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["MSC_WEAPON_SPEED"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_2H_60_70"] = { 
        ["MSC_WEAPON_DPS"]=5.0, 
        ["MSC_WEAPON_SPEED"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.3,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },      
    -- [[ 3. FURY / DW LEVELING ]]
    ["Leveling_DW_21_40"] = { 
        ["MSC_WEAPON_DPS"]=6.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_DW_41_51"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_DW_52_59"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_DW_60_70"] = { 
        ["MSC_WEAPON_DPS"]=4.5,
        ["ITEM_MOD_HIT_RATING_SHORT"]=2.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.4, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.0,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    -- [[ 4. TANK LEVELING ]]
    ["Leveling_Tank_21_40"] = { 
        ["MSC_WEAPON_DPS"]=4.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.2, 
        ["ITEM_MOD_ARMOR_SHORT"]=0.1, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.5, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Tank_41_51"] = { 
        ["MSC_WEAPON_DPS"]=3.0,
        ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Tank_52_59"] = { 
        ["MSC_WEAPON_DPS"]=2.0,
        ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02
    },
    ["Leveling_Tank_60_70"] = { 
        ["MSC_WEAPON_DPS"]=2.0,
        ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_PARRY_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Warrior.Specs = { [1]="Arms", [2]="Fury", [3]="Protection" }

Warrior.PrettyNames = {
    ["FURY_2H"]         = "Raid: Arms/Fury (2H)",
    ["FURY_DW"]         = "Raid: Fury (Dual Wield)",
    ["ARMS_PVP"]        = "PvP: Arms (Mortal Strike)",
    ["ARMS_PVE"]        = "Raid: Arms (Blood Frenzy)",
    ["DEEP_PROT"]       = "Tank: Deep Protection",
    -- Leveling Brackets
    ["Leveling_2H_1_20"]  = "Starter (1-20)",
    ["Leveling_2H_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_2H_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_2H_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_2H_60_70"] = "Standard Leveling (Outland)",
    ["Leveling_DW_21_40"]    = "Fury/DW (21-40)",
    ["Leveling_DW_41_51"]    = "Fury/DW (41-51)",
    ["Leveling_DW_52_59"]    = "Fury/DW (52-59)",
    ["Leveling_DW_60_70"]    = "Fury/DW (Outland)",
    ["Leveling_Tank_21_40"] = "Dungeon Tank (21-40)",
    ["Leveling_Tank_41_51"] = "Dungeon Tank (41-51)",
    ["Leveling_Tank_52_59"] = "Dungeon Tank (52-59)",
    ["Leveling_Tank_60_70"] = "Dungeon Tank (Outland)",
}
Warrior.SpeedChecks = { 
    ["Default"]={ MH_Slow=true }, 
    ["FURY_DW"]={ MH_Slow=true, OH_Fast=true }, 
    ["DEEP_PROT"]={ MH_Fast=true } 
}
Warrior.ValidWeapons = {
    [0]=true, [1]=true,   -- Axes
    [4]=true, [5]=true,   -- Maces
    [7]=true, [8]=true,   -- Swords
    [6]=true, [10]=true,  -- Polearm, Staff
    [13]=true, [15]=true, -- Fist, Dagger
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Xbow, Thrown
}
Warrior.StatToCritMatrix = { 
    Agi = { {1, 4.0}, {60, 20.0}, {70, 33.0} } 
}
Warrior.Talents = { 
    ["PRECISION"]       = "Precision",
    ["MORTAL_STRIKE"]   = "Mortal Strike",
    ["ENDLESS_RAGE"]    = "Endless Rage",
    ["BLOOD_FRENZY"]    = "Blood Frenzy",
    ["SECOND_WIND"]     = "Second Wind",
    ["BLOODTHIRST"]     = "Bloodthirst",
    ["RAMPAGE"]         = "Rampage",
    ["SHIELD_SLAM"]     = "Shield Slam",
    ["DEVASTATE"]       = "Devastate",
    ["VITALITY"]        = "Vitality",
    ["POLEAXE_SPEC"]    = "Poleaxe Specialization",
    ["SWORD_SPEC"]      = "Sword Specialization",
    ["MACE_SPEC"]       = "Mace Specialization"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Warrior:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("DEVASTATE") > 0 or Rank("SHIELD_SLAM") > 0 then return "DEEP_PROT" end
        if Rank("RAMPAGE") > 0 or Rank("BLOODTHIRST") > 0 then return "FURY_DW" end
        if Rank("MORTAL_STRIKE") > 0 then
            if Rank("BLOOD_FRENZY") > 0 then return "ARMS_PVE" end
            return "ARMS_PVP"
        end
        return "FURY_DW"
    end

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

local role = "Leveling_2H" -- Default Role
    
    if Rank("SHIELD_SLAM") > 0 or Rank("DEVASTATE") > 0 then role = "Leveling_Tank"
    elseif Rank("BLOODTHIRST") > 0 or Rank("RAMPAGE") > 0 then role = "Leveling_DW"
    end

    local specificKey = role .. suffix
    
    if Warrior.LevelingWeights[specificKey] then return specificKey end
    if Warrior.LevelingWeights["Leveling" .. suffix] then return "Leveling" .. suffix end
    return "Leveling_2H" .. suffix
end

function Warrior:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 0. 2H SPECIALIZATION ENFORCER ]]
    if currentSpec and (currentSpec:find("ARMS") or currentSpec:find("2H")) then
        weights["MSC_WEAPON_DPS_OH"] = 0
    end

    -- [[ 1. ARPEN SCALING (The TBC Meta) ]]
    -- ArPen value increases exponentially as you stack it.
    if weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] then
        local arPen = GetCombatRating(25) -- Armor Pen Rating
        if arPen > 100 then
            -- Boost the weight by up to 40% as you get more gear
            local scaler = 1 + (arPen / 1000) 
            if scaler > 1.4 then scaler = 1.4 end
            weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] * scaler
        end
    end

	-- [[ 2. HIT CAP (Smart Fury Logic) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(6) 
        local baseCap = 142 -- 9% (Yellow Cap)
        local talentBonus = Rank("PRECISION") * 15.8
        local finalCap = baseCap - talentBonus
        if finalCap < 0 then finalCap = 0 end
        
        -- Hysteresis Buffer
        if hitRating >= (finalCap + 15) then
            -- CHECK SPEC: Is this Fury?
            if currentSpec:find("FURY") or currentSpec:find("DW") then
                -- Fury: Hit is still good for Rage generation (White Hit Cap is 28%)
                -- We drop it below Str/Crit, but keep it useful (0.8 ~ 1.0)
                weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.8
                table.insert(activeCaps, "Y-Hit (Rage)")
            else
                -- Arms/Prot: Hit is effectively useless after Yellow Cap
                weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.1
                table.insert(activeCaps, "Hit")
            end
            
        elseif hitRating >= finalCap then
            -- Soft Cap Zone (Approaching Yellow Cap)
            -- If Fury, keep it high (1.4). If Arms, drop it (0.4).
            if currentSpec:find("FURY") or currentSpec:find("DW") then
                 weights["ITEM_MOD_HIT_RATING_SHORT"] = 1.4
            else
                 weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * 0.4
            end
            table.insert(activeCaps, "Hit (Soft)")
        end
    end

    -- [[ 3. DEFENSE CAP (Effective Health Pivot) ]]
    if weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] and weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] > 1.0 then
        local baseDef, armorDef = UnitDefense("player")
        if (baseDef + armorDef) >= 490 then
            -- 1. Drop Defense Value
            weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8
            table.insert(activeCaps, "Def")
            
            -- 2. Boost Stamina/Armor (Effective Health is King for Capped Tanks)
            weights["ITEM_MOD_STAMINA_SHORT"] = (weights["ITEM_MOD_STAMINA_SHORT"] or 1.5) * 1.3
            weights["ITEM_MOD_ARMOR_SHORT"] = (weights["ITEM_MOD_ARMOR_SHORT"] or 0.1) * 1.5
        end
    end

    -- [[ 4. EXPERTISE CAP ]]
    if weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] and weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] > 0.1 then
        local expRating = GetCombatRating(24)
        local _, raceID = UnitRace("player") -- Use ID for safety (Human/Orc)
        
        -- Rough estimate: 20 rating ~= 5 skill
        local racialBonus = (raceID == "Human" or raceID == "Orc") and 20 or 0 
        
        -- 103 rating is roughly the dodge cap (6.5%)
        if (expRating + racialBonus) >= 103 then
            weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] = weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] * 0.5
            table.insert(activeCaps, "Exp")
        end
    end

    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Warrior:GetWeaponBonus(itemLink)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Racials (Human/Orc can use both 1H and 2H versions of these weapons)
    if race == "Human" and (subClassID == 7 or subClassID == 8 or subClassID == 4 or subClassID == 5) then bonus = bonus + 40 end
    if race == "Orc" and (subClassID == 0 or subClassID == 1) then bonus = bonus + 40 end

    -- Talents
    local function Rank(k) return MSC:GetTalentRank(k) end
    if subClassID == 0 or subClassID == 1 or subClassID == 6 then
        local rank = Rank("POLEAXE_SPEC")
        if rank > 0 then bonus = bonus + (rank * 35.0) end
    end
    if subClassID == 7 or subClassID == 8 then
        local rank = Rank("SWORD_SPEC")
        if rank > 0 then bonus = bonus + (rank * 35.0) end
    end
    if subClassID == 4 or subClassID == 5 then
        local rank = Rank("MACE_SPEC")
        if rank > 0 then bonus = bonus + (rank * 10.0) end
    end

    return bonus
end

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
Warrior.Profiles = {}
for k, v in pairs(Warrior.Weights) do Warrior.Profiles[k] = v end
for k, v in pairs(Warrior.LevelingWeights) do Warrior.Profiles[k] = v end

MSC.RegisterModule("WARRIOR", Warrior)