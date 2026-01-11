local addonName, MSC = ...
local Priest = {}
Priest.Name = "PRIEST"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Priest.Weights = {
    ["Default"] = {
        ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0 
    },
    ["HOLY_RAID"] = {
        ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, -- Higher weight for Spiritual Guidance
        ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 
    },
    ["DISC_PI"] = {
        ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 
    },
    ["SHADOW_PVE"] = {
        ["MSC_SPELL_HIT_PERCENT"]=20.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.4, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
    }
}

-- =============================================================
-- LEVELING WEIGHTS (Spirit is King)
-- =============================================================
Priest.LevelingWeights = {
    ["Leveling_1_20"]  = { ["MSC_WAND_DPS"]=6.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
    ["Leveling_21_40"] = { ["ITEM_MOD_SPIRIT_SHORT"]=2.5, ["MSC_WAND_DPS"]=4.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["MSC_SPELL_HIT_PERCENT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    
    ["Leveling_Smite_21_59"] = { ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["MSC_SPELL_CRIT_PERCENT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 }
}

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Priest.Talents = { 
    ["POWER_INFUSION"]  = "Power Infusion", 
    ["SPIRIT_GUIDANCE"] = "Spiritual Guidance", 
    ["SPIRIT_REDEMPT"]  = "Spirit of Redemption",
    ["SHADOWFORM"]      = "Shadowform", 
    ["SHADOW_FOCUS"]    = "Shadow Focus",
    ["WAND_SPEC"]       = "Wand Specialization",
    ["DARKNESS"]        = "Darkness"
}

-- =============================================================
-- LOGIC
-- =============================================================
function Priest:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        if Rank("SHADOWFORM") == 0 and Rank("SPIRIT_GUIDANCE") > 0 then return "Leveling_Smite_21_59" end
        
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("SHADOWFORM") > 0 then return "SHADOW_PVE" end
    if Rank("SPIRIT_REDEMPT") > 0 then return "HOLY_RAID" end
    if Rank("POWER_INFUSION") > 0 then return "DISC_PI" end
    
    return "Default"
end

function Priest:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Spiritual Guidance (Spirit -> Spell Power)
    local rSG = Rank("SPIRIT_GUIDANCE")
    if rSG > 0 and weights["ITEM_MOD_SPIRIT_SHORT"] then
        -- 1 Spirit gives 0.25 SP at rank 5. 
        -- We add 25% of the Spell Power weight to the Spirit weight.
        local spWeight = weights["ITEM_MOD_SPELL_POWER_SHORT"] or 1.0
        weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] + (spWeight * (rSG * 0.05))
    end
    
    -- 2. Covariance (Mana Regen / Healing Power Synergy)
    if currentSpec:find("HOLY") or currentSpec:find("DISC") then
        local healPower = MSC.PlayerStats.HealingPower or 0
        if healPower > 600 then
            -- High heal power makes Spirit regen more valuable for longevity
            local hScaler = 1 + ((healPower - 600) / 6000)
            weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * hScaler
        end
    end

    -- 3. Shadow Hit Cap (16% in Era)
    if currentSpec:find("SHADOW") and weights["MSC_SPELL_HIT_PERCENT"] then
        local gearHit = MSC.PlayerStats.SpellHit or 0
        local talentHit = Rank("SHADOW_FOCUS") * 2 -- 2% per rank in Era
        local totalHit = gearHit + talentHit
        
        if totalHit >= 16 then
            weights["MSC_SPELL_HIT_PERCENT"] = 1.0 -- Cap reached
            table.insert(activeCaps, "Hit (16%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Priest:GetWeaponBonus(itemLink) return 0 end

MSC.RegisterModule("PRIEST", Priest)