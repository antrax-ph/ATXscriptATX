--[[
    ═══════════════════════════════════════════════════════
    ANTRAX • RIDE A PET — Pro Edition (v5.0)
    By ANTRAX
    ═══════════════════════════════════════════════════════
    Clean • Minimal • Professional
    Sidebar Navigation • Logo • Minimize
]]

--==================================================
-- SERVICES
--==================================================
local Players             = game:GetService("Players")
local TweenService        = game:GetService("TweenService")
local RunService          = game:GetService("RunService")
local UserInputService    = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace           = game:GetService("Workspace")

local LocalPlayer         = Players.LocalPlayer
local TargetParent        = LocalPlayer:WaitForChild("PlayerGui")
local RenderedEggsFolder  = Workspace:WaitForChild("RenderedEggs", 10)

--==================================================
-- PALETTE
--==================================================
local P = {
    bg          = Color3.fromRGB(8,   8,  12),
    surface     = Color3.fromRGB(18, 18,  26),
    surface2    = Color3.fromRGB(24, 24,  34),
    surface3    = Color3.fromRGB(32, 32,  46),
    line        = Color3.fromRGB(46, 46,  68),
    lineSoft    = Color3.fromRGB(34, 34,  50),
    text        = Color3.fromRGB(232, 232, 240),
    textDim     = Color3.fromRGB(150, 152, 168),
    textMute    = Color3.fromRGB(108, 112, 132),
    violet      = Color3.fromRGB(124,  58, 237),
    violetDim   = Color3.fromRGB(88,  44, 178),
    cyan        = Color3.fromRGB(6,  182, 212),
    cyanDim     = Color3.fromRGB(14, 116, 144),
    amber       = Color3.fromRGB(245, 158, 11),
    magenta     = Color3.fromRGB(236,  72, 153),
    rose        = Color3.fromRGB(244,  63,  94),
    success     = Color3.fromRGB(16, 185, 129),
    sky         = Color3.fromRGB(14, 165, 233),
    indigo      = Color3.fromRGB(99, 102, 241),
    danger      = Color3.fromRGB(239,  68,  68),
    white       = Color3.fromRGB(255, 255, 255),
}

local C = {
    ESPFillTransparency    = 0.5,
    ESPOutlineTransparency = 0,
    GlobalESPColor         = Color3.fromRGB(255, 255, 0),
    CustomESPColor         = Color3.fromRGB(0, 255, 0),
    TPHeight               = 3,
    MovementSpeed          = 500,
    BestEggName            = "cherub",
    AutoEggHoldTime        = 3,
    AutoFarmHoldTime       = 2,
    AutoEggDelay           = 0.8,
    DesignW    = 500,
    DesignH    = 340,
    HeaderH    = 46,
    SidebarW   = 148,
    AnimTime   = 0.15,
    AnimFast   = 0.10,
    AnimSlow   = 0.25,
}

--==================================================
-- STATE
--==================================================
local S = {
    mainESPActive = false, espPlayers = false, espPets = false,
    espChests = false, espItems = false, eggData = {},
    autoBestEggActive = false, autoBestEggThread = nil,
    autoFarmActive = false, autoFarmThread = nil,
    autoFarmEggs = {}, autoFarmProcessed = {},
    autoRebirthActive = false, autoRebirthThread = nil, autoRebirthDelay = 5,
    autoSell = false, autoCollectRewards = false, showDamage = false,
    movementMode = "AutoFarm",
    movementActive = false, movementHumanoid = nil, movementPartsState = nil,
    tpKeybind = Enum.KeyCode.T, listeningForKey = false,
    currentSearchQuery = "", sortMode = "Name",
    activeTab = "Home", isMinimized = false,
}
local UI = { tabs = {}, refs = {} }

--==================================================
-- HELPERS
--==================================================
local function getCharacter() return LocalPlayer.Character end
local function getRootPart()
    local ch = getCharacter()
    return ch and ch:FindFirstChild("HumanoidRootPart")
end
local function getTargetCFrame(t)
    if not t or not t.Parent then return nil end
    if t:IsA("Model") then return t:GetPivot() end
    if t:IsA("BasePart") then return t.CFrame end
    return nil
end
local function getDistanceToTarget(t)
    local r = getRootPart(); local cf = getTargetCFrame(t)
    if not r or not cf then return math.huge end
    return (r.Position - cf.Position).Magnitude
end
local function getEggImage(n)
    local pg = LocalPlayer:FindFirstChild("PlayerGui"); if not pg then return "" end
    local m = pg:FindFirstChild("Main")
    local i = m and m:FindFirstChild("Index")
    local h = i and i:FindFirstChild("Holders")
    local e = h and h:FindFirstChild("EggsHolder"); if not e then return "" end
    local f = e:FindFirstChild(n); if not f then return "" end
    local im = f:FindFirstChild("ImageLabel")
    return (im and im:IsA("ImageLabel") and im.Image) or ""
end
local function tween(o, p, d, style, dir)
    if not o or not o.Parent then return end
    TweenService:Create(o, TweenInfo.new(
        d or C.AnimTime, style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out), p):Play()
end
local function grad(inst, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 0
    g.Parent = inst
    return g
end

--==================================================
-- ESP SYSTEM
--==================================================
local function createEggLabel(egg)
    local d = S.eggData[egg]
    if not d or (d.NameBillboard and d.NameBillboard.Parent) then return end
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 130, 0, 32)
    bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true
    bb.MaxDistance = 2000; bb.Enabled = false; bb.Parent = egg
    local n = Instance.new("TextLabel")
    n.Name = "EggName"; n.Size = UDim2.new(1, 0, 0, 17)
    n.BackgroundTransparency = 1; n.Text = egg.Name
    n.TextColor3 = P.white
    n.TextStrokeTransparency = 0.35; n.TextSize = 10
    n.Font = Enum.Font.GothamBold; n.Parent = bb
    local ds = Instance.new("TextLabel")
    ds.Name = "Distance"; ds.Size = UDim2.new(1, 0, 0, 13)
    ds.Position = UDim2.new(0, 0, 0, 17); ds.BackgroundTransparency = 1
    ds.TextColor3 = Color3.fromRGB(210, 210, 210)
    ds.TextStrokeTransparency = 0.4; ds.TextSize = 8
    ds.Font = Enum.Font.Gotham; ds.Parent = bb
    d.NameBillboard = bb
end
local function updateEggLabel(egg)
    local d = S.eggData[egg]
    if not d or not d.NameBillboard or not d.NameBillboard.Parent then return end
    local bb = d.NameBillboard
    local n = bb:FindFirstChild("EggName"); local ds = bb:FindFirstChild("Distance")
    if n then n.Text = egg.Name end
    if ds then
        local dd = getDistanceToTarget(egg)
        ds.Text = (dd == math.huge) and "?" or string.format("%dm", math.floor(dd + 0.5))
    end
end
local function updateEggESP(egg)
    if not egg or not (egg:IsA("Model") or egg:IsA("BasePart")) then return end
    if not S.eggData[egg] then
        S.eggData[egg] = {Highlight=nil, NameBillboard=nil,
            CustomColor = C.CustomESPColor, CustomActive = false}
    end
    local d = S.eggData[egg]
    local show, color = false, C.GlobalESPColor
    if d.CustomActive then show, color = true, d.CustomColor
    elseif S.mainESPActive then show, color = true, C.GlobalESPColor end
    if show then
        if not d.Highlight or not d.Highlight.Parent then
            local hl = Instance.new("Highlight")
            hl.Adornee = egg
            hl.FillTransparency = C.ESPFillTransparency
            hl.OutlineTransparency = C.ESPOutlineTransparency
            hl.Parent = egg; d.Highlight = hl
        end
        d.Highlight.FillColor = color; d.Highlight.OutlineColor = color
        d.Highlight.Enabled = true
        createEggLabel(egg)
        if d.NameBillboard then d.NameBillboard.Enabled = true end
        updateEggLabel(egg)
    else
        if d.Highlight then d.Highlight.Enabled = false end
        if d.NameBillboard then d.NameBillboard.Enabled = false end
    end
end
local function updateAllESP()
    if not RenderedEggsFolder then return end
    for _, e in ipairs(RenderedEggsFolder:GetChildren()) do updateEggESP(e) end
end
local function removeEggData(egg)
    local d = S.eggData[egg]; if not d then return end
    if d.Highlight then d.Highlight:Destroy() end
    if d.NameBillboard then d.NameBillboard:Destroy() end
    S.eggData[egg] = nil
end

--==================================================
-- MOVEMENT
--==================================================
local function teleportToModel(target)
    local r = getRootPart(); if not r then return false end
    local cf = getTargetCFrame(target); if not cf then return false end
    r.CFrame = cf * CFrame.new(0, C.TPHeight, 0); return true
end
local function setNoclip(en)
    local ch = getCharacter(); if not ch then return end
    if en then
        S.movementPartsState = {}
        for _, p in ipairs(ch:GetDescendants()) do
            if p:IsA("BasePart") then
                S.movementPartsState[p] = p.CanCollide; p.CanCollide = false
            end
        end
    elseif S.movementPartsState then
        for p, o in pairs(S.movementPartsState) do
            if p and p.Parent then p.CanCollide = o end
        end
        S.movementPartsState = nil
    end
end
local function moveToModel(target)
    if S.movementMode == "Teleport" then return teleportToModel(target) end
    if S.movementActive then return false end
    local ch = getCharacter(); local root = getRootPart()
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local cf = getTargetCFrame(target)
    if not root or not hum or not cf then return false end
    local dest = cf.Position + Vector3.new(0, C.TPHeight, 0)
    local sd = (root.Position - dest).Magnitude
    if sd <= 2 then root.CFrame = cf * CFrame.new(0, C.TPHeight, 0); return true end
    S.movementActive = true; S.movementHumanoid = hum
    local oldRot = hum.AutoRotate; local ok = false
    local t0 = os.clock(); local mx = math.max(3, sd / C.MovementSpeed + 2)
    setNoclip(true); hum.AutoRotate = false
    while S.movementActive and (os.clock() - t0) <= mx do
        if not target or not target.Parent then break end
        if getRootPart() ~= root then break end
        local off = dest - root.Position; local d = off.Magnitude
        if d <= 2 then root.CFrame = cf * CFrame.new(0, C.TPHeight, 0); ok = true; break end
        local dt = RunService.Heartbeat:Wait()
        root.CFrame = root.CFrame + off.Unit * math.min(d, C.MovementSpeed * dt)
    end
    S.movementActive = false
    if hum.Parent then hum.AutoRotate = oldRot end
    S.movementHumanoid = nil; setNoclip(false); return ok
end
local function stopMovement()
    S.movementActive = false
    if S.movementHumanoid and S.movementHumanoid.Parent then
        S.movementHumanoid.AutoRotate = true
    end
    S.movementHumanoid = nil; setNoclip(false)
end
local function teleportToHomePlot()
    local p = Workspace:FindFirstChild("Plots"); if not p then return false end
    for _, plot in ipairs(p:GetChildren()) do
        local d = plot:FindFirstChild("Data")
        if d then
            local o = d:FindFirstChild("Owner")
            if o then
                local own
                if o:IsA("StringValue") then own = o.Value == LocalPlayer.Name
                elseif o:IsA("ObjectValue") then own = o.Value == LocalPlayer
                else own = tostring(o.Value) == LocalPlayer.Name end
                if own then return moveToModel(plot) end
            end
        end
    end
    return false
end

--==================================================
-- AUTO FARM
--==================================================
local function holdEKey(dur)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(dur)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end
local function findBestEgg()
    if not RenderedEggsFolder then return nil end
    for _, e in ipairs(RenderedEggsFolder:GetChildren()) do
        if string.find(e.Name:lower(), C.BestEggName:lower(), 1, true) then return e end
    end
    return nil
end
local function stopAutoBestEgg()
    S.autoBestEggActive = false; stopMovement()
    if S.autoBestEggThread then task.cancel(S.autoBestEggThread); S.autoBestEggThread = nil end
end
local function startAutoBestEgg()
    stopAutoBestEgg(); S.autoBestEggActive = true
    S.autoBestEggThread = task.spawn(function()
        while S.autoBestEggActive do
            local egg = findBestEgg()
            if egg and egg.Parent then
                if moveToModel(egg) then
                    task.wait(0.3)
                    if S.autoBestEggActive and egg.Parent then holdEKey(C.AutoEggHoldTime) end
                    task.wait(0.2)
                    if S.autoBestEggActive then teleportToHomePlot() end
                    task.wait(C.AutoEggDelay)
                end
            else task.wait(0.5) end
        end
    end)
end
local function isValidEgg(e)
    return e and e.Parent == RenderedEggsFolder and (e:IsA("Model") or e:IsA("BasePart"))
end
local function getAutoFarmEggs()
    local f = {}; if not RenderedEggsFolder then return f end
    for _, e in ipairs(RenderedEggsFolder:GetChildren()) do
        if isValidEgg(e) and S.autoFarmEggs[e.Name] and not S.autoFarmProcessed[e] then
            table.insert(f, e)
        end
    end
    table.sort(f, function(a,b) return a.Name:lower() < b.Name:lower() end)
    return f
end
local function stopAutoFarm()
    S.autoFarmActive = false; stopMovement()
    if S.autoFarmThread then task.cancel(S.autoFarmThread); S.autoFarmThread = nil end
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end
local function startAutoFarm()
    stopAutoFarm(); S.autoFarmActive = true
    S.autoFarmThread = task.spawn(function()
        while S.autoFarmActive do
            local eggs = getAutoFarmEggs()
            if #eggs == 0 then S.autoFarmActive = false; S.autoFarmThread = nil; break end
            local worked = false
            for _, egg in ipairs(eggs) do
                if not S.autoFarmActive then break end
                if isValidEgg(egg) and not S.autoFarmProcessed[egg] then
                    worked = true
                    if moveToModel(egg) and S.autoFarmActive then
                        task.wait(0.3)
                        if S.autoFarmActive and isValidEgg(egg) then holdEKey(C.AutoFarmHoldTime) end
                        if S.autoFarmActive then task.wait(0.2); teleportToHomePlot() end
                        S.autoFarmProcessed[egg] = true; task.wait(0.2)
                    end
                end
            end
            if not worked then S.autoFarmActive = false; S.autoFarmThread = nil; break end
            task.wait(0.2)
        end
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end
local function stopAutoRebirth()
    S.autoRebirthActive = false
    if S.autoRebirthThread then task.cancel(S.autoRebirthThread); S.autoRebirthThread = nil end
end
local function startAutoRebirth()
    stopAutoRebirth(); S.autoRebirthActive = true
    S.autoRebirthThread = task.spawn(function()
        while S.autoRebirthActive do
            pcall(function()
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                local btn = pg and pg:FindFirstChild("RebirthButton", true)
                if btn and btn:IsA("GuiButton") then
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true, game, 0)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false, game, 0)
                end
            end)
            task.wait(S.autoRebirthDelay)
        end
    end)
end

--==================================================
-- CLEANUP
--==================================================
for _, name in ipairs({"ANTRAX_Menu","ANTRAX_RIDE_A_PET_Menu","RenderedEggsESP_Menu","ANTRAX_Pro_UI","ANTRAX_MiniIcon"}) do
    pcall(function()
        local o = TargetParent:FindFirstChild(name)
        if o then o:Destroy() end
    end)
end

--==================================================
-- ROOT
--==================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ANTRAX_Pro_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = TargetParent

--==================================================
-- MAIN WINDOW
--==================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, C.DesignW, 0, C.DesignH)
MainFrame.Position = UDim2.new(0.5, -C.DesignW/2, 0.5, -C.DesignH/2)
MainFrame.BackgroundColor3 = P.bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner", MainFrame)
mainCorner.CornerRadius = UDim.new(0, 14)

-- Gradient border
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 1.6
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
grad(mainStroke, P.violet, P.cyan, 135)

--==================================================
-- HEADER
--==================================================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, C.HeaderH)
Header.BackgroundColor3 = P.surface
Header.BorderSizePixel = 0
Header.Active = true
Header.Parent = MainFrame

local hCorner = Instance.new("UICorner", Header)
hCorner.CornerRadius = UDim.new(0, 14)

-- Header filler (bottom corners square)
local hFill = Instance.new("Frame")
hFill.Size = UDim2.new(1, 0, 0, 14)
hFill.Position = UDim2.new(0, 0, 1, -14)
hFill.BackgroundColor3 = P.surface
hFill.BorderSizePixel = 0
hFill.Parent = Header

-- Header gradient overlay
local hGrad = Instance.new("Frame")
hGrad.Size = UDim2.new(1, 0, 1, 0)
hGrad.BackgroundColor3 = P.surface2
hGrad.BackgroundTransparency = 0.5
hGrad.BorderSizePixel = 0
hGrad.Parent = Header
local hg = grad(hGrad, P.surface, P.surface2, 90)
local hgCorner = Instance.new("UICorner", hGrad)
hgCorner.CornerRadius = UDim.new(0, 14)

-- Logo circle (ANTRAX brand)
local LogoBox = Instance.new("Frame")
LogoBox.Name = "LogoBox"
LogoBox.Size = UDim2.fromOffset(30, 30)
LogoBox.Position = UDim2.new(0, 14, 0.5, -15)
LogoBox.BackgroundColor3 = P.violet
LogoBox.BorderSizePixel = 0
LogoBox.ZIndex = 3
LogoBox.Parent = Header
local lbCorner = Instance.new("UICorner", LogoBox)
lbCorner.CornerRadius = UDim.new(1, 0)
grad(LogoBox, P.violetDim, P.violet, 135)

local lbStroke = Instance.new("UIStroke", LogoBox)
lbStroke.Color = P.violet
lbStroke.Thickness = 1.4
lbStroke.Transparency = 0.2

local lbText = Instance.new("TextLabel")
lbText.Size = UDim2.fromScale(1, 1)
lbText.BackgroundTransparency = 1
lbText.Text = "E"
lbText.TextColor3 = P.white
lbText.TextSize = 16
lbText.Font = Enum.Font.GothamBlack
lbText.ZIndex = 4
lbText.Parent = LogoBox

-- Title
local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(0, 200, 0, 18)
TitleLbl.Position = UDim2.new(0, 52, 0, 6)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "ANTRAX"
TitleLbl.TextColor3 = P.text
TitleLbl.TextSize = 14
TitleLbl.Font = Enum.Font.GothamBlack
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.ZIndex = 3
TitleLbl.Parent = Header
grad(TitleLbl, P.violet, P.cyan, 0)

local SubLbl = Instance.new("TextLabel")
SubLbl.Size = UDim2.new(0, 260, 0, 14)
SubLbl.Position = UDim2.new(0, 52, 0, 24)
SubLbl.BackgroundTransparency = 1
SubLbl.Text = "RIDE A PET  •  PRO EDITION v5.0"
SubLbl.TextColor3 = P.textDim
SubLbl.TextSize = 9
SubLbl.Font = Enum.Font.GothamBold
SubLbl.TextXAlignment = Enum.TextXAlignment.Left
SubLbl.ZIndex = 3
SubLbl.Parent = Header

-- Minimize button (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.fromOffset(28, 28)
MinBtn.Position = UDim2.new(1, -70, 0.5, -14)
MinBtn.BackgroundColor3 = P.surface2
MinBtn.Text = "-"
MinBtn.TextColor3 = P.text
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
MinBtn.AutoButtonColor = false
MinBtn.BorderSizePixel = 0
MinBtn.ZIndex = 4
MinBtn.Parent = Header
local mbCorner = Instance.new("UICorner", MinBtn)
mbCorner.CornerRadius = UDim.new(0, 8)
local mbStroke = Instance.new("UIStroke", MinBtn)
mbStroke.Color = P.line
mbStroke.Thickness = 1

-- Close button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.fromOffset(28, 28)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundColor3 = P.surface2
CloseBtn.Text = "X"
CloseBtn.TextColor3 = P.text
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 4
CloseBtn.Parent = Header
local cbCorner = Instance.new("UICorner", CloseBtn)
cbCorner.CornerRadius = UDim.new(0, 8)
local cbStroke = Instance.new("UIStroke", CloseBtn)
cbStroke.Color = P.line
cbStroke.Thickness = 1

--==================================================
-- SIDEBAR
--==================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, C.SidebarW, 1, -C.HeaderH - 24)
Sidebar.Position = UDim2.new(0, 0, 0, C.HeaderH)
Sidebar.BackgroundColor3 = P.surface
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Sidebar content list
local SidebarList = Instance.new("Frame")
SidebarList.Size = UDim2.new(1, 0, 1, 0)
SidebarList.BackgroundTransparency = 1
SidebarList.Parent = Sidebar

local SBLayout = Instance.new("UIListLayout")
SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
SBLayout.Padding = UDim.new(0, 3)
SBLayout.Parent = SidebarList

local SBPad = Instance.new("UIPadding")
SBPad.PaddingTop = UDim.new(0, 10)
SBPad.PaddingBottom = UDim.new(0, 10)
SBPad.PaddingLeft = UDim.new(0, 8)
SBPad.PaddingRight = UDim.new(0, 8)
SBPad.Parent = SidebarList

-- Section label helper
local function sectionLabel(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = P.textMute
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.Parent = parent
    return lbl
end

-- Add section labels
sectionLabel(SidebarList, "NAVIGATION", 0)

--==================================================
-- SIDEBAR TABS
--==================================================
local tabsOrder = {
    { id = "Home",      icon = "H",  title = "Home",       section = 1 },
    { id = "ESP",       icon = "E",  title = "ESP",        section = 1 },
    { id = "AutoFarm",  icon = "F",  title = "Auto Farm",  section = 1 },
    { id = "Teleports", icon = "T",  title = "Teleports",  section = 1 },
    { id = "Eggs",      icon = "G",  title = "Eggs List",  section = 1 },
    { id = "Misc",      icon = "M",  title = "Misc",       section = 2 },
    { id = "Settings",  icon = "S",  title = "Settings",   section = 2 },
}

-- Add second section label before Misc
local miscSectionAdded = false

for i, tab in ipairs(tabsOrder) do
    if tab.section == 2 and not miscSectionAdded then
        local sp = Instance.new("Frame")
        sp.Size = UDim2.new(1, 0, 0, 8)
        sp.BackgroundTransparency = 1
        sp.LayoutOrder = 100
        sp.Parent = SidebarList
        sectionLabel(SidebarList, "SYSTEM", 101)
        miscSectionAdded = true
    end

    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. tab.id
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = P.surface
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = i + 200
    btn.Parent = SidebarList

    local bCorner = Instance.new("UICorner", btn)
    bCorner.CornerRadius = UDim.new(0, 8)

    -- Icon box
    local iconBox = Instance.new("Frame")
    iconBox.Size = UDim2.fromOffset(20, 20)
    iconBox.Position = UDim2.new(0, 8, 0.5, -10)
    iconBox.BackgroundColor3 = P.surface2
    iconBox.BorderSizePixel = 0
    iconBox.ZIndex = 2
    iconBox.Parent = btn
    local ibC = Instance.new("UICorner", iconBox)
    ibC.CornerRadius = UDim.new(0, 6)

    local iconText = Instance.new("TextLabel")
    iconText.Size = UDim2.fromScale(1, 1)
    iconText.BackgroundTransparency = 1
    iconText.Text = tab.icon
    iconText.TextColor3 = P.textDim
    iconText.TextSize = 10
    iconText.Font = Enum.Font.GothamBlack
    iconText.ZIndex = 3
    iconText.Parent = iconBox

    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -36, 1, 0)
    titleLbl.Position = UDim2.new(0, 34, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = tab.title
    titleLbl.TextColor3 = P.textDim
    titleLbl.TextSize = 11
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 2
    titleLbl.Parent = btn

    -- Active indicator (left bar)
    local activeBar = Instance.new("Frame")
    activeBar.Size = UDim2.new(0, 3, 0.6, 0)
    activeBar.Position = UDim2.new(0, -2, 0.5, 0)
    activeBar.AnchorPoint = Vector2.new(0, 0.5)
    activeBar.BackgroundColor3 = P.violet
    activeBar.BorderSizePixel = 0
    activeBar.Visible = false
    activeBar.ZIndex = 4
    activeBar.Parent = btn
    local abC = Instance.new("UICorner", activeBar)
    abC.CornerRadius = UDim.new(1, 0)

    -- Content area
    local content = Instance.new("Frame")
    content.Name = "Content_" .. tab.id
    content.Size = UDim2.new(1, -C.SidebarW, 1, -C.HeaderH - 24)
    content.Position = UDim2.new(0, C.SidebarW, 0, C.HeaderH)
    content.BackgroundColor3 = P.bg
    content.BorderSizePixel = 0
    content.Visible = false
    content.Parent = MainFrame

    UI.tabs[tab.id] = {
        button = btn,
        content = content,
        iconBox = iconBox,
        iconText = iconText,
        label = titleLbl,
        activeBar = activeBar,
    }

    btn.MouseEnter:Connect(function()
        if S.activeTab ~= tab.id then
            tween(btn, { BackgroundTransparency = 0.4 }, C.AnimFast)
            btn.BackgroundColor3 = P.surface2
        end
    end)
    btn.MouseLeave:Connect(function()
        if S.activeTab ~= tab.id then
            tween(btn, { BackgroundTransparency = 1 }, C.AnimFast)
        end
    end)
end

--==================================================
-- FOOTER (Status bar)
--==================================================
local Footer = Instance.new("Frame")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, 0, 0, 24)
Footer.Position = UDim2.new(0, 0, 1, -24)
Footer.BackgroundColor3 = P.surface
Footer.BorderSizePixel = 0
Footer.Parent = MainFrame

local fCorner = Instance.new("UICorner", Footer)
fCorner.CornerRadius = UDim.new(0, 14)

local fTop = Instance.new("Frame")
fTop.Size = UDim2.new(1, 0, 0, 12)
fTop.Position = UDim2.new(0, 0, 0, 0)
fTop.BackgroundColor3 = P.surface
fTop.BorderSizePixel = 0
fTop.Parent = Footer

local fLine = Instance.new("Frame")
fLine.Size = UDim2.new(1, -20, 0, 1)
fLine.Position = UDim2.new(0, 10, 0, 0)
fLine.BackgroundColor3 = P.lineSoft
fLine.BorderSizePixel = 0
fLine.Parent = Footer

local fDot = Instance.new("Frame")
fDot.Size = UDim2.fromOffset(6, 6)
fDot.Position = UDim2.new(0, 14, 0.5, -3)
fDot.BackgroundColor3 = P.success
fDot.BorderSizePixel = 0
fDot.Parent = Footer
local fDotC = Instance.new("UICorner", fDot)
fDotC.CornerRadius = UDim.new(1, 0)

local fStatus = Instance.new("TextLabel")
fStatus.Size = UDim2.new(0, 200, 1, 0)
fStatus.Position = UDim2.new(0, 26, 0, 0)
fStatus.BackgroundTransparency = 1
fStatus.Text = "Status: Ready"
fStatus.TextColor3 = P.success
fStatus.TextSize = 9
fStatus.Font = Enum.Font.GothamBold
fStatus.TextXAlignment = Enum.TextXAlignment.Left
fStatus.Parent = Footer

local fVersion = Instance.new("TextLabel")
fVersion.Size = UDim2.new(0, 200, 1, 0)
fVersion.Position = UDim2.new(1, -212, 0, 0)
fVersion.BackgroundTransparency = 1
fVersion.Text = "ANTRAX  •  PRO v5.0"
fVersion.TextColor3 = P.textMute
fVersion.TextSize = 9
fVersion.Font = Enum.Font.GothamBold
fVersion.TextXAlignment = Enum.TextXAlignment.Right
fVersion.Parent = Footer

--==================================================
-- TAB SWITCHING
--==================================================
local function switchTab(id)
    S.activeTab = id
    for tid, t in pairs(UI.tabs) do
        if tid == id then
            t.content.Visible = true
            t.button.BackgroundTransparency = 0
            t.button.BackgroundColor3 = P.surface2
            t.iconText.TextColor3 = P.white
            t.iconBox.BackgroundColor3 = P.violet
            t.label.TextColor3 = P.text
            t.label.Font = Enum.Font.GothamBold
            t.activeBar.Visible = true

            -- Add gradient to icon box
            if not t.iconBox:FindFirstChildOfClass("UIGradient") then
                grad(t.iconBox, P.violetDim, P.violet, 135)
            end
        else
            t.content.Visible = false
            t.button.BackgroundTransparency = 1
            t.iconText.TextColor3 = P.textDim
            t.iconBox.BackgroundColor3 = P.surface2
            t.label.TextColor3 = P.textDim
            t.label.Font = Enum.Font.GothamMedium
            t.activeBar.Visible = false

            local g = t.iconBox:FindFirstChildOfClass("UIGradient")
            if g then g:Destroy() end
        end
    end
    local r = UI.refs["refresh_" .. id]
    if r then pcall(r) end
end

for id, t in pairs(UI.tabs) do
    t.button.MouseButton1Click:Connect(function() switchTab(id) end)
end

--==================================================
-- UI BUILDERS
--==================================================
local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 4); c.Parent = p
    return c
end
local function stroke(p, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or P.line; s.Thickness = t or 1
    s.Transparency = tr or 0; s.Parent = p
    return s
end
local function label(p, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1; l.Text = text or ""
    l.TextSize = size or 8; l.TextColor3 = color or P.text
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = p
    return l
end

local function makeCard(parent, title, height, order)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, height or 60)
    card.BackgroundColor3 = P.surface
    card.BorderSizePixel = 0
    card.LayoutOrder = order or 0
    card.Parent = parent
    corner(card, 10)
    stroke(card, P.lineSoft, 1, 0.5)

    -- Title row
    local tr = Instance.new("Frame")
    tr.Size = UDim2.new(1, -20, 0, 20)
    tr.Position = UDim2.new(0, 10, 0, 6)
    tr.BackgroundTransparency = 1
    tr.Parent = card

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(3, 12)
    dot.Position = UDim2.new(0, 0, 0.5, -6)
    dot.BackgroundColor3 = P.violet
    dot.BorderSizePixel = 0
    dot.Parent = tr
    corner(dot, 2)
    grad(dot, P.violet, P.cyan, 90)

    local tl = label(tr, title, 10, P.text, Enum.Font.GothamBold)
    tl.Size = UDim2.new(1, -10, 1, 0)
    tl.Position = UDim2.new(0, 10, 0, 0)

    -- Divider
    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, -20, 0, 1)
    div.Position = UDim2.new(0, 10, 0, 30)
    div.BackgroundColor3 = P.lineSoft
    div.BorderSizePixel = 0
    div.Parent = card

    -- Body
    local body = Instance.new("Frame")
    body.BackgroundTransparency = 1
    body.Size = UDim2.new(1, -20, 1, -38)
    body.Position = UDim2.new(0, 10, 0, 34)
    body.Parent = card

    local ll = Instance.new("UIListLayout")
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0, 4)
    ll.Parent = body

    return card, body
end

local function makeToggle(parent, text, initial, order, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 20)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    row.Parent = parent

    local l = label(row, text, 10, P.text, Enum.Font.GothamMedium)
    l.Size = UDim2.new(1, -46, 1, 0)

    local track = Instance.new("TextButton")
    track.Size = UDim2.fromOffset(36, 18)
    track.Position = UDim2.new(1, -36, 0.5, -9)
    track.BackgroundColor3 = initial and P.violet or P.surface3
    track.Text = ""
    track.AutoButtonColor = false
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 9)
    stroke(track, P.line, 1, 0.4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = initial and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = P.white
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 7)

    local state = initial
    local function set(v, fire)
        state = v
        tween(track, { BackgroundColor3 = state and P.violet or P.surface3 }, C.AnimFast)
        tween(knob, { Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }, C.AnimFast)
        if fire and callback then callback(state) end
    end
    track.MouseButton1Click:Connect(function() set(not state, true) end)
    return { setState = set, getState = function() return state end }
end

local function makeButton(parent, text, style, height, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, height or 22)
    b.Text = text
    b.TextColor3 = P.text
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Parent = parent
    corner(b, 8)

    if style == "primary" then
        b.BackgroundColor3 = P.violet
        grad(b, P.violetDim, P.violet, 90)
    elseif style == "danger" then
        b.BackgroundColor3 = P.danger
        grad(b, Color3.fromRGB(180, 40, 40), P.danger, 90)
    elseif style == "success" then
        b.BackgroundColor3 = P.success
        grad(b, Color3.fromRGB(10, 130, 90), P.success, 90)
    elseif style == "warning" then
        b.BackgroundColor3 = P.amber
    elseif style == "accent" then
        b.BackgroundColor3 = P.cyan
        grad(b, P.cyanDim, P.cyan, 90)
    else
        b.BackgroundColor3 = P.surface2
        stroke(b, P.line, 1, 0.3)
    end

    b.MouseEnter:Connect(function()
        tween(b, { BackgroundTransparency = 0.15 }, C.AnimFast)
    end)
    b.MouseLeave:Connect(function()
        tween(b, { BackgroundTransparency = 0 }, C.AnimFast)
    end)

    if callback then b.MouseButton1Click:Connect(callback) end
    return b
end

local function makeInput(parent, placeholder, initial, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 20)
    box.BackgroundColor3 = P.surface2
    box.BorderSizePixel = 0
    box.Text = tostring(initial or "")
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = P.textMute
    box.TextColor3 = P.text
    box.TextSize = 10
    box.Font = Enum.Font.GothamMedium
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = parent
    corner(box, 6)
    stroke(box, P.line, 1, 0.4)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = box

    box.FocusLost:Connect(function()
        if callback then callback(box.Text) end
    end)
    return box
end

local function makeScroll(parent)
    local s = Instance.new("ScrollingFrame")
    s.Size = UDim2.new(1, 0, 1, 0)
    s.BackgroundTransparency = 1
    s.BorderSizePixel = 0
    s.ScrollBarThickness = 3
    s.ScrollBarImageColor3 = P.violet
    s.CanvasSize = UDim2.new(0, 0, 0, 0)
    s.Parent = parent

    local ll = Instance.new("UIListLayout")
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0, 3)
    ll.Parent = s

    ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        s.CanvasSize = UDim2.new(0, 0, 0, ll.AbsoluteContentSize.Y + 5)
    end)
    return s
end

local function getEggList()
    local l = {}; if not RenderedEggsFolder then return l end
    for _, e in ipairs(RenderedEggsFolder:GetChildren()) do
        if e:IsA("Model") or e:IsA("BasePart") then table.insert(l, e) end
    end
    table.sort(l, function(a, b)
        if S.sortMode == "Distance" then
            return getDistanceToTarget(a) < getDistanceToTarget(b)
        end
        return a.Name:lower() < b.Name:lower()
    end)
    return l
end

local function clearList(s)
    for _, ch in ipairs(s:GetChildren()) do
        if not ch:IsA("UIListLayout") then ch:Destroy() end
    end
end

local function buildEggRow(parent, egg, actions)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -3, 0, 24)
    row.BackgroundColor3 = P.surface2
    row.BackgroundTransparency = 0.2
    row.BorderSizePixel = 0
    row.Parent = parent
    corner(row, 6)
    stroke(row, P.lineSoft, 1, 0.6)

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(18, 18)
    icon.Position = UDim2.new(0, 4, 0.5, -9)
    icon.BackgroundTransparency = 1
    icon.Image = getEggImage(egg.Name)
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = row

    local n = #actions
    local area = n * 26
    local dd = getDistanceToTarget(egg)
    local ds = (dd ~= math.huge) and string.format(" (%dm)", math.floor(dd + 0.5)) or ""

    local nl = label(row, egg.Name .. ds, 10, P.text, Enum.Font.GothamMedium)
    nl.Size = UDim2.new(1, -(26 + area), 1, 0)
    nl.Position = UDim2.new(0, 26, 0, 0)
    nl.TextTruncate = Enum.TextTruncate.AtEnd

    for i, act in ipairs(actions) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(24, 16)
        b.Position = UDim2.new(1, -3 - (n - i) * 26 - 24, 0.5, -8)
        b.BackgroundColor3 = act.color or P.surface3
        b.Text = act.text
        b.TextColor3 = P.white
        b.TextSize = 8
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.BorderSizePixel = 0
        b.Parent = row
        corner(b, 4)
        b.MouseButton1Click:Connect(function() if act.cb then act.cb(b) end end)
    end
    return row
end

local function tabBody(tabId)
    local content = UI.tabs[tabId].content
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = content

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = P.violet
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Parent = content

    local ll = Instance.new("UIListLayout")
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0, 8)
    ll.Parent = scroll

    ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, ll.AbsoluteContentSize.Y + 5)
    end)
    return scroll
end

--==================================================
-- HOME TAB
--==================================================
do
    local body = tabBody("Home")
    local c1, b1 = makeCard(body, "ESP SYSTEM", 90, 1)
    makeToggle(b1, "Enable ESP All", false, 1, function(v)
        S.mainESPActive = v; updateAllESP()
    end)
    makeToggle(b1, "Players ESP", false, 2, function(v) S.espPlayers = v end)
    makeToggle(b1, "Pets ESP", false, 3, function(v) S.espPets = v end)

    local c2, b2 = makeCard(body, "AUTO BEST EGG", 66, 2)
    makeToggle(b2, "Enable", false, 1, function(v)
        S.autoBestEggActive = v
        if v then startAutoBestEgg() else stopAutoBestEgg() end
    end)
    makeInput(b2, "Best egg name", C.BestEggName, function(t)
        C.BestEggName = (t ~= "" and t) or C.BestEggName
    end)

    local c3, b3 = makeCard(body, "QUICK ACTIONS", 42, 3)
    makeButton(b3, "Teleport Home", "primary", 22, function()
        teleportToHomePlot()
    end)

    local c4, b4 = makeCard(body, "INFO", 60, 4)
    local il = label(b4, "Drag header to move\nClick - to minimize\nClick X to close", 10, P.textDim, Enum.Font.Gotham)
    il.Size = UDim2.new(1, 0, 1, 0); il.TextYAlignment = Enum.TextYAlignment.Top
end

--==================================================
-- ESP TAB
--==================================================
do
    local body = tabBody("ESP")
    local c1, b1 = makeCard(body, "ESP TARGETS", 120, 1)
    makeToggle(b1, "Players", false, 1, function(v) S.espPlayers = v end)
    makeToggle(b1, "Pets", false, 2, function(v) S.espPets = v end)
    makeToggle(b1, "Eggs", false, 3, function(v)
        S.mainESPActive = v; updateAllESP()
    end)
    makeToggle(b1, "Chests", false, 4, function(v) S.espChests = v end)
    makeToggle(b1, "Items", false, 5, function(v) S.espItems = v end)

    local c2, b2 = makeCard(body, "INDIVIDUAL EGGS", 200, 2)
    local scroll = makeScroll(b2)
    local function refreshESPList()
        clearList(scroll)
        local eggs = getEggList()
        if #eggs == 0 then
            local n = label(scroll, "No eggs detected", 10, P.textMute, Enum.Font.GothamItalic)
            n.Size = UDim2.new(1, -3, 0, 18); return
        end
        for _, egg in ipairs(eggs) do
            local isOn = S.eggData[egg] and S.eggData[egg].CustomActive
            buildEggRow(scroll, egg, {
                { text = isOn and "ON" or "ESP",
                  color = isOn and P.success or P.surface3,
                  cb = function(btn)
                      if not S.eggData[egg] then
                          S.eggData[egg] = {Highlight=nil, NameBillboard=nil,
                              CustomColor = C.CustomESPColor, CustomActive = false}
                      end
                      local d = S.eggData[egg]
                      d.CustomActive = not d.CustomActive
                      d.CustomColor = C.CustomESPColor
                      btn.Text = d.CustomActive and "ON" or "ESP"
                      btn.BackgroundColor3 = d.CustomActive and P.success or P.surface3
                      updateEggESP(egg)
                  end }
            })
        end
    end
    UI.refs.refresh_ESP = refreshESPList
end

--==================================================
-- AUTO FARM TAB
--==================================================
do
    local body = tabBody("AutoFarm")
    local c1, b1 = makeCard(body, "FARM MODE", 80, 1)
    makeButton(b1, "AutoFarm (Walk)", "success", 22, function()
        S.movementMode = "AutoFarm"
    end)
    makeButton(b1, "Teleport", "accent", 22, function()
        S.movementMode = "Teleport"
    end)

    local c2, b2 = makeCard(body, "STOP", 42, 2)
    makeButton(b2, "Stop Auto Farm", "danger", 22, function()
        stopAutoFarm()
    end)

    local c3, b3 = makeCard(body, "AUTO REBIRTH", 76, 3)
    makeToggle(b3, "Auto Rebirth", false, 1, function(v)
        S.autoRebirthActive = v
        if v then startAutoRebirth() else stopAutoRebirth() end
    end)
    makeInput(b3, "Delay (s)", 5, function(t)
        local n = tonumber(t); if n then S.autoRebirthDelay = n end
    end)

    local c4, b4 = makeCard(body, "STATUS", 66, 4)
    local st = label(b4, "Active: false", 10, P.textDim, Enum.Font.Gotham)
    st.Size = UDim2.new(1, 0, 0, 14)
    local ct = label(b4, "Selected: 0", 10, P.textDim, Enum.Font.Gotham)
    ct.Size = UDim2.new(1, 0, 0, 14)
    local function upd()
        st.Text = "Active: " .. tostring(S.autoFarmActive)
        local n = 0
        for _ in pairs(S.autoFarmEggs) do n += 1 end
        ct.Text = "Selected: " .. n
    end
    upd()
    makeButton(b4, "Update", "default", 18, upd)
end

--==================================================
-- TELEPORTS TAB
--==================================================
do
    local body = tabBody("Teleports")
    local c1, b1 = makeCard(body, "QUICK TELEPORT", 100, 1)
    makeButton(b1, "Home Plot", "primary", 22, function() teleportToHomePlot() end)
    makeButton(b1, "Walk Home", "default", 20, function()
        S.movementMode = "AutoFarm"; teleportToHomePlot()
    end)
    makeButton(b1, "Instant Home", "default", 20, function()
        S.movementMode = "Teleport"; teleportToHomePlot()
    end)

    local c2, b2 = makeCard(body, "TELEPORT TO EGG", 200, 2)
    local scroll = makeScroll(b2)
    local function refreshTP()
        clearList(scroll)
        local eggs = getEggList()
        if #eggs == 0 then
            local n = label(scroll, "No eggs", 10, P.textMute, Enum.Font.GothamItalic)
            n.Size = UDim2.new(1, -3, 0, 18); return
        end
        for _, egg in ipairs(eggs) do
            buildEggRow(scroll, egg, {
                { text = "TP", color = P.violet, cb = function() teleportToModel(egg) end }
            })
        end
    end
    UI.refs.refresh_Teleports = refreshTP
end

--==================================================
-- EGGS TAB
--==================================================
do
    local content = UI.tabs.Eggs.content
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = content

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 22)
    top.BackgroundTransparency = 1
    top.Parent = content

    local search = makeInput(top, "Search eggs...", "", function(t)
        S.currentSearchQuery = t; UI.refs.refresh_Eggs()
    end)
    search.Size = UDim2.new(1, -110, 1, 0); search.Position = UDim2.new(0, 0, 0, 0)

    local sortB = makeButton(top, "Name", "default", 22, function(b)
        if S.sortMode == "Name" then
            S.sortMode = "Distance"; b.Text = "Dist"
        else
            S.sortMode = "Name"; b.Text = "Name"
        end
        UI.refs.refresh_Eggs()
    end)
    sortB.Size = UDim2.new(0, 50, 1, 0); sortB.Position = UDim2.new(1, -108, 0, 0)

    local refreshB = makeButton(top, "Refresh", "primary", 22, function()
        UI.refs.refresh_Eggs(); updateAllESP()
    end)
    refreshB.Size = UDim2.new(0, 52, 1, 0); refreshB.Position = UDim2.new(1, -52, 0, 0)

    local cnt = label(content, "Eggs: 0  |  Results: 0", 10, P.textDim, Enum.Font.GothamBold)
    cnt.Size = UDim2.new(1, 0, 0, 14); cnt.Position = UDim2.new(0, 0, 0, 26)

    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 1, -44)
    holder.Position = UDim2.new(0, 0, 0, 44)
    holder.BackgroundTransparency = 1; holder.Parent = content

    local scroll = makeScroll(holder)
    local function refreshEggs()
        clearList(scroll)
        local all = getEggList()
        local q = S.currentSearchQuery:lower()
        local shown = 0
        for _, egg in ipairs(all) do
            local match = q == "" or string.find(egg.Name:lower(), q, 1, true)
            if match then
                shown += 1
                local farmOn = S.autoFarmEggs[egg.Name] == true
                local espOn = S.eggData[egg] and S.eggData[egg].CustomActive
                buildEggRow(scroll, egg, {
                    { text = "TP", color = P.violet, cb = function()
                        teleportToModel(egg)
                    end },
                    { text = farmOn and "ON" or "FARM",
                      color = farmOn and P.success or P.surface3,
                      cb = function(btn)
                          S.autoFarmEggs[egg.Name] = not S.autoFarmEggs[egg.Name]
                          for p in pairs(S.autoFarmProcessed) do
                              if p and p.Name == egg.Name then
                                  S.autoFarmProcessed[p] = nil
                              end
                          end
                          local on = S.autoFarmEggs[egg.Name]
                          btn.Text = on and "ON" or "FARM"
                          btn.BackgroundColor3 = on and P.success or P.surface3
                          if on and not S.autoFarmActive then startAutoFarm() end
                          local any = false
                          for _ in pairs(S.autoFarmEggs) do any = true; break end
                          if not any then stopAutoFarm() end
                      end },
                    { text = espOn and "ON" or "ESP",
                      color = espOn and P.success or P.surface3,
                      cb = function(btn)
                          if not S.eggData[egg] then
                              S.eggData[egg] = {Highlight=nil, NameBillboard=nil,
                                  CustomColor = C.CustomESPColor, CustomActive = false}
                          end
                          local d = S.eggData[egg]
                          d.CustomActive = not d.CustomActive
                          d.CustomColor = C.CustomESPColor
                          btn.Text = d.CustomActive and "ON" or "ESP"
                          btn.BackgroundColor3 = d.CustomActive and P.success or P.surface3
                          updateEggESP(egg)
                      end },
                })
            end
        end
        cnt.Text = "Eggs: " .. tostring(#all) .. "  |  Results: " .. tostring(shown)
        if shown == 0 then
            local n = label(scroll, "No eggs found", 10, P.textMute, Enum.Font.GothamItalic)
            n.Size = UDim2.new(1, -3, 0, 18)
        end
    end
    UI.refs.refresh_Eggs = refreshEggs
end

--==================================================
-- MISC TAB
--==================================================
do
    local body = tabBody("Misc")
    local c1, b1 = makeCard(body, "MISC FEATURES", 90, 1)
    makeToggle(b1, "Auto Sell", false, 1, function(v) S.autoSell = v end)
    makeToggle(b1, "Auto Collect Rewards", false, 2, function(v) S.autoCollectRewards = v end)
    makeToggle(b1, "Show Damage", false, 3, function(v) S.showDamage = v end)

    local c2, b2 = makeCard(body, "UI SCALE", 70, 2)
    makeButton(b2, "Mobile Optimized", "primary", 22, function() end)
    makeButton(b2, "PC Optimized", "default", 20, function() end)
end

--==================================================
-- SETTINGS TAB
--==================================================
do
    local body = tabBody("Settings")
    local c1, b1 = makeCard(body, "KEYBIND", 50, 1)
    local kbB = makeButton(b1, "Key: [" .. S.tpKeybind.Name .. "]", "default", 22, function(b)
        S.listeningForKey = true; b.Text = "Press a key..."
    end)
    UI.refs.keybindBtn = kbB

    local c2, b2 = makeCard(body, "CREDITS", 100, 2)
    local cr = label(b2, "By ANTRAX\nRide A Pet\nPro Edition v5.0\nCommunity Build", 10, P.textDim, Enum.Font.Gotham)
    cr.Size = UDim2.new(1, 0, 1, 0); cr.TextYAlignment = Enum.TextYAlignment.Top
end

--==================================================
-- DRAG SYSTEM
--==================================================
local dragging, dragInput, dragStart, startPos
local function beginDrag(input)
    dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then dragging = false end
    end)
end
local function bindDrag(el)
    el.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            beginDrag(input)
        end
    end)
end
bindDrag(Header)
bindDrag(TitleLbl)
bindDrag(SubLbl)
bindDrag(LogoBox)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

--==================================================
-- MINIMIZE / RESTORE
--==================================================
local MiniIcon = Instance.new("TextButton")
MiniIcon.Name = "ANTRAX_MiniIcon"
MiniIcon.Size = UDim2.fromOffset(48, 48)
MiniIcon.Position = UDim2.new(0, 20, 0, 100)
MiniIcon.BackgroundColor3 = P.violet
MiniIcon.Text = "E"
MiniIcon.TextColor3 = P.white
MiniIcon.TextSize = 22
MiniIcon.Font = Enum.Font.GothamBlack
MiniIcon.AutoButtonColor = false
MiniIcon.Visible = false
MiniIcon.ZIndex = 200
MiniIcon.Parent = ScreenGui
corner(MiniIcon, 24)
grad(MiniIcon, P.violetDim, P.violet, 135)

local miStroke = Instance.new("UIStroke", MiniIcon)
miStroke.Color = P.violet
miStroke.Thickness = 2
miStroke.Transparency = 0.3

-- Drag support for mini icon
local miDragging, miDragStart, miStartPos
MiniIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        miDragging = true
        miDragStart = input.Position
        miStartPos = MiniIcon.Position
    end
end)
MiniIcon.InputChanged:Connect(function(input)
    if miDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - miDragStart
        MiniIcon.Position = UDim2.new(
            miStartPos.X.Scale, miStartPos.X.Offset + d.X,
            miStartPos.Y.Scale, miStartPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        miDragging = false
    end
end)

local miPressStart = 0
MiniIcon.MouseButton1Down:Connect(function()
    miPressStart = tick()
end)
MiniIcon.MouseButton1Up:Connect(function()
    if tick() - miPressStart < 0.25 then
        MiniIcon.Visible = false
        MainFrame.Visible = true
        S.isMinimized = false
    end
end)

local function minimizeMenu()
    S.isMinimized = true
    MainFrame.Visible = false
    MiniIcon.Visible = true
end

local function restoreMenu()
    S.isMinimized = false
    MiniIcon.Visible = false
    MainFrame.Visible = true
end

MinBtn.MouseButton1Click:Connect(minimizeMenu)
CloseBtn.MouseButton1Click:Connect(function()
    pcall(function() ScreenGui:Destroy() end)
end)

--==================================================
-- KEYBIND
--==================================================
UserInputService.InputBegan:Connect(function(input, gp)
    if S.listeningForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            S.tpKeybind = input.KeyCode; S.listeningForKey = false
            if UI.refs.keybindBtn then
                UI.refs.keybindBtn.Text = "Key: [" .. S.tpKeybind.Name .. "]"
            end
        end
        return
    end
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == S.tpKeybind then teleportToHomePlot() end
    end
end)

--==================================================
-- UPDATERS
--==================================================
task.spawn(function()
    while ScreenGui.Parent do
        if S.mainESPActive then
            for egg, d in pairs(S.eggData) do
                if egg and egg.Parent and d.NameBillboard and d.NameBillboard.Enabled then
                    updateEggLabel(egg)
                end
            end
        end
        task.wait(0.25)
    end
end)

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(1.5)
        if S.activeTab == "Eggs" and UI.refs.refresh_Eggs then
            pcall(UI.refs.refresh_Eggs)
        elseif S.activeTab == "ESP" and UI.refs.refresh_ESP then
            pcall(UI.refs.refresh_ESP)
        elseif S.activeTab == "Teleports" and UI.refs.refresh_Teleports then
            pcall(UI.refs.refresh_Teleports)
        end
    end
end)

--==================================================
-- WATCH EGGS
--==================================================
if RenderedEggsFolder then
    RenderedEggsFolder.ChildAdded:Connect(function(egg)
        S.autoFarmProcessed[egg] = nil
        task.wait(0.05)
        updateEggESP(egg)
    end)
    RenderedEggsFolder.ChildRemoved:Connect(function(egg)
        removeEggData(egg)
    end)
    for _, egg in ipairs(RenderedEggsFolder:GetChildren()) do
        updateEggESP(egg)
    end
end

--==================================================
-- BOOT
--==================================================
switchTab("Home")
print("[ATX] LOADED....")
