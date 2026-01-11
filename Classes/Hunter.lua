local addonName, MSC = ...
local Hunter = {}
Hunter.Name = "HUNTER"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Hunter.Weights = {
    ["Default"] = {
        ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["MSC_CRIT_PERCENT"]=25.0, ["MSC_HIT_PERCENT"]=20.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5 
    },
    ["RAID_MM"] = {
        ["MSC_HIT_PERCENT"]=30.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["MSC_CRIT_PERCENT"]=28.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.4 
    },
    ["RAID_SURV"] = {
        -- Survival in Era is all about the Agility 
        ["ITEM_MOD_AGILITY_SHORT"]=3.0, ["MSC_CRIT_PERCENT"]=25.0, ["MSC_HIT_PERCENT"]=25.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 
    },
    ["PVP_ERA"] = {
        ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["MSC_CRIT_PERCENT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 
    }
}

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Hunter.LevelingWeights = {
    ["Leveling_1_20"]  = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_21_40"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["MSC_CRIT_PERCENT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["MSC_HIT_PERCENT"]=10.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
    ["Leveling_52_59"] = { ["MSC_HIT_PERCENT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["MSC_CRIT_PERCENT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
}

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Hunter.Talents = { 
    ["SUREFOOTED"]      = "Surefooted",       -- 3% Hit
    ["BESTIAL_WRATH"]   = "Bestial Wrath",    -- BM 31
    ["TRUESHOT_AURA"]   = "Trueshot Aura",    -- MM 31
    ["WYVERN_STING"]    = "Wyvern Sting",     -- Surv 31
    ["LIGHTNING_REFL"]  = "Lightning Reflexes", -- 15% Agi
    ["RANGED_WEAP_SPEC"]= "Ranged Weapon Specialization"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Hunter:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("WYVERN_STING") > 0 or Rank("LIGHTNING_REFL") > 0 then return "RAID_SURV" end
    if Rank("TRUESHOT_AURA") > 0 then return "RAID_MM" end
    
    return "Default"
end

function Hunter:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Lightning Reflexes (Agi Scaling) - The Era "Expose Weakness"
    local rLR = Rank("LIGHTNING_REFL")
    if rLR > 0 and weights["ITEM_MOD_AGILITY_SHORT"] then 
        weights["ITEM_MOD_AGILITY_SHORT"] = weights["ITEM_MOD_AGILITY_SHORT"] * (1 + (rLR * 0.03)) 
    end
    
    -- 2. Covariance (Crit scales with RAP)
    if weights["MSC_CRIT_PERCENT"] then
        local base, pos, neg = UnitRangedAttackPower("player")
        local totalRAP = base + pos + neg
        if totalRAP > 1500 then
            local rapScaler = 1 + ((totalRAP - 1500) / 10000)
            if rapScaler > 1.2 then rapScaler = 1.2 end
            weights["MSC_CRIT_PERCENT"] = weights["MSC_CRIT_PERCENT"] * rapScaler
        end
    end

    -- 3. Hit Cap (9% for Era)
    if weights["MSC_HIT_PERCENT"] then
        local currentHit = MSC.PlayerStats.Hit or 0
        local talentHit = Rank("SUREFOOTED") -- 1% per rank
        local totalHit = currentHit + talentHit

        if totalHit >= 9 then
            weights["MSC_HIT_PERCENT"] = 2.0 -- Cap reached
            table.insert(activeCaps, "Hit (9%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Hunter:GetWeaponBonus(itemLink)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- Era Racial: Dwarf (Gun) and Troll (Bow) +5 Skill
    -- In Era, +5 Skill is roughly 15-20 score points worth of value
    if race == "Dwarf" and subClassID == 3 then bonus = bonus + 20 end
    if race == "Troll" and subClassID == 2 then bonus = bonus + 20 end
    
    return bonus
end

MSC.RegisterModule("HUNTER", Hunter)