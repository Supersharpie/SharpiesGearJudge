local addonName, MSC = ...
local Priest = {}
Priest.Name = "PRIEST"
-- =============================================================
-- ENDGAME STAT WEIGHTS
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

        -- POISON
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
        
        -- POISON
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
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.3, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.5,
        
        -- POISON
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.1, -- Avoid penalty
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
        -- POISON
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
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Priest.LevelingWeights = {
    -- [[ 1. SHADOW / SPIRIT TAP ]]
    -- Wands are the primary source of damage.
    ["Leveling_1_20"] = { 
        ["MSC_WEAPON_DPS"]=2.5,  -- High value for Wands
        ["ITEM_MOD_SPIRIT_SHORT"]=2.5, -- Spirit Tap
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_21_40"] = { 
        ["MSC_WEAPON_DPS"]=2.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=2.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.8,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_41_51"] = { 
        ["MSC_WEAPON_DPS"]=1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_52_59"] = { 
        ["MSC_WEAPON_DPS"]=1.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.8,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },

    -- [[ 2. SMITE PRIEST ]]
    ["Leveling_Smite_21_40"] = { 
        ["MSC_WEAPON_DPS"]=1.5,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Smite_41_51"] = { 
        ["MSC_WEAPON_DPS"]=1.2,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.5, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.2,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Smite_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.8,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Smite_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.4,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },

    -- [[ 3. HEALER ]]
    ["Leveling_Healer_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.8,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Healer_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.8, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
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
    -- Leveling Brackets
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
    [4]=true, [10]=true, [15]=true, [19]=true -- 1H Mace, Staff, Dagger, Wand
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
    
    if level >= 60 then
        if Rank("VAMPIRIC_TOUCH") > 0 or Rank("SHADOWFORM") > 0 then return "SHADOW_PVE" end
        if Rank("CIRCLE_HEALING") > 0 or Rank("SPIRIT_OF_REDEMPTION") > 0 then return "HOLY_DEEP" end
        if Rank("SEARING_LIGHT") > 0 then return "SMITE_DPS" end
        if Rank("PAIN_SUPP") > 0 or Rank("POWER_INFUSION") > 0 then return "DISC_SUPPORT" end
        return "HOLY_DEEP"
    end

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" -- Default Shadow
    if Rank("SEARING_LIGHT") > 0 then role = "Leveling_Smite"
    elseif Rank("CIRCLE_HEALING") > 0 or Rank("SPIRIT_OF_REDEMPTION") > 0 then role = "Leveling_Healer"
    end 

    local specificKey = role .. suffix
    if Priest.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Priest:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- 1. Enlightenment (Stam/Int/Spirit)
    local rEnlight = Rank("ENLIGHTENMENT")
    if rEnlight > 0 then
        if weights["ITEM_MOD_INTELLECT_SHORT"] then weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rEnlight * 0.01)) end
        if weights["ITEM_MOD_SPIRIT_SHORT"] then weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rEnlight * 0.01)) end
        if weights["ITEM_MOD_STAMINA_SHORT"] then weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEnlight * 0.01)) end
    end
    
    -- 2. Shadow Focus (Hit Cap)
    if currentSpec:find("SHADOW") and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(8) -- Spell Hit
        local baseCap = 202 
        local talentBonus = Rank("SHADOW_FOCUS") * 25.2 -- 2% per rank
        
        if hitRating >= (baseCap - talentBonus + 5) then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02
            table.insert(activeCaps, "Hit")
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Priest:GetWeaponBonus(itemLink) return 0 end

MSC.RegisterModule("PRIEST", Priest)