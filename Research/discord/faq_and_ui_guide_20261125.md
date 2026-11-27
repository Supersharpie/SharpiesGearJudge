# Discord rewrites: #faq and #ui-guide-and-info (drafted 2026-11-25)

Each "Message N" block is under Discord's 2,000-character limit. Delete the old posts and paste these in order,
or edit the old posts in place (the #faq had 4 posts, #ui-guide had 1 post plus an image).

What changed from the February posts:
- The addon now **equips** (Equip Best Upgrade keybind / `/sgj equip`). The old FAQ said it never would.
- Forever weights come from **sims and leveling models**, level by level from 10 to 59, not "community theorycrafting"
  and not "brackets 1-69".
- New: Talents plugin, Roster, Spell Impact, Gear for PvP / Raiding, enchanter help, Pawn/Zygor answer kept.
- UI: the window now has **Weapon Thunderdome, Receipt, Stat Logic, Spell Impact (Forever), Settings**; the
  Laboratory is its own plugin (the old guide mixed it up with the Thunderdome). The Receipt is 3 columns now.
- Laboratory no longer claims SeventyUpgrades/SimC import (the core imports Pawn strings and Sixty Upgrades).

---

## #faq

### Message 1

```
# 📘 Sharpie's Gear Judge (SGJ): The FAQ
Works on **Classic Era**, **TBC Anniversary** and **WoW: Forever**. One download; it detects your game.

## ⚔️ General Features

**Q: Can it tell me if an item is a real upgrade, even with different stats?**
A: Yes. SGJ turns every stat into what it's worth for your class, spec, level and talents, then compares your whole character with and without the item. The tooltip shows Upgrade or Downgrade with the difference.

**Q: Can it compare a two-hander against a main-hand + off-hand?**
A: Yes. Hover a two-hander while dual wielding (or with a shield) and SGJ pairs it against your best one-hand setup from your bags, so the comparison is fair. The **Weapon Thunderdome** tab compares six weapon setups side by side.

**Q: Does it count enchants (and gems on TBC) before I put them on?**
A: Yes. Set **Enchant Mode** to Project Best and items are judged as if they had the best enchant for your spec and level. On TBC it also projects gems and warns when a swap would turn off your Meta Gem.

**Q: Will it warn me if I break a set bonus?**
A: Yes. The tooltip warns when a swap drops a set bonus and shows when an item completes one.

**Q: Will it equip the best gear for me?**
A: Yes, one item at a time. Bind **Equip Best Upgrade** (Key Bindings → AddOns → Sharpie's Gear Judge) or type `/sgj equip`. Each press puts on the biggest upgrade in your bags (out of combat). Bind-on-Equip items ask first. It works in a macro, so it can go on a controller button.

**Q: Can it track gear for my off-spec or my alts?**
A: Yes. Tick off-specs in **Settings → Off-Specs** and tooltips add an upgrade line for each. With dual spec, each spec keeps its own profile. The **Roster** plugin shows which of your alts an item upgrades.
```

### Message 2

```
**Q: Can I run it alongside Pawn or Zygor's gear scorer?**
A: Not recommended. Two gear scorers give you two different answers and a crowded tooltip. SGJ warns once on login if it sees Pawn or Zygor; turn the warning off with **Disable Conflict Check**.

**Q: Does it have a built-in BiS list?**
A: No, on purpose. Your best item depends on what you already wear: a "BiS" hit helm is a downgrade if it pushes you past the hit cap. SGJ judges each item against your own gear. To plan upgrades, the **Roadmap** plugin ranks dungeons and quest zones by the upgrades they hold for you, and the **Laboratory** plugin lets you build and compare whole sets.

**Q: Era players: do the gem features work?**
A: No. Era has no sockets, so gems and Meta Gems are TBC only. Everything else works on every client.

## 🌳 WoW: Forever

**Q: Where do the Forever weights come from?**
A: From simulations, not guesswork. Level-60 damage and tank weights come from the wowsims Forever simulator, healers from a healing model with downranking. Leveling weights (10-59) come from leveling models for every spec: they ask "how much faster does this stat make me level?" with the talents, spells and quest/dungeon gear each spec really has at that level. Models are checked against Warcraft Logs.

**Q: Which profile does it use?**
A: Auto-Detect picks from your talents: Solo Leveling, Dungeon Leveling, PvP Leveling, AoE Farming, PvP or Raid. With the **Talents** plugin, the weights follow the build you picked. You can always pick one by hand in **Settings → Character Profile**.

**Q: What is Spell Impact?**
A: A tooltip block showing how an item changes your main spells now vs. with the item: damage or healing per second and per mana for casters, auto-attack and ability damage for melee. `/sgj spells` opens its tab, where you can add your own spells.
```

### Message 3

```
**Q: Gear for PvP? Gear for Raiding?**
A: **Gear for PvP** (`/sgj pvp`, off by default) scores gear for fighting players: Stamina, armor and burst count for more. **Gear for Raiding** (on by default) slides hit and tank defense toward raid caps from level 50; turn it off if you won't raid.

**Q: I'm an enchanter. Does it help?**
A: Yes (from 3.9.0). Enchanting recipes show what the enchant is worth on your gear, off-specs and alts, the best recipe per slot gets a green arrow, Projected Enchant says whether you know the recipe, and gear nobody can use gets a disenchant mark in your bags.

## 🧮 Under the Hood

**Q: Are the weights the same at level 20 and level 60?**
A: No. On Forever, leveling weights are set level by level from 10 to 59, and your talents and gear adjust them. At 60 they're set per spec and role. Era and TBC use their own leveling and endgame profiles.

**Q: Why does a useless stat show a tiny value like 0.02?**
A: So an otherwise great item isn't thrown out for having one off-stat. A hard 0 means the stat really does nothing for you.

**Q: What happens at my hit or defense cap?**
A: The **Cap Guardian** watches your gear. Hit and defense count for less as you near the cap, and a swap that would drop you below it gets a penalty and a red warning. `/sgj hitcheck` shows your hit, where it comes from, and your target. Gear is judged without the buffs you happen to have on; turn on **Assume Raid Buffed** or **World Buffed** to count them.

**Q: Does it simulate my rotation during a fight?**
A: Not live in game. The weights come from simulations and models run outside the game; in game SGJ scores your gear with them and adjusts for caps, talents and level.

**Q: Can I use my own weights?**
A: Yes. `/sgj import` takes a Pawn string (from SimC or WowSims) or a Sixty Upgrades export and makes a profile you can pick in Settings.
```

### Message 4

```
**Q: What does the Talents plugin do?**
A: A talent guide from 10 to 60. The next talent glows in your talent window, a side panel shows your progress, and **Learn Next** stages your build's next points for you. All builds: <https://sharpiesgearjudge.web.app>

**Q: Off-hand weapons when dual wielding?**
A: Off-hand damage is counted at its real share, and a one-hander is judged in the hand where it gains the most.

## 🛠️ Commands & Help
`/sgj` open the window · `/sgj config` settings · `/sgj equip` equip best upgrade · `/sgj spells` Spell Impact · `/sgj pvp` Gear for PvP · `/sgj hitcheck` your hit and targets · `/sgj talents` what SGJ reads from your talents · `/sgj whatsnew` What's New · `/sgjwipe` reset settings

Something look wrong? Post in **#bug-reporting** with your class, level, the item, and a screenshot of the tooltip. Ideas go in **#feature-requests**.
```

---

## #ui-guide-and-info

### Message 1

```
# 🖥️ Sharpie's Gear Judge: Interface Guide
Open the window with `/sgj` (or the minimap button). The tabs down the side:

## ⚔️ Weapon Thunderdome
Compare weapon setups without equipping them. Drag items from your bags (or Shift/Ctrl-click) into six slots: two two-handers, two one-hand + off-hand/shield, and two dual-wield pairs. The winner is highlighted, with a ranking of every setup.

## 🧾 Receipt
Your equipped gear at a glance, in three columns:
• **Left:** your profile, total score and alerts ("2 missing enchants", "1 better item in your bags"). Click an alert to flash the slots it means.
• **Middle:** your character, with each slot's score beside it. Click a slot for its score breakdown.
• **Right:** your weighted stat totals.

## 📐 Stat Logic
Why items score the way they do. At the top, cap rings for your role (hit, spell hit, defense and the like) turn green at the cap. Below, every stat your profile weighs, with its weight and how much you have. Hover a bar for what the stat does and the math.

## ✨ Spell Impact (WoW: Forever)
Your main spells with your current gear: per cast, per second and per mana. Drag in, shift-click or hover an item to see the change. **Add Spell** adds any other damage or healing spell you know. Also holds the Spell Impact tooltip options.
```

### Message 2

```
## ⚙️ Settings
• **Interface:** minimap button, tooltip on/off or Shift-only, bag upgrade arrows (on by default), loot roll arrows, loot upgrade alerts.
• **Tooltip Visuals:** compact text, short stat names, stat colors, Spell Impact options.
• **Comparison Logic:** Enchant Mode (raw stats / current enchants / project best), gems on TBC, and shield tanks ignoring two-handers.
• **Buff Assumptions:** Assume Raid Buffed or World Buffed, consumables, and on Forever **Gear for Raiding** and **Gear for PvP**.
• **Character Profile:** Auto-Detect or pick a profile by hand, import Pawn / Sixty Upgrades weights.
• **Off-Specs:** tick the other profiles this character plays.

## 🧩 Plugins (separate downloads, each adds its own tab or window)
• **Talents** (Forever): talent guide, glowing next talent, Learn Next.
• **Roadmap:** dungeons and quest zones ranked by upgrades for you; `/sgjq` lists quests in your zone (with QuestieDB).
• **Roster:** which alts an item upgrades, a gear grid of all your characters, and the BoE Finder.
• **Laboratory:** a virtual paperdoll to build and compare whole sets.
• **XP:** experience bar with rested XP, quest turn-ins and upgrades waiting in your bags.

## 🎒 Outside the window
• Green/red **bag arrows** on upgrades (Blizzard bags, Bagnon, ElvUI, Baganator, GudaBags, DaylightUI).
• **Loot alerts** when you loot an upgrade; click to equip.
• **Quest reward** marks on the best choice, and green arrows on recipes that craft an upgrade.
• **Equip Best Upgrade** keybind or `/sgj equip`.
```
