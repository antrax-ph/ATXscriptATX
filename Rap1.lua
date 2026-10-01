--[[
	╔══════════════════════════════════════════════════╗
	║   Ride A Pet Hub v3 (Fixed Version + Ctrl Key)  ║
	╠══════════════════════════════════════════════════╣
	║  RightShift  : เปิด/ปิดเมนู                         ║
	║  F           : บิน (WASD, Space/Ctrl ขึ้นลง)       ║
	║  N           : Noclip                            ║
	║  LeftControl : ล็อกเดินเร็ว (Toggle Walk Speed)      ║
	╚══════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = nil
do
	local ok, v = pcall(function()
		return game:GetService("VirtualUser")
	end)
	if ok then VirtualUser = v end
end

local LocalPlayer = Players.LocalPlayer

-- ประกาศล่วงหน้า
local notifyUI, shutdown, statusPara, WindUILib
local walkLockToggleObj = nil

--═══════════════ ปิดสคริปต์รอบก่อน (ถ้ามี) ═══════════════
do
	local old = getgenv().__RideHubHandle
	if old and old.shutdown then pcall(old.shutdown) end
	local oldFly = getgenv().__FlyHandle
	if oldFly and oldFly.shutdown then pcall(oldFly.shutdown) end
end

--═══════════════ GAME DATA ═══════════════
local EggConfig = {}
do
	local gd = ReplicatedStorage:FindFirstChild("GameData")
	local mod = gd and gd:FindFirstChild("Eggs")
	if mod then
		local ok, result = pcall(require, mod)
		if ok and type(result) == "table" then EggConfig = result end
	end
end

local Remotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Game")
local EggPickup = Remotes:WaitForChild("EggPickup")
local EggArrivalClaim = Remotes:FindFirstChild("EggArrivalClaim")
local HatchRemote = Remotes:FindFirstChild("Hatch")
local ActivateRadar = Remotes:FindFirstChild("ActivateRadar")
local FeedPetRemote = Remotes:FindFirstChild("FeedPet")
local PickupPetRemote = Remotes:FindFirstChild("PickupPet")
local RebirthRemote = Remotes:FindFirstChild("Rebirth")
local BuyWithCashRemote = Remotes:FindFirstChild("BuyWithCash")
local PlotNestsRemote = (Remotes:FindFirstChild("Plot") or {}) and Remotes:FindFirstChild("Plot") and Remotes:FindFirstChild("Plot"):FindFirstChild("Nests")
-- Remote สำหรับอัปเกรดป้าย
local PlotUpgradesRemote = Remotes:FindFirstChild("Plot") and Remotes:FindFirstChild("Plot"):FindFirstChild("Upgrades")

local RARITY_LIST = { "Common", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Ethereal" }
local RARITY_ORDER = { Common = 1, Rare = 2, Epic = 3, Legendary = 4, Mythic = 5, Divine = 6, Ethereal = 7 }
local RARITY_COLOR = {
	Common = Color3.fromRGB(200, 200, 200),
	Rare = Color3.fromRGB(80, 160, 255),
	Epic = Color3.fromRGB(175, 90, 255),
	Legendary = Color3.fromRGB(255, 170, 30),
	Mythic = Color3.fromRGB(255, 70, 70),
	Divine = Color3.fromRGB(60, 255, 230),
	Ethereal = Color3.fromRGB(255, 255, 255),
}

local function fmtNum(n)
	n = tonumber(n) or 0
	if n >= 1e12 then return string.format("%.1fT", n / 1e12) end
	if n >= 1e9 then return string.format("%.1fB", n / 1e9) end
	if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
	if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
	return tostring(math.floor(n))
end

-- รายการไอเทมในร้าน
local shopCatalog = {}
do
	local shop = LocalPlayer.PlayerGui:FindFirstChild("Main")
	shop = shop and shop:FindFirstChild("Shop")
	local holders = shop and shop:FindFirstChild("Holders")
	if holders then
		for _, cat in ipairs({ "Food", "Gears" }) do
			local container = holders:FindFirstChild(cat)
			if container then
				for _, tile in ipairs(container:GetChildren()) do
					if tile:IsA("Frame") and tile.Name ~= "BottomSpacer" and tile.Name ~= "ItemTemplate" then
						table.insert(shopCatalog, { cat = cat, item = tile.Name })
					end
				end
			end
		end
	end
end

--═══════════════ SETTINGS ═══════════════
local Settings = {
	rarities = { Common = true, Rare = true, Epic = true, Legendary = true, Mythic = true, Divine = true, Ethereal = true },
	sortMode = "หายากสุดก่อน",
	settleDelay = 1.2,
	perEggDelay = 0.3,
	eggsPerTrip = 1,
	buyItems = {},
	-- สวิตช์รายระบบ (เริ่มต้นปิดหมด)
	autoFarm = false,
	autoHatch = false,
	autoRadar = false,
	autoCash = false,
	autoFeed = false,
	autoManageNest = false,
	autoUnlockNest = false,
	autoBuy = false,
	autoRebirth = false,
	autoRejoin = false,
	autoUpgrades = false,
	sellMode = false,
	antiAfk = false,
	-- ESP
	esp = false,
	espDistance = true,
	-- การเคลื่อนที่
	flySpeed = 60,
	walkLock = false,
	walkSpeed = 16,
	jumpLock = false,
	jumpPower = 50,
}

--═══════════════ STATE ═══════════════
local version = 0
version += 1

local connections = {}
local function bind(signal, fn)
	local conn = signal:Connect(fn)
	table.insert(connections, conn)
	return conn
end

local controllerRunning = false
local mainRunning = false
local farmStats = { collected = 0, failed = 0, last = "-" }
local espObjects = {}
local espOrigColors = {}
local cool = {}

local function cd(key, secs)
	local t = cool[key]
	local now = os.clock()
	if t and now - t < secs then return false end
	cool[key] = now
	return true
end

--═══════════════ HELPERS ═══════════════
local function getRoot(char)
	char = char or LocalPlayer.Character
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
end

local function getHumanoid(char)
	char = char or LocalPlayer.Character
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function teleportTo(cf)
	local root = getRoot()
	if not root then return false end
	local hum = getHumanoid()
	if hum then hum.Sit = false end
	root.AssemblyLinearVelocity = Vector3.zero
	root.CFrame = cf
	return true
end

local function getPlot()
	local plots = Workspace:FindFirstChild("Plots")
	if not plots then return nil end
	for _, plot in ipairs(plots:GetChildren()) do
		local data = plot:FindFirstChild("Data")
		local owner = data and data:FindFirstChild("Owner")
		if owner and owner.Value == LocalPlayer then
			return plot
		end
	end
	return nil
end

local function getHomeCF()
	local plot = getPlot()
	local base = plot and plot:FindFirstChild("Baseplate")
	if base then
		return CFrame.new(base.Position + Vector3.new(0, base.Size.Y * 0.5 + 3.5, 0))
	end
	return nil
end

local function getBasket()
	return LocalPlayer:FindFirstChild("Basket")
end

local function basketCount()
	local basket = getBasket()
	return basket and #basket:GetChildren() or 0
end

local function hasFreeNest()
	return LocalPlayer:GetAttribute("NoNest") ~= true
end

--═══════════════ FLY ═══════════════
local flyState = { on = false, bv = nil, bg = nil }
local flySync = nil

local function flyDestroyParts()
	if flyState.bv then
		flyState.bv:Destroy()
		flyState.bv = nil
	end
	if flyState.bg then
		flyState.bg:Destroy()
		flyState.bg = nil
	end
end

local function flyStart()
	local root, hum = getRoot(), getHumanoid()
	if not root or not hum or hum.Health <= 0 then return end
	hum.Sit = false
	hum.PlatformStand = true
	flyDestroyParts()
	flyState.bv = Instance.new("BodyVelocity")
	flyState.bv.Name = "HubFlyVelocity"
	flyState.bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	flyState.bv.Velocity = Vector3.zero
	flyState.bv.Parent = root
	flyState.bg = Instance.new("BodyGyro")
	flyState.bg.Name = "HubFlyGyro"
	flyState.bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	flyState.bg.P = 9e4
	flyState.bg.D = 2659
	flyState.bg.CFrame = root.CFrame
	flyState.bg.Parent = root
	flyState.on = true
	if flySync then pcall(flySync, true) end
end

local function flyStop(silent)
	flyState.on = false
	flyDestroyParts()
	local hum = getHumanoid()
	if hum then hum.PlatformStand = false end
	local root = getRoot()
	if root then root.AssemblyLinearVelocity = Vector3.zero end
	if flySync then pcall(flySync, false) end
	if not silent then notifyUI("ปิดบินแล้ว") end
end

local function flyToggle(silent)
	if flyState.on then
		flyStop(silent)
	else
		flyStart()
	end
end

local noclip = false

local function setNoclip(on, silent)
	noclip = on
	if not on then
		local char = LocalPlayer.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					local holder = part.Parent
					if holder and holder:IsA("Accessory") then continue end
					part.CanCollide = true
				end
			end
		end
	end
	if not silent then notifyUI("Noclip: " .. (on and "เปิด" or "ปิด")) end
end

local function toggleWalkLock(state)
	if state == nil then
		Settings.walkLock = not Settings.walkLock
	else
		Settings.walkLock = state
	end

	local hum = getHumanoid()
	if not Settings.walkLock then
		if hum then hum.WalkSpeed = 16 end
		notifyUI("ล็อกเดินเร็ว: ปิด")
	else
		notifyUI("ล็อกเดินเร็ว: เปิด (" .. tostring(Settings.walkSpeed) .. ")")
	end

	if walkLockToggleObj then
		pcall(function() walkLockToggleObj:Set(Settings.walkLock) end)
	end
end

bind(RunService.RenderStepped, function()
	if flyState.on then
		local root, hum = getRoot(), getHumanoid()
		if not root or not hum or hum.Health <= 0 then
			flyStop(true)
			return
		end
		local cam = Workspace.CurrentCamera
		local move = Vector3.zero
		if cam then
			local look = cam.CFrame.LookVector
			local right = cam.CFrame.RightVector
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += look end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= look end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += right end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= right end
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.yAxis end
		if flyState.bv then
			flyState.bv.Velocity = move.Magnitude > 0 and move.Unit * Settings.flySpeed or Vector3.zero
		end
		if flyState.bg and cam then
			local look = cam.CFrame.LookVector
			local flat = Vector3.new(look.X, 0, look.Z)
			if flat.Magnitude > 0.01 then
				flyState.bg.CFrame = CFrame.lookAt(root.Position, root.Position + flat)
			end
		end
		hum.PlatformStand = true
	end
	if noclip then
		local char = LocalPlayer.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end
end)

bind(UserInputService.InputBegan, function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F then
		flyToggle()
	elseif input.KeyCode == Enum.KeyCode.N then
		setNoclip(not noclip)
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		if not flyState.on then
			toggleWalkLock()
		end
	end
end)

bind(LocalPlayer.CharacterAdded, function(char)
	local v = version
	char:WaitForChild("HumanoidRootPart", 5)
	task.wait(0.2)
	if version == v and flyState.on then
		flyStart()
	end
end)

bind(RunService.Heartbeat, function()
	local hum = getHumanoid()
	if not hum then return end
	if Settings.walkLock then
		if hum.WalkSpeed ~= Settings.walkSpeed then hum.WalkSpeed = Settings.walkSpeed end
	end
	if Settings.jumpLock then
		if hum.UseJumpPower then
			if hum.JumpPower ~= Settings.jumpPower then hum.JumpPower = Settings.jumpPower end
		else
			hum.UseJumpPower = true
			hum.JumpPower = Settings.jumpPower
		end
	end
end)

--═══════════════ ANTI-AFK ═══════════════
local antiAfkConn = nil
local function setAntiAfk(on)
	Settings.antiAfk = on
	if antiAfkConn then
		antiAfkConn:Disconnect()
		antiAfkConn = nil
	end
	if on and VirtualUser then
		antiAfkConn = LocalPlayer.Idled:Connect(function()
			pcall(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		end)
		table.insert(connections, antiAfkConn)
	end
end

--═══════════════ ESP ไข่ ═══════════════
local function rarityOf(eggName)
	local info = EggConfig[eggName]
	return info and info.Rarity or "Common"
end

local function luckOf(eggName)
	local info = EggConfig[eggName]
	return tonumber(info and info.Luck) or 0
end

local function espClear()
	for model, obj in pairs(espObjects) do
		if obj.billboard then obj.billboard:Destroy() end
		local hl = model:FindFirstChild("EggOutline")
		if hl and hl:IsA("Highlight") then
			local orig = espOrigColors[model]
			if orig then hl.OutlineColor = orig end
		end
	end
	table.clear(espObjects)
	table.clear(espOrigColors)
end

local function espUpdate()
	local rendered = Workspace:FindFirstChild("RenderedEggs")
	if not rendered then return end
	local root = getRoot()
	local seen = {}
	for _, model in ipairs(rendered:GetChildren()) do
		local base = model:FindFirstChild("EggBase")
		if base then
			seen[model] = true
			local obj = espObjects[model]
			if not obj then
				local billboard = Instance.new("BillboardGui")
				billboard.Name = "HubEggESP"
				billboard.Adornee = base
				billboard.AlwaysOnTop = true
				billboard.Size = UDim2.new(0, 180, 0, 66)
				billboard.StudsOffset = Vector3.new(0, 3.6, 0)
				billboard.MaxDistance = 5000
				local label = Instance.new("TextLabel")
				label.Name = "Label"
				label.BackgroundTransparency = 1
				label.Size = UDim2.new(1, 0, 1, 0)
				label.Font = Enum.Font.GothamBold
				label.TextScaled = true
				label.TextStrokeTransparency = 0.2
				label.TextColor3 = RARITY_COLOR[rarityOf(model.Name)] or Color3.new(1, 1, 1)
				label.Parent = billboard
				billboard.Parent = base
				local hl = model:FindFirstChild("EggOutline")
				if hl and hl:IsA("Highlight") then
					if espOrigColors[model] == nil then
						espOrigColors[model] = hl.OutlineColor
					end
					hl.OutlineColor = RARITY_COLOR[rarityOf(model.Name)] or Color3.new(1, 1, 1)
					hl.OutlineTransparency = 0
				end
				obj = { billboard = billboard, label = label, base = base }
				espObjects[model] = obj
			end
			local dist = root and math.floor((obj.base.Position - root.Position).Magnitude) or 0
			local luck = luckOf(model.Name)
			local line1 = model.Name .. (luck > 0 and ("  ★" .. fmtNum(luck)) or "")
			local line2 = Settings.espDistance and (dist .. " สตั๊ด") or ""
			obj.label.Text = line1 .. "\n" .. line2
		end
	end
	for model, obj in pairs(espObjects) do
		if not seen[model] or not model.Parent then
			if obj.billboard then obj.billboard:Destroy() end
			espObjects[model] = nil
		end
	end
end

local function setEsp(on)
	Settings.esp = on
	if not on then
		espClear()
	end
end

local espAcc = 0
bind(RunService.Heartbeat, function(dt)
	if not Settings.esp then return end
	espAcc += dt
	if espAcc < 0.5 then return end
	espAcc = 0
	espUpdate()
end)

--═══════════════ สแกนไข่ ═══════════════
local function scanEggs()
	local list = {}
	local serverData = ReplicatedStorage:FindFirstChild("ServerData")
	local activeEggs = serverData and serverData:FindFirstChild("ActiveEggs")
	local rendered = Workspace:FindFirstChild("RenderedEggs")
	if not activeEggs then return list end
	local renderedList = rendered and rendered:GetChildren() or {}
	local root = getRoot()
	for _, marker in ipairs(activeEggs:GetChildren()) do
		local eggName = marker:GetAttribute("Egg")
		local pos = marker:GetAttribute("Position")
		local info = eggName and EggConfig[eggName]
		local rarity = info and info.Rarity or "Common"
		if info and pos and Settings.rarities[rarity] then
			local bestModel, bestD
			for _, m in ipairs(renderedList) do
				if m.Name == eggName then
					local base = m:FindFirstChild("EggBase")
					if base then
						local d = (base.Position - pos).Magnitude
						if d < (bestD or 12) then
							bestModel, bestD = m, d
						end
					end
				end
			end
			if bestModel then
				table.insert(list, {
					guid = marker.Name,
					name = eggName,
					rarity = rarity,
					luck = tonumber(info.Luck) or 0,
					pos = pos,
					dist = root and (root.Position - pos).Magnitude or 0,
				})
			end
		end
	end
	if Settings.sortMode == "ใกล้สุดก่อน" then
		table.sort(list, function(a, b) return a.dist < b.dist end)
	elseif Settings.sortMode == "Luck สูงสุดก่อน" then
		table.sort(list, function(a, b)
			if a.luck ~= b.luck then return a.luck > b.luck end
			return a.dist < b.dist
		end)
	else
		table.sort(list, function(a, b)
			local ra, rb = RARITY_ORDER[a.rarity] or 0, RARITY_ORDER[b.rarity] or 0
			if ra ~= rb then return ra > rb end
			return a.dist < b.dist
		end)
	end
	return list
end

--═══════════════ เก็บไข่ + ฝากบ้าน ═══════════════
local pendingReplies = {}

bind(EggPickup.OnClientEvent, function(status, info, key)
	if key then
		pendingReplies[key] = { status = status, info = info }
	end
end)

local function tryPickup(entry)
	local root = getRoot()
	if not root then return { status = "NoCharacter" } end
	teleportTo(CFrame.new(entry.pos + Vector3.new(0, 4, 0)))
	task.wait(Settings.settleDelay)
	if not Settings.autoFarm then return { status = "Cancelled" } end
	pendingReplies[entry.guid] = nil
	EggPickup:FireServer(entry.guid)
	local t0 = os.clock()
	while os.clock() - t0 < 3 do
		if not Settings.autoFarm then return { status = "Cancelled" } end
		local reply = pendingReplies[entry.guid]
		if reply then return reply end
		task.wait(0.1)
	end
	return { status = "NoReply" }
end

local function depositAtHome()
	local homeCF = getHomeCF()
	if not homeCF then return false end
	teleportTo(homeCF)
	task.wait(1.0)
	local t0 = os.clock()
	while os.clock() - t0 < 4 do
		if basketCount() == 0 then return true end
		task.wait(0.25)
	end
	local basket = getBasket()
	local root = getRoot()
	if basket and #basket:GetChildren() > 0 and root and EggArrivalClaim then
		pcall(function()
			EggArrivalClaim:FireServer(Workspace:GetServerTimeNow(), root.Position, basket:GetChildren())
		end)
		task.wait(1.5)
	end
	return basketCount() == 0
end

--═══════════════ ระบบอัตโนมัติ ═══════════════

local function hatchReadyEggs()
	local plot = getPlot()
	if not plot or not HatchRemote then return 0 end
	local n = 0
	for _, d in ipairs(plot:GetDescendants()) do
		if not Settings.autoHatch then break end
		local key = d:GetAttribute("EggKey")
		if key then
			n += 1
			if cd("hatch_" .. key, 10) then
				task.spawn(function()
					pcall(function()
						HatchRemote:FireServer({ EggKey = key })
					end)
				end)
			end
		end
	end
	return n
end

local function collectPetCash()
	local plot = getPlot()
	local pets = plot and plot:FindFirstChild("Pets")
	if not pets then return 0 end
	local n = 0
	for _, pet in ipairs(pets:GetChildren()) do
		if not Settings.autoCash then break end
		if pet:IsA("Model") then
			local ok, pivot = pcall(function() return pet:GetPivot().Position end)
			if ok and pivot then
				teleportTo(CFrame.new(pivot + Vector3.new(0, 4, 0)))
				n += 1
				task.wait(0.15)
			end
		end
	end
	return n
end

local function pickupOnePet()
	if not PickupPetRemote then return false end
	local roots = {}
	local plot = getPlot()
	if plot then table.insert(roots, plot) end
	local gameObjects = Workspace:FindFirstChild("GameObjects")
	if gameObjects then table.insert(roots, gameObjects) end
	for _, rootInst in ipairs(roots) do
		if rootInst:GetAttribute("PetKey") then
			pcall(function() PickupPetRemote:FireServer(rootInst:GetAttribute("PetKey")) end)
			return true
		end
		for _, d in ipairs(rootInst:GetDescendants()) do
			local pk = d:GetAttribute("PetKey")
			if pk then
				pcall(function() PickupPetRemote:FireServer(pk) end)
				return true
			end
		end
	end
	return false
end

local function unlockOneNest()
	local plot = getPlot()
	local nests = plot and plot:FindFirstChild("Nests")
	if not nests or not PlotNestsRemote then return false end
	for _, nest in ipairs(nests:GetChildren()) do
		local num = tonumber(nest.Name)
		if num and nest:FindFirstChild("Locked") and cd("unlockNest_" .. num, 60) then
			local ok, pivot = pcall(function() return nest:GetPivot().Position end)
			if ok and pivot then
				teleportTo(CFrame.new(pivot + Vector3.new(0, 4, 0)))
				task.wait(1.0)
			end
			pcall(function() PlotNestsRemote:FireServer(num) end)
			return true
		end
	end
	return false
end

local function feedPets()
	local hum = getHumanoid()
	if not hum or not FeedPetRemote then return 0 end
	local food = nil
	for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
		if t:IsA("Tool") and t:HasTag("Food") then
			food = t
			break
		end
	end
	if not food then
		farmStats.last = "🍔 ไม่มีอาหารในกระเป๋า — ไปซื้อที่ร้าน Food"
		return 0
	end
	local plot = getPlot()
	if not plot then return 0 end
	hum:EquipTool(food)
	task.wait(0.3)
	local fed = 0
	for _, d in ipairs(plot:GetDescendants()) do
		if not Settings.autoFeed then break end
		local pk = d:GetAttribute("PetKey")
		if pk and cd("feed_" .. pk, 120) then
			pcall(function() FeedPetRemote:FireServer(pk, food.Name) end)
			fed += 1
			task.wait(0.2)
		end
	end
	if food.Parent == LocalPlayer.Character then food.Parent = LocalPlayer.Backpack end
	return fed
end

local function autoBuyItems()
	if #shopCatalog == 0 then
		farmStats.last = "🛒 ไม่พบรายการร้าน — เปิดร้านครั้งแรกแล้วรันสคริปต์ใหม่"
		return 0
	end
	local anySelected = false
	for _, entry in ipairs(shopCatalog) do
		if Settings.buyItems[entry.cat .. "|" .. entry.item] then
			anySelected = true
			break
		end
	end
	local bought = 0
	for _, entry in ipairs(shopCatalog) do
		if not Settings.autoBuy then break end
		local key = entry.cat .. "|" .. entry.item
		local allowed = not anySelected or Settings.buyItems[key]
		if allowed and BuyWithCashRemote and cd("buy_" .. key, 120) then
			pcall(function() BuyWithCashRemote:FireServer(entry.cat, entry.item) end)
			bought += 1
			if bought >= 5 then break end
		end
	end
	if bought > 0 then farmStats.last = ("🛒 ซื้อของอัตโนมัติ %d รายการ"):format(bought) end
	return bought
end

local function tryRebirth()
	if not RebirthRemote then return false end
	local ok = pcall(function() RebirthRemote:FireServer() end)
	if ok then farmStats.last = "♻️️ ยิง Rebirth แล้ว" end
	return ok
end

local function visitStall(name)
	local stalls = Workspace:FindFirstChild("Stalls")
	local stall = stalls and stalls:FindFirstChild(name)
	if not stall then
		notifyUI("ไม่พบร้าน " .. tostring(name))
		return
	end
	local ok, pivot = pcall(function() return stall:GetPivot().Position end)
	if not ok or not pivot then return end
	teleportTo(CFrame.new(pivot + Vector3.new(0, 4, 0)))
	task.wait(0.8)
	for _, d in ipairs(stall:GetDescendants()) do
		if d:IsA("ProximityPrompt") and d.Enabled then
			pcall(function() fireproximityprompt(d) end)
			break
		end
	end
	notifyUI("ไปร้าน " .. name .. " แล้ว")
end

local rejoinConn = nil
local function setAutoRejoin(on)
	Settings.autoRejoin = on
	if rejoinConn then
		rejoinConn:Disconnect()
		rejoinConn = nil
	end
	if not on then return end
	pcall(function()
		local uiRoot = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")
		local frame = uiRoot:FindFirstChild("RobloxPromptGuiFrame")
		local dialog = frame and frame:FindFirstChild("promptDialog")
		if dialog then
			rejoinConn = dialog:GetPropertyChangedSignal("Text"):Connect(function()
				local t = string.lower(dialog.Text or "")
				if t:find("kick") or t:find("kicked") or t:find("disconnect") then
					notifyUI("โดนเตะ! กำลังกลับเข้าเกมใหม่...")
					task.delay(1.5, function()
						pcall(function()
							game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
						end)
					end)
				end
			end)
		end
	end)
end

-- ฟังก์ชันอัปเกรดป้ายอัตโนมัติ (หน่วงเวลา 10 วินาที)
local function autoUpgradesLoop()
	while Settings.autoUpgrades do
		pcall(function()
			if PlotUpgradesRemote and cd("autoUpgrade_tick", 10.0) then
				PlotUpgradesRemote:FireServer("Max")
			end
		end)
		task.wait(1.0)
	end
end

--═══════════════ ลูปควบคุมหลัก ═══════════════
local function mainController()
	controllerRunning = true
	mainRunning = true
	while mainRunning do
		local hum = getHumanoid()
		if not hum or hum.Health <= 0 then
			task.wait(1)
			continue
		end

		if Settings.autoRadar and ActivateRadar and cd("radar", 30) then
			pcall(function() ActivateRadar:FireServer() end)
		end

		if Settings.autoRebirth and RebirthRemote and cd("rebirth", 120) then
			tryRebirth()
		end

		if Settings.autoHatch then
			hatchReadyEggs()
		end

		if Settings.autoFeed and cd("feed", 60) then
			feedPets()
		end

		if Settings.autoCash and cd("cash", 60) then
			collectPetCash()
		end

		if Settings.autoBuy and cd("autoBuy", 45) then
			autoBuyItems()
		end

		if Settings.autoFarm then
			local list = scanEggs()
			if #list == 0 then
				farmStats.last = "ไม่มีไข่ตามเงื่อนไข — รอเกิดไข่ใหม่"
				task.wait(3)
			else
				local tripDone = false
				for _, entry in ipairs(list) do
					if not Settings.autoFarm or tripDone then break end
					local reply = tryPickup(entry)
					
					if not Settings.autoFarm then break end
					
					if reply.status == "PickedUp" then
						farmStats.collected += 1
						farmStats.last = ("เก็บ %s (★%s) สำเร็จ"):format(entry.name, fmtNum(entry.luck))
						task.wait(0.2)
						if basketCount() >= Settings.eggsPerTrip then
							if Settings.sellMode then
								if cd("sellVisit", 30) then
									visitStall("Sell")
									farmStats.last = "💰 อยู่หน้าร้าน Sell — กดขายในหน้าต่างที่เกมเปิดให้"
								end
							else
								if not hasFreeNest() and Settings.autoUnlockNest then unlockOneNest() end
								if not hasFreeNest() and Settings.autoManageNest and cd("pickupPet", 180) then pickupOnePet() end
								depositAtHome()
								farmStats.last = hasFreeNest() and "ฝากไข่ที่บ้านแล้ว — เริ่มรอบใหม่" or "กลับบ้านแล้ว — รังยังเต็ม ถือไข่ไว้"
							end
							tripDone = true
						end
					elseif reply.status == "BasketFull" then
						farmStats.last = "🎒 ตะกร้าเต็ม!"
						break
					elseif reply.status ~= "Cancelled" then
						farmStats.failed += 1
						farmStats.last = ("พลาด %s: %s"):format(entry.name, tostring(reply.info or reply.status))
					end
					task.wait(Settings.perEggDelay)
				end
			end
		end

		if Settings.autoFarm and basketCount() > 0 then
			if Settings.sellMode then
				if cd("sellVisit", 30) then visitStall("Sell") end
			elseif hasFreeNest() then
				depositAtHome()
			end
		end

		task.wait(0.5)
	end
	controllerRunning = false
end

--═══════════════ UI (WindUI) ═══════════════
local Window
do
	local ok, WindUI = pcall(function()
		return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
	end)
	if ok and WindUI then
		WindUILib = WindUI
		local created, win = pcall(function()
			return WindUI:CreateWindow({
				Title = "Ride A Pet Hub",
				Icon = "egg",
				Author = "v3 Fixed • อัตโนมัติทุกระบบ",
				Folder = "RideAPetHub",
				Size = UDim2.fromOffset(560, 480),
				Theme = "Dark",
				Resizable = true,
				ToggleKey = Enum.KeyCode.RightShift,
				OpenButton = {
					Title = "เปิดเมนู RideHub",
					Icon = "egg",
					CornerRadius = UDim.new(0, 16),
					StrokeThickness = 2,
					Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
					OnlyMobile = false,
					Enabled = true,
					Draggable = true,
				},
			})
		end)
		if created then
			Window = win
			pcall(function() WindUI:SetNotificationLower(true) end)

			local TabMain = Window:Tab({ Title = "หน้าหลัก", Icon = "home" })
			local TabEggs = Window:Tab({ Title = "🥚 ไข่", Icon = "egg" })
			local TabPets = Window:Tab({ Title = "🐾 สัตว์เลี้ยง", Icon = "paw-print" })
			local TabShop = Window:Tab({ Title = "🛒 ร้านค้า", Icon = "shopping-cart" })
			local TabMove = Window:Tab({ Title = "🎮 การเคลื่อนที่", Icon = "feather" })
			local TabOther = Window:Tab({ Title = "⚙️ อื่น ๆ", Icon = "settings" })

			-- หน้าหลัก
			statusPara = TabMain:Paragraph({ Title = "📊 สถานะ", Desc = "กำลังโหลด..." })
			TabMain:Paragraph({ Title = "🤖 ระบบอัตโนมัติ", Desc = "เปิด/ปิดแต่ละระบบได้ในแท็บของมัน" })
			TabMain:Button({
				Title = "🏠 วาบกลับบ้าน",
				Icon = "house",
				Callback = function()
					local cf = getHomeCF()
					if cf then teleportTo(cf) notifyUI("กลับบ้านแล้ว") else notifyUI("ไม่พบบ้านของคุณ") end
				end,
			})

			-- แท็บ ไข่
			TabEggs:Toggle({
				Title = "🧺 เก็บไข่อัตโนมัติ",
				Value = Settings.autoFarm,
				Callback = function(v) Settings.autoFarm = v end,
			})
			TabEggs:Dropdown({
				Title = "ระดับไข่ที่จะเก็บ",
				Values = RARITY_LIST,
				Multi = true,
				AllowNone = true,
				Callback = function(selected)
					local chosen = {}
					if type(selected) == "table" then for _, r in ipairs(selected) do chosen[r] = true end
					elseif type(selected) == "string" then chosen[selected] = true end
					local any = false
					for _, r in ipairs(RARITY_LIST) do if chosen[r] then any = true break end end
					for _, r in ipairs(RARITY_LIST) do Settings.rarities[r] = not any or chosen[r] end
				end,
			})
			TabEggs:Dropdown({
				Title = "ลำดับการเก็บ",
				Values = { "หายากสุดก่อน", "Luck สูงสุดก่อน", "ใกล้สุดก่อน" },
				Callback = function(sel) Settings.sortMode = sel end,
			})
			TabEggs:Slider({
				Title = "เวลารอหลังวาบ (วินาที)",
				Value = { Min = 0.5, Max = 3, Default = 1.2 },
				Step = 0.1,
				Callback = function(v) Settings.settleDelay = v end,
			})
			TabEggs:Slider({
				Title = "หน่วงต่อฟอง (วินาที)",
				Value = { Min = 0.1, Max = 1, Default = 0.3 },
				Step = 0.05,
				Callback = function(v) Settings.perEggDelay = v end,
			})
			TabEggs:Slider({
				Title = "เก็บกี่ฟองต่อการกลับบ้าน",
				Value = { Min = 1, Max = 5, Default = 1 },
				Step = 1,
				Callback = function(v) Settings.eggsPerTrip = v end,
			})
			TabEggs:Toggle({
				Title = "ฟักไข่อัตโนมัติ",
				Value = Settings.autoHatch,
				Callback = function(v) Settings.autoHatch = v end,
			})
			TabEggs:Toggle({
				Title = "📡 เปิดเรดาร์อัตโนมัติ",
				Value = Settings.autoRadar,
				Callback = function(v) Settings.autoRadar = v end,
			})
			TabEggs:Toggle({
				Title = "ESP ไข่",
				Value = false,
				Callback = function(v) setEsp(v) end,
			})
			TabEggs:Toggle({
				Title = "แสดงระยะทาง ESP",
				Value = true,
				Callback = function(v) Settings.espDistance = v end,
			})

			-- แท็บ สัตว์เลี้ยง
			TabPets:Toggle({
				Title = "💰 เก็บเงินจากสัตว์เลี้ยง",
				Value = Settings.autoCash,
				Callback = function(v) Settings.autoCash = v end,
			})
			TabPets:Toggle({
				Title = "🍔 ให้อาหารอัตโนมัติ",
				Value = Settings.autoFeed,
				Callback = function(v) Settings.autoFeed = v end,
			})
			TabPets:Toggle({
				Title = "🐕 จัดรังอัตโนมัติ",
				Value = Settings.autoManageNest,
				Callback = function(v) Settings.autoManageNest = v end,
			})

			-- แท็บ ร้านค้า
			TabShop:Toggle({
				Title = "🛒 ซื้อของอัตโนมัติ",
				Value = Settings.autoBuy,
				Callback = function(v) Settings.autoBuy = v end,
			})
			do
				local byCat = { Food = {}, Gears = {} }
				for _, entry in ipairs(shopCatalog) do
					if byCat[entry.cat] then table.insert(byCat[entry.cat], entry.item) end
				end
				for _, cat in ipairs({ "Food", "Gears" }) do
					local items = byCat[cat]
					if items and #items > 0 then
						TabShop:Dropdown({
							Title = "🥬 ไอเทมร้าน " .. cat,
							Values = items,
							Multi = true,
							AllowNone = true,
							Callback = function(selected)
								local chosen = {}
								if type(selected) == "table" then for _, name in ipairs(selected) do chosen[name] = true end
								elseif type(selected) == "string" then chosen[selected] = true end
								local any = false
								for _, name in ipairs(items) do if chosen[name] then any = true break end end
								for _, name in ipairs(items) do Settings.buyItems[cat .. "|" .. name] = not any or chosen[name] end
							end,
						})
					end
				end
			end
			TabShop:Button({ Title = "⚙️ ไปร้าน Gears", Icon = "wrench", Callback = function() visitStall("Gears") end })
			TabShop:Button({ Title = "🍎 ไปร้าน Food", Icon = "apple", Callback = function() visitStall("Food") end })

			-- แท็บ การเคลื่อนที่
			local flyToggleObj = TabMove:Toggle({
				Title = "บิน (หรือกด F)",
				Value = false,
				Callback = function(v) if v ~= flyState.on then flyToggle(true) end end,
			})
			flySync = function(on) pcall(function() flyToggleObj:Set(on) end) end
			TabMove:Slider({
				Title = "ความเร็วบิน",
				Value = { Min = 10, Max = 500, Default = 60 },
				Step = 10,
				Callback = function(v) Settings.flySpeed = v end,
			})

			walkLockToggleObj = TabMove:Toggle({
				Title = "ล็อกเดินเร็ว (หรือกด Ctrl)",
				Value = false,
				Callback = function(v)
					if Settings.walkLock ~= v then
						toggleWalkLock(v)
					end
				end,
			})
			
			TabMove:Slider({
				Title = "ความเร็วเดิน",
				Value = { Min = 16, Max = 300, Default = 16 },
				Step = 2,
				Callback = function(v) Settings.walkSpeed = v end,
			})
			TabMove:Toggle({
				Title = "ล็อกกระโดดสูง",
				Value = false,
				Callback = function(v)
					Settings.jumpLock = v
					if not v then
						local hum = getHumanoid()
						if hum then hum.JumpPower = 50 end
					end
				end,
			})
			TabMove:Slider({
				Title = "พลังกระโดด",
				Value = { Min = 50, Max = 500, Default = 50 },
				Step = 5,
				Callback = function(v) Settings.jumpPower = v end,
			})
			TabMove:Toggle({
				Title = "Noclip ทะลุกำแพง (หรือกด N)",
				Value = false,
				Callback = function(v) setNoclip(v, true) end,
			})

			-- แท็บ อื่น ๆ (อัปเกรดป้ายแบบ Max หน่วง 10 วิ)
			TabOther:Toggle({
				Title = "⚡ อัปเกรดป้ายอัตโนมัติ (Max - หน่วง 10 วิ)",
				Value = false,
				Callback = function(v)
					Settings.autoUpgrades = v
					if v then
						task.spawn(autoUpgradesLoop)
						notifyUI("เปิดระบบอัปเกรดป้ายอัตโนมัติแล้ว (หน่วง 10 วินาที)")
					else
						notifyUI("ปิดระบบอัปเกรดป้ายอัตโนมัติแล้ว")
					end
				end,
			})
			TabOther:Toggle({
				Title = "♻️ Rebirth อัตโนมัติ",
				Value = Settings.autoRebirth,
				Callback = function(v) Settings.autoRebirth = v end,
			})
			TabOther:Toggle({
				Title = "🔁 Auto Rejoin",
				Value = Settings.autoRejoin,
				Callback = function(v) setAutoRejoin(v) end,
			})
			TabOther:Toggle({ Title = "Anti-AFK", Value = false, Callback = setAntiAfk })
			TabOther:Button({ Title = "🗑 ปิดสคริปต์ทั้งหมด", Callback = function() pcall(shutdown) end })
		end
	end
end

--═══════════════ อัปเดตสถานะ ═══════════════
local statusAcc = 0
bind(RunService.Heartbeat, function(dt)
	statusAcc += dt
	if statusAcc < 1 then return end
	statusAcc = 0
	if Window and statusPara then
		local counts = {}
		local list = scanEggs()
		local topLuck, topLuckName = 0, "-"
		for _, e in ipairs(list) do
			counts[e.rarity] = (counts[e.rarity] or 0) + 1
			if e.luck > topLuck then topLuck, topLuckName = e.luck, e.name end
		end
		local parts = {}
		for _, r in ipairs(RARITY_LIST) do
			if counts[r] then table.insert(parts, r:sub(1, 3) .. ":" .. counts[r]) end
		end
		local desc = ("ไข่ในแมป: %d (%s)\nLuck สูงสุดในแมป: %s ★%s"):format(#list, table.concat(parts, " "), topLuckName, fmtNum(topLuck))
		desc = desc .. ("\nตะกร้า: %d • รังว่าง: %s • เก็บไข่อัตโนมัติ: %s"):format(basketCount(), hasFreeNest() and "มี" or "ไม่มี!", Settings.autoFarm and "เปิด" or "ปิด")
		desc = desc .. ("\nเก็บแล้ว %d พลาด %d • ล่าสุด: %s"):format(farmStats.collected, farmStats.failed, farmStats.last)
		pcall(function() statusPara:SetDesc(desc) end)
	end
end)

--═══════════════ notifyUI / SHUTDOWN / API ═══════════════
notifyUI = function(text)
	pcall(function()
		if WindUILib then
			WindUILib:Notify({ Title = "RideHub", Content = text, Duration = 2.5, Icon = "info" })
		else
			StarterGui:SetCore("SendNotification", { Title = "RideHub", Text = text, Duration = 2.5 })
		end
	end)
end

shutdown = function()
	version += 1
	mainRunning = false
	if rejoinConn then
		rejoinConn:Disconnect()
		rejoinConn = nil
	end
	flyStop(true)
	setNoclip(false, true)
	setEsp(false)
	setAntiAfk(false)
	
	local hum = getHumanoid()
	if hum then
		hum.WalkSpeed = 16
		hum.JumpPower = 50
	end
	
	Settings.walkLock = false
	Settings.jumpLock = false
	Settings.autoUpgrades = false
	for _, conn in ipairs(connections) do conn:Disconnect() end
	table.clear(connections)
	if Window then pcall(function() Window:Destroy() end) end
end

getgenv().__RideHubHandle = { shutdown = shutdown }
getgenv().RideHub = {
	teleportHome = function() local cf = getHomeCF() if cf then teleportTo(cf) end end,
	setEsp = setEsp,
	visitStall = visitStall,
	hatchNow = hatchReadyEggs,
	feedNow = feedPets,
	isRunning = function() return controllerRunning end,
	fly = {
		toggle = flyToggle,
		start = flyStart,
		stop = flyStop,
		setSpeed = function(v) Settings.flySpeed = v end,
	},
	settings = Settings,
	stats = farmStats,
	shutdown = shutdown,
}

--═══════════════ เริ่มระบบ ═══════════════
print("[RideHub v3 Fixed] โหลดเรียบร้อย — อัปเกรดป้ายแบบ Max (หน่วง 10 วินาที)")
notifyUI("พร้อมใช้งาน — กด RightShift เพื่อเปิด/ปิดเมนู")

task.delay(1, function()
	if not controllerRunning then
		task.spawn(mainController)
	end
end)
