local addonName, MSC = ...
local L = MSC.L

if GetLocale() ~= "esES" then return end

-- =============================================================
-- esES
-- =============================================================

-- =============================================================
-- Init
-- =============================================================
L["|cff00ff00Sharpie's Gear Judge:|r Loaded %s"] =

-- =============================================================
-- Conflict Manager
-- =============================================================
L["Yes, Disable & Reload"] =
L["No, Keep Both"] =
L["|cff00FF00[SGJ]|r: Pawn settings not found yet."] =
L["|cff00FF00Sharpie's Gear Judge|r\n\nI see RestedXP is active.\n\nIt is currently showing its own gear tips.\n\nDo you want me to disable their **Item Upgrade** setting?"] =
L["|cff00FF00Sharpie's Gear Judge|r\n\nI see Zygor Guides is active.\n\nIt adds its own 'Gear Score' to tooltips.\n\nDo you want me to disable their **Auto Gear** system?"] =
L["|cff00FF00Sharpie's Gear Judge|r\n\nI see Pawn is active.\n\nFor conflict-free use, we recommend disabling **Pawn's Tooltip Upgrades** so they don't overlap with our Verdict.\n\nDisable Pawn tooltip info?"] =

-- =============================================================
-- Evaluator
-- =============================================================
L["Bag Item"] =
L["Cap"] =
L["Exp"] =
L["Def"] =

-- Context Messages
L["|cffff0000(Not 2Hander)|r"] =
L["|cff00ff00(w/ %s)|r"] =
L["|cffff0000(No OH found)|r"] =
L["|cffff0000(No MH found)|r"] =
L["|cff00ff00(Set Bonus %s)|r"] =

-- Cap Warnings (Format Strings)
L[" |cffff0000(Cap %.1f %s)|r"] =
L[" |cffff0000(Cap %.1f Def)|r"] =

-- =============================================================
-- Database
-- =============================================================
-- STAT NAMES 
L["Resilience"] =
L["Haste"] =
L["Spell Haste"] =
L["Expertise"] =
L["Armor Pen"] =
L["Spell Pen"] =
L["Feral AP"] =
L["PvP Utility"] =
L["Armor"] =
L["Agility"] =
L["Strength"] =
L["Intellect"] =
L["Spirit"] =
L["Stamina"] =
L["Health"] =
L["Mana"] =
L["Spell Power"] =
L["Healing"] =
L["Mp5"] =
L["DPS"] =
L["Attack Power"] =
L["Ranged AP"] =
L["Hp5"] =
L["Crit"] =
L["Spell Crit"] =
L["Hit"] =
L["Spell Hit"] =
L["Crit (from Agi)"] =
L["Spell Crit (from Int)"] =
L["Defense"] =
L["Dodge"] =
L["Parry"] =
L["Block %"] =
L["Block Value"] =
L["Shadow Dmg"] =
L["Fire Dmg"] =
L["Frost Dmg"] =
L["Arcane Dmg"] =
L["Nature Dmg"] =
L["Holy Dmg"] =
L["Shadow Res"] =
L["Fire Res"] =
L["Frost Res"] =
L["Nature Res"] =
L["Arcane Res"] =
L["All Res"] =
L["Speed"] =
L["Weapon DPS"] =
L["Wand DPS"] =

-- PROFILE NAMES
L["Starter (1-20)"] =
L["Standard Leveling (21-40)"] =
L["Standard Leveling (41-51)"] =
L["Standard Leveling (52-59)"] =
L["Standard Leveling (Outland)"] =

-- ENCHANT NAMES
L["Mongoose"] =
L["Sunfire"] =
L["Soulfrost"] =
L["Executioner"] =
L["Major Spellpower"] =
L["Major Healing"] =
L["Sunfire (Healing)"] =
L["Major Intellect"] =
L["Savagery"] =
L["Major Agility"] =
L["Greater Agility (2H)"] =
L["Spell Surge"] =
L["Potency"] =
L["Crusader"] =
L["Fiery Weapon"] =
L["Weapon Dmg +5"] =
L["Spellpower +30"] =
L["Healing +55"] =
L["Unholy Weapon"] =
L["Major Strength (+15)"] =
L["Lifestealing"] =
L["Lesser Striking (+3)"] =
L["Icy Chill"] =
L["Agility +15"] =
L["Major Striking (+4)"] =
L["Superior Striking (+5)"] =
L["Greater Striking (+4)"] =
L["Striking (+3)"] =
L["Lesser Striking (+2)"] =
L["Minor Striking (+1)"] =
L["Demonslaying"] =
L["Lesser Beastslayer"] =
L["Minor Beastslayer"] =
L["Adamantite Scope"] =
L["Khorium Scope"] =
L["Stabilized Eternium Scope"] =
L["Sniper Scope"] =
L["Accurate Scope"] =
L["Standard Scope"] =
L["Biznicks Accurascope"] =
L["Major Stamina"] =
L["Shield Block"] =
L["Lesser Stamina"] =
L["Greater Spirit"] =
L["Greater Stamina"] =
L["Felsteel Shield Spike"] =
L["Thorium Shield Spike"] =
L["Mithril Shield Spike"] =
L["Iron Shield Spike"] =
L["Glyph of Power"] =
L["Glyph of Ferocity"] =
L["Glyph of the Defender"] =
L["Glyph of Renewal"] =
L["Glyph of the Gladiator"] =
L["Glyph of the Outcast"] =
L["Lesser Arcanum (Agi)"] =
L["Lesser Arcanum (Int)"] =
L["Lesser Arcanum (Str)"] =
L["Syncretist's Sigil"] =
L["Greater Inscription of the Orb"] =
L["Greater Inscription of Vengeance"] =
L["Greater Inscription of the Knight"] =
L["Greater Inscription of the Oracle"] =
L["Inscription of the Orb"] =
L["Inscription of Vengeance"] =
L["Inscription of the Knight"] =
L["Inscription of the Oracle"] =
L["Zandalar Signet of Mojo"] =
L["Zandalar Signet of Might"] =
L["Zandalar Signet of Serenity"] =
L["Greater Agility (+12)"] =
L["Spell Penetration"] =
L["Steelweave"] =
L["Major Armor"] =
L["Lesser Agility (+3)"] =
L["Greater Resistance"] =
L["Superior Defense (+70)"] =
L["Greater Defense (+50)"] =
L["Minor Agility (+1)"] =
L["Subtlety (-2% Threat)"] =
L["Dodge (+1%)"] =
L["Major Resistance (+7)"] =
L["Greater Shadow Resistance"] =
L["Subtlety"] =
L["Exceptional Stats (+6)"] =
L["Major Health (+150)"] =
L["Major Resilience"] =
L["Restore Mana Prime"] =
L["Greater Stats (+4)"] =
L["Minor Stats (+1)"] =
L["Major Health (+100)"] =
L["Stats (+3)"] =
L["Lesser Stats (+2)"] =
L["Major Mana (+100)"] =
L["Superior Health (+50)"] =
L["Minor Health (+5)"] =
L["Lesser Health (+15)"] =
L["Health (+25)"] =
L["Greater Health (+35)"] =
L["Mana (+50)"] =
L["Lesser Mana (+30)"] =
L["Brawn (+12 Str)"] =
L["Spellpower (+15)"] =
L["Major Healing (+30)"] =
L["Assault (+24 AP)"] =
L["Major Defense"] =
L["Fortitude (+12 Stam)"] =
L["Intellect +7"] =
L["Spirit +9"] =
L["Minor Strength (+1)"] =
L["Superior Strength (+9)"] =
L["Superior Stamina (+9)"] =
L["Mana Regen (+4mp5)"] =
L["Healing Power (+24)"] =
L["Major Strength (+12)"] =
L["Major Intellect (+12)"] =
L["Minor Spirit (+1)"] =
L["Lesser Spirit (+3)"] =
L["Spirit (+5)"] =
L["Greater Spirit (+7)"] =
L["Minor Stamina (+1)"] =
L["Lesser Stamina (+3)"] =
L["Stamina (+5)"] =
L["Greater Stamina (+7)"] =
L["Superior Agility (+15)"] =
L["Major Spellpower (+20)"] =
L["Major Healing (+35)"] =
L["Assault (+26 AP)"] =
L["Threat (+Hit)"] =
L["Blast (+Crit)"] =
L["Agility +7"] =
L["Greater Strength (+7)"] =
L["Greater Agility (Classic +7)"] =
L["Agility (+5)"] =
L["Riding Skill"] =
L["Strength (+5)"] =
L["Shadow Power (+20)"] =
L["Frost Power (+20)"] =
L["Fire Power (+20)"] =
L["Healing Power (+30)"] =
L["Precision (+15 Hit)"] =
L["Spell Strike (+15 Hit)"] =
L["Glove Reinforcements"] =
L["Runic Spellthread"] =
L["Golden Spellthread"] =
L["Nethercobra Leg Armor"] =
L["Nethercleft Leg Armor"] =
L["Cobrahide Leg Armor"] =
L["Mystic Spellthread"] =
L["Clefthide Leg Armor"] =
L["Lesser Arcanum of Rumination"] =
L["Lesser Arcanum of Constitution"] =
L["Boar's Speed"] =
L["Cat's Swiftness"] =
L["Surefooted"] =
L["Minor Speed"] =
L["Surefooted (+5% Resist)"] =
L["Dexterity (+12 Agi)"] =
L["Spellpower"] =
L["Healing Power"] =
L["Stats"] =
L["Striking"] =
L["Minor Haste"] =
L["Winter's Might (+7 SP)"] =
L["Lesser Intellect (+6)"] =
L["Major Intellect (+22)"] =
L["Major Spirit (+20)"] =
L["Impact (+5 Dmg)"] =
L["Lesser Absorption"] =
L["Power of the Scourge"] =
L["Fortitude of the Scourge"] =
L["Might of the Scourge"] =
L["Resilience of the Scourge"] =
L["CC Break (Rank 1)"] =
L["CC Break (Rank 2)"] =
L["CC Break (Rank 3)"] =

-- GEM NAMES
L["Void Sphere"] =
L["Bold Living Ruby"] =
L["Delicate Living Ruby"] =
L["Runed Living Ruby"] =
L["Bright Living Ruby"] =
L["Subtle Living Ruby"] =
L["Flashing Living Ruby"] =
L["Teardrop Living Ruby"] =
L["Runed Ornate Ruby"] =
L["Bold Ornate Ruby"] =
L["Solid Star of Elune"] =
L["Sparkling Star of Elune"] =
L["Lustrous Star of Elune"] =
L["Stormy Star of Elune"] =
L["Eye of the Sea"] =
L["Rigid Dawnstone"] =
L["Smooth Dawnstone"] =
L["Brilliant Dawnstone"] =
L["Thick Dawnstone"] =
L["Mystic Dawnstone"] =
L["Gleaming Dawnstone"] =
L["Great Dawnstone"] =
L["Smooth Ornate Dawnstone"] =
L["Inscribed Noble Topaz"] =
L["Etched Noble Topaz"] =
L["Potent Noble Topaz"] =
L["Veiled Noble Topaz"] =
L["Glinting Noble Topaz"] =
L["Luminous Noble Topaz"] =
L["Inscribed Ornate Topaz"] =
L["Sovereign Nightseye"] =
L["Shifting Nightseye"] =
L["Glowing Nightseye"] =
L["Purified Nightseye"] =
L["Royal Nightseye"] =
L["Balanced Nightseye"] =
L["Purified Shadow Pearl"] =
L["Regal Nightseye"] =
L["Enduring Talasite"] =
L["Dazzling Talasite"] =
L["Jagged Talasite"] =
L["Vivid Talasite"] =
L["Steady Talasite"] =
L["Relentless Earthstorm"] =
L["Chaotic Skyfire"] =
L["Mystical Skyfire"] =
L["Powerful Earthstorm"] =
L["Brutal Earthstorm"] =
L["Insightful Earthstorm"] =
L["Destructive Skyfire"] =
L["Swift Starfire"] =
L["Bracing Earthstorm"] =
L["Bold Crimson Spinel"] =
L["Delicate Crimson Spinel"] =
L["Runed Crimson Spinel"] =
L["Teardrop Crimson Spinel"] =
L["Solid Empyrean Sapphire"] =
L["Sparkling Empyrean Sapphire"] =
L["Stormy Empyrean Sapphire"] =
L["Brilliant Lionseye"] =
L["Smooth Lionseye"] =
L["Rigid Lionseye"] =
L["Thick Lionseye"] =
L["Mystic Lionseye"] =
L["Great Lionseye"] =
L["Inscribed Pyrestone"] =
L["Potent Pyrestone"] =
L["Luminous Pyrestone"] =
L["Glinting Pyrestone"] =
L["Veiled Pyrestone"] =
L["Wicked Pyrestone"] =
L["Sovereign Shadowsong Amethyst"] =
L["Shifting Shadowsong Amethyst"] =
L["Glowing Shadowsong Amethyst"] =
L["Royal Shadowsong Amethyst"] =
L["Purified Shadowsong Amethyst"] =
L["Enduring Seaspray Emerald"] =
L["Jagged Seaspray Emerald"] =
L["Crimson Sun"] =
L["Don Julio's Heart"] =
L["Kailee's Rose"] =
L["Don Amancio's Heart"] =
L["Delicate Fire Ruby"] =
L["Falling Star"] =
L["Sparkling Falling Star"] =
L["Lustrous Falling Star"] =
L["Stormy Falling Star"] =
L["Blood of Amber"] =
L["Stone of Blades"] =
L["Brilliant Bladestone"] =
L["Great Bladestone"] =
L["Rigid Bladestone"] =
L["Mystic Bladestone"] =
L["Facet of Eternity"] =
L["Quick Lionseye"] =
L["Reckless Pyrestone"] =
L["Luminous Fire Opal"] =
L["Glinting Fire Opal"] =
L["Etched Fire Opal"] =
L["Shining Fire Opal"] =
L["Deadly Fire Opal"] =
L["Potent Fire Opal"] =
L["Iridescent Fire Opal"] =
L["Resplendent Fire Opal"] =
L["Sovereign Tanzanite"] =
L["Shifting Tanzanite"] =
L["Glowing Tanzanite"] =
L["Brutal Tanzanite"] =
L["Fluorescent Tanzanite"] =
L["Royal Tanzanite"] =
L["Steady Seaspray Emerald"] =
L["Forceful Seaspray Emerald"] =
L["Sundered Chrysoprase"] =
L["Jagged Chrysoprase"] =
L["Vivid Chrysoprase"] =
L["Lambent Chrysoprase"] =
L["Eternal Earthstorm"] =
L["Bold Blood Garnet"] =
L["Delicate Blood Garnet"] =
L["Runed Blood Garnet"] =
L["Bright Blood Garnet"] =
L["Teardrop Blood Garnet"] =
L["Solid Azure Moonstone"] =
L["Sparkling Azure Moonstone"] =
L["Lustrous Azure Moonstone"] =
L["Stormy Azure Moonstone"] =
L["Rigid Golden Draenite"] =
L["Smooth Golden Draenite"] =
L["Brilliant Golden Draenite"] =
L["Thick Golden Draenite"] =
L["Gleaming Golden Draenite"] =
L["Inscribed Flame Spessarite"] =
L["Glinting Flame Spessarite"] =
L["Potent Flame Spessarite"] =
L["Veiled Flame Spessarite"] =
L["Luminous Flame Spessarite"] =
L["Sovereign Shadow Draenite"] =
L["Shifting Shadow Draenite"] =
L["Glowing Shadow Draenite"] =
L["Royal Shadow Draenite"] =
L["Enduring Deep Peridot"] =
L["Dazzling Deep Peridot"] =
L["Jagged Deep Peridot"] =
L["Radiant Deep Peridot"] =

-- TOOLTIP NOTES (Trinkets & Procs)
L["Use: 21 Avg Dodge (based on uptime)"] =
L["Use: Mana restore avg to ~15 mp5"] =
L["Use: 25 Avg SP (based on uptime)"] =
L["Use: 55 Avg AP (based on uptime)"] =
L["Use: 60 Avg AP + Pet Heal utility"] =
L["Use: 45 Avg AP + Pet Heal utility"] =
L["Use: ~34 Avg SP"] =
L["Use: 46 Avg AP (Defensive)"] =
L["Use: ~23 mp5"] =
L["Use: 80 Avg AP"] =
L["Use: Avg Summon Dmg"] =
L["Use: 21 Avg SP"] =
L["Use: 33 Avg AP"] =
L["Use: 20 Avg SP"] =
L["Use: 150 Avg Armor"] =
L["Use: 33 Avg SP"] =
L["Use: 22.5 Avg AP"] =
L["Use: HP valued flat"] =
L["Use: 23 Avg SP"] =
L["Use: 29 Avg AP"] =
L["Use: 43 Avg HSP"] =
L["Use: 30 Avg AP"] =
L["Use: ~12 mp5"] =
L["Use: ~14 Avg SP"] =
L["Use: 10 Avg AP (3.3% Uptime)"] =
L["Use: Heal Valued as flat Stam"] =
L["Use: 25 Avg SP"] =
L["Use: 39 Avg HSP"] =
L["Use: 46 Avg AP"] =
L["Use: 26 Avg SP"] =
L["Use: 20 Avg Dodge"] =
L["Use: Aggro reduction utility"] =
L["Use: Heal"] =
L["Use: 46.6 Avg Agi"] =
L["Proc: ~100 Avg Dodge (High Uptime)"] =
L["Use: 216 Avg Armor"] =
L["Use: 600 ArP (Avg 100)"] =
L["Use: 22 Avg SP"] =
L["Use: 16.6 Avg SP"] =
L["Use: Absorb valued as Health"] =
L["Use: Heal avg to 15 BV"] =
L["Proc: 38 Avg Haste"] =
L["Proc: 50 Avg AP"] =
L["Use: 21 Avg Haste"] =
L["Proc: ~15 mp5"] =
L["Proc: 300 AP (Internal CD)"] =
L["Use: Absorb valued as Stam"] =
L["Proc: ~19 Avg SP"] =
L["Use: 14 Avg Agi"] =
L["Proc: 160 Haste (15% spell proc) = ~26 Avg"] =
L["Proc: ~21 mp5"] =
L["Proc: ~65 Avg AP"] =
L["Proc: 108 Avg Haste"] =
L["Use: 49.5 Avg HSP"] =
L["Use: 170 SP"] =
L["Use: 300 Dodge"] =
L["Use: 22 Avg mp5"] =
L["Proc: Chance to reduce mana cost avg to 45 mp5"] =
L["Proc: Lightning Capacitor Dmg avg to 55 SP"] =
L["Proc: Rage/Energy gain avg to 30 AP"] =
L["Use: 53 Avg AP"] =
L["Proc: 340 AP (10s duration)"] =
L["Use: 300 Spirit"] =
L["Use: 130 SP"] =
L["Use: 145 Dodge"] =
L["Proc: 130 SP"] =
L["Use: 175 Haste"] =
L["Use: 320 Haste (Decaying)"] =
L["Use: 211 SP"] =
L["Use: 360 AP"] =
L["Use: 260 Haste"] =
L["Use: 1750 HP"] =
L["Use: 2000 Armor (Valued as defensive)"] =
L["Proc: 152 Dodge"] =
L["Use: Sustain"] =
L["Use: ~23 Avg SP"] =
L["Proc: ~22 Avg SP"] =
L["Proc: Heal Stacks avg to 49 Heal"] =
L["Proc: 152 Dodge for 10s (Low rate) = ~25 Avg"] =
L["Passive: Resistances not valued"] =
L["Proc: 1.33% Proc @ 70 (Nerfed in TBC)"] =
L["Use: 29 Avg SP"] =
L["Use: Decaying stacks avg to ~34 SP"] =
L["Use: 16.6 Avg Haste"] =
L["Use: 43 Avg AP"] =
L["Use: 33 Avg Haste"] =
L["Proc: ArP"] =
L["Passive: 25.2 Hit"] =
L["Use: 450 Heal (Decaying)"] =
L["Use: 260 Def"] =
L["Use: 235 Block"] =
L["Use: AP (Stacking)"] =
L["Proc: Dmg"] =
L["Use: Absorb"] =
L["Use: Threat Drop"] =
L["Use: Heal/Shield"] =
L["Use: 280 AP"] =
L["Use: 330 Haste"] =
L["Use: Mana"] =
L["Use: 1500 HP"] =
L["Use: Poison Dmg"] =
L["Use: 250 SP"] =
L["Use: 250 SP (Hunter)"] =
L["Passive: 2% Legacy Crit converts to 28 Rating"] =
L["Passive: 2% Legacy Spell Crit converts to 28 Rating"] =
L["Passive: Weighted average vs Undead/Demon"] =
L["Proc: Cannon dmg avg to ~10 AP"] =
L["Proc: 25 Stats with ~33% uptime"] =
L["Proc: Dmg reduction value avg to Stam"] =
L["Passive: 29 SP"] =
L["Use: Dmg/Heal"] =
L["Passive: Max Stacks (120 AP / 80 SP)"] =
L["Proc: Holy Dmg avg to ~10 AP"] =
L["Passive: 51 Stamina Base"] =
L["Proc: 100% Regen (Blue Dragon) avg to 60mp5"] =
L["Use: SP"] =
L["Use: 36.6 Avg AP"] =
L["Use: Health valued as Defense"] =
L["Use: ~23 Avg SP"] =
L["Use: 1000 HP (Shared CD)"] =
L["Use: Stun/Dmg utility"] =
L["Use: Haste"] =
L["Use: HP"] =
L["Use: Avg 20 BV"] =
L["Use: 265 Heal"] =
L["Use: Shield"] =
L["Use: Block value avg to 20"] =
L["Use: Dmg"] =
L["Use: Pet"] =
L["Use: Poly"] =
L["Proc: Extra Swing value avg to 30 AP"] =
L["Use: 50% Haste - Burst Value"] =
L["Powershift: Energy Refund valued as 80 AP"] =
L["Passive: 85 SP vs Demon/Undead"] =
L["Passive: 150 AP vs Demon/Undead"] =

-- =============================================================
-- Data_sets
-- =============================================================

-- PROC & SET BONUS NOTES
L["Chance on hit: Haste"] =
L["ERA BiS for Melee (HoJ)"] =
L["ERA BiS Caster (Nelth's Tear)"] =
L["ERA BiS Physical (DFT)"] =
L["Legendary Threat Gen (TF)"] =
L["ERA Top Tier Prot Pally"] =
L["Bladestorm Proc"] =
L["BiS Physical"] =
L["Moroes' Watch (Dodge Use)"] =
L["Talisman of Tenacity (Use: HP)"] =
L["Pet Proc"] =
L["Rage/Energy Proc"] =
L["BiS (Infinite Energy Proc)"] =
L["BiS Tank (Proc)"] =
L["BiS Hunter (Mana Proc)"] =
L["BiS (Mechanic)"] =
L["LEGENDARY"] =
L["Stun Proc PvP BiS"] =

-- =============================================================
-- JUDGE
-- =============================================================
L["Classic Era"] =
L["TBC Edition"] =
L["|cff00ff00Sharpie's Gear Judge|r (%s) Loaded. Type /sgj for menu."] =
L["|cffffd100SGJ Warning:|r 'Pawn' is loaded. Tooltips may look cluttered."] =
L["|cffffd100SGJ Warning:|r 'Zygor' detected. Ensure its item scoring is disabled."] =

-- Popups
L["|cff00ccffSharpie's Gear Judge|r\n\nProfile imported successfully!\n\nYou must reload your UI for the changes to take effect."] =
L["Reload Now"] =
L["Later"] =

-- Tooltip Headers
L["Judge's Score:"] =
L["Verdict Profile:"] =
L["Capped"] =
L["|cff00ffff* EQUIPPED *|r"] =
L["vs."] =
L["Judge's Note:"] =
L["Class Bonus: "] =

-- Upgrade/Downgrade Text
-- Note: %s is the Texture, %.1f are numbers
L["|cff00ff00%s Upgrade (+%.1f / +%.1f%%)|r"] =
L["|cffff0000%s Downgrade (%.1f / %.1f%%)|r"] =
L["|cff888888= Sidegrade (0.0)|r"] =

-- Warnings
L["|cffff0000!!! WARNING: Breaking Set Bonus (%d) !!!|r"] =
L["|cff00ff00+++ GAINED: %d-pc Set Bonus! +++|r"] =
L["  |cffff0000(Breaks %d-pc Set Bonus!)|r"] =
L["|cff00ff00+%s (Upgrade)|r"] =

-- Projections
L["Projected Enchant:"] =
L["Best Available"] =
L["Projected Gems:"] =
L["+ Meta Gem Active"] =
L["- Meta Gem Inactive (Reqs unmet)"] =

-- Lists
L["Gains:"] =
L["Losses:"] =

-- =============================================================
-- DYNAMIC ENGINE
-- =============================================================
L["Auto: %s"] =

-- =============================================================
-- INTERFACE (Lab, Receipt, Settings)
-- =============================================================
-- Stat Logic Tooltips

L["Need %d more rating to cap."] =
L["Cap reached!"] =
L["Current Rating:"] =
L["1%% requires %.2f Rating"] =
L["Gear Contribution:"] =
L["Character Sheet:"] =
L["%d (Includes Base/Enchants)"] =
L["Score Calculation:"] =
L["%.2f (Weight) x %.1f (Gear)"] =
L["Stat Weight:"] =
L["You currently have 0 of this stat from gear."] =

-- Misc
L["Laboratory"] =
L["Select..."] =
L["(Empty)"] =
L["Weapon Thunderdome"] =
L["Receipt"] =
L["Stat Logic"] =
L["Rating:"] =
L["Protocol"] =
L["Drag (Shift/Ctrl+Click) items to compare. 6 Sets Enter, 1 Set Wins!"] =
L["Option A1: Two-Hander"] =
L["Option B1: 1H + Shield/OH"] =
L["Option C1: Dual Wield"] =
L["Option A2: Two-Hander"] =
L["Option B2: 1H + Shield/OH"] =
L["Option C2: Dual Wield"] =
L["Waiting for Items..."] =
L["Option A1 (2H)"] =
L["Option B1 (1H+OH)"] =
L["Option C1 (DW)"] =
L["Option A2 (2H)"] =
L["Option B2 (1H+OH)"] =
L["Option C2 (DW)"] =
L["%s Wins! (+%s)"] =

-- Receipt
L["ARMOR"] =
L["ACCESSORIES"] =
L["WEAPONS"] =
L["Head"] =
L["Shoulder"] =
L["Back"] =
L["Chest"] =
L["Wrist"] =
L["Hands"] =
L["Waist"] =
L["Legs"] =
L["Feet"] =
L["Neck"] =
L["Ring 1"] =
L["Ring 2"] =
L["Trinket 1"] =
L["Trinket 2"] =
L["Main Hand"] =
L["Off Hand"] =
L["Ranged"] =
L["COMBINED GEAR STAT TOTALS"] =
L["Score: "] =
L["Missing Enchant!"] =
L["Better item in bags!"] =

-- Settings
L["Comparison Logic"] =
L["Enchant Mode"] =
L["Off (Raw Stats)"] =
L["Current Only"] =
L["Project Best"] =
L["Controls how item enchantments affect the score.\n\n|cffffffffOff:|r Scores items based on base stats only.\n|cffffffffCurrent:|r Includes the value of the enchant currently on the item.\n|cffffffffProject:|r Simulates the best possible enchant for that item level."] =

L["Gemming Logic"] =
L["The Skeptic"] =
L["The Casual"] =
L["The Pro"] =
L["Controls how empty sockets are scored.\n\n|cffffffffSkeptic:|r Empty sockets are worth 0. Socket bonuses are ignored unless fully met.\n|cffffffffCasual:|r Assumes empty sockets are filled with Rare (Blue) quality gems.\n|cffffffffPro:|r Assumes empty sockets are filled with Epic/Best-in-Slot gems."] =

L["Character Profile"] =
L["Auto-Detect"] =
L["Active Scoring Profile"] =
L["Manually override the scoring profile.\n\n|cffffffffAuto-Detect:|r Automatically selects a profile based on your talents and recent gameplay.\n\nSelecting a specific profile forces the addon to judge all gear for that spec, regardless of your current talents."] =

L["Interface Options"] =
L["Hide Minimap Button"] =
L["Hides the circular button on your minimap."] =
L["Hide Tooltip Verdict"] =
L["Stops the addon from adding scores to item tooltips."] =
L["Show Only via Shift Key"] =
L["Only shows the Judge score in tooltips while holding the SHIFT key."] =
L["Mute Error Sounds"] =
L["Stops the error sound when clicking invalid items."] =
L["Disable Conflict Check"] =
L["Stops the chat warning about Pawn/Zygor."] =

L["Secondary Spec Tracking"] =
L["Select additional profiles to track in tooltips.\n\nIf an item is an upgrade for a checked profile, a small notification will appear at the bottom of the item tooltip."] =

L["Import Pawn String"] =
L["Export Data"] =
L["Paste Pawn string here..."] =
L["Import"] =
L["Export Data (Discord Ready)"] =
L["Unknown"] =
L["Unknown Item"] =
L["No Weights Loaded"] =
L["Total Score: "] =
L["Scroll to Scale"] =
L["Hold\nto Move"] =

-- Stat Reasons
L["Increases Attack Power and Block Value"] =
L["Increases Crit Chance, Dodge, and Armor"] =
L["Increases total Health Pool"] =
L["Increases Mana Pool and Spell Crit"] =
L["Increases Out-of-Combat and Spell5 Regen"] =
L["Increases Raw Physical Damage Output"] =
L["Reduces chance Target Parries or Dodges"] =
L["Ignores a portion of Target's Armor"] =
L["Reduces chance to Miss Physical attacks"] =
L["Increases Scaling Damage of Spells"] =
L["Increases Potency of Healing spells"] =
L["Reduces chance for Spells to Resist/Miss"] =
L["Constant Mana Sustain (Mp5)"] =
L["Chance for Extra Critical Damage/Healing"] =
L["Increases Attack/Casting Speed"] =
L["Reduces chance to be Crit and Hit"] =
L["Chance to completely Avoid Physical attacks"] =
L["Chance to Deflect front-facing attacks"] =
L["Increases Damage mitigated by Shield"] =
L["Chance to Mitigate damage with Shield"] =
L["Reduces Crit Damage and Chance (PvP)"] =
L["Reduces Incoming Physical Damage"] =

-- =============================================================
-- HELPERS & DEBUG
-- =============================================================
L["|cffff0000SGJ: Invalid Pawn string format or empty stats.|r"] =
L["|cff00ff00SGJ:|r Successfully imported %s"] =

L["|cffff0000SGJ: Please hover over an item to debug.|r"] =
L["|cffff0000SGJ: No weights loaded.|r"] =
L["|cff00ccff--- SGJ DEBUG REPORT ---|r"] =
L["Item: "] =
L["Profile: "] =
L["|cffffffff%s:|r %.1f x %.2f = |cff00ff00%.1f|r"] =
L["|cff888888%s: %.1f (Weight: 0)|r"] =
L["Ratio Check: "] =
L["Useful: %.1f / Useless: %.1f"] =
L["|cffff0000[FAIL] Item rejected by Bouncer (Mostly Junk)|r"] =
L["|cff00ff00[PASS] Item accepted|r"] =
L["Final Score: "] =

-- =============================================================
-- PARSER: KEYWORDS & PATTERNS
-- =============================================================
-- Classify Keywords
L["equip"] =
L["use:"] =
L["chance on"] =
L["set:"] =
L["socket"] =
L["bonus"] =
L["spell"] =
L["hit"] =
L["crit"] =
L["speed"] =
L["haste"] =
L["armor"] =
L["^to "] =
L["^equip: "] =

-- Header Patterns
L["^(.*)%s+%(?(%d+)/(%d+)%)?$"] =
L["^%s*equip:%s*"] =
L["^chance on hit: "] =
L["^equip: chance on hit: "] =
L["^use: "] =

-- Stat Patterns (Regex)
L["^[%+]?%s*(%d+%.?%d*)%s+(.-)[%s%.]*$"] =
L["^(.-)%s+[%+:]?%s*(%d+%.?%d*)[%s%.]*$"] =
L["^(%d+) armor$"] =
L["^(%d+) block$"] =
L["speed (%d+%.?%d*)"] =
L["^%((%d+%.?%d*) damage per second%)$"] =
L["^%((%d+%.?%d*) dps%)$"] =
L["^(%d+)%s?[-~]%s?(%d+) damage$"] =
L["scope %([%+:]*(%d+) (.*)%)"] =
L["enchant:? [%+:]*(%d+) (.*)"] =

-- Equip/Use/Proc Patterns (English Defaults)
L["damage and healing.-(%d+)"] =
L["healing done.-(%d+)"] =
L["spell penetration.-(%d+)"] =
L["restores (%d+) mana"] =
L["spell hit rating.-(%d+)"] =
L["ranged hit rating.-(%d+)"] =
L["hit rating.-(%d+)"] =
L["spell crit.-(%d+)"] =
L["ranged crit.-(%d+)"] =
L["critical strike rating.-(%d+)"] =
L["ranged attack power.-(%d+)"] =
L["feral attack power.-(%d+)"] =
L["attack power.-(%d+)"] =
L["expertise rating.-(%d+)"] =
L["armor penetration.-(%d+)"] =
L["block value.-(%d+)"] =
L["block rating.-(%d+)"] =
L["defense rating.-(%d+)"] =
L["dodge rating.-(%d+)"] =
L["parry rating.-(%d+)"] =
L["resilience.-(%d+)"] =
L["spell haste.-(%d+)"] =
L["haste rating.-(%d+)"] =
L["shadow damage.-(%d+)"] =
L["fire damage.-(%d+)"] =
L["frost damage.-(%d+)"] =
L["arcane damage.-(%d+)"] =
L["nature damage.-(%d+)"] =
L["holy damage.-(%d+)"] =
L["healing.-up to (%d+).-damage.-up to (%d+)"] =
L["adds (%d+) weapon damage"] =
L["adds (%d+) damage"] =
L["improves your (.*) by (%d+)%%%.?"] =
L["increases your (.*) by (%d+)%%%.?"] =
L["increases (.*) by (%d+)%%%.?"] =
L["improves your (.*) by (%d+)%.?"] =
L["improves (.*) by (%d+)%.?"] =
L["increases your (.*) by (%d+)%.?"] =
L["increases (.*) by up to (%d+)%.?"] =
L["increases (.*) by (%d+)%.?"] =
L["^%+?%s*(%d+)%%? (.*)$"] =
L["^(.-) %+(%d+)%%?$"] =
L["^%+(%d+) (.*) for (%d+) sec"] =
L["grants (%d+) (.*) for (%d+) sec"] =
L["gain (%d+) (.*) for (%d+) sec"] =
L["increases (.*) by (%d+) for (%d+) sec"] =
L["increases your (.*) by (%d+)$"] =
L["chance on melee or ranged hit to gain (%d+) (.*) for (%d+) sec"] =
L["chance on spell critical hit to gain (%d+) (.*) for (%d+) sec"] =
L["chance on spell cast to gain (%d+) (.*) for (%d+) sec"] =
L["for (%d+) to (%d+) .*damage"] =
L["inflicts (%d+) to (%d+) .*damage"] =
L["for (%d+) .*damage"] =
L["inflicts (%d+) .*damage"] =
L["deals (%d+) .*damage"] =
L["blasts (.*) for (%d+)"] =
L["chance to strike your enemy for (%d+) to (%d+) .*damage"] =
L["chance to blast your target for (%d+) to (%d+) .*damage"] =
L["steals (%d+) life"] =
L["restores (%d+) health"] =
L["blasts your enemy"] =
L["^%+(%d+) (.*)$"] =
L["increases (.*) by up to (%d+) for (%d+) sec"] =
L["restores (%d+) to (%d+) mana"] =
L["restores (%d+) to (%d+) health"] =

-- Data Map Keys (Standard)
L["strength"] =
L["agility"] =
L["stamina"] =
L["intellect"] =
L["spirit"] =
L["armor"] =
L["block"] =
L["block value"] =
L["speed"] =
L["damage per second"] =
L["dps"] =
L["shadow resistance"] =
L["fire resistance"] =
L["frost resistance"] =
L["arcane resistance"] =
L["nature resistance"] =
L["attack power"] =
L["healing spells"] =
L["healing"] =
L["spell damage"] =
L["spell power"] =
L["shadow damage"] =
L["fire damage"] =
L["frost damage"] =
L["arcane damage"] =
L["nature damage"] =
L["holy damage"] =
L["shadow spell damage"] =
L["fire spell damage"] =
L["frost spell damage"] =
L["arcane spell damage"] =
L["nature spell damage"] =
L["holy spell damage"] =
L["spell damage and healing"] =
L["damage and healing spells"] =
L["ranged attack power"] =
L["spell penetration"] =
L["all stats"] =
L["magic resistance"] =
L["mana"] =
L["health"] =
L["hp"] =
L["mp"] =
L["dodge rating"] =
L["parry rating"] =
L["block rating"] =
L["hit rating"] =
L["crit rating"] =
L["critical strike rating"] =
L["haste rating"] =
L["resilience rating"] =
L["defense rating"] =
L["expertise rating"] =
L["armor penetration rating"] =

-- Green Text Map Keys
L["chance to hit"] =
L["chance to get a critical strike"] =
L["spell hit rating"] =
L["chance to hit with spells"] =
L["spell critical strike rating"] =
L["critical strike with spells"] =
L["chance to get a critical strike with spells"] =
L["spell haste rating"] =
L["magical resistances"] =
L["magical resistances of your spell targets"] =
L["increased defense"] =
L["defense"] =
L["chance to dodge"] =
L["chance to parry"] =
L["chance to block"] =
L["shield block value"] =
L["the block value of your shield"] =
L["all resistances"] =
L["resistance to all schools of magic"] =
L["attack power in cat"] =
L["feral attack power"] =
L["mana per 5 sec"] =
L["health per 5 sec"] =
L["healing done by spells and effects"] =
L["healing done by magical spells and effects"] =
L["spell damage rating"] =
L["damage done by magical spells and effects"] =
L["damage and healing done by magical spells and effects"] =
L["damage and healing done by magical spells and effects by up to"] =
L["damage done by shadow spells and effects"] =
L["damage done by fire spells and effects"] =
L["damage done by frost spells and effects"] =
L["damage done by arcane spells and effects"] =
L["damage done by nature spells and effects"] =
L["damage done by holy spells and effects"] =
L["swords"] =
L["axes"] =
L["maces"] =
L["daggers"] =
L["bows"] =
L["crossbows"] =
L["guns"] =
L["staves"] =
L["polearms"] =
L["two-handed swords"] =
L["two-handed axes"] =
L["two-handed maces"] =
L["skill with swords"] =
L["skill with axes"] =
L["skill with maces"] =
L["skill with bows"] =
L["skill with guns"] =
L["skill with daggers"] =
L["skill with crossbows"] =
L["skill with staves"] =
L["skill with polearms"] =
L["ranged critical strike rating"] =
L["ranged hit rating"] =
L["ranged haste rating"] =
L["shield block rating"] =
L["your pet's armor"] =
L["your pet's attack power"] =
L["your pet's damage"] =
L["chance to resist mechanic mechanics"] =
L["^(.*)%s+%(?(%d+)/(%d+)%)?$"] =