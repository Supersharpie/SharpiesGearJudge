local addonName, MSC = ...
local Warrior = {}
Warrior.Name = "WARRIOR"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Warrior.Weights = {
    ["Default"] = {
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=0.5
    },
    ["RAID_FURY_DW"] = {
        ["MSC_WEAPON_SKILL"]=45.0, -- Priority #1 until +5
        ["MSC_HIT_PERCENT"]=18.0,  -- High value until 6% or 9%
        ["MSC_CRIT_PERCENT"]=30.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
        ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
        ["ITEM_MOD_AGILITY_SHORT"]=1.4
    },
    ["RAID_ARMS_2H"] = {
        ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=8.5, 
        ["MSC_CRIT_PERCENT"]=28.0, 
        ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
        ["MSC_HIT_PERCENT"]=15.0,
        ["ITEM_MOD_AGILITY_SHORT"]=1.2
    },
    ["DEEP_PROT_ERA"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
        ["MSC_DEFENSE_SKILL"]=1.5, 
        ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, 
        ["MSC_HIT_PERCENT"]=12.0, 
        ["MSC_PARRY_PERCENT"]=15.0, 
        ["MSC_DODGE_PERCENT"]=15.0
    }
}

-- =============================================================
-- LEVELING WEIGHTS (The Spirit Meta)
-- =============================================================
Warrior.LevelingWeights = {
    ["Leveling_1_30"]  = { ["ITEM_MOD_SPIRIT_SHORT"]=2.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
    ["Leveling_31_50"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["MSC_CRIT_PERCENT"]=10.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.5 },
    ["Leveling_51_60"] = { ["MSC_HIT_PERCENT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["MSC_WEAPON_SKILL"]=20.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5 }
}

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Warrior.Talents = { 
    ["MORTAL_STRIKE"]   = "Mortal Strike", 
    ["BLOODTHIRST"]     = "Bloodthirst", 
    ["SHIELD_SLAM"]     = "Shield Slam",
    ["PIERCING_HOWL"]   = "Piercing Howl",
    ["WEAP_MASTERY"]    = "Weapon Mastery", -- SoD or Era Specifics
    ["DUAL_WIELD_SPEC"] = "Dual Wield Specialization"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Warrior:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling 
    if level < 60 then
        if level < 30 then return "Leveling_1_30"
        elseif level < 50 then return "Leveling_31_50"
        else return "Leveling_51_60" end
    end

    -- Endgame Spec detection
    if Rank("SHIELD_SLAM") > 0 then return "DEEP_PROT_ERA" end
    if Rank("BLOODTHIRST") > 0 then return "RAID_FURY_DW" end
    if Rank("MORTAL_STRIKE") > 0 then return "RAID_ARMS_2H" end
    
    return "Default"
end

function Warrior:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Yellow Hit Cap (Classic Era: 9% base, 6% with +5 Skill)
    if weights["MSC_HIT_PERCENT"] then
        local currentHit = MSC.PlayerStats.Hit or 0
        
        -- Detect Weapon Skill (Racial + Gear)
        local _, race = UnitRace("player")
        local skillBonus = 0
        if race == "Human" or race == "Orc" then skillBonus = 5 end
        -- (Add logic here to check gear-based skill like Edgemaster's if your MSC scanner supports it)

        local yellowCap = (skillBonus >= 5) and 6 or 9
        
        if currentHit >= yellowCap then
            -- Hit is still good for DW (White hits), but weight drops for 2H
            local mult = (currentSpec:find("DW")) and 0.5 or 0.1
            weights["MSC_HIT_PERCENT"] = weights["MSC_HIT_PERCENT"] * mult
            table.insert(activeCaps, "Yellow Hit ("..yellowCap.."%)")
        end
    end

    -- 2. Weapon Skill Cap (+5 is the breakpoint)
    if weights["MSC_WEAPON_SKILL"] then
        local _, race = UnitRace("player")
        local skillBonus = (race == "Human" or race == "Orc") and 5 or 0
        
        if skillBonus >= 5 then
            weights["MSC_WEAPON_SKILL"] = 8.0 -- Drop from 45.0
            table.insert(activeCaps, "Skill (+5)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Warrior:GetWeaponBonus(itemLink)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Racial: Human (Sword/Mace)
    if race == "Human" and (subClassID == 7 or subClassID == 4 or subClassID == 8 or subClassID == 5) then 
        bonus = bonus + 60 
    end
    -- Racial: Orc (Axes)
    if race == "Orc" and (subClassID == 0 or subClassID == 1) then 
        bonus = bonus + 60 
    end
    
    return bonus
end

MSC.RegisterModule("WARRIOR", Warrior)