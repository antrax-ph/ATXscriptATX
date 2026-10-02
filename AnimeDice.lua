-- ==============================================================================
-- [OP] AnimeDice v2.1 — build for "Anime Dice"
-- Inside: TowerFarm (tower queue + auto-money + auto-potions), AutoProgression
-- (claims, rebirth, upgrades, traits, grades, fusion) and Farm Boost (dice, spins,
-- auto-roll, dynamic auto-sell, slot upgrades) + shared AFK Guard.
-- Panels are draggable by their title bar and can be collapsed with the "–" button.
-- RightCtrl — hide/show all panels. Re-running correctly
-- replaces the previous session (old loops/UI are shut down).
-- v2.1: fixed economic math (income, payback, rebirth, stands).
-- v2.2: stands — RAREST FIRST (chance "1 in N" × variant multiplier), income — tie-breaker.
-- v2.3: stands — by VISIBLE "1 in N" (as in the game UI); variant and income — only tie-breakers.
-- v2.4: + SECTION 4 COOP: shared tower pool (files between clients) and auto-trade potions.
-- v2.5: + auto-distribution of towers by squad strength (recommended level, dynamic).
-- v2.7: COOP — part of the main script: auto-start, TowerFarm queue sync, unified cleanup.
-- v2.8: TowerFarm — auto-equip best team before EACH tower start (toggle "Auto-equip").
-- v2.9: COOP — auto-start TowerFarm after distribution (toggle "Auto-start farm").
-- v3.0: FULLY AUTONOMOUS: recalculate distribution every minute, sync queue, keep-alive farm (~10s), dedupe logs.
-- v3.1: on launch EVERYTHING is active automatically: force-enable all module features + auto-start (TowerFarm/Progress/FarmBoost/Coop).
-- ==============================================================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- ==============================================================================
-- CORE: session. Re-running kills loops, connections, and UI of the previous session.
-- ==============================================================================
if type(_G.__OP_AD_CLEANUP) == "function" then pcall(_G.__OP_AD_CLEANUP) end

local SESSION = {}
_G.__OP_AD_SESSION = SESSION
-- reset service flags from previous sessions (otherwise they can hold rebirth/spending)
_G.__OP_SMART_MONEY = nil
_G.__OP_REBIRTH_BLOCK = nil
-- AUTONOMOUS MODE: on launch all features are enabled and modules start themselves.
-- To disable: _G.__OP_AUTONOMY = false before running the script.
if _G.__OP_AUTONOMY == nil then _G.__OP_AUTONOMY = true end
_G.__OP_SPENT = 0 -- how much was spent since the last income measurement (for honest EMA)
local connections, guis, cleanupHooks = {}, {}, {}

local function alive() return _G.__OP_AD_SESSION == SESSION end
local function track(conn) table.insert(connections, conn); return conn end
local function onCleanup(fn) table.insert(cleanupHooks, fn) end

_G.__OP_AD_CLEANUP = function()
    if _G.__OP_AD_SESSION == SESSION then _G.__OP_AD_SESSION = nil end
    for _, fn in ipairs(cleanupHooks) do pcall(fn) end
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    for _, g in ipairs(guis) do pcall(function() g:Destroy() end) end
    table.clear(cleanupHooks); table.clear(connections); table.clear(guis)
    -- SECTION 4 (COOP) — its own session/UI
    if type(_G.__ADCOOP_CLEANUP) == "function" then pcall(_G.__ADCOOP_CLEANUP) end
end

-- Periodic worker: lives as long as the session is alive; an error does not kill the loop.
-- interval — number or function (so the interval can be changed via CONFIG on the fly).
local function loop(interval, fn, name)
    task.spawn(function()
        while alive() do
            task.wait(type(interval) == "function" and interval() or interval)
            if not alive() then break end
            local ok, err = pcall(fn)
            if not ok then warn("[OP] " .. tostring(name or "loop") .. ": " .. tostring(err)) end
        end
    end)
end

local function try(fn, ...)
    local ok, v = pcall(fn, ...)
    if ok then return v end
    return nil
end

-- track spending for income measurement
local function markSpent(amount)
    amount = tonumber(amount) or 0
    if amount > 0 then _G.__OP_SPENT = (tonumber(_G.__OP_SPENT) or 0) + amount end
end

-- ==============================================================================
-- CORE: game data (shared helpers for all sections)
-- ==============================================================================
local F = RS.Framework.Features
local NET = RS.Network
local DC = require(F.Data.DataController)
local ER = require(F.Inventory.EntryRegistry)
local FusingUtil = require(F.Fusing.FusingUtil)
local UpgradesCfg = require(F.Upgrades.Upgrades)
local TreeStructure = try(function() return require(F.Upgrades.TreeStructure) end)

local Data = {}

local kindCache = {}
function Data.config(name)
    local cfg = try(function() return ER.getEntryConfig(name) end)
    return type(cfg) == "table" and cfg or nil
end
function Data.kindOf(name)
    if name == nil then return nil end
    local k = kindCache[name]
    if k == nil then
        local cfg = Data.config(name)
        if not cfg then return nil end -- don't cache failures
        k = cfg.kind or false
        kindCache[name] = k
    end
    return k or nil
end

function Data.inv()
    local t = try(function() return DC.Inventory() end)
    return type(t) == "table" and t or {}
end
function Data.money() return tonumber(try(function() return DC.Money() end)) or 0 end
function Data.rebirth() return tonumber(try(function() return DC.Rebirth() end)) or 0 end
function Data.amountOf(name)
    local e = Data.inv()[name]
    return e and tonumber(e.amount) or 0
end
function Data.slots()
    local s = try(function() return DC.Slots() end)
    return type(s) == "table" and s or {}
end
function Data.isUnit(item)
    return type(item) == "table" and item.name ~= nil and tonumber(item.amount) == 1
        and Data.kindOf(item.name) == "Unit"
end
function Data.chance(item)
    return tonumber(try(function() return FusingUtil.GetChance(item) end))
end

-- units that must not be touched: stands, tower team, unit in hand
function Data.busyUnits()
    local set = {}
    for _, s in pairs(Data.slots()) do
        if type(s) == "table" and s.unitId then set[s.unitId] = true end
    end
    for i = 1, 4 do
        local u = try(function() return DC.TowerTeam[i]() end)
        if u then set[u] = true end
    end
    local held = try(function() return DC.EquippedUnit() end)
    if held then set[held] = true end
    return set
end

function Data.upgradeOwned(id)
    return try(function() return DC.Upgrades[id]() end) and true or false
end
function Data.upgradeAvailable(id)
    if Data.upgradeOwned(id) then return false end
    local parent = TreeStructure and try(function() return TreeStructure.GetParent(id) end)
    if parent and parent ~= "Start" then return Data.upgradeOwned(parent) end
    return true
end

local function formatShort(v)
    if type(v) ~= "number" or v ~= v then return "-" end
    if v == math.huge or v == -math.huge then return "∞" end
    local a = math.abs(v)
    if a >= 1e15 then return string.format("%.2fqd", v / 1e15) end
    if a >= 1e12 then return string.format("%.2ft", v / 1e12) end
    if a >= 1e9 then return string.format("%.2fb", v / 1e9) end
    if a >= 1e6 then return string.format("%.2fm", v / 1e6) end
    if a >= 1e3 then return string.format("%.2fk", v / 1e3) end
    return tostring(math.floor(v))
end

local function formatTime(sec)
    if type(sec) ~= "number" or sec ~= sec or sec == math.huge then return "∞" end
    sec = math.max(0, math.floor(sec))
    if sec >= 86400 * 30 then return ">30d" end
    if sec >= 3600 then return string.format("%dh %dm", sec // 3600, (sec % 3600) // 60) end
    return string.format("%dm %ds", sec // 60, sec % 60)
end

-- ==============================================================================
-- CORE: settings save (one cfg file, prefixes T_ / P_ / no prefix)
-- ==============================================================================
local OPCfg = (function()
    local FILE = "OP_AnimeDice_FarmBoost.cfg"
    local function load()
        local out = {}
        if type(readfile) ~= "function" or type(isfile) ~= "function" then return out end
        if not try(isfile, FILE) then return out end
        local data = try(readfile, FILE)
        if type(data) ~= "string" then return out end
        for line in string.gmatch(data, "[^\r\n]+") do
            local k, v = string.match(line, "^([%w_]+)=(.*)$")
            if k then out[k] = v end
        end
        return out
    end
    local function save(kvs)
        if type(writefile) ~= "function" then return end
        local all = load()
        for k, v in pairs(kvs) do all[k] = tostring(v) end
        local lines = {}
        for k, v in pairs(all) do table.insert(lines, k .. "=" .. v) end
        table.sort(lines)
        pcall(writefile, FILE, table.concat(lines, "\n"))
    end
    local function parse(raw)
        if raw == "true" then return true end
        if raw == "false" then return false end
        return tonumber(raw)
    end
    local function applyTo(cfg, prefix, all)
        all = all or load()
        for key, cur in pairs(cfg) do
            local raw = all[(prefix or "") .. key]
            if raw ~= nil then
                local v = parse(raw)
                if v ~= nil and type(v) == type(cur) then cfg[key] = v end
            end
        end
    end
    return {load = load, save = save, parse = parse, applyTo = applyTo, FILE = FILE}
end)()

-- ==============================================================================
-- CORE: UI kit (panel with title, dragging, and collapsing)
-- ==============================================================================
local Theme = {
    Bg = Color3.fromRGB(18, 20, 32), Card = Color3.fromRGB(24, 27, 44), Deep = Color3.fromRGB(13, 15, 24),
    Text = Color3.fromRGB(238, 240, 250), Sub = Color3.fromRGB(150, 155, 180),
    Accent = Color3.fromRGB(114, 90, 255), AccentGlow = Color3.fromRGB(160, 140, 255),
    Success = Color3.fromRGB(46, 160, 90), SuccessDark = Color3.fromRGB(24, 90, 52),
    Danger = Color3.fromRGB(160, 60, 60), DangerDim = Color3.fromRGB(90, 60, 60),
    Gold = Color3.fromRGB(255, 200, 120), Off = Color3.fromRGB(60, 60, 90),
    Active = Color3.fromRGB(70, 56, 130), Selected = Color3.fromRGB(34, 40, 72),
}

local UI = {}

local function destroyOld(name)
    local parents = {CoreGui, PG}
    if type(gethui) == "function" then
        local h = try(gethui)
        if h then table.insert(parents, h) end
    end
    for _, p in ipairs(parents) do
        pcall(function()
            local old = p:FindFirstChild(name)
            if old then old:Destroy() end
        end)
    end
end

local function mountGui(gui)
    if type(gethui) == "function" then pcall(function() gui.Parent = gethui() end) end
    if not gui.Parent then pcall(function() gui.Parent = CoreGui end) end
    if not gui.Parent then gui.Parent = PG end
end

function UI.panel(name, title, w, h, x, y)
    destroyOld(name)
    local gui = Instance.new("ScreenGui")
    gui.Name = name
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mountGui(gui)
    table.insert(guis, gui)

    local cam = workspace.CurrentCamera
    if cam then
        local vp = cam.ViewportSize
        if vp.X > 0 and vp.Y > 0 then
            x = math.clamp(x, 0, math.max(0, vp.X - w - 8))
            y = math.clamp(y, 0, math.max(0, vp.Y - h - 8))
        end
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(w, h)
    frame.Position = UDim2.fromOffset(x, y)
    frame.BackgroundColor3 = Theme.Bg
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.ClipsDescendants = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Theme.Accent
    stroke.Thickness = 1

    local body = Instance.new("Frame")
    body.Size = UDim2.fromScale(1, 1)
    body.BackgroundTransparency = 1
    body.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 26)
    bar.BackgroundTransparency = 1
    bar.Active = true
    bar.ZIndex = 2
    bar.Parent = frame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -44, 0, 20)
    titleLbl.Position = UDim2.fromOffset(8, 5)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextColor3 = Theme.AccentGlow
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Text = title
    titleLbl.ZIndex = 2
    titleLbl.Parent = bar

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(24, 18)
    minBtn.Position = UDim2.new(1, -30, 0, 5)
    minBtn.BackgroundColor3 = Theme.Off
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 12
    minBtn.TextColor3 = Theme.Text
    minBtn.Text = "–"
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 3
    minBtn.Parent = bar
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

    local collapsed = false
    track(minBtn.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        body.Visible = not collapsed
        frame.Size = UDim2.fromOffset(w, collapsed and 30 or h)
        minBtn.Text = collapsed and "+" or "–"
    end))

    local dragging, dragStart, startPos = false, nil, nil
    track(bar.InputBegan:Connect(function(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, frame.Position
        end
    end))
    track(UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Touch then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    track(UIS.InputEnded:Connect(function(input)
        local t = input.UserInputType
        if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then dragging = false end
    end))

    local P = {gui = gui, frame = frame, body = body}

    function P.label(ly, lh, color, size)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -16, 0, lh)
        l.Position = UDim2.fromOffset(8, ly)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.Gotham
        l.TextSize = size or 11
        l.TextColor3 = color or Theme.Text
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.Text = ""
        l.Parent = body
        return l
    end

    function P.multiline(ly, lh, color)
        local l = P.label(ly, lh, color)
        l.TextWrapped = true
        l.TextTruncate = Enum.TextTruncate.None
        l.TextYAlignment = Enum.TextYAlignment.Top
        return l
    end

    function P.button(text, bx, by, bw, bh, color, size)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(bw, bh)
        b.Position = UDim2.fromOffset(bx, by)
        b.BackgroundColor3 = color or Theme.Off
        b.Font = Enum.Font.GothamBold
        b.TextSize = size or 11
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Text = text
        b.AutoButtonColor = false
        b.Parent = body
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end

    function P.onClick(btn, fn)
        track(btn.MouseButton1Click:Connect(function()
            local ok, err = pcall(fn)
            if not ok then warn("[OP] UI: " .. tostring(err)) end
        end))
    end

    return P
end

function UI.paintToggle(btn, on, label)
    btn.Text = label .. ": " .. (on and "ON" or "OFF")
    btn.BackgroundColor3 = on and Theme.SuccessDark or Theme.Off
end

track(UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        for _, g in ipairs(guis) do g.Enabled = not g.Enabled end
    end
end))

-- ==============================================================================
-- AFK GUARD (shared): blocks the game's auto-teleport (1080s) and keeps real input
-- ==============================================================================
do
    local function disableAfkScript()
        local ps = LP:FindFirstChild("PlayerScripts")
        local afk = ps and ps:FindFirstChild("AFK")
        if afk and not afk.Disabled then pcall(function() afk.Disabled = true end) end
    end
    disableAfkScript()

    if not _G.__OP_AFK_HOOKED and type(getnamecallmethod) == "function" then
        local TS = game:GetService("TeleportService")
        local wrap = type(newcclosure) == "function" and newcclosure or function(f) return f end
        local function blocked(self, ...)
            if self ~= TS or getnamecallmethod() ~= "Teleport" then return false end
            local placeId, player = ...
            return placeId == game.PlaceId and (player == nil or player == LP)
        end
        local ok = false
        if type(hookmetamethod) == "function" then
            ok = pcall(function()
                local old
                old = hookmetamethod(game, "__namecall", wrap(function(self, ...)
                    if blocked(self, ...) then
                        _G.__AFKTeleports = (_G.__AFKTeleports or 0) + 1
                        return
                    end
                    return old(self, ...)
                end))
            end)
        end
        if not ok and type(getrawmetatable) == "function" and type(setreadonly) == "function" then
            ok = pcall(function()
                local mt = getrawmetatable(game)
                local old = mt.__namecall
                setreadonly(mt, false)
                mt.__namecall = wrap(function(self, ...)
                    if blocked(self, ...) then
                        _G.__AFKTeleports = (_G.__AFKTeleports or 0) + 1
                        return
                    end
                    return old(self, ...)
                end)
                setreadonly(mt, true)
            end)
        end
        _G.__OP_AFK_HOOKED = ok
    end

    loop(10, disableAfkScript, "afk-script")

    -- Anti-idle: Roblox kicks after 20 min without input. Send SEVERAL input channels
    -- (mouse — the most reliable, it also resets the system idle; plus space and VIM).
    _G.__OP_AFK_INPUTS = _G.__OP_AFK_INPUTS or 0
    local function afkInput()
        local any = false
        -- 1) mouse movement (jiggle ±2px)
        if type(mousemoverel) == "function" then
            if pcall(mousemoverel, 2, 0) then any = true end
            task.wait(0.05)
            pcall(mousemoverel, -2, 0)
        end
        -- 2) space (also resets the game's AFK timer via InputBegan)
        if type(keypress) == "function" and type(keyrelease) == "function" then
            pcall(keypress, 0x20)
            task.wait(0.05)
            pcall(keyrelease, 0x20)
            any = true
        end
        -- 3) VIM — fallback channel (keys work; SendMouseMoveEvent is not supported in this version)
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.03)
            VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
        if any then _G.__OP_AFK_INPUTS = (_G.__OP_AFK_INPUTS or 0) + 1 end
    end
    loop(120, afkInput, "afk-input")

    -- backstop: if the client still declares us idle — immediately send a burst of inputs
    pcall(function()
        LP.Idled:Connect(function()
            for _ = 1, 3 do
                afkInput()
                task.wait(0.5)
            end
        end)
    end)
end

-- ==============================================================================
-- SECTION 1: TOWER FARM
-- ==============================================================================
do
    local RF = NET.Towers.RF
    local RE = NET.Towers.RE
    local BoostRE = NET.BoostService.RE
    local PlotRE = NET.PlotService.RE
    local Towers = require(F.Towers.Towers)
    local ALL = Towers.GetAll() or {}

    local SORTED = {}
    for id, cfg in pairs(ALL) do
        local c = type(cfg) == "table" and cfg or {}
        table.insert(SORTED, {
            id = id,
            order = tonumber(c.order) or 999,
            diff = (type(c.difficulty) == "table" and c.difficulty.name) or "?",
        })
    end
    table.sort(SORTED, function(a, b)
        if a.order ~= b.order then return a.order < b.order end
        return tostring(a.id) < tostring(b.id)
    end)
    local DEFAULT_TOWER = (ALL["Infinity Tower"] and "Infinity Tower") or (SORTED[1] and SORTED[1].id) or "Infinity Tower"

    -- number of tower floors (to count a "victory"); if not in config — 100
    local function towerMaxFloors(id)
        local c = type(ALL[id]) == "table" and ALL[id] or {}
        for _, k in ipairs({"maxFloor", "maxFloors", "floorCount", "totalFloors"}) do
            local v = tonumber(c[k])
            if v and v > 0 then return v end
        end
        if type(c.floors) == "number" and c.floors > 0 then return c.floors end
        if type(c.floors) == "table" and #c.floors > 0 then return #c.floors end
        return 100
    end

    local CONFIG = {
        TOWER = DEFAULT_TOWER,
        START_DELAY = 3.05,
        NIL_TOLERANCE = 4,
        COLLECT_INTERVAL = 15,
        POTION_INTERVAL = 6,
        POTION_REFRESH = 60,    -- top up the buff if less than (sec) remains; 0 if the game overwrites the timer
        POTION_RETRY = 10,
        AUTO_COLLECT = true,
        AUTO_POTIONS = true,
        HIDE_TOWER_UI = true,
        AUTO_EQUIP_BEST = true,   -- equip the best team BEFORE each tower start
    }

    local ACTION_WAIT = {damageEnemy = 0.62, damagePlayer = 0.62, ended = 0, memberDefeated = 0.32, floorStarted = 0.76, floorCompleted = 0.24}
    local FLOOR_START_WAIT = {initial = 0.76, transition = 0.38}

    local state = {
        running = false, runId = 0, needStart = true, restartAt = 0, nilStreak = 0,
        floors = 0, runs = 0, completed = 0, startedAt = 0, rewards = {},
        towerId = DEFAULT_TOWER, runStartFloors = 0, bestRun = 0,
        collects = 0, potionsUsed = 0, lastPotion = "-",
        selected = {[DEFAULT_TOWER] = true},
        queue = {DEFAULT_TOWER}, queueIndex = 1,
    }

    local refreshFarmUI, persistTF, setStatus

    local function sequenceWait(actions)
        local total = 0
        for i, a in ipairs(actions) do
            if a.action == "floorStarted" then
                if i == 1 then
                    total = total + ((a.floor == 1) and FLOOR_START_WAIT.initial or FLOOR_START_WAIT.transition)
                elseif actions[i - 1] and actions[i - 1].action == "memberDefeated" then
                    total = total + FLOOR_START_WAIT.transition
                end
            else
                total = total + (ACTION_WAIT[a.action] or 0)
            end
        end
        return total
    end

    local function buildQueue()
        local q = {}
        for _, t in ipairs(SORTED) do
            if state.selected[t.id] then table.insert(q, t.id) end
        end
        state.queue = q
        state.queueIndex = 1
        for i, id in ipairs(q) do
            if id == state.towerId then state.queueIndex = i break end
        end
    end

    local function ensureTower()
        buildQueue()
        if #state.queue == 0 then return false end
        if not state.selected[state.towerId] then
            state.towerId, state.queueIndex = state.queue[1], 1
        end
        return true
    end

    local function nextInQueue()
        buildQueue()
        local n = #state.queue
        if n == 0 then return nil, nil end
        local idx = state.selected[state.towerId] and state.queueIndex or 0
        local ni = (idx % n) + 1
        return state.queue[ni], ni
    end

    local function advanceQueue()
        local nxt, ni = nextInQueue()
        if nxt then state.towerId, state.queueIndex = nxt, ni end
    end

    -- ---------------- auto-collect money ----------------
    local function collectSlots()
        local fired = 0
        for idx in pairs(Data.slots()) do
            local slotNum = tonumber(idx)
            if slotNum then
                pcall(function() PlotRE.CollectBalance:FireServer(slotNum) end)
                fired = fired + 1
            end
        end
        if fired == 0 then
            for slot = 1, 15 do
                pcall(function() PlotRE.CollectBalance:FireServer(slot) end)
            end
            fired = 15
        end
        state.collects = state.collects + 1
        return fired
    end

    loop(function() return CONFIG.COLLECT_INTERVAL end, function()
        if CONFIG.AUTO_COLLECT then collectSlots() end
    end, "collect")

    -- ---------------- auto-potions ----------------
    local function parseTime(text)
        if type(text) ~= "string" or text == "" then return nil end
        local a, b, c = string.match(text, "(%d+):(%d+):(%d+)")
        if a then return tonumber(a) * 3600 + tonumber(b) * 60 + tonumber(c) end
        local mm, ss = string.match(text, "(%d+):(%d+)")
        if mm then return tonumber(mm) * 60 + tonumber(ss) end
        local d = string.match(text, "(%d+)d")
        local h = string.match(text, "(%d+)h")
        local m = string.match(text, "(%d+)m")
        local s = string.match(text, "(%d+)s")
        if not (d or h or m or s) then return nil end
        return (tonumber(d) or 0) * 86400 + (tonumber(h) or 0) * 3600 + (tonumber(m) or 0) * 60 + (tonumber(s) or 0)
    end

    local function activePotionTimers()
        local root = PG:FindFirstChild("Root")
        local hud = root and root:FindFirstChild("HUD")
        local bar = hud and hud:FindFirstChild("BuffBar")
        if not bar then return nil end
        local map = {}
        for _, ch in ipairs(bar:GetChildren()) do
            if string.sub(ch.Name, 1, 6) == "Boost_" then
                local secs = nil
                for _, d in ipairs(ch:GetDescendants()) do
                    if d:IsA("TextLabel") then
                        secs = parseTime(d.Text)
                        if secs then break end
                    end
                end
                map[string.sub(ch.Name, 7)] = secs or math.huge
            end
        end
        return map
    end

    local function ownedBoosts()
        local byName = {}
        for key, item in pairs(Data.inv()) do
            if type(item) == "table" and item.name and (tonumber(item.amount) or 0) > 0
               and Data.kindOf(item.name) == "Boost" and not byName[item.name] then
                byName[item.name] = {key = key, name = item.name, amount = tonumber(item.amount)}
            end
        end
        local list = {}
        for _, b in pairs(byName) do table.insert(list, b) end
        table.sort(list, function(a, b) return a.name < b.name end)
        return list
    end

    local potionLock = {}
    loop(function() return CONFIG.POTION_INTERVAL end, function()
        if not CONFIG.AUTO_POTIONS then return end
        local timers = activePotionTimers()
        if not timers then return end
        local now = os.clock()
        local drink = {}
        for _, b in ipairs(ownedBoosts()) do
            if (potionLock[b.name] or 0) <= now then
                local remaining = timers[b.name]
                if remaining == nil then
                    table.insert(drink, {b = b, prio = 1})
                elseif remaining <= CONFIG.POTION_REFRESH then
                    table.insert(drink, {b = b, prio = 2})
                end
            end
        end
        table.sort(drink, function(a, b)
            if a.prio ~= b.prio then return a.prio < b.prio end
            return a.b.name < b.b.name
        end)
        for _, d in ipairs(drink) do
            pcall(function() BoostRE.Use:FireServer(d.b.key) end)
            potionLock[d.b.name] = os.clock() + CONFIG.POTION_RETRY
            state.potionsUsed = state.potionsUsed + 1
            state.lastPotion = d.b.name
            task.wait(0.2)
        end
    end, "potions")

    -- ---------------- API for Towers mode ----------------
    local function equipBest()
        pcall(function() RE.EquipBestTowerTeam:FireServer() end)
    end

    local function startRun()
        if CONFIG.AUTO_EQUIP_BEST then
            equipBest()
            task.wait(0.2)
        end
        pcall(function() RF.PlayTower:InvokeServer(state.towerId) end)
        state.needStart = false
        task.wait(0.4)
    end

    local TowerController = nil
    do
        local okC, mod = pcall(require, F.Towers.TowerController)
        if okC and type(mod) == "table" and type(mod.startTower) == "function" then
            TowerController = mod
        end
    end

    local function towerScreen()
        local root = PG:FindFirstChild("Root")
        local tower = root and root:FindFirstChild("Tower")
        local screen = tower and tower:FindFirstChild("Screen")
        local hidden = tower and tower:FindFirstChild("Hidden")
        if hidden and not hidden:IsA("GuiButton") then hidden = nil end
        return screen, hidden
    end

    local function hideTowerScreen()
        if not CONFIG.HIDE_TOWER_UI or type(firesignal) ~= "function" then return end
        local screen, hidden = towerScreen()
        if not (screen and hidden) or not screen.Visible then return end
        pcall(firesignal, hidden.Activated)
    end

    if TowerController then
        task.spawn(function()
            local root = PG:WaitForChild("Root", 60)
            local tower = root and root:WaitForChild("Tower", 60)
            local screen = tower and tower:WaitForChild("Screen", 60)
            local floorLabel = screen and screen:WaitForChild("Floor", 60)
            if not (alive() and floorLabel and floorLabel:IsA("TextLabel")) then return end
            local lastFloor = tonumber(string.match(floorLabel.Text or "", "%d+")) or 0
            track(floorLabel:GetPropertyChangedSignal("Text"):Connect(function()
                local n = tonumber(string.match(floorLabel.Text or "", "%d+"))
                if not n then return end
                -- FIX: reset only on a real decrease (new run), not when the same text
                -- is set again — otherwise floors were counted twice
                if n < lastFloor then lastFloor = 0 end
                if n > lastFloor then
                    if state.running then state.floors = state.floors + (n - lastFloor) end
                    lastFloor = n
                end
                if n == 1 then task.delay(0.8, hideTowerScreen) end
            end))
        end)

        pcall(function()
            local EDC = require(F.Notifications.EntryDropController)
            if type(EDC) == "table" and type(EDC.Play) == "function" and not (table.isfrozen and table.isfrozen(EDC)) then
                local orig = EDC.__OP_ORIG_PLAY or EDC.Play
                EDC.__OP_ORIG_PLAY = orig
                EDC.Play = function(name, amount, ...)
                    if alive() and state.running and type(name) == "string" then
                        state.rewards[name] = (state.rewards[name] or 0) + (tonumber(amount) or 1)
                    end
                    return orig(name, amount, ...)
                end
            end
        end)
    end

    -- ---------------- UI ----------------
    local P = UI.panel("TowerFarm", "Tower Farm", 330, 410, 30, 240)
    local statusLbl = P.label(26, 14, Theme.Sub)
    statusLbl.Text = "Select a tower and press START"
    local infoLbl = P.label(42, 14, Theme.Text)
    local statsLbl = P.label(58, 14, Theme.Text)
    local rateLbl = P.label(74, 14, Theme.Sub)
    P.label(92, 14, Theme.Gold).Text = "Session rewards:"
    local rewLbl = P.multiline(108, 42, Theme.Text)
    P.label(152, 14, Theme.Sub).Text = "Towers (click — on/off):"

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -16, 0, 90)
    scroll.Position = UDim2.fromOffset(8, 168)
    scroll.BackgroundColor3 = Theme.Deep
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = P.body
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 2)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local startBtn = P.button("START", 8, 266, 100, 28, Theme.Success, 12)
    local stopBtn = P.button("STOP", 116, 266, 100, 28, Theme.Danger, 12)
    local equipBtn = P.button("Equip Best", 224, 266, 98, 28, Theme.Off, 12)
    local collectBtn = P.button("", 8, 300, 153, 26, Theme.SuccessDark)
    local potionBtn = P.button("", 169, 300, 153, 26, Theme.SuccessDark)
    local hideBtn = P.button("", 8, 330, 153, 24, Theme.SuccessDark)
    local equipAutoBtn = P.button("", 169, 330, 153, 24, Theme.SuccessDark)
    local selAllBtn = P.button("All", 238, 149, 40, 18, Theme.Off)
    local selNoneBtn = P.button("Reset", 282, 149, 40, 18, Theme.Off)
    local baseLbl = P.label(358, 14, Theme.Sub)
    local extraLbl = P.label(374, 14, Theme.Sub)
    local afkLbl = P.label(390, 14, Theme.Sub)

    setStatus = function(text) statusLbl.Text = tostring(text) end

    local towerRows = {}
    for _, t in ipairs(SORTED) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, -6, 0, 24)
        row.BackgroundColor3 = Theme.Card
        row.BorderSizePixel = 0
        row.Font = Enum.Font.Gotham
        row.TextSize = 11
        row.TextColor3 = Theme.Text
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.AutoButtonColor = false
        row.LayoutOrder = t.order
        row.Parent = scroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
        Instance.new("UIPadding", row).PaddingLeft = UDim.new(0, 6)
        towerRows[t.id] = {row = row, info = t}
        P.onClick(row, function()
            local id = t.id
            state.selected[id] = not state.selected[id]
            if not state.running then
                if state.selected[id] then
                    state.towerId = id
                elseif state.towerId == id then
                    buildQueue()
                    state.towerId = state.queue[1] or state.towerId
                end
            end
            refreshFarmUI()
            persistTF()
        end)
    end

    local function refreshRewards()
        local list = {}
        for k, v in pairs(state.rewards) do table.insert(list, {k = k, v = v}) end
        table.sort(list, function(a, b) return a.v > b.v end)
        local parts = {}
        for i = 1, math.min(#list, 4) do
            table.insert(parts, list[i].k .. " x" .. formatShort(list[i].v))
        end
        rewLbl.Text = #parts > 0 and table.concat(parts, "\n") or "—"
    end

    refreshFarmUI = function()
        buildQueue()
        for id, r in pairs(towerRows) do
            local sel = state.selected[id] and true or false
            local isActive = (id == state.towerId)
            r.row.Text = (isActive and state.running and "▶ " or "") .. (sel and "[x]  " or "[ ]  ") .. r.info.id .. "  [" .. r.info.diff .. "]"
            r.row.BackgroundColor3 = isActive and Theme.Active or (sel and Theme.Selected or Theme.Card)
        end
        local teamCount = 0
        for i = 1, 4 do
            if try(function() return DC.TowerTeam[i]() end) then teamCount = teamCount + 1 end
        end
        infoLbl.Text = string.format("Tower: %s (%d/%d) | Team: %d/4",
            tostring(state.towerId), state.queueIndex, math.max(#state.queue, 1), teamCount)
        local elapsed = state.startedAt > 0 and (os.clock() - state.startedAt) or 0
        local rate = elapsed > 0 and math.floor(state.floors / elapsed * 60) or 0
        statsLbl.Text = string.format("Floors: %d | Runs: %d | Wins: %d | Best: %d",
            state.floors, state.runs, state.completed, state.bestRun)
        rateLbl.Text = string.format("Speed: %d fl/min | Time: %s | Mode: %s",
            rate, formatTime(elapsed), TowerController and "game" or "fallback")
        baseLbl.Text = string.format("AFK teleports: %d | Money collects: %d", _G.__AFKTeleports or 0, state.collects)
        extraLbl.Text = string.format("Potions: %d (last: %s)", state.potionsUsed, state.lastPotion)
        UI.paintToggle(collectBtn, CONFIG.AUTO_COLLECT, CONFIG.AUTO_COLLECT and string.format("Money (%ds)", CONFIG.COLLECT_INTERVAL) or "Money")
        UI.paintToggle(potionBtn, CONFIG.AUTO_POTIONS, "Potions")
        UI.paintToggle(hideBtn, CONFIG.HIDE_TOWER_UI, "Hide screen")
        UI.paintToggle(equipAutoBtn, CONFIG.AUTO_EQUIP_BEST, "Auto-equip")
        stopBtn.BackgroundColor3 = state.running and Theme.Danger or Theme.DangerDim
        refreshRewards()
        local guard = _G.__OP_AFK_HOOKED and "ON" or "partial (no hook)"
        afkLbl.Text = "AFK Guard: " .. guard .. (state.running and " | Farming..." or "")
    end

    -- ---------------- farm loops ----------------
    local thread = nil
    local function isCurrent(runId) return alive() and state.running and state.runId == runId end
    local function finishLoop(runId)
        if state.runId == runId then
            state.running = false
            thread = nil
        end
        refreshFarmUI()
    end

    local function registerRunEnd(finished, nxt)
        state.runs = state.runs + 1
        local runFloors = state.floors - state.runStartFloors
        if runFloors > state.bestRun then state.bestRun = runFloors end
        if runFloors >= towerMaxFloors(finished) then
            state.completed = state.completed + 1
            setStatus("Tower completed! Wins: " .. state.completed .. " -> next: " .. tostring(nxt))
        else
            setStatus(string.format("Run %s: %d fl. -> next: %s", tostring(finished), runFloors, tostring(nxt)))
        end
        state.runStartFloors = state.floors
    end

    local function farmLoop(runId)
        while isCurrent(runId) do
            if state.needStart then
                if os.clock() < state.restartAt then
                    task.wait(0.2)
                    continue
                end
                if not ensureTower() then
                    setStatus("No towers selected — tick the checkboxes")
                    break
                end
                state.runStartFloors = state.floors
                startRun()
            end
            local ok, actions = pcall(function() return RF.CompleteTowerFloor:InvokeServer() end)
            if not isCurrent(runId) then break end
            if ok and type(actions) == "table" and #actions > 0 then
                state.nilStreak = 0
                local ended, wiped, reachedFloor = false, false, nil
                for _, a in ipairs(actions) do
                    if a.action == "floorCompleted" then
                        state.floors = state.floors + 1
                        reachedFloor = a.floor
                        if type(a.rewards) == "table" then
                            for k, v in pairs(a.rewards) do
                                state.rewards[k] = (state.rewards[k] or 0) + (tonumber(v) or 0)
                            end
                        end
                    elseif a.action == "memberDefeated" then
                        wiped = true
                    elseif a.action == "ended" then
                        ended = true
                    end
                end
                if ended then
                    state.runs = state.runs + 1
                    local runFloors = state.floors - state.runStartFloors
                    if runFloors > state.bestRun then state.bestRun = runFloors end
                    local msg
                    if reachedFloor and reachedFloor >= towerMaxFloors(state.towerId) then
                        state.completed = state.completed + 1
                        msg = "Tower completed! Wins: " .. state.completed
                    elseif wiped then
                        msg = "Wipe on floor " .. tostring(reachedFloor or "?")
                    else
                        msg = "Run ended"
                    end
                    state.needStart = true
                    state.restartAt = os.clock() + CONFIG.START_DELAY
                    advanceQueue()
                    setStatus(msg .. " -> next: " .. tostring(state.towerId))
                else
                    task.wait(sequenceWait(actions))
                end
            else
                state.nilStreak = state.nilStreak + 1
                if state.nilStreak >= CONFIG.NIL_TOLERANCE then
                    state.nilStreak = 0
                    state.needStart = true
                    state.restartAt = os.clock() + CONFIG.START_DELAY
                    advanceQueue()
                    setStatus("Run interrupted -> next: " .. tostring(state.towerId))
                else
                    task.wait(0.15)
                end
            end
        end
        finishLoop(runId)
    end

    local function farmLoopGame(runId)
        if not ensureTower() then
            setStatus("No towers selected — tick the checkboxes")
            finishLoop(runId)
            return
        end
        if CONFIG.AUTO_EQUIP_BEST then
            equipBest()
            task.wait(0.25)
        end
        local okS, started = pcall(TowerController.startTower, state.towerId)
        if okS and started then
            state.runStartFloors = state.floors
            task.delay(0.9, hideTowerScreen)
            setStatus("Game is running the run: " .. tostring(state.towerId))
        else
            setStatus("Waiting to start the run: " .. tostring(state.towerId))
        end
        while isCurrent(runId) do
            task.wait(0.6)
            if not isCurrent(runId) then break end
            local nxt, ni = nextInQueue()
            if not nxt then
                setStatus("Queue is empty — select towers")
            else
                if CONFIG.AUTO_EQUIP_BEST then
                    equipBest()
                    task.wait(0.25)
                    if not isCurrent(runId) then break end
                end
                local ok2, res = pcall(TowerController.startTower, nxt)
                if ok2 and res then
                    task.delay(0.9, hideTowerScreen)
                    local finished = state.towerId
                    state.towerId, state.queueIndex = nxt, ni
                    registerRunEnd(finished, nxt)
                end
            end
        end
        finishLoop(runId)
    end

    local function start()
        if state.running then return end
        if not ensureTower() then
            setStatus("Select at least one tower (checkboxes)")
            return
        end
        state.runId = state.runId + 1
        local myId = state.runId
        state.running = true
        state.needStart = true
        state.restartAt = 0
        state.nilStreak = 0
        state.floors, state.runs, state.completed, state.bestRun = 0, 0, 0, 0
        state.runStartFloors = 0
        state.rewards = {}
        state.startedAt = os.clock()
        setStatus(string.format("Farming queue (%d): %s", #state.queue, tostring(state.towerId)))
        thread = task.spawn(TowerController and farmLoopGame or farmLoop, myId)
        if TowerController then
            task.spawn(function()
                while isCurrent(myId) do
                    task.wait(20)
                    if isCurrent(myId) then equipBest() end
                end
            end)
        end
        refreshFarmUI()
    end

    local function stop()
        local wasRunning = state.running
        state.running = false
        state.runId = state.runId + 1
        if thread then pcall(task.cancel, thread); thread = nil end
        if not wasRunning then setStatus("Stopped") return end
        setStatus("Stopping...")
        task.spawn(function()
            pcall(function() RF.CancelTower:InvokeServer() end)
            task.wait(0.15)
            pcall(function() RF.CompleteTowerFloor:InvokeServer() end)
            task.wait(0.2)
            refreshFarmUI()
            setStatus("Stopped")
        end)
    end

    onCleanup(function()
        state.running = false
        state.runId = state.runId + 1
        if thread then pcall(task.cancel, thread) end
    end)

    P.onClick(startBtn, start)
    P.onClick(stopBtn, stop)
    P.onClick(equipBtn, function()
        equipBest()
        setStatus("Team updated (equip best)")
    end)
    P.onClick(collectBtn, function()
        CONFIG.AUTO_COLLECT = not CONFIG.AUTO_COLLECT
        refreshFarmUI(); persistTF()
    end)
    P.onClick(potionBtn, function()
        CONFIG.AUTO_POTIONS = not CONFIG.AUTO_POTIONS
        refreshFarmUI(); persistTF()
    end)
    P.onClick(hideBtn, function()
        CONFIG.HIDE_TOWER_UI = not CONFIG.HIDE_TOWER_UI
        if CONFIG.HIDE_TOWER_UI then task.spawn(hideTowerScreen) end
        refreshFarmUI(); persistTF()
    end)
    P.onClick(equipAutoBtn, function()
        CONFIG.AUTO_EQUIP_BEST = not CONFIG.AUTO_EQUIP_BEST
        setStatus(CONFIG.AUTO_EQUIP_BEST and "Auto-equip before tower: ON" or "Auto-equip before tower: OFF")
        refreshFarmUI(); persistTF()
    end)
    P.onClick(selAllBtn, function()
        for _, t in ipairs(SORTED) do state.selected[t.id] = true end
        refreshFarmUI(); persistTF()
    end)
    P.onClick(selNoneBtn, function()
        for _, t in ipairs(SORTED) do state.selected[t.id] = false end
        refreshFarmUI(); persistTF()
    end)

    persistTF = function()
        local towers = {}
        for _, t in ipairs(SORTED) do
            if state.selected[t.id] then table.insert(towers, t.id) end
        end
        OPCfg.save({
            T_MONEY = tostring(CONFIG.AUTO_COLLECT),
            T_POTIONS = tostring(CONFIG.AUTO_POTIONS),
            T_HIDE = tostring(CONFIG.HIDE_TOWER_UI),
            T_EQUIP = tostring(CONFIG.AUTO_EQUIP_BEST),
            T_TOWERS = table.concat(towers, "|"),
        })
    end

    do
        local all = OPCfg.load()
        if all.T_MONEY ~= nil then CONFIG.AUTO_COLLECT = (all.T_MONEY == "true") end
        if all.T_POTIONS ~= nil then CONFIG.AUTO_POTIONS = (all.T_POTIONS == "true") end
        if all.T_HIDE ~= nil then CONFIG.HIDE_TOWER_UI = (all.T_HIDE == "true") end
        if all.T_EQUIP ~= nil then CONFIG.AUTO_EQUIP_BEST = (all.T_EQUIP == "true") end
        if all.T_TOWERS and #all.T_TOWERS > 0 then
            local restored = {}
            for name in string.gmatch(all.T_TOWERS, "[^|]+") do
                if ALL[name] then restored[name] = true end
            end
            if next(restored) then state.selected = restored end
        end
        if not ensureTower() then
            state.selected = {[DEFAULT_TOWER] = true}
            ensureTower()
        end
    end

    refreshFarmUI()
    loop(1, refreshFarmUI, "tf-ui")

    _G.TowerFarm = {
        start = start, stop = stop, state = state, config = CONFIG,
        hideTowerScreen = hideTowerScreen, collectSlots = collectSlots,
        towerMaxFloors = towerMaxFloors,
        setTower = function(id)
            if ALL[id] then
                state.selected[id] = true
                if not state.running then state.towerId = id end
                refreshFarmUI(); persistTF()
            end
        end,
        toggleTower = function(id)
            if ALL[id] then
                state.selected[id] = not state.selected[id]
                refreshFarmUI(); persistTF()
            end
        end,
        setQueue = function(ids)
            state.selected = {}
            for _, id in ipairs(ids) do if ALL[id] then state.selected[id] = true end end
            if ensureTower() and not state.running then state.towerId, state.queueIndex = state.queue[1], 1 end
            refreshFarmUI(); persistTF()
        end,
    }
    print(string.format("[TowerFarm] loaded. towers: %d | selected: %s | mode: %s",
        #SORTED, tostring(state.towerId), TowerController and "game" or "fallback"))

    -- AUTONOMOUS: force-enable features + auto-start
    if _G.__OP_AUTONOMY ~= false then
        CONFIG.AUTO_COLLECT, CONFIG.AUTO_POTIONS, CONFIG.HIDE_TOWER_UI, CONFIG.AUTO_EQUIP_BEST = true, true, true, true
        task.delay(2, function()
            if alive() and not state.running then
                local okA = pcall(start)
                print("[TowerFarm] auto-start: " .. tostring(okA))
            end
        end)
    end
end

-- ==============================================================================
-- SECTION 2: AUTO PROGRESSION
-- ==============================================================================
do
    local FusingConfig = require(F.Fusing.FusingConfig)
    local Rebirths = require(F.Rebirth.Rebirths)
    local QuestConfig = require(F.Quests.QuestConfig)

    local DailyClaim = NET.DailyRewardService.RE.Claim
    local OfflineClaim = NET.OfflineEarningsService.RE.Claim
    local GroupClaim = NET.GroupRewardService.RE.Claim
    local QuestClaim = NET.QuestService.RE.Claim
    local RebirthRE = NET.RebirthService.RE.Rebirth
    local BuyUpgradeRE = NET.RE.BuyUpgrade
    local TraitRollRE = NET.TraitService.RE.Roll
    local TraitProtectRE = NET.TraitService.RE.SetTraitProtected
    local GradeRollRE = NET.GradeService.RE.Roll
    local GradeProtectRE = NET.GradeService.RE.SetGradeProtected
    local FuseRE = NET.FusingService.RE.Fuse

    local CONFIG = {
        CLAIMS = true, CLAIMS_INTERVAL = 60,
        REBIRTH = false,
        UPGRADES = true, UPGRADES_INTERVAL = 30,
        TRAITS = true, TRAIT_PAUSE = 1.6, TRAIT_MAX_PER_UNIT = 60,
        GRADES = true, GRADE_PAUSE = 1.6, GRADE_MAX_PER_UNIT = 80,
        FUSE = true, FUSE_INTERVAL = 5, FUSE_DUPES_ONLY = true, FUSE_ONLY_UNMUTATED = false,
        FUSE_SAME_NAME_PRIO = true,
        FUSE_MAX_SPEND_PCT = 0.15,
        FUSE_PROTECT_TOP_PCT = 0.10,
        PROTECT = true,
        MIN_REROLLS_KEEP = 0,
        MIN_GEMS_KEEP = 0,
    }

    local TRAIT_CHOICES = {"Damage III", "Money III", "Health III", "Samurai", "Shogun", "Monarch", "Transcendent", "Eternal"}
    local GRADE_CHOICES = {"A+", "S", "S+", "Z", "Z+", "神"}
    local RARE_TRAITS = {"Samurai", "Shogun", "Monarch", "Transcendent", "Eternal"}
    local RARE_GRADES = {"S", "S+", "Z", "Z+", "神"}

    local function setOf(list)
        local t = {}
        for _, v in ipairs(list) do t[v] = true end
        return t
    end

    local state = {
        running = false, startedAt = 0,
        claims = 0, rebirths = 0, upgrades = 0,
        traitRolls = 0, traitHits = 0, lastTrait = "-",
        gradeRolls = 0, gradeHits = 0, lastGrade = "-",
        fuses = 0, lastFuse = "-",
        traitTries = {}, gradeTries = {},
        targetUnit = "-", note = "-",
        targetTraits = setOf(TRAIT_CHOICES),
        targetGrades = setOf(GRADE_CHOICES),
        newUnits = {}, seenUnits = {},
    }

    local refreshProgUI, persistAP

    local function isProtected(map, key)
        if map == nil or key == nil then return false end
        local ok, val = pcall(function()
            local v = map[key]
            if v == nil then return false end
            if type(v) == "boolean" then return v end
            return v()
        end)
        return (ok and val) and true or false
    end

    local function unitDone(attrs)
        return attrs and attrs.trait and state.targetTraits[attrs.trait]
            and attrs.grade and state.targetGrades[attrs.grade] and true or false
    end

    local function myUnits()
        local list, copies = {}, {}
        for uuid, item in pairs(Data.inv()) do
            if Data.isUnit(item) then
                copies[item.name] = (copies[item.name] or 0) + 1
                local attrs = item.attributes or {}
                if not attrs.locked then
                    table.insert(list, {uuid = uuid, name = item.name, attrs = attrs, chance = Data.chance(item)})
                end
            end
        end
        table.sort(list, function(a, b) return (a.chance or 1e18) < (b.chance or 1e18) end)
        return list, copies
    end

    local function standUnits()
        local onStand = {}
        for _, s in pairs(Data.slots()) do
            if type(s) == "table" and s.unitId then onStand[s.unitId] = true end
        end
        local list = {}
        for uuid, item in pairs(Data.inv()) do
            if onStand[uuid] and Data.isUnit(item) then
                local attrs = item.attributes or {}
                if not attrs.locked then
                    table.insert(list, {uuid = uuid, name = item.name, attrs = attrs, chance = Data.chance(item)})
                end
            end
        end
        table.sort(list, function(a, b) return (a.chance or 0) > (b.chance or 0) end)
        return list
    end

    local function rebirthCost()
        local nxt = try(function() return Rebirths.GetNext(Data.rebirth()) end)
        return type(nxt) == "table" and tonumber(nxt.cost) or nil
    end

    local function applyProtect()
        for _, t in ipairs(RARE_TRAITS) do pcall(function() TraitProtectRE:FireServer(t, true) end) end
        for _, g in ipairs(RARE_GRADES) do pcall(function() GradeProtectRE:FireServer(g, true) end) end
    end

    -- ---------------- claims ----------------
    local function claimsOnce()
        pcall(function() DailyClaim:FireServer() end)
        pcall(function() OfflineClaim:FireServer() end)
        pcall(function() GroupClaim:FireServer() end)
        local periods = QuestConfig.Periods
        if type(periods) == "table" then
            for period, pcfg in pairs(periods) do
                local st = try(function() return DC.Quests[period]() end)
                local expiresAt = (type(st) == "table" and tonumber(st.expiresAt)) or 0
                local list = type(pcfg) == "table" and pcfg.quests or nil
                if type(list) == "table" then
                    for id, q in pairs(list) do
                        local qid = (type(q) == "table" and (q.id or q.name)) or id
                        pcall(function() QuestClaim:FireServer(period, qid, expiresAt) end)
                        task.wait(0.05)
                    end
                end
            end
        end
        state.claims = state.claims + 1
    end

    loop(function() return CONFIG.CLAIMS_INTERVAL end, function()
        if state.running and CONFIG.CLAIMS then claimsOnce() end
    end, "claims")

    -- ---------------- rebirth ----------------
    loop(10, function()
        if not (state.running and CONFIG.REBIRTH) then return end
        if _G.__OP_SMART_MONEY and _G.__OP_REBIRTH_BLOCK then return end
        local cost = rebirthCost()
        if cost and Data.money() >= cost then
            pcall(function() RebirthRE:FireServer() end)
            state.rebirths = state.rebirths + 1
            task.wait(1)
        end
    end, "rebirth")

    -- ---------------- upgrades (only without smart spending) ----------------
    loop(function() return CONFIG.UPGRADES_INTERVAL end, function()
        if not (state.running and CONFIG.UPGRADES) or _G.__OP_SMART_MONEY then return end
        local m = Data.money()
        local list = {}
        for id, cfg in pairs(UpgradesCfg) do
            local price = type(cfg) == "table" and tonumber(cfg.price) or nil
            if price and price <= m and Data.upgradeAvailable(id) then
                table.insert(list, {id = id, price = price})
            end
        end
        table.sort(list, function(a, b) return a.price < b.price end)
        local left = m
        for _, u in ipairs(list) do
            if not state.running or math.min(Data.money(), left) < u.price then break end
            pcall(function() BuyUpgradeRE:FireServer(u.id) end)
            left = left - u.price
            state.upgrades = state.upgrades + 1
            task.wait(0.1)
        end
    end, "upgrades")

    -- ---------------- traits / grades ----------------
    local function needsRoll(u, field, goodSet, protectMap, tries, maxTries)
        local v = u.attrs[field]
        if v and goodSet[v] then return false end
        if v and isProtected(protectMap, v) then return false end
        if (tries[u.uuid] or 0) >= maxTries then return false end
        return true
    end

    local function rollTarget(field, goodSet, protectMap, tries, maxTries)
        for _, u in ipairs(standUnits()) do
            if needsRoll(u, field, goodSet, protectMap, tries, maxTries) then return u end
        end
        return nil
    end

    local function doRoll(field)
        local isTrait = field == "trait"
        local goodSet = isTrait and state.targetTraits or state.targetGrades
        local protectMap = try(function() return isTrait and DC.ProtectedTraits or DC.ProtectedGrades end)
        local tries = isTrait and state.traitTries or state.gradeTries
        local maxTries = isTrait and CONFIG.TRAIT_MAX_PER_UNIT or CONFIG.GRADE_MAX_PER_UNIT
        local target = rollTarget(field, goodSet, protectMap, tries, maxTries)
        if not target then return end

        state.targetUnit = target.name
        local before = target.attrs[field]
        local remote = isTrait and TraitRollRE or GradeRollRE
        pcall(function() remote:FireServer(target.uuid) end)
        tries[target.uuid] = (tries[target.uuid] or 0) + 1
        if isTrait then state.traitRolls = state.traitRolls + 1 else state.gradeRolls = state.gradeRolls + 1 end

        local item, after = nil, before
        for _ = 1, 10 do
            task.wait(0.1)
            item = Data.inv()[target.uuid]
            after = item and item.attributes and item.attributes[field]
            if after ~= before then break end
        end
        if after and after ~= before then
            if isTrait then
                state.lastTrait = tostring(after)
                if goodSet[after] then state.traitHits = state.traitHits + 1 end
            else
                state.lastGrade = tostring(after)
                if goodSet[after] then state.gradeHits = state.gradeHits + 1 end
            end
        end
        if item and unitDone(item.attributes) then state.newUnits[target.uuid] = nil end
    end

    loop(function() return CONFIG.TRAIT_PAUSE end, function()
        if state.running and CONFIG.TRAITS and Data.amountOf("Trait Reroll") - CONFIG.MIN_REROLLS_KEEP > 0 then
            doRoll("trait")
        end
    end, "traits")

    loop(function() return CONFIG.GRADE_PAUSE end, function()
        if state.running and CONFIG.GRADES and Data.amountOf("Gems") - CONFIG.MIN_GEMS_KEEP > 0 then
            doRoll("grade")
        end
    end, "grades")

    loop(6, function()
        if not state.running then return end
        local list = myUnits()
        for _, u in ipairs(list) do
            if not state.seenUnits[u.uuid] then
                state.seenUnits[u.uuid] = true
                if not unitDone(u.attrs) then state.newUnits[u.uuid] = true end
            end
        end
        local inv = Data.inv()
        for uuid in pairs(state.newUnits) do
            local item = inv[uuid]
            if not item or unitDone(item.attributes) then state.newUnits[uuid] = nil end
        end
    end, "new-units")

    -- ---------------- fusion of duplicates ----------------
    local function fusionCandidates()
        local list, copies = myUnits()
        local busy = Data.busyUnits()

        local protectPct = tonumber(CONFIG.FUSE_PROTECT_TOP_PCT) or 0.10
        local scored = {}
        for _, u in ipairs(list) do
            local s = u.chance or 1
            local t, g = u.attrs.trait, u.attrs.grade
            if t and state.targetTraits[t] then s = s * 5 end
            if g and state.targetGrades[g] then s = s * 5 end
            if u.attrs.mutation then s = s * 2 end
            table.insert(scored, {uuid = u.uuid, score = s})
        end
        table.sort(scored, function(a, b) return a.score > b.score end)
        local protectN = math.max(1, math.ceil(#scored * protectPct))
        local protectedSet = {}
        for i = 1, math.min(protectN, #scored) do protectedSet[scored[i].uuid] = true end

        local eligible = {}
        for _, u in ipairs(list) do
            local t, g = u.attrs.trait, u.attrs.grade
            local ok = u.chance ~= nil and not busy[u.uuid] and not protectedSet[u.uuid]
                and not (t and state.targetTraits[t]) and not (g and state.targetGrades[g])
                and ((not CONFIG.FUSE_ONLY_UNMUTATED) or u.attrs.mutation == nil)
            if ok then table.insert(eligible, u) end
        end

        local picks = {}
        if CONFIG.FUSE_DUPES_ONLY then
            local byName = {}
            for _, u in ipairs(eligible) do
                if not byName[u.name] then byName[u.name] = {} end
                table.insert(byName[u.name], u)
            end

            if CONFIG.FUSE_SAME_NAME_PRIO then
                local bestGroup, bestAvgCh = nil, math.huge
                for name, grp in pairs(byName) do
                    local totalCopies = copies[name] or 0
                    local canUse = math.min(#grp, totalCopies - 1)
                    if canUse >= 3 then
                        local avg = 0
                        for i = 1, 3 do avg = avg + (grp[i].chance or 0) end
                        avg = avg / 3
                        if avg < bestAvgCh then bestGroup, bestAvgCh = grp, avg end
                    end
                end
                if bestGroup then
                    for i = 1, 3 do table.insert(picks, bestGroup[i]) end
                    return picks
                end
            end

            local usedFromName = {}
            for _, u in ipairs(eligible) do
                if #picks >= 3 then break end
                local left = (copies[u.name] or 1) - (usedFromName[u.name] or 0)
                if left >= 2 then
                    usedFromName[u.name] = (usedFromName[u.name] or 0) + 1
                    table.insert(picks, u)
                end
            end
        else
            for _, u in ipairs(eligible) do
                if #picks >= 3 then break end
                table.insert(picks, u)
            end
        end
        return picks
    end

    loop(function() return CONFIG.FUSE_INTERVAL end, function()
        if not (state.running and CONFIG.FUSE) then return end
        local picks = fusionCandidates()
        if #picks < 3 then return end
        local sum = picks[1].chance + picks[2].chance + picks[3].chance
        local cost = tonumber(try(function() return FusingConfig.GetCost(sum) end))
        if not cost then return end
        local m = Data.money()
        local maxSpend = m * math.clamp(tonumber(CONFIG.FUSE_MAX_SPEND_PCT) or 0.15, 0, 1)
        if cost > maxSpend then return end
        pcall(function() FuseRE:FireServer(picks[1].uuid, picks[2].uuid, picks[3].uuid) end)
        markSpent(cost) -- FIX: otherwise smart spending counted fusion as an "income drop"
        state.fuses = state.fuses + 1
        state.lastFuse = picks[1].name .. " + " .. picks[2].name .. " + " .. picks[3].name
        task.wait(3.2)
    end, "fuse")

    task.delay(1, function()
        if alive() and CONFIG.PROTECT then applyProtect() end
    end)

    -- ---------------- UI ----------------
    local P = UI.panel("AutoProgression", "AutoProgression (Anime Dice)", 360, 456, 380, 240)
    local statusLbl = P.label(26, 14, Theme.Sub)
    statusLbl.Text = "Configure the toggles and press START"
    local resLbl = P.label(42, 14, Theme.Gold)
    local statLbl = P.label(58, 14, Theme.Text)
    local statLbl2 = P.label(74, 14, Theme.Text)
    local targetLbl = P.label(90, 14, Theme.Sub)

    local startBtn = P.button("START", 8, 112, 110, 28, Theme.Success)
    local stopBtn = P.button("STOP", 126, 112, 110, 28, Theme.Danger)
    local protectBtn = P.button("", 244, 112, 108, 28, Theme.SuccessDark)

    local toggles = {
        {key = "CLAIMS", label = "Claims"},
        {key = "REBIRTH", label = "Rebirth"},
        {key = "UPGRADES", label = "Upgrades"},
        {key = "TRAITS", label = "Traits"},
        {key = "GRADES", label = "Grades"},
        {key = "FUSE", label = "Fusion"},
    }
    local toggleBtns = {}
    for i, t in ipairs(toggles) do
        local col = (i - 1) % 2
        local rowN = (i - 1) // 2
        local b = P.button("", col == 0 and 8 or 184, 148 + rowN * 32, 168, 26, Theme.Off)
        toggleBtns[t.key] = {btn = b, label = t.label}
        P.onClick(b, function()
            CONFIG[t.key] = not CONFIG[t.key]
            refreshProgUI(); persistAP()
        end)
    end

    local afkLbl = P.label(244, 14, Theme.Sub)
    local rewLbl = P.label(262, 14, Theme.Sub)
    local rewLbl2 = P.label(278, 14, Theme.Sub)
    local rewLbl3 = P.label(294, 14, Theme.Sub)

    P.label(310, 14, Theme.Gold).Text = "Grade target (gems):"
    local gradeSelBtns = {}
    for idx, name in ipairs(GRADE_CHOICES) do
        local b = P.button(name, 8 + (idx - 1) * 58, 326, 54, 22, Theme.Off)
        gradeSelBtns[name] = b
        P.onClick(b, function()
            state.targetGrades[name] = (not state.targetGrades[name]) or nil
            refreshProgUI(); persistAP()
        end)
    end
    P.label(352, 14, Theme.Gold).Text = "Trait target (rerolls):"
    local traitSelBtns = {}
    for idx, name in ipairs(TRAIT_CHOICES) do
        local rowN = (idx <= 4) and 0 or 1
        local col = (idx - 1) % 4
        local b = P.button(name, 8 + col * 86, 368 + rowN * 24, 84, 22, Theme.Off)
        traitSelBtns[name] = b
        P.onClick(b, function()
            state.targetTraits[name] = (not state.targetTraits[name]) or nil
            refreshProgUI(); persistAP()
        end)
    end

    local hintLbl = P.multiline(420, 30, Theme.Sub)
    hintLbl.Text = "Rebirth: enable the toggle (with Smart Spending it only happens when profitable). Fusion only eats duplicates."

    local function setStatus(text) statusLbl.Text = tostring(text) end

    refreshProgUI = function()
        stopBtn.BackgroundColor3 = state.running and Theme.Danger or Theme.DangerDim
        UI.paintToggle(protectBtn, CONFIG.PROTECT, "Protect")
        for key, t in pairs(toggleBtns) do UI.paintToggle(t.btn, CONFIG[key], t.label) end
        for name, b in pairs(gradeSelBtns) do
            b.BackgroundColor3 = state.targetGrades[name] and Theme.SuccessDark or Theme.Off
        end
        for name, b in pairs(traitSelBtns) do
            b.BackgroundColor3 = state.targetTraits[name] and Theme.SuccessDark or Theme.Off
        end
        local cost = rebirthCost()
        resLbl.Text = string.format("RB %d | Money %s | Reroll %d | Gems %s",
            Data.rebirth(), formatShort(Data.money()), Data.amountOf("Trait Reroll"), formatShort(Data.amountOf("Gems")))
        statLbl.Text = string.format("Claims %d | Rebirths %d | Upgrades %d | Fusions %d",
            state.claims, state.rebirths, state.upgrades, state.fuses)
        statLbl2.Text = string.format("Traits %d/success %d (%s) | Grades %d/success %d (%s)",
            state.traitRolls, state.traitHits, state.lastTrait, state.gradeRolls, state.gradeHits, state.lastGrade)
        targetLbl.Text = state.running and ("Active | unit: " .. tostring(state.targetUnit))
            or ("Idle | rebirth: " .. formatShort(cost))
        afkLbl.Text = "AFK Guard: " .. (_G.__OP_AFK_HOOKED and "ON" or "partial")
        rewLbl.Text = "Last fusion: " .. state.lastFuse
        local blocked = _G.__OP_SMART_MONEY and _G.__OP_REBIRTH_BLOCK
        rewLbl2.Text = blocked and "Rebirth held back by smart spending (Farm Boost)"
            or (state.note ~= "-" and ("Note: " .. state.note) or "")
        rewLbl3.Text = string.format("AFK teleports blocked: %d", _G.__AFKTeleports or 0)
    end

    persistAP = function()
        local kvs = {}
        for key, v in pairs(CONFIG) do
            if type(v) == "boolean" or type(v) == "number" then kvs["P_" .. key] = v end
        end
        local tl, gl = {}, {}
        for _, name in ipairs(TRAIT_CHOICES) do if state.targetTraits[name] then table.insert(tl, name) end end
        for _, name in ipairs(GRADE_CHOICES) do if state.targetGrades[name] then table.insert(gl, name) end end
        kvs.P_TRAITS = table.concat(tl, "|")
        kvs.P_GRADES = table.concat(gl, "|")
        OPCfg.save(kvs)
    end

    do
        local all = OPCfg.load()
        OPCfg.applyTo(CONFIG, "P_", all)
        local function applyChoiceList(raw, choices, target)
            if raw == nil then return end
            local allowed = setOf(choices)
            table.clear(target)
            for name in string.gmatch(raw, "[^|]+") do
                if allowed[name] then target[name] = true end
            end
        end
        applyChoiceList(all.P_TRAITS, TRAIT_CHOICES, state.targetTraits)
        applyChoiceList(all.P_GRADES, GRADE_CHOICES, state.targetGrades)
    end

    -- AUTONOMOUS: all progression features enabled
    if _G.__OP_AUTONOMY ~= false then
        CONFIG.CLAIMS, CONFIG.REBIRTH, CONFIG.UPGRADES = true, true, true
        CONFIG.TRAITS, CONFIG.GRADES, CONFIG.FUSE, CONFIG.PROTECT = true, true, true, true
    end

    local function start()
        if state.running then return end
        state.running = true
        state.startedAt = os.clock()
        state.note = "-"
        setStatus("Running")
        if CONFIG.PROTECT then applyProtect() end
        if CONFIG.CLAIMS then task.spawn(function() pcall(claimsOnce) end) end
        refreshProgUI()
    end

    local function stop()
        state.running = false
        setStatus("Stopped")
        refreshProgUI()
    end

    onCleanup(function() state.running = false end)

    P.onClick(startBtn, start)
    P.onClick(stopBtn, stop)
    P.onClick(protectBtn, function()
        CONFIG.PROTECT = not CONFIG.PROTECT
        if CONFIG.PROTECT then applyProtect() end
        refreshProgUI(); persistAP()
    end)

    refreshProgUI()
    loop(1, refreshProgUI, "ap-ui")

    _G.AutoProgression = {
        start = start, stop = stop, state = state, config = CONFIG,
        claimsOnce = claimsOnce, money = Data.money, amountOf = Data.amountOf,
        standUnits = standUnits,
        save = persistAP,
    }
    print("[AutoProgression] loaded. money=" .. formatShort(Data.money()) .. " RB=" .. tostring(Data.rebirth()))

    -- AUTONOMOUS: auto-start progression
    if _G.__OP_AUTONOMY ~= false then
        task.delay(2.5, function()
            if alive() and not state.running then
                local okA = pcall(start)
                print("[AutoProgression] auto-start: " .. tostring(okA))
            end
        end)
    end
end

-- ==============================================================================
-- SECTION 3: FARM BOOST — dice, spins, auto-roll, dynamic auto-sell,
-- income units on stands, stand upgrades, smart spending, smart inventory cleanup.
-- ==============================================================================
do
    local Dice = require(F.Rolling.Dice)
    local PlotConfig = require(F.Plot.PlotConfig)
    local BuffController = require(F.Buffs.BuffController)
    local Rebirths = require(F.Rebirth.Rebirths)
    local UnitUtil = require(F.Inventory.Kinds.Unit.UnitUtil)
    local Rarities = require(RS.Framework.Other.Rarities)
    local Variants = require(F.Inventory.Kinds.Unit.Variants)

    local BuyDiceRE = NET.DiceShopService.RE.BuyDice
    local EquipDiceRE = NET.DiceShopService.RE.EquipDice
    local SpinRE = NET.SpinService.RE.Use
    local SetAutoRollRE = NET.RollService.RE.SetAutoRoll
    local UpdateAutoSellRE = NET.SellService.RE.UpdateAutoSell
    local LevelUpSlotRE = NET.PlotService.RE.LevelUpSlot
    local InteractSlotRE = NET.PlotService.RE.InteractSlot
    local EquipUnitRF = NET.UnitService.RF.Equip
    local UnequipUnitRF = NET.UnitService.RF.Unequip
    local BuyUpgradeRE = NET.RE.BuyUpgrade
    local SellInventoryRF = NET.SellService.RF.SellInventory

    local CONFIG = {
        DICE_BUY = true, DICE_EQUIP = true, SPINS = true, AUTO_ROLL = true, AUTO_SELL = true,
        SLOTS = true,
        SMART_MONEY = true,
        SMART_CLEAN = true,
        EQUIP_RAREST = true,    -- put the visible "1 in N" on stands (variant/income — tie-breakers)
        EQUIP_MIN_GAIN = 1.05,  -- change a unit on a stand only if the new income is 5%+ better
        EQUIP_INTERVAL = 30,
        PERSIST = true,
        CLEAN_FREE_SLOTS = 15, CLEAN_INTERVAL = 25, CLEAN_MAX_PER_CYCLE = 40,
        CLEAN_DYNAMIC = true,
        SELL_KEEP_FRACTION = 0.35, SELL_MIN_KEEP = 20,
        SMART_INTERVAL = 15,
        SLOT_ACTIONS_PER_CYCLE = 8,
        REBIRTH_SAVE = 0.65, REBIRTH_MIN_GAIN = 0.03,
        DICE_MIN_GAIN = 1.15,
        DICE_PRIORITY = true,    -- FIX: buy dice as soon as money allows (priority over stands)
        DICE_SAVE = 0.75,        -- FIX: at what fraction of the price to start saving for a die (blocks other spending)
        LUCK_TO_INCOME = 0.4,   -- empirical: +100% luck ≈ +40% income (same for die and rebirth)
        UPGRADE_EST_GAIN = 0.02, -- estimated income increase from a tree upgrade
        SLOT_ABS_MIN_ROI = 0, SLOT_MAX_PAYBACK = 1800, SLOT_BUDGET_PCT = 0.12, -- MAX_PAYBACK — manual mode only
        UPGRADE_SHARE = 0.4, RESERVE_GOAL_PCT = 0.75,
        MAX_PAYBACK_H = 3,       -- unified payback limit for all options (3 hours)
        SPEND_BEFORE_RB_ONLY = true, -- with rebirth enabled, only buy what pays back before it
        DICE_INTERVAL = 45, SPIN_INTERVAL = 30, ROLL_INTERVAL = 60, SELL_INTERVAL = 60, SLOT_INTERVAL = 15,
    }

    local state = {
        running = false,
        diceBought = 0, diceEquip = "-", lastBuy = "-",
        spinsUsed = 0, lastSpin = "-",
        slotsFired = 0, lastSlot = "-",
        autorollSet = 0, sellSet = 0,
        sellThreshold = 0, sellKeep = 0, sellTotal = 0,
        smartNote = "-", smartUpgrades = 0,
        incomePerSec = nil, lastMoney = nil, lastMoneyT = nil, lastRb = nil,
        unitDropRate = nil, seenUnitSet = nil, seenUnitT = nil,
        cleaned = 0, equipChanges = 0, equipNote = "-",
        moneyStart = 0, startedAt = 0,
    }

    local refreshBoostUI

    -- ---------------- helpers ----------------
    local function ownedDice()
        local t = try(function() return DC.OwnedDice() end)
        return type(t) == "table" and t or {}
    end
    local function currentDice() return try(function() return DC.Dice() end) end
    local function diceLuck(name)
        local cfg = name and try(function() return Dice.Get(name) end)
        return type(cfg) == "table" and tonumber(cfg.luck) or nil
    end
    local function bestOwnedDice()
        local best, bestLuck = nil, -1
        for name, owned in pairs(ownedDice()) do
            if owned then
                local luck = diceLuck(name)
                if luck and luck > bestLuck then best, bestLuck = name, luck end
            end
        end
        return best, bestLuck >= 0 and bestLuck or nil
    end
    local function maxSlots()
        return tonumber(try(function() return PlotConfig.GetMaxSlots() end)) or 20
    end
    local function storageCap()
        return tonumber(try(function() return BuffController.GetBuff("Unit Storage") end)) or 0
    end
    local function unitStats()
        local units = 0
        for _, item in pairs(Data.inv()) do
            if Data.isUnit(item) then units = units + 1 end
        end
        return units, storageCap()
    end
    local function keepCount(storage)
        return math.clamp(math.floor((storage > 0 and storage or 100) * CONFIG.SELL_KEEP_FRACTION), CONFIG.SELL_MIN_KEEP, 1000000)
    end

    -- slots unlocked at the given rebirth count
    local function unlockedSlots(rb)
        local list = {}
        for i = 1, maxSlots() do
            local need = tonumber(try(function() return PlotConfig.GetSlotRebirthRequirement(i) end))
            if need ~= nil and rb >= need then table.insert(list, i) end
        end
        return list
    end

    local function computeSellThreshold()
        local units, storage = unitStats()
        local keep = keepCount(storage)
        local fillRate = storage > 0 and (units / storage) or 0
        if fillRate > 0.8 then
            keep = math.max(CONFIG.SELL_MIN_KEEP, math.floor(keep * (1 - (fillRate - 0.8) * 2)))
        end
        local chances = {}
        for _, item in pairs(Data.inv()) do
            if Data.isUnit(item) then
                local ch = Data.chance(item)
                if ch then table.insert(chances, ch) end
            end
        end
        if #chances <= keep then return 0, keep, #chances end
        table.sort(chances, function(a, b) return a > b end)
        return chances[keep], keep, #chances
    end

    -- ---------------- best on stands ----------------
    local function readSlots()
        local out = {}
        local slots = Data.slots()
        for i = 1, maxSlots() do
            local s = slots[tostring(i)] or slots[i]
            if type(s) == "table" and s.unitId then out[i] = s.unitId end
        end
        return out
    end

    local function unitRank(item, key)
        local cfg = Data.config(item.name)
        if not (cfg and cfg.kind == "Unit") then return nil end
        local attrs = item.attributes or {}
        local rarity = try(function() return cfg.getRarity and cfg.getRarity(attrs) or cfg.rarity end) or cfg.rarity
        local r = try(function() return Rarities.Get(rarity) end)
        local variantMult = 1
        if cfg.variant and type(Variants[cfg.variant]) == "table" then
            variantMult = tonumber(Variants[cfg.variant].chanceMultiplier) or 1
        end
        local income = 0
        if type(cfg.income) == "function" then
            income = tonumber(try(function() return cfg.income(attrs) end)) or 0
        end
        return {
            key = key,
            income = income, -- income including level/trait/grade/mutation
            sortOrder = type(r) == "table" and tonumber(r.sortOrder) or 0,
            chance = Data.chance(item) or 0,
            variantMult = variantMult,
            order = tonumber(cfg.order) or 0,
        }
    end

    -- v2.3: main criterion is the VISIBLE chance "1 in N" (as the game shows it), higher = rarer.
    -- Variant multiplier (Huge ×10 / Titanic ×100) and income — only tie-breakers.
    local function rarityScore(r)
        return tonumber(r.chance) or 0
    end
    local function variantRank(r)
        return tonumber(r.variantMult) or 1
    end
    local function betterFirst(a, b)
        local ra, rb = rarityScore(a), rarityScore(b)
        if ra ~= rb then return ra > rb end
        if variantRank(a) ~= variantRank(b) then return variantRank(a) > variantRank(b) end
        if a.income ~= b.income then return a.income > b.income end
        if a.order ~= b.order then return a.order > b.order end
        return tostring(a.key) < tostring(b.key)
    end

    local function equipRarest()
        local unlocked = unlockedSlots(Data.rebirth())
        if #unlocked == 0 then return 0 end

        local list, byKey = {}, {}
        for key, item in pairs(Data.inv()) do
            if type(item) == "table" and item.name and tonumber(item.amount) == 1 then
                local rank = unitRank(item, key)
                if rank then
                    table.insert(list, rank)
                    byKey[key] = rank
                end
            end
        end
        table.sort(list, betterFirst)

        local n = math.min(#unlocked, #list)
        local top = {}
        for i = 1, n do top[list[i].key] = true end

        -- units from the top already on stands are NOT moved (no unnecessary swaps)
        local cur = readSlots()
        local placed, freeSlots = {}, {}
        for _, slot in ipairs(unlocked) do
            local u = cur[slot]
            if u and top[u] then
                placed[u] = true
            else
                table.insert(freeSlots, {slot = slot, occ = u, occIncome = u and byKey[u] and byKey[u].income or -1})
            end
        end
        -- replace the weakest first
        table.sort(freeSlots, function(a, b) return a.occIncome < b.occIncome end)

        local toPlace = {}
        for i = 1, n do
            local k = list[i].key
            if not placed[k] then table.insert(toPlace, list[i]) end
        end
        if #toPlace == 0 then return 0 end

        local pairsToDo = {}
        for i, want in ipairs(toPlace) do
            local fs = freeSlots[i]
            if not fs then break end
            -- v2.3: replace if the slot is empty / the occupant is unknown, OR the new one is RARER by
            -- visible "1 in N", OR same chance but higher variant, OR same rank but noticeably more income
            local occRank = fs.occ and byKey[fs.occ] or nil
            local replace = false
            if fs.occ == nil or occRank == nil then
                replace = true
            elseif rarityScore(want) > rarityScore(occRank) then
                replace = true
            elseif rarityScore(want) == rarityScore(occRank) and variantRank(want) > variantRank(occRank) then
                replace = true
            elseif rarityScore(want) == rarityScore(occRank) and variantRank(want) == variantRank(occRank)
                and want.income > math.max(fs.occIncome, 0) * CONFIG.EQUIP_MIN_GAIN then
                replace = true
            end
            if replace then
                table.insert(pairsToDo, {slot = fs.slot, want = want.key})
            end
        end
        if #pairsToDo == 0 then return 0 end

        pcall(function() UnequipUnitRF:InvokeServer() end)
        task.wait(0.55)
        local moved = 0
        for _, p in ipairs(pairsToDo) do
            if not alive() then break end
            local cur2 = readSlots()
            if cur2[p.slot] ~= p.want then
                local src = nil
                for s2, u2 in pairs(cur2) do
                    if u2 == p.want then src = s2 break end
                end
                local held = false
                if src then
                    pcall(function() InteractSlotRE:FireServer(src) end)
                    task.wait(0.6)
                    held = readSlots()[src] == nil
                else
                    local okE, res = pcall(function() return EquipUnitRF:InvokeServer(p.want) end)
                    task.wait(0.6)
                    held = okE and res ~= false
                end
                if held then
                    pcall(function() InteractSlotRE:FireServer(p.slot) end)
                    task.wait(0.6)
                    if readSlots()[p.slot] == p.want then moved = moved + 1 end
                end
            end
        end
        pcall(function() UnequipUnitRF:InvokeServer() end)
        state.equipChanges = state.equipChanges + moved
        state.equipNote = string.format("Stands: %d changes (rarest, slots %d)", moved, #unlocked)
        return moved
    end

    -- ---------------- smart cleanup ----------------
    local function unitCompositeScore(item, dupeCount)
        local ch = Data.chance(item) or 1
        local attrs = item.attributes or {}
        local apState = _G.AutoProgression and _G.AutoProgression.state
        local goodTraits = apState and apState.targetTraits
        local goodGrades = apState and apState.targetGrades
        local score = ch
        local t, g = attrs.trait, attrs.grade
        if t and goodTraits and goodTraits[t] then score = score * 5 end
        if g and goodGrades and goodGrades[g] then score = score * 5 end
        if attrs.mutation then score = score * 2 end
        if dupeCount and dupeCount >= 3 then score = score * 1.5 end
        return score
    end

    local function cleanCandidates(need)
        local protected = Data.busyUnits()
        local units, storage = unitStats()
        local keep = keepCount(storage)
        local dupes = {}
        local list = {}
        for uuid, item in pairs(Data.inv()) do
            if Data.isUnit(item) then
                local attrs = item.attributes or {}
                local ch = Data.chance(item)
                if not attrs.locked and ch then
                    dupes[item.name] = (dupes[item.name] or 0) + 1
                    table.insert(list, {uuid = uuid, chance = ch, attrs = attrs, name = item.name, item = item})
                end
            end
        end
        for _, u in ipairs(list) do
            u.score = unitCompositeScore(u.item, dupes[u.name])
        end
        table.sort(list, function(a, b) return a.score < b.score end)
        for i = #list, math.max(1, #list - keep + 1), -1 do protected[list[i].uuid] = true end

        local apState = _G.AutoProgression and _G.AutoProgression.state
        local goodTraits = apState and apState.targetTraits
        local goodGrades = apState and apState.targetGrades
        local out = {}
        for _, u in ipairs(list) do
            if #out >= need then break end
            if not protected[u.uuid] then
                local t, g = u.attrs.trait, u.attrs.grade
                local valuableT = t and ((not goodTraits) or goodTraits[t])
                local valuableG = g and ((not goodGrades) or goodGrades[g])
                if not valuableT and not valuableG then table.insert(out, u.uuid) end
            end
        end
        return out, units, storage
    end

    -- ---------------- saving ----------------
    local function saveCfg(force)
        local kvs = {PERSIST = CONFIG.PERSIST}
        if CONFIG.PERSIST or force then
            for k, v in pairs(CONFIG) do
                if type(v) == "boolean" or type(v) == "number" then kvs[k] = v end
            end
        end
        OPCfg.save(kvs)
    end
    local function loadCfg() OPCfg.applyTo(CONFIG, "") end
    loadCfg()

    -- AUTONOMOUS: all Farm Boost features enabled
    if _G.__OP_AUTONOMY ~= false then
        CONFIG.DICE_BUY, CONFIG.DICE_EQUIP, CONFIG.SPINS = true, true, true
        CONFIG.AUTO_ROLL, CONFIG.AUTO_SELL, CONFIG.SLOTS = true, true, true
        CONFIG.SMART_MONEY, CONFIG.SMART_CLEAN, CONFIG.EQUIP_RAREST = true, true, true
        CONFIG.DICE_PRIORITY, CONFIG.PERSIST = true, true
    end

    -- ---------------- workers ----------------
    loop(function() return CONFIG.DICE_INTERVAL end, function()
        if not state.running then return end
        if CONFIG.DICE_BUY and not CONFIG.SMART_MONEY then
            local all = try(function() return Dice.GetAll() end)
            if type(all) == "table" then
                local list = {}
                for name, cfg in pairs(all) do
                    if type(cfg) == "table" and tonumber(cfg.price) then
                        table.insert(list, {name = name, price = tonumber(cfg.price)})
                    end
                end
                table.sort(list, function(a, b) return a.price < b.price end)
                local left = Data.money()
                for _, d in ipairs(list) do
                    if not ownedDice()[d.name] and math.min(Data.money(), left) >= d.price then
                        pcall(function() BuyDiceRE:FireServer(d.name) end)
                        left = left - d.price
                        state.diceBought = state.diceBought + 1
                        state.lastBuy = d.name
                        task.wait(0.2)
                    end
                end
            end
        end
        if CONFIG.DICE_EQUIP then
            local best = bestOwnedDice()
            if best and best ~= currentDice() then
                pcall(function() EquipDiceRE:FireServer(best) end)
                state.diceEquip = best
            end
        end
    end, "dice")

    loop(function() return CONFIG.SPIN_INTERVAL end, function()
        if not (state.running and CONFIG.SPINS) then return end
        local spins = {}
        for key, item in pairs(Data.inv()) do
            if type(item) == "table" and item.name and (tonumber(item.amount) or 0) > 0 and Data.kindOf(item.name) == "Spin" then
                table.insert(spins, {key = key, name = item.name})
            end
        end
        for _, s in ipairs(spins) do
            if not state.running then break end
            pcall(function() SpinRE:FireServer(s.key) end)
            state.spinsUsed = state.spinsUsed + 1
            state.lastSpin = s.name
            task.wait(0.12)
        end
    end, "spins")

    loop(function() return CONFIG.ROLL_INTERVAL end, function()
        if state.running and CONFIG.AUTO_ROLL then
            pcall(function() SetAutoRollRE:FireServer(true) end)
            state.autorollSet = state.autorollSet + 1
        end
    end, "autoroll")

    loop(function() return CONFIG.SELL_INTERVAL end, function()
        if not (state.running and CONFIG.AUTO_SELL) then return end
        local threshold, keep, total = computeSellThreshold()
        state.sellThreshold, state.sellKeep, state.sellTotal = threshold or 0, keep or 0, total or 0
        pcall(function() UpdateAutoSellRE:FireServer(state.sellThreshold) end)
        state.sellSet = state.sellSet + 1
    end, "autosell")

    -- FIX: calculate drop rate from NEW uuids (sales/fusion don't distort it),
    -- and independently of smart spending; clamp no longer drops on a small inventory
    loop(function() return CONFIG.CLEAN_INTERVAL end, function()
        if not (state.running and CONFIG.SMART_CLEAN) then
            state.seenUnitSet, state.seenUnitT = nil, nil
            return
        end
        local now = os.clock()
        local curSet, units = {}, 0
        for uuid, item in pairs(Data.inv()) do
            if Data.isUnit(item) then
                curSet[uuid] = true
                units = units + 1
            end
        end
        if state.seenUnitSet and state.seenUnitT and now > state.seenUnitT then
            local fresh = 0
            for uuid in pairs(curSet) do
                if not state.seenUnitSet[uuid] then fresh = fresh + 1 end
            end
            local inst = fresh / (now - state.seenUnitT)
            state.unitDropRate = state.unitDropRate and (state.unitDropRate * 0.8 + inst * 0.2) or inst
        end
        state.seenUnitSet, state.seenUnitT = curSet, now

        local storage = storageCap()
        if storage <= 0 then return end
        local freeTarget = CONFIG.CLEAN_FREE_SLOTS
        if CONFIG.CLEAN_DYNAMIC and state.unitDropRate and state.unitDropRate > 0 then
            local hi = math.max(CONFIG.CLEAN_FREE_SLOTS, math.floor(storage * 0.25))
            freeTarget = math.clamp(math.ceil(state.unitDropRate * 120), CONFIG.CLEAN_FREE_SLOTS, hi)
        end
        if units <= storage - freeTarget then return end
        local need = math.min(units - (storage - freeTarget), CONFIG.CLEAN_MAX_PER_CYCLE)
        local keys = cleanCandidates(need)
        if #keys > 0 and pcall(function() return SellInventoryRF:InvokeServer(keys) end) then
            state.cleaned = state.cleaned + #keys
            state.smartNote = string.format("Cleanup: -%d units (was %d/%d, target: %d free)", #keys, units, storage, freeTarget)
        end
    end, "clean")

    loop(function() return CONFIG.EQUIP_INTERVAL end, function()
        if state.running and CONFIG.SLOTS and CONFIG.EQUIP_RAREST then equipRarest() end
    end, "equip-best")

    loop(function() return CONFIG.SLOT_INTERVAL end, function()
        if not (state.running and CONFIG.SLOTS) or CONFIG.SMART_MONEY then return end
        for slot = 1, maxSlots() do
            if not state.running then break end
            pcall(function() LevelUpSlotRE:FireServer(slot) end)
            state.slotsFired = state.slotsFired + 1
            state.lastSlot = tostring(slot)
            task.wait(0.12)
        end
    end, "slots")

    -- ---------------- smart spending: model ----------------
    local function rebirthInfo()
        local rb = Data.rebirth()
        local nxt = try(function() return Rebirths.GetNext(rb) end)
        return rb, type(nxt) == "table" and tonumber(nxt.cost) or nil
    end

    -- FIX: best luck gain per coin, relative to the BEST purchased die
    local function diceGoal()
        local all = try(function() return Dice.GetAll() end)
        if type(all) ~= "table" then return nil end
        local _, ownedBest = bestOwnedDice()
        local baseLuck = math.max(diceLuck(currentDice()) or 1, ownedBest or 1, 1e-9)
        local owned = ownedDice()
        local goal = nil
        for name, cfg in pairs(all) do
            local price = type(cfg) == "table" and tonumber(cfg.price) or nil
            local luck = type(cfg) == "table" and tonumber(cfg.luck) or 0
            if price and price > 0 and not owned[name] and luck > baseLuck then
                local gain = luck / baseLuck
                if gain >= CONFIG.DICE_MIN_GAIN then
                    local value = (gain - 1) / price
                    if not goal or value > goal.value then
                        goal = {name = name, price = price, luck = luck, gain = gain, value = value}
                    end
                end
            end
        end
        return goal
    end

    -- "raw" income gain of the next level and its price
    local function levelStep(cfg, itemName, baseAttrs, level)
        local cur, nxt = table.clone(baseAttrs), table.clone(baseAttrs)
        cur.level, nxt.level = level, level + 1
        local inc1 = tonumber(try(function() return cfg.income(cur) end))
        local inc2 = tonumber(try(function() return cfg.income(nxt) end))
        local price = tonumber(try(function() return UnitUtil.GetLevelPrice(itemName, cur) end))
        if not (inc1 and inc2 and price and price > 0) then return nil end
        return inc2 - inc1, price
    end

    -- "raw" income of all stands
    local function standIncomes()
        local inv, list, sum = Data.inv(), {}, 0
        for slotIdx, s in pairs(Data.slots()) do
            local item = type(s) == "table" and s.unitId and inv[s.unitId]
            local cfg = item and item.name and Data.config(item.name)
            if cfg and type(cfg.income) == "function" then
                local inc = tonumber(try(function() return cfg.income(item.attributes or {}) end)) or 0
                sum = sum + inc
                table.insert(list, {slot = slotIdx, income = inc})
            end
        end
        return list, sum
    end

    -- how many times real income is greater than "raw" (rebirth, upgrades, potions)
    local function globalMult()
        local _, base = standIncomes()
        local inc = state.incomePerSec or 0
        if base > 0 and inc > 0 then return math.clamp(inc / base, 0.1, 1e12) end
        return 1
    end

    -- share of income a new slot will give ≈ the weakest current stand
    local function newSlotShare()
        local list, sum = standIncomes()
        if sum <= 0 or #list == 0 then return 0.05 end
        local weakest = math.huge
        for _, s in ipairs(list) do weakest = math.min(weakest, s.income) end
        return weakest / sum
    end

    local function bestSlotUpgrade()
        local best = nil
        local inv = Data.inv()
        local mult = globalMult()
        for slotIdx, s in pairs(Data.slots()) do
            local item = type(s) == "table" and s.unitId and inv[s.unitId]
            local cfg = item and item.name and Data.config(item.name)
            if cfg and cfg.kind == "Unit" and type(cfg.income) == "function" then
                local attrs = item.attributes or {}
                local gain, price = levelStep(cfg, item.name, attrs, tonumber(attrs.level) or 1)
                if gain and gain > 0 then
                    gain = gain * mult
                    local roi = gain / price
                    if not best or roi > best.roi then
                        best = {slot = slotIdx, name = item.name, price = price, gain = gain, roi = roi}
                    end
                end
            end
        end
        return best
    end

    -- Greedy ROI over all stands. gain — in REAL coins/sec (× globalMult),
    -- budget no more than balance, cutoff only by payback.
    local function slotUpgradePlan(maxPaybackSec)
        local plan = {}
        local inv = Data.inv()
        local m = Data.money()
        local income = state.incomePerSec or 0
        local mult = globalMult()
        maxPaybackSec = tonumber(maxPaybackSec) or (tonumber(CONFIG.SLOT_MAX_PAYBACK) or 1800)
        local minRoi = math.max(tonumber(CONFIG.SLOT_ABS_MIN_ROI) or 0, 1 / math.max(maxPaybackSec, 1))

        local budget = m * math.clamp(tonumber(CONFIG.SLOT_BUDGET_PCT) or 0.12, 0, 1)
        if income > 0 then budget = math.max(budget, income * 3600 * 0.15) end
        budget = math.min(budget, m)

        local slots = {}
        for slotIdx, s in pairs(Data.slots()) do
            local item = type(s) == "table" and s.unitId and inv[s.unitId]
            local cfg = item and item.name and Data.config(item.name)
            if cfg and type(cfg.income) == "function" then
                local attrs = item.attributes or {}
                local plain = tonumber(try(function() return cfg.income({mutation = attrs.mutation, level = 1}) end))
                local withTG = table.clone(attrs); withTG.level = 1
                local rolled = tonumber(try(function() return cfg.income(withTG) end))
                table.insert(slots, {
                    slot = tonumber(slotIdx) or slotIdx, name = item.name, cfg = cfg,
                    baseAttrs = attrs, level = tonumber(attrs.level) or 1,
                    trait = attrs.trait, grade = attrs.grade,
                    mults = (plain and rolled and plain > 0) and (rolled / plain) or 1,
                })
            end
        end

        local maxSteps = (tonumber(CONFIG.SLOT_ACTIONS_PER_CYCLE) or 8) * 6
        for _ = 1, maxSteps do
            local best = nil
            for _, s in ipairs(slots) do
                local gain, price = levelStep(s.cfg, s.name, s.baseAttrs, s.level)
                if gain and gain > 0 and price <= budget then
                    gain = gain * mult
                    local roi = gain / price
                    if roi >= minRoi and (not best or roi > best.roi) then
                        best = {s = s, gain = gain, price = price, roi = roi}
                    end
                end
            end
            if not best then break end
            budget = budget - best.price
            local s = best.s
            table.insert(plan, {
                slot = s.slot, name = s.name, level = s.level + 1,
                gain = best.gain, price = best.price, roi = best.roi,
                trait = s.trait, grade = s.grade, mults = s.mults,
            })
            s.level = s.level + 1
        end
        return plan
    end

    -- execute a plan (shared part for smart spending and manual call)
    local function executeSlotPlan(plan, startMoney)
        local actions, spent = 0, 0
        for _, a in ipairs(plan) do
            if actions >= CONFIG.SLOT_ACTIONS_PER_CYCLE or not alive() then break end
            -- FireServer is async: the balance may not have decreased yet — we count ourselves
            if math.min(Data.money(), startMoney - spent) < a.price then break end
            pcall(function() LevelUpSlotRE:FireServer(a.slot) end)
            actions = actions + 1
            spent = spent + a.price
            markSpent(a.price)
            state.slotsFired = state.slotsFired + 1
            state.lastSlot = tostring(a.slot)
            state.smartNote = string.format("Stand %s: %s [%s/%s ×%.2f] ->lvl%d (ROI %.5f, payback %s)",
                tostring(a.slot), a.name, tostring(a.trait or "—"), tostring(a.grade or "—"),
                a.mults or 1, a.level, a.roi, formatTime(a.price / math.max(a.gain, 1e-12)))
            task.wait(0.15)
        end
        return actions
    end

    local function runSlotUpgrades()
        return executeSlotPlan(slotUpgradePlan(), Data.money())
    end

    local function cheapestUpgrade()
        local best = nil
        for id, cfg in pairs(UpgradesCfg) do
            local price = type(cfg) == "table" and tonumber(cfg.price)
            if price and (not best or price < best.price) and Data.upgradeAvailable(id) then
                best = {id = id, price = price}
            end
        end
        return best
    end

    -- ---------------- smart spending: decision ----------------
    local function smartTick()
        _G.__OP_SMART_MONEY = (state.running and CONFIG.SMART_MONEY) or false
        if not _G.__OP_SMART_MONEY then
            _G.__OP_REBIRTH_BLOCK = false
            return
        end

        local m, now = Data.money(), os.clock()
        local rb, rbCost = rebirthInfo()

        -- FIX: income = balance increase + everything spent over the interval;
        -- skip intervals with a rebirth (balance reset to zero — that's not "income")
        if state.lastMoneyT and state.lastMoney and now > state.lastMoneyT and state.lastRb == rb then
            local inst = (m - state.lastMoney + (tonumber(_G.__OP_SPENT) or 0)) / (now - state.lastMoneyT)
            if inst >= 0 then
                state.incomePerSec = state.incomePerSec and (state.incomePerSec * 0.7 + inst * 0.3) or inst
            end
        end
        state.lastRb = rb
        _G.__OP_SPENT = 0
        state.lastMoney, state.lastMoneyT = m, now -- snapshot BEFORE spending; this tick's spending goes to __OP_SPENT

        local income = state.incomePerSec or 0
        local maxPaybackSec = math.max((tonumber(CONFIG.MAX_PAYBACK_H) or 3) * 3600, 1)
        local horizon = maxPaybackSec
        local luckK = tonumber(CONFIG.LUCK_TO_INCOME) or 0.4

        -- === Stage 1: rebirth ===
        local apCfg = _G.AutoProgression and _G.AutoProgression.config
        local rebirthOn = apCfg and apCfg.REBIRTH
        _G.__OP_REBIRTH_BLOCK = false

        if rebirthOn and rbCost then
            local cur = try(function() return Rebirths.Get(rb) end)
            local nxt = try(function() return Rebirths.GetNext(rb) end)
            if type(nxt) == "table" then
                local curMM = type(cur) == "table" and tonumber(cur.moneyMultiplier) or 1
                local curLM = type(cur) == "table" and tonumber(cur.luckMultiplier) or 1
                local mg = (tonumber(nxt.moneyMultiplier) or curMM) / math.max(curMM, 1e-9)
                local lg = (tonumber(nxt.luckMultiplier) or curLM) / math.max(curLM, 1e-9)
                -- luck affects income partially (same coefficient as for a die)
                local gain = mg * (1 + luckK * (lg - 1)) - 1
                local unlockSlot = #unlockedSlots(rb + 1) > #unlockedSlots(rb)
                if unlockSlot then gain = gain + newSlotShare() * mg end
                -- the ENTIRE balance is burned -> payback = balance / (income × gain)
                local lost = math.max(m, rbCost)
                local payback = (income > 0 and gain > 1e-4) and (lost / (income * gain)) or math.huge
                -- until income is measured — don't block (the next tick will decide)
                local worth = (gain >= CONFIG.REBIRTH_MIN_GAIN or unlockSlot)
                    and (income <= 0 or payback <= maxPaybackSec)

                if worth then
                    if m >= rbCost then
                        state.smartNote = string.format("Waiting for rebirth: +%.0f%%%s, pays back in %s",
                            gain * 100, unlockSlot and " +slot" or "", formatTime(payback))
                        return
                    elseif m >= rbCost * CONFIG.REBIRTH_SAVE then
                        _G.__OP_REBIRTH_BLOCK = true
                        state.smartNote = string.format("Saving for rebirth%s (%.0f%% of %s, payback %s)",
                            unlockSlot and " for a slot" or "", m / rbCost * 100, formatShort(rbCost), formatTime(payback))
                        return
                    end
                    -- rebirth is far away: only buy what pays back before it
                    if CONFIG.SPEND_BEFORE_RB_ONLY and income > 0 then
                        horizon = math.min(horizon, math.max((rbCost - m) / income, 1))
                    end
                else
                    _G.__OP_REBIRTH_BLOCK = true
                    state.smartNote = string.format("Rebirth unprofitable (+%.0f%%, payback %s) — developing",
                        gain * 100, formatTime(payback))
                end
            end
        end

        -- === Stage 1.6: FIX — die priority (save and buy before stands) ===
        if CONFIG.DICE_BUY and CONFIG.DICE_PRIORITY then
            local goal = diceGoal()
            if goal and goal.price > 0 then
                local payback = income > 0 and (goal.price / (income * (goal.gain - 1) * luckK)) or nil
                local okPay = (payback == nil) or (payback <= horizon)
                if okPay then
                    if m >= goal.price then
                        pcall(function() BuyDiceRE:FireServer(goal.name) end)
                        markSpent(goal.price)
                        state.diceBought = state.diceBought + 1
                        state.lastBuy = goal.name
                        state.smartNote = string.format("Bought die %s (luck ×%.2f%s)",
                            goal.name, goal.gain, payback and (", payback " .. formatTime(payback)) or "")
                        return
                    elseif income > 0 and m >= goal.price * (tonumber(CONFIG.DICE_SAVE) or 0.75) then
                        state.smartNote = string.format("Saving for die %s (%.0f%% of %s, payback %s)",
                            goal.name, m / goal.price * 100, formatShort(goal.price), formatTime(payback))
                        return
                    end
                end
            end
        end

        -- === Stage 2: options (all in real coins/sec, unified horizon) ===
        local options = {}

        if CONFIG.DICE_BUY and income > 0 then
            local goal = diceGoal()
            if goal then
                local payback = goal.price / (income * (goal.gain - 1) * luckK)
                if payback <= horizon then
                    table.insert(options, {type = "dice", name = goal.name, cost = goal.price, paybackSec = payback, gain = goal.gain})
                end
            end
        end

        if CONFIG.SLOTS then
            local plan = slotUpgradePlan(horizon)
            local n = math.min(#plan, CONFIG.SLOT_ACTIONS_PER_CYCLE)
            if n > 0 then
                local c, g = 0, 0
                for i = 1, n do c = c + plan[i].price; g = g + plan[i].gain end -- only the executable part
                local payback = g > 0 and (c / g) or math.huge
                if payback <= horizon then
                    table.insert(options, {type = "slots", cost = c, paybackSec = payback, plan = plan})
                end
            end
        end

        local up = cheapestUpgrade()
        local upGain = tonumber(CONFIG.UPGRADE_EST_GAIN) or 0.02
        if up and income > 0 and upGain > 0 and up.price <= m * CONFIG.UPGRADE_SHARE then
            local payback = up.price / (income * upGain)
            if payback <= horizon then
                table.insert(options, {type = "upgrade", id = up.id, cost = up.price, paybackSec = payback})
            end
        end

        table.sort(options, function(a, b) return a.paybackSec < b.paybackSec end)

        -- === Stage 3: execute the best ===
        for _, opt in ipairs(options) do
            if opt.type == "dice" then
                if m >= opt.cost then
                    pcall(function() BuyDiceRE:FireServer(opt.name) end)
                    markSpent(opt.cost)
                    state.diceBought = state.diceBought + 1
                    state.lastBuy = opt.name
                    state.smartNote = string.format("Bought die %s (luck ×%.2f, payback %s)",
                        opt.name, opt.gain, formatTime(opt.paybackSec))
                    return
                elseif m >= opt.cost * CONFIG.RESERVE_GOAL_PCT then
                    state.smartNote = string.format("Saving for die %s (%.0f%% of %s, payback %s)",
                        opt.name, m / opt.cost * 100, formatShort(opt.cost), formatTime(opt.paybackSec))
                    return
                end
            elseif opt.type == "slots" then
                if executeSlotPlan(opt.plan, m) > 0 then return end
            elseif opt.type == "upgrade" then
                if m >= opt.cost then
                    pcall(function() BuyUpgradeRE:FireServer(opt.id) end)
                    markSpent(opt.cost)
                    state.smartUpgrades = state.smartUpgrades + 1
                    state.smartNote = string.format("Upgrade %s (%s, payback %s)",
                        tostring(opt.id), formatShort(opt.cost), formatTime(opt.paybackSec))
                    return
                end
            end
        end

        if rbCost and m >= rbCost and not rebirthOn then
            state.smartNote = "Rebirth available! Enable \"Rebirth\" in AutoProgression"
        elseif income <= 0 then
            state.smartNote = "Measuring income... (1–2 ticks)"
        else
            state.smartNote = string.format("Waiting for savings (%s) | options: %d | horizon %s",
                formatShort(m), #options, formatTime(horizon))
        end
    end

    loop(function() return CONFIG.SMART_INTERVAL end, smartTick, "smart-money")

    -- ---------------- UI ----------------
    local P = UI.panel("FarmBoost", "Farm Boost (auto-farm)", 360, 444, 30, 650)
    local statusLbl = P.label(26, 14, Theme.Sub)
    statusLbl.Text = "Configure the toggles and press START"
    local rateLbl = P.label(42, 14, Theme.Gold)
    local statLbl = P.label(58, 14, Theme.Text)
    local statLbl2 = P.label(74, 14, Theme.Text)
    local statLbl3 = P.label(90, 14, Theme.Sub)
    local lastLbl = P.label(106, 14, Theme.Sub)

    local startBtn = P.button("START", 8, 128, 110, 28, Theme.Success)
    local stopBtn = P.button("STOP", 126, 128, 110, 28, Theme.Danger)
    local saveBtn = P.button("Save", 244, 128, 108, 28, Theme.Off)

    local toggles = {
        {key = "DICE_BUY", label = "Dice: buy"},
        {key = "DICE_PRIORITY", label = "Dice: priority"},
        {key = "DICE_EQUIP", label = "Dice: equip"},
        {key = "SPINS", label = "Spins"},
        {key = "AUTO_ROLL", label = "Auto-roll"},
        {key = "AUTO_SELL", label = "Auto-sell"},
        {key = "SLOTS", label = "Slots + equip"},
        {key = "PERSIST", label = "Save"},
        {key = "SMART_MONEY", label = "Smart spending"},
        {key = "SMART_CLEAN", label = "Smart cleanup"},
        {key = "EQUIP_RAREST", label = "Rare on stands"},
    }
    local toggleBtns = {}
    for i, t in ipairs(toggles) do
        local col = (i - 1) % 2
        local rowN = (i - 1) // 2
        local b = P.button("", col == 0 and 8 or 184, 164 + rowN * 32, 168, 26, Theme.Off)
        toggleBtns[t.key] = {btn = b, label = t.label}
        P.onClick(b, function()
            CONFIG[t.key] = not CONFIG[t.key]
            saveCfg()
            refreshBoostUI()
        end)
    end

    local hintLbl = P.multiline(356, 30, Theme.Sub)
    local afkLbl = P.label(390, 14, Theme.Sub)
    local footLbl = P.multiline(408, 28, Theme.Sub)

    local function setStatus(text) statusLbl.Text = tostring(text) end

    refreshBoostUI = function()
        stopBtn.BackgroundColor3 = state.running and Theme.Danger or Theme.DangerDim
        for key, t in pairs(toggleBtns) do UI.paintToggle(t.btn, CONFIG[key], t.label) end
        local units, storage = unitStats()
        local best, luck = bestOwnedDice()
        statLbl.Text = string.format("Units: %d/%d | Best die: %s (x%s)", units, storage, tostring(best or "-"), tostring(luck or "-"))
        statLbl2.Text = string.format("Dice bought: %d | Spins: %d | Slots: %d", state.diceBought, state.spinsUsed, state.slotsFired)
        statLbl3.Text = string.format("Auto-roll: %d | Auto-sell: %d | Threshold: %s | Drop: %.2f/s",
            state.autorollSet, state.sellSet, formatShort(state.sellThreshold), state.unitDropRate or 0)
        if CONFIG.SMART_MONEY then
            hintLbl.Text = "Smart spending: " .. tostring(state.smartNote)
                .. string.format("\nIncome: %s/h | upgrades: %d", formatShort((state.incomePerSec or 0) * 3600), state.smartUpgrades)
        else
            hintLbl.Text = string.format("Keeping best: %d of %d | sell threshold: %s", state.sellKeep, state.sellTotal, formatShort(state.sellThreshold))
        end
        local m = Data.money()
        local elapsed = state.startedAt > 0 and (os.clock() - state.startedAt) or 0
        local netPerHour = elapsed > 1 and ((m - state.moneyStart) / elapsed * 3600) or 0
        rateLbl.Text = string.format("Income/h: %s | Net/h: %s | Money: %s",
            formatShort((state.incomePerSec or 0) * 3600), formatShort(netPerHour), formatShort(m))
        lastLbl.Text = string.format("Equip: %s | Last buy: %s | Spin: %s", tostring(state.diceEquip), tostring(state.lastBuy), tostring(state.lastSpin))
        afkLbl.Text = string.format("AFK Guard: %s (shared) | inputs: %d | %s", _G.__OP_AFK_HOOKED and "ON" or "partial", _G.__OP_AFK_INPUTS or 0, state.equipNote)
        local rolls = tonumber(try(function() return DC.Rolls() end)) or 0
        footLbl.Text = string.format("Slot: %s | Rolls: %s | Cleanup: -%d | Stands: %d",
            tostring(state.lastSlot), formatShort(rolls), state.cleaned, state.equipChanges)
    end

    local function start()
        if state.running then return end
        state.running = true
        state.startedAt = os.clock()
        state.moneyStart = Data.money()
        state.lastMoney, state.lastMoneyT, state.incomePerSec, state.lastRb = nil, nil, nil, nil
        state.unitDropRate, state.seenUnitSet, state.seenUnitT = nil, nil, nil
        _G.__OP_SPENT = 0
        setStatus("Running")
        refreshBoostUI()
    end
    local function stop()
        state.running = false
        _G.__OP_SMART_MONEY = false
        _G.__OP_REBIRTH_BLOCK = false
        setStatus("Stopped")
        refreshBoostUI()
    end

    onCleanup(function()
        state.running = false
        _G.__OP_SMART_MONEY = false
        _G.__OP_REBIRTH_BLOCK = false
    end)

    P.onClick(startBtn, start)
    P.onClick(stopBtn, stop)
    P.onClick(saveBtn, function()
        saveCfg(true)
        setStatus("Settings saved")
    end)

    refreshBoostUI()
    loop(1, refreshBoostUI, "fb-ui")

    _G.FarmBoost = {
        start = start, stop = stop, state = state, config = CONFIG,
        save = saveCfg, load = loadCfg, money = Data.money, bestOwnedDice = bestOwnedDice,
        maxSlots = maxSlots, unitStats = unitStats, computeSellThreshold = computeSellThreshold,
        diceGoal = diceGoal, bestSlotUpgrade = bestSlotUpgrade, cheapestUpgrade = cheapestUpgrade,
        slotUpgradePlan = slotUpgradePlan, runSlotUpgrades = runSlotUpgrades,
        cleanCandidates = cleanCandidates, equipRarest = equipRarest, readSlots = readSlots,
        globalMult = globalMult, standIncomes = standIncomes, unlockedSlots = unlockedSlots,
    }
    print("[FarmBoost] loaded. dice=" .. tostring(currentDice()) .. " | best owned=" .. tostring((bestOwnedDice())))

    -- AUTONOMOUS: auto-start Farm Boost
    if _G.__OP_AUTONOMY ~= false then
        task.delay(2.5, function()
            if alive() and not state.running then
                local okA = pcall(start)
                print("[FarmBoost] auto-start: " .. tostring(okA))
            end
        end)
    end
end


-- ==============================================================================
-- SECTION 4: COOP — autonomous system: recalculate every minute, sync queue, keep-alive farm, trade
-- ==============================================================================
do
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local F = RS.Framework.Features
local ER = require(F.Inventory.EntryRegistry)
local Towers = require(F.Towers.Towers)
local DC = require(F.Data.DataController)
local NET = RS.Network
local TradeRE = NET.TradeService.RE

-- ------------------------------------------------------------------ session --
if type(_G.__ADCOOP_CLEANUP) == "function" then pcall(_G.__ADCOOP_CLEANUP) end
local SESSION = {}
_G.__ADCOOP_SESSION = SESSION
local conns, guis = {}, {}
local function alive() return _G.__ADCOOP_SESSION == SESSION end
local function track(c) conns[#conns + 1] = c return c end
local function try(fn, ...) local ok, v = pcall(fn, ...) if ok then return v end return nil end
_G.__ADCOOP_CLEANUP = function()
    if _G.__ADCOOP_SESSION == SESSION then _G.__ADCOOP_SESSION = nil end
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    for _, g in ipairs(guis) do pcall(function() g:Destroy() end) end
    table.clear(conns); table.clear(guis)
end

-- ------------------------------------------------------------------- config --
local CONFIG = {
    COOP = true,
    AUTOSTART = true,         -- auto-start coop together with the main script
    PARTNERS = {},            -- empty = auto-detect via OP_AD_COOP_*.json files; fill in names to restrict
    AUTO_SPLIT = true,        -- auto-distribute towers (by squad strength)
    AUTO_START_FARM = true,   -- auto-start TowerFarm after distribution
    SPLIT_LISTS = {},         -- manual override: ["name"] = {"Dragon Tower", ...}
    MIN_PRED_FLOORS = 5,      -- if predicted less — the tower is "out of reach"
    ASSIGN_INTERVAL = 60,     -- seconds between assignment recalculations
    REASSIGN_DELTA = 0.2,     -- recalculate earlier if strength changed by 20%+
    AUTO_REQUEST = true,
    REQUEST_INTERVAL = 25,
    KEEP = 1,
    GIVE_MAX = 5,
    WANT_FILTER = { "Luck", "Damage", "Income" },
    WANT_MIN = 1,
    AUTO_ACCEPT = true,
    POLL = 2,
    CFG_FILE = "OP_AD_Coop.cfg",
    PREFIX = "OP_AD_COOP_",
}

local function loadCfg()
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
    if not try(isfile, CONFIG.CFG_FILE) then return end
    local data = try(readfile, CONFIG.CFG_FILE)
    if type(data) ~= "string" then return end
    for line in string.gmatch(data, "[^\r\n]+") do
        local k, v = string.match(line, "^([%w_]+)=(.*)$")
        if k and CONFIG[k] ~= nil and type(CONFIG[k]) ~= "table" then
            if v == "true" then CONFIG[k] = true
            elseif v == "false" then CONFIG[k] = false
            elseif type(CONFIG[k]) == "number" then CONFIG[k] = tonumber(v) or CONFIG[k]
            elseif type(CONFIG[k]) == "string" then CONFIG[k] = v end
        end
    end
end
local function saveCfg()
    if type(writefile) ~= "function" then return end
    local lines = {}
    for k, v in pairs(CONFIG) do
        if type(v) ~= "table" then table.insert(lines, k .. "=" .. tostring(v)) end
    end
    table.sort(lines)
    pcall(writefile, CONFIG.CFG_FILE, table.concat(lines, "\n"))
end
loadCfg()

-- -------------------------------------------------------------------- state --
local state = {
    running = false, phase = "-", log = {},
    pool = {}, myPotions = {}, want = {}, partners = {},
    myFloors = {}, myQueue = {}, myPower = { dmg = 0, hp = 0 }, myPred = {},
    assign = {}, assignCounts = {}, assignedAt = 0, assignVersion = 0,
    trade = { active = false, partner = nil, role = nil, phase = nil, give = {} },
    lastRequest = 0, requests = 0, trades = 0,
    targetCooldown = {}, retryAt = 0,
    enabled = false, lastWrite = 0,
}

local function log(msg)
    local line = string.format("[%s] %s", os.date("%H:%M:%S"), tostring(msg))
    table.insert(state.log, 1, line)
    if #state.log > 40 then table.remove(state.log) end
    print("[ADCoop] " .. tostring(msg))
end

-- --------------------------------------------------------------------- drops --
local DROPS = {}
do
    local ok, all = pcall(function() return Towers.GetAll() end)
    if ok and type(all) == "table" then
        for id, cfg in pairs(all) do
            if type(cfg.drops) == "table" then
                DROPS[id] = {}
                for _, g in ipairs(cfg.drops) do
                    local ents = {}
                    for _, e in ipairs(g.entries or {}) do
                        if e.name then table.insert(ents, { name = e.name, chance = tonumber(e.chance) or 0 }) end
                    end
                    table.insert(DROPS[id], { minFloor = tonumber(g.minFloor) or 1, entries = ents })
                end
            end
        end
    end
end

local function dropsUpTo(towerId, floor)
    local out = {}
    for _, g in ipairs(DROPS[towerId] or {}) do
        if g.minFloor <= floor then
            for _, e in ipairs(g.entries) do out[e.name] = true end
        end
    end
    return out
end

-- ------------------------------------------------------- tower and squad strength --
local TOWER_INFO = {}     -- [id] = { strength, refFloor, recDPS, recTank, recPower, order }
do
    local ok, all = pcall(function() return Towers.GetAll() end)
    if ok and type(all) == "table" then
        for id, cfg in pairs(all) do
            -- reference floor: last drop tier (90 for normal, 150 for Infinity)
            local ref = 90
            if type(cfg.drops) == "table" then
                for _, g in ipairs(cfg.drops) do
                    local mf = tonumber(g.minFloor)
                    if mf and mf > ref then ref = mf end
                end
            end
            local hp, dmg = 0, 0
            pcall(function() hp = tonumber(cfg.enemyHealth(ref)) or 0 end)
            pcall(function() dmg = tonumber(cfg.enemyDamage(ref)) or 0 end)
            local recDPS = hp / 10
            local recTank = dmg * 10
            TOWER_INFO[id] = {
                strength = math.max(hp, 1) * math.max(dmg, 1),
                refFloor = ref,
                recDPS = recDPS,
                recTank = recTank,
                recPower = recDPS + recTank,
                order = tonumber(cfg.order) or 999,
            }
        end
    end
end

local function allTowerIds()
    local ids = {}
    for id, info in pairs(TOWER_INFO) do ids[#ids + 1] = id end
    table.sort(ids, function(a, b)
        local A, B = TOWER_INFO[a], TOWER_INFO[b]
        if A.order ~= B.order then return A.order < B.order end
        return a < b
    end)
    return ids
end

local function buffMult(kind)
    local okB, BuffService = pcall(function() return require(F.Buffs.BuffService) end)
    if okB and type(BuffService) == "table" and type(BuffService.GetBuff) == "function" then
        local ok, v = pcall(function() return BuffService.GetBuff(LP, kind) end)
        if ok then return tonumber(v) or 1 end
    end
    return 1
end

local function myTeam()
    local dmgMult, hpMult = buffMult("Damage Multiplier"), buffMult("Health Multiplier")
    local team = {}
    for i = 1, 4 do
        local u = nil
        pcall(function() u = DC.TowerTeam[i]() end)
        if u then
            local item = DC.Inventory()[u]
            if item then
                local cfg = try(function() return ER.getEntryConfig(item.name) end)
                if cfg then
                    local d = 0
                    local h = 0
                    pcall(function() d = tonumber(select(1, cfg.damage(item.attributes or {}))) or 0 end)
                    pcall(function() h = tonumber(select(1, cfg.health(item.attributes or {}))) or 0 end)
                    team[#team + 1] = { name = item.name, dmg = d * dmgMult, hp = h * hpMult }
                end
            end
        end
    end
    return team
end

local function predictFloor(towerId, team)
    if #team == 0 then return 0 end
    local cfg = try(function() return Towers.Get(towerId) end)
    if type(cfg) ~= "table" then return 0 end
    local sim = {}
    for i, t in ipairs(team) do sim[i] = { dmg = t.dmg, hp = t.hp } end
    local idx, floor, maxF = 1, 0, 500
    while floor < maxF do
        floor = floor + 1
        local ehp = nil
        local edmg = nil
        pcall(function() ehp = tonumber(cfg.enemyHealth(floor)) end)
        pcall(function() edmg = tonumber(cfg.enemyDamage(floor)) end)
        if not ehp or not edmg then break end
        local guard = 0
        while true do
            guard = guard + 1
            if guard > 200000 then break end
            local m = sim[idx]
            if not m or m.hp <= 0 then
                local nxt = nil
                for j = idx + 1, #sim do if sim[j].hp > 0 then nxt = j break end end
                if not nxt then return floor - 1 end
                idx = nxt
                m = sim[idx]
            end
            ehp = ehp - m.dmg
            if ehp <= 0 then break end
            m.hp = m.hp - edmg
            if m.hp <= 0 then
                local nxt = nil
                for j = idx + 1, #sim do if sim[j].hp > 0 then nxt = j break end end
                if not nxt then return floor - 1 end
                idx = nxt
            end
        end
    end
    return floor
end

local function computePower()
    local team = myTeam()
    local total = { dmg = 0, hp = 0 }
    for _, t in ipairs(team) do total.dmg = total.dmg + t.dmg total.hp = total.hp + t.hp end
    local pred = {}
    for _, id in ipairs(allTowerIds()) do pred[id] = predictFloor(id, team) end
    state.myPower = total
    state.myPred = pred
    return total, pred, team
end

-- ------------------------------------------------------------------ game i/o --
local function myPotions()
    local out = {}
    for key, item in pairs(DC.Inventory() or {}) do
        if type(item) == "table" and item.name and (tonumber(item.amount) or 0) > 0 then
            local cfg = try(function() return ER.getEntryConfig(item.name) end)
            if cfg and cfg.kind == "Boost" then
                out[item.name] = { amount = tonumber(item.amount) or 0, key = key }
            end
        end
    end
    return out
end
local function kindOf(name)
    local cfg = try(function() return ER.getEntryConfig(name) end)
    return cfg and cfg.kind or nil
end
local function categoryOf(name)
    local cfg = try(function() return ER.getEntryConfig(name) end)
    return cfg and tostring(cfg.category or "") or ""
end

-- ------------------------------------------------------------------- files ---
local function myFile() return CONFIG.PREFIX .. LP.Name .. ".json" end

-- shared coop account registry (to find each other without listfiles)
local function registryFile() return CONFIG.PREFIX .. "registry.json" end

local function readRegistry()
    local out = {}
    if type(readfile) ~= "function" then return out end
    local ok, data = pcall(readfile, registryFile())
    if ok and type(data) == "string" and #data > 1 then
        local okJ, obj = pcall(function() return HttpService:JSONDecode(data) end)
        if okJ and type(obj) == "table" then
            for k, v in pairs(obj) do if v and type(k) == "string" then out[k] = true end end
        end
    end
    return out
end

local function registerSelf()
    if type(writefile) ~= "function" then return end
    local reg = readRegistry()
    if not reg[LP.Name] then
        reg[LP.Name] = true
        local ok, body = pcall(function() return HttpService:JSONEncode(reg) end)
        if ok and body then pcall(writefile, registryFile(), body) end
        log("registered in the coop registry")
    end
end

local function listStateFiles()
    local files = {}
    if type(listfiles) == "function" then
        local ok, l = pcall(listfiles, CONFIG.PREFIX .. "*.json")
        if ok and type(l) == "table" and #l > 0 then
            for _, f in ipairs(l) do
                local base = tostring(f):match("([^/\\]+)$") or tostring(f)
                files[base] = true
            end
        else
            local ok2, all = pcall(listfiles)
            if ok2 and type(all) == "table" then
                for _, f in ipairs(all) do
                    local base = tostring(f):match("([^/\\]+)$") or tostring(f)
                    if base and base:sub(1, #CONFIG.PREFIX) == CONFIG.PREFIX then files[base] = true end
                end
            end
        end
    end
    -- coop account registry (shared file)
    local reg = readRegistry()
    for name in pairs(reg) do files[CONFIG.PREFIX .. name .. ".json"] = true end
    -- explicit list from config
    for _, name in ipairs(CONFIG.PARTNERS) do files[CONFIG.PREFIX .. name .. ".json"] = true end
    files[myFile()] = true
    local out = {}
    for f in pairs(files) do out[#out + 1] = f end
    return out
end

local function towerQueue()
    local TF = _G.TowerFarm
    local q = {}
    if TF and type(TF.state) == "table" then
        for id, on in pairs(TF.state.selected or {}) do if on then table.insert(q, id) end end
        if #q == 0 and TF.state.towerId then table.insert(q, TF.state.towerId) end
    end
    if #q == 0 and type(state.myQueue) == "table" then
        for _, id in ipairs(state.myQueue) do table.insert(q, id) end
    end
    table.sort(q)
    return q
end

local function writeState()
    if type(writefile) ~= "function" then return end
    local pots = {}
    for name, v in pairs(myPotions()) do pots[name] = v.amount end
    local rolls = tonumber(try(function() return DC.Rolls() end)) or 0
    local payload = {
        name = LP.Name,
        t = os.time(),
        rolls = rolls,
        age = LP.AccountAge,
        power = state.myPower,
        pred = state.myPred,
        assigned = state.assign[LP.Name] or state.myQueue,
        queue = state.myQueue,
        floors = state.myFloors,
        potions = pots,
        want = state.want,
        lastReqAt = state.lastReqAt or 0,
        trade = { with = state.trade.partner, role = state.trade.role, phase = state.trade.phase, active = state.trade.active },
        enabled = state.enabled,
    }
    local ok, body = pcall(function() return HttpService:JSONEncode(payload) end)
    if ok and body then
        pcall(writefile, myFile(), body)
        state.lastWrite = os.time()
    end
end

local function readStates()
    local list = {}
    for _, f in ipairs(listStateFiles()) do
        if f ~= myFile() then
            local ok, data = pcall(function() return readfile(f) end)
            if ok and type(data) == "string" and #data > 2 then
                local okJ, obj = pcall(function() return HttpService:JSONDecode(data) end)
                if okJ and type(obj) == "table" and obj.name then
                    obj.__file = f
                    list[#list + 1] = obj
                end
            end
        end
    end
    return list
end

-- -------------------------------------------------------------------- pool ---
local function computePool(states)
    local pool, floors = {}, {}
    local all = { { name = LP.Name, queue = state.myQueue, floors = state.myFloors } }
    for _, s in ipairs(states) do table.insert(all, s) end
    for _, s in ipairs(all) do
        for _, id in ipairs(s.queue or {}) do
            local fl = tonumber((s.floors or {})[id]) or 1
            if (floors[id] or 0) < fl then floors[id] = fl end
            for name in pairs(dropsUpTo(id, math.max(fl, 1))) do pool[name] = true end
        end
    end
    return pool
end

local function wantAllowed(name)
    if #CONFIG.WANT_FILTER == 0 then return true end
    local cat = categoryOf(name) .. " " .. name
    for _, pat in ipairs(CONFIG.WANT_FILTER) do
        if string.find(cat, pat, 1, true) then return true end
    end
    return false
end

local function recomputeWant()
    local states = readStates()
    state.pool = computePool(states)
    state.partners = states
    local mine = myPotions()
    state.myPotions = mine
    local want = {}
    for name in pairs(state.pool) do
        if kindOf(name) == "Boost" and wantAllowed(name) then
            local have = mine[name] and mine[name].amount or 0
            if have < CONFIG.WANT_MIN then want[name] = CONFIG.WANT_MIN - have end
        end
    end
    state.want = want
    return want
end

-- ------------------------------------------------------- auto-distribution --
local function accStrength(a)
    local p = a.power or {}
    return (tonumber(p.dmg) or 0) + (tonumber(p.hp) or 0)
end

-- does the actual TowerFarm selected set match the assignment?
local function selMatches(sel, list)
    local n = 0
    for k, v in pairs(sel or {}) do
        if v then
            local found = false
            for _, x in ipairs(list) do if x == k then found = true break end end
            if not found then return false end
            n = n + 1
        end
    end
    return n == #list
end

-- is this a partner (by list or auto-detection)
local function isPartnerName(name)
    if not name or name == LP.Name then return false end
    if #CONFIG.PARTNERS > 0 then
        for _, n in ipairs(CONFIG.PARTNERS) do if n == name then return true end end
        return false
    end
    for _, s in ipairs(state.partners or {}) do if s.name == name then return true end end
    return false
end

local function computeAssignment(states)
    -- all accounts (me + partners with fresh data)
    local accs = { { name = LP.Name, power = state.myPower, pred = state.myPred } }
    for _, s in ipairs(states) do
        if s.name ~= LP.Name then
            accs[#accs + 1] = { name = s.name, power = s.power or {}, pred = s.pred or {} }
        end
    end
    -- only coop accounts (list or all detected)
    local filtered = {}
    for _, a in ipairs(accs) do
        local okName = (a.name == LP.Name)
        if not okName then
            if #CONFIG.PARTNERS > 0 then
                for _, n in ipairs(CONFIG.PARTNERS) do if a.name == n then okName = true break end end
            else
                okName = true
            end
        end
        if okName then filtered[#filtered + 1] = a end
    end
    accs = filtered
    table.sort(accs, function(a, b)
        local sa, sb = accStrength(a), accStrength(b)
        if sa ~= sb then return sa > sb end
        return a.name < b.name
    end)
    -- towers by strength (strongest first)
    local towers = allTowerIds()
    table.sort(towers, function(a, b)
        local A, B = TOWER_INFO[a], TOWER_INFO[b]
        if A.strength ~= B.strength then return A.strength > B.strength end
        return a < b
    end)
    local n, M = #accs, #towers
    local assign, counts = {}, {}
    for _, a in ipairs(accs) do assign[a.name] = {} end
    if n == 0 then return assign, counts end
    -- evenly: base for each, remainder — for the strongest
    local base = math.floor(M / n)
    local extra = M % n
    local idx = 1
    for i, a in ipairs(accs) do
        local want = base + (i <= extra and 1 or 0)
        for _ = 1, want do
            if towers[idx] then
                table.insert(assign[a.name], towers[idx])
                idx = idx + 1
            end
        end
        counts[a.name] = #assign[a.name]
    end
    -- more accounts than towers: extras get the least loaded tower (tie — the stronger one)
    if n > M then
        local perTower = {}
        for name, list in pairs(assign) do
            for _, tw in ipairs(list) do perTower[tw] = (perTower[tw] or 0) + 1 end
        end
        for i = M + 1, n do
            local acc = accs[i]
            if acc then
                local best, bestCnt = nil, nil
                for _, tw in ipairs(towers) do
                    local c = perTower[tw] or 0
                    if not bestCnt or c < bestCnt
                        or (c == bestCnt and (TOWER_INFO[tw].strength > TOWER_INFO[best].strength)) then
                        best, bestCnt = tw, c
                    end
                end
                if best then
                    table.insert(assign[acc.name], best)
                    perTower[best] = (perTower[best] or 0) + 1
                    counts[acc.name] = (counts[acc.name] or 0) + 1
                end
            end
        end
    end
    return assign, counts, accs, towers
end

local function applyAssignment(assign, counts, accs, towers, why)
    state.assign = assign
    state.assignCounts = counts or {}
    state.assignedAt = os.time()
    state.assignVersion = state.assignVersion + 1
    local mine = {}
    for _, tw in ipairs(assign[LP.Name] or {}) do mine[#mine + 1] = tw end
    -- queue — in order of tower difficulty (order)
    table.sort(mine, function(a, b)
        local A, B = TOWER_INFO[a], TOWER_INFO[b]
        if (A.order or 999) ~= (B.order or 999) then return (A.order or 999) < (B.order or 999) end
        return a < b
    end)
    state.myQueue = mine
    local TF = _G.TowerFarm
    if TF and type(TF.setQueue) == "function" and #mine > 0 then
        pcall(TF.setQueue, mine)
    end
    local summary = {}
    for _, a in ipairs(accs or {}) do
        summary[#summary + 1] = a.name .. " -> " .. ((#(assign[a.name] or {}) > 0) and table.concat(assign[a.name], "+") or "—")
    end
    log("assignment (" .. tostring(why or "auto") .. "): " .. table.concat(summary, " | "))
    -- warnings about unbeatable towers (only on changes)
    local warnLines = {}
    for _, a in ipairs(accs or {}) do
        local bad = {}
        for _, tw in ipairs(assign[a.name] or {}) do
            local p = tonumber((a.pred or {})[tw]) or 0
            if p < CONFIG.MIN_PRED_FLOORS then table.insert(bad, tw .. "(" .. p .. ")") end
        end
        if #bad > 0 then warnLines[#warnLines + 1] = a.name .. ": " .. table.concat(bad, ", ") end
    end
    local wt = table.concat(warnLines, " | ")
    if wt ~= "" and wt ~= state.lastWarnText then
        state.lastWarnText = wt
        log("⚠ can't handle: " .. wt)
    end
    writeState()
end

local function sameSet(a, b)
    if #a ~= #b then return false end
    local sa, sb = {}, {}
    for _, v in ipairs(a) do sa[v] = true end
    for _, v in ipairs(b) do sb[v] = true end
    for v in pairs(sa) do if not sb[v] then return false end end
    return true
end

local function autoAssign(force)
    if not CONFIG.AUTO_SPLIT then return end
    local states = readStates()
    local assign, counts, accs, towers = computeAssignment(states)
    -- recalculate every ASSIGN_INTERVAL (default 60 s) or forcibly
    local need = force or (os.time() - (state.assignedAt or 0) >= (CONFIG.ASSIGN_INTERVAL or 60))
    if need then
        applyAssignment(assign, counts, accs, towers, force and "manual" or "auto")
    end
end

-- -------------------------------------------------------------------- trade --
local function partnerPlayer(name)
    if name == LP.Name then return nil end
    return Players:FindFirstChild(name)
end

local function canGive()
    local mine = myPotions()
    local give = {}
    local states = readStates()
    for _, s in ipairs(states) do
        if s.trade and s.trade.active and s.trade.role == "requester" and s.name and partnerPlayer(s.name) then
            for name, cnt in pairs(s.want or {}) do
                local have = mine[name] and mine[name].amount or 0
                local can = math.max(0, have - CONFIG.KEEP)
                local amount = math.min(can, CONFIG.GIVE_MAX, tonumber(cnt) or 1)
                if amount > 0 then give[name] = amount end
            end
        end
    end
    if next(give) == nil then
        local n = 0
        for name, v in pairs(mine) do
            if n >= 3 then break end
            if state.pool[name] and wantAllowed(name) and v.amount > CONFIG.KEEP then
                give[name] = math.min(v.amount - CONFIG.KEEP, CONFIG.GIVE_MAX)
                n = n + 1
            end
        end
    end
    return give
end

local function sendOffers(give)
    for name, amount in pairs(give) do
        pcall(function() TradeRE.ChangeOffer:FireServer(name, amount) end)
        task.wait(0.15)
    end
end

local function onTradeEvent(action, data)
    if not CONFIG.COOP then return end
    if action == "RequestReceived" then
        local sender = type(data) == "table" and data.player or nil
        if not (sender and sender:IsA("Player")) then return end
        if state.trade.active then
            pcall(function() TradeRE.RespondToRequest:FireServer(false) end)
            log("request from " .. sender.Name .. " — busy with another trade, declining")
            return
        end
        if not isPartnerName(sender.Name) or not CONFIG.AUTO_ACCEPT then
            pcall(function() TradeRE.RespondToRequest:FireServer(false) end)
            return
        end
        local give = canGive()
        if next(give) == nil then
            pcall(function() TradeRE.RespondToRequest:FireServer(false) end)
            log("request from " .. sender.Name .. " — nothing to give, declining")
            return
        end
        state.trade = { active = true, partner = sender, role = "responder", phase = "Offer", give = give }
        pcall(function() TradeRE.RespondToRequest:FireServer(true) end)
        log("request from " .. sender.Name .. " — accepted, preparing offer")
    elseif action == "Started" then
        local partner = type(data) == "table" and data.partner or nil
        if not (partner and partner:IsA("Player")) then return end
        if state.trade.partner ~= partner then
            state.trade = { active = true, partner = partner, role = "responder", phase = "Offer", give = canGive() }
        end
        state.trade.phase = "Offer"
        if state.trade.role == "responder" then sendOffers(state.trade.give or {}) end
        pcall(function() TradeRE.AdvanceTrade:FireServer() end)
        log("trade with " .. partner.Name .. " started (" .. tostring(state.trade.role) .. ")")
    elseif action == "Updated" then
        local d = type(data) == "table" and data or {}
        state.trade.phase = tostring(d.phase or state.trade.phase)
        if d.phase == "Offer" and d.ownReady == false then
            pcall(function() TradeRE.AdvanceTrade:FireServer() end)
        elseif d.phase == "Confirm" and d.ownAccepted == false then
            pcall(function() TradeRE.AdvanceTrade:FireServer() end)
        end
    elseif action == "Ended" then
        local reason = type(data) == "table" and tostring(data.reason) or "?"
        if state.trade.active then
            state.trades = state.trades + 1
            log("trade ended (" .. reason .. ")")
        end
        state.trade = { active = false, partner = nil, role = nil, phase = nil, give = {} }
        task.delay(1, function() if alive() then recomputeWant(); writeState() end end)
    elseif action == "RequestClosed" or action == "RequestExpired" then
        local who = state.trade.partner and state.trade.partner.Name
        if state.trade.role == "requester" and who then
            state.targetCooldown[who] = os.clock() + 45
            log("no response from " .. who .. " — will try another partner")
        end
        state.trade = { active = false, partner = nil, role = nil, phase = nil, give = {} }
        state.retryAt = os.clock() + 5
    end
end

track(TradeRE.TradeEvent.OnClientEvent:Connect(function(action, data)
    if not alive() then return end
    local ok, err = pcall(onTradeEvent, action, data)
    if not ok then log("trade error: " .. tostring(err)) end
end))

local function setEnabled(on)
    state.enabled = on and true or false
    pcall(function() TradeRE.SetTradeRequestsEnabled:FireServer(state.enabled) end)
    log("trade requests: " .. (state.enabled and "ON" or "OFF"))
end

local function canTradeSelf()
    local rolls = tonumber(try(function() return DC.Rolls() end)) or 0
    if rolls < 1000 then return false, string.format("no 1000 rolls (I have %d)", rolls) end
    if LP.AccountAge < 14 then return false, "account younger than 14 days" end
    return true
end

local function requestNow()
    if not CONFIG.COOP then return false, "disabled" end
    if state.trade.active then return false, "trade already in progress" end
    local okT, why = canTradeSelf()
    if not okT then
        state.phase = "trade unavailable: " .. tostring(why)
        return false, why
    end
    if os.clock() - state.lastRequest < CONFIG.REQUEST_INTERVAL then
        return false, string.format("cooldown %.0fs", CONFIG.REQUEST_INTERVAL - (os.clock() - state.lastRequest))
    end
    recomputeWant()
    if next(state.want) == nil then
        return false, "nothing to request"
    end
    for _, s in ipairs(state.partners) do
        local tr = s.trade or {}
        if tr.active and tr.role == "requester" and (tonumber(s.lastReqAt) or 0) >= (state.lastReqAt or 0)
           and (os.time() - (tonumber(s.t) or 0)) < 30 then
            state.phase = "partner " .. tostring(s.name) .. " is requesting themselves — waiting"
            return false, "partner requests first"
        end
    end
    -- candidates: partners in the server, with trade, no cooldown; score — how many of our potions they have
    local candidates = {}
    for _, s in ipairs(state.partners) do
        local p = partnerPlayer(s.name)
        if p and (tonumber(s.rolls) or 0) >= 1000 and (os.clock() >= (state.targetCooldown[s.name] or 0)) then
            local score = 0
            for name, cnt in pairs(state.want) do
                local have = (s.potions or {})[name] or 0
                if have > 0 then score = score + math.min(have, cnt) end
            end
            if score > 0 then candidates[#candidates + 1] = { player = p, name = s.name, score = score } end
        end
    end
    table.sort(candidates, function(a, b)
        if a.score ~= b.score then return a.score > b.score end
        return a.name < b.name
    end)
    if #candidates == 0 then
        -- nobody has what we need — try any available partner with trade
        for _, s in ipairs(state.partners) do
            local p = partnerPlayer(s.name)
            if p and (tonumber(s.rolls) or 0) >= 1000 and (os.clock() >= (state.targetCooldown[s.name] or 0)) then
                candidates[#candidates + 1] = { player = p, name = s.name, score = 0 }
            end
        end
        table.sort(candidates, function(a, b) return a.name < b.name end)
    end
    if #candidates == 0 then
        state.phase = "no partners with trade in the server"
        state.retryAt = os.clock() + 15
        return false, "no partners (or they have <1000 rolls / cooldown)"
    end
    local target = candidates[1].player
    state.lastRequest = os.clock()
    state.lastReqAt = os.time()
    state.retryAt = os.clock() + 8
    state.requests = state.requests + 1
    state.trade = { active = true, partner = target, role = "requester", phase = "requested", give = {} }
    pcall(function() TradeRE.RequestTrade:FireServer(target) end)
    log("requesting potions from " .. target.Name .. (candidates[1].score > 0 and (" (matches: " .. candidates[1].score .. ")") or ""))
    writeState()
    return true
end

-- ------------------------------------------------------------------ workers --
local function tick()
    if not CONFIG.COOP then return end
    local TF = _G.TowerFarm
    local tid = TF and TF.state and TF.state.towerId or nil
    local root = PG:FindFirstChild("Root")
    local tower = root and root:FindFirstChild("Tower")
    local screen = tower and tower:FindFirstChild("Screen")
    local floorLabel = screen and screen:FindFirstChild("Floor")
    if floorLabel and floorLabel:IsA("TextLabel") and screen.Visible then
        local n = tonumber(string.match(floorLabel.Text or "", "%d+"))
        if n and tid then
            if (state.myFloors[tid] or 0) < n then state.myFloors[tid] = n end
        end
    end
    computePower()
    -- queue: if there is an assignment — don't overwrite it with the TowerFarm list
    if #(state.assign[LP.Name] or {}) == 0 then
        state.myQueue = towerQueue()
    end
    recomputeWant()
    writeState()
    autoAssign(false)
    -- sync TowerFarm queue with the assignment (by the actual set)
    local asg = state.assign[LP.Name]
    if TF and type(TF.setQueue) == "function" and asg and #asg > 0 and not selMatches(TF.state and TF.state.selected or {}, asg) then
        state.tfSeen = true
        state.tfSynced = state.assignVersion
        pcall(TF.setQueue, asg)
        log("TowerFarm queue updated to match the assignment (" .. #asg .. " towers)")
    end
    -- autonomous farm keep-alive: if not running — start it (after STOP/failure within ~10 s)
    if CONFIG.AUTO_START_FARM and TF and type(TF.start) == "function" and asg and #asg > 0 then
        if TF.state and TF.state.running then
            state.farmStoppedAt = nil
        else
            local nowC = os.clock()
            state.farmStoppedAt = state.farmStoppedAt or nowC
            if (nowC - state.farmStoppedAt) >= 10 then
                state.farmStoppedAt = nowC
                local okS, errS = pcall(TF.start)
                log(okS and "auto-start tower farm" or ("auto-start farm failed: " .. tostring(errS)))
            end
        end
    end
    local canT, whyT = canTradeSelf()
    if CONFIG.AUTO_REQUEST and state.running and next(state.want) ~= nil and not state.trade.active and canT
        and os.clock() >= (state.retryAt or 0) then
        requestNow()
    end
    local rolls = tonumber(try(function() return DC.Rolls() end)) or 0
    state.phase = string.format("rolls %d | strength %.3g | pool %d | potions %d | want %d | %s",
        rolls, accStrength({ power = state.myPower }),
        (function() local n = 0 for _ in pairs(state.pool) do n = n + 1 end return n end)(),
        (function() local n = 0 for _ in pairs(state.myPotions) do n = n + 1 end return n end)(),
        (function() local n = 0 for _ in pairs(state.want) do n = n + 1 end return n end)(),
        state.trade.active and ("trade with " .. tostring(state.trade.partner and state.trade.partner.Name) .. " [" .. tostring(state.trade.phase) .. "]")
            or (canT and "waiting" or ("trade unavailable: " .. tostring(whyT))))
end

local function start()
    if state.running then return end
    state.running = true
    registerSelf()
    setEnabled(true)
    computePower()
    if CONFIG.AUTO_SPLIT then autoAssign(true) end
    log("coop start (" .. LP.Name .. ")")
end
local function stop()
    state.running = false
    log("coop stop")
end

task.spawn(function()
    local lastReg = 0
    while alive() do
        task.wait(CONFIG.POLL or 2)
        if state.running then
            pcall(tick)
            if os.clock() - lastReg > 30 then
                lastReg = os.clock()
                pcall(registerSelf)
            end
        end
    end
end)

-- -------------------------------------------------------------------- UI -----
local Theme = {
    Bg = Color3.fromRGB(18, 20, 32), Text = Color3.fromRGB(238, 240, 250),
    Sub = Color3.fromRGB(150, 155, 180), Accent = Color3.fromRGB(80, 200, 160),
    Success = Color3.fromRGB(46, 160, 90), SuccessDark = Color3.fromRGB(24, 90, 52),
    Danger = Color3.fromRGB(170, 60, 60), Off = Color3.fromRGB(60, 60, 90),
}
local function new(parent, cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end
local gui = new(nil, "ScreenGui", { Name = "ADCoop", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = PG end
guis[#guis + 1] = gui
local frame = new(gui, "Frame", { Size = UDim2.fromOffset(380, 400), Position = UDim2.fromOffset(30, 430),
    BackgroundColor3 = Theme.Bg, BorderSizePixel = 0, Active = true })
new(frame, "UICorner", { CornerRadius = UDim.new(0, 10) })
new(frame, "UIStroke", { Color = Theme.Accent, Thickness = 1 })
local bar = new(frame, "Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Active = true, ZIndex = 2 })
new(bar, "TextLabel", { Size = UDim2.new(1, -44, 0, 20), Position = UDim2.fromOffset(8, 5), BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Left,
    Text = "AD Coop (pool + assignment + trade)", ZIndex = 2 })
local minBtn = new(bar, "TextButton", { Size = UDim2.fromOffset(24, 18), Position = UDim2.new(1, -30, 0, 5),
    BackgroundColor3 = Theme.Off, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Text, Text = "–", AutoButtonColor = false, ZIndex = 3 })
new(minBtn, "UICorner", { CornerRadius = UDim.new(0, 5) })
local body = new(frame, "Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
local collapsed = false
track(minBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    body.Visible = not collapsed
    frame.Size = UDim2.fromOffset(380, collapsed and 30 or 400)
    minBtn.Text = collapsed and "+" or "–"
end))
local dragging, dragStart, startPos = false, nil, nil
track(bar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, i.Position, frame.Position
    end
end))
track(UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end))
track(UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
end))
local function label(y, h, color, size)
    return new(body, "TextLabel", { Size = UDim2.new(1, -16, 0, h), Position = UDim2.fromOffset(8, y), BackgroundTransparency = 1,
        Font = Enum.Font.Gotham, TextSize = size or 11, TextColor3 = color or Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, Text = "" })
end
local function button(text, x, y, w, h, color)
    local b = new(body, "TextButton", { Size = UDim2.fromOffset(w, h), Position = UDim2.fromOffset(x, y), BackgroundColor3 = color or Theme.Off,
        Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.new(1, 1, 1), Text = text, AutoButtonColor = false })
    new(b, "UICorner", { CornerRadius = UDim.new(0, 6)})
    return b
end
local startBtn = button("START", 8, 30, 100, 26, Theme.Success)
local stopBtn = button("STOP", 116, 30, 100, 26, Theme.Danger)
local reqBtn = button("Request potions", 224, 30, 148, 26, Theme.Accent)
local assignBtn = button("Assign towers", 8, 60, 180, 24)
local enBtn = button("Trade requests: -", 196, 60, 176, 24)
local farmBtn = button("Auto-start farm: -", 8, 86, 364, 20)
local lbl0 = label(110, 14, Theme.Text)
local lbl1 = label(124, 14, Theme.Text)
local lbl2 = label(138, 14, Theme.Sub)
local lbl3 = label(152, 14, Theme.Sub)
local lbl4 = label(166, 70, Theme.Sub, 10)
local logLbl = new(body, "TextLabel", { Size = UDim2.new(1, -16, 0, 150), Position = UDim2.fromOffset(8, 240), BackgroundTransparency = 1,
    Font = Enum.Font.Code, TextSize = 10, TextColor3 = Theme.Sub, TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Text = "" })

local function fmt(n)
    n = tonumber(n) or 0
    local units = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No" }
    local i = 1
    while math.abs(n) >= 1000 and i < #units do n = n / 1000 i = i + 1 end
    return string.format("%.2f%s", n, units[i])
end

local function refresh()
    startBtn.BackgroundColor3 = state.running and Theme.Off or Theme.Success
    stopBtn.BackgroundColor3 = state.running and Theme.Danger or Color3.fromRGB(90, 60, 60)
    enBtn.Text = "Trade requests: " .. (state.enabled and "ON" or "OFF")
    enBtn.BackgroundColor3 = state.enabled and Theme.SuccessDark or Theme.Off
    farmBtn.Text = "Auto-start farm: " .. (CONFIG.AUTO_START_FARM and "ON" or "OFF")
    farmBtn.BackgroundColor3 = CONFIG.AUTO_START_FARM and Theme.SuccessDark or Theme.Off
    local poolN = 0 for _ in pairs(state.pool) do poolN = poolN + 1 end
    local wantN = 0 for _ in pairs(state.want) do wantN = wantN + 1 end
    local rolls = tonumber(try(function() return DC.Rolls() end)) or 0
    lbl0.Text = string.format("%s | rolls %d | squad strength %s", LP.Name, rolls, fmt(accStrength({ power = state.myPower })))
    lbl1.Text = string.format("Pool: %d | want potions: %d | %s", poolN, wantN, tostring(state.trade.active and ("trade: " .. tostring(state.trade.phase)) or "trade: -"))
    -- assignment
    local lines = {}
    local accs = { { name = LP.Name, power = state.myPower, pred = state.myPred } }
    for _, s in ipairs(state.partners or {}) do table.insert(accs, s) end
    table.sort(accs, function(a, b) return (a.name or "") < (b.name or "") end)
    for _, a in ipairs(accs) do
        local tw = {}
        for _, id in ipairs((state.assign or {})[a.name] or {}) do
            local p = tonumber((a.pred or {})[id]) or 0
            tw[#tw + 1] = string.format("%s(%d)", id:gsub(" Tower", ""), p)
        end
        lines[#lines + 1] = string.format("%s: strength %s -> %s", tostring(a.name), fmt(accStrength(a)), table.concat(tw, ", "))
    end
    lbl4.Text = table.concat(lines, "\n")
    lbl2.Text = string.format("Trades: %d | requests: %d | %s", state.trades, state.requests, tostring(state.phase))
    lbl3.Text = "Next assignment recalc: " .. tostring(math.max(0, (CONFIG.ASSIGN_INTERVAL or 60) - (os.time() - (state.assignedAt or 0)))) .. "s"
    local l = {}
    for i = 1, math.min(#state.log, 9) do l[#l + 1] = state.log[i] end
    logLbl.Text = table.concat(l, "\n")
end
track(startBtn.MouseButton1Click:Connect(function() start() refresh() end))
track(stopBtn.MouseButton1Click:Connect(function() stop() refresh() end))
track(reqBtn.MouseButton1Click:Connect(function()
    local ok, err = requestNow()
    if not ok then log("request not sent: " .. tostring(err)) end
    refresh()
end))
track(assignBtn.MouseButton1Click:Connect(function()
    if CONFIG.AUTO_SPLIT then autoAssign(true) else
        log("AUTO_SPLIT is off — assignment not applied")
    end
    refresh()
end))
track(enBtn.MouseButton1Click:Connect(function() setEnabled(not state.enabled) refresh() end))
track(farmBtn.MouseButton1Click:Connect(function()
    CONFIG.AUTO_START_FARM = not CONFIG.AUTO_START_FARM
    log("auto-start farm: " .. (CONFIG.AUTO_START_FARM and "ON" or "OFF"))
    saveCfg()
    refresh()
end))
task.spawn(function()
    while alive() do task.wait(0.5) pcall(refresh) end
end)

_G.AD_Coop = {
    start = start, stop = stop, state = state, config = CONFIG,
    requestNow = requestNow, autoAssign = autoAssign, writeState = writeState,
    recomputeWant = recomputeWant, setEnabled = setEnabled, computePower = computePower,
    towerInfo = function() return TOWER_INFO end,
}
log("ready (v2). START or _G.AD_Coop.start()")

if CONFIG.AUTOSTART then
    task.delay(2, function()
        if alive() and not state.running then
            local ok, err = pcall(start)
            if ok then
                log("auto-start (together with the main script)")
            else
                log("auto-start failed: " .. tostring(err))
            end
        end
    end)
end

end

print("[OP AnimeDice v3.1] ready (COOP built in). RightCtrl — hide/show panels. Unload: _G.__OP_AD_CLEANUP()")