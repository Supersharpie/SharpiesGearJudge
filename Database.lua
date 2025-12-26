local _, MSC = ...

-- =============================================================
-- 1. STAT WEIGHTS (EP VALUES - v1.15.8 Classic
-- =============================================================
-- NOTE: Melee Weights normalized to Attack Power = 1
-- NOTE: Caster Weights normalized to Spell Power = 1
-- NOTE: Low weights (0.1 - 0.5) added to Stam/Int/Armor to ensure Tooltip Visibility

MSC.WeightDB = {
    ["WARRIOR"] = {
        ["Default"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0,       
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.3,        
            ["ITEM_MOD_STAMINA_SHORT"]=0.5,        
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1, 
            ["ITEM_MOD_ARMOR_SHORT"]=0.05,         
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=2.0 
        },
        
        -- [[ DYNAMIC ENGINE SPECS ]] --
        ["FURY_2H"] = {
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 7.5, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.3,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 28.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 12.0,  
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 0.1, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.5,        
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.1, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.05,         
        },
        ["FURY_DW"] = {
            ["ITEM_MOD_HIT_RATING_SHORT"] = 22.0,  
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 18.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 30.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,      
            ["ITEM_MOD_STAMINA_SHORT"] = 0.5,        
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.1, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.05,
        },
        ["ARMS_MS"] = {
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 8.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 28.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.2,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,      
            ["ITEM_MOD_ARMOR_SHORT"] = 0.1,        
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.2,
        },
        ["DEEP_PROT"] = {
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,      
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5, 
            ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 0.6,  
            ["ITEM_MOD_HIT_RATING_SHORT"] = 10.0,  
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 12.0,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 12.0,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.1,        
            ["ITEM_MOD_STRENGTH_SHORT"] = 0.5,     
            ["ITEM_MOD_AGILITY_SHORT"] = 0.5,      
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.1,
        },
        ["FURY_PROT"] = {
            ["ITEM_MOD_HIT_RATING_SHORT"] = 22.0,  
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 20.0, 
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,      
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.5,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.1,
        },
        ["ARMS_PROT"] = {
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 20.0,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0,
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 0.8,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 10.0,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.08,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 0.1,
        },
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=5.0, 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.0,              
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=3.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5,              
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.3, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=15.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
    },

    ["PALADIN"] = {
        ["Default"]     = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_MANA_SHORT"]=0.05,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5
        },
        ["HOLY_RAID"]   = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=14.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,          
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=3.0,  
            ["ITEM_MOD_MANA_SHORT"]=0.05,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.8,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,  
            ["ITEM_MOD_ARMOR_SHORT"]=0.01,  
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["HOLY_DEEP"]   = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=4.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=8.0,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_MANA_SHORT"]=0.04,
            ["ITEM_MOD_ARMOR_SHORT"]=0.01,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["PROT_DEEP"]   = { 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5,
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.8,    
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.6,    
            ["ITEM_MOD_BLOCK_RATING_SHORT"]=0.8,
            ["ITEM_MOD_DODGE_RATING_SHORT"]=12.0, 
            ["ITEM_MOD_PARRY_RATING_SHORT"]=12.0, 
            ["ITEM_MOD_ARMOR_SHORT"]=0.1,          
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,      
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["PROT_AOE"]    = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,    
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,        
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4,      
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=0.5,    
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.3,
            ["ITEM_MOD_ARMOR_SHORT"]=0.1,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["RET_STANDARD"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=22.0,   
            ["ITEM_MOD_AGILITY_SHORT"]=1.2,
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.5,     
            ["ITEM_MOD_INTELLECT_SHORT"]=0.1,   
            ["ITEM_MOD_MANA_SHORT"]=0.01,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
        ["RET_UTILITY"] = { 
            ["ITEM_MOD_HIT_RATING_SHORT"]=30.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_STAMINA_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
        ["SHOCKADIN"]   = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,    
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,        
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_ARMOR_SHORT"]=0.1
        },
        ["RECK_BOMB"]   = { 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,        
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0,       
            ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,
            ["ITEM_MOD_ARMOR_SHORT"]=0.1
        },
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=4.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.4,
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
    },

    ["PRIEST"] = {
        ["Default"]    = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=1.0,
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_STAMINA_SHORT"]=0.5,
            ["ITEM_MOD_MANA_SHORT"]=0.02,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["HOLY_DEEP"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.2, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 3.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 6.0,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2, 
            ["ITEM_MOD_MANA_SHORT"]=0.02,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["DISC_PI_SUPPORT"] = { 
            ["ITEM_MOD_INTELLECT_SHORT"] = 1.0, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 3.5,
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 0.8,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.6, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.4, 
            ["ITEM_MOD_MANA_SHORT"]=0.05,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["SHADOW_PVE"] = { 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 15.0, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 8.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,   
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["SHADOW_PVP"] = { 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 8.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05,    
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["HYBRID_POWER_WEAVING"] = {
             ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 12.0,
             ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
             ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 3.0,
             ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
             ["ITEM_MOD_STAMINA_SHORT"]=0.3,
             ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
             ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.0,            
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5,
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.0,            
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6,
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
    },

    ["ROGUE"] = {
        ["Default"]       = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.1,     
            ["ITEM_MOD_STAMINA_SHORT"]=0.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=15.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RAID_COMBAT_SWORDS"] = { 
            ["ITEM_MOD_HIT_RATING_SHORT"]=22.0,   
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.1, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=28.0,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2, 
            ["ITEM_MOD_ARMOR_SHORT"]=0.01,  
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RAID_COMBAT_DAGGERS"] = {
            ["ITEM_MOD_CRIT_RATING_SHORT"]=28.0,  
            ["ITEM_MOD_AGILITY_SHORT"]=2.4,
            ["ITEM_MOD_HIT_RATING_SHORT"]=20.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0,
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=15.0,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2,
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.01,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RAID_SEAL_FATE"] = { 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=32.0,  
            ["ITEM_MOD_AGILITY_SHORT"]=2.5,      
            ["ITEM_MOD_HIT_RATING_SHORT"]=18.0,   
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2,
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.01,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["PVP_HEMO"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,      
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0,      
            ["ITEM_MOD_HIT_RATING_SHORT"]=10.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"]=15.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.1,        
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["PVP_CB_DAGGER"] = {
            ["ITEM_MOD_CRIT_RATING_SHORT"]=25.0,  
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0,
            ["ITEM_MOD_AGILITY_SHORT"]=2.2,
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            ["ITEM_MOD_ARMOR_SHORT"]=0.1,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["PVP_MACE"] = {
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5,      
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 15.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 10.0,
            ["ITEM_MOD_AGILITY_SHORT"] = 1.8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.1,
            ["ITEM_MOD_ARMOR_SHORT"]=0.1,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.1, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.3, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=15.0,   
            ["ITEM_MOD_STRENGTH_SHORT"]=1.1, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5, 
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.4, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=18.0,   
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0,
            ["ITEM_MOD_STRENGTH_SHORT"]=1.1,
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
    },

    ["HUNTER"] = {
        ["Default"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]=1.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"]=32.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,
            ["ITEM_MOD_HIT_RATING_SHORT"]=32.0,
            ["ITEM_MOD_STAMINA_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RAID_MM_STANDARD"] = {
            ["ITEM_MOD_HIT_RATING_SHORT"] = 32.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5,
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 32.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RAID_MM_STARTER"] = { 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 20.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5,
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 32.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RAID_SURV_DEEP"] = {
            ["ITEM_MOD_AGILITY_SHORT"] = 3.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 30.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 30.0,
            ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["PVP_MM_UTIL"] = {
            ["ITEM_MOD_STAMINA_SHORT"] = 1.5, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 20.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["PVP_SURV_TANK"] = {
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["MELEE_NIGHTFALL"] = {
            ["ITEM_MOD_HIT_RATING_SHORT"] = 20.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["SOLO_DME_TRIBUTE"] = {
            ["ITEM_MOD_AGILITY_SHORT"] = 2.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,        
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=20.0,
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
    },

    ["MAGE"] = {
        ["Default"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.3, 
            ["ITEM_MOD_MANA_SHORT"]=0.02,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["FIRE_RAID"] = { 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=13.0, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=14.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["FROST_AP"]  = {
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,   
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=16.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=9.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["FROST_WC"]  = {
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=16.0,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.2,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["FROST_AOE"] = {
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,     
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,       
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.2,   
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8,        
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_ARMOR_SHORT"]=0.01,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["POM_PYRO"]  = {
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2,   
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_STAMINA_SHORT"]=0.8,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=15.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["ELEMENTAL"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_ARMOR_SHORT"]=0.02,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["FROST_PVP"] = {
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_ARMOR_SHORT"]=0.02,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=4.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,            
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,         
            ["ITEM_MOD_STAMINA_SHORT"]=1.2,           
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=0.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=0.5,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.3,
            ["ITEM_MOD_STAMINA_SHORT"]=0.5,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
    },

    ["WARLOCK"] = {
        ["Default"]     = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_MANA_SHORT"]=0.02,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RAID_DS_RUIN"] = {
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 15.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 11.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.3, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RAID_SM_RUIN"] = {
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 15.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 9.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["PVE_MD_RUIN"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 11.0,
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 15.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.3,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["PVP_NF_CONFLAG"] = { 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 10.0, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["PVP_SOUL_LINK"] = {
            ["ITEM_MOD_STAMINA_SHORT"] = 2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 5.0, 
            ["ITEM_MOD_ARMOR_SHORT"]=0.05,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["PVP_DEEP_DESTRO"] = {
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 12.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=5.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0,   
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0,
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8,     
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
    },

    ["SHAMAN"] = {
        ["Default"]     = { 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_MANA_SHORT"]=0.05, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            ["ITEM_MOD_STAMINA_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["ELE_PVE"] = {
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 10.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 13.0,  
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 1.0,
            ["ITEM_MOD_STAMINA_SHORT"]=0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["ELE_PVP"] = {
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 10.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.05,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["ENH_STORMSTRIKE"] = {
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0,     
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,  
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 25.0,  
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,       
            ["ITEM_MOD_HIT_RATING_SHORT"] = 20.0,    
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 10.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
        ["RESTO_DEEP"] = {
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 3.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 8.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.1,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RESTO_TOTEM_SUPPORT"] = {
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 4.0, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.5,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["HYBRID_ELE_RESTO"] = {
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.8,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.6,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 8.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["HYBRID_ENH_RESTO"] = {
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 0.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8,
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5,
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
    },

    ["DRUID"] = {
        ["Default"]     = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0,
            ["ITEM_MOD_MANA_SHORT"]=0.05,
            ["ITEM_MOD_STAMINA_SHORT"]=0.5,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["BALANCE_BOOMKIN"] = {
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 10.0, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 15.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.3, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.2,
            ["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = 1.0,
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"] = 1.0,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.2,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RESTO_MOONGLOW"] = {
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.5, 
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.6, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RESTO_REGROWTH"] = {
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 12.0, 
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 2.0,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["RESTO_DEEP"] = {
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 3.5, 
            ["ITEM_MOD_SPIRIT_SHORT"] = 1.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.5,
            ["ITEM_MOD_STAMINA_SHORT"] = 0.2,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["FERAL_CAT_DPS"] = {
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.4, 
            ["ITEM_MOD_AGILITY_SHORT"] = 1.5,  
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.0, -- REQUIRED for new Scoring
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 26.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"] = 22.0, 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 1.0,
            ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"] = 0, 
            ["ITEM_MOD_STAMINA_SHORT"] = 0.5,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.1,
            ["ITEM_MOD_ARMOR_SHORT"]=0.05,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.1
        },
        ["FERAL_BEAR_TANK"] = {
            ["ITEM_MOD_ARMOR_MODIFIER_SHORT"] = 1.0, 
            ["ITEM_MOD_ARMOR_SHORT"] = 0.2, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0, 
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 15.0,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 10.0, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 1.5,
            ["ITEM_MOD_AGILITY_SHORT"]=0.5,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["HYBRID_HOTW"] = {
            ["ITEM_MOD_STRENGTH_SHORT"] = 2.0,
            ["ITEM_MOD_INTELLECT_SHORT"] = 0.8, 
            ["ITEM_MOD_STAMINA_SHORT"] = 1.0,  
            ["ITEM_MOD_HEALING_POWER_SHORT"] = 0.8,
            ["ITEM_MOD_ARMOR_SHORT"] = 0.2,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.2
        },
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.2, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.4, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
        ["Leveling_41_59"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=2.4, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=20.0,
            ["ITEM_MOD_STAMINA_SHORT"]=1.0,
            ["ITEM_MOD_INTELLECT_SHORT"]=0.3,
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=0.5,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"]=0.5
        },
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
-- 4. WEAPON SPEED PREFERENCES
-- =============================================================
MSC.SpeedChecks = {
    ["WARRIOR"] = { ["Fury"]={ MH_Slow=true, OH_Fast=true }, ["Protection"]={ MH_Fast=true }, ["Default"]={ MH_Slow=true } },
    ["ROGUE"]   = { ["Combat"]={ MH_Slow=true, OH_Fast=true }, ["Default"]={ MH_Slow=true, OH_Fast=true } },
    ["PALADIN"] = { ["Protection"]={ MH_Fast=true }, ["Default"]={ MH_Slow=true } },
    ["HUNTER"]  = { ["Default"]={ Ranged_Slow=true } },
    ["SHAMAN"]  = { ["Enhancement"]={ MH_Slow=true }, ["Default"]={ MH_Slow=true } }
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
        ["FURY_DW"]         = "Raid: Fury (Dual Wield)",
        ["FURY_2H"]         = "Raid: Fury (2H Slam)",
        ["ARMS_MS"]         = "PvP: Arms (Mortal Strike)",
        ["DEEP_PROT"]       = "Tank: Deep Protection",
        ["FURY_PROT"]       = "Tank: Fury-Prot (Threat)",
        ["ARMS_PROT"]       = "Tank: Arms (Dungeon Hybrid)",
		["Leveling_1_20"] = "Leveling (Brackets 1-20)",
		["Leveling_21_40"] = "Leveling (Brackets 21-40)",
		["Leveling_41_59"] = "Leveling (Brackets 41-59)",
    },
    ["PALADIN"] = {
        ["HOLY_RAID"]       = "Healer: Holy (Illumination)",
        ["HOLY_DEEP"]       = "Healer: Deep Holy (Buffs)",
        ["PROT_DEEP"]       = "Tank: Deep Protection",
        ["PROT_AOE"]        = "Farming: Protection AoE",
        ["RET_STANDARD"]    = "DPS: Retribution",
        ["SHOCKADIN"]       = "PvP: Shockadin (Burst)",
        ["RECK_BOMB"]       = "PvP: Reck-Bomb (One-Shot)",
        ["RET_UTILITY"]     = "Raid: Ret Utility (Nightfall)",
		["Leveling_1_20"] = "Leveling (Brackets 1-20)",
		["Leveling_21_40"] = "Leveling (Brackets 21-40)",
		["Leveling_41_59"] = "Leveling (Brackets 41-59)",
    },
    ["HUNTER"] = {
        ["RAID_MM_STANDARD"] = "Raid: Marksmanship (Standard)",
        ["RAID_MM_SUREFOOTED"]  = "Raid: MM (Surefooted)",
        ["RAID_SURV_DEEP"]   = "Raid: Deep Survival (Agi)",
        ["PVP_MM_UTIL"]      = "PvP: Marksmanship Utility",
        ["PVP_SURV_TANK"]    = "PvP: Survival Tank",
        ["MELEE_NIGHTFALL"]  = "Support: Nightfall (Melee)",
        ["SOLO_DME_TRIBUTE"] = "Farming: DM North Solo",
		["Leveling_1_20"] = "Leveling (Brackets 1-20)",
		["Leveling_21_40"] = "Leveling (Brackets 21-40)",
		["Leveling_41_59"] = "Leveling (Brackets 41-59)",
    },
    ["ROGUE"] = {
        ["RAID_COMBAT_SWORDS"]  = "Raid: Combat Swords",  -- Changed from PVE_
        ["RAID_COMBAT_DAGGERS"] = "Raid: Combat Daggers", -- Changed from PVE_
        ["RAID_SEAL_FATE"]      = "Raid: Seal Fate (Crit)", -- Changed from PVE_
        ["PVP_MACE"]		    = "PvP: Mace Specialization (Stun)",
		["PVP_HEMO"]            = "PvP: Hemo Control",
        ["PVP_CB_DAGGER"]       = "PvP: Cold Blood Burst",
		["Leveling_1_20"] = "Leveling (Brackets 1-20)",
		["Leveling_21_40"] = "Leveling (Brackets 21-40)",
		["Leveling_41_59"] = "Leveling (Brackets 41-59)",
    },
    ["PRIEST"] = {
        ["HOLY_DEEP"]          = "Healer: Deep Holy",
        ["DISC_PI_SUPPORT"]    = "Healer: Disc (Power Infusion)",
        ["SHADOW_PVE"]         = "DPS: Shadow (PvE)",
        ["SHADOW_PVP"]         = "PvP: Shadow (Blackout)",
        ["HYBRID_POWER_WEAVING"] = "Support: Power Weaving",
		["Leveling_1_20"] = "Leveling (Brackets 1-20)",
		["Leveling_21_40"] = "Leveling (Brackets 21-40)",
		["Leveling_41_59"] = "Leveling (Brackets 41-59)",
    },
    ["SHAMAN"] = {
        ["ELE_PVE"]            = "DPS: Elemental (PvE)",
        ["ELE_PVP"]            = "PvP: Elemental (Burst)",
        ["RESTO_DEEP"]         = "Healer: Deep Restoration",
        ["RESTO_TOTEM_SUPPORT"]= "Healer: Totem Twisting",
        ["ENH_STORMSTRIKE"]    = "DPS: Enhancement",
        ["HYBRID_ELE_RESTO"]   = "Hybrid: Ele / Resto (NS)",
        ["HYBRID_ENH_RESTO"]   = "Hybrid: Enh / Resto (PvP)",
		["Leveling_1_20"] = "Leveling (Brackets 1-20)",
		["Leveling_21_40"] = "Leveling (Brackets 21-40)",
		["Leveling_41_59"] = "Leveling (Brackets 41-59)",
    },
    ["MAGE"] = {
        ["FIRE_RAID"]          = "Raid: Deep Fire (Combustion)",
        ["FROST_AP"]           = "Raid: Frost (Arcane Power)",
        ["FROST_WC"]           = "Raid: Frost (Winter's Chill)",
        ["POM_PYRO"]           = "PvP: PoM Pyro (3-Min Mage)",
        ["ELEMENTAL"]          = "PvP: Elemental (Shatter)", -- Changed from PVP_ELEMENTAL
        ["FARM_AOE_BLIZZ"]     = "Farming: Frost AoE",
        ["FROST_PVP"]          = "PvP: Deep Frost",
		["Leveling_1_20"] = "Leveling (Brackets 1-20)",
		["Leveling_21_40"] = "Leveling (Brackets 21-40)",
		["Leveling_41_59"] = "Leveling (Brackets 41-59)",
    },
    ["WARLOCK"] = {
        ["RAID_DS_RUIN"]        = "Raid: Destruction (DS/Ruin)", -- Changed from PVE_
        ["RAID_SM_RUIN"]        = "Raid: Affliction (SM/Ruin)",  -- Changed from PVE_
        ["PVE_MD_RUIN"]    = "Raid: Master Demonologist (Ruin)",
		["PVP_NF_CONFLAG"] = "PvP: Nightfall / Conflagrate",
		["PVP_SOUL_LINK"]      = "PvP: Soul Link (Tank)",
        ["PVP_DEEP_DESTRO"]    = "PvP: Destruction (Conflag)",
		["Leveling_1_20"] = "Leveling (Brackets 1-20)",
		["Leveling_21_40"] = "Leveling (Brackets 21-40)",
		["Leveling_41_59"] = "Leveling (Brackets 41-59)",
    },
    ["DRUID"] = {
        ["BALANCE_BOOMKIN"]    = "DPS: Balance (Boomkin)",
        ["RESTO_DEEP"]         = "Healer: Deep Restoration",
        ["RESTO_MOONGLOW"]     = "Healer: Moonglow",
        ["RESTO_REGROWTH"]     = "Healer: Regrowth (Crit)",
        ["FERAL_CAT_DPS"]      = "DPS: Feral Cat",
        ["FERAL_BEAR_TANK"]    = "Tank: Feral Bear",
        ["HYBRID_HOTW"]        = "Hybrid: Heart of the Wild",
		["Leveling_1_20"] = "Leveling (Brackets 1-20)",
		["Leveling_21_40"] = "Leveling (Brackets 21-40)",
		["Leveling_41_59"] = "Leveling (Brackets 41-59)",
    },
}