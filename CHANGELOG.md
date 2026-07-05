# Sharpie's Gear Judge - Version History

---

## 🚀 v2.6.1

### 🐛 Bug Fixes

- **Mage**: Fixed a typo (`math_max` -> `math.max`) in TBC Mage class hit cap logic.

---

## 🚀 v2.6.0

### ✨ New Features

- **Raid & World Buff Assumptions:** New `RaidBuffs.lua` engine and **Buff Assumptions** section in Protocol settings (`/sgj` → Settings).
  - **Assume Raid Buffed** with presets (Off / 25-Man Full / 10-Man Minimal) — models Totem of Wrath, Improved Faerie Fire, Blessing of Kings, Mark of the Wild, and **Heroic Presence from a Draenei in your raid** (without double-counting your own Draenei racial).
  - **Assume World Buffed** with presets (Off / Full World Buffed / DM Tribute Only) — models classic world buffs (Ony/Nef, Rend/Alliance, ZG, Songflower, DM tribute). Off by default at 70; enable for leveling or vanilla content.
  - Stat synergy deflates primary-stat weights when buffs inflate your existing stats (Kings, MotW, ZG, etc.).
- **Unified Hit Cap Engine:** Shared cap logic across all TBC classes via `MSC.BuffEngine` — melee, spell, and ranged hit credits now include raid debuffs and external buffs when assumptions are enabled.
- **Balance Druid Hit Caps:** Added missing spell/melee hit cap softening for Boomkin and Feral specs (previously had no cap logic in `ApplyScalers`).
- **Era defense floor (Cap Guardian):** Tank profiles on Classic Era now get reactive defense-floor penalties (`level×5+140`, 440 at 60) matching Stat Logic targets.
- **TBC hybrid AUTO profiles:** Fury-Prot, Arms-Prot, HOTW, Ele/Resto NS, Enh/Resto NS detection with dedicated weight tables.
- **Endgame talent point-scan:** Dominant-tree fallback when no capstone matches (Warrior, Paladin, Shaman, Druid).
- **Uncertain profile UI:** Stat Logic shows when AUTO detection confidence is low or ambiguous.

### 🔧 Improvements (data & engine)

- **Stat Logic rings** now display raid-buff modifiers when **Assume Raid Buffed** is enabled.
- **Cap Guardian** (`Evaluator.lua`) uses effective hit targets that respect raid buff assumptions.
- Class `ApplyScalers` refactored for Mage, Warlock, Priest, Shaman, Paladin, Hunter, Warrior, and Druid to use the shared buff engine.
- **Scoring revision system:** `MSC:BumpScoringRevision()` centralizes cache invalidation when equipment, talents, gem/enchant mode, or buff assumptions change.
- **Processed stat cache:** `SafeGetItemStats` results are memoized per link, slot, settings, and revision; `SolveColorMatch` is memoized for socket bonus checks.
- **Narrow cache invalidation:** `BAG_UPDATE` no longer wipes the full raw `StatCache`; equipment/talent events use targeted clears instead.
- **Faster bag arrows:** New `EvaluateUpgradeFast` path scores single slots for bag overlays (default on; full `EvaluateUpgrade` still used for tooltips and comparisons).
- **Equipped baseline cache:** `GetCachedCharacterScore` avoids re-scoring the entire character on every upgrade comparison.
- **Receipt view:** Single-pass scoring via `GetTotalCharacterScore` instead of per-slot stat aggregation plus a second full pass.
- **Rogue hit caps:** TBC Rogue `ApplyScalers` now uses `MSC.BuffEngine:ApplyMeleeHitCap` with raid-buff hit credits, preserving Combat yellow-hit vs Assassination soft-cap behavior.
- **Receipt bag upgrades:** Uses `EvaluateUpgrade` / `EvaluateUpgradeFast` (same engine as tooltips and bag arrows).
- **BaseSpec on login:** `dbLoader` no longer flat-copies custom weights into `CurrentClass.Weights`; cache invalidates on reload when a custom profile is selected.
- **LookupRawWeights:** Falls back to `BaseSpec` from `customWeights` when resolving tracked specs.
- **TBC set data:** Fixed Malorne/Nordrassil `[641]` collision (Nordrassil Resto → `[602]`); Cyclone T4 Enh/Ele/Resto IDs remapped to `[631]`/`[633]`/`[632]`; T6 token duplicates removed from set item lists.
- **Expanded TBC SetBonusScores:** Added scores for Nordrassil, Cataclysm, Avatar, crafted, D3 gaps, T6 heal/caster, and S4 priest heal.
- **BuildDatabase validation:** Debug mode warns on item→set collisions and sets missing `SetBonusScores`.
- **ContentPhase gem gating:** `BuildGemOptionsForPhase(phase)` — P1 gems through P2; P3+ and P5+ tiers unlock at phases 3 and 5 (Roadmap phase dropdown rebuilds gem pool).
- **Fast bag arrows:** `FastBagArrows` setting (default on); falls back to full `EvaluateUpgrade` for set pieces and weapons.
- **Removed dead snapshot engine:** `PerformSnapshot` / `QueueGearSnapshot` deleted; manual Save Profile remains the baseline path.
- **Parse hardening:** Set `(n/m)` headers classify before generic stat lines; proc line index handling aligned with equip parser.
- **Custom weight load:** `dbLoader` unpacks Pawn-style `{weights, BaseSpec}` saved profiles correctly.
- **Proc dedup:** Scanner `UseEffects` skipped when ProcDB/WeaponDB/TrinketDB owns the item.
- **Shaman DW gate:** Off-hand weapon comparison requires `DUAL_WIELD` talent rank.
- **Tracked-spec safety:** Off-spec tooltip loop wrapped in `xpcall` with guaranteed `TalentCache` restore.

### 🐛 Bug Fixes

- **Gem double-counting:** `GetTotalCharacterScore` no longer re-adds physical gem stats when Gem Mode is Casual/Pro and `SafeGetItemStats` already projected sockets.
- **Off-spec weight pipeline:** `GetProfileWeights` / `GetWeightsByName` now run `ApplyScalers` and `ApplyStatSynergy` for every spec profile, not just the active one.
- **Stale evaluation cache:** Cache keys now include `ScoringRevision` and a baseline gear fingerprint so saved-profile and live-gear comparisons cannot cross-pollinate after gear or setting changes.
- **Hunter ranged hit scalar:** Combat rating ID 7 (ranged hit) now resolves to the correct 15.8 scalar in `RaidBuffs.lua`.
- **Set bonus double-count:** `GetTotalCharacterScore` no longer adds precomputed `.score` when a tier also defines `.stats`.
- **ProcDB trinkets:** `_MANUAL_SCORE` entries (Ashtongue, DMC, etc.) are honored in `GetItemScore`.
- **Gem Mode 2 (Casual):** Partially socketed items no longer double-count existing gems when projecting empty sockets.
- **Talent/spec cache:** Talent and spec changes call `BumpScoringRevision()` so processed-stat and evaluation caches stay fresh.
- **All-resist stat key:** `ITEM_MOD_RESISTANCE_ALL_SHORT` aliases to `ITEM_MOD_ALL_RESISTANCE_SHORT` across gems, enchants, and parsing.
- **Cap guardian off-spec:** Hit cap targets use the evaluation `specName`, not the active spec, for tracked-spec tooltips.
- **S4 Priest heal set:** Brutal Gladiator heal set `[772]` chest corrected from Enhancement shaman item `35107` to `35080`.
- **Duplicate classic set `[383]`:** Removed second Warlord's Battlegear entry that overwrote the Horde definition.
- **Receipt enchant check:** Enchant ID parsed from the correct item-link field.
- **TBC** `FURY_2H`**:** Endgame detection now returns the existing 2H profile when appropriate.
- **Unified endgame level gate:** TBC capstone detection uses `level >= 60` consistently (was `== 70` on some classes).
- **Profile tooltip:** Removed unimplemented "recent gameplay" claim; documents capstone + point-scan behavior.
- **TBC Resto/Priest Spirit weight:** `ApplyScalers` passed total player Intellect to `GetSpiritValueInMP5` instead of 1 spirit point, inflating Spirit weight by hundreds and dominating healer gear scoring on profiles and tracked off-spec.
- **TBC spirit regen formula:** Added `+0.001` constant to `GetSpiritValueInMP5`; Intensity and Meditation talent ranks now drive in-combat `combatMult` for Druid/Priest instead of hardcoded 0.65.

---

## 🚀 v2.5.11

- **Added support for Sixty Upgrades EP imports (JSON, URL, and CSV formats) via the standard import window.**
- **Fixed missing downgrade arrow overlays on items in standard Blizzard bags.**
- **Fixed missing downgrade arrow overlays on items in third-party bag addons (Bagnon, ElvUI, Baganator, XLoot, etc.).**
- **Applied initialization safety checks to the Pawn importer and fixed duplicate scanner logic.**
- **Corrected the TBC Spirit-to-MP5 formula.**

### 🐛 Bug Fixes

- **Bag Addon Overlays
- **Fixed an issue where downgrade arrows were entirely omitted from the codebase for both standard Blizzard bags and third-party bag addons (Bagnon, ElvUI, Baganator, etc.).**
- **The bag interfaces will now properly overlay both green Upgrade arrows and red Downgrade arrows exactly like the quest windows do.**

---

## 🚀 v2.5.10

### 🐛 Minor Fixes

- **Update Parse.lua to recognize Era-style stat lines by adding patterns for "+%d+ ranged/feral/attack power", and reorder related feral patterns for correct matching.** 
- **Also tighten proc name cleanup to strip trailing spaces and periods (use "[%s%.]+$"), improving stat/proc parsing accuracy.**

---

## 🚀 v2.5.9

### 🐛 Minor Fixes

- **Extended TermMap with additional spell hit/crit synonyms and remove duplicate entries; add mappings for various era phrasings so spell hit/crit are recognized consistently.**
- **Reordered and expand EquipPatterns so critical-related patterns are checked before hit (prevents "critical hit" from being matched as plain "hit") and add several regexes to catch alternate phrasings (e.g. "critical hit with spells", "critical hit rating").**

---

## 🚀 v2.5.8

- **UI: Fix EditBox focus for popup windows — enable mouse, focus on click (including empty ScrollFrame area), and hide frame on Escape (Interface.lua).**
- **Parser: Add missing stat entries and adjust term mapping (rename holy damage key), add a "procs/buffs escape hatch" to detect duration markers and record temporary effects into outputProcs instead of treating them as permanent stats, plus minor pattern/whitespace tweaks.**
- **Changed Swift Starfire Diamond (id 28557) quality from 3 to 4.** 
- **Added a set of TBC-era _AUTO_PROC overrides that provide averaged uptime stat equivalents for various proc trinkets and weapons (e.g., Dragonspine Trophy, Quagmirran's Eye, Sextant of Unstable Currents, Madness of the Betrayer, assorted rings and weapons).** 
- **These entries include stat keys, averaged values, and notes to improve equip-proc stat estimation in calculations.**

---

## 🚀 v2.5.7

- **Introduced CacheManager.lua and TooltipManager.lua to handle dynamic cache invalidation and prevent 0-score tooltip evaluations.** 
- **CacheManager wipes evaluation, slot, and stat caches on equipment, talent, stance, and world-entry events so items are re-scored when baseline stats change.** 
- **TooltipManager wraps the tooltip evaluation to wait for GET_ITEM_INFO for uncached items (including quest rewards), shows a "Fetching item data..." indicator, and refreshes evaluation when data arrives; it supports modern TooltipDataProcessor and falls back to legacy hooks.** 
- **Added the new localization string and register both new files in the TBC and Vanilla .toc files.**
- **Druid/Rogue/Warrior: default GetCombatRating(25) to 0 (arPen = GetCombatRating(25) or 0) to avoid nil errors before ARP scaling.**
- **Interface: ensure manual spec override is loaded into engine by assigning MSC.ManualSpec = SGJ_Settings.Mode on ADDON_LOADED.**
- **Judge: add visual color entry for "Spell Dmg, Heal".**
- **Parse: add scanner term mapping for MSC.L["spell dmg, heal"] => ITEM_MOD_SPELL_POWER_SHORT so that the parser recognizes the new label.**
- **These changes fix potential runtime errors, ensure the manual spec setting takes effect, and support a new spell-damage label in parsing and display.**

---

## 🚀 v2.5.6

- **Added a "Clear" button next to the Save button in MSC.InitSettingsView and reposition the status label to the right of it.** 
*The new button clears the saved gear and talent profiles for the current player key (SGJ_Settings.GearProfiles and SGJ_Settings.TalentProfiles), wipes MSC.EvaluationCache, and updates the status label.** 
*The Clear button is enabled only when a baseline is set.**
 *Also wipes the evaluation cache after saving a baseline so evaluations refresh immediately.**
- **Adjusted parsing and evaluation to correctly handle hybrid items that list both healing and damage/spell power.** 
- **Parse.lua: updated two equip patterns to record the full spell power value as ITEM_MOD_SPELL_POWER_SHORT and only add the excess (healing minus spell power) to ITEM_MOD_SPELL_HEALING_DONE_SHORT when positive.**
- **Judge.lua: added derived-stat logic to convert existing spell power into healing (TBC logic) by adding ITEM_MOD_SPELL_POWER_SHORT into ITEM_MOD_SPELL_HEALING_DONE_SHORT.**
- **Evaluator.lua: ensured item scoring uses a modified stat table (copied via SafeCopy) that includes spell power added into healing before computing the item score.**
- **This prevents double-counting and yields correct scoring for hybrid heal/damage items.**

---

## 🚀 v2.5.5

### 🐛 Minor Fixes

- ** Fix Minimap button drift*

## 🚀 v2.5.4

### 🐛 Minor Fixes

- **By ckhatri - Fix Project Best enchant double counting on pre-enchanted items; attempts to strip existing enchants off an item by comparing the item's raw stats against its base template, which is super helpful for accurate comparisons if Blizzard's API hides the enchant ID.**
- **Avoid nil-index errors in MSC.SolveColorMatch by defaulting the result of GetItemStats(baseLink) to an empty table.** 
- **This ensures subsequent accesses like template["EMPTY_SOCKET_RED"] are safe when GetItemStats returns nil (e.g., for invalid or stat-less items).**

---

## 🚀 v2.5.3

### ⚖️ UI, Scoring & Off Spec Logic

- **Added TalentProfiles storage, build & copy talent cache when saving a profile, and flush evaluation caches.**  
- **GetWeightsByName now copies raw weight tables and applies class scalers to avoid mutating core data; tooltip evaluation injects saved off-spec talents into MSC.TalentCache to get correct scaled weights, then restores the live cache.**  
- **Introduced per-character baseline gear profiles and UI to save/compare off-spec gear.** 
- **Added MSC:GetPlayerKey and MSC:SaveBaselineProfile to store equipped gear by character/spec and flush relevant caches.**
- **Updated Evaluator:GetEvaluateUpgrade to accept a baselineGear parameter, include a Live/Saved flag in cache keys, and use baseline stats when present (adjusts hit/defense calculations and one/two-hand logic).** 
- **Made Slot-cache keys spec-aware and allow GetComparisonSlot to consult baselineGear when comparing rings/trinkets and weapons.** 
- **Expanded tooltip multi-spec tracking to load saved baselines and show saved vs. live comparisons with a Saved label.** 
- **Refactored settings UI into a scrollable pane, reorganize sections, add Save Gear buttons for each tracked profile, improve dropdown/check behavior, and streamline custom-profile deletion.**

### 🐛 Minor Fixes

- **Updated localization strings to support new UI text.**
- **Removed PLAYER_REGEN_ENABLED snapshot branch and related trigger code.**
- **Fixed When the GameTooltip is visible, fall back to MSC.HoveredQuestLink if no item link is returned so tooltip matching works for quest-linked items and the tooltip is re-evaluated.**
- **Adjusted weight checks to bypass the minimum-weight threshold for the Armor stat in both total and item diff handling so Armor contributions are not incorrectly ignored.**

---

## 🚀 v2.5.2 - Unreleased

### ⚖️ UI, Scoring & Evaluator Logic

- **Added an optional customBaselineGear parameter to MSC:EvaluateUpgrade so upgrades can be evaluated against a ghost/virtual gear set.**
- **Initialized SGJ_Settings.GearProfiles and use per-spec GearProfiles (snapshot) when evaluating item tooltips.** 
- **Introduced a background snapshot engine that automatically captures the player's equipped gear into SGJ_Settings.GearProfiles.** 
- **Added PerformSnapshot (with a 2s debounce timer), MSC:QueueGearSnapshot, and an isGearDirty flag to defer snapshots during combat and re-run them on PLAYER_REGEN_ENABLED.** 
- **Registered PLAYER_REGEN_ENABLED and updated the existing event handler to queue snapshots on equipment/inventory changes, talent/spec changes, and entering the world.**

### 🐛 Minor Fixes

- **Updated the section header comment for the event listener.**
- **Minor refactor: compute prettySpec earlier for reuse and adjust tooltip formatting for upgrade and raw-score cases.**

---

## 🚀 v2.5.1

### 💎 Gemming System & Database Overhaul

- **Introduced a new "Gem Quality" setting, allowing users to set a budget limit (Common, Uncommon, Rare, Epic) for how empty sockets are scored and projected.**
- **Separated the Gemming Algorithm (The Casual vs. The Pro) from the Gem Quality to allow flexible combinations (e.g., using "Pro" min-max logic with "Uncommon" budget gems for leveling or fresh 70s).**
- **Restructured the Gem Database to explicitly tag vendor gems (Tourmaline, Zircon, Amber) as Common (`quality=1`) and crafted leveling gems as Uncommon (`quality=2`).**
- **Injected lower-tier leveling gems into the Level 70 endgame arrays, ensuring budget gemming settings work correctly for max-level characters trying to save gold.**
- **Updated the Evaluator logic to respect the new Gem Quality setting, automatically filtering out gems that exceed the player's chosen budget limit.**

---

## 🚀 v2.5.0

- **Introduced (still a work in progress)loot roll overlay support and improve quest/reward UI robustness.**

### 📺 UI & User Experience

- **Added a ShowLootArrows setting and UI checkbox to enable/disable green upgrade arrows on group loot popups.** 
- **Localization strings for the new option were added to the main and several locale files.**
- **Added START_LOOT_ROLL handling, MSC.UpdateLootRollOverlays (creates upgrade/downgrade icons on GroupLoot frames) and a GroupLootFrame_OpenNewFrame hook.** 
- **Added hooks to support ElvUI's custom loot roll frames and XLoot, with a short C_Timer.After(0.05) delay to let frames populate before calling EvaluateAndDraw on the icon frames.**
- **Harden UpdateAllQuestOverlays by using IsVisible, safe iteration of QuestInfoRewardsFrame.RewardButtons via rawget, and increased timing delays to avoid race conditions.** 
- **Added a Blizzard UI hotfix wrapping QuestInfo_ShowRewards to prefill missing reward buttons (prevents crashes from 3rd-party addons).** 
- **Added new Warlock leveling brackets for Destruction (Shadow) across level ranges (21-70) and register PrettyNames for those brackets.** 
- **Improved quest UI overlay handling by hiding ElvUI/Blizzard arrow overlays and making quest item link retrieval more robust (use QuestInfoFrame.questLog to choose GetQuestLogItemLink vs GetQuestItemLink with a fallback).** 
- **Added/adjusted localization patterns in Localization.lua and Locales/deDE.lua (socket bonus regex, several German pattern fixes and punctuation adjustments for mana/health per 5 sec, armor/feral/cat power patterns) and update Parse.lua to strip socket bonuses using the localized regex.**

### 🐛 Minor Fixes

- **Fixed spell rating mappings in Parse.lua.
- **Fixed role detection to use "Leveling_Destro_Shadow" when SHADOW_AND_FLAME is present.
- **Minor UI/comment and whitespace adjustments.**

---

##🚀 SharpiesGearJudge:Collection (v2.4.0 – v2.4.11)

###🛠️ Major Feature: Tanking & Scoring Logic

- **Crush & Def Cap Engine: Full support for Protection Paladins and Warriors, including dynamic "Crush Cap" visual rings and EHP weight pivoting once safely capped.**
- **The "Exploder" Parser: Advanced detection for "+All Stats," "Attack Power in Cat Form," and "On-Use" trinket value mapping.**
- **Relic & Spec Overhaul: Standardized scoring for Idols, Librams, and Totems (e.g., Idol of the Raven Goddess) and deepened Warlock endgame spec detection.**
- **Pawn 2.0: Robust Pawn string import support with negative value handling and "Base Spec" assignment.**

###🌍 Global Localization (MSC.L)

- **Multi-Language Framework: Introduced a complete localization system.**
- **Full Support: Extensive translations and regex patterns for deDE, esES, frFR, ptBR, and ruRU, including technical terms and meta-gem effects.**

###⚡ Performance & Caching (The "Speed" Update)

- **Triple-Layer Caching: Implemented EvaluationCache, UsableCache, and SlotCache to eliminate redundant calculations and UI stutter.**
- **Event Debouncing: Added a 0.5s gate to GET_ITEM_INFO_RECEIVED to keep the frame rate smooth during heavy data loading.**
- **Smart Filtering: Uses GetItemInfoInstant to ignore non-equippable items before they ever hit the scoring engine.**

###📺 UI, UX & Compatibility

- **Unified Overlays: Integrated upgrade indicators for Merchant, Trade Skill, Quest Log, and Quest Accept frames.**
- **Addon Synergy: Native hooks for TSM, ElvUI, Bagnon, and Baganator, plus a LibDataBroker (LDB) launcher for Titan Panel.**
- **Visual Polish: Added "Compact Equip" and "Colorize Stats" settings; restructured ApplyRingArt to fix animation flickering and stutter.**

###🐛 Key Fixes & Reliability

- **Infinite Loop Fix: Resolved the TSM tooltip flickering/looping issue.**
- **Async Loading: Integrated C_Timer delays to handle uncached item data gracefully without showing "empty" scores.**
- **Math Corrections: Fixed "triple-dipping" errors on Proc-based trinkets and refined weapon-set swap detection logic.**

---

##🚀 SharpiesGearJudge:Collection (v2.2.8 - v2.3.7)

###🛠 Core Engine & Performance

- **Initialization Overhaul: Moved to a "Pending Module" registration system. The addon now uses PLAYER_LOGIN and ForceInit to detect class modules, wiring up profiles only when needed to save memory.**
- **Micro-Optimizations: Extensive localization of Lua and WoW APIs across all files to reduce global lookups.**
- **Memory Management: Implemented database flattening for item sets and automated "garbage collection" of temporary tables after database builds.**
- **Update Throttling: Replaced old OnUpdate logic with a C_Timer based debounce system (RequestUpdate) to handle UI refreshes efficiently during bag/event changes.**

###🔍 Parser & Data Accuracy

- **Parse.lua Overhaul: Expanded TermMap and EquipPatterns to support Era/TBC phrasings (e.g., "spell damage and healing," ranged AP, elemental resistances). Improved right-side tooltip scanning to fix missing weapon speed/damage data.**
- **Item Overrides & Procs: Centralized the ProcDB and AddOverrides tables. Introduced _AUTO_PROC for more accurate valuation of trinkets and procs with detailed internal notes.**
- **Pawn Integration: Added a robust Pawn v1 string parser, allowing users to import external weight scales directly into the addon's DB with an automatic UI reload prompt.**

###⚖️ Evaluator & Mechanics

- **Dynamic Caps: Added talent and racial detection (e.g., Heroic Presence, Survival of the Fittest) to dynamically adjust hit, expertise, and defense caps for the UI rings.**
- **Set Bonus Logic: Rewrote the item set system to use a fast itemID->setID lookup. The evaluator now accurately calculates set bonus gains or breaks when comparing gear.**
- **Stat Refinements: Improved dual-wield/off-hand logic, added meta gem color counting, and fixed cap/delta math for hit and defense checks.**

###📺 UI & User Experience

- **Multi-Spec Tracking: Introduced the ability to track secondary profiles simultaneously, showing upgrade deltas for off-specs in the item tooltips.**
- **Quest Overlays: Added QUEST_COMPLETE handling to visually mark the best upgrade choice among quest rewards.**
- **Tooltip Improvements: Added a "Shift Key Only" toggle, fixed minimap anchoring/draggability, and refined the score breakdown to include proc contributions.**
- **Settings: Transitioned SGJ_Settings to SavedVariablesPerCharacter to allow for unique setups on different alts.**

###⚔️ Class Specific Highlights

- **Warlocks: Added TBC-specific weights, mana regeneration tiebreakers, and PvP spell penetration caps.**
- **Druids: Integrated Dreamstate/Predatory Instincts logic, Feral AP scaling, and expertise cap softening. Added a dynamic "Raven Goddess" idol entry.**
- **Paladins/Priests: Corrected missing spell power weights for leveling/healing and adjusted Retribution priorities.**

