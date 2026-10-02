
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer

-- Aliases
local e = Players
local r = Workspace
local y = RunService
local u = TweenService
local w = UIS
local j = game:GetService("ReplicatedStorage")
local k = game:GetService("ProximityPromptService")
local a = HttpService
local o = LP

-- ==============================================================================
-- CREDITS
-- ==============================================================================
local CREDITS_NAME = "Antrax"
local CREDITS_TG = "@AntraxdevZ"
local CREDITS_FULL = "by " .. CREDITS_NAME .. " | " .. CREDITS_TG

-- ==============================================================================
-- ORANGE & BLACK THEME
-- ==============================================================================
local TH = {
    -- Backgrounds
    Bg          = Color3.fromRGB(8, 8, 10),
    BgDark      = Color3.fromRGB(5, 5, 7),
    Card        = Color3.fromRGB(16, 16, 20),
    CardHover   = Color3.fromRGB(24, 24, 30),
    CardActive  = Color3.fromRGB(30, 26, 20),
    Deep        = Color3.fromRGB(11, 11, 14),
    Header      = Color3.fromRGB(13, 13, 16),
    HeaderAccent= Color3.fromRGB(20, 18, 15),
    -- Text
    Text        = Color3.fromRGB(242, 242, 246),
    Sub         = Color3.fromRGB(155, 155, 168),
    Muted       = Color3.fromRGB(105, 105, 118),
    -- Orange Accents
    Orange      = Color3.fromRGB(255, 130, 20),
    OrangeBright= Color3.fromRGB(255, 155, 55),
    OrangeGlow  = Color3.fromRGB(255, 180, 95),
    OrangeDark  = Color3.fromRGB(160, 70, 10),
    OrangeDeep  = Color3.fromRGB(75, 35, 5),
    OrangeFaint = Color3.fromRGB(35, 20, 8),
    -- States
    Success     = Color3.fromRGB(255, 130, 20),
    SuccessDark = Color3.fromRGB(90, 45, 10),
    Danger      = Color3.fromRGB(200, 40, 40),
    DangerDim   = Color3.fromRGB(75, 20, 20),
    Warning     = Color3.fromRGB(240, 170, 40),
    Gold        = Color3.fromRGB(255, 200, 100),
    Off         = Color3.fromRGB(32, 32, 38),
    OffLight    = Color3.fromRGB(45, 45, 52),
    -- Borders
    Border      = Color3.fromRGB(55, 35, 15),
    BorderBright= Color3.fromRGB(255, 130, 20),
}

local Window = nil
local currentLang = "EN"
local executorCheckCaller = typeof(checkcaller) == "function" and checkcaller or function() return false end
local safeNewCClosure = typeof(newcclosure) == "function" and newcclosure or function(fn) return fn end

-- Auto ProximityPrompt
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

-- ==============================================================================
-- REQUIRE MODULES
-- ==============================================================================
local s = nil
pcall(function(...) s = require((j:WaitForChild("Client", 5)):WaitForChild("EggState", 5)) end)
if not s then pcall(function(...) s = require(j.Client.EggState) end) end

local p = nil
pcall(function(...) p = require(((j:WaitForChild("Shared", 5)):WaitForChild("Util", 5)):WaitForChild("AssetItems", 5)) end)
if not p then pcall(function(...) p = require(j.Shared.Util.AssetItems) end) end

local B = nil
pcall(function(...) B = require((j:WaitForChild("Shared", 5)):WaitForChild("Remotes", 5)) end)
if not B then pcall(function(...) B = require(j.Shared.Remotes) end) end

-- ==============================================================================
-- REMOTE FINDER
-- ==============================================================================
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

H(string.format("[RemoteCheck] Carry: %s | Snapshot: %s | Place: %s | Hatch: %s | FinishHatch: %s | Strike: %s | Toll: %s | Doff: %s",
    tostring(i ~= nil), tostring(R ~= nil), tostring(K ~= nil), tostring(g ~= nil),
    tostring(Q ~= nil), tostring(P ~= nil), tostring(N ~= nil), tostring(U ~= nil)))

-- ==============================================================================
-- CONFIG DATA
-- ==============================================================================
local f = {
    ["Light Dark"] = 1300, ["LightDark"] = 1300,
    ["Titan Temple"] = 1100, ["Cherry Blossom"] = 1000, ["Cosmic"] = 900,
    ["Prehistoric"] = 800, ["Abyss Ocean"] = 700, ["Volcano"] = 600,
    ["Snow"] = 500, ["Jungle"] = 400, ["Desert"] = 300,
    ["Lake"] = 200, ["Forest"] = 100
}
local M = {"Light Dark", "Titan Temple", "Cherry Blossom", "Cosmic", "Prehistoric",
    "Abyss Ocean", "Volcano", "Snow", "Jungle", "Desert", "Lake", "Forest"}

local I = {
    ["Light Dark"] = 420, ["LightDark"] = 420, ["Titan Temple"] = 380,
    ["Cherry Blossom"] = 330, ["Cosmic"] = 280, ["Prehistoric"] = 240,
    ["Abyss Ocean"] = 200, ["Volcano"] = 180, ["Snow"] = 160,
    ["Jungle"] = 140, ["Desert"] = 130, ["Lake"] = 125, ["Forest"] = 125
}

local L = -360
local E = 525
local b = 620
local A = 130
local S = CFrame.new(4773.7587890625, 70.392112731934, -315.73501586914)

local Z = "AntraxHub_FlightSpeed.txt"
local z = "AntraxHub_EggSelectConfig.json"

local d = {
    ["Light Dark"] = Color3.fromRGB(168, 85, 247), ["Titan Temple"] = Color3.fromRGB(245, 158, 11),
    ["Cherry Blossom"] = Color3.fromRGB(236, 72, 153), ["Cosmic"] = Color3.fromRGB(6, 182, 212),
    ["Prehistoric"] = Color3.fromRGB(16, 185, 129), ["Abyss Ocean"] = Color3.fromRGB(59, 130, 246),
    ["Volcano"] = Color3.fromRGB(239, 68, 68), ["Snow"] = Color3.fromRGB(147, 197, 253),
    ["Jungle"] = Color3.fromRGB(34, 197, 94), ["Desert"] = Color3.fromRGB(234, 179, 8),
    ["Lake"] = Color3.fromRGB(20, 184, 166), ["Forest"] = Color3.fromRGB(22, 163, 74)
}

local X = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare", "Uncommon", "Common"}
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

-- ==============================================================================
-- FILE HELPERS
-- ==============================================================================
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
    local defaultZones = {["Light Dark"] = false, ["Titan Temple"] = false, ["Cherry Blossom"] = false,
        ["Cosmic"] = false, ["Prehistoric"] = false, ["Abyss Ocean"] = false,
        ["Volcano"] = false, ["Snow"] = false, ["Jungle"] = false,
        ["Desert"] = false, ["Lake"] = false, ["Forest"] = false}
    local defaultRarities = {["Divine"] = false, ["Eternal"] = false, ["Secret"] = false,
        ["Cosmic"] = false, ["Mythic"] = false, ["Legendary"] = false,
        ["Epic"] = false, ["Rare"] = false, ["Uncommon"] = false, ["Common"] = false}
    if type(data) ~= "table" then
        data = {
            ["selectedZones"] = defaultZones,
            ["selectedRarities"] = defaultRarities,
            ["alwaysCollectSecretPlus"] = false,
            ["minRarityTier"] = 2,
            ["autoTreadmill"] = false,
            ["autoUpgradeTreadmill"] = false,
            ["autoBuyTrails"] = false,
            ["hideNotEnoughMoney"] = false,
            ["performanceMode"] = false,
            ["disable3D"] = false,
            ["antiAFK"] = false,
            ["language"] = "EN"
        }
    else
        if type(data.selectedZones) ~= "table" then data.selectedZones = defaultZones end
        if type(data.selectedRarities) ~= "table" then data.selectedRarities = defaultRarities
        else
            for _, r in ipairs(X) do
                if data.selectedRarities[r] == nil then
                    data.selectedRarities[r] = (defaultRarities[r] == true)
                end
            end
        end
        -- Force all feature toggles OFF on load (per user request)
        data.alwaysCollectSecretPlus = false
        data.autoTreadmill = false
        data.autoUpgradeTreadmill = false
        data.autoBuyTrails = false
        data.hideNotEnoughMoney = false
        data.performanceMode = false
        data.disable3D = false
        data.antiAFK = false
        -- Preserve language and selections
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
                ["selectedZones"] = h.selectedZones or {},
                ["selectedRarities"] = h.selectedRarities or {},
                ["alwaysCollectSecretPlus"] = (h.alwaysCollectSecretPlus == true),
                ["minRarityTier"] = h.minRarityTier or 2,
                ["autoTreadmill"] = (h.autoTreadmill == true),
                ["autoUpgradeTreadmill"] = (h.autoUpgradeTreadmill == true),
                ["autoBuyTrails"] = (h.autoBuyTrails == true),
                ["hideNotEnoughMoney"] = (h.hideNotEnoughMoney == true),
                ["performanceMode"] = (h.performanceMode == true),
                ["disable3D"] = (h.disable3D == true),
                ["antiAFK"] = (h.antiAFK == true),
                ["language"] = currentLang or "EN"
            }
            writefile(z, a:JSONEncode(payload))
        end
    end)
end

-- ==============================================================================
-- GLOBAL STATE (all OFF by default)
-- ==============================================================================
local W = T()
h = {
    godmode = false,          -- OFF by default
    autoGlide = false,        -- OFF by default
    autoHatch = false,        -- OFF by default
    autoPlaceEvery5 = false,
    batchStealCount = 0,
    isBatchPlacing = false,
    isHatching = false,
    autoFarmLoop = false,     -- OFF by default
    pureTweenFarm = false,    -- OFF by default
    glidingToTarget = false,
    securingEgg = false,
    glideSpeed = O(),
    selectedZones = W.selectedZones,
    selectedRarities = W.selectedRarities,
    alwaysCollectSecretPlus = false,
    minRarityTier = W.minRarityTier,
    autoTreadmill = false,
    autoUpgradeTreadmill = false,
    autoBuyTrails = false,
    hideNotEnoughMoney = false,
    performanceMode = false,
    disable3D = false,
    antiAFK = false,
    onTreadmill = false,
    lastTreadmillMount = 0,
    laneZ = -360,
    swapped = false,
    teleporting = false,
    isReturning = false,
    delivering = false,
    holdingEggForGuard = false,
    currentTargetModel = nil,
    targetPosition = nil,
    stateTime = os.clock(),
    statusText = "Idle",
    bestEggInfo = "Scanning...",
    gui = nil,
    alive = true,
    plot = nil, pen = nil, origin = nil, tread = nil
}

-- Forward declarations
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

-- ==============================================================================
-- DAY/NIGHT RESET
-- ==============================================================================
pcall(function(...)
    local Light = game:GetService("Lighting")
    Light:GetPropertyChangedSignal("ClockTime"):Connect(function(...)
        X4 = {}
        G4 = 0
    end)
end)

pcall(function(...)
    local function checkRemote(obj)
        if obj:IsA("RemoteEvent") then
            local lower = string.lower(obj.Name)
            if string.find(lower, "reset") or string.find(lower, "night") or string.find(lower, "spawn") or string.find(lower, "countdown") then
                pcall(function(...)
                    obj.OnClientEvent:Connect(function(...)
                        X4 = {}
                        G4 = 0
                    end)
                end)
            end
        end
    end
    for _, obj in ipairs(j:GetDescendants()) do checkRemote(obj) end
    j.DescendantAdded:Connect(checkRemote)
end)

-- ==============================================================================
-- EGG HELPERS
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
        for _, item in ipairs(bp:GetChildren()) do
            if m(item) then count = count + 1 end
        end
    end
    local char = o.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if m(item) then count = count + 1 end
        end
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
            if child:IsA("Tool") then
                pcall(function(...) child.Parent = bp end)
            end
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
        else
            return true
        end
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
                    else
                        return true
                    end
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
                if not uid or childUid == uid or child.Name == tostring(uid) then
                    return true
                end
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
            if #records > 0 then
                F4 = records
                G4 = os.clock()
            end
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
            if rec.Uid then
                seen[rec.Uid] = true
                table.insert(result, rec)
            end
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
                            Uid = name,
                            AssetCategory = category,
                            AreaId = areaId,
                            Rarity = rarity,
                            Rank = rank,
                            Income = income,
                            BoundsCFrame = pivot,
                            BottomCFrame = pivot,
                            CFrame = pivot,
                            State = "Slot",
                            AssetScale = scale,
                            Mutations = muts,
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
    if not uid then
        local _, bUid = r4()
        uid = bUid
    end
    if not uid then return false end
    if s and s.ReadFieldEggs then
        local ok, data = pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _, rec in ipairs(data.Records) do
                if rec.Uid == uid then
                    local area = tostring(rec.AreaId or "")
                    if area == "Lake" or string.find(string.lower(area), "lake") ~= nil then
                        return true
                    end
                end
            end
        end
    end
    if string.find(string.lower(tostring(uid)), "lake") ~= nil then return true end
    return false
end

o4 = function(...)
    local _, uid = e4()
    if not uid then
        local _, bUid = r4()
        uid = bUid
    end
    if not uid then return h.glideSpeed or 350 end
    if s and s.ReadFieldEggs then
        local ok, data = pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _, rec in ipairs(data.Records) do
                if rec.Uid == uid and rec.AreaId then
                    return I[rec.AreaId] or h.glideSpeed or 350
                end
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
    task.delay(duration, function(...)
        pcall(function(...) pad:Destroy() end)
    end)
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

-- Anti-ragdoll hook
if typeof(hookmetamethod) == "function" and not _G._DesyncAntiRagdollHooked then
    _G._DesyncAntiRagdollHooked = true
    local oldIndex
    oldIndex = hookmetamethod(game, "__newindex", safeNewCClosure(function(self, prop, val, ...)
        if not executorCheckCaller() and typeof(self) == "Instance" then
            if self:IsA("Motor6D") and prop == "Enabled" and val == false then return nil end
            if self:IsA("Humanoid") then
                if prop == "PlatformStand" and val == true then return nil end
                if prop == "Sit" and val == true and (h.pureTweenFarm or h.autoFarmLoop or h.isReturning or h.glidingToTarget) then
                    return nil
                end
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
        task.spawn(function(...)
            pcall(function(...) U:InvokeServer() end)
        end)
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
                                for _, conn in ipairs(conns) do
                                    pcall(function(...) conn:Fire() end)
                                    break
                                end
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
                        tread.CanTouch = true
                        tread.CanCollide = true
                    else
                        tread.CanTouch = false
                        tread.CanCollide = false
                    end
                end
                local upg = plot:FindFirstChild("TreadmillUpgrade")
                if upg then
                    for _, obj in ipairs(upg:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            if isMine and h and h.autoTreadmill then
                                obj.CanTouch = true
                            else
                                obj.CanTouch = false
                                obj.CanCollide = false
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
                    child.CanTouch = true
                    child.CanCollide = true
                else
                    for _, obj in ipairs(child:GetDescendants()) do
                        if obj:IsA("BasePart") then obj.CanTouch = true end
                    end
                end
            else
                if isTread then
                    child.CanTouch = false
                    child.CanCollide = false
                else
                    for _, obj in ipairs(child:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            obj.CanTouch = false
                            obj.CanCollide = false
                        end
                    end
                end
            end
        end
    end)
end)

D4 = function(...)
    h.onTreadmill = false
    h.teleporting = false
    h.glidingToTarget = false
    h.securingEgg = false
    h.isReturning = false
    h.delivering = false
    h.holdingEggForGuard = false
    h.currentTargetModel = nil
    h.targetPosition = nil
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
                    obj.RequiresLineOfSight = false
                    obj.HoldDuration = 0
                    if typeof(fireproximityprompt) == "function" then
                        fireproximityprompt(obj, 0)
                        fireproximityprompt(obj)
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
                            obj.RequiresLineOfSight = false
                            obj.HoldDuration = 0
                            if typeof(fireproximityprompt) == "function" then
                                fireproximityprompt(obj, 0)
                                fireproximityprompt(obj)
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
            if on then
                obj.CanTouch = false
                obj.CanCollide = false
            end
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
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = clone
        end
        r.CurrentCamera.CameraSubject = clone
        local animate = char:FindFirstChild("Animate")
        if animate and animate:IsA("LocalScript") then
            animate.Disabled = true
            task.defer(function(...)
                task.wait(0.05)
                animate.Disabled = false
            end)
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
                    if plot then
                        verified = true
                        break
                    end
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
                    if plot then
                        verified = true
                        break
                    end
                end
            end
        end
    end
    if not plot then
        for _, child in ipairs(plots:GetChildren()) do
            local attr = child:GetAttribute("Owner") or child:GetAttribute("OwnerUserId") or child:GetAttribute("UserId") or child:GetAttribute("OwnerId") or child:GetAttribute("Player")
            if attr and (attr == uid or tostring(attr) == tostring(uid) or attr == name or tostring(attr) == name or attr == dName) then
                plot = child
                verified = true
                break
            end
        end
    end
    if not plot then
        for _, child in ipairs(plots:GetChildren()) do
            for _, desc in ipairs(child:GetDescendants()) do
                if desc:IsA("TextLabel") and desc.Text ~= "" then
                    local lower = string.lower(desc.Text)
                    if string.find(lower, string.lower(name), 1, true) or (dName and string.find(lower, string.lower(dName), 1, true)) then
                        plot = child
                        verified = true
                        break
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
                    if dist < minDist then
                        minDist = dist
                        closest = child
                    end
                end
            end
            if closest and minDist < 160 then plot = closest end
        end
    end
    if not plot then
        plot = plots:FindFirstChild("2") or plots:FindFirstChild("1") or (plots:GetChildren())[1]
    end
    if not plot then return nil, nil, nil end
    h.plot = plot
    h.plotVerified = verified
    h.origin = plot:FindFirstChild("CenterPoint")
    local toUpdate = plot:FindFirstChild("ToUpdate")
    h.pen = (toUpdate and toUpdate:FindFirstChild("PetArea")) or plot:FindFirstChild("PetArea")
    h.tread = plot:FindFirstChild("TreadmillBottom")
    if not h.pen and toUpdate then
        for _, child in ipairs(toUpdate:GetChildren()) do
            if child:IsA("BasePart") and string.find(string.lower(child.Name), "pet") then
                h.pen = child
                break
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
            if ((pos - cf.Position)).Magnitude < 5.5 then
                ok = false
                break
            end
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
                H(string.format("[PlaceEgg] Placed egg %s from inventory", tostring(uid)))
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
    if not ok or type(data) ~= "table" then
        h.isHatching = false
        return 0
    end
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
            if isReady then
                table.insert(ready, {uid = uid, category = rec.AssetCategory or "Egg"})
            end
        end
    end
    if #ready == 0 then
        h.isHatching = false
        return 0
    end
    H(string.format("[AutoHatch] Found %d eggs ready to hatch! Starting hatch sequence...", #ready))
    h.statusText = string.format("[Hatch] Hatching %d ready eggs...", #ready)
    local hatched = 0
    for _, egg in ipairs(ready) do
        task.spawn(function(...)
            local ok1, res1 = pcall(function(...)
                if g:IsA("RemoteFunction") then return g:InvokeServer(egg.uid)
                else
                    g:FireServer(egg.uid)
                    return true
                end
            end)
            if ok1 and res1 ~= false then
                task.wait(0.9)
                local ok2, res2 = pcall(function(...)
                    if Q:IsA("RemoteFunction") then return Q:InvokeServer(egg.uid)
                    else
                        Q:FireServer(egg.uid)
                        return true
                    end
                end)
                if ok2 and res2 ~= false then
                    hatched = hatched + 1
                    h.hatched = ((h.hatched or 0)) + 1
                    H(string.format("[+] [AutoHatch] Hatched %s (UID: %s) -> Total Hatched: %d", egg.category, tostring(egg.uid), h.hatched))
                end
            end
        end)
        task.wait(0.04)
    end
    task.wait(0.95)
    h.isHatching = false
    H(string.format("[AutoHatch] Finished! Hatched %d eggs.", hatched))
    return hatched
end

i4 = function(...)
    local hitboxes = {}
    local debris = r:FindFirstChild("__DEBRIS")
    if debris then
        for _, child in ipairs(debris:GetChildren()) do
            local hitbox = child:FindFirstChild("Hitbox")
            if hitbox and hitbox:IsA("BasePart") then
                table.insert(hitboxes, hitbox)
            elseif child:IsA("BasePart") and string.find(child.Name:lower(), "hitbox") then
                table.insert(hitboxes, child)
            end
        end
    end
    local boss = r:FindFirstChild("BossArenaTeleport")
    if boss then
        local hitbox = boss:FindFirstChild("Hitbox") or boss:FindFirstChildWhichIsA("BasePart") or (boss:IsA("BasePart") and boss)
        if hitbox and hitbox:IsA("BasePart") then table.insert(hitboxes, hitbox) end
    end
    return hitboxes
end

g4 = function(speed, sess, force, ...)
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp then return false end
    if humanoid then humanoid.AutoRotate = false end
    local target = s4()
    speed = math.max(100, speed or h.glideSpeed or 600)
    local laneZ = h.laneZ or L
    h.isReturning = true
    h.stateTime = os.clock()
    V4(target, 20)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    local areaSpeed = o4()
    local maxSpeed = math.max(speed, areaSpeed)
    local deadline = os.clock() + 25
    while h.alive and h.isReturning and os.clock() < deadline do
        if sess and O4 ~= sess then
            if humanoid then humanoid.AutoRotate = true end
            h.isReturning = false
            return false
        end
        if not force and not h.pureTweenFarm and not h.autoFarmLoop then
            if humanoid then humanoid.AutoRotate = true end
            h.isReturning = false
            return false
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
        elseif pos.X <= E then
            currentSpeed = A
        end
        local targetZ = target.Z
        if pos.X > 540 then targetZ = laneZ end
        local dx = math.sign(target.X - pos.X)
        local newX = pos.X + dx * math.min(math.abs(target.X - pos.X), currentSpeed * dt)
        local dy = math.sign(target.Y - pos.Y)
        local newY = pos.Y + dy * math.min(math.abs(target.Y - pos.Y), (currentSpeed * dt) * 0.5)
        local dz = targetZ - pos.Z
        local newZ = pos.Z + math.sign(dz) * math.min(math.abs(dz), currentSpeed * dt)
        local obstacles = i4()
        local dodging = false
        if pos.X > E then
            for _, ob in ipairs(obstacles) do
                local op = ob.Position
                local dist2 = ((Vector3.new(newX, newY, newZ) - op)).Magnitude
                if dist2 < 22 or (math.abs(newX - op.X) < 18 and math.abs(newZ - op.Z) < 14) then
                    dodging = true
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
    h.isReturning = false
    h.delivering = false
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
    if distToBase > 8 then
        h.statusText = "[Place] Tweening back to base plot..."
        g4(speed or h.glideSpeed or 600, sess, true)
    end
    V4(basePos, 15)
    hrp.CFrame = CFrame.new(basePos)
    hrp.AssemblyLinearVelocity = Vector3.zero
    h.statusText = "[Place] Placing All Eggs to Stand..."
    local deadline = os.clock() + 3
    while y4() > 0 and os.clock() < deadline and h.alive do
        B4()
        task.wait(0.06)
    end
    h.statusText = "[Place] Hatching ready eggs..."
    J4(true)
    u4()
    h.isReturning = false
    h.delivering = false
    h.currentTargetModel = nil
    h.targetPosition = nil
    local remaining = y4()
    h.statusText = string.format("Placed & Hatched (Left: %d)", remaining)
end

local uk = 5

K4 = function(mode, ...)
    if h.isBatchPlacing then return end
    h.isBatchPlacing = true
    H(string.format("[AutoPlace] %d steals done! Batch placing (%s mode)...", uk, tostring(mode)))
    local sess = O4
    h.pureTweenFarm = (mode == "TWEEN")
    h.autoFarmLoop = (mode == "WARP")
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local basePos = s4()
    local distToBase = hrp and ((hrp.Position - basePos)).Magnitude or 999
    if distToBase > 8 then
        h.statusText = "[AutoPlace] Tweening home to base plot..."
        g4(h.glideSpeed or 600, sess, true)
    end
    if hrp then
        V4(basePos, 20)
        hrp.CFrame = CFrame.new(basePos)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if humanoid then humanoid.AutoRotate = true end
    end
    task.spawn(function(...)
        pcall(B4)
        pcall(J4, true)
    end)
    u4()
    h.isReturning = false
    h.delivering = false
    h.glidingToTarget = false
    h.securingEgg = false
    h.teleporting = false
    h.currentTargetModel = nil
    h.targetPosition = nil
    for i = 5, 1, -1 do
        if not h.alive then break end
        h.statusText = string.format("[AutoPlace] At Base: Resuming in %ds...", i)
        task.wait(1)
    end
    h.isBatchPlacing = false
    if h.alive and O4 == sess then
        H(string.format("[AutoPlace] Done! Continuing %s farm.", mode))
        h.statusText = string.format("[AutoPlace] Resuming %s farm...", mode)
        if mode == "TWEEN" then
            h.pureTweenFarm = true
            h.autoFarmLoop = false
        elseif mode == "WARP" then
            h.autoFarmLoop = true
            h.pureTweenFarm = false
        end
        Y4 = mode
    end
end

c4 = function(mode, ...)
    if not h.autoPlaceEvery5 then return false end
    h.batchStealCount = ((h.batchStealCount or 0)) + 1
    H(string.format("[AutoPlace] Steal trip %d / %d completed successfully.", h.batchStealCount, uk))
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
    speed = math.max(60, speed or h.glideSpeed or 350)
    local targetPos = targetCFrame.Position
    V4(targetPos, 14)
    pcall(function(...) o:RequestStreamAroundAsync(targetPos) end)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    local laneZ = h.laneZ or L
    h.glidingToTarget = true
    h.stateTime = os.clock()
    local lastCheck = 0
    local deadline = os.clock() + 15
    while h.alive and h.glidingToTarget and os.clock() < deadline do
        if sess and O4 ~= sess then
            if humanoid then humanoid.AutoRotate = true end
            h.glidingToTarget = false
            return false
        end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.teleporting then
            if humanoid then humanoid.AutoRotate = true end
            h.glidingToTarget = false
            return false
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
                h.glidingToTarget = false
                return false
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
        local dodging = false
        if dist2 > 25 then
            local obstacles = i4()
            for _, ob in ipairs(obstacles) do
                local op = ob.Position
                local d = ((Vector3.new(newX, newY, newZ) - op)).Magnitude
                if d < 22 or (math.abs(newX - op.X) < 18 and math.abs(newZ - op.Z) < 14) then
                    dodging = true
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
                h.statusText = "[AutoSteal] Exiting Base -> Waypoint..."
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
    speed = math.max(100, speed or h.glideSpeed or 350)
    h.isReturning = true
    h.stateTime = os.clock()
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
            h.isReturning = false
            return false
        end
        if not h.pureTweenFarm and not h.autoFarmLoop then
            if humanoid then humanoid.AutoRotate = true end
            h.isReturning = false
            return false
        end
        local pos = hrp.Position
        local dist = ((target - pos)).Magnitude
        if pos.X <= (E + 10) or dist <= 6 then
            u4()
            break
        end
        if char then
            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("Tool") then
                    pcall(u4)
                    break
                end
            end
        end
        local dt = y.Heartbeat:Wait()
        pos = hrp.Position
        local currentSpeed = maxSpeed
        if pos.X <= b and pos.X > E then
            local t = math.clamp(((pos.X - E)) / ((b - E)), 0, 1)
            currentSpeed = A + (((maxSpeed - A)) * t)
        elseif pos.X <= E then
            currentSpeed = A
        end
        local dx = math.sign(target.X - pos.X)
        local newX = pos.X + dx * math.min(math.abs(target.X - pos.X), currentSpeed * dt)
        local dy = math.sign(target.Y - pos.Y)
        local newY = pos.Y + dy * math.min(math.abs(target.Y - pos.Y), (currentSpeed * dt) * 0.5)
        local dz = laneZ - pos.Z
        local newZ = pos.Z + math.sign(dz) * math.min(math.abs(dz), currentSpeed * dt)
        local obstacles = i4()
        local dodging = false
        for _, ob in ipairs(obstacles) do
            local op = ob.Position
            local d = ((Vector3.new(newX, newY, newZ) - op)).Magnitude
            if d < 22 or (math.abs(newX - op.X) < 18 and math.abs(newZ - op.Z) < 14) then
                dodging = true
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
    h.isReturning = false
    h.delivering = false
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
        local bestPart = nil
        local minY = 999999
        for _, part in ipairs(upg:GetDescendants()) do
            if part:IsA("BasePart") and part.Size.X >= 1.2 and part.Size.Z >= 1.2 then
                if part.Position.Y < minY then
                    minY = part.Position.Y
                    bestPart = part
                end
            end
        end
        if bestPart then return bestPart end
        if upg.PrimaryPart then return upg.PrimaryPart end
        local anyPart = upg:FindFirstChildWhichIsA("BasePart", true)
        if anyPart then return anyPart end
    end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and string.find(string.lower(part.Name), "treadmill") then
            return part
        end
    end
    return nil
end

I4 = function(...)
    local mine = t4()
    if h.tread and h.tread.Parent then return h.tread end
    local tread = nil
    if mine then tread = jk(mine) end
    if not tread then
        local plots = r:FindFirstChild("Plots")
        if plots then
            local nameLower = string.lower(o.Name)
            local dNameLower = o.DisplayName and string.lower(o.DisplayName)
            for _, plot in ipairs(plots:GetChildren()) do
                local t = jk(plot)
                if t then
                    local isMine = false
                    for _, desc in ipairs(plot:GetDescendants()) do
                        if desc:IsA("TextLabel") and desc.Text ~= "" then
                            local lower = string.lower(desc.Text)
                            if string.find(lower, nameLower, 1, true) or (dNameLower and string.find(lower, dNameLower, 1, true)) then
                                isMine = true
                                break
                            end
                        end
                    end
                    if isMine then
                        h.plot = plot
                        h.plotVerified = true
                        tread = t
                        break
                    end
                end
            end
            if not tread and mine then tread = jk(mine) end
        end
    end
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
    if not tread then
        t("[AutoTreadmill] Treadmill part not found!")
        return false
    end
    pcall(function(...)
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end)
    pcall(function(...)
        tread.CanTouch = true
        tread.CanCollide = true
        local upg = mine and mine:FindFirstChild("TreadmillUpgrade", true)
        if upg then
            for _, part in ipairs(upg:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanTouch = true
                    part.CanCollide = true
                end
            end
        end
        if tread.Parent and tread.Parent:IsA("Model") then
            for _, part in ipairs(tread.Parent:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanTouch = true
                    part.CanCollide = true
                end
            end
        end
    end)
    local padPos = tread.Position + Vector3.new(0, 1.8, 0)
    if hrp.Position.X > 535 then
        h.statusText = "[AutoTreadmill] Returning to base..."
        Q4(h.glideSpeed, sess)
        if sess and O4 ~= sess then return false end
        if hrp.Position.X > 535 then
            if hrp.Position.X <= 560 then
                hrp.CFrame = CFrame.new(E, 70, h.laneZ or L)
            else
                return false
            end
        end
    end
    if sess and O4 ~= sess then return false end
    local dist2 = ((Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(padPos.X, padPos.Z))).Magnitude
    if dist2 > 4 then
        local speed = math.max(250, h.glideSpeed or 400)
        local startTime = os.clock()
        while h.alive and ((Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(padPos.X, padPos.Z))).Magnitude > 4 and (os.clock() - startTime < 4) do
            if sess and O4 ~= sess then return false end
            local dt = y.Heartbeat:Wait()
            local pos = hrp.Position
            local dest = Vector3.new(padPos.X, 70, padPos.Z)
            local diff = (dest - pos)
            local step = diff.Unit * math.min(diff.Magnitude, speed * dt)
            local newPos = pos + step
            hrp.CFrame = CFrame.lookAt(newPos, newPos + ((diff.Magnitude > 0.05 and diff.Unit or hrp.CFrame.LookVector)))
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            if humanoid then
                if humanoid.PlatformStand then humanoid.PlatformStand = false end
                if humanoid.Sit then humanoid.Sit = false end
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
    if sess and O4 ~= sess then return false end
    local startTime = os.clock()
    while h.alive and math.abs(hrp.Position.Y - padPos.Y) > 2 and (os.clock() - startTime < 1.5) do
        if sess and O4 ~= sess then return false end
        local dt = y.Heartbeat:Wait()
        local pos = hrp.Position
        local diff = (padPos - pos)
        local step = diff.Unit * math.min(diff.Magnitude, 150 * dt)
        hrp.CFrame = CFrame.new(pos + step)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    hrp.CFrame = CFrame.new(padPos)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    local dist = ((hrp.Position - padPos)).Magnitude
    if dist <= 6 then
        pcall(function(...)
            if typeof(firetouchinterest) == "function" then
                firetouchinterest(hrp, tread, 0)
                task.wait(0.02)
                firetouchinterest(hrp, tread, 1)
            end
        end)
        pcall(function(...)
            for _, obj in ipairs(tread:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    if typeof(fireproximityprompt) == "function" then fireproximityprompt(obj) end
                end
            end
            if tread.Parent then
                for _, obj in ipairs(tread.Parent:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        if typeof(fireproximityprompt) == "function" then fireproximityprompt(obj) end
                    end
                end
            end
        end)
        if l then pcall(function(...) l:InvokeServer() end) end
        h.onTreadmill = true
        h.lastTreadmillMount = os.clock()
        h.statusText = "[AutoTreadmill] Running on treadmill"
        return true
    else
        h.onTreadmill = false
        t(string.format("[AutoTreadmill] Not at pad (dist=%.1f studs)", dist))
        return false
    end
end

local function kk(...)
    if not h or not h.hideNotEnoughMoney then return end
    local pg = o:FindFirstChild("PlayerGui")
    if not pg then return end
    pcall(function(...)
        for _, obj in ipairs(pg:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Visible then
                local lower = (tostring(obj.Text or "")):lower()
                if lower:find("not enough money") or lower:find("not enough cash") or
                   (lower:find("not enough") and (lower:find("money") or lower:find("cash") or lower:find("coin") or lower:find("fund"))) then
                    obj.Visible = false
                    obj.TextTransparency = 1
                    obj.TextStrokeTransparency = 1
                    local parent = obj.Parent
                    if parent and (parent:IsA("Frame") or parent:IsA("CanvasGroup")) and #parent:GetChildren() <= 3 then
                        parent.Visible = false
                    end
                end
            end
        end
    end)
end

local function ak(...)
    local pg = o:FindFirstChild("PlayerGui")
    if not pg then return end
    local function hookLabel(label, ...)
        if label:IsA("TextLabel") then
            local function check(...)
                if not h or not h.hideNotEnoughMoney then return end
                local lower = (tostring(label.Text or "")):lower()
                if lower:find("not enough money") or lower:find("not enough cash") or
                   (lower:find("not enough") and (lower:find("money") or lower:find("cash") or lower:find("coin") or lower:find("fund"))) then
                    label.Visible = false
                    label.TextTransparency = 1
                    label.TextStrokeTransparency = 1
                    local parent = label.Parent
                    if parent and (parent:IsA("Frame") or parent:IsA("CanvasGroup")) and #parent:GetChildren() <= 3 then
                        parent.Visible = false
                    end
                end
            end
            check()
            label:GetPropertyChangedSignal("Text"):Connect(check)
            label:GetPropertyChangedSignal("Visible"):Connect(function(...)
                if label.Visible then check() end
            end)
        end
    end
    pcall(function(...)
        for _, obj in ipairs(pg:GetDescendants()) do task.spawn(hookLabel, obj) end
        pg.DescendantAdded:Connect(hookLabel)
    end)
    task.spawn(function(...)
        while h and h.alive do
            if h.hideNotEnoughMoney then kk() end
            task.wait(0.25)
        end
    end)
end

task.spawn(ak)

local function ok(text, ...)
    if not text then return 0 end
    local clean = (((tostring(text)):gsub("[$,]", "")):gsub("%s+", "")):lower()
    local numStr = clean:match("[%d%.]+")
    if not numStr then return 0 end
    local num = tonumber(numStr)
    if not num then return 0 end
    if clean:find("sp") then return num * 999999999999999983222784
    elseif clean:find("sx") then return num * 1000000000000000000000
    elseif clean:find("qi") then return num * 1000000000000000000
    elseif clean:find("qa") or clean:find("q") then return num * 1000000000000000
    elseif clean:find("t") then return num * 1000000000000
    elseif clean:find("b") then return num * 1000000000
    elseif clean:find("m") then return num * 1000000
    elseif clean:find("k") then return num * 1000 end
    return num
end

local function Vk(...)
    local stats = o:FindFirstChild("leaderstats")
    if stats then
        for _, key in ipairs({"Money", "Cash", "Coins", "Currency"}) do
            local stat = stats:FindFirstChild(key)
            if stat then
                local num = tonumber(stat.Value) or ok(stat.Value)
                if num and num > 0 then return num end
            end
        end
    end
    local pg = o:FindFirstChild("PlayerGui")
    if pg then
        local hud = pg:FindFirstChild("HUD") or pg:FindFirstChild("GameHUD") or pg:FindFirstChild("MainHUD") or pg:FindFirstChild("Main")
        if hud then
            for _, obj in ipairs(hud:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Visible then
                    local n = obj.Name:lower()
                    if n == "money" or n == "cash" or n == "coins" or n == "currency" or n == "value" then
                        local num = ok(obj.Text)
                        if num and num > 0 then return num end
                    end
                end
            end
        end
    end
    return 0
end

local function Hk(...)
    local mine = h.plot or (t4 and t4())
    if not mine then return nil end
    local upg = mine:FindFirstChild("TreadmillUpgrade", true)
    if not upg then return nil end
    local best = nil
    for _, obj in ipairs(upg:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local txt = tostring(obj.Text or "")
            local match = txt:match("%$([%d%.,]+%s*[kKmMbBtTqQ]?[aA]?)")
            if match then
                local num = ok(match)
                if num and num > 0 then
                    if not best or num > best then best = num end
                end
            end
        end
    end
    return best
end

local tk = 0
local sk = 10

local function pk(...)
    if not h.autoUpgradeTreadmill then return end
    if os.clock() - tk < sk then return end
    local mine = h.plot or (t4 and t4())
    if not mine then return end
    local upg = mine:FindFirstChild("TreadmillUpgrade", true)
    if not upg then return end
    local money = Vk()
    local cost = Hk()
    if cost and cost > 0 and money < cost then return end
    tk = os.clock()
    if D then pcall(function(...) D:InvokeServer() end) end
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    pcall(function(...)
        for _, obj in ipairs(upg:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                if typeof(fireproximityprompt) == "function" then
                    fireproximityprompt(obj, 0)
                    fireproximityprompt(obj)
                end
            end
            if obj:IsA("GuiButton") and obj.Visible then
                local txt = (obj:IsA("TextButton") and obj.Text) or obj.Name
                local lower = string.lower(txt)
                if not string.find(lower, "robux") and not string.find(lower, "r%$") and
                   (string.find(lower, "%$") or string.find(lower, "upgrade") or string.find(lower, "cash") or
                   (obj.BackgroundColor3 and obj.BackgroundColor3.G > obj.BackgroundColor3.R)) then
                    if typeof(firesignal) == "function" and obj.Activated then
                        firesignal(obj.Activated)
                    elseif typeof(firesignal) == "function" and obj.MouseButton1Click then
                        firesignal(obj.MouseButton1Click)
                    end
                end
            end
            if obj:IsA("BasePart") and obj.Name:find("Pad") and hrp then
                if ((hrp.Position - obj.Position)).Magnitude < 10 then
                    if typeof(firetouchinterest) == "function" then
                        firetouchinterest(hrp, obj, 0)
                        task.wait(0.02)
                        firetouchinterest(hrp, obj, 1)
                    end
                end
            end
        end
    end)
end

local Bk = {
    {id = "GreyTrail", base = "Grey", name = "Grey Trail", price = 100, mult = 1.5},
    {id = "GreenTrail", base = "Green", name = "Green Trail", price = 5000, mult = 2},
    {id = "BlueTrail", base = "Blue", name = "Blue Trail", price = 75000, mult = 2.5},
    {id = "PurpleTrail", base = "Purple", name = "Purple Trail", price = 1500000, mult = 3},
    {id = "GoldenTrail", base = "Golden", name = "Golden Trail", price = 1500000, mult = 3.5},
    {id = "RedTrail", base = "Red", name = "Red Trail", price = 750000000, mult = 4},
    {id = "GalaxyTrail", base = "Galaxy", name = "Galaxy Trail", price = 20000000000, mult = 5},
    {id = "SecretTrail", base = "Secret", name = "Secret Trail", price = 500000000000, mult = 6},
    {id = "EternalTrail", base = "Eternal", name = "Eternal Trail", price = 12500000000000, mult = 10},
    {id = "DivineTrail", base = "Divine", name = "Divine Trail", price = 300000000000000, mult = 14},
    {id = "MoonbloomTrail", base = "Moonbloom", name = "Moonbloom Trail", price = 5000000000000000, mult = 20}
}

local function Jk(...) return Bk end

local function Kk(...)
    local owned = {}
    local pg = o:FindFirstChild("PlayerGui")
    local shop = pg and (pg:FindFirstChild("TrailShop") or pg:FindFirstChild("TrailShop", true))
    local scroll = shop and shop:FindFirstChild("ScrollingFrame", true)
    if scroll then
        pcall(function(...)
            for _, child in ipairs(scroll:GetChildren()) do
                if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                    local name = child.Name
                    for _, sub in ipairs(child:GetDescendants()) do
                        if sub:IsA("GuiButton") or sub:IsA("TextButton") then
                            local txt = (sub:IsA("TextButton") and sub.Text:lower()) or sub.Name:lower()
                            if txt:find("unequip") or (txt:find("equip") and not txt:find("unequip")) then
                                owned[name] = true
                                owned[name:lower()] = true
                                local base = name:gsub("Trail", "")
                                owned[base] = true
                                owned[base:lower()] = true
                            end
                        end
                    end
                end
            end
        end)
    end
    return owned
end

local function ck(btn, ...)
    if not btn then return false end
    pcall(function(...)
        if typeof(firebutton1click) == "function" then firebutton1click(btn)
        elseif typeof(firesignal) == "function" and btn.Activated then firesignal(btn.Activated)
        elseif typeof(firesignal) == "function" and btn.MouseButton1Click then firesignal(btn.MouseButton1Click) end
    end)
    return true
end

local function vk(...)
    local list = Jk()
    local owned = Kk()
    local pg = o:FindFirstChild("PlayerGui")
    local shop = pg and (pg:FindFirstChild("TrailShop") or pg:FindFirstChild("TrailShop", true))
    local scroll = shop and shop:FindFirstChild("ScrollingFrame", true)
    if scroll then
        for i = #list, 1, -1 do
            local trail = list[i]
            local frame = scroll:FindFirstChild(trail.id) or scroll:FindFirstChild(trail.base) or scroll:FindFirstChild(trail.name)
            if not frame then
                for _, child in ipairs(scroll:GetChildren()) do
                    if child:IsA("GuiObject") and (child.Name:lower() == trail.id:lower() or child.Name:lower() == trail.base:lower() or child.Name:lower() == trail.name:lower()) then
                        frame = child
                        break
                    end
                end
            end
            if frame then
                local isEquipped = false
                local equipBtn = nil
                for _, obj in ipairs(frame:GetDescendants()) do
                    if obj:IsA("GuiButton") or obj:IsA("TextButton") then
                        local txt = (obj:IsA("TextButton") and obj.Text:lower()) or obj.Name:lower()
                        if txt:find("unequip") then
                            isEquipped = true
                            break
                        elseif txt:find("equip") and not txt:find("unequip") then
                            equipBtn = obj
                        end
                    end
                end
                if isEquipped then return true end
                if equipBtn then
                    ck(equipBtn)
                    if q then pcall(function(...) q:InvokeServer(trail.id) end) end
                    task.wait(0.2)
                    return true
                end
            end
        end
    end
    if q then
        for i = #list, 1, -1 do
            local trail = list[i]
            local has = owned[trail.id] or owned[trail.id:lower()] or owned[trail.base] or owned[trail.base:lower()] or owned[trail.name] or owned[trail.name:lower()]
            if has then
                pcall(function(...) q:InvokeServer(trail.id) end)
                return true
            end
        end
    end
    return false
end

local ik = 0
local Rk = 8

local function gk(...)
    if not h.autoBuyTrails then return end
    vk()
    if os.clock() - ik < Rk then return end
    local money = Vk()
    if money <= 0 then return end
    local list = Jk()
    local owned = Kk()
    local pg = o:FindFirstChild("PlayerGui")
    local shop = pg and (pg:FindFirstChild("TrailShop") or pg:FindFirstChild("TrailShop", true))
    local scroll = shop and shop:FindFirstChild("ScrollingFrame", true)
    for i = #list, 1, -1 do
        local trail = list[i]
        local has = owned[trail.id] or owned[trail.id:lower()] or owned[trail.base] or owned[trail.base:lower()] or owned[trail.name] or owned[trail.name:lower()]
        if not has and trail.price > 0 and money >= trail.price then
            ik = os.clock()
            local bought = false
            if scroll then
                local frame = scroll:FindFirstChild(trail.id) or scroll:FindFirstChild(trail.base) or scroll:FindFirstChild(trail.name)
                if not frame then
                    for _, child in ipairs(scroll:GetChildren()) do
                        if child:IsA("GuiObject") and (child.Name:lower() == trail.id:lower() or child.Name:lower() == trail.base:lower() or child.Name:lower() == trail.name:lower()) then
                            frame = child
                            break
                        end
                    end
                end
                if frame then
                    for _, obj in ipairs(frame:GetDescendants()) do
                        if obj:IsA("GuiButton") or obj:IsA("TextButton") then
                            local txt = (obj:IsA("TextButton") and obj.Text:lower()) or obj.Name:lower()
                            if not txt:find("robux") and not txt:find("r%$") and not txt:find("unequip") and not txt:find("equip") then
                                if txt:find("%$") or txt:find("buy") then
                                    ck(obj)
                                    bought = true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if C then
                pcall(function(...) C:InvokeServer(trail.id) end)
                bought = true
            end
            if bought then
                task.wait(0.3)
                vk()
                break
            end
        end
    end
end

-- ==============================================================================
-- TARGET SELECTION
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
    if #candidates == 0 and list and #list > 0 then
        for _, rec in ipairs(list) do
            local available = (rec.State == "Slot" or rec.State == "Dropped" or rec.State == 1)
            local pos = rec.BoundsCFrame and rec.BoundsCFrame.Position
            local inBounds = pos and (pos.X >= 545 and pos.X < 850)
            local cooled = X4[rec.Uid] and (os.clock() < X4[rec.Uid])
            if available and inBounds and not cooled then
                table.insert(candidates, {Uid = rec.Uid, Model = nil, CFrame = rec.BoundsCFrame, Position = pos, Distance = ((hrp.Position - pos)).Magnitude, Area = rec.AreaId or "Field"})
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

local Qk = nil
local Pk = nil
local Nk = 350

local function Uk(...)
    local objects = r:FindFirstChild("__OBJECTS") or r:FindFirstChild("Objects")
    local areas = objects and (objects:FindFirstChild("Areas") or objects:FindFirstChild("Area"))
    local guards = areas and (areas:FindFirstChild("GuardAreas") or areas:FindFirstChild("Guards"))
    if guards then
        local ld = guards:FindFirstChild("Light Dark") or guards:FindFirstChild("LightDark") or guards:FindFirstChild("Light_Dark") or guards:FindFirstChild("Light-Dark")
        if ld then return ld end
        for _, child in ipairs(guards:GetChildren()) do
            local lower = string.lower(child.Name)
            if string.find(lower, "light") and string.find(lower, "dark") then return child end
        end
    end
    if areas then
        local ld = areas:FindFirstChild("Light Dark") or areas:FindFirstChild("LightDark") or areas:FindFirstChild("Light_Dark")
        if ld then return ld end
        for _, child in ipairs(areas:GetChildren()) do
            local lower = string.lower(child.Name)
            if string.find(lower, "light") and string.find(lower, "dark") then return child end
        end
    end
    for _, child in ipairs(r:GetChildren()) do
        local name = child.Name
        if name == "__OBJECTS" or name == "Objects" or name == "Areas" or name == "Map" then
            for _, desc in ipairs(child:GetDescendants()) do
                local lower = string.lower(desc.Name)
                if lower == "light dark" or lower == "lightdark" or (string.find(lower, "light") and string.find(lower, "dark")) then
                    if desc:IsA("BasePart") or desc:IsA("Model") or desc:IsA("Folder") then
                        return desc
                    end
                end
            end
        end
    end
    return nil
end

local function lk(pos, ...)
    if not pos then return false end
    if Qk then
        local d = ((Vector3.new(pos.X, 0, pos.Z) - Vector3.new(Qk.X, 0, Qk.Z))).Magnitude
        if d <= Nk then return true end
    end
    local area = Uk()
    if not area then
        if pos.X >= 5200 then return true end
        return false
    end
    local inside = false
    pcall(function(...)
        local cf, size = nil, nil
        if area:IsA("BasePart") then
            cf = area.CFrame
            size = area.Size
        elseif area:IsA("Model") then
            cf, size = area:GetBoundingBox()
        else
            local min, max = nil, nil
            for _, child in ipairs(area:GetChildren()) do
                if child:IsA("BasePart") then
                    local c = child.CFrame
                    local half = child.Size / 2
                    local lo = c.Position - half
                    local hi = c.Position + half
                    if not min then
                        min = lo
                        max = hi
                    else
                        min = Vector3.new(math.min(min.X, lo.X), math.min(min.Y, lo.Y), math.min(min.Z, lo.Z))
                        max = Vector3.new(math.max(max.X, hi.X), math.max(max.Y, hi.Y), math.max(max.Z, hi.Z))
                    end
                end
            end
            if min and max then
                cf = CFrame.new(((min + max)) / 2)
                size = max - min
            end
        end
        if cf and size then
            Qk = cf.Position
            Pk = cf
            Nk = math.max(350, math.max(size.X, size.Z) / 2 + 150)
            local d = ((Vector3.new(pos.X, 0, pos.Z) - Vector3.new(cf.Position.X, 0, cf.Position.Z))).Magnitude
            if d <= Nk then
                inside = true
                return
            end
            local local_ = cf:PointToObjectSpace(pos)
            local half = size / 2
            if math.abs(local_.X) <= (half.X + 200) and math.abs(local_.Z) <= (half.Z + 200) then
                inside = true
                return
            end
        end
        for _, child in ipairs(area:GetDescendants()) do
            if child:IsA("BasePart") then
                if ((pos - child.Position)).Magnitude <= 250 then
                    inside = true
                    if not Qk then Qk = child.Position end
                    return
                end
            end
        end
    end)
    return inside
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
        local o = (explicit and explicit ~= "Unknown" and explicit) or "Common"
        return F[o] or 0, o
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
                local isSecret = (tier >= 4 or rarName == "Secret" or rarName == "Eternal" or rarName == "Divine")
                local zoneOk = (h.selectedZones and h.selectedZones[zone] == true)
                local rarOk = (h.selectedRarities and h.selectedRarities[rarName] == true)
                local allowed = isSecret or (zoneOk and rarOk)
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
    if not target then
        X4 = {}
        target = score(true)
    end
    if not target then
        list = h4(true)
        target = score(true)
    end
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
    h.securingEgg = true
    h.isReturning = false
    h.stateTime = os.clock()
    h.holdingEggForGuard = true
    local pos = target.Position
    V4(pos, 14)
    h.currentTargetModel = model
    h.targetPosition = pos
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    Z4(char)
    pcall(function(...) o:RequestStreamAroundAsync(pos) end)
    if not model and r:FindFirstChild("AreaEggSlotsClient") then
        for _, child in ipairs(r.AreaEggSlotsClient:GetChildren()) do
            local part = child:FindFirstChildWhichIsA("BasePart") or child.PrimaryPart
            if part and ((part.Position - pos)).Magnitude <= 16 then
                model = child
                h.currentTargetModel = child
                break
            end
        end
    end
    if model then
        pcall(function(...)
            for _, obj in ipairs(model:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Transparency > 0.8 and obj.Name ~= "Hitbox" and obj.Name ~= "Root" and not obj.Name:find("Pad") then
                    obj.Transparency = 0
                end
            end
        end)
    end
    h.statusText = "[1/4] Lifting Egg to Trigger Guard..."
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
        h.currentTargetModel = nil
        h.targetPosition = nil
        h.securingEgg = false
        h.holdingEggForGuard = false
        return false
    end
    h.statusText = "[2/4] Waiting for Guard Strike..."
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
    h.statusText = "[3/4] Re-grabbing Egg..."
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
    h.currentTargetModel = nil
    h.targetPosition = nil
    h.securingEgg = false
    h.holdingEggForGuard = false
    if sess and O4 ~= sess then return false end
    if success then
        pcall(u4)
        h.statusText = "Egg Secured"
    else
        if uid then X4[uid] = os.clock() + 2 end
        h.statusText = "Failed to grab"
    end
    return success
end

l4 = function(target, sess, ...)
    if h.teleporting or h.glidingToTarget or h.delivering or h.securingEgg then return false end
    h.teleporting = true
    h.isReturning = false
    h.stateTime = os.clock()
    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then
        D4()
        return false
    end
    humanoid:UnequipTools()
    h.statusText = "[1/7] Pre-Flight Desync..."
    if not h.swapped then A4() end
    if not h.godmode then b4(true) end
    Z4(char)
    if not target then target = N4() end
    local cf = target and target.CFrame or S
    local uid = target and target.Uid
    local pos = cf.Position
    if uid then
        local ok, reason = k4(uid)
        if not ok and reason ~= "CarriedBySelf" then
            X4[uid] = os.clock() + 5
            D4()
            return false
        end
    end
    local heldUid = select(2, e4())
    if not heldUid then
        local lakeEgg = P4()
        if not lakeEgg then
            D4()
            return false
        end
        h.currentTargetModel = lakeEgg.Model
        h.targetPosition = lakeEgg.Position
        local dist = ((hrp.Position - lakeEgg.Position)).Magnitude
        local align = lakeEgg.CFrame * CFrame.new(0, 0.4, 0)
        pcall(function(...) o:RequestStreamAroundAsync(lakeEgg.Position) end)
        V4(lakeEgg.Position, 8)
        if dist > 60 then
            h.glidingToTarget = true
            local ok = R4(align, h.glideSpeed, lakeEgg.Uid, sess)
            h.glidingToTarget = false
            if not ok then
                X4[lakeEgg.Uid] = os.clock() + 5
                D4()
                return false
            end
        else
            hrp.CFrame = align
            hrp.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.04)
        end
        hrp.Anchored = true
        task.wait(0.06)
        hrp.Anchored = false
        h.holdingEggForGuard = true
        local deadline = os.clock() + 3
        while not w4() and os.clock() < deadline and h.alive and h.teleporting do
            if sess and O4 ~= sess then
                D4()
                return false
            end
            if not h.autoFarmLoop and not h.teleporting then
                D4()
                return false
            end
            d4(lakeEgg.Model, lakeEgg.Position)
            if lakeEgg.Uid and i then
                task.spawn(function(...)
                    pcall(function(...)
                        if i:IsA("RemoteFunction") then i:InvokeServer({["Uid"] = lakeEgg.Uid})
                        else i:FireServer({["Uid"] = lakeEgg.Uid}) end
                    end)
                end)
            end
            y.Heartbeat:Wait()
        end
        heldUid = select(2, e4())
        if not w4() then
            D4()
            return false
        end
    end
    h.statusText = "[3/7] Pre-streaming Target..."
    pcall(function(...) o:RequestStreamAroundAsync(pos) end)
    V4(pos, 12)
    h.statusText = "[4/7] Waiting for physical bounce..."
    hrp.Anchored = false
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
    local origSpeed = (humanoid.WalkSpeed > 0) and humanoid.WalkSpeed or 16
    humanoid.WalkSpeed = 0
    humanoid:Move(Vector3.zero, false)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.04)
    local beforePos = hrp.Position
    local beforeY = beforePos.Y
    local heldForGuard = select(2, e4()) or heldUid
    local bounceDetected = false
    local tollConn = nil
    if N and N:IsA("RemoteEvent") then
        tollConn = N.OnClientEvent:Connect(function(...)
            bounceDetected = true
            if tollConn then tollConn:Disconnect() end
        end)
    end
    h.holdingEggForGuard = true
    H4(heldForGuard)
    local startTime = os.clock()
    local bounced = false
    local deadline = startTime + 2.5
    local resendStrike = false
    while os.clock() < deadline and h.alive and h.teleporting do
        if sess and O4 ~= sess then
            if tollConn then tollConn:Disconnect() end
            humanoid.WalkSpeed = origSpeed
            D4()
            return false
        end
        local elapsed = os.clock() - startTime
        local vel = hrp.AssemblyLinearVelocity
        local curPos = hrp.Position
        local dY = curPos.Y - beforeY
        local dDist = ((curPos - beforePos)).Magnitude
        if elapsed >= 0.08 then
            local detected = bounceDetected or vel.Y >= 10 or (dY >= 1.5 and vel.Magnitude >= 16) or dDist >= 2 or vel.Magnitude >= 20
            if detected then
                bounced = true
                break
            end
        end
        if elapsed >= 0.5 and not resendStrike then
            resendStrike = true
            H4(heldForGuard)
        end
        y.Heartbeat:Wait()
    end
    if tollConn then tollConn:Disconnect() end
    humanoid.WalkSpeed = origSpeed
    h.holdingEggForGuard = false
    if not bounced then
        D4()
        pcall(u4)
        return false
    end
    task.wait(0.05)
    if uid then
        local ok, reason = k4(uid)
        if not ok and reason == "CarriedByOther" then
            X4[uid] = os.clock() + 5
            D4()
            return false
        end
    end
    h.currentTargetModel = target and target.Model
    h.targetPosition = pos
    h.statusText = "[5/7] Warping to Target Egg..."
    V4(pos, 8)
    char:PivotTo(cf * CFrame.new(0, 0.4, 0))
    hrp.Anchored = true
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.AssemblyLinearVelocity = Vector3.zero
            obj.AssemblyAngularVelocity = Vector3.zero
        end
    end
    h.statusText = "[6/7] Picking up Target Egg..."
    local bp = o:FindFirstChild("Backpack")
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            pcall(function(...)
                if bp then child.Parent = bp
                else child.Parent = r end
            end)
        end
    end
    task.wait(0.06)
    hrp.Anchored = false
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
    local ok = U4(uid, cf, target and target.Model, sess)
    hrp.Anchored = false
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.AssemblyLinearVelocity = Vector3.zero
            obj.AssemblyAngularVelocity = Vector3.zero
        end
    end
    if not ok then
        D4()
        return false
    else
        h.statusText = "[7/7] Target Secured"
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
    h.pureTweenFarm = false
    h.autoFarmLoop = false
    pcall(D4)
    pcall(u4)
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
                h.pureTweenFarm = true
                h.autoFarmLoop = false
                pcall(u4)
            elseif mode == "WARP" then
                h.autoFarmLoop = true
                h.pureTweenFarm = false
                pcall(u4)
            else
                h.pureTweenFarm = false
                h.autoFarmLoop = false
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
                            h.currentTargetModel = target.Model
                            h.targetPosition = target.Position
                            h.glidingToTarget = true
                            h.stateTime = os.clock()
                            if not h.swapped then A4() end
                            if not h.godmode then b4(true) end
                            Z4(char)
                            pcall(function(...) o:RequestStreamAroundAsync(target.Position) end)
                            local align = target.CFrame * CFrame.new(0, 0.4, 0)
                            local flew = R4(align, h.glideSpeed, target.Uid, sess)
                            h.glidingToTarget = false
                            if O4 ~= sess or not h.pureTweenFarm or Y4 ~= "TWEEN" then return end
                            if not flew then
                                X4[target.Uid] = os.clock() + 5
                                D4()
                                return
                            end
                            if h.pureTweenFarm and Y4 == "TWEEN" and ((hrp.Position - target.Position)).Magnitude <= 22 then
                                local secured = U4(target.Uid, align, target.Model, sess)
                                if not secured and w4() then secured = true end
                                if O4 ~= sess or not h.pureTweenFarm or Y4 ~= "TWEEN" then return end
                                if secured then
                                    pcall(u4)
                                    if h.autoGlide then
                                        Q4(h.glideSpeed, sess)
                                        pcall(u4)
                                    end
                                    pcall(u4)
                                    h.isReturning = false
                                    h.delivering = false
                                    h.glidingToTarget = false
                                    h.securingEgg = false
                                    h.currentTargetModel = nil
                                    h.targetPosition = nil
                                    if c4("TWEEN") then return end
                                else
                                    if O4 == sess and h.pureTweenFarm and Y4 == "TWEEN" then
                                        X4[target.Uid] = os.clock() + 5
                                        D4()
                                    end
                                end
                            else
                                h.currentTargetModel = nil
                                h.targetPosition = nil
                                h.glidingToTarget = false
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
        if not ok then
            t("[AutoSteal Loop]", tostring(err))
            pcall(D4)
        end
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
                                if h.autoGlide then
                                    Q4(h.glideSpeed, sess)
                                    pcall(u4)
                                end
                                pcall(u4)
                                h.isReturning = false
                                h.delivering = false
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
        if not ok then
            t("[SnipeLoop]", tostring(err))
            pcall(D4)
        end
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
        pcall(function(...)
            if h.autoUpgradeTreadmill then pk() end
        end)
        task.wait(5)
        pcall(function(...)
            if h.autoBuyTrails then gk() end
        end)
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
                pcall(function(...) obj.RenderFidelity = Enum.RenderFidelity.Performance end)
                pcall(function(...) obj.CollisionFidelity = Enum.CollisionFidelity.Box end)
            end
        elseif obj:IsA("SpecialMesh") then obj.TextureId = ""
        elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then obj.Enabled = false
        elseif obj:IsA("Beam") then obj.Enabled = false
        elseif obj:IsA("Explosion") then obj.Visible = false
        elseif obj:IsA("Light") or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then obj.Enabled = false
        elseif obj:IsA("Highlight") and obj.Name ~= "EggESP_Highlight" then obj.Enabled = false end
    end)
end

local function Mk(...)
    h.performanceMode = true
    pcall(function(...)
        local esp = r:FindFirstChild("AntraxHub_EggESP")
        if esp then esp:Destroy() end
        local Lighting = game:GetService("Lighting")
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
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 0
            end)
        end
        for _, obj in ipairs(workspace:GetDescendants()) do fk(obj) end
        if not nk then
            nk = workspace.DescendantAdded:Connect(function(child, ...)
                if h.performanceMode then fk(child) end
            end)
        end
        pcall(function(...)
            if settings and (settings()).Rendering then
                (settings()).Rendering.QualityLevel = 1
            end
        end)
    end)
end

local function Ik(...)
    h.performanceMode = false
    if nk then
        pcall(function(...) nk:Disconnect() end)
        nk = nil
    end
    pcall(function(...)
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = true
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("Atmosphere") then
                pcall(function(...) obj.Enabled = true end)
            end
        end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then pcall(function(...) terrain.Decoration = true end) end
    end)
end

-- ==============================================================================
-- ANTI-AFK
-- ==============================================================================
local function Ek(...)
    pcall(function(...)
        local VIM = game:GetService("VirtualInputManager")
        if VIM then
            VIM:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
            task.wait(0.12)
            VIM:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
            task.wait(0.35)
            VIM:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
            task.wait(0.12)
            VIM:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
            pcall(function(...)
                if typeof(VIM.SendTouchEvent) == "function" then
                    VIM:SendTouchEvent(99999, 0, 15, 15)
                    task.wait(0.04)
                    VIM:SendTouchEvent(99999, 2, 15, 15)
                end
            end)
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
            local counter = 0
            while counter < 600 and h and h.alive and h.antiAFK and Lk do
                task.wait(5)
                counter = counter + 5
            end
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
    local hasEgg = w4()
    if pos.Y < 45 then
        hrp.CFrame = CFrame.new(pos.X, 72, pos.Z)
        hrp.AssemblyLinearVelocity = Vector3.zero
        return
    end
    if (h.pureTweenFarm or h.autoFarmLoop) and not h.holdingEggForGuard then
        local toolEquipped = false
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") then
                toolEquipped = true
                break
            end
        end
        if toolEquipped then u4() end
    end
    if h.pureTweenFarm or h.autoFarmLoop or h.teleporting or h.glidingToTarget or
       h.delivering or h.securingEgg or h.isReturning then return end
    if h.alive and h.autoGlide and hasEgg and not a4() and pos.X > E then
        task.spawn(function(...)
            Q4(h.glideSpeed)
            u4()
            h.isReturning = false
            h.delivering = false
        end)
    end
end)

-- ==============================================================================
-- ICON
-- ==============================================================================
local Sk = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAedEVYdFNvZnR3YXJlAFBhaW50Lk5FVCB2My41LjEw/7R3GwAAA6BJREFUeN7tW01oE1EQnk0qih4sevCiF/Wg4kEPgqeCHsSDhyIeVIoHDx48KIKHIh48ePAgePBiPRQ8eBA8COJBD4L4B8WD4kHxov7cm2yT3WzeZjdps7t58CG72bebzPfevPlmdg3DMFwul8vlcv13qampWSKi82S2kxgiVpLZZ2T2G5lDZHaRmU9mDxEViOgqEZ1Np9N3V1ZWLlutFh1vNJvN5+12+4bf77+s/p5zIuKCiAgiGhcRLkRkCRkH+rYikYjlOE7G87w/wWBwLxKJbIeDk8mky3q31xG/37/FwR1Fq9V6Q0SX1N9tIuKNiKgiIo/bbrfb+zwez44qchRzHMcioh2Xy6Xb7fYDIsrqu5WIeBDRoohwJ2VlZaWRSCS2VNEdzZTL5ctEdF1V5Yj4QUQ8EXG73e51j8ejiojOa/V6/ZaI7tDfvUS0SUQJEXFeRNRUVVW5mZmZe/R7kZ2cTCZ1vV4/yXfO/4eQeC4iWqpQKJRkZWWl9XrdISJDRMKIyKqqqjIjI2Pj4uLiGef8lMvlYg4eE9E1VVVP9ff/c5z4n04Gg0F3PB7/TkR5dF6k4/F4v9frdc3NzbV1XW/R/2lEVBER91RVVV1TU8OHr1gsVpP198lkct5xnM/q73kiOq+O37G6uvrVdV2u1+vv6XkRkS8UCr3xeDybyuVydWVlZZlOp9v0/y/O+X41538j1b+/qKurW1bVjYg4b0xMTKyqPZ8gIs7pYx7e1/V6/bKa1xEi6k9OTnZVVVW/IqI7RLRJRHkikVhyHGdBVff9+/cf6LpOU1NTD/T3NBFxRkR00Xm1Xq/fV0U+JqK/RETJ7OzsM7vdzhw81nW9RURDRHSpWCze13Wd6/X6bVV0u6qq6mUkEtnSdV3S10z9vUtE3InpdPrB8vLybSLiTk5OTg1tQ7eP8+jo6Jqqwscikcj2wsLCGuf8FBFxJycnJ7sNDQ1rV1dXWzQ4JCKHqnK6XC5bVfS06rp+k6ry8ZWVFR4eHl4jIs4jIyN9hmF81HX9B1Xl9MTERD8RcfN4PDupVOq+67pP1H1bJpPpvb6+7hPRfVVVV0ZGRtiVlRWWSCReZ7PZX36//6Cvr48PDQ09y2azVzwez7Kqqk8556fdbvdnItpVVdUaGRmZoKqaoP6sUjKZ3B8YGGBd122qyu3j/Ojo6F1N034MDAyw6elpW1VVLhQKzH1HRkZ6m4qKiicikajlOI7ler3e9y6X643L5dqi/+NyuZ6rqvpOVdV/Kysr51wu17fW3w8AAAD//wMAe7/lQy8mR0AAAAAElFTkSuQmCC"

local function Zk(data, ...)
    if crypt and crypt.base64decode then return crypt.base64decode(data) end
    if base64_decode then return base64_decode(data) end
    if syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode then return syn.crypt.base64.decode(data) end
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for i = 1, #alphabet do lookup[alphabet:sub(i, i)] = i - 1 end
    data = (data:gsub("[^" .. (alphabet .. "=]"), "")):gsub("=", "")
    local out = {}
    for i = 1, #data, 4 do
        local a = lookup[data:sub(i, i)] or 0
        local b = lookup[data:sub(i + 1, i + 1)] or 0
        local c = lookup[data:sub(i + 2, i + 2)]
        local d = lookup[data:sub(i + 3, i + 3)]
        table.insert(out, string.char(bit32.bor(bit32.lshift(a, 2), bit32.rshift(b, 4))))
        if c then
            table.insert(out, string.char(bit32.bor(bit32.lshift(bit32.band(b, 15), 4), bit32.rshift(c, 2))))
            if d then
                table.insert(out, string.char(bit32.bor(bit32.lshift(bit32.band(c, 3), 6), d)))
            end
        end
    end
    return table.concat(out)
end

local zk = "Antrax_Hub_Icon.png"
local dk = "rbxassetid://10734950309"
pcall(function(...)
    if writefile and (getcustomasset or getsynasset) then
        local getAsset = getcustomasset or getsynasset
        if not (isfile and isfile(zk)) then writefile(zk, Zk(Sk)) end
        dk = getAsset(zk)
    end
end)

-- ==============================================================================
-- ZONE AND RARITY LABELS (no emoji)
-- ==============================================================================
local ZONE_LABELS = {
    ["Light Dark"] = "Light Dark",
    ["Titan Temple"] = "Titan Temple",
    ["Cherry Blossom"] = "Cherry Blossom",
    ["Cosmic"] = "Cosmic",
    ["Prehistoric"] = "Prehistoric",
    ["Abyss Ocean"] = "Abyss Ocean",
    ["Volcano"] = "Volcano",
    ["Snow"] = "Snow",
    ["Jungle"] = "Jungle",
    ["Desert"] = "Desert",
    ["Lake"] = "Lake",
    ["Forest"] = "Forest",
}

local RARITY_LABELS = {
    ["Divine"] = "Divine",
    ["Eternal"] = "Eternal",
    ["Secret"] = "Secret",
    ["Cosmic"] = "Cosmic",
    ["Mythic"] = "Mythic",
    ["Legendary"] = "Legendary",
    ["Epic"] = "Epic",
    ["Rare"] = "Rare",
    ["Uncommon"] = "Uncommon",
    ["Common"] = "Common",
}

-- ==============================================================================
-- MAIN UI BUILDER
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
    
    -- Main Frame
    local WINDOW_W = 420
    local WINDOW_H = 500
    local HEADER_H = 50
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.fromOffset(WINDOW_W, WINDOW_H)
    main.Position = UDim2.new(0, 40, 0, 80)
    main.BackgroundColor3 = TH.Bg
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Parent = screenGui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = TH.Orange
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.2
    
    -- Top glow accent
    local topGlow = Instance.new("Frame")
    topGlow.Size = UDim2.new(1, 0, 0, 2)
    topGlow.BackgroundColor3 = TH.OrangeBright
    topGlow.BorderSizePixel = 0
    topGlow.ZIndex = 3
    topGlow.Parent = main
    local topGrad = Instance.new("UIGradient", topGlow)
    topGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    
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
    headerCover.Size = UDim2.new(1, 0, 0, 15)
    headerCover.Position = UDim2.new(0, 0, 1, -15)
    headerCover.BackgroundColor3 = TH.Header
    headerCover.BorderSizePixel = 0
    headerCover.ZIndex = 2
    headerCover.Parent = header
    
    -- Orange accent strip
    local strip = Instance.new("Frame")
    strip.Size = UDim2.new(1, 0, 0, 2)
    strip.Position = UDim2.new(0, 0, 1, -2)
    strip.BackgroundColor3 = TH.Orange
    strip.BorderSizePixel = 0
    strip.ZIndex = 3
    strip.Parent = header
    local stripGrad = Instance.new("UIGradient", strip)
    stripGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.7),
    })
    
    -- Logo mark
    local logo = Instance.new("Frame")
    logo.Size = UDim2.fromOffset(26, 26)
    logo.Position = UDim2.fromOffset(12, 12)
    logo.BackgroundColor3 = TH.Orange
    logo.BorderSizePixel = 0
    logo.ZIndex = 3
    logo.Parent = header
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 7)
    
    local logoInner = Instance.new("Frame")
    logoInner.Size = UDim2.fromOffset(10, 10)
    logoInner.Position = UDim2.fromScale(0.5, 0.5)
    logoInner.AnchorPoint = Vector2.new(0.5, 0.5)
    logoInner.BackgroundColor3 = TH.Text
    logoInner.BorderSizePixel = 0
    logoInner.ZIndex = 4
    logoInner.Parent = logo
    Instance.new("UICorner", logoInner).CornerRadius = UDim.new(1, 0)
    
    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -200, 0, 18)
    titleLbl.Position = UDim2.fromOffset(46, 7)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = TH.OrangeGlow
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Text = "Antrax Hub"
    titleLbl.ZIndex = 3
    titleLbl.Parent = header
    
    -- Subtitle
    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -200, 0, 12)
    subLbl.Position = UDim2.fromOffset(46, 26)
    subLbl.BackgroundTransparency = 1
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 10
    subLbl.TextColor3 = TH.Muted
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.Text = CREDITS_FULL
    subLbl.ZIndex = 3
    subLbl.Parent = header
    
    -- Credit badge
    local badge = Instance.new("Frame")
    badge.Size = UDim2.fromOffset(120, 20)
    badge.Position = UDim2.new(1, -232, 0, 15)
    badge.BackgroundColor3 = TH.OrangeDeep
    badge.BorderSizePixel = 0
    badge.ZIndex = 3
    badge.Parent = header
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 5)
    local badgeStroke = Instance.new("UIStroke", badge)
    badgeStroke.Color = TH.Orange
    badgeStroke.Thickness = 1
    badgeStroke.Transparency = 0.4
    
    local badgeLbl = Instance.new("TextLabel")
    badgeLbl.Size = UDim2.fromScale(1, 1)
    badgeLbl.BackgroundTransparency = 1
    badgeLbl.Font = Enum.Font.GothamBold
    badgeLbl.TextSize = 9
    badgeLbl.TextColor3 = TH.OrangeGlow
    badgeLbl.Text = CREDITS_TG
    badgeLbl.ZIndex = 4
    badgeLbl.Parent = badge
    
    -- Minimize button
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinBtn"
    minBtn.Size = UDim2.fromOffset(28, 24)
    minBtn.Position = UDim2.new(1, -66, 0, 13)
    minBtn.BackgroundColor3 = TH.OrangeDark
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 15
    minBtn.TextColor3 = TH.Text
    minBtn.Text = "−"
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 5
    minBtn.Parent = header
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)
    local minStroke = Instance.new("UIStroke", minBtn)
    minStroke.Color = TH.Orange
    minStroke.Thickness = 1
    minStroke.Transparency = 0.4
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(28, 24)
    closeBtn.Position = UDim2.new(1, -34, 0, 13)
    closeBtn.BackgroundColor3 = TH.Danger
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.TextColor3 = TH.Text
    closeBtn.Text = "X"
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 5
    closeBtn.Parent = header
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
    
    -- Body
    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, 0, 1, -HEADER_H)
    body.Position = UDim2.fromOffset(0, HEADER_H)
    body.BackgroundTransparency = 1
    body.Parent = main
    
    -- Tab bar
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -20, 0, 34)
    tabBar.Position = UDim2.fromOffset(10, 8)
    tabBar.BackgroundColor3 = TH.Deep
    tabBar.BorderSizePixel = 0
    tabBar.Parent = body
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 7)
    local tabBarStroke = Instance.new("UIStroke", tabBar)
    tabBarStroke.Color = TH.Border
    tabBarStroke.Thickness = 1
    tabBarStroke.Transparency = 0.5
    
    -- Content area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -50)
    content.Position = UDim2.fromOffset(10, 50)
    content.BackgroundTransparency = 1
    content.Parent = body
    
    -- Tab system
    local tabs = {}
    local tabOrder = {}
    local contentFrames = {}
    local activeTab = nil
    
    local function resizeTabs()
        local total = #tabOrder
        if total == 0 then return end
        for i, name in ipairs(tabOrder) do
            local tab = tabs[name]
            if tab then
                tab.button.Size = UDim2.new(1 / total, -6, 1, -8)
                tab.button.Position = UDim2.new((i - 1) / total, 3, 0, 4)
            end
        end
    end
    
    local function showTab(name)
        for tabName, tab in pairs(tabs) do
            local isActive = (tabName == name)
            tab.frame.Visible = isActive
            if isActive then
                tab.button.BackgroundColor3 = TH.OrangeDark
                tab.button.TextColor3 = TH.OrangeGlow
                local stroke = tab.button:FindFirstChildOfClass("UIStroke")
                if not stroke then
                    stroke = Instance.new("UIStroke", tab.button)
                end
                stroke.Color = TH.Orange
                stroke.Thickness = 1.4
                stroke.Transparency = 0.2
            else
                tab.button.BackgroundColor3 = TH.Card
                tab.button.TextColor3 = TH.Sub
                local stroke = tab.button:FindFirstChildOfClass("UIStroke")
                if stroke then stroke:Destroy() end
            end
        end
        activeTab = name
    end
    
    local function addTab(name, label)
        local count = #tabOrder
        tabOrder[#tabOrder + 1] = name
        
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. name
        tabBtn.BackgroundColor3 = TH.Card
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.TextSize = 12
        tabBtn.TextColor3 = TH.Sub
        tabBtn.Text = label
        tabBtn.AutoButtonColor = false
        tabBtn.ZIndex = 2
        tabBtn.Parent = tabBar
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
        scroll.ScrollBarImageColor3 = TH.Orange
        scroll.ScrollBarImageTransparency = 0.3
        scroll.CanvasSize = UDim2.new()
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Parent = tabFrame
        
        local layout = Instance.new("UIListLayout", scroll)
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local pad = Instance.new("UIPadding", scroll)
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 2)
        pad.PaddingRight = UDim.new(0, 2)
        
        tabs[name] = {button = tabBtn, frame = tabFrame, scroll = scroll}
        contentFrames[name] = tabFrame
        
        tabBtn.MouseButton1Click:Connect(function(...) showTab(name) end)
        resizeTabs()
        return scroll
    end
    
    -- Section header
    local function addSection(parent, text, order)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 24)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = order
        frame.Parent = parent
        
        local accent = Instance.new("Frame")
        accent.Size = UDim2.fromOffset(3, 14)
        accent.Position = UDim2.new(0, 2, 0.5, -7)
        accent.BackgroundColor3 = TH.Orange
        accent.BorderSizePixel = 0
        accent.Parent = frame
        Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 2)
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -14, 1, 0)
        label.Position = UDim2.fromOffset(12, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = TH.OrangeGlow
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
    end
    
    -- Toggle row
    local function addToggle(parent, title, desc, initial, order, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 46)
        frame.BackgroundColor3 = TH.Card
        frame.LayoutOrder = order
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
        local frameStroke = Instance.new("UIStroke", frame)
        frameStroke.Color = TH.Border
        frameStroke.Thickness = 1
        frameStroke.Transparency = 0.6
        
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -70, 0, 16)
        titleLbl.Position = UDim2.fromOffset(12, 7)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = TH.Text
        titleLbl.TextSize = 12
        titleLbl.Font = Enum.Font.GothamSemibold
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = frame
        
        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, -70, 0, 14)
        descLbl.Position = UDim2.fromOffset(12, 24)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = desc
        descLbl.TextColor3 = TH.Muted
        descLbl.TextSize = 10
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.TextTruncate = Enum.TextTruncate.AtEnd
        descLbl.Parent = frame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.fromOffset(48, 26)
        toggle.Position = UDim2.new(1, -60, 0.5, -13)
        toggle.BackgroundColor3 = initial and TH.OrangeDark or TH.Off
        toggle.Text = ""
        toggle.AutoButtonColor = false
        toggle.Parent = frame
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
        
        local toggleStroke = Instance.new("UIStroke", toggle)
        toggleStroke.Color = initial and TH.Orange or TH.Border
        toggleStroke.Thickness = 1
        toggleStroke.Transparency = 0.3
        
        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(20, 20)
        knob.Position = initial and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        knob.BackgroundColor3 = initial and TH.OrangeGlow or TH.Muted
        knob.Parent = toggle
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        
        local state = initial
        local function setVisual(v)
            state = v
            TweenService:Create(toggle, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                BackgroundColor3 = state and TH.OrangeDark or TH.Off
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = state and TH.OrangeGlow or TH.Muted
            }):Play()
            toggleStroke.Color = state and TH.Orange or TH.Border
            titleLbl.TextColor3 = state and TH.OrangeGlow or TH.Text
        end
        
        toggle.MouseButton1Click:Connect(function(...)
            setVisual(not state)
            callback(state)
        end)
        
        return setVisual
    end
    
    -- Button row
    local function addButton(parent, title, desc, color, order, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 46)
        frame.BackgroundColor3 = TH.Card
        frame.LayoutOrder = order
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
        local frameStroke = Instance.new("UIStroke", frame)
        frameStroke.Color = TH.Border
        frameStroke.Thickness = 1
        frameStroke.Transparency = 0.6
        
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -100, 0, 16)
        titleLbl.Position = UDim2.fromOffset(12, 7)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = color or TH.Text
        titleLbl.TextSize = 12
        titleLbl.Font = Enum.Font.GothamSemibold
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = frame
        
        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, -100, 0, 14)
        descLbl.Position = UDim2.fromOffset(12, 24)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = desc
        descLbl.TextColor3 = TH.Muted
        descLbl.TextSize = 10
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.TextTruncate = Enum.TextTruncate.AtEnd
        descLbl.Parent = frame
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(80, 28)
        btn.Position = UDim2.new(1, -92, 0.5, -14)
        btn.BackgroundColor3 = color or TH.Orange
        btn.Text = "RUN"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.Parent = frame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = TH.OrangeBright
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.5
        
        btn.MouseButton1Click:Connect(function(...)
            TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = TH.OrangeBright}):Play()
            task.delay(0.1, function(...)
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color or TH.Orange}):Play()
            end)
            callback()
        end)
    end
    
    -- Chip group (for zone/rarity selection)
    local function addChipGroup(parent, title, items, order, getState, onToggle)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40 + math.ceil(#items / 3) * 34)
        frame.BackgroundColor3 = TH.Card
        frame.LayoutOrder = order
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
        local frameStroke = Instance.new("UIStroke", frame)
        frameStroke.Color = TH.Border
        frameStroke.Thickness = 1
        frameStroke.Transparency = 0.6
        
        local head = Instance.new("TextLabel")
        head.Size = UDim2.new(1, -16, 0, 20)
        head.Position = UDim2.fromOffset(12, 8)
        head.BackgroundTransparency = 1
        head.Text = title
        head.TextColor3 = TH.OrangeGlow
        head.TextSize = 11
        head.Font = Enum.Font.GothamBold
        head.TextXAlignment = Enum.TextXAlignment.Left
        head.Parent = frame
        
        local grid = Instance.new("Frame")
        grid.Size = UDim2.new(1, -20, 1, -36)
        grid.Position = UDim2.fromOffset(10, 30)
        grid.BackgroundTransparency = 1
        grid.Parent = frame
        
        local gridLayout = Instance.new("UIGridLayout", grid)
        gridLayout.CellSize = UDim2.new(0.32, 0, 0, 28)
        gridLayout.CellPadding = UDim2.new(0.02, 0, 0, 6)
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        for i, item in ipairs(items) do
            local chip = Instance.new("TextButton")
            chip.LayoutOrder = i
            chip.Font = Enum.Font.GothamSemibold
            chip.TextSize = 10
            chip.AutoButtonColor = false
            chip.TextTruncate = Enum.TextTruncate.AtEnd
            Instance.new("UICorner", chip).CornerRadius = UDim.new(0, 5)
            
            local function refresh()
                local active = getState(item)
                if active then
                    chip.BackgroundColor3 = TH.OrangeDark
                    chip.TextColor3 = TH.OrangeGlow
                    chip.Text = "[+] " .. item
                    chipStroke.Color = TH.Orange
                else
                    chip.BackgroundColor3 = TH.Off
                    chip.TextColor3 = TH.Sub
                    chip.Text = "[ ] " .. item
                    chipStroke.Color = TH.Border
                end
            end
            
            local chipStroke = Instance.new("UIStroke", chip)
            chipStroke.Thickness = 1
            chipStroke.Transparency = 0.4
            
            refresh()
            
            chip.MouseButton1Click:Connect(function(...)
                onToggle(item)
                refresh()
            end)
            
            chip.Parent = grid
        end
    end
    
    -- Status bar
    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(1, -20, 0, 22)
    statusBar.Position = UDim2.new(0, 10, 1, -26)
    statusBar.BackgroundColor3 = TH.Deep
    statusBar.BorderSizePixel = 0
    statusBar.Parent = main
    Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 5)
    
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.fromOffset(8, 8)
    statusDot.Position = UDim2.new(0, 8, 0.5, -4)
    statusDot.BackgroundColor3 = TH.Muted
    statusDot.BorderSizePixel = 0
    statusDot.Parent = statusBar
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)
    
    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, -24, 1, 0)
    statusLbl.Position = UDim2.fromOffset(22, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "Idle — all features OFF"
    statusLbl.TextColor3 = TH.Sub
    statusLbl.TextSize = 10
    statusLbl.Font = Enum.Font.Gotham
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.Parent = statusBar
    
    -- Minimize handler
    local collapsed = false
    minBtn.MouseButton1Click:Connect(function(...)
        collapsed = not collapsed
        body.Visible = not collapsed
        statusBar.Visible = not collapsed
        main.Size = UDim2.fromOffset(WINDOW_W, collapsed and HEADER_H or WINDOW_H)
        minBtn.Text = collapsed and "+" or "−"
    end)
    
    -- Close handler
    closeBtn.MouseButton1Click:Connect(function(...) aM() end)
    
    -- Dragging
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
        if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- RightCtrl toggle
    w.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)
    
    -- Status update loop
    task.spawn(function(...)
        while h.alive do
            pcall(function(...)
                local mode = "Idle"
                if h.pureTweenFarm then mode = "Tween Steal"
                elseif h.autoFarmLoop then mode = "Warp Snipe"
                elseif h.autoTreadmill then mode = "Treadmill"
                elseif h.securingEgg then mode = "Securing"
                elseif h.glidingToTarget then mode = "Gliding"
                elseif h.isReturning then mode = "Returning"
                end
                local eggs = y4()
                local actives = {}
                if h.autoTreadmill then actives[#actives + 1] = "Treadmill" end
                if h.autoHatch then actives[#actives + 1] = "Hatch" end
                if h.autoPlaceEvery5 then actives[#actives + 1] = "Place5" end
                if h.autoGlide then actives[#actives + 1] = "Return" end
                if h.autoUpgradeTreadmill then actives[#actives + 1] = "Upgrade" end
                if h.autoBuyTrails then actives[#actives + 1] = "Trails" end
                if h.antiAFK then actives[#actives + 1] = "AFK" end
                if h.godmode then actives[#actives + 1] = "God" end
                if h.disable3D then actives[#actives + 1] = "3D-OFF" end
                
                local extra = ""
                if #actives > 0 then extra = " | " .. table.concat(actives, " • ") end
                statusLbl.Text = string.format("[%s] Eggs: %d%s", mode, eggs, extra)
                
                if mode == "Idle" and #actives == 0 then
                    statusDot.BackgroundColor3 = TH.Muted
                else
                    statusDot.BackgroundColor3 = TH.OrangeBright
                end
            end)
            task.wait(0.4)
        end
    end)
    
    -- ==========================================================================
    -- TAB 1: FARM
    -- ==========================================================================
    local farmScroll = addTab("farm", "FARM")
    local o1 = 0
    local function no1() o1 = o1 + 1 return o1 end
    
    addSection(farmScroll, "AUTO STEAL MODES", no1())
    
    addToggle(farmScroll, "Auto Steal (Tween)", "Smoothly fly to steal eggs", false, no1(), function(v)
        if v then T4("TWEEN")
        else
            if Y4 == "TWEEN" or h.pureTweenFarm then T4("NONE") end
        end
    end)
    
    addToggle(farmScroll, "Auto Steal (Warp)", "Instantly teleport to steal eggs", false, no1(), function(v)
        if v then T4("WARP")
        else
            if Y4 == "WARP" or h.autoFarmLoop then T4("NONE") end
        end
    end)
    
    addButton(farmScroll, "Single Steal", "Teleport, steal 1 egg, and return", TH.Orange, no1(), function(...)
        task.spawn(function(...)
            if Y4 ~= "NONE" then T4("NONE") task.wait(0.2) end
            local target = N4()
            if target then
                local ok = l4(target, nil)
                if ok then
                    pcall(u4)
                    if h.autoGlide then Q4(h.glideSpeed) u4() end
                end
            end
        end)
    end)
    
    addSection(farmScroll, "PLACE & HATCH", no1())
    
    addButton(farmScroll, "Place Eggs", "Fly home, place all eggs & hatch", TH.Orange, no1(), function(...)
        task.spawn(function(...)
            h.statusText = "[Manual] Depositing eggs..."
            g4(h.glideSpeed) v4() u4()
            h.isReturning = false
            h.delivering = false
        end)
    end)
    
    addToggle(farmScroll, "Auto Place (Every 5)", "Return home every 5 steals to deposit", false, no1(), function(v)
        h.autoPlaceEvery5 = v
        if not v then h.batchStealCount = 0 end
    end)
    
    addToggle(farmScroll, "Auto Hatch", "Hatch ready eggs continuously", false, no1(), function(v)
        h.autoHatch = v
    end)
    
    addToggle(farmScroll, "Auto Return", "Return to safe area after stealing", false, no1(), function(v)
        h.autoGlide = v
    end)
    
    addSection(farmScroll, "AUTOMATION", no1())
    
    addToggle(farmScroll, "Auto Treadmill", "Run on treadmill when no eggs available", false, no1(), function(v)
        h.autoTreadmill = v
        x() n4()
        if not v and (h.onTreadmill or L4()) then M4() end
    end)
    
    addToggle(farmScroll, "Auto Upgrade Treadmill", "Auto-upgrade when affordable", false, no1(), function(v)
        h.autoUpgradeTreadmill = v
        x()
    end)
    
    addToggle(farmScroll, "Auto Buy Trails", "Buy and equip best speed trail", false, no1(), function(v)
        h.autoBuyTrails = v
        x()
    end)
    
    addToggle(farmScroll, "Hide Money Alerts", "Suppress 'Not Enough Money' popup", false, no1(), function(v)
        h.hideNotEnoughMoney = v
        x()
    end)
    
    -- ==========================================================================
    -- TAB 2: EGG SELECT
    -- ==========================================================================
    local eggScroll = addTab("egg", "EGG SELECT")
    local o2 = 0
    local function no2() o2 = o2 + 1 return o2 end
    
    addSection(eggScroll, "TARGET ZONES", no2())
    
    addChipGroup(eggScroll, "Select zones to steal from", M, no2(), function(item)
        return h.selectedZones and h.selectedZones[item] == true
    end, function(item)
        if not h.selectedZones then h.selectedZones = {} end
        h.selectedZones[item] = not (h.selectedZones[item] == true)
        x()
    end)
    
    addSection(eggScroll, "TARGET RARITIES", no2())
    
    addChipGroup(eggScroll, "Select rarities to collect", X, no2(), function(item)
        return h.selectedRarities and h.selectedRarities[item] == true
    end, function(item)
        if not h.selectedRarities then h.selectedRarities = {} end
        h.selectedRarities[item] = not (h.selectedRarities[item] == true)
        x()
    end)
    
    -- ==========================================================================
    -- TAB 3: CHARACTER
    -- ==========================================================================
    local charScroll = addTab("char", "CHARACTER")
    local o3 = 0
    local function no3() o3 = o3 + 1 return o3 end
    
    addSection(charScroll, "SAFETY", no3())
    
    addToggle(charScroll, "Godmode", "Immunity against attacks and traps", false, no3(), function(v)
        if v then enableDesyncGodmode() else disableDesyncGodmode() end
    end)
    
    addButton(charScroll, "Get Unstuck", "Escape treadmill and geometry", TH.Warning, no3(), function(...)
        pcall(M4) pcall(C4) pcall(D4)
    end)
    
    addSection(charScroll, "FLIGHT", no3())
    
    -- Speed slider
    do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 46)
        frame.BackgroundColor3 = TH.Card
        frame.LayoutOrder = no3()
        frame.Parent = charScroll
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
        local frameStroke = Instance.new("UIStroke", frame)
        frameStroke.Color = TH.Border
        frameStroke.Thickness = 1
        frameStroke.Transparency = 0.6
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -140, 0, 16)
        lbl.Position = UDim2.fromOffset(12, 7)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Flight Speed"
        lbl.TextColor3 = TH.Text
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame
        
        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0, 90, 0, 24)
        valLbl.Position = UDim2.new(1, -102, 0.5, -12)
        valLbl.BackgroundColor3 = TH.Deep
        valLbl.Text = string.format("%d studs/s", h.glideSpeed or 600)
        valLbl.TextColor3 = TH.OrangeGlow
        valLbl.TextSize = 11
        valLbl.Font = Enum.Font.GothamBold
        valLbl.Parent = frame
        Instance.new("UICorner", valLbl).CornerRadius = UDim.new(0, 5)
        
        local minus = Instance.new("TextButton")
        minus.Size = UDim2.fromOffset(24, 24)
        minus.Position = UDim2.new(1, -132, 0.5, -12)
        minus.BackgroundColor3 = TH.Off
        minus.Text = "−"
        minus.TextColor3 = TH.Text
        minus.TextSize = 14
        minus.Font = Enum.Font.GothamBold
        minus.Parent = frame
        Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 5)
        
        local plus = Instance.new("TextButton")
        plus.Size = UDim2.fromOffset(24, 24)
        plus.Position = UDim2.new(1, -160, 0.5, -12)
        plus.BackgroundColor3 = TH.Off
        plus.Text = "+"
        plus.TextColor3 = TH.Text
        plus.TextSize = 14
        plus.Font = Enum.Font.GothamBold
        plus.Parent = frame
        Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 5)
        
        minus.MouseButton1Click:Connect(function(...)
            h.glideSpeed = math.max(100, (h.glideSpeed or 600) - 25)
            valLbl.Text = string.format("%d studs/s", h.glideSpeed)
            Y(h.glideSpeed)
        end)
        plus.MouseButton1Click:Connect(function(...)
            h.glideSpeed = math.min(1000, (h.glideSpeed or 600) + 25)
            valLbl.Text = string.format("%d studs/s", h.glideSpeed)
            Y(h.glideSpeed)
        end)
    end
    
    addButton(charScroll, "Reset Character", "Clear velocity, cancel push, unfreeze", TH.Orange, no3(), function(...)
        pcall(D4) pcall(u4)
    end)
    
    -- ==========================================================================
    -- TAB 4: SETTINGS
    -- ==========================================================================
    local setScroll = addTab("set", "SETTINGS")
    local o4 = 0
    local function no4() o4 = o4 + 1 return o4 end
    
    addSection(setScroll, "PERFORMANCE", no4())
    
    addToggle(setScroll, "Ultra Potato Mode", "Disable textures/effects for FPS", false, no4(), function(v)
        h.performanceMode = v
        if v then Mk() else Ik() end
        x()
    end)
    
    addToggle(setScroll, "Disable 3D Rendering", "Freeze viewport for GPU saver", false, no4(), function(v)
        h.disable3D = v
        pcall(function(...) y:Set3dRenderingEnabled(not v) end)
        x()
    end)
    
    addSection(setScroll, "SYSTEM", no4())
    
    addToggle(setScroll, "Anti-AFK", "Prevent idle kick automatically", false, no4(), function(v)
        h.antiAFK = v
        if v then bk() else Ak() end
        x()
    end)
    
    addButton(setScroll, "Rejoin Server", "Reconnect to the same server", TH.Orange, no4(), function(...)
        pcall(function(...) TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, o) end)
    end)
    
    addButton(setScroll, "Unload Script", "Stop all loops and destroy UI", TH.Danger, no4(), function(...)
        aM()
    end)
    
    -- ==========================================================================
    -- FINAL: show first tab
    -- ==========================================================================
    showTab("farm")
end

-- ==============================================================================
-- UNLOAD
-- ==============================================================================
local function aM(...)
    h.alive = false
    pcall(Ik)
    pcall(Ak)
    pcall(function(...) y:Set3dRenderingEnabled(true) end)
    pcall(function(...)
        local esp = r:FindFirstChild("AntraxHub_EggESP")
        if esp then esp:Destroy() end
    end)
    pcall(D4)
    pcall(u4)
    if h.gui then pcall(function(...) h.gui:Destroy() end) end
    pcall(function(...)
        for _, gui in ipairs(game.CoreGui:GetChildren()) do
            if gui.Name:find("Antrax_") or gui.Name:find("DesyncSniperUI") then
                gui:Destroy()
            end
        end
    end)
end

-- ==============================================================================
-- BOOT
-- ==============================================================================
H("[+] Initializing Antrax Hub • Orange Edition")
H("[+] Credits: " .. CREDITS_NAME .. " | " .. CREDITS_TG)

buildUI()

task.spawn(function(...)
    task.wait(0.5)
    A4()
    C4()
    if o.Character then z4(o.Character) end
    u4()
    H("[+] Character initialized.")
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
H("    Antrax Hub — ORANGE & BLACK EDITION")
H("    Credits: " .. CREDITS_NAME)
H("    Telegram: " .. CREDITS_TG)
H("    All toggles OFF by default")
H("═══════════════════════════════════════════════════")
print("[Antrax Hub • Antrax] Loaded successfully!")
print("Credits: " .. CREDITS_NAME .. " | " .. CREDITS_TG)