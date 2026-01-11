local addonName, MSC = ...
local Warlock = {}
Warlock.Name = "WARLOCK"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
-- NOTE: In Era Helpers.lua, 1.0 Rating = 1% Hit/Crit. 
-- We use standard keys so the Evaluator can match them.

Warlock.Weights = {
        ["Default"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.1 },
        ["RAID_DS_RUIN"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=11.0, ["ITEM_MOD_STAMINA_SHORT"]=0.3, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        ["RAID_SM_RUIN"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=9.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        ["PVE_MD_RUIN"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=11.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=0.3 },
        ["PVP_NF_CONFLAG"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        ["PVP_SOUL_LINK"] = {
			["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=5.0 },
        ["PVP_DEEP_DESTRO"] = {
			["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
    }
-- =============================================================
-- LEVELING WEIGHTS (Distinct Keys to fix Dropdown bug)
-- =============================================================
Warlock.LevelingWeights = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
        ["Leveling_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0 },
        -- Fire
        ["Leveling_Fire_21_40"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["Leveling_Fire_41_51"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=5.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Leveling_Fire_52_59"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0 },
        -- Demo
        ["Leveling_Demo_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_Demo_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0 },
        ["Leveling_Demo_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
    }
-- =============================================================
-- DISPLAY NAMES (For Options Menu)
-- =============================================================
Warlock.PrettyNames = {
        -- Endgame
        ["RAID_DS_RUIN"]        = "Raid: Destruction (DS/Ruin)",
        ["RAID_SM_RUIN"]        = "Raid: Affliction (SM/Ruin)",
        ["PVE_MD_RUIN"]         = "Raid: Master Demonologist",
        ["PVP_NF_CONFLAG"]      = "PvP: Nightfall / Conflagrate",
        ["PVP_SOUL_LINK"]       = "PvP: Soul Link (Tank)",
        ["PVP_DEEP_DESTRO"]     = "PvP: Destruction (Conflag)",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Affliction (21-40)",
        ["Leveling_41_51"]      = "Leveling: Affliction (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Affliction (52-59)",
        
        ["Leveling_Fire_21_40"] = "Leveling: Destruction (21-40)",
        ["Leveling_Fire_41_51"] = "Leveling: Destruction (41-51)",
        ["Leveling_Fire_52_59"] = "Leveling: Destruction (52-59)",
        
        ["Leveling_Demo_21_40"] = "Leveling: Demonology (21-40)",
        ["Leveling_Demo_41_51"] = "Leveling: Demonology (41-51)",
        ["Leveling_Demo_52_59"] = "Leveling: Demonology (52-59)",
    }
-- =============================================================
-- ERA TALENTS (Vanilla 31-Point Tree)
-- =============================================================
-- Keys must match GetTalentInfo() exactly (case-insensitive in Core)
Warlock.Talents = { 
        ["DEMONIC_SACRIFICE"] = "Demonic Sacrifice",
        ["SHADOW_MASTERY"]    = "Shadow Mastery",
        ["RUIN"]              = "Ruin",
        ["SOUL_LINK"]         = "Soul Link",
        ["CONFLAGRATE"]       = "Conflagrate",
        ["FEL_CONCENTRATION"] = "Fel Concentration",
        ["NIGHTFALL"]         = "Nightfall",
        ["INTENSITY"]         = "Intensity",
        ["MASTER_DEMON"]      = "Master Demonologist",
        ["SUPPRESSION"]       = "Suppression",
        ["DEMONIC_EMBRACE"]   = "Demonic Embrace",
        ["EMBERSTORM"]        = "Emberstorm",
    }
-- =============================================================
-- LOGIC
-- =============================================================
function Warlock:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- ===========================
    -- 1. LEVELING LOGIC (< 60)
    -- ===========================
    if level < 60 then 
        -- Determine Level Bracket
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end -- Covers 52-59

        -- Determine Playstyle (Affliction vs Fire vs Demo)
        local prefix = "Leveling" -- Default to Affliction
        
        -- Check Fire: Conflagrate or Emberstorm or heavy Destruction
        if Rank("CONFLAGRATE") > 0 or Rank("EMBERSTORM") > 0 then 
            prefix = "Leveling_Fire"
        
        -- Check Demo: Soul Link or Master Demonologist
        elseif Rank("SOUL_LINK") > 0 or Rank("MASTER_DEMON") > 0 then 
            prefix = "Leveling_Demo"
        end 

        -- Combine (e.g. "Leveling_Fire_41_51")
        local key = prefix .. suffix
        
        -- Fallback: If "Leveling_Fire_1_20" doesn't exist, use generic "Leveling_1_20"
        if Warlock.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- ===========================
    -- 2. ENDGAME LOGIC (60+)
    -- ===========================
    if Rank("DEMONIC_SACRIFICE") > 0 and Rank("RUIN") > 0 then return "RAID_DS_RUIN" end
    if Rank("SHADOW_MASTERY") > 0 and Rank("RUIN") > 0 then return "RAID_SM_RUIN" end
    if Rank("MASTER_DEMON") > 0 and Rank("RUIN") > 0 then return "PVE_MD_RUIN" end
    if Rank("SOUL_LINK") > 0 then return "PVP_SOUL_LINK" end
    if Rank("CONFLAGRATE") > 0 then 
        if Rank("NIGHTFALL") > 0 then return "PVP_NF_CONFLAG" end
        return "PVP_DEEP_DESTRO" 
    end
    
    return "Default"
end

function Warlock:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}

    -- 1. Demonic Embrace (Stamina Multiplier)
    local rEmb = Rank("Demonic Embrace")
    if rEmb > 0 and weights["ITEM_MOD_STAMINA_SHORT"] then 
        -- 3% per rank
        weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03)) 
    end

    -- 2. Suppression Hysteresis (Specific to Affliction)
    -- In Era, Hit is very hard to get. Cap is 16%. 
    -- Suppression gives 2% hit per rank to Affliction spells only.
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        local currentHit = MSC.PlayerStats.SpellHit or 0
        local suppressionBonus = Rank("Suppression") * 2 
        
        -- If we are Deep Destro (Conflag), Suppression doesn't help our main nuke.
        local isDestro = (Rank("Conflagrate") > 0)
        local totalHit = currentHit + (isDestro and 0 or suppressionBonus)
        
        local HIT_CAP = 16
        
        if totalHit >= HIT_CAP then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.5 -- Cap reached
            table.insert(activeCaps, "Hit Cap")
        elseif totalHit >= (HIT_CAP - 3) then
            -- Near cap, value diminishes slightly
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] * 0.8
            table.insert(activeCaps, "Hit (Soft)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Warlock:GetWeaponBonus(itemLink)
    -- Warlocks have no weapon-based racials in Era
    return 0
end

MSC.RegisterModule("WARLOCK", Warlock)