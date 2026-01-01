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
        
        -- [TBC] Outland Arms (60-70)
        ["Leveling_60_70"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2 },

        -- Dual Wield Fury
        ["Leveling_DW_21_40"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_DW_41_51"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_DW_52_59"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        
        -- [TBC] Outland Fury (60-70)
        ["Leveling_DW_60_70"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=25.0, ["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=15.0 },

        -- Tank
        ["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.1, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=5.0 },
        ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=10.0 },
        -- [TBC] Outland Tank (60-70)
        ["Leveling_Tank_60_70"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, ["ITEM_MOD_DODGE_RATING_SHORT"]=12.0, ["ITEM_MOD_PARRY_RATING_SHORT"]=12.0 },
    },

    -- [[ ROGUE ]]
    ["ROGUE"] = {
        -- Combat
        ["Leveling_1_20"]  = { ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.3, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.1, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.4, ["ITEM_MOD_HIT_RATING_SHORT"]=12.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 },
        ["Leveling_52_59"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=10.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        -- [TBC] Outland Combat (60-70)
        ["Leveling_60_70"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=15.0 },
		-- Dagger/Mutilate (1-20)
        -- High Agility for Crit/Dodge. Spirit is weighted higher here for 1-20 regen efficiency.
        ["Leveling_Dagger_1_20"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.4, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        -- Hemo/Subtlety (1-20)
        -- Hemo isn't available until lvl 30, but this covers early Subtlety (Ghostly Strike).
        ["Leveling_Hemo_1_20"]   = { ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["Leveling_Dagger_21_40"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Leveling_Dagger_41_51"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=8.0 },
        ["Leveling_Dagger_52_59"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.8, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },
        -- [TBC] Outland Mutilate (60-70)
        ["Leveling_Dagger_60_70"] = { ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5 },

        -- Hemo/Sub
        ["Leveling_Hemo_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 },
        ["Leveling_Hemo_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0 },
        ["Leveling_Hemo_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },
        -- [TBC] Outland Subtlety (60-70)
        ["Leveling_Hemo_60_70"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_STAMINA_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },
    },

    -- [[ MAGE ]]
    ["MAGE"] = {
        -- Frost
        ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["Leveling_41_51"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        ["Leveling_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        -- [TBC] Outland Frost (60-70)
        ["Leveling_60_70"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 },

        -- Fire
        ["Leveling_Fire_21_40"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_Fire_41_51"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Leveling_Fire_52_59"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0 },
        -- [TBC] Outland Fire (60-70)
        ["Leveling_Fire_60_70"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },

        -- AoE
        ["Leveling_AoE_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2 },
        ["Leveling_AoE_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
        ["Leveling_AoE_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8 },
        -- [TBC] Outland AoE (60-70)
        ["Leveling_AoE_60_70"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.5, ["ITEM_MOD_INTELLECT_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=0.1 },
    },

    -- [[ DRUID ]]
    ["DRUID"] = {
        -- Feral Cat
        ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.4, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=12.0 },
        -- [TBC] Outland Cat (60-70)
        ["Leveling_60_70"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_FERAL_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0 },

        -- Bear Tank
        ["Leveling_Bear_21_40"] = { ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=0.8, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0 },
        ["Leveling_Bear_41_51"] = { ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=2.5, ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=8.0 },
        ["Leveling_Bear_52_59"] = { ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=3.0, ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5 },
        -- [TBC] Outland Bear (60-70)
        ["Leveling_Bear_60_70"] = { ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=3.0, ["ITEM_MOD_STAMINA_SHORT"]=3.5, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_DODGE_RATING_SHORT"]=12.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0 },

        -- Balance
        ["Leveling_Caster_41_51"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_Caster_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_CRIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        -- [TBC] Outland Balance (60-70)
        ["Leveling_Caster_60_70"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },

        -- Restoration
        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
        ["Leveling_Healer_60_70"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    },

    -- [[ PALADIN ]]
    ["PALADIN"] = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=6.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.3, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=8.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.4 },
        ["Leveling_Ret_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        -- [TBC] Outland Ret (60-70)
        ["Leveling_60_70"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=18.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },

        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        ["Leveling_Healer_60_70"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.8, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },

        ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Leveling_Tank_60_70"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
    },

    -- [[ HUNTER ]]
    ["HUNTER"] = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.2 },
        ["Leveling_21_40"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["Leveling_52_59"] = { ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        -- [TBC] Outland Hunter (60-70)
        ["Leveling_60_70"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=18.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },

        -- Melee Hunter
        ["Leveling_Melee_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_PARRY_RATING_SHORT"]=2.0 },
        ["Leveling_Melee_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5 },
        ["Leveling_Melee_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
        ["Leveling_Melee_60_70"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_AGILITY_SHORT"]=2.2, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=2.0 },
    },

    -- [[ WARLOCK ]]
    ["WARLOCK"] = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
        ["Leveling_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0 },
        -- [TBC] Outland Affliction (60-70)
        ["Leveling_60_70"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.2, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },

        -- Fire
        ["Leveling_Fire_21_40"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8 },
        ["Leveling_Fire_41_51"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=5.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Leveling_Fire_52_59"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0 },
        ["Leveling_Fire_60_70"] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.2, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5 },

        -- Demo
        ["Leveling_Demo_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_Demo_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0 },
        ["Leveling_Demo_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Leveling_Demo_60_70"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0 },
    },

    -- [[ PRIEST ]]
    ["PRIEST"] = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.6 },
        ["Leveling_41_51"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Leveling_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        -- [TBC] Outland Shadow (60-70)
        ["Leveling_60_70"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },

        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Leveling_Healer_60_70"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.8, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },

        -- Smite
        ["Leveling_Smite_21_40"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.2, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=5.0 },
        ["Leveling_Smite_41_51"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HOLY_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
        ["Leveling_Smite_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Leveling_Smite_60_70"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=18.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    },

    -- [[ SHAMAN ]]
    ["SHAMAN"] = {
        ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=8.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Leveling_41_51"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2 },
        ["Leveling_52_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5 },
        -- [TBC] Outland Enh (60-70)
        ["Leveling_60_70"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },

        ["Leveling_Caster_52_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_CRIT_SPELL_RATING_SHORT"]=10.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Leveling_Caster_60_70"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_CRIT_SPELL_RATING_SHORT"]=12.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.5 },

        ["Leveling_Healer_52_59"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Leveling_Healer_60_70"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
		-- Tank Shaman (1-20)
        -- Rockbiter Face-Tanking phase. High Stamina and Spirit for survival/regen.
        ["Leveling_Tank_1_20"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.0 },
         -- Tank Shaman
		["Leveling_Tank_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0 },
        ["Leveling_Tank_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_ARMOR_SHORT"]=0.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.5, ["ITEM_MOD_DODGE_RATING_SHORT"]=5.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.2 },
        ["Leveling_Tank_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.0, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=10.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },
        ["Leveling_Tank_60_70"] = { ["ITEM_MOD_STAMINA_SHORT"]=3.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=2.5, ["ITEM_MOD_DODGE_RATING_SHORT"]=12.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=12.0 },
    },
}

-- =========================================================================
-- [[ 2. LEVELING LOGIC (The Brain for < 70) ]] --
-- =========================================================================

function MSC:GetLevelingSpec(class, level)
    -- PHASE 1: GENERIC (1-20)
    if level <= 20 then return "Leveling_1_20" end
    
    -- [[ SPECIALTY DETECTION LOGIC ]] --
    
    local suffix = ""
    if level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end -- [TBC] New Bracket

    local role = "Leveling" -- Default Fallback

    if class == "PRIEST" then
        if self:GetTalentRank("SHADOWFORM") > 0 or self:GetTalentRank("VAMPIRIC_TOUCH") > 0 then role = "Leveling" -- Shadow
        elseif self:GetTalentRank("SEARING_LIGHT") > 0 then role = "Leveling_Smite"
        elseif self:GetTalentRank("CIRCLE_HEALING") > 0 or self:GetTalentRank("SPIRIT_OF_REDEMPTION") > 0 then role = "Leveling_Healer"
        else role = "Leveling_Healer" end -- Default to Healer if undecided

    elseif class == "WARRIOR" then
        if self:GetTalentRank("SHIELD_SLAM") > 0 or self:GetTalentRank("DEVASTATE") > 0 then role = "Leveling_Tank"
        elseif self:GetTalentRank("BLOODTHIRST") > 0 or self:GetTalentRank("RAMPAGE") > 0 then role = "Leveling_DW"
        else role = "Leveling" end -- Arms/2H

    elseif class == "PALADIN" then
        if self:GetTalentRank("HOLY_SHIELD") > 0 or self:GetTalentRank("AVENGERS_SHIELD") > 0 then role = "Leveling_Tank"
        elseif self:GetTalentRank("DIVINE_ILLUM") > 0 or self:GetTalentRank("HOLY_SHOCK") > 0 then role = "Leveling_Healer"
        else role = "Leveling_Ret" end -- Default Ret is fine here because generic "Leveling" table for Paladin maps to Ret stats anyway? No, looks like "Leveling" maps to generic. Let's fix logic:
        if role == "Leveling_Ret" and level >= 52 then role = "Leveling_Ret" else role = "Leveling" end 
        -- Actually, the table uses "Leveling_Ret_52_59". For < 52 it uses generic "Leveling". This logic is fine.

    elseif class == "DRUID" then
        if self:GetTalentRank("MOONKIN_FORM") > 0 then role = "Leveling_Caster"
        elseif self:GetTalentRank("TREE_OF_LIFE") > 0 or self:GetTalentRank("NATURES_SWIFTNESS") > 0 then role = "Leveling_Healer"
        elseif self:GetTalentRank("THICK_HIDE") >= 3 then role = "Leveling_Bear"
        else role = "Leveling" end -- Feral Cat

    elseif class == "SHAMAN" then
        -- Tank Shaman Check (Shield Spec + Anticipation) - Rare but supported
        -- Note: SHIELD_SPEC/ANTICIPATION might not be in TBC map. If not, this skips.
        -- Fallback to standard specs:
        if self:GetTalentRank("ELEMENTAL_MASTERY") > 0 or self:GetTalentRank("TOTEM_OF_WRATH") > 0 then role = "Leveling_Caster"
        elseif self:GetTalentRank("MANA_TIDE") > 0 or self:GetTalentRank("EARTH_SHIELD") > 0 then role = "Leveling_Healer"
        else role = "Leveling" end -- Enhancement

    elseif class == "MAGE" then
        if self:GetTalentRank("IMP_BLIZZARD") >= 2 then role = "Leveling_AoE"
        elseif self:GetTalentRank("DRAGONS_BREATH") > 0 or self:GetTalentRank("COMBUSTION") > 0 then role = "Leveling_Fire"
        else role = "Leveling" end -- Frost ST

    elseif class == "WARLOCK" then
        if self:GetTalentRank("CONFLAGRATE") > 0 or self:GetTalentRank("SHADOWFURY") > 0 then role = "Leveling_Fire"
        elseif self:GetTalentRank("SUMMON_FELGUARD") > 0 or self:GetTalentRank("SOUL_LINK") > 0 then role = "Leveling_Demo"
        else role = "Leveling" end -- Affliction

    elseif class == "HUNTER" then
        -- Melee Hunter support?
        -- TBC Survival is usually Ranged Agi support, but if they are leveling Melee...
        -- Counterattack/Deterrence are in Survival.
        if self:GetTalentRank("SURVIVAL_INST") > 0 and self:GetTalentRank("WYVERN_STING") == 0 then role = "Leveling_Melee" -- Guesswork for melee
        else role = "Leveling" end
        
    elseif class == "ROGUE" then
        if self:GetTalentRank("MUTILATE") > 0 then role = "Leveling_Dagger"
        elseif self:GetTalentRank("HEMORRHAGE") > 0 then role = "Leveling_Hemo"
        else role = "Leveling" end -- Combat Swords
    end

    -- Construct Key
    local specificKey = role .. suffix
    if role == "Leveling" then specificKey = "Leveling" .. suffix end

    -- SAFETY CHECK
    -- If the specific key (e.g., Leveling_Tank_60_70) exists, use it.
    if MSC.LevelingWeightDB[class] and MSC.LevelingWeightDB[class][specificKey] then 
        return specificKey
    else
        -- If not found (maybe Leveling_Ret_21_40 doesn't exist, only generic Leveling_21_40), fallback.
        return "Leveling" .. suffix 
    end
end