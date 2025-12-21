local _, MSC = ... 

-- =========================================================================
-- SHARPIES GEAR JUDGE: DYNAMIC STAT ENGINE
-- =========================================================================

MSC.TalentMap = {
    ["PALADIN"] = {
        ["PRECISION"]       = {2, 15}, 
        ["DIVINE_STR"]      = {1, 8},  
        ["DIVINE_INT"]      = {1, 7},  
        ["ILLUMINATION"]    = {1, 9}, 
        ["VENGEANCE"]       = {3, 2}, 
    },
    ["MAGE"] = {
        ["ELE_PRECISION"]   = {3, 17}, 
        ["ARCANE_FOCUS"]    = {1, 3}, 
        ["ARCANE_MIND"]     = {1, 4}, 
        ["IGNITE"]          = {2, 12}, 
        ["ICE_SHARDS"]      = {3, 15},
    },
    ["DRUID"] = {
        ["HEART_WILD"]      = {2, 14}, 
        ["REFLECTION"]      = {3, 9}, 
        ["NATURAL_WEAPON"]  = {1, 13},
    },
    ["ROGUE"] = {
        ["PRECISION"]       = {2, 1}, 
        ["SEAL_FATE"]       = {1, 13}, 
        ["LETHALITY"]       = {1, 2}, 
        ["WEAP_EXPERTISE"]  = {2, 19},
    },
    ["WARRIOR"] = {
        ["CRUELTY"]         = {2, 4}, 
        ["IMPALE"]          = {1, 18}, 
        ["FLURRY"]          = {2, 3}, 
    },
    ["HUNTER"] = {
        ["SUREFOOTED"]      = {3, 8}, 
        ["LIGHTNING_REF"]   = {3, 2}, 
        ["KILLER_INSTINCT"] = {3, 11},
    },
    ["SHAMAN"] = {
        ["NATURE_GUIDANCE"] = {3, 3}, 
        ["ANCESTRAL_KNOW"]  = {2, 10}, 
        ["THUNDERING"]      = {2, 9}, 
        ["TIDAL_MASTERY"]   = {3, 12},
    },
    ["PRIEST"] = {
        ["SHADOW_FOCUS"]    = {3, 3}, 
        ["SPIRIT_GUIDANCE"] = {2, 3}, 
        ["MENTAL_STR"]      = {1, 14},
    },
    ["WARLOCK"] = {
        ["SUPPRESSION"]     = {1, 5}, 
        ["RUIN"]            = {3, 9}, 
        ["DEMONIC_EMBRACE"] = {2, 3},
    },
}

-- Helper to get talent rank
function MSC:GetTalentRank(talentKey)
    local class = select(2, UnitClass("player"))
    if not self.TalentMap[class] or not self.TalentMap[class][talentKey] then return 0 end
    local tab, index = unpack(self.TalentMap[class][talentKey])
    local _, _, _, _, rank = GetTalentInfo(tab, index)
    return rank or 0
end

-- MAIN ENGINE: Modifies the Base Weights based on Live Data
function MSC:ApplyDynamicAdjustments(baseWeights)
    -- Create a copy so we don't corrupt the database
    local w = {}
    for k,v in pairs(baseWeights) do w[k] = v end

    local class = select(2, UnitClass("player"))
    
    -- [[ 1. HIT CAP LOGIC ]] --
    local myHit, hitCap = 0, 9 -- Default 9% Melee
    
    if class == "PALADIN" or class == "ROGUE" then
        myHit = (GetHitModifier() or 0) + self:GetTalentRank("PRECISION")
    elseif class == "MAGE" then
        hitCap = 16
        local gearHit = GetSpellHitModifier() or 0
        local talHit = math.max(self:GetTalentRank("ELE_PRECISION")*2, self:GetTalentRank("ARCANE_FOCUS")*2)
        myHit = gearHit + talHit
    elseif class == "HUNTER" then
        myHit = (GetHitModifier() or 0) + self:GetTalentRank("SUREFOOTED")
    elseif class == "WARLOCK" then
        hitCap = 16
        myHit = (GetSpellHitModifier() or 0) + (self:GetTalentRank("SUPPRESSION") * 2)
    else
        -- Fallback for others using base API
        myHit = (GetHitModifier() or 0)
    end

    -- The Switch: If capped, nuke the weight
    local hitKey = (class == "MAGE" or class == "WARLOCK" or class == "PRIEST") and "ITEM_MOD_HIT_SPELL_RATING_SHORT" or "ITEM_MOD_HIT_RATING_SHORT"
    
    if w[hitKey] then
        if myHit >= hitCap then
            w[hitKey] = 0.01 -- Cap reached
        elseif myHit >= (hitCap - 1) then
            w[hitKey] = w[hitKey] * 0.4 -- Soft cap
        end
    end

    -- [[ 2. TALENT SCALING ]] --
    
    if class == "PALADIN" then
        -- Divine Strength (+10% Str)
        local rank = self:GetTalentRank("DIVINE_STR")
        if rank > 0 and w["ITEM_MOD_STRENGTH_SHORT"] then 
            w["ITEM_MOD_STRENGTH_SHORT"] = w["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rank * 0.02)) 
        end
        -- Vengeance (Crit Value Up)
        if self:GetTalentRank("VENGEANCE") > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then 
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * 1.2 
        end
    end

    if class == "DRUID" then
        -- Heart of the Wild (+20% Int/Str)
        local rank = self:GetTalentRank("HEART_WILD")
        if rank > 0 then
            local mod = 1 + (rank * 0.04)
            if w["ITEM_MOD_STRENGTH_SHORT"] then w["ITEM_MOD_STRENGTH_SHORT"] = w["ITEM_MOD_STRENGTH_SHORT"] * mod end
            if w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * mod end
        end
    end

    if class == "MAGE" then
        -- Arcane Mind (+10% Int)
        local rank = self:GetTalentRank("ARCANE_MIND")
        if rank > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rank * 0.02))
        end
    end

    if class == "PRIEST" then
        -- Spirit Guidance (Spirit -> SP)
        local rank = self:GetTalentRank("SPIRIT_GUIDANCE")
        if rank > 0 and w["ITEM_MOD_SPELL_POWER_SHORT"] then 
            -- Add 5% of SP weight to Spirit per rank
            local bonus = w["ITEM_MOD_SPELL_POWER_SHORT"] * (rank * 0.05)
            w["ITEM_MOD_SPIRIT_SHORT"] = (w["ITEM_MOD_SPIRIT_SHORT"] or 0) + bonus
        end
    end

    return w
end