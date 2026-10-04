local addonName, MSC = ...
_G.MSC = MSC 

-- [[ SPEED OPTIMIZATION: LOCALIZED FUNCTIONS ]]
local pairs, next = pairs, next
local tonumber = tonumber

local GetNumTalentTabs = GetNumTalentTabs
local GetNumTalents = GetNumTalents
local GetTalentInfo = GetTalentInfo
local GetTalentTabInfo = GetTalentTabInfo
local C_SpecializationInfo = C_SpecializationInfo
local UnitClass = UnitClass
local CreateFrame = CreateFrame
local C_Timer = C_Timer
local UIDropDownMenu_SetText = UIDropDownMenu_SetText

-- =========================================================================
-- 1. TALENT CACHING SYSTEM 
-- =========================================================================
MSC.TalentCache = {}
MSC.TalentCacheLoaded = false

MSC.CachedWeights = nil
MSC.CachedSpecKey = nil
MSC.CachedWeightsBySpec = {}
MSC.ScoringRevision = 0
MSC.EquippedSlotScoreCache = {}

function MSC:BumpScoringRevision()
    MSC.ScoringRevision = (MSC.ScoringRevision or 0) + 1
    MSC.CachedWeights = nil
    MSC.CachedSpecKey = nil
    MSC.CachedCapText = nil
    if MSC.CachedWeightsBySpec then wipe(MSC.CachedWeightsBySpec) end
    if MSC.EquippedSlotScoreCache then wipe(MSC.EquippedSlotScoreCache) end
    if MSC.ProcessedStatCache then wipe(MSC.ProcessedStatCache) end
    if MSC.ColorMatchCache then wipe(MSC.ColorMatchCache) end
    if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
    if MSC.UsableCache then wipe(MSC.UsableCache) end
    if MSC.UpdateSetBonusScores and MSC.GetCurrentWeights then
        local weights = MSC.GetCurrentWeights()
        if weights then MSC:UpdateSetBonusScores(weights) end
    end
end

function MSC:ApplyWeightPipeline(rawWeights, specKey)
    local finalWeights = {}
    if rawWeights then
        for k, v in pairs(rawWeights) do finalWeights[k] = v end
    end
    local capText = nil
    if MSC.CurrentClass and MSC.CurrentClass.ApplyScalers then
        finalWeights, capText = MSC.CurrentClass:ApplyScalers(finalWeights, specKey)
    end
    if MSC.BuffEngine and MSC.BuffEngine.ApplyStatSynergy then
        MSC.BuffEngine:ApplyStatSynergy(finalWeights, specKey)
    end
    return finalWeights, capText
end

function MSC:LookupRawWeights(profileName)
    if not profileName or not MSC.CurrentClass then return nil, profileName end
    local rawWeights, specKey, mathSpec = nil, profileName, nil

    if SharpiesGearJudgeDB and SharpiesGearJudgeDB.customWeights and SharpiesGearJudgeDB.customWeights[profileName] then
        local data = SharpiesGearJudgeDB.customWeights[profileName]
        if type(data) == "table" and data.weights then
            rawWeights = data.weights
            if data.BaseSpec then mathSpec = data.BaseSpec end
        else
            rawWeights = data
        end
    end

    if not rawWeights and MSC.CurrentClass.GetDynamicWeights then
        local dynWeights, dynKey = MSC.CurrentClass:GetDynamicWeights(profileName)
        if dynWeights then rawWeights = dynWeights; specKey = dynKey end
    end

    if not rawWeights then
        if MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[profileName] then
            rawWeights = MSC.CurrentClass.Weights[profileName]
        elseif MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[profileName] then
            rawWeights = MSC:GetLevelingRow(MSC.CurrentClass, profileName)
        elseif MSC.CurrentClass.Profiles and MSC.CurrentClass.Profiles[profileName] then
            rawWeights = MSC.CurrentClass.Profiles[profileName]
        elseif MSC.CurrentClass.LevelingBrackets and MSC.CurrentClass.LevelingBrackets[profileName] then
            rawWeights = MSC.CurrentClass.LevelingBrackets[profileName]
        end
        if not mathSpec and SharpiesGearJudgeDB and SharpiesGearJudgeDB.customWeights and SharpiesGearJudgeDB.customWeights[profileName] then
            local data = SharpiesGearJudgeDB.customWeights[profileName]
            if type(data) == "table" and data.BaseSpec then mathSpec = data.BaseSpec end
        end
    end

    return rawWeights, specKey, mathSpec
end

function MSC:GetProfileWeights(profileName)
    if not profileName then
        return MSC.GetCurrentWeights()
    end

    if MSC.CachedWeightsBySpec[profileName] then
        return MSC.CachedWeightsBySpec[profileName]
    end

    local rawWeights, specKey, mathSpec = MSC:LookupRawWeights(profileName)
    if not rawWeights then return nil end

    local finalWeights = select(1, MSC:ApplyWeightPipeline(rawWeights, mathSpec or specKey))
    MSC.CachedWeightsBySpec[profileName] = finalWeights
    return finalWeights, specKey
end

-- Talent names are matched ignoring case and spaces: Forever's patch notes and
-- data sites don't always agree on spacing ("Rage of the Farseer" vs "Rage of
-- the Far Seer"), and one exact-match miss silently breaks spec detection.
local function TalentKey(name)
    return (name:lower():gsub("%s+", ""))
end

-- Forever's client removed the Classic talent globals (GetNumTalents,
-- GetTalentInfo, and the tab/index form of GetTalentTabInfo) in favour of
-- C_SpecializationInfo, which exposes each talent tree as a "specialization".
-- Its GetTalentInfo has no talentIndex lookup there ("query.tier must be
-- specified"), so the tree is walked by tier/column grid position instead.
-- The grid bounds cover Classic/TBC trees (9 tiers x 4 columns) with room to
-- spare. Each call is pcall'd so an empty or invalid cell is skipped rather
-- than raising an error on every tooltip.
local MAX_TALENT_TIERS, MAX_TALENT_COLUMNS = 11, 4

-- Forever's talent window is the modern trait system (Blizzard_PlayerSpells,
-- Camelot overrides): one trait tree per class whose node groups are the
-- three Classic trees, in Classic tab order. Talents are trait nodes, read
-- from the active spec group's config. Returns configID, treeID or nil
-- (Classic Era / TBC have no class-talent trait config and use the globals).
local function GetTraitTalentConfig()
    if not (C_Traits and C_Traits.GetConfigInfo and C_Traits.GetTreeNodes and C_Traits.GetNodeInfo) then return nil end
    local configID
    local spec = C_SpecializationInfo
    if spec and spec.GetActiveSpecGroup and spec.GetCombatConfigIDForSpecGroup then
        local ok, group = pcall(spec.GetActiveSpecGroup)
        if ok and group then
            local ok2, id = pcall(spec.GetCombatConfigIDForSpecGroup, group)
            if ok2 then configID = id end
        end
    end
    if not configID and C_ClassTalents and C_ClassTalents.GetActiveConfigID then
        local ok, id = pcall(C_ClassTalents.GetActiveConfigID)
        if ok then configID = id end
    end
    if not configID then return nil end
    local ok, info = pcall(C_Traits.GetConfigInfo, configID)
    local treeID = ok and info and info.treeIDs and info.treeIDs[1]
    if not treeID then return nil end
    return configID, treeID
end

local function GetTraitNodeName(configID, node)
    local entryID = (node.activeEntry and node.activeEntry.entryID) or (node.entryIDs and node.entryIDs[1])
    if not entryID then return nil end
    local ok, entry = pcall(C_Traits.GetEntryInfo, configID, entryID)
    if not ok or not entry or not entry.definitionID then return nil end
    local okDef, def = pcall(C_Traits.GetDefinitionInfo, entry.definitionID)
    if not okDef or not def then return nil end
    local name = def.overrideName
    if (not name or name == "") and def.spellID then
        if C_Spell and C_Spell.GetSpellName then name = C_Spell.GetSpellName(def.spellID)
        elseif GetSpellInfo then name = GetSpellInfo(def.spellID) end
    end
    if name == "" then return nil end
    return name
end

-- Calls fn(name, rank, tab, node) for every named talent node in the trait
-- tree (node is the C_Traits node info: .ID, .maxRanks, ...). Returns false
-- when this client has no class-talent trait config.
function MSC.ForEachTraitTalent(fn)
    local configID, treeID = GetTraitTalentConfig()
    if not configID then return false end

    local tabOfGroup = {}
    local okD, displays = pcall(C_Traits.GetGroupDisplayInfoByTreeID, treeID)
    if okD and type(displays) == "table" then
        for i, d in ipairs(displays) do
            if d.groupID then tabOfGroup[d.groupID] = i end
        end
    end

    local okN, nodes = pcall(C_Traits.GetTreeNodes, treeID)
    if not okN or type(nodes) ~= "table" then return false end
    for _, nodeID in ipairs(nodes) do
        local okI, node = pcall(C_Traits.GetNodeInfo, configID, nodeID)
        if okI and type(node) == "table" and node.ID and node.ID ~= 0 then
            local name = GetTraitNodeName(configID, node)
            if name then
                local tab
                for _, groupID in ipairs(node.groupIDs or {}) do
                    if tabOfGroup[groupID] then tab = tabOfGroup[groupID]; break end
                end
                fn(name, tonumber(node.activeRank) or tonumber(node.ranksPurchased) or 0, tab, node)
            end
        end
    end
    return true
end

-- Calls fn(name, rank) for each talent in the tab; stops early if fn returns true.
function MSC.ForEachTalent(tab, fn)
    if MSC.TraitTalentData then
        for _, t in ipairs(MSC.TraitTalentData) do
            if t.tab == tab and fn(t.name, t.rank) then return end
        end
        return
    end
    if GetNumTalents then
        for i = 1, GetNumTalents(tab) or 0 do
            local name, _, _, _, rank = GetTalentInfo(tab, i)
            if name and fn(name, tonumber(rank) or 0) then return end
        end
        return
    end
    local getTalent = C_SpecializationInfo and C_SpecializationInfo.GetTalentInfo
    if not getTalent then return end
    for tier = 1, MAX_TALENT_TIERS do
        for column = 1, MAX_TALENT_COLUMNS do
            local ok, info = pcall(getTalent, { specializationIndex = tab, tier = tier, column = column })
            if ok and type(info) == "table" and info.name
                and fn(info.name, tonumber(info.rank) or 0) then
                return
            end
        end
    end
end

function MSC.GetTabPointsSpent(tab)
    if not MSC.TalentCacheLoaded then MSC:BuildTalentCache() end
    if MSC.TraitTalentData then
        local total = 0
        for _, t in ipairs(MSC.TraitTalentData) do
            if t.tab == tab then total = total + t.rank end
        end
        return total
    end
    if GetNumTalents and GetTalentTabInfo then
        local _, _, _, _, pointsSpent = GetTalentTabInfo(tab)
        return tonumber(pointsSpent) or 0
    end
    local total = 0
    MSC.ForEachTalent(tab, function(_, rank) total = total + rank end)
    return total
end

function MSC:BuildTalentCache()
    MSC.TalentCache = {}
    MSC.TraitTalentData = nil

    -- Forever: read the trait tree (see GetTraitTalentConfig). Only used when
    -- it actually yields talents; otherwise fall through to the Classic path.
    local traitData = {}
    if MSC.ForEachTraitTalent(function(name, rank, tab)
        table.insert(traitData, { name = name, rank = rank, tab = tab })
    end) and #traitData > 0 then
        for _, t in ipairs(traitData) do
            local k = TalentKey(t.name)
            MSC.TalentCache[k] = math.max(MSC.TalentCache[k] or 0, t.rank)
        end
        MSC.TraitTalentData = traitData
        MSC.TalentCacheLoaded = true
        return
    end

    if not GetNumTalentTabs then
        MSC.TalentCacheLoaded = true
        return
    end

    local tabs = GetNumTalentTabs() or 0
    if tabs == 0 then return end

    for t = 1, tabs do
        MSC.ForEachTalent(t, function(name, rank)
            MSC.TalentCache[TalentKey(name)] = rank
        end)
    end
    MSC.TalentCacheLoaded = true
end

function MSC:GetTalentRank(talentKey)
    if not MSC.CurrentClass or not MSC.CurrentClass.Talents then return 0 end

    if not MSC.TalentCacheLoaded then 
        self:BuildTalentCache() 
        if not MSC.TalentCacheLoaded then return 0 end
    end

    local localizedName = MSC.CurrentClass.Talents[talentKey]
    if not localizedName then return 0 end

    return MSC.TalentCache[TalentKey(localizedName)] or 0
end

-- Returns spec key from dominant talent tree when capstones are ambiguous.
-- tabMap: { [tabIndex] = "SPEC_KEY", ... }; margin = minimum point lead required.
function MSC:GetDominantTalentTree(tabMap, margin)
    if not tabMap then return nil, "ambiguous" end
    margin = margin or 5
    local maxPts, secondPts = 0, 0
    local maxTab = nil
    for tab, _ in pairs(tabMap) do
        local p = MSC.GetTabPointsSpent(tab)
        if p > maxPts then
            secondPts = maxPts
            maxPts = p
            maxTab = tab
        elseif p > secondPts then
            secondPts = p
        end
    end
    if maxTab and maxPts > 0 then
        if (maxPts - secondPts) >= margin then
            return tabMap[maxTab], "low"
        end
        return tabMap[maxTab], "ambiguous"
    end
    return nil, "ambiguous"
end

-- Leveling role detection (levels 11-59). Early levels only reach talent
-- tiers 1-3, and several common DPS leveling picks sit inside the tank/
-- healer trees (Paladin Divine Strength in Holy, Druid Furor in Restoration,
-- Priest Wand Specialization in Discipline), so raw tree points can't tell
-- the roles apart. Each class instead lists the "marker" talents only that
-- role would take (checked against Forever's talent data on
-- wowforevertools.com); a class's GetSpec falls back to its DPS bracket when
-- the matching role profile doesn't exist for the player's level:
--   roleMarkers = { [profilePrefix] = { "TALENT_KEY", ... }, ... }
-- Returns the prefix whose markers hold the most points, or nil if none/tied.
-- A build chosen in the Talents plugin names the leveling role and endgame
-- profile it is built for, so the weights follow the build even before its
-- marker talents are taken. leveling is a LowLevelRoles key (e.g.
-- "Leveling_Tank") or "Leveling" for the class's default chain; endgame is a
-- Weights key used at 60. nil, nil clears it.
function MSC.SetTalentBuildRole(leveling, endgame)
    local cur = MSC.TalentBuildRole
    if (cur and cur.leveling) == leveling and (cur and cur.endgame) == endgame then return end
    MSC.TalentBuildRole = (leveling or endgame) and { leveling = leveling, endgame = endgame } or nil
    MSC.CachedWeights = nil
end

function MSC:GetLowLevelRole(roleMarkers)
    if not roleMarkers then return nil end
    local forced = MSC.TalentBuildRole and MSC.TalentBuildRole.leveling
    if forced then
        if roleMarkers[forced] then return forced end
        if forced == "Leveling" then return nil end
    end
    local bestRole, bestPts, tied = nil, 0, false
    for role, keys in pairs(roleMarkers) do
        local pts = 0
        for _, key in ipairs(keys) do pts = pts + self:GetTalentRank(key) end
        if pts > bestPts then
            bestRole, bestPts, tied = role, pts, false
        elseif pts > 0 and pts == bestPts then
            tied = true
        end
    end
    if tied then return nil end
    return bestRole
end

-- Forever leveling blend (TBC-style smooth weights). Each LevelingWeights row
-- "<role>_<lo>_<hi>" holds the weights at level <lo>; between <lo> and the
-- next band's start the weights slide linearly toward that band's row (same
-- role, or the module's LevelingNext[key] when the chain changes name, e.g.
-- Paladin Leveling_41_51 -> Leveling_Ret_52_59). A role's last band holds
-- flat. Levels outside the band clamp, so previewing another band's profile
-- shows its start (below) or end (above) weights. Era/TBC rows pass through.
local function ParseLevelingBand(key)
    local role, lo, hi = string.match(key, "^(Leveling.-)_(%d+)_(%d+)$")
    return role, tonumber(lo), tonumber(hi)
end

-- Forever per-spec curves (Classes/Forever/Curves/<Class>_Curves.lua): an ordered
-- list of { level, weights } keyframes. Linear between keyframes, flat
-- outside them. A stat missing from one keyframe counts as 0 there; explicit
-- 0s are kept in the result (MSC_WEAPON_DPS_MELEE = 0 is an override), and a
-- blended value that lands in the scorer's 0-0.02 "useless" band becomes 0.
function MSC.EvaluateLevelingCurve(curve, level)
    local n = #curve
    if n == 0 then return {} end
    local a, b = curve[1], curve[n]
    if level <= a[1] then b = a
    elseif level >= b[1] then a = b
    else
        for i = 1, n - 1 do
            if level >= curve[i][1] and level <= curve[i + 1][1] then a, b = curve[i], curve[i + 1]; break end
        end
    end
    local t = (b[1] > a[1]) and ((level - a[1]) / (b[1] - a[1])) or 0
    local out = {}
    local function put(stat)
        if out[stat] ~= nil then return end
        local va, vb = a[2][stat] or 0, b[2][stat] or 0
        local v = va + (vb - va) * t
        if v > 0 and v < 0.02 then v = 0 end
        out[stat] = v
    end
    for stat in pairs(a[2]) do put(stat) end
    for stat in pairs(b[2]) do put(stat) end
    return out
end

function MSC:GetLevelingRow(module, key)
    local rows = module and module.LevelingWeights
    local row = rows and rows[key]
    if not row or not MSC.IsForever then return row end

    local role, lo, hi = ParseLevelingBand(key)
    if not role then return row end

    -- Per-spec curve: weights at the player's level, held inside the chosen
    -- band so previewing another band's profile shows that band's weights.
    local curves = module.LevelingCurves
    local curve = curves and (curves[role] or (MSC.LevelingCurveAlias and curves[MSC.LevelingCurveAlias[role] or ""]))
    if curve then
        local level = UnitLevel("player")
        if level < lo then level = lo elseif level > hi then level = hi end
        return MSC.EvaluateLevelingCurve(curve, level)
    end

    local nextKey = module.LevelingNext and module.LevelingNext[key]
    local nextLo = nextKey and rows[nextKey] and select(2, ParseLevelingBand(nextKey))
    if not nextLo then
        nextKey = nil
        for k in pairs(rows) do
            local r, l = ParseLevelingBand(k)
            if r == role and l and l > lo and (not nextLo or l < nextLo) then nextKey, nextLo = k, l end
        end
    end
    if not nextKey then return row end

    local t = (UnitLevel("player") - lo) / (nextLo - lo)
    if t <= 0 then return row end
    local nextRow = rows[nextKey]
    if t >= 1 then return nextRow end

    local blended = {}
    for stat, v in pairs(row) do blended[stat] = v + ((nextRow[stat] or 0) - v) * t end
    for stat, v in pairs(nextRow) do
        if row[stat] == nil then blended[stat] = v * t end
    end
    return blended
end

-- =========================================================================
-- 2. WEIGHT DISPATCHER
-- =========================================================================

function MSC:ApplyDynamicAdjustments()
    local _, class = UnitClass("player")
    local specKey = "Default"
    local rawWeights = {}
    local mathSpec = nil
    MSC.CachedSpecConfidence = "high"

    -- 1. CHECK FOR MANUAL OVERRIDE 
    if MSC.ManualSpec and MSC.ManualSpec ~= "AUTO" then
        specKey = MSC.ManualSpec
        local found = false
        
        -- [[ A. PRIORITY 1: CHECK CUSTOM DATABASE (Pawn Imports) ]]
        if SharpiesGearJudgeDB and SharpiesGearJudgeDB.customWeights and SharpiesGearJudgeDB.customWeights[specKey] then
             local data = SharpiesGearJudgeDB.customWeights[specKey]
             
             if type(data) == "table" and data.weights then
                 rawWeights = data.weights
                 if data.BaseSpec then mathSpec = data.BaseSpec end -- Only set mathSpec, leave specKey alone!
             else
                 rawWeights = data
             end
             found = true
        end
        
        -- [[ B. PRIORITY 2: FORCE DYNAMIC CALCULATION ]]
        if not found and MSC.CurrentClass and MSC.CurrentClass.GetDynamicWeights then
            local dynWeights, dynKey = MSC.CurrentClass:GetDynamicWeights(specKey)
            if dynWeights then
                rawWeights = dynWeights
                specKey = dynKey
                found = true
            end
        end
        
        -- [[ C. PRIORITY 3: FALLBACK TO STATIC ]]
        if not found then
            if MSC.CurrentClass and MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[specKey] then
                rawWeights = MSC.CurrentClass.Weights[specKey]
            elseif MSC.CurrentClass and MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[specKey] then
                rawWeights = MSC:GetLevelingRow(MSC.CurrentClass, specKey)
            end
        end
        
    else
        -- 2. AUTO-DETECT MODE
        -- 2a. A Talents-plugin build names its level-60 profile (see
        -- MSC.SetTalentBuildRole); leveling roles are handled in GetLowLevelRole.
        local forcedEnd = MSC.TalentBuildRole and MSC.TalentBuildRole.endgame
        local cls = MSC.CurrentClass
        if forcedEnd and (UnitLevel("player") or 0) >= 60 and cls and cls.Weights and cls.Weights[forcedEnd] then
            specKey = forcedEnd
            rawWeights = cls.Weights[forcedEnd]
        elseif MSC.CurrentClass and MSC.CurrentClass.GetDynamicWeights then
            local dynWeights, dynKey = MSC.CurrentClass:GetDynamicWeights()
            if dynWeights then
                rawWeights = dynWeights
                specKey = dynKey
            end
        end

        -- 3. FALLBACK: STATIC LOOKUP
        if (not rawWeights or not next(rawWeights)) and MSC.CurrentClass and MSC.CurrentClass.GetSpec then
            local conf
            specKey, conf = MSC.CurrentClass:GetSpec()
            MSC.CachedSpecConfidence = conf or "high"
            
            if MSC.CurrentClass.Weights and MSC.CurrentClass.Weights[specKey] then
                rawWeights = MSC.CurrentClass.Weights[specKey]
            elseif MSC.CurrentClass.LevelingWeights and MSC.CurrentClass.LevelingWeights[specKey] then
                rawWeights = MSC:GetLevelingRow(MSC.CurrentClass, specKey)
            end
        end
    end

    -- 4. COPY WEIGHTS (Don't edit the originals!)
    local finalWeights, capText = MSC:ApplyWeightPipeline(rawWeights, mathSpec or specKey)

    return finalWeights, specKey, capText 
end

-- [[ THE MASTER WRAPPER ]] --
function MSC.GetCurrentWeights()
    if MSC.CachedWeights then
        return MSC.CachedWeights, MSC.CachedSpecKey, MSC.CachedCapText, MSC.CachedSpecConfidence
    end

    local w, key, capText = MSC:ApplyDynamicAdjustments()
    
    MSC.CachedWeights = w
    MSC.CachedSpecKey = key
    MSC.CachedCapText = capText
    MSC.CachedSpecConfidence = MSC.CachedSpecConfidence or "high"
    
    -- [[ NUKE TOOLTIP CACHE WHEN PROFILE CHANGES ]]
    if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
    if MSC.SlotCache then wipe(MSC.SlotCache) end
    
    return w, key, capText, MSC.CachedSpecConfidence
end

-- =========================================================================
-- 3. WEAPON SPEC BONUS (Delegated)
-- =========================================================================
function MSC:GetWeaponSpecBonus(itemLink, class, specKey)
    if MSC.CurrentClass and MSC.CurrentClass.GetWeaponBonus then
        return MSC.CurrentClass:GetWeaponBonus(itemLink)
    end
    return 0
end

-- =========================================================================
-- 4. EVENT LISTENER (Cache Invalidation)
-- =========================================================================

-- [[ THE EVENT LISTENER ]]
local talentTracker = CreateFrame("Frame")
talentTracker:RegisterEvent("CHARACTER_POINTS_CHANGED")
talentTracker:RegisterEvent("PLAYER_TALENT_UPDATE")
talentTracker:RegisterEvent("PLAYER_ENTERING_WORLD")
talentTracker:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") 
talentTracker:RegisterEvent("UNIT_INVENTORY_CHANGED")
talentTracker:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
talentTracker:RegisterEvent("PLAYER_LEVEL_UP") -- Forever leveling weights blend by level
-- Forever's trait-based talent window commits through the trait config
-- (unknown events raise an error on Classic clients, hence the pcall)
pcall(talentTracker.RegisterEvent, talentTracker, "TRAIT_CONFIG_UPDATED")

talentTracker:SetScript("OnEvent", function(self, event, unit)
    if event == "UNIT_INVENTORY_CHANGED" and unit ~= "player" then return end

    if event == "PLAYER_TALENT_UPDATE" or event == "CHARACTER_POINTS_CHANGED" or event == "ACTIVE_TALENT_GROUP_CHANGED"
        or event == "TRAIT_CONFIG_UPDATED" then
        MSC.TalentCache = {} 
        MSC.TalentCacheLoaded = false
        MSC:BumpScoringRevision()
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        MSC:BumpScoringRevision()
    else
        MSC.CachedWeights = nil
        MSC.CachedSpecKey = nil
        if MSC.CachedWeightsBySpec then wipe(MSC.CachedWeightsBySpec) end
    end
    
    if MyStatCompareFrame and MyStatCompareFrame:IsShown() and MyStatCompareFrame.ProfileDD then
        local _, detectedKey = MSC.GetCurrentWeights()
        local displayName = detectedKey
        if MSC.PrettyNames and MSC.PrettyNames[detectedKey] then
            displayName = MSC.PrettyNames[detectedKey]
        end
        UIDropDownMenu_SetText(MyStatCompareFrame.ProfileDD, string.format(MSC.L["Auto: %s"], displayName))
    end
end)

-- =========================================================================
-- 5. SET BONUS CALCULATOR
-- =========================================================================
function MSC:UpdateSetBonusScores(weights)
    if not MSC.SetBonusScores or not weights then return end

    local count = 0
    for setID, setStages in pairs(MSC.SetBonusScores) do
        for reqCount, data in pairs(setStages) do
            if data.stats then
                local score = 0
                for stat, val in pairs(data.stats) do
                    local w = weights[stat] or 0
                    if w > 0 then
                        score = score + (val * w)
                    end
                end
                data.score = MSC.Round(score, 1)
                count = count + 1
            end
        end
    end
end

-- [[ AUTO-CALCULATE ON LOAD ]]
local setCalcFrame = CreateFrame("Frame")
setCalcFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
setCalcFrame:SetScript("OnEvent", function(self, event)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    C_Timer.After(2, function()
        if MSC.GetCurrentWeights then
            local weights = MSC.GetCurrentWeights()
            if weights then
                MSC:UpdateSetBonusScores(weights)
            end
        end
    end)
end)

-- =========================================================================
-- BASELINE PROFILE MANAGER
-- =========================================================================

-- Generates a unique key for the current character
function MSC:GetPlayerKey()
    local name = UnitName("player") or "Unknown"
    local realm = GetRealmName() or "Local"
    return name .. "-" .. realm
end

-- Saves the currently equipped gear AND talents to the specific spec
function MSC:SaveBaselineProfile(specName)
    if not SGJ_Settings.GearProfiles then SGJ_Settings.GearProfiles = {} end
    if not SGJ_Settings.TalentProfiles then SGJ_Settings.TalentProfiles = {} end
    
    local playerKey = MSC:GetPlayerKey()
    
    if not SGJ_Settings.GearProfiles[playerKey] then SGJ_Settings.GearProfiles[playerKey] = {} end
    if not SGJ_Settings.TalentProfiles[playerKey] then SGJ_Settings.TalentProfiles[playerKey] = {} end
    
    -- 1. Save Gear
    SGJ_Settings.GearProfiles[playerKey][specName] = MSC:GetEquippedGear()
    
    -- 2. Save Talents (Force a rebuild just to be safe, then copy it)
    MSC:BuildTalentCache()
    SGJ_Settings.TalentProfiles[playerKey][specName] = MSC:SafeCopy(MSC.TalentCache)
    
    -- 3. Flush the cache
    if MSC.EvaluationCache then wipe(MSC.EvaluationCache) end
    if MSC.SlotCache then wipe(MSC.SlotCache) end
    if MSC.StatCache then wipe(MSC.StatCache) end
    
    local prettyName = (MSC.CurrentClass and MSC.CurrentClass.PrettyNames and MSC.CurrentClass.PrettyNames[specName]) or specName
    print(string.format(MSC.L["|cff00ff00SGJ:|r Locked in current gear and talents as the baseline for %s!"], prettyName))
end

function MSC:AutoUpdateBaseline()
    if not SGJ_Settings then return end
    local weights, specName = self.GetCurrentWeights()
    if not weights or not specName then return end

    local playerKey = self:GetPlayerKey()
    if not SGJ_Settings.GearProfiles then SGJ_Settings.GearProfiles = {} end
    if not SGJ_Settings.GearProfiles[playerKey] then SGJ_Settings.GearProfiles[playerKey] = {} end

    local savedGear = SGJ_Settings.GearProfiles[playerKey][specName]
    local liveGear = {}
    self:GetEquippedGear(liveGear)
    
    local liveScore = self:GetCachedCharacterScore(liveGear, weights, specName, nil)
    local savedScore = 0
    if savedGear then
        savedScore = self:GetCachedCharacterScore(savedGear, weights, specName, savedGear)
    end
    
    if liveScore >= savedScore then
        self:SaveBaselineProfile(specName)
    end
end
