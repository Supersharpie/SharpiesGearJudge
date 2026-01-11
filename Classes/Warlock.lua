local addonName, MSC = ...
local Warlock = {}
Warlock.Name = "WARLOCK"

-- =============================================================
-- ENDGAME STAT WEIGHTS
-- =============================================================
Warlock.Weights = {
    ["Default"] = { 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_STAMINA_SHORT"]=0.8, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.3, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
        ["MSC_WEAPON_DPS"]=0.0 
    },

    -- [[ 1. DESTRUCTION SHADOW ]]
    ["DESTRUCT_SHADOW"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        -- POISON PROTECTION
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 0.02, 
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 2. DESTRUCTION FIRE ]]
    ["DESTRUCT_FIRE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.4, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        -- POISON PROTECTION
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 0.02,
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 3. RAID AFFLICTION ]]
    ["RAID_AFFLICTION"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.4, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.5, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.6, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.3,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]      = 0.02,
    },

    -- [[ 4. DEMO PVE ]]
    ["DEMO_PVE"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.3, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]= 0.8, 
        ["ITEM_MOD_STAMINA_SHORT"]          = 0.9, -- High base for Demonic Knowledge
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.6, 
        ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]= 0.9, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },

    -- [[ 5. PVP SL/SL ]]
    ["PVP_SL_SL"] = { 
        ["MSC_WEAPON_DPS"]                  = 0.0,
        ["ITEM_MOD_STAMINA_SHORT"]          = 1.8, -- King Stat
        ["ITEM_MOD_RESILIENCE_RATING_SHORT"]= 1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]      = 1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]        = 0.8, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.3, 
        ["ITEM_MOD_SPIRIT_SHORT"]           = 0.2,
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]    = 1.0,
        -- POISON PROTECTION
        ["ITEM_MOD_STRENGTH_SHORT"]         = 0.02,
        ["ITEM_MOD_AGILITY_SHORT"]          = 0.02,
        ["ITEM_MOD_HEALING_POWER_SHORT"]    = 0.02,
    },
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Warlock.LevelingWeights = {
    ["Leveling_1_20"] = { 
        ["MSC_WEAPON_DPS"]=0.0, 
        ["MSC_WAND_DPS"]=2.0, -- Wand is primary DPS
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_21_40"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=1.5, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_41_51"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=0.8, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=0.4,
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=0.8,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=0.1, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8, 
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    -- [[ DESTRUCTION LEVELING ]]
    ["Leveling_Fire_21_40"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=1.2, 
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Fire_41_51"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=0.8,
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Fire_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=0.4,
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.8, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Fire_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=0.1,
        ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_STAMINA_SHORT"]=1.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    -- [[ DEMO LEVELING ]]
    ["Leveling_Demo_21_40"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=1.0,
        ["ITEM_MOD_STAMINA_SHORT"]=2.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Demo_41_51"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=0.6,
        ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
        ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Demo_52_59"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=0.2,
        ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
    ["Leveling_Demo_60_70"] = { 
        ["MSC_WEAPON_DPS"]=0.0,
        ["MSC_WAND_DPS"]=0.1,
        ["ITEM_MOD_STAMINA_SHORT"]=3.5, 
        ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
        ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.4, 
        ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
        ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0,
        ["ITEM_MOD_STRENGTH_SHORT"]=0.02,
        ["ITEM_MOD_AGILITY_SHORT"]=0.02
    },
}

-- =============================================================
-- CLASS METADATA
-- =============================================================
Warlock.Specs = { [1]="Affliction", [2]="Demonology", [3]="Destruction" }

Warlock.PrettyNames = {
    ["DESTRUCT_SHADOW"]  = "Raid: Destruction (Shadow)",
    ["DESTRUCT_FIRE"]    = "Raid: Destruction (Fire)",
    ["RAID_AFFLICTION"]  = "Raid: Affliction (UA)",
    ["DEMO_PVE"]         = "Raid: Demonology (Felguard)",
    ["PVP_SL_SL"]        = "PvP: Soul Link / Siphon Life",
    -- Leveling Brackets
    ["Leveling_1_20"]  = "Starter (1-20)",
    ["Leveling_21_40"] = "Standard Leveling (21-40)",
    ["Leveling_41_51"] = "Standard Leveling (41-51)",
    ["Leveling_52_59"] = "Standard Leveling (52-59)",
    ["Leveling_60_70"] = "Standard Leveling (Outland)",
    ["Leveling_Fire_21_40"] = "Destro Fire (21-40)",
    ["Leveling_Fire_41_51"] = "Destro Fire (41-51)",
    ["Leveling_Fire_52_59"] = "Destro Fire (52-59)",
    ["Leveling_Fire_60_70"] = "Destro Fire (Outland)",
    
    ["Leveling_Demo_21_40"] = "Demonology (21-40)",
    ["Leveling_Demo_41_51"] = "Demonology (41-51)",
    ["Leveling_Demo_52_59"] = "Demonology (52-59)",
    ["Leveling_Demo_60_70"] = "Demonology (Outland)",
}

Warlock.SpeedChecks = { ["Default"]={} }

Warlock.ValidWeapons = {
    [7]=true, [10]=true, [15]=true, [19]=true -- 1H Sword, Staff, Dagger, Wand
}

Warlock.StatToCritMatrix = { 
    Agi = { {60, 20.0}, {70, 25.0} }, 
    Int = { {1, 6.5}, {60, 60.6}, {70, 80.0} } 
}

Warlock.Talents = { 
    ["DARK_PACT"]       = "Dark Pact", 
    ["UNSTABLE_AFF"]    = "Unstable Affliction", 
    ["SIPHON_LIFE"]     = "Siphon Life", 
    ["SOUL_LINK"]       = "Soul Link", 
    ["SUMMON_FELGUARD"] = "Summon Felguard", 
    ["CONFLAGRATE"]     = "Conflagrate", 
    ["RUIN"]            = "Ruin", 
    ["SHADOWFURY"]      = "Shadowfury", 
    ["DEMONIC_EMBRACE"] = "Demonic Embrace", 
    ["FEL_INTELLECT"]   = "Fel Intellect",
    ["EMBERSTORM"]      = "Emberstorm",
    ["SUPPRESSION"]     = "Suppression",
    ["DEMONIC_KNOWLEDGE"] = "Demonic Knowledge" -- Added for Logic
}

-- =============================================================
-- LOGIC
-- =============================================================
function Warlock:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    if level >= 60 then
        if Rank("SUMMON_FELGUARD") > 0 then return "DEMO_PVE" end
        if Rank("SIPHON_LIFE") > 0 and Rank("SOUL_LINK") > 0 then return "PVP_SL_SL" end
        if Rank("UNSTABLE_AFF") > 0 or Rank("DARK_PACT") > 0 then return "RAID_AFFLICTION" end
        if Rank("EMBERSTORM") > 0 or Rank("CONFLAGRATE") > 0 then return "DESTRUCT_FIRE" end
        if Rank("RUIN") > 0 or Rank("SHADOWFURY") > 0 then return "DESTRUCT_SHADOW" end
        return "Default"
    end

    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    local role = "Leveling" -- Affliction
    if Rank("CONFLAGRATE") > 0 or Rank("SHADOWFURY") > 0 then role = "Leveling_Fire"
    elseif Rank("SUMMON_FELGUARD") > 0 or Rank("SOUL_LINK") > 0 then role = "Leveling_Demo"
    end 

    local specificKey = role .. suffix
    if Warlock.LevelingWeights[specificKey] then return specificKey end
    return "Leveling" .. suffix
end

function Warlock:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    
    -- [[ 1. EXISTING TALENTS ]]
    local rEmb = Rank("DEMONIC_EMBRACE")
    if rEmb > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then 
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03)) 
    end
    
    local rFel = Rank("FEL_INTELLECT")
    if rFel > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rFel * 0.01)) 
    end

    -- [[ 2. DEMONIC KNOWLEDGE ]]
    -- Demo Locks gain SP from Stamina/Int. We boost their value if this talent is taken.
    local rDemoKnow = Rank("DEMONIC_KNOWLEDGE")
    if rDemoKnow > 0 then
        -- Approx 5% value boost to Stam/Int per rank (converting pet stats to master SP)
        local boost = rDemoKnow * 0.05
        if weights["ITEM_MOD_STAMINA_SHORT"] then 
            weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] + boost
        end
        if weights["ITEM_MOD_INTELLECT_SHORT"] then 
            weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] + boost
        end
    end

    -- [[ 3. COVARIANCE (Destro Loves Crit/Haste) ]]
    if currentSpec:find("DESTRUCT") then
        local spellPower = 0
        if currentSpec:find("SHADOW") then spellPower = GetSpellBonusDamage(3) 
        else spellPower = GetSpellBonusDamage(2) end
        
        if spellPower > 800 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            -- Boost Crit/Haste value as SP climbs
            local scaler = 1 + ((spellPower - 800) / 10000)
            if scaler > 1.15 then scaler = 1.15 end
            weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * scaler
            if weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] then
                 weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] = weights["ITEM_MOD_SPELL_HASTE_RATING_SHORT"] * scaler
            end
        end
    end
    
    -- [[ 4. HIT CAP with HYSTERESIS ]]
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] and weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] > 0.1 then
        local hitRating = GetCombatRating(8) 
        local baseCap = 202 -- 16%
        local talentBonus = 0
        
        -- Suppression: 2% per rank (Affliction)
        if currentSpec:find("AFFLICTION") or currentSpec:find("Leveling") then
             talentBonus = Rank("SUPPRESSION") * 25.2 
        end
        
        local finalCap = baseCap - talentBonus

        -- Check Draenei
        local _, race = UnitRace("player")
        if race == "Draenei" then finalCap = finalCap - 12.6 end

        if finalCap < 0 then finalCap = 0 end
        
        -- BUFFER LOGIC
        if hitRating >= (finalCap + 15) then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.02
            table.insert(activeCaps, "Hit")
        elseif hitRating >= finalCap then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] * 0.4
            table.insert(activeCaps, "Hit (Soft)")
        end
    end
    
    local capText = (#activeCaps > 0) and table.concat(activeCaps, ", ") or nil
    return weights, capText
end
function Warlock:GetWeaponBonus(itemLink) return 0 end

MSC.RegisterModule("WARLOCK", Warlock)