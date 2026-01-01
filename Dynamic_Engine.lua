local _, MSC = ... 

-- =========================================================================
-- SHARPIES GEAR JUDGE: DYNAMIC STAT ENGINE (TBC Edition)
-- =========================================================================

-- [[ 1. TALENT NAME MAPPING (TBC 2.4.3 Strings) ]] --
MSC.TalentStringMap = {
    ["DRUID"] = {
        ["MOONKIN_FORM"]    = "Moonkin Form",
        ["FORCE_OF_NATURE"] = "Force of Nature", 
        ["MANGLE"]          = "Mangle",          
        ["TREE_OF_LIFE"]    = "Tree of Life",    
        ["NATURES_GRACE"]   = "Nature's Grace",
        ["HEART_WILD"]      = "Heart of the Wild",
        ["LIVING_SPIRIT"]   = "Living Spirit",   
        ["DREAMSTATE"]      = "Dreamstate",      
        ["MOONGLOW"]        = "Moonglow",
        ["NATURES_SWIFTNESS"] = "Nature's Swiftness",
        ["FERAL_INSTINCT"]  = "Feral Instinct",
        ["THICK_HIDE"]      = "Thick Hide",
    },
    ["HUNTER"] = {
        ["BESTIAL_WRATH"]   = "Bestial Wrath",
        ["BEAST_WITHIN"]    = "The Beast Within", 
        ["TRUESHOT_AURA"]   = "Trueshot Aura",
        ["SILENCING_SHOT"]  = "Silencing Shot",   
        ["SCATTER_SHOT"]    = "Scatter Shot",     
        ["WYVERN_STING"]    = "Wyvern Sting",
        ["READYNESS"]       = "Readiness",        
        ["EXPOSE_WEAKNESS"] = "Expose Weakness",  
        ["CAREFUL_AIM"]     = "Careful Aim",      
        ["SURVIVAL_INST"]   = "Survival Instincts",
    },
    ["MAGE"] = {
        ["ARCANE_POWER"]    = "Arcane Power",
        ["SLOW"]            = "Slow",             
        ["COMBUSTION"]      = "Combustion",
        ["DRAGONS_BREATH"]  = "Dragon's Breath",  
        ["ICE_BARRIER"]     = "Ice Barrier",
        ["SUMMON_WELE"]     = "Summon Water Elemental", 
        ["WINTERS_CHILL"]   = "Winter's Chill",   
        ["IMP_BLIZZARD"]    = "Improved Blizzard", -- Farming Key
        ["ARCANE_MIND"]     = "Arcane Mind",
        ["MOLTEN_ARMOR"]    = "Molten Armor",
        ["ICY_VEINS"]       = "Icy Veins",
    },
    ["PALADIN"] = {
        ["HOLY_SHOCK"]      = "Holy Shock",
        ["DIVINE_ILLUM"]    = "Divine Illumination", 
        ["HOLY_SHIELD"]     = "Holy Shield",
        ["AVENGERS_SHIELD"] = "Avenger's Shield",    
        ["REPENTANCE"]      = "Repentance",
        ["CRUSADER_STRIKE"] = "Crusader Strike",     
        ["SANCTITY_AURA"]   = "Sanctity Aura",       
        ["DIVINE_STR"]      = "Divine Strength",
        ["DIVINE_INT"]      = "Divine Intellect",
        ["COMBAT_EXPERTISE"]= "Combat Expertise",    
    },
    ["PRIEST"] = {
        ["POWER_INFUSION"]  = "Power Infusion",
        ["PAIN_SUPP"]       = "Pain Suppression",    
        ["SPIRIT_GUIDANCE"] = "Spiritual Guidance",
        ["CIRCLE_HEALING"]  = "Circle of Healing",  
        ["SEARING_LIGHT"]   = "Searing Light",       
        ["SPIRIT_OF_REDEMPTION"] = "Spirit of Redemption", 
        ["SHADOWFORM"]      = "Shadowform",
        ["VAMPIRIC_TOUCH"]  = "Vampiric Touch",      
        ["ENLIGHTENMENT"]   = "Enlightenment",       
    },
    ["ROGUE"] = {
        ["MUTILATE"]        = "Mutilate",            
        ["ADRENALINE_RUSH"] = "Adrenaline Rush",
        ["SURPRISE_ATTACK"] = "Surprise Attack",    
        ["COMBAT_POTENCY"]  = "Combat Potency",      
        ["HEMORRHAGE"]      = "Hemorrhage",
        ["SHADOWSTEP"]      = "Shadowstep",          
        ["CHEAT_DEATH"]     = "Cheat Death",         
        ["VITALITY"]        = "Vitality",            
        ["SINISTER_CALLING"]= "Sinister Calling",    
    },
    ["SHAMAN"] = {
        ["ELEMENTAL_MASTERY"] = "Elemental Mastery",
        ["TOTEM_OF_WRATH"]    = "Totem of Wrath",    
        ["LIGHTNING_MASTERY"] = "Lightning Mastery",
        ["STORMSTRIKE"]       = "Stormstrike",
        ["SHAMANISTIC_RAGE"]  = "Shamanistic Rage", 
        ["MANA_TIDE"]         = "Mana Tide Totem",
        ["EARTH_SHIELD"]      = "Earth Shield",      
        ["NATURE_GUIDANCE"]   = "Nature's Guidance",
        ["ANCESTRAL_KNOW"]    = "Ancestral Knowledge",
        ["MENTAL_QUICKNESS"]  = "Mental Quickness",
        ["SHIELD_SPEC"]       = "Shield Specialization",
        ["ANTICIPATION"]      = "Anticipation",     
    },
    ["WARLOCK"] = {
        ["DARK_PACT"]         = "Dark Pact",
        ["UNSTABLE_AFF"]      = "Unstable Affliction", 
        ["SIPHON_LIFE"]       = "Siphon Life",         
        ["SOUL_LINK"]         = "Soul Link",           
        ["SUMMON_FELGUARD"]   = "Summon Felguard",     
        ["CONFLAGRATE"]       = "Conflagrate",
        ["RUIN"]              = "Ruin",                
        ["SHADOWFURY"]        = "Shadowfury",          
        ["DEMONIC_EMBRACE"]   = "Demonic Embrace",
        ["FEL_INTELLECT"]     = "Fel Intellect",
    },
    ["WARRIOR"] = {
        ["MORTAL_STRIKE"]    = "Mortal Strike",
        ["ENDLESS_RAGE"]     = "Endless Rage",       
        ["BLOOD_FRENZY"]     = "Blood Frenzy",       
        ["SECOND_WIND"]      = "Second Wind",        
        ["BLOODTHIRST"]      = "Bloodthirst",
        ["RAMPAGE"]          = "Rampage",            
        ["SHIELD_SLAM"]      = "Shield Slam",
        ["DEVASTATE"]        = "Devastate",          
        ["VITALITY"]         = "Vitality",           
    },
}

-- =========================================================================
-- 2. SCANNER LOGIC
-- =========================================================================

MSC.TalentCache = {}
MSC.TalentCacheLoaded = false

function MSC:BuildTalentCache()
    MSC.TalentCache = {}
    local tabs = GetNumTalentTabs() or 0
    for t = 1, tabs do
        local num = GetNumTalents(t) or 0
        for i = 1, num do
            local name, _, _, _, rank = GetTalentInfo(t, i)
            if name then MSC.TalentCache[name] = rank end
        end
    end
    MSC.TalentCacheLoaded = true
end

function MSC:GetTalentRank(talentKey)
    local _, class = UnitClass("player")
    -- Only build cache if empty
    if not next(MSC.TalentCache) then self:BuildTalentCache() end 
    
    if not self.TalentStringMap[class] then return 0 end
    local englishName = self.TalentStringMap[class][talentKey]
    if not englishName then return 0 end
    return MSC.TalentCache[englishName] or 0
end

-- =========================================================================
-- 3. SYSTEM B: ENDGAME DETECTORS (TBC Updated)
-- =========================================================================

function MSC:GetDruidRaidSpec()
    if self:GetTalentRank("TREE_OF_LIFE") > 0 then return "RESTO_TREE" end
    if self:GetTalentRank("DREAMSTATE") > 0 and self:GetTalentRank("MOONKIN_FORM") == 0 then return "DREAMSTATE" end
    if self:GetTalentRank("MOONKIN_FORM") > 0 or self:GetTalentRank("FORCE_OF_NATURE") > 0 then return "BALANCE_PVE" end
    if self:GetTalentRank("MOONGLOW") > 0 and self:GetTalentRank("NATURES_SWIFTNESS") > 0 then return "MOONGLOW" end
    if self:GetTalentRank("MANGLE") > 0 or self:GetTalentRank("FERAL_INSTINCT") > 0 then
        if self:GetTalentRank("THICK_HIDE") >= 3 then return "FERAL_BEAR" end
        return "FERAL_CAT"
    end
    if self:GetTalentRank("NATURES_SWIFTNESS") > 0 then return "RESTO_PVP" end
    return "FERAL_CAT"
end

function MSC:GetHunterRaidSpec()
    if self:GetTalentRank("BEAST_WITHIN") > 0 or self:GetTalentRank("BESTIAL_WRATH") > 0 then return "RAID_BM" end
    if self:GetTalentRank("EXPOSE_WEAKNESS") > 0 or self:GetTalentRank("WYVERN_STING") > 0 then return "RAID_SURV" end
    if self:GetTalentRank("TRUESHOT_AURA") > 0 or self:GetTalentRank("SILENCING_SHOT") > 0 then
        if self:GetTalentRank("SURVIVAL_INST") > 0 then return "PVP_MM" end
        return "RAID_MM"
    end
    return "RAID_BM" 
end

function MSC:GetPaladinRaidSpec()
    if self:GetTalentRank("AVENGERS_SHIELD") > 0 or self:GetTalentRank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
    if self:GetTalentRank("CRUSADER_STRIKE") > 0 or self:GetTalentRank("REPENTANCE") > 0 then return "RET_STANDARD" end
    if self:GetTalentRank("HOLY_SHOCK") > 0 then
        if self:GetTalentRank("SANCTITY_AURA") > 0 then return "SHOCKADIN_PVP" end
        return "HOLY_RAID"
    end
    if self:GetTalentRank("DIVINE_ILLUM") > 0 then return "HOLY_RAID" end
    return "RET_STANDARD"
end

function MSC:GetWarriorRaidSpec()
    if self:GetTalentRank("DEVASTATE") > 0 or self:GetTalentRank("SHIELD_SLAM") > 0 then return "DEEP_PROT" end
    if self:GetTalentRank("RAMPAGE") > 0 or self:GetTalentRank("BLOODTHIRST") > 0 then return "FURY_DW" end
    if self:GetTalentRank("MORTAL_STRIKE") > 0 then
        if self:GetTalentRank("BLOOD_FRENZY") > 0 then return "ARMS_PVE" end
        return "ARMS_PVP"
    end
    return "FURY_DW"
end

function MSC:GetPriestRaidSpec()
    if self:GetTalentRank("VAMPIRIC_TOUCH") > 0 or self:GetTalentRank("SHADOWFORM") > 0 then return "SHADOW_PVE" end
    if self:GetTalentRank("CIRCLE_HEALING") > 0 or self:GetTalentRank("SPIRIT_OF_REDEMPTION") > 0 then return "HOLY_DEEP" end
    if self:GetTalentRank("SEARING_LIGHT") > 0 then return "SMITE_DPS" end
    if self:GetTalentRank("PAIN_SUPP") > 0 or self:GetTalentRank("POWER_INFUSION") > 0 then return "DISC_SUPPORT" end
    return "HOLY_DEEP"
end

function MSC:GetRogueRaidSpec()
    if self:GetTalentRank("SHADOWSTEP") > 0 or self:GetTalentRank("CHEAT_DEATH") > 0 then return "PVP_SUBTLETY" end
    if self:GetTalentRank("HEMORRHAGE") > 0 and self:GetTalentRank("ADRENALINE_RUSH") == 0 then return "PVP_SUBTLETY" end
    if self:GetTalentRank("MUTILATE") > 0 then return "RAID_MUTILATE" end
    if self:GetTalentRank("ADRENALINE_RUSH") > 0 or self:GetTalentRank("COMBAT_POTENCY") > 0 then return "RAID_COMBAT" end
    return "RAID_COMBAT"
end

function MSC:GetMageRaidSpec()
    if self:GetTalentRank("DRAGONS_BREATH") > 0 or self:GetTalentRank("COMBUSTION") > 0 then return "FIRE_RAID" end
    if self:GetTalentRank("SLOW") > 0 or self:GetTalentRank("ARCANE_POWER") > 0 then return "ARCANE_RAID" end
    if self:GetTalentRank("SUMMON_WELE") > 0 or self:GetTalentRank("ICE_BARRIER") > 0 then
        if self:GetTalentRank("IMP_BLIZZARD") > 0 and self:GetTalentRank("WINTERS_CHILL") == 0 then return "FROST_AOE" end
        if self:GetTalentRank("WINTERS_CHILL") > 0 then return "FROST_PVE" end
        return "FROST_PVP"
    end
    return "FROST_PVP"
end

function MSC:GetWarlockRaidSpec()
    if self:GetTalentRank("SUMMON_FELGUARD") > 0 then return "DEMO_PVE" end
    if self:GetTalentRank("SIPHON_LIFE") > 0 and self:GetTalentRank("SOUL_LINK") > 0 then return "PVP_SL_SL" end
    if self:GetTalentRank("UNSTABLE_AFF") > 0 or self:GetTalentRank("DARK_PACT") > 0 then return "RAID_AFFLICTION" end
    if self:GetTalentRank("SHADOWFURY") > 0 or self:GetTalentRank("CONFLAGRATE") > 0 or self:GetTalentRank("RUIN") > 0 then return "RAID_DESTRUCTION" end
    return "RAID_DESTRUCTION"
end

function MSC:GetShamanRaidSpec()
    if self:GetTalentRank("TOTEM_OF_WRATH") > 0 then return "ELE_PVE" end
    if self:GetTalentRank("ELEMENTAL_MASTERY") > 0 then return "ELE_PVP" end
    if self:GetTalentRank("LIGHTNING_MASTERY") > 0 then return "ELE_PVE" end
    if self:GetTalentRank("SHAMANISTIC_RAGE") > 0 or self:GetTalentRank("STORMSTRIKE") > 0 then return "ENH_PVE" end
    if self:GetTalentRank("EARTH_SHIELD") > 0 or self:GetTalentRank("MANA_TIDE") > 0 then return "RESTO_PVE" end
    if self:GetTalentRank("SHIELD_SPEC") > 0 and self:GetTalentRank("ANTICIPATION") > 0 then return "SHAMAN_TANK" end
    return "RESTO_PVE"
end

-- MAIN ROUTER FOR SYSTEM B
function MSC:GetEndgameSpec(class)
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then return MSC.ManualSpec end
    if class == "WARRIOR" then return self:GetWarriorRaidSpec() end
    if class == "PALADIN" then return self:GetPaladinRaidSpec() end
    if class == "PRIEST"  then return self:GetPriestRaidSpec() end
    if class == "ROGUE"   then return self:GetRogueRaidSpec() end
    if class == "MAGE"    then return self:GetMageRaidSpec() end
    if class == "WARLOCK" then return self:GetWarlockRaidSpec() end
    if class == "HUNTER"  then return self:GetHunterRaidSpec() end
    if class == "DRUID"   then return self:GetDruidRaidSpec() end
    if class == "SHAMAN"  then return self:GetShamanRaidSpec() end
    return "Default"
end

-- =========================================================================
-- 4. DYNAMIC SCALERS (TBC Adjusted)
-- =========================================================================

function MSC:ApplyTalentScalers(class, w, spec)
    
    -- [[ TBC: PALADIN ]]
    if class == "PALADIN" then
        local rStr = self:GetTalentRank("DIVINE_STR")
        if rStr > 0 and w["ITEM_MOD_STRENGTH_SHORT"] then 
            w["ITEM_MOD_STRENGTH_SHORT"] = w["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) 
        end
        local rInt = self:GetTalentRank("DIVINE_INT")
        if rInt > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then 
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rInt * 0.02)) 
        end
        local rStam = self:GetTalentRank("COMBAT_EXPERTISE")
        if rStam > 0 and w["ITEM_MOD_STAMINA_SHORT"] then
            w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rStam * 0.02))
        end

    -- [[ TBC: HUNTER ]]
    elseif class == "HUNTER" then
        local rExp = self:GetTalentRank("EXPOSE_WEAKNESS")
        if rExp > 0 and w["ITEM_MOD_AGILITY_SHORT"] then
            w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * 1.2 
        end

    -- [[ TBC: DRUID ]]
    elseif class == "DRUID" then
        local rHotW = self:GetTalentRank("HEART_WILD")
        if rHotW > 0 then
            if w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.04)) end
        end
        local rLiv = self:GetTalentRank("LIVING_SPIRIT")
        if rLiv > 0 and w["ITEM_MOD_SPIRIT_SHORT"] then
            w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rLiv * 0.03))
        end

    -- [[ TBC: WARLOCK ]]
    elseif class == "WARLOCK" then
        local rEmb = self:GetTalentRank("DEMONIC_EMBRACE")
        if rEmb > 0 and w["ITEM_MOD_STAMINA_SHORT"] then
            w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03))
        end
        local rFel = self:GetTalentRank("FEL_INTELLECT")
        if rFel > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
             w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rFel * 0.01))
        end

    -- [[ TBC: MAGE ]]
    elseif class == "MAGE" then
        local rMind = self:GetTalentRank("ARCANE_MIND")
        if rMind > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then 
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rMind * 0.03)) 
        end

    -- [[ TBC: SHAMAN ]]
    elseif class == "SHAMAN" then
        local rAncestral = self:GetTalentRank("ANCESTRAL_KNOW")
        if rAncestral > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAncestral * 0.01))
        end
        local rMent = self:GetTalentRank("MENTAL_QUICKNESS")
        if rMent > 0 and w["ITEM_MOD_ATTACK_POWER_SHORT"] then
            w["ITEM_MOD_ATTACK_POWER_SHORT"] = w["ITEM_MOD_ATTACK_POWER_SHORT"] * 1.1
        end

    -- [[ TBC: PRIEST ]]
    elseif class == "PRIEST" then
        local rEnlight = self:GetTalentRank("ENLIGHTENMENT")
        if rEnlight > 0 then
            if w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rEnlight * 0.01)) end
            if w["ITEM_MOD_SPIRIT_SHORT"] then w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rEnlight * 0.01)) end
            if w["ITEM_MOD_STAMINA_SHORT"] then w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEnlight * 0.01)) end
        end

    -- [[ TBC: ROGUE ]]
    elseif class == "ROGUE" then
        local rVit = self:GetTalentRank("VITALITY")
        if rVit > 0 and w["ITEM_MOD_AGILITY_SHORT"] then
            w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * (1 + (rVit * 0.01))
        end
        local rSin = self:GetTalentRank("SINISTER_CALLING")
        if rSin > 0 and w["ITEM_MOD_AGILITY_SHORT"] then
            w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * (1 + (rSin * 0.03))
        end
    end

    return w
end

-- =========================================================================
-- 5. TRAFFIC CONTROLLER (The Brain)
-- =========================================================================

-- Helper to safely clone tables so we don't delete Hit from the permanent DB
function MSC:DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[MSC:DeepCopy(orig_key)] = MSC:DeepCopy(orig_value)
        end
        setmetatable(copy, MSC:DeepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- NEW: Hit Cap Logic
function MSC:ApplyHitCaps(weights, specName)
    if not weights then return weights end
    
    -- TBC Caps: ~142 rating (9%) for Melee, ~202 rating (16%) for Casters
    local hitRating = 0
    local isCaster = false
    
    -- 1. Identify Caster vs Melee based on Spec Name
    if specName:find("MAGE") or specName:find("WARLOCK") or specName:find("PRIEST") or specName:find("ELE") or specName:find("BALANCE") then
        isCaster = true
        hitRating = GetCombatRating(CR_HIT_SPELL)
    else
        local _, class = UnitClass("player")
        if class == "HUNTER" then 
            hitRating = GetCombatRating(CR_HIT_RANGED) 
        else
            hitRating = GetCombatRating(CR_HIT_MELEE)
        end
    end
    
    -- 2. Check Thresholds
    local cap = isCaster and 202 or 142
    
    -- 3. If Capped, SLASH the weight
    if hitRating >= cap then
        -- Clone first to protect database
        local safeWeights = MSC:DeepCopy(weights)
        if safeWeights["ITEM_MOD_HIT_RATING_SHORT"] then safeWeights["ITEM_MOD_HIT_RATING_SHORT"] = 0.01 end
        if safeWeights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then safeWeights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.01 end
        return safeWeights
    end

    return weights
end

function MSC:ApplyDynamicAdjustments(baseWeights)
    local w = {}
    -- If baseWeights were passed (unlikely in this flow, but safe to keep), copy them
    if baseWeights then for k,v in pairs(baseWeights) do w[k] = v end end
    
    local _, class = UnitClass("player")
    local level = UnitLevel("player")
    local specKey = "Default"
    local weightTable = MSC.WeightDB -- Default to Endgame DB

    -- [[ TRAFFIC CONTROL & MANUAL OVERRIDE ]] --
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then
        specKey = MSC.ManualSpec
        if MSC.WeightDB[class][specKey] then 
            weightTable = MSC.WeightDB
        elseif MSC.LevelingWeightDB and MSC.LevelingWeightDB[class][specKey] then 
            weightTable = MSC.LevelingWeightDB
        end
    elseif level < 70 then
        -- SYSTEM A: LEVELING ENGINE (1-69)
        if MSC.GetLevelingSpec and MSC.LevelingWeightDB then
            specKey = MSC:GetLevelingSpec(class, level)
            weightTable = MSC.LevelingWeightDB
        else
            specKey = "Leveling_1_20"
        end
    else
        -- SYSTEM B: ENDGAME ENGINE (70+)
        specKey = self:GetEndgameSpec(class)
    end

    -- [[ LOAD WEIGHTS ]] --
    if weightTable[class] and weightTable[class][specKey] then
        w = {}
        for k,v in pairs(weightTable[class][specKey]) do w[k] = v end
    end

    -- [[ DYNAMIC SCALERS ]] --
    w = self:ApplyTalentScalers(class, w, specKey)
    
    -- [[ NEW: APPLY HIT CAPS ]] --
    w = self:ApplyHitCaps(w, specKey)

    return w, specKey
end

-- Replaced the broken function with this Wrapper
function MSC.GetCurrentWeights()
    return MSC:ApplyDynamicAdjustments({})
end

-- =========================================================================
-- EVENT LISTENER
-- =========================================================================
local talentTracker = CreateFrame("Frame")
talentTracker:RegisterEvent("CHARACTER_POINTS_CHANGED")
talentTracker:RegisterEvent("PLAYER_TALENT_UPDATE")
talentTracker:SetScript("OnEvent", function(self, event)
    MSC.TalentCacheLoaded = false
    if MyStatCompareFrame and MyStatCompareFrame:IsShown() and SGJ_SpecDropDown then
        local _, class = UnitClass("player")
        local _, detectedKey = MSC.GetCurrentWeights()
        local displayName = detectedKey
        if MSC.PrettyNames and MSC.PrettyNames[class] and MSC.PrettyNames[class][detectedKey] then
            displayName = MSC.PrettyNames[class][detectedKey]
        end
        UIDropDownMenu_SetText(SGJ_SpecDropDown, "Auto: " .. displayName)
    end
end)