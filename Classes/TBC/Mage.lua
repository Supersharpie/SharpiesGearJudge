local addonName, MSC = ...
local Mage = {}
Mage.Name = "MAGE"

-- =============================================================
-- ENDGAME STAT WEIGHTS (Static Profiles)
-- =============================================================
Mage.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
        ["MSC_WEAPON_DPS"]=0.02 
    },

    -- [[ 1. ARCANE (Mana Battery / Burst) ]]
    ["ARCANE_RAID"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.2, -- King Stat (Mind Mastery)
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.7, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.6, -- Arcane Meditation
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 2. FIRE (Crit / Ignite) ]]
    ["FIRE_RAID"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.95, -- Ignite
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 3. FROST PVE (Safe DPS) ]]
    ["FROST_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]     = 1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.6, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.5, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 4. FROST PVP ]]
    ["FROST_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]     = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.6, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5, 
        ["MSC_PVP_UTILITY"]                 = 1.0,
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 5. FROST AOE ]]
    ["FROST_AOE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.5, -- Mana Pool
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_FROST_DAMAGE_SHORT"]     = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.1, -- Blizzard doesn't crit
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.1, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.1,
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },
}

-- Safety Init
Mage.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (The Interpolation System)
-- =============================================================
Mage.LevelingBrackets = {
    -- [[ 1. STANDARD FROST (Single Target) ]]
    -- Wand DPS is king early.
    ["Leveling_1_20"] = { 
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, -- Mana > Health for single target
            ["ITEM_MOD_STAMINA_SHORT"]=0.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        },
        End = { 
            ["MSC_WEAPON_DPS"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        }
    },
    ["Leveling_21_40"] = { 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8,
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,      -- ADDED (Progression to 1.2)
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=0.8, -- ADDED (Progression to 1.0)
            ["ITEM_MOD_SPIRIT_SHORT"]=0.3        -- ADDED (Progression to 0.2)
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.2 
        }
    },
    ["Leveling_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.6, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.2 -- RESTORED (Bridge Gap)
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1 -- RESTORED (Fading out)
        }
    },
    ["Leveling_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.5 -- RESTORED (Bridge Gap)
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.5 -- RESTORED
        }
    },
    ["Leveling_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2,
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.5,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.5 -- RESTORED (Bridge Gap)
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.1, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.2 -- RESTORED
        }
    },

    -- [[ 6. FIRE LEVELING ]]
    -- Crit is vital for Master of Elements (Mana Sustain).
    ["Leveling_Fire_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.8, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, -- ADDED (Progression to 1.5)
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0          -- ADDED (Progression to 1.2)
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.5, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, -- High Crit Priority
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2 
        }
    },
	["Leveling_Fire_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.5, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2,
            ["ITEM_MOD_STAMINA_SHORT"]=0.5 -- ADDED (Starting fade in)
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.2, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, -- Scaling up
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, -- Scaling down to match lvl 60 start
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2,
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 -- Matches lvl 60 start
        }
    },
    ["Leveling_Fire_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.2, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, -- ADDED (Progression to 2.2)
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2,   -- ADDED (Matched End)
            ["ITEM_MOD_STAMINA_SHORT"]=1.0      -- ADDED (Progression to 1.2)
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.1, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2 
        }
    },

    -- [[ 7. AOE BLIZZARD LEVELING ]]
    -- Stamina (Don't Die) > Int (Don't OOM) > SP (Kill).
    ["Leveling_AoE_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.1, 
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.8,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2, -- ADDED (Progression to 0.5)
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5       -- ADDED (Matched End)
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.1, 
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        }
    },
    ["Leveling_AoE_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.1, 
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=2.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5, -- ADDED (Progression to 0.8)
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5       -- ADDED (Matched End)
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.1, 
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=2.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        }
    },
    ["Leveling_AoE_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.1, 
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=2.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, -- ADDED (Progression to 1.2)
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5       -- ADDED (Matched End)
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.1, 
            ["ITEM_MOD_STAMINA_SHORT"]=3.5, -- Effective Health is King
            ["ITEM_MOD_INTELLECT_SHORT"]=3.0, -- Mana Pool is Queen
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, -- Spell Power is just a nice bonus
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        }
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Mage.Specs = { [1]="Arcane", [2]="Fire", [3]="Frost" }

Mage.PrettyNames = {
    ["FIRE_RAID"]        = "Raid: Deep Fire",
    ["ARCANE_RAID"]      = "Raid: Arcane (Mind Mastery)",
    ["FROST_PVE"]        = "Raid: Deep Frost",
    ["FROST_PVP"]        = "PvP: Frost",
    ["FROST_AOE"]        = "Farming: AoE Blizzard",
    
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
    
    ["Leveling_Fire_21_40"] = "Fire (21-40)",
    ["Leveling_Fire_41_51"] = "Fire (41-51)",
    ["Leveling_Fire_52_59"] = "Fire (52-59)",
    ["Leveling_Fire_60_70"] = "Fire (Outland)",
    
    ["Leveling_AoE_21_40"] = "Frost AoE Grind (21-40)",
    ["Leveling_AoE_41_51"] = "Frost AoE Grind (41-51)",
    ["Leveling_AoE_52_59"] = "Frost AoE Grind (52-59)",
    ["Leveling_AoE_60_70"] = "Frost AoE Grind (Outland)",
}

Mage.SpeedChecks = { 
    ["Default"]={} 
}

Mage.ValidWeapons = {
    [7]=true,             -- 1H Swords
    [15]=true,            -- Daggers
    [10]=true,            -- Staves
    [19]=true             -- Wands
}

Mage.StatToCritMatrix = { 
    Agi = { {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 59.5}, {70, 80.0} } 
}

Mage.Talents = { 
    ["ELEMENTAL_PRECISION"] = "Elemental Precision",
    ["ARCANE_POWER"]    ="Arcane Power", 
    ["SLOW"]            ="Slow", 
    ["COMBUSTION"]      ="Combustion", 
    ["DRAGONS_BREATH"]  ="Dragon's Breath", 
    ["ICE_BARRIER"]     ="Ice Barrier", 
    ["SUMMON_WELE"]     ="Summon Water Elemental", 
    ["WINTERS_CHILL"]   ="Winter's Chill", 
    ["IMP_BLIZZARD"]    ="Improved Blizzard", 
    ["ARCANE_MIND"]     ="Arcane Mind", 
    ["MOLTEN_ARMOR"]    ="Molten Armor", 
    ["ICY_VEINS"]       ="Icy Veins",
    ["ARCANE_FOCUS"]    ="Arcane Focus",
    ["MIND_MASTERY"]    ="Mind Mastery"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Mage:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level >= 60 then
        if Rank("DRAGONS_BREATH") > 0 or Rank("COMBUSTION") > 0 then return "FIRE_RAID" end
        if Rank("SLOW") > 0 or Rank("ARCANE_POWER") > 0 then return "ARCANE_RAID" end
        if Rank("SUMMON_WELE") > 0 or Rank("ICE_BARRIER") > 0 then
            if Rank("IMP_BLIZZARD") > 0 and Rank("WINTERS_CHILL") == 0 then return "FROST_AOE" end
            if Rank("WINTERS_CHILL") > 0 then return "FROST_PVE" end
            return "FROST_PVP"
        end
        return "FROST_PVP"
    end

    -- [[ LEVELING BRACKET CALCULATION ]]
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    -- Determine Role
    local role = "Leveling" 
    if Rank("IMP_BLIZZARD") >= 2 then role = "Leveling_AoE"
    elseif Rank("DRAGONS_BREATH") > 0 or Rank("COMBUSTION") > 0 then role = "Leveling_Fire"
    end 

    local specificKey = role .. suffix
    if Mage.LevelingBrackets and Mage.LevelingBrackets[specificKey] then return specificKey end
    if Mage.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Mage:GetDynamicWeights(forceKey)
    -- [[ FIX 1: TRANSLATOR ]]
    -- If the dropdown sends a "Pretty Name" (e.g. "Standard Leveling..."), 
    -- we reverse-lookup the "Code Key" (e.g. "Leveling_2H...").
    if forceKey and not Mage.LevelingBrackets[forceKey] and not Mage.Weights[forceKey] then
        if Mage.PrettyNames then
            for key, name in pairs(Mage.PrettyNames) do
                if name == forceKey then
                    forceKey = key
                    break
                end
            end
        end
    end

    local level = UnitLevel("player")
    local specKey = forceKey or self:GetSpec() 

    -- 1. Check Leveling Brackets
    if Mage.LevelingBrackets and Mage.LevelingBrackets[specKey] then
        local bracket = Mage.LevelingBrackets[specKey]
        
        -- Calculate progress
        local progress = (level - bracket.min) / (bracket.max - bracket.min)
        
        -- [[ FIX 2: PREVIEW CLAMPING ]]
        -- If previewing a different level bracket, force progress to 0 or 1 
        -- to prevent "Negative Stats" from vanishing.
        if forceKey then
            if level < bracket.min then progress = 0 end -- Show Start weights
            if level > bracket.max then progress = 1 end -- Show End weights
        else
            -- Normal play strict clamping
            if progress < 0 then progress = 0 end
            if progress > 1 then progress = 1 end
        end

        local dynamicWeights = {}
        
        -- [[ FIX 3: ROBUSTNESS ]]
        -- Collect ALL keys so nothing vanishes if you made a typo in Start vs End
        local allStats = {}
        if bracket.Start then for k in pairs(bracket.Start) do allStats[k] = true end end
        if bracket.End then for k in pairs(bracket.End) do allStats[k] = true end end

        for stat, _ in pairs(allStats) do
            local startValue = (bracket.Start and bracket.Start[stat]) or 0
            local endValue = (bracket.End and bracket.End[stat]) or 0
            
            local result = startValue + ((endValue - startValue) * progress)
            
            -- Safety: Never return negative weight
            if result < 0 then result = 0 end
            
            dynamicWeights[stat] = result
        end
        
        return dynamicWeights, specKey
    end

    -- 2. Static Weights Fallback
    if Mage.Weights and Mage.Weights[specKey] then 
        return Mage.Weights[specKey], specKey
    elseif Mage.LevelingWeights and Mage.LevelingWeights[specKey] then 
        return Mage.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Mage:ApplyScalers(weights, currentSpec)
    -- [[ SAFETY COPY ]]
    local w = {}
    for k, v in pairs(weights) do w[k] = v end

    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- [[ 1. MIND MASTERY / ARCANE MIND ]]
    local rMindMastery = Rank("MIND_MASTERY")
    if rMindMastery > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
        local bonusRatio = rMindMastery * 0.05 
        w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] + (bonusRatio * (w["ITEM_MOD_SPELL_POWER_SHORT"] or 1.0))
    end

    local rArcaneMind = Rank("ARCANE_MIND")
    if rArcaneMind > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then 
        w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rArcaneMind * 0.03)) 
    end
    
    -- [[ 2. COVARIANCE ]]
    if w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        local spellPower = GetSpellBonusDamage(2) -- Frost
        if spellPower > 500 then
            local spScaler = 1 + ((spellPower - 500) / 2000)
            if spScaler > 1.15 then spScaler = 1.15 end
            w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * spScaler
        end
    end

    -- [[ 3. HIT CAP (Smart Leveling Detection) ]]
    if w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local spellHitRating = GetCombatRating(8) 
        
        -- Default to Raid Cap (16% ~ 202 Rating)
        local hitCapNeeded = 202 
        
        -- [[ LEVELING ADJUSTMENT ]]
        -- If we are in a Leveling bracket, we only need ~6% hit (Level + 2 mobs max)
        -- 6% Hit * 12.6 Rating = ~76 Rating
        if currentSpec:find("Leveling") then
            hitCapNeeded = 76
        end
        
        -- PvP Adjustment
        if currentSpec:find("PVP") then hitCapNeeded = 50 end -- ~4%
        
        -- Talent Reductions
        local arcaneBonus = Rank("ARCANE_FOCUS") * 25.2    -- 2% per rank
        local frostFireBonus = Rank("ELEMENTAL_PRECISION") * 12.6 -- 1% per rank
        
        -- Subtract the best active talent (usually don't have both active for main nuke)
        hitCapNeeded = hitCapNeeded - math.max(arcaneBonus, frostFireBonus)
        
        -- Draenei Racial
        local _, race = UnitRace("player")
        if race == "Draenei" then hitCapNeeded = hitCapNeeded - 12.6 end
        
        if hitCapNeeded < 0 then hitCapNeeded = 0 end

        if spellHitRating >= (hitCapNeeded + 15) then
            w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.05 
            table.insert(activeCaps, "Hit")
        elseif spellHitRating >= hitCapNeeded then
            w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "Hit (Soft)")
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return w, capText
end

function Mage:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
Mage.Profiles = {}
for k, v in pairs(Mage.Weights) do Mage.Profiles[k] = v end
if Mage.LevelingBrackets then
    for k, v in pairs(Mage.LevelingBrackets) do Mage.Profiles[k] = v.End end
end
if Mage.LevelingWeights then
    for k, v in pairs(Mage.LevelingWeights) do Mage.Profiles[k] = v end
end

MSC.RegisterModule("MAGE", Mage)