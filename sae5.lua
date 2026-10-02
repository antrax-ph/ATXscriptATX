-- ==============================================================================
-- [Antrax Hub] Steal An Egg Suite — ORANGE & BLACK ULTIMATE EDITION
-- Credits: Antrax
-- Telegram: @AntraxdevZ
-- ==============================================================================
-- Features:
--   • Sidebar navigation
--   • Rarity filters for Auto Steal
--   • Egg ESP/Highlight
--   • Steal speed multiplier
--   • Stats overlay
--   • Auto sell by rarity
--   • Zone rotation
--   • Presets save/load
--   • Keybind system
--   • Theme switcher
--   • Secret+ toast notifications
--   • Anti-kick/reconnect
--   • Auto-heal
--   • Panic button
--   • Trap detector
--   • All toggles OFF by default
-- ==============================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer

local e = Players
local r = Workspace
local y = RunService
local u = TweenService
local w = UIS
local j = game:GetService("ReplicatedStorage")
local k = game:GetService("ProximityPromptService")
local a = HttpService
local o = LP

local CREDITS_NAME = "Antrax"
local CREDITS_TG = "@AntraxdevZ"
local CREDITS_FULL = "by " .. CREDITS_NAME .. " | " .. CREDITS_TG

-- ==============================================================================
-- THEME SYSTEM
-- ==============================================================================
local THEMES = {
    Orange = {
        Bg          = Color3.fromRGB(8, 8, 10),
        Card        = Color3.fromRGB(16, 16, 20),
        Sidebar     = Color3.fromRGB(12, 12, 15),
        SidebarItem = Color3.fromRGB(20, 20, 26),
        Deep        = Color3.fromRGB(11, 11, 14),
        Header      = Color3.fromRGB(13, 13, 16),
        Text        = Color3.fromRGB(242, 242, 246),
        Sub         = Color3.fromRGB(155, 155, 168),
        Muted       = Color3.fromRGB(105, 105, 118),
        Accent      = Color3.fromRGB(255, 130, 20),
        AccentBright= Color3.fromRGB(255, 155, 55),
        AccentGlow  = Color3.fromRGB(255, 180, 95),
        AccentDark  = Color3.fromRGB(160, 70, 10),
        AccentDeep  = Color3.fromRGB(75, 35, 5),
        Off         = Color3.fromRGB(32, 32, 38),
        Border      = Color3.fromRGB(55, 35, 15),
    },
    Red = {
        Bg          = Color3.fromRGB(8, 8, 10),
        Card        = Color3.fromRGB(16, 16, 20),
        Sidebar     = Color3.fromRGB(12, 12, 15),
        SidebarItem = Color3.fromRGB(20, 20, 26),
        Deep        = Color3.fromRGB(11, 11, 14),
        Header      = Color3.fromRGB(13, 13, 16),
        Text        = Color3.fromRGB(242, 242, 246),
        Sub         = Color3.fromRGB(155, 155, 168),
        Muted       = Color3.fromRGB(105, 105, 118),
        Accent      = Color3.fromRGB(220, 40, 55),
        AccentBright= Color3.fromRGB(240, 70, 85),
        AccentGlow  = Color3.fromRGB(255, 110, 120),
        AccentDark  = Color3.fromRGB(140, 25, 35),
        AccentDeep  = Color3.fromRGB(70, 12, 18),
        Off         = Color3.fromRGB(32, 32, 38),
        Border      = Color3.fromRGB(60, 15, 25),
    },
    Blue = {
        Bg          = Color3.fromRGB(8, 8, 12),
        Card        = Color3.fromRGB(16, 16, 24),
        Sidebar     = Color3.fromRGB(12, 12, 18),
        SidebarItem = Color3.fromRGB(20, 20, 30),
        Deep        = Color3.fromRGB(11, 11, 16),
        Header      = Color3.fromRGB(13, 13, 20),
        Text        = Color3.fromRGB(242, 242, 246),
        Sub         = Color3.fromRGB(155, 155, 175),
        Muted       = Color3.fromRGB(105, 105, 125),
        Accent      = Color3.fromRGB(50, 130, 240),
        AccentBright= Color3.fromRGB(80, 160, 255),
        AccentGlow  = Color3.fromRGB(130, 190, 255),
        AccentDark  = Color3.fromRGB(30, 75, 150),
        AccentDeep  = Color3.fromRGB(15, 35, 75),
        Off         = Color3.fromRGB(32, 32, 42),
        Border      = Color3.fromRGB(20, 45, 80),
    },
    Purple = {
        Bg          = Color3.fromRGB(10, 8, 14),
        Card        = Color3.fromRGB(18, 16, 24),
        Sidebar     = Color3.fromRGB(14, 12, 18),
        SidebarItem = Color3.fromRGB(22, 20, 30),
        Deep        = Color3.fromRGB(12, 10, 16),
        Header      = Color3.fromRGB(15, 13, 20),
        Text        = Color3.fromRGB(242, 242, 246),
        Sub         = Color3.fromRGB(160, 155, 180),
        Muted       = Color3.fromRGB(110, 105, 130),
        Accent      = Color3.fromRGB(160, 90, 240),
        AccentBright= Color3.fromRGB(180, 120, 255),
        AccentGlow  = Color3.fromRGB(210, 160, 255),
        AccentDark  = Color3.fromRGB(90, 50, 150),
        AccentDeep  = Color3.fromRGB(45, 25, 75),
        Off         = Color3.fromRGB(35, 32, 45),
        Border      = Color3.fromRGB(55, 35, 85),
    },
    Green = {
        Bg          = Color3.fromRGB(8, 12, 10),
        Card        = Color3.fromRGB(16, 22, 18),
        Sidebar     = Color3.fromRGB(12, 16, 14),
        SidebarItem = Color3.fromRGB(20, 26, 22),
        Deep        = Color3.fromRGB(11, 14, 12),
        Header      = Color3.fromRGB(13, 18, 16),
        Text        = Color3.fromRGB(242, 246, 242),
        Sub         = Color3.fromRGB(155, 175, 160),
        Muted       = Color3.fromRGB(105, 125, 110),
        Accent      = Color3.fromRGB(40, 200, 100),
        AccentBright= Color3.fromRGB(70, 230, 130),
        AccentGlow  = Color3.fromRGB(120, 255, 170),
        AccentDark  = Color3.fromRGB(25, 120, 60),
        AccentDeep  = Color3.fromRGB(15, 60, 30),
        Off         = Color3.fromRGB(32, 40, 35),
        Border      = Color3.fromRGB(25, 70, 40),
    },
}

local TH = THEMES.Orange

local Window = nil
local currentLang = "EN"
local executorCheckCaller = typeof(checkcaller) == "function" and checkcaller or function() return false end
local safeNewCClosure = typeof(newcclosure) == "function" and newcclosure or function(fn) return fn end

local V = k
pcall(function(...)
    V.PromptButtonHoldBegan:Connect(function(prompt, ...)
        pcall(function(...)
            if typeof(fireproximityprompt) == "function" then
                fireproximityprompt(prompt)
            end
        end)
    end)
end)

local H = function(...) end
local t = function(...) end

local s = nil
pcall(function(...) s = require((j:WaitForChild("Client", 5)):WaitForChild("EggState", 5)) end)
if not s then pcall(function(...) s = require(j.Client.EggState) end) end

local p = nil
pcall(function(...) p = require(((j:WaitForChild("Shared", 5)):WaitForChild("Util", 5)):WaitForChild("AssetItems", 5)) end)
if not p then pcall(function(...) p = require(j.Shared.Util.AssetItems) end) end

local B = nil
pcall(function(...) B = require((j:WaitForChild("Shared", 5)):WaitForChild("Remotes", 5)) end)
if not B then pcall(function(...) B = require(j.Shared.Remotes) end) end

local function J(name, alt, alt2)
    local y = (j:FindFirstChild("Packages") and j.Packages:FindFirstChild("Networking")) or j:FindFirstChild("Network") or j
    local u = y:FindFirstChild(name) or j:FindFirstChild(name)
    if u then return u end
    local w = y:FindFirstChild(name, true) or j:FindFirstChild(name, true)
    if w then return w end
    if alt then
        local e = y:FindFirstChild(alt) or j:FindFirstChild(alt)
        if e then return e end
        local u = y:FindFirstChild(alt, true) or j:FindFirstChild(alt, true)
        if u then return u end
    end
    if alt2 then
        local e = y:FindFirstChild(alt2) or j:FindFirstChild(alt2)
        if e then return e end
        local u = y:FindFirstChild(alt2, true) or j:FindFirstChild(alt2, true)
        if u then return u end
    end
    local k = string.match(name, "[^/]+$")
    if k then
        local e = y:FindFirstChild(k, true) or j:FindFirstChild(k, true)
        if e then return e end
    end
    return nil
end

local K = J("RF/EggWorld/AskPlaceEgg", "AskPlaceEgg")
local c = J("RF/EggWorld/AskLiveSnapshot", "AskLiveSnapshot")
local v = J("RF/Homestead/AskState", "RF/Plots/AskState") or J("AskState")
local i = J("RF/EggWorld/AskFieldEggCarry", "AskFieldEggCarry")
local R = J("RF/EggWorld/AskFieldEggSnapshot", "AskFieldEggSnapshot") or J("Eggs: RequestAreaEggSnapshot", "RequestAreaEggSnapshot")
local g = J("RF/EggWorld/AskHatch", "AskHatch") or J("Eggs: RequestHatchEgg")
local Q = J("RF/EggWorld/AskFinishHatch", "AskFinishHatch") or J("Eggs: RequestCompleteHatchEgg")
local P = J("RE/GuardPatrol/ForestStrike", "ForestStrike") or (B and B.GuardPatrol and B.GuardPatrol.ForestStrike)
local N = J("SpeedTollOffer", "RE/GuardPatrol/SpeedTollOffer") or (B and B.GuardPatrol and B.GuardPatrol.SpeedTollOffer)
local U = J("RF/Treadmill/AskDoff", "AskDoff")
local l = J("RF/Treadmill/AskDon", "AskDon") or J("RF/Treadmill/AskMount", "AskMount")
local D = J("RF/Treadmill/AskTierRaise", "Treadmills: RequestUpgrade", "AskTierRaise")
local C = J("RF/Trailwear/AskPurchase", "Trailwear: RequestPurchase", "AskPurchase")
local q = J("RF/Trailwear/AskChoose", "Trailwear: RequestEquip", "AskChoose")
local n = J("RF/Trailwear/AskDoff", "Trailwear: RequestUnequip", "AskDoff")

H("[Remotes] OK")

local f = {
    ["Light Dark"] = 1300, ["LightDark"] = 1300, ["Titan Temple"] = 1100, ["Cherry Blossom"] = 1000,
    ["Cosmic"] = 900, ["Prehistoric"] = 800, ["Abyss Ocean"] = 700, ["Volcano"] = 600,
    ["Snow"] = 500, ["Jungle"] = 400, ["Desert"] = 300, ["Lake"] = 200, ["Forest"] = 100
}
local M = {"Light Dark", "Titan Temple", "Cherry Blossom", "Cosmic", "Prehistoric",
    "Abyss Ocean", "Volcano", "Snow", "Jungle", "Desert", "Lake", "Forest"}

local I = {
    ["Light Dark"] = 420, ["LightDark"] = 420, ["Titan Temple"] = 380, ["Cherry Blossom"] = 330,
    ["Cosmic"] = 280, ["Prehistoric"] = 240, ["Abyss Ocean"] = 200, ["Volcano"] = 180,
    ["Snow"] = 160, ["Jungle"] = 140, ["Desert"] = 130, ["Lake"] = 125, ["Forest"] = 125
}

local L = -360
local E = 525
local b = 620
local A = 130
local S = CFrame.new(4773.7587890625, 70.392112731934, -315.73501586914)

local Z = "AntraxHub_FlightSpeed.txt"
local z = "AntraxHub_EggSelectConfig.json"
local Z_PRESETS = "AntraxHub_Presets.json"
local Z_STATS = "AntraxHub_Stats.json"

local d = {
    ["Light Dark"] = Color3.fromRGB(168, 85, 247), ["Titan Temple"] = Color3.fromRGB(245, 158, 11),
    ["Cherry Blossom"] = Color3.fromRGB(236, 72, 153), ["Cosmic"] = Color3.fromRGB(6, 182, 212),
    ["Prehistoric"] = Color3.fromRGB(16, 185, 129), ["Abyss Ocean"] = Color3.fromRGB(59, 130, 246),
    ["Volcano"] = Color3.fromRGB(239, 68, 68), ["Snow"] = Color3.fromRGB(147, 197, 253),
    ["Jungle"] = Color3.fromRGB(34, 197, 94), ["Desert"] = Color3.fromRGB(234, 179, 8),
    ["Lake"] = Color3.fromRGB(20, 184, 166), ["Forest"] = Color3.fromRGB(22, 163, 74)
}

local X = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine"}
local G = {
    ["Divine"] = Color3.fromRGB(244, 63, 94), ["Eternal"] = Color3.fromRGB(217, 70, 239),
    ["Secret"] = Color3.fromRGB(249, 115, 22), ["Cosmic"] = Color3.fromRGB(6, 182, 212),
    ["Mythic"] = Color3.fromRGB(139, 92, 246), ["Legendary"] = Color3.fromRGB(251, 191, 36),
    ["Epic"] = Color3.fromRGB(168, 85, 247), ["Rare"] = Color3.fromRGB(59, 130, 246),
    ["Uncommon"] = Color3.fromRGB(34, 197, 94), ["Common"] = Color3.fromRGB(148, 163, 184)
}
local F = {["Divine"] = 6, ["Eternal"] = 5, ["Secret"] = 4, ["Cosmic"] = 3, ["Mythic"] = 2,
    ["Legendary"] = 1, ["Epic"] = 0.5, ["Rare"] = 0.3, ["Uncommon"] = 0.1, ["Common"] = 0}

local h

local function O(...)
    local speed = 600
    pcall(function(...)
        local ok = false
        if isfile then ok = isfile(Z)
        elseif readfile then
            local s, v = pcall(readfile, Z)
            ok = s and (v ~= nil)
        end
        if ok and readfile then
            local val = readfile(Z)
            local num = tonumber(val)
            if num and num >= 100 and num <= 1000 then speed = math.floor(num) end
        end
    end)
    return speed
end

local function Y(speed, ...)
    pcall(function(...)
        if writefile then
            local v = math.clamp(math.floor(tonumber(speed) or 600), 100, 1000)
            writefile(Z, tostring(v))
        end
    end)
end

-- Default config
local function defaultConfig()
    local defaultZones = {}
    for _, zn in ipairs(M) do defaultZones[zn] = false end
    local defaultRarities = {}
    for _, rr in ipairs(X) do defaultRarities[rr] = true end
    return {
        selectedZones = defaultZones,
        selectedRarities = defaultRarities,
        alwaysCollectSecretPlus = false,
        minRarityTier = 2,
        autoTreadmill = false,
        autoUpgradeTreadmill = false,
        autoBuyTrails = false,
        hideNotEnoughMoney = false,
        performanceMode = false,
        disable3D = false,
        antiAFK = false,
        eggESP = false,
        trapDetector = false,
        autoHeal = false,
        antiKick = false,
        stealSpeedMult = 1,
        returnSpeedMult = 1,
        autoSellEnabled = false,
        autoSellBelow = "Common",
        zoneRotation = false,
        rotationCount = 3,
        theme = "Orange",
        opacity = 0,
        notifySecretPlus = true,
        soundAlert = false,
        language = "EN"
    }
end

local function T(...)
    local data = nil
    pcall(function(...)
        local ok = false
        if isfile then ok = isfile(z)
        elseif readfile then
            local s, v = pcall(readfile, z)
            ok = s and (v ~= nil)
        end
        if ok and readfile and a then
            local raw = readfile(z)
            if raw and raw ~= "" then
                local obj = a:JSONDecode(raw)
                if type(obj) == "table" then data = obj end
            end
        end
    end)
    local defaults = defaultConfig()
    if type(data) ~= "table" then
        data = defaults
    else
        -- Merge with defaults
        for k, v in pairs(defaults) do
            if data[k] == nil then data[k] = v end
        end
        -- Force feature toggles OFF (per user request)
        data.alwaysCollectSecretPlus = false
        data.autoTreadmill = false
        data.autoUpgradeTreadmill = false
        data.autoBuyTrails = false
        data.hideNotEnoughMoney = false
        data.performanceMode = false
        data.disable3D = false
        data.antiAFK = false
        data.eggESP = false
        data.trapDetector = false
        data.autoHeal = false
        data.antiKick = false
        data.autoSellEnabled = false
        data.zoneRotation = false
        -- Ensure rarity defaults (all true)
        for _, rr in ipairs(X) do
            if data.selectedRarities[rr] == nil then data.selectedRarities[rr] = true end
        end
        for _, zn in ipairs(M) do
            if data.selectedZones[zn] == nil then data.selectedZones[zn] = false end
        end
        if data.language and (data.language == "EN" or data.language == "TH") then
            currentLang = data.language
        end
    end
    return data
end

local function x(...)
    pcall(function(...)
        if writefile and a and h then
            local payload = {
                selectedZones = h.selectedZones or {},
                selectedRarities = h.selectedRarities or {},
                alwaysCollectSecretPlus = (h.alwaysCollectSecretPlus == true),
                minRarityTier = h.minRarityTier or 2,
                autoTreadmill = (h.autoTreadmill == true),
                autoUpgradeTreadmill = (h.autoUpgradeTreadmill == true),
                autoBuyTrails = (h.autoBuyTrails == true),
                hideNotEnoughMoney = (h.hideNotEnoughMoney == true),
                performanceMode = (h.performanceMode == true),
                disable3D = (h.disable3D == true),
                antiAFK = (h.antiAFK == true),
                eggESP = (h.eggESP == true),
                trapDetector = (h.trapDetector == true),
                autoHeal = (h.autoHeal == true),
                antiKick = (h.antiKick == true),
                stealSpeedMult = h.stealSpeedMult or 1,
                returnSpeedMult = h.returnSpeedMult or 1,
                autoSellEnabled = (h.autoSellEnabled == true),
                autoSellBelow = h.autoSellBelow or "Common",
                zoneRotation = (h.zoneRotation == true),
                rotationCount = h.rotationCount or 3,
                theme = h.themeName or "Orange",
                opacity = h.opacity or 0,
                notifySecretPlus = (h.notifySecretPlus == true),
                soundAlert = (h.soundAlert == true),
                language = currentLang or "EN"
            }
            writefile(z, a:JSONEncode(payload))
        end
    end)
end

local W = T()
h = {
    godmode = false, autoGlide = false, autoHatch = false, autoPlaceEvery5 = false,
    batchStealCount = 0, isBatchPlacing = false, isHatching = false,
    autoFarmLoop = false, pureTweenFarm = false, glidingToTarget = false, securingEgg = false,
    glideSpeed = O(), selectedZones = W.selectedZones, selectedRarities = W.selectedRarities,
    alwaysCollectSecretPlus = false, minRarityTier = W.minRarityTier,
    autoTreadmill = false, autoUpgradeTreadmill = false, autoBuyTrails = false,
    hideNotEnoughMoney = false, performanceMode = false, disable3D = false, antiAFK = false,
    eggESP = false, trapDetector = false, autoHeal = false, antiKick = false,
    stealSpeedMult = W.stealSpeedMult or 1, returnSpeedMult = W.returnSpeedMult or 1,
    autoSellEnabled = false, autoSellBelow = W.autoSellBelow or "Common",
    zoneRotation = false, rotationCount = W.rotationCount or 3,
    themeName = W.theme or "Orange", opacity = W.opacity or 0,
    notifySecretPlus = (W.notifySecretPlus ~= false), soundAlert = (W.soundAlert == true),
    onTreadmill = false, lastTreadmillMount = 0, laneZ = -360, swapped = false,
    teleporting = false, isReturning = false, delivering = false, holdingEggForGuard = false,
    currentTargetModel = nil, targetPosition = nil, stateTime = os.clock(),
    statusText = "Idle", bestEggInfo = "Scanning...",
    gui = nil, alive = true, plot = nil, pen = nil, origin = nil, tread = nil,
    -- stats
    sessionEggs = 0, sessionStart = os.clock(), rarityBreakdown = {},
    bestSteals = {}, lastRotationZone = 0, rotationIndex = 0,
    reconnectAttempts = 0, lastActive = os.clock(),
}

-- forward decls
local m, e4, r4, y4, u4, w4, j4, k4, a4, o4, V4, H4, t4, s4, p4, B4, J4, K4, c4, v4, i4, R4, g4, Q4, P4, N4, U4, l4, D4, C4, q4, n4, f4, M4, I4, L4, E4, b4, A4, S4, Z4, z4, d4
local X4 = {}
local G4 = 0
local F4 = nil
local h4
local O4 = 0
local Y4 = "NONE"
local T4
local x4 = nil
local W4 = nil
local rk = 0
local yk = false
local m4 = false
local nk = nil
local Lk = false

-- ESP / Trap storage
local ESP_FOLDER = nil
local TRAP_FOLDER = nil
local TRAP_CONNS = {}

pcall(function(...)
    local Light = game:GetService("Lighting")
    Light:GetPropertyChangedSignal("ClockTime"):Connect(function(...)
        X4 = {} G4 = 0
    end)
end)

pcall(function(...)
    local function checkRemote(obj)
        if obj:IsA("RemoteEvent") then
            local lower = string.lower(obj.Name)
            if string.find(lower, "reset") or string.find(lower, "night") or string.find(lower, "spawn") or string.find(lower, "countdown") then
                pcall(function(...)
                    obj.OnClientEvent:Connect(function(...)
                        X4 = {} G4 = 0
                    end)
                end)
            end
        end
    end
    for _, obj in ipairs(j:GetDescendants()) do checkRemote(obj) end
    j.DescendantAdded:Connect(checkRemote)
end)

-- ==============================================================================
-- HELPER FUNCTIONS
-- ==============================================================================

local function formatTime(sec)
    if not sec or sec < 0 then sec = 0 end
    sec = math.floor(sec)
    if sec >= 3600 then return string.format("%dh %dm", sec // 3600, (sec % 3600) // 60) end
    if sec >= 60 then return string.format("%dm %ds", sec // 60, sec % 60) end
    return string.format("%ds", sec)
end

local function saveStats(...)
    pcall(function(...)
        if writefile and a and h then
            local payload = {
                sessionEggs = h.sessionEggs or 0,
                rarityBreakdown = h.rarityBreakdown or {},
                bestSteals = h.bestSteals or {},
                totalTimePlayed = (h.totalTimePlayed or 0) + (os.clock() - (h.sessionStart or os.clock())),
            }
            writefile(Z_STATS, a:JSONEncode(payload))
        end
    end)
end

local function loadStats(...)
    pcall(function(...)
        if readfile and a then
            local ok, raw = pcall(readfile, Z_STATS)
            if ok and raw and raw ~= "" then
                local obj = a:JSONDecode(raw)
                if type(obj) == "table" then
                    h.totalTimePlayed = tonumber(obj.totalTimePlayed) or 0
                end
            end
        end
    end)
end

local function recordSteal(eggRarity, eggName)
    h.sessionEggs = (h.sessionEggs or 0) + 1
    if not h.rarityBreakdown then h.rarityBreakdown = {} end
    h.rarityBreakdown[eggRarity] = (h.rarityBreakdown[eggRarity] or 0) + 1
    if not h.bestSteals then h.bestSteals = {} end
    local tier = F[eggRarity] or 0
    table.insert(h.bestSteals, 1, {
        rarity = eggRarity,
        name = eggName or "?",
        time = os.time(),
        tier = tier
    })
    -- Keep only top 10
    while #h.bestSteals > 10 do table.remove(h.bestSteals) end
end

-- ==============================================================================
-- CORE GAME HELPERS
-- ==============================================================================

m = function(item, ...)
    if not item or not item:IsA("Tool") then return false end
    local lower = string.lower(item.Name)
    if string.find(lower, "sword") or string.find(lower, "radar") or string.find(lower, "basket") or string.find(lower, "punch") then
        return false
    end
    if item:GetAttribute("EggUid") or item:GetAttribute("UID") or string.find(lower, "egg") or
       item:GetAttribute("Category") or item:GetAttribute("ItemType") == "Egg" then
        return true
    end
    return false
end

e4 = function(...)
    local char = o.Character
    if char then
        for _, child in ipairs(char:GetChildren()) do
            if m(child) then
                local uid = child:GetAttribute("UID") or child:GetAttribute("EggUid")
                return child, uid or child.Name
            end
        end
    end
    return nil, nil
end

r4 = function(...)
    local bp = o:FindFirstChild("Backpack")
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if m(child) then
                local uid = child:GetAttribute("UID") or child:GetAttribute("EggUid")
                return child, uid or child.Name
            end
        end
    end
    return nil, nil
end

y4 = function(...)
    local count = 0
    local bp = o:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do if m(item) then count = count + 1 end end
    end
    local char = o.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do if m(item) then count = count + 1 end end
    end
    return count
end

u4 = function(force, ...)
    if not force and not (h.pureTweenFarm or h.autoFarmLoop or h.teleporting) then return end
    local char = o.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local bp = o:FindFirstChild("Backpack")
    if humanoid then pcall(function(...) humanoid:UnequipTools() end) end
    if char and bp then
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") then pcall(function(...) child.Parent = bp end) end
        end
    end
end

w4 = function(uid, ...)
    if (h.pureTweenFarm or h.autoFarmLoop) and not h.holdingEggForGuard then
        local item = e4()
        if item then pcall(u4) end
        return false
    end
    local item, heldUid = e4()
    if item then
        if uid then
            if heldUid == uid or not heldUid then return true end
        else return true end
    end
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and hrp.Position.X <= (E + 15) then return false end
    if s and s.ReadFieldEggs then
        local ok, data = pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _, rec in ipairs(data.Records) do
                if (rec.State == "Carried" or rec.State == 2) and
                   (rec.CarrierUserId == o.UserId or rec.Carrier == o.UserId) then
                    if uid then
                        if rec.Uid == uid then return true end
                    else return true end
                end
            end
        end
    end
    return false
end

j4 = function(uid, ...)
    local item, heldUid = e4()
    if item then
        if not uid or heldUid == uid or not heldUid then return true end
    end
    local bp = o:FindFirstChild("Backpack")
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if m(child) then
                local childUid = child:GetAttribute("UID") or child:GetAttribute("EggUid")
                if not uid or childUid == uid or child.Name == tostring(uid) then return true end
            end
        end
    end
    if uid and s and s.ReadFieldEggs then
        local ok, data = pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _, rec in ipairs(data.Records) do
                if rec.Uid == uid then
                    if rec.State == "Carried" or rec.State == 2 then
                        local carrier = rec.CarrierUserId or rec.Carrier
                        if carrier == o.UserId then return true end
                    end
                end
            end
        end
    end
    return false
end

local function ek(...)
    if m4 then return end
    local rf = R or j:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot", true) or
               j:FindFirstChild("AskFieldEggSnapshot", true) or
               j:FindFirstChild("Eggs: RequestAreaEggSnapshot", true)
    if not rf or not rf:IsA("RemoteFunction") then return end
    m4 = true
    task.spawn(function(...)
        local ok, result = pcall(function(...) return rf:InvokeServer() end)
        if ok and type(result) == "table" then
            local records = {}
            local raw = result.Records or result
            if type(raw) == "table" then
                for key, rec in pairs(raw) do
                    if type(rec) == "table" then
                        if not rec.Uid and type(key) == "string" then rec.Uid = key end
                        table.insert(records, rec)
                    end
                end
            end
            if #records > 0 then F4 = records G4 = os.clock() end
        end
        m4 = false
    end)
end

task.spawn(function(...)
    while true do
        task.wait(1.5)
        pcall(ek)
    end
end)

h4 = function(force, ...)
    local now = os.clock()
    if force or (now - G4 >= 1.5) or not F4 then ek() end
    local snapshot = ((F4 and #F4 > 0)) and F4 or nil
    local live = nil
    if s and s.ReadFieldEggs then
        local ok, data = pcall(s.ReadFieldEggs)
        if ok and type(data) == "table" then
            local records = {}
            local raw = data.Records or data
            if type(raw) == "table" then
                for key, rec in pairs(raw) do
                    if type(rec) == "table" then
                        if not rec.Uid and type(key) == "string" then rec.Uid = key end
                        table.insert(records, rec)
                    end
                end
            end
            if #records > 0 then live = records end
        end
    end
    local result = {}
    local seen = {}
    if snapshot then
        for _, rec in ipairs(snapshot) do
            if rec.Uid then seen[rec.Uid] = true table.insert(result, rec) end
        end
    end
    if live then
        for _, rec in ipairs(live) do
            if rec.Uid and not seen[rec.Uid] then
                seen[rec.Uid] = true
                table.insert(result, rec)
            end
        end
    end
    local slots = r:FindFirstChild("AreaEggSlotsClient")
    if slots then
        for _, child in ipairs(slots:GetChildren()) do
            local name = child.Name
            if name and name ~= "" then
                local pivot = child:GetPivot()
                local pos = pivot.Position
                if pos.X >= 530 and not string.find(tostring(name), "FirstArea") then
                    if not seen[name] then
                        seen[name] = true
                        local category = child:GetAttribute("Category") or child:GetAttribute("AssetCategory") or child.Name
                        local areaId = child:GetAttribute("AreaId") or child:GetAttribute("Area")
                        local rarity = child:GetAttribute("Rarity") or child:GetAttribute("RarityTier")
                        local rank = child:GetAttribute("RarityRank") or child:GetAttribute("Rank")
                        local income = child:GetAttribute("Income") or child:GetAttribute("EarningRate")
                        local scale = child:GetAttribute("Scale") or child:GetAttribute("AssetScale") or 1
                        local muts = child:GetAttribute("Mutations") or child:GetAttribute("Mutation")
                        table.insert(result, {
                            Uid = name, AssetCategory = category, AreaId = areaId,
                            Rarity = rarity, Rank = rank, Income = income,
                            BoundsCFrame = pivot, BottomCFrame = pivot, CFrame = pivot,
                            State = "Slot", AssetScale = scale, Mutations = muts,
                            PhysicalModel = child
                        })
                    else
                        for _, rec in ipairs(result) do
                            if rec.Uid == name then
                                rec.PhysicalModel = child
                                if not rec.BoundsCFrame then rec.BoundsCFrame = pivot end
                                if not rec.AreaId or rec.AreaId == "" or rec.AreaId == "Unknown" then
                                    rec.AreaId = child:GetAttribute("AreaId") or child:GetAttribute("Area")
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return result
end

k4 = function(uid, ...)
    if not uid then return false, "NoUid" end
    local list = h4(false)
    if list and #list > 0 then
        for _, rec in ipairs(list) do
            if rec.Uid == uid then
                if rec.State == "Carried" or rec.State == 2 then
                    local carrier = rec.CarrierUserId or rec.Carrier
                    if carrier and carrier == o.UserId then return true, "CarriedBySelf"
                    else return false, "CarriedByOther" end
                end
                if rec.State == "Slot" or rec.State == "Dropped" or rec.State == "GuardCarried" or rec.State == 1 then
                    return true, "Available"
                end
                local carrier = rec.CarrierUserId or rec.Carrier
                if carrier then
                    if carrier == o.UserId then return true, "CarriedBySelf"
                    else return false, "CarriedByOther" end
                end
                return true, "Available"
            end
        end
    end
    local slots = r:FindFirstChild("AreaEggSlotsClient")
    if slots then
        for _, child in ipairs(slots:GetChildren()) do
            if child.Name == tostring(uid) or child:GetAttribute("UID") == uid or child:GetAttribute("Uid") == uid then
                return true, "Available"
            end
        end
    end
    return true, "Unchecked"
end

a4 = function(...)
    local _, uid = e4()
    if not uid then local _, bUid = r4() uid = bUid end
    if not uid then return false end
    if s and s.ReadFieldEggs then
        local ok, data = pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _, rec in ipairs(data.Records) do
                if rec.Uid == uid then
                    local area = tostring(rec.AreaId or "")
                    if area == "Lake" or string.find(string.lower(area), "lake") ~= nil then return true end
                end
            end
        end
    end
    if string.find(string.lower(tostring(uid)), "lake") ~= nil then return true end
    return false
end

o4 = function(...)
    local _, uid = e4()
    if not uid then local _, bUid = r4() uid = bUid end
    if not uid then return h.glideSpeed or 350 end
    if s and s.ReadFieldEggs then
        local ok, data = pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _, rec in ipairs(data.Records) do
                if rec.Uid == uid and rec.AreaId then return I[rec.AreaId] or h.glideSpeed or 350 end
            end
        end
    end
    return h.glideSpeed or 350
end

V4 = function(pos, duration, ...)
    duration = duration or 8
    local pad = Instance.new("Part")
    pad.Name = "SafetyFloorPad_AntiVoid"
    pad.Size = Vector3.new(28, 1.5, 28)
    pad.Position = pos - Vector3.new(0, 3.2, 0)
    pad.Anchored = true
    pad.Transparency = 1
    pad.CanCollide = true
    pad.Parent = r
    task.delay(duration, function(...) pcall(function(...) pad:Destroy() end) end)
    return pad
end

H4 = function(uid, ...)
    if P and uid then
        pcall(function(...)
            local char = o.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local cf = hrp and (hrp.CFrame * CFrame.new(0, 0, -3)) or CFrame.new()
            if P:IsA("RemoteFunction") then
                P:InvokeServer({["EggUid"] = uid, ["GuardCFrame"] = cf})
            else
                P:FireServer({["EggUid"] = uid, ["GuardCFrame"] = cf})
            end
        end)
    end
end

if typeof(hookmetamethod) == "function" and not _G._DesyncAntiRagdollHooked then
    _G._DesyncAntiRagdollHooked = true
    local oldIndex
    oldIndex = hookmetamethod(game, "__newindex", safeNewCClosure(function(self, prop, val, ...)
        if not executorCheckCaller() and typeof(self) == "Instance" then
            if self:IsA("Motor6D") and prop == "Enabled" and val == false then return nil end
            if self:IsA("Humanoid") then
                if prop == "PlatformStand" and val == true then return nil end
                if prop == "Sit" and val == true and (h.pureTweenFarm or h.autoFarmLoop or h.isReturning or h.glidingToTarget) then return nil end
            end
        end
        return oldIndex(self, prop, val)
    end))
end

S4 = function(char, ...)
    char = char or o.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or hrp
    if not torso then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") or obj:IsA("NoCollisionConstraint") then
            pcall(function(...) obj:Destroy() end)
        end
    end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Motor6D") and obj.Part0 and obj.Part1 then
            obj.Enabled = true
            local weldName = "RigidJointWeld_" .. obj.Name
            local existing = obj.Part1:FindFirstChild(weldName)
            if not existing then
                local weld = Instance.new("WeldConstraint")
                weld.Name = weldName
                weld.Part0 = obj.Part0
                weld.Part1 = obj.Part1
                weld.Parent = obj.Part1
            end
        end
    end
end

Z4 = function(char, ...)
    if h and h.onTreadmill then return end
    char = char or o.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        if humanoid.PlatformStand then humanoid.PlatformStand = false end
        if humanoid.Sit then humanoid.Sit = false end
    end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("LocalScript") and (string.find(string.lower(obj.Name), "ragdoll") or string.find(string.lower(obj.Name), "fall")) then
            obj.Disabled = true
        end
    end
    S4(char)
end

z4 = function(char, ...)
    if not char then return end
    Z4(char)
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Motor6D") then
            obj:GetPropertyChangedSignal("Enabled"):Connect(function(...)
                if not obj.Enabled then obj.Enabled = true end
            end)
        end
    end
    char.DescendantAdded:Connect(function(child, ...)
        if child:IsA("BallSocketConstraint") or child:IsA("HingeConstraint") or child:IsA("NoCollisionConstraint") then
            task.defer(function(...)
                pcall(function(...) child:Destroy() end)
                Z4(char)
            end)
        elseif child:IsA("LocalScript") and (string.find(string.lower(child.Name), "ragdoll") or string.find(string.lower(child.Name), "fall")) then
            child.Disabled = true
        end
    end)
    char.ChildAdded:Connect(function(child, ...)
        if child:IsA("Tool") and (h.pureTweenFarm or h.autoFarmLoop) and not h.holdingEggForGuard then
            task.defer(function(...) u4() end)
        end
    end)
end

C4 = function(...)
    if h then h.onTreadmill = false end
    local char = o.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if U then
        task.spawn(function(...) pcall(function(...) U:InvokeServer() end) end)
    end
    if humanoid then
        pcall(function(...)
            for _, anim in ipairs(humanoid:GetPlayingAnimationTracks()) do
                local animObj = anim.Animation
                local id = animObj and animObj.AnimationId or ""
                if string.find(id, "10921259953") or string.find(string.lower(anim.Name), "treadmill") or string.find(string.lower(anim.Name), "run") then
                    anim:Stop(0)
                end
            end
            humanoid.PlatformStand = false
            humanoid.Sit = false
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local pg = o:FindFirstChild("PlayerGui")
    if pg then
        local animGui = pg:FindFirstChild("SpeedGainAnimation")
        if animGui then pcall(function(...) animGui:Destroy() end) end
    end
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    Z4(char)
end

E4 = function(...)
    local pg = o:FindFirstChild("PlayerGui")
    if not pg then return false end
    local clicked = false
    pcall(function(...)
        for _, gui in ipairs(pg:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Enabled then
                for _, obj in ipairs(gui:GetDescendants()) do
                    if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Visible then
                        local txt = (obj:IsA("TextButton") and obj.Text) or obj.Name
                        local lower = string.lower(txt or "")
                        if string.find(lower, "get out") or string.find(lower, "treadmill") or
                           string.find(lower, "doff") or string.find(lower, "leave") or string.find(lower, "exit") then
                            if typeof(firesignal) == "function" and obj.Activated then
                                pcall(firesignal, obj.Activated)
                            elseif typeof(firesignal) == "function" and obj.MouseButton1Click then
                                pcall(firesignal, obj.MouseButton1Click)
                            elseif typeof(getconnections) == "function" then
                                local conns = getconnections(obj.MouseButton1Click) or getconnections(obj.Activated) or {}
                                for _, conn in ipairs(conns) do pcall(function(...) conn:Fire() end) break end
                            end
                            clicked = true
                            break
                        end
                    end
                end
                if clicked then break end
            end
        end
    end)
    return clicked
end

L4 = function(...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local tread = (typeof(I4) == "function") and I4() or nil
    if tread then
        local tp = tread.Position + Vector3.new(0, 1.8, 0)
        local dist = ((hrp.Position - tp)).Magnitude
        if dist > 6 then
            if h then h.onTreadmill = false end
            return false
        end
    else
        if hrp.Position.X > 535 then
            if h then h.onTreadmill = false end
            return false
        end
    end
    if h and h.onTreadmill then return true end
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        for _, anim in ipairs(humanoid:GetPlayingAnimationTracks()) do
            local animObj = anim.Animation
            local id = animObj and animObj.AnimationId or ""
            local lower = string.lower(anim.Name or "")
            if string.find(id, "10921259953") or string.find(lower, "treadmill") or string.find(lower, "run") then
                return true
            end
        end
    end
    local pg = o:FindFirstChild("PlayerGui")
    if pg and pg:FindFirstChild("SpeedGainAnimation") then return true end
    return false
end

M4 = function(...)
    if yk then return end
    if os.clock() - rk < 0.8 then
        if h then h.onTreadmill = false end
        return
    end
    yk = true
    rk = os.clock()
    if h then h.onTreadmill = false end
    E4()
    if U then pcall(function(...) U:InvokeServer() end) end
    local char = o.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if humanoid then
        pcall(function(...)
            for _, anim in ipairs(humanoid:GetPlayingAnimationTracks()) do
                local animObj = anim.Animation
                local id = animObj and animObj.AnimationId or ""
                local lower = string.lower(anim.Name or "")
                if string.find(id, "10921259953") or string.find(lower, "treadmill") or string.find(lower, "run") then
                    anim:Stop(0)
                end
            end
            humanoid.PlatformStand = false
            humanoid.Sit = false
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local pg = o:FindFirstChild("PlayerGui")
    if pg then
        local animGui = pg:FindFirstChild("SpeedGainAnimation")
        if animGui then pcall(function(...) animGui:Destroy() end) end
    end
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    Z4(char)
    task.wait(0.15)
    yk = false
end

q4 = M4

n4 = function(...)
    pcall(function(...)
        local plots = r:FindFirstChild("Plots")
        if plots then
            local mine = h and h.plot
            if not mine and t4 then mine = select(1, t4()) end
            for _, plot in ipairs(plots:GetChildren()) do
                local isMine = (mine ~= nil and plot == mine)
                local tread = plot:FindFirstChild("TreadmillBottom")
                if tread and tread:IsA("BasePart") then
                    if isMine and h and h.autoTreadmill then
                        tread.CanTouch = true tread.CanCollide = true
                    else
                        tread.CanTouch = false tread.CanCollide = false
                    end
                end
                local upg = plot:FindFirstChild("TreadmillUpgrade")
                if upg then
                    for _, obj in ipairs(upg:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            if isMine and h and h.autoTreadmill then
                                obj.CanTouch = true
                            else
                                obj.CanTouch = false obj.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end)
end

n4()

r.DescendantAdded:Connect(function(child, ...)
    pcall(function(...)
        local isTread = (child.Name == "TreadmillBottom" and child:IsA("BasePart"))
        local isUpg = (child.Name == "TreadmillUpgrade" and child:IsA("Model"))
        if isTread or isUpg then
            local mine = h and h.plot
            if not mine and t4 then mine = select(1, t4()) end
            local isMine = mine and child:IsDescendantOf(mine)
            if isMine and h and h.autoTreadmill then
                if isTread then
                    child.CanTouch = true child.CanCollide = true
                else
                    for _, obj in ipairs(child:GetDescendants()) do
                        if obj:IsA("BasePart") then obj.CanTouch = true end
                    end
                end
            else
                if isTread then
                    child.CanTouch = false child.CanCollide = false
                else
                    for _, obj in ipairs(child:GetDescendants()) do
                        if obj:IsA("BasePart") then obj.CanTouch = false obj.CanCollide = false end
                    end
                end
            end
        end
    end)
end)

D4 = function(...)
    h.onTreadmill = false h.teleporting = false h.glidingToTarget = false
    h.securingEgg = false h.isReturning = false h.delivering = false
    h.holdingEggForGuard = false h.currentTargetModel = nil h.targetPosition = nil
    h.stateTime = os.clock()
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function(...)
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    pcall(function(...) if C4 then C4() end end)
    pcall(function(...) if Z4 and char then Z4(char) end end)
    pcall(function(...) if u4 and (h.pureTweenFarm or h.autoFarmLoop) then u4() end end)
end

d4 = function(model, pos, ...)
    if model then
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                pcall(function(...)
                    obj.RequiresLineOfSight = false obj.HoldDuration = 0
                    if typeof(fireproximityprompt) == "function" then
                        fireproximityprompt(obj, 0) fireproximityprompt(obj)
                    end
                end)
            end
        end
    end
    local slots = r:FindFirstChild("AreaEggSlotsClient")
    if slots and pos then
        for _, slot in ipairs(slots:GetChildren()) do
            local part = slot:FindFirstChildWhichIsA("BasePart") or slot.PrimaryPart
            if part and ((part.Position - pos)).Magnitude <= 18 then
                for _, obj in ipairs(slot:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        pcall(function(...)
                            obj.RequiresLineOfSight = false obj.HoldDuration = 0
                            if typeof(fireproximityprompt) == "function" then
                                fireproximityprompt(obj, 0) fireproximityprompt(obj)
                            end
                        end)
                    end
                end
            end
        end
    end
end

b4 = function(on, ...)
    h.godmode = on
    local char = o.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, not on)
        if on and humanoid.Health < 100 then humanoid.Health = 100 end
    end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            if on then obj.CanTouch = false obj.CanCollide = false end
        end
    end
    Z4(char)
end

local function enableDesyncGodmode() b4(true) end
local function disableDesyncGodmode() b4(false) end

A4 = function(...)
    local char = o.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not humanoid then return false end
    pcall(function(...)
        humanoid.BreakJointsOnDeath = false
        local clone = humanoid:Clone()
        clone.Parent = char
        humanoid:Destroy()
        local animator = clone:FindFirstChildOfClass("Animator")
        if not animator then animator = Instance.new("Animator") animator.Parent = clone end
        r.CurrentCamera.CameraSubject = clone
        local animate = char:FindFirstChild("Animate")
        if animate and animate:IsA("LocalScript") then
            animate.Disabled = true
            task.defer(function(...) task.wait(0.05) animate.Disabled = false end)
        end
        clone:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        clone:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        clone:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        clone:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        clone.JumpPower = math.max(50, clone.JumpPower)
        clone.JumpHeight = math.max(7.2, clone.JumpHeight)
        clone:ChangeState(Enum.HumanoidStateType.Running)
    end)
    h.swapped = true
    if h.godmode then b4(true) end
    z4(char)
    return true
end

t4 = function(...)
    if h.plot and h.plot.Parent and h.pen and h.origin and h.plotVerified then
        return h.plot, h.pen, h.origin
    end
    local plots = r:FindFirstChild("Plots")
    if not plots then return nil, nil, nil end
    local uid = o.UserId
    local name = o.Name
    local dName = o.DisplayName
    local plot = nil
    local verified = false
    if v then
        local ok, data = pcall(function(...) return v:InvokeServer() end)
        if ok and type(data) == "table" and type(data.OwnersBySlot) == "table" then
            for slot, owner in pairs(data.OwnersBySlot) do
                if owner == uid or tostring(owner) == tostring(uid) or owner == name then
                    plot = plots:FindFirstChild(tostring(slot))
                    if plot then verified = true break end
                end
            end
        end
    end
    if not plot and c then
        local ok, data = pcall(function(...) return c:InvokeServer() end)
        if ok and type(data) == "table" then
            for slot, info in pairs(data) do
                if type(info) == "table" and (info.OwnerUserId == uid or tostring(info.OwnerUserId) == tostring(uid)) then
                    local slotId = info.Slot or slot
                    plot = plots:FindFirstChild(tostring(slotId)) or plots:FindFirstChild(tostring(slot))
                    if plot then verified = true break end
                end
            end
        end
    end
    if not plot then
        for _, child in ipairs(plots:GetChildren()) do
            local attr = child:GetAttribute("Owner") or child:GetAttribute("OwnerUserId") or child:GetAttribute("UserId") or child:GetAttribute("OwnerId") or child:GetAttribute("Player")
            if attr and (attr == uid or tostring(attr) == tostring(uid) or attr == name or tostring(attr) == name or attr == dName) then
                plot = child verified = true break
            end
        end
    end
    if not plot then
        for _, child in ipairs(plots:GetChildren()) do
            for _, desc in ipairs(child:GetDescendants()) do
                if desc:IsA("TextLabel") and desc.Text ~= "" then
                    local lower = string.lower(desc.Text)
                    if string.find(lower, string.lower(name), 1, true) or (dName and string.find(lower, string.lower(dName), 1, true)) then
                        plot = child verified = true break
                    end
                end
            end
            if plot then break end
        end
    end
    if not plot then
        local char = o.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Position.X <= (E + 30) then
            local closest = nil
            local minDist = 999999
            for _, child in ipairs(plots:GetChildren()) do
                local center = child:FindFirstChild("CenterPoint") or child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                if center then
                    local dist = ((hrp.Position - center.Position)).Magnitude
                    if dist < minDist then minDist = dist closest = child end
                end
            end
            if closest and minDist < 160 then plot = closest end
        end
    end
    if not plot then plot = plots:FindFirstChild("2") or plots:FindFirstChild("1") or (plots:GetChildren())[1] end
    if not plot then return nil, nil, nil end
    h.plot = plot h.plotVerified = verified h.origin = plot:FindFirstChild("CenterPoint")
    local toUpdate = plot:FindFirstChild("ToUpdate")
    h.pen = (toUpdate and toUpdate:FindFirstChild("PetArea")) or plot:FindFirstChild("PetArea")
    h.tread = plot:FindFirstChild("TreadmillBottom")
    if not h.pen and toUpdate then
        for _, child in ipairs(toUpdate:GetChildren()) do
            if child:IsA("BasePart") and string.find(string.lower(child.Name), "pet") then
                h.pen = child break
            end
        end
    end
    if not h.origin then h.origin = plot:FindFirstChild("CenterPoint") or h.pen or plot.PrimaryPart end
    if not h.pen then h.pen = h.origin end
    return h.plot, h.pen, h.origin
end

s4 = function(...)
    local _, pen, origin = t4()
    if pen then return pen.Position + Vector3.new(0, 3.5, 0) end
    if origin then return origin.Position + Vector3.new(0, 3.5, 0) end
    return Vector3.new(464.7, 71.7, -304)
end

p4 = function(occupied, ...)
    local _, pen, _ = t4()
    if not pen then return nil end
    local size = pen.Size
    local rx = math.max(4, size.X / 2 - 5)
    local rz = math.max(4, size.Z / 2 - 5)
    for i = 1, 60 do
        local dx = math.random(-math.floor(rx), math.floor(rx))
        local dz = math.random(-math.floor(rz), math.floor(rz))
        local cf = pen.CFrame * CFrame.new(dx, size.Y / 2 + 1, dz)
        local ok = true
        for _, pos in ipairs(occupied) do
            if ((pos - cf.Position)).Magnitude < 5.5 then ok = false break end
        end
        if ok then return cf end
    end
    return pen.CFrame * CFrame.new(math.random(-8, 8), size.Y / 2 + 1, math.random(-8, 8))
end

B4 = function(...)
    local _, _, origin = t4()
    if not origin or not K then return 0 end
    local placed = 0
    local occupied = {}
    if c then
        local ok, data = pcall(function(...) return c:InvokeServer() end)
        if ok and type(data) == "table" then
            local mine = {}
            for _, info in pairs(data) do
                if type(info) == "table" and info.OwnerUserId == o.UserId then
                    for uid, rec in pairs(info.Records or {}) do mine[uid] = rec end
                end
            end
            for uid, rec in pairs(mine) do
                if rec.Placement and rec.Placement.LocalCFrame then
                    occupied[#occupied + 1] = ((origin.CFrame * rec.Placement.LocalCFrame)).Position
                else
                    local cf = p4(occupied)
                    if cf then
                        local localCf = origin.CFrame:ToObjectSpace(cf)
                        local ok2, ok3 = pcall(function(...) return K:InvokeServer({["Uid"] = uid, ["LocalCFrame"] = localCf}) end)
                        if ok2 and ok3 then
                            placed = placed + 1
                            occupied[#occupied + 1] = cf.Position
                        end
                    end
                end
            end
        end
    end
    local inv = {}
    local char = o.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if m(item) then table.insert(inv, item) end
        end
    end
    local bp = o:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if m(item) then table.insert(inv, item) end
        end
    end
    for _, item in ipairs(inv) do
        if not h.alive then break end
        local uid = item:GetAttribute("UID") or item:GetAttribute("EggUid") or item.Name
        local cf = p4(occupied)
        if cf then
            local localCf = origin.CFrame:ToObjectSpace(cf)
            local ok, result = pcall(function(...) return K:InvokeServer({["Uid"] = uid, ["LocalCFrame"] = localCf}) end)
            if ok and result ~= false then
                placed = placed + 1
                occupied[#occupied + 1] = cf.Position
            end
            task.wait(0.04)
        end
    end
    return placed
end

J4 = function(force, ...)
    if (not force and not h.autoHatch) or not g or not Q or not c then return 0 end
    if h.isHatching then return 0 end
    h.isHatching = true
    local ok, data = pcall(function(...) return c:InvokeServer() end)
    if not ok or type(data) ~= "table" then h.isHatching = false return 0 end
    local owned = {}
    for _, info in pairs(data) do
        if type(info) == "table" and info.OwnerUserId == o.UserId then
            for uid, rec in pairs(info.Records or {}) do owned[uid] = rec end
        end
    end
    local ready = {}
    local now = r:GetServerTimeNow()
    for uid, rec in pairs(owned) do
        if not h.alive then break end
        if rec.Placement then
            local isReady = nil
            if s then
                local func = s.IsReadyToHatch or s.IsLocalEggReady
                if func then
                    local ok2, result = pcall(func, uid)
                    if ok2 and type(result) == "boolean" then isReady = result end
                end
            end
            if isReady == nil then
                local placedAt = rec.Placement.PlacedAt or rec.Placement.Time or 0
                local growthTime = 30
                if p and p.Assets and p.Assets[rec.AssetCategory] then
                    local asset = p.Assets[rec.AssetCategory]
                    growthTime = (asset and (asset.Egg and asset.Egg.GrowthTime)) or 30
                end
                local effective = growthTime / math.max(0.01, rec.GrowthSpeedMultiplier or 1)
                isReady = (now - placedAt) >= effective
            end
            if isReady then table.insert(ready, {uid = uid, category = rec.AssetCategory or "Egg"}) end
        end
    end
    if #ready == 0 then h.isHatching = false return 0 end
    local hatched = 0
    for _, egg in ipairs(ready) do
        task.spawn(function(...)
            local ok1, res1 = pcall(function(...)
                if g:IsA("RemoteFunction") then return g:InvokeServer(egg.uid)
                else g:FireServer(egg.uid) return true end
            end)
            if ok1 and res1 ~= false then
                task.wait(0.9)
                local ok2, res2 = pcall(function(...)
                    if Q:IsA("RemoteFunction") then return Q:InvokeServer(egg.uid)
                    else Q:FireServer(egg.uid) return true end
                end)
                if ok2 and res2 ~= false then
                    hatched = hatched + 1
                    h.hatched = ((h.hatched or 0)) + 1
                end
            end
        end)
        task.wait(0.04)
    end
    task.wait(0.95)
    h.isHatching = false
    return hatched
end

i4 = function(...)
    local hitboxes = {}
    local debris = r:FindFirstChild("__DEBRIS")
    if debris then
        for _, child in ipairs(debris:GetChildren()) do
            local hitbox = child:FindFirstChild("Hitbox")
            if hitbox and hitbox:IsA("BasePart") then table.insert(hitboxes, hitbox)
            elseif child:IsA("BasePart") and string.find(child.Name:lower(), "hitbox") then table.insert(hitboxes, child) end
        end
    end
    local boss = r:FindFirstChild("BossArenaTeleport")
    if boss then
        local hitbox = boss:FindFirstChild("Hitbox") or boss:FindFirstChildWhichIsA("BasePart") or (boss:IsA("BasePart") and boss)
        if hitbox and hitbox:IsA("BasePart") then table.insert(hitboxes, hitbox) end
    end
    return hitboxes
end

-- Speed multiplier helpers
local function getStealSpeed(base)
    return math.max(60, (base or h.glideSpeed or 350) * (h.stealSpeedMult or 1))
end
local function getReturnSpeed(base)
    return math.max(60, (base or h.glideSpeed or 350) * (h.returnSpeedMult or 1))
end

g4 = function(speed, sess, force, ...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp then return false end
    if humanoid then humanoid.AutoRotate = false end
    local target = s4()
    speed = getReturnSpeed(speed)
    local laneZ = h.laneZ or L
    h.isReturning = true h.stateTime = os.clock()
    V4(target, 20)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    local areaSpeed = o4()
    local maxSpeed = math.max(speed, areaSpeed)
    local deadline = os.clock() + 25
    while h.alive and h.isReturning and os.clock() < deadline do
        if sess and O4 ~= sess then
            if humanoid then humanoid.AutoRotate = true end
            h.isReturning = false return false
        end
        if not force and not h.pureTweenFarm and not h.autoFarmLoop then
            if humanoid then humanoid.AutoRotate = true end
            h.isReturning = false return false
        end
        local pos = hrp.Position
        local dist = ((target - pos)).Magnitude
        if (pos.X <= (target.X + 3) and math.abs(pos.Z - target.Z) <= 8) or dist <= 6 then break end
        local dt = y.Heartbeat:Wait()
        pos = hrp.Position
        local currentSpeed = maxSpeed
        if pos.X <= b and pos.X > E then
            local t = math.clamp(((pos.X - E)) / ((b - E)), 0, 1)
            currentSpeed = A + (((maxSpeed - A)) * t)
        elseif pos.X <= E then currentSpeed = A end
        local targetZ = target.Z
        if pos.X > 540 then targetZ = laneZ end
        local dx = math.sign(target.X - pos.X)
        local newX = pos.X + dx * math.min(math.abs(target.X - pos.X), currentSpeed * dt)
        local dy = math.sign(target.Y - pos.Y)
        local newY = pos.Y + dy * math.min(math.abs(target.Y - pos.Y), (currentSpeed * dt) * 0.5)
        local dz = targetZ - pos.Z
        local newZ = pos.Z + math.sign(dz) * math.min(math.abs(dz), currentSpeed * dt)
        local obstacles = i4()
        if pos.X > E then
            for _, ob in ipairs(obstacles) do
                local op = ob.Position
                local dist2 = ((Vector3.new(newX, newY, newZ) - op)).Magnitude
                if dist2 < 22 or (math.abs(newX - op.X) < 18 and math.abs(newZ - op.Z) < 14) then
                    local safeY = op.Y + 16
                    if newY < safeY then newY = math.min(newY + ((currentSpeed * dt) * 1.5), safeY) end
                    break
                end
            end
        end
        local newPos = Vector3.new(newX, newY, newZ)
        local lookDir = ((newPos - pos)).Magnitude > 0.05 and ((newPos - pos)).Unit or hrp.CFrame.LookVector
        hrp.CFrame = CFrame.lookAt(newPos, newPos + lookDir)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    hrp.CFrame = CFrame.new(target)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    if humanoid then humanoid.AutoRotate = true end
    u4()
    h.isReturning = false h.delivering = false
    h.statusText = "Arrived at Base"
    return true
end

v4 = function(speed, sess, force, ...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end
    local basePos = s4()
    local distToBase = ((hrp.Position - basePos)).Magnitude
    if distToBase > 8 then g4(speed or h.glideSpeed or 600, sess, true) end
    V4(basePos, 15)
    hrp.CFrame = CFrame.new(basePos)
    hrp.AssemblyLinearVelocity = Vector3.zero
    h.statusText = "Placing eggs..."
    local deadline = os.clock() + 3
    while y4() > 0 and os.clock() < deadline and h.alive do
        B4()
        task.wait(0.06)
    end
    h.statusText = "Hatching eggs..."
    J4(true)
    u4()
    h.isReturning = false h.delivering = false
    h.currentTargetModel = nil h.targetPosition = nil
end

local uk = 5

K4 = function(mode, ...)
    if h.isBatchPlacing then return end
    h.isBatchPlacing = true
    local sess = O4
    h.pureTweenFarm = (mode == "TWEEN")
    h.autoFarmLoop = (mode == "WARP")
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local basePos = s4()
    local distToBase = hrp and ((hrp.Position - basePos)).Magnitude or 999
    if distToBase > 8 then g4(h.glideSpeed or 600, sess, true) end
    if hrp then
        V4(basePos, 20)
        hrp.CFrame = CFrame.new(basePos)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if humanoid then humanoid.AutoRotate = true end
    end
    task.spawn(function(...) pcall(B4) pcall(J4, true) end)
    u4()
    h.isReturning = false h.delivering = false h.glidingToTarget = false
    h.securingEgg = false h.teleporting = false
    h.currentTargetModel = nil h.targetPosition = nil
    for i = 5, 1, -1 do
        if not h.alive then break end
        task.wait(1)
    end
    h.isBatchPlacing = false
    if h.alive and O4 == sess then
        if mode == "TWEEN" then h.pureTweenFarm = true h.autoFarmLoop = false
        elseif mode == "WARP" then h.autoFarmLoop = true h.pureTweenFarm = false end
        Y4 = mode
    end
end

c4 = function(mode, ...)
    if not h.autoPlaceEvery5 then return false end
    h.batchStealCount = ((h.batchStealCount or 0)) + 1
    if h.batchStealCount >= uk then
        h.batchStealCount = 0
        task.spawn(function(...) K4(mode) end)
        return true
    end
    return false
end

local function wk(targetCFrame, speed, uid, sess, ...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp then return false end
    if humanoid then humanoid.AutoRotate = false end
    speed = getStealSpeed(speed)
    local targetPos = targetCFrame.Position
    V4(targetPos, 14)
    pcall(function(...) o:RequestStreamAroundAsync(targetPos) end)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    local laneZ = h.laneZ or L
    h.glidingToTarget = true h.stateTime = os.clock()
    local lastCheck = 0
    local deadline = os.clock() + 15
    while h.alive and h.glidingToTarget and os.clock() < deadline do
        if sess and O4 ~= sess then
            if humanoid then humanoid.AutoRotate = true end
            h.glidingToTarget = false return false
        end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.teleporting then
            if humanoid then humanoid.AutoRotate = true end
            h.glidingToTarget = false return false
        end
        local pos = hrp.Position
        local dist3 = ((targetPos - pos)).Magnitude
        local dist2 = ((Vector2.new(pos.X, pos.Z) - Vector2.new(targetPos.X, targetPos.Z))).Magnitude
        local dy = math.abs(pos.Y - targetPos.Y)
        if dist3 <= 6 or (dist2 <= 3.5 and dy <= 6) then break end
        local dt = y.Heartbeat:Wait()
        pos = hrp.Position
        dist3 = ((targetPos - pos)).Magnitude
        dist2 = ((Vector2.new(pos.X, pos.Z) - Vector2.new(targetPos.X, targetPos.Z))).Magnitude
        local dxAbs = math.abs(pos.X - targetPos.X)
        if uid and (os.clock() - lastCheck > 0.5) then
            lastCheck = os.clock()
            local ok, reason = k4(uid)
            if not ok and reason == "CarriedByOther" then
                if humanoid then humanoid.AutoRotate = true end
                h.glidingToTarget = false return false
            end
        end
        local targetZ = targetPos.Z
        if dxAbs > 40 then targetZ = laneZ end
        local dx = math.sign(targetPos.X - pos.X)
        local newX = pos.X + dx * math.min(math.abs(targetPos.X - pos.X), speed * dt)
        local yRatio = (dist2 <= 25) and 1.2 or 0.5
        local dy2 = math.sign(targetPos.Y - pos.Y)
        local newY = pos.Y + dy2 * math.min(math.abs(targetPos.Y - pos.Y), (speed * dt) * yRatio)
        local dz = targetZ - pos.Z
        local newZ = pos.Z + math.sign(dz) * math.min(math.abs(dz), speed * dt)
        if dist2 > 25 then
            local obstacles = i4()
            for _, ob in ipairs(obstacles) do
                local op = ob.Position
                local d = ((Vector3.new(newX, newY, newZ) - op)).Magnitude
                if d < 22 or (math.abs(newX - op.X) < 18 and math.abs(newZ - op.Z) < 14) then
                    local safeY = op.Y + 16
                    if newY < safeY then newY = math.min(newY + ((speed * dt) * 1.5), safeY) end
                    break
                end
            end
        end
        local newPos = Vector3.new(newX, newY, newZ)
        local lookDir = ((newPos - pos)).Magnitude > 0.05 and ((newPos - pos)).Unit or hrp.CFrame.LookVector
        hrp.CFrame = CFrame.lookAt(newPos, newPos + lookDir)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    hrp.CFrame = targetCFrame * CFrame.new(0, 0.4, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    if humanoid then humanoid.AutoRotate = true end
    h.glidingToTarget = false
    return true
end

R4 = function(targetCFrame, speed, uid, sess, ...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local px = hrp.Position.X
        local tx = targetCFrame.Position.X
        if px <= 535 and tx > 510 then
            local wp = CFrame.new(500, 70, -364)
            local dist = ((hrp.Position - wp.Position)).Magnitude
            if dist > 5 then
                local ok = wk(wp, speed, uid, sess)
                if not ok then return false end
                task.wait(0.04)
            end
        end
    end
    return wk(targetCFrame, speed, uid, sess)
end

Q4 = function(speed, sess, ...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp then return false end
    if humanoid then humanoid.AutoRotate = false end
    local laneZ = h.laneZ or L
    local target = Vector3.new(E - 10, 70, laneZ)
    speed = getReturnSpeed(speed)
    h.isReturning = true h.stateTime = os.clock()
    V4(Vector3.new(E, 70, laneZ), 20)
    pcall(u4)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    local areaSpeed = o4()
    local maxSpeed = math.max(speed, areaSpeed)
    local deadline = os.clock() + 15
    while h.alive and h.isReturning and os.clock() < deadline do
        if sess and O4 ~= sess then
            if humanoid then humanoid.AutoRotate = true end
            h.isReturning = false return false
        end
        if not h.pureTweenFarm and not h.autoFarmLoop then
            if humanoid then humanoid.AutoRotate = true end
            h.isReturning = false return false
        end
        local pos = hrp.Position
        local dist = ((target - pos)).Magnitude
        if pos.X <= (E + 10) or dist <= 6 then u4() break end
        if char then
            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("Tool") then pcall(u4) break end
            end
        end
        local dt = y.Heartbeat:Wait()
        pos = hrp.Position
        local currentSpeed = maxSpeed
        if pos.X <= b and pos.X > E then
            local t = math.clamp(((pos.X - E)) / ((b - E)), 0, 1)
            currentSpeed = A + (((maxSpeed - A)) * t)
        elseif pos.X <= E then currentSpeed = A end
        local dx = math.sign(target.X - pos.X)
        local newX = pos.X + dx * math.min(math.abs(target.X - pos.X), currentSpeed * dt)
        local dy = math.sign(target.Y - pos.Y)
        local newY = pos.Y + dy * math.min(math.abs(target.Y - pos.Y), (currentSpeed * dt) * 0.5)
        local dz = laneZ - pos.Z
        local newZ = pos.Z + math.sign(dz) * math.min(math.abs(dz), currentSpeed * dt)
        local obstacles = i4()
        for _, ob in ipairs(obstacles) do
            local op = ob.Position
            local d = ((Vector3.new(newX, newY, newZ) - op)).Magnitude
            if d < 22 or (math.abs(newX - op.X) < 18 and math.abs(newZ - op.Z) < 14) then
                local safeY = op.Y + 16
                if newY < safeY then newY = math.min(newY + ((currentSpeed * dt) * 1.5), safeY) end
                break
            end
        end
        local newPos = Vector3.new(newX, newY, newZ)
        local lookDir = ((newPos - pos)).Magnitude > 0.05 and ((newPos - pos)).Unit or hrp.CFrame.LookVector
        hrp.CFrame = CFrame.lookAt(newPos, newPos + lookDir)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    hrp.CFrame = CFrame.new(E, math.max(68, hrp.Position.Y), laneZ)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    if humanoid then humanoid.AutoRotate = true end
    u4()
    h.isReturning = false h.delivering = false
    if h then h.onTreadmill = false end
    h.statusText = "Arrived at Safe Line"
    return true
end

local function jk(model, ...)
    if not model then return nil end
    local tread = model:FindFirstChild("TreadmillBottom")
    if tread and tread:IsA("BasePart") then return tread end
    tread = model:FindFirstChild("TreadmillBottom", true)
    if tread and tread:IsA("BasePart") then return tread end
    local upg = model:FindFirstChild("TreadmillUpgrade", true)
    if upg then
        for _, name in ipairs({"TreadmillBottom", "Belt", "RunArea", "Run", "Platform", "Pad", "Floor", "Base"}) do
            local found = upg:FindFirstChild(name, true)
            if found and found:IsA("BasePart") then return found end
        end
    end
    return nil
end

I4 = function(...)
    local mine = t4()
    if h.tread and h.tread.Parent then return h.tread end
    local tread = nil
    if mine then tread = jk(mine) end
    h.tread = tread
    return tread
end

f4 = function(sess, ...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return false end
    if humanoid.PlatformStand then humanoid.PlatformStand = false end
    if humanoid.Sit then humanoid.Sit = false end
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
    local mine = t4()
    local tread = I4()
    if not tread then return false end
    local padPos = tread.Position + Vector3.new(0, 1.8, 0)
    pcall(function(...)
        if typeof(firetouchinterest) == "function" then
            firetouchinterest(hrp, tread, 0)
            task.wait(0.02)
            firetouchinterest(hrp, tread, 1)
        end
    end)
    if l then pcall(function(...) l:InvokeServer() end) end
    h.onTreadmill = true
    h.lastTreadmillMount = os.clock()
    return true
end

-- ==============================================================================
-- EGG ESP
-- ==============================================================================
local function cleanupESP(...)
    if ESP_FOLDER then
        pcall(function(...) ESP_FOLDER:Destroy() end)
        ESP_FOLDER = nil
    end
end

local function cleanupTrap(...)
    if TRAP_FOLDER then
        pcall(function(...) TRAP_FOLDER:Destroy() end)
        TRAP_FOLDER = nil
    end
    for _, c in ipairs(TRAP_CONNS) do pcall(function(...) c:Disconnect() end) end
    TRAP_CONNS = {}
end

local function rarityOf(rec)
    if rec.PhysicalModel then
        local pm = rec.PhysicalModel
        local rar = pm:GetAttribute("Rarity") or pm:GetAttribute("RarityTier") or pm:GetAttribute("Tier")
        if rar and tostring(rar) ~= "" and tostring(rar) ~= "Unknown" then
            local lower = string.lower(tostring(rar))
            if string.find(lower, "divine") then return "Divine"
            elseif string.find(lower, "eternal") then return "Eternal"
            elseif string.find(lower, "secret") then return "Secret"
            elseif string.find(lower, "cosmic") then return "Cosmic"
            elseif string.find(lower, "mythic") then return "Mythic"
            elseif string.find(lower, "legendary") then return "Legendary"
            elseif string.find(lower, "epic") then return "Epic"
            elseif string.find(lower, "rare") then return "Rare"
            elseif string.find(lower, "uncommon") then return "Uncommon"
            elseif string.find(lower, "common") then return "Common" end
        end
    end
    if rec.Rarity then
        local lower = string.lower(tostring(rec.Rarity))
        for _, rr in ipairs(X) do
            if string.find(lower, string.lower(rr)) then return rr end
        end
    end
    return "Common"
end

local function updateESP(...)
    if not h.eggESP then
        cleanupESP()
        return
    end
    local list = h4(false)
    if not list or #list == 0 then
        cleanupESP()
        return
    end
    if not ESP_FOLDER then
        ESP_FOLDER = Instance.new("Folder")
        ESP_FOLDER.Name = "AntraxHub_EggESP"
        ESP_FOLDER.Parent = game:GetService("CoreGui")
    end
    local seen = {}
    for _, rec in ipairs(list) do
        local pm = rec.PhysicalModel
        if pm and pm.Parent then
            local uid = rec.Uid
            seen[uid] = true
            local hname = "ESP_" .. tostring(uid):gsub("[^%w]", "_")
            local existing = ESP_FOLDER:FindFirstChild(hname)
            local rarity = rarityOf(rec)
            local color = G[rarity] or Color3.fromRGB(255, 255, 255)
            if not existing then
                local highlight = Instance.new("Highlight")
                highlight.Name = hname
                highlight.Adornee = pm
                highlight.FillColor = color
                highlight.FillTransparency = 0.6
                highlight.OutlineColor = color
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = ESP_FOLDER
                -- Label
                local billboard = Instance.new("BillboardGui")
                billboard.Name = hname .. "_BB"
                billboard.Adornee = pm
                billboard.Size = UDim2.fromOffset(140, 32)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = ESP_FOLDER
                local label = Instance.new("TextLabel")
                label.Size = UDim2.fromScale(1, 1)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamBold
                label.TextSize = 11
                label.TextColor3 = color
                label.TextStrokeTransparency = 0
                label.TextStrokeColor3 = Color3.new(0, 0, 0)
                label.Text = rarity
                label.Parent = billboard
            else
                existing.FillColor = color
                existing.OutlineColor = color
                existing.Adornee = pm
                local bb = ESP_FOLDER:FindFirstChild(hname .. "_BB")
                if bb then
                    bb.Adornee = pm
                    local label = bb:FindFirstChildOfClass("TextLabel")
                    if label then
                        label.TextColor3 = color
                        label.Text = rarity
                    end
                end
            end
        end
    end
    -- Cleanup gone
    for _, child in ipairs(ESP_FOLDER:GetChildren()) do
        local uid = string.gsub(child.Name, "^ESP_", "")
        local baseUid = string.gsub(uid, "_BB$", "")
        local found = false
        for u, _ in pairs(seen) do
            if tostring(u):gsub("[^%w]", "_") == baseUid then found = true break end
        end
        if not found then pcall(function(...) child:Destroy() end) end
    end
end

task.spawn(function(...)
    while h.alive do
        pcall(updateESP)
        task.wait(0.5)
    end
end)

-- ==============================================================================
-- TRAP DETECTOR
-- ==============================================================================
local function updateTraps(...)
    if not h.trapDetector then
        cleanupTrap()
        return
    end
    if not TRAP_FOLDER then
        TRAP_FOLDER = Instance.new("Folder")
        TRAP_FOLDER.Name = "AntraxHub_TrapESP"
        TRAP_FOLDER.Parent = game:GetService("CoreGui")
    end
    local traps = i4()
    for _, ob in ipairs(traps) do
        if ob and ob.Parent then
            local hname = "Trap_" .. tostring(ob:GetDebugId())
            if not TRAP_FOLDER:FindFirstChild(hname) then
                local hl = Instance.new("Highlight")
                hl.Name = hname
                hl.Adornee = ob
                hl.FillColor = Color3.fromRGB(255, 40, 40)
                hl.FillTransparency = 0.5
                hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = TRAP_FOLDER
            end
        end
    end
end

task.spawn(function(...)
    while h.alive do
        pcall(updateTraps)
        task.wait(1)
    end
end)

-- ==============================================================================
-- AUTO HEAL
-- ==============================================================================
local function autoHealTick(...)
    if not h.autoHeal then return end
    local char = o.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if humanoid.Health < humanoid.MaxHealth * 0.35 then
        -- Try to return to base
        if not h.isReturning and not h.securingEgg and not h.teleporting then
            task.spawn(function(...)
                pcall(function(...) Q4(h.glideSpeed) end)
            end)
        end
    end
end

task.spawn(function(...)
    while h.alive do
        pcall(autoHealTick)
        task.wait(1)
    end
end)

-- ==============================================================================
-- AUTO SELL
-- ==============================================================================
local SellInv = (j.Network and j.Network.SellService and j.Network.SellService.RF and j.Network.SellService.RF.SellInventory) or nil
if not SellInv then
    SellInv = j:FindFirstChild("SellInventory", true) or j:FindFirstChild("RF/SellService/SellInventory", true)
end

local function autoSellTick(...)
    if not h.autoSellEnabled or not SellInv then return end
    local threshold = F[h.autoSellBelow or "Common"] or 0
    local toSell = {}
    local inv = o:FindFirstChild("Backpack")
    local char = o.Character
    local function consider(item)
        if not item or not item:IsA("Tool") then return end
        local cfg = nil
        pcall(function(...) cfg = j.Framework and nil end)
        local rarity = "Common"
        local name = item.Name
        local lower = string.lower(name)
        for _, rr in ipairs(X) do
            if string.find(lower, string.lower(rr)) then rarity = rr break end
        end
        local tier = F[rarity] or 0
        if tier <= threshold then
            local uid = item:GetAttribute("UID") or item:GetAttribute("EggUid") or name
            if uid then table.insert(toSell, uid) end
        end
    end
    if inv then for _, item in ipairs(inv:GetChildren()) do consider(item) end end
    if char then for _, item in ipairs(char:GetChildren()) do consider(item) end end
    if #toSell > 0 then
        pcall(function(...) SellInv:InvokeServer(toSell) end)
    end
end

task.spawn(function(...)
    while h.alive do
        pcall(autoSellTick)
        task.wait(5)
    end
end)

-- ==============================================================================
-- ZONE ROTATION
-- ==============================================================================
local function doZoneRotation(...)
    if not h.zoneRotation then return end
    h.rotationIndex = (h.rotationIndex or 0) + 1
    if h.rotationIndex < (h.rotationCount or 3) then return end
    h.rotationIndex = 0
    -- Toggle zones: pick a random zone, set only that one
    local allZones = {}
    for _, z in ipairs(M) do table.insert(allZones, z) end
    local picked = allZones[math.random(1, #allZones)]
    for _, z in ipairs(M) do h.selectedZones[z] = (z == picked) end
    x()
end

-- ==============================================================================
-- TARGET SELECTION (with rarity filter)
-- ==============================================================================
P4 = function(...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local candidates = {}
    local slots = r:FindFirstChild("AreaEggSlotsClient")
    local list = h4(false)
    if list and #list > 0 then
        for _, rec in ipairs(list) do
            local available = (rec.State == "Slot" or rec.State == "Dropped" or rec.State == 1)
            local isLake = (rec.AreaId == "Lake") or (string.find(string.lower(tostring(rec.AreaId)), "lake") ~= nil) or
                (string.find(string.lower(tostring(rec.Uid)), "lake") ~= nil)
            local cooled = X4[rec.Uid] and (os.clock() < X4[rec.Uid])
            if available and isLake and rec.BoundsCFrame and not cooled then
                local pos = rec.BoundsCFrame.Position
                local dist = ((hrp.Position - pos)).Magnitude
                table.insert(candidates, {Uid = rec.Uid, Model = nil, CFrame = rec.BoundsCFrame, Position = pos, Distance = dist, Area = "Lake"})
            end
        end
    end
    if #candidates == 0 then return nil end
    table.sort(candidates, function(a, b) return a.Distance < b.Distance end)
    local best = candidates[1]
    if best and slots then
        for _, child in ipairs(slots:GetChildren()) do
            local part = child:FindFirstChildWhichIsA("BasePart") or child.PrimaryPart
            if part and ((part.Position - best.Position)).Magnitude <= 8 then
                best.Model = child
                break
            end
        end
    end
    return best
end

local function Dk(area, pos, name, ...)
    local x = pos and pos.X or 0
    local lowerArea = string.lower(tostring(area or ""))
    if (string.find(lowerArea, "light") and string.find(lowerArea, "dark")) or lowerArea == "lightdark" then return "Light Dark"
    elseif string.find(lowerArea, "titan") then return "Titan Temple"
    elseif string.find(lowerArea, "cherry") then return "Cherry Blossom"
    elseif string.find(lowerArea, "cosmic") then return "Cosmic"
    elseif string.find(lowerArea, "prehistoric") or string.find(lowerArea, "dino") then return "Prehistoric"
    elseif string.find(lowerArea, "abyss") or string.find(lowerArea, "ocean") then return "Abyss Ocean"
    elseif string.find(lowerArea, "volcano") or string.find(lowerArea, "lava") then return "Volcano"
    elseif string.find(lowerArea, "snow") or string.find(lowerArea, "ice") or string.find(lowerArea, "winter") then return "Snow"
    elseif string.find(lowerArea, "jungle") then return "Jungle"
    elseif string.find(lowerArea, "desert") or string.find(lowerArea, "sand") then return "Desert"
    elseif string.find(lowerArea, "lake") or string.find(lowerArea, "water") then return "Lake"
    elseif string.find(lowerArea, "forest") then return "Forest" end
    if x > 0 then
        if x >= 5200 then return "Light Dark"
        elseif x >= 4750 then return "Titan Temple"
        elseif x >= 4000 then return "Cherry Blossom"
        elseif x >= 3350 then return "Cosmic"
        elseif x >= 2780 then return "Prehistoric"
        elseif x >= 2250 then return "Abyss Ocean"
        elseif x >= 1850 then return "Volcano"
        elseif x >= 1450 then return "Snow"
        elseif x >= 1150 then return "Jungle"
        elseif x >= 920 then return "Desert"
        elseif x >= 720 then return "Lake"
        else return "Forest" end
    end
    return "Forest"
end

N4 = function(...)
    local list = h4(false)
    if not list or #list == 0 then list = h4(true) end
    if not list or #list == 0 then return nil end
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local myPos = hrp and hrp.Position or Vector3.new(525, 70, -360)
    local function getRarity(rec, cat, explicit)
        if rec and rec.PhysicalModel then
            local pm = rec.PhysicalModel
            local rar = pm:GetAttribute("Rarity") or pm:GetAttribute("RarityTier") or pm:GetAttribute("Tier")
            if rar and tostring(rar) ~= "" and tostring(rar) ~= "Unknown" then explicit = tostring(rar) end
            if not cat or cat == "Egg" or cat == "" then
                cat = pm:GetAttribute("Category") or pm:GetAttribute("AssetCategory") or pm.Name
            end
        end
        local lower1 = string.lower(tostring(rec.Rarity or ""))
        local lower2 = string.lower(tostring(explicit or ""))
        for _, r in ipairs({lower1, lower2}) do
            if r ~= "" and r ~= "unknown" and r ~= "nil" then
                if string.find(r, "divine") then return 6, "Divine" end
                if string.find(r, "eternal") then return 5, "Eternal" end
                if string.find(r, "secret") then return 4, "Secret" end
                if string.find(r, "cosmic") then return 3, "Cosmic" end
                if string.find(r, "mythic") then return 2, "Mythic" end
                if string.find(r, "legendary") then return 1, "Legendary" end
                if string.find(r, "epic") then return 0.5, "Epic" end
                if string.find(r, "rare") then return 0.3, "Rare" end
                if string.find(r, "uncommon") then return 0.1, "Uncommon" end
                if string.find(r, "common") then return 0, "Common" end
            end
        end
        local o2 = (explicit and explicit ~= "Unknown" and explicit) or "Common"
        return F[o2] or 0, o2
    end
    local function score(forceAll)
        local candidates = {}
        for _, rec in ipairs(list) do
            local available = (rec.State == "Slot" or rec.State == "Dropped" or rec.State == "GuardCarried" or rec.State == 1)
            local blocked = (rec.BoundsCFrame and rec.BoundsCFrame.Position.X < 530) or string.find(tostring(rec.Uid), "FirstArea")
            local cooled = X4[rec.Uid] and (os.clock() < X4[rec.Uid])
            if available and not blocked and rec.BoundsCFrame and (forceAll or not cooled) then
                local cat = rec.AssetCategory or "Egg"
                local pos = rec.BoundsCFrame.Position
                local area = rec.AreaId
                if (not area or area == "" or area == "Unknown") and rec.PhysicalModel then
                    area = rec.PhysicalModel:GetAttribute("AreaId") or rec.PhysicalModel:GetAttribute("Area")
                end
                local combined = string.format("%s %s %s %s", tostring(cat or ""), tostring(rec.Uid or ""), tostring(rec.Name or ""), (rec.PhysicalModel and rec.PhysicalModel.Name) or "")
                local zone = Dk(area, pos, combined)
                local tier, rarName = getRarity(rec, cat)
                local rarityAllowed = (h.selectedRarities and h.selectedRarities[rarName] == true)
                local zoneOk = (h.selectedZones and h.selectedZones[zone] == true)
                local isSecretPlus = (rarName == "Secret" or rarName == "Eternal" or rarName == "Divine")
                local allowed = rarityAllowed and (zoneOk or (h.alwaysCollectSecretPlus and isSecretPlus))
                if allowed then
                    local scale = tonumber(rec.AssetScale or rec.Scale) or 1
                    local dist = ((myPos - rec.BoundsCFrame.Position)).Magnitude
                    table.insert(candidates, {
                        Uid = rec.Uid, Category = cat, Area = zone,
                        ZoneWeight = f[zone] or 50,
                        Rarity = rarName, RarityTier = tier,
                        RealIncome = 0, Scale = scale,
                        CFrame = rec.BoundsCFrame, Position = rec.BoundsCFrame.Position,
                        Distance = dist, Model = rec.PhysicalModel
                    })
                end
            end
        end
        if #candidates == 0 then return nil end
        table.sort(candidates, function(a, b)
            local sa = ((a.RarityTier or 0) >= 4) and (400000 + (a.RarityTier or 0) * 10000) + (a.ZoneWeight or 50) or ((a.ZoneWeight or 50) * 11 + (a.RarityTier or 0) * 1000)
            local sb = ((b.RarityTier or 0) >= 4) and (400000 + (b.RarityTier or 0) * 10000) + (b.ZoneWeight or 50) or ((b.ZoneWeight or 50) * 11 + (b.RarityTier or 0) * 1000)
            if sa ~= sb then return sa > sb end
            if a.ZoneWeight ~= b.ZoneWeight then return a.ZoneWeight > b.ZoneWeight end
            return a.Distance < b.Distance
        end)
        return candidates[1]
    end
    local target = score(false)
    if not target then X4 = {} target = score(true) end
    if not target then list = h4(true) target = score(true) end
    if target and r:FindFirstChild("AreaEggSlotsClient") then
        for _, child in ipairs(r.AreaEggSlotsClient:GetChildren()) do
            local part = child:FindFirstChildWhichIsA("BasePart") or child.PrimaryPart
            if part and ((part.Position - target.Position)).Magnitude <= 12 then
                target.Model = child
                break
            end
        end
    end
    return target
end

U4 = function(uid, target, model, sess, ...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return false end
    h.securingEgg = true h.isReturning = false h.stateTime = os.clock()
    h.holdingEggForGuard = true
    local pos = target.Position
    V4(pos, 14)
    h.currentTargetModel = model h.targetPosition = pos
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    Z4(char)
    pcall(function(...) o:RequestStreamAroundAsync(pos) end)
    if not model and r:FindFirstChild("AreaEggSlotsClient") then
        for _, child in ipairs(r.AreaEggSlotsClient:GetChildren()) do
            local part = child:FindFirstChildWhichIsA("BasePart") or child.PrimaryPart
            if part and ((part.Position - pos)).Magnitude <= 16 then
                model = child h.currentTargetModel = child
                break
            end
        end
    end
    local deadline = os.clock() + 3.5
    local lastCheck = 0
    while not w4() and os.clock() < deadline and h.alive and h.securingEgg do
        if sess and O4 ~= sess then break end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.teleporting then break end
        if uid and (os.clock() - lastCheck > 0.4) then
            lastCheck = os.clock()
            local ok, reason = k4(uid)
            if not ok and reason == "CarriedByOther" then break end
        end
        char:PivotTo(target * CFrame.new(0, 0.4, 0))
        d4(model, pos)
        if uid and i then
            task.spawn(function(...)
                pcall(function(...)
                    if i:IsA("RemoteFunction") then
                        i:InvokeServer({["Uid"] = uid})
                        i:InvokeServer(uid)
                    else
                        i:FireServer({["Uid"] = uid})
                        i:FireServer(uid)
                    end
                end)
            end)
        end
        y.Heartbeat:Wait()
    end
    if not w4() then
        if uid then X4[uid] = os.clock() + 2 end
        h.currentTargetModel = nil h.targetPosition = nil
        h.securingEgg = false h.holdingEggForGuard = false
        return false
    end
    local start = os.clock()
    local deadline2 = start + 4.5
    local strikeSent = false
    while w4() and os.clock() < deadline2 and h.alive and h.securingEgg do
        if sess and O4 ~= sess then break end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.teleporting then break end
        char:PivotTo(target * CFrame.new(0, 0.4, 0))
        V4(pos, 14)
        if P and not strikeSent then
            task.spawn(function(...)
                pcall(function(...)
                    if P:IsA("RemoteFunction") then P:InvokeServer()
                    else P:FireServer() end
                end)
            end)
            strikeSent = true
        end
        y.Heartbeat:Wait()
    end
    local deadline3 = os.clock() + 3
    while not w4() and os.clock() < deadline3 and h.alive and h.securingEgg do
        if sess and O4 ~= sess then break end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.teleporting then break end
        char:PivotTo(target * CFrame.new(0, 0.4, 0))
        d4(model, pos)
        if uid and i then
            task.spawn(function(...)
                pcall(function(...)
                    if i:IsA("RemoteFunction") then
                        i:InvokeServer({["Uid"] = uid})
                        i:InvokeServer(uid)
                    else
                        i:FireServer({["Uid"] = uid})
                        i:FireServer(uid)
                    end
                end)
            end)
        end
        y.Heartbeat:Wait()
    end
    local success = j4(uid)
    if not success then
        task.wait(0.12)
        success = j4(uid)
    end
    h.currentTargetModel = nil h.targetPosition = nil
    h.securingEgg = false h.holdingEggForGuard = false
    if sess and O4 ~= sess then return false end
    if success then
        pcall(u4)
        -- Record steal
        local rarity = "Unknown"
        if target then rarity = target.Rarity or "Unknown" end
        recordSteal(rarity, target and target.Category or "Egg")
        -- Notification for Secret+
        if h.notifySecretPlus and (rarity == "Secret" or rarity == "Eternal" or rarity == "Divine") then
            if h.soundAlert then
                pcall(function(...)
                    local snd = Instance.new("Sound")
                    snd.SoundId = "rbxassetid://9120386436"
                    snd.Volume = 2
                    snd.Parent = game:GetService("SoundService")
                    snd:Play()
                    task.delay(2, function(...) pcall(function(...) snd:Destroy() end) end)
                end)
            end
            pcall(function(...)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Antrax • " .. rarity,
                    Text = "Stole a " .. rarity .. " egg!",
                    Duration = 3
                })
            end)
        end
        -- Zone rotation
        if h.zoneRotation then pcall(doZoneRotation) end
        return true
    else
        if uid then X4[uid] = os.clock() + 2 end
        return false
    end
end

l4 = function(target, sess, ...)
    if h.teleporting or h.glidingToTarget or h.delivering or h.securingEgg then return false end
    h.teleporting = true h.isReturning = false h.stateTime = os.clock()
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then D4() return false end
    humanoid:UnequipTools()
    if not h.swapped then A4() end
    if not h.godmode then b4(true) end
    Z4(char)
    if not target then target = N4() end
    if not target then D4() return false end
    local cf = target.CFrame
    local uid = target.Uid
    local pos = cf.Position
    if uid then
        local ok, reason = k4(uid)
        if not ok and reason ~= "CarriedBySelf" then
            X4[uid] = os.clock() + 5 D4() return false
        end
    end
    h.currentTargetModel = target.Model h.targetPosition = pos
    pcall(function(...) o:RequestStreamAroundAsync(pos) end)
    V4(pos, 12)
    char:PivotTo(cf * CFrame.new(0, 0.4, 0))
    hrp.Anchored = true
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.AssemblyLinearVelocity = Vector3.zero
            obj.AssemblyAngularVelocity = Vector3.zero
        end
    end
    local bp = o:FindFirstChild("Backpack")
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            pcall(function(...)
                if bp then child.Parent = bp else child.Parent = r end
            end)
        end
    end
    task.wait(0.06)
    hrp.Anchored = false
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
    local ok = U4(uid, cf, target.Model, sess)
    if not ok then D4() return false
    else
        h.teleporting = false
        pcall(u4)
        return true
    end
end

T4 = function(mode, ...)
    if Y4 == mode then return end
    O4 = O4 + 1
    local sess = O4
    Y4 = "SWITCHING"
    h.pureTweenFarm = false h.autoFarmLoop = false
    pcall(D4) pcall(u4)
    if mode == "TWEEN" then
        if W4 then W4(false, true) end
        if x4 then x4(true, true) end
    elseif mode == "WARP" then
        if x4 then x4(false, true) end
        if W4 then W4(true, true) end
    else
        if x4 then x4(false, true) end
        if W4 then W4(false, true) end
    end
    task.delay(0.06, function(...)
        if O4 == sess then
            Y4 = mode
            if mode == "TWEEN" then
                h.pureTweenFarm = true h.autoFarmLoop = false
                pcall(u4)
            elseif mode == "WARP" then
                h.autoFarmLoop = true h.pureTweenFarm = false
                pcall(u4)
            else
                h.pureTweenFarm = false h.autoFarmLoop = false
                if not h.isBatchPlacing then h.batchStealCount = 0 end
            end
        end
    end)
end

-- ==============================================================================
-- MAIN LOOPS
-- ==============================================================================
local Ck = os.clock()
task.spawn(function(...)
    while h.alive do
        local ok, err = pcall(function(...)
            if h.pureTweenFarm and not h.autoFarmLoop and Y4 == "TWEEN" and
               not h.isBatchPlacing and not h.teleporting and not h.glidingToTarget and
               not h.securingEgg and not h.delivering and not h.isReturning then
                local char = o.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and humanoid then
                    pcall(u4)
                    local hasEgg = w4()
                    if not hasEgg then
                        local sess = O4
                        local target = N4()
                        if target and h.pureTweenFarm and Y4 == "TWEEN" and O4 == sess then
                            if h.onTreadmill or L4() then M4() task.wait(0.08) end
                            local ok2, reason = k4(target.Uid)
                            if not ok2 and reason ~= "CarriedBySelf" then
                                X4[target.Uid] = os.clock() + 5
                                task.wait(0.12)
                                return
                            end
                            h.currentTargetModel = target.Model h.targetPosition = target.Position
                            h.glidingToTarget = true h.stateTime = os.clock()
                            if not h.swapped then A4() end
                            if not h.godmode then b4(true) end
                            Z4(char)
                            pcall(function(...) o:RequestStreamAroundAsync(target.Position) end)
                            local align = target.CFrame * CFrame.new(0, 0.4, 0)
                            local flew = R4(align, h.glideSpeed, target.Uid, sess)
                            h.glidingToTarget = false
                            if O4 ~= sess or not h.pureTweenFarm or Y4 ~= "TWEEN" then return end
                            if not flew then
                                X4[target.Uid] = os.clock() + 5 D4() return
                            end
                            if ((hrp.Position - target.Position)).Magnitude <= 22 then
                                local secured = U4(target.Uid, align, target.Model, sess)
                                if not secured and w4() then secured = true end
                                if O4 ~= sess or not h.pureTweenFarm or Y4 ~= "TWEEN" then return end
                                if secured then
                                    pcall(u4)
                                    if h.autoGlide then Q4(h.glideSpeed, sess) pcall(u4) end
                                    pcall(u4)
                                    h.isReturning = false h.delivering = false h.glidingToTarget = false
                                    h.securingEgg = false h.currentTargetModel = nil h.targetPosition = nil
                                    if c4("TWEEN") then return end
                                else
                                    if O4 == sess and h.pureTweenFarm and Y4 == "TWEEN" then
                                        X4[target.Uid] = os.clock() + 5 D4()
                                    end
                                end
                            else
                                h.currentTargetModel = nil h.targetPosition = nil h.glidingToTarget = false
                            end
                        else
                            if os.clock() - Ck > 5 then X4 = {} Ck = os.clock() end
                            if h.autoTreadmill and not h.isBatchPlacing and not h.isHatching then
                                if not h.onTreadmill and not L4() then f4() end
                            end
                        end
                    end
                end
            end
        end)
        if not ok then pcall(D4) end
        task.wait(0.08)
    end
end)

local qk = os.clock()
task.spawn(function(...)
    while h.alive do
        local ok, err = pcall(function(...)
            if h.autoFarmLoop and not h.pureTweenFarm and Y4 == "WARP" and
               not h.isBatchPlacing and not h.teleporting and not h.glidingToTarget and
               not h.securingEgg and not h.delivering and not h.isReturning then
                local char = o.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and humanoid then
                    pcall(u4)
                    local hasEgg = w4()
                    if not hasEgg then
                        local sess = O4
                        local target = N4()
                        if target and h.autoFarmLoop and Y4 == "WARP" and O4 == sess then
                            if h.onTreadmill or L4() then M4() task.wait(0.08) end
                            local secured = l4(target, sess)
                            if O4 ~= sess or not h.autoFarmLoop or Y4 ~= "WARP" then return end
                            if secured then
                                pcall(u4)
                                if h.autoGlide then Q4(h.glideSpeed, sess) pcall(u4) end
                                pcall(u4)
                                h.isReturning = false h.delivering = false
                                if c4("WARP") then return end
                            else
                                if O4 == sess and h.autoFarmLoop and Y4 == "WARP" then
                                    if target and target.Uid then X4[target.Uid] = os.clock() + 5 end
                                    pcall(D4)
                                end
                            end
                        else
                            if os.clock() - qk > 5 then X4 = {} qk = os.clock() end
                            if h.autoTreadmill and not h.isBatchPlacing and not h.isHatching then
                                if not h.onTreadmill and not L4() then f4() end
                            end
                        end
                    end
                end
            end
        end)
        if not ok then pcall(D4) end
        task.wait(0.08)
    end
end)

task.spawn(function(...)
    while h.alive do
        pcall(function(...)
            if h.autoTreadmill and not h.pureTweenFarm and not h.autoFarmLoop and
               not h.isBatchPlacing and not h.isHatching and not h.teleporting and
               not h.glidingToTarget and not h.securingEgg and not h.delivering and not h.isReturning then
                local char = o.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and not w4() then
                    if not h.onTreadmill and not L4() then f4() end
                end
            end
        end)
        task.wait(0.5)
    end
end)

task.spawn(function(...)
    while h.alive do
        pcall(function(...) if h.autoUpgradeTreadmill then pk() end end)
        task.wait(5)
        pcall(function(...) if h.autoBuyTrails then gk() end end)
        task.wait(5)
    end
end)

task.spawn(function(...)
    while h.alive do
        if h.autoHatch and not h.securingEgg and not h.teleporting and not h.isHatching then
            pcall(function(...) J4(false) end)
        end
        task.wait(4)
    end
end)

-- Stats save every 30s
task.spawn(function(...)
    while h.alive do
        task.wait(30)
        pcall(saveStats)
    end
end)

pcall(loadStats)

-- ==============================================================================
-- ANTI-KICK / AUTO RECONNECT
-- ==============================================================================
-- Uses LP.Idled to detect kick signal; robust rejoin on disconnect handled by executor typically
local function setupAntiKick(...)
    if not h.antiKick then return end
    pcall(function(...)
        local conn = o.Idled:Connect(function(...)
            -- Prevent Roblox 20-min kick
            pcall(function(...)
                if typeof(VirtualUserInput) == "function" then
                    VirtualUserInput()
                elseif typeof(VirtualInputManager) == "userdata" then
                    local VIM = game:GetService("VirtualInputManager")
                    VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.05)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                end
            end)
        end)
        table.insert(TRAP_CONNS, conn)
    end)
end

task.spawn(function(...)
    while h.alive do
        pcall(setupAntiKick)
        task.wait(10)
    end
end)

-- ==============================================================================
-- PERFORMANCE MODE
-- ==============================================================================
local function fk(obj, ...)
    pcall(function(...)
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
            if obj:IsA("MeshPart") then
                obj.TextureID = ""
            end
        elseif obj:IsA("SpecialMesh") then obj.TextureId = ""
        elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then obj.Enabled = false
        elseif obj:IsA("Beam") then obj.Enabled = false
        elseif obj:IsA("Light") or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then obj.Enabled = false
        elseif obj:IsA("Highlight") and obj.Name ~= "EggESP_Highlight" and not obj.Name:find("ESP_") and not obj.Name:find("Trap_") then obj.Enabled = false end
    end)
end

local function Mk(...)
    h.performanceMode = true
    pcall(function(...)
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9000000000
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("Atmosphere") then
                pcall(function(...) obj.Enabled = false end)
            elseif obj:IsA("Sky") then
                pcall(function(...) obj.Parent = nil end)
            end
        end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            pcall(function(...)
                terrain.Decoration = false
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
            end)
        end
        for _, obj in ipairs(workspace:GetDescendants()) do fk(obj) end
        if not nk then
            nk = workspace.DescendantAdded:Connect(function(child, ...)
                if h.performanceMode then fk(child) end
            end)
        end
    end)
end

local function Ik(...)
    h.performanceMode = false
    if nk then pcall(function(...) nk:Disconnect() end) nk = nil end
    pcall(function(...)
        Lighting.GlobalShadows = true
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("Atmosphere") then
                pcall(function(...) obj.Enabled = true end)
            end
        end
    end)
end

-- ==============================================================================
-- ANTI-AFK
-- ==============================================================================
local function Ek(...)
    pcall(function(...)
        local VIM = game:GetService("VirtualInputManager")
        if VIM then
            VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end)
    pcall(function(...)
        if typeof(mousemoverel) == "function" then
            mousemoverel(1, 0)
            task.wait(0.05)
            mousemoverel(-1, 0)
        end
    end)
end

local function bk(...)
    if Lk then return end
    Lk = true
    task.spawn(function(...)
        while h and h.alive and h.antiAFK do
            task.wait(240)
            if not h.antiAFK or not Lk then break end
            Ek()
        end
        Lk = false
    end)
end

local function Ak(...) Lk = false end

-- ==============================================================================
-- HEARTBEAT
-- ==============================================================================
y.Heartbeat:Connect(function(...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp then return end
    if humanoid and not (h and h.onTreadmill) then
        if humanoid.PlatformStand then
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        if humanoid.Sit and (h.pureTweenFarm or h.autoFarmLoop or h.isReturning or h.glidingToTarget) then
            humanoid.Sit = false
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
    local pos = hrp.Position
    if pos.Y < 45 then
        hrp.CFrame = CFrame.new(pos.X, 72, pos.Z)
        hrp.AssemblyLinearVelocity = Vector3.zero
        return
    end
    if (h.pureTweenFarm or h.autoFarmLoop) and not h.holdingEggForGuard then
        local toolEquipped = false
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") then toolEquipped = true break end
        end
        if toolEquipped then u4() end
    end
end)

-- ==============================================================================
-- PRESETS SYSTEM
-- ==============================================================================
local function savePreset(name, ...)
    pcall(function(...)
        if not writefile or not a then return end
        local all = {}
        if readfile and isfile and isfile(Z_PRESETS) then
            local raw = readfile(Z_PRESETS)
            if raw and raw ~= "" then
                local obj = a:JSONDecode(raw)
                if type(obj) == "table" then all = obj end
            end
        end
        all[name] = {
            selectedZones = h.selectedZones,
            selectedRarities = h.selectedRarities,
            glideSpeed = h.glideSpeed,
            stealSpeedMult = h.stealSpeedMult,
            returnSpeedMult = h.returnSpeedMult,
            alwaysCollectSecretPlus = h.alwaysCollectSecretPlus,
            autoSellBelow = h.autoSellBelow,
            rotationCount = h.rotationCount,
            theme = h.themeName,
            savedAt = os.time()
        }
        writefile(Z_PRESETS, a:JSONEncode(all))
    end)
end

local function loadPreset(name, ...)
    pcall(function(...)
        if not readfile or not a then return end
        if not (isfile and isfile(Z_PRESETS)) then return end
        local raw = readfile(Z_PRESETS)
        if not raw or raw == "" then return end
        local all = a:JSONDecode(raw)
        if type(all) ~= "table" then return end
        local preset = all[name]
        if type(preset) ~= "table" then return end
        if preset.selectedZones then h.selectedZones = preset.selectedZones end
        if preset.selectedRarities then h.selectedRarities = preset.selectedRarities end
        if preset.glideSpeed then h.glideSpeed = preset.glideSpeed end
        if preset.stealSpeedMult then h.stealSpeedMult = preset.stealSpeedMult end
        if preset.returnSpeedMult then h.returnSpeedMult = preset.returnSpeedMult end
        if preset.alwaysCollectSecretPlus ~= nil then h.alwaysCollectSecretPlus = preset.alwaysCollectSecretPlus end
        if preset.autoSellBelow then h.autoSellBelow = preset.autoSellBelow end
        if preset.rotationCount then h.rotationCount = preset.rotationCount end
        if preset.theme and THEMES[preset.theme] then
            TH = THEMES[preset.theme]
            h.themeName = preset.theme
        end
        x()
    end)
end

-- ==============================================================================
-- UI BUILDER
-- ==============================================================================
local function buildUI(...)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Antrax_Antrax_UI"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 9999
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.AutoLocalize = false
    pcall(function(...)
        if syn and syn.protect_gui then
            syn.protect_gui(screenGui)
            screenGui.Parent = game:GetService("CoreGui")
        else
            screenGui.Parent = o:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
        end
    end)
    if not screenGui.Parent then screenGui.Parent = game:GetService("CoreGui") end
    h.gui = screenGui

    local WINDOW_W = 500
    local WINDOW_H = 380
    local HEADER_H = 38
    local SIDEBAR_W = 130

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.fromOffset(WINDOW_W, WINDOW_H)
    main.Position = UDim2.new(0, 30, 0, 60)
    main.BackgroundColor3 = TH.Bg
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Parent = screenGui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = TH.Accent
    mainStroke.Thickness = 1.4
    mainStroke.Transparency = 0.2

    local topGlow = Instance.new("Frame")
    topGlow.Size = UDim2.new(1, 0, 0, 2)
    topGlow.BackgroundColor3 = TH.AccentBright
    topGlow.BorderSizePixel = 0
    topGlow.ZIndex = 3
    topGlow.Parent = main

    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, HEADER_H)
    header.BackgroundColor3 = TH.Header
    header.BorderSizePixel = 0
    header.Active = true
    header.ZIndex = 2
    header.Parent = main
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

    local headerCover = Instance.new("Frame")
    headerCover.Size = UDim2.new(1, 0, 0, 12)
    headerCover.Position = UDim2.new(0, 0, 1, -12)
    headerCover.BackgroundColor3 = TH.Header
    headerCover.BorderSizePixel = 0
    headerCover.ZIndex = 2
    headerCover.Parent = header

    local strip = Instance.new("Frame")
    strip.Size = UDim2.new(1, 0, 0, 2)
    strip.Position = UDim2.new(0, 0, 1, -2)
    strip.BackgroundColor3 = TH.Accent
    strip.BorderSizePixel = 0
    strip.ZIndex = 3
    strip.Parent = header

    local logo = Instance.new("Frame")
    logo.Size = UDim2.fromOffset(20, 20)
    logo.Position = UDim2.fromOffset(11, 9)
    logo.BackgroundColor3 = TH.Accent
    logo.BorderSizePixel = 0
    logo.ZIndex = 3
    logo.Parent = header
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 5)

    local logoInner = Instance.new("Frame")
    logoInner.Size = UDim2.fromOffset(8, 8)
    logoInner.Position = UDim2.fromScale(0.5, 0.5)
    logoInner.AnchorPoint = Vector2.new(0.5, 0.5)
    logoInner.BackgroundColor3 = TH.Text
    logoInner.BorderSizePixel = 0
    logoInner.ZIndex = 4
    logoInner.Parent = logo
    Instance.new("UICorner", logoInner).CornerRadius = UDim.new(1, 0)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -280, 0, 16)
    titleLbl.Position = UDim2.fromOffset(38, 4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextColor3 = TH.AccentGlow
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Text = "Antrax Hub — Ultimate"
    titleLbl.ZIndex = 3
    titleLbl.Parent = header

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -280, 0, 12)
    subLbl.Position = UDim2.fromOffset(38, 21)
    subLbl.BackgroundTransparency = 1
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 9
    subLbl.TextColor3 = TH.Muted
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.Text = CREDITS_FULL
    subLbl.ZIndex = 3
    subLbl.Parent = header

    local badge = Instance.new("Frame")
    badge.Size = UDim2.fromOffset(105, 18)
    badge.Position = UDim2.new(1, -238, 0, 10)
    badge.BackgroundColor3 = TH.AccentDeep
    badge.BorderSizePixel = 0
    badge.ZIndex = 3
    badge.Parent = header
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)
    local badgeStroke = Instance.new("UIStroke", badge)
    badgeStroke.Color = TH.Accent
    badgeStroke.Thickness = 1
    badgeStroke.Transparency = 0.4

    local badgeLbl = Instance.new("TextLabel")
    badgeLbl.Size = UDim2.fromScale(1, 1)
    badgeLbl.BackgroundTransparency = 1
    badgeLbl.Font = Enum.Font.GothamBold
    badgeLbl.TextSize = 9
    badgeLbl.TextColor3 = TH.AccentGlow
    badgeLbl.Text = CREDITS_TG
    badgeLbl.ZIndex = 4
    badgeLbl.Parent = badge

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(24, 20)
    minBtn.Position = UDim2.new(1, -58, 0, 9)
    minBtn.BackgroundColor3 = TH.AccentDark
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.TextColor3 = TH.Text
    minBtn.Text = "−"
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 5
    minBtn.Parent = header
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(24, 20)
    closeBtn.Position = UDim2.new(1, -30, 0, 9)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 11
    closeBtn.TextColor3 = TH.Text
    closeBtn.Text = "X"
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 5
    closeBtn.Parent = header
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, 0, 1, -HEADER_H)
    body.Position = UDim2.fromOffset(0, HEADER_H)
    body.BackgroundTransparency = 1
    body.Parent = main

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -16)
    sidebar.Position = UDim2.fromOffset(8, 8)
    sidebar.BackgroundColor3 = TH.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = body
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)
    local sidebarStroke = Instance.new("UIStroke", sidebar)
    sidebarStroke.Color = TH.Border
    sidebarStroke.Thickness = 1
    sidebarStroke.Transparency = 0.6

    local sidebarLayout = Instance.new("UIListLayout", sidebar)
    sidebarLayout.Padding = UDim.new(0, 3)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local sidebarPad = Instance.new("UIPadding", sidebar)
    sidebarPad.PaddingTop = UDim.new(0, 5)
    sidebarPad.PaddingLeft = UDim.new(0, 4)
    sidebarPad.PaddingRight = UDim.new(0, 4)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -(SIDEBAR_W + 24), 1, -16)
    content.Position = UDim2.fromOffset(SIDEBAR_W + 16, 8)
    content.BackgroundColor3 = TH.Card
    content.BorderSizePixel = 0
    content.ClipsDescendants = true
    content.Parent = body
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)
    local contentStroke = Instance.new("UIStroke", content)
    contentStroke.Color = TH.Border
    contentStroke.Thickness = 1
    contentStroke.Transparency = 0.6

    -- Status bar
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, -16, 0, 20)
    statusBar.Position = UDim2.new(0, 8, 1, -26)
    statusBar.BackgroundColor3 = TH.Deep
    statusBar.BorderSizePixel = 0
    statusBar.Parent = main
    Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 5)

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.fromOffset(7, 7)
    statusDot.Position = UDim2.new(0, 7, 0.5, -3.5)
    statusDot.BackgroundColor3 = TH.Muted
    statusDot.BorderSizePixel = 0
    statusDot.Parent = statusBar
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, -22, 1, 0)
    statusLbl.Position = UDim2.fromOffset(20, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "Idle"
    statusLbl.TextColor3 = TH.Sub
    statusLbl.TextSize = 10
    statusLbl.Font = Enum.Font.Gotham
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.Parent = statusBar

    -- Tab system
    local tabs = {}
    local activeTab = nil

    local function showTab(name)
        for tabName, tab in pairs(tabs) do
            local isActive = (tabName == name)
            tab.frame.Visible = isActive
            if isActive then
                tab.button.BackgroundColor3 = TH.AccentDark
                tab.button.TextColor3 = TH.AccentGlow
                local stroke = tab.button:FindFirstChildOfClass("UIStroke")
                if not stroke then stroke = Instance.new("UIStroke", tab.button) end
                stroke.Color = TH.Accent
                stroke.Thickness = 1.2
                stroke.Transparency = 0.2
            else
                tab.button.BackgroundColor3 = TH.SidebarItem
                tab.button.TextColor3 = TH.Sub
                local stroke = tab.button:FindFirstChildOfClass("UIStroke")
                if stroke then stroke:Destroy() end
            end
        end
        activeTab = name
    end

    local function addTab(name, label)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. name
        tabBtn.Size = UDim2.new(1, 0, 0, 27)
        tabBtn.BackgroundColor3 = TH.SidebarItem
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.TextSize = 10
        tabBtn.TextColor3 = TH.Sub
        tabBtn.Text = "  " .. label
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = sidebar
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)

        local tabFrame = Instance.new("Frame")
        tabFrame.Name = "Content_" .. name
        tabFrame.Size = UDim2.fromScale(1, 1)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = content

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.fromScale(1, 1)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 4
        scroll.ScrollBarImageColor3 = TH.Accent
        scroll.ScrollBarImageTransparency = 0.3
        scroll.CanvasSize = UDim2.new()
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Parent = tabFrame

        local layout = Instance.new("UIListLayout", scroll)
        layout.Padding = UDim.new(0, 5)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        local pad = Instance.new("UIPadding", scroll)
        pad.PaddingTop = UDim.new(0, 6)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)

        tabs[name] = {button = tabBtn, frame = tabFrame, scroll = scroll}
        tabBtn.MouseButton1Click:Connect(function(...) showTab(name) end)
        return scroll
    end

    -- Section header
    local function addSection(parent, text, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 18)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = parent

        local accent = Instance.new("Frame")
        accent.Size = UDim2.fromOffset(3, 10)
        accent.Position = UDim2.new(0, 0, 0.5, -5)
        accent.BackgroundColor3 = TH.Accent
        accent.BorderSizePixel = 0
        accent.Parent = frame
        Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 2)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -12, 1, 0)
        label.Position = UDim2.fromOffset(10, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = TH.AccentGlow
        label.TextSize = 10
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
    end

    -- Toggle
    local function addToggle(parent, title, desc, initial, order, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 32)
        frame.BackgroundColor3 = TH.Deep
        frame.LayoutOrder = order
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -60, 0, 12)
        titleLbl.Position = UDim2.fromOffset(10, 4)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = TH.Text
        titleLbl.TextSize = 10
        titleLbl.Font = Enum.Font.GothamSemibold
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = frame

        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, -60, 0, 10)
        descLbl.Position = UDim2.fromOffset(10, 17)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = desc
        descLbl.TextColor3 = TH.Muted
        descLbl.TextSize = 8
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.TextTruncate = Enum.TextTruncate.AtEnd
        descLbl.Parent = frame

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.fromOffset(36, 18)
        toggle.Position = UDim2.new(1, -44, 0.5, -9)
        toggle.BackgroundColor3 = initial and TH.AccentDark or TH.Off
        toggle.Text = ""
        toggle.AutoButtonColor = false
        toggle.Parent = frame
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local toggleStroke = Instance.new("UIStroke", toggle)
        toggleStroke.Color = initial and TH.Accent or TH.Border
        toggleStroke.Thickness = 1
        toggleStroke.Transparency = 0.3

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(14, 14)
        knob.Position = initial and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        knob.BackgroundColor3 = initial and TH.AccentGlow or TH.Muted
        knob.Parent = toggle
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local state = initial
        local function setVisual(v)
            state = v
            TweenService:Create(toggle, TweenInfo.new(0.15), {BackgroundColor3 = state and TH.AccentDark or TH.Off}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = state and TH.AccentGlow or TH.Muted
            }):Play()
            toggleStroke.Color = state and TH.Accent or TH.Border
            titleLbl.TextColor3 = state and TH.AccentGlow or TH.Text
        end

        toggle.MouseButton1Click:Connect(function(...)
            setVisual(not state)
            callback(state)
        end)
        return setVisual
    end

    -- Button
    local function addButton(parent, title, desc, color, order, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 32)
        frame.BackgroundColor3 = TH.Deep
        frame.LayoutOrder = order
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -75, 0, 12)
        titleLbl.Position = UDim2.fromOffset(10, 4)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = color or TH.Text
        titleLbl.TextSize = 10
        titleLbl.Font = Enum.Font.GothamSemibold
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = frame

        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, -75, 0, 10)
        descLbl.Position = UDim2.fromOffset(10, 17)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = desc
        descLbl.TextColor3 = TH.Muted
        descLbl.TextSize = 8
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.TextTruncate = Enum.TextTruncate.AtEnd
        descLbl.Parent = frame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(58, 22)
        btn.Position = UDim2.new(1, -68, 0.5, -11)
        btn.BackgroundColor3 = color or TH.Accent
        btn.Text = "RUN"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.Parent = frame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

        btn.MouseButton1Click:Connect(function(...)
            TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = TH.AccentBright}):Play()
            task.delay(0.1, function(...)
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color or TH.Accent}):Play()
            end)
            callback()
        end)
    end

    -- Chip group
    local function addChips(parent, title, items, order, getState, onToggle, cols)
        cols = cols or 2
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 26 + math.ceil(#items / cols) * 24)
        frame.BackgroundColor3 = TH.Deep
        frame.LayoutOrder = order
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local head = Instance.new("TextLabel")
        head.Size = UDim2.new(1, -12, 0, 14)
        head.Position = UDim2.fromOffset(10, 4)
        head.BackgroundTransparency = 1
        head.Text = title
        head.TextColor3 = TH.AccentGlow
        head.TextSize = 9
        head.Font = Enum.Font.GothamBold
        head.TextXAlignment = Enum.TextXAlignment.Left
        head.Parent = frame

        local grid = Instance.new("Frame")
        grid.Size = UDim2.new(1, -16, 1, -20)
        grid.Position = UDim2.fromOffset(8, 18)
        grid.BackgroundTransparency = 1
        grid.Parent = frame

        local gridLayout = Instance.new("UIGridLayout", grid)
        gridLayout.CellSize = UDim2.new(1 / cols, -3, 0, 20)
        gridLayout.CellPadding = UDim2.new(0, 3, 0, 3)
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

        for i, item in ipairs(items) do
            local chip = Instance.new("TextButton")
            chip.LayoutOrder = i
            chip.Font = Enum.Font.GothamSemibold
            chip.TextSize = 9
            chip.AutoButtonColor = false
            chip.TextTruncate = Enum.TextTruncate.AtEnd
            Instance.new("UICorner", chip).CornerRadius = UDim.new(0, 4)

            local chipStroke = Instance.new("UIStroke", chip)
            chipStroke.Thickness = 1
            chipStroke.Transparency = 0.4

            local function refresh()
                local active = getState(item)
                if active then
                    chip.BackgroundColor3 = (G[item] or TH.AccentDark)
                    chip.TextColor3 = Color3.new(1, 1, 1)
                    chip.Text = "+ " .. item
                    chipStroke.Color = TH.Accent
                else
                    chip.BackgroundColor3 = TH.Off
                    chip.TextColor3 = TH.Sub
                    chip.Text = item
                    chipStroke.Color = TH.Border
                end
            end

            refresh()

            chip.MouseButton1Click:Connect(function(...)
                onToggle(item)
                refresh()
            end)

            chip.Parent = grid
        end
    end

    -- Slider
    local function addSlider(parent, title, min, max, step, initial, order, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 32)
        frame.BackgroundColor3 = TH.Deep
        frame.LayoutOrder = order
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -80, 0, 12)
        lbl.Position = UDim2.fromOffset(10, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = TH.Text
        lbl.TextSize = 10
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0, 60, 0, 18)
        valLbl.Position = UDim2.new(1, -68, 0.5, -9)
        valLbl.BackgroundColor3 = TH.Off
        valLbl.Text = tostring(initial)
        valLbl.TextColor3 = TH.AccentGlow
        valLbl.TextSize = 9
        valLbl.Font = Enum.Font.GothamBold
        valLbl.Parent = frame
        Instance.new("UICorner", valLbl).CornerRadius = UDim.new(0, 4)

        local minus = Instance.new("TextButton")
        minus.Size = UDim2.fromOffset(18, 18)
        minus.Position = UDim2.new(1, -90, 0.5, -9)
        minus.BackgroundColor3 = TH.Off
        minus.Text = "−"
        minus.TextColor3 = TH.Text
        minus.TextSize = 12
        minus.Font = Enum.Font.GothamBold
        minus.Parent = frame
        Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 4)

        local plus = Instance.new("TextButton")
        plus.Size = UDim2.fromOffset(18, 18)
        plus.Position = UDim2.new(1, -110, 0.5, -9)
        plus.BackgroundColor3 = TH.Off
        plus.Text = "+"
        plus.TextColor3 = TH.Text
        plus.TextSize = 12
        plus.Font = Enum.Font.GothamBold
        plus.Parent = frame
        Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 4)

        local current = initial
        minus.MouseButton1Click:Connect(function(...)
            current = math.max(min, current - step)
            valLbl.Text = tostring(current)
            callback(current)
        end)
        plus.MouseButton1Click:Connect(function(...)
            current = math.min(max, current + step)
            valLbl.Text = tostring(current)
            callback(current)
        end)
        return function(v) current = v valLbl.Text = tostring(v) end
    end

    -- Dropdown (simplified as cycle button)
    local function addDropdown(parent, title, options, initial, order, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 32)
        frame.BackgroundColor3 = TH.Deep
        frame.LayoutOrder = order
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -110, 0, 12)
        lbl.Position = UDim2.fromOffset(10, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = title
        lbl.TextColor3 = TH.Text
        lbl.TextSize = 10
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(90, 22)
        btn.Position = UDim2.new(1, -100, 0.5, -11)
        btn.BackgroundColor3 = TH.Off
        btn.Text = initial or options[1]
        btn.TextColor3 = TH.AccentGlow
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.Parent = frame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

        local idx = 1
        for i, opt in ipairs(options) do if opt == initial then idx = i break end end
        btn.MouseButton1Click:Connect(function(...)
            idx = idx + 1
            if idx > #options then idx = 1 end
            btn.Text = options[idx]
            callback(options[idx])
        end)
    end

    -- Sidebar tabs
    local stealScroll = addTab("steal", "Auto Steal")
    local placeScroll = addTab("place", "Auto Place")
    local eggScroll = addTab("egg", "Egg Select")
    local visScroll = addTab("visual", "Visual")
    local charScroll = addTab("char", "Character")
    local autoScroll = addTab("auto", "Automation")
    local setScroll = addTab("set", "Settings")
    local statsScroll = addTab("stats", "Stats")
    local presetScroll = addTab("preset", "Presets")

    -- =========== Tab: Auto Steal ===========
    do
        local o = 0
        local function no() o = o + 1 return o end

        addSection(stealScroll, "STEAL MODES", no())
        addToggle(stealScroll, "Auto Steal (Tween)", "Smooth fly to steal", false, no(), function(v)
            if v then T4("TWEEN") else if Y4 == "TWEEN" or h.pureTweenFarm then T4("NONE") end end
        end)
        addToggle(stealScroll, "Auto Steal (Warp)", "Teleport to steal", false, no(), function(v)
            if v then T4("WARP") else if Y4 == "WARP" or h.autoFarmLoop then T4("NONE") end end
        end)
        addButton(stealScroll, "Single Steal", "Steal 1 egg and return", TH.Accent, no(), function(...)
            task.spawn(function(...)
                if Y4 ~= "NONE" then T4("NONE") task.wait(0.2) end
                local target = N4()
                if target then
                    local ok = l4(target, nil)
                    if ok then pcall(u4) if h.autoGlide then Q4(h.glideSpeed) u4() end end
                end
            end)
        end)
        addSection(stealScroll, "OPTIONS", no())
        addToggle(stealScroll, "Auto Return", "Return to safe line", false, no(), function(v) h.autoGlide = v end)
        addToggle(stealScroll, "Auto Place (Every 5)", "Home every 5 steals", false, no(), function(v)
            h.autoPlaceEvery5 = v
            if not v then h.batchStealCount = 0 end
        end)
        addToggle(stealScroll, "Secret+ Bypass", "Always steal Secret/Eternal/Divine", false, no(), function(v) h.alwaysCollectSecretPlus = v x() end)
        addSection(stealScroll, "SPEED MULTIPLIERS", no())
        addSlider(stealScroll, "Steal Speed", 1, 10, 1, h.stealSpeedMult, no(), function(v) h.stealSpeedMult = v x() end)
        addSlider(stealScroll, "Return Speed", 1, 10, 1, h.returnSpeedMult, no(), function(v) h.returnSpeedMult = v x() end)
    end

    -- =========== Tab: Auto Place ===========
    do
        local o = 0
        local function no() o = o + 1 return o end
        addSection(placeScroll, "PLACE & HATCH", no())
        addButton(placeScroll, "Place Eggs Now", "Fly home, place all eggs", TH.Accent, no(), function(...)
            task.spawn(function(...) g4(h.glideSpeed) v4() u4() h.isReturning = false h.delivering = false end)
        end)
        addToggle(placeScroll, "Auto Hatch", "Hatch ready eggs", false, no(), function(v) h.autoHatch = v end)
        addSection(placeScroll, "AUTOMATION", no())
        addToggle(placeScroll, "Auto Treadmill", "Treadmill when idle", false, no(), function(v)
            h.autoTreadmill = v x() n4()
            if not v and (h.onTreadmill or L4()) then M4() end
        end)
        addToggle(placeScroll, "Auto Upgrade Treadmill", "Upgrade treadmill", false, no(), function(v) h.autoUpgradeTreadmill = v x() end)
        addToggle(placeScroll, "Auto Buy Trails", "Buy best trail", false, no(), function(v) h.autoBuyTrails = v x() end)
        addToggle(placeScroll, "Hide Money Alerts", "Suppress popups", false, no(), function(v) h.hideNotEnoughMoney = v x() end)
    end

    -- =========== Tab: Egg Select ===========
    do
        local o = 0
        local function no() o = o + 1 return o end
        addSection(eggScroll, "TARGET ZONES", no())
        addChips(eggScroll, "Select zones", M, no(), function(item)
            return h.selectedZones and h.selectedZones[item] == true
        end, function(item)
            if not h.selectedZones then h.selectedZones = {} end
            h.selectedZones[item] = not (h.selectedZones[item] == true)
            x()
        end, 2)
        addSection(eggScroll, "TARGET RARITIES (AUTO STEAL)", no())
        addChips(eggScroll, "Only steal selected", X, no(), function(item)
            return h.selectedRarities and h.selectedRarities[item] == true
        end, function(item)
            if not h.selectedRarities then h.selectedRarities = {} end
            h.selectedRarities[item] = not (h.selectedRarities[item] == true)
            x()
        end, 3)
        addSection(eggScroll, "ZONE ROTATION", no())
        addToggle(eggScroll, "Enable Zone Rotation", "Auto-switch zones", false, no(), function(v) h.zoneRotation = v x() end)
        addSlider(eggScroll, "Rotation Count", 1, 10, 1, h.rotationCount, no(), function(v) h.rotationCount = v x() end)
    end

    -- =========== Tab: Visual ===========
    do
        local o = 0
        local function no() o = o + 1 return o end
        addSection(visScroll, "ESP & HIGHLIGHTS", no())
        addToggle(visScroll, "Egg ESP", "Highlight target eggs", false, no(), function(v) h.eggESP = v x() end)
        addToggle(visScroll, "Trap Detector", "Red outline on traps", false, no(), function(v) h.trapDetector = v x() end)
        addSection(visScroll, "NOTIFICATIONS", no())
        addToggle(visScroll, "Secret+ Notify", "Toast on Secret+ steals", true, no(), function(v) h.notifySecretPlus = v x() end)
        addToggle(visScroll, "Sound Alert", "Play sound on Secret+", false, no(), function(v) h.soundAlert = v x() end)
        addSection(visScroll, "TRAIL SPEED DISPLAY", no())
        addToggle(visScroll, "Show Flight Speed", "Display speed in status", false, no(), function(v) h.showSpeed = v end)
    end

    -- =========== Tab: Character ===========
    do
        local o = 0
        local function no() o = o + 1 return o end
        addSection(charScroll, "SAFETY", no())
        addToggle(charScroll, "Godmode", "Immunity against attacks", false, no(), function(v)
            if v then enableDesyncGodmode() else disableDesyncGodmode() end
        end)
        addToggle(charScroll, "Auto Heal", "Return home on low HP", false, no(), function(v) h.autoHeal = v x() end)
        addButton(charScroll, "Get Unstuck", "Escape treadmill", TH.Warning, no(), function(...)
            pcall(M4) pcall(C4) pcall(D4)
        end)
        addButton(charScroll, "PANIC BUTTON", "Return home + disable all", Color3.fromRGB(200, 40, 40), no(), function(...)
            task.spawn(function(...)
                T4("NONE")
                pcall(D4)
                pcall(function(...) Q4(h.glideSpeed) end)
            end)
        end)
        addSection(charScroll, "FLIGHT", no())
        addSlider(charScroll, "Base Speed", 100, 1000, 25, h.glideSpeed, no(), function(v) h.glideSpeed = v Y(v) end)
        addButton(charScroll, "Reset Character", "Clear state", TH.Accent, no(), function(...) pcall(D4) pcall(u4) end)
    end

    -- =========== Tab: Automation ===========
    do
        local o = 0
        local function no() o = o + 1 return o end
        addSection(autoScroll, "AUTO SELL", no())
        addToggle(autoScroll, "Enable Auto Sell", "Sell below rarity", false, no(), function(v) h.autoSellEnabled = v x() end)
        addDropdown(autoScroll, "Sell Below Rarity", X, h.autoSellBelow or "Common", no(), function(v) h.autoSellBelow = v x() end)
        addSection(autoScroll, "SYSTEM", no())
        addToggle(autoScroll, "Anti-Kick", "Prevent idle disconnect", false, no(), function(v)
            h.antiKick = v x()
            if v then setupAntiKick() end
        end)
        addToggle(autoScroll, "Anti-AFK", "Reset idle timer", false, no(), function(v)
            h.antiAFK = v x()
            if v then bk() else Ak() end
        end)
    end

    -- =========== Tab: Settings ===========
    do
        local o = 0
        local function no() o = o + 1 return o end
        addSection(setScroll, "PERFORMANCE", no())
        addToggle(setScroll, "Ultra Potato Mode", "Disable textures/effects", false, no(), function(v)
            h.performanceMode = v x()
            if v then Mk() else Ik() end
        end)
        addToggle(setScroll, "Disable 3D Rendering", "Freeze viewport", false, no(), function(v)
            h.disable3D = v x()
            pcall(function(...) y:Set3dRenderingEnabled(not v) end)
        end)
        addSection(setScroll, "THEME", no())
        addDropdown(setScroll, "Color Theme", {"Orange", "Red", "Blue", "Purple", "Green"}, h.themeName, no(), function(v)
            if THEMES[v] then
                TH = THEMES[v]
                h.themeName = v
                x()
                -- Apply to existing UI immediately
                pcall(function(...)
                    main.BackgroundColor3 = TH.Bg
                    header.BackgroundColor3 = TH.Header
                    headerCover.BackgroundColor3 = TH.Header
                    strip.BackgroundColor3 = TH.Accent
                    mainStroke.Color = TH.Accent
                    topGlow.BackgroundColor3 = TH.AccentBright
                    logo.BackgroundColor3 = TH.Accent
                    titleLbl.TextColor3 = TH.AccentGlow
                    sidebar.BackgroundColor3 = TH.Sidebar
                    content.BackgroundColor3 = TH.Card
                    statusBar.BackgroundColor3 = TH.Deep
                end)
            end
        end)
        addSlider(setScroll, "Opacity", 0, 90, 5, h.opacity, no(), function(v)
            h.opacity = v x()
            pcall(function(...)
                local alpha = math.clamp(v / 100, 0, 0.9)
                main.BackgroundTransparency = alpha
                sidebar.BackgroundTransparency = math.min(1, alpha + 0.05)
                content.BackgroundTransparency = math.min(1, alpha + 0.05)
            end)
        end)
        addSection(setScroll, "SYSTEM", no())
        addButton(setScroll, "Rejoin Server", "Reconnect same", TH.Accent, no(), function(...)
            pcall(function(...) TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, o) end)
        end)
        addButton(setScroll, "Unload Script", "Close everything", Color3.fromRGB(200, 40, 40), no(), function(...) aM() end)
    end

    -- =========== Tab: Stats ===========
    do
        local statsLbl = Instance.new("TextLabel")
        statsLbl.Size = UDim2.new(1, -8, 1, -8)
        statsLbl.Position = UDim2.fromOffset(4, 4)
        statsLbl.BackgroundTransparency = 1
        statsLbl.Font = Enum.Font.Code
        statsLbl.TextSize = 11
        statsLbl.TextColor3 = TH.Text
        statsLbl.TextXAlignment = Enum.TextXAlignment.Left
        statsLbl.TextYAlignment = Enum.TextYAlignment.Top
        statsLbl.TextWrapped = true
        statsLbl.Parent = statsScroll
        task.spawn(function(...)
            while h.alive do
                pcall(function(...)
                    local lines = {}
                    local elapsed = os.clock() - (h.sessionStart or os.clock())
                    lines[#lines + 1] = "=== SESSION STATS ==="
                    lines[#lines + 1] = ""
                    lines[#lines + 1] = string.format("Eggs stolen:  %d", h.sessionEggs or 0)
                    lines[#lines + 1] = string.format("Time played:  %s", formatTime(elapsed))
                    local rate = elapsed > 0 and (h.sessionEggs or 0) / elapsed * 60 or 0
                    lines[#lines + 1] = string.format("Rate:         %.1f eggs/min", rate)
                    lines[#lines + 1] = ""
                    lines[#lines + 1] = "=== BY RARITY ==="
                    if h.rarityBreakdown then
                        for _, r in ipairs(X) do
                            local c = h.rarityBreakdown[r] or 0
                            if c > 0 then
                                lines[#lines + 1] = string.format("%-12s  %d", r, c)
                            end
                        end
                    end
                    lines[#lines + 1] = ""
                    lines[#lines + 1] = "=== BEST STEALS ==="
                    if h.bestSteals then
                        for i = 1, math.min(10, #h.bestSteals) do
                            local s = h.bestSteals[i]
                            lines[#lines + 1] = string.format("#%d  %s  %s", i, s.rarity, s.name)
                        end
                    end
                    statsLbl.Text = table.concat(lines, "\n")
                end)
                task.wait(1)
            end
        end)
    end

    -- =========== Tab: Presets ===========
    do
        local o = 0
        local function no() o = o + 1 return o end
        addSection(presetScroll, "QUICK PRESETS", no())
        addButton(presetScroll, "Save as: Farmer", "Save current config", TH.Accent, no(), function(...)
            savePreset("Farmer")
        end)
        addButton(presetScroll, "Load: Farmer", "Apply Farmer preset", TH.AccentBright, no(), function(...)
            loadPreset("Farmer")
        end)
        addButton(presetScroll, "Save as: Speedrun", "Save current config", TH.Accent, no(), function(...)
            savePreset("Speedrun")
        end)
        addButton(presetScroll, "Load: Speedrun", "Apply Speedrun preset", TH.AccentBright, no(), function(...)
            loadPreset("Speedrun")
        end)
        addButton(presetScroll, "Save as: Secret Hunter", "Save current config", TH.Accent, no(), function(...)
            savePreset("SecretHunter")
        end)
        addButton(presetScroll, "Load: Secret Hunter", "Apply Secret Hunter preset", TH.AccentBright, no(), function(...)
            loadPreset("SecretHunter")
        end)
    end

    -- Minimize / Close / Drag
    local collapsed = false
    minBtn.MouseButton1Click:Connect(function(...)
        collapsed = not collapsed
        body.Visible = not collapsed
        statusBar.Visible = not collapsed
        main.Size = UDim2.fromOffset(WINDOW_W, collapsed and HEADER_H or WINDOW_H)
        minBtn.Text = collapsed and "+" or "−"
    end)

    closeBtn.MouseButton1Click:Connect(function(...) aM() end)

    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    w.InputChanged:Connect(function(input)
        if not dragging then return end
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    w.InputEnded:Connect(function(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then dragging = false end
    end)

    w.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)

    -- Status loop
    task.spawn(function(...)
        while h.alive do
            pcall(function(...)
                local mode = "Idle"
                if h.pureTweenFarm then mode = "Tween"
                elseif h.autoFarmLoop then mode = "Warp"
                elseif h.autoTreadmill then mode = "Treadmill"
                elseif h.securingEgg then mode = "Securing"
                elseif h.glidingToTarget then mode = "Gliding"
                elseif h.isReturning then mode = "Returning"
                end
                local eggs = y4()
                statusLbl.Text = string.format("[%s] Eggs: %d | Session: %d", mode, eggs, h.sessionEggs or 0)
                if mode == "Idle" then
                    statusDot.BackgroundColor3 = TH.Muted
                else
                    statusDot.BackgroundColor3 = TH.AccentBright
                end
            end)
            task.wait(0.4)
        end
    end)

    showTab("steal")
end

-- ==============================================================================
-- UNLOAD
-- ==============================================================================
local function aM(...)
    h.alive = false
    pcall(Ik)
    pcall(Ak)
    pcall(cleanupESP)
    pcall(cleanupTrap)
    pcall(saveStats)
    pcall(function(...) y:Set3dRenderingEnabled(true) end)
    pcall(D4)
    pcall(u4)
    if h.gui then pcall(function(...) h.gui:Destroy() end) end
end

-- ==============================================================================
-- BOOT
-- ==============================================================================
H("[+] Antrax Hub — Ultimate Edition")
H("[+] Credits: " .. CREDITS_NAME .. " | " .. CREDITS_TG)

buildUI()

task.spawn(function(...)
    task.wait(0.5)
    A4()
    C4()
    if o.Character then z4(o.Character) end
    u4()
end)

o.CharacterAdded:Connect(function(char, ...)
    task.wait(0.6)
    if h.alive then
        D4()
        n4()
        C4()
        A4()
        if h.godmode then b4(true) end
        z4(char)
        u4()
    end
end)

H("═══════════════════════════════════════════════════")
H("    Antrax Hub — ULTIMATE EDITION")
H("    Credits: " .. CREDITS_NAME)
H("    Telegram: " .. CREDITS_TG)
H("═══════════════════════════════════════════════════")
print("[Antrax Hub • Antrax] Loaded successfully!")
print("Credits: " .. CREDITS_NAME .. " | " .. CREDITS_TG)