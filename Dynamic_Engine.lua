local _, MSC = ... 

-- =========================================================================
-- SHARPIES GEAR JUDGE: DYNAMIC STAT ENGINE (Core & Endgame)
-- =========================================================================

-- [[ 1. TALENT NAME MAPPING (English Strings) ]] --
MSC.TalentStringMap = {
    ["DRUID"] = {
        ["MOONKIN_FORM"]    = "Moonkin Form",
        ["MOONGLOW"]        = "Moonglow",
        ["NATURES_GRACE"]   = "Nature's Grace",
        ["LEADER_OF_PACK"]  = "Leader of the Pack",
        ["HEART_WILD"]      = "Heart of the Wild",
        ["THICK_HIDE"]      = "Thick Hide",
        ["FUROR"]           = "Furor",
        ["SWIFTMEND"]       = "Swiftmend",
        ["NATURES_SWIFT"]   = "Nature's Swiftness",
        ["IMP_REGROWTH"]    = "Improved Regrowth",
        ["REFLECTION"]      = "Reflection",
    },
    ["HUNTER"] = {
        ["BESTIAL_WRATH"]   = "Bestial Wrath",
        ["UNLEASHED_FURY"]  = "Unleashed Fury",
        ["TRUESHOT_AURA"]   = "Trueshot Aura",
        ["AIMED_SHOT"]      = "Aimed Shot",
        ["WYVERN_STING"]    = "Wyvern Sting",
        ["COUNTERATTACK"]   = "Counterattack",
        ["DETERRENCE"]      = "Deterrence",
        ["SUREFOOTED"]      = "Surefooted",
        ["LIGHTNING_REF"]   = "Lightning Reflexes",
        ["MORTAL_SHOTS"]    = "Mortal Shots",
        ["SURVIVALIST"]     = "Survivalist",
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
        ["IGNITE"]          = "Ignite",
        ["ICE_SHARDS"]      = "Ice Shards",
        ["ELE_PRECISION"]   = "Elemental Precision",
        ["ARCANE_FOCUS"]    = "Arcane Focus",
    },
    ["PALADIN"] = {
        ["HOLY_SHOCK"]      = "Holy Shock",
        ["ILLUMINATION"]    = "Illumination",
        ["HOLY_SHIELD"]     = "Holy Shield",
        ["RECKONING"]       = "Reckoning",
        ["KINGS"]           = "Blessing of Kings",
        ["REPENTANCE"]      = "Repentance",
        ["VENGEANCE"]       = "Vengeance",
        ["IMP_MIGHT"]       = "Improved Blessing of Might",
        ["DIVINE_STR"]      = "Divine Strength",
        ["DIVINE_INT"]      = "Divine Intellect",
        ["PRECISION"]       = "Precision",
        ["REDOUBT"]         = "Redoubt", 
    },
    ["PRIEST"] = {
        ["SHADOWFORM"]      = "Shadowform",
        ["POWER_INFUSION"]  = "Power Infusion",
        ["SPIRIT_GUIDANCE"] = "Spiritual Guidance",
        ["SHADOW_WEAVING"]  = "Shadow Weaving",
        ["BLACKOUT"]        = "Blackout",
        ["WAND_SPEC"]       = "Wand Specialization",
        ["SPIRIT_TAP"]      = "Spirit Tap",
        ["MENTAL_STRENGTH"] = "Mental Strength",
        ["DIVINE_FURY"]     = "Divine Fury",
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
        ["LETHALITY"]       = "Lethality",
        ["PRECISION"]       = "Precision",
        ["WEAP_EXPERTISE"]  = "Weapon Expertise",
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
        ["ELEMENTAL_FURY"]    = "Elemental Fury",
        ["SHIELD_SPEC"]       = "Shield Specialization",
        ["ANTICIPATION"]      = "Anticipation",
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
        ["TACTICAL_MASTERY"] = "Tactical Mastery",
        ["IMPALE"]           = "Impale",
        ["CRUELTY"]          = "Cruelty",
        ["FLURRY"]           = "Flurry",
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
    -- Always refresh cache to ensure accuracy
    self:BuildTalentCache() 
    if not self.TalentStringMap[class] then return 0 end
    local englishName = self.TalentStringMap[class][talentKey]
    if not englishName then return 0 end
    return MSC.TalentCache[englishName] or 0
end

-- =========================================================================
-- 3. SYSTEM B: ENDGAME DETECTORS (Level 60 Only)
-- =========================================================================

function MSC:GetDruidRaidSpec()
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
    return "FERAL_CAT_DPS" 
end

function MSC:GetHunterRaidSpec()
    local _, _, _, _, mmPoints = GetTalentTabInfo(2); mmPoints = mmPoints or 0
    local _, _, _, _, survPoints = GetTalentTabInfo(3); survPoints = survPoints or 0

    if self:GetTalentRank("COUNTERATTACK") > 0 then return "MELEE_NIGHTFALL" end
    if self:GetTalentRank("TRUESHOT_AURA") > 0 and self:GetTalentRank("UNLEASHED_FURY") > 0 then return "RAID_MM_STANDARD" end
    if self:GetTalentRank("TRUESHOT_AURA") > 0 and self:GetTalentRank("SUREFOOTED") > 0 then return "RAID_MM_STARTER" end
    if self:GetTalentRank("LIGHTNING_REF") == 5 and self:GetTalentRank("WYVERN_STING") > 0 then return "RAID_SURV_DEEP" end
    if self:GetTalentRank("TRUESHOT_AURA") > 0 and self:GetTalentRank("DETERRENCE") > 0 then return "PVP_MM_UTIL" end
    if (self:GetTalentRank("WYVERN_STING") > 0 and self:GetTalentRank("SUREFOOTED") > 0) then return "PVP_SURV_TANK" end
    if mmPoints >= 30 then return "RAID_MM_STANDARD" end
    return "RAID_MM_STANDARD"
end

function MSC:GetMageRaidSpec()
    if self:GetTalentRank("COMBUSTION") > 0 then return "FIRE_RAID" end
    if self:GetTalentRank("ARCANE_POWER") > 0 and self:GetTalentRank("ICE_SHARDS") > 0 then return "FROST_AP" end
    if self:GetTalentRank("WINTERS_CHILL") > 0 then return "FROST_WC" end
    if self:GetTalentRank("PRESENCE_OF_MIND") > 0 and self:GetTalentRank("PYROBLAST") > 0 then return "POM_PYRO" end
    if self:GetTalentRank("BLAST_WAVE") > 0 and self:GetTalentRank("ICE_SHARDS") > 0 then return "ELEMENTAL" end
    if self:GetTalentRank("IMP_BLIZZARD") == 3 and self:GetTalentRank("PERMAFROST") > 0 then return "FROST_AOE" end
    if self:GetTalentRank("ICE_BARRIER") > 0 then return "FROST_PVP" end
    return "FROST_AP"
end

function MSC:GetPaladinRaidSpec()
    if self:GetTalentRank("RECKONING") > 0 and self:GetTalentRank("VENGEANCE") > 0 then return "RECK_BOMB" end
    if self:GetTalentRank("REPENTANCE") > 0 and self:GetTalentRank("KINGS") > 0 then return "RET_UTILITY" end
    if self:GetTalentRank("REPENTANCE") > 0 then return "RET_STANDARD" end
    if self:GetTalentRank("HOLY_SHIELD") > 0 then return "PROT_DEEP" end
    if self:GetTalentRank("HOLY_SHOCK") > 0 and self:GetTalentRank("KINGS") == 0 then return "SHOCKADIN" end
    if self:GetTalentRank("ILLUMINATION") > 0 and self:GetTalentRank("KINGS") > 0 then return "HOLY_RAID" end
    if self:GetTalentRank("ILLUMINATION") > 0 and self:GetTalentRank("IMP_MIGHT") > 0 then return "HOLY_DEEP" end
    return "HOLY_RAID"
end

function MSC:GetPriestRaidSpec()
    if self:GetTalentRank("SHADOWFORM") > 0 and self:GetTalentRank("SHADOW_WEAVING") > 0 then return "SHADOW_PVE" end
    if self:GetTalentRank("SHADOWFORM") > 0 and self:GetTalentRank("BLACKOUT") > 0 then return "SHADOW_PVP" end
    if self:GetTalentRank("POWER_INFUSION") > 0 and self:GetTalentRank("SHADOW_WEAVING") > 0 then return "HYBRID_POWER_WEAVING" end
    if self:GetTalentRank("POWER_INFUSION") > 0 then return "DISC_PI_SUPPORT" end
    if self:GetTalentRank("SPIRIT_GUIDANCE") > 0 then return "HOLY_DEEP" end
    return "HOLY_DEEP"
end

function MSC:GetRogueRaidSpec()
    if self:GetTalentRank("HEMORRHAGE") > 0 and self:GetTalentRank("PREPARATION") > 0 then return "PVP_HEMO" end
    if self:GetTalentRank("COLD_BLOOD") > 0 and self:GetTalentRank("PREPARATION") > 0 and self:GetTalentRank("HEMORRHAGE") == 0 then return "PVP_CB_DAGGER" end
    if self:GetTalentRank("MACE_SPEC") > 0 then return "PVP_MACE" end
    if self:GetTalentRank("SEAL_FATE") > 0 then return "RAID_SEAL_FATE" end
    if self:GetTalentRank("ADRENALINE_RUSH") > 0 and self:GetTalentRank("SWORD_SPEC") > 0 then return "RAID_COMBAT_SWORDS" end
    if self:GetTalentRank("DAGGER_SPEC") > 0 then return "RAID_COMBAT_DAGGERS" end
    return "RAID_COMBAT_SWORDS"
end

function MSC:GetShamanRaidSpec()
    if self:GetTalentRank("ELEMENTAL_MASTERY") > 0 then 
        if self:GetTalentRank("EYE_OF_STORM") > 0 then return "ELE_PVP" end
        return "ELE_PVE" 
    end
    if self:GetTalentRank("MANA_TIDE") > 0 then return "RESTO_DEEP" end
    if self:GetTalentRank("STORMSTRIKE") > 0 then return "ENH_STORMSTRIKE" end
    if self:GetTalentRank("NATURES_SWIFTNESS") > 0 and self:GetTalentRank("LIGHTNING_MASTERY") > 0 then return "HYBRID_ELE_RESTO" end
    if self:GetTalentRank("NATURES_SWIFTNESS") > 0 and self:GetTalentRank("FLURRY") > 0 then return "HYBRID_ENH_RESTO" end
    if self:GetTalentRank("ENHANCING_TOTEMS") > 0 and self:GetTalentRank("TIDAL_MASTERY") > 0 then return "RESTO_TOTEM_SUPPORT" end
    return "RESTO_DEEP"
end

function MSC:GetWarlockRaidSpec()
    if self:GetTalentRank("DEMONIC_SACRIFICE") > 0 and self:GetTalentRank("RUIN") > 0 then return "RAID_DS_RUIN" end
    if self:GetTalentRank("SHADOW_MASTERY") > 0 and self:GetTalentRank("RUIN") > 0 then return "RAID_SM_RUIN" end
    if self:GetTalentRank("MASTER_DEMON") > 0 and self:GetTalentRank("RUIN") > 0 then return "PVE_MD_RUIN" end
    if self:GetTalentRank("SOUL_LINK") > 0 then return "PVP_SOUL_LINK" end
    if self:GetTalentRank("CONFLAGRATE") > 0 then return "PVP_DEEP_DESTRO" end
    if self:GetTalentRank("NIGHTFALL") > 0 and self:GetTalentRank("CONFLAGRATE") > 0 then return "PVP_NF_CONFLAG" end
    return "RAID_DS_RUIN"
end

function MSC:GetWarriorRaidSpec()
    if self:GetTalentRank("SHIELD_SLAM") > 0 then return "DEEP_PROT" end
    if self:GetTalentRank("BLOODTHIRST") > 0 and self:GetTalentRank("DEFIANCE") > 0 then return "FURY_PROT" end
    if self:GetTalentRank("TACTICAL_MASTERY") > 0 and self:GetTalentRank("DEFIANCE") > 0 then return "ARMS_PROT" end
    if self:GetTalentRank("BLOODTHIRST") > 0 and self:GetTalentRank("IMP_SLAM") > 0 then return "FURY_2H" end
    if self:GetTalentRank("BLOODTHIRST") > 0 then return "FURY_DW" end
    if self:GetTalentRank("MORTAL_STRIKE") > 0 then return "ARMS_MS" end
    return "FURY_DW"
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
-- 4. DYNAMIC SCALERS (Applies to ALL Systems)
-- =========================================================================

function MSC:ApplyTalentScalers(class, w, spec)
    if class == "PALADIN" then
        local rStr = self:GetTalentRank("DIVINE_STR")
        if rStr > 0 and w["ITEM_MOD_STRENGTH_SHORT"] then 
            w["ITEM_MOD_STRENGTH_SHORT"] = w["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) 
        end
        local rInt = self:GetTalentRank("DIVINE_INT")
        if rInt > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then 
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rInt * 0.02)) 
        end
        if self:GetTalentRank("VENGEANCE") > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then 
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * 1.2 
        end

    elseif class == "HUNTER" then
        local rRef = self:GetTalentRank("LIGHTNING_REF")
        if rRef > 0 and w["ITEM_MOD_AGILITY_SHORT"] then
            w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * (1 + (rRef * 0.03))
        end
        local rSurv = self:GetTalentRank("SURVIVALIST")
        if rSurv > 0 and w["ITEM_MOD_STAMINA_SHORT"] then
            w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rSurv * 0.02))
        end
        local rMortal = self:GetTalentRank("MORTAL_SHOTS")
        if rMortal > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rMortal * 0.06))
        end

    elseif class == "DRUID" then
        local rHotW = self:GetTalentRank("HEART_WILD")
        if rHotW > 0 then
            if w["ITEM_MOD_INTELLECT_SHORT"] then
                w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.04))
            end
            if (spec == "FERAL_BEAR_TANK" or spec == "HYBRID_HOTW") and w["ITEM_MOD_STAMINA_SHORT"] then
                w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rHotW * 0.04))
            end
        end

    elseif class == "WARLOCK" then
        local rEmb = self:GetTalentRank("DEMONIC_EMBRACE")
        if rEmb > 0 and w["ITEM_MOD_STAMINA_SHORT"] then
            w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03))
        end
        if self:GetTalentRank("RUIN") > 0 and w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * 1.5
        end
        local rEmber = self:GetTalentRank("EMBERSTORM")
        if rEmber > 0 and w["ITEM_MOD_FIRE_DAMAGE_SHORT"] then
            w["ITEM_MOD_FIRE_DAMAGE_SHORT"] = w["ITEM_MOD_FIRE_DAMAGE_SHORT"] * (1 + (rEmber * 0.02))
        end

    elseif class == "MAGE" then
        local rMind = self:GetTalentRank("ARCANE_MIND")
        if rMind > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then 
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rMind * 0.03)) 
        end
        if (self:GetTalentRank("ICE_SHARDS") > 0 or self:GetTalentRank("IGNITE") > 0) and w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = w["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * 1.3
        end

    elseif class == "SHAMAN" then
        local rAncestral = self:GetTalentRank("ANCESTRAL_KNOW")
        if rAncestral > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAncestral * 0.01))
        end
        if self:GetTalentRank("FLURRY") > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * 1.2
        end

    elseif class == "PRIEST" then
        local rMental = self:GetTalentRank("MENTAL_STRENGTH")
        if rMental > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then
            w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rMental * 0.02))
        end
        local rGuide = self:GetTalentRank("SPIRIT_GUIDANCE")
        if rGuide > 0 and w["ITEM_MOD_SPIRIT_SHORT"] then
            w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rGuide * 0.05))
        end

    elseif class == "ROGUE" then
        local rLethal = self:GetTalentRank("LETHALITY")
        if rLethal > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rLethal * 0.05))
        end

    elseif class == "WARRIOR" then
        local rImpale = self:GetTalentRank("IMPALE")
        if rImpale > 0 and w["ITEM_MOD_CRIT_RATING_SHORT"] then
            w["ITEM_MOD_CRIT_RATING_SHORT"] = w["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rImpale * 0.10))
        end
    end

    -- [[ HIT CAP LOGIC ]]
    local myHit, hitCap = 0, 9
    
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
        if spec == "ELE_PVE" then hitCap = 16 end
        myHit = (GetHitModifier() or 0) + self:GetTalentRank("NATURE_GUIDANCE")
    else
        myHit = (GetHitModifier() or 0)
    end

    local hitKey = (class == "MAGE" or class == "WARLOCK" or class == "PRIEST" or (class == "SHAMAN" and spec == "ELE_PVE")) and "ITEM_MOD_HIT_SPELL_RATING_SHORT" or "ITEM_MOD_HIT_RATING_SHORT"
    
    if w[hitKey] then
        if myHit >= hitCap then w[hitKey] = 0.01
        elseif myHit >= (hitCap - 1) then w[hitKey] = w[hitKey] * 0.4 end
    end

    return w
end

-- =========================================================================
-- 5. TRAFFIC CONTROLLER (The Brain)
-- =========================================================================

function MSC:ApplyDynamicAdjustments(baseWeights)
    local w = {}
    for k,v in pairs(baseWeights) do w[k] = v end
    
    local _, class = UnitClass("player")
    local level = UnitLevel("player")
    local specKey = "Default"
    local weightTable = MSC.WeightDB -- Default to Endgame DB

    -- [[ TRAFFIC CONTROL & MANUAL OVERRIDE ]] --
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then
        specKey = MSC.ManualSpec
        -- Detect which DB holds the manual key to ensure we load the right weights
        if MSC.WeightDB[class][specKey] then 
            weightTable = MSC.WeightDB
        elseif MSC.LevelingWeightDB and MSC.LevelingWeightDB[class][specKey] then 
            weightTable = MSC.LevelingWeightDB
        end
    elseif level < 60 then
        -- SYSTEM A: LEVELING ENGINE
        if MSC.GetLevelingSpec and MSC.LevelingWeightDB then
            specKey = MSC:GetLevelingSpec(class, level)
            weightTable = MSC.LevelingWeightDB -- SWITCH DATABASE
        else
            specKey = "Leveling_1_20" -- Safety Fallback
        end
    else
        -- SYSTEM B: ENDGAME ENGINE
        specKey = self:GetEndgameSpec(class)
        -- weightTable remains MSC.WeightDB
    end

    -- [[ LOAD WEIGHTS ]] --
    if weightTable[class] and weightTable[class][specKey] then
        w = {}
        for k,v in pairs(weightTable[class][specKey]) do w[k] = v end
    end

    -- [[ DYNAMIC SCALERS ]] --
    w = self:ApplyTalentScalers(class, w, specKey)

    return w, specKey
end

-- [[ THE MISSING FUNCTION ]] --
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