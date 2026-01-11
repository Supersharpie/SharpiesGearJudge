local addonName, MSC = ...
local Druid = {}
Druid.Name = "DRUID"
-- =============================================================
-- ENDGAME STAT WEIGHTS
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
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.4, -- Hit Cap is #1
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.5, 
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
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.2, -- 1 Str = 2 AP
        ["ITEM_MOD_AGILITY_SHORT"]          = 2.0, -- 1 Agi = 1 AP + Crit
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]= 1.0, -- FIXED KEY NAME
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.4, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.4,
        
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
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.7, 
        ["ITEM_MOD_ARMOR_SHORT"]            = 0.35, -- Multiplied by Bear (huge)
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.5, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 1.3, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.2, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.0, -- Crit Immunity
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 0.6, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.8, 
        ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]= 0.5, -- FIXED KEY NAME
        
        -- POISON PROTECTION
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
        ["ITEM_MOD_SPIRIT_SHORT"]           = 1.1, -- Intensity
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

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Druid.LevelingWeights = {
    ["Leveling_1_20"] = { 
        ["MSC_WEAPON_DPS"]=0.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02 
    },
    ["Leveling_21_40"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.4, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_41_51"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.4, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0,
        ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.2,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=1.0, -- FIXED KEY
        ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    -- [[ FERAL BEAR LEVELING ]]
    ["Leveling_Bear_21_40"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_ARMOR_SHORT"]=0.4, 
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=0.8, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_Bear_41_51"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_ARMOR_SHORT"]=0.4,
        ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02 
    },
    ["Leveling_Bear_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_ARMOR_SHORT"]=0.4,
        ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02 
    },
    ["Leveling_Bear_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=0.5, -- FIXED KEY
        ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.02,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    -- [[ BOOMKIN LEVELING ]]
    ["Leveling_Caster_41_51"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Caster_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02
    },
    ["Leveling_Caster_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02
    },
    -- [[ HEALER LEVELING ]]
    ["Leveling_Healer_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.2,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02
    },
    ["Leveling_Healer_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.8, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02
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
	
	-- Leveling Brackets
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
    
    ["Leveling_Bear_21_40"]    = "Feral Bear (21-40)",
    ["Leveling_Bear_41_51"]    = "Feral Bear (41-51)",
    ["Leveling_Bear_52_59"]    = "Feral Bear (52-59)",
    ["Leveling_Bear_60_70"]    = "Feral Bear (Outland)",
    
    ["Leveling_Caster_41_51"] = "Balance (41-51)",
    ["Leveling_Caster_52_59"] = "Balance (52-59)",
    ["Leveling_Caster_60_70"] = "Balance (Outland)",
    
    ["Leveling_Healer_52_59"] = "Resto Dungeon (52-59)",
    ["Leveling_Healer_60_70"] = "Resto Dungeon (Outland)",
}

Druid.SpeedChecks = { 
    ["Default"]={} 
}

Druid.ValidWeapons = {
    [4]=true, [5]=true,   -- Maces (1H/2H)
    [10]=true, [15]=true  -- Staff, Dagger
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
    ["THICK_HIDE"]="Thick Hide" 
}

-- =============================================================
-- LOGIC
-- =============================================================
function Druid:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("TREE_OF_LIFE") > 0 then return "RESTO_TREE" end
        if Rank("MOONKIN_FORM") > 0 or Rank("FORCE_OF_NATURE") > 0 then return "BALANCE_PVE" end
        if Rank("MANGLE") > 0 or Rank("FERAL_INSTINCT") > 0 then
            if Rank("THICK_HIDE") >= 3 then return "FERAL_BEAR" end
            return "FERAL_CAT"
        end
        return "FERAL_CAT"
    end

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("MOONKIN_FORM") > 0 then role = "Leveling_Caster"
    elseif Rank("TREE_OF_LIFE") > 0 then role = "Leveling_Healer"
    elseif Rank("THICK_HIDE") >= 3 then role = "Leveling_Bear"
    end 

    local specificKey = role .. suffix
    if Druid.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Druid:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {} -- Store capped stats here
    
    -- [[ 1. EXISTING TALENT SCALERS ]]
    -- Heart of the Wild (Int)
    local rHotW = Rank("HEART_WILD")
    if rHotW > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.04)) 
    end
    
    -- Living Spirit (Spirit)
    local rLiv = Rank("LIVING_SPIRIT")
    if rLiv > 0 and weights["ITEM_MOD_SPIRIT_SHORT"] then 
        weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rLiv * 0.03)) 
    end

    -- [[ 2. COVARIANCE (Synergy) ]]
    -- We must branch by spec because the stats are totally different.

    if currentSpec:find("BALANCE") or currentSpec:find("Caster") then
        -- BALANCE: Haste scales with Spell Power
        if weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
            local spellPower = GetSpellBonusDamage(4) -- 4 = Nature
            if spellPower > 600 then
                 local spScaler = 1 + ((spellPower - 600) / 10000)
                 if spScaler > 1.2 then spScaler = 1.2 end
                 weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] * spScaler
            end
        end

    elseif currentSpec:find("FERAL") or currentSpec:find("Bear") or currentSpec:find("Cat") then
        -- FERAL: Crit scales with Attack Power
        if weights["ITEM_MOD_CRIT_RATING_SHORT"] then
            local base, pos, neg = UnitAttackPower("player")
            local totalAP = base + pos + neg
            
            -- Feral AP is usually higher than Warrior AP, so threshold is 2000
            if totalAP > 2000 then 
                 local apScaler = 1 + ((totalAP - 2000) / 20000)
                 if apScaler > 1.15 then apScaler = 1.15 end
                 weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * apScaler
            end
        end

    elseif currentSpec:find("RESTO") or currentSpec:find("Healer") then
        -- RESTO: Regen scales with Healing Power
        if weights["ITEM_MOD_MANA_REGENERATION_SHORT"] then
            local healPower = GetSpellBonusHealing()
            if healPower > 800 then
                local hScaler = 1 + ((healPower - 800) / 10000)
                if hScaler > 1.2 then hScaler = 1.2 end
                weights["ITEM_MOD_MANA_REGENERATION_SHORT"] = weights["ITEM_MOD_MANA_REGENERATION_SHORT"] * hScaler
            end
        end
    end
    
    -- [[ 3. CAPS with HYSTERESIS (Anti-Loop) ]]
    
    -- A. BALANCE HIT CAP (Spell Hit)
    if (currentSpec:find("BALANCE") or currentSpec:find("Caster")) and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(8) -- CR_HIT_SPELL
        local baseCap = 202 
        local talentBonus = Rank("BALANCE_OF_POWER") * 25.2 -- 2% per rank
        local finalCap = baseCap - talentBonus
        
        -- Hysteresis Buffer: 15 Rating
        if hitRating >= (finalCap + 15) then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02
            table.insert(activeCaps, "Hit")
        elseif hitRating >= finalCap then
            -- "Soft Cap" Zone
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "Hit (Soft)")
        end
    end

    -- B. FERAL HIT CAP (Melee Hit 9%)
    if (currentSpec:find("FERAL") or currentSpec:find("Cat") or currentSpec:find("Bear")) and weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(6)
        local cap = 142
        
        if hitRating >= (cap + 15) then
             if currentSpec:find("Bear") then
                 weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.1 -- Bear hit is low value after cap
             else
                 weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.5 -- Cat white hit still decent
             end
             table.insert(activeCaps, "Hit")
        elseif hitRating >= cap then
             weights["ITEM_MOD_HIT_RATING_SHORT"] = weights["ITEM_MOD_HIT_RATING_SHORT"] * 0.7
             table.insert(activeCaps, "Hit (Soft)")
        end
    end

    -- C. BEAR CRIT IMMUNITY (Def/Resil)
    if (currentSpec:find("FERAL_BEAR") or currentSpec:find("Bear")) and weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] then
        local baseDef, armorDef = UnitDefense("player")
        local defenseSkill = baseDef + armorDef
        local resil = GetCombatRating(15) -- CR_CRIT_TAKEN_MELEE
        
        local reductionNeeded = 5.6
        -- Check for Survival of the Fittest (usually taken with Thick Hide)
        if Rank("THICK_HIDE") >= 3 then reductionNeeded = 2.6 end
        
        local defReduction = (defenseSkill - 350) * 0.04
        if defReduction < 0 then defReduction = 0 end
        local resilReduction = resil / 39.4
        
        local currentReduction = defReduction + resilReduction
        
        -- Hysteresis Buffer: 0.2% reduction (~8 defense skill or ~8 resil)
        -- This prevents the "Equip/Unequip" loop for tanks hovering near the danger zone.
        if currentReduction >= (reductionNeeded + 0.2) then
             weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8
             weights["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 0.5
             table.insert(activeCaps, "Crit Immune")
        elseif currentReduction >= reductionNeeded then
             -- Soft Cap
             weights["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.0
             weights["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 0.8
             table.insert(activeCaps, "Immune (Soft)")
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Druid:GetWeaponBonus(itemLink) return 0 end

-- =============================================================
-- CLASS SPECIFIC ITEMS (Idols)
-- =============================================================
Druid.Relics = {
    -- [Idol of the Raven Goddess] (Swift Flight Form): Healing +20 / Crit +9 / Str +9
    -- This is a "Stat Stick" that works for everyone.
    [32387] = { ITEM_MOD_HEALING_POWER_SHORT = 20, ITEM_MOD_CRIT_RATING_SHORT = 9, ITEM_MOD_STRENGTH_SHORT = 9 },

    -- [Idol of the Moon] (TBC): Moonfire Dmg +33
    [23197] = { ITEM_MOD_ARCANE_DAMAGE_SHORT = 33 },

    -- [Idol of the Avenger] (Shadowmoon): Wrath Dmg +25
    [31037] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 25 },

    -- [Idol of Ursoc] (HFP): Lacerate Dmg +8 per stack (~24 Dmg avg)
    [27483] = { ITEM_MOD_ATTACK_POWER_FERAL_SHORT = 24 },

    -- [Idol of Terror] (Badges): Mangle (Cat) +24 Agi proc (~15 avg) / Mangle (Bear) +50 Dodge (~15 avg)
    -- We assume average uptime makes this worth roughly 15 static stats.
    [30652] = { ITEM_MOD_AGILITY_SHORT = 15, ITEM_MOD_DODGE_RATING_SHORT = 15 },

    -- [Idol of the Wild] (Hellfire): Shred +48 / Maul +48
    -- Roughly equivalent to 40 Attack Power in specific scenarios.
    [28064] = { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 40 },

    -- [Idol of the Emerald Queen] (Shadowmoon): Lifebloom +47
    [27886] = { ITEM_MOD_HEALING_POWER_SHORT = 47 },

    -- [Harold's Rejuvenating Broach] (Quest): Rejuvenation +86
    [25643] = { ITEM_MOD_HEALING_POWER_SHORT = 86 },
}

-- INJECT INTO MAIN DATABASE
if MSC.RelicDB then
    for id, stats in pairs(Druid.Relics) do
        MSC.RelicDB[id] = stats
    end
end

MSC.RegisterModule("DRUID", Druid)