local _, MSC = ...

-- =============================================================
-- Raid / World Buff Assumption Engine (TBC)
-- =============================================================

MSC.BuffEngine = MSC.BuffEngine or {}
local BE = MSC.BuffEngine

local pairs, ipairs = pairs, ipairs
local math_max, math_min = math.max, math.min
local wipe = wipe or table.wipe
local UnitRace = UnitRace
local UnitLevel = UnitLevel
local GetCombatRating = GetCombatRating

-- -------------------------------------------------------------
-- Preset toggle tables (buff id -> default on)
-- -------------------------------------------------------------

local RAID_PRESETS = {
    off = {},
    full25 = {
        TOTEM_OF_WRATH = true, IMPROVED_FAERIE_FIRE = true, HEROIC_PRESENCE = true,
        MOONKIN_AURA = true, LEADER_OF_THE_PACK = true, BLESSING_OF_KINGS = true,
        MARK_OF_THE_WILD = true, TRUESHOT_AURA = true, STRENGTH_OF_EARTH = true,
        GRACE_OF_AIR = true,
    },
    minimal10 = {
        IMPROVED_FAERIE_FIRE = true, HEROIC_PRESENCE = true, BLESSING_OF_KINGS = true,
        TOTEM_OF_WRATH = true,
    },
}

local WORLD_PRESETS = {
    off = {},
    full = {
        DRAGONSLAYER = true, FACTION_HEAD = true, SPIRIT_OF_ZANDALAR = true,
        SONGFLOWER = true, FENGUS = true, MOLDAR = true, SLIPKIK = true,
    },
    dmTribute = { FENGUS = true, MOLDAR = true, SLIPKIK = true },
}

-- -------------------------------------------------------------
-- Spec role resolution
-- -------------------------------------------------------------

function BE:GetSpecRole(specKey)
    if not specKey then return "all" end
    local s = tostring(specKey):upper()
    if s:find("PVP") then return "pvp" end
    if s:find("BALANCE") or s:find("CASTER") then return "caster" end
    if s:find("ELE") or s:find("ELEMENTAL") then return "caster" end
    if s:find("SHADOW") or s:find("DESTRO") or s:find("AFFL") then return "caster" end
    if s:find("ARCANE") or s:find("FROST") or s:find("FIRE") and s:find("MAGE") == nil then
        if s:find("MAGE") or s == "FROST" or s == "FIRE" or s == "ARCANE" then return "caster" end
    end
    if s:find("MAGE") or s:find("WARLOCK") or s:find("PRIEST") or s:find("HOLY") or s:find("DISC") then
        if not s:find("PALADIN") then return "caster" end
    end
    if s:find("RESTO") or s:find("HEAL") or s:find("TREE") then return "healer" end
    if s:find("PROT") or s:find("BEAR") or s:find("TANK") then return "tank" end
    if s:find("HUNT") then return "hunter" end
    if s:find("ENH") then return "enhancement" end
    if s:find("FERAL") or s:find("CAT") or s:find("ROGUE") or s:find("FURY") or s:find("ARMS") or s:find("RET") or s:find("COMBAT") or s:find("MUTI") then
        return "melee"
    end
    if s:find("WARRIOR") or s:find("PALADIN") or s:find("SHAMAN") then return "melee" end
    return "all"
end

function BE:RoleMatches(roles, specKey)
    if not roles then return true end
    local role = self:GetSpecRole(specKey)
    for _, r in ipairs(roles) do
        if r == "all" or r == role then return true end
        if r == "physical" and (role == "melee" or role == "hunter" or role == "enhancement") then return true end
        if r == "caster" and role == "caster" then return true end
        if r == "dps" and role ~= "healer" and role ~= "tank" then return true end
    end
    return false
end

function BE:IsPlayerDraenei()
    local _, race = UnitRace("player")
    return race == "Draenei"
end

function BE:GetPlayerFaction()
    local faction = UnitFactionGroup("player")
    return faction -- "Alliance" or "Horde"
end

-- -------------------------------------------------------------
-- Settings helpers
-- -------------------------------------------------------------

function BE:InitSettings()
    if not SGJ_Settings then return end
    if SGJ_Settings.AssumeRaidBuffs == nil then SGJ_Settings.AssumeRaidBuffs = false end
    if SGJ_Settings.AssumeWorldBuffs == nil then SGJ_Settings.AssumeWorldBuffs = false end
    if SGJ_Settings.RaidBuffPreset == nil then SGJ_Settings.RaidBuffPreset = "off" end
    if SGJ_Settings.WorldBuffPreset == nil then SGJ_Settings.WorldBuffPreset = "off" end
    if not SGJ_Settings.RaidBuffToggles then SGJ_Settings.RaidBuffToggles = {} end
    if not SGJ_Settings.WorldBuffToggles then SGJ_Settings.WorldBuffToggles = {} end
    if SGJ_Settings.ContentPhase == nil then SGJ_Settings.ContentPhase = 1 end
end

function BE:InvalidateCaches()
    if MSC.BumpScoringRevision then
        MSC:BumpScoringRevision()
    else
        MSC.CachedWeights = nil
        MSC.CachedSpecKey = nil
        if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
        if MSC.SlotCache then wipe(MSC.SlotCache) end
    end
end

function BE:ApplyRaidPreset(preset)
    SGJ_Settings.RaidBuffPreset = preset
    SGJ_Settings.RaidBuffToggles = {}
    local src = RAID_PRESETS[preset] or {}
    for id, on in pairs(src) do SGJ_Settings.RaidBuffToggles[id] = on end
    SGJ_Settings.AssumeRaidBuffs = (preset ~= "off")
    self:InvalidateCaches()
end

function BE:ApplyWorldPreset(preset)
    SGJ_Settings.WorldBuffPreset = preset
    SGJ_Settings.WorldBuffToggles = {}
    local src = WORLD_PRESETS[preset] or {}
    for id, on in pairs(src) do SGJ_Settings.WorldBuffToggles[id] = on end
    SGJ_Settings.AssumeWorldBuffs = (preset ~= "off")
    self:InvalidateCaches()
end

function BE:IsRaidBuffOn(id)
    if not SGJ_Settings or not SGJ_Settings.AssumeRaidBuffs then return false end
    return SGJ_Settings.RaidBuffToggles[id] == true
end

function BE:IsWorldBuffOn(id)
    if not SGJ_Settings or not SGJ_Settings.AssumeWorldBuffs then return false end
    return SGJ_Settings.WorldBuffToggles[id] == true
end

function BE:PlayerHasTalent(talentKey)
    if MSC.GetTalentRank then return (MSC:GetTalentRank(talentKey) or 0) > 0 end
    return false
end

function BE:IsBalanceDruid(specKey)
    local s = tostring(specKey or ""):upper()
    return s:find("BALANCE") ~= nil
end

-- -------------------------------------------------------------
-- Hit cap credits (% subtracted from base cap)
-- -------------------------------------------------------------

function BE:GetPersonalRacialHitPct()
    if self:IsPlayerDraenei() then return 1 end
    return 0
end

function BE:GetRaidHitCreditPct(hitType, specKey)
    if not SGJ_Settings or not SGJ_Settings.AssumeRaidBuffs then return 0 end
    local credit = 0

    if self:IsRaidBuffOn("IMPROVED_FAERIE_FIRE") then
        credit = credit + 3
    end

    if hitType == "SPELL" then
        if self:IsRaidBuffOn("TOTEM_OF_WRATH") and not self:PlayerHasTalent("TOTEM_OF_WRATH") then
            credit = credit + 3
        end
        if self:IsRaidBuffOn("MISERY") and not self:IsRaidBuffOn("TOTEM_OF_WRATH") then
            credit = credit + 3
        end
        if self:IsRaidBuffOn("MOONKIN_AURA") and not self:IsBalanceDruid(specKey) then
            -- spell crit buff, not hit — handled in synergy
        end
    end

    if self:IsRaidBuffOn("HEROIC_PRESENCE") and not self:IsPlayerDraenei() then
        credit = credit + 1
    end

    return credit
end

function BE:GetTotalHitCreditPct(hitType, specKey, talentPct)
    return (talentPct or 0) + self:GetPersonalRacialHitPct() + self:GetRaidHitCreditPct(hitType, specKey)
end

-- -------------------------------------------------------------
-- Cap hysteresis (shared by all classes)
-- -------------------------------------------------------------

function BE:GetRatingScalar(ratingId, level)
    level = level or UnitLevel("player")
    if level > 70 then level = 70 end
    if MSC.CombatRatingScalars and MSC.CombatRatingScalars[level] and MSC.CombatRatingScalars[level][ratingId] then
        return MSC.CombatRatingScalars[level][ratingId]
    end
    if ratingId == 8 then return 12.6 end  -- spell hit
    if ratingId == 7 or ratingId == 6 then return 15.8 end  -- melee / ranged hit
    return 15.8
end

--[[
  Apply hard/soft cap to a rating-based stat weight.
  options: { furyCapped, furySoft, hardVal, softMult, hardLabel, softLabel }
]]
function BE:ApplyRatingCap(weights, activeCaps, weightKey, ratingId, baseCapPct, creditPct, options)
    if not weights[weightKey] or weights[weightKey] <= 0.1 then return end
    options = options or {}

    local hitRating = GetCombatRating(ratingId)
    local scalar = self:GetRatingScalar(ratingId)
    local finalCapRating = math_max(0, baseCapPct - (creditPct or 0)) * scalar
    local hardVal = options.hardVal or 0.05
    local softMult = options.softMult or 0.4
    local hardLabel = options.hardLabel or MSC.L["Hit"]
    local softLabel = options.softLabel or MSC.L["Hit (Soft)"]

    if hitRating >= (finalCapRating + scalar) then
        if options.furyCapped then
            weights[weightKey] = 0.8
            table.insert(activeCaps, MSC.L["Y-Hit (Rage)"])
        else
            weights[weightKey] = hardVal
            table.insert(activeCaps, hardLabel)
        end
    elseif hitRating >= finalCapRating then
        if options.furySoft then
            weights[weightKey] = 1.4
        else
            weights[weightKey] = weights[weightKey] * softMult
        end
        table.insert(activeCaps, softLabel)
    end
end

function BE:ApplyMeleeHitCap(weights, activeCaps, currentSpec, talentHitPct, ratingId, options)
    options = options or {}
    local baseCapPct = (currentSpec and currentSpec:find("Leveling")) and 5 or 9
    local credit = self:GetTotalHitCreditPct("MELEE", currentSpec, talentHitPct or 0)
    local isFury = currentSpec and (currentSpec:find("FURY") or currentSpec:find("DW"))
    self:ApplyRatingCap(weights, activeCaps, "ITEM_MOD_HIT_RATING_SHORT", ratingId or 6, baseCapPct, credit, {
        furyCapped = options.furyCapped or isFury,
        furySoft = options.furySoft or isFury,
        hardVal = options.hardVal or (isFury and 0.8 or 0.1),
        softMult = options.softMult or 0.4,
        hardLabel = options.hardLabel or MSC.L["Hit"],
        softLabel = options.softLabel or MSC.L["Hit (Soft)"],
    })
end

function BE:ApplySpellHitCap(weights, activeCaps, currentSpec, talentHitPct, options)
    options = options or {}
    local baseCapPct = 16
    if currentSpec and currentSpec:find("PVP") then baseCapPct = 4
    elseif currentSpec and currentSpec:find("Leveling") then baseCapPct = 6 end
    local credit = self:GetTotalHitCreditPct("SPELL", currentSpec, talentHitPct or 0)
    self:ApplyRatingCap(weights, activeCaps, "ITEM_MOD_HIT_SPELL_RATING_SHORT", 8, baseCapPct, credit, {
        hardVal = options.hardVal or 0.05,
        softMult = options.softMult or 0.4,
        hardLabel = options.hardLabel or MSC.L["Hit"],
        softLabel = options.softLabel or MSC.L["Hit (Soft)"],
    })
end

-- -------------------------------------------------------------
-- Stat synergy (raid + world buffs deflate gear stat weights)
-- -------------------------------------------------------------

local SYNERGY_BUFFS = {
    -- raid
    { id = "BLESSING_OF_KINGS", pct = 5, stats = { "STR", "AGI", "STA", "INT" }, raid = true },
    { id = "MARK_OF_THE_WILD", pct = 4, stats = { "STR", "AGI", "STA", "INT" }, raid = true },
    { id = "SPIRIT_OF_ZANDALAR", pct = 15, stats = { "STR", "AGI", "STA", "INT" }, world = true },
    { id = "SONGFLOWER", pct = 3, stats = { "STR", "AGI", "STA", "INT" }, world = true }, -- ~15 flat ≈ small % at 70
}

local STAT_KEYS = {
    STR = "ITEM_MOD_STRENGTH_SHORT",
    AGI = "ITEM_MOD_AGILITY_SHORT",
    STA = "ITEM_MOD_STAMINA_SHORT",
    INT = "ITEM_MOD_INTELLECT_SHORT",
    SPI = "ITEM_MOD_SPIRIT_SHORT",
}

function BE:IsSynergyBuffActive(entry)
    if entry.raid and self:IsRaidBuffOn(entry.id) then return true end
    if entry.world and self:IsWorldBuffOn(entry.id) then return true end
    return false
end

function BE:GetCombinedStatSynergyPct()
    local pcts = {}
    for _, entry in ipairs(SYNERGY_BUFFS) do
        if self:IsSynergyBuffActive(entry) then
            table.insert(pcts, entry.pct)
        end
    end
    if #pcts == 0 then return 0 end
    table.sort(pcts, function(a, b) return a > b end)
    local total = pcts[1]
    for i = 2, #pcts do total = total + pcts[i] * 0.5 end
    return total
end

function BE:ApplyStatSynergy(weights, specKey)
    local synergyPct = self:GetCombinedStatSynergyPct()
    if synergyPct <= 0 then return end
    local mult = 1 / (1 + synergyPct / 100)
    for _, key in pairs(STAT_KEYS) do
        if weights[key] then weights[key] = weights[key] * mult end
    end
    -- Flat AP world buffs
    if self:IsWorldBuffOn("FENGUS") or self:IsWorldBuffOn("FACTION_HEAD") then
        local apMult = 0.92
        if weights["ITEM_MOD_ATTACK_POWER_SHORT"] then
            weights["ITEM_MOD_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_ATTACK_POWER_SHORT"] * apMult
        end
    end
    if self:IsWorldBuffOn("DRAGONSLAYER") then
        if weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
            weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * 0.9
        end
    end
end

-- -------------------------------------------------------------
-- SAFETY_CAPS effective base (rating) for Evaluator
-- -------------------------------------------------------------

function BE:GetEffectiveHitRatingBase(statKey, classTalentKey, talentRatingPerRank, specKey)
    local base = 202 -- 16% spell hit in rating at 70
    if statKey == "ITEM_MOD_HIT_RATING_SHORT" then base = 142 end -- 9% melee

    local talentRank = 0
    if classTalentKey and MSC.GetTalentRank then
        talentRank = MSC:GetTalentRank(classTalentKey) or 0
    end
    local creditRating = talentRank * (talentRatingPerRank or 0)

    local hitType = (statKey == "ITEM_MOD_HIT_SPELL_RATING_SHORT") and "SPELL" or "MELEE"
    local creditPct = self:GetRaidHitCreditPct(hitType, specKey) + self:GetPersonalRacialHitPct()
    local scalar = self:GetRatingScalar(hitType == "SPELL" and 8 or 6)
    creditRating = creditRating + creditPct * scalar

    return math_max(0, base - creditRating)
end

function BE:GetCapModifiersForUI(specKey)
    local mods = {}
    if self:GetPersonalRacialHitPct() > 0 then
        table.insert(mods, { source = "Heroic Presence (Racial)", val = 1, isPct = true })
    end
    if SGJ_Settings and SGJ_Settings.AssumeRaidBuffs then
        if self:IsRaidBuffOn("IMPROVED_FAERIE_FIRE") then
            table.insert(mods, { source = "Improved Faerie Fire", val = 3, isPct = true })
        end
        if self:IsRaidBuffOn("TOTEM_OF_WRATH") and not self:PlayerHasTalent("TOTEM_OF_WRATH") then
            table.insert(mods, { source = "Totem of Wrath", val = 3, isPct = true })
        end
        if self:IsRaidBuffOn("HEROIC_PRESENCE") and not self:IsPlayerDraenei() then
            table.insert(mods, { source = "Draenei in Raid", val = 1, isPct = true })
        end
    end
    return mods
end

BE.InitSettings()
