local addonName, MSC = ...
local Mage = {}
Mage.Name = "MAGE"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Mage.Weights = {
        ["Default"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_MANA_SHORT"]=0.02, ["ITEM_MOD_STAMINA_SHORT"]=0.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5 },
        ["FIRE_RAID"] = {
			["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=13.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=14.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        ["FROST_AP"] = {
			["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=16.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=9.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        ["FROST_WC"] = {
			["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=16.0, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        ["FROST_AOE"] = {
			["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["POM_PYRO"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=15.0 },
        ["ELEMENTAL"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0 },
        ["FROST_PVP"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0 },
    }

-- =============================================================
-- LEVELING WEIGHTS
-- =============================================================
Mage.LevelingWeights = {
        -- Frost (ST)
        ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["Leveling_41_51"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        ["Leveling_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },

        -- [NEW] Fire Leveling (High Damage / Downtime)
        ["Leveling_Fire_21_40"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_Fire_41_51"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Leveling_Fire_52_59"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0 },

        -- AoE Grinding
        ["Leveling_AoE_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2 },
        ["Leveling_AoE_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
        ["Leveling_AoE_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8 },
    }

-- =============================================================
-- DISPLAY NAMES (For Options Menu)
-- =============================================================
Mage.PrettyNames = {
        -- Endgame
        ["FIRE_RAID"]          = "Raid: Deep Fire (Combustion)",
        ["FROST_AP"]           = "Raid: Frost (Arcane Power)",
        ["FROST_WC"]           = "Raid: Frost (Winter's Chill)",
        ["POM_PYRO"]           = "PvP: PoM Pyro (3-Min Mage)",
        ["ELEMENTAL"]          = "PvP: Elemental (Shatter)",
        ["FARM_AOE_BLIZZ"]     = "Farming: Frost AoE",
        ["FROST_PVP"]          = "PvP: Deep Frost",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Frost/Fire ST (21-40)",
        ["Leveling_41_51"]      = "Leveling: Frost/Fire ST (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Mage (52-59)",
        
        ["Leveling_AoE_21_40"]  = "Leveling: AoE Grinding (21-40)",
        ["Leveling_AoE_41_51"]  = "Leveling: AoE Grinding (41-51)",
        ["Leveling_AoE_52_59"]  = "Leveling: AoE Grinding (52-59)",
        
        ["Leveling_Fire_21_40"] = "Leveling: Fire (21-40)",
        ["Leveling_Fire_41_51"] = "Leveling: Fire (41-51)",
        ["Leveling_Fire_52_59"] = "Leveling: Fire (52-59)",
    }

-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
Mage.Talents = { 
        ["ARCANE_POWER"]    = "Arcane Power",
        ["PRESENCE_OF_MIND"]= "Presence of Mind",
        ["COMBUSTION"]      = "Combustion",
        ["BLAST_WAVE"]      = "Blast Wave",
        ["PYROBLAST"]       = "Pyroblast",
        ["ICE_BARRIER"]     = "Ice Barrier",
        ["WINTERS_CHILL"]   = "Winter's Chill",
        ["IMP_BLIZZARD"]    = "Improved Blizzard",
        ["PERMAFROST"]      = "Permafrost",
        ["ARCANE_MIND"]     = "Arcane Mind",
        ["IGNITE"]          = "Ignite",
        ["ICE_SHARDS"]      = "Ice Shards",
        ["ELE_PRECISION"]   = "Elemental Precision",
        ["ARCANE_FOCUS"]    = "Arcane Focus",
    }

-- =============================================================
-- LOGIC
-- =============================================================
function Mage:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        if Rank("IMP_BLIZZARD") >= 2 then return "Leveling_AoE_21_59" end
        
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end
        return "Leveling" .. suffix
    end

    -- Endgame
    if Rank("COMBUSTION") > 0 then return "FIRE_RAID" end
    if Rank("ARCANE_POWER") > 0 and Rank("ICE_SHARDS") > 0 then return "FROST_AP" end
    if Rank("WINTERS_CHILL") > 0 then return "FROST_WC" end
    if Rank("PRESENCE_OF_MIND") > 0 and Rank("PYROBLAST") > 0 then return "POM_PYRO" end
    if Rank("BLAST_WAVE") > 0 and Rank("ICE_SHARDS") > 0 then return "ELEMENTAL" end
    if Rank("IMP_BLIZZARD") == 3 and Rank("PERMAFROST") > 0 then return "FROST_AOE" end
    if Rank("ICE_BARRIER") > 0 then return "FROST_PVP" end
    return "FROST_AP"
end

function Mage:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Arcane Mind (Int Scaling)
    -- FIX: Changed 0.02 -> 0.03 (Vanilla is 15% total, not 10%)
    local rAM = Rank("ARCANE_MIND")
    if rAM > 0 and weights["ITEM_MOD_INTELLECT_SHORT"] then 
        weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAM * 0.03)) 
    end
    
    -- 2. Covariance (Crit Value scales with Spell Power)
    -- FIX: Changed MSC_SPELL_CRIT_PERCENT -> ITEM_MOD_SPELL_CRIT_RATING_SHORT
    if weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        local sp = MSC.PlayerStats.SpellPower or 0
        if sp > 400 then
            local spScaler = 1 + ((sp - 400) / 4000)
            weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * spScaler
        end
    end

    -- 3. Spell Hit Cap (16%)
    -- FIX: Changed MSC_SPELL_HIT_PERCENT -> ITEM_MOD_HIT_SPELL_RATING_SHORT
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        local currentHit = MSC.PlayerStats.SpellHit or 0
        local talentHit = 0
        
        if currentSpec:find("FIRE") or currentSpec:find("FROST") then
            talentHit = Rank("ELE_PRECISION") * 2
        elseif currentSpec:find("ARCANE") then
            talentHit = Rank("ARCANE_FOCUS") * 2
        end
        
        local totalHit = currentHit + talentHit
        if totalHit >= 16 then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0
            table.insert(activeCaps, "Hit (16%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Mage:GetWeaponBonus(itemLink) return 0 end

MSC.RegisterModule("MAGE", Mage)