local _, MSC = ...

function MSC.ParseTooltipLine(text)
    if not text then return nil, 0 end
    
    -- 1. SMART SET BONUS LOGIC
    if text:find("Set:") and not text:find("ff00ff00") then return nil, 0 end
    
    -- 2. SANITIZE
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    
    -- 3. IGNORE JUNK
    if text:find("^Use:") or text:find("^Chance on hit:") or text:find("when fighting") then return nil, 0 end
    
    local patterns = {
        -- [[ 1. SPEED ]]
        { pattern = "Speed (%d+%.%d+)", stat = "MSC_WEAPON_SPEED" },

        -- [[ 2. RANGED ATTACK POWER (New for Hunters) ]]
        -- Must come BEFORE generic Attack Power to prevent Rogues from getting credit for Hunter stats
        { pattern = "ranged attack power.-by (%d+)", stat = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" },
        { pattern = "%+(%d+) Ranged Attack Power", stat = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT" },

        -- [[ 3. SPELL POWER & HEALING (Fuzzy Matches) ]]
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
        
        -- [[ 7. ATTACK POWER (Generic) ]]
        { pattern = "Attack Power by (%d+)", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { pattern = "Attack Power in Cat, Bear", stat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" }, 
        { pattern = "%+(%d+) Attack Power", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        
        -- [[ 8. BASIC STATS ]]
        { pattern = "%+(%d+) Stamina", stat = "ITEM_MOD_STAMINA_SHORT" },
        { pattern = "%+(%d+) Intellect", stat = "ITEM_MOD_INTELLECT_SHORT" },
        { pattern = "%+(%d+) Spirit", stat = "ITEM_MOD_SPIRIT_SHORT" },
        { pattern = "%+(%d+) Strength", stat = "ITEM_MOD_STRENGTH_SHORT" },
        { pattern = "%+(%d+) Agility", stat = "ITEM_MOD_AGILITY_SHORT" },
        
        -- [[ 9. FALLBACK ]]
        { pattern = "up to (%d+)%.?$", stat = "ITEM_MOD_SPELL_POWER_SHORT" }, 
    }

    for _, p in ipairs(patterns) do
        local val = text:match(p.pattern)
        if val then return p.stat, tonumber(val) end
    end
    return nil, 0
end