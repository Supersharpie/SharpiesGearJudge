local addonName, MSC = ...
local Druid = {}
Druid.Name = "DRUID"

-- =============================================================
-- CLASSIC ERA STAT WEIGHTS (Vanilla / SoD)
-- =============================================================
Druid.Weights = {
		["Default"] = {
			["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=0.5 },
		["BALANCE_BOOMKIN"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=1.0 },
		["RESTO_MOONGLOW"] = {
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
		["RESTO_REGROWTH"] = {
			["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0 },
		["RESTO_DEEP"] = {
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
		["FERAL_CAT_DPS"] = {
			["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=26.0, ["ITEM_MOD_HIT_RATING_SHORT"]=22.0 },
		["FERAL_BEAR_TANK"] = {
			["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5 },
		["HYBRID_HOTW"] = {
			["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.8, ["ITEM_MOD_ARMOR_SHORT"]=0.2 },
	}

-- =============================================================
-- LEVELING WEIGHTS (Era Specific)
-- =============================================================
Druid.LevelingWeights = {
        -- Cat Form (Standard)
        ["Leveling_1_20"]  = { ["ITEM_MOD_ARMOR_SHORT"]= 0.2, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=12.0 },

        -- [NEW] Bear Tank Leveling (Thick Hide)
        ["Leveling_Bear_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.2, ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=0.8, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0 },
        ["Leveling_Bear_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.4, ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.5, ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=8.0 },
        ["Leveling_Bear_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]= 0.8, ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=3.0, ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5 },

        -- Balance
        ["Leveling_Caster_41_51"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_Caster_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_CRIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },

        -- Restoration
        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
    }

-- =============================================================
-- DISPLAY NAMES (For Options Menu)
-- =============================================================
Druid.PrettyNames = {
        -- Endgame
        ["BALANCE_BOOMKIN"]    = "DPS: Balance (Boomkin)",
        ["RESTO_DEEP"]         = "Healer: Deep Restoration",
        ["RESTO_MOONGLOW"]     = "Healer: Moonglow",
        ["RESTO_REGROWTH"]     = "Healer: Regrowth (Crit)",
        ["FERAL_CAT_DPS"]      = "DPS: Feral Cat",
        ["FERAL_BEAR_TANK"]    = "Tank: Feral Bear",
        ["HYBRID_HOTW"]        = "Hybrid: Heart of the Wild",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Feral Cat (21-40)",
        ["Leveling_41_51"]      = "Leveling: Feral Cat (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Feral (52-59)",
        
        ["Leveling_Bear_21_40"] = "Leveling: Bear Tank (21-40)",
        ["Leveling_Bear_41_51"] = "Leveling: Bear Tank (41-51)",
        ["Leveling_Bear_52_59"] = "Leveling: Bear Tank (52-59)",
        
        ["Leveling_Caster_41_51"] = "Leveling: Balance (41-51)",
        ["Leveling_Caster_52_59"] = "Leveling: Pre-BiS Balance (52-59)",
        
        ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Resto (52-59)",
    }

-- =============================================================
-- ERA TALENTS (31-Point Tree)
-- =============================================================
Druid.Talents = { 
        ["MOONKIN_FORM"]    = "Moonkin Form",
        ["MOONGLOW"]        = "Moonglow",
        ["NATURES_GRACE"]   = "Nature's Grace",
        ["LEADER_OF_PACK"]  = "Leader of the Pack",
        ["HEART_WILD"]      = "Heart of the Wild",
        ["THICK_HIDE"]      = "Thick Hide",
        ["FUROR"]           = "Furor",
        ["SWIFTMEND"]       = "Swiftmend",
        ["NATURES_SWIFT"]   = "Nature's Swiftness",
        ["IMP_REGROWTH"]    = "Improved Regrowth",
        ["REFLECTION"]      = "Reflection",
}
-- =============================================================
-- LOGIC
-- =============================================================
function Druid:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 20 then suffix = "_1_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end

        if Rank("MOONKIN_FORM") > 0 then return "Leveling_Caster" .. suffix end
        if Rank("INNATE_ENERVATION") > 0 then return "Leveling_Healer" .. suffix end
        return "Leveling" .. suffix
    end

    local _, _, _, _, balPoints  = GetTalentTabInfo(1); balPoints = balPoints or 0
    local _, _, _, _, feralPoints = GetTalentTabInfo(2); feralPoints = feralPoints or 0
    local _, _, _, _, restoPoints = GetTalentTabInfo(3); restoPoints = restoPoints or 0
	
    -- Endgame
    if Rank("COUNTERATTACK") > 0 then return "MELEE_NIGHTFALL" end
    if Rank("TRUESHOT_AURA") > 0 and Rank("UNLEASHED_FURY") > 0 then return "RAID_MM_STANDARD" end
    if Rank("TRUESHOT_AURA") > 0 and Rank("SUREFOOTED") > 0 then return "RAID_MM_STARTER" end
    if Rank("LIGHTNING_REF") == 5 and Rank("WYVERN_STING") > 0 then return "RAID_SURV_DEEP" end
    if Rank("TRUESHOT_AURA") > 0 and Rank("DETERRENCE") > 0 then return "PVP_MM_UTIL" end
    if (Rank("WYVERN_STING") > 0 and Rank("SUREFOOTED") > 0) then return "PVP_SURV_TANK" end
    if mmPoints >= 30 then return "RAID_MM_STANDARD" end
    return "RAID_MM_STANDARD"
end

function Druid:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {} 
    
    -- 1. Heart of the Wild
    local rHotW = Rank("HEART_WILD")
    if rHotW > 0 then
        if weights["ITEM_MOD_INTELLECT_SHORT"] then 
            weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.04)) 
        end
        if weights["ITEM_MOD_STRENGTH_SHORT"] then
            weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rHotW * 0.04))
        end
    end

    -- 2. Covariance (Mana Regen / Healing Synergy)
    if currentSpec:find("RESTO") or currentSpec:find("Healer") then
        local healPower = MSC.PlayerStats.HealingPower or 0
        if healPower > 500 then
             local hScaler = 1 + ((healPower - 500) / 5000)
             weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * hScaler
        end
    end

    -- 3. Caps (Hit Cap 9%)
    -- FIX: Changed MSC_HIT_PERCENT -> ITEM_MOD_HIT_RATING_SHORT
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        local currentHit = MSC.PlayerStats.Hit or 0
        if currentHit >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0
            table.insert(activeCaps, "Hit (9%)")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

-- =============================================================
-- FERAL ATTACK POWER (Era Specific)
-- =============================================================
function Druid:GetWeaponBonus(itemLink) 
    -- Logic to extract "Feral Attack Power" from Era staves/maces
    -- Vanilla items like "Atiesh" or "Maul of the Redeemed" have hidden FAP
    return 0 
end

-- =============================================================
-- IDOLS (Classic Era)
-- =============================================================
Druid.Relics = {
    [22398] = { ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 20 }, -- Idol of Brutality
    [22396] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 30 }, 	  -- Idol of Health
    [23197] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 33 },	      -- Idol of the Moon
    [22398] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 40, estimate = true, replace = true },
    [22399] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 50, estimate = true, replace = true },
    [23198] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 40, estimate = true, replace = true },
    [22394] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 50, estimate = true, replace = true },
}

MSC.RegisterModule("DRUID", Druid)