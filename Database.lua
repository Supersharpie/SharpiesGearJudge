local _, MSC = ...

-- 1. STAT WEIGHTS
MSC.WeightDB = {
    ["PALADIN"] = {
        ["Default"]     = { ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Holy"]        = { ["ITEM_MOD_SPELL_HEALING_DONE"]=2.2, ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_POWER_REGEN0_SHORT"]=2.5, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5 },
        ["Protection"]  = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.0 },
        ["Retribution"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=0.8 },
        ["Hybrid"]      = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 }, 
    },
    ["PRIEST"] = {
        ["Default"]    = { ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2 },
        ["Discipline"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_POWER_REGEN0_SHORT"]=1.5, ["ITEM_MOD_SPELL_HEALING_DONE"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Holy"]       = { ["ITEM_MOD_SPELL_HEALING_DONE"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Shadow"]     = { ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Hybrid"]     = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.5 },
    },
    ["DRUID"] = {
        ["Default"]     = { ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Balance"]     = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=2.0 },
        ["FeralCombat"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
        ["Restoration"] = { ["ITEM_MOD_SPELL_HEALING_DONE"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.5, ["ITEM_MOD_POWER_REGEN0_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Hybrid"]      = { ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
    },
    ["SHAMAN"] = {
        ["Default"]     = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.0 },
        ["Elemental"]   = { ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5 },
        ["Enhancement"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2 },
        ["Restoration"] = { ["ITEM_MOD_SPELL_HEALING_DONE"]=2.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, ["ITEM_MOD_POWER_REGEN0_SHORT"]=1.5, ["ITEM_MOD_INTELLECT_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Hybrid"]      = { ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
    },
    ["WARLOCK"] = {
        ["Default"]     = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.8 },
        ["Affliction"]  = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8 },
        ["Demonology"]  = { ["ITEM_MOD_STAMINA_SHORT"]=1.8, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5 },
        ["Destruction"] = { ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
        ["Hybrid"]      = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.0 },
    },
    ["MAGE"] = {
        ["Default"] = { ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5 },
        ["Arcane"]  = { ["ITEM_MOD_INTELLECT_SHORT"]=1.5, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2 },
        ["Fire"]    = { ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.5, ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0 },
        ["Frost"]   = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=3.0 },
        ["Hybrid"]  = { ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=1.0 },
    },
    ["ROGUE"] = {
        ["Default"]       = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=0.6, ["ITEM_MOD_STAMINA_SHORT"]=0.8 },
        ["Assassination"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
        ["Combat"]        = { ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_STRENGTH_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0 },
        ["Subtlety"]      = { ["ITEM_MOD_AGILITY_SHORT"]=1.8, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Hybrid"]        = { ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_STAMINA_SHORT"]=1.2 }, 
    },
    ["WARRIOR"] = {
        ["Default"]    = { ["ITEM_MOD_STRENGTH_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Arms"]       = { ["ITEM_MOD_STRENGTH_SHORT"]=1.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, ["ITEM_MOD_STAMINA_SHORT"]=1.2 },
        ["Fury"]       = { ["ITEM_MOD_STRENGTH_SHORT"]=1.4, ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=0.9 },
        ["Protection"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.2 },
        ["Hybrid"]     = { ["ITEM_MOD_STAMINA_SHORT"]=1.5, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.0, ["ITEM_MOD_STRENGTH_SHORT"]=1.2 }, 
    },
    ["HUNTER"] = {
        ["Default"]      = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.4 },
        ["BeastMastery"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
        ["Marksmanship"] = { ["ITEM_MOD_AGILITY_SHORT"]=1.6, ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0 },
        ["Survival"]     = { ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STAMINA_SHORT"]=1.2, ["ITEM_MOD_INTELLECT_SHORT"]=0.6 },
        ["Hybrid"]       = { ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.5 }, 
    },
}

MSC.SpecNames = {
    ["WARLOCK"] = { [1]="Affliction", [2]="Demonology", [3]="Destruction" },
    ["PALADIN"] = { [1]="Holy", [2]="Protection", [3]="Retribution" },
    ["MAGE"]    = { [1]="Arcane", [2]="Fire", [3]="Frost" },
}

-- 2. SHORT NAMES MAPPING
MSC.ShortNames = {
    ["ITEM_MOD_SPELL_HEALING_DONE"]       = "Healing",
    ["ITEM_MOD_HEALING_POWER_SHORT"]      = "Healing",
    ["ITEM_MOD_SPELL_POWER_SHORT"]        = "Spell Power",
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]  = "DPS",
    ["ITEM_MOD_POWER_REGEN0_SHORT"]       = "Mp5",
    ["ITEM_MOD_MANA_REGENERATION_SHORT"]  = "Mp5",
    ["ITEM_MOD_AGILITY_SHORT"]            = "Agility",
    ["ITEM_MOD_STRENGTH_SHORT"]           = "Strength",
    ["ITEM_MOD_INTELLECT_SHORT"]          = "Intellect",
    ["ITEM_MOD_SPIRIT_SHORT"]             = "Spirit",
    ["ITEM_MOD_STAMINA_SHORT"]            = "Stamina",
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = "Defense",
    ["ITEM_MOD_DODGE_RATING_SHORT"]       = "Dodge",
    ["ITEM_MOD_PARRY_RATING_SHORT"]       = "Parry",
    ["ITEM_MOD_BLOCK_RATING_SHORT"]       = "Block Chance",
    ["ITEM_MOD_HIT_RATING_SHORT"]         = "Hit",
    ["ITEM_MOD_CRIT_RATING_SHORT"]        = "Crit",
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]  = "Spell Crit",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]   = "Spell Hit",
    ["ITEM_MOD_ATTACK_POWER_SHORT"]       = "Attack Power",
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = "Feral AP",
    ["ITEM_MOD_BLOCK_VALUE_SHORT"]        = "Block Value",
    ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]      = "Shadow Dmg",
    ["ITEM_MOD_FIRE_DAMAGE_SHORT"]        = "Fire Dmg",
    ["ITEM_MOD_FROST_DAMAGE_SHORT"]       = "Frost Dmg",
    ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]      = "Arcane Dmg",
    ["ITEM_MOD_NATURE_DAMAGE_SHORT"]      = "Nature Dmg",
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"]        = "Holy Dmg"
}