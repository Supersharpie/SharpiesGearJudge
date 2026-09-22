local addonName, MSC = ...
local Druid = {}
Druid.Name = "DRUID"

-- =============================================================
-- WOW FOREVER STAT WEIGHTS (Beta Baseline)
-- =============================================================
Druid.Weights = {
    ["Default"] = { ["ITEM_MOD_STRENGTH_SHORT"]=1.0, ["ITEM_MOD_AGILITY_SHORT"]=2.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=1.0, ["ITEM_MOD_MANA_SHORT"]=0.05, ["ITEM_MOD_STAMINA_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    -- Spell Hit 187.5 / Spell Crit 30 at this profile's Spell Power 15: 1%
    -- Hit = 12.5 Spell Power (the raid standard on the Spell Power 2 profiles
    -- elsewhere) and 1% Crit = 2 Spell Power before Vengeance doubles it.
    ["BALANCE_BOOMKIN"] = {  ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=187.5, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=1.0  },
    -- Healer Spell Crit: 1% crit is worth ~2.4 Healing (a crit heal adds 50%),
    -- so 48 at Healing 20 (the old 10 made it 0.5 Healing).
    ["RESTO_MOONGLOW"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0  },
    ["RESTO_REGROWTH"] = {  ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPIRIT_SHORT"]=5.0  },
    ["RESTO_DEEP"] = {  ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0  },
    -- Cat melee AP = Strength x 2 + Agility (+ level) -- Druids get 2 AP per
    -- Strength in every form, and Forever's Cat Form ("+12 plus Agility") adds
    -- 1 AP per Agility on top. So Strength (2 AP) leads and Agility is 1 AP
    -- plus its crit/dodge rider (1.4). The old Agility 3 / Strength 1 had
    -- this backwards, citing a "double-rate" Agility conversion. Weapon DPS
    -- is left out: Cat/Bear attacks use the form's own damage, not the
    -- weapon's -- a feral weapon's "+X Attack Power in Cat, Bear..." counts
    -- like Attack Power instead.
    ["FERAL_CAT_DPS"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=1.0 },
    -- Armor 0.1 (was 0.2): Dire Bear's x4.6 item armor at raid health and
    -- this profile's Stamina 1.0 -- the band-ladder armor math in Warrior.lua.
    ["FERAL_BEAR_TANK"] = {  ["ITEM_MOD_ARMOR_MODIFIER_SHORT"]=1.0, ["ITEM_MOD_ARMOR_SHORT"]=0.1, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=15.0, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5  },
    ["HYBRID_HOTW"] = { ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_ARMOR_SHORT"]=0.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_SPIRIT_SHORT"]=5.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=5.0 },
}

-- =============================================================
-- LEVELING WEIGHTS (Era Specific)
-- =============================================================
Druid.LevelingWeights = {
    -- Band ladder (Spirit/Mp5/Armor/Defense/school damage by level): see Warrior.lua's LevelingWeights.
    -- 1-10: caster form until Bear Form at 10 -- real weapon swings, so Weapon
    -- DPS counts; Strength is 2 AP and Agility gives no AP (crit/armor only).
    -- Attack Power 1.0 is the anchor.
    ["Leveling_1_10"]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=14.0, ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.0, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    -- 11-20 is Bear Form, not Cat: Forever teaches Bear Form at 10 but Cat
    -- Form not until 20 (wowforevertools ability data). Bear gets no Attack
    -- Power from Agility and ignores weapon damage, so Strength (2 AP) leads,
    -- Agility drops to Warrior's crit/dodge/armor value and Weapon DPS goes.
    -- Armor comes from Bear Form's own armor math (+180% armor from items) --
    -- see the band-ladder comment in Warrior.lua's LevelingWeights.
    ["Leveling_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.04, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.2, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0 },
    -- 21+ is Cat Form (learned at 20): Strength 2.0 / Agility 1.4 per the Cat
    -- AP formula in the comment above Druid.Weights' FERAL_CAT_DPS entry, and
    -- no Weapon DPS (form attacks ignore the weapon's damage).
    -- Hit/Crit were brought up to match Leveling_1_10/11_20's convention
    -- (entirely absent before; see Warrior.lua's leveling-bracket comment for
    -- the item-database evidence).
    ["Leveling_21_40"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=1.0 },
    ["Leveling_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.5, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=1.0 },
    ["Leveling_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.025, ["ITEM_MOD_STRENGTH_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.4, ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=20.0, ["ITEM_MOD_CRIT_RATING_SHORT"]=12.0, ["ITEM_MOD_WEAPON_SKILL_RATING_SHORT"]=13.0, ["ITEM_MOD_INTELLECT_SHORT"]=0.3, ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=1.0 },

    -- Bear Tank Leveling: matched to FERAL_BEAR_TANK's own endgame shape,
    -- which weights Dodge/Defense/a modest Hit instead of Weapon Skill --
    -- all three of those were entirely absent here before.
    -- 11-20 weights Defense low (see Warrior.lua's Leveling_Tank_11_20
    -- comment); Dodge Rating doesn't appear on 11-20 items.
    ["Leveling_Bear_11_20"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.08, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.25, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0 },
    ["Leveling_Bear_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.1, ["ITEM_MOD_SPIRIT_SHORT"]=0.8, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=4.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=0.5 },
    ["Leveling_Bear_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.17, ["ITEM_MOD_SPIRIT_SHORT"]=0.4, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=8.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.0 },
    ["Leveling_Bear_52_59"] = { ["ITEM_MOD_STAMINA_SHORT"]=2.0, ["ITEM_MOD_AGILITY_SHORT"]=1.5, ["ITEM_MOD_STRENGTH_SHORT"]=1.2, ["ITEM_MOD_ARMOR_SHORT"]=0.19, ["ITEM_MOD_SPIRIT_SHORT"]=0.2, ["ITEM_MOD_HIT_RATING_SHORT"]=10.0, ["ITEM_MOD_DODGE_RATING_SHORT"]=13.0, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.6 },

    -- Balance: matched to BALANCE_BOOMKIN's own endgame convention (Spell
    -- Hit/Crit were entirely absent here before)
    ["Leveling_Caster_11_20"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.4, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0 },
    ["Leveling_Caster_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.2, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=2.4, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=12.0 },
    ["Leveling_Caster_41_51"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.9, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=40.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=25.0, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.8 },
    ["Leveling_Caster_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_INTELLECT_SHORT"]=2.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=15.0, ["ITEM_MOD_SPIRIT_SHORT"]=0.6, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=45.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=30.0, ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=15.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2 },

    -- Restoration: matched to RESTO_DEEP's own endgame convention. Spell
    -- Healing was entirely absent -- a healer profile with zero credit for
    -- healing power -- and Spell Power/Intellect were still on the old
    -- compressed scale. 11-20 uses the same shape plus Mp5 at RESTO_DEEP's
    -- Mp5:Healing ratio.
    ["Leveling_Healer_11_20"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0 },
    ["Leveling_Healer_21_40"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=10.0 },
    ["Leveling_Healer_41_51"] = { ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0, ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0 },
    ["Leveling_Healer_52_59"] = { ["ITEM_MOD_ARMOR_SHORT"]=0.05, ["ITEM_MOD_SPIRIT_SHORT"]=1.0, ["ITEM_MOD_INTELLECT_SHORT"]=15.0, ["ITEM_MOD_SPELL_POWER_SHORT"]=20.0, ["ITEM_MOD_SPELL_HEALING_DONE_SHORT"]=20.0, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=48.0, ["ITEM_MOD_STAMINA_SHORT"]=1.0, ["ITEM_MOD_MANA_REGENERATION_SHORT"]=8.0 },
}

-- =============================================================
-- DISPLAY NAMES
-- =============================================================
Druid.PrettyNames = {
    ["BALANCE_BOOMKIN"]    = "DPS: Balance (Boomkin)",
    ["RESTO_DEEP"]         = "Healer: Deep Restoration",
    ["RESTO_MOONGLOW"]     = "Healer: Moonglow",
    ["RESTO_REGROWTH"]     = "Healer: Regrowth (Crit)",
    ["FERAL_CAT_DPS"]      = "DPS: Feral Cat",
    ["FERAL_BEAR_TANK"]    = "Tank: Feral Bear",
    ["HYBRID_HOTW"]        = "Hybrid: Heart of the Wild",
    
    ["Leveling_1_10"]       = "Leveling (1-10)",
    
    ["Leveling_11_20"]      = "Leveling: Bear Form (11-20)",
    ["Leveling_21_40"]      = "Leveling: Feral Cat (21-40)",
    ["Leveling_41_51"]      = "Leveling: Feral Cat (41-51)",
    ["Leveling_52_59"]      = "Leveling: Pre-BiS Feral (52-59)",
    
    ["Leveling_Bear_11_20"] = "Leveling: Bear Tank (11-20)",
    ["Leveling_Bear_21_40"] = "Leveling: Bear Tank (21-40)",
    ["Leveling_Bear_41_51"] = "Leveling: Bear Tank (41-51)",
    ["Leveling_Bear_52_59"] = "Leveling: Bear Tank (52-59)",
    
    ["Leveling_Caster_11_20"] = "Leveling: Balance (11-20)",
    ["Leveling_Caster_21_40"] = "Leveling: Balance (21-40)",
    ["Leveling_Caster_41_51"] = "Leveling: Balance (41-51)",
    ["Leveling_Caster_52_59"] = "Leveling: Pre-BiS Balance (52-59)",
    
    ["Leveling_Healer_11_20"] = "Leveling: Resto Healer (11-20)",
    ["Leveling_Healer_21_40"] = "Leveling: Resto Healer (21-40)",
    ["Leveling_Healer_41_51"] = "Leveling: Resto Healer (41-51)",
    ["Leveling_Healer_52_59"] = "Leveling: Pre-BiS Resto (52-59)",
}

-- =============================================================
-- WOW FOREVER TALENTS
-- =============================================================
Druid.Talents = { 
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
    ["WILD_GROWTH"]     = "Wild Growth",
    ["LIVING_SPIRIT"]   = "Living Spirit",
    ["NATURES_REACH"]   = "Nature's Reach",
    ["VENGEANCE"]       = "Vengeance", -- Balance t4, 5 ranks, +20%/rank crit damage bonus on Arcane/Nature spells
    ["MOONFURY"]        = "Moonfury", -- Balance t6, 5 ranks, +2%/rank Arcane/Nature spell damage
    ["GENESIS"]         = "Genesis", -- New in Forever, Balance t1, 5 ranks, +1%/rank periodic damage AND healing
    ["GIFT_OF_NATURE"]  = "Gift of Nature", -- Restoration t3, 5 ranks, +2%/rank universal healing (Same as Classic)
    ["PREDATORY_INSTINCTS"] = "Predatory Instincts", -- New in Forever, Feral t5, 2 ranks, +10%/rank melee crit damage bonus
    ["SAVAGE_FURY"]     = "Savage Fury", -- Feral t3, 2 ranks, +5%/rank Claw/Rake/Shred/Maul/Swipe damage
    ["NATURALIST"]      = "Naturalist", -- Restoration t2, 5 ranks, +1%/rank all damage dealt
    ["NATURES_FOCUS"]   = "Nature's Focus", -- Restoration t1, 5 ranks, pushback protection on Nature/Arcane casts
    ["SUBTLETY"]        = "Subtlety", -- Restoration t2, 3 ranks, Nature/Arcane threat reduction
    ["GIFT_OF_EARTHMOTHER"] = "Gift of the Earthmother", -- New in Forever, Restoration t3, 1 rank
    ["IMP_WRATH"]       = "Improved Wrath", -- Balance t1, 5 ranks
    ["IMP_MOONFIRE"]    = "Improved Moonfire", -- Balance t2, 2 ranks
}

-- Leveling role marker talents (see MSC:GetLowLevelRole). Furor is
-- deliberately not a Restoration marker -- nearly every leveling Druid takes
-- it -- and Genesis / Nature's Majesty aren't Balance markers because they
-- help Restoration and Feral too. Balance was otherwise only detected by
-- Moonkin Form (40+).
Druid.LowLevelRoles = {
    Leveling_Bear   = { "THICK_HIDE" },
    Leveling_Healer = { "NATURES_FOCUS", "SUBTLETY", "REFLECTION", "GIFT_OF_NATURE", "GIFT_OF_EARTHMOTHER" },
    Leveling_Caster = { "IMP_WRATH", "MOONGLOW", "IMP_MOONFIRE", "NATURES_REACH", "VENGEANCE", "MOONFURY" },
}

-- =============================================================
-- LOGIC
-- =============================================================
Druid.ValidWeapons = {
    [4]=true, [5]=true,   -- 1H/2H Maces
    [10]=true,            -- Staves
    [13]=true,            -- Fist Weapons
    [15]=true             -- Daggers
}

function Druid:GetSpec()
    local function Rank(k) return MSC:GetTalentRank(k) end
    local level = UnitLevel("player")
    
    -- Leveling Bracket Logic
    if level < 60 then
        local suffix = ""
        if level <= 10 then suffix = "_1_10"
        elseif level <= 20 then suffix = "_11_20"
        elseif level <= 40 then suffix = "_21_40"
        elseif level <= 51 then suffix = "_41_51"
        else suffix = "_52_59" end

        local role = "Leveling" -- Default to Cat
        if Rank("MOONKIN_FORM") > 0 then role = "Leveling_Caster"
        elseif Rank("SWIFTMEND") > 0 then role = "Leveling_Healer"
        elseif Rank("THICK_HIDE") >= 3 then role = "Leveling_Bear"
        elseif level > 10 then role = MSC:GetLowLevelRole(Druid.LowLevelRoles) or role
        end

        -- Not every role has every bracket (e.g. no Leveling_Caster_21_40);
        -- returning a missing key would leave the profile with no weights
        -- and silence every verdict, so fall back like the other classes do.
        local key = role .. suffix
        if Druid.LevelingWeights[key] then return key end
        return "Leveling" .. suffix
    end

    -- Endgame Spec Detection
    if Rank("MOONKIN_FORM") > 0 then return "BALANCE_BOOMKIN" end
    if Rank("WILD_GROWTH") > 0 then return "RESTO_DEEP" end
    if Rank("SWIFTMEND") > 0 and Rank("LEADER_OF_PACK") == 0 then return "RESTO_DEEP" end
    if Rank("MOONGLOW") > 0 and Rank("NATURES_SWIFT") > 0 then return "RESTO_MOONGLOW" end
    if Rank("IMP_REGROWTH") >= 3 then return "RESTO_REGROWTH" end
    if Rank("LEADER_OF_PACK") > 0 and Rank("NATURES_SWIFT") > 0 then return "HYBRID_HOTW" end
    
    -- Feral Split: Bear vs Cat
    if Rank("THICK_HIDE") >= 3 then return "FERAL_BEAR_TANK" end
    return "FERAL_CAT_DPS"
end

function Druid:ApplyScalers(weights, currentSpec)
    local function Rank(k) return MSC:GetTalentRank(k) end
    local activeCaps = {}
    -- Cat weights: FERAL_CAT_DPS plus the 21-40 / 41-51 / 52-59 default
    -- leveling brackets (Leveling_1_10 is pre-form and Leveling_11_20 is Bear)
    local isCat = currentSpec:find("CAT") or currentSpec:match("^Leveling_[245]%d_%d%d$")
    
    -- 1. Heart of the Wild
    local rHotW = Rank("HEART_WILD")
    if rHotW > 0 then
        if weights["ITEM_MOD_INTELLECT_SHORT"] then 
            weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.02)) 
        end
        -- upper(): the leveling profiles are "Leveling_Bear_*", not "BEAR".
        -- Leveling_11_20 is Bear Form weights too (no Cat Form until 20).
        if (currentSpec:upper():find("BEAR") or currentSpec == "Leveling_11_20") and weights["ITEM_MOD_STAMINA_SHORT"] then
            weights["ITEM_MOD_STAMINA_SHORT"] = weights["ITEM_MOD_STAMINA_SHORT"] * (1 + (rHotW * 0.04))
        end
        if (isCat or currentSpec:find("DPS")) and weights["ITEM_MOD_STRENGTH_SHORT"] then
            weights["ITEM_MOD_STRENGTH_SHORT"] = weights["ITEM_MOD_STRENGTH_SHORT"] * (1 + (rHotW * 0.02))
        end
    end
    
    local rLS = Rank("LIVING_SPIRIT")
    if rLS > 0 and weights["ITEM_MOD_SPIRIT_SHORT"] then
        weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * (1 + (rLS * 0.05))
    end

    -- Vengeance (Balance t4, 5 ranks): "Increases the critical strike damage
    -- bonus of your Arcane and Nature spells by 20%" -- same phrasing/math as
    -- Mage's Arcane Mind/Ice Shards -- 1+rank*0.20, reaching 2.0x at 5/5
    local rVengeance = Rank("VENGEANCE")
    if rVengeance > 0 and weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = weights["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] * (1 + (rVengeance * 0.20))
    end

    -- Moonfury (Balance t6, 5 ranks): +2%/rank Arcane/Nature spell damage
    local rMoonfury = Rank("MOONFURY")
    if rMoonfury > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
        weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rMoonfury * 0.02))
    end

    -- Genesis (New in Forever, Balance t1, 5 ranks): +1%/rank periodic damage
    -- AND healing -- applies to whichever weight the current spec carries
    local rGenesis = Rank("GENESIS")
    if rGenesis > 0 then
        if weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rGenesis * 0.01))
        end
        if weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
            weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rGenesis * 0.01))
        end
    end

    -- Gift of Nature (Restoration t3, 5 ranks, Same as Classic): +2%/rank
    -- universal healing done
    local rGoN = Rank("GIFT_OF_NATURE")
    if rGoN > 0 and weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
        weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rGoN * 0.02))
    end

    -- Naturalist (Restoration t2, 5 ranks): +1%/rank all damage dealt --
    -- applies to whichever damage weight the current spec carries
    local rNaturalist = Rank("NATURALIST")
    if rNaturalist > 0 then
        if weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rNaturalist * 0.01))
        end
        if weights["ITEM_MOD_ATTACK_POWER_SHORT"] then
            weights["ITEM_MOD_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (1 + (rNaturalist * 0.01))
        end
    end

    -- Predator's Instincts (New in Forever, Feral t5, 2 ranks): +10%/rank
    -- melee crit damage bonus -- only the Cat profiles track Attack Power/melee
    -- Crit meaningfully among the Feral profiles (Bear tank doesn't weight AP)
    local rPredInstincts = Rank("PREDATORY_INSTINCTS")
    if rPredInstincts > 0 and isCat and weights["ITEM_MOD_CRIT_RATING_SHORT"] then
        weights["ITEM_MOD_CRIT_RATING_SHORT"] = weights["ITEM_MOD_CRIT_RATING_SHORT"] * (1 + (rPredInstincts * 0.10))
    end

    -- Savage Fury (Feral t3, 2 ranks): +5%/rank Claw/Rake/Shred/Maul/Swipe
    -- damage -- same CAT-only gate as Predator's Instincts
    local rSavageFury = Rank("SAVAGE_FURY")
    if rSavageFury > 0 and isCat and weights["ITEM_MOD_ATTACK_POWER_SHORT"] then
        weights["ITEM_MOD_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (1 + (rSavageFury * 0.05))
    end

    -- 2. Covariance (Mana Regen / Healing Synergy)
    if currentSpec:find("RESTO") or currentSpec:find("Healer") then
        local healPower = MSC.SanitizeStat(GetSpellBonusHealing()) -- Using Classic API directly via shim usually preferred
        if healPower > 500 then
             local hScaler = 1 + ((healPower - 500) / 5000)
             weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * hScaler
        end
    end

    -- 3. Caps (Hit Cap 9%)
    local nrHit = Rank("NATURES_REACH") * 2
    if weights["ITEM_MOD_HIT_RATING_SHORT"] then
        -- FIX: Use Shim
        local currentHit = MSC:GetPlayerStat("HIT")
        if (currentHit + nrHit) >= 9 then
            weights["ITEM_MOD_HIT_RATING_SHORT"] = 2.0 -- Drop value
            table.insert(activeCaps, "Hit (9%)")
        end
    end
    if weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] then
        local spellHit = MSC:GetPlayerStat("SPELL_HIT")
        if (spellHit + nrHit) >= 16 then
            weights["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 1.0
            table.insert(activeCaps, "Spell Hit Cap")
        end
    end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Druid:GetWeaponBonus(itemLink, weights)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights)
end

function Druid:GetRelicBonus(itemID, currentSpec)
    local bonus = {}
    if Druid.Relics[itemID] then
        for k, v in pairs(Druid.Relics[itemID]) do bonus[k] = v end
    end
    return bonus
end

-- =============================================================
-- IDOLS
-- Wiped for the beta (2026-09-21): these were real TBC Idol item IDs. TBC
-- content isn't part of Forever, so this starts blank and repopulates
-- organically with confirmed Forever Idol IDs, same as the ProcDB/TrinketDB
-- cleanup above.
-- =============================================================
Druid.Relics = {}

-- Register Profiles
Druid.Profiles = {}
for k, v in pairs(Druid.Weights) do Druid.Profiles[k] = v end
for k, v in pairs(Druid.LevelingWeights) do Druid.Profiles[k] = v end

MSC.RegisterModule("DRUID", Druid)



