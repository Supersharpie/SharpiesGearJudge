local _, MSC = ...

-- =============================================================
-- 1. STAT WEIGHTS (Raiding & Leveling Brackets)
-- =============================================================
MSC.WeightDB = {
    ["WARRIOR"] = {
        ["Default"]    = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        ["Arms"]       = { ["ITEM_MOD_STRENGTH_SHORT"]=1.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, ["ITEM_MOD_AGILITY_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        ["Fury"]       = { ["ITEM_MOD_STRENGTH_SHORT"]=1.4, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=0.9, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.5 },
        ["Protection"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.8, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=0.8, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.5 },
        
        -- LEVELING
        -- 1-20: Prioritize hitting harder (Str) and not dying (Stam).
        ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=0.8 },
        -- 21-40: "Whirlwind Axe" Era. Big slow hits matter most.
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.6, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        -- 41-59: Pre-Raid prep. Crit and Hit start becoming vital for rage generation.
        ["Leveling_41_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.2 },
    },
    ["PALADIN"] = {
        ["Default"]     = { ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        ["Holy"]        = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Protection"]  = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.5 },
        ["Retribution"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.5 },
        
        -- LEVELING
        -- 1-20: Seal of Righteousness. Needs Mana (Int) and HP (Stam). Strength to kill.
        ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=1.4, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        -- 21-40: Seal of Command. Slow 2H weapons + Strength.
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.6, ["ITEM_MOD_AGILITY_SHORT"]=0.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        -- 41-59: Vengeance Spec. Crit becomes massive for proc uptime.
        ["Leveling_41_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5 },
    },
    ["PRIEST"] = {
        ["Default"]    = { ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2 },
        ["Discipline"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_HEALING_POWER_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Holy"]       = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Shadow"]     = { ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        
        -- LEVELING
        -- 1-20: Wand DPS is primary damage. Spirit Tap is primary regen.
        ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        -- 21-40: Wand Specialization active. Spells begin to weave in.
        ["Leveling_21_40"] = { ["ITEM_MOD_SPIRIT_SHORT"]=2.0, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        -- 41-59: Shadowform Era. Shadow Damage becomes the #1 stat.
        ["Leveling_41_59"] = { ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_SPIRIT_SHORT"]=1.2 },
    },
    ["ROGUE"] = {
        ["Default"]       = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.6, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        ["Assassination"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        ["Combat"]        = { ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_STRENGTH_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.5 },
        ["Subtlety"]      = { ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        ["Tank"]          = { ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_PARRY_RATING_SHORT"]=1.5, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        
        -- LEVELING
        -- 1-20: Agility (Armor/Dodge/Crit) and Strength (Raw AP).
        ["Leveling_1_20"]  = { ["ITEM_MOD_AGILITY_SHORT"]=1.6, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        -- 21-40: Dual Wield penalty is high. Hit Rating starts mattering.
        ["Leveling_21_40"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        -- 41-59: Combat Potency/Sword Spec. Crit and AP scaling.
        ["Leveling_41_59"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=1.2 },
    },
    ["HUNTER"] = {
        ["Default"]      = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.4, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 },
        ["BeastMastery"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 },
        ["Marksmanship"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0 },
        ["Survival"]     = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.6, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 },
        
        -- LEVELING
        -- 1-20: Raptor Strike Era. Agi/Stam.
        ["Leveling_1_20"]  = { ["ITEM_MOD_AGILITY_SHORT"]=1.6, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.6 },
        -- 21-40: Needs more mana (Int) for Stings/Multi-Shot.
        ["Leveling_21_40"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=0.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        -- 41-59: Pure Ranged Damage (AP/Crit).
        ["Leveling_41_59"] = { ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2 },
    },
    ["MAGE"] = {
        ["Default"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5 },
        ["Arcane"]  = { ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Fire"]    = { ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Frost"]   = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=3.0 },
        
        -- LEVELING
        -- 1-20: Wand DPS is primary finisher. Int for Mana Pool.
        ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        -- 21-40: AoE Farming risks require higher Stamina.
        ["Leveling_21_40"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.5 },
        -- 41-59: Shatter Combos. Spell Power stacking.
        ["Leveling_41_59"] = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
    },
    ["WARLOCK"] = {
        ["Default"]     = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Affliction"]  = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.8 },
        ["Demonology"]  = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5 },
        ["Destruction"] = { ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Tank"]        = { ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"]=3.0, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0 },
        
        -- LEVELING
        -- 1-20: Wand DPS is Life. Stamina IS Mana (Life Tap).
        ["Leveling_1_20"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5 },
        -- 21-40: Drain Life unlocked, but Wands still used as filler.
        ["Leveling_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.2, ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=1.0, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2 },
        -- 41-59: Drain Tanking (Dark Pact). Shadow Dmg + Stamina are mostly what matters.
        ["Leveling_41_59"] = { ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5 },
    },
    ["SHAMAN"] = {
        ["Default"]     = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 },
        ["Elemental"]   = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5 },
        ["Enhancement"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.5 },
        ["Restoration"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Tank"]        = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_SHIELD_BLOCK_RATING_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        
        -- LEVELING
        -- 1-20: Auto-attacking with Staff/Mace + Shocks. Str/Stam/Int.
        ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        -- 21-40: Windfury Weapon (Lvl 30). Strength and Agi.
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        -- 41-59: Stormstrike. Crit starts to scale well with Flurry.
        ["Leveling_41_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2 },
    },
    ["DRUID"] = {
        ["Default"]     = { ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Balance"]     = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["FeralCombat"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=1.0 },
        ["Restoration"] = { ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Tank"]        = { ["ITEM_MOD_STAMINA_SHORT"]=2.5, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ARMOR_SHORT"]=2.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=1.5, ["ITEM_MOD_HIT_RATING_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=0.8, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 },
        
        -- LEVELING
        -- 1-20: Bear Form. Str/Stam > Agi.
        ["Leveling_1_20"]  = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_AGILITY_SHORT"]=1.0 },
        -- 21-40: Cat Form (Level 20). Speed increases. Str/Agi.
        ["Leveling_21_40"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.6, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        -- 41-59: Ferocious Bite/Crit stacking.
        ["Leveling_41_59"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.8, ["ITEM_MOD_AGILITY_SHORT"]=1.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2 },
    },
}

-- =============================================================
-- 2. SPEC NAMES (Unchanged)
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
-- 3. ENCHANT DATABASE (Unchanged)
-- =============================================================
MSC.EnchantDB = {
    [2504] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 30 }, 
    [2505] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 55 },
    [2564] = { ["ITEM_MOD_AGILITY_SHORT"] = 15 },
    [2563] = { ["ITEM_MOD_STRENGTH_SHORT"] = 15 },
    [1900] = { ["ITEM_MOD_STRENGTH_SHORT"] = 100 }, 
    [2565] = { ["ITEM_MOD_INTELLECT_SHORT"] = 22 },
    [1897] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30 },
    [2503] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 7 },
    [2621] = { ["ITEM_MOD_STAMINA_SHORT"] = 4, ["ITEM_MOD_STRENGTH_SHORT"] = 4, ["ITEM_MOD_AGILITY_SHORT"] = 4, ["ITEM_MOD_INTELLECT_SHORT"] = 4, ["ITEM_MOD_SPIRIT_SHORT"] = 4 },
    [2629] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 4 },
    [2603] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 26, ["ITEM_MOD_CRIT_RATING_SHORT"] = 1 },
    [2604] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 15, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 1 },
    [2605] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 33, ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 5 },
    [2606] = { ["ITEM_MOD_STAMINA_SHORT"] = 16, ["ITEM_MOD_ARMOR_SHORT"] = 100 },
    [2586] = { ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 24, ["ITEM_MOD_STAMINA_SHORT"] = 10, ["ITEM_MOD_HIT_RATING_SHORT"] = 1 },
    [2585] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 28, ["ITEM_MOD_DODGE_RATING_SHORT"] = 1 },
    [2583] = { ["ITEM_MOD_STAMINA_SHORT"] = 10, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 7, ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 15 },
    [2584] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 24, ["ITEM_MOD_STAMINA_SHORT"] = 10, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 7 },
    [2589] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 24, ["ITEM_MOD_STAMINA_SHORT"] = 10, ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 4 },
    [2587] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 18, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1 },
    [2588] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 18, ["ITEM_MOD_STAMINA_SHORT"] = 10 },
    [2591] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 13, ["ITEM_MOD_INTELLECT_SHORT"] = 15 },
    [2590] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 24, ["ITEM_MOD_STAMINA_SHORT"] = 10, ["ITEM_MOD_INTELLECT_SHORT"] = 10 },
    [2607] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30 },
    [2608] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 18 },
    [2609] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 33 },
    [2443] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 8 },
    [2543] = { ["ITEM_MOD_ATTACK_SPEED_SHORT"] = 1 }, 
    [2544] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 8 },
    [2545] = { ["ITEM_MOD_DODGE_RATING_SHORT"] = 1 },
    [2488] = { ["ITEM_MOD_HEALTH_SHORT"] = 100 },
    [2483] = { ["ITEM_MOD_STRENGTH_SHORT"] = 8 },
    [2484] = { ["ITEM_MOD_STAMINA_SHORT"] = 8 },
    [2485] = { ["ITEM_MOD_AGILITY_SHORT"] = 8 },
    [2486] = { ["ITEM_MOD_INTELLECT_SHORT"] = 8 },
    [2487] = { ["ITEM_MOD_SPIRIT_SHORT"] = 8 },
}