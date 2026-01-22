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

    -- [[ 1. COMBAT (Swords/Maces/Fists) - The PvE King ]]
    ["RAID_COMBAT"] = { 
        ["MSC_WEAPON_DPS"]                  = 6.5, -- Massive weight for Main Hand
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, -- Yellow Cap is priority #1
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.1, -- Dodge reduction is massive DPS gain
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.4, -- DST / Haste Pot meta
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.35,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.1, 
        
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.02,
    },

    -- [[ 2. MUTILATE (Daggers) ]]
    ["RAID_MUTILATE"] = { 
        ["MSC_WEAPON_DPS"]                  = 5.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.6, -- Seal Fate relies on Crit
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.1, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.7, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.8, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.0,
        
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },

    -- [[ 3. SUBTLETY (PvP / Hemo) ]]
    ["PVP_SUBTLETY"] = { 
        ["MSC_WEAPON_DPS"]                  = 3.0, -- Lower priority in PvP than stats
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.8, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.4, -- Sinister Calling = Agi King
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.5, -- Only need 5% cap
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.3, 
        
        -- TRACE VALUES
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
    },
}

-- Safety Init
Rogue.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (The Interpolation System)
-- =============================================================
Rogue.LevelingBrackets = {
    -- [[ 1. STANDARD COMBAT (Swords/Maces/Fists) ]]
    -- Meta: Slow MH (Sinister Strike) / Fast OH (Poisons/Combat Potency)
    ["Leveling_1_20"] = { 
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"]=10.0, 
            ["MSC_WEAPON_SPEED"]=1.0, -- Prefer Slow MH early for big SS hits
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.8, -- 1 Str = 1 AP. Agi is way better.
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"]=10.0, 
            ["MSC_WEAPON_SPEED"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2 
        }
    },
    ["Leveling_21_40"] = { 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"]=10.0, ["MSC_WEAPON_SPEED"]=1.5,
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_HIT_RATING_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 
        },
        End = { 
            ["MSC_WEAPON_DPS"]=12.0, 
            ["MSC_WEAPON_SPEED"]=2.0, 
            ["MSC_OH_WEAPON_SPEED"]=-2.0, -- Start looking for Fast OH (Poisons)
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5,
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2 
        }
    },
    ["Leveling_41_51"] = { -- Combat Potency Era (Fast OH is mandatory)
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"]=12.0, 
            ["MSC_WEAPON_SPEED"]=2.0, ["MSC_OH_WEAPON_SPEED"]=-2.0,
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"]=14.0, 
            ["MSC_WEAPON_SPEED"]=2.5, ["MSC_OH_WEAPON_SPEED"]=-2.5, -- Strong Fast OH preference
            ["ITEM_MOD_AGILITY_SHORT"]=2.8, ["ITEM_MOD_HIT_RATING_SHORT"]=1.8,
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 
        }
    },
    ["Leveling_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"]=14.0, 
            ["MSC_WEAPON_SPEED"]=2.5, ["MSC_OH_WEAPON_SPEED"]=-2.5,
            ["ITEM_MOD_AGILITY_SHORT"]=2.8, ["ITEM_MOD_HIT_RATING_SHORT"]=1.8 
        },
        End = { 
            ["MSC_WEAPON_DPS"]=15.0, 
            ["MSC_WEAPON_SPEED"]=3.0, ["MSC_OH_WEAPON_SPEED"]=-3.0,
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=3.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.0 
        }
    },
    ["Leveling_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"]=15.0, 
            ["MSC_WEAPON_SPEED"]=3.0, ["MSC_OH_WEAPON_SPEED"]=-3.0,
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=3.0 
        },
        End = { 
            ["MSC_WEAPON_DPS"]=18.0, -- Weapon DPS is king for SS
            ["MSC_WEAPON_SPEED"]=4.0, ["MSC_OH_WEAPON_SPEED"]=-4.0, -- Max Speed Logic
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.5, -- Combat loves Hit past cap (White dmg)
            ["ITEM_MOD_AGILITY_SHORT"]=3.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=2.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.5 
        }
    },

    -- [[ 2. DAGGERS (Assassination) ]]
    -- Speed doesn't matter (Daggers are always fast). Focus on Crit/Dagger Skill.
    ["Leveling_Dagger_21_40"] = { 
        min = 21, max = 40,
        Start = { ["MSC_WEAPON_DPS"]=10.0, ["ITEM_MOD_AGILITY_SHORT"]=2.4, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5 },
        End = { ["MSC_WEAPON_DPS"]=12.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.8 }
    },
    ["Leveling_Dagger_41_51"] = { 
        min = 41, max = 51,
        Start = { ["MSC_WEAPON_DPS"]=12.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=2.5 },
        End = { ["MSC_WEAPON_DPS"]=14.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.8, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 }
    },
    ["Leveling_Dagger_52_59"] = { 
        min = 52, max = 59,
        Start = { ["MSC_WEAPON_DPS"]=14.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.8 },
        End = { ["MSC_WEAPON_DPS"]=15.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=2.2, ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.8 }
    },
    ["Leveling_Dagger_60_70"] = { 
        min = 60, max = 70,
        Start = { ["MSC_WEAPON_DPS"]=15.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=2.2, ["ITEM_MOD_AGILITY_SHORT"]=3.0 },
        End = { ["MSC_WEAPON_DPS"]=18.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=3.5, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0 }
    },

    -- [[ 3. HEMO (Subtlety) ]]
    -- Slow MH (Hemo hits harder). OH Speed less important than Combat, but Fast usually better for poisons.
    ["Leveling_Hemo_21_40"] = { 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"]=10.0, 
            ["MSC_WEAPON_SPEED"]=1.5, -- Hemo likes Slow
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_STAMINA_SHORT"]=1.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"]=12.0, 
            ["MSC_WEAPON_SPEED"]=2.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2 
        }
    },
    ["Leveling_Hemo_41_51"] = { 
        min = 41, max = 51,
        Start = { ["MSC_WEAPON_DPS"]=12.0, ["MSC_WEAPON_SPEED"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5 },
        End = { ["MSC_WEAPON_DPS"]=14.0, ["MSC_WEAPON_SPEED"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=2.8, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5 }
    },
    ["Leveling_Hemo_60_70"] = { 
        min = 60, max = 70,
        Start = { ["MSC_WEAPON_DPS"]=15.0, ["MSC_WEAPON_SPEED"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=2.8 },
        End = { 
            ["MSC_WEAPON_DPS"]=18.0, ["MSC_WEAPON_SPEED"]=3.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=3.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 
        }
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
    [13]=true, [15]=true, -- Fists, Daggers
    [2]=true, [3]=true, [18]=true, [16]=true -- Bow, Gun, Crossbow, Thrown
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
    ["WEAPON_EXPERTISE"]= "Weapon Expertise",
	["DUAL_WIELD_SPEC"] = "Dual Wield Specialization"	
}

-- =============================================================
-- LOGIC
-- =============================================================
function Rogue:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level == 70 then
        if Rank("SHADOWSTEP") > 0 or Rank("CHEAT_DEATH") > 0 then return "PVP_SUBTLETY" end
        if Rank("HEMORRHAGE") > 0 and Rank("ADRENALINE_RUSH") == 0 then return "PVP_SUBTLETY" end
        if Rank("MUTILATE") > 0 then return "RAID_MUTILATE" end
        if Rank("ADRENALINE_RUSH") > 0 or Rank("COMBAT_POTENCY") > 0 then return "RAID_COMBAT" end
        return "RAID_COMBAT"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
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
    
    -- [[ BRACKET CHECK ]]
    if Rogue.LevelingBrackets and Rogue.LevelingBrackets[specificKey] then return specificKey end
    
    -- [[ FALLBACK TO STATIC ]]
    if Rogue.LevelingWeights and Rogue.LevelingWeights[specificKey] then return specificKey end
    
    return "Leveling" .. suffix
end

function Rogue:GetDynamicWeights()
    local level = UnitLevel("player")
    local specKey = self:GetSpec()

    if self.LevelingBrackets and self.LevelingBrackets[specKey] then
        local bracket = self.LevelingBrackets[specKey]
        local progress = (level - bracket.min) / (bracket.max - bracket.min)
        progress = math.max(0, math.min(1, progress))

        local dynamicWeights = {}
        for stat, endValue in pairs(bracket.End) do
            local startValue = bracket.Start[stat] or 0
            dynamicWeights[stat] = startValue + ((endValue - startValue) * progress)
        end
        return dynamicWeights, specKey
    end

    if self.Weights and self.Weights[specKey] then return self.Weights[specKey], specKey end
    return self.Weights["Default"], specKey
end

function Rogue:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- [[ 1. DUAL WIELD SCALING ]]
    if currentSpec:find("COMBAT") or currentSpec:find("Default") or currentSpec:find("Leveling") then
        -- Default OH penalty is 0.5. Talent adds 10-50%.
        -- 5/5 DW Spec = 50% * 1.5 = 75% Damage.
        local dwTalent = Rank("DUAL_WIELD_SPEC") or 0 -- Need to add DUAL_WIELD_SPEC to Rogue.Talents
        local ohMult = 0.5 + (dwTalent * 0.05) -- 0.5 to 0.75
        weights["MSC_WEAPON_DPS_OH"] = ohMult

        -- [[ 2. AUTO-SPEED LOGIC ]]
        -- If we want Slow MH (Positive), force Fast OH (Negative)
        if not weights["MSC_OH_WEAPON_SPEED"] and weights["MSC_WEAPON_SPEED"] and weights["MSC_WEAPON_SPEED"] > 0 then
             weights["MSC_OH_WEAPON_SPEED"] = -1 * weights["MSC_WEAPON_SPEED"]
        end
    end

    -- [[ 0. ARPEN SCALING ]]
    if weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] then
        local arPen = GetCombatRating(25)
        if arPen > 100 then
            local scaler = 1 + (arPen / 1000)
            if scaler > 1.4 then scaler = 1.4 end
            weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = weights["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] * scaler
        end
    end
    
    -- [[ 1. TALENT SCALERS ]]
    local rVit = Rank("VITALITY")
    if rVit > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then 
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rVit * 0.01)) 
    end
    
    local rSin = Rank("SINISTER_CALLING")
    if rSin > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then 
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rSin * 0.03)) 
    end

    -- [[ 2. COVARIANCE (Crit scales with AP) ]]
    if weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        local base, pos, neg = UnitAttackPower("player")
        local totalAP = base + pos + neg
        
        if totalAP > 1000 then
            local apScaler = 1 + ((totalAP - 1000) / 20000)
            if apScaler > 1.15 then apScaler = 1.15 end
            weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * apScaler
        end
    end

    -- [[ 3. HIT CAP (With Hysteresis) ]]
    if weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(6) 
        local baseCap = 142
        local talentBonus = Rank("PRECISION") * 15.8 
        local finalCap = baseCap - talentBonus
        
        if finalCap < 0 then finalCap = 0 end

        -- Hysteresis Buffer: 15 Rating
        if hitRating >= (finalCap + 15) then
            -- Safely Capped (Yellow)
            if currentSpec:find("COMBAT") or currentSpec:find("Default") or currentSpec:find("Leveling") then
                -- Combat still wants hit for White Damage (Dual Wield Cap is 28%)
                weights["ITEM_MOD_HIT_RATING_SHORT"] = 1.0 
                table.insert(activeCaps, "Yellow Hit")
            else
                weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.5 
                table.insert(activeCaps, "Hit")
            end
        elseif hitRating >= finalCap then
            -- "Twilight Zone" (Softened Weight)
            weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * 0.8
            table.insert(activeCaps, "Hit (Soft)")
        end
    end
    
    -- [[ 4. EXPERTISE CAP ]]
    if weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] and weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] > 0.1 then
        local expRating = GetCombatRating(24)
        local _, race = UnitRace("player")
        
        -- Check if we are using a Racial weapon
        local humanBonus = 0
        if race == "Human" then
             local itemLink = GetInventoryItemLink("player", 16)
             if itemLink then
                 local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
                 if classID == 2 and (subClassID == 7 or subClassID == 4) then -- Sword/Mace
                     humanBonus = 20
                 end
             end
        end
        
        local talentBonus = Rank("WEAPON_EXPERTISE") * 20 
        local totalExp = expRating + humanBonus + talentBonus
        
        if totalExp >= (103 + 10) then
             weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.5
             table.insert(activeCaps, "Exp")
        elseif totalExp >= 103 then
             weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] = weights["ITEM_MOD_EXPERTISE_RATING_SHORT"] * 0.8
             table.insert(activeCaps, "Exp (Soft)")
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
    if race == "Human" and (subClassID == 7 or subClassID == 4) then 
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
    if subClassID == 7 and Rank("SWORD_SPEC") > 0 then bonus = bonus + (Rank("SWORD_SPEC") * 35.0) end
    if subClassID == 4 and Rank("MACE_SPEC") > 0 then bonus = bonus + (Rank("MACE_SPEC") * 25.0) end

    return bonus
end

-- =============================================================
-- REGISTER PROFILES
-- =============================================================
Rogue.Profiles = {}
for k, v in pairs(Rogue.Weights) do Rogue.Profiles[k] = v end
if Rogue.LevelingBrackets then
    for k, v in pairs(Rogue.LevelingBrackets) do Rogue.Profiles[k] = v.End end
end
if Rogue.LevelingWeights then
    for k, v in pairs(Rogue.LevelingWeights) do Rogue.Profiles[k] = v end
end

MSC.RegisterModule("ROGUE", Rogue)