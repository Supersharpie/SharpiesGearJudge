local addonName, MSC = ...
local Priest = {}
Priest.Name = "PRIEST"

-- =============================================================
-- ENDGAME STAT WEIGHTS (Static Profiles)
-- =============================================================
Priest.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5,
        ["MSC_WEAPON_DPS"]=0.0, 
    },
    
    -- [[ 1. HOLY (Deep Healing) ]]
    ["HOLY_DEEP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.9, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 1.1, -- Spiritual Guidance
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.6, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.4, 

        -- POISON PROTECTION
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 2. DISC (Support/Efficiency) ]]
    ["DISC_SUPPORT"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.5, -- Max Mana = Rapture
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.9,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.6, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.5,
        
        -- POISON PROTECTION
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 3. SHADOW PVE (Mana Battery) ]]
    ["SHADOW_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.4, -- Cap is #1
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.4, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.3, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.05, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.5,
        
        -- POISON PROTECTION
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.1, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 4. SMITE DPS (Niche) ]]
    ["SMITE_DPS"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_HOLY_DAMAGE_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.7, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.7, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 5. SHADOW PVP ]]
    ["SHADOW_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.0,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.6, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },
}

-- Safety Init
Priest.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (The Interpolation System)
-- =============================================================
Priest.LevelingBrackets = {
    -- [[ 1. SHADOW / SPIRIT TAP (1-20) ]]
    ["Leveling_1_20"] = { 
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"]=3.0, ["ITEM_MOD_SPIRIT_SHORT"]=3.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=0.5
        },
        End = { 
            ["MSC_WEAPON_DPS"]=2.5, ["ITEM_MOD_SPIRIT_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=0.5
        }
    },
    -- [[ 2. SHADOW / SPIRIT TAP (21-40) ]]
    ["Leveling_21_40"] = { 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"]=2.5, ["ITEM_MOD_SPIRIT_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8
        },
        End = { 
            ["MSC_WEAPON_DPS"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=0.8
        }
    },
    -- [[ 3. SHADOW / SPIRIT TAP (41-51) ]]
    ["Leveling_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.2
        },
        End = { 
            ["MSC_WEAPON_DPS"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0
        }
    },
    -- [[ 4. SHADOW / SPIRIT TAP (52-59) ]]
    ["Leveling_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8
        },
        End = { 
            ["MSC_WEAPON_DPS"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5
        }
    },
    -- [[ 5. SHADOW / SPIRIT TAP (60-70) ]]
    ["Leveling_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8 
        }
    },

    -- [[ SMITE PRIEST BRACKETS ]]
    ["Leveling_Smite_21_40"] = { 
        min = 21, max = 40,
        Start = { ["MSC_WEAPON_DPS"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.8 },
        End = { 
            ["MSC_WEAPON_DPS"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0
        }
    },
    ["Leveling_Smite_41_51"] = { 
        min = 41, max = 51,
        Start = { ["MSC_WEAPON_DPS"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0 },
        End = { 
            ["MSC_WEAPON_DPS"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.2
        }
    },
    ["Leveling_Smite_52_59"] = { 
        min = 52, max = 59,
        Start = { ["MSC_WEAPON_DPS"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.0 },
        End = { 
            ["MSC_WEAPON_DPS"]=0.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0
        }
    },
    ["Leveling_Smite_60_70"] = { 
        min = 60, max = 70,
        Start = { ["MSC_WEAPON_DPS"]=0.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2 },
        End = { 
            ["MSC_WEAPON_DPS"]=0.4, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0
        }
    },

    -- [[ HEALER BRACKETS ]]
    ["Leveling_Healer_52_59"] = { 
        min = 52, max = 59,
        Start = { ["ITEM_MOD_HEALING_POWER_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8
        }
    },
    ["Leveling_Healer_60_70"] = { 
        min = 60, max = 70,
        Start = { ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5 },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0
        }
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Priest.Specs = { [1]="Discipline", [2]="Holy", [3]="Shadow" }

Priest.PrettyNames = {
    ["HOLY_DEEP"]       = "Healer: Circle of Healing",
    ["DISC_SUPPORT"]    = "Healer: Discipline (Pain Supp)",
    ["SMITE_DPS"]       = "DPS: Smite (Holy Fire)",
    ["SHADOW_PVE"]      = "DPS: Shadow (Mana Battery)",
    ["SHADOW_PVP"]      = "PvP: Shadow",
    
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
    
    ["Leveling_Smite_21_40"] = "Smite DPS (21-40)",
    ["Leveling_Smite_41_51"] = "Smite DPS (41-51)",
    ["Leveling_Smite_52_59"] = "Smite DPS (52-59)",
    ["Leveling_Smite_60_70"] = "Smite DPS (Outland)",
    
    ["Leveling_Healer_52_59"] = "Dungeon Healer (52-59)",
    ["Leveling_Healer_60_70"] = "Dungeon Healer (Outland)",
}

Priest.SpeedChecks = { ["Default"]={} }

Priest.ValidWeapons = {
    [4]=true,             -- 1H Maces
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

Priest.StatToCritMatrix = { 
    Agi = { {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 59.2}, {70, 80.0} } 
}

Priest.Talents = { 
    ["POWER_INFUSION"]  ="Power Infusion", 
    ["PAIN_SUPP"]       ="Pain Suppression", 
    ["SPIRIT_GUIDANCE"] ="Spiritual Guidance", 
    ["CIRCLE_HEALING"]  ="Circle of Healing", 
    ["SEARING_LIGHT"]   ="Searing Light", 
    ["SPIRIT_OF_REDEMPTION"]="Spirit of Redemption", 
    ["SHADOWFORM"]      ="Shadowform", 
    ["VAMPIRIC_TOUCH"]  ="Vampiric Touch",
    ["ENLIGHTENMENT"]   ="Enlightenment",
    ["SHADOW_FOCUS"]    ="Shadow Focus"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Priest:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level >= 60 then
        if Rank("VAMPIRIC_TOUCH") > 0 or Rank("SHADOWFORM") > 0 then return "SHADOW_PVE" end
        if Rank("CIRCLE_HEALING") > 0 or Rank("SPIRIT_OF_REDEMPTION") > 0 then return "HOLY_DEEP" end
        if Rank("SEARING_LIGHT") > 0 then return "SMITE_DPS" end
        if Rank("PAIN_SUPP") > 0 or Rank("POWER_INFUSION") > 0 then return "DISC_SUPPORT" end
        return "HOLY_DEEP"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("SEARING_LIGHT") > 0 then role = "Leveling_Smite"
    elseif Rank("CIRCLE_HEALING") > 0 or Rank("SPIRIT_OF_REDEMPTION") > 0 then role = "Leveling_Healer"
    end 

    local specificKey = role .. suffix
    if Priest.LevelingBrackets and Priest.LevelingBrackets[specificKey] then return specificKey end
    if Priest.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Priest:GetDynamicWeights()
    local level = UnitLevel("player")
    local specKey = self:GetSpec()

    -- 1. Dynamic Bracket Interpolation
    if Priest.LevelingBrackets and Priest.LevelingBrackets[specKey] then
        local bracket = Priest.LevelingBrackets[specKey]
        local progress = (level - bracket.min) / (bracket.max - bracket.min)
        if progress < 0 then progress = 0 end
        if progress > 1 then progress = 1 end

        local dynamicWeights = {}
        for stat, endValue in pairs(bracket.End) do
            local startValue = bracket.Start[stat] or 0
            dynamicWeights[stat] = startValue + ((endValue - startValue) * progress)
        end
        return dynamicWeights, specKey
    end

    -- 2. Fallback to Static
    if Priest.Weights and Priest.Weights[specKey] then return Priest.Weights[specKey], specKey
    elseif Priest.LevelingWeights and Priest.LevelingWeights[specKey] then return Priest.LevelingWeights[specKey], specKey
    end
    return nil, specKey
end

function Priest:ApplyScalers(weights, currentSpec)
    -- [[ SAFETY COPY ]]
    local w = {}
    for k, v in pairs(weights) do w[k] = v end

    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- [[ 0. SMART SPIRIT SCALING ]]
    if w["ITEM_MOD_SPIRIT_SHORT"] and (currentSpec:find("HOLY") or currentSpec:find("DISC") or currentSpec:find("Healer")) then
        local level = UnitLevel("player")
        local intellect = UnitStat("player", 4) 
        
        local mp5Value = MSC:GetSpiritValueInMP5(level, intellect)
        local combatMult = 0.65
        if currentSpec:find("DISC") then combatMult = 0.60 end
        local mp5Weight = w["ITEM_MOD_MANA_REGENERATION_SHORT"] or 2.5
        
        w["ITEM_MOD_SPIRIT_SHORT"] = mp5Value * mp5Weight * combatMult
    end
    
    -- [[ 1. EXISTING TALENT SCALING ]]
    local rEnlight = Rank("ENLIGHTENMENT")
    if rEnlight > 0 then
        local mult = 1 + (rEnlight * 0.01)
        if w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * mult end
        if w["ITEM_MOD_SPIRIT_SHORT"] then w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * mult end
        if w["ITEM_MOD_STAMINA_SHORT"] then w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * mult end
    end

    local rSpiritGuide = Rank("SPIRIT_GUIDANCE")
    if rSpiritGuide > 0 and w["ITEM_MOD_SPIRIT_SHORT"] then
        local bonus = rSpiritGuide * 0.05
        w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] + (bonus * (w["ITEM_MOD_SPELL_POWER_SHORT"] or 1.0))
    end
    
    -- [[ 2. COVARIANCE ]]
    if currentSpec:find("SHADOW") or currentSpec:find("SMITE") then
        if w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] or w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            local spellPower = 0
            if currentSpec:find("SHADOW") then spellPower = GetSpellBonusDamage(3)
            else spellPower = GetSpellBonusDamage(2) end 
            
            if spellPower > 700 then
                 local spScaler = 1 + ((spellPower - 700) / 10000)
                 if spScaler > 1.2 then spScaler = 1.2 end 
                 
                 if w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
                     w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] * spScaler
                 end
                 if w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
                     w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * spScaler
                 end
            end
        end
    end
    
    -- [[ 3. HIT CAP ]]
    if w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(8) 
        local baseCap = 202 
        local talentBonus = 0
        if currentSpec:find("SHADOW") then
             talentBonus = Rank("SHADOW_FOCUS") * 25.2
        end
        local finalCap = baseCap - talentBonus
        local _, race = UnitRace("player")
        if race == "Draenei" then finalCap = finalCap - 12.6 end
        if finalCap < 0 then finalCap = 0 end
        
        if hitRating >= (finalCap + 15) then
            w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02
            table.insert(activeCaps, "Hit")
        elseif hitRating >= finalCap then
            w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "Hit (Soft)")
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return w, capText
end

function Priest:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- REGISTER PROFILES
-- =============================================================
Priest.Profiles = {}
for k, v in pairs(Priest.Weights) do Priest.Profiles[k] = v end
if Priest.LevelingBrackets then
    for k, v in pairs(Priest.LevelingBrackets) do Priest.Profiles[k] = v.End end
end
if Priest.LevelingWeights then
    for k, v in pairs(Priest.LevelingWeights) do Priest.Profiles[k] = v end
end

MSC.RegisterModule("PRIEST", Priest)