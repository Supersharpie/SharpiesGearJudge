local _, MSC = ...

-- =============================================================
-- 1. RACIAL BONUSES (Now using IDs for 100% accuracy)
-- =============================================================
-- IDs: 0=Axe1H, 1=Axe2H, 2=Bow, 3=Gun, 4=Mace1H, 5=Mace2H, 
-- 7=Sword1H, 8=Sword2H, 16=Thrown, 18=Crossbow
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
-- 2. WEAPON SPEED PREFERENCES
-- =============================================================
MSC.SpeedChecks = {
    ["WARRIOR"] = { ["Fury"]={ MH_Slow=true, OH_Fast=true }, ["Protection"]={ MH_Fast=true }, ["Default"]={ MH_Slow=true } },
    ["ROGUE"]   = { ["Combat"]={ MH_Slow=true, OH_Fast=true }, ["Default"]={ MH_Slow=true, OH_Fast=true } },
    ["PALADIN"] = { ["Protection"]={ MH_Fast=true }, ["Default"]={ MH_Slow=true } },
    ["HUNTER"]  = { ["Default"]={ Ranged_Slow=true } },
    ["SHAMAN"]  = { ["Enhancement"]={ MH_Slow=true }, ["Default"]={ MH_Slow=true } }
}

-- =============================================================
-- 3. CLASS WEAPON PROFICIENCIES
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
-- 4. SHORT NAMES
-- =============================================================
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
    ["ITEM_MOD_HOLY_DAMAGE_SHORT"]        = "Holy Dmg",
    ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"]  = "Shadow Res",
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = "Ranged AP",
    ["ITEM_MOD_ARMOR_SHORT"]              = "Armor",
    ["ITEM_MOD_HEALTH_SHORT"]             = "Health",
    ["ITEM_MOD_MANA_SHORT"]               = "Mana",
    ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = "Weapon Skill",
}

-- =============================================================
-- 5. SLOT MAPPING
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