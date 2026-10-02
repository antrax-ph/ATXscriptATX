-- ==============================================================================
-- [Lunaris Hub] Steal An Egg Suite — RED & BLACK EDITION
-- Credits: Antrax
-- Telegram: @AntraxdevZ
-- ==============================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer

-- Aliases matching original naming
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
local CREDITS_FULL = "by " .. CREDITS_NAME .. " • " .. CREDITS_TG

-- ==============================================================================
-- RED & BLACK THEME
-- ==============================================================================
local RB = {
    Bg          = Color3.fromRGB(10, 10, 12),
    BgDark      = Color3.fromRGB(6, 6, 8),
    Card        = Color3.fromRGB(18, 18, 22),
    CardHover   = Color3.fromRGB(28, 28, 34),
    Deep        = Color3.fromRGB(12, 12, 15),
    Header      = Color3.fromRGB(14, 14, 18),
    Text        = Color3.fromRGB(240, 240, 245),
    Sub         = Color3.fromRGB(160, 160, 175),
    Muted       = Color3.fromRGB(110, 110, 125),
    Red         = Color3.fromRGB(200, 30, 45),
    RedBright   = Color3.fromRGB(240, 55, 70),
    RedGlow     = Color3.fromRGB(255, 90, 100),
    RedDark     = Color3.fromRGB(120, 20, 30),
    RedDeep     = Color3.fromRGB(60, 10, 18),
    Success     = Color3.fromRGB(200, 30, 45),
    SuccessDark = Color3.fromRGB(80, 15, 25),
    Danger      = Color3.fromRGB(180, 20, 20),
    DangerDim   = Color3.fromRGB(70, 15, 15),
    Warning     = Color3.fromRGB(220, 130, 40),
    Gold        = Color3.fromRGB(255, 190, 90),
    Off         = Color3.fromRGB(35, 35, 42),
    Border      = Color3.fromRGB(60, 15, 25),
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

local Z = "LunarisHub_FlightSpeed.txt"
local z = "LunarisHub_EggSelectConfig.json"

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
    local defaultZones = {["Light Dark"] = true, ["Titan Temple"] = true, ["Cherry Blossom"] = true,
        ["Cosmic"] = false, ["Prehistoric"] = false, ["Abyss Ocean"] = false,
        ["Volcano"] = false, ["Snow"] = false, ["Jungle"] = false,
        ["Desert"] = false, ["Lake"] = false, ["Forest"] = false}
    local defaultRarities = {["Divine"] = true, ["Eternal"] = true, ["Secret"] = true,
        ["Cosmic"] = true, ["Mythic"] = true, ["Legendary"] = false,
        ["Epic"] = false, ["Rare"] = false, ["Uncommon"] = false, ["Common"] = false}
    if type(data) ~= "table" then
        data = {
            ["selectedZones"] = defaultZones,
            ["selectedRarities"] = defaultRarities,
            ["alwaysCollectSecretPlus"] = true,
            ["minRarityTier"] = 2,
            ["autoTreadmill"] = true,
            ["autoUpgradeTreadmill"] = true,
            ["autoBuyTrails"] = true,
            ["hideNotEnoughMoney"] = true,
            ["performanceMode"] = false,
            ["disable3D"] = false,
            ["antiAFK"] = true,
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
        if data.alwaysCollectSecretPlus == nil then data.alwaysCollectSecretPlus = true end
        if data.minRarityTier == nil then data.minRarityTier = 2 end
        if data.autoTreadmill == nil then data.autoTreadmill = true end
        if data.autoUpgradeTreadmill == nil then data.autoUpgradeTreadmill = true end
        if data.autoBuyTrails == nil then data.autoBuyTrails = true end
        if data.hideNotEnoughMoney == nil then data.hideNotEnoughMoney = true end
        if data.performanceMode == nil then data.performanceMode = false end
        if data.disable3D == nil then data.disable3D = false end
        if data.antiAFK == nil then data.antiAFK = true end
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
                ["alwaysCollectSecretPlus"] = (h.alwaysCollectSecretPlus ~= false),
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
-- GLOBAL STATE
-- ==============================================================================
local W = T()
h = {
    godmode = true, autoGlide = true, autoHatch = true,
    autoPlaceEvery5 = false, batchStealCount = 0, isBatchPlacing = false,
    isHatching = false, autoFarmLoop = false, pureTweenFarm = false,
    glidingToTarget = false, securingEgg = false, glideSpeed = O(),
    selectedZones = W.selectedZones, selectedRarities = W.selectedRarities,
    alwaysCollectSecretPlus = W.alwaysCollectSecretPlus, minRarityTier = W.minRarityTier,
    autoTreadmill = (W.autoTreadmill ~= false),
    autoUpgradeTreadmill = (W.autoUpgradeTreadmill ~= false),
    autoBuyTrails = (W.autoBuyTrails ~= false),
    hideNotEnoughMoney = true, performanceMode = (W.performanceMode == true),
    disable3D = (W.disable3D == true), antiAFK = (W.antiAFK ~= false),
    onTreadmill = false, lastTreadmillMount = 0, laneZ = -360, swapped = false,
    teleporting = false, isReturning = false, delivering = false,
    holdingEggForGuard = false, currentTargetModel = nil, targetPosition = nil,
    stateTime = os.clock(), statusText = "Ready", bestEggInfo = "Scanning...",
    gui = nil, alive = true, plot = nil, pen = nil, origin = nil, tread = nil
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
        if dodging then h.statusText = string.format("Tweening Home (Z: %.0f) [DODGING TRAP!]", newZ)
        else h.statusText = string.format("Tweening Home (%.0f studs | Z: %.0f | Spd: %.0f)", dist, newZ, currentSpeed) end
    end
    hrp.CFrame = CFrame.new(target)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    if humanoid then humanoid.AutoRotate = true end
    u4()
    h.isReturning = false
    h.delivering = false
    h.statusText = "Arrived at Base PetArea!"
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
    h.statusText = string.format("Placed & Hatched (Left: %d)! Hands Free.", remaining)
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
        if dodging then h.statusText = string.format("Gliding Out (Z: %.0f) [DODGING TRAP!]", newZ)
        else h.statusText = string.format("Gliding -> Egg (%.0f studs | H: %.0f)", dist3, dist2) end
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
                h.statusText = "[AutoSteal] Exiting Base -> Waypoint (500, 70, -364)..."
                H(string.format("[AutoSteal] Leaving base (X=%.1f): Gliding to waypoint first (dist=%.1f studs)...", px, dist))
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
            t("[Return] Aborted by session switch!")
            if humanoid then humanoid.AutoRotate = true end
            h.isReturning = false
            return false
        end
        if not h.pureTweenFarm and not h.autoFarmLoop then
            t("[Return] Aborted (all farms disabled)")
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
        if dodging then h.statusText = string.format("Tweening Safe Line (Z: %.0f) [DODGING!]", newZ)
        else h.statusText = string.format("Tweening to Safe Line (%.0f studs | X: %.0f)", dist, pos.X) end
    end
    hrp.CFrame = CFrame.new(E, math.max(68, hrp.Position.Y), laneZ)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    if humanoid then humanoid.AutoRotate = true end
    u4()
    h.isReturning = false
    h.delivering = false
    if h then h.onTreadmill = false end
    h.statusText = "Arrived at Safe Line (X=525)! Hands Free."
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
        t("[AutoTreadmill] Treadmill part not found! Retrying next loop...")
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
        h.statusText = "[AutoTreadmill] Returning along highway to base..."
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
        h.statusText = "[AutoTreadmill] Elevated flyover to base plot..."
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
        h.statusText = "[AutoTreadmill] Running on treadmill (Waiting for eggs...)"
        return true
    else
        h.onTreadmill = false
        t(string.format("[AutoTreadmill] Not yet at treadmill pad (dist=%.1f studs). Will retry!", dist))
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
    local lowerName = string.lower(tostring(name or ""))
    if lowerName ~= "" and lowerName ~= "egg" then
        -- mapping omitted for brevity, same as original
    end
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
    local function fmt(n)
        n = tonumber(n) or 0
        if n >= 1e12 then return string.format("%.1fT", n / 1e12) end
        if n >= 1e9 then return string.format("%.1fB", n / 1e9) end
        if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
        if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
        return string.format("%.0f", n)
    end
    local function getRarity(rec, cat, explicit, rank)
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
    local function score(rec, forceAll)
        local candidates = {}
        for _, r in ipairs(list) do
            local available = (r.State == "Slot" or r.State == "Dropped" or r.State == "GuardCarried" or r.State == 1)
            local blocked = (r.BoundsCFrame and r.BoundsCFrame.Position.X < 530) or string.find(tostring(r.Uid), "FirstArea")
            local cooled = X4[r.Uid] and (os.clock() < X4[r.Uid])
            if available and not blocked and r.BoundsCFrame and (forceAll or not cooled) then
                local cat = r.AssetCategory or "Egg"
                local pos = r.BoundsCFrame.Position
                local area = r.AreaId
                if (not area or area == "" or area == "Unknown") and r.PhysicalModel then
                    area = r.PhysicalModel:GetAttribute("AreaId") or r.PhysicalModel:GetAttribute("Area")
                end
                local combined = string.format("%s %s %s %s", tostring(cat or ""), tostring(r.Uid or ""), tostring(r.Name or ""), (r.PhysicalModel and r.PhysicalModel.Name) or "")
                local zone = Dk(area, pos, combined)
                local tier, rarName = getRarity(r, cat, nil, nil)
                local isSecret = (tier >= 4 or rarName == "Secret" or rarName == "Eternal" or rarName == "Divine")
                local zoneOk = (h.selectedZones and h.selectedZones[zone] == true)
                local rarOk = (h.selectedRarities and h.selectedRarities[rarName] == true)
                local allowed = isSecret or (zoneOk and rarOk)
                if allowed then
                    local income = 0
                    local scale = tonumber(r.AssetScale or r.Scale) or 1
                    local dist = ((myPos - r.BoundsCFrame.Position)).Magnitude
                    table.insert(candidates, {
                        Uid = r.Uid, Category = cat, Area = zone,
                        ZoneWeight = f[zone] or 50,
                        Rarity = rarName, RarityTier = tier,
                        RealIncome = income, Scale = scale,
                        CFrame = r.BoundsCFrame, Position = r.BoundsCFrame.Position,
                        Distance = dist, Model = r.PhysicalModel
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
    local target = score(nil, false)
    if not target then
        X4 = {}
        target = score(nil, true)
    end
    if not target then
        list = h4(true)
        target = score(nil, true)
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
    H(string.format("[GuardStrike] Step 1: Lifting target egg (%s)...", tostring(uid)))
    local deadline = os.clock() + 3.5
    local lastCheck = 0
    while not w4() and os.clock() < deadline and h.alive and h.securingEgg do
        if sess and O4 ~= sess then break end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.teleporting then break end
        if uid and (os.clock() - lastCheck > 0.4) then
            lastCheck = os.clock()
            local ok, reason = k4(uid)
            if not ok and reason == "CarriedByOther" then
                t(string.format("[GuardStrike] Target egg %s was snatched! Aborting...", tostring(uid)))
                break
            end
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
        t("[GuardStrike] Initial egg pickup timed out")
        if uid then X4[uid] = os.clock() + 2 end
        h.currentTargetModel = nil
        h.targetPosition = nil
        h.securingEgg = false
        h.holdingEggForGuard = false
        return false
    end
    h.statusText = "[2/4] Waiting for Guard Strike..."
    H("[GuardStrike] Step 2: Egg lifted! Triggering guard strike...")
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
    H("[GuardStrike] Step 3: Guard struck! Re-grabbing egg...")
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
        H("[GuardStrike] Egg successfully secured! Stashed in backpack.")
        h.statusText = "Egg Secured!"
    else
        t("[-] Failed to re-grab egg after guard strike")
        h.statusText = "[-] Failed to re-grab egg"
        if uid then X4[uid] = os.clock() + 2 end
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
            t(string.format("[Snipe] Target egg %s taken (%s)! Selecting next...", tostring(uid), tostring(reason)))
            h.statusText = "Target taken!"
            X4[uid] = os.clock() + 5
            D4()
            return false
        end
    end
    local heldUid = select(2, e4())
    if not heldUid then
        local lakeEgg = P4()
        if not lakeEgg then
            t("[-] Lake egg not found")
            h.statusText = "[-] No Lake egg found"
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
            h.statusText = string.format("[2/7] Gliding to Lake Egg (%.0f studs)...", dist)
            h.glidingToTarget = true
            local ok = R4(align, h.glideSpeed, lakeEgg.Uid, sess)
            h.glidingToTarget = false
            if not ok then
                t("[-] Lake starter egg taken during flight")
                X4[lakeEgg.Uid] = os.clock() + 5
                D4()
                return false
            end
        else
            h.statusText = "[2/7] Aligning with Lake Egg..."
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
            t("[-] Lake egg pickup failed")
            h.statusText = "[-] Lake pickup failed"
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
        t("[-] No bounce detected, aborting")
        h.statusText = "[-] Aborted (No bounce)"
        D4()
        pcall(u4)
        return false
    end
    task.wait(0.05)
    if uid then
        local ok, reason = k4(uid)
        if not ok and reason == "CarriedByOther" then
            t(string.format("[Snipe] Target %s snatched during bounce!", tostring(uid)))
            h.statusText = "Target taken!"
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
        t("[-] Guard Strike criteria not met")
        h.statusText = "[-] Guard Strike failed"
        D4()
        return false
    else
        h.statusText = "[7/7] Target Secured!"
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
                H("[FarmController] Pure Auto Steal (Tween) ACTIVATED.")
            elseif mode == "WARP" then
                h.autoFarmLoop = true
                h.pureTweenFarm = false
                pcall(u4)
                H("[FarmController] Snipe Auto Loop (Warp) ACTIVATED.")
            else
                h.pureTweenFarm = false
                h.autoFarmLoop = false
                if not h.isBatchPlacing then h.batchStealCount = 0 end
                H("[FarmController] All farms DEACTIVATED.")
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
                            if h.onTreadmill or L4() then
                                h.statusText = "[AutoSteal] Target found! Getting off treadmill..."
                                M4()
                                task.wait(0.08)
                            end
                            local ok2, reason = k4(target.Uid)
                            if not ok2 and reason ~= "CarriedBySelf" then
                                H(string.format("[AutoSteal] Egg %s taken (%s). Next...", tostring(target.Uid), tostring(reason)))
                                X4[target.Uid] = os.clock() + 5
                                task.wait(0.12)
                                return
                            end
                            h.currentTargetModel = target.Model
                            h.targetPosition = target.Position
                            h.glidingToTarget = true
                            h.stateTime = os.clock()
                            local extra = (target.Scale and target.Scale > 1.05) and string.format(" | %.1fx", target.Scale) or ""
                            h.statusText = string.format("[AutoSteal] Flying to %s (%s%s)...", tostring(target.Category or "Egg"), tostring(target.Area or "Field"), extra)
                            if not h.swapped then A4() end
                            if not h.godmode then b4(true) end
                            Z4(char)
                            pcall(function(...) o:RequestStreamAroundAsync(target.Position) end)
                            local align = target.CFrame * CFrame.new(0, 0.4, 0)
                            local flew = R4(align, h.glideSpeed, target.Uid, sess)
                            h.glidingToTarget = false
                            if O4 ~= sess or not h.pureTweenFarm or Y4 ~= "TWEEN" then return end
                            if not flew then
                                t("[AutoSteal] Egg taken during flight. Next target...")
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
                                        h.statusText = "[AutoSteal] Secured! Returning to Safe Line..."
                                        H("[AutoSteal] Egg secured! Returning to Safe Line X=525...")
                                        Q4(h.glideSpeed, sess)
                                        pcall(u4)
                                        local count = y4()
                                        h.statusText = string.format("Stashed in Bag (%d Eggs). Next steal...", count)
                                    else
                                        h.statusText = "[AutoSteal] Secured! (Auto Return OFF)"
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
                                        t("[AutoSteal] Guard Strike failed. Next egg...")
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
                                if not h.onTreadmill and not L4() then
                                    h.statusText = "[AutoTreadmill] Idle. Mounting treadmill..."
                                    f4()
                                else
                                    h.statusText = "[AutoTreadmill] Running on treadmill..."
                                end
                            else
                                h.statusText = "[AutoSteal] Scanning for targets..."
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            t("[AutoSteal Loop Recovered]:", tostring(err))
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
                            if h.onTreadmill or L4() then
                                h.statusText = "[SnipeLoop] Target found! Leaving treadmill..."
                                M4()
                                task.wait(0.08)
                            end
                            local extra = (target.Scale and target.Scale > 1.05) and string.format(" | %.1fx", target.Scale) or ""
                            H(string.format("[SnipeLoop] Starting Warp Snipe: %s | Zone: %s%s", tostring(target.Category or "Egg"), tostring(target.Area or "Field"), extra))
                            h.statusText = string.format("[SnipeLoop] Warping for %s%s...", tostring(target.Category or "Egg"), extra)
                            local secured = l4(target, sess)
                            if O4 ~= sess or not h.autoFarmLoop or Y4 ~= "WARP" then return end
                            if secured then
                                pcall(u4)
                                if h.autoGlide then
                                    h.statusText = "[SnipeLoop] Secured! Returning to Safe Line..."
                                    Q4(h.glideSpeed, sess)
                                    pcall(u4)
                                    local count = y4()
                                    h.statusText = string.format("Stashed in Bag (%d Eggs). Next snipe...", count)
                                else
                                    h.statusText = "[SnipeLoop] Secured! (Auto Return OFF)"
                                end
                                pcall(u4)
                                h.isReturning = false
                                h.delivering = false
                                if c4("WARP") then return end
                            else
                                if O4 == sess and h.autoFarmLoop and Y4 == "WARP" then
                                    t("[SnipeLoop] Snipe failed. Resetting...")
                                    if target and target.Uid then X4[target.Uid] = os.clock() + 5 end
                                    pcall(D4)
                                end
                            end
                        else
                            if os.clock() - qk > 5 then X4 = {} qk = os.clock() end
                            if h.autoTreadmill and not h.isBatchPlacing and not h.isHatching then
                                if not h.onTreadmill and not L4() then
                                    h.statusText = "[AutoTreadmill] Idle. Mounting treadmill..."
                                    f4()
                                else
                                    h.statusText = "[AutoTreadmill] Running on treadmill..."
                                end
                            else
                                h.statusText = "[SnipeLoop] Searching for targets..."
                            end
                        end
                    end
                end
            end
        end)
        if not ok then
            t("[SnipeLoop Loop Recovered]:", tostring(err))
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
                    if not h.onTreadmill and not L4() then
                        h.statusText = "[AutoTreadmill] Idle without farm. Mounting..."
                        f4()
                    end
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
        local esp = r:FindFirstChild("LunarisHub_EggESP")
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

local zk = "Lunaris_Hub_Icon.png"
local dk = "rbxassetid://10734950309"
pcall(function(...)
    if writefile and (getcustomasset or getsynasset) then
        local getAsset = getcustomasset or getsynasset
        if not (isfile and isfile(zk)) then writefile(zk, Zk(Sk)) end
        dk = getAsset(zk)
    end
end)

-- ==============================================================================
-- TRANSLATIONS
-- ==============================================================================
local Xk = currentLang or "EN"
local Gk = {
    ["EN"] = {
        ["StatusTagReady"] = "Status: Ready",
        ["Tabs"] = {["Farm"] = "Auto Farm", ["EggSelect"] = "Egg Selection", ["Character"] = "Character", ["Settings"] = "Settings"},
        ["EggSelect"] = {
            ["SecZones"] = "Target Zones", ["SecZonesDesc"] = "Select zones to steal from",
            ["DropZonesTitle"] = "Selected Zones", ["DropZonesDesc"] = "Click to choose zones",
            ["SecRarities"] = "Target Rarities", ["SecRaritiesDesc"] = "Select egg rarities",
            ["DropRaritiesTitle"] = "Selected Rarities", ["DropRaritiesDesc"] = "Click to choose",
            ["AlwaysSecretPlus"] = "Always Steal Secret+", ["AlwaysSecretPlusDesc"] = "Secret+ from any zone"
        },
        ["Farm"] = {
            ["SecModes"] = "Auto Steal Modes", ["TweenTitle"] = "Auto Steal (Tween)",
            ["TweenDesc"] = "Smoothly fly to steal eggs", ["TeleportTitle"] = "Auto Steal (Teleport)",
            ["TeleportDesc"] = "Instantly warp to steal eggs", ["SingleTitle"] = "Single Steal",
            ["SingleDesc"] = "Teleport to steal 1 egg", ["SecPlace"] = "Place & Hatch",
            ["PlaceTitle"] = "Place Eggs", ["PlaceDesc"] = "Fly home, place eggs",
            ["AutoPlaceTitle"] = "Auto Place (Every 5)", ["AutoPlaceDesc"] = "Return home every 5",
            ["HatchTitle"] = "Auto Hatch", ["HatchDesc"] = "Hatch ready eggs",
            ["ReturnTitle"] = "Auto Return", ["ReturnDesc"] = "Auto return after stealing",
            ["AutoTreadmillTitle"] = "Auto Treadmill", ["AutoTreadmillDesc"] = "Run on treadmill when idle",
            ["UpgradeTreadmillTitle"] = "Auto Upgrade Treadmill", ["UpgradeTreadmillDesc"] = "Upgrade treadmill",
            ["BuyTrailsTitle"] = "Auto Buy Trails", ["BuyTrailsDesc"] = "Buy best speed trail",
            ["HideNotEnoughMoneyTitle"] = "Hide 'Not Enough Money'", ["HideNotEnoughMoneyDesc"] = "Suppress red alert"
        },
        ["Character"] = {
            ["SecSafety"] = "Character & Safety", ["GodmodeTitle"] = "Godmode", ["GodmodeDesc"] = "Full immunity",
            ["UnstickTitle"] = "Get Unstuck", ["UnstickDesc"] = "Escape treadmill",
            ["SecFlight"] = "Flight Settings", ["SpeedTitle"] = "Flight Speed", ["SpeedDesc"] = "Cruise flight speed"
        },
        ["Settings"] = {
            ["SecDashboard"] = "Live Dashboard", ["DashTitle"] = "Live Dashboard",
            ["DashDesc"] = "Status: %s | Farm: %s | Eggs: %d | Speed: %d",
            ["SecBlacklist"] = "Zone Preferences", ["BlacklistToggleTitle"] = "Zone: %s", ["BlacklistToggleDesc"] = "Enable %s",
            ["SecUI"] = "UI Customization", ["TranspTitle"] = "Transparency", ["TranspDesc"] = "Adjust UI transparency",
            ["ThemeTitle"] = "Theme", ["SecPerformance"] = "Performance",
            ["PerformanceTitle"] = "Ultra Potato Mode", ["PerformanceDesc"] = "Disables textures/effects",
            ["Disable3DTitle"] = "Disable 3D Rendering", ["Disable3DDesc"] = "Freeze viewport",
            ["LangTitle"] = "Language", ["BtnTranslate"] = "Switch to Thai", ["DescTranslate"] = "Switch to Thai",
            ["SecSystem"] = "System", ["AntiAFKTitle"] = "Anti-AFK", ["AntiAFKDesc"] = "Resets idle timer",
            ["ResetTitle"] = "Reset Character", ["ResetDesc"] = "Clear internal states",
            ["RejoinTitle"] = "Rejoin Server", ["RejoinDesc"] = "Reconnect",
            ["UnloadTitle"] = "Unload Script", ["UnloadDesc"] = "Terminate all loops"
        },
        ["Notifications"] = {
            ["PlaceStarted"] = "Flying back to place eggs...", ["PlaceDone"] = "Eggs placed!",
            ["AutoPlaceStarted"] = "Auto Place enabled", ["AutoPlaceStopped"] = "Auto Place disabled",
            ["NoEggFound"] = "No eligible eggs", ["UnstickDone"] = "Unstick sent!",
            ["TweenStarted"] = "Auto Steal (Tween) ON", ["TweenStopped"] = "Auto Steal (Tween) OFF",
            ["TeleportStarted"] = "Auto Steal (Warp) ON", ["TeleportStopped"] = "Auto Steal (Warp) OFF",
            ["HatchStarted"] = "Auto Hatch ON", ["HatchStopped"] = "Auto Hatch OFF",
            ["ReturnStarted"] = "Auto Return ON", ["ReturnStopped"] = "Auto Return OFF",
            ["AutoTreadmillStarted"] = "Auto Treadmill ON", ["AutoTreadmillStopped"] = "Auto Treadmill OFF",
            ["UpgradeTreadmillStarted"] = "Upgrade Treadmill ON", ["UpgradeTreadmillStopped"] = "Upgrade Treadmill OFF",
            ["BuyTrailsStarted"] = "Buy Trails ON", ["BuyTrailsStopped"] = "Buy Trails OFF",
            ["HideNotEnoughMoneyStarted"] = "Hide alerts ON", ["HideNotEnoughMoneyStopped"] = "Hide alerts OFF",
            ["GodmodeStarted"] = "Godmode ON", ["GodmodeStopped"] = "Godmode OFF",
            ["PerformanceStarted"] = "Performance Mode ON", ["PerformanceStopped"] = "Performance Mode OFF",
            ["Disable3DStarted"] = "3D Rendering OFF", ["Disable3DStopped"] = "3D Rendering ON",
            ["AntiAFKStarted"] = "Anti-AFK ON", ["AntiAFKStopped"] = "Anti-AFK OFF",
            ["LangSwitched"] = "Language switched to English!"
        }
    }
}
-- Add Thai as alias to EN to keep script small
Gk["TH"] = Gk["EN"]

local Fk = {}
local hk, Ok, Yk, Tk
local xk = {"Farm", "EggSelect", "Character", "Settings"}

local function Wk(lang, ...)
    local isTH = (lang == "TH")
    if h.delivering then return isTH and "กำลังวางไข่" or "Placing Egg"
    elseif h.securingEgg or h.holdingEggForGuard then return isTH and "กำลังหยิบไข่" or "Securing Egg"
    elseif h.teleporting then return isTH and "กำลังวาร์ป" or "Teleporting"
    elseif h.isReturning then return isTH and "กำลังบินกลับ" or "Returning"
    elseif h.glidingToTarget then return isTH and "กำลังบิน" or "Stealing"
    elseif h.onTreadmill or (L4 and L4()) then return isTH and "อยู่บนลู่วิ่ง" or "On Treadmill"
    elseif Y4 == "TWEEN" and not h.isReturning then return isTH and "กำลังหาไข่" or "Searching"
    elseif Y4 == "WARP" and not h.isReturning then return isTH and "กำลังหาไข่" or "Searching"
    else return isTH and "พร้อม" or "Ready" end
end

local function mk(inst, ...)
    pcall(function(...)
        if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
            inst.AutoLocalize = false
        end
        for _, obj in ipairs(inst:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                obj.AutoLocalize = false
            end
        end
    end)
end

-- ==============================================================================
-- LOADER SCREEN
-- ==============================================================================
local function jM(...)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Lunaris_LOADER_SCREEN"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 9999999
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
    
    local card = Instance.new("Frame")
    card.Name = "Card"
    card.Size = UDim2.fromOffset(360, 160)
    card.Position = UDim2.new(0.5, -180, 0.5, -80)
    card.BackgroundColor3 = RB.Bg
    card.BorderSizePixel = 0
    card.Parent = screenGui
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
    
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = RB.Red
    stroke.Thickness = 1.4
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local logoDot = Instance.new("Frame")
    logoDot.Size = UDim2.fromOffset(20, 20)
    logoDot.Position = UDim2.new(0, 14, 0, 14)
    logoDot.BackgroundColor3 = RB.Red
    logoDot.BorderSizePixel = 0
    logoDot.Parent = card
    Instance.new("UICorner", logoDot).CornerRadius = UDim.new(1, 0)
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -56, 0, 22)
    titleLbl.Position = UDim2.new(0, 42, 0, 13)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "Lunaris Hub"
    titleLbl.TextColor3 = RB.RedGlow
    titleLbl.TextSize = 18
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.AutoLocalize = false
    titleLbl.Parent = card
    
    local creditsLbl = Instance.new("TextLabel")
    creditsLbl.Size = UDim2.new(1, -28, 0, 14)
    creditsLbl.Position = UDim2.new(0, 14, 0, 38)
    creditsLbl.BackgroundTransparency = 1
    creditsLbl.Text = CREDITS_FULL
    creditsLbl.TextColor3 = RB.RedBright
    creditsLbl.TextSize = 10
    creditsLbl.Font = Enum.Font.GothamBold
    creditsLbl.TextXAlignment = Enum.TextXAlignment.Left
    creditsLbl.AutoLocalize = false
    creditsLbl.Parent = card
    
    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -28, 0, 14)
    subLbl.Position = UDim2.new(0, 14, 0, 54)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Steal an Egg Suite v42.64"
    subLbl.TextColor3 = RB.Sub
    subLbl.TextSize = 11
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.AutoLocalize = false
    subLbl.Parent = card
    
    local pctLbl = Instance.new("TextLabel")
    pctLbl.Size = UDim2.new(0, 50, 0, 24)
    pctLbl.Position = UDim2.new(1, -64, 0, 14)
    pctLbl.BackgroundTransparency = 1
    pctLbl.Text = "0%"
    pctLbl.TextColor3 = RB.RedBright
    pctLbl.TextSize = 14
    pctLbl.Font = Enum.Font.GothamBold
    pctLbl.TextXAlignment = Enum.TextXAlignment.Right
    pctLbl.AutoLocalize = false
    pctLbl.Parent = card
    
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -28, 0, 10)
    barBg.Position = UDim2.new(0, 14, 0, 86)
    barBg.BackgroundColor3 = RB.RedDeep
    barBg.BorderSizePixel = 0
    barBg.Parent = card
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 5)
    
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = RB.Red
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 5)
    
    local grad = Instance.new("UIGradient", barFill)
    grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, RB.Red), ColorSequenceKeypoint.new(1, RB.RedGlow)})
    
    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, -28, 0, 16)
    statusLbl.Position = UDim2.new(0, 14, 0, 106)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "Initializing Lunaris Hub..."
    statusLbl.TextColor3 = RB.Muted
    statusLbl.TextSize = 11
    statusLbl.Font = Enum.Font.Gotham
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.AutoLocalize = false
    statusLbl.Parent = card
    
    task.spawn(function(...)
        for i = 1, 100 do
            if not screenGui.Parent then break end
            pctLbl.Text = tostring(i) .. "%"
            barFill.Size = UDim2.new(i / 100, 0, 1, 0)
            if i == 25 then statusLbl.Text = "Loading interface modules..."
            elseif i == 60 then statusLbl.Text = "Setting up auto-steal controllers..."
            elseif i == 85 then statusLbl.Text = "Syncing server telemetry..."
            elseif i == 100 then statusLbl.Text = "Ready!" end
            task.wait(0.008)
        end
    end)
    
    return function(callback)
        task.spawn(function(...)
            task.wait(0.9)
            local tween = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            TweenService:Create(card, tween, {BackgroundTransparency = 1}):Play()
            TweenService:Create(stroke, tween, {Transparency = 1}):Play()
            TweenService:Create(titleLbl, tween, {TextTransparency = 1}):Play()
            TweenService:Create(creditsLbl, tween, {TextTransparency = 1}):Play()
            TweenService:Create(subLbl, tween, {TextTransparency = 1}):Play()
            TweenService:Create(pctLbl, tween, {TextTransparency = 1}):Play()
            TweenService:Create(barBg, tween, {BackgroundTransparency = 1}):Play()
            TweenService:Create(barFill, tween, {BackgroundTransparency = 1}):Play()
            TweenService:Create(statusLbl, tween, {TextTransparency = 1}):Play()
            task.wait(0.4)
            pcall(function(...) screenGui:Destroy() end)
            if callback then callback() end
        end)
    end
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
        local esp = r:FindFirstChild("LunarisHub_EggESP")
        if esp then esp:Destroy() end
    end)
    pcall(D4)
    pcall(u4)
    if h.gui then pcall(function(...) h.gui:Destroy() end) end
    pcall(function(...)
        for _, gui in ipairs(game.CoreGui:GetChildren()) do
            if gui.Name:find("Lunaris_") or gui.Name:find("DesyncSniperUI") then
                gui:Destroy()
            end
        end
    end)
end

-- ==============================================================================
-- MAIN UI
-- ==============================================================================
local function oM(...)
    local done = jM()
    
    local windlib = nil
    pcall(function(...)
        windlib = (loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")))()
    end)
    
    local function notify(opts)
        if not opts then return end
        local sent = false
        if windlib and windlib.Notify then
            local ok = pcall(function(...) windlib:Notify(opts) sent = true end)
        end
        if not sent then
            pcall(function(...)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = tostring(opts.Title or "Lunaris Hub • Antrax"),
                    Text = tostring(opts.Content or ""),
                    Duration = 3
                })
            end)
        end
    end
    
    if windlib then
        pcall(function(...)
            local origNotify = windlib.Notify
            if origNotify then
                windlib.Notify = function(self, opts, ...)
                    local ok = pcall(function(...) origNotify(self, opts) end)
                    if not ok then
                        pcall(function(...)
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = tostring(opts and opts.Title or "Lunaris Hub • Antrax"),
                                Text = tostring(opts and opts.Content or ""),
                                Duration = 3
                            })
                        end)
                    end
                end
            end
        end)
        
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
        local isTouch = w.TouchEnabled and not w.KeyboardEnabled
        local winW = isTouch and math.clamp(vp.X * 0.7, 440, 500) or 500
        local winH = isTouch and math.clamp(vp.Y * 0.72, 280, 340) or 340
        local winSize = UDim2.fromOffset(winW, winH)
        
        local win = windlib:CreateWindow({
            Title = "Lunaris • Antrax Edition",
            Author = CREDITS_FULL,
            Folder = "Lunaris_StealAnEgg",
            Icon = dk,
            Theme = "Dark",
            IconSize = 28,
            Size = winSize,
            MinSize = Vector2.new(400, 240),
            MaxSize = Vector2.new(900, 600),
            Resizable = true,
            SideBarWidth = isTouch and 140 or 160,
            ToggleKey = Enum.KeyCode.RightShift,
            IgnoreAlerts = true,
            Topbar = {Height = 44, ButtonsType = "Default"}
        })
        
        Window = win
        win.IgnoreAlerts = true
        pcall(function(...)
            if win.UIElements and win.UIElements.Main then
                win.UIElements.Main.Visible = false
            end
        end)
        
        local statusTag = win:Tag({Title = "Status: Ready", Color = RB.RedBright, Border = true})
        
        -- Credits badge
        pcall(function(...)
            if win.UIElements and win.UIElements.Main then
                local badge = Instance.new("Frame")
                badge.Name = "CreditsBadge"
                badge.Size = UDim2.fromOffset(180, 20)
                badge.Position = UDim2.new(1, -190, 0, 4)
                badge.BackgroundColor3 = RB.RedDeep
                badge.BorderSizePixel = 0
                badge.ZIndex = 9999
                badge.Parent = win.UIElements.Main
                Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)
                local badgeStroke = Instance.new("UIStroke", badge)
                badgeStroke.Color = RB.Red
                badgeStroke.Thickness = 1
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.fromScale(1, 1)
                lbl.BackgroundTransparency = 1
                lbl.Text = CREDITS_FULL
                lbl.TextColor3 = RB.RedGlow
                lbl.TextSize = 10
                lbl.Font = Enum.Font.GothamBold
                lbl.Parent = badge
            end
        end)
        
        local P = Gk[Xk] or Gk.EN
        hk = win:Tab({Title = P.Tabs.Farm, Icon = "solar:box-minimalistic-bold"})
        Ok = win:Tab({Title = P.Tabs.EggSelect, Icon = "lucide:egg"})
        Yk = win:Tab({Title = P.Tabs.Character, Icon = "solar:user-bold"})
        Tk = win:Tab({Title = P.Tabs.Settings, Icon = "solar:settings-bold"})
        
        Fk.secModes = hk:Section({Title = P.Farm.SecModes})
        
        local updating = false
        local tweenToggle, warpToggle
        
        Fk.togTween = hk:Toggle({
            Title = P.Farm.TweenTitle, Desc = P.Farm.TweenDesc,
            Icon = "solar:compass-bold", Value = h.pureTweenFarm,
            Callback = function(v, ...)
                if updating then return end
                if v then T4("TWEEN")
                else
                    if Y4 == "TWEEN" or h.pureTweenFarm then T4("NONE") end
                end
            end
        })
        tweenToggle = Fk.togTween
        
        Fk.togTeleport = hk:Toggle({
            Title = P.Farm.TeleportTitle, Desc = P.Farm.TeleportDesc,
            Icon = "solar:magic-stick-3-bold", Value = h.autoFarmLoop,
            Callback = function(v, ...)
                if updating then return end
                if v then T4("WARP")
                else
                    if Y4 == "WARP" or h.autoFarmLoop then T4("NONE") end
                end
            end
        })
        warpToggle = Fk.togTeleport
        
        x4 = function(v, silent, ...)
            pcall(function(...)
                if tweenToggle and tweenToggle.Set then
                    updating = true
                    tweenToggle:Set(v)
                    updating = false
                end
            end)
        end
        W4 = function(v, silent, ...)
            pcall(function(...)
                if warpToggle and warpToggle.Set then
                    updating = true
                    warpToggle:Set(v)
                    updating = false
                end
            end)
        end
        
        Fk.secPlace = hk:Section({Title = P.Farm.SecPlace})
        
        Fk.btnPlaceEgg = hk:Button({
            Title = P.Farm.PlaceTitle, Desc = P.Farm.PlaceDesc, Icon = "solar:box-bold",
            Callback = function(...)
                task.spawn(function(...)
                    notify({Title = "Lunaris Hub • Antrax", Content = Gk[Xk].Notifications.PlaceStarted, Icon = "loader"})
                    h.statusText = "[Manual] Tweening to base..."
                    v4(h.glideSpeed, nil, true)
                    notify({Title = "Lunaris Hub • Antrax", Content = Gk[Xk].Notifications.PlaceDone, Icon = "check-circle"})
                end)
            end
        })
        
        Fk.togAutoPlaceEvery5 = hk:Toggle({
            Title = P.Farm.AutoPlaceTitle, Desc = P.Farm.AutoPlaceDesc,
            Icon = "solar:box-minimalistic-bold", Value = h.autoPlaceEvery5,
            Callback = function(v, ...)
                h.autoPlaceEvery5 = v
                if not v then h.batchStealCount = 0 end
                local r = Gk[Xk] or Gk.EN
                notify({Title = "Auto Place (Every 5)", Content = v and r.Notifications.AutoPlaceStarted or r.Notifications.AutoPlaceStopped, Icon = v and "check-circle" or "x-circle"})
            end
        })
        
        Fk.togAutoHatch = hk:Toggle({
            Title = P.Farm.HatchTitle, Desc = P.Farm.HatchDesc,
            Icon = "solar:star-bold", Value = h.autoHatch,
            Callback = function(v, ...)
                h.autoHatch = v
                notify({Title = "Auto Hatch", Content = v and Gk[Xk].Notifications.HatchStarted or Gk[Xk].Notifications.HatchStopped, Icon = v and "check-circle" or "x-circle"})
            end
        })
        
        Fk.togAutoReturn = hk:Toggle({
            Title = P.Farm.ReturnTitle, Desc = P.Farm.ReturnDesc,
            Icon = "solar:undo-left-round-bold", Value = h.autoGlide,
            Callback = function(v, ...)
                h.autoGlide = v
                notify({Title = "Auto Return", Content = v and Gk[Xk].Notifications.ReturnStarted or Gk[Xk].Notifications.ReturnStopped, Icon = v and "check-circle" or "x-circle"})
            end
        })
        
        Fk.togAutoTreadmill = hk:Toggle({
            Title = P.Farm.AutoTreadmillTitle, Desc = P.Farm.AutoTreadmillDesc,
            Icon = "solar:running-bold", Value = h.autoTreadmill,
            Callback = function(v, ...)
                h.autoTreadmill = v
                x() n4()
                if not v and (h.onTreadmill or L4()) then M4() end
                local r = Gk[Xk] or Gk.EN
                notify({Title = "Auto Treadmill", Content = v and r.Notifications.AutoTreadmillStarted or r.Notifications.AutoTreadmillStopped, Icon = v and "check-circle" or "x-circle"})
            end
        })
        
        Fk.togAutoUpgradeTreadmill = hk:Toggle({
            Title = P.Farm.UpgradeTreadmillTitle, Desc = P.Farm.UpgradeTreadmillDesc,
            Icon = "solar:double-alt-arrow-up-bold", Value = h.autoUpgradeTreadmill,
            Callback = function(v, ...)
                h.autoUpgradeTreadmill = v
                x()
                local r = Gk[Xk] or Gk.EN
                notify({Title = "Upgrade Treadmill", Content = v and r.Notifications.UpgradeTreadmillStarted or r.Notifications.UpgradeTreadmillStopped, Icon = v and "check-circle" or "x-circle"})
            end
        })
        
        Fk.togAutoBuyTrails = hk:Toggle({
            Title = P.Farm.BuyTrailsTitle, Desc = P.Farm.BuyTrailsDesc,
            Icon = "solar:fire-bold", Value = h.autoBuyTrails,
            Callback = function(v, ...)
                h.autoBuyTrails = v
                x()
                local r = Gk[Xk] or Gk.EN
                notify({Title = "Buy Trails", Content = v and r.Notifications.BuyTrailsStarted or r.Notifications.BuyTrailsStopped, Icon = v and "check-circle" or "x-circle"})
            end
        })
        
        Fk.secEggZones = Ok:Section({Title = P.EggSelect.SecZones})
        
        local zoneValues = {"🟣 Light Dark", "🟡 Titan Temple", "🌸 Cherry Blossom", "🌌 Cosmic", "🦖 Prehistoric", "🌊 Abyss Ocean", "🌋 Volcano", "❄️ Snow", "🌴 Jungle", "🏜️ Desert", "💧 Lake", "🌲 Forest"}
        local zoneToKey = {["🟣 Light Dark"] = "Light Dark", ["🟡 Titan Temple"] = "Titan Temple", ["🌸 Cherry Blossom"] = "Cherry Blossom", ["🌌 Cosmic"] = "Cosmic", ["🦖 Prehistoric"] = "Prehistoric", ["🌊 Abyss Ocean"] = "Abyss Ocean", ["🌋 Volcano"] = "Volcano", ["❄️ Snow"] = "Snow", ["🌴 Jungle"] = "Jungle", ["🏜️ Desert"] = "Desert", ["💧 Lake"] = "Lake", ["🌲 Forest"] = "Forest"}
        local keyToZone = {["Light Dark"] = "🟣 Light Dark", ["Titan Temple"] = "🟡 Titan Temple", ["Cherry Blossom"] = "🌸 Cherry Blossom", ["Cosmic"] = "🌌 Cosmic", ["Prehistoric"] = "🦖 Prehistoric", ["Abyss Ocean"] = "🌊 Abyss Ocean", ["Volcano"] = "🌋 Volcano", ["Snow"] = "❄️ Snow", ["Jungle"] = "🌴 Jungle", ["Desert"] = "🏜️ Desert", ["Lake"] = "💧 Lake", ["Forest"] = "🌲 Forest"}
        local selectedZones = {}
        for k, v in pairs(h.selectedZones or {}) do
            if v and keyToZone[k] then table.insert(selectedZones, keyToZone[k]) end
        end
        
        Fk.dropTargetZones = Ok:Dropdown({
            Title = P.EggSelect.DropZonesTitle, Desc = P.EggSelect.DropZonesDesc,
            Values = zoneValues, Value = selectedZones, Multi = true,
            Callback = function(v, ...)
                local newZones = {}
                local function add(entry)
                    if type(entry) == "table" then entry = entry.Title or entry.Name or entry[1] or "" end
                    local s = tostring(entry or "")
                    local key = zoneToKey[s]
                    if not key and s ~= "" and s ~= "true" and s ~= "false" then
                        for _, z in ipairs(M) do
                            if string.find(string.lower(s), string.lower(z)) then key = z break end
                        end
                    end
                    if key and f[key] then newZones[key] = true end
                end
                if type(v) == "table" then
                    for k, val in pairs(v) do
                        if type(val) == "string" or type(val) == "table" then add(val)
                        elseif type(k) == "string" and val == true then add(k) end
                    end
                elseif type(v) == "string" then add(v) end
                h.selectedZones = newZones
                x()
            end
        })
        
        Fk.secEggRarity = Ok:Section({Title = P.EggSelect.SecRarities})
        
        local rarityValues = {"👑 Divine", "⚡ Eternal", "🔥 Secret", "✨ Cosmic", "🔮 Mythic", "⭐ Legendary", "💜 Epic", "🔷 Rare", "🟢 Uncommon", "⚪ Common"}
        local rarityToKey = {["👑 Divine"] = "Divine", ["⚡ Eternal"] = "Eternal", ["🔥 Secret"] = "Secret", ["✨ Cosmic"] = "Cosmic", ["🔮 Mythic"] = "Mythic", ["⭐ Legendary"] = "Legendary", ["💜 Epic"] = "Epic", ["🔷 Rare"] = "Rare", ["🟢 Uncommon"] = "Uncommon", ["⚪ Common"] = "Common"}
        local keyToRarity = {["Divine"] = "👑 Divine", ["Eternal"] = "⚡ Eternal", ["Secret"] = "🔥 Secret", ["Cosmic"] = "✨ Cosmic", ["Mythic"] = "🔮 Mythic", ["Legendary"] = "⭐ Legendary", ["Epic"] = "💜 Epic", ["Rare"] = "🔷 Rare", ["Uncommon"] = "🟢 Uncommon", ["Common"] = "⚪ Common"}
        local selectedRarities = {}
        for k, v in pairs(h.selectedRarities or {}) do
            if v and keyToRarity[k] then table.insert(selectedRarities, keyToRarity[k]) end
        end
        
        Fk.dropTargetRarities = Ok:Dropdown({
            Title = P.EggSelect.DropRaritiesTitle, Desc = P.EggSelect.DropRaritiesDesc,
            Values = rarityValues, Value = selectedRarities, Multi = true,
            Callback = function(v, ...)
                local newRar = {}
                local function add(entry)
                    if type(entry) == "table" then entry = entry.Title or entry.Name or entry[1] or "" end
                    local s = string.lower(tostring(entry or ""))
                    for _, r in ipairs(X) do
                        if string.find(s, string.lower(r)) then newRar[r] = true break end
                    end
                end
                if type(v) == "table" then
                    for k, val in pairs(v) do
                        if type(val) == "string" or type(val) == "table" then add(val)
                        elseif type(k) == "string" and val == true then add(k) end
                    end
                elseif type(v) == "string" then add(v) end
                h.selectedRarities = newRar
                x()
            end
        })
        
        Fk.secSafety = Yk:Section({Title = P.Character.SecSafety})
        
        Fk.togGodmode = Yk:Toggle({
            Title = P.Character.GodmodeTitle, Desc = P.Character.GodmodeDesc,
            Icon = "solar:shield-check-bold", Value = false,
            Callback = function(v, ...)
                if v then
                    enableDesyncGodmode()
                    notify({Title = "Godmode", Content = Gk[Xk].Notifications.GodmodeStarted, Icon = "shield-check"})
                else
                    disableDesyncGodmode()
                    notify({Title = "Godmode", Content = Gk[Xk].Notifications.GodmodeStopped, Icon = "shield-off"})
                end
            end
        })
        
        Fk.btnUnstick = Yk:Button({
            Title = P.Character.UnstickTitle, Desc = P.Character.UnstickDesc, Icon = "solar:exit-bold",
            Callback = function(...)
                pcall(M4) pcall(C4) pcall(D4)
                notify({Title = "Unstick", Content = Gk[Xk].Notifications.UnstickDone, Icon = "check"})
            end
        })
        
        Fk.secFlight = Yk:Section({Title = P.Character.SecFlight})
        
        Fk.sliderSpeed = Yk:Slider({
            Title = P.Character.SpeedTitle, Desc = P.Character.SpeedDesc, Step = 25,
            Value = {Min = 100, Max = 1000, Default = h.glideSpeed or 600},
            Callback = function(v, ...)
                h.glideSpeed = v
                Y(v)
            end
        })
        
        Fk.secDashboard = Tk:Section({Title = P.Settings.SecDashboard})
        
        Fk.paraLiveDash = Tk:Paragraph({
            Title = P.Settings.DashTitle,
            Desc = string.format("Status: Ready\nFarm Mode: Idle\nCarried Eggs: 0\nFlight Speed: %d Studs/s", h.glideSpeed or 600)
        })
        
        Fk.secUI = Tk:Section({Title = P.Settings.SecUI})
        
        Fk.dropLang = Tk:Dropdown({
            Title = P.Settings.LangTitle, Values = {"English", "ไทย"},
            Value = (Xk == "EN" and "English" or "ไทย"),
            Callback = function(v, ...)
                local newLang = (v == "ไทย") and "TH" or "EN"
                if newLang ~= Xk then
                    Xk = newLang
                    pcall(x)
                    notify({Title = "Language", Content = Gk[Xk].Notifications.LangSwitched, Icon = "check-circle"})
                end
            end
        })
        
        Fk.sliderTransp = Tk:Slider({
            Title = P.Settings.TranspTitle, Desc = P.Settings.TranspDesc, Step = 5,
            Value = {Min = 0, Max = 90, Default = 0},
            Callback = function(v, ...)
                pcall(function(...)
                    local main = win.UIElements and win.UIElements.Main
                    if not main then return end
                    local alpha = math.clamp(tonumber(v) or 0, 0, 90) / 100
                    local bg = main:FindFirstChild("Background")
                    if bg then
                        if bg:IsA("ImageLabel") then bg.ImageTransparency = alpha
                        elseif bg:IsA("Frame") then bg.BackgroundTransparency = alpha end
                    end
                end)
            end
        })
        
        Fk.dropTheme = Tk:Dropdown({
            Title = P.Settings.ThemeTitle,
            Values = {"Dark", "Rose", "Plant", "Red", "Sky", "Purple"},
            Value = "Dark",
            Callback = function(v, ...)
                pcall(function(...) windlib:SetTheme(v) end)
            end
        })
        
        Fk.secPerformance = Tk:Section({Title = P.Settings.SecPerformance})
        
        Fk.togPerformance = Tk:Toggle({
            Title = P.Settings.PerformanceTitle, Desc = P.Settings.PerformanceDesc,
            Icon = "solar:bolt-bold", Value = h.performanceMode,
            Callback = function(v, ...)
                h.performanceMode = v
                x()
                if v then Mk() else Ik() end
                local r = Gk[Xk] or Gk.EN
                notify({Title = "Performance Mode", Content = v and r.Notifications.PerformanceStarted or r.Notifications.PerformanceStopped, Icon = v and "check-circle" or "x-circle"})
            end
        })
        
        Fk.togDisable3D = Tk:Toggle({
            Title = P.Settings.Disable3DTitle, Desc = P.Settings.Disable3DDesc,
            Icon = "solar:monitor-camera-bold", Value = h.disable3D,
            Callback = function(v, ...)
                h.disable3D = v
                x()
                pcall(function(...) y:Set3dRenderingEnabled(not v) end)
                local r = Gk[Xk] or Gk.EN
                notify({Title = "3D Rendering", Content = v and r.Notifications.Disable3DStarted or r.Notifications.Disable3DStopped, Icon = v and "check-circle" or "x-circle"})
            end
        })
        
        Fk.secSystem = Tk:Section({Title = P.Settings.SecSystem})
        
        Fk.togAntiAFK = Tk:Toggle({
            Title = P.Settings.AntiAFKTitle, Desc = P.Settings.AntiAFKDesc,
            Icon = "solar:shield-check-bold", Value = h.antiAFK,
            Callback = function(v, ...)
                h.antiAFK = v
                x()
                if v then bk() else Ak() end
                local r = Gk[Xk] or Gk.EN
                notify({Title = "Anti-AFK", Content = v and r.Notifications.AntiAFKStarted or r.Notifications.AntiAFKStopped, Icon = v and "check-circle" or "x-circle"})
            end
        })
        
        Fk.btnReset = Tk:Button({
            Title = P.Settings.ResetTitle, Desc = P.Settings.ResetDesc, Icon = "solar:restart-bold",
            Callback = function(...)
                pcall(D4) pcall(u4)
                notify({Title = "Reset State", Content = "Character state reset successfully", Icon = "check-circle"})
            end
        })
        
        Fk.btnRejoin = Tk:Button({
            Title = P.Settings.RejoinTitle, Desc = P.Settings.RejoinDesc, Icon = "solar:logout-2-bold",
            Callback = function(...)
                pcall(function(...) TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, o) end)
            end
        })
        
        Fk.btnUnload = Tk:Button({
            Title = P.Settings.UnloadTitle, Desc = P.Settings.UnloadDesc, Icon = "solar:trash-bin-trash-bold",
            Callback = function(...) aM() end
        })
        
        task.spawn(function(...)
            while h.alive do
                pcall(function(...)
                    local count = y4()
                    local isTH = (Xk == "TH")
                    local state = Wk(Xk)
                    if statusTag then
                        local color = RB.RedBright
                        if h.securingEgg or h.teleporting then color = RB.Warning
                        elseif h.isReturning or h.glidingToTarget then color = RB.Red
                        elseif h.delivering then color = RB.RedGlow end
                        pcall(function(...)
                            if statusTag.SetTitle then statusTag:SetTitle((isTH and "สถานะ: " or "Status: ") .. state) end
                            if statusTag.SetColor then statusTag:SetColor(color) end
                        end)
                    end
                    if Fk.paraLiveDash and Fk.paraLiveDash.SetDesc then
                        local mode = isTH and "หยุดพัก" or "Idle"
                        if Y4 == "TWEEN" then mode = isTH and "ขโมยไข่ (บิน)" or "Auto Steal (Tween)"
                        elseif Y4 == "WARP" then mode = isTH and "ขโมยไข่ (วาร์ป)" or "Auto Steal (Warp)" end
                        local text = string.format("Status: %s\nFarm: %s\nEggs: %d\nSpeed: %d", state, mode, count, h.glideSpeed or 600)
                        pcall(function(...) Fk.paraLiveDash:SetDesc(text) end)
                    end
                end)
                task.wait(0.5)
            end
        end)
        
        done(function(...)
            pcall(function(...)
                if win.UIElements and win.UIElements.Main then
                    win.UIElements.Main.Visible = true
                end
            end)
        end)
        return
    end
    
    -- Fallback UI (no WindUI)
    H("[!] WindUI failed to load — using fallback UI")
    done(function(...)
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Lunaris_Antrax_Fallback"
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 99999
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.AutoLocalize = false
        local parent = o:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
        pcall(function(...)
            if syn and syn.protect_gui then
                syn.protect_gui(screenGui)
                screenGui.Parent = game:GetService("CoreGui")
            else
                screenGui.Parent = parent
            end
        end)
        if not screenGui.Parent then screenGui.Parent = parent end
        h.gui = screenGui
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 340, 0, 500)
        mainFrame.Position = UDim2.new(0.04, 0, 0.15, 0)
        mainFrame.BackgroundColor3 = RB.Bg
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.ClipsDescendants = true
        mainFrame.Parent = screenGui
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
        
        local stroke = Instance.new("UIStroke", mainFrame)
        stroke.Color = RB.Red
        stroke.Thickness = 1.4
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        local header = Instance.new("Frame")
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, 46)
        header.BackgroundColor3 = RB.Header
        header.BorderSizePixel = 0
        header.Parent = mainFrame
        Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
        
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -90, 0, 20)
        titleLbl.Position = UDim2.new(0, 12, 0, 5)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = "Lunaris • Antrax Edition"
        titleLbl.TextColor3 = RB.RedGlow
        titleLbl.TextSize = 14
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.AutoLocalize = false
        titleLbl.Parent = header
        
        local subLbl = Instance.new("TextLabel")
        subLbl.Size = UDim2.new(1, -90, 0, 14)
        subLbl.Position = UDim2.new(0, 12, 0, 24)
        subLbl.BackgroundTransparency = 1
        subLbl.Text = CREDITS_FULL
        subLbl.TextColor3 = RB.RedBright
        subLbl.TextSize = 10
        subLbl.Font = Enum.Font.GothamBold
        subLbl.TextXAlignment = Enum.TextXAlignment.Left
        subLbl.AutoLocalize = false
        subLbl.Parent = header
        
        local minBtn = Instance.new("TextButton")
        minBtn.Size = UDim2.new(0, 28, 0, 28)
        minBtn.Position = UDim2.new(1, -68, 0, 9)
        minBtn.BackgroundColor3 = RB.Card
        minBtn.Text = "-"
        minBtn.TextColor3 = RB.Text
        minBtn.TextSize = 16
        minBtn.Font = Enum.Font.GothamBold
        minBtn.AutoButtonColor = false
        minBtn.Parent = header
        Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 28, 0, 28)
        closeBtn.Position = UDim2.new(1, -36, 0, 9)
        closeBtn.BackgroundColor3 = RB.Danger
        closeBtn.Text = "X"
        closeBtn.TextColor3 = RB.Text
        closeBtn.TextSize = 12
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.AutoButtonColor = false
        closeBtn.Parent = header
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
        
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, -46)
        scroll.Position = UDim2.new(0, 0, 0, 46)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = RB.Red
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Parent = mainFrame
        
        local layout = Instance.new("UIListLayout", scroll)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 7)
        
        local pad = Instance.new("UIPadding", scroll)
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        
        local collapsed = false
        minBtn.MouseButton1Click:Connect(function(...)
            collapsed = not collapsed
            minBtn.Text = collapsed and "+" or "-"
            TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = collapsed and UDim2.new(0, 340, 0, 46) or UDim2.new(0, 340, 0, 500)
            }):Play()
        end)
        closeBtn.MouseButton1Click:Connect(function(...) aM() end)
        
        local function addHeader(text, order)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 20)
            f.BackgroundTransparency = 1
            f.LayoutOrder = order
            f.Parent = scroll
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = RB.RedGlow
            lbl.TextSize = 11
            lbl.Font = Enum.Font.GothamBold
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.AutoLocalize = false
            lbl.Parent = f
        end
        
        local function addToggle(title, desc, initial, color, order, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 52)
            frame.BackgroundColor3 = RB.Card
            frame.LayoutOrder = order
            frame.Parent = scroll
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            
            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, -60, 0, 18)
            titleLbl.Position = UDim2.new(0, 10, 0, 8)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Text = title
            titleLbl.TextColor3 = color or RB.Text
            titleLbl.TextSize = 13
            titleLbl.Font = Enum.Font.GothamBold
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.AutoLocalize = false
            titleLbl.Parent = frame
            
            local descLbl = Instance.new("TextLabel")
            descLbl.Size = UDim2.new(1, -60, 0, 16)
            descLbl.Position = UDim2.new(0, 10, 0, 26)
            descLbl.BackgroundTransparency = 1
            descLbl.Text = desc
            descLbl.TextColor3 = RB.Sub
            descLbl.TextSize = 10
            descLbl.Font = Enum.Font.Gotham
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.AutoLocalize = false
            descLbl.Parent = frame
            
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(0, 44, 0, 24)
            toggle.Position = UDim2.new(1, -54, 0.5, -12)
            toggle.BackgroundColor3 = initial and (color or RB.Red) or RB.Off
            toggle.Text = ""
            toggle.AutoButtonColor = false
            toggle.Parent = frame
            Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 18, 0, 18)
            knob.Position = initial and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            knob.BackgroundColor3 = initial and RB.RedGlow or RB.Muted
            knob.Parent = toggle
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
            
            local state = initial
            local function setVisual(v)
                state = v
                TweenService:Create(toggle, TweenInfo.new(0.18), {BackgroundColor3 = state and (color or RB.Red) or RB.Off}):Play()
                TweenService:Create(knob, TweenInfo.new(0.18), {
                    Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                    BackgroundColor3 = state and RB.RedGlow or RB.Muted
                }):Play()
            end
            toggle.MouseButton1Click:Connect(function(...)
                setVisual(not state)
                callback(state)
            end)
            return setVisual
        end
        
        local function addButton(title, desc, color, order, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 48)
            frame.BackgroundColor3 = RB.Card
            frame.LayoutOrder = order
            frame.Parent = scroll
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            
            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, -95, 0, 18)
            titleLbl.Position = UDim2.new(0, 10, 0, 6)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Text = title
            titleLbl.TextColor3 = color or RB.Text
            titleLbl.TextSize = 13
            titleLbl.Font = Enum.Font.GothamBold
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.AutoLocalize = false
            titleLbl.Parent = frame
            
            local descLbl = Instance.new("TextLabel")
            descLbl.Size = UDim2.new(1, -95, 0, 16)
            descLbl.Position = UDim2.new(0, 10, 0, 24)
            descLbl.BackgroundTransparency = 1
            descLbl.Text = desc
            descLbl.TextColor3 = RB.Sub
            descLbl.TextSize = 10
            descLbl.Font = Enum.Font.Gotham
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.AutoLocalize = false
            descLbl.Parent = frame
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 78, 0, 30)
            btn.Position = UDim2.new(1, -86, 0.5, -15)
            btn.BackgroundColor3 = color or RB.Red
            btn.Text = "RUN"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 11
            btn.Font = Enum.Font.GothamBold
            btn.AutoButtonColor = false
            btn.Parent = frame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            btn.MouseButton1Click:Connect(callback)
        end
        
        addHeader("AUTO STEAL MODES", 10)
        addToggle("Auto Steal (Tween)", "Fly to steal eggs & auto stash", h.pureTweenFarm, RB.RedBright, 11, function(v)
            if v then T4("TWEEN")
            elseif Y4 == "TWEEN" or h.pureTweenFarm then T4("NONE") end
        end)
        addToggle("Auto Steal (Teleport)", "Warp to steal eggs in loop", h.autoFarmLoop, RB.Red, 12, function(v)
            if v then T4("WARP")
            elseif Y4 == "WARP" or h.autoFarmLoop then T4("NONE") end
        end)
        addButton("Single Steal", "Steal 1 target egg and return", RB.Red, 13, function(...)
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
        
        addHeader("PLACE EGG", 20)
        addButton("Place Egg", "Fly home, place eggs & hatch", RB.Red, 21, function(...)
            task.spawn(function(...)
                h.statusText = "[Manual] Depositing eggs..."
                g4(h.glideSpeed) v4() u4()
                h.isReturning = false
                h.delivering = false
            end)
        end)
        addToggle("Auto Place (Every 5)", "Return home every 5 steals", h.autoPlaceEvery5, RB.Red, 22, function(v)
            h.autoPlaceEvery5 = v
            if not v then h.batchStealCount = 0 end
        end)
        addToggle("Auto Hatch", "Hatch ready eggs continuously", h.autoHatch, RB.RedBright, 23, function(v) h.autoHatch = v end)
        addToggle("Auto Return", "Auto return after stealing", h.autoGlide, RB.Red, 24, function(v) h.autoGlide = v end)
        addToggle("Auto Treadmill", "Run on treadmill when idle", h.autoTreadmill, RB.Red, 25, function(v)
            h.autoTreadmill = v
            x() n4()
            if not v and (h.onTreadmill or L4()) then M4() end
        end)
        addToggle("Auto Upgrade Treadmill", "Upgrade when affordable", h.autoUpgradeTreadmill, RB.Red, 26, function(v)
            h.autoUpgradeTreadmill = v
            x()
        end)
        addToggle("Auto Buy Trails", "Buy best speed trail", h.autoBuyTrails, RB.Red, 27, function(v)
            h.autoBuyTrails = v
            x()
        end)
        addToggle("Hide 'Not Enough Money'", "Suppress red alert", h.hideNotEnoughMoney, RB.Red, 28, function(v)
            h.hideNotEnoughMoney = v
            x()
        end)
        
        addHeader("CHARACTER & SAFETY", 30)
        addToggle("Godmode", "Invincible against attacks", false, RB.Danger, 31, function(v)
            if v then enableDesyncGodmode() else disableDesyncGodmode() end
        end)
        addButton("Get Out Treadmill", "Instantly escape treadmill", RB.Warning, 32, function(...)
            pcall(M4) pcall(C4) pcall(D4)
        end)
        
        addHeader("FLIGHT", 40)
        local speedFrame = Instance.new("Frame")
        speedFrame.Size = UDim2.new(1, 0, 0, 48)
        speedFrame.BackgroundColor3 = RB.Card
        speedFrame.LayoutOrder = 41
        speedFrame.Parent = scroll
        Instance.new("UICorner", speedFrame).CornerRadius = UDim.new(0, 8)
        
        local speedLbl = Instance.new("TextLabel")
        speedLbl.Size = UDim2.new(1, -130, 0, 18)
        speedLbl.Position = UDim2.new(0, 10, 0, 6)
        speedLbl.BackgroundTransparency = 1
        speedLbl.Text = "Flight Speed"
        speedLbl.TextColor3 = RB.Text
        speedLbl.TextSize = 13
        speedLbl.Font = Enum.Font.GothamBold
        speedLbl.TextXAlignment = Enum.TextXAlignment.Left
        speedLbl.AutoLocalize = false
        speedLbl.Parent = speedFrame
        
        local speedVal = Instance.new("TextLabel")
        speedVal.Size = UDim2.new(0, 70, 0, 24)
        speedVal.Position = UDim2.new(1, -80, 0.5, -12)
        speedVal.BackgroundColor3 = RB.Bg
        speedVal.Text = string.format("%d Studs/s", h.glideSpeed or 600)
        speedVal.TextColor3 = RB.RedBright
        speedVal.TextSize = 11
        speedVal.Font = Enum.Font.GothamBold
        speedVal.AutoLocalize = false
        speedVal.Parent = speedFrame
        Instance.new("UICorner", speedVal).CornerRadius = UDim.new(0, 6)
        
        local minusBtn = Instance.new("TextButton")
        minusBtn.Size = UDim2.new(0, 24, 0, 24)
        minusBtn.Position = UDim2.new(1, -110, 0.5, -12)
        minusBtn.BackgroundColor3 = RB.Off
        minusBtn.Text = "-"
        minusBtn.TextColor3 = RB.Text
        minusBtn.TextSize = 14
        minusBtn.Font = Enum.Font.GothamBold
        minusBtn.Parent = speedFrame
        Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)
        
        local plusBtn = Instance.new("TextButton")
        plusBtn.Size = UDim2.new(0, 24, 0, 24)
        plusBtn.Position = UDim2.new(1, -138, 0.5, -12)
        plusBtn.BackgroundColor3 = RB.Off
        plusBtn.Text = "+"
        plusBtn.TextColor3 = RB.Text
        plusBtn.TextSize = 14
        plusBtn.Font = Enum.Font.GothamBold
        plusBtn.Parent = speedFrame
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)
        
        minusBtn.MouseButton1Click:Connect(function(...)
            h.glideSpeed = math.max(100, (h.glideSpeed or 600) - 25)
            speedVal.Text = string.format("%d Studs/s", h.glideSpeed)
            Y(h.glideSpeed)
        end)
        plusBtn.MouseButton1Click:Connect(function(...)
            h.glideSpeed = math.min(1000, (h.glideSpeed or 600) + 25)
            speedVal.Text = string.format("%d Studs/s", h.glideSpeed)
            Y(h.glideSpeed)
        end)
        
        addButton("Reset Character State", "Clear velocity, cancel push", RB.Red, 42, function(...)
            pcall(D4) pcall(u4)
        end)
        addButton("Unload Script", "Destroy UI and stop loops", RB.Danger, 43, function(...) aM() end)
        
        addHeader("EGG SELECT", 45)
        
        local function makeZoneFrame(order, label, values, color, current, onChange)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 30 + math.ceil(#values / 2) * 36)
            frame.BackgroundColor3 = RB.Card
            frame.LayoutOrder = order
            frame.Parent = scroll
            Instance.new("UICorner", frame).Radius = UDim.new(0, 8)
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            
            local head = Instance.new("TextLabel")
            head.Size = UDim2.new(1, -20, 0, 20)
            head.Position = UDim2.new(0, 10, 0, 5)
            head.BackgroundTransparency = 1
            head.Text = label
            head.TextColor3 = color
            head.TextSize = 12
            head.Font = Enum.Font.GothamBold
            head.TextXAlignment = Enum.TextXAlignment.Left
            head.AutoLocalize = false
            head.Parent = frame
            
            local grid = Instance.new("Frame")
            grid.Size = UDim2.new(1, -20, 1, -30)
            grid.Position = UDim2.new(0, 10, 0, 26)
            grid.BackgroundTransparency = 1
            grid.Parent = frame
            
            local gridLayout = Instance.new("UIGridLayout", grid)
            gridLayout.CellSize = UDim2.new(0.48, 0, 0, 30)
            gridLayout.CellPadding = UDim2.new(0.04, 0, 0, 6)
            gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            for i, val in ipairs(values) do
                local btn = Instance.new("TextButton")
                btn.LayoutOrder = i
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 10
                btn.AutoButtonColor = false
                btn.AutoLocalize = false
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
                local isActive = current[val]
                if isActive then
                    btn.BackgroundColor3 = color
                    btn.TextColor3 = Color3.new(1, 1, 1)
                    btn.Text = "✓ " .. val
                else
                    btn.BackgroundColor3 = RB.Off
                    btn.TextColor3 = RB.Sub
                    btn.Text = val
                end
                btn.MouseButton1Click:Connect(function(...)
                    current[val] = not current[val]
                    if current[val] then
                        btn.BackgroundColor3 = color
                        btn.TextColor3 = Color3.new(1, 1, 1)
                        btn.Text = "✓ " .. val
                    else
                        btn.BackgroundColor3 = RB.Off
                        btn.TextColor3 = RB.Sub
                        btn.Text = val
                    end
                    onChange()
                end)
                btn.Parent = grid
            end
        end
        
        local zoneState = {}
        for _, z in ipairs(M) do
            zoneState[z] = h.selectedZones and h.selectedZones[z] == true
        end
        makeZoneFrame(46, "📍 Target Zones", M, RB.RedGlow, zoneState, function(...)
            h.selectedZones = {}
            for k, v in pairs(zoneState) do if v then h.selectedZones[k] = true end end
            x()
        end)
        
        local rarityState = {}
        for _, r in ipairs(X) do
            rarityState[r] = h.selectedRarities and h.selectedRarities[r] == true
        end
        makeZoneFrame(47, "🥚 Target Rarities", X, RB.Gold, rarityState, function(...)
            h.selectedRarities = {}
            for k, v in pairs(rarityState) do if v then h.selectedRarities[k] = true end end
            x()
        end)
        
        -- Anti-void / tool fix loop
        task.spawn(function(...)
            while h.alive do
                pcall(function(...)
                    local char = o.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Position.Y < 45 then
                        hrp.CFrame = CFrame.new(hrp.Position.X, 72, hrp.Position.Z)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                    end
                end)
                task.wait(0.5)
            end
        end)
    end)
end

-- ==============================================================================
-- BOOT
-- ==============================================================================
H("[+] Initializing Lunaris Hub • Antrax Edition")
H("[+] Credits: " .. CREDITS_NAME .. " | Telegram: " .. CREDITS_TG)

oM()

task.spawn(function(...)
    task.wait(0.5)
    A4()
    b4(true)
    C4()
    if o.Character then z4(o.Character) end
    u4()
    H("[+] Auto Humanoid Swap & Rigid Joint Locking Active.")
end)

o.CharacterAdded:Connect(function(char, ...)
    task.wait(0.6)
    if h.alive then
        D4()
        n4()
        C4()
        A4()
        b4(true)
        z4(char)
        u4()
    end
end)

if h.performanceMode then task.spawn(Mk) end
if h.disable3D then pcall(function(...) y:Set3dRenderingEnabled(false) end) end
if h.antiAFK then task.spawn(bk) end

H("═══════════════════════════════════════════════════")
H("    Lunaris Hub — RED & BLACK EDITION")
H("    Credits: " .. CREDITS_NAME)
H("    Telegram: " .. CREDITS_TG)
H("═══════════════════════════════════════════════════")
print("[Lunaris Hub • Antrax] Loaded successfully!")
print("Credits: " .. CREDITS_NAME .. " | Telegram: " .. CREDITS_TG)