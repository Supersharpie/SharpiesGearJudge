local _, MSC = ... 

-- =========================================================================
-- SHARPIES GEAR JUDGE: DYNAMIC STAT ENGINE (v1.15.8+ Compatible)
-- =========================================================================

-- [[ 1. TALENT NAME MAPPING ]] --
MSC.TalentStringMap = {
    ["DRUID"] = {
        ["MOONKIN_FORM"]    = "Moonkin Form",
        ["MOONGLOW"]        = "Moonglow",
        ["OMEN_OF_CLARITY"] = "Omen of Clarity",
        ["NATURES_GRACE"]   = "Nature's Grace",
        ["LEADER_OF_PACK"]  = "Leader of the Pack",
        ["HEART_WILD"]      = "Heart of the Wild",
        ["FELINE_SWIFT"]    = "Feline Swiftness",
        ["THICK_HIDE"]      = "Thick Hide",
        ["FUROR"]           = "Furor",
        ["SWIFTMEND"]       = "Swiftmend",
        ["NATURES_SWIFT"]   = "Nature's Swiftness",
        ["IMP_REGROWTH"]    = "Improved Regrowth",
        ["REFLECTION"]      = "Reflection",
        ["NATURAL_WEAPON"]  = "Natural Weapons",
        ["VENGEANCE"]       = "Vengeance",
    },
    ["HUNTER"] = {
        ["BESTIAL_WRATH"]   = "Bestial Wrath",
        ["UNLEASHED_FURY"]  = "Unleashed Fury",
        ["TRUESHOT_AURA"]   = "Trueshot Aura",
        ["SCATTER_SHOT"]    = "Scatter Shot",
        ["AIMED_SHOT"]      = "Aimed Shot",
        ["WYVERN_STING"]    = "Wyvern Sting",
        ["COUNTERATTACK"]   = "Counterattack",
        ["DETERRENCE"]      = "Deterrence",
        ["SUREFOOTED"]      = "Surefooted",
        ["LIGHTNING_REF"]   = "Lightning Reflexes",
        ["KILLER_INSTINCT"] = "Killer Instinct",
        ["MORTAL_SHOTS"]    = "Mortal Shots",
        ["SURVIVALIST"]     = "Survivalist",
        ["THICK_HIDE"]      = "Thick Hide",
    },
    ["MAGE"] = {
        ["ARCANE_POWER"]    = "Arcane Power",
        ["PRESENCE_OF_MIND"]= "Presence of Mind",
        ["COMBUSTION"]      = "Combustion",
        ["BLAST_WAVE"]      = "Blast Wave",
        ["PYROBLAST"]       = "Pyroblast",
        ["ICE_BARRIER"]     = "Ice Barrier",
        ["WINTERS_CHILL"]   = "Winter's Chill",
        ["IMP_BLIZZARD"]    = "Improved Blizzard",
        ["PERMAFROST"]      = "Permafrost",
        ["ARCANE_MIND"]     = "Arcane Mind",
        ["ARCANE_INSTABILITY"] = "Arcane Instability",
        ["IGNITE"]          = "Ignite",
        ["CRITICAL_MASS"]   = "Critical Mass",
        ["ICE_SHARDS"]      = "Ice Shards",
        ["ELE_PRECISION"]   = "Elemental Precision",
        ["ARCANE_FOCUS"]    = "Arcane Focus",
    },
    ["PALADIN"] = {
        ["HOLY_SHOCK"]      = "Holy Shock",
        ["ILLUMINATION"]    = "Illumination",
        ["CONSECRATION"]    = "Consecration",
        ["HOLY_SHIELD"]     = "Holy Shield",
        ["RECKONING"]       = "Reckoning",
        ["KINGS"]           = "Blessing of Kings",
        ["SANCTUARY"]       = "Blessing of Sanctuary",
        ["REPENTANCE"]      = "Repentance",
        ["VENGEANCE"]       = "Vengeance",
        ["IMP_MIGHT"]       = "Improved Blessing of Might",
        ["SEAL_COMMAND"]    = "Seal of Command",
        ["DIVINE_STR"]      = "Divine Strength",
        ["DIVINE_INT"]      = "Divine Intellect",
        ["PRECISION"]       = "Precision",
        ["REDOUBT"]         = "Redoubt",
    },
    ["PRIEST"] = {
        ["SHADOWFORM"]      = "Shadowform",
        ["POWER_INFUSION"]  = "Power Infusion",
        ["DIVINE_SPIRIT"]   = "Divine Spirit",
        ["SPIRIT_GUIDANCE"] = "Spiritual Guidance",
        ["SHADOW_WEAVING"]  = "Shadow Weaving",
        ["BLACKOUT"]        = "Blackout",
        ["WAND_SPEC"]       = "Wand Specialization",
        ["SPIRIT_TAP"]      = "Spirit Tap",
        ["SILENCE"]         = "Silence",
        ["MENTAL_STRENGTH"] = "Mental Strength",
        ["MEDITATION"]      = "Meditation",
        ["FORCE_OF_WILL"]   = "Force of Will",
        ["SHADOW_FOCUS"]    = "Shadow Focus",
    },
    ["ROGUE"] = {
        ["SEAL_FATE"]       = "Seal Fate",
        ["COLD_BLOOD"]      = "Cold Blood",
        ["ADRENALINE_RUSH"] = "Adrenaline Rush",
        ["SWORD_SPEC"]      = "Sword Specialization",
        ["DAGGER_SPEC"]     = "Dagger Specialization",
        ["MACE_SPEC"]       = "Mace Specialization",
        ["RIPOSTE"]         = "Riposte",
        ["HEMORRHAGE"]      = "Hemorrhage",
        ["PREPARATION"]     = "Preparation",
        ["GHOSTLY_STRIKE"]  = "Ghostly Strike",
        ["LETHALITY"]       = "Lethality",
        ["PRECISION"]       = "Precision",
        ["WEAP_EXPERTISE"]  = "Weapon Expertise",
        ["OPPORTUNITY"]     = "Opportunity",
    },
    ["SHAMAN"] = {
        ["ELEMENTAL_MASTERY"] = "Elemental Mastery",
        ["STORMSTRIKE"]       = "Stormstrike",
        ["MANA_TIDE"]         = "Mana Tide Totem",
        ["NATURES_SWIFTNESS"] = "Nature's Swiftness",
        ["LIGHTNING_MASTERY"] = "Lightning Mastery",
        ["FLURRY"]            = "Flurry",
        ["ENHANCING_TOTEMS"]  = "Enhancing Totems",
        ["EYE_OF_STORM"]      = "Eye of the Storm",
        ["ANCESTRAL_KNOW"]    = "Ancestral Knowledge",
        ["NATURE_GUIDANCE"]   = "Nature's Guidance",
        ["THUNDERING"]        = "Thundering Strikes",
        ["TIDAL_MASTERY"]     = "Tidal Mastery",
        ["ELEMENTAL_FURY"]    = "Elemental Fury",
    },
    ["WARLOCK"] = {
        ["DEMONIC_SACRIFICE"] = "Demonic Sacrifice",
        ["SHADOW_MASTERY"]    = "Shadow Mastery",
        ["RUIN"]              = "Ruin",
        ["SOUL_LINK"]         = "Soul Link",
        ["CONFLAGRATE"]       = "Conflagrate",
        ["FEL_CONCENTRATION"] = "Fel Concentration",
        ["NIGHTFALL"]         = "Nightfall",
        ["INTENSITY"]         = "Intensity",
        ["MASTER_DEMON"]      = "Master Demonologist",
        ["SUPPRESSION"]       = "Suppression",
        ["DEMONIC_EMBRACE"]   = "Demonic Embrace",
        ["EMBERSTORM"]        = "Emberstorm",
    },
    ["WARRIOR"] = {
        ["MORTAL_STRIKE"]    = "Mortal Strike",
        ["BLOODTHIRST"]      = "Bloodthirst",
        ["SHIELD_SLAM"]      = "Shield Slam",
        ["DEFIANCE"]         = "Defiance",
        ["IMP_SLAM"]         = "Improved Slam",
        ["DW_SPEC"]          = "Dual Wield Specialization",
        ["SWEEPING_STRIKES"] = "Sweeping Strikes",
        ["AXE_SPEC"]         = "Axe Specialization",
        ["TACTICAL_MASTERY"] = "Tactical Mastery",
        ["IMPALE"]           = "Impale",
        ["CRUELTY"]          = "Cruelty",
        ["FLURRY"]           = "Flurry",
        ["SHIELD_SPEC"]      = "Shield Specialization",
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
    -- FORCE REBUILD: Always refresh when checking for spec changes
    self:BuildTalentCache() 
    if not self.TalentStringMap[class] then return 0 end
    local englishName = self.TalentStringMap[class][talentKey]
    if not englishName then return 0 end
    return MSC.TalentCache[englishName] or 0
end

-- =========================================================================
-- 3. CLASS SPEC DETECTION (FIXED NAMES)
-- =========================================================================

function MSC:GetDruidSpec()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then return MSC.ManualSpec end
    local _, _, _, _, balPoints  = GetTalentTabInfo(1); balPoints = balPoints or 0
    local _, _, _, _, feralPoints = GetTalentTabInfo(2); feralPoints = feralPoints or 0
    local _, _, _, _, restoPoints = GetTalentTabInfo(3); restoPoints = restoPoints or 0

    if self:GetTalentRank("MOONKIN_FORM") > 0 or balPoints >= 30 then return "BALANCE_BOOMKIN" end
    if self:GetTalentRank("SWIFTMEND") > 0 or restoPoints >= 30 then return "RESTO_DEEP" end
    if self:GetTalentRank("MOONGLOW") > 0 and self:GetTalentRank("NATURES_SWIFT") > 0 then return "RESTO_MOONGLOW" end
    if self:GetTalentRank("NATURES_GRACE") > 0 and self:GetTalentRank("IMP_REGROWTH") > 0 then return "RESTO_REGROWTH" end
    if self:GetTalentRank("HEART_WILD") > 0 and self:GetTalentRank("NATURES_SWIFT") > 0 then return "HYBRID_HOTW" end
    if self:GetTalentRank("LEADER_OF_PACK") > 0 and self:GetTalentRank("FUROR") > 0 then return "FERAL_CAT_DPS" end
    if self:GetTalentRank("LEADER_OF_PACK") > 0 or feralPoints >= 30 then return "FERAL_BEAR_TANK" end
    return "LEVELING_FERAL"
end

function MSC:GetHunterSpec()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then return MSC.ManualSpec end
    local _, _, _, _, bmPoints   = GetTalentTabInfo(1); bmPoints = bmPoints or 0
    local _, _, _, _, mmPoints   = GetTalentTabInfo(2); mmPoints = mmPoints or 0
    local _, _, _, _, survPoints = GetTalentTabInfo(3); survPoints = survPoints or 0

    if self:GetTalentRank("COUNTERATTACK") > 0 then return "MELEE_NIGHTFALL" end
    if (self:GetTalentRank("TRUESHOT_AURA") > 0 and self:GetTalentRank("UNLEASHED_FURY") > 0) or mmPoints >= 30 then return "RAID_MM_STANDARD" end
    if self:GetTalentRank("TRUESHOT_AURA") > 0 and self:GetTalentRank("SUREFOOTED") > 0 then return "RAID_MM_SUREFOOTED" end
    if self:GetTalentRank("LIGHTNING_REF") == 5 and self:GetTalentRank("WYVERN_STING") > 0 then return "RAID_SURV_DEEP" end
    if self:GetTalentRank("TRUESHOT_AURA") > 0 and self:GetTalentRank("DETERRENCE") > 0 then return "PVP_MM_UTIL" end
    if (self:GetTalentRank("WYVERN_STING") > 0 and self:GetTalentRank("SUREFOOTED") > 0) or survPoints >= 30 then return "PVP_SURV_TANK" end
    if self:GetTalentRank("BESTIAL_WRATH") > 0 or bmPoints >= 30 then return "LEVELING_BM" end
    return "LEVELING_BM"
end

function MSC:GetMageSpec()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then return MSC.ManualSpec end
    local _, _, _, _, firePoints  = GetTalentTabInfo(2); firePoints = firePoints or 0
    local _, _, _, _, frostPoints = GetTalentTabInfo(3); frostPoints = frostPoints or 0

    if self:GetTalentRank("COMBUSTION") > 0 or firePoints >= 30 then return "FIRE_RAID" end
    if self:GetTalentRank("ARCANE_POWER") > 0 and self:GetTalentRank("ICE_SHARDS") > 0 then return "FROST_AP" end
    if self:GetTalentRank("WINTERS_CHILL") > 0 then return "FROST_WC" end
    if self:GetTalentRank("PRESENCE_OF_MIND") > 0 and self:GetTalentRank("PYROBLAST") > 0 then return "POM_PYRO" end
    if self:GetTalentRank("BLAST_WAVE") > 0 and self:GetTalentRank("ICE_SHARDS") > 0 then return "ELEMENTAL" end
    if self:GetTalentRank("IMP_BLIZZARD") == 3 and self:GetTalentRank("PERMAFROST") > 0 then return "FROST_AOE" end
    if self:GetTalentRank("ICE_BARRIER") > 0 or frostPoints >= 30 then return "FROST_PVP" end
    return "LEVELING_FROST"
end

function MSC:GetPaladinSpec()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then return MSC.ManualSpec end
    local _, _, _, _, holP = GetTalentTabInfo(1); holP = holP or 0
    local _, _, _, _, proP = GetTalentTabInfo(2); proP = proP or 0
    local _, _, _, _, retP = GetTalentTabInfo(3); retP = retP or 0

    if self:GetTalentRank("RECKONING") > 0 and self:GetTalentRank("VENGEANCE") > 0 then return "RECK_BOMB" end
    if self:GetTalentRank("REPENTANCE") > 0 and self:GetTalentRank("KINGS") > 0 then return "RET_UTILITY" end
    if self:GetTalentRank("REPENTANCE") > 0 or retP >= 30 then return "RET_STANDARD" end
    if self:GetTalentRank("HOLY_SHIELD") > 0 or proP >= 30 then return "PROT_DEEP" end -- FIXED: Matches Database
    if self:GetTalentRank("HOLY_SHOCK") > 0 and self:GetTalentRank("KINGS") == 0 then return "SHOCKADIN" end
    if self:GetTalentRank("ILLUMINATION") > 0 and self:GetTalentRank("KINGS") > 0 then return "HOLY_RAID" end
    if (self:GetTalentRank("ILLUMINATION") > 0 and self:GetTalentRank("IMP_MIGHT") > 0) or holP >= 30 then return "HOLY_DEEP" end
    
    -- Fallbacks (Fixed Naming)
    if holP >= 20 then return "HOLY_DEEP" end
    if proP >= 20 then return "PROT_DEEP" end
    if retP >= 20 then return "RET_STANDARD" end

    return "LEVELING"
end

function MSC:GetPriestSpec()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then return MSC.ManualSpec end
    local _, _, _, _, discPoints   = GetTalentTabInfo(1); discPoints = discPoints or 0
    local _, _, _, _, holyPoints   = GetTalentTabInfo(2); holyPoints = holyPoints or 0
    local _, _, _, _, shadowPoints = GetTalentTabInfo(3); shadowPoints = shadowPoints or 0

    if (self:GetTalentRank("SHADOWFORM") > 0 and self:GetTalentRank("SHADOW_WEAVING") > 0) or shadowPoints >= 30 then return "SHADOW_PVE" end
    if self:GetTalentRank("SHADOWFORM") > 0 and self:GetTalentRank("BLACKOUT") > 0 then return "SHADOW_PVP" end
    if self:GetTalentRank("POWER_INFUSION") > 0 and self:GetTalentRank("SHADOW_WEAVING") > 0 then return "HYBRID_POWER_WEAVING" end
    if self:GetTalentRank("POWER_INFUSION") > 0 or discPoints >= 30 then return "DISC_PI_SUPPORT" end
    if self:GetTalentRank("SPIRIT_GUIDANCE") > 0 or holyPoints >= 30 then return "HOLY_DEEP" end
    if self:GetTalentRank("WAND_SPEC") > 0 and self:GetTalentRank("SPIRIT_TAP") > 0 then return "LEVELING_WAND" end
    return "LEVELING_WAND"
end

function MSC:GetRogueSpec()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then return MSC.ManualSpec end
    local _, _, _, _, assPoints = GetTalentTabInfo(1); assPoints = assPoints or 0
    local _, _, _, _, comPoints = GetTalentTabInfo(2); comPoints = comPoints or 0
    local _, _, _, _, subPoints = GetTalentTabInfo(3); subPoints = subPoints or 0

    if (self:GetTalentRank("HEMORRHAGE") > 0 and self:GetTalentRank("PREPARATION") > 0) or subPoints >= 30 then return "PVP_HEMO" end
    if self:GetTalentRank("COLD_BLOOD") > 0 and self:GetTalentRank("PREPARATION") > 0 and self:GetTalentRank("HEMORRHAGE") == 0 then return "PVP_CB_DAGGER" end
    if self:GetTalentRank("MACE_SPEC") > 0 then return "PVP_MACE" end
    
    -- FIXED: Use RAID_ prefixes to match Database
    if self:GetTalentRank("SEAL_FATE") > 0 or assPoints >= 30 then return "RAID_SEAL_FATE" end
    if (self:GetTalentRank("ADRENALINE_RUSH") > 0 and self:GetTalentRank("SWORD_SPEC") > 0) or comPoints >= 30 then return "RAID_COMBAT_SWORDS" end
    if self:GetTalentRank("DAGGER_SPEC") > 0 then return "RAID_COMBAT_DAGGERS" end
    
    if self:GetTalentRank("RIPOSTE") > 0 then return "LEVELING_SWORDS" end
    if self:GetTalentRank("GHOSTLY_STRIKE") > 0 then return "LEVELING_SUBTLETY" end
    return "LEVELING_SWORDS"
end

function MSC:GetShamanSpec()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then return MSC.ManualSpec end
    local _, _, _, _, elePoints = GetTalentTabInfo(1); elePoints = elePoints or 0
    local _, _, _, _, enhPoints = GetTalentTabInfo(2); enhPoints = enhPoints or 0
    local _, _, _, _, restPoints = GetTalentTabInfo(3); restPoints = restPoints or 0

    if self:GetTalentRank("ELEMENTAL_MASTERY") > 0 or elePoints >= 30 then 
        if self:GetTalentRank("EYE_OF_STORM") > 0 then return "ELE_PVP" end
        return "ELE_PVE" 
    end
    if self:GetTalentRank("MANA_TIDE") > 0 or restPoints >= 30 then return "RESTO_DEEP" end
    if self:GetTalentRank("STORMSTRIKE") > 0 or enhPoints >= 30 then return "ENH_STORMSTRIKE" end
    if self:GetTalentRank("NATURES_SWIFTNESS") > 0 and self:GetTalentRank("LIGHTNING_MASTERY") > 0 then return "HYBRID_ELE_RESTO" end
    if self:GetTalentRank("NATURES_SWIFTNESS") > 0 and self:GetTalentRank("FLURRY") > 0 then return "HYBRID_ENH_RESTO" end
    if self:GetTalentRank("ENHANCING_TOTEMS") > 0 and self:GetTalentRank("TIDAL_MASTERY") > 0 then return "RESTO_TOTEM_SUPPORT" end
    if self:GetTalentRank("FLURRY") > 0 then return "LEVELING_ENH" end
    return "LEVELING_ENH"
end

function MSC:GetWarlockSpec()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then return MSC.ManualSpec end
    local _, _, _, _, affPoints  = GetTalentTabInfo(1); affPoints = affPoints or 0
    local _, _, _, _, demoPoints = GetTalentTabInfo(2); demoPoints = demoPoints or 0
    local _, _, _, _, destPoints = GetTalentTabInfo(3); destPoints = destPoints or 0

    -- FIXED: Use RAID_ prefixes to match Database
    if self:GetTalentRank("DEMONIC_SACRIFICE") > 0 and self:GetTalentRank("RUIN") > 0 or demoPoints >= 30 then return "RAID_DS_RUIN" end
    if self:GetTalentRank("SHADOW_MASTERY") > 0 and self:GetTalentRank("RUIN") > 0 or affPoints >= 30 then return "RAID_SM_RUIN" end
    
    if self:GetTalentRank("MASTER_DEMON") > 0 and self:GetTalentRank("RUIN") > 0 then return "PVE_MD_RUIN" end
    if self:GetTalentRank("SOUL_LINK") > 0 then return "PVP_SOUL_LINK" end
    if self:GetTalentRank("CONFLAGRATE") > 0 or destPoints >= 30 then return "PVP_DEEP_DESTRO" end
    if self:GetTalentRank("NIGHTFALL") > 0 and self:GetTalentRank("CONFLAGRATE") > 0 then return "PVP_NF_CONFLAG" end
    if self:GetTalentRank("FEL_CONCENTRATION") > 0 then return "LEVELING_DRAIN" end
    if self:GetTalentRank("INTENSITY") > 0 then return "LEVELING_AOE" end
    return "LEVELING_DRAIN"
end

function MSC:GetWarriorSpec()
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then return MSC.ManualSpec end
    local _, _, _, _, armsPoints = GetTalentTabInfo(1); armsPoints = armsPoints or 0
    local _, _, _, _, furyPoints = GetTalentTabInfo(2); furyPoints = furyPoints or 0
    local _, _, _, _, protPoints = GetTalentTabInfo(3); protPoints = protPoints or 0

    if self:GetTalentRank("SHIELD_SLAM") > 0 or protPoints >= 30 then return "DEEP_PROT" end
    if self:GetTalentRank("BLOODTHIRST") > 0 and self:GetTalentRank("DEFIANCE") > 0 then return "FURY_PROT" end
    if self:GetTalentRank("TACTICAL_MASTERY") > 0 and self:GetTalentRank("DEFIANCE") > 0 then return "ARMS_PROT" end
    if self:GetTalentRank("BLOODTHIRST") > 0 and self:GetTalentRank("IMP_SLAM") > 0 then return "FURY_2H" end
    if self:GetTalentRank("BLOODTHIRST") > 0 or furyPoints >= 30 then return "FURY_DW" end
    if self:GetTalentRank("MORTAL_STRIKE") > 0 or armsPoints >= 30 then return "ARMS_MS" end
    return "LEVELING_ARMS"
end

-- =========================================================================
-- 4. APPLY ADJUSTMENTS & SCALERS (THE "BRAIN")
-- =========================================================================

function MSC:ApplyDynamicAdjustments(baseWeights, playerLevel, specIndex)
    local w = {}
    for k,v in pairs(baseWeights) do w[k] = v end
    local class = select(2, UnitClass("player"))
    local spec = "Default"

    -- [[ 1. SPEC DETECTION ]]
    if class == "WARRIOR" then spec = self:GetWarriorSpec()
    elseif class == "PALADIN" then spec = self:GetPaladinSpec()
    elseif class == "HUNTER" then spec = self:GetHunterSpec()
    elseif class == "ROGUE" then spec = self:GetRogueSpec()
    elseif class == "PRIEST" then spec = self:GetPriestSpec()
    elseif class == "SHAMAN" then spec = self:GetShamanSpec()
    elseif class == "MAGE" then spec = self:GetMageSpec()
    elseif class == "WARLOCK" then spec = self:GetWarlockSpec()
    elseif class == "DRUID" then spec = self:GetDruidSpec()
    end

    -- [[ 2. LEVELING BRACKET LOGIC ]]
    if playerLevel < 60 and (spec == "LEVELING" or spec == "Default" or spec == "LEVELING_FERAL" or spec == "LEVELING_BM" or spec == "LEVELING_FROST" or spec == "LEVELING_DRAIN" or spec == "LEVELING_ENH" or spec == "LEVELING_WAND" or spec == "LEVELING_SWORDS" or spec == "LEVELING_ARMS") then
        local isDungeonRole = false
        if class == "WARRIOR" and specIndex == 3 then isDungeonRole = true end 
        if class == "PALADIN" and (specIndex == 1 or specIndex == 2) then isDungeonRole = true end 
        if class == "PRIEST" and (specIndex == 1 or specIndex == 2) then isDungeonRole = true end 
        if class == "SHAMAN" and specIndex == 3 then isDungeonRole = true end 
        if class == "DRUID" and specIndex == 3 then isDungeonRole = true end 

        if not isDungeonRole then
            if playerLevel <= 20 and MSC.WeightDB[class]["Leveling_1_20"] then 
                spec = "Leveling_1_20"
            elseif playerLevel <= 40 and MSC.WeightDB[class]["Leveling_21_40"] then 
                spec = "Leveling_21_40"
            elseif MSC.WeightDB[class]["Leveling_41_59"] then 
                spec = "Leveling_41_59"
            end
        end
    end

    -- [[ 3. LOAD FINAL WEIGHTS ]]
    if MSC.WeightDB[class] and MSC.WeightDB[class][spec] then
        w = {}; for k,v in pairs(MSC.WeightDB[class][spec]) do w[k] = v end
    end

    -- [[ 4. DYNAMIC TALENT SCALERS (Multiplies Weights based on Talents) ]]
    
    if class == "PALADIN" then
        -- Divine Strength (+10% Str)
        local rStr = self:GetTalentRank("DIVINE_STR")
        if rStr > 0 and w["ITEM_MOD_STRENGTH_SHORT"] then 
            w["ITEM_MOD_STRENGTH_SHORT"] = w["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) 
        end
        -- Divine Intellect (+10% Int)
        local rInt = self:GetTalentRank("DIVINE_INT")
        if rInt > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then 
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rInt * 0.02)) 
        end
        -- Vengeance (Crit Value Up due to proc)
        if self:GetTalentRank("VENGEANCE") > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then 
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * 1.2 
        end

    elseif class == "HUNTER" then
        -- Lightning Reflexes (+15% Agi)
        local rRef = self:GetTalentRank("LIGHTNING_REF")
        if rRef > 0 and w["ITEM_MOD_AGILITY_SHORT"] then
            w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * (1 + (rRef * 0.03))
        end
        -- Survivalist (+10% Health -> Stamina Value)
        local rSurv = self:GetTalentRank("SURVIVALIST")
        if rSurv > 0 and w["ITEM_MOD_STAMINA_SHORT"] then
            w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rSurv * 0.02))
        end
        -- Mortal Shots (+30% Crit Dmg -> Crit Value Up)
        local rMortal = self:GetTalentRank("MORTAL_SHOTS")
        if rMortal > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rMortal * 0.06)) -- Up to +30% value
        end

    elseif class == "DRUID" then
        -- Heart of the Wild (+20% Int always)
        local rHotW = self:GetTalentRank("HEART_WILD")
        if rHotW > 0 then
            if w["ITEM_MOD_INTELLECT_SHORT"] then
                w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.04))
            end
            -- Heart of the Wild (+20% Stam in Bear)
            if (spec == "FERAL_BEAR_TANK" or spec == "HYBRID_HOTW") and w["ITEM_MOD_STAMINA_SHORT"] then
                w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rHotW * 0.04))
            end
        end

    elseif class == "WARLOCK" then
        -- Demonic Embrace (+15% Stam)
        local rEmb = self:GetTalentRank("DEMONIC_EMBRACE")
        if rEmb > 0 and w["ITEM_MOD_STAMINA_SHORT"] then
            w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03))
        end
        -- Ruin (+100% Crit Dmg -> Massive Crit Value)
        if self:GetTalentRank("RUIN") > 0 and w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * 1.5
        end
        -- Emberstorm (+10% Fire Dmg)
        local rEmber = self:GetTalentRank("EMBERSTORM")
        if rEmber > 0 and w["ITEM_MOD_FIRE_DAMAGE_SHORT"] then
            w["ITEM_MOD_FIRE_DAMAGE_SHORT"] = w["ITEM_MOD_FIRE_DAMAGE_SHORT"] * (1 + (rEmber * 0.02))
        end

    elseif class == "MAGE" then
        -- Arcane Mind (+15% Int)
        local rMind = self:GetTalentRank("ARCANE_MIND")
        if rMind > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then 
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rMind * 0.03)) 
        end
        -- Ice Shards (+100% Crit Dmg) or Ignite (+40% DoT)
        if (self:GetTalentRank("ICE_SHARDS") > 0 or self:GetTalentRank("IGNITE") > 0) and w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * 1.3
        end

    elseif class == "SHAMAN" then
        -- Ancestral Knowledge (+5% Mana -> Int Value)
        local rAncestral = self:GetTalentRank("ANCESTRAL_KNOW")
        if rAncestral > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAncestral * 0.01))
        end
        -- Flurry (Crit proc -> Crit Value Up)
        if self:GetTalentRank("FLURRY") > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * 1.2
        end

    elseif class == "PRIEST" then
        -- Mental Strength (+10% Mana -> Int Value)
        local rMental = self:GetTalentRank("MENTAL_STRENGTH")
        if rMental > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rMental * 0.02))
        end
        -- Spirit Guidance (+25% Spirit to Healing)
        local rGuide = self:GetTalentRank("SPIRIT_GUIDANCE")
        if rGuide > 0 and w["ITEM_MOD_SPIRIT_SHORT"] then
            w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rGuide * 0.05))
        end

    elseif class == "ROGUE" then
        -- Lethality (+30% Crit Dmg -> Crit Value)
        local rLethal = self:GetTalentRank("LETHALITY")
        if rLethal > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rLethal * 0.05))
        end

    elseif class == "WARRIOR" then
        -- Impale (+20% Crit Dmg)
        local rImpale = self:GetTalentRank("IMPALE")
        if rImpale > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rImpale * 0.10))
        end
    end

    -- [[ 5. HIT CAP LOGIC (Restored) ]]
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
    elseif class == "SHAMAN" then
        if spec == "ELE_PVE" then hitCap = 16 end -- Elemental uses Spell Hit
        myHit = (GetHitModifier() or 0) + self:GetTalentRank("NATURE_GUIDANCE")
    else
        myHit = (GetHitModifier() or 0)
    end

    -- Cap Switch
    local hitKey = (class == "MAGE" or class == "WARLOCK" or class == "PRIEST" or (class == "SHAMAN" and spec == "ELE_PVE")) and "ITEM_MOD_HIT_SPELL_RATING_SHORT" or "ITEM_MOD_HIT_RATING_SHORT"
    
    if w[hitKey] then
        if myHit >= hitCap then
            w[hitKey] = 0.01 -- Cap reached
        elseif myHit >= (hitCap - 1) then
            w[hitKey] = w[hitKey] * 0.4 -- Soft cap
        end
    end

    return w, spec
end

function MSC.GetCurrentWeights()
    local _, class = UnitClass("player")
    local defaultW = MSC.WeightDB[class] and MSC.WeightDB[class]["Default"] or {}
    return MSC:ApplyDynamicAdjustments(defaultW)
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