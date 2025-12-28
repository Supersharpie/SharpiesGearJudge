local _, MSC = ...

-- =========================================================================
-- SHARPIES GEAR JUDGE: LEVELING MODULE (Logic + Database)
-- =========================================================================

-- [[ 1. LEVELING STAT WEIGHTS (The Database) ]] --
MSC.LevelingWeightDB = {
    -- [[ WARRIOR ]]
    ["WARRIOR"] = {
        -- Standard Arms/2H Fury
        ["Leveling_1_20"]  = { ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=5.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=8.0, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        ["Leveling_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.2 },
        
        -- [NEW] Dual Wield Fury Leveling (Needs Hit!)
        ["Leveling_DW_21_40"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_DW_41_51"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_DW_52_59"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },

        -- Tank Leveling (Dungeon Grinding)
        ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.1, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=5.0 },
        ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=10.0 },
    },

    -- [[ ROGUE ]]
    ["ROGUE"] = {
        -- Combat Swords/Maces
        ["Leveling_1_20"]  = { ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.3, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.4, ["ITEM_MOD_HIT_RATING_SHORT"]=12.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 },
        ["Leveling_52_59"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=10.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },

        -- [NEW] Dagger Leveling (Ambush/Backstab) - Needs Crit & Dagger Skill
        ["Leveling_Dagger_21_40"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Leveling_Dagger_41_51"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=8.0 },
        ["Leveling_Dagger_52_59"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.8, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },

        -- [NEW] Hemo Leveling (Subtlety) - Needs Stamina & AP
        ["Leveling_Hemo_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 },
        ["Leveling_Hemo_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0 },
        ["Leveling_Hemo_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },
    },

    -- [[ MAGE ]]
    ["MAGE"] = {
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
    },

    -- [[ DRUID ]]
    ["DRUID"] = {
        -- Cat Form (Standard)
        ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=12.0 },

        -- [NEW] Bear Tank Leveling (Thick Hide)
        ["Leveling_Bear_21_40"] = { ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=0.8, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0 },
        ["Leveling_Bear_41_51"] = { ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.5, ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=8.0 },
        ["Leveling_Bear_52_59"] = { ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=3.0, ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5 },

        -- Balance
        ["Leveling_Caster_41_51"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_Caster_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_CRIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },

        -- Restoration
        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
    },

    -- [[ PALADIN ]]
    ["PALADIN"] = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=6.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.3, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=8.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.4 },
        ["Leveling_Ret_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Leveling_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
    },

    -- [[ HUNTER ]]
    ["HUNTER"] = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        ["Leveling_21_40"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["Leveling_52_59"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        -- Melee Hunter
        ["Leveling_Melee_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_PARRY_RATING_SHORT"]=2.0 },
        ["Leveling_Melee_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5 },
        ["Leveling_Melee_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
    },

    -- [[ WARLOCK ]]
    ["WARLOCK"] = {
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
    },

    -- [[ PRIEST ]]
    ["PRIEST"] = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.6 },
        ["Leveling_41_51"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Leveling_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        -- Smite
        ["Leveling_Smite_21_40"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=5.0 },
        ["Leveling_Smite_41_51"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
        ["Leveling_Smite_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
    },

    -- [[ SHAMAN ]]
    ["SHAMAN"] = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2 },
        ["Leveling_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
        ["Leveling_Caster_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_CRIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        -- Tank Shaman
        ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0 },
        ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.2 },
        ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },
    },
}

-- =========================================================================
-- [[ 2. LEVELING LOGIC (The Brain for < 60) ]] --
-- =========================================================================

function MSC:GetLevelingSpec(class, level)
    -- PHASE 1: GENERIC (1-20)
    if level <= 20 then return "Leveling_1_20" end
    
    -- [[ SPECIALTY DETECTION LOGIC ]] --
    
    local suffix = ""
    if level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    else suffix = "_52_59" end

    local role = "Leveling" -- Default Fallback

    if class == "PRIEST" then
        if self:GetTalentRank("SHADOWFORM") > 0 then role = "Leveling" -- Shadow
        elseif self:GetTalentRank("DIVINE_FURY") > 0 and self:GetTalentRank("SPIRIT_TAP") > 0 then role = "Leveling_Smite"
        else role = "Leveling_Healer" end

    elseif class == "WARRIOR" then
        if self:GetTalentRank("SHIELD_SLAM") > 0 or self:GetTalentRank("DEFIANCE") > 0 then role = "Leveling_Tank"
        elseif self:GetTalentRank("DW_SPEC") > 0 or self:GetTalentRank("BLOODTHIRST") > 0 then role = "Leveling_DW"
        else role = "Leveling" end

    elseif class == "PALADIN" then
        if self:GetTalentRank("HOLY_SHIELD") > 0 or self:GetTalentRank("REDOUBT") > 0 then role = "Leveling_Tank"
        elseif self:GetTalentRank("ILLUMINATION") > 0 then role = "Leveling_Healer"
        else role = "Leveling_Ret" end

    elseif class == "DRUID" then
        if self:GetTalentRank("MOONKIN_FORM") > 0 then role = "Leveling_Caster"
        elseif self:GetTalentRank("SWIFTMEND") > 0 or self:GetTalentRank("NATURES_SWIFT") > 0 then role = "Leveling_Healer"
        elseif self:GetTalentRank("THICK_HIDE") > 0 then role = "Leveling_Bear"
        else role = "Leveling" end -- Feral Cat

    elseif class == "SHAMAN" then
        if self:GetTalentRank("SHIELD_SPEC") > 0 and self:GetTalentRank("ANTICIPATION") > 0 then role = "Leveling_Tank"
        elseif self:GetTalentRank("ELEMENTAL_MASTERY") > 0 then role = "Leveling_Caster"
        elseif self:GetTalentRank("MANA_TIDE") > 0 then role = "Leveling_Healer"
        else role = "Leveling" end

    elseif class == "MAGE" then
        if self:GetTalentRank("IMP_BLIZZARD") == 3 then role = "Leveling_AoE"
        elseif self:GetTalentRank("PYROBLAST") > 0 or self:GetTalentRank("IGNITE") > 0 then role = "Leveling_Fire"
        else role = "Leveling" end

    elseif class == "WARLOCK" then
        if self:GetTalentRank("EMBERSTORM") > 0 then role = "Leveling_Fire"
        elseif self:GetTalentRank("SOUL_LINK") > 0 or self:GetTalentRank("MASTER_DEMON") > 0 then role = "Leveling_Demo"
        else role = "Leveling" end

    elseif class == "HUNTER" then
        if self:GetTalentRank("COUNTERATTACK") > 0 or self:GetTalentRank("DETERRENCE") > 0 then role = "Leveling_Melee"
        else role = "Leveling" end
    elseif class == "ROGUE" then
        if self:GetTalentRank("DAGGER_SPEC") > 0 then role = "Leveling_Dagger"
        elseif self:GetTalentRank("HEMORRHAGE") > 0 then role = "Leveling_Hemo"
        else role = "Leveling" end -- Combat Swords
    end

    -- Construct Key
    local specificKey = role .. suffix
    if role == "Leveling" then specificKey = "Leveling" .. suffix end

    -- SAFETY CHECK
    if MSC.LevelingWeightDB[class] and MSC.LevelingWeightDB[class][specificKey] then 
        return specificKey
    else
        return "Leveling" .. suffix -- Fallback to generic
    end
end