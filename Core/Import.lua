local _, MSC = ...

-- =============================================================
-- PAWN STRING TRANSLATOR (Pawn -> Era Addon Keys)
-- =============================================================
MSC.PawnMap = {
    -- Stats
    ["Strength"]        = "ITEM_MOD_STRENGTH_SHORT",
    ["Agility"]         = "ITEM_MOD_AGILITY_SHORT",
    ["Stamina"]         = "ITEM_MOD_STAMINA_SHORT",
    ["Intellect"]       = "ITEM_MOD_INTELLECT_SHORT",
    ["Spirit"]          = "ITEM_MOD_SPIRIT_SHORT",
    ["Armor"]           = "ITEM_MOD_ARMOR_SHORT",
    
    -- Physical
    ["Ap"]              = "ITEM_MOD_ATTACK_POWER_SHORT",
    ["Rap"]             = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT",
    ["FeralAp"]         = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
    ["CritRating"]      = "ITEM_MOD_CRIT_RATING_SHORT",
    ["HitRating"]       = "ITEM_MOD_HIT_RATING_SHORT",
    ["Dps"]             = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
    ["DefenseRating"]   = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["DodgeRating"]     = "ITEM_MOD_DODGE_RATING_SHORT",
    ["ParryRating"]     = "ITEM_MOD_PARRY_RATING_SHORT",
    ["BlockValue"]      = "ITEM_MOD_BLOCK_VALUE_SHORT",

    -- Caster
    ["SpellPower"]      = "ITEM_MOD_SPELL_POWER_SHORT",
    ["SpellHitRating"]  = "ITEM_MOD_HIT_SPELL_RATING_SHORT",
    ["SpellCritRating"] = "ITEM_MOD_SPELL_CRIT_RATING_SHORT",
    ["Healing"]         = "ITEM_MOD_HEALING_POWER_SHORT",
    ["Mp5"]             = "ITEM_MOD_MANA_REGENERATION_SHORT",
    
    -- Magic Schools (Era Specific)
    ["FireSpellDamage"]   = "ITEM_MOD_FIRE_DAMAGE_SHORT",
    ["ShadowSpellDamage"] = "ITEM_MOD_SHADOW_DAMAGE_SHORT",
    ["FrostSpellDamage"]  = "ITEM_MOD_FROST_DAMAGE_SHORT",
    ["NatureSpellDamage"] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    ["ArcaneSpellDamage"] = "ITEM_MOD_ARCANE_DAMAGE_SHORT",
    ["HolySpellDamage"]   = "ITEM_MOD_HOLY_DAMAGE_SHORT",
}

function MSC:ParsePawnString(pawnString)
    if not pawnString or type(pawnString) ~= "string" then return nil, "Empty String" end
    
    -- 1. Clean (Remove outer parenthesis if present)
    local clean = pawnString:match("%((.+)%)") or pawnString
    
    -- 2. Extract Name
    local name = clean:match("v1: \"([^\"]+)\"")
    if not name then return nil, "No Profile Name Found" end
    
    -- 3. Extract Weights
    local weights = {}
    for key, val in clean:gmatch("([%a%d]+)=([%d%.]+)") do
        local addonKey = MSC.PawnMap[key]
        if addonKey then
            weights[addonKey] = tonumber(val)
        end
    end
    
    if not next(weights) then return nil, "No Valid Stats Found" end
    return weights, name
end

function MSC:ApplyCustomWeights(name, weights)
    if not MSC.CurrentClass then return end
    
    -- Inject into the current class module
    MSC.CurrentClass.Weights["Custom"] = weights
    MSC.CurrentClass.PrettyNames["Custom"] = "|cff00ff00Custom: " .. name .. "|r"
    
    -- Save to Global Settings so it loads next time
    if not SGJ_Settings.CustomWeights then SGJ_Settings.CustomWeights = {} end
    SGJ_Settings.CustomWeights[MSC.CurrentClass.Name] = { name = name, weights = weights }
    
    -- Switch mode to Manual: Custom
    SGJ_Settings.Mode = "Custom"
    MSC.ManualSpec = "Custom"
    MSC.CachedWeights = nil
    
    print("|cff00ff00[GearJudge]|r Imported Profile: " .. name)
end