local addonName, MSC = ...
local Shaman = {}
Shaman.Name = "SHAMAN"
-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Shaman.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_MANA_SHORT"]=0.05, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.5,
        ["MSC_WEAPON_DPS"]=1.0
    },

    -- [[ 1. ELEMENTAL ]]
    ["ELE_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 0.5, 
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
    },

    -- [[ 2. ELEMENTAL PVP ]]
    ["ELE_PVP"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_NATURE_DAMAGE_SHORT"]    = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5,
        -- POISON
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
    },

    -- [[ 3. ENHANCEMENT ]]
    ["ENH_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 4.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]       = 1.9, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 2.1, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 2.1, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.6, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]     = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 1.1, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]      = 1.3, 
        ["ITEM_MOD_HASTE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]= 0.4,
        -- POISON
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 0.02, 
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
    },

    -- [[ 4. RESTORATION ]]
    ["RESTO_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 1.0, 
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]= 2.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.9, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.6, 
        -- POISON
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.02,
    },

    -- [[ 5. SHAMAN TANK ]]
    ["SHAMAN_TANK"] = { 
        ["MSC_WEAPON_DPS"]                  = 1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 2.0, 
        ["ITEM_MOD_ARMOR_SHORT"]            = 0.8, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]      = 1.5, 
        ["ITEM_MOD_BLOCK_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_PARRY_RATING_SHORT"]     = 1.2, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.2, 
        ["ITEM_MOD_AGILITY_SHORT"]          = 1.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Shaman.LevelingWeights = {
    ["Leveling_1_20"] = { 
        ["MSC_WEAPON_DPS"]=8.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_21_40"] = { 
        ["MSC_WEAPON_DPS"]=6.0,
        ["MSC_WEAPON_SPEED"]=2.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_41_51"] = { 
        ["MSC_WEAPON_DPS"]=5.5,
        ["MSC_WEAPON_SPEED"]=2.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.1, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_52_59"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["MSC_WEAPON_SPEED"]=2.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.6, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.1, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_60_70"] = { 
        ["MSC_WEAPON_DPS"]=5.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=2.5, 
        ["ITEM_MOD_CRIT_RATING_SHORT"]=1.8, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.1, 
        ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.02
    },
    ["Leveling_Caster_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2,
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Caster_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.4,
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
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
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Tank_1_20"] = { 
        ["MSC_WEAPON_DPS"]=5.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
        ["ITEM_MOD_ARMOR_SHORT"]=0.5, 
        ["ITEM_MOD_SPIRIT_SHORT"]=1.0
    },
    ["Leveling_Tank_21_40"] = { 
        ["MSC_WEAPON_DPS"]=4.0,
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
        ["ITEM_MOD_ARMOR_SHORT"]=0.5, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.2, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8
    },
    ["Leveling_Tank_41_51"] = { 
        ["MSC_WEAPON_DPS"]=4.0,
        ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
        ["ITEM_MOD_ARMOR_SHORT"]=0.5, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]=1.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.8
    },
    ["Leveling_Tank_52_59"] = { 
        ["MSC_WEAPON_DPS"]=3.0,
        ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.5, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0
    },
    ["Leveling_Tank_60_70"] = { 
        ["MSC_WEAPON_DPS"]=3.0,
        ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]=3.0, 
        ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.5
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Shaman.Specs = { [1]="Elemental", [2]="Enhancement", [3]="Restoration" }

Shaman.PrettyNames = {
    ["ELE_PVE"]         = "Raid: Elemental",
    ["ELE_PVP"]         = "PvP: Elemental",
    ["ENH_PVE"]         = "Raid: Enhancement",
    ["RESTO_PVE"]       = "Raid: Restoration",
    ["SHAMAN_TANK"]     = "Tank: Warden",
	-- Leveling Brackets
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
    ["Leveling_Caster_52_59"] = "Elemental (52-59)",
    ["Leveling_Caster_60_70"] = "Elemental (Outland)",
    ["Leveling_Healer_52_59"] = "Resto Dungeon (52-59)",
    ["Leveling_Healer_60_70"] = "Resto Dungeon (Outland)",
    ["Leveling_Tank_1_20"]    = "Shaman Tank (1-20)",
    ["Leveling_Tank_21_40"]   = "Shaman Tank (21-40)",
    ["Leveling_Tank_41_51"]   = "Shaman Tank (41-51)",
    ["Leveling_Tank_52_59"]   = "Shaman Tank (52-59)",
    ["Leveling_Tank_60_70"]   = "Shaman Tank (Outland)",
}

Shaman.SpeedChecks = { ["Default"]={ MH_Slow=true } }

Shaman.ValidWeapons = {
    [0]=true, [1]=true,   -- Axes (1H/2H)
    [4]=true, [5]=true,   -- Maces (1H/2H)
    [10]=true, [13]=true, [15]=true -- Staff, Fist, Dagger
}

Shaman.StatToCritMatrix = { 
    Agi = { {1, 4.0}, {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.0}, {60, 59.5}, {70, 80.0} } 
}

Shaman.Talents = { 
    ["ELEMENTAL_MASTERY"]="Elemental Mastery", 
    ["TOTEM_OF_WRATH"]="Totem of Wrath", 
    ["LIGHTNING_MASTERY"]="Lightning Mastery", 
    ["STORMSTRIKE"]="Stormstrike", 
    ["SHAMANISTIC_RAGE"]="Shamanistic Rage", 
    ["MANA_TIDE"]="Mana Tide Totem", 
    ["EARTH_SHIELD"]="Earth Shield", 
    ["NATURE_GUIDANCE"]="Nature's Guidance", 
    ["ANCESTRAL_KNOW"]="Ancestral Knowledge", 
    ["MENTAL_QUICKNESS"]="Mental Quickness", 
    ["SHIELD_SPEC"]="Shield Specialization", 
    ["ANTICIPATION"]="Anticipation",
    ["DUAL_WIELD_SPEC"]="Dual Wield Specialization"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Shaman:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("TOTEM_OF_WRATH") > 0 then return "ELE_PVE" end
        if Rank("ELEMENTAL_MASTERY") > 0 then return "ELE_PVP" end
        if Rank("LIGHTNING_MASTERY") > 0 then return "ELE_PVE" end
        if Rank("SHAMANISTIC_RAGE") > 0 or Rank("STORMSTRIKE") > 0 then return "ENH_PVE" end
        if Rank("EARTH_SHIELD") > 0 or Rank("MANA_TIDE") > 0 then return "RESTO_PVE" end
        if Rank("SHIELD_SPEC") > 0 and Rank("ANTICIPATION") > 0 then return "SHAMAN_TANK" end
        return "RESTO_PVE"
    end

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" 
    if Rank("SHIELD_SPEC") > 0 and Rank("ANTICIPATION") > 0 then role = "Leveling_Tank"
    elseif Rank("ELEMENTAL_MASTERY") > 0 or Rank("TOTEM_OF_WRATH") > 0 then role = "Leveling_Caster"
    elseif Rank("MANA_TIDE") > 0 or Rank("EARTH_SHIELD") > 0 then role = "Leveling_Healer"
    end 

    local specificKey = role .. suffix
    if Shaman.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Shaman:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- 1. TALENTS
    local rAnc = Rank("ANCESTRAL_KNOW")
    if rAnc > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAnc * 0.01)) 
    end
    
    local rMent = Rank("MENTAL_QUICKNESS")
    if rMent > 0 and weights["ITEM_MOD_ATTACK_POWER_SHORT"] then 
        weights["ITEM_MOD_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_ATTACK_POWER_SHORT"] * 1.1 
    end
    
    -- 2. CAPS
    local baseCap = 142 
    local talentBonus = Rank("NATURE_GUIDANCE") * 15.8
    if currentSpec:find("ENH") and Rank("DUAL_WIELD_SPEC") > 0 then
         -- Dual Wield Hit Cap Logic
         -- Cap is huge (363 rating). But special cap is 142.
         -- If we hit Special Cap, lower weight but DON'T kill it.
         local hitRating = GetCombatRating(6)
         if hitRating >= (baseCap - talentBonus) then
             weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.8 -- Reduced, but still useful for White Dmg
             table.insert(activeCaps, "Yellow Hit")
         end
    elseif weights["ITEM_MOD_HIT_RATING_SHORT"] and weights["ITEM_MOD_HIT_RATING_SHORT"] > 0.1 then
         -- 2H or Tank Logic (Hard Cap)
         local hitRating = GetCombatRating(6)
         if hitRating >= (baseCap - talentBonus) then
             weights["ITEM_MOD_HIT_RATING_SHORT"] = 0.02
             table.insert(activeCaps, "Hit")
         end
    end
    
    -- Spell Hit Cap (Elemental)
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
         local hitRating = GetCombatRating(8)
         -- Elemental Hit Cap is 164 (12.6%) because Totem of Wrath gives 3% + 3% Talents
         local spellCap = 164 
         if Rank("ELEMENTAL_MASTERY") > 0 then spellCap = 76 end -- If deep Ele, likely have Totem + Talents
         
         if hitRating >= spellCap then
             weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02
             table.insert(activeCaps, "Spell Hit")
         end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end

function Shaman:GetWeaponBonus(itemLink) 
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Racial: Orc (Axe/Fist) -> TBC Orcs have axe expertise, not Fist? Checking...
    -- Correct: Orcs get Axe (1H/2H). Trolls get Bow/Thrown.
    if race == "Orc" and (subClassID == 0 or subClassID == 1) then bonus = bonus + 40 end
    
    return bonus
end

-- =============================================================
-- CLASS SPECIFIC ITEMS (Totems)
-- =============================================================
Shaman.Relics = {
    -- [Totem of the Void] (Chamber of Aspects): Lightning Bolt +55
    [28248] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 55 },
    -- [Totem of Healing Rains] (Kara): Chain Heal +87
    [28523] = { ITEM_MOD_HEALING_POWER_SHORT = 87 },
    -- [Totem of the Astral Winds] (Sethekk): Earth Shock +80
    [27815] = { ITEM_MOD_NATURE_DAMAGE_SHORT = 40 }, -- Average value
}

if MSC.RelicDB then
    for id, stats in pairs(Shaman.Relics) do
        MSC.RelicDB[id] = stats
    end
end

MSC.RegisterModule("SHAMAN", Shaman)