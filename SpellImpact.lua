-- =============================================================
-- SPELL IMPACT (WoW Forever, 2026-11-19)
-- =============================================================
-- An optional tooltip block (setting ShowSpellImpact, on by default from 3.5.0):
-- how the hovered item changes your main spells at the highest rank you
-- know. Casters and healers get damage (or healing) per second and per
-- mana; Warriors, Rogues and Hunters get damage per use (and per mana for
-- Hunters). Now in yellow, with the item in green (better) or red (worse).
--
-- One cast's value, against a mob of your level, before talents (talent
-- bonuses scale both numbers the same):
--   base (middle of the roll, grown by level until the rank's cap)
--   + coefficient x spell damage (or healing) x Forever's downrank share,
--   periodic parts the same per tick; weapon abilities use the weapon's
--   damage plus Attack Power / 14 x speed (normalized for instants);
--   x hit chance (damage) and x (1 + crit x (crit damage - 1)) on the
--   direct part, and on ticks the client lets crit. Per second: the direct part over the cast (1.5 s global
--   cooldown at least, channels their channel time) plus the periodic part
--   over its duration. Mana cost and cast time come from the game, so the
--   rank, talents and haste are in them.
-- Data: Data/SpellImpact_Forever.lua (Research/spellimpact/gen_spell_impact.py).

local _, MSC = ...
local math_max, math_min, math_floor = math.max, math.min, math.floor
local string_format, string_upper, string_find = string.format, string.upper, string.find
local ipairs, pairs, tonumber, select, type = ipairs, pairs, tonumber, select, type

local IsKnown = IsPlayerSpell or IsSpellKnown

local function Num(v)
    if MSC.SanitizeStat then return MSC.SanitizeStat(v) end
    return tonumber(v) or 0
end

local function SpellName(id)
    if C_Spell and C_Spell.GetSpellName then return C_Spell.GetSpellName(id) end
    return GetSpellInfo and (GetSpellInfo(id)) or nil
end

local function SpellRankText(id)
    if C_Spell and C_Spell.GetSpellSubtext then return C_Spell.GetSpellSubtext(id) end
    return GetSpellSubtext and GetSpellSubtext(id) or nil
end

-- The game's cast time in seconds (talents and haste in it), nil when unknown
local function GameCastTime(id)
    if C_Spell and C_Spell.GetSpellInfo then
        local info = C_Spell.GetSpellInfo(id)
        if type(info) == "table" and info.castTime then return Num(info.castTime) / 1000 end
    end
    if GetSpellInfo then
        local ms = select(4, GetSpellInfo(id))
        if ms then return Num(ms) / 1000 end
    end
    return nil
end

-- The game's mana cost (rank and talents in it), nil when unknown
local function GameManaCost(id)
    local f = (C_Spell and C_Spell.GetSpellPowerCost) or GetSpellPowerCost
    local costs = f and f(id)
    if type(costs) ~= "table" then return nil end
    for _, c in ipairs(costs) do
        if type(c) == "table" and (c.type == 0 or c.name == "MANA") then return Num(c.cost) end
    end
    return nil
end

-- =============================================================
-- KNOWN RANKS (cached until the spellbook, level or talents change)
-- =============================================================
local knownCache = nil
local cacheFrame = CreateFrame("Frame")
for _, ev in ipairs({ "SPELLS_CHANGED", "LEARNED_SPELL_IN_TAB", "PLAYER_LEVEL_UP", "PLAYER_TALENT_UPDATE", "TRAIT_CONFIG_UPDATED", "CHARACTER_POINTS_CHANGED" }) do
    pcall(cacheFrame.RegisterEvent, cacheFrame, ev)
end
function MSC.ResetSpellImpactCache() knownCache = nil end
cacheFrame:SetScript("OnEvent", MSC.ResetSpellImpactCache)

-- =============================================================
-- OPTIONS (SGJ_Settings.SpellImpact; the Spell Impact tab, SpellImpactView.lua)
-- =============================================================
local DEFAULTS = { rows = "auto", maxRows = 3, target = 0, efficient = false, extraTargets = false, showRank = true }
function MSC.SpellImpactOptions()
    if not SGJ_Settings then return DEFAULTS end
    local o = SGJ_Settings.SpellImpact
    if type(o) ~= "table" then o = {}; SGJ_Settings.SpellImpact = o end
    for k, v in pairs(DEFAULTS) do if o[k] == nil then o[k] = v end end
    if type(o.hidden) ~= "table" then o.hidden = {} end
    return o
end
function MSC.ResetSpellImpactOptions()
    if SGJ_Settings then SGJ_Settings.SpellImpact = nil end
    return MSC.SpellImpactOptions()
end

-- Miss chance to cover by target level (0 = your level ... 3 = boss): spells 4 / 5 / 6 / 17%, melee and ranged
-- 5 / 5.5 / 6 / 9% (MSC.ForeverCaps: the same-level and +3 ends)
local SPELL_MISS = { [0] = 4, 5, 6, 17 }
local MELEE_MISS = { [0] = 5, 5.5, 6, 9 }
local function MissCap(kind)
    local t = math_max(0, math_min(3, tonumber(MSC.SpellImpactOptions().target) or 0))
    local caps = MSC.ForeverCaps and MSC.ForeverCaps[kind]
    if kind == "SPELL" then
        if t == 0 and caps then return caps.leveling end
        if t == 3 and caps then return caps.raid end
        return SPELL_MISS[t]
    end
    if t == 0 and caps then return caps.leveling end
    if t == 3 and caps then return caps.raid end
    return MELEE_MISS[t]
end

-- Every rank of one spell entry you know: { rank, id } by level
local function KnownRanks(entry)
    local out = {}
    for _, r in ipairs(entry.ranks) do
        for _, id in ipairs(r.ids) do
            if IsKnown(id) then out[#out + 1] = { rank = r, id = id }; break end
        end
    end
    table.sort(out, function(a, b) return a.rank.l < b.rank.l end)
    return out
end

-- The highest rank you know of one spell entry: rank row, the id you know
local function HighestKnown(entry)
    local ranks = KnownRanks(entry)
    local top = ranks[#ranks]
    if top then return top.rank, top.id, ranks end
    return nil
end

-- Rows for a role ("dmg" / "heal" / "melee" / "bear"): { entry, rank, id, ranks }, every row of the class list you know
local function KnownRows(class, role)
    knownCache = knownCache or {}
    local key = class .. role
    if knownCache[key] then return knownCache[key] end
    local out = {}
    local data = MSC.SpellImpactData and MSC.SpellImpactData[class]
    for _, row in ipairs(data and data[role] or {}) do
        for _, entry in ipairs(row) do
            local r, id, ranks = HighestKnown(entry)
            if r then out[#out + 1] = { entry = entry, rank = r, id = id, ranks = ranks }; break end
        end
    end
    knownCache[key] = out
    return out
end

-- The roles your class has rows for, in display order
function MSC.SpellImpactRoles(class)
    local data = MSC.SpellImpactData and MSC.SpellImpactData[class]
    local out = {}
    for _, role in ipairs({ "dmg", "heal", "melee", "bear" }) do
        if data and data[role] and #data[role] > 0 then out[#out + 1] = role end
    end
    return out
end

-- Healer profiles show heals, every other profile damage
local function IsHealerProfile(specName)
    local s = string_upper(tostring(specName or ""))
    return string_find(s, "HEAL") or string_find(s, "HOLY") or string_find(s, "DISC") or string_find(s, "RESTO")
end

-- The rows a profile shows: "heal", "dmg" (spells), or for the hybrids' melee profiles "melee" (Retribution and
-- Protection, Enhancement and the Shaman tank, Feral Cat: the leveling "Leveling" rows are the melee ones) and "bear"
local HYBRID = { PALADIN = true, SHAMAN = true, DRUID = true }
local function ProfileRole(class, specName)
    if IsHealerProfile(specName) then return "heal" end
    if not HYBRID[class] then return "dmg" end
    local s = string_upper(tostring(specName or ""))
    if class == "DRUID" and string_find(s, "BEAR") then return "bear" end
    if string_find(s, "CASTER") or string_find(s, "BAL") or string_find(s, "ELE") or string_find(s, "MOONKIN")
        or string_find(s, "BOOM") or string_find(s, "SHOCK") then return "dmg" end
    return "melee"
end

-- Who gets an auto-attack line: Warriors, Rogues, the hybrids' melee profiles, Hunter melee profiles (and every
-- Hunter an Auto Shot line)
local function MeleeLine(class, role, specName)
    if class == "WARRIOR" or class == "ROGUE" then return true end
    if role == "melee" or role == "bear" then return true end
    return class == "HUNTER" and string_find(string_upper(tostring(specName or "")), "MELEE") and true or false
end

-- =============================================================
-- STATS (now / with the item)
-- =============================================================
local AP_PER = { -- AttackPowerPerStrength, AttackPowerPerAgility, RangedAttackPowerPerAgility (ChrClasses)
    WARRIOR = { 2, 0, 1 }, PALADIN = { 2, 0, 0 }, SHAMAN = { 2, 0, 0 }, DRUID = { 2, 0, 0 },
    ROGUE = { 1, 1, 2 }, HUNTER = { 1, 1, 2 },
}
local SCHOOL_DMG_KEY = { [2] = "ITEM_MOD_HOLY_DAMAGE_SHORT", [3] = "ITEM_MOD_FIRE_DAMAGE_SHORT", [4] = "ITEM_MOD_NATURE_DAMAGE_SHORT",
    [5] = "ITEM_MOD_FROST_DAMAGE_SHORT", [6] = "ITEM_MOD_SHADOW_DAMAGE_SHORT", [7] = "ITEM_MOD_ARCANE_DAMAGE_SHORT" }
local TWO_HAND = { [1] = true, [5] = true, [6] = true, [8] = true, [10] = true }   -- 2H axe, 2H mace, polearm, 2H sword, staff

-- Weapon in a slot: average hit, speed, normalized speed (nil when none)
local function WeaponOf(stats, link, ranged)
    if not stats then return nil end
    local dps, speed = tonumber(stats.MSC_WEAPON_DPS) or tonumber(stats.ITEM_MOD_DAMAGE_PER_SECOND_SHORT), tonumber(stats.MSC_WEAPON_SPEED)
    if not dps or not speed or speed <= 0 then return nil end
    local norm = 2.4
    if ranged then
        norm = 2.8
    elseif link and GetItemInfoInstant then
        local _, _, _, _, _, classID, subID = GetItemInfoInstant(link)
        if classID == 2 and subID == 15 then norm = 1.7 elseif classID == 2 and TWO_HAND[subID] then norm = 3.3 end
    end
    return { avg = dps * speed, speed = speed, norm = norm }
end

-- Stats for both sides: now (gear as judged) and with the item in slotId
local function BuildSides(link, slotId, itemNewStats, itemOldStats, weights, specName)
    local j = MSC.GetJudgingStats()
    local _, class = UnitClass("player")
    local L = math_max(1, math_min(60, UnitLevel("player") or 1))
    local lv = MSC.SpellImpactLevel and MSC.SpellImpactLevel[class]
    local per = AP_PER[class] or { 1, 0, 0 }
    local new, old = itemNewStats or {}, itemOldStats or {}
    local function D(k) return (tonumber(new[k]) or 0) - (tonumber(old[k]) or 0) end

    local dStr, dAgi, dInt = D("ITEM_MOD_STRENGTH_SHORT"), D("ITEM_MOD_AGILITY_SHORT"), D("ITEM_MOD_INTELLECT_SHORT")
    local dCritRating = D("ITEM_MOD_CRIT_RATING_SHORT") + D("ITEM_MOD_SPELL_CRIT_RATING_SHORT")
    local dMeleeCrit = D("ITEM_MOD_CRIT_MELEE_RATING_SHORT")
    local dRangedCrit = D("ITEM_MOD_CRIT_RANGED_RATING_SHORT")
    local dHitRating = MSC.HitRatingOf and (MSC.HitRatingOf(new) - MSC.HitRatingOf(old)) or 0
    local agiPer = lv and lv.agi[L] or 0
    local intPer = lv and lv.int[L] or 0

    local function hitPct(kind)
        if MSC.GetForeverHitPercent then return (MSC:GetForeverHitPercent(kind)) end
        return 0
    end
    -- Crit as gear is judged (2026-11-19, user): the live crit chance less what your buffs give, the flat crit %
    -- (MSC.SpellImpactCritBuffs, from the buffs' client effects) and the crit of the Agility / Intellect they add over
    -- the judged stats (unbuffed + Buff Assumptions), like spell power and attack power above
    local buffM, buffS = 0, 0
    local CB = MSC.SpellImpactCritBuffs
    if CB and MSC.ForEachPlayerBuff then
        MSC.ForEachPlayerBuff(function(spellId)
            local c = CB[spellId]
            if c then buffM, buffS = buffM + (c.m or 0), buffS + (c.s or 0) end
        end)
    end
    local liveAgi = UnitStat and Num(select(2, UnitStat("player", 2))) or 0
    local liveInt = UnitStat and Num(select(2, UnitStat("player", 4))) or 0
    local agiCrit = (agiPer > 0 and j.agi) and (liveAgi - j.agi) / agiPer or 0
    local intCrit = (intPer > 0 and j.int) and (liveInt - j.int) / intPer or 0
    local function judgedSpellCrit(school)
        local live = GetSpellCritChance and Num(GetSpellCritChance(school)) or 0
        return math_max(0, live - buffS - intCrit)
    end

    local now = {
        level = L, class = class,
        sp = j.spSchool or {}, spAll = 0, heal = j.heal or 0,
        ap = j.ap or 0, rap = j.rap or 0,
        meleeCrit = math_max(0, (GetCritChance and Num(GetCritChance()) or 0) - buffM - agiCrit),
        rangedCrit = math_max(0, (GetRangedCritChance and Num(GetRangedCritChance()) or 0) - buffM - agiCrit),
        spellCrit = judgedSpellCrit, critAdd = 0, meleeCritAdd = 0, rangedCritAdd = 0,
        spellHit = hitPct("SPELL"), meleeHit = hitPct("MELEE"), rangedHit = hitPct("RANGED"),
        baseMana = lv and lv.mana[L] or 0,
    }
    local spGeneric = D("ITEM_MOD_SPELL_POWER_SHORT")
    local spDamage = spGeneric + D("ITEM_MOD_SPELL_DAMAGE_DONE_SHORT")
    local with = {}
    for k, v in pairs(now) do with[k] = v end
    with.sp = {}
    for school = 2, 7 do with.sp[school] = (now.sp[school] or 0) + spDamage + D(SCHOOL_DMG_KEY[school]) end
    with.heal = now.heal + spGeneric + D("ITEM_MOD_SPELL_HEALING_DONE_SHORT")
    with.ap = now.ap + dStr * per[1] + dAgi * per[2] + D("ITEM_MOD_ATTACK_POWER_SHORT")
    with.rap = now.rap + dAgi * per[3] + D("ITEM_MOD_ATTACK_POWER_SHORT") + D("ITEM_MOD_RANGED_ATTACK_POWER_SHORT")
    with.critAdd = dCritRating / 14 + (intPer > 0 and dInt / intPer or 0)
    with.meleeCritAdd = (dCritRating + dMeleeCrit) / 14 + (agiPer > 0 and dAgi / agiPer or 0)
    with.rangedCritAdd = (dCritRating + dRangedCrit) / 14 + (agiPer > 0 and dAgi / agiPer or 0)
    with.spellHit = now.spellHit + dHitRating / 10
    with.meleeHit = now.meleeHit + dHitRating / 10
    with.rangedHit = now.rangedHit + dHitRating / 10

    -- weapons: the worn ones now; the item's own when it goes in that slot
    local function Worn(slot)
        local wl = GetInventoryItemLink("player", slot)
        if not wl then return nil end
        return WeaponOf(MSC.SafeGetItemStats(wl, slot, weights, specName), wl, slot == 18)
    end
    now.mh, now.oh, now.rw = Worn(16), Worn(17), Worn(18)
    with.mh, with.oh, with.rw = now.mh, now.oh, now.rw
    if slotId == 16 then
        with.mh = WeaponOf(new, link, false)
        -- a two-hander takes the off hand's place too
        local equipLoc = GetItemInfoInstant and select(4, GetItemInfoInstant(link))
        if equipLoc == "INVTYPE_2HWEAPON" then with.oh = nil end
    elseif slotId == 17 then with.oh = WeaponOf(new, link, false)   -- a shield or held item: no off-hand swings
    elseif slotId == 18 then with.rw = WeaponOf(new, link, true) end
    return now, with
end

-- =============================================================
-- ONE CAST
-- =============================================================
local function Grown(r, base, perLevel, L)
    if not base then return 0 end
    if perLevel and perLevel > 0 and r.m and r.m > 0 then
        return base + perLevel * math_max(0, math_min(L, r.m) - r.l)
    end
    return base
end

-- Forever downranking: a rank keeps its whole bonus for 17 levels, then 5% less a level
local function DownrankShare(r, L)
    return math_max(0, math_min(1, 1 - (L - 17 - r.l) * 0.05))
end

-- Value of one cast: total amount, per second, per mana (nil when no cost)
local function Evaluate(row, side, isHeal)
    local r, id = row.rank, row.id
    local L = side.level
    -- physical school (Ferocious Bite, Swipe: no weapon or AP part in the tables) or a weapon / AP part (Holy Strike)
    local physical = r.s == 1 or r.w or r.ap or r.tap or r.ppr
    local ranged = r.r or (r.w and side.class == "HUNTER" and r.s == 1 and row.entry.name ~= "Raptor Strike")

    -- bonus and crit for the spell's kind
    local bonus, crit, critMult, hitChance
    if physical then
        local ap = ranged and side.rap or side.ap
        bonus = ap
        crit = ranged and (side.rangedCrit + side.rangedCritAdd) or (side.meleeCrit + side.meleeCritAdd)
        critMult = 2
        local cap = MissCap("MELEE")
        hitChance = 1 - math_max(0, cap - (ranged and side.rangedHit or side.meleeHit)) / 100
    else
        bonus = isHeal and side.heal or (side.sp[r.s] or 0)
        crit = side.spellCrit(r.s) + side.critAdd
        critMult = 1.5
        local cap = MissCap("SPELL")
        hitChance = isHeal and 1 or (1 - math_max(0, cap - side.spellHit) / 100)
    end
    crit = math_max(0, math_min(100, crit)) / 100
    local share = DownrankShare(r, L)

    -- direct part
    local direct = 0
    if r.w then
        local wpn = ranged and side.rw or side.mh
        if not wpn then return nil end
        local speed = (r.w == 2) and wpn.norm or wpn.speed
        direct = (wpn.avg + bonus / 14 * speed) * (r.wpct or 1) + (r.b or 0)
    elseif r.b then
        local base = Grown(r, r.b, r.g, L)
        if r.ppr then   -- finishers at 5 combo points
            direct = base + r.ppr * 5 + (r.ap or 0) * bonus * 5
        elseif physical then
            direct = base + (r.ap or 0) * bonus
        else
            direct = base + (r.c or 0) * bonus * share
        end
    end
    direct = direct * (1 + crit * (critMult - 1))
    -- extra targets (option): chain jumps at the client's scaling each jump (Chain Lightning x0.7, Chain Heal x0.5,
    -- Multi-Shot and Swipe x1), area spells on 3 mobs
    if MSC.SpellImpactOptions().extraTargets then
        if r.jt and r.jt > 1 then
            local sum, f = 0, 1
            for _ = 1, r.jt do sum = sum + f; f = f * (r.ja or 1) end
            direct = direct * sum
        elseif r.aoe then
            direct = direct * 3
        end
    end

    -- periodic part: ticks crit when the spell has the client's "Periodic Can Crit" flag (pc: Shadow Word: Pain,
    -- Corruption, Moonfire, Mind Flay, Rejuvenation...; Forever's own Renew and Serpent Sting ranks don't) and on
    -- channeled missiles (Arcane Missiles); a periodic crit is a spell crit (150%), Serpent Sting's too
    local periodic = 0
    if r.tb and r.k then
        local tick = Grown(r, r.tb, r.tg, L)
        if physical then tick = tick + (r.tap or 0) * bonus else tick = tick + (r.tc or 0) * bonus * share end
        periodic = tick * r.k
        if r.pc or r.ch then periodic = periodic * (1 + crit * ((r.s ~= 1) and 0.5 or (critMult - 1))) end
    end

    direct, periodic = direct * hitChance, periodic * hitChance
    local total = direct + periodic

    -- time: the game's cast time, at least the global cooldown; channels take their channel
    local cast = GameCastTime(id) or r.ct or 0
    local perSec
    if r.ch then
        perSec = total / math_max(1, r.ch)
    else
        local exec = math_max(cast, 1.5)
        perSec = direct / exec + ((r.du and r.du > 0) and periodic / r.du or periodic / exec)
    end

    local cost = GameManaCost(id)
    if not cost then
        cost = (r.pt or 0) == 0 and ((r.cost or 0) + (r.pct or 0) / 100 * (side.baseMana or 0)) or 0
    end
    local perMana = (cost and cost > 0) and total / cost or nil
    return total, perSec, perMana, physical, math_max(cast, 0), cost
end

-- Auto-attack damage per second against a mob of your level (2026-11-19, user): each weapon's average hit plus
-- Attack Power / 14 x its speed, over its speed. Melee: 5% miss less your hit (+19% while dual wielding), 5% dodge,
-- 5% parry (mobs face you while questing), 10% glancing blows at 95%, crits at 200% (SimStudio wmodel.js), the off
-- hand at half damage; forms swing the real weapon in Forever. Ranged (Auto Shot): 5% miss less your hit, crits at 200%.
local function WhiteDPS(side, ranged)
    local function swing(w, ap, mult) return (w.avg + ap / 14 * w.speed) / w.speed * mult end
    local cap = MissCap("MELEE")
    if ranged then
        local w = side.rw
        if not w then return nil end
        local land = 1 - math_max(0, cap - side.rangedHit) / 100
        local c = math_min(math_max(0, (side.rangedCrit + side.rangedCritAdd) / 100), land)
        return swing(w, side.rap, (land - c) + 2 * c)
    end
    local mh, oh = side.mh, side.oh
    if not mh then return nil end
    local miss = math_max(0, cap - side.meleeHit) / 100 + (oh and 0.19 or 0)
    local land, glance = math_max(0, 1 - miss - 0.05 - 0.05), 0.10
    local c = math_min(math_max(0, (side.meleeCrit + side.meleeCritAdd) / 100), math_max(0, land - glance))
    local mult = math_max(0, land - glance - c) + glance * 0.95 + 2 * c
    local dps = swing(mh, side.ap, mult)
    if oh then dps = dps + 0.5 * swing(oh, side.ap, mult) end
    return dps
end

-- =============================================================
-- TOOLTIP BLOCK
-- =============================================================
local YELLOW, GREEN, RED = "|cffffff00", "|cff00ff00", "|cffff3333"

-- Decimals for a value: none from 100; under 100 one (damage, healing), per-mana values 1 from 10, else 2
-- (2026-11-19, user: a +1 spell power item read "DPS 19 > 19")
local function Decimals(v, small)
    if v >= 100 then return 0 end
    if not small or v >= 10 then return 1 end
    return 2
end

local function Fmt(v, dec)
    if dec == 0 then return string_format("%d", math_floor(v + 0.5)) end
    return string_format("%." .. dec .. "f", v)
end

-- Both sides of a pair use the larger value's decimals ("9.7 > 11" shows as "10 > 11")
local function Pair(label, a, b, small)
    if not a or not b then return nil end
    local dec = Decimals(math_max(a, b), small)
    local ta, tb = Fmt(a, dec), Fmt(b, dec)
    local col = YELLOW
    if tb ~= ta then col = (b > a) and GREEN or RED end
    return string_format("%s %s%s|r > %s%s|r", label, YELLOW, ta, col, tb)
end

-- The role shown: the option (Damage / Healing / Melee / Bear) when your class has rows for it, else your profile's
function MSC.SpellImpactRole(class, specName)
    local want = MSC.SpellImpactOptions().rows
    if want and want ~= "auto" then
        for _, r in ipairs(MSC.SpellImpactRoles(class)) do if r == want then return want end end
    end
    return ProfileRole(class, specName)
end

-- Every line for one item (link nil: your spells now, both sides the same). Each line:
-- { key, spellId, name, rank, white, heal, physical, efficient, a = { total, perSec, perMana }, b = {...}, cast, cost }.
-- Auto-attack lines first. hidden spells (option) are left out unless all is true.
function MSC.SpellImpactLines(link, slotId, itemNewStats, itemOldStats, weights, specName, all)
    if not MSC.SpellImpactData or not MSC.GetJudgingStats then return {}, nil end
    local o = MSC.SpellImpactOptions()
    local _, class = UnitClass("player")
    local role = MSC.SpellImpactRole(class, specName)
    local heal = role == "heal"
    local rows = KnownRows(class, role)
    if #rows == 0 and role ~= "dmg" then heal = false; role = "dmg"; rows = KnownRows(class, "dmg") end
    local melee, autoShot = MeleeLine(class, role, specName), class == "HUNTER"

    local now, with = BuildSides(link, slotId, itemNewStats, itemOldStats, weights, specName)
    local lines = {}
    -- auto-attack first: the client's own names for Attack and Auto Shot
    local function white(ranged, spellId, fallback)
        local a, b = WhiteDPS(now, ranged), WhiteDPS(with, ranged)
        if a and b then
            local key = ranged and "Auto Shot" or "Attack"
            if all or not o.hidden[key] then
                lines[#lines + 1] = { key = key, spellId = spellId, name = SpellName(spellId) or fallback, white = true,
                    physical = true, a = { a, a }, b = { b, b } }
            end
        end
    end
    if melee then white(false, 6603, "Attack") end
    if autoShot then white(true, 75, "Auto Shot") end

    local function add(row, rankEntry, efficient)
        local r = { entry = row.entry, rank = rankEntry.rank, id = rankEntry.id }
        local aT, aS, aM, physical, cast, cost = Evaluate(r, now, heal)
        local bT, bS, bM = Evaluate(r, with, heal)
        if not (aT and bT) then return end
        lines[#lines + 1] = { key = row.entry.name, spellId = r.id, name = SpellName(r.id) or row.entry.name,
            rank = SpellRankText(r.id), heal = heal, physical = physical, efficient = efficient,
            a = { aT, aS, aM }, b = { bT, bS, bM }, cast = cast, cost = cost }
    end
    for _, row in ipairs(rows) do
        if all or not o.hidden[row.entry.name] then
            add(row, { rank = row.rank, id = row.id })
            -- healers: the rank you know that heals most per mana (downranking), when it isn't the top one
            if heal and o.efficient and row.ranks and #row.ranks > 1 then
                local best, bestHPM
                for _, k in ipairs(row.ranks) do
                    local t, _, m = Evaluate({ entry = row.entry, rank = k.rank, id = k.id }, now, true)
                    if t and m and (not bestHPM or m > bestHPM) then best, bestHPM = k, m end
                end
                if best and best.id ~= row.id then add(row, best, true) end
            end
        end
    end
    return lines, role
end

-- One line's value text, "DPS a > b  DPM c > d" (physical rows: damage per use; auto-attack: DPS)
function MSC.SpellImpactValueText(l)
    if l.white then return Pair(MSC.L["DPS"], l.a[1], l.b[1]) end
    local parts
    if l.physical then
        parts = Pair(MSC.L["Damage"], l.a[1], l.b[1])
        local m = Pair(MSC.L["DPM"], l.a[3], l.b[3], true)
        if m then parts = parts .. "  " .. m end
    else
        parts = Pair(l.heal and MSC.L["HPS"] or MSC.L["DPS"], l.a[2], l.b[2])
        local m = Pair(l.heal and MSC.L["HPM"] or MSC.L["DPM"], l.a[3], l.b[3], true)
        if m then parts = parts .. "  " .. m end
    end
    return parts
end

-- A number as the tooltip shows it (no decimals from 100, one under, per mana two under 10)
function MSC.SpellImpactFormat(v, small)
    if not v then return "-" end
    return Fmt(v, Decimals(v, small))
end

-- A line's left text: the spell's name, its rank (option) and a mark for the most efficient rank
function MSC.SpellImpactLabel(l)
    local name = l.name or l.key
    if l.efficient then
        name = name .. " |cff888888(" .. (l.rank or "") .. ", " .. MSC.L["most efficient"] .. ")|r"
    elseif MSC.SpellImpactOptions().showRank and l.rank and l.rank ~= "" then
        name = name .. " |cff888888(" .. l.rank .. ")|r"
    end
    return name
end

-- The last item a tooltip judged (the Spell Impact tab compares it)
MSC.SpellImpactLastLink = nil

-- Adds the block to a tooltip (Judge.lua, items you don't wear)
function MSC.AddSpellImpact(tooltip, link, slotId, itemNewStats, itemOldStats, weights, specName)
    if link and MSC.SpellImpactLastLink ~= link then
        MSC.SpellImpactLastLink = link
        if MSC.OnSpellImpactHover then MSC.OnSpellImpactHover(link) end
    end
    if not (SGJ_Settings and SGJ_Settings.ShowSpellImpact) then return end
    local lines = MSC.SpellImpactLines(link, slotId, itemNewStats, itemOldStats, weights, specName)
    if #lines == 0 then return end
    -- auto-attack lines and the efficient-rank lines don't count against the row limit
    local maxRows = math_max(1, math_min(6, tonumber(MSC.SpellImpactOptions().maxRows) or 3))
    tooltip:AddLine(" ")
    tooltip:AddDoubleLine(MSC.L["Spell Impact:"], MSC.L["now > with this item"], 1, 0.82, 0, 0.6, 0.6, 0.6)
    local shown = 0
    for _, l in ipairs(lines) do
        local counts = not l.white and not l.efficient
        if counts then shown = shown + 1 end
        if not counts or shown <= maxRows then
            local text = MSC.SpellImpactValueText(l)
            if text then tooltip:AddDoubleLine(MSC.SpellImpactLabel(l), text, 1, 1, 1, 1, 1, 1) end
        end
    end
end
