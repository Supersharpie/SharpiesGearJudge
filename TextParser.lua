local _, MSC = ...

function MSC.ParseTooltipLine(text)
    if not text then return nil, 0 end
    
    if text:find("Set:") and not text:find("ff00ff00") then return nil, 0 end
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if text:find("^Use:") or text:find("^Chance on hit:") or text:find("when fighting") then return nil, 0 end
    
    local patterns = {
        -- [[ 1. SPEED ]]
        { pattern = "Speed (%d+%.%d+)", stat = "MSC_WEAPON_SPEED" },

        -- [[ 2. RANGED ATTACK POWER ]]
        { pattern = "ranged attack power.-by (%d+)", stat = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" },
        { pattern = "%+(%d+) Ranged Attack Power", stat = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" },

        -- [[ 3. SPELL POWER & HEALING ]]
        { pattern = "damage and healing.-up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "magical spells.-up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "healing done.-up to (%d+)", stat = "ITEM_MOD_HEALING_POWER_SHORT" },
        { pattern = "spells and effects.-up to (%d+)", stat = "ITEM_MOD_HEALING_POWER_SHORT" },

        -- [[ 4. SPECIFIC SCHOOLS ]]
        { pattern = "Shadow damage.-up to (%d+)", stat = "ITEM_MOD_SHADOW_DAMAGE_SHORT" },
        { pattern = "Fire damage.-up to (%d+)", stat = "ITEM_MOD_FIRE_DAMAGE_SHORT" },
        { pattern = "Frost damage.-up to (%d+)", stat = "ITEM_MOD_FROST_DAMAGE_SHORT" },
        { pattern = "Arcane damage.-up to (%d+)", stat = "ITEM_MOD_ARCANE_DAMAGE_SHORT" },
        { pattern = "Nature damage.-up to (%d+)", stat = "ITEM_MOD_NATURE_DAMAGE_SHORT" },
        { pattern = "Holy damage.-up to (%d+)", stat = "ITEM_MOD_HOLY_DAMAGE_SHORT" },

        -- [[ 5. CRIT & HIT ]]
        { pattern = "critical strike.-spells.-(%d+)%%", stat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
        { pattern = "critical strike.-(%d+)%%", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "hit.-spells.-(%d+)%%", stat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { pattern = "hit.-(%d+)%%", stat = "ITEM_MOD_HIT_RATING_SHORT" },

        -- [[ 6. MP5 / HP5 ]]
        { pattern = "(%d+) mana per 5 sec", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "(%d+) health per 5 sec", stat = "ITEM_MOD_HEALTH_REGENERATION_SHORT" },
        
        -- [[ 7. ATTACK POWER ]]
        { pattern = "Attack Power by (%d+)", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { pattern = "Attack Power in Cat, Bear", stat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" }, 
        { pattern = "%+(%d+) Attack Power", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        
        -- [[ 8. BASIC STATS ]]
        { pattern = "%+(%d+) Stamina", stat = "ITEM_MOD_STAMINA_SHORT" },
        { pattern = "%+(%d+) Intellect", stat = "ITEM_MOD_INTELLECT_SHORT" },
        { pattern = "%+(%d+) Spirit", stat = "ITEM_MOD_SPIRIT_SHORT" },
        { pattern = "%+(%d+) Strength", stat = "ITEM_MOD_STRENGTH_SHORT" },
        { pattern = "%+(%d+) Agility", stat = "ITEM_MOD_AGILITY_SHORT" },
        
		-- [[ 9. MISSING ENCHANTS (Expanded for "Mana +30" format) ]]
        { pattern = "%+(%d+) Health", stat = "ITEM_MOD_HEALTH_SHORT" },
        { pattern = "Health %+(%d+)", stat = "ITEM_MOD_HEALTH_SHORT" }, -- New
        
        { pattern = "%+(%d+) Mana", stat = "ITEM_MOD_MANA_SHORT" },
        { pattern = "Mana %+(%d+)", stat = "ITEM_MOD_MANA_SHORT" }, -- New
        
        { pattern = "%+(%d+) Armor", stat = "ITEM_MOD_ARMOR_SHORT" }, 
        { pattern = "Armor %+(%d+)", stat = "ITEM_MOD_ARMOR_SHORT" }, -- New
        
        { pattern = "%+(%d+) Block", stat = "ITEM_MOD_BLOCK_VALUE_SHORT" },
        
        { pattern = "%+(%d+) Damage", stat = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { pattern = "%+(%d+) Weapon Damage", stat = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" },
        { pattern = "%+(%d+) Defense", stat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { pattern = "%+(%d+) All Stats", stat = "ITEM_MOD_STATS_ALL_SHORT" },
        
        -- [[ 10. FALLBACK ]]
        { pattern = "up to (%d+)%.?$", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
    }

    for _, p in ipairs(patterns) do
        local val = text:match(p.pattern)
        if val then return p.stat, tonumber(val) end
    end
    return nil, 0
end