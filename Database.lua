local _, MSC = ...

-- =============================================================
-- 1. STAT WEIGHTS (TBC Smart Leveling Edition - REVISED)
-- =============================================================
MSC.WeightDB = {
["WARRIOR"] = {
        -- ========================================================
        -- LEVEL 70 RAIDING (TBC)
        -- ========================================================
        -- Default: Fallback for un-specced or unknown situations.
        ["Default"]    = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0 
        },

        -- ARMS: The "Slam" Spec. Needs ArPen and Burst.
        ["Arms"]       = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.5, -- Weapon Dmg is vital for Mortal Strike
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=1.6, -- Huge in TBC
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8, -- 1.8x Weight ensures Racial Weapons win
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5,
            ["ITEM_MOD_AGILITY_SHORT"]=0.8 
        },

        -- FURY: The "Dual Wield" Spec. Needs Hit (Soft Cap) and Expertise.
        ["Fury"]       = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.2, -- Misses destroy rage gen
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.2, -- Dodge/Parry reduction is critical
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.3,
            ["ITEM_MOD_AGILITY_SHORT"]=0.9
        },

        -- PROTECTION: TBC Tanking (Crushing Blows matter).
        ["Protection"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=2.5, -- Effective Health is King
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, -- Reach 490 Cap
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8, -- Threat (reduces Parry-Haste by boss)
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, -- Threat
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.2, -- Shield Slam scaling
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.3, 
            ["ITEM_MOD_PARRY_RATING_SHORT"]=1.3,
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, -- Armor + Dodge
            ["ITEM_MOD_STRENGTH_SHORT"]=0.5 
        },

        -- ========================================================
        -- SMART LEVELING (1-69)
        -- ========================================================
        
        -- 1-20: SURVIVAL & REGEN
        -- Warriors have no self-heal. Spirit reduces "Eating Time" significantly.
        -- Weapon DPS is the only stat that truly speeds up kills here.
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0, -- Highly weighted for leveling efficiency
            ["ITEM_MOD_AGILITY_SHORT"]=0.8 
        },

        -- 21-40: WHIRLWIND AXE ERA
        -- You have "Sweeping Strikes" & "Whirlwind". Slow, high-damage weapons rule.
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, -- Crit triggers 'Flurry'
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        },

        -- 41-57: PRE-OUTLAND
        -- Prepare for Mortal Strike (Lv 40). Hit Rating starts appearing on gear.
        ["Leveling_41_57"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0 
        },

        -- 58-69: OUTLAND (HELLFIRE -> SHADOWMOON)
        -- Mobs hit harder. TBC Stats (Expertise) appear. 
        -- You need Stamina to survive accidental multi-pulls in Hellfire.
        ["Leveling_58_69"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, -- Bumped for Hellfire survival
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8 -- If you are Orc/Human, this makes specific weapons god-tier
        },
    },
    ["PALADIN"] = {
        -- ========================================================
        -- LEVEL 70 RAIDING (TBC)
        -- ========================================================
        ["Default"]     = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8 
        },

        -- HOLY: Illumination (Mana on Crit) is the engine of this spec.
        ["Holy"]        = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.8, -- Critical for Mana Sustain
            ["ITEM_MOD_INTELLECT_SHORT"]=1.6, -- Mana Pool + Spell Crit
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.2 
        },

        -- PROTECTION: The "AoE Tank". Needs Spell Power for Threat.
        ["Protection"]  = { 
            ["ITEM_MOD_STAMINA_SHORT"]=2.8, -- Effective Health
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=2.0, -- Reach 490 Defense Cap
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, -- Massive Threat (Consecration/Holy Shield)
            ["ITEM_MOD_BLOCK_VALUE_SHORT"]=1.4, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2, -- For Taunts/Exorcism
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.2,
            ["ITEM_MOD_PARRY_RATING_SHORT"]=1.2,
            ["ITEM_MOD_STRENGTH_SHORT"]=0.5 
        },

        -- RETRIBUTION: Seal of Blood/Command. Weapon Dmg is king.
        ["Retribution"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.5, -- Crusader Strike / Seals Scale hard
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, -- Vengeance Uptime
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=0.9, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.8 
        },

        -- ========================================================
        -- SMART LEVELING (1-69)
        -- ========================================================

        -- 1-20: SEAL OF RIGHTEOUSNESS
        -- Paladins suffer from mana issues early. Spirit helps reduce downtime.
        -- Auto-Attack DPS is your primary damage source.
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0 
        },

        -- 21-40: SEAL OF COMMAND
        -- Slow 2H Weapons are mandatory for SoC. 
        -- Scoring.lua handles the speed check, we handle the stats.
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },

        -- 41-57: VENGEANCE ERA
        -- You need Crit to keep the Vengeance buff (15% dmg) active.
        ["Leveling_41_57"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5 
        },

        -- 58-69: OUTLAND
        -- Crusader Strike (Lv 50 Talent) makes Weapon DPS even more valuable.
        ["Leveling_58_69"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0 -- Helps with Judgement/Exorcism scaling
        },
    },
    ["PRIEST"] = {
        -- ========================================================
        -- LEVEL 70 RAIDING (TBC)
        -- ========================================================
        ["Default"]    = { 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.2 
        },

        -- DISCIPLINE: Improved Divine Spirit / Pain Suppression.
        -- High Int for mana pool, Spirit for regen/buffs.
        ["Discipline"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.6, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, -- Imp Divine Spirit
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },

        -- HOLY: Circle of Healing / CoH Spam.
        -- Spirit is massive (Spiritual Guidance). Haste is great for GCD reduction later.
        ["Holy"]       = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, -- Spiritual Guidance (25% Spirit -> SP)
            ["ITEM_MOD_INTELLECT_SHORT"]=1.4, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.2 
        },

        -- SHADOW: The "Mana Battery".
        -- Damage = Mana for party. Hit Cap is #1 priority until capped.
        ["Shadow"]     = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=2.0, -- Mandatory for Raids
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8 
        },

        -- ========================================================
        -- SMART LEVELING (1-69)
        -- ========================================================

        -- 1-20: WAND SPECIALIZATION
        -- Your wand does more DPS than your spells.
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.5, -- Wand DPS is everything
            ["ITEM_MOD_SPIRIT_SHORT"]=2.0, -- Spirit Tap
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },

        -- 21-40: SPIRIT TAP SUSTAIN
        -- Wands still strong, but you need Spirit to never stop pulling.
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_SPIRIT_SHORT"]=2.2, -- Never eat/drink again
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0 
        },

        -- 41-57: SHADOWFORM
        -- Shadow Dmg becomes the primary kill stat.
        ["Leveling_41_57"] = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0 
        },

        -- 58-69: OUTLAND (Vampiric Touch)
        -- DoTs tick harder. Stamina needed for survival.
        ["Leveling_58_69"] = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, -- Survival in Hellfire
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2 
        },
    },
["ROGUE"] = {
        -- ========================================================
        -- LEVEL 70 RAIDING (TBC)
        -- ========================================================
        ["Default"]       = { 
            ["ITEM_MOD_AGILITY_SHORT"]=1.6, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0 
        },

        -- ASSASSINATION: Mutilate / Seal Fate.
        -- Crit generates Combo Points. Hit ensures Poisons land.
        ["Assassination"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.8, -- Dagger DPS
            ["ITEM_MOD_AGILITY_SHORT"]=1.7, -- Main scaler
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, -- Seal Fate (Crit = 2 CP)
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.6, -- Poison Hit Cap is vital
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.1, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.2 
        },

        -- COMBAT: Swords / Glaives.
        -- Expertise is massive (Human Racial + Weapon Mastery). Haste scales white dmg.
        ["Combat"]        = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.2, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.2, -- Huge stat for Combat
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, -- Dual Wield Miss penalty
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.6, -- Scales Blade Flurry
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=0.8 
        },

        -- SUBTLETY: Hemo / PvP Burst.
        -- High Agi/AP for big openers. Resilience included for PvP checks.
        ["Subtlety"]      = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, -- Sinister Calling (+15% Agi)
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=1.5, -- Burst damage
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },

        -- ========================================================
        -- SMART LEVELING (1-69)
        -- ========================================================

        -- 1-20: GOUGE & BANDAGE
        -- You have no self-sustain. Spirit helps HP regen between kills.
        -- Weapon DPS is the only thing that matters for Sinister Strike.
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0 -- Reduces downtime significantly
        },

        -- 21-40: RIPOSTE & DUAL WIELD
        -- You get Dual Wield at 10, but the miss penalty hurts. Hit starts helping.
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        },

        -- 41-57: COMBAT POTENCY / ADRENALINE RUSH
        -- Fast Off-hand needed. AP/Crit start scaling well.
        ["Leveling_41_57"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2 
        },

        -- 58-69: OUTLAND
        -- Mobs hit harder. Evasion helps, but Stamina prevents 2-shot deaths.
        -- Expertise starts appearing on dungeon gear.
        ["Leveling_58_69"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.5 
        },
    },
    ["HUNTER"] = {
        -- ========================================================
        -- LEVEL 70 RAIDING (TBC)
        -- ========================================================
        ["Default"]      = { 
            ["ITEM_MOD_AGILITY_SHORT"]=1.5, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.0 
        },

        -- BEAST MASTERY: The TBC King.
        -- Haste speeds up Auto-Shot -> More Crits -> More Pet Focus (Go for the Throat).
        ["BeastMastery"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, -- Auto Shot is huge
            ["ITEM_MOD_AGILITY_SHORT"]=1.6, 
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.8, -- Serpent's Swiftness synergy
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, -- Cap is vital so Pet hits land
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6 
        },

        -- MARKSMANSHIP: Physical Sniper.
        -- Armor Pen is massive for Aimed/Steady/Multi-Shot.
        ["Marksmanship"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.2, -- Weapon Dmg scales abilities
            ["ITEM_MOD_AGILITY_SHORT"]=1.6, 
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=1.8, -- Primary Stat
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.1, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8 -- Careful Aim (Int -> AP)
        },

        -- SURVIVAL: The "Raid Buffer".
        -- Expose Weakness converts % of your Agility to Raid AP.
        ["Survival"]     = { 
            ["ITEM_MOD_AGILITY_SHORT"]=2.5, -- STACK AGILITY ABOVE ALL ELSE
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, -- To proc Expose Weakness
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, -- Survivalist Talent (+HP)
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=0.8, -- Raw AP is less valuable than Agi
            ["ITEM_MOD_INTELLECT_SHORT"]=0.6 
        },

        -- ========================================================
        -- SMART LEVELING (1-69)
        -- ========================================================

        -- 1-20: RAPTOR STRIKE / KITING
        -- You clip auto-shots constantly. Raw weapon DPS is the only reliable scaler.
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.6, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, -- Needed for Mend Pet mana
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        },

        -- 21-40: ASPECT OF THE CHEETAH
        -- You start using Multi-Shot/Arcane Shot more. OOM is a real threat.
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, -- Bumped to keep uptime high
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.5 
        },

        -- 41-57: BESTIAL WRATH ERA
        -- Your pet does the work. You just need to auto-shot hard.
        ["Leveling_41_57"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=2.0, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.2, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.2 
        },

        -- 58-69: OUTLAND (STEADY SHOT)
        -- Steady Shot rotation begins. You need Mana (Int) and Attack Power.
        ["Leveling_58_69"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.5, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, 
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.4, -- Steady Shot scaling
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, -- Aspect of the Viper helps, but Int still needed
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5 
        },
    },
    ["MAGE"] = {
        -- ========================================================
        -- LEVEL 70 RAIDING (TBC)
        -- ========================================================
        ["Default"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0 
        },

        -- ARCANE: Arcane Blast spam.
        -- Intellect gives % Spell Power (Mind Mastery) and Mana Pool.
        ["Arcane"]  = { 
            ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.6, -- Mind Mastery (15% Int -> SP)
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.4, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.2 
        },

        -- FIRE: Ignite / Rolling Scorch.
        -- Crit is massive for Combustion consistency.
        ["Fire"]    = { 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.6, -- Ignite/Master of Elements
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.3, -- Fireball cast time
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5 
        },

        -- FROST: Water Elemental / Shatter.
        -- Solid control/survival.
        ["Frost"]   = { 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.6, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.3 
        },

        -- ========================================================
        -- SMART LEVELING (1-69)
        -- ========================================================

        -- 1-20: WAND & REGEN
        -- Wand DPS is your finisher. Spirit helps reduce drinking time.
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.0, -- Mage Armor (Lv 34) isn't here yet, but Spirit helps out of combat
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },

        -- 21-40: AOE POTENTIAL
        -- Blizzard kiting requires Mana (Int) and Health (Stam) for mistakes.
        -- Mage Armor (Lv 34) makes Spirit useful in combat (30%).
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.8, -- Mana pool is vital
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, -- AoE Survival
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=1.5, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8, -- Mage Armor active
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=1.0 -- Wands fall off slightly
        },

        -- 41-57: SHATTER / COMBUSTION
        -- You kill fast with talents. Spell Power starts scaling.
        ["Leveling_41_57"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_FROST_DAMAGE_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },

        -- 58-69: OUTLAND
        -- High spell power gear available. Hit rating starts mattering.
        ["Leveling_58_69"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=2.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.4, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2 
        },
    },
    ["WARLOCK"] = {
        -- ========================================================
        -- LEVEL 70 RAIDING (TBC)
        -- ========================================================
        ["Default"]     = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2 
        },

        -- AFFLICTION: UA / DoT Rot.
        -- Shadow Dmg and Hit are paramount.
        ["Affliction"]  = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.8, -- 16% Cap needed
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },

        -- DEMONOLOGY: Felguard.
        -- Pet scales with your stats.
        ["Demonology"]  = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.6, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, -- Demonic Knowledge (Stam/Int -> SP)
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.2 
        },

        -- DESTRUCTION: Shadow Bolt Spam (0/21/40).
        -- Crit triggers Improved Shadow Bolt (+20% Dmg). Haste scales SB well.
        ["Destruction"] = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_FIRE_DAMAGE_SHORT"]=2.0, -- Incinerate builds exist, but Shadow is meta
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.6, -- ISB Uptime + Ruin
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8 
        },

        -- TANK: Leotheras / Illidan Tanking.
        -- High Stamina + Mitigation.
        ["Tank"]        = { 
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, 
            ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"]=3.0, 
            ["ITEM_MOD_FIRE_RESISTANCE_SHORT"]=3.0, 
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"]=2.0, -- Crit Immunity
            ["ITEM_MOD_ARMOR_SHORT"]=1.0, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0 -- Threat (Searing Pain)
        },

        -- ========================================================
        -- SMART LEVELING (1-69)
        -- ========================================================

        -- 1-20: WAND SPECIALIZATION
        -- Life Tap gives Mana, but costs Health. Wand saves both.
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.5, -- Wand DPS
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, -- Life Tap fuel
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8 
        },

        -- 21-40: DRAIN TANKING
        -- You face-tank mobs while Draining Life. Stamina = Efficiency.
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STAMINA_SHORT"]=2.0, -- Primary stat for Drain Tanking
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=1.8, -- Scales Drain Life
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=1.0 -- Spells take priority now
        },

        -- 41-57: DARK PACT / SIPHON LIFE
        -- You become a perpetual motion machine.
        ["Leveling_41_57"] = { 
            ["ITEM_MOD_SHADOW_DAMAGE_SHORT"]=2.2, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8 
        },

        -- 58-69: OUTLAND (FELGUARD)
        -- If Demo (Felguard), stats scale the pet. If Affliction, UA hits hard.
        ["Leveling_58_69"] = { 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.5, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=1.2 
        },
    },
["SHAMAN"] = {
        -- ========================================================
        -- LEVEL 70 RAIDING (TBC)
        -- ========================================================
        ["Default"]     = { 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0,
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0,
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.0 
        },

        -- ELEMENTAL: Lightning Bolt / Chain Lightning.
        -- Hit Cap is mandatory. Crit fuels "Lightning Overload" (extra spells).
        ["Elemental"]   = { 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=2.0, -- Reach 16% Cap ASAP
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.4, -- Lightning Overload / Elemental Focus
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0 -- Crit + Mana
        },

        -- ENHANCEMENT: Dual Wield / Stormstrike.
        -- Expertise is huge (Dodge/Parry = No Windfury).
        -- Hit Rating vital for White Damage (Flurry uptime) and Shamanistic Rage returns.
        ["Enhancement"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.2, -- Weapon DPS is paramount
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=2.2, -- Huge for consistency
            ["ITEM_MOD_HIT_RATING_SHORT"]=2.0, -- Dual Wield Miss penalty is harsh
            ["ITEM_MOD_STRENGTH_SHORT"]=1.6, -- 1 Str = 2 AP
            ["ITEM_MOD_ATTACK_POWER_SHORT"]=1.0, 
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.3, -- Flurry / Unleashed Rage
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, -- Crit + Armor
            ["ITEM_MOD_HASTE_RATING_SHORT"]=1.1, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.5 -- Mana pool only (AP comes from Str/AP)
        },

        -- RESTORATION: Chain Heal Spam.
        -- Healing Power is the best throughput stat. Haste lowers Chain Heal cast time.
        ["Restoration"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.8, -- Mana Tide / Constant casting
            ["ITEM_MOD_INTELLECT_SHORT"]=1.4, -- Mana Pool + Crit (Ancestral Awakening later)
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.5, -- Great for Chain Heal throughput
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.0 
        },

        -- ========================================================
        -- SMART LEVELING (1-69)
        -- ========================================================

        -- 1-20: ROCKBITER ERA
        -- You usually use a Shield or 2H Staff. 
        -- Shocks do high damage, so Intellect helps, but Melee DPS is king.
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0, -- For Shocks/Heals
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8 -- Regen is nice
        },

        -- 21-39: WINDFURY 2-HANDER ERA
        -- Windfury (Lv 30) favors slow, hard-hitting 2H weapons. 
        -- Strength/Agility take priority over Int as you rely less on shocks.
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=3.0, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.2, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0 
        },

        -- 40-57: DUAL WIELD SWITCH
        -- At Lv 40, you talent into Dual Wield. You NEED Hit Rating now.
        -- Crit becomes important to maintain Flurry (30% atk speed).
        ["Leveling_41_57"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.8, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, -- Miss penalty hurts
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, -- Flurry Uptime
            ["ITEM_MOD_AGILITY_SHORT"]=1.2 
        },

        -- 58-69: OUTLAND (STORMSTRIKE)
        -- Stormstrike (Lv 50) hits with both weapons.
        -- Expertise starts appearing on gear (Lower City rep, etc).
        ["Leveling_58_69"] = { 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=2.8, 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.4, 
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.5 -- Keeps DPS consistent
        },
    },
["DRUID"] = {
        -- ========================================================
        -- LEVEL 70 RAIDING (TBC)
        -- ========================================================
        ["Default"]     = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.0, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=1.0 
        },

        -- BALANCE: Starfire Turret.
        -- Hit Cap (16%) is vital. Crit scales well with Vengeance (100% bonus crit dmg).
        ["Balance"]     = { 
            ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]=2.0, -- Reach Cap
            ["ITEM_MOD_ARCANE_DAMAGE_SHORT"]=1.8, 
            ["ITEM_MOD_NATURE_DAMAGE_SHORT"]=1.8, 
            ["ITEM_MOD_SPELL_POWER_SHORT"]=1.5, 
            ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]=1.4, -- Vengeance Talent
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, -- Lunar Guidance (Int -> SP)
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.2 
        },

        -- FERAL COMBAT: Cat DPS.
        -- Weapon DPS = 0. You need Feral AP, Strength, and Agility.
        ["FeralCombat"] = { 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=2.5, -- The only "Weapon Dmg" that matters
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, -- 1 Agi = 1 AP + Crit (Kings/Survival scales it)
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, -- 1 Str = 2 AP
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.5, -- 9% Cap
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"]=1.5, -- Dodge reduction
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.4, -- Primal Fury (Crit = 2 CP)
            ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"]=1.4,
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=0 -- FORMS DON'T USE WEAPON DAMAGE
        },

        -- RESTORATION: Tree of Life.
        -- Spirit is your best stat (Tree Aura + Intensity).
        ["Restoration"] = { 
            ["ITEM_MOD_HEALING_POWER_SHORT"]=2.2, 
            ["ITEM_MOD_SPIRIT_SHORT"]=1.8, -- Tree of Life (Spirit -> Healing)
            ["ITEM_MOD_SPELL_HASTE_RATING_SHORT"]=1.4, -- GCD reduction for HoTs
            ["ITEM_MOD_INTELLECT_SHORT"]=1.2, 
            ["ITEM_MOD_MANA_REGENERATION_SHORT"]=1.0 
        },

        -- TANK: Bear Form.
        -- Armor and Stamina are multiplied in Bear Form.
        ["Tank"]        = { 
            ["ITEM_MOD_STAMINA_SHORT"]=3.0, -- Bear Form Multiplier
            ["ITEM_MOD_ARMOR_SHORT"]=2.5, -- Bear Form Multiplier (400%)
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, -- Dodge + Armor
            ["ITEM_MOD_DODGE_RATING_SHORT"]=1.8, 
            ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]=1.5, -- Crit Immunity
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=1.0, -- Threat
            ["ITEM_MOD_HIT_RATING_SHORT"]=1.2, -- Threat
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=0 
        },

        -- ========================================================
        -- SMART LEVELING (1-69)
        -- ========================================================

        -- 1-20: BEAR / CASTER HYBRID
        -- You will melee in caster form or Bear. Weapon DPS helps slightly in caster form,
        -- but stats are king.
        ["Leveling_1_20"]  = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.0, 
            ["ITEM_MOD_INTELLECT_SHORT"]=0.8, -- For shifting mana
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=0.5 -- Low weight, switch to Bear mostly
        },

        -- 21-40: CAT FORM SPEED
        -- You are now a Cat. Weapon DPS is officially useless. 
        -- Stack Str/Agi to kill faster.
        ["Leveling_21_40"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, -- Raw AP
            ["ITEM_MOD_AGILITY_SHORT"]=1.6, -- Crit + AP
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_SPIRIT_SHORT"]=0.8, -- Reduces downtime
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=0 
        },

        -- 41-57: MANGLE / LEADER OF THE PACK
        -- Crit becomes huge for healing (LotP) and Combo Points (Primal Fury).
        ["Leveling_41_57"] = { 
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.8, -- Crit priority rises
            ["ITEM_MOD_CRIT_RATING_SHORT"]=1.5, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.0, 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=0 
        },

        -- 58-69: OUTLAND (FERAL WEAPONS)
        -- "Feral Attack Power" weapons appear (e.g., Staff of Natural Fury).
        -- These are massive upgrades over standard weapons.
        ["Leveling_58_69"] = { 
            ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]=2.5, -- Explicit Feral Weapons win now
            ["ITEM_MOD_STRENGTH_SHORT"]=1.8, 
            ["ITEM_MOD_AGILITY_SHORT"]=1.6, 
            ["ITEM_MOD_STAMINA_SHORT"]=1.2, 
            ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]=0 
        },
    },
}

-- =============================================================
-- 2. SPEC NAMES (Unchanged)
-- =============================================================
MSC.SpecNames = {
    ["WARLOCK"] = { [1]="Affliction", [2]="Demonology", [3]="Destruction" },
    ["PALADIN"] = { [1]="Holy", [2]="Protection", [3]="Retribution" },
    ["MAGE"]    = { [1]="Arcane", [2]="Fire", [3]="Frost" },
    ["PRIEST"]  = { [1]="Discipline", [2]="Holy", [3]="Shadow" },
    ["DRUID"]   = { [1]="Balance", [2]="FeralCombat", [3]="Restoration" },
    ["SHAMAN"]  = { [1]="Elemental", [2]="Enhancement", [3]="Restoration" },
    ["ROGUE"]   = { [1]="Assassination", [2]="Combat", [3]="Subtlety" },
    ["WARRIOR"] = { [1]="Arms", [2]="Fury", [3]="Protection" },
    ["HUNTER"]  = { [1]="BeastMastery", [2]="Marksmanship", [3]="Survival" },
}

-- =============================================================
-- 3. ENCHANT DATABASE (Comprehensive - Classic & TBC)
-- =============================================================
MSC.EnchantDB = {
    -- [[ WEAPON: PHYSICAL ]]
    [2673] = { ["ITEM_MOD_AGILITY_SHORT"] = 120, ["ITEM_MOD_ATTACK_SPEED_SHORT"] = 2 }, -- Mongoose
    [3225] = { ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = 120 }, -- Executioner
    [2670] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 70 }, -- Savagery (2H)
    [1900] = { ["ITEM_MOD_STRENGTH_SHORT"] = 30, ["ITEM_MOD_HEALING_POWER_SHORT"] = 10 }, -- Crusader (Classic)
    [2672] = { ["ITEM_MOD_STRENGTH_SHORT"] = 20 }, -- Potency (1H)
    [3223] = { ["ITEM_MOD_HIT_RATING_SHORT"] = 20 }, -- Accuracy
    [2621] = { ["ITEM_MOD_AGILITY_SHORT"] = 20 }, -- Greater Agility
    [2564] = { ["ITEM_MOD_AGILITY_SHORT"] = 15 }, -- Agility (Classic)
    [803]  = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 4 }, -- Fiery Weapon (Approx DPS)
    [1898] = { ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 3, ["ITEM_MOD_HEALING_POWER_SHORT"] = 3 }, -- Lifestealing
    [1894] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 1 }, -- Unholy Weapon
    [805]  = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 4 }, -- Weapon Damage +5 (Classic)
    [2667] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5 }, -- Major Striking (+7 Dmg)
    [2935] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 2 }, -- Striking (+2 Dmg)

    -- [[ WEAPON: CASTER / HEALER ]]
    [5865] = { ["ITEM_MOD_ARCANE_DAMAGE_SHORT"] = 50, ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 50 }, -- Sunfire
    [5866] = { ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 54, ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 54 }, -- Soulfrost
    [2669] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 40 }, -- Major Spellpower
    [2675] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 81 }, -- Major Healing
    [2674] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 10 }, -- Spellsurge
    [5390] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 30 }, -- Battlemaster
    [2504] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 30 }, -- Spellpower (Classic)
    [2505] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 55 }, -- Healing Power (Classic)
    [2666] = { ["ITEM_MOD_INTELLECT_SHORT"] = 30 }, -- Major Intellect
    [2443] = { ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 7 }, -- Winter's Might (Classic)
    [1903] = { ["ITEM_MOD_SPIRIT_SHORT"] = 20 }, -- Major Spirit (2H)
    [1904] = { ["ITEM_MOD_INTELLECT_SHORT"] = 22 }, -- Major Intellect (2H)

    -- [[ SHIELD ]]
    [2655] = { ["ITEM_MOD_STAMINA_SHORT"] = 18 }, -- Major Stamina
    [3229] = { ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 12 }, -- Resilience
    [2658] = { ["ITEM_MOD_BLOCK_VALUE_SHORT"] = 18 }, -- Shield Block
    [2653] = { ["ITEM_MOD_INTELLECT_SHORT"] = 12 }, -- Intellect
    [1889] = { ["ITEM_MOD_BLOCK_RATING_SHORT"] = 10 }, -- Lesser Block
    [1071] = { ["ITEM_MOD_BLOCK_RATING_SHORT"] = 8 }, -- Classic "Stamina" shield (actually usually +Stam, mapped to block sometimes in old DBs, fixed below)
    [1337] = { ["ITEM_MOD_STAMINA_SHORT"] = 7 }, -- Lesser Stamina

    -- [[ HEAD (Glyphs) ]]
    [2999] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 6, ["ITEM_MOD_HEALING_POWER_SHORT"] = 22 }, -- Sha'tar Healer
    [2996] = { ["ITEM_MOD_CRIT_RATING_SHORT"] = 15, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 34 }, -- Cenarion Physical
    [2997] = { ["ITEM_MOD_DODGE_RATING_SHORT"] = 16, ["ITEM_MOD_HIT_RATING_SHORT"] = 16 }, -- Keepers Tank
    [2998] = { ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 14, ["ITEM_MOD_SPELL_POWER_SHORT"] = 22 }, -- Sha'tar Caster
    [3003] = { ["ITEM_MOD_FIRE_RESISTANCE_SHORT"] = 20 }, -- Fire Warding
    [3004] = { ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"] = 20 }, -- Shadow Warding
    [2583] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 13, ["ITEM_MOD_STAMINA_SHORT"] = 15 }, -- ZG Tank
    [2584] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 18, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 10 }, -- ZG Caster
    [2587] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 28, ["ITEM_MOD_DODGE_RATING_SHORT"] = 10 }, -- ZG Physical

    -- [[ SHOULDERS ]]
    [2979] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30, ["ITEM_MOD_CRIT_RATING_SHORT"] = 10 }, -- Naxx Might
    [2980] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 18, ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 10 }, -- Naxx Power
    [2996] = { ["ITEM_MOD_CRIT_RATING_SHORT"] = 15, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 20 }, -- Aldor/Scryer Blade
    [2997] = { ["ITEM_MOD_DODGE_RATING_SHORT"] = 15, ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 10 }, -- Aldor/Scryer Warding
    [2998] = { ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 15, ["ITEM_MOD_SPELL_POWER_SHORT"] = 12 }, -- Aldor/Scryer Orb
    [2999] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 6, ["ITEM_MOD_HEALING_POWER_SHORT"] = 22 }, -- Aldor/Scryer Oracle
    [2983] = { ["ITEM_MOD_CRIT_RATING_SHORT"] = 10, ["ITEM_MOD_ATTACK_POWER_SHORT"] = 15 }, -- Blue Blade
    [2986] = { ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"] = 10, ["ITEM_MOD_SPELL_POWER_SHORT"] = 15 }, -- Blue Orb
    [2588] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30 }, -- ZG Might
    [2715] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 33 }, -- Naxx Healing (Fortitude of the Scourge)

    -- [[ CLOAK ]]
    [3242] = { ["ITEM_MOD_ARMOR_SHORT"] = 120 }, -- Major Armor
    [3256] = { ["ITEM_MOD_SPELL_PENETRATION_SHORT"] = 20 }, -- Spell Pen
    [2621] = { ["ITEM_MOD_AGILITY_SHORT"] = 12 }, -- Greater Agility
    [3296] = { ["ITEM_MOD_DODGE_RATING_SHORT"] = 12 }, -- Steelweave
    [1099] = { ["ITEM_MOD_AGILITY_SHORT"] = 3 }, -- Lesser Agility
    [2502] = { ["ITEM_MOD_STRENGTH_SHORT"] = 3 }, -- Lesser Strength
    [1887] = { ["ITEM_MOD_DODGE_RATING_SHORT"] = 10 }, -- Stealth (Classic, treated as Dodge)
    [3294] = { ["ITEM_MOD_ARCANE_RESISTANCE_SHORT"] = 15 }, 
    [1885] = { ["ITEM_MOD_ARMOR_SHORT"] = 70 }, -- Superior Defense (Classic)
    [2503] = { ["ITEM_MOD_FIRE_RESISTANCE_SHORT"] = 15 }, -- Fire Res
    [2501] = { ["ITEM_MOD_NATURE_RESISTANCE_SHORT"] = 15 }, -- Nature Res
    [1883] = { ["ITEM_MOD_FIRE_RESISTANCE_SHORT"]=5, ["ITEM_MOD_NATURE_RESISTANCE_SHORT"]=5, ["ITEM_MOD_FROST_RESISTANCE_SHORT"]=5, ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"]=5, ["ITEM_MOD_ARCANE_RESISTANCE_SHORT"]=5 }, -- Greater Resistance

    -- [[ CHEST ]]
    [2665] = { ["ITEM_MOD_STAMINA_SHORT"] = 6, ["ITEM_MOD_STRENGTH_SHORT"] = 6, ["ITEM_MOD_AGILITY_SHORT"] = 6, ["ITEM_MOD_INTELLECT_SHORT"] = 6, ["ITEM_MOD_SPIRIT_SHORT"] = 6 }, -- Stats +6
    [3251] = { ["ITEM_MOD_SPIRIT_SHORT"] = 15 }, -- Major Spirit
    [3245] = { ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 15 }, -- Major Resilience
    [2668] = { ["ITEM_MOD_STAMINA_SHORT"] = 150 }, -- Exceptional Health (150 HP -> 15 Stam equivalent for scoring)
    [1891] = { ["ITEM_MOD_STAMINA_SHORT"] = 4, ["ITEM_MOD_STRENGTH_SHORT"] = 4, ["ITEM_MOD_AGILITY_SHORT"] = 4, ["ITEM_MOD_INTELLECT_SHORT"] = 4, ["ITEM_MOD_SPIRIT_SHORT"] = 4 }, -- Stats +4
    [2666] = { ["ITEM_MOD_INTELLECT_SHORT"] = 10 }, -- Major Mana (150 Mana -> 10 Int equivalent)
    [1890] = { ["ITEM_MOD_INTELLECT_SHORT"] = 6 }, -- +100 Mana (Classic)
    [1888] = { ["ITEM_MOD_STAMINA_SHORT"] = 10 }, -- +100 Health (Classic)

    -- [[ WRIST ]]
    [2661] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 15 }, -- Spellpower
    [2647] = { ["ITEM_MOD_STRENGTH_SHORT"] = 12 }, -- Brawn
    [2650] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 24 }, -- Assault
    [2662] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 12 }, -- Major Defense
    [2648] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 30 }, -- Superior Healing
    [2663] = { ["ITEM_MOD_STAMINA_SHORT"] = 12 }, -- Fortitude
    [2508] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 6 }, -- Mana Prime
    [1563] = { ["ITEM_MOD_STAMINA_SHORT"] = 7 }, -- Stamina +7 (Classic)
    [1122] = { ["ITEM_MOD_INTELLECT_SHORT"] = 7 }, -- Intellect +7 (Classic)
    [1888] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 24 }, -- Healing +24 (Classic)
    [1886] = { ["ITEM_MOD_MANA_REGENERATION_SHORT"] = 4 }, -- MP5 +4 (Classic)

    -- [[ GLOVES ]]
    [3244] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 20 }, -- Major Spellpower
    [3246] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 35 }, -- Major Healing
    [3243] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 26 }, -- Assault
    [3253] = { ["ITEM_MOD_HIT_RATING_SHORT"] = 15 }, -- Precise Strikes
    [2613] = { ["ITEM_MOD_AGILITY_SHORT"] = 15 }, -- Superior Agility
    [3239] = { ["ITEM_MOD_STRENGTH_SHORT"] = 15 }, -- Major Strength
    [1603] = { ["ITEM_MOD_AGILITY_SHORT"] = 7 }, -- Agility +7
    [1604] = { ["ITEM_MOD_STRENGTH_SHORT"] = 7 }, -- Strength +7
    [2939] = { ["ITEM_MOD_SHADOW_DAMAGE_SHORT"] = 20 }, -- Shadow Power
    [2940] = { ["ITEM_MOD_FROST_DAMAGE_SHORT"] = 20 }, -- Frost Power
    [2938] = { ["ITEM_MOD_FIRE_DAMAGE_SHORT"] = 20 }, -- Fire Power
    [1884] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 30 }, -- Healing +30
    [2565] = { ["ITEM_MOD_AGILITY_SHORT"] = 15 }, -- Classic "Superior Agi" (15 Agi)

    -- [[ LEGS (Spellthread / Leg Armor) ]] --
    [3021] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 35, ["ITEM_MOD_STAMINA_SHORT"] = 20 }, -- Runic
    [3023] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 66, ["ITEM_MOD_STAMINA_SHORT"] = 20 }, -- Golden
    [3012] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 50, ["ITEM_MOD_CRIT_RATING_SHORT"] = 12 }, -- Nethercobra
    [3013] = { ["ITEM_MOD_STAMINA_SHORT"] = 40, ["ITEM_MOD_AGILITY_SHORT"] = 12 }, -- Clefthide
    [3020] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 25, ["ITEM_MOD_STAMINA_SHORT"] = 15 }, -- Mystic
    [3022] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 46, ["ITEM_MOD_STAMINA_SHORT"] = 15 }, -- Silver
    [3010] = { ["ITEM_MOD_ATTACK_POWER_SHORT"] = 40, ["ITEM_MOD_CRIT_RATING_SHORT"] = 10 }, -- Cobrahide
    [3011] = { ["ITEM_MOD_STAMINA_SHORT"] = 30, ["ITEM_MOD_AGILITY_SHORT"] = 10 }, -- Clefthide (Blue)
    [2582] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 18, ["ITEM_MOD_HIT_SPELL_RATING_SHORT"] = 10 }, -- ZG Caster
    [2581] = { ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"] = 10, ["ITEM_MOD_STAMINA_SHORT"] = 10 }, -- ZG Tank

    -- [[ BOOTS ]]
    [3232] = { ["ITEM_MOD_STAMINA_SHORT"] = 9, ["MSC_SPEED_BOOST"] = 1 }, -- Boar's Speed
    [3229] = { ["ITEM_MOD_AGILITY_SHORT"] = 6, ["MSC_SPEED_BOOST"] = 1 }, -- Cat's Swiftness
    [3241] = { ["ITEM_MOD_HIT_RATING_SHORT"] = 10 }, -- Surefooted
    [2657] = { ["ITEM_MOD_AGILITY_SHORT"] = 12 }, -- Dexterity
    [2656] = { ["ITEM_MOD_STAMINA_SHORT"] = 12 }, -- Fortitude
    [911]  = { ["MSC_SPEED_BOOST"] = 1 }, -- Minor Speed
    [1075] = { ["ITEM_MOD_STAMINA_SHORT"] = 7 }, -- Stamina +7
    [1074] = { ["ITEM_MOD_AGILITY_SHORT"] = 7 }, -- Agility +7
    [910]  = { ["ITEM_MOD_SPIRIT_SHORT"] = 5 }, -- Spirit +5

    -- [[ RINGS ]]
    [2937] = { ["ITEM_MOD_SPELL_POWER_SHORT"] = 12 }, -- Spellpower
    [2938] = { ["ITEM_MOD_HEALING_POWER_SHORT"] = 20 }, -- Healing Power
    [2935] = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 2 }, -- Striking
    [2936] = { ["ITEM_MOD_STAMINA_SHORT"] = 4, ["ITEM_MOD_STRENGTH_SHORT"] = 4, ["ITEM_MOD_AGILITY_SHORT"] = 4, ["ITEM_MOD_INTELLECT_SHORT"] = 4 }, -- Stats
}
-- =============================================================
-- 4. GEM OPTIONS (TBC Rare Gems - Including Hybrids)
-- =============================================================
-- The addon will pick the best gem for your spec from this list.
-- Hybrid Gems (Orange/Purple/Green) are listed in BOTH colors they match.

MSC.GemOptions = {
    -- [[ RED SOCKETS ]] --
    -- Matches: Red, Orange, Purple
    ["EMPTY_SOCKET_RED"] = {
        -- Pure Red
        { stat="ITEM_MOD_STRENGTH_SHORT", val=8, name="Bold Living Ruby" },       
        { stat="ITEM_MOD_AGILITY_SHORT", val=8, name="Delicate Living Ruby" },    
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=9, name="Runed Living Ruby" },   
        { stat="ITEM_MOD_HEALING_POWER_SHORT", val=18, name="Teardrop Living Ruby" }, 
        
        -- Orange (Red + Yellow) - Great for Red sockets if you need Hit/Crit
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, val2=4, stat2="ITEM_MOD_CRIT_RATING_SHORT", name="Inscribed Noble Topaz" }, -- Str/Crit
        { stat="ITEM_MOD_AGILITY_SHORT", val=4, val2=4, stat2="ITEM_MOD_HIT_RATING_SHORT", name="Glinting Noble Topaz" },   -- Agi/Hit
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, val2=4, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", name="Potent Noble Topaz" }, -- SP/Crit
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, val2=4, stat2="ITEM_MOD_SPELL_HASTE_RATING_SHORT", name="Reckless Noble Topaz" }, -- SP/Haste
        
        -- Purple (Red + Blue) - Great for Red sockets if you need Stamina
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Sovereign Nightseye" }, -- Str/Stam
        { stat="ITEM_MOD_AGILITY_SHORT", val=4, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Shifting Nightseye" },  -- Agi/Stam
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Glowing Nightseye" }, -- SP/Stam
    },
    
    -- [[ YELLOW SOCKETS ]] --
    -- Matches: Yellow, Orange, Green
    ["EMPTY_SOCKET_YELLOW"] = {
        -- Pure Yellow
        { stat="ITEM_MOD_CRIT_RATING_SHORT", val=8, name="Smooth Dawnstone" },      
        { stat="ITEM_MOD_SPELL_CRIT_RATING_SHORT", val=8, name="Gleaming Dawnstone" }, 
        { stat="ITEM_MOD_HIT_RATING_SHORT", val=8, name="Rigid Dawnstone" },        
        { stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=8, name="Thick Dawnstone" },
        
        -- Orange (Red + Yellow) - THE BEST CHOICE FOR DPS IN YELLOW SOCKETS
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, val2=4, stat2="ITEM_MOD_CRIT_RATING_SHORT", name="Inscribed Noble Topaz" }, 
        { stat="ITEM_MOD_AGILITY_SHORT", val=4, val2=4, stat2="ITEM_MOD_HIT_RATING_SHORT", name="Glinting Noble Topaz" },   
        { stat="ITEM_MOD_AGILITY_SHORT", val=4, val2=4, stat2="ITEM_MOD_CRIT_RATING_SHORT", name="Deadly Noble Topaz" }, -- Agi/Crit
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, val2=4, stat2="ITEM_MOD_SPELL_CRIT_RATING_SHORT", name="Potent Noble Topaz" }, 
        
        -- Green (Blue + Yellow)
        { stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Jagged Talasite" }, -- Crit/Stam
        { stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=4, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Enduring Talasite" }, -- Def/Stam (Tank God Gem)
        { stat="ITEM_MOD_INTELLECT_SHORT", val=4, val2=2, stat2="ITEM_MOD_MANA_REGENERATION_SHORT", name="Dazzling Talasite" }, -- Int/MP5
    },
    
    -- [[ BLUE SOCKETS ]] --
    -- Matches: Blue, Purple, Green
    ["EMPTY_SOCKET_BLUE"] = {
        -- Pure Blue
        { stat="ITEM_MOD_STAMINA_SHORT", val=12, name="Solid Star of Elune" },     
        { stat="ITEM_MOD_SPIRIT_SHORT", val=10, name="Sparkling Star of Elune" },  
        
        -- Purple (Red + Blue) - The only way for DPS to match Blue sockets nicely
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Sovereign Nightseye" }, 
        { stat="ITEM_MOD_AGILITY_SHORT", val=4, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Shifting Nightseye" },  
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Glowing Nightseye" }, 
        
        -- Green (Blue + Yellow)
        { stat="ITEM_MOD_DEFENSE_SKILL_RATING_SHORT", val=4, val2=6, stat2="ITEM_MOD_STAMINA_SHORT", name="Enduring Talasite" },
    },

    -- [[ META SOCKETS ]] --
    ["EMPTY_SOCKET_META"] = {
        { stat="ITEM_MOD_AGILITY_SHORT", val=12, name="Relentless Earthstorm" }, 
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=14, name="Chaotic Skyfire" },   
        { stat="ITEM_MOD_STAMINA_SHORT", val=18, name="Austere Earthstorm" },    
        { stat="ITEM_MOD_INTELLECT_SHORT", val=12, name="Insightful Earthstorm" }, 
    }
}
-- =============================================================
-- 5. BEST IN SLOT DEFAULTS (For Projection Mode)
-- =============================================================
-- Usage: [SlotID] = { ["SpecName"] = EnchantID }
MSC.BestEnchants = {
    -- [[ HEAD (Glyph of Power/Ferocity) ]]
    [1] = { 
        ["Default"] = 2999, -- Shao'tar (Healer) default safe
        ["Arms"] = 2996, ["Fury"] = 2996, ["Retribution"] = 2996, ["Combat"] = 2996, -- Physical DPS
        ["Holy"] = 2999, ["Restoration"] = 2999, -- Healer
        ["Protection"] = 2997, -- Tank
        ["Mage"] = 2998, ["Warlock"] = 2998, ["Elemental"] = 2998, -- Caster DPS
    },
    
    -- [[ SHOULDERS (Aldor/Scryer) ]]
    [3] = {
        ["Default"] = 2979, -- Aldor/Scryer Physical
        ["Protection"] = 2997, 
        ["Holy"] = 2999, 
        ["Destruction"] = 2980,
    },
    
    -- [[ CHEST (Stats/Health) ]]
    [5] = {
        ["Default"] = 2665, -- +6 All Stats
        ["Tank"] = 2668, -- +150 HP
    },
    
    -- [[ LEGS (Spellthread/Armor Kits) ]]
    [7] = {
        ["Default"] = 3012, -- Nethercobra (Physical)
        ["Holy"] = 3023, ["Restoration"] = 3023, -- Golden Spellthread (Heal)
        ["Destruction"] = 3021, ["Arcane"] = 3021, -- Runic Spellthread (Spell Dmg)
        ["Protection"] = 3013, -- Clefthide (Tank)
    },
    
    -- [[ FEET (Speed/Dex/Fort) ]]
    [8] = {
        ["Default"] = 3232, -- Boar's Speed
        ["Rogue"] = 3229, -- Cat's Swiftness
    },
    
    -- [[ WRIST (Spellpower/Assault/Brawn) ]]
    [9] = {
        ["Default"] = 2647, -- +12 Str
        ["Rogue"] = 2650, -- +24 AP
        ["Mage"] = 2661, ["Warlock"] = 2661, -- +15 SP
        ["Holy"] = 2648, -- +30 Heal
        ["Protection"] = 2663, -- +12 Stam
    },
    
    -- [[ HANDS (Str/Agi/SP) ]]
    [10] = {
        ["Default"] = 3244, -- +20 SP
        ["Warrior"] = 3239, -- +15 Str
        ["Rogue"] = 2613, -- +15 Agi
        ["Hunter"] = 3253, -- +15 Hit (Surefooted)
    },
    
    -- [[ WEAPON (Mongoose/Sunfire) ]]
    [16] = {
        ["Default"] = 2673, -- Mongoose
        ["Mage"] = 5865, -- Sunfire (Arcane/Fire)
        ["Frost"] = 5866, -- Soulfrost
        ["Warlock"] = 5866, -- Soulfrost (Shadow)
        ["Holy"] = 2675, -- +81 Heal
    },
    [17] = {
        ["Default"] = 2673, -- Mongoose
        ["Protection"] = 2655, -- +18 Stam (Shield)
    }
}
-- =============================================================
-- 6. LEVELING / BUDGET OPTIONS (Level 1-69)
-- =============================================================

-- [LEVELING GEMS: Green Quality]
MSC.GemOptions_Leveling = {
    -- Matches: Red, Orange, Purple
    ["EMPTY_SOCKET_RED"] = {
        { stat="ITEM_MOD_STRENGTH_SHORT", val=4, name="Bold Blood Garnet" }, 
        { stat="ITEM_MOD_AGILITY_SHORT", val=4, name="Delicate Blood Garnet" }, 
        { stat="ITEM_MOD_SPELL_POWER_SHORT", val=5, name="Runed Blood Garnet" },
        { stat="ITEM_MOD_HEALING_POWER_SHORT", val=9, name="Teardrop Blood Garnet" },
        -- Hybrids (Orange/Purple)
        { stat="ITEM_MOD_STRENGTH_SHORT", val=3, val2=3, stat2="ITEM_MOD_CRIT_RATING_SHORT", name="Inscribed Flame Spessarite" },
        { stat="ITEM_MOD_STRENGTH_SHORT", val=3, val2=4, stat2="ITEM_MOD_STAMINA_SHORT", name="Sovereign Shadow Draenite" },
    },
    -- Matches: Yellow, Orange, Green
    ["EMPTY_SOCKET_YELLOW"] = {
        { stat="ITEM_MOD_CRIT_RATING_SHORT", val=4, name="Smooth Golden Draenite" },
        { stat="ITEM_MOD_HIT_RATING_SHORT", val=4, name="Rigid Golden Draenite" },
        { stat="ITEM_MOD_INTELLECT_SHORT", val=4, name="Brilliant Golden Draenite" },
        -- Hybrids
        { stat="ITEM_MOD_STRENGTH_SHORT", val=3, val2=3, stat2="ITEM_MOD_CRIT_RATING_SHORT", name="Inscribed Flame Spessarite" },
        { stat="ITEM_MOD_AGILITY_SHORT", val=3, val2=3, stat2="ITEM_MOD_HIT_RATING_SHORT", name="Glinting Flame Spessarite" },
    },
    -- Matches: Blue, Purple, Green
    ["EMPTY_SOCKET_BLUE"] = {
        { stat="ITEM_MOD_STAMINA_SHORT", val=6, name="Solid Azure Moonstone" },
        { stat="ITEM_MOD_SPIRIT_SHORT", val=4, name="Sparkling Azure Moonstone" },
        -- Hybrids
        { stat="ITEM_MOD_STRENGTH_SHORT", val=3, val2=4, stat2="ITEM_MOD_STAMINA_SHORT", name="Sovereign Shadow Draenite" },
        { stat="ITEM_MOD_AGILITY_SHORT", val=3, val2=4, stat2="ITEM_MOD_STAMINA_SHORT", name="Shifting Shadow Draenite" },
    },
    -- Meta (Use generic low values)
    ["EMPTY_SOCKET_META"] = {
        { stat="ITEM_MOD_AGILITY_SHORT", val=12, name="Relentless Earthstorm" }, -- Metas don't have "Green" versions usually, keep standard
    }
}

-- [LEVELING ENCHANTS: Cheap / Classic Era]
MSC.BestEnchants_Leveling = {
    -- HEAD/SHOULDER: Usually empty while leveling (ZG/Naxx enchants are rare/expensive)
    [1] = {}, [3] = {},
    
    -- CHEST: +4 Stats (Cheap Classic)
    [5] = { ["Default"] = 1891 }, 
    
    -- LEGS: Empty (Leg armor is usually too expensive for leveling gear)
    [7] = { ["Default"] = 0 }, 
    
    -- BOOTS: Minor Speed is the best leveling stat, period.
    [8] = { ["Default"] = 911 }, 
    
    -- WRIST: Stamina or Int (Cheap)
    [9] = { 
        ["Default"] = 1563, -- +7 Stam
        ["Mage"] = 1122, ["Warlock"] = 1122, ["Priest"] = 1122, -- +5 Int
    },
    
    -- GLOVES: Primary Stats (Cheap Classic)
    [10] = {
        ["Default"] = 3243, -- +26 AP (Assault is often cheap in TBC)
        ["Warrior"] = 1604, -- +7 Str
        ["Rogue"] = 1603, -- +7 Agi
        ["Hunter"] = 1603, -- +7 Agi
        ["Caster"] = 0, -- Spellpower gloves are expensive, skip
    },
    
    -- CLOAK: Minor Agility (Cheap)
    [15] = {
        ["Default"] = 1099, -- +3 Agi (Good for melee/hunters)
        ["Caster"] = 0, -- No great cheap caster cloak enchants
    },
    
    -- WEAPON: Crusader is King for Melee Leveling
    [16] = {
        ["Default"] = 1900, -- Crusader (Str + Heal)
        ["Rogue"] = 2564, -- +15 Agi
        ["Hunter"] = 2564, -- +15 Agi (2H Stat Stick)
        ["Caster"] = 2504, -- +30 Spell Power
    },
    [17] = { 
        ["Default"] = 1900, -- Crusader
        ["Rogue"] = 2564, 
    },
}
-- =============================================================
-- 7. RACIAL BONUSES (TBC EDITION)
-- =============================================================
-- TBC Mechanics: 
-- Humans/Orcs: +5 Expertise (~19.7 Rating).
-- Dwarves/Trolls: +1% Crit (~22.1 Rating).
-- Draenei: +1% Hit (Global, handled via weights usually).

MSC.RacialTraits = {
    ["Human"] = {
        ["Swords"] = { stat = "ITEM_MOD_EXPERTISE_RATING_SHORT", val = 20 },
        ["Two-Handed Swords"] = { stat = "ITEM_MOD_EXPERTISE_RATING_SHORT", val = 20 },
        ["Maces"] = { stat = "ITEM_MOD_EXPERTISE_RATING_SHORT", val = 20 },
        ["Two-Handed Maces"] = { stat = "ITEM_MOD_EXPERTISE_RATING_SHORT", val = 20 },
    },
    ["Orc"] = {
        ["Axes"] = { stat = "ITEM_MOD_EXPERTISE_RATING_SHORT", val = 20 },
        ["Two-Handed Axes"] = { stat = "ITEM_MOD_EXPERTISE_RATING_SHORT", val = 20 },
        ["Fist Weapons"] = { stat = "ITEM_MOD_EXPERTISE_RATING_SHORT", val = 20 },
    },
    ["Dwarf"] = {
        ["Guns"] = { stat = "ITEM_MOD_CRIT_RATING_SHORT", val = 22 },
    },
    ["Troll"] = {
        ["Bows"] = { stat = "ITEM_MOD_CRIT_RATING_SHORT", val = 22 },
        ["Thrown"] = { stat = "ITEM_MOD_CRIT_RATING_SHORT", val = 22 },
    },
}

-- =============================================================
-- 8. SHORT NAMES (TBC Updated)
-- =============================================================
MSC.ShortNames = {
    -- FIXES
    ["RESISTANCE0_NAME"]                      = "Armor",
    ["ITEM_MOD_ARMOR_SHORT"]                  = "Armor",
    
    -- TBC NEW STATS
    ["ITEM_MOD_HASTE_RATING_SHORT"]           = "Haste",
    ["ITEM_MOD_EXPERTISE_RATING_SHORT"]       = "Expertise",
    ["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"] = "Armor Pen",
    ["ITEM_MOD_SPELL_PENETRATION_SHORT"]      = "Spell Pen",
    
    -- STANDARD STATS
    ["ITEM_MOD_SPELL_HEALING_DONE"]           = "Healing",
    ["ITEM_MOD_HEALING_POWER_SHORT"]          = "Healing",
    ["ITEM_MOD_SPELL_POWER_SHORT"]            = "Spell Power",
    ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"]      = "DPS",
    ["ITEM_MOD_POWER_REGEN0_SHORT"]           = "Mp5",
    ["ITEM_MOD_MANA_REGENERATION_SHORT"]      = "Mp5",
    ["ITEM_MOD_AGILITY_SHORT"]                = "Agility",
    ["ITEM_MOD_STRENGTH_SHORT"]               = "Strength",
    ["ITEM_MOD_INTELLECT_SHORT"]              = "Intellect",
    ["ITEM_MOD_SPIRIT_SHORT"]                 = "Spirit",
    ["ITEM_MOD_STAMINA_SHORT"]                = "Stamina",
    ["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"]   = "Defense",
    ["ITEM_MOD_DODGE_RATING_SHORT"]           = "Dodge",
    ["ITEM_MOD_PARRY_RATING_SHORT"]           = "Parry",
    ["ITEM_MOD_BLOCK_RATING_SHORT"]           = "Block Chance",
    ["ITEM_MOD_HIT_RATING_SHORT"]             = "Hit",
    ["ITEM_MOD_CRIT_RATING_SHORT"]            = "Crit",
    ["ITEM_MOD_SPELL_CRIT_RATING_SHORT"]      = "Spell Crit",
    ["ITEM_MOD_HIT_SPELL_RATING_SHORT"]       = "Spell Hit",
    ["ITEM_MOD_ATTACK_POWER_SHORT"]           = "Attack Power",
    ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"]     = "Feral AP",
    ["ITEM_MOD_BLOCK_VALUE_SHORT"]            = "Block Value",
    ["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"]    = "Ranged AP",
    ["ITEM_MOD_HEALTH_SHORT"]                 = "Health",
    ["ITEM_MOD_MANA_SHORT"]                   = "Mana",
    ["ITEM_MOD_RESILIENCE_RATING_SHORT"]      = "Resilience",
    
    -- RESISTANCES
    ["ITEM_MOD_SHADOW_RESISTANCE_SHORT"]      = "Shadow Res",
    ["ITEM_MOD_FIRE_RESISTANCE_SHORT"]        = "Fire Res",
    ["ITEM_MOD_FROST_RESISTANCE_SHORT"]       = "Frost Res",
    ["ITEM_MOD_NATURE_RESISTANCE_SHORT"]      = "Nature Res",
    ["ITEM_MOD_ARCANE_RESISTANCE_SHORT"]      = "Arcane Res",
}

-- =============================================================
-- 9. WEAPON SPEED & PROFICIENCIES (TBC Compatible)
-- =============================================================
MSC.SpeedChecks = {
    ["WARRIOR"] = { ["Fury"]={ MH_Slow=true, OH_Fast=true }, ["Protection"]={ MH_Fast=true }, ["Default"]={ MH_Slow=true } },
    ["ROGUE"]   = { ["Combat"]={ MH_Slow=true, OH_Fast=true }, ["Default"]={ MH_Slow=true, OH_Fast=true } },
    ["PALADIN"] = { ["Protection"]={ MH_Fast=true }, ["Default"]={ MH_Slow=true } },
    ["HUNTER"]  = { ["Default"]={ Ranged_Slow=true } },
    ["SHAMAN"]  = { ["Enhancement"]={ MH_Slow=true }, ["Default"]={ MH_Slow=true } }
}

MSC.ValidWeapons = {
    ["WARRIOR"] = { [0]=true, [1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true, [10]=true, [13]=true, [15]=true, [18]=true, [19]=false },
    ["PALADIN"] = { [0]=true, [1]=true, [4]=true, [5]=true, [6]=true, [7]=true, [8]=true },
    ["HUNTER"]  = { [0]=true, [1]=true, [2]=true, [3]=true, [6]=true, [7]=true, [8]=true, [10]=true, [13]=true, [15]=true, [18]=true },
    ["ROGUE"]   = { [0]=false, [1]=false, [2]=true, [3]=true, [4]=true, [5]=false, [7]=true, [8]=false, [13]=true, [15]=true, [18]=true },
    ["PRIEST"]  = { [4]=true, [10]=true, [15]=true, [19]=true },
    ["SHAMAN"]  = { [0]=true, [1]=true, [4]=true, [5]=true, [10]=true, [13]=true, [15]=true, [19]=false },
    ["MAGE"]    = { [7]=true, [10]=true, [15]=true, [19]=true },
    ["WARLOCK"] = { [7]=true, [10]=true, [15]=true, [19]=true },
    ["DRUID"]   = { [4]=true, [5]=true, [10]=true, [13]=true, [15]=true } 
}

-- =============================================================
-- 10. SLOT MAPPING
-- =============================================================
MSC.SlotMap = { 
    ["INVTYPE_HEAD"]=1, ["INVTYPE_NECK"]=2, ["INVTYPE_SHOULDER"]=3, ["INVTYPE_BODY"]=4, 
    ["INVTYPE_CHEST"]=5, ["INVTYPE_ROBE"]=5, ["INVTYPE_WAIST"]=6, ["INVTYPE_LEGS"]=7, 
    ["INVTYPE_FEET"]=8, ["INVTYPE_WRIST"]=9, ["INVTYPE_HAND"]=10, ["INVTYPE_FINGER"]=11, 
    ["INVTYPE_TRINKET"]=13, ["INVTYPE_CLOAK"]=15, ["INVTYPE_WEAPON"]=16, ["INVTYPE_SHIELD"]=17, 
    ["INVTYPE_2HWEAPON"]=16, ["INVTYPE_WEAPONMAINHAND"]=16, ["INVTYPE_WEAPONOFFHAND"]=17, 
    ["INVTYPE_HOLDABLE"]=17, ["INVTYPE_RANGED"]=18, ["INVTYPE_THROWN"]=18, 
    ["INVTYPE_RANGEDRIGHT"]=18, ["INVTYPE_RELIC"]=18 
}