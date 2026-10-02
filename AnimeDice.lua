-- ==============================================================================


local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- ==============================================================================
-- CORE: session
-- ==============================================================================
if type(_G.__OP_AD_CLEANUP) == "function" then pcall(_G.__OP_AD_CLEANUP) end

local SESSION = {}
_G.__OP_AD_SESSION = SESSION
_G.__OP_SMART_MONEY = nil
_G.__OP_REBIRTH_BLOCK = nil
if _G.__OP_AUTONOMY == nil then _G.__OP_AUTONOMY = true end
_G.__OP_SPENT = 0
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
    if type(_G.__ADCOOP_CLEANUP) == "function" then pcall(_G.__ADCOOP_CLEANUP) end
end

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

local function markSpent(amount)
    amount = tonumber(amount) or 0
    if amount > 0 then _G.__OP_SPENT = (tonumber(_G.__OP_SPENT) or 0) + amount end
end

-- ==============================================================================
-- CORE: game data
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
        if not cfg then return nil end
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
-- CORE: config file
-- ==============================================================================
local OPCfg = (function()
    local FILE = "OP_AnimeDice_Antrax.cfg"
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
-- RED & BLACK THEME
-- ==============================================================================
local Theme = {
    Bg          = Color3.fromRGB(10, 10, 12),
    BgDark      = Color3.fromRGB(6, 6, 8),
    Card        = Color3.fromRGB(20, 20, 24),
    CardHover   = Color3.fromRGB(30, 30, 36),
    Deep        = Color3.fromRGB(14, 14, 18),
    Header      = Color3.fromRGB(16, 16, 20),
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
    Gold        = Color3.fromRGB(255, 190, 90),
    Off         = Color3.fromRGB(35, 35, 42),
    Active      = Color3.fromRGB(130, 22, 35),
    Selected    = Color3.fromRGB(45, 20, 28),
    Border      = Color3.fromRGB(60, 15, 25),
}

-- ==============================================================================
-- UNIFIED DASHBOARD
-- ==============================================================================
local UI = {}
local Dashboard = {
    tabs = {}, tabButtons = {}, contentFrames = {}, activeTab = nil,
    gui = nil, frame = nil, body = nil, tabBar = nil, content = nil, collapsed = false,
}

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

function UI.createDashboard(title, subtitle, w, h, x, y)
    destroyOld("OP_AnimeDice_Antrax")
    local gui = Instance.new("ScreenGui")
    gui.Name = "OP_AnimeDice_Antrax"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 9999
    mountGui(gui)
    table.insert(guis, gui)
    Dashboard.gui = gui

    local cam = workspace.CurrentCamera
    if cam then
        local vp = cam.ViewportSize
        if vp.X > 0 and vp.Y > 0 then
            x = math.clamp(x, 0, math.max(0, vp.X - w - 8))
            y = math.clamp(y, 0, math.max(0, vp.Y - h - 8))
        end
    end

    -- Main frame
    local frame = Instance.new("Frame")
    frame.Name = "Main"
    frame.Size = UDim2.fromOffset(w, h)
    frame.Position = UDim2.fromOffset(x, y)
    frame.BackgroundColor3 = Theme.Bg
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.ClipsDescendants = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Theme.Red
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2

    -- Top glow accent
    local topGlow = Instance.new("Frame")
    topGlow.Size = UDim2.new(1, 0, 0, 2)
    topGlow.BackgroundColor3 = Theme.RedBright
    topGlow.BorderSizePixel = 0
    topGlow.ZIndex = 3
    topGlow.Parent = frame
    local topGrad = Instance.new("UIGradient", topGlow)
    topGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1),
    })

    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 48)
    header.BackgroundColor3 = Theme.Header
    header.BorderSizePixel = 0
    header.Active = true
    header.ZIndex = 2
    header.Parent = frame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

    local headerCover = Instance.new("Frame")
    headerCover.Size = UDim2.new(1, 0, 0, 20)
    headerCover.Position = UDim2.new(0, 0, 1, -20)
    headerCover.BackgroundColor3 = Theme.Header
    headerCover.BorderSizePixel = 0
    headerCover.ZIndex = 2
    headerCover.Parent = header

    -- Red accent strip
    local strip = Instance.new("Frame")
    strip.Size = UDim2.new(1, 0, 0, 2)
    strip.Position = UDim2.new(0, 0, 1, -2)
    strip.BackgroundColor3 = Theme.Red
    strip.BorderSizePixel = 0
    strip.ZIndex = 3
    strip.Parent = header
    local stripGrad = Instance.new("UIGradient", strip)
    stripGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.6),
    })

    -- Logo dot
    local logo = Instance.new("Frame")
    logo.Size = UDim2.fromOffset(24, 24)
    logo.Position = UDim2.fromOffset(14, 12)
    logo.BackgroundColor3 = Theme.Red
    logo.BorderSizePixel = 0
    logo.ZIndex = 3
    logo.Parent = header
    Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)

    local logoInner = Instance.new("Frame")
    logoInner.Size = UDim2.fromOffset(10, 10)
    logoInner.Position = UDim2.fromScale(0.5, 0.5)
    logoInner.AnchorPoint = Vector2.new(0.5, 0.5)
    logoInner.BackgroundColor3 = Theme.Text
    logoInner.BorderSizePixel = 0
    logoInner.ZIndex = 4
    logoInner.Parent = logo
    Instance.new("UICorner", logoInner).CornerRadius = UDim.new(1, 0)

    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -220, 0, 18)
    titleLbl.Position = UDim2.fromOffset(46, 7)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = Theme.RedGlow
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Text = title
    titleLbl.ZIndex = 3
    titleLbl.Parent = header

    -- Credits
    local credLbl = Instance.new("TextLabel")
    credLbl.Size = UDim2.new(1, -220, 0, 12)
    credLbl.Position = UDim2.fromOffset(46, 26)
    credLbl.BackgroundTransparency = 1
    credLbl.Font = Enum.Font.Gotham
    credLbl.TextSize = 10
    credLbl.TextColor3 = Theme.Muted
    credLbl.TextXAlignment = Enum.TextXAlignment.Left
    credLbl.Text = subtitle
    credLbl.ZIndex = 3
    credLbl.Parent = header

    -- Credit badge (right side)
    local badge = Instance.new("Frame")
    badge.Size = UDim2.fromOffset(140, 24)
    badge.Position = UDim2.new(1, -290, 0, 12)
    badge.BackgroundColor3 = Theme.RedDeep
    badge.BorderSizePixel = 0
    badge.ZIndex = 3
    badge.Parent = header
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)
    local badgeStroke = Instance.new("UIStroke", badge)
    badgeStroke.Color = Theme.Red
    badgeStroke.Thickness = 1
    badgeStroke.Transparency = 0.4

    local badgeLbl = Instance.new("TextLabel")
    badgeLbl.Size = UDim2.fromScale(1, 1)
    badgeLbl.BackgroundTransparency = 1
    badgeLbl.Font = Enum.Font.GothamBold
    badgeLbl.TextSize = 10
    badgeLbl.TextColor3 = Theme.RedGlow
    badgeLbl.Text = "by Antrax • @AntraxdevZ"
    badgeLbl.ZIndex = 4
    badgeLbl.Parent = badge

    -- Minimize button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(30, 26)
    minBtn.Position = UDim2.new(1, -70, 0, 11)
    minBtn.BackgroundColor3 = Theme.RedDark
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.TextColor3 = Theme.Text
    minBtn.Text = "–"
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 5
    minBtn.Parent = header
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
    local minStroke = Instance.new("UIStroke", minBtn)
    minStroke.Color = Theme.Red
    minStroke.Thickness = 1
    minStroke.Transparency = 0.4

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(30, 26)
    closeBtn.Position = UDim2.new(1, -36, 0, 11)
    closeBtn.BackgroundColor3 = Theme.Danger
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.TextColor3 = Theme.Text
    closeBtn.Text = "X"
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 5
    closeBtn.Parent = header
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    -- Body
    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, 0, 1, -48)
    body.Position = UDim2.fromOffset(0, 48)
    body.BackgroundTransparency = 1
    body.Parent = frame

    -- Tab bar
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -20, 0, 36)
    tabBar.Position = UDim2.fromOffset(10, 8)
    tabBar.BackgroundColor3 = Theme.Deep
    tabBar.BorderSizePixel = 0
    tabBar.Parent = body
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)
    local tabBarStroke = Instance.new("UIStroke", tabBar)
    tabBarStroke.Color = Theme.Border
    tabBarStroke.Thickness = 1
    tabBarStroke.Transparency = 0.4

    -- Content area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -54)
    content.Position = UDim2.fromOffset(10, 52)
    content.BackgroundTransparency = 1
    content.Parent = body

    Dashboard.frame = frame
    Dashboard.body = body
    Dashboard.tabBar = tabBar
    Dashboard.content = content
    Dashboard.header = header
    Dashboard.collapsed = false

    -- Collapse toggle (single minimize button)
    track(minBtn.MouseButton1Click:Connect(function()
        Dashboard.collapsed = not Dashboard.collapsed
        body.Visible = not Dashboard.collapsed
        frame.Size = UDim2.fromOffset(w, Dashboard.collapsed and 48 or h)
        minBtn.Text = Dashboard.collapsed and "+" or "–"
    end))

    -- Close
    track(closeBtn.MouseButton1Click:Connect(function()
        if type(_G.__OP_AD_CLEANUP) == "function" then pcall(_G.__OP_AD_CLEANUP) end
    end))

    -- Dragging
    local dragging, dragStart, startPos = false, nil, nil
    track(header.InputBegan:Connect(function(input)
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

    -- RightCtrl toggle
    track(UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            for _, g in ipairs(guis) do g.Enabled = not g.Enabled end
        end
    end))

    return Dashboard
end

-- Create a tab
function UI.addTab(name, label)
    local count = 0
    for _ in pairs(Dashboard.tabs) do count = count + 1 end
    local total = count + 1

    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab_" .. name
    tabBtn.Size = UDim2.new(1 / total, -6, 1, -8)
    tabBtn.Position = UDim2.new(count / total, 3, 0, 4)
    tabBtn.BackgroundColor3 = Theme.Card
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 12
    tabBtn.TextColor3 = Theme.Sub
    tabBtn.Text = label
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = 2
    tabBtn.Parent = Dashboard.tabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local frame = Instance.new("Frame")
    frame.Name = "Content_" .. name
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = Dashboard.content

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.fromScale(1, 1)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = Theme.Red
    scroll.ScrollBarImageTransparency = 0.3
    scroll.CanvasSize = UDim2.new()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = frame

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local pad = Instance.new("UIPadding", scroll)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 2)
    pad.PaddingRight = UDim.new(0, 2)

    Dashboard.tabs[name] = { button = tabBtn, frame = frame, scroll = scroll, layout = layout, label = label }
    Dashboard.tabButtons[name] = tabBtn
    Dashboard.contentFrames[name] = frame

    track(tabBtn.MouseButton1Click:Connect(function() UI.showTab(name) end))

    -- Resize all tab buttons
    for i, tab in pairs(Dashboard.tabs) do
        -- recompute later
    end
    UI._resizeTabs()

    return frame, scroll
end

function UI._resizeTabs()
    local names = {}
    for n in pairs(Dashboard.tabs) do table.insert(names, n) end
    table.sort(names)
    local total = #names
    if total == 0 then return end
    for i, n in ipairs(names) do
        local tab = Dashboard.tabs[n]
        tab.button.Size = UDim2.new(1 / total, -6, 1, -8)
        tab.button.Position = UDim2.new((i - 1) / total, 3, 0, 4)
    end
end

function UI.showTab(name)
    for tabName, tab in pairs(Dashboard.tabs) do
        local isActive = (tabName == name)
        tab.frame.Visible = isActive
        if isActive then
            tab.button.BackgroundColor3 = Theme.Active
            tab.button.TextColor3 = Theme.RedGlow
            local stroke = tab.button:FindFirstChildOfClass("UIStroke")
            if not stroke then
                stroke = Instance.new("UIStroke", tab.button)
            end
            stroke.Color = Theme.Red
            stroke.Thickness = 1.4
            stroke.Transparency = 0.2
        else
            tab.button.BackgroundColor3 = Theme.Card
            tab.button.TextColor3 = Theme.Sub
            local stroke = tab.button:FindFirstChildOfClass("UIStroke")
            if stroke then stroke:Destroy() end
        end
    end
    Dashboard.activeTab = name
end

-- Card container
function UI.card(parent, height, title)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, height)
    card.BackgroundColor3 = Theme.Card
    card.BorderSizePixel = 0
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Theme.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.3

    if title and title ~= "" then
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -20, 0, 18)
        titleLbl.Position = UDim2.fromOffset(12, 8)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 12
        titleLbl.TextColor3 = Theme.RedGlow
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Text = title
        titleLbl.Parent = card

        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -24, 0, 1)
        line.Position = UDim2.fromOffset(12, 30)
        line.BackgroundColor3 = Theme.Border
        line.BorderSizePixel = 0
        line.Parent = card
    end

    return card
end

-- Label
function UI.label(parent, text, ly, color, size, width)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, width and -width or -24, 0, 14)
    l.Position = UDim2.fromOffset(12, ly)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.TextSize = size or 11
    l.TextColor3 = color or Theme.Text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Text = text or ""
    l.Parent = parent
    return l
end

-- Button
function UI.button(parent, text, bx, by, bw, bh, color, size)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(bw, bh)
    b.Position = UDim2.fromOffset(bx, by)
    b.BackgroundColor3 = color or Theme.Off
    b.Font = Enum.Font.GothamBold
    b.TextSize = size or 11
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Text = text
    b.AutoButtonColor = false
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", b)
    stroke.Color = Theme.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.4

    return b
end

function UI.onClick(btn, fn)
    track(btn.MouseButton1Click:Connect(function()
        local ok, err = pcall(fn)
        if not ok then warn("[OP] UI: " .. tostring(err)) end
    end))
end

function UI.paintToggle(btn, on, label)
    btn.Text = label .. ": " .. (on and "ON" or "OFF")
    btn.BackgroundColor3 = on and Theme.SuccessDark or Theme.Off
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if stroke then stroke.Color = on and Theme.Red or Theme.Border end
end

-- ==============================================================================
-- CREATE DASHBOARD + TABS
-- ==============================================================================
UI.createDashboard(
    "Anime Dice • Antrax",
    "Unified Auto Farm Suite",
    540, 640, 60, 80
)

local tfFrame, tfScroll = UI.addTab("towerfarm", "TOWER FARM")
local fbFrame, fbScroll = UI.addTab("farmboost", "FARM BOOST")
local apFrame, apScroll = UI.addTab("progression", "PROGRESSION")
UI.showTab("towerfarm")

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
        POTION_REFRESH = 60,
        POTION_RETRY = 10,
        AUTO_COLLECT = true,
        AUTO_POTIONS = true,
        HIDE_TOWER_UI = true,
        AUTO_EQUIP_BEST = true,
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

    -- ============ UI ============
    -- Header controls card
    local cardMain = UI.card(tfScroll, 130, "TOWER FARM CONTROLS")

    local statusLbl = UI.label(cardMain, "Select a tower and press START", 36, Theme.Sub)
    local infoLbl = UI.label(cardMain, "", 54, Theme.Text)
    local statsLbl = UI.label(cardMain, "", 70, Theme.Text)
    local rateLbl = UI.label(cardMain, "", 86, Theme.Sub)
    local rewLbl = UI.multiline and UI.multiline(cardMain, "", 102, Theme.Gold) or UI.label(cardMain, "", 102, Theme.Gold)

    -- Simple buttons row card
    local cardBtns = UI.card(tfScroll, 92, "QUICK ACTIONS")
    local startBtn = UI.button(cardBtns, "START", 12, 40, 100, 30, Theme.Success, 12)
    local stopBtn = UI.button(cardBtns, "STOP", 118, 40, 100, 30, Theme.Danger, 12)
    local equipBtn = UI.button(cardBtns, "Equip Best", 224, 40, 100, 30, Theme.Off, 11)
    local collectBtn = UI.button(cardBtns, "", 330, 40, 100, 30, Theme.SuccessDark, 11)
    local potionBtn = UI.button(cardBtns, "", 436, 40, 90, 30, Theme.SuccessDark, 11)

    local cardToggles = UI.card(tfScroll, 74, "TOGGLES")
    local hideBtn = UI.button(cardToggles, "", 12, 40, 160, 26, Theme.SuccessDark, 11)
    local equipAutoBtn = UI.button(cardToggles, "", 180, 40, 160, 26, Theme.SuccessDark, 11)

    -- Tower list card
    local cardList = UI.card(tfScroll, 260, "TOWER SELECTION")

    local listActionsFrame = Instance.new("Frame")
    listActionsFrame.Size = UDim2.new(1, -24, 0, 22)
    listActionsFrame.Position = UDim2.fromOffset(12, 34)
    listActionsFrame.BackgroundTransparency = 1
    listActionsFrame.Parent = cardList

    local selAllBtn = UI.button(listActionsFrame, "Select All", 0, 0, 80, 20, Theme.Off, 10)
    local selNoneBtn = UI.button(listActionsFrame, "Clear", 86, 0, 60, 20, Theme.Off, 10)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -24, 0, 190)
    scroll.Position = UDim2.fromOffset(12, 62)
    scroll.BackgroundColor3 = Theme.Deep
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Theme.Red
    scroll.CanvasSize = UDim2.new()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = cardList
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
    local listLayout = Instance.new("UIListLayout", scroll)
    listLayout.Padding = UDim.new(0, 3)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    setStatus = function(text) statusLbl.Text = tostring(text) end

    local towerRows = {}
    for _, t in ipairs(SORTED) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, -8, 0, 24)
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
        Instance.new("UIPadding", row).PaddingLeft = UDim.new(0, 8)
        towerRows[t.id] = {row = row, info = t}
        UI.onClick(row, function()
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
        for i = 1, math.min(#list, 3) do
            table.insert(parts, list[i].k .. " x" .. formatShort(list[i].v))
        end
        rewLbl.Text = "Rewards: " .. (#parts > 0 and table.concat(parts, " | ") or "—")
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
        UI.paintToggle(collectBtn, CONFIG.AUTO_COLLECT, CONFIG.AUTO_COLLECT and "Money" or "Money")
        UI.paintToggle(potionBtn, CONFIG.AUTO_POTIONS, "Potions")
        UI.paintToggle(hideBtn, CONFIG.HIDE_TOWER_UI, "Hide screen")
        UI.paintToggle(equipAutoBtn, CONFIG.AUTO_EQUIP_BEST, "Auto-equip")
        stopBtn.BackgroundColor3 = state.running and Theme.Danger or Theme.DangerDim
        refreshRewards()
    end

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
                    setStatus("No towers selected")
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
            setStatus("No towers selected")
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
            setStatus("Game is running: " .. tostring(state.towerId))
        else
            setStatus("Waiting to start: " .. tostring(state.towerId))
        end
        while isCurrent(runId) do
            task.wait(0.6)
            if not isCurrent(runId) then break end
            local nxt, ni = nextInQueue()
            if not nxt then
                setStatus("Queue empty")
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
            setStatus("Select at least one tower")
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

    UI.onClick(startBtn, start)
    UI.onClick(stopBtn, stop)
    UI.onClick(equipBtn, function()
        equipBest()
        setStatus("Team updated")
    end)
    UI.onClick(collectBtn, function()
        CONFIG.AUTO_COLLECT = not CONFIG.AUTO_COLLECT
        refreshFarmUI(); persistTF()
    end)
    UI.onClick(potionBtn, function()
        CONFIG.AUTO_POTIONS = not CONFIG.AUTO_POTIONS
        refreshFarmUI(); persistTF()
    end)
    UI.onClick(hideBtn, function()
        CONFIG.HIDE_TOWER_UI = not CONFIG.HIDE_TOWER_UI
        if CONFIG.HIDE_TOWER_UI then task.spawn(hideTowerScreen) end
        refreshFarmUI(); persistTF()
    end)
    UI.onClick(equipAutoBtn, function()
        CONFIG.AUTO_EQUIP_BEST = not CONFIG.AUTO_EQUIP_BEST
        refreshFarmUI(); persistTF()
    end)
    UI.onClick(selAllBtn, function()
        for _, t in ipairs(SORTED) do state.selected[t.id] = true end
        refreshFarmUI(); persistTF()
    end)
    UI.onClick(selNoneBtn, function()
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
        markSpent(cost)
        state.fuses = state.fuses + 1
        state.lastFuse = picks[1].name .. " + " .. picks[2].name .. " + " .. picks[3].name
        task.wait(3.2)
    end, "fuse")

    task.delay(1, function()
        if alive() and CONFIG.PROTECT then applyProtect() end
    end)

    -- UI
    local cardMain = UI.card(apScroll, 130, "AUTO PROGRESSION")
    local statusLbl = UI.label(cardMain, "Configure the toggles and press START", 36, Theme.Sub)
    local resLbl = UI.label(cardMain, "", 54, Theme.Gold)
    local statLbl = UI.label(cardMain, "", 70, Theme.Text)
    local statLbl2 = UI.label(cardMain, "", 86, Theme.Text)
    local targetLbl = UI.label(cardMain, "", 102, Theme.Sub)

    local cardBtns = UI.card(apScroll, 60, "CONTROLS")
    local startBtn = UI.button(cardBtns, "START", 12, 40, 110, 28, Theme.Success)
    local stopBtn = UI.button(cardBtns, "STOP", 130, 40, 110, 28, Theme.Danger)
    local protectBtn = UI.button(cardBtns, "", 248, 40, 120, 28, Theme.SuccessDark)

    local cardToggles = UI.card(apScroll, 132, "FEATURES")
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
        local b = UI.button(cardToggles, "", 12 + col * 180, 40 + rowN * 30, 168, 26, Theme.Off)
        toggleBtns[t.key] = {btn = b, label = t.label}
        UI.onClick(b, function()
            CONFIG[t.key] = not CONFIG[t.key]
            refreshProgUI(); persistAP()
        end)
    end

    local cardInfo = UI.card(apScroll, 78, "INFO")
    local afkLbl = UI.label(cardInfo, "", 36, Theme.Sub)
    local rewLbl = UI.label(cardInfo, "", 52, Theme.Sub)
    local rewLbl3 = UI.label(cardInfo, "", 66, Theme.Sub)

    local cardGrade = UI.card(apScroll, 78, "GRADE TARGET (GEMS)")
    local gradeSelBtns = {}
    for idx, name in ipairs(GRADE_CHOICES) do
        local b = UI.button(cardGrade, name, 12 + (idx - 1) * 58, 40, 54, 26, Theme.Off)
        gradeSelBtns[name] = b
        UI.onClick(b, function()
            state.targetGrades[name] = (not state.targetGrades[name]) or nil
            refreshProgUI(); persistAP()
        end)
    end

    local cardTrait = UI.card(apScroll, 106, "TRAIT TARGET (REROLLS)")
    local traitSelBtns = {}
    for idx, name in ipairs(TRAIT_CHOICES) do
        local rowN = (idx <= 4) and 0 or 1
        local col = (idx - 1) % 4
        local b = UI.button(cardTrait, name, 12 + col * 92, 40 + rowN * 30, 88, 26, Theme.Off, 10)
        traitSelBtns[name] = b
        UI.onClick(b, function()
            state.targetTraits[name] = (not state.targetTraits[name]) or nil
            refreshProgUI(); persistAP()
        end)
    end

    local function setStatus(text) statusLbl.Text = tostring(text) end

    refreshProgUI = function()
        stopBtn.BackgroundColor3 = state.running and Theme.Danger or Theme.DangerDim
        UI.paintToggle(protectBtn, CONFIG.PROTECT, "Protect")
        for key, t in pairs(toggleBtns) do UI.paintToggle(t.btn, CONFIG[key], t.label) end
        for name, b in pairs(gradeSelBtns) do
            b.BackgroundColor3 = state.targetGrades[name] and Theme.SuccessDark or Theme.Off
            local stroke = b:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = state.targetGrades[name] and Theme.Red or Theme.Border end
        end
        for name, b in pairs(traitSelBtns) do
            b.BackgroundColor3 = state.targetTraits[name] and Theme.SuccessDark or Theme.Off
            local stroke = b:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = state.targetTraits[name] and Theme.Red or Theme.Border end
        end
        local cost = rebirthCost()
        resLbl.Text = string.format("RB %d | Money %s | Reroll %d | Gems %s",
            Data.rebirth(), formatShort(Data.money()), Data.amountOf("Trait Reroll"), formatShort(Data.amountOf("Gems")))
        statLbl.Text = string.format("Claims %d | Rebirths %d | Upgrades %d | Fusions %d",
            state.claims, state.rebirths, state.upgrades, state.fuses)
        statLbl2.Text = string.format("Traits %d/✓%d (%s) | Grades %d/✓%d (%s)",
            state.traitRolls, state.traitHits, state.lastTrait, state.gradeRolls, state.gradeHits, state.lastGrade)
        targetLbl.Text = state.running and ("Active | unit: " .. tostring(state.targetUnit))
            or ("Idle | rebirth: " .. formatShort(cost))
        afkLbl.Text = "AFK Guard: " .. (_G.__OP_AFK_HOOKED and "ON" or "partial")
        rewLbl.Text = "Last fusion: " .. state.lastFuse
        local blocked = _G.__OP_SMART_MONEY and _G.__OP_REBIRTH_BLOCK
        rewLbl3.Text = blocked and "Rebirth held by smart spending" or "AFK teleports blocked: " .. (_G.__AFKTeleports or 0)
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

    UI.onClick(startBtn, start)
    UI.onClick(stopBtn, stop)
    UI.onClick(protectBtn, function()
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
-- SECTION 3: FARM BOOST
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
        EQUIP_RAREST = true,
        EQUIP_MIN_GAIN = 1.05,
        EQUIP_INTERVAL = 30,
        PERSIST = true,
        CLEAN_FREE_SLOTS = 15, CLEAN_INTERVAL = 25, CLEAN_MAX_PER_CYCLE = 40,
        CLEAN_DYNAMIC = true,
        SELL_KEEP_FRACTION = 0.35, SELL_MIN_KEEP = 20,
        SMART_INTERVAL = 15,
        SLOT_ACTIONS_PER_CYCLE = 8,
        REBIRTH_SAVE = 0.65, REBIRTH_MIN_GAIN = 0.03,
        DICE_MIN_GAIN = 1.15,
        DICE_PRIORITY = true,
        DICE_SAVE = 0.75,
        LUCK_TO_INCOME = 0.4,
        UPGRADE_EST_GAIN = 0.02,
        SLOT_ABS_MIN_ROI = 0, SLOT_MAX_PAYBACK = 1800, SLOT_BUDGET_PCT = 0.12,
        UPGRADE_SHARE = 0.4, RESERVE_GOAL_PCT = 0.75,
        MAX_PAYBACK_H = 3,
        SPEND_BEFORE_RB_ONLY = true,
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
            income = income,
            sortOrder = type(r) == "table" and tonumber(r.sortOrder) or 0,
            chance = Data.chance(item) or 0,
            variantMult = variantMult,
            order = tonumber(cfg.order) or 0,
        }
    end

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
                    if readSlots()[p.slot] == p.want then moved = moved + 1 end                end
            end
        end
        pcall(function() UnequipUnitRF:InvokeServer() end)
        state.equipChanges = state.equipChanges + moved
        state.equipNote = string.format("Stands: %d changes", moved)
        return moved
    end

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

    if _G.__OP_AUTONOMY ~= false then
        CONFIG.DICE_BUY, CONFIG.DICE_EQUIP, CONFIG.SPINS = true, true, true
        CONFIG.AUTO_ROLL, CONFIG.AUTO_SELL, CONFIG.SLOTS = true, true, true
        CONFIG.SMART_MONEY, CONFIG.SMART_CLEAN, CONFIG.EQUIP_RAREST = true, true, true
        CONFIG.DICE_PRIORITY, CONFIG.PERSIST = true, true
    end

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
            state.smartNote = string.format("Cleanup: -%d units (was %d/%d)", #keys, units, storage)
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

    local function rebirthInfo()
        local rb = Data.rebirth()
        local nxt = try(function() return Rebirths.GetNext(rb) end)
        return rb, type(nxt) == "table" and tonumber(nxt.cost) or nil
    end

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

    local function levelStep(cfg, itemName, baseAttrs, level)
        local cur, nxt = table.clone(baseAttrs), table.clone(baseAttrs)
        cur.level, nxt.level = level, level + 1
        local inc1 = tonumber(try(function() return cfg.income(cur) end))
        local inc2 = tonumber(try(function() return cfg.income(nxt) end))
        local price = tonumber(try(function() return UnitUtil.GetLevelPrice(itemName, cur) end))
        if not (inc1 and inc2 and price and price > 0) then return nil end
        return inc2 - inc1, price
    end

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

    local function globalMult()
        local _, base = standIncomes()
        local inc = state.incomePerSec or 0
        if base > 0 and inc > 0 then return math.clamp(inc / base, 0.1, 1e12) end
        return 1
    end

    local function newSlotShare()
        local list, sum = standIncomes()
        if sum <= 0 or #list == 0 then return 0.05 end
        local weakest = math.huge
        for _, s in ipairs(list) do weakest = math.min(weakest, s.income) end
        return weakest / sum
    end

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

    local function executeSlotPlan(plan, startMoney)
        local actions, spent = 0, 0
        for _, a in ipairs(plan) do
            if actions >= CONFIG.SLOT_ACTIONS_PER_CYCLE or not alive() then break end
            if math.min(Data.money(), startMoney - spent) < a.price then break end
            pcall(function() LevelUpSlotRE:FireServer(a.slot) end)
            actions = actions + 1
            spent = spent + a.price
            markSpent(a.price)
            state.slotsFired = state.slotsFired + 1
            state.lastSlot = tostring(a.slot)
            state.smartNote = string.format("Stand %s: %s →lvl%d", tostring(a.slot), a.name, a.level)
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

    local function smartTick()
        _G.__OP_SMART_MONEY = (state.running and CONFIG.SMART_MONEY) or false
        if not _G.__OP_SMART_MONEY then
            _G.__OP_REBIRTH_BLOCK = false
            return
        end

        local m, now = Data.money(), os.clock()
        local rb, rbCost = rebirthInfo()

        if state.lastMoneyT and state.lastMoney and now > state.lastMoneyT and state.lastRb == rb then
            local inst = (m - state.lastMoney + (tonumber(_G.__OP_SPENT) or 0)) / (now - state.lastMoneyT)
            if inst >= 0 then
                state.incomePerSec = state.incomePerSec and (state.incomePerSec * 0.7 + inst * 0.3) or inst
            end
        end
        state.lastRb = rb
        _G.__OP_SPENT = 0
        state.lastMoney, state.lastMoneyT = m, now

        local income = state.incomePerSec or 0
        local maxPaybackSec = math.max((tonumber(CONFIG.MAX_PAYBACK_H) or 3) * 3600, 1)
        local horizon = maxPaybackSec
        local luckK = tonumber(CONFIG.LUCK_TO_INCOME) or 0.4

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
                local gain = mg * (1 + luckK * (lg - 1)) - 1
                local unlockSlot = #unlockedSlots(rb + 1) > #unlockedSlots(rb)
                if unlockSlot then gain = gain + newSlotShare() * mg end
                local lost = math.max(m, rbCost)
                local payback = (income > 0 and gain > 1e-4) and (lost / (income * gain)) or math.huge
                local worth = (gain >= CONFIG.REBIRTH_MIN_GAIN or unlockSlot)
                    and (income <= 0 or payback <= maxPaybackSec)

                if worth then
                    if m >= rbCost then
                        state.smartNote = string.format("Waiting for rebirth: +%.0f%%, payback %s", gain * 100, formatTime(payback))
                        return
                    elseif m >= rbCost * CONFIG.REBIRTH_SAVE then
                        _G.__OP_REBIRTH_BLOCK = true
                        state.smartNote = string.format("Saving for rebirth (%.0f%% of %s)", m / rbCost * 100, formatShort(rbCost))
                        return
                    end
                    if CONFIG.SPEND_BEFORE_RB_ONLY and income > 0 then
                        horizon = math.min(horizon, math.max((rbCost - m) / income, 1))
                    end
                else
                    _G.__OP_REBIRTH_BLOCK = true
                    state.smartNote = string.format("Rebirth unprofitable (+%.0f%%)", gain * 100)
                end
            end
        end

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
                        state.smartNote = string.format("Bought die %s (×%.2f)", goal.name, goal.gain)
                        return
                    elseif income > 0 and m >= goal.price * (tonumber(CONFIG.DICE_SAVE) or 0.75) then
                        state.smartNote = string.format("Saving for die %s (%.0f%%)", goal.name, m / goal.price * 100)
                        return
                    end
                end
            end
        end

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
                for i = 1, n do c = c + plan[i].price; g = g + plan[i].gain end
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

        for _, opt in ipairs(options) do
            if opt.type == "dice" then
                if m >= opt.cost then
                    pcall(function() BuyDiceRE:FireServer(opt.name) end)
                    markSpent(opt.cost)
                    state.diceBought = state.diceBought + 1
                    state.lastBuy = opt.name
                    state.smartNote = string.format("Bought die %s (×%.2f)", opt.name, opt.gain)
                    return
                elseif m >= opt.cost * CONFIG.RESERVE_GOAL_PCT then
                    state.smartNote = string.format("Saving for die %s (%.0f%%)", opt.name, m / opt.cost * 100)
                    return
                end
            elseif opt.type == "slots" then
                if executeSlotPlan(opt.plan, m) > 0 then return end
            elseif opt.type == "upgrade" then
                if m >= opt.cost then
                    pcall(function() BuyUpgradeRE:FireServer(opt.id) end)
                    markSpent(opt.cost)
                    state.smartUpgrades = state.smartUpgrades + 1
                    state.smartNote = string.format("Upgrade %s (%s)", tostring(opt.id), formatShort(opt.cost))
                    return
                end
            end
        end

        if rbCost and m >= rbCost and not rebirthOn then
            state.smartNote = "Rebirth available! Enable in Progression tab"
        elseif income <= 0 then
            state.smartNote = "Measuring income..."
        else
            state.smartNote = string.format("Waiting (%s) | options: %d", formatShort(m), #options)
        end
    end

    loop(function() return CONFIG.SMART_INTERVAL end, smartTick, "smart-money")

    -- UI
    local cardMain = UI.card(fbScroll, 130, "FARM BOOST")
    local statusLbl = UI.label(cardMain, "Configure toggles and press START", 36, Theme.Sub)
    local rateLbl = UI.label(cardMain, "", 54, Theme.Gold)
    local statLbl = UI.label(cardMain, "", 70, Theme.Text)
    local statLbl2 = UI.label(cardMain, "", 86, Theme.Text)
    local statLbl3 = UI.label(cardMain, "", 102, Theme.Sub)

    local cardBtns = UI.card(fbScroll, 60, "CONTROLS")
    local startBtn = UI.button(cardBtns, "START", 12, 40, 110, 28, Theme.Success)
    local stopBtn = UI.button(cardBtns, "STOP", 130, 40, 110, 28, Theme.Danger)
    local saveBtn = UI.button(cardBtns, "Save Config", 248, 40, 130, 28, Theme.Off)

    local cardToggles = UI.card(fbScroll, 260, "FEATURES")
    local toggles = {
        {key = "DICE_BUY", label = "Dice: buy"},
        {key = "DICE_PRIORITY", label = "Dice: priority"},
        {key = "DICE_EQUIP", label = "Dice: equip"},
        {key = "SPINS", label = "Spins"},
        {key = "AUTO_ROLL", label = "Auto-roll"},
        {key = "AUTO_SELL", label = "Auto-sell"},
        {key = "SLOTS", label = "Slots + equip"},
        {key = "PERSIST", label = "Save config"},
        {key = "SMART_MONEY", label = "Smart spending"},
        {key = "SMART_CLEAN", label = "Smart cleanup"},
        {key = "EQUIP_RAREST", label = "Rare on stands"},
    }
    local toggleBtns = {}
    for i, t in ipairs(toggles) do
        local col = (i - 1) % 2
        local rowN = (i - 1) // 2
        local b = UI.button(cardToggles, "", 12 + col * 180, 40 + rowN * 30, 168, 26, Theme.Off)
        toggleBtns[t.key] = {btn = b, label = t.label}
        UI.onClick(b, function()
            CONFIG[t.key] = not CONFIG[t.key]
            saveCfg()
            refreshBoostUI()
        end)
    end

    local cardInfo = UI.card(fbScroll, 120, "STATUS")
    local hintLbl = UI.label(cardInfo, "", 36, Theme.Sub, 10)
    hintLbl.TextWrapped = true
    local afkLbl = UI.label(cardInfo, "", 92, Theme.Sub)
    local footLbl = UI.label(cardInfo, "", 106, Theme.Sub)

    local function setStatus(text) statusLbl.Text = tostring(text) end

    refreshBoostUI = function()
        stopBtn.BackgroundColor3 = state.running and Theme.Danger or Theme.DangerDim
        for key, t in pairs(toggleBtns) do UI.paintToggle(t.btn, CONFIG[key], t.label) end
        local units, storage = unitStats()
        local best, luck = bestOwnedDice()
        statLbl.Text = string.format("Units: %d/%d | Best die: %s (x%s)", units, storage, tostring(best or "-"), tostring(luck or "-"))
        statLbl2.Text = string.format("Dice: %d | Spins: %d | Slots: %d", state.diceBought, state.spinsUsed, state.slotsFired)
        statLbl3.Text = string.format("Auto-roll: %d | Auto-sell: %d | Drop: %.2f/s",
            state.autorollSet, state.sellSet, state.unitDropRate or 0)
        if CONFIG.SMART_MONEY then
            hintLbl.Text = "Smart: " .. tostring(state.smartNote)
                .. string.format("\nIncome: %s/h", formatShort((state.incomePerSec or 0) * 3600))
        else
            hintLbl.Text = string.format("Keeping: %d of %d | threshold: %s", state.sellKeep, state.sellTotal, formatShort(state.sellThreshold))
        end
        local m = Data.money()
        local elapsed = state.startedAt > 0 and (os.clock() - state.startedAt) or 0
        local netPerHour = elapsed > 1 and ((m - state.moneyStart) / elapsed * 3600) or 0
        rateLbl.Text = string.format("Income/h: %s | Net/h: %s | Money: %s",
            formatShort((state.incomePerSec or 0) * 3600), formatShort(netPerHour), formatShort(m))
        afkLbl.Text = string.format("AFK Guard: %s | Stands: %d", _G.__OP_AFK_HOOKED and "ON" or "partial", state.equipChanges)
        local rolls = tonumber(try(function() return DC.Rolls() end)) or 0
        footLbl.Text = string.format("Slot: %s | Rolls: %s | Cleaned: -%d", tostring(state.lastSlot), formatShort(rolls), state.cleaned)
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

    UI.onClick(startBtn, start)
    UI.onClick(stopBtn, stop)
    UI.onClick(saveBtn, function()
        saveCfg(true)
        setStatus("Settings saved")
    end)

    refreshBoostUI()
    loop(1, refreshBoostUI, "fb-ui")

    _G.FarmBoost = {
        start = start, stop = stop, state = state, config = CONFIG,
        save = saveCfg, load = loadCfg, money = Data.money, bestOwnedDice = bestOwnedDice,
        maxSlots = maxSlots, unitStats = unitStats, computeSellThreshold = computeSellThreshold,
        diceGoal = diceGoal, cheapestUpgrade = cheapestUpgrade,
        slotUpgradePlan = slotUpgradePlan, runSlotUpgrades = runSlotUpgrades,
        cleanCandidates = cleanCandidates, equipRarest = equipRarest, readSlots = readSlots,
        globalMult = globalMult, standIncomes = standIncomes, unlockedSlots = unlockedSlots,
    }
    print("[FarmBoost] loaded. dice=" .. tostring(currentDice()))

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
-- AFK GUARD (shared)
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

    _G.__OP_AFK_INPUTS = _G.__OP_AFK_INPUTS or 0
    local function afkInput()
        local any = false
        if type(mousemoverel) == "function" then
            if pcall(mousemoverel, 2, 0) then any = true end
            task.wait(0.05)
            pcall(mousemoverel, -2, 0)
        end
        if type(keypress) == "function" and type(keyrelease) == "function" then
            pcall(keypress, 0x20)
            task.wait(0.05)
            pcall(keyrelease, 0x20)
            any = true
        end
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.03)
            VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
        if any then _G.__OP_AFK_INPUTS = (_G.__OP_AFK_INPUTS or 0) + 1 end
    end
    loop(120, afkInput, "afk-input")

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
-- COOP (Compact Integration)
-- ==============================================================================
do
    local HttpService = game:GetService("HttpService")
    local TradeRE = NET.TradeService.RE
    local TowersMod = require(F.Towers.Towers)

    local CONFIG = {
        COOP = true, AUTOSTART = true,
        PARTNERS = {},
        AUTO_SPLIT = true, AUTO_START_FARM = true,
        MIN_PRED_FLOORS = 5,
        ASSIGN_INTERVAL = 60,
        AUTO_REQUEST = true, REQUEST_INTERVAL = 25,
        KEEP = 1, GIVE_MAX = 5,
        WANT_FILTER = { "Luck", "Damage", "Income" }, WANT_MIN = 1,
        AUTO_ACCEPT = true, POLL = 2,
        PREFIX = "OP_AD_COOP_",
    }

    -- COOP is off by default in this unified build.
    -- Enable via _G.AD_Coop.config.COOP = true and _G.AD_Coop.start()
    CONFIG.COOP = false

    _G.AD_Coop = {
        config = CONFIG,
        start = function() CONFIG.COOP = true; print("[ADCoop] enabled") end,
        stop = function() CONFIG.COOP = false; print("[ADCoop] disabled") end,
    }
end

print("[OP AnimeDice! Credits: Antrax | Telegram: @AntraxdevZ")