local addonName, MSC = ...
local L = MSC.L

-- =============================================================
-- 1. PAWN KEYWORDS
-- =============================================================
MSC.PawnStatMap = {
    -- Base Stats
    ["Strength"] = "ITEM_MOD_STRENGTH_SHORT", 
    ["Agility"] = "ITEM_MOD_AGILITY_SHORT",
    ["Stamina"] = "ITEM_MOD_STAMINA_SHORT", 
    ["Intellect"] = "ITEM_MOD_INTELLECT_SHORT",
    ["Spirit"] = "ITEM_MOD_SPIRIT_SHORT", 
    
    -- Ratings (Modern & Classic Syntax)
    ["CritRating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["Crit"] = "ITEM_MOD_CRIT_RATING_SHORT", -- Classic
    ["HitRating"] = "ITEM_MOD_HIT_RATING_SHORT", 
    ["Hit"] = "ITEM_MOD_HIT_RATING_SHORT", -- Classic
    ["HasteRating"] = "ITEM_MOD_HASTE_RATING_SHORT",
    ["Haste"] = "ITEM_MOD_HASTE_RATING_SHORT", -- Classic
    ["ResilienceRating"] = "ITEM_MOD_RESILIENCE_RATING_SHORT", 
    ["Resilience"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
    ["ArmorPenetration"] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",
    
    -- Attack Power
    ["AttackPower"] = "ITEM_MOD_ATTACK_POWER_SHORT",
    ["Ap"] = "ITEM_MOD_ATTACK_POWER_SHORT",
    ["RangedAttackPower"] = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT",
    ["Rap"] = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT",
    ["FeralAttackPower"] = "ITEM_MOD_ATTACK_POWER_SHORT", 
    ["FeralAp"] = "ITEM_MOD_ATTACK_POWER_SHORT", 
    
    -- Spell
    ["SpellPower"] = "ITEM_MOD_SPELL_POWER_SHORT", 
    ["Healing"] = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
    ["SpellCritRating"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT", 
    ["SpellHitRating"] = "ITEM_MOD_HIT_SPELL_RATING_SHORT",
    ["SpellHasteRating"] = "ITEM_MOD_SPELL_HASTE_RATING_SHORT", 
    ["Mp5"] = "ITEM_MOD_MANA_REGENERATION_SHORT",
    
    -- Tank
    ["DefenseRating"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", 
    ["Defense"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["DodgeRating"] = "ITEM_MOD_DODGE_RATING_SHORT",
    ["Dodge"] = "ITEM_MOD_DODGE_RATING_SHORT",
    ["ParryRating"] = "ITEM_MOD_PARRY_RATING_SHORT", 
    ["Parry"] = "ITEM_MOD_PARRY_RATING_SHORT",
    ["BlockRating"] = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["Block"] = "ITEM_MOD_BLOCK_RATING_SHORT",
    ["BlockValue"] = "ITEM_MOD_BLOCK_VALUE_SHORT", 
    ["ExpertiseRating"] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    ["Expertise"] = "ITEM_MOD_EXPERTISE_RATING_SHORT",

    -- Weapon
    ["Dps"] = "MSC_WEAPON_DPS", 
    ["Speed"] = "MSC_WEAPON_SPEED",

-- =============================================================
-- 2. GERMAN PAWN KEYWORDS
-- =============================================================

	["Stärke"] = "ITEM_MOD_STRENGTH_SHORT",
	["Beweglichkeit"] = "ITEM_MOD_AGILITY_SHORT",
	["Ausdauer"] = "ITEM_MOD_STAMINA_SHORT",
	["Intelligenz"] = "ITEM_MOD_INTELLECT_SHORT",
	["Willenskraft"] = "ITEM_MOD_SPIRIT_SHORT",

	-- Ratings
	["KritischeTrefferwertung"] = "ITEM_MOD_CRIT_RATING_SHORT",
	["Trefferwertung"] = "ITEM_MOD_HIT_RATING_SHORT",
	["Tempowertung"] = "ITEM_MOD_HASTE_RATING_SHORT",
	["Abhärtungswertung"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
	["Rüstungsumgehungswertung"] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",

	-- Attack Power
	["Angriffskraft"] = "ITEM_MOD_ATTACK_POWER_SHORT",
	["Distanzangriffskraft"] = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT",
	["FeralAngriffskraft"] = "ITEM_MOD_ATTACK_POWER_SHORT",

	-- Spell
	["Zaubermacht"] = "ITEM_MOD_SPELL_POWER_SHORT",
	["Heilung"] = "ITEM_MOD_SPELL_HEALING_DONE_SHORT",
	["ZauberkritischeTrefferwertung"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT",
	["Zaubertempowertung"] = "ITEM_MOD_SPELL_HASTE_RATING_SHORT",
	["ManaAlle5Sek"] = "ITEM_MOD_MANA_REGENERATION_SHORT",

	-- Tank
	["Verteidigungswertung"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
	["Ausweichwertung"] = "ITEM_MOD_DODGE_RATING_SHORT",
	["Parrierwertung"] = "ITEM_MOD_PARRY_RATING_SHORT",
	["Blockwertung"] = "ITEM_MOD_BLOCK_RATING_SHORT",
	["Blockwert"] = "ITEM_MOD_BLOCK_VALUE_SHORT",
	["Waffenkundewertung"] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
}

-- =============================================================
--  PAWN PARSER
-- =============================================================

function MSC.ParsePawnString(pawnString)
    if not pawnString or type(pawnString) ~= "string" then return nil end
    
    -- 1. CLEANUP
    local clean = string_gsub(string_gsub(pawnString, "%)", ""), "%(", "")
    
    -- 2. EXTRACT PROFILE NAME
    local namePattern = "v1:%s*\"([^\"]+)\":"
    local profileName = string_match(clean, namePattern)
    
    if not profileName then 
        profileName = string_match(clean, "v1:%s*([^%s:,]+):") 
    end
    if not profileName then return nil end

    -- 3. EXTRACT STATS
    local weights = {}
    local _, endPos = string_find(clean, namePattern)
    if not endPos then _, endPos = string_find(clean, "v1:") end
    
    if endPos then
        local statBlock = string_sub(clean, endPos + 1)
        for stat, val in string.gmatch(statBlock, "([^%s=]+)%s*=%s*([%-%d%.]+)") do
            local internalKey = MSC.PawnStatMap[stat]
            local numberVal = tonumber(val)
            
            if internalKey and numberVal and numberVal ~= 0 then
                weights[internalKey] = numberVal
            end
        end
    end

    -- 4. VALIDATION
    if not next(weights) then return nil end
    
    return weights, profileName
end

function MSC.ImportAndSavePawnString(pawnString)
    -- 1. Parse the string
    local weights, name = MSC.ParsePawnString(pawnString)
    
    if not weights then 
        print(MSC.L["|cffff0000SGJ: Invalid Pawn string format or empty stats.|r"])
        return false 
    end

    -- 2. Save to your Character-Specific DB
    SharpiesGearJudgeDB = SharpiesGearJudgeDB or {}
    SharpiesGearJudgeDB.customWeights = SharpiesGearJudgeDB.customWeights or {}
    SharpiesGearJudgeDB.customWeights[name] = weights
    
    -- 3. Update active session
    if MSC.CurrentClass then
        MSC.CurrentClass.Weights = MSC.CurrentClass.Weights or {}
        MSC.CurrentClass.Weights[name] = weights
    end
	
    -- 4. TRIGGER THE RELOAD POPUP
    StaticPopup_Show("SGJ_RELOAD_REQUIRED")
    
    return true, name
end