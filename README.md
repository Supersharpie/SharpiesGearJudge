# Sharpie's Gear Judge (Era & TBC Anniversary Edition)

**The Final Verdict on your gear.**

**Sharpie's Gear Judge (SGJ)** is a real-time **theorycrafting engine** and UI enhancement built for **World of Warcraft: Classic Era** and the **TBC Anniversary Edition**.

Unlike addons that assign static points to items (e.g., "Hit = 10 pts"), SGJ understands **context**. It knows if you are hit-capped, if a helm swap will break your Meta Gem, whether a quest reward is better than what you wear, and — in TBC — it can **project** the best possible gems and enchants for an item before you equip it.

---

## 🔥 What's New in Version 2.6.0

### Raid & world buff modeling

- **Buff Assumptions** in **Settings → Protocol** — model Totem of Wrath, Improved Faerie Fire, Kings, MotW, Draenei-in-raid Heroic Presence, and classic world buffs (Ony, ZG, Songflower, DM tribute).
- **Unified hit cap engine** across all TBC classes; Boomkin, Rogue, and other specs get raid-aware cap softening.
- **Cap Guardian** uses your **evaluation spec** for hit targets — off-spec tracked tooltips no longer use the wrong cap.

### Performance & accuracy

- **Faster bag arrows** with automatic fallback to full evaluation for **set pieces** and **weapons**.
- **Scoring revision system** — caches invalidate cleanly on talent, spec, gear, gem/enchant mode, and buff changes.
- **Receipt view** scores your character in a single pass instead of double-scanning every slot.
- **Era defense floor:** Cap Guardian now enforces tank defense floors on Era (`level×5+140`, 440 at 60) — same reactive penalties as TBC.
- **Hybrid AUTO detection:** TBC hybrid profiles (Fury-Prot, HOTW, Ele/Resto NS, etc.), endgame talent point-scan fallbacks, and uncertain-profile hints in Stat Logic.
- **BaseSpec on login:** Imported Pawn profiles keep `BaseSpec` scalers after reload (no stale flat-copy into class weights).
- **Receipt bag upgrades:** Uses full `EvaluateUpgrade` / fast-path — same engine as tooltips and bag arrows.

### Data & engine fixes

- TBC set ID corrections (Malorne/Nordrassil, Cyclone, S4 Priest heal, T6 tokens).
- Expanded `SetBonusScores` for crafted, dungeon, T5/T6, and arena sets.
- **ContentPhase gem gating** — P1 gems through Phase 2; BT/Hyjal (P3+) and Sunwell (P5+) gem tiers unlock via the **Roadmap** phase dropdown.
- ProcDB trinkets, gem Mode 2 partial sockets, set bonus double-count, and custom-weight import fixes.

---

## 🚀 Key Features

### 🧠 Dynamic "Cap Guardian" Engine

The Judge watches your stats in real-time and penalizes gear that would drop you below critical thresholds.

**Two mechanisms work together:**

1. **Weight scalers (proactive):** Class `ApplyScalers` and TBC `BuffEngine` reduce hit/defense *weights* as you approach effective caps — affects how all items score.
2. **Cap Guardian (reactive):** `EvaluateUpgrade` compares your live rating + gear-simulated delta. If you are at/above a cap and a swap would drop you below the target, a score penalty and tooltip warning are applied.

- **Raid-buffed scoring:** Enable **Assume Raid Buffed** to credit common TBC raid buffs/debuffs when calculating how much hit you still need from gear.
- **World buff assumptions:** Optionally model classic world buffs for leveling and vanilla content.
- **Tank defense protocol:** Cap Guardian enforces defense skill floors for tank profiles — **490** at level 70 (TBC) or **level×5+140** on Era (440 at 60). Only applies when your active profile weights defense.
- **Hybrid live preview:** Tooltips answer *"if I swap this piece, where does my hit land?"* using your real sheet rating plus a gear-simulated delta — without requiring you to equip the item.

### 🔮 Smart Projection (SimC-Lite)

- **Gem simulator (TBC):** Three gemming strategies — **The Skeptic** (empty sockets = 0), **The Casual** (respect socket colors), **The Pro** (min-max, including off-color gems). Partially socketed items are handled correctly in Casual mode.
- **Gem quality tier:** Project sockets using Common, Uncommon, Rare, or Epic gem cuts.
- **Enchant projector:** Compare items as if they had the best available enchant for your level and spec.
- **Meta gem enforcement:** Detects when a gear swap would deactivate your Meta Gem and adjusts the score.
- **Progression-aware gem pool:** On TBC progression servers, the available projected gems follow **Content Phase** (P1–2 = Kara/Gruul cuts; P3+ and P5+ unlock later tiers when set in Roadmap).

### 📊 Tooltip Verdicts

Hover any item — world drops, vendor goods, quest rewards, dungeon loot, or AH listings.

- **Judge's Score:** Calculated power for your active spec (or tracked off-specs).
- **Upgrade / Downgrade verdict** with score delta.
- **Context warnings:** Cap breaks, set bonus loss, meta deactivation, missing enchants, off-hand requirements, and more.
- **Shift-only mode:** Optionally show verdicts only while holding **Shift**.
- **Async cache protection:** Quest and uncached items wait for server data instead of showing a bogus 0-score.

### 🎒 Bag, Loot & Quest Overlays

**Opt-in by default** — enable in Settings → Interface Options.

- **Bag upgrade arrows** (`ShowBagArrows`, **off** by default): Green/red arrows on items in your bags (Blizzard bags, **Bagnon**, **ElvUI**, **Baganator**, **XLoot**).
- **Fast bag arrows** (`FastBagArrows`, **on** when bag arrows are enabled): Quick single-slot scoring; automatically uses full evaluation for set pieces and weapons.
- **Loot roll arrows** (`ShowLootArrows`, **off** by default): Highlights the best upgrade on group loot popups.
- **Quest reward overlays:** Marks the best choice among quest reward options.

### 🧾 The Gear Receipt

An auditing panel for your current loadout (`/sgj` → **Receipt**).

- **Per-slot scores** on your paperdoll.
- **Bag scan:** Flags slots where a better item in your bags would be a full upgrade (same `EvaluateUpgrade` engine as tooltips).
- **Enchant police:** Warns on missing enchants for valid enchant slots.
- **Stat summary:** Top weighted stats for your current build.

### ⚔️ Weapon Thunderdome (built-in)

Core `/sgj` tab — compare **2H vs. dual wield** weapon layouts (6 weapon slots) without equipping gear. This is **not** the full Laboratory paperdoll.

### 🔬 The Laboratory Plugin

*(Separate addon: **SharpiesGearJudge_Laboratory** — required for full virtual paperdoll)*

- **Virtual paperdoll:** Drag items from chat or bags to test loadouts without equipping.
- **All armor slots:** Full gear comparison beyond the core weapon thunderdome.

### 🗺️ The Roadmap Plugin

*(Separate addon: **SharpiesGearJudge_Roadmap** — required for Content Phase UI)*

- Zone and dungeon loot rankings using SGJ scoring.
- **Content Phase** dropdown sets `SGJ_Settings.ContentPhase` and rebuilds the gem projection pool for that progression tier. Without Roadmap, the phase setting exists but has no in-core UI.
- Buff assumptions flow into Roadmap scoring when using manual profile overrides.

### 👥 Multi-Spec & Saved Baselines

- **Tracked specs:** Enable secondary specs in **Settings → Secondary Specs & Baselines**. Tooltips show upgrade lines for each tracked profile.
- **Save Profile:** Snapshot your **currently equipped gear** as a baseline for a spec. Off-spec comparisons use *(Saved)* gear instead of what you happen to be wearing — essential for healers evaluating DPS drops while in heal gear.
- **Clear Profile:** Remove a saved baseline per spec.

---

## 💻 Slash Commands


| Command            | Action                                                           |
| ------------------ | ---------------------------------------------------------------- |
| `/sgj` or `/judge` | Open the **Main Menu** (Receipt, Settings, Import, etc.)         |
| `/sgj config`      | Open **Settings** directly                                       |
| `/sgj import`      | Open the **weight import** window (Pawn strings, Sixty Upgrades) |
| `/sgj simple`      | Toggle shortened stat names in tooltips                          |
| `/sgj colors`      | Toggle stat colorization in tooltips                             |


---

## ⚙️ Settings Guide

Open **Settings** from the main menu or `/sgj config`.

### Interface Options

- **Hide Minimap Button** — Remove the circular minimap icon.
- **Hide Tooltip Verdict** — Disable SGJ lines on item tooltips.
- **Show Only via Shift Key** — Verdicts appear only while holding Shift.
- **Show Bag Upgrade Arrows** — **Off by default.** Green/red arrows on bag items.
- **Fast Bag Arrows** — On by default; only applies when bag arrows are enabled. Single-slot scoring for bags (full eval for sets/weapons).
- **Show Loot Roll Arrows** — **Off by default.** Arrows on group loot frames.

### Comparison Logic

- **Enchant Mode** — Off (raw stats) / Current Only / Project Best.
- **Gemming Logic** — The Skeptic / The Casual / The Pro.
- **Gem Quality** — Common / Uncommon / Rare / Epic tier used when projecting empty sockets.

### Buff Assumptions (TBC)

- **Assume Raid Buffed** — Credit raid buffs and debuffs (ToW, IFF, Kings, MotW, Draenei in raid, etc.).
- **Raid Buff Preset** — Off / 25-Man Full / 10-Man Minimal.
- **Assume World Buffed** — Credit classic world buffs (usually off at 70 in Outland).
- **World Buff Preset** — Off / Full World Buffed / DM Tribute Only.

Your personal racials (e.g. Draenei +1% Hit) are always applied. Enable raid assumptions to model a Draenei in your raid buffing everyone via Heroic Presence.

### Character Profile

- **Active Scoring Profile** — **Auto-Detect** uses talent capstones + point-scan fallbacks. Does **not** auto-select imported Pawn profiles. Hybrid builds with points spread across trees may show an **uncertain** hint in Stat Logic — pick a profile manually if needed.
- **Imported profiles:** Select explicitly; `BaseSpec` from import drives hit-cap scalers for that profile.

### Secondary Specs & Baselines

- Check specs to **track** in tooltips.
- **Save Profile** — Store current equipped gear as that spec's comparison baseline.
- **Clear** — Remove saved baseline for a spec.

---

## 📥 Importing Custom Weights

Power users can import **Pawn-format strings** (export from SimC/WowSims) or **Sixty Upgrades** JSON/URL/CSV.

1. Copy your Pawn string or Sixty Upgrades export.
2. Type `/sgj import` in-game.
3. Paste and confirm. The addon creates a custom profile stored in `SharpiesGearJudgeDB`.

Imported Pawn profiles with a `BaseSpec` field apply the correct class scalers on login and after reload.

---

## 📥 Installation & Compatibility

Unified codebase — the addon detects your client automatically:


| Client                      | Support                                                           |
| --------------------------- | ----------------------------------------------------------------- |
| **Classic Era (1.15.x)**    | Hit %, Defense Skill, T0–T3 sets, vanilla proc logic              |
| **TBC Anniversary (2.5.x)** | Combat ratings, gems, meta gems, TBC sets, progression gem phases |


### Install

1. Download the latest release.
2. Extract the `SharpiesGearJudge` folder.
3. Place in:
  - `_classic_era_/Interface/AddOns` — Vanilla / Era
  - `_classic_/Interface/AddOns` — TBC Anniversary

### Optional plugins

- **SharpiesGearJudge_Laboratory** — Virtual paperdoll / loadout testing.
- **SharpiesGearJudge_Roadmap** — Zone loot rankings and Content Phase control.

### Supported bag addons

Blizzard default bags, **Bagnon**, **ElvUI Bags**, **Baganator**, **XLoot** (loot rolls).

### Localization

English (default) plus **deDE**, **esES**, **frFR**, **ptBR**, **ruRU**.

---

## 🏗️ How It Works (Brief)

```
Item tooltip / bag link
    → Parse.lua (scan stats, procs, sockets, set headers)
    → Helpers.lua (raw stats, ProcDB, gem/enchant projection)
    → Evaluator.lua (character score, upgrade delta, cap guardian)
    → Judge.lua / Interface.lua (draw tooltip verdict or bag arrow)
```

Set bonuses, meta requirements, weapon specialization, and raid-buff-adjusted caps are applied in the scoring engine — not as flat per-stat multipliers on individual items.

---

## Credits

- **Author:** SuperSharpie
- **Version:** 2.6.0 (TBC Anniversary Ready)
- **GitHub:** [Supersharpie/SharpiesGearJudge](https://github.com/Supersharpie/SharpiesGearJudge)
- **Discord:** [Join the Theorycrafting Hub](https://discord.gg/aYmhmtGxYs)
- **Feedback:** Found a weight that feels off? Drop by the Discord or open an issue on GitHub!

For detailed version history, see [CHANGELOG.md](CHANGELOG.md).