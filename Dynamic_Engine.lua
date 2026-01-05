local _, MSC = ... 

-- =========================================================================
-- DYNAMIC STAT ENGINE (Optimized - Caching Added)
-- =========================================================================

-- =========================================================================
-- [[ 1. TALENT NAME MAPPING ]] --
-- =========================================================================

MSC.TalentStringMap = {
    ["DRUID"] = { 
		["MOONKIN_FORM"]="Moonkin Form", 
		["FORCE_OF_NATURE"]="Force of Nature", 
		["MANGLE"]="Mangle", 
		["TREE_OF_LIFE"]="Tree of Life", 
		["NATURES_GRACE"]="Nature's Grace", 
		["HEART_WILD"]="Heart of the Wild", 
		["LIVING_SPIRIT"]="Living Spirit", 
		["DREAMSTATE"]="Dreamstate", 
		["MOONGLOW"]="Moonglow", 
		["NATURES_SWIFTNESS"]="Nature's Swiftness", 
		["FERAL_INSTINCT"]="Feral Instinct",
		["BALANCE_OF_POWER"] = "Balance of Power",	
		["THICK_HIDE"]="Thick Hide" 
	},
	
    ["HUNTER"] = { 
		["SUREFOOTED"] = "Surefooted",
		["BESTIAL_WRATH"]="Bestial Wrath", 
		["BEAST_WITHIN"]="The Beast Within", 
		["TRUESHOT_AURA"]="Trueshot Aura", 
		["SILENCING_SHOT"]="Silencing Shot", 
		["SCATTER_SHOT"]="Scatter Shot", 
		["WYVERN_STING"]="Wyvern Sting", 
		["READYNESS"]="Readiness", 
		["EXPOSE_WEAKNESS"]="Expose Weakness", 
		["CAREFUL_AIM"]="Careful Aim", 
		["SURVIVAL_INST"]="Survival Instincts" 
	},
	
    ["MAGE"] = { 
		["ELEMENTAL_PRECISION"] = "Elemental Precision",
		["ARCANE_POWER"]="Arcane Power", 
		["SLOW"]="Slow", ["COMBUSTION"]="Combustion", 
		["DRAGONS_BREATH"]="Dragon's Breath", 
		["ICE_BARRIER"]="Ice Barrier", 
		["SUMMON_WELE"]="Summon Water Elemental", 
		["WINTERS_CHILL"]="Winter's Chill", 
		["IMP_BLIZZARD"]="Improved Blizzard", 
		["ARCANE_MIND"]="Arcane Mind", 
		["MOLTEN_ARMOR"]="Molten Armor", 
		["ICY_VEINS"]="Icy Veins" 
	},
	
    ["PALADIN"] = { 
		["PRECISION"] = "Precision",
		["HOLY_SHOCK"]="Holy Shock", 
		["DIVINE_ILLUM"]="Divine Illumination", 
		["HOLY_SHIELD"]="Holy Shield", 
		["AVENGERS_SHIELD"]="Avenger's Shield", 
		["REPENTANCE"]="Repentance", 
		["CRUSADER_STRIKE"]="Crusader Strike", 
		["SANCTITY_AURA"]="Sanctity Aura", 
		["DIVINE_STR"]="Divine Strength", 
		["DIVINE_INT"]="Divine Intellect", 
		["COMBAT_EXPERTISE"]="Combat Expertise" 
	},
	
    ["PRIEST"] = { 
		["POWER_INFUSION"]="Power Infusion", 
		["PAIN_SUPP"]="Pain Suppression", 
		["SPIRIT_GUIDANCE"]="Spiritual Guidance", 
		["CIRCLE_HEALING"]="Circle of Healing", 
		["SEARING_LIGHT"]="Searing Light", 
		["SPIRIT_OF_REDEMPTION"]="Spirit of Redemption", 
		["SHADOWFORM"]="Shadowform", 
		["VAMPIRIC_TOUCH"]="Vampiric Touch",
		["ENLIGHTENMENT"]="Enlightenment" 
	},
	
    ["ROGUE"] = {
		["PRECISION"] = "Precision",	
        ["MUTILATE"]="Mutilate", 
        ["ADRENALINE_RUSH"]="Adrenaline Rush", 
        ["SURPRISE_ATTACK"]="Surprise Attack", 
        ["COMBAT_POTENCY"]="Combat Potency", 
        ["HEMORRHAGE"]="Hemorrhage", 
        ["SHADOWSTEP"]="Shadowstep", 
        ["CHEAT_DEATH"]="Cheat Death", 
        ["VITALITY"]="Vitality", 
        ["SINISTER_CALLING"]="Sinister Calling",
        ["DAGGER_SPEC"] = "Dagger Specialization",
        ["FIST_SPEC"]   = "Fist Weapon Specialization",
        ["SWORD_SPEC"]  = "Sword Specialization",
        ["MACE_SPEC"]   = "Mace Specialization" 
    },
	["SHAMAN"] = { 
		["ELEMENTAL_MASTERY"]="Elemental Mastery", 
		["TOTEM_OF_WRATH"]="Totem of Wrath", 
		["LIGHTNING_MASTERY"]="Lightning Mastery", 
		["STORMSTRIKE"]="Stormstrike", 
		["SHAMANISTIC_RAGE"]="Shamanistic Rage", 
		["MANA_TIDE"]="Mana Tide Totem", 
		["EARTH_SHIELD"]="Earth Shield", 
		["NATURE_GUIDANCE"]="Nature's Guidance", 
		["ANCESTRAL_KNOW"]="Ancestral Knowledge", 
		["MENTAL_QUICKNESS"]="Mental Quickness", 
		["SHIELD_SPEC"]="Shield Specialization", 
		["ANTICIPATION"]="Anticipation" 
		},
		
	["WARLOCK"] = { 
        ["DARK_PACT"]       = "Dark Pact", 
        ["UNSTABLE_AFF"]    = "Unstable Affliction", 
        ["SIPHON_LIFE"]     = "Siphon Life", 
        ["SOUL_LINK"]       = "Soul Link", 
        ["SUMMON_FELGUARD"] = "Summon Felguard", 
        ["CONFLAGRATE"]     = "Conflagrate", 
        ["RUIN"]            = "Ruin", 
        ["SHADOWFURY"]      = "Shadowfury", 
        ["DEMONIC_EMBRACE"] = "Demonic Embrace", 
        ["FEL_INTELLECT"]   = "Fel Intellect",
        ["EMBERSTORM"]      = "Emberstorm"   
    },
	
    ["WARRIOR"] = { 
		["PRECISION"] = "Precision",
		["MORTAL_STRIKE"]	="Mortal Strike",
		["ENDLESS_RAGE"]	="Endless Rage",
		["BLOOD_FRENZY"]	="Blood Frenzy",
		["SECOND_WIND"]		="Second Wind",
		["BLOODTHIRST"]		="Bloodthirst",
		["RAMPAGE"]			="Rampage",
		["SHIELD_SLAM"]		="Shield Slam",
		["DEVASTATE"]		="Devastate",
		["VITALITY"]		="Vitality",
		["POLEAXE_SPEC"]    = "Poleaxe Specialization",
        ["SWORD_SPEC"]      = "Sword Specialization",
        ["MACE_SPEC"]       = "Mace Specialization"
	}
}

-- =========================================================================
-- 2. SCANNER LOGIC (Safe & Robust)
-- =========================================================================

MSC.TalentCache = {}
MSC.TalentCacheLoaded = false

-- =========================================================================
-- 3. WEIGHT CACHE --
-- =========================================================================
-- This stores the final calculated weights so we don't recalculate on every mouseover.
MSC.CachedWeights = nil
MSC.CachedSpecKey = nil

function MSC:BuildTalentCache()
    MSC.TalentCache = {}
    local tabs = GetNumTalentTabs() or 0
    if tabs == 0 then return end

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
    if not MSC.TalentCacheLoaded then 
        self:BuildTalentCache() 
        if not MSC.TalentCacheLoaded then return 0 end
    end
    if not self.TalentStringMap[class] then return 0 end
    local englishName = self.TalentStringMap[class][talentKey]
    if not englishName then return 0 end
    return MSC.TalentCache[englishName] or 0
end

-- [[ WEAPON SPECIALIZATION & RACIAL BONUS ]] --
function MSC:GetWeaponSpecBonus(itemLink, class, specKey)
    if not itemLink then return 0 end
    local _, _, _, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(itemLink)
    -- classID 2 = Weapon. 
    -- SubIDs: 0=Axe1H, 1=Axe2H, 2=Bow, 3=Gun, 4=Mace1H, 5=Mace2H, 6=Polearm, 7=Sword1H, 8=Sword2H, 10=Staff, 13=Fist, 15=Dagger, 18=XBow
    if classID ~= 2 then return 0 end 

    local bonus = 0
    local _, race = UnitRace("player")

    -- [[ 1. RACIAL BONUSES (Hidden Stats) ]] --
    -- HUMAN: Sword/Mace (+5 Expertise ~ 20 Rating ~ 40 Score)
    if race == "Human" and (subClassID == 7 or subClassID == 8 or subClassID == 4 or subClassID == 5) then
        bonus = bonus + 40
    end
    -- ORC: Axe (+5 Expertise ~ 40 Score)
    if race == "Orc" and (subClassID == 0 or subClassID == 1) then
        bonus = bonus + 40
    end
    -- DWARF: Gun (+1% Crit from Skill ~ 35 Score)
    if race == "Dwarf" and subClassID == 3 then
        bonus = bonus + 35
    end
    -- TROLL: Bow (+1% Crit from Skill ~ 35 Score)
    if race == "Troll" and subClassID == 2 then
        bonus = bonus + 35
    end

    -- [[ 2. CLASS TALENT BONUSES ]] --
    if class == "WARRIOR" then
        -- Poleaxe Spec (Axes & Polearms): 1% Crit per rank
        if subClassID == 0 or subClassID == 1 or subClassID == 6 then
            local rank = self:GetTalentRank("POLEAXE_SPEC")
            if rank > 0 then bonus = bonus + (rank * 35.0) end
        end
        -- Sword Spec (Swords): Extra Swing
        if subClassID == 7 or subClassID == 8 then
            local rank = self:GetTalentRank("SWORD_SPEC")
            if rank > 0 then bonus = bonus + (rank * 35.0) end
        end
        -- Mace Spec (Maces): Stun/Rage (Low PvE value)
        if subClassID == 4 or subClassID == 5 then
            local rank = self:GetTalentRank("MACE_SPEC")
            if rank > 0 then bonus = bonus + (rank * 10.0) end
        end

    elseif class == "ROGUE" then
        -- Dagger Spec: 1% Crit per rank
        if subClassID == 15 then 
            local rank = self:GetTalentRank("DAGGER_SPEC")
            if rank > 0 then bonus = bonus + (rank * 35.0) end
        end
        -- Fist Spec: 1% Crit per rank
        if subClassID == 13 then
            local rank = self:GetTalentRank("FIST_SPEC")
            if rank > 0 then bonus = bonus + (rank * 35.0) end
        end
        -- Sword Spec: Extra Swing
        if subClassID == 7 or subClassID == 8 then
            local rank = self:GetTalentRank("SWORD_SPEC")
            if rank > 0 then bonus = bonus + (rank * 35.0) end
        end
        -- Mace Spec (Rogue): Increases Expertise by 2 per rank (+Stun)
        -- 2 Skill = ~7.8 Rating. Weight ~2.0. Value ~16 per rank. + Stun Utility.
        if subClassID == 4 or subClassID == 5 then
            local rank = self:GetTalentRank("MACE_SPEC")
            if rank > 0 then bonus = bonus + (rank * 25.0) end
        end
    end
    
    return bonus
end

-- =========================================================================
-- 4. ENDGAME LEVEL DETECTORS
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
    -- 1. DEMONOLOGY (Felguard is the defining talent)
    if self:GetTalentRank("SUMMON_FELGUARD") > 0 then return "DEMO_PVE" end

    -- 2. PVP SL/SL (Siphon Life + Soul Link combo)
    if self:GetTalentRank("SIPHON_LIFE") > 0 and self:GetTalentRank("SOUL_LINK") > 0 then return "PVP_SL_SL" end

    -- 3. AFFLICTION (UA or Dark Pact)
    if self:GetTalentRank("UNSTABLE_AFF") > 0 or self:GetTalentRank("DARK_PACT") > 0 then return "RAID_AFFLICTION" end

    -- 4. DESTRUCTION FIRE (Incinerate Spec)
    -- Must have Emberstorm (faster Incinerate) or Conflagrate
    if self:GetTalentRank("EMBERSTORM") > 0 or self:GetTalentRank("CONFLAGRATE") > 0 then 
        return "DESTRUCT_FIRE" 
    end

    -- 5. DESTRUCTION SHADOW (Shadow Bolt Spec)
    -- STRICTER CHECK: Must have Ruin (Crit Bonus). 
    -- If they don't have Ruin, they aren't a Raid Destro lock.
    if self:GetTalentRank("RUIN") > 0 or self:GetTalentRank("SHADOWFURY") > 0 then
        return "DESTRUCT_SHADOW"
    end

    -- 6. FALLBACK (Leveling / Mixed / Unknown)
    -- Returns the ["Default"] block (Generic SP/Stam/Int)
    return "Default"
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
-- 5. LEVELING LOGIC (The Brain for < 70) --
-- =========================================================================

function MSC:GetLevelingSpec(class, level)
    -- 1. Determine Level Suffix
    local suffix = ""
    if level <= 20 then suffix = "_1_20"
    elseif level <= 40 then suffix = "_21_40"
    elseif level < 52 then suffix = "_41_51"
    elseif level < 60 then suffix = "_52_59" 
    else suffix = "_60_70" end

    -- 2. Determine Role Prefix
    local role = "Leveling" -- Default Fallback

    if class == "PALADIN" then
        -- Updated to match our new dynamic DB keys:
        if self:GetTalentRank("HOLY_SHIELD") > 0 or self:GetTalentRank("AVENGERS_SHIELD") > 0 then 
            role = "Leveling_PROT_AOE"
        elseif self:GetTalentRank("DIVINE_ILLUM") > 0 or self:GetTalentRank("HOLY_SHOCK") > 0 then 
            role = "Leveling_HOLY_DUNGEON"
        else 
            role = "Leveling_RET" -- Always use specific RET table (we defined 1-70)
        end 

    elseif class == "PRIEST" then
        if self:GetTalentRank("SEARING_LIGHT") > 0 then role = "Leveling_Smite"
        elseif self:GetTalentRank("CIRCLE_HEALING") > 0 or self:GetTalentRank("SPIRIT_OF_REDEMPTION") > 0 then role = "Leveling_Healer"
        else role = "Leveling" end -- Shadow

    elseif class == "WARRIOR" then
        if self:GetTalentRank("SHIELD_SLAM") > 0 or self:GetTalentRank("DEVASTATE") > 0 then role = "Leveling_Tank"
        elseif self:GetTalentRank("BLOODTHIRST") > 0 or self:GetTalentRank("RAMPAGE") > 0 then role = "Leveling_DW"
        else role = "Leveling" end -- Arms

    elseif class == "DRUID" then
        if self:GetTalentRank("MOONKIN_FORM") > 0 then role = "Leveling_Caster"
        elseif self:GetTalentRank("TREE_OF_LIFE") > 0 or self:GetTalentRank("NATURES_SWIFTNESS") > 0 then role = "Leveling_Healer"
        elseif self:GetTalentRank("THICK_HIDE") >= 3 then role = "Leveling_Bear"
        else role = "Leveling" end -- Feral Cat

    elseif class == "SHAMAN" then
        if self:GetTalentRank("SHIELD_SPEC") > 0 and self:GetTalentRank("ANTICIPATION") > 0 then role = "Leveling_Tank"
        elseif self:GetTalentRank("ELEMENTAL_MASTERY") > 0 or self:GetTalentRank("TOTEM_OF_WRATH") > 0 then role = "Leveling_Caster"
        elseif self:GetTalentRank("MANA_TIDE") > 0 or self:GetTalentRank("EARTH_SHIELD") > 0 then role = "Leveling_Healer"
        else role = "Leveling" end -- Enhancement

    elseif class == "MAGE" then
        if self:GetTalentRank("IMP_BLIZZARD") >= 2 then role = "Leveling_AoE"
        elseif self:GetTalentRank("DRAGONS_BREATH") > 0 or self:GetTalentRank("COMBUSTION") > 0 then role = "Leveling_Fire"
        else role = "Leveling" end -- Frost

    elseif class == "WARLOCK" then
        if self:GetTalentRank("CONFLAGRATE") > 0 or self:GetTalentRank("SHADOWFURY") > 0 then role = "Leveling_Fire"
        elseif self:GetTalentRank("SUMMON_FELGUARD") > 0 or self:GetTalentRank("SOUL_LINK") > 0 then role = "Leveling_Demo"
        else role = "Leveling" end -- Affliction

    elseif class == "HUNTER" then
        if self:GetTalentRank("SURVIVAL_INST") > 0 and self:GetTalentRank("WYVERN_STING") == 0 then role = "Leveling_Melee"
        else role = "Leveling" end -- Ranged

    elseif class == "ROGUE" then
        if self:GetTalentRank("MUTILATE") > 0 then role = "Leveling_Dagger"
        elseif self:GetTalentRank("HEMORRHAGE") > 0 then role = "Leveling_Hemo"
        else role = "Leveling" end -- Combat
    end

    -- 3. Construct Key (e.g., "Leveling_RET_21_40")
    local specificKey = role .. suffix
    
    -- Handle Generic "Leveling" prefix (e.g. "Leveling" + "_21_40" -> "Leveling_21_40")
    if role == "Leveling" then specificKey = "Leveling" .. suffix end

    -- 4. Safety Lookup
    if MSC.LevelingWeightDB[class] and MSC.LevelingWeightDB[class][specificKey] then 
        return specificKey
    else
        -- Fallback: If specialized key missing, try generic
        return "Leveling" .. suffix 
    end
end

-- =========================================================================
-- 6. DYNAMIC SCALERS
-- =========================================================================

function MSC:ApplyTalentScalers(class, w, spec)
    if class == "PALADIN" then
        local rStr = self:GetTalentRank("DIVINE_STR")
        if rStr > 0 and w["ITEM_MOD_STRENGTH_SHORT"] then w["ITEM_MOD_STRENGTH_SHORT"] = w["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rStr * 0.02)) end
        local rInt = self:GetTalentRank("DIVINE_INT")
        if rInt > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rInt * 0.02)) end
        local rStam = self:GetTalentRank("COMBAT_EXPERTISE")
        if rStam > 0 and w["ITEM_MOD_STAMINA_SHORT"] then w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rStam * 0.02)) end
    elseif class == "HUNTER" then
        local rExp = self:GetTalentRank("EXPOSE_WEAKNESS")
        if rExp > 0 and w["ITEM_MOD_AGILITY_SHORT"] then w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * 1.2 end
    elseif class == "DRUID" then
        local rHotW = self:GetTalentRank("HEART_WILD")
        if rHotW > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.04)) end
        local rLiv = self:GetTalentRank("LIVING_SPIRIT")
        if rLiv > 0 and w["ITEM_MOD_SPIRIT_SHORT"] then w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rLiv * 0.03)) end
    elseif class == "WARLOCK" then
        local rEmb = self:GetTalentRank("DEMONIC_EMBRACE")
        if rEmb > 0 and w["ITEM_MOD_STAMINA_SHORT"] then w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEmb * 0.03)) end
        local rFel = self:GetTalentRank("FEL_INTELLECT")
        if rFel > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rFel * 0.01)) end
    elseif class == "MAGE" then
        local rMind = self:GetTalentRank("ARCANE_MIND")
        if rMind > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rMind * 0.03)) end
    elseif class == "SHAMAN" then
        local rAncestral = self:GetTalentRank("ANCESTRAL_KNOW")
        if rAncestral > 0 and w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rAncestral * 0.01)) end
        local rMent = self:GetTalentRank("MENTAL_QUICKNESS")
        if rMent > 0 and w["ITEM_MOD_ATTACK_POWER_SHORT"] then w["ITEM_MOD_ATTACK_POWER_SHORT"] = w["ITEM_MOD_ATTACK_POWER_SHORT"] * 1.1 end
    elseif class == "PRIEST" then
        local rEnlight = self:GetTalentRank("ENLIGHTENMENT")
        if rEnlight > 0 then
            if w["ITEM_MOD_INTELLECT_SHORT"] then w["ITEM_MOD_INTELLECT_SHORT"] = w["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rEnlight * 0.01)) end
            if w["ITEM_MOD_SPIRIT_SHORT"] then w["ITEM_MOD_SPIRIT_SHORT"] = w["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rEnlight * 0.01)) end
            if w["ITEM_MOD_STAMINA_SHORT"] then w["ITEM_MOD_STAMINA_SHORT"] = w["ITEM_MOD_STAMINA_SHORT"] * (1 + (rEnlight * 0.01)) end
        end
    elseif class == "ROGUE" then
        local rVit = self:GetTalentRank("VITALITY")
        if rVit > 0 and w["ITEM_MOD_AGILITY_SHORT"] then w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * (1 + (rVit * 0.01)) end
        local rSin = self:GetTalentRank("SINISTER_CALLING")
        if rSin > 0 and w["ITEM_MOD_AGILITY_SHORT"] then w["ITEM_MOD_AGILITY_SHORT"] = w["ITEM_MOD_AGILITY_SHORT"] * (1 + (rSin * 0.03)) end
    end
    return w
end

-- =========================================================================
-- 7. TRAFFIC CONTROLLER (Safe Copy & Caching)
-- =========================================================================

function MSC:SafeCopy(orig)
    if type(orig) ~= 'table' then return orig end
    local copy = {}
    for k, v in pairs(orig) do copy[k] = v end
    return copy
end

function MSC:ApplyHitCaps(weights, specName)
    if not weights then return weights end
    
    local _, class = UnitClass("player")
    local hitRating = 0
    local isCaster = false
    
    -- 1. Determine if Caster and get current Gear Rating
    if specName:find("MAGE") or specName:find("WARLOCK") or specName:find("PRIEST") or specName:find("ELE") or specName:find("BALANCE") then
        isCaster = true
        hitRating = GetCombatRating(CR_HIT_SPELL)
    else
        if class == "HUNTER" then hitRating = GetCombatRating(CR_HIT_RANGED) 
        else hitRating = GetCombatRating(CR_HIT_MELEE) end
    end
    
    -- 2. TBC Base Caps and Conversions
    local baseCap = isCaster and 202 or 142
    local ratingPerPercent = isCaster and 12.6 or 15.8

    -- 3. Calculate "Invisible" Hit % from Talents
    local talentBonusPct = 0
    if class == "WARRIOR" or class == "ROGUE" or class == "PALADIN" then
        talentBonusPct = self:GetTalentRank("PRECISION") * 1 -- 1% per rank
    elseif class == "SHAMAN" then
        talentBonusPct = self:GetTalentRank("NATURES_GUIDANCE") * 1
        if specName:find("ENHANCE") then 
            talentBonusPct = talentBonusPct + (self:GetTalentRank("DUAL_WIELD_SPEC") * 2) 
        end
    elseif class == "HUNTER" then
        talentBonusPct = self:GetTalentRank("SUREFOOTED") * 1
    elseif class == "DRUID" and isCaster then
        talentBonusPct = self:GetTalentRank("BALANCE_OF_POWER") * 2
    elseif class == "PRIEST" and specName:find("SHADOW") then
        talentBonusPct = self:GetTalentRank("SHADOW_FOCUS") * 2
    end

    -- 4. Adjust the Cap (Subtract talent value from the required rating)
    -- If you have 5% hit from talents, your "Required Gear Rating" drops by ~79
    local adjustedCap = baseCap - (talentBonusPct * ratingPerPercent)
    local safeZone = adjustedCap + 5 -- Reduced buffer because calculation is now precise
    
    -- 5. If current gear rating is over the talent-adjusted cap, kill the weight
    if hitRating >= safeZone then
        local safeWeights = MSC:SafeCopy(weights)
        if safeWeights["ITEM_MOD_HIT_RATING_SHORT"] then safeWeights["ITEM_MOD_HIT_RATING_SHORT"] = 0.01 end
        if safeWeights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then safeWeights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 0.01 end
        return safeWeights
    end

    return weights
end

function MSC:ApplyDynamicAdjustments(baseWeights)
    local w = {}
    if baseWeights then for k,v in pairs(baseWeights) do w[k] = v end end
    
    local _, class = UnitClass("player")
    local level = UnitLevel("player")
    local specKey = "Default"
    local weightTable = MSC.WeightDB

    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then
        specKey = MSC.ManualSpec
        if MSC.WeightDB[class][specKey] then weightTable = MSC.WeightDB
        elseif MSC.LevelingWeightDB and MSC.LevelingWeightDB[class][specKey] then weightTable = MSC.LevelingWeightDB end
    elseif level < 70 then
        if MSC.GetLevelingSpec and MSC.LevelingWeightDB then
            specKey = MSC:GetLevelingSpec(class, level)
            weightTable = MSC.LevelingWeightDB
        else
            specKey = "Leveling_1_20"
        end
    else
        specKey = self:GetEndgameSpec(class)
    end

    if weightTable[class] and weightTable[class][specKey] then
        w = {}
        for k,v in pairs(weightTable[class][specKey]) do w[k] = v end
    end

    w = self:ApplyTalentScalers(class, w, specKey)
    w = self:ApplyHitCaps(w, specKey)

    return w, specKey
end

-- [[ THE MASTER WRAPPER (CACHE IMPLEMENTED) ]] --
function MSC.GetCurrentWeights()
    -- If we have a cached result, return it instantly!
    if MSC.CachedWeights then
        return MSC.CachedWeights, MSC.CachedSpecKey
    end

    -- Otherwise, do the heavy math
    local w, key = MSC:ApplyDynamicAdjustments({})
    
    -- Save the result
    MSC.CachedWeights = w
    MSC.CachedSpecKey = key
    
    return w, key
end

-- =========================================================================
-- 8. EVENT LISTENER (Cache Invalidation)
-- =========================================================================

local talentTracker = CreateFrame("Frame")
talentTracker:RegisterEvent("CHARACTER_POINTS_CHANGED")
talentTracker:RegisterEvent("PLAYER_TALENT_UPDATE")
talentTracker:RegisterEvent("PLAYER_ENTERING_WORLD")
-- [[ NEW: We must listen for Gear Changes to update Hit Rating ]] --
talentTracker:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") 
talentTracker:RegisterEvent("UNIT_INVENTORY_CHANGED")

talentTracker:SetScript("OnEvent", function(self, event, unit)
    -- Optimization: Only care about player inventory
    if event == "UNIT_INVENTORY_CHANGED" and unit ~= "player" then return end

    -- 1. Wipe Talent Cache (only on talent events)
    if event == "PLAYER_TALENT_UPDATE" or event == "CHARACTER_POINTS_CHANGED" then
        MSC.TalentCache = {} 
        MSC.TalentCacheLoaded = false
    end

    -- 2. Wipe Weight Cache (ALWAYS - forces recalculation on next mouseover)
    MSC.CachedWeights = nil
    MSC.CachedSpecKey = nil
    
    -- 3. Update Dropdown if Open
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