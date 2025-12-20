local _, MSC = ...

function MSC.ParseTooltipLine(text)
    if not text then return nil, 0 end
    
    -- 1. SMART SET BONUS LOGIC (Color Check)
    -- We strictly only want to read Set Bonuses if they are ACTIVE (Green).
    -- If a line contains "Set:" but does NOT have the Green color code (|cff00ff00), it is inactive/gray.
    if text:find("Set:") then
        if not text:find("ff00ff00") then 
            return nil, 0 
        end
    end
    
    -- 2. SANITIZE & CLEANUP
    -- Now we strip colors to read the numbers
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    
    -- 3. IGNORE TEMPORARY BUFFS
    -- Note: We removed "Set:" from here so the Green ones above can pass through!
    if text:find("^Use:") or 
       text:find("^Chance on hit:") or 
       text:find("^Procs:") then 
        return nil, 0 
    end
    
    local patterns = {
        -- [[ NEW FALLBACKS FOR WRAPPED TEXT ]] --
        -- WEAPON SPEED
        { pattern = "^Speed (%d+%.%d+)", stat = "MSC_WEAPON_SPEED" },
        
        -- HIT / SPELL HIT
        { pattern = "%+(%d+)%%? Hit", stat = "ITEM_MOD_HIT_RATING_SHORT" },
        { pattern = "Improves your chance to hit by (%d+)%%", stat = "ITEM_MOD_HIT_RATING_SHORT" },
        { pattern = "Increases your spell hit rating by (%d+)", stat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { pattern = "Improves your chance to hit with spells by (%d+)%%", stat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { pattern = "by (%d+)%%%.?$", stat = "ITEM_MOD_HIT_RATING_SHORT" },

        -- CRIT / SPELL CRIT
        { pattern = "%+(%d+)%%? Crit", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "Improves your chance to get a critical strike by (%d+)%%", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "Increases your critical strike rating by (%d+)", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "Increases your spell critical strike rating by (%d+)", stat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
        { pattern = "Improves your chance to get a critical strike with spells by (%d+)%%", stat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
        { pattern = "with spells by (%d+)%%%.?$", stat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        
        -- CLASSIC WEAPON SKILLS
        { pattern = "Increased Axes %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Swords %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Daggers %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Maces %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Two%-Handed Swords %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Two%-Handed Axes %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Two%-Handed Maces %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Bows %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Guns %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Crossbows %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Staves %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Fists %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        { pattern = "Increased Dagger Skill %+(%d+)", stat = "ITEM_MOD_WEAPON_SKILL_RATING_SHORT" },
        
        -- DEFENSIVE
        { pattern = "%+(%d+)%%? Dodge", stat = "ITEM_MOD_DODGE_RATING_SHORT" },
        { pattern = "Increases your chance to dodge an attack by (%d+)%%", stat = "ITEM_MOD_DODGE_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Parry", stat = "ITEM_MOD_PARRY_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Block", stat = "ITEM_MOD_BLOCK_RATING_SHORT" },
        { pattern = "Increases your chance to block attacks with a shield by (%d+)%%", stat = "ITEM_MOD_BLOCK_RATING_SHORT" },
        { pattern = "Increases the block value of your shield by (%d+)", stat = "ITEM_MOD_BLOCK_VALUE_SHORT" },
        { pattern = "defense rating by (%d+)", stat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { pattern = "Increased Defense %+(%d+)", stat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { pattern = "%+(%d+) Defense", stat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { pattern = "dodge an attack by (%d+)%%%.?$", stat = "ITEM_MOD_DODGE_RATING_SHORT" },
        
        -- MANA PER 5 (MP5)
        { pattern = "Restores (%d+) mana per 5 sec", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "(%d+) mana per 5 sec", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "Restores (%d+) mana", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "^mana per 5 sec%.?$", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        
        -- HEALTH PER 5 (HP5)
        { pattern = "Restores (%d+) health per 5 sec", stat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
        { pattern = "(%d+) health per 5 sec", stat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
        { pattern = "Restores (%d+) health every 5 sec", stat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
        { pattern = "%+(%d+) Health Regen", stat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
        
        -- ATTACK POWER
        { pattern = "Attack Power by (%d+)", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { pattern = "Attack Power in Cat, Bear", stat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" }, 
        { pattern = "%+(%d+) Attack Power", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        
        -- SPELL POWER / HEALING
        { pattern = "damage and healing done by magical spells and effects by up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "damage done by magical spells and effects by up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "healing done by spells and effects by up to (%d+)", stat = "ITEM_MOD_HEALING_POWER_SHORT" },
        { pattern = "%+(%d+) Healing Spells", stat = "ITEM_MOD_HEALING_POWER_SHORT" },
        { pattern = "%+(%d+) Spell Damage", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "by up to (%d+)%.?$", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        
        -- SPECIFIC MAGIC DAMAGE
        { pattern = "Shadow damage by up to (%d+)", stat = "ITEM_MOD_SHADOW_DAMAGE_SHORT" },
        { pattern = "Fire damage by up to (%d+)", stat = "ITEM_MOD_FIRE_DAMAGE_SHORT" },
        { pattern = "Frost damage by up to (%d+)", stat = "ITEM_MOD_FROST_DAMAGE_SHORT" },
        { pattern = "Arcane damage by up to (%d+)", stat = "ITEM_MOD_ARCANE_DAMAGE_SHORT" },
        { pattern = "Nature damage by up to (%d+)", stat = "ITEM_MOD_NATURE_DAMAGE_SHORT" },
        { pattern = "Holy damage by up to (%d+)", stat = "ITEM_MOD_HOLY_DAMAGE_SHORT" },
        
        -- PRIMARY STATS
        { pattern = "Agility by (%d+)", stat = "ITEM_MOD_AGILITY_SHORT" },
        { pattern = "Strength by (%d+)", stat = "ITEM_MOD_STRENGTH_SHORT" },
        { pattern = "Intellect by (%d+)", stat = "ITEM_MOD_INTELLECT_SHORT" },
        { pattern = "Spirit by (%d+)", stat = "ITEM_MOD_SPIRIT_SHORT" },
        { pattern = "Stamina by (%d+)", stat = "ITEM_MOD_STAMINA_SHORT" }, 
        
        -- PRIMARY STATS (Standard Format)
        { pattern = "%+(%d+) Agility", stat = "ITEM_MOD_AGILITY_SHORT" },
        { pattern = "%+(%d+) Strength", stat = "ITEM_MOD_STRENGTH_SHORT" },
        { pattern = "%+(%d+) Intellect", stat = "ITEM_MOD_INTELLECT_SHORT" },
        { pattern = "%+(%d+) Spirit", stat = "ITEM_MOD_SPIRIT_SHORT" },
        { pattern = "%+(%d+) Stamina", stat = "ITEM_MOD_STAMINA_SHORT" },
        
        -- FLAT RESOURCES
        { pattern = "%+(%d+) Health", stat = "ITEM_MOD_HEALTH_SHORT" },
        { pattern = "%+(%d+) Mana", stat = "ITEM_MOD_MANA_SHORT" },
    }

    for _, p in ipairs(patterns) do
        local val = text:match(p.pattern)
        if val then return p.stat, tonumber(val) end
    end
    return nil, 0
end