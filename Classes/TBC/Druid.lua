local addonName, MSC = ...
local Druid = {}
Druid.Name = "DRUID"

-- =============================================================
-- ENDGAME STAT WEIGHTS (Static Profiles)
-- =============================================================
Druid.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["MSC_WEAPON_DPS"]=0.0, 
    },

    -- [[ 1. BALANCE (Boomkin) ]]
    ["BALANCE_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.4,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.7, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.3, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.4,
        
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 0.02,
        ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]= 0.02,
    },

    -- [[ 2. FERAL CAT (DPS) ]]
    ["FERAL_CAT"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.8, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.9, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.1, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.8, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]= 1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.8,
        
        -- POISON PROTECTION
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.02,    
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 3. FERAL BEAR (Tank) ]]
    ["FERAL_BEAR"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,    
        -- SURVIVAL
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.8, 
        ["ITEM_MOD_ARMOR_SHORT"]            = 0.18,      
        -- MITIGATION
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.6,      
        -- AVOIDANCE
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 1.4, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.3, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.0,    
        -- THREAT
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.5, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.6,      
        -- OFFENSIVE
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.0, 
        ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]= 0.5,
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 0.8,      
        -- TRASH
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.002,    
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.002,
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.002,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.002,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.002,
        ["ITEM_MOD_PARRY_RATING_SHORT"]     = 0.002, 
        ["ITEM_MOD_BLOCK_RATING_SHORT"]     = 0.002, 
    },

    -- [[ 4. RESTO (Healer) ]]
    ["RESTO_TREE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 1.1, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.7, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.6, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.3,
        
        -- POISON PROTECTION
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02,
    },
}

-- Safety Init
Druid.LevelingWeights = {}

-- =============================================================
-- DYNAMIC LEVELING BRACKETS (The Interpolation System)
-- =============================================================
Druid.LevelingBrackets = {
    -- [[ GENERIC / FERAL START ]]
    ["Leveling_1_20"] = { 
        min = 1, max = 20,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, -- Useless
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, -- 2 AP
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, -- 1 AP + Crit + Dodge (Buffed from 1.0)
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=0.8
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5
        }
    },
    
    -- [[ FERAL CAT LEVELING ]]
    -- Focus: Str (Raw AP) > Agi (Crit/AP). 
    -- Feral AP appears on weapons in Outland.
    ["Leveling_21_40"] = { 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8 -- Omen of Clarity helps mana issues
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        }
    },
    ["Leveling_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2
        }
    },
    ["Leveling_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5
        }
    },
    ["Leveling_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=1.0, -- Crucial for Outland Weapons
            ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.8, -- 1 Str = 2 AP
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=2.0 
        }
    },
    
    -- [[ FERAL BEAR LEVELING ]]
    -- Agility Buffed: It gives Armor/Dodge/Crit/AP. It is better than Str for Tanks.
    ["Leveling_Bear_21_40"] = { 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, -- Bonus Armor is HUGE
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, -- Buffed from 0.8
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0 
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_ARMOR_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, -- Agi > Str
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.2 
        }
    },
    ["Leveling_Bear_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_ARMOR_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_ARMOR_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5,
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=0.5
        }
    },
    ["Leveling_Bear_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_ARMOR_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8,
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_ARMOR_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5
        }
    },
    ["Leveling_Bear_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=0.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.8
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=4.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_DODGE_RATING_SHORT"]=2.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.5, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5 
        }
    },
    
    -- [[ BOOMKIN LEVELING ]]
    -- Int is King (Lunar Guidance + Dreamstate).
    ["Leveling_Caster_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, -- Buffed for Lunar Guidance
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.2
        }
    },
    ["Leveling_Caster_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2
        }
    },
    ["Leveling_Caster_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=2.5, -- Int is massive for Boomkin sustain/dmg
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5 
        }
    },
    
    -- [[ HEALER LEVELING (Dungeon Spam) ]]
    ["Leveling_Healer_21_40"] = { 
        min = 21, max = 40,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, -- Mana Pool is vital early
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, -- High regen
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, -- "of Healing" greens start appearing
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 
        }
    },
    ["Leveling_Healer_41_51"] = { 
        min = 41, max = 51,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.0, 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5 
        }
    },
    ["Leveling_Healer_52_59"] = { 
        min = 52, max = 59,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.0, -- Spirit > Mp5 for Druids (Tree/Intensity)
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5
        }
    },
    ["Leveling_Healer_60_70"] = { 
        min = 60, max = 70,
        Start = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5
        },
        End = { 
            ["MSC_WEAPON_DPS"]=0.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=3.0, -- Tree of Life Aura makes Spirit God Tier
            ["ITEM_MOD_INTELLECT_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.2
        }
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Druid.Specs = { [1]="Balance", [2]="FeralCombat", [3]="Restoration" }

Druid.PrettyNames = {
    ["BALANCE_PVE"]       = "DPS: Balance (Boomkin)",
    ["RESTO_TREE"]        = "Healer: Tree of Life",
    ["FERAL_CAT"]         = "DPS: Feral Cat",
    ["FERAL_BEAR"]        = "Tank: Feral Bear",
    
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Feral Cat (21-40)",
    ["Leveling_41_51"] = "Feral Cat (41-51)",
    ["Leveling_52_59"] = "Feral Cat (52-59)",
    ["Leveling_60_70"] = "Feral Cat (Outland)",
    
    ["Leveling_Bear_21_40"]    = "Feral Bear (21-40)",
    ["Leveling_Bear_41_51"]    = "Feral Bear (41-51)",
    ["Leveling_Bear_52_59"]    = "Feral Bear (52-59)",
    ["Leveling_Bear_60_70"]    = "Feral Bear (Outland)",
    
    ["Leveling_Caster_41_51"] = "Balance (41-51)",
    ["Leveling_Caster_52_59"] = "Balance (52-59)",
    ["Leveling_Caster_60_70"] = "Balance (Outland)",
	
	["Leveling_Healer_21_40"] = "Resto Dungeon (21-40)",
    ["Leveling_Healer_41_51"] = "Resto Dungeon (41-51)",
    ["Leveling_Healer_52_59"] = "Resto Dungeon (52-59)",
    ["Leveling_Healer_60_70"] = "Resto Dungeon (Outland)",
}

Druid.SpeedChecks = { 
    ["Default"]={} 
}

Druid.ValidWeapons = {
    [4]=true, [5]=true,   -- 1H/2H Maces
    [10]=true,            -- Staves
    [13]=true,            -- Fist Weapons
    [15]=true             -- Daggers
}

Druid.StatToCritMatrix = { 
    Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.5}, {60, 60.0}, {70, 80.0} } 
}

Druid.Talents = { 
    ["MOONKIN_FORM"]="Moonkin Form", 
    ["FORCE_OF_NATURE"]="Force of Nature", 
    ["MANGLE"]="Mangle", 
    ["TREE_OF_LIFE"]="Tree of Life", 
    ["NATURES_GRACE"]="Nature's Grace", 
    ["HEART_WILD"]="Heart of the Wild", 
    ["LIVING_SPIRIT"]="Living Spirit", 
    ["DREAMSTATE"]="Dreamstate", 
    ["MOONGLOW"]="Moonglow", 
    ["NATURES_SWIFTNESS"]="Nature's Swiftness", 
    ["FERAL_INSTINCT"]="Feral Instinct",
    ["BALANCE_OF_POWER"] = "Balance of Power",  
    ["THICK_HIDE"]="Thick Hide",
    ["SURVIVAL_OF_FITTEST"] = "Survival of the Fittest",
    ["FERAL_CHARGE"]="Feral Charge",
	["INSECT_SWARM"]="Insect Swarm",
	["LUNAR_GUIDANCE"]="Lunar Guidance"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Druid:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- [[ ENDGAME DETECTION ]]
    if level >= 60 then
        if Rank("TREE_OF_LIFE") > 0 then return "RESTO_TREE" end
        if Rank("MOONKIN_FORM") > 0 or Rank("FORCE_OF_NATURE") > 0 then return "BALANCE_PVE" end
        if Rank("MANGLE") > 0 or Rank("FERAL_INSTINCT") > 0 then
            if Rank("THICK_HIDE") >= 3 then return "FERAL_BEAR" end
            return "FERAL_CAT"
        end
        return "FERAL_CAT"
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
    if Rank("MOONKIN_FORM") > 0 then role = "Leveling_Caster"
    -- FIX: Check for Tree (50+) OR Nature's Swiftness (21+) OR Insect Swarm (21+)
    elseif Rank("TREE_OF_LIFE") > 0 or Rank("NATURES_SWIFTNESS") > 0 or Rank("INSECT_SWARM") > 0 then 
        role = "Leveling_Healer"
    elseif Rank("FERAL_CHARGE") > 0 or Rank("THICK_HIDE") >= 3 then role = "Leveling_Bear"
    end 

    local specificKey = role .. suffix

    -- [[ FALLBACK CHECKS ]]
    if Druid.LevelingBrackets and Druid.LevelingBrackets[specificKey] then return specificKey end
    if Druid.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Druid:GetDynamicWeights(forceKey)
    -- [[ FIX 1: TRANSLATOR ]]
    -- If the dropdown sends a "Pretty Name" (e.g. "Standard Leveling..."), 
    -- we reverse-lookup the "Code Key" (e.g. "Leveling_2H...").
    if forceKey and not Druid.LevelingBrackets[forceKey] and not Druid.Weights[forceKey] then
        if Druid.PrettyNames then
            for key, name in pairs(Druid.PrettyNames) do
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
    if Druid.LevelingBrackets and Druid.LevelingBrackets[specKey] then
        local bracket = Druid.LevelingBrackets[specKey]
        
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
    if Druid.Weights and Druid.Weights[specKey] then 
        return Druid.Weights[specKey], specKey
    elseif Druid.LevelingWeights and Druid.LevelingWeights[specKey] then 
        return Druid.LevelingWeights[specKey], specKey
    end

    return nil, specKey
end

function Druid:ApplyScalers(weights, currentSpec)
    -- [[ SAFETY COPY ]]
    local w = {}
    for k, v in pairs(weights) do w[k] = v end

    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {} 
    
    -- [[ 1. EXISTING TALENT SCALERS ]]
    -- Heart of the Wild (Int)
    local rHotW = Rank("HEART_WILD")
    if rHotW > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then 
        w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.04)) 
    end
    
    -- Living Spirit (Spirit) - FIX: 5% per rank, not 3%
    local rLiv = Rank("LIVING_SPIRIT")
    if rLiv > 0 and w["ITEM_MOD_SPIRIT_SHORT"] then 
        w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rLiv * 0.05)) 
    end

    -- [[ LUNAR GUIDANCE (Int -> SP) ]]
    local rLunar = Rank("LUNAR_GUIDANCE") -- You need to add this to Druid.Talents!
    if rLunar > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
        -- 8/16/25% of Int converted to Spell Damage
        local ratio = rLunar * 0.083 -- Approx 8.3% per rank
        local spWeight = w["ITEM_MOD_SPELL_POWER_SHORT"] or 1.0
        w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] + (ratio * spWeight)
    end

    -- [[ 2. COVARIANCE (Synergy) ]]
    if currentSpec:find("BALANCE") or currentSpec:find("Caster") then
        if w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
            local spellPower = GetSpellBonusDamage(4) -- 4 = Nature
            if spellPower > 600 then
                 local spScaler = 1 + ((spellPower - 600) / 10000)
                 if spScaler > 1.2 then spScaler = 1.2 end
                 w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = w["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] * spScaler
            end
        end

    elseif currentSpec:find("FERAL") or currentSpec:find("Bear") or currentSpec:find("Cat") then
        if w["ITEM_MOD_CRIT_RATING_SHORT"] then
            local base, pos, neg = UnitAttackPower("player")
            local totalAP = base + pos + neg
            if totalAP > 2000 then 
                 local apScaler = 1 + ((totalAP - 2000) / 20000)
                 if apScaler > 1.15 then apScaler = 1.15 end
                 w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * apScaler
            end
        end
        
        if (currentSpec:find("FERAL_CAT") or currentSpec:find("Cat")) and w["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] then
            local arPen = GetCombatRating(25)
            if arPen > 100 then
                local scaler = 1 + (arPen / 1000)
                if scaler > 1.4 then scaler = 1.4 end
                w["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = w["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] * scaler
            end
        end

    elseif currentSpec:find("RESTO") or currentSpec:find("Healer") then
        -- [[ SMART SPIRIT SCALING ]]
        if w["ITEM_MOD_SPIRIT_SHORT"] then
            local level = UnitLevel("player")
            local intellect = UnitStat("player", 4) -- Stat 4 = Intellect
            
            -- 1. Get raw MP5 gained from 1 Spirit
            local mp5Value = MSC:GetSpiritValueInMP5(level, intellect)
            
            -- 2. Combat Regeneration Uptime (Intensity)
            local combatMult = 0.65
            
            -- 3. Convert to Score
            local mp5Weight = w["ITEM_MOD_MANA_REGENERATION_SHORT"] or 2.0
            
            -- New Spirit Weight = (MP5 gained) * (Value of MP5) * (Combat Uptime)
            w["ITEM_MOD_SPIRIT_SHORT"] = mp5Value * mp5Weight * combatMult
        end
    end
    
    -- [[ 3. CAPS with HYSTERESIS ]]
    
    -- A. BALANCE HIT CAP (Spell Hit)
    if (currentSpec:find("BALANCE") or currentSpec:find("Caster")) and w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(8) -- CR_HIT_SPELL
        local baseCap = 202 
        local talentBonus = Rank("BALANCE_OF_POWER") * 25.2 -- 2% per rank
        local finalCap = baseCap - talentBonus
        if finalCap < 0 then finalCap = 0 end
        
        if hitRating >= (finalCap + 15) then
            w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02
            table.insert(activeCaps, "Hit")
        elseif hitRating >= finalCap then
            w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = w["ITEM_MOD_HIT_SPELL_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "Hit (Soft)")
        end
    end

    -- B. FERAL HIT CAP (Melee Hit 9%)
    if (currentSpec:find("FERAL") or currentSpec:find("Cat") or currentSpec:find("Bear")) and w["ITEM_MOD_HIT_RATING_SHORT"] and w["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(6)
        local cap = 142
        
        if hitRating >= (cap + 15) then
             if currentSpec:find("Bear") then
                 w["ITEM_MOD_HIT_RATING_SHORT"] = 0.1 
             else
                 w["ITEM_MOD_HIT_RATING_SHORT"] = 0.5 
             end
                table.insert(activeCaps, "Hit")
        elseif hitRating >= cap then
            w["ITEM_MOD_HIT_RATING_SHORT"] = w["ITEM_MOD_HIT_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "Hit (Soft)")
        end
    end

    -- C. BEAR CRIT IMMUNITY (Def/Resil)
    if (currentSpec:find("FERAL_BEAR") or currentSpec:find("Bear")) and w["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] then
        local baseDef, armorDef = UnitDefense("player")
        local defenseSkill = baseDef + armorDef
        local resil = GetCombatRating(15) 
        
        local reductionNeeded = 5.6
        if Rank("SURVIVAL_OF_FITTEST") >= 3 then 
            reductionNeeded = 2.6 
        end
        
        local defReduction = (defenseSkill - 350) * 0.04
        if defReduction < 0 then defReduction = 0 end
        local resilReduction = resil / 39.4
        local currentReduction = defReduction + resilReduction
        
        -- HYSTERESIS
        if currentReduction >= (reductionNeeded + 0.2) then
             w["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.6
             w["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 0.5
             table.insert(activeCaps, "Crit Immune")
             
             w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * 1.2
             w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * 1.2
             
        elseif currentReduction >= reductionNeeded then
             w["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.0
             w["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 0.8
             table.insert(activeCaps, "Immune (Soft)")
        else
             w["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 2.5
             w["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 2.5
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return w, capText
end

function Druid:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- CLASS SPECIFIC ITEMS (Idols)
-- =============================================================
Druid.Relics = {
	-- [[ CLASSIC OP ITEMS ]]
    [8345] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 80 }, -- Wolfshead Helm (Manual weighting to force it to win)
    -- [[ LEVELING / CLASSIC IDOLS ]]
    [22398] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 20 },
    [22396] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 20 },
    [22397] = { ITEM_MOD_HEALING_POWER_SHORT = 50 },
    [22330] = { ITEM_MOD_HEALING_POWER_SHORT = 50 },
    [23197] = { ITEM_MOD_ARCANE_DAMAGE_SHORT = 33 },

    -- [[ TBC DUNGEON / QUEST ]]
    [25643] = { ITEM_MOD_HEALING_POWER_SHORT = 86 },
    [28064] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 40 },
    [27526] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 30 },
    [27483] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 24 },
    [27886] = { ITEM_MOD_HEALING_POWER_SHORT = 47 },
    [31037] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 25 },

    -- [[ TBC RAID ]]
    [29390] = { ITEM_MOD_HEALING_POWER_SHORT = 136 },
    [29391] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 45 },
    [27885] = { ITEM_MOD_HEALING_POWER_SHORT = 65 },
    [32387] = { ITEM_MOD_HEALING_POWER_SHORT = 44, ITEM_MOD_CRIT_RATING_SHORT = 40, ITEM_MOD_SPELL_CRIT_RATING_SHORT = 40 },
    [30652] = { ITEM_MOD_AGILITY_SHORT = 45, ITEM_MOD_DODGE_RATING_SHORT = 45 },
    [32257] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 70 },
    [38295] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 60 },
    
    -- [[ PVP IDOLS ]]
    [28355] = { ITEM_MOD_HEALING_POWER_SHORT = 87 },
    [33076] = { ITEM_MOD_HEALING_POWER_SHORT = 105 },
    [33841] = { ITEM_MOD_HEALING_POWER_SHORT = 116 },
    [35021] = { ITEM_MOD_HEALING_POWER_SHORT = 131 },
    [28356] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 },
    [33074] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 },
    [33840] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 },
    [35020] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 },
    [28357] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 26 },
    [33075] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 31 },
    [33842] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 34 },
    [35019] = { ITEM_MOD_RESILIENCE_RATING_SHORT = 39 },
}

-- =============================================================
-- REGISTER PROFILES FOR INIT (UI LIST ONLY)
-- =============================================================
Druid.Profiles = {}
for k, v in pairs(Druid.Weights) do Druid.Profiles[k] = v end
if Druid.LevelingBrackets then
    for k, v in pairs(Druid.LevelingBrackets) do Druid.Profiles[k] = v.End end
end
if Druid.LevelingWeights then
    for k, v in pairs(Druid.LevelingWeights) do Druid.Profiles[k] = v end
end
MSC.RegisterModule("DRUID", Druid)