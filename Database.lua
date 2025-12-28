local _, MSC = ...

-- =============================================================
-- ENDGAME STAT WEIGHTS (Level 60 Raid & PvP)
-- =============================================================
MSC.WeightDB = {
    ["WARRIOR"] = {
        ["Default"] = {
			["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.3, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        ["FURY_2H"] = {
			["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 7.5, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.3, ["ITEM_MOD_CRIT_RATING_SHORT"] = 28.0, ["ITEM_MOD_HIT_RATING_SHORT"] = 12.0, ["ITEM_MOD_STAMINA_SHORT"] = 0.5 },
        ["FURY_DW"] = {
			["ITEM_MOD_HIT_RATING_SHORT"] = 22.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 18.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 30.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.5, ["ITEM_MOD_STAMINA_SHORT"] = 0.5 },
        ["ARMS_MS"] = {
			["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 8.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 28.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_AGILITY_SHORT"] = 1.2, ["ITEM_MOD_STAMINA_SHORT"] = 1.5 },
        ["DEEP_PROT"] = {
			["ITEM_MOD_STAMINA_SHORT"] = 1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 0.6, ["ITEM_MOD_HIT_RATING_SHORT"] = 10.0, ["ITEM_MOD_DODGE_RATING_SHORT"] = 12.0, ["ITEM_MOD_PARRY_RATING_SHORT"] = 12.0, ["ITEM_MOD_STRENGTH_SHORT"] = 0.5 },
        ["FURY_PROT"] = {
			["ITEM_MOD_HIT_RATING_SHORT"] = 22.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 20.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, ["ITEM_MOD_STAMINA_SHORT"] = 1.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.5 },
        ["ARMS_PROT"] = {
			["ITEM_MOD_STAMINA_SHORT"] = 1.0, ["ITEM_MOD_CRIT_RATING_SHORT"] = 20.0, ["ITEM_MOD_STRENGTH_SHORT"] = 2.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8, ["ITEM_MOD_PARRY_RATING_SHORT"] = 10.0 },
    },
    ["PALADIN"] = {
        ["Default"] = { 
			["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        ["HOLY_RAID"] = {
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=14.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=0.2 },
        ["HOLY_DEEP"] = {
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=4.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 },
        ["PROT_DEEP"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.6, ["ITEM_MOD_DODGE_RATING_SHORT"]=12.0, ["ITEM_MOD_PARRY_RATING_SHORT"]=12.0 },
        ["PROT_AOE"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.4, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.5 },
        ["RET_STANDARD"] = {
			["ITEM_MOD_STRENGTH_SHORT"]=2.3, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_HIT_RATING_SHORT"]=22.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2 },
        ["RET_UTILITY"] = {
			["ITEM_MOD_HIT_RATING_SHORT"]=30.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        ["SHOCKADIN"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.5 },
        ["RECK_BOMB"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
    },
    ["PRIEST"] = {
        ["Default"] = {
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5 },
        ["HOLY_DEEP"] = {
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        ["DISC_PI_SUPPORT"] = {
			["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=0.6 },
        ["SHADOW_PVE"] = {
			["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        ["SHADOW_PVP"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 },
        ["HYBRID_POWER_WEAVING"] = {
			["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
    },
    ["ROGUE"] = {
        ["Default"] = {
			["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0 },
        ["RAID_COMBAT_SWORDS"] = {
			["ITEM_MOD_HIT_RATING_SHORT"]=22.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=28.0 },
        ["RAID_COMBAT_DAGGERS"] = {
			["ITEM_MOD_CRIT_RATING_SHORT"]=28.0, ["ITEM_MOD_AGILITY_SHORT"]=2.4, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0 },
        ["RAID_SEAL_FATE"] = {
			["ITEM_MOD_CRIT_RATING_SHORT"]=32.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_HIT_RATING_SHORT"]=18.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
        ["PVP_HEMO"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0 },
        ["PVP_CB_DAGGER"] = {
			["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["PVP_MACE"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_AGILITY_SHORT"]=1.8 },
    },
    ["HUNTER"] = {
        ["Default"] = {
			["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=32.0, ["ITEM_MOD_HIT_RATING_SHORT"]=32.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5 },
        ["RAID_MM_STANDARD"] = {
			["ITEM_MOD_HIT_RATING_SHORT"]=32.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=32.0 },
        ["RAID_MM_STARTER"] = {
			["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=32.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
        ["RAID_SURV_DEEP"] = {
			["ITEM_MOD_AGILITY_SHORT"]=3.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_HIT_RATING_SHORT"]=30.0, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
        ["PVP_MM_UTIL"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
        ["PVP_SURV_TANK"] = {
			["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
        ["MELEE_NIGHTFALL"] = {
			["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 },
        ["SOLO_DME_TRIBUTE"] = {
			["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
    },
    ["MAGE"] = {
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
    },
    ["WARLOCK"] = {
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
    },
    ["SHAMAN"] = {
        ["Default"] = {
			["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_SHORT"]=0.05, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.5 },
        ["ELE_PVE"] = {
			["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3 },
        ["ELE_PVP"] = {
			["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        ["ENH_STORMSTRIKE"] = {
			["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=10.0 },
        ["RESTO_DEEP"] = {
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 },
        ["RESTO_TOTEM_SUPPORT"] = {
			["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=4.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=0.5 },
        ["HYBRID_ELE_RESTO"] = {
			["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 },
        ["HYBRID_ENH_RESTO"] = {
			["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HEALING_POWER_SHORT"]=0.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
    },
    ["DRUID"] = {
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
	},
}
-- =============================================================
-- 2. SPEC NAMES
-- =============================================================
MSC.SpecNames = {
    ["WARLOCK"] = { [1]="Affliction", [2]="Demonology", [3]="Destruction" },
    ["PALADIN"] = { [1]="Holy", [2]="Protection", [3]="Retribution" },
    ["MAGE"]    = { [1]="Arcane", [2]="Fire", [3]="Frost" },
    ["PRIEST"]  = { [1]="Discipline", [2]="Holy", [3]="Shadow" },
    ["DRUID"]   = { [1]="Balance", [2]="FeralCombat", [3]="Restoration" },
    ["SHAMAN"]  = { [1]="Elemental", [2]="Enhancement", [3]="Restoration" },
    ["ROGUE"]   = { [1]="Assassination", [2]="Combat", [3]="Subtlety" },
    ["WARRIOR"] = { [1]="Arms", [2]="Fury", [3]="Protection" },
    ["HUNTER"]  = { [1]="BeastMastery", [2]="Marksmanship", [3]="Survival" },
}

-- =============================================================
-- 3. RACIAL BONUSES (Using IDs)
-- =============================================================
MSC.RacialTraits = {
    ["Human"] = { 
        [7] = 5, -- One-Handed Swords
        [8] = 5, -- Two-Handed Swords
        [4] = 5, -- One-Handed Maces
        [5] = 5  -- Two-Handed Maces
    },
    ["Orc"] = { 
        [0] = 5, -- One-Handed Axes
        [1] = 5  -- Two-Handed Axes
    },
    ["Dwarf"] = { 
        [3] = 5  -- Guns
    },
    ["Troll"] = { 
        [2] = 5,  -- Bows
        [16] = 5  -- Thrown
    }, 
}

-- =============================================================
-- 4. WEAPON SPEED PREFERENCES (Updated for v2.0 Keys)
-- =============================================================
MSC.SpeedChecks = {
    ["WARRIOR"] = {
        ["Default"]     = { MH_Slow=true },
        ["FURY_DW"]     = { MH_Slow=true, OH_Fast=true }, -- Slow MH for dmg, Fast OH for Rage
        ["FURY_2H"]     = { MH_Slow=true },
        ["ARMS_MS"]     = { MH_Slow=true }, -- Big hits for Mortal Strike
        ["DEEP_PROT"]   = { MH_Fast=true }, -- Fast for Heroic Strike queuing
    },
    ["ROGUE"] = {
        ["Default"]             = { MH_Slow=true, OH_Fast=true },
        ["RAID_COMBAT_SWORDS"]  = { MH_Slow=true, OH_Fast=true }, -- Slow Sword MH (Sinister Strike)
        ["RAID_COMBAT_DAGGERS"] = { MH_Fast=false, OH_Fast=true }, -- (Daggers logic handled by stats)
        ["PVP_HEMO"]            = { MH_Slow=true }, -- Slow weapon for Hemo dmg
    },
    ["PALADIN"] = {
        ["Default"]      = { MH_Slow=true },
        ["RET_STANDARD"] = { MH_Slow=true }, -- Seal of Command needs 3.5+ speed ideally
        ["PROT_DEEP"]    = { MH_Fast=true }, -- Fast for threat/procs
        ["RECK_BOMB"]    = { MH_Slow=true },
    },
    ["HUNTER"] = {
        ["Default"] = { Ranged_Slow=true }, -- Slower bows/guns = bigger Multi-Shots
    },
    ["SHAMAN"] = {
        ["Default"]         = { MH_Slow=true },
        ["ENH_STORMSTRIKE"] = { MH_Slow=true }, -- Stormstrike calculates off weapon dmg
    }
}

-- =============================================================
-- 5. CLASS WEAPON PROFICIENCIES
-- =============================================================
MSC.ValidWeapons = {
    ["WARRIOR"] = { [0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true, [10]=true, [13]=true, [15]=true, [18]=true, [19]=false },
    ["PALADIN"] = { [0]=true, [1]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true },
    ["HUNTER"]  = { [0]=true, [1]=true, [2]=true, [3]=true, [6]=true, [7]=true, [8]=true, [10]=true, [13]=true, [15]=true, [18]=true },
    ["ROGUE"]   = { [0]=false, [1]=false, [2]=true, [3]=true, [4]=true, [5]=false, [7]=true, [8]=false, [13]=true, [15]=true, [18]=true },
    ["PRIEST"]  = { [4]=true, [10]=true, [15]=true, [19]=true },
    ["SHAMAN"]  = { [0]=true, [1]=true, [4]=true, [5]=true, [10]=true, [13]=true, [15]=true, [19]=false },
    ["MAGE"]    = { [7]=true, [10]=true, [15]=true, [19]=true },
    ["WARLOCK"] = { [7]=true, [10]=true, [15]=true, [19]=true },
    ["DRUID"]   = { [4]=true, [5]=true, [10]=true, [13]=true, [15]=true } 
}

-- =============================================================
-- 6. SHORT NAMES (Display text for Tooltips)
-- =============================================================
MSC.ShortNames = {
    -- [[ FIX FOR BLIZZARD ARMOR RETURN ]]
    ["RESISTANCE0_NAME"]              = "Armor", 
    ["ITEM_MOD_ARMOR_SHORT"]          = "Armor",

    -- [[ ATTRIBUTES ]]
    ["ITEM_MOD_AGILITY_SHORT"]        = "Agility",
    ["ITEM_MOD_STRENGTH_SHORT"]       = "Strength",
    ["ITEM_MOD_INTELLECT_SHORT"]      = "Intellect",
    ["ITEM_MOD_SPIRIT_SHORT"]         = "Spirit",
    ["ITEM_MOD_STAMINA_SHORT"]        = "Stamina",
    ["ITEM_MOD_HEALTH_SHORT"]         = "Health",
    ["ITEM_MOD_MANA_SHORT"]           = "Mana",

    -- [[ SPELL & HEALING ]]
    ["ITEM_MOD_SPELL_POWER_SHORT"]    = "Spell Power",
    ["ITEM_MOD_HEALING_POWER_SHORT"]  = "Healing",
    ["ITEM_MOD_SPELL_HEALING_DONE"]   = "Healing", -- Legacy
    ["ITEM_MOD_MANA_REGENERATION_SHORT"] = "Mp5",
    ["ITEM_MOD_POWER_REGEN0_SHORT"]   = "Mp5", -- Legacy
    
    -- [[ PHYSICAL ]]
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = "DPS",
    ["ITEM_MOD_ATTACK_POWER_SHORT"]      = "Attack Power",
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = "Ranged AP", 
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = "Feral AP",
    ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = "Hp5",

    -- [[ HIT / CRIT / SKILL ]]
    ["ITEM_MOD_CRIT_RATING_SHORT"]       = "Crit",
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = "Spell Crit",
    ["ITEM_MOD_HIT_RATING_SHORT"]        = "Hit",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]  = "Spell Hit",
    ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = "Wpn Skill",
    
    -- [[ CRIT CONVERSIONS FROM STATS ]]
    ["ITEM_MOD_CRIT_FROM_STATS_SHORT"]       = "Crit (from Agi)",
    ["ITEM_MOD_SPELL_CRIT_FROM_STATS_SHORT"] = "Spell Crit (from Int)",

    -- [[ DEFENSIVE ]]
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = "Defense",
    ["ITEM_MOD_DODGE_RATING_SHORT"]      = "Dodge",
    ["ITEM_MOD_PARRY_RATING_SHORT"]      = "Parry",
    ["ITEM_MOD_BLOCK_RATING_SHORT"]      = "Block %",
    ["ITEM_MOD_BLOCK_VALUE_SHORT"]       = "Block Value",

    -- [[ SPECIFIC DAMAGE ]]
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]     = "Shadow Dmg",
    ["ITEM_MOD_FIRE_DAMAGE_SHORT"]       = "Fire Dmg",
    ["ITEM_MOD_FROST_DAMAGE_SHORT"]      = "Frost Dmg",
    ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]     = "Arcane Dmg",
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"]     = "Nature Dmg",
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"]       = "Holy Dmg",

    -- [[ RESISTANCES ]]
    ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"] = "Shadow Res",
    ["ITEM_MOD_FIRE_RESISTANCE_SHORT"]   = "Fire Res",
    ["ITEM_MOD_FROST_RESISTANCE_SHORT"]  = "Frost Res",
    ["ITEM_MOD_NATURE_RESISTANCE_SHORT"] = "Nature Res",
    ["ITEM_MOD_ARCANE_RESISTANCE_SHORT"] = "Arcane Res",
    ["ITEM_MOD_ALL_RESISTANCE_SHORT"]    = "All Res",
}

-- =============================================================
-- 7. SLOT MAPPING
-- =============================================================
MSC.SlotMap = { 
    ["INVTYPE_HEAD"]=1, ["INVTYPE_NECK"]=2, ["INVTYPE_SHOULDER"]=3, ["INVTYPE_BODY"]=4, 
    ["INVTYPE_CHEST"]=5, ["INVTYPE_ROBE"]=5, ["INVTYPE_WAIST"]=6, ["INVTYPE_LEGS"]=7, 
    ["INVTYPE_FEET"]=8, ["INVTYPE_WRIST"]=9, ["INVTYPE_HAND"]=10, ["INVTYPE_FINGER"]=11, 
    ["INVTYPE_TRINKET"]=13, ["INVTYPE_CLOAK"]=15, ["INVTYPE_WEAPON"]=16, ["INVTYPE_SHIELD"]=17, 
    ["INVTYPE_2HWEAPON"]=16, ["INVTYPE_WEAPONMAINHAND"]=16, ["INVTYPE_WEAPONOFFHAND"]=17, 
    ["INVTYPE_HOLDABLE"]=17, ["INVTYPE_RANGED"]=18, ["INVTYPE_THROWN"]=18, 
    ["INVTYPE_RANGEDRIGHT"]=18, ["INVTYPE_RELIC"]=18 
}

-- =============================================================
-- 8. CRIT CONVERSION MATRIX (Level Brackets)
-- =============================================================
MSC.StatToCritMatrix = {
    ["WARRIOR"] = { 
        Agi = { {1, 4.0}, {20, 8.5}, {40, 13.5}, {60, 20.0} } 
    },
    ["ROGUE"] = { 
        Agi = { {1, 3.5}, {20, 9.0}, {40, 18.0}, {60, 29.0} } 
    },
    ["HUNTER"] = { 
        Agi = { {1, 4.5}, {20, 12.0}, {40, 26.0}, {60, 53.0} } 
    },
    ["PALADIN"] = { 
        Agi = { {1, 4.0}, {60, 20.0} }, 
        Int = { {1, 6.0}, {30, 15.0}, {60, 29.5} } 
    },
    ["SHAMAN"] = { 
        Agi = { {1, 4.0}, {60, 20.0} }, 
        Int = { {1, 6.0}, {20, 15.0}, {40, 35.0}, {60, 59.5} } 
    },
    ["DRUID"] = { 
        Agi = { {1, 4.0}, {60, 20.0} }, 
        Int = { {1, 6.5}, {20, 16.0}, {40, 38.0}, {60, 60.0} } 
    },
    ["MAGE"] = { 
        Agi = { {60, 20.0} }, 
        Int = { {1, 6.0}, {20, 15.0}, {40, 35.0}, {60, 59.5} } 
    },
    ["PRIEST"] = { 
        Agi = { {60, 20.0} }, 
        Int = { {1, 6.0}, {20, 15.0}, {40, 37.0}, {60, 59.2} } 
    },
    ["WARLOCK"] = { 
        Agi = { {60, 20.0} }, 
        Int = { {1, 6.5}, {20, 16.0}, {40, 38.0}, {60, 60.6} } 
    },
}
-- =============================================================
-- 9. ITEM OVERRIDES (Master List: Active & Passive)
-- =============================================================
MSC.ItemOverrides = {
    -- [[ ⚠️ HYBRID / ADDITIVE (Scanner Stats + ~Bonus) ]]
    [22954] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 55, estimate = true }, -- Kiss of the Spider
    [23041] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 20, estimate = true }, -- Slayer's Crest
    [11815] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 22, estimate = true }, -- Hand of Justice
    [23046] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 26, estimate = true },  -- Essence of Sapphiron

    -- [[ ⚠️ PURE REPLACEMENTS ]]
    -- Melee
    [19406] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 86, estimate = true, replace = true }, -- Drake Fang Talisman
    [13965] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30, estimate = true, replace = true }, -- Blackhand's Breadth
    [19991] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 39, estimate = true, replace = true }, -- Devilsaur Eye
    [19120] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 35, estimate = true, replace = true }, -- Rune of the Guard Captain
    [18469] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30, estimate = true, replace = true }, -- Royal Seal (Rogue)
    [21567] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 20, estimate = true, replace = true }, -- Rune of Duty
    
    -- Active/Procs 
    [19949] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 34, estimate = true, replace = true }, -- Zandalarian Hero Medallion
    [23570] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 65, estimate = true, replace = true }, -- Jom Gabbar
    [21180] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 47, estimate = true, replace = true }, -- Earthstrike
    [21670] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 60, estimate = true, replace = true }, -- Badge of the Swarmguard
    [20130] = { ["ITEM_MOD_STRENGTH_SHORT"] = 60, estimate = true, replace = true },     -- Diamond Flask
    [19342] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30, estimate = true, replace = true }, -- Venomous Totem
    [11302] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 15, estimate = true, replace = true }, -- Uther's Strength

    -- Caster 
    [19379] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 70, estimate = true, replace = true }, -- Neltharion's Tear
    [12930] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 29, estimate = true, replace = true }, -- Briarwood Reed
    [18467] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 23, estimate = true, replace = true }, -- Royal Seal (Mage)
    [19336] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 39, estimate = true, replace = true }, -- Arcane Infused Gem
    [21566] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 20, estimate = true, replace = true }, -- Rune of Perfection
    [18820] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 39, estimate = true, replace = true }, -- Talisman of Ephemeral Power
    [19339] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 45, estimate = true, replace = true }, -- Mind Quickening Gem
    [19950] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 34, estimate = true, replace = true }, -- Zandalarian Hero Charm
    [21891] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 32, estimate = true, replace = true }, -- Shard of the Fallen Star
    [18646] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 40, estimate = true, replace = true }, -- The Black Book
    [11832] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 12, estimate = true, replace = true }, -- Burst of Knowledge
    [23001] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 20, estimate = true, replace = true }, -- Eye of Diminution
    [22268] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 20, ["ITEM_MOD_HEALING_POWER_SHORT"] = 18, estimate = true, replace = true }, -- Draconic Infused Emblem

    -- Healer 
    [19395] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 102, estimate = true, replace = true }, -- Rejuvenating Gem
    [23027] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 64, estimate = true, replace = true },  -- Warmth of Forgiveness
    [17064] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 64, estimate = true, replace = true },  -- Shard of the Scale
    [18371] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 45, estimate = true, replace = true },  -- Mindtap Talisman
    [18665] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 55, estimate = true, replace = true },  -- The Eye of Divinity
    [18466] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 44, estimate = true, replace = true },  -- Royal Seal (Druid)
    [18468] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 44, estimate = true, replace = true },  -- Royal Seal (Priest)
    [23047] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 135, estimate = true, replace = true }, -- Eye of the Dead
    [19288] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 70, estimate = true, replace = true },  -- Darkmoon Card: Blue Dragon
    [19344] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 65, estimate = true, replace = true },  -- Natural Alignment Crystal
    [11819] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 35, estimate = true, replace = true },  -- Second Wind
    [19990] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 32, estimate = true, replace = true },  -- Blessed Prayer Beads
    [21625] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 65, estimate = true, replace = true },  -- Scarab Brooch

    -- Tank
    [19431] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 25, ["ITEM_MOD_STAMINA_SHORT"] = 30, estimate = true, replace = true }, -- Styleen's
    [13966] = { ["ITEM_MOD_ARMOR_SHORT"] = 450, ["ITEM_MOD_DODGE_RATING_SHORT"] = 1, estimate = true, replace = true }, -- Mark of Tyranny
    [23040] = { ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 60, ["ITEM_MOD_ARMOR_SHORT"] = 300, estimate = true, replace = true }, -- Glyph of Deflection
    [21685] = { ["ITEM_MOD_STAMINA_SHORT"] = 50, estimate = true, replace = true }, -- Petrified Scarab
    [11811] = { ["ITEM_MOD_ARMOR_SHORT"] = 300, ["ITEM_MOD_STAMINA_SHORT"] = 15, estimate = true, replace = true }, -- Smoking Heart
    [18406] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 15, ["ITEM_MOD_PARRY_RATING_SHORT"] = 2, estimate = true, replace = true }, -- Onyxia Blood
    [11810] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 12, ["ITEM_MOD_STAMINA_SHORT"] = 10, estimate = true, replace = true }, -- Force of Will
    [17744] = { ["ITEM_MOD_DODGE_RATING_SHORT"] = 15, estimate = true, replace = true }, -- Vigilance Charm
    [18537] = { ["ITEM_MOD_PARRY_RATING_SHORT"] = 10, estimate = true, replace = true }, -- Counterattack
    [23558] = { ["ITEM_MOD_STAMINA_SHORT"] = 40, estimate = true, replace = true }, -- Burrower's Shell
    [21647] = { ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 40, ["ITEM_MOD_ARMOR_SHORT"] = 150, estimate = true, replace = true }, -- Chitinous Spikes
    [18815] = { ["ITEM_MOD_STAMINA_SHORT"] = 10, estimate = true, replace = true }, -- Pure Flame
    
    -- Lifegiving Gem
    [19341] = { percent_hp_value = 0.30, estimate = true, replace = true },
    -- Lifestone
    [833] = { ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 10, replace = true }, 

    -- PvP / Utility
    [1404]  = { ["ITEM_MOD_STAMINA_SHORT"] = 20, estimate = true, replace = true }, -- Tidal Charm
    [18638] = { ["ITEM_MOD_STAMINA_SHORT"] = 18, estimate = true, replace = true }, -- Reflectors
    [18639] = { ["ITEM_MOD_STAMINA_SHORT"] = 18, estimate = true, replace = true },
    [14557] = { ["ITEM_MOD_STAMINA_SHORT"] = 16, estimate = true, replace = true }, -- Stopwatch
    [17909] = { ["ITEM_MOD_STAMINA_SHORT"] = 14, estimate = true, replace = true }, -- Insignia
    [17904] = { ["ITEM_MOD_STAMINA_SHORT"] = 14, estimate = true, replace = true },
    [10577] = { ["ITEM_MOD_STAMINA_SHORT"] = 12, estimate = true, replace = true }, -- Mortar
    [10587] = { ["ITEM_MOD_STAMINA_SHORT"] = 10, estimate = true, replace = true }, -- Bomb Dispenser
    [21115] = { ["ITEM_MOD_STAMINA_SHORT"] = 8, estimate = true, replace = true },  -- Defiler's
    [11905] = { ["ITEM_MOD_STAMINA_SHORT"] = 8, estimate = true, replace = true },  -- Linken's

-- [[ 🗿 RELICS, IDOLS, LIBRAMS, TOTEMS (Converted to Generic Stats) ]]
    -- SHAMAN (Totems)
    [23199] = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 33, estimate = true, replace = true }, -- Totem of the Storm
    [22395] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 65, estimate = true, replace = true }, -- Totem of Life
    [23200] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 40, estimate = true, replace = true }, -- Totem of Sustaining
    [22397] = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 20, estimate = true, replace = true }, -- Totem of Rage
    [20644] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2, estimate = true, replace = true }, -- Totem of Rebirth

    -- PALADIN (Librams)
    [23201] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 45, estimate = true, replace = true }, -- Libram of Divinity
    [22396] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 45, estimate = true, replace = true }, -- Libram of Truth
    [22402] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 8, estimate = true, replace = true }, -- Libram of Hope
    [23006] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 25, estimate = true, replace = true },   -- Libram of Fervor

    -- DRUID (Idols)
    [22398] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 40, estimate = true, replace = true }, -- Idol of Rejuvenation
    [22399] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 50, estimate = true, replace = true }, -- Idol of Health
    [23197] = { ["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = 25, estimate = true, replace = true }, -- Idol of the Moon
    [23198] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 40, estimate = true, replace = true },  -- Idol of Brutality
    [22394] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 50, estimate = true, replace = true },  -- Idol of Ferocity
}
-- =============================================================
-- 10. PRETTY NAMES (Translation Layer for UI)
-- =============================================================
MSC.PrettyNames = {
    ["WARRIOR"] = {
        -- Endgame
        ["FURY_DW"]         = "Raid: Fury (Dual Wield)",
        ["FURY_2H"]         = "Raid: Fury (2H Slam)",
        ["ARMS_MS"]         = "PvP: Arms (Mortal Strike)",
        ["DEEP_PROT"]       = "Tank: Deep Protection",
        ["FURY_PROT"]       = "Tank: Fury-Prot (Threat)",
        ["ARMS_PROT"]       = "Tank: Arms (Dungeon Hybrid)",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Arms/Fury (21-40)",
        ["Leveling_41_51"]      = "Leveling: Arms/Fury (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Fury (52-59)",
        
        ["Leveling_DW_21_40"]   = "Leveling: Dual Wield (21-40)",
        ["Leveling_DW_41_51"]   = "Leveling: Dual Wield (41-51)",
        ["Leveling_DW_52_59"]   = "Leveling: Dual Wield (52-59)",
        
        ["Leveling_Tank_21_40"] = "Leveling: Tank (21-40)",
        ["Leveling_Tank_41_51"] = "Leveling: Tank (41-51)",
        ["Leveling_Tank_52_59"] = "Leveling: Tank (52-59)",
    },
    ["PALADIN"] = {
        -- Endgame
        ["HOLY_RAID"]       = "Healer: Holy (Illumination)",
        ["HOLY_DEEP"]       = "Healer: Deep Holy (Buffs)",
        ["PROT_DEEP"]       = "Tank: Deep Protection",
        ["PROT_AOE"]        = "Farming: Protection AoE",
        ["RET_STANDARD"]    = "DPS: Retribution",
        ["SHOCKADIN"]       = "PvP: Shockadin (Burst)",
        ["RECK_BOMB"]       = "PvP: Reck-Bomb (One-Shot)",
        ["RET_UTILITY"]     = "Raid: Ret Utility (Nightfall)",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Retribution (21-40)",
        ["Leveling_41_51"]      = "Leveling: Retribution (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Ret (52-59)",
        
        ["Leveling_Ret_52_59"]  = "Leveling: Pre-BiS Ret (52-59)",
        
        ["Leveling_Tank_41_51"] = "Leveling: Prot (41-51)",
        ["Leveling_Tank_52_59"] = "Leveling: Pre-BiS Prot (52-59)",
        
        ["Leveling_Healer_41_51"] = "Leveling: Holy (41-51)",
        ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Holy (52-59)",
    },
    ["HUNTER"] = {
        -- Endgame
        ["RAID_MM_STANDARD"] = "Raid: Marksmanship (Standard)",
        ["RAID_MM_STARTER"]  = "Raid: MM (Surefooted)",
        ["RAID_SURV_DEEP"]   = "Raid: Deep Survival (Agi)",
        ["PVP_MM_UTIL"]      = "PvP: Marksmanship Utility",
        ["PVP_SURV_TANK"]    = "PvP: Survival Tank",
        ["MELEE_NIGHTFALL"]  = "Support: Nightfall (Melee)",
        ["SOLO_DME_TRIBUTE"] = "Farming: DM North Solo",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Beast Mastery (21-40)",
        ["Leveling_41_51"]      = "Leveling: Beast Mastery (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Hunter (52-59)",
        
        ["Leveling_Melee_21_40"] = "Leveling: Melee/Survival (21-40)",
        ["Leveling_Melee_41_51"] = "Leveling: Melee/Survival (41-51)",
        ["Leveling_Melee_52_59"] = "Leveling: Melee/Survival (52-59)",
    },
    ["ROGUE"] = {
        -- Endgame
        ["RAID_COMBAT_SWORDS"]  = "Raid: Combat Swords",
        ["RAID_COMBAT_DAGGERS"] = "Raid: Combat Daggers",
        ["RAID_SEAL_FATE"]      = "Raid: Seal Fate (Crit)",
        ["PVP_MACE"]            = "PvP: Mace Specialization",
        ["PVP_HEMO"]            = "PvP: Hemo Control",
        ["PVP_CB_DAGGER"]       = "PvP: Cold Blood Burst",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Combat (21-40)",
        ["Leveling_41_51"]      = "Leveling: Combat (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Combat (52-59)",
        
        ["Leveling_Dagger_21_40"] = "Leveling: Daggers (21-40)",
        ["Leveling_Dagger_41_51"] = "Leveling: Daggers (41-51)",
        ["Leveling_Dagger_52_59"] = "Leveling: Daggers (52-59)",
        
        ["Leveling_Hemo_21_40"]   = "Leveling: Hemo (21-40)",
        ["Leveling_Hemo_41_51"]   = "Leveling: Hemo (41-51)",
        ["Leveling_Hemo_52_59"]   = "Leveling: Hemo (52-59)",
    },
    ["PRIEST"] = {
        -- Endgame
        ["HOLY_DEEP"]          = "Healer: Deep Holy",
        ["DISC_PI_SUPPORT"]    = "Healer: Disc (Power Infusion)",
        ["SHADOW_PVE"]         = "DPS: Shadow (PvE)",
        ["SHADOW_PVP"]         = "PvP: Shadow (Blackout)",
        ["HYBRID_POWER_WEAVING"] = "Support: Power Weaving",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Shadow/Wand (21-40)",
        ["Leveling_41_51"]      = "Leveling: Shadow (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Shadow (52-59)",
        
        ["Leveling_Smite_21_40"] = "Leveling: Smite/Holy (21-40)",
        ["Leveling_Smite_41_51"] = "Leveling: Smite/Holy (41-51)",
        ["Leveling_Smite_52_59"] = "Leveling: Smite/Holy (52-59)",
        
        ["Leveling_Healer_41_51"] = "Leveling: Dungeon Healer (41-51)",
        ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Healer (52-59)",
    },
    ["SHAMAN"] = {
        -- Endgame
        ["ELE_PVE"]            = "DPS: Elemental (PvE)",
        ["ELE_PVP"]            = "PvP: Elemental (Burst)",
        ["RESTO_DEEP"]         = "Healer: Deep Restoration",
        ["RESTO_TOTEM_SUPPORT"]= "Healer: Totem Twisting",
        ["ENH_STORMSTRIKE"]    = "DPS: Enhancement",
        ["HYBRID_ELE_RESTO"]   = "Hybrid: Ele / Resto (NS)",
        ["HYBRID_ENH_RESTO"]   = "Hybrid: Enh / Resto (PvP)",
        
        -- Leveling
        ["Leveling_1_20"]       = "Leveling (1-20)",
        ["Leveling_21_40"]      = "Leveling: Enhancement (21-40)",
        ["Leveling_41_51"]      = "Leveling: Enhancement (41-51)",
        ["Leveling_52_59"]      = "Leveling: Pre-BiS Enh (52-59)",
        
        ["Leveling_Caster_41_51"] = "Leveling: Elemental (41-51)",
        ["Leveling_Caster_52_59"] = "Leveling: Pre-BiS Ele (52-59)",
        
        ["Leveling_Tank_21_40"]   = "Leveling: Tank Shaman (21-40)",
        ["Leveling_Tank_41_51"]   = "Leveling: Tank Shaman (41-51)",
        ["Leveling_Tank_52_59"]   = "Leveling: Tank Shaman (52-59)",
        
        ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Resto (52-59)",
    },
    ["MAGE"] = {
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
    },
    ["WARLOCK"] = {
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
    },
    ["DRUID"] = {
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
    },
}
-- =============================================================
-- 12. ENCHANT DATABASE (ID Lookup)
-- =============================================================
MSC.EnchantDB = {
    -- [[ 1. WEAPON DAMAGE ]]
    [250] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 1 }, name = "Minor Striking (+1 Dmg)" }, 
    [249] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2 }, name = "Minor Beastslayer (+2)" },
    [843] = { stats = { ITEM_MOD_MANA_SHORT = 30 }, name = "Enchant Chest - Mana (+30)" }, 
    [943] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 3 }, name = "Lesser Striking (+3 Dmg)" },
    [803] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 4 }, name = "Fiery Weapon (+4 Fire)" }, 
    [853] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 4 }, name = "Striking (+4 Dmg)" },
    [854] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 5 }, name = "Greater Striking (+5 Dmg)" }, 
    [1897] = { stats = { ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 5 }, name = "Superior Striking (+5 Dmg)" },

    -- [[ 2. SPELL POWER & HEALING ]]
    [2504] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 30 }, name = "Spell Power (+30)" }, 
    [2505] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 55 }, name = "Healing Power (+55)" },
    [2443] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 8 }, name = "Winter's Might (+7 Cold)" },
    
    -- [[ 3. NAXXRAMAS ]]
    [2603] = { stats = { ITEM_MOD_ATTACK_POWER_SHORT = 26, ITEM_MOD_CRIT_RATING_SHORT = 1 }, name = "Might of the Scourge" }, 
    [2604] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 15, ITEM_MOD_SPELL_CRIT_RATING_SHORT = 1 }, name = "Power of the Scourge" }, 
    [2605] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 31, ITEM_MOD_MANA_REGENERATION_SHORT = 5 }, name = "Resilience of the Scourge" }, 
    [2606] = { stats = { ITEM_MOD_STAMINA_SHORT = 16, ITEM_MOD_ARMOR_SHORT = 100 }, name = "Fortitude of the Scourge" },

    -- [[ 4. LIBRAMS / ARCANUMS ]]
    [2284] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 8 }, name = "Arcanum of Focus (+8 SP)" },
    [2283] = { stats = { ITEM_MOD_DODGE_RATING_SHORT = 1 }, name = "Arcanum of Protection (1% Dodge)" },
    [2285] = { stats = { ITEM_MOD_ATTACK_SPEED_SHORT = 1 }, name = "Arcanum of Rapidity (1% Haste)" },

    -- [[ 5. ZUL'GURUB ]]
    [2621] = { stats = { ITEM_MOD_STAMINA_SHORT = 4, ITEM_MOD_STRENGTH_SHORT = 4, ITEM_MOD_AGILITY_SHORT = 4, ITEM_MOD_INTELLECT_SHORT = 4, ITEM_MOD_SPIRIT_SHORT = 4 }, name = "ZG (All +4)" },
    [2607] = { stats = { ITEM_MOD_ATTACK_POWER_SHORT = 30 }, name = "ZG (+30 AP)" },
    [2608] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 18 }, name = "ZG (+18 SP)" },
    [2609] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 33 }, name = "ZG (+33 Healing)" },

    -- [[ 6. STANDARD STATS (Low Level) ]]
    [15] = { stats = { ITEM_MOD_HEALTH_SHORT = 15 }, name = "Minor Health (+15)" },  
    [16] = { stats = { ITEM_MOD_HEALTH_SHORT = 25 }, name = "Lesser Health (+25)" },  
    [241] = { stats = { ITEM_MOD_HEALTH_SHORT = 35 }, name = "Health (+35)" }, 
    [242] = { stats = { ITEM_MOD_HEALTH_SHORT = 50 }, name = "Greater Health (+50)" }, 
    [243] = { stats = { ITEM_MOD_HEALTH_SHORT = 100 }, name = "Major Health (+100)" },
    [17] = { stats = { ITEM_MOD_MANA_SHORT = 30 }, name = "Minor Mana (+30)" },
    [18] = { stats = { ITEM_MOD_MANA_SHORT = 50 }, name = "Lesser Mana (+50)" },
    [244] = { stats = { ITEM_MOD_MANA_SHORT = 100 }, name = "Mana (+100)" },
    [39] = { stats = { ITEM_MOD_STATS_ALL_SHORT = 1 }, name = "Minor Stats (+1)" },
    [40] = { stats = { ITEM_MOD_STATS_ALL_SHORT = 2 }, name = "Lesser Stats (+2)" },
    [41] = { stats = { ITEM_MOD_STATS_ALL_SHORT = 3 }, name = "Stats (+3)" },
    [256] = { stats = { ITEM_MOD_STATS_ALL_SHORT = 4 }, name = "Greater Stats (+4)" },
    [245] = { stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 1 }, name = "Minor Defense (+1)" },
    [246] = { stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 2 }, name = "Lesser Defense (+2)" },
    [247] = { stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 3 }, name = "Defense (+3)" },
    [2503] = { stats = { ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 7 }, name = "Greater Defense (+7)" },
    [385] = { stats = { ITEM_MOD_STAMINA_SHORT = 1 }, name = "Minor Stamina (+1)" },
    [386] = { stats = { ITEM_MOD_STAMINA_SHORT = 3 }, name = "Lesser Stamina (+3)" },
    [387] = { stats = { ITEM_MOD_STAMINA_SHORT = 5 }, name = "Stamina (+5)" },
    [388] = { stats = { ITEM_MOD_STAMINA_SHORT = 7 }, name = "Greater Stamina (+7)" },
    [389] = { stats = { ITEM_MOD_STAMINA_SHORT = 9 }, name = "Superior Stamina (+9)" },
    [393] = { stats = { ITEM_MOD_AGILITY_SHORT = 1 }, name = "Minor Agility (+1)" },
    [394] = { stats = { ITEM_MOD_AGILITY_SHORT = 3 }, name = "Lesser Agility (+3)" },
    [395] = { stats = { ITEM_MOD_AGILITY_SHORT = 5 }, name = "Agility (+5)" },
    [396] = { stats = { ITEM_MOD_AGILITY_SHORT = 7 }, name = "Greater Agility (+7)" },
    [2564] = { stats = { ITEM_MOD_AGILITY_SHORT = 15 }, name = "Superior Agility (+15)" },
    [373] = { stats = { ITEM_MOD_STRENGTH_SHORT = 1 }, name = "Minor Strength (+1)" },
    [374] = { stats = { ITEM_MOD_STRENGTH_SHORT = 3 }, name = "Lesser Strength (+3)" },
    [375] = { stats = { ITEM_MOD_STRENGTH_SHORT = 5 }, name = "Strength (+5)" },
    [376] = { stats = { ITEM_MOD_STRENGTH_SHORT = 7 }, name = "Greater Strength (+7)" },
    [377] = { stats = { ITEM_MOD_STRENGTH_SHORT = 9 }, name = "Superior Strength (+9)" },
    [2563] = { stats = { ITEM_MOD_STRENGTH_SHORT = 15 }, name = "Strength (+15)" },
    [1128] = { stats = { ITEM_MOD_INTELLECT_SHORT = 3 }, name = "Lesser Intellect (+3)" },
    [1127] = { stats = { ITEM_MOD_INTELLECT_SHORT = 5 }, name = "Intellect (+5)" },
    [1126] = { stats = { ITEM_MOD_INTELLECT_SHORT = 7 }, name = "Greater Intellect (+7)" },
    [2565] = { stats = { ITEM_MOD_INTELLECT_SHORT = 22 }, name = "Mighty Intellect (+22)" },
    [249] = { stats = { ITEM_MOD_SPIRIT_SHORT = 3 }, name = "Lesser Spirit (+3)" },
    [250] = { stats = { ITEM_MOD_SPIRIT_SHORT = 5 }, name = "Spirit (+5)" },
    [256] = { stats = { ITEM_MOD_SPIRIT_SHORT = 7 }, name = "Greater Spirit (+7)" },
    [1147] = { stats = { ITEM_MOD_SPIRIT_SHORT = 9 }, name = "Superior Spirit (+9)" },
    [2566] = { stats = { ITEM_MOD_SPIRIT_SHORT = 20 }, name = "Mighty Spirit (+20)" },
    [911] = { stats = { MSC_RUN_SPEED = 8 }, name = "Minor Speed" },
    [2629] = { stats = { ITEM_MOD_MANA_REGENERATION_SHORT = 4 }, name = "+4 Mp5" },
    [2586] = { stats = { ITEM_MOD_RANGED_ATTACK_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_HIT_RATING_SHORT = 1 }, name = "Biznicks Scope" },
    [2585] = { stats = { ITEM_MOD_ATTACK_POWER_SHORT = 28, ITEM_MOD_DODGE_RATING_SHORT = 1 }, name = "ZG (+28 AP / +1% Dodge)" },
    [2583] = { stats = { ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 7, ITEM_MOD_BLOCK_VALUE_SHORT = 15 }, name = "ZG Tank" },
    [2584] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = 7 }, name = "ZG Heal/Def" },
    [2589] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_MANA_REGENERATION_SHORT = 4 }, name = "ZG Heal/Mp5" },
    [2587] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 18, ITEM_MOD_HIT_SPELL_RATING_SHORT = 1 }, name = "ZG (+18 SP / +1% Hit)" },
    [2588] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 18, ITEM_MOD_STAMINA_SHORT = 10 }, name = "ZG (+18 SP / +10 Stam)" },
    [2591] = { stats = { ITEM_MOD_SPELL_POWER_SHORT = 13, ITEM_MOD_INTELLECT_SHORT = 15 }, name = "+13 SP / +15 Int" },
    [2590] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 24, ITEM_MOD_STAMINA_SHORT = 10, ITEM_MOD_INTELLECT_SHORT = 10 }, name = "Heal/Int Ench" },
    [2543] = { stats = { ITEM_MOD_ATTACK_SPEED_SHORT = 1 }, name = "+1% Haste" }, 
    [2544] = { stats = { ITEM_MOD_HEALING_POWER_SHORT = 8 }, name = "+8 Healing" },
    [2545] = { stats = { ITEM_MOD_DODGE_RATING_SHORT = 1 }, name = "+1% Dodge" },
    [2488] = { stats = { ITEM_MOD_HEALTH_SHORT = 100 }, name = "+100 Health" },
    [2483] = { stats = { ITEM_MOD_STRENGTH_SHORT = 8 }, name = "+8 Strength" },
    [2484] = { stats = { ITEM_MOD_STAMINA_SHORT = 8 }, name = "+8 Stamina" },
    [2485] = { stats = { ITEM_MOD_AGILITY_SHORT = 8 }, name = "+8 Agility" },
    [2486] = { stats = { ITEM_MOD_INTELLECT_SHORT = 8 }, name = "+8 Intellect" },
    [2487] = { stats = { ITEM_MOD_SPIRIT_SHORT = 8 }, name = "+8 Spirit" },
}