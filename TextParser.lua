local _, MSC = ...

function MSC.ParseTooltipLine(text)
    if not text then return nil, 0 end
    
    -- 1. SANITIZE & CLEANUP
    -- Removes color codes to make parsing easier
    text = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    
    -- 2. IGNORE TEMPORARY BUFFS
    if text:find("^Use:") or text:find("^Chance on hit:") or text:find("^Procs:") then 
        return nil, 0 
    end
    
    local patterns = {
        -- [[ TBC NEW STATS ]] --
        
        -- HASTE
        { pattern = "Increases haste rating by (%d+)", stat = "ITEM_MOD_HASTE_RATING_SHORT" },
        { pattern = "Increases your haste rating by (%d+)", stat = "ITEM_MOD_HASTE_RATING_SHORT" },
        { pattern = "Improves haste rating by (%d+)", stat = "ITEM_MOD_HASTE_RATING_SHORT" },
        
        -- SPELL HASTE
        { pattern = "Increases spell haste rating by (%d+)", stat = "ITEM_MOD_SPELL_HASTE_RATING_SHORT" },
        { pattern = "Increases your spell haste rating by (%d+)", stat = "ITEM_MOD_SPELL_HASTE_RATING_SHORT" },

        -- EXPERTISE (Reduces Dodge/Parry)
        { pattern = "Increases your expertise rating by (%d+)", stat = "ITEM_MOD_EXPERTISE_RATING_SHORT" },
        { pattern = "Increases expertise rating by (%d+)", stat = "ITEM_MOD_EXPERTISE_RATING_SHORT" },
        
        -- ARMOR PENETRATION
        { pattern = "Increases your armor penetration rating by (%d+)", stat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" },
        { pattern = "Ignores (%d+) armor", stat = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" }, -- Early TBC phrasing

        -- RESILIENCE (PvP)
        { pattern = "Increases your resilience rating by (%d+)", stat = "ITEM_MOD_RESILIENCE_RATING_SHORT" },
        { pattern = "Increases resilience rating by (%d+)", stat = "ITEM_MOD_RESILIENCE_RATING_SHORT" },

        -- FERAL ATTACK POWER (Druid Weapons)
        { pattern = "Increases attack power by (%d+) in Cat", stat = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT" },

        -- [[ STANDARD STATS (Updated for Rating Keywords) ]] --

        -- HIT
        { pattern = "Increases hit rating by (%d+)", stat = "ITEM_MOD_HIT_RATING_SHORT" }, 
        { pattern = "Increases your hit rating by (%d+)", stat = "ITEM_MOD_HIT_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Hit", stat = "ITEM_MOD_HIT_RATING_SHORT" }, -- Legacy/Vanilla
        { pattern = "Improves your chance to hit by (%d+)%%", stat = "ITEM_MOD_HIT_RATING_SHORT" }, -- Legacy

        -- SPELL HIT
        { pattern = "Increases your spell hit rating by (%d+)", stat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" },
        { pattern = "Improves your chance to hit with spells by (%d+)%%", stat = "ITEM_MOD_HIT_SPELL_RATING_SHORT" }, -- Legacy
        
        -- CRIT
        { pattern = "Increases your critical strike rating by (%d+)", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "Increases critical strike rating by (%d+)", stat = "ITEM_MOD_CRIT_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Crit", stat = "ITEM_MOD_CRIT_RATING_SHORT" }, -- Legacy
        { pattern = "Improves your chance to get a critical strike by (%d+)%%", stat = "ITEM_MOD_CRIT_RATING_SHORT" }, -- Legacy

        -- SPELL CRIT
        { pattern = "Increases your spell critical strike rating by (%d+)", stat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" },
        { pattern = "Improves your chance to get a critical strike with spells by (%d+)%%", stat = "ITEM_MOD_SPELL_CRIT_RATING_SHORT" }, -- Legacy

        -- WEAPON SPEED
        { pattern = "^Speed (%d+%.%d+)", stat = "MSC_WEAPON_SPEED" },

        -- DEFENSIVE
        { pattern = "defense rating by (%d+)", stat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { pattern = "%+(%d+) Defense", stat = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" },
        { pattern = "dodge rating by (%d+)", stat = "ITEM_MOD_DODGE_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Dodge", stat = "ITEM_MOD_DODGE_RATING_SHORT" },
        { pattern = "parry rating by (%d+)", stat = "ITEM_MOD_PARRY_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Parry", stat = "ITEM_MOD_PARRY_RATING_SHORT" },
        { pattern = "block rating by (%d+)", stat = "ITEM_MOD_BLOCK_RATING_SHORT" },
        { pattern = "%+(%d+)%%? Block", stat = "ITEM_MOD_BLOCK_RATING_SHORT" },
        { pattern = "block value of your shield by (%d+)", stat = "ITEM_MOD_BLOCK_VALUE_SHORT" },
        
        -- MANA PER 5 (MP5)
        { pattern = "Restores (%d+) mana per 5 sec", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "(%d+) mana per 5 sec", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        { pattern = "Restores (%d+) mana", stat = "ITEM_MOD_MANA_REGENERATION_SHORT" },
        
        -- ATTACK POWER
        { pattern = "Attack Power by (%d+)", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        { pattern = "%+(%d+) Attack Power", stat = "ITEM_MOD_ATTACK_POWER_SHORT" },
        
        -- SPELL POWER / HEALING
        { pattern = "damage and healing done by magical spells and effects by up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "damage done by magical spells and effects by up to (%d+)", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        { pattern = "healing done by spells and effects by up to (%d+)", stat = "ITEM_MOD_HEALING_POWER_SHORT" },
        { pattern = "%+(%d+) Healing Spells", stat = "ITEM_MOD_HEALING_POWER_SHORT" },
        { pattern = "%+(%d+) Spell Damage", stat = "ITEM_MOD_SPELL_POWER_SHORT" },
        
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
        { pattern = "Stamina by (%d+)", stat = "ITEM_MOD_STAMINA_SHORT" }
    }
    
    for _, p in ipairs(patterns) do
        local val = text:match(p.pattern)
        if val then return p.stat, tonumber(val) end
    end
    return nil, 0
end
-- =============================================================
-- SOCKET BONUS PARSER
-- =============================================================
function MSC.ParseSocketBonus(text)
    if not text then return nil, 0 end
    
    -- Look for the standard TBC label "Socket Bonus: +4 Strength"
    local bonusText = text:match("^Socket Bonus: (.*)")
    
    -- Also catch gray text (inactive) if colors are present in the raw string
    if not bonusText then
        -- Sometimes it looks like "|cff808080Socket Bonus: +4 Strength|r"
        bonusText = text:match("Socket Bonus: (.*)")
    end

    if bonusText then
        -- Clean up color codes just in case
        bonusText = bonusText:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
        
        -- Now feed this clean string (e.g., "+4 Strength") back into our main parser
        -- to figure out WHICH stat it is.
        return MSC.ParseTooltipLine(bonusText)
    end
    
    return nil, 0
end