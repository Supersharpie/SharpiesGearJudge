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
    ["NATURAL_SHAPESHIFTER"] = "Natural Shapeshifter", -- Restoration t2, 3 ranks, -10%/rank shapeshift mana cost
    ["SHIFTING_POWER"]  = "Shifting Power", -- Feral t4, 1 rank (2 Oct patch): 55% base mana -> 40 Energy, 16 s cd
    ["IMP_SHIFTING_POWER"] = "Improved Shifting Power", -- Feral t5, 2 ranks: -4 s cooldown per rank
    ["PREDATORY_STRIKES"] = "Predatory Strikes", -- Feral t4 (minLevel 25), 3 ranks, +0.5 x level AP per rank in Cat/Bear
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
    [6]=true,             -- Polearms (Forever: learned at 20)
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
        elseif level >= 10 then role = MSC:GetLowLevelRole(Druid.LowLevelRoles) or role
        end

        -- Not every role has every bracket (e.g. no Leveling_Caster_21_40);
        -- returning a missing key would leave the profile with no weights
        -- and silence every verdict, so fall back like the other classes do.
        -- Level 10 brings the first talent point: a role it marks uses that
        -- role's 11-20 row (the 1-10 band only has the default row).
        if level == 10 and role ~= "Leveling" then suffix = "_11_20" end
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
    -- The default leveling line changes form by level, not by band: caster
    -- form to 9, Bear Form 10-19, Cat Form (learned at 20) from 20 on.
    local level = UnitLevel("player")
    local isCat = currentSpec:find("CAT") or currentSpec:match("^Leveling_[245]%d_%d%d$")
        or (currentSpec == "Leveling_11_20" and level >= 20)
    local isDefaultBear = (currentSpec == "Leveling_1_10" and level == 10)
        or (currentSpec == "Leveling_11_20" and level < 20)
    
    -- 1. Heart of the Wild
    local rHotW = Rank("HEART_WILD")
    if rHotW > 0 then
        if weights["ITEM_MOD_INTELLECT_SHORT"] then 
            weights["ITEM_MOD_INTELLECT_SHORT"] = weights["ITEM_MOD_INTELLECT_SHORT"] * (1 + (rHotW * 0.02)) 
        end
        -- upper(): the leveling profiles are "Leveling_Bear_*", not "BEAR".
        if (currentSpec:upper():find("BEAR") or isDefaultBear) and weights["ITEM_MOD_STAMINA_SHORT"] then
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

    -- Row families the talent hooks below route by. isBear is the leveling
    -- Bear rows plus the 10-19 default line (isDefaultBear above).
    local isBear = currentSpec:find("^Leveling_Bear") or isDefaultBear
    local isCasterRow = currentSpec:find("^Leveling_Caster")
    local isHealerRow = currentSpec:find("^Leveling_Healer")
    local isLevelingRow = currentSpec:find("^Leveling")
    local Keys = MSC.ScaleForeverKeys
    local touched = {}
    local function Touch(list) for _, k in ipairs(list) do touched[k] = true end end
    -- Melee offense keys a Cat/Bear damage talent scales together.
    local FERAL_OFFENSE = { "ITEM_MOD_ATTACK_POWER_SHORT", "ITEM_MOD_FERAL_ATTACK_POWER_SHORT", "ITEM_MOD_STRENGTH_SHORT",
        "ITEM_MOD_AGILITY_SHORT", "ITEM_MOD_CRIT_RATING_SHORT", "ITEM_MOD_HIT_RATING_SHORT" }
    local BEAR_STRIKES_KEYS = { "ITEM_MOD_CRIT_RATING_SHORT", "ITEM_MOD_HIT_RATING_SHORT", "ITEM_MOD_STAMINA_SHORT",
        "ITEM_MOD_HEALTH_SHORT", "ITEM_MOD_ARMOR_SHORT", "ITEM_MOD_DODGE_RATING_SHORT",
        "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", "ITEM_MOD_AGILITY_SHORT" }

    -- Natural Shapeshifter (Restoration t2, 3 ranks): -10% shapeshift mana
    -- cost per rank. The shift is ~55% of a Cat leveler's mana per kill, so
    -- every mana stat loses 5.5% of its value per rank.
    local rNatShift = Rank("NATURAL_SHAPESHIFTER")
    if rNatShift > 0 and isCat and isLevelingRow then
        Keys(weights, MSC.ForeverManaKeys, 1 - 0.055 * rNatShift)
        Touch(MSC.ForeverManaKeys)
    end

    -- Shifting Power (Feral t4, minLevel 25; new in the 2 Oct patch, 16 s
    -- cooldown): turns 55% of base mana into 40 Energy, so a Cat's spare mana
    -- becomes damage. Using it is mana-limited, not cooldown-limited, so each
    -- mana point is worth 40 / cost Energy: about 1.2 AP per Intellect at 30
    -- falling to 0.6 at 59, and Mp5 about 0.6 (the study's kill times, paw
    -- damage and special-attack damage per Energy), hedged x0.6 for players
    -- who don't spend every cooldown. Natural Shapeshifter makes it cheaper,
    -- so more Energy per mana. Spirit is left out: casting it starts the
    -- five-second rule.
    if Rank("SHIFTING_POWER") > 0 and isCat and isLevelingRow and level >= 25 then
        local cheaper = 1 / (1 - 0.1 * rNatShift)
        local addInt = MSC.ForeverLevelLerp({ { 30, 0.70 }, { 40, 0.52 }, { 50, 0.41 }, { 59, 0.38 } }, level) * cheaper
        local addMp5 = MSC.ForeverLevelLerp({ { 30, 0.39 }, { 59, 0.32 } }, level) * cheaper
        weights["ITEM_MOD_INTELLECT_SHORT"] = (weights["ITEM_MOD_INTELLECT_SHORT"] or 0) + addInt
        weights["ITEM_MOD_MANA_REGENERATION_SHORT"] = (weights["ITEM_MOD_MANA_REGENERATION_SHORT"] or 0) + addMp5
        Touch({ "ITEM_MOD_INTELLECT_SHORT", "ITEM_MOD_MANA_REGENERATION_SHORT" })
    end

    -- Predatory Strikes (Feral t4, minLevel 25, 3 ranks): +0.5 x level attack
    -- power per rank in Cat/Bear -- about +2.2% Cat damage (+1.5% Bear) per
    -- rank at every level.
    local rPredStrikes = Rank("PREDATORY_STRIKES")
    if rPredStrikes > 0 and level >= 25 and isLevelingRow then
        if isCat then
            -- Crit goes through the helper so Agility's crit share follows.
            MSC.ScaleForeverMeleeCrit(weights, 1 + 0.022 * rPredStrikes, level)
            Keys(weights, { "ITEM_MOD_HIT_RATING_SHORT" }, 1 + 0.022 * rPredStrikes)
            Touch({ "ITEM_MOD_CRIT_RATING_SHORT", "ITEM_MOD_HIT_RATING_SHORT", "ITEM_MOD_AGILITY_SHORT" })
        elseif isBear then
            -- Bigger damage makes every safety stat worth more against it;
            -- Strength/AP/Feral AP stay the unit.
            Keys(weights, BEAR_STRIKES_KEYS, 1 + 0.015 * rPredStrikes)
            Touch(BEAR_STRIKES_KEYS)
        end
    end

    -- Moonfury (Balance t6, 5 ranks): +2%/rank Arcane/Nature spell damage.
    -- Genesis (New in Forever, Balance t1, 5 ranks): +1%/rank periodic damage
    -- AND healing. Naturalist (Restoration t2, 5 ranks): +1%/rank all damage.
    -- Gift of Nature (Restoration t3, 5 ranks): +2%/rank universal healing.
    -- A flat damage/healing multiplier lifts every damage-derived stat
    -- equally, so the caster/healer leveling rows take it by dividing the
    -- safety stats (Agility included) instead of scaling Spell Power or
    -- Healing; endgame specs keep the plain scaling.
    local rMoonfury = Rank("MOONFURY")
    local rGenesis = Rank("GENESIS")
    local rGoN = Rank("GIFT_OF_NATURE")
    local rNaturalist = Rank("NATURALIST")
    if isCasterRow then
        -- Genesis at 0.3 of nominal: DoTs are ~25-35% of modelled damage.
        local m = (1 + 0.02 * rMoonfury) * (1 + 0.01 * rNaturalist) * (1 + 0.003 * rGenesis)
        MSC.ApplyForeverDamageMult(weights, m, { "ITEM_MOD_AGILITY_SHORT" })
        Touch(MSC.ForeverSafetyKeys)
        Touch({ "ITEM_MOD_AGILITY_SHORT" })
    elseif isHealerRow then
        -- Genesis at 0.4 of nominal: HoTs and Wild Growth are ~40% of healing.
        local m = (1 + 0.02 * rGoN) * (1 + 0.004 * rGenesis) * (1 + 0.01 * rNaturalist)
        MSC.ApplyForeverDamageMult(weights, m, { "ITEM_MOD_AGILITY_SHORT" })
        Touch(MSC.ForeverSafetyKeys)
        Touch({ "ITEM_MOD_AGILITY_SHORT" })
    else
        if rMoonfury > 0 and weights["ITEM_MOD_SPELL_POWER_SHORT"] then
            weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rMoonfury * 0.02))
        end
        if rGenesis > 0 then
            if weights["ITEM_MOD_SPELL_POWER_SHORT"] then
                weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rGenesis * 0.01))
            end
            if weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
                weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rGenesis * 0.01))
            end
        end
        if rGoN > 0 and weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] then
            weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] = weights["ITEM_MOD_SPELL_HEALING_DONE_SHORT"] * (1 + (rGoN * 0.02))
        end
        if rNaturalist > 0 then
            if (isCat or isBear) and isLevelingRow then
                -- Feral rows: the melee offense keys plus Spell Power.
                local f = 1 + 0.01 * rNaturalist
                Keys(weights, FERAL_OFFENSE, f)
                Keys(weights, { "ITEM_MOD_SPELL_POWER_SHORT" }, f)
                Touch(FERAL_OFFENSE)
            else
                if weights["ITEM_MOD_SPELL_POWER_SHORT"] then
                    weights["ITEM_MOD_SPELL_POWER_SHORT"] = weights["ITEM_MOD_SPELL_POWER_SHORT"] * (1 + (rNaturalist * 0.01))
                end
                if weights["ITEM_MOD_ATTACK_POWER_SHORT"] then
                    weights["ITEM_MOD_ATTACK_POWER_SHORT"] = weights["ITEM_MOD_ATTACK_POWER_SHORT"] * (1 + (rNaturalist * 0.01))
                end
            end
        end
    end

    -- Reflection (Restoration t3, 3 ranks, minLevel 20): 17% of mana regen
    -- continues while casting per rank. The Healer anchors bake rb(L): 0 to
    -- 15, 1 at 20, 3 from 25; Spirit and Intellect move with the gap.
    if isHealerRow then
        local rReflection = Rank("REFLECTION")
        local rb = MSC.ForeverLevelLerp({ {15, 0}, {20, 1}, {25, 3} }, level)
        if rReflection ~= rb then
            Keys(weights, { "ITEM_MOD_SPIRIT_SHORT" }, (0.70 + 0.10 * rReflection) / (0.70 + 0.10 * rb))
            Keys(weights, { "ITEM_MOD_INTELLECT_SHORT" }, 1 + 0.04 * (rb - rReflection))
            Touch({ "ITEM_MOD_SPIRIT_SHORT", "ITEM_MOD_INTELLECT_SHORT" })
        end
    end

    -- Predator's Instincts (New in Forever, Feral t5, 2 ranks): +10%/rank
    -- melee crit damage bonus -- Cat and Bear leveling rows both carry Crit.
    -- The helper also moves Agility's crit share.
    local rPredInstincts = Rank("PREDATORY_INSTINCTS")
    if rPredInstincts > 0 and (isCat or isBear) then
        MSC.ScaleForeverMeleeCrit(weights, 1 + 0.10 * rPredInstincts, level)
        Touch({ "ITEM_MOD_CRIT_RATING_SHORT", "ITEM_MOD_AGILITY_SHORT" })
    end

    -- Savage Fury (Feral t3, 2 ranks): +5%/rank Claw/Rake/Shred/Maul/Swipe
    -- damage, ~40% of Cat damage (Maul in Bear) -- +2% per rank on the
    -- offense keys, Bear Agility at half that.
    local rSavageFury = Rank("SAVAGE_FURY")
    if rSavageFury > 0 and (isCat or isBear) then
        Keys(weights, FERAL_OFFENSE, 1 + 0.02 * rSavageFury)
        if isBear and not isCat then
            -- FERAL_OFFENSE took Agility at the full +2%: pull it back to +1%.
            Keys(weights, { "ITEM_MOD_AGILITY_SHORT" }, (1 + 0.01 * rSavageFury) / (1 + 0.02 * rSavageFury))
        end
        Touch(FERAL_OFFENSE)
    end

    -- Weights under 0.02 are noise to the scorer: zero what the talent
    -- hooks shrank into that band.
    for k in pairs(touched) do
        local v = weights[k]
        if v and v > 0 and v < 0.02 then weights[k] = 0 end
    end

    -- 2. Covariance (Mana Regen / Healing Synergy)
    if currentSpec:find("RESTO") or currentSpec:find("Healer") then
        local healPower = MSC.SanitizeStat(GetSpellBonusHealing()) -- Using Classic API directly via shim usually preferred
        if healPower > 500 then
             local hScaler = 1 + ((healPower - 500) / 5000)
             weights["ITEM_MOD_SPIRIT_SHORT"] = weights["ITEM_MOD_SPIRIT_SHORT"] * hScaler
        end
    end

    -- 3. Caps
    -- Nature's Reach (+2% hit per rank, all attacks) is already in the game's
    -- hit numbers read by MSC:GetForeverHitPercent. Targets are the level's
    -- caps, sliding to the raid caps from 50; past a cap Hit keeps 10% of
    -- its value (the same for every class).
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_RATING_SHORT", "MELEE", 0.1, "Hit", activeCaps)
    MSC.ApplyForeverHitCap(weights, "ITEM_MOD_HIT_SPELL_RATING_SHORT", "SPELL", 0.1, "Spell Hit", activeCaps)
    -- Bear: defense toward 440 from 50 (bears can't block, so no uncrushable)
    if currentSpec:upper():find("BEAR") then MSC.ApplyForeverDefenseTarget(weights, activeCaps) end

    return weights, (#activeCaps > 0 and table.concat(activeCaps, ", ") or nil)
end

function Druid:GetWeaponBonus(itemLink, weights, slotId, specName, otherHandLink)
    return MSC.GetForeverWeaponRacialBonus(itemLink, weights, otherHandLink)
end

function Druid:GetRelicBonus(itemID, currentSpec)
    return MSC.GetForeverRelicBonus(Druid.Relics, itemID, currentSpec)
end

-- =============================================================
-- IDOLS
-- Wiped for the beta (2026-09-21): these were real TBC Idol item IDs. TBC
-- content isn't part of Forever, so this starts blank and repopulates
-- organically with confirmed Forever Idol IDs, same as the ProcDB/TrinketDB
-- cleanup above.
-- =============================================================
-- Forever idols as equivalent stats per spec (MSC.GetForeverRelicBonus).
-- role: "melee" (Cat/default feral line), "tank" (Bear), "caster", "healer".
-- Mana savings become Mp5; small cooldown/duration effects get a hand-set
-- equivalent for the spec that uses them (estimates, not modeled).
Druid.Relics = {
    -- Windcharged Leaf: shapeshift cost -40. Feral levelers shift about once
    -- a minute (40 mana/min = 3.3 Mp5); casters rarely.
    [263411] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "melee" or role == "tank") and 3.3 or 1 } end,
    -- Mark of Urs'endris: +4% armor from items
    [263435] = function(role, ctx) return { ITEM_MOD_ARMOR_SHORT = 0.04 * ctx.itemArmor } end,
    -- Mystic Mushroom: +5% Spirit
    [249396] = function(role, ctx) return { ITEM_MOD_SPIRIT_SHORT = 0.05 * ctx.spirit } end,
    -- Talons of Wrath: Wrath 50% chance to restore 35 mana. A Balance leveler
    -- casts Wrath about a quarter of the time it's fighting: ~13 Mp5.
    [249441] = function(role) return { ITEM_MOD_MANA_REGENERATION_SHORT = (role == "caster") and 13 or 1 } end,
    -- Howling Idol: Tiger's Fury cooldown -3 sec. Tiger's Fury was removed
    -- from Forever in the 2 Oct patch, so the idol does nothing now.
    [272427] = {},
    -- Enraged Idol: Enrage +10 rage (Bear)
    [272428] = function(role) return (role == "tank") and { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 15 } or {} end,
    -- Idol of Synthesis: Swiftmend cooldown -1 sec per HoT on the target
    [272429] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 20 } or {} end,
    -- Swarming Idol: Insect Swarm +2 sec
    [272430] = function(role) return (role == "caster") and { ITEM_MOD_SPELL_POWER_SHORT = 5 } or {} end,
    -- Idol of Swiftness: Swiftmend cooldown -3 sec
    [279250] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 30 } or {} end,
    -- Idol of the Ursine Twins: Lacerate 10% chance to reset Mangle (Bear)
    [279251] = function(role) return (role == "tank") and { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 30 } or {} end,

    -- Unchanged Classic idols (Wowhead Classic data). Single-spell bonuses
    -- count at that spell's share of the spec's healing/damage/mana use.
    -- Idol of Ferocity: Claw and Rake cost 3 less energy (~4% more Cat damage)
    [22397] = function(role, ctx) return (role == "melee") and { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = math.max(15, 0.03 * ctx.ap) } or {} end,
    -- Idol of Rejuvenation: Rejuvenation heals up to 50 more (~35% of healing)
    [22398] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 17.5 } or {} end,
    -- Idol of Health: Healing Touch cast time -0.15 sec (~2% more healing)
    [22399] = function(role) return (role == "healer") and { ITEM_MOD_SPELL_HEALING_DONE_SHORT = 25 } or {} end,
    -- Idol of Longevity: up to 25 mana back per Healing Touch
    [23004] = function(role) return (role == "healer") and { ITEM_MOD_MANA_REGENERATION_SHORT = 8 } or {} end,
    -- Idol of the Moon: Moonfire deals up to 33 more (~25% of a Balance
    -- Druid's damage)
    [23197] = function(role) return (role == "caster") and { ITEM_MOD_SPELL_POWER_SHORT = 8 } or {} end,
    -- Idol of Brutality: Maul and Swipe cost 3 less rage (Bear)
    [23198] = function(role) return (role == "tank") and { ITEM_MOD_FERAL_ATTACK_POWER_SHORT = 20 } or {} end,
}

-- Register Profiles
Druid.Profiles = {}
for k, v in pairs(Druid.Weights) do Druid.Profiles[k] = v end
for k, v in pairs(Druid.LevelingWeights) do Druid.Profiles[k] = v end

MSC.RegisterModule("DRUID", Druid)



