local e=game:GetService("Players")
local r=game:GetService("Workspace")
local y=game:GetService("RunService")
local u=game:GetService("TweenService")
local w=game:GetService("UserInputService")
local j=game:GetService("ReplicatedStorage")
local k=game:GetService("ProximityPromptService")
local a=game:GetService("HttpService")
local TeleportService=game:GetService("TeleportService")
local GuiService=game:GetService("GuiService")
local Lighting=game:GetService("Lighting")
local o=e.LocalPlayer
local Window=nil
local currentLang="EN"
local executorCheckCaller=typeof(checkcaller)=="function"and checkcaller or function()return false end
local safeNewCClosure=typeof(newcclosure)=="function"and newcclosure or function(fn)return fn end
local useNotifFn=typeof(notify)=="function"and notify or nil
local useReqFn=typeof(request)=="function"and request or( typeof(http_request)=="function"and http_request or nil )
local BRAND_NAME="Antraxdevz"
local BRAND_VER="v42.66"
local BRAND_TG="https://t.me/AntraxdevZ"
local BRAND_TG_TAG="@AntraxdevZ"
local PAL={
    bg=Color3.fromRGB(42,7,7),
    surface=Color3.fromRGB(58,11,11),
    surface2=Color3.fromRGB(74,15,15),
    surface3=Color3.fromRGB(92,20,20),
    line=Color3.fromRGB(122,32,32),
    lineSoft=Color3.fromRGB(90,24,24),
    text=Color3.fromRGB(255,233,214),
    textDim=Color3.fromRGB(217,169,138),
    textMute=Color3.fromRGB(168,122,96),
    orange=Color3.fromRGB(255,138,30),
    orange2=Color3.fromRGB(249,115,22),
    orange3=Color3.fromRGB(194,65,12),
    amber=Color3.fromRGB(245,158,11),
    rose=Color3.fromRGB(244,63,94),
    success=Color3.fromRGB(16,185,129),
    sky=Color3.fromRGB(14,165,233),
    violet=Color3.fromRGB(124,58,237),
    magenta=Color3.fromRGB(236,72,153),
    indigo=Color3.fromRGB(99,102,241),
    danger=Color3.fromRGB(239,68,68),
}
local function grad(inst,c1,c2,rot)
    local g=Instance.new("UIGradient")
    g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)})
    g.Rotation=rot or 0
    g.Parent=inst
    return g
end
local function openTelegram()
    local url=BRAND_TG
    local opened=false
    pcall(function()GuiService:OpenBrowserWindow(url)opened=true end)
    if not opened then pcall(function()if setclipboard then setclipboard(url)end end)end
end
local V=game:GetService("ProximityPromptService")
pcall(function()V.PromptButtonHoldBegan:Connect(function(e2)pcall(function()if typeof(fireproximityprompt)=="function"then fireproximityprompt(e2)end end)end)end)
local H=function(...)end
local t=function(...)end
local s=nil
pcall(function()s=require((j:WaitForChild("Client",5)):WaitForChild("EggState",5))end)
if not s then pcall(function()s=require(j.Client.EggState)end)end
local p=nil
pcall(function()p=require(((j:WaitForChild("Shared",5)):WaitForChild("Util",5)):WaitForChild("AssetItems",5))end)
if not p then pcall(function()p=require(j.Shared.Util.AssetItems)end)end
local B=nil
pcall(function()B=require((j:WaitForChild("Shared",5)):WaitForChild("Remotes",5))end)
if not B then pcall(function()B=require(j.Shared.Remotes)end)end
local function J(e2,r2)
    local y2=(j:FindFirstChild("Packages")and j.Packages:FindFirstChild("Networking"))or j:FindFirstChild("Network")or j
    local u2=y2:FindFirstChild(e2)or j:FindFirstChild(e2)
    if u2 then return u2 end
    local w2=y2:FindFirstChild(e2,true)or j:FindFirstChild(e2,true)
    if w2 then return w2 end
    if r2 then
        local e3=y2:FindFirstChild(r2)or j:FindFirstChild(r2)
        if e3 then return e3 end
        local u3=y2:FindFirstChild(r2,true)or j:FindFirstChild(r2,true)
        if u3 then return u3 end
    end
    local k2=string.match(e2,"[^/]+$")
    if k2 then
        local e4=y2:FindFirstChild(k2,true)or j:FindFirstChild(k2,true)
        if e4 then return e4 end
    end
    return nil
end
local K=J("RF/EggWorld/AskPlaceEgg","AskPlaceEgg")
local c=J("RF/EggWorld/AskLiveSnapshot","AskLiveSnapshot")
local v=J("RF/Homestead/AskState","RF/Plots/AskState")or J("AskState")
local i=J("RF/EggWorld/AskFieldEggCarry","AskFieldEggCarry")
local R=J("RF/EggWorld/AskFieldEggSnapshot","AskFieldEggSnapshot")or J("Eggs: RequestAreaEggSnapshot","RequestAreaEggSnapshot")
local g=J("RF/EggWorld/AskHatch","AskHatch")or J("Eggs: RequestHatchEgg")
local Q=J("RF/EggWorld/AskFinishHatch","AskFinishHatch")or J("Eggs: RequestCompleteHatchEgg")
local P=J("RE/GuardPatrol/ForestStrike","ForestStrike")or(B and(B.GuardPatrol and B.GuardPatrol.ForestStrike))
local N=J("SpeedTollOffer","RE/GuardPatrol/SpeedTollOffer")or(B and(B.GuardPatrol and B.GuardPatrol.SpeedTollOffer))
local U=J("RF/Treadmill/AskDoff","AskDoff")
local l=J("RF/Treadmill/AskDon","AskDon")or J("RF/Treadmill/AskMount","AskMount")
local D=J("RF/Treadmill/AskTierRaise","Treadmills: RequestUpgrade","AskTierRaise")
local C=J("RF/Trailwear/AskPurchase","Trailwear: RequestPurchase","AskPurchase")
local q=J("RF/Trailwear/AskChoose","Trailwear: RequestEquip","AskChoose")
local n=J("RF/Trailwear/AskDoff","Trailwear: RequestUnequip","AskDoff")
H(string.format("[Remotes] %s %s %s %s %s %s %s %s",tostring(i~=nil),tostring(R~=nil),tostring(K~=nil),tostring(g~=nil),tostring(Q~=nil),tostring(P~=nil),tostring(N~=nil),tostring(U~=nil)))
local f={["Light Dark"]=1300,["LightDark"]=1300,["Titan Temple"]=1100,["Cherry Blossom"]=1000,["Cosmic"]=900,["Prehistoric"]=800,["Abyss Ocean"]=700,["Volcano"]=600,["Snow"]=500,["Jungle"]=400,["Desert"]=300,["Lake"]=200,["Forest"]=100}
local M={"Light Dark","Titan Temple","Cherry Blossom","Cosmic","Prehistoric","Abyss Ocean","Volcano","Snow","Jungle","Desert","Lake","Forest"}
local I={["Light Dark"]=420,["LightDark"]=420,["Titan Temple"]=380,["Cherry Blossom"]=330,["Cosmic"]=280,["Prehistoric"]=240,["Abyss Ocean"]=200,["Volcano"]=180,["Snow"]=160,["Jungle"]=140,["Desert"]=130,["Lake"]=125,["Forest"]=125}
local L=-360
local E=525
local b=620
local A=130
local S=CFrame.new(4773.7587890625,70.392112731934,-315.73501586914)
local Z="Antraxdevz_FlightSpeed.txt"
local z="Antraxdevz_EggSelectConfig.json"
local KEYFILE="Antraxdevz_Keybinds.json"
local d={["Light Dark"]=Color3.fromRGB(168,85,247),["Titan Temple"]=Color3.fromRGB(245,158,11),["Cherry Blossom"]=Color3.fromRGB(236,72,153),["Cosmic"]=Color3.fromRGB(6,182,212),["Prehistoric"]=Color3.fromRGB(16,185,129),["Abyss Ocean"]=Color3.fromRGB(59,130,246),["Volcano"]=Color3.fromRGB(239,68,68),["Snow"]=Color3.fromRGB(147,197,253),["Jungle"]=Color3.fromRGB(34,197,94),["Desert"]=Color3.fromRGB(234,179,8),["Lake"]=Color3.fromRGB(20,184,166),["Forest"]=Color3.fromRGB(22,163,74)}
local X={"Divine","Eternal","Secret","Cosmic","Mythic","Legendary","Epic","Rare","Uncommon","Common"}
local G={["Divine"]=Color3.fromRGB(244,63,94),["Eternal"]=Color3.fromRGB(217,70,239),["Secret"]=Color3.fromRGB(249,115,22),["Cosmic"]=Color3.fromRGB(6,182,212),["Mythic"]=Color3.fromRGB(139,92,246),["Legendary"]=Color3.fromRGB(251,191,36),["Epic"]=Color3.fromRGB(168,85,247),["Rare"]=Color3.fromRGB(59,130,246),["Uncommon"]=Color3.fromRGB(34,197,94),["Common"]=Color3.fromRGB(148,163,184)}
local F={["Divine"]=6,["Eternal"]=5,["Secret"]=4,["Cosmic"]=3,["Mythic"]=2,["Legendary"]=1,["Epic"]=0.5,["Rare"]=0.3,["Uncommon"]=0.1,["Common"]=0}
local h
local function O()
    local e2=600
    pcall(function()
        local r2=false
        if isfile then r2=isfile(Z)elseif readfile then local e3,y2=pcall(readfile,Z)r2=e3 and(y2~=nil)end
        if r2 and readfile then
            local r3=readfile(Z)
            local u2=tonumber(r3)
            if u2 and(u2>=100 and u2<=1000)then e2=math.floor(u2)end
        end
    end)
    return e2
end
local function Y(e2)pcall(function()if writefile then writefile(Z,tostring(math.clamp(math.floor(tonumber(e2)or 600),100,1000)))end end)end
local DEF_KEYS={Tween=Enum.KeyCode.Z,Warp=Enum.KeyCode.X,Place=Enum.KeyCode.B,Unstuck=Enum.KeyCode.U,ESP=Enum.KeyCode.P,Watermark=Enum.KeyCode.K,Hop=Enum.KeyCode.H,Panic=Enum.KeyCode.Delete}
local function loadKeys()
    local out={}
    for k2,v2 in pairs(DEF_KEYS)do out[k2]=v2 end
    pcall(function()
        if readfile and a and isfile and isfile(KEYFILE)then
            local raw=readfile(KEYFILE)
            if raw and raw~=""then
                local dec=a:JSONDecode(raw)
                if type(dec)=="table"then
                    for k3,v3 in pairs(dec)do
                        if DEF_KEYS[k3]and type(v3)=="string"then
                            pcall(function()out[k3]=Enum.KeyCode[v3]end)
                        end
                    end
                end
            end
        end
    end)
    return out
end
local function saveKeys(tbl)
    pcall(function()
        if writefile and a then
            local out={}
            for k2,v2 in pairs(tbl)do out[k2]=tostring(v2):match("%.(%w+)$")or tostring(v2)end
            writefile(KEYFILE,a:JSONEncode(out))
        end
    end)
end
local function T()
    local e2=nil
    pcall(function()
        local r2=false
        if isfile then r2=isfile(z)elseif readfile then local e3,y2=pcall(readfile,z)r2=e3 and(y2~=nil)end
        if r2 and(readfile and a)then
            local r3=readfile(z)
            if r3 and r3~=""then
                local u2=a:JSONDecode(r3)
                if type(u2)=="table"then e2=u2 end
            end
        end
    end)
    local r2={["Light Dark"]=true,["Titan Temple"]=true,["Cherry Blossom"]=true,["Cosmic"]=false,["Prehistoric"]=false,["Abyss Ocean"]=false,["Volcano"]=false,["Snow"]=false,["Jungle"]=false,["Desert"]=false,["Lake"]=false,["Forest"]=false}
    local y2={["Divine"]=true,["Eternal"]=true,["Secret"]=true,["Cosmic"]=true,["Mythic"]=true,["Legendary"]=false,["Epic"]=false,["Rare"]=false,["Uncommon"]=false,["Common"]=false}
    if type(e2)~="table"then
        e2={selectedZones=r2,selectedRarities=y2,alwaysCollectSecretPlus=true,minRarityTier=2,autoTreadmill=true,autoUpgradeTreadmill=true,autoBuyTrails=true,hideNotEnoughMoney=true,performanceMode=false,disable3D=false,antiAFK=true,language="EN"}
    else
        if type(e2.selectedZones)~="table"then e2.selectedZones=r2 end
        if type(e2.selectedRarities)~="table"then e2.selectedRarities=y2
        else
            for _,w2 in ipairs(X)do
                if e2.selectedRarities[w2]==nil then e2.selectedRarities[w2]=(y2[w2]==true)end
            end
        end
        if e2.alwaysCollectSecretPlus==nil then e2.alwaysCollectSecretPlus=true end
        if e2.minRarityTier==nil then e2.minRarityTier=2 end
        if e2.autoTreadmill==nil then e2.autoTreadmill=true end
        if e2.autoUpgradeTreadmill==nil then e2.autoUpgradeTreadmill=true end
        if e2.autoBuyTrails==nil then e2.autoBuyTrails=true end
        if e2.hideNotEnoughMoney==nil then e2.hideNotEnoughMoney=true end
        if e2.performanceMode==nil then e2.performanceMode=false end
        if e2.disable3D==nil then e2.disable3D=false end
        if e2.antiAFK==nil then e2.antiAFK=true end
        if e2.language and(e2.language=="EN"or e2.language=="TH")then currentLang=e2.language end
    end
    return e2
end
local function x()
    pcall(function()
        if writefile and(a and h)then
            writefile(z,a:JSONEncode({selectedZones=h.selectedZones or{},selectedRarities=h.selectedRarities or{},alwaysCollectSecretPlus=(h.alwaysCollectSecretPlus~=false),minRarityTier=h.minRarityTier or 2,autoTreadmill=(h.autoTreadmill==true),autoUpgradeTreadmill=(h.autoUpgradeTreadmill==true),autoBuyTrails=(h.autoBuyTrails==true),hideNotEnoughMoney=(h.hideNotEnoughMoney==true),performanceMode=(h.performanceMode==true),disable3D=(h.disable3D==true),antiAFK=(h.antiAFK==true),language=currentLang or "EN"}))
        end
    end)
end
local W=T()
h={
    godmode=true,
    autoGlide=true,
    autoHatch=true,
    autoPlaceEvery5=false,
    batchStealCount=0,
    isBatchPlacing=false,
    isHatching=false,
    autoFarmLoop=false,
    pureTweenFarm=false,
    glidingToTarget=false,
    securingEgg=false,
    glideSpeed=O(),
    selectedZones=W.selectedZones,
    selectedRarities=W.selectedRarities,
    alwaysCollectSecretPlus=W.alwaysCollectSecretPlus,
    minRarityTier=W.minRarityTier,
    autoTreadmill=(W.autoTreadmill~=false),
    autoUpgradeTreadmill=(W.autoUpgradeTreadmill~=false),
    autoBuyTrails=(W.autoBuyTrails~=false),
    hideNotEnoughMoney=true,
    performanceMode=(W.performanceMode==true),
    disable3D=(W.disable3D==true),
    antiAFK=(W.antiAFK~=false),
    onTreadmill=false,
    lastTreadmillMount=0,
    laneZ=-360,
    swapped=false,
    teleporting=false,
    isReturning=false,
    delivering=false,
    holdingEggForGuard=false,
    currentTargetModel=nil,
    targetPosition=nil,
    stateTime=os.clock(),
    statusText="Ready",
    gui=nil,
    alive=true,
    plot=nil,
    pen=nil,
    origin=nil,
    tread=nil,
    eggESP=false,
    espMinRarity=4,
    espBillboard=true,
    espHighlight=true,
    watermark=true,
    masterKeybinds=true,
    keybinds=loadKeys(),
    noclip=false,
    infiniteJump=false,
    walkSpeed=16,
    jumpPower=50,
    autoSell=false,
    autoSellEvery=30,
    lastSell=0,
    autoRejoin=false,
    antiStaff=false,
    toasts=true,
    stats={stolen=0,hatched=0,placed=0,startedAt=os.clock(),cashStart=0,cashNow=0,hops=0,rejoins=0},
}
local m,e4,r4,y4,u4,w4,j4,k4,a4,o4,V4,H4,t4,s4,p4,B4,J4,K4,c4,v4,i4,R4,g4,Q4,P4,N4,U4,l4,D4,C4,q4,n4,f4,M4,I4,L4,E4,b4,A4,S4,Z4,z4,d4
local X4={}
local G4=0
local F4=nil
local h4
local O4=0
local Y4="NONE"
local T4
local x4=nil
local W4=nil
pcall(function()
    local e2=Lighting
    (e2:GetPropertyChangedSignal("ClockTime")):Connect(function()X4={}G4=0 end)
end)
pcall(function()
    local function e2(e3)
        if e3:IsA("RemoteEvent")then
            local y2=string.lower(e3.Name)
            if string.find(y2,"reset")or string.find(y2,"night")or string.find(y2,"spawn")or string.find(y2,"countdown")then
                pcall(function()e3.OnClientEvent:Connect(function()X4={}G4=0 end)end)
            end
        end
    end
    for _,u2 in ipairs(j:GetDescendants())do e2(u2)end
    j.DescendantAdded:Connect(e2)
end)
m=function(e2)
    if not e2 or not e2:IsA("Tool")then return false end
    local r2=string.lower(e2.Name)
    if string.find(r2,"sword")or string.find(r2,"radar")or string.find(r2,"basket")or string.find(r2,"punch")then return false end
    if e2:GetAttribute("EggUid")or e2:GetAttribute("UID")or string.find(r2,"egg")or e2:GetAttribute("Category")or e2:GetAttribute("ItemType")=="Egg"then return true end
    return false
end
e4=function()
    local e2=o.Character
    if e2 then
        for _,y2 in ipairs(e2:GetChildren())do
            if m(y2)then
                local e3=y2:GetAttribute("UID")or y2:GetAttribute("EggUid")
                return y2,e3 or y2.Name
            end
        end
    end
    return nil,nil
end
r4=function()
    local e2=o:FindFirstChild("Backpack")
    if e2 then
        for _,y2 in ipairs(e2:GetChildren())do
            if m(y2)then
                local e3=y2:GetAttribute("UID")or y2:GetAttribute("EggUid")
                return y2,e3 or y2.Name
            end
        end
    end
    return nil,nil
end
y4=function()
    local e2=0
    local r2=o:FindFirstChild("Backpack")
    if r2 then
        for _,y2 in ipairs(r2:GetChildren())do if m(y2)then e2=e2+1 end end
    end
    local y2=o.Character
    if y2 then
        for _,r3 in ipairs(y2:GetChildren())do if m(r3)then e2=e2+1 end end
    end
    return e2
end
u4=function(e2)
    if not e2 and not(h.pureTweenFarm or h.autoFarmLoop or h.teleporting)then return end
    local r2=o.Character
    local y2=r2 and r2:FindFirstChildOfClass("Humanoid")
    local u2=o:FindFirstChild("Backpack")
    if y2 then pcall(function()y2:UnequipTools()end)end
    if r2 and u2 then
        for _,r3 in ipairs(r2:GetChildren())do
            if r3:IsA("Tool")then pcall(function()r3.Parent=u2 end)end
        end
    end
end
w4=function(e2)
    if((h.pureTweenFarm or h.autoFarmLoop))and not h.holdingEggForGuard then
        local e3=e4()
        if e3 then pcall(u4)end
        return false
    end
    local r2,y2=e4()
    if r2 then
        if e2 then
            if y2==e2 or not y2 then return true end
        else
            return true
        end
    end
    local u2=o.Character
    local w2=u2 and u2:FindFirstChild("HumanoidRootPart")
    if w2 and w2.Position.X<=(E+15)then return false end
    if s and s.ReadFieldEggs then
        local rr,yy=pcall(s.ReadFieldEggs)
        if rr and(yy and yy.Records)then
            for _,yy2 in ipairs(yy.Records)do
                if((yy2.State=="Carried"or yy2.State==2))and((yy2.CarrierUserId==o.UserId or yy2.Carrier==o.UserId))then
                    if e2 then
                        if yy2.Uid==e2 then return true end
                    else
                        return true
                    end
                end
            end
        end
    end
    return false
end
j4=function(e2)
    local r2,y2=e4()
    if r2 then
        if not e2 or y2==e2 or not y2 then return true end
    end
    local u2=o:FindFirstChild("Backpack")
    if u2 then
        for _,y3 in ipairs(u2:GetChildren())do
            if m(y3)then
                local r3=y3:GetAttribute("UID")or y3:GetAttribute("EggUid")
                if not e2 or r3==e2 or y3.Name==tostring(e2)then return true end
            end
        end
    end
    if e2 and(s and s.ReadFieldEggs)then
        local rr,yy=pcall(s.ReadFieldEggs)
        if rr and(yy and yy.Records)then
            for _,yy2 in ipairs(yy.Records)do
                if yy2.Uid==e2 then
                    if(yy2.State=="Carried"or yy2.State==2)then
                        local cc=yy2.CarrierUserId or yy2.Carrier
                        if cc==o.UserId then return true end
                    end
                end
            end
        end
    end
    return false
end
local m4=false
local function ek()
    if m4 then return end
    local e2=R or j:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot",true)or j:FindFirstChild("AskFieldEggSnapshot",true)or j:FindFirstChild("Eggs: RequestAreaEggSnapshot",true)
    if not e2 or not e2:IsA("RemoteFunction")then return end
    m4=true
    task.spawn(function()
        local r2,y2=pcall(function()return e2:InvokeServer()end)
        if r2 and type(y2)=="table"then
            local e3={}
            local r3=y2.Records or y2
            if type(r3)=="table"then
                for r4b,y3 in pairs(r3)do
                    if type(y3)=="table"then
                        if not y3.Uid and type(r4b)=="string"then y3.Uid=r4b end
                        table.insert(e3,y3)
                    end
                end
            end
            if#e3>0 then F4=e3 G4=os.clock()end
        end
        m4=false
    end)
end
task.spawn(function()while true do task.wait(1.5)pcall(ek)end end)
function h4(e2)
    local y2=os.clock()
    if e2 or(y2-G4>=1.5)or not F4 then ek()end
    local u2=((F4 and#F4>0))and F4 or nil
    local w2=nil
    if s and s.ReadFieldEggs then
        local rr,yy=pcall(s.ReadFieldEggs)
        if rr and type(yy)=="table"then
            local e3={}
            local y3=yy.Records or yy
            if type(y3)=="table"then
                for r4c,y4c in pairs(y3)do
                    if type(y4c)=="table"then
                        if not y4c.Uid and type(r4c)=="string"then y4c.Uid=r4c end
                        table.insert(e3,y4c)
                    end
                end
            end
            if#e3>0 then w2=e3 end
        end
    end
    local j2={}
    local k2={}
    if u2 then
        for _,r4d in ipairs(u2)do
            if r4d.Uid then k2[r4d.Uid]=true table.insert(j2,r4d)end
        end
    end
    if w2 then
        for _,r4e in ipairs(w2)do
            if r4e.Uid and not k2[r4e.Uid]then k2[r4e.Uid]=true table.insert(j2,r4e)end
        end
    end
    local aa=r:FindFirstChild("AreaEggSlotsClient")
    if aa then
        for _,r4f in ipairs(aa:GetChildren())do
            local y3=r4f.Name
            if y3 and y3~=""then
                local e3=r4f:GetPivot()
                local u3=e3.Position
                if u3.X>=530 and not string.find(tostring(y3),"FirstArea")then
                    if not k2[y3]then
                        k2[y3]=true
                        local u4b=r4f:GetAttribute("Category")or r4f:GetAttribute("AssetCategory")or r4f.Name
                        local w3=r4f:GetAttribute("AreaId")or r4f:GetAttribute("Area")
                        local a2=r4f:GetAttribute("Rarity")or r4f:GetAttribute("RarityTier")
                        local V2=r4f:GetAttribute("RarityRank")or r4f:GetAttribute("Rank")
                        local H2=r4f:GetAttribute("Income")or r4f:GetAttribute("EarningRate")
                        local t2=r4f:GetAttribute("Scale")or r4f:GetAttribute("AssetScale")or 1
                        local s2=r4f:GetAttribute("Mutations")or r4f:GetAttribute("Mutation")
                        table.insert(j2,{Uid=y3,AssetCategory=u4b,AreaId=w3,Rarity=a2,Rank=V2,Income=H2,BoundsCFrame=e3,BottomCFrame=e3,CFrame=e3,State="Slot",AssetScale=t2,Mutations=s2,PhysicalModel=r4f})
                    else
                        for _,w3 in ipairs(j2)do
                            if w3.Uid==y3 then
                                w3.PhysicalModel=r4f
                                if not w3.BoundsCFrame then w3.BoundsCFrame=e3 end
                                if not w3.AreaId or w3.AreaId==""or w3.AreaId=="Unknown"then
                                    w3.AreaId=r4f:GetAttribute("AreaId")or r4f:GetAttribute("Area")
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return j2
end
k4=function(e2)
    if not e2 then return false,"NoUid"end
    local y2=h4(false)
    if y2 and#y2>0 then
        for _,y3 in ipairs(y2)do
            if y3.Uid==e2 then
                if(y3.State=="Carried"or y3.State==2)then
                    local cc=y3.CarrierUserId or y3.Carrier
                    if cc and cc==o.UserId then return true,"CarriedBySelf"
                    else return false,"CarriedByOther"end
                end
                if(y3.State=="Slot"or y3.State=="Dropped"or y3.State=="GuardCarried"or y3.State==1)then return true,"Available"end
                local cc=y3.CarrierUserId or y3.Carrier
                if cc then
                    if cc==o.UserId then return true,"CarriedBySelf"
                    else return false,"CarriedByOther"end
                end
                return true,"Available"
            end
        end
    end
    local u2=r:FindFirstChild("AreaEggSlotsClient")
    if u2 then
        for _,y3 in ipairs(u2:GetChildren())do
            if y3.Name==tostring(e2)or y3:GetAttribute("UID")==e2 or y3:GetAttribute("Uid")==e2 then return true,"Available"end
        end
    end
    return true,"Unchecked"
end
a4=function()
    local e2,r2=e4()
    if not r2 then local e3,y2=r4()r2=y2 end
    if not r2 then return false end
    if s and s.ReadFieldEggs then
        local rr,yy=pcall(s.ReadFieldEggs)
        if rr and(yy and yy.Records)then
            for _,yy2 in ipairs(yy.Records)do
                if yy2.Uid==r2 then
                    local cc=tostring(yy2.AreaId or"")
                    if cc=="Lake"or string.find(string.lower(cc),"lake")~=nil then return true end
                end
            end
        end
    end
    if string.find(string.lower(tostring(r2)),"lake")~=nil then return true end
    return false
end
o4=function()
    local e2,r2=e4()
    if not r2 then local e3,y2=r4()r2=y2 end
    if not r2 then return h.glideSpeed or 350 end
    if s and s.ReadFieldEggs then
        local rr,yy=pcall(s.ReadFieldEggs)
        if rr and(yy and yy.Records)then
            for _,yy2 in ipairs(yy.Records)do
                if yy2.Uid==r2 and yy2.AreaId then return I[yy2.AreaId]or h.glideSpeed or 350 end
            end
        end
    end
    return h.glideSpeed or 350
end
V4=function(e2,y2)
    y2=y2 or 8
    local u2=Instance.new("Part")
    u2.Name="SafetyFloorPad_AntiVoid"
    u2.Size=Vector3.new(28,1.5,28)
    u2.Position=e2-Vector3.new(0,3.2,0)
    u2.Anchored=true
    u2.Transparency=1
    u2.CanCollide=true
    u2.Parent=r
    task.delay(y2,function()pcall(function()u2:Destroy()end)end)
    return u2
end
H4=function(e2)
    if P and e2 then
        pcall(function()
            local r2=o.Character
            local y2=r2 and r2:FindFirstChild("HumanoidRootPart")
            local u2=y2 and(y2.CFrame*CFrame.new(0,0,-3))or CFrame.new()
            if P:IsA("RemoteFunction")then
                P:InvokeServer({EggUid=e2,GuardCFrame=u2})
            else
                P:FireServer({EggUid=e2,GuardCFrame=u2})
            end
        end)
    end
end
if typeof(hookmetamethod)=="function"and not _G._AntraxDevzAntiRagdollHooked then
    _G._AntraxDevzAntiRagdollHooked=true
    local e2
    e2=hookmetamethod(game,"__newindex",safeNewCClosure(function(r2,y2,u2)
        if not executorCheckCaller()and typeof(r2)=="Instance"then
            if r2:IsA("Motor6D")and(y2=="Enabled"and u2==false)then return nil end
            if r2:IsA("Humanoid")then
                if y2=="PlatformStand"and u2==true then return nil end
                if y2=="Sit"and(u2==true and((h.pureTweenFarm or h.autoFarmLoop or h.isReturning or h.glidingToTarget)))then return nil end
            end
        end
        return e2(r2,y2,u2)
    end))
end
S4=function(e2)
    e2=e2 or o.Character
    if not e2 then return end
    local r2=e2:FindFirstChild("HumanoidRootPart")
    local y2=e2:FindFirstChild("Torso")or e2:FindFirstChild("UpperTorso")or r2
    if not y2 then return end
    for _,r3 in ipairs(e2:GetDescendants())do
        if r3:IsA("BallSocketConstraint")or r3:IsA("HingeConstraint")or r3:IsA("NoCollisionConstraint")then
            pcall(function()r3:Destroy()end)
        end
    end
    for _,r3 in ipairs(e2:GetDescendants())do
        if r3:IsA("Motor6D")and(r3.Part0 and r3.Part1)then
            r3.Enabled=true
            local e3="RigidJointWeld_"..r3.Name
            local y3=r3.Part1:FindFirstChild(e3)
            if not y3 then
                local y4=Instance.new("WeldConstraint")
                y4.Name=e3
                y4.Part0=r3.Part0
                y4.Part1=r3.Part1
                y4.Parent=r3.Part1
            end
        end
    end
end
Z4=function(e2)
    if h and h.onTreadmill then return end
    e2=e2 or o.Character
    if not e2 then return end
    local r2=e2:FindFirstChildOfClass("Humanoid")
    if r2 then
        r2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
        r2:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
        r2:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
        r2:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
        r2:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        if r2.PlatformStand then r2.PlatformStand=false end
        if r2.Sit then r2.Sit=false end
    end
    for _,r3 in ipairs(e2:GetDescendants())do
        if r3:IsA("LocalScript")and((string.find(string.lower(r3.Name),"ragdoll")or string.find(string.lower(r3.Name),"fall")))then
            r3.Disabled=true
        end
    end
    S4(e2)
end
z4=function(e2)
    if not e2 then return end
    Z4(e2)
    for _,y2 in ipairs(e2:GetDescendants())do
        if y2:IsA("Motor6D")then
            (y2:GetPropertyChangedSignal("Enabled")):Connect(function()if not y2.Enabled then y2.Enabled=true end end)
        end
    end
    e2.DescendantAdded:Connect(function(y2)
        if y2:IsA("BallSocketConstraint")or y2:IsA("HingeConstraint")or y2:IsA("NoCollisionConstraint")then
            task.defer(function()pcall(function()y2:Destroy()end)Z4(e2)end)
        elseif y2:IsA("LocalScript")and((string.find(string.lower(y2.Name),"ragdoll")or string.find(string.lower(y2.Name),"fall")))then
            y2.Disabled=true
        end
    end)
    e2.ChildAdded:Connect(function(e3)
        if e3:IsA("Tool")and(((h.pureTweenFarm or h.autoFarmLoop))and not h.holdingEggForGuard)then
            task.defer(function()u4()end)
        end
    end)
end
C4=function()
    if h then h.onTreadmill=false end
    local e2=o.Character
    local r2=e2 and e2:FindFirstChildOfClass("Humanoid")
    local y2=e2 and e2:FindFirstChild("HumanoidRootPart")
    if U then
        task.spawn(function()pcall(function()U:InvokeServer()end)end)
    end
    if r2 then
        pcall(function()
            for _,y3 in ipairs(r2:GetPlayingAnimationTracks())do
                local u2=y3.Animation
                local w2=u2 and u2.AnimationId or""
                if string.find(w2,"10921259953")or string.find(string.lower(y3.Name),"treadmill")or string.find(string.lower(y3.Name),"run")then
                    y3:Stop(0)
                end
            end
            r2.PlatformStand=false
            r2.Sit=false
            r2:SetStateEnabled(Enum.HumanoidStateType.Running,true)
            r2:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
            r2:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local u2=o:FindFirstChild("PlayerGui")
    if u2 then
        local e3=u2:FindFirstChild("SpeedGainAnimation")
        if e3 then pcall(function()e3:Destroy()end)end
    end
    if y2 then
        y2.AssemblyLinearVelocity=Vector3.zero
        y2.AssemblyAngularVelocity=Vector3.zero
    end
    Z4(e2)
end
local rk=0
local yk=false
E4=function()
    local e2=o:FindFirstChild("PlayerGui")
    if not e2 then return false end
    local r2=false
    pcall(function()
        for _,u2 in ipairs(e2:GetChildren())do
            if u2:IsA("ScreenGui")and u2.Enabled then
                for _,w2 in ipairs(u2:GetDescendants())do
                    if((w2:IsA("TextButton")or w2:IsA("ImageButton")))and w2.Visible then
                        local e3=(w2:IsA("TextButton")and w2.Text)or w2.Name
                        local w3=string.lower(e3 or"")
                        if string.find(w3,"get out")or string.find(w3,"treadmill")or string.find(w3,"doff")or string.find(w3,"leave")or string.find(w3,"exit")then
                            if typeof(firesignal)=="function"and w2.Activated then
                                pcall(firesignal,w2.Activated)
                            elseif typeof(firesignal)=="function"and w2.MouseButton1Click then
                                pcall(firesignal,w2.MouseButton1Click)
                            elseif typeof(getconnections)=="function"then
                                local cc=getconnections(w2.MouseButton1Click)or getconnections(w2.Activated)or{}
                                for _,c2 in ipairs(cc)do pcall(function()c2:Fire()end)break end
                            end
                            r2=true
                            break
                        end
                    end
                end
                if r2 then break end
            end
        end
    end)
    return r2
end
L4=function()
    local e2=o.Character
    local r2=e2 and e2:FindFirstChild("HumanoidRootPart")
    if not r2 then return false end
    local y2=(typeof(I4)=="function")and I4()or nil
    if y2 then
        local e3=y2.Position+Vector3.new(0,1.8,0)
        local u2=((r2.Position-e3)).Magnitude
        if u2>6 then if h then h.onTreadmill=false end return false end
    else
        if r2.Position.X>535 then if h then h.onTreadmill=false end return false end
    end
    if h and h.onTreadmill then return true end
    local u2=e2 and e2:FindFirstChildOfClass("Humanoid")
    if u2 then
        for _,y3 in ipairs(u2:GetPlayingAnimationTracks())do
            local u3=y3.Animation
            local w2=u3 and u3.AnimationId or""
            local w3=string.lower(y3.Name or"")
            if string.find(w2,"10921259953")or string.find(w3,"treadmill")or string.find(w3,"run")then return true end
        end
    end
    local w2=o:FindFirstChild("PlayerGui")
    if w2 and w2:FindFirstChild("SpeedGainAnimation")then return true end
    return false
end
M4=function()
    if yk then return end
    if os.clock()-rk<0.8 then if h then h.onTreadmill=false end return end
    yk=true
    rk=os.clock()
    if h then h.onTreadmill=false end
    E4()
    if U then pcall(function()U:InvokeServer()end)end
    local e2=o.Character
    local r2=e2 and e2:FindFirstChildOfClass("Humanoid")
    local y2=e2 and e2:FindFirstChild("HumanoidRootPart")
    if r2 then
        pcall(function()
            for _,y3 in ipairs(r2:GetPlayingAnimationTracks())do
                local u2=y3.Animation
                local w2=u2 and u2.AnimationId or""
                local j2=string.lower(y3.Name or"")
                if string.find(w2,"10921259953")or string.find(j2,"treadmill")or string.find(j2,"run")then y3:Stop(0)end
            end
            r2.PlatformStand=false
            r2.Sit=false
            r2:SetStateEnabled(Enum.HumanoidStateType.Running,true)
            r2:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
            r2:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local u2=o:FindFirstChild("PlayerGui")
    if u2 then
        local e3=u2:FindFirstChild("SpeedGainAnimation")
        if e3 then pcall(function()e3:Destroy()end)end
    end
    if y2 then
        y2.AssemblyLinearVelocity=Vector3.zero
        y2.AssemblyAngularVelocity=Vector3.zero
    end
    Z4(e2)
    task.wait(0.15)
    yk=false
end
q4=M4
n4=function()
    pcall(function()
        local e2=r:FindFirstChild("Plots")
        if e2 then
            local r2=h and h.plot
            if not r2 and t4 then r2=select(1,t4())end
            for _,u2 in ipairs(e2:GetChildren())do
                local w2=(r2~=nil and u2==r2)
                local j2=u2:FindFirstChild("TreadmillBottom")
                if j2 and j2:IsA("BasePart")then
                    if w2 and(h and h.autoTreadmill)then j2.CanTouch=true j2.CanCollide=true
                    else j2.CanTouch=false j2.CanCollide=false end
                end
                local k2=u2:FindFirstChild("TreadmillUpgrade")
                if k2 then
                    for _,r3 in ipairs(k2:GetDescendants())do
                        if r3:IsA("BasePart")then
                            if w2 and(h and h.autoTreadmill)then r3.CanTouch=true
                            else r3.CanTouch=false r3.CanCollide=false end
                        end
                    end
                end
            end
        end
    end)
end
n4()
r.DescendantAdded:Connect(function(e2)
    pcall(function()
        local r2=(e2.Name=="TreadmillBottom"and e2:IsA("BasePart"))
        local y2=(e2.Name=="TreadmillUpgrade"and e2:IsA("Model"))
        if r2 or y2 then
            local y3=h and h.plot
            if not y3 and t4 then y3=select(1,t4())end
            local w2=y3 and e2:IsDescendantOf(y3)
            if w2 and(h and h.autoTreadmill)then
                if r2 then e2.CanTouch=true e2.CanCollide=true
                else for _,r3 in ipairs(e2:GetDescendants())do if r3:IsA("BasePart")then r3.CanTouch=true end end end
            else
                if r2 then e2.CanTouch=false e2.CanCollide=false
                else for _,r3 in ipairs(e2:GetDescendants())do if r3:IsA("BasePart")then r3.CanTouch=false r3.CanCollide=false end end end
            end
        end
    end)
end)
D4=function()
    h.onTreadmill=false
    h.teleporting=false
    h.glidingToTarget=false
    h.securingEgg=false
    h.isReturning=false
    h.delivering=false
    h.holdingEggForGuard=false
    h.currentTargetModel=nil
    h.targetPosition=nil
    h.stateTime=os.clock()
    local e2=o.Character
    local r2=e2 and e2:FindFirstChild("HumanoidRootPart")
    if r2 then pcall(function()r2.Anchored=false r2.AssemblyLinearVelocity=Vector3.zero r2.AssemblyAngularVelocity=Vector3.zero end)end
    pcall(function()if C4 then C4()end end)
    pcall(function()if Z4 and e2 then Z4(e2)end end)
    pcall(function()if u4 and((h.pureTweenFarm or h.autoFarmLoop))then u4()end end)
end
d4=function(e2,y2)
    if e2 then
        for _,r2 in ipairs(e2:GetDescendants())do
            if r2:IsA("ProximityPrompt")then
                pcall(function()r2.RequiresLineOfSight=false r2.HoldDuration=0 if typeof(fireproximityprompt)=="function"then fireproximityprompt(r2,0)fireproximityprompt(r2)end end)
            end
        end
    end
    local u2=r:FindFirstChild("AreaEggSlotsClient")
    if u2 and y2 then
        for _,r2 in ipairs(u2:GetChildren())do
            local u3=r2:FindFirstChildWhichIsA("BasePart")or r2.PrimaryPart
            if u3 and((u3.Position-y2)).Magnitude<=18 then
                for _,r3 in ipairs(r2:GetDescendants())do
                    if r3:IsA("ProximityPrompt")then
                        pcall(function()r3.RequiresLineOfSight=false r3.HoldDuration=0 if typeof(fireproximityprompt)=="function"then fireproximityprompt(r3,0)fireproximityprompt(r3)end end)
                    end
                end
            end
        end
    end
end
b4=function(e2)
    h.godmode=e2
    local r2=o.Character
    if not r2 then return end
    local y2=r2:FindFirstChildOfClass("Humanoid")
    if y2 then
        y2:SetStateEnabled(Enum.HumanoidStateType.Dead,not e2)
        if e2 and y2.Health<100 then y2.Health=100 end
    end
    for _,r3 in ipairs(r2:GetDescendants())do
        if r3:IsA("BasePart")then
            if e2 then r3.CanTouch=false r3.CanCollide=false end
        end
    end
    Z4(r2)
end
local function enableDesyncGodmode()b4(true)end
local function disableDesyncGodmode()b4(false)end
A4=function()
    local e2=o.Character
    local y2=e2 and e2:FindFirstChildOfClass("Humanoid")
    if not e2 or not y2 then return false end
    pcall(function()
        y2.BreakJointsOnDeath=false
        local w2=y2:Clone()
        w2.Parent=e2
        y2:Destroy()
        local j2=w2:FindFirstChildOfClass("Animator")
        if not j2 then j2=Instance.new("Animator")j2.Parent=w2 end
        r.CurrentCamera.CameraSubject=w2
        local k2=e2:FindFirstChild("Animate")
        if k2 and k2:IsA("LocalScript")then
            k2.Disabled=true
            task.defer(function()task.wait(0.05)k2.Disabled=false end)
        end
        w2:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
        w2:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
        w2:SetStateEnabled(Enum.HumanoidStateType.Running,true)
        w2:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
        w2.JumpPower=math.max(50,w2.JumpPower)
        w2.JumpHeight=math.max(7.2,w2.JumpHeight)
        w2:ChangeState(Enum.HumanoidStateType.Running)
    end)
    h.swapped=true
    if h.godmode then b4(true)end
    z4(e2)
    return true
end
t4=function()
    if h.plot and(h.plot.Parent and(h.pen and(h.origin and h.plotVerified)))then return h.plot,h.pen,h.origin end
    local e2=r:FindFirstChild("Plots")
    if not e2 then return nil,nil,nil end
    local y2=o.UserId
    local u2=o.Name
    local w2=o.DisplayName
    local j2=nil
    local k2=false
    if v then
        local rr,yy=pcall(function()return v:InvokeServer()end)
        if rr and(type(yy)=="table"and type(yy.OwnersBySlot)=="table")then
            for r3,w3 in pairs(yy.OwnersBySlot)do
                if w3==y2 or tostring(w3)==tostring(y2)or w3==u2 then
                    j2=e2:FindFirstChild(tostring(r3))
                    if j2 then k2=true break end
                end
            end
        end
    end
    if not j2 and c then
        local rr,yy=pcall(function()return c:InvokeServer()end)
        if rr and type(yy)=="table"then
            for r3,w3 in pairs(yy)do
                if type(w3)=="table"and((w3.OwnerUserId==y2 or tostring(w3.OwnerUserId)==tostring(y2)))then
                    local y3=w3.Slot or r3
                    j2=e2:FindFirstChild(tostring(y3))or e2:FindFirstChild(tostring(r3))
                    if j2 then k2=true break end
                end
            end
        end
    end
    if not j2 then
        for _,r3 in ipairs(e2:GetChildren())do
            local a2=r3:GetAttribute("Owner")or r3:GetAttribute("OwnerUserId")or r3:GetAttribute("UserId")or r3:GetAttribute("OwnerId")or r3:GetAttribute("Player")
            if a2 and((a2==y2 or tostring(a2)==tostring(y2)or a2==u2 or tostring(a2)==u2 or a2==w2))then j2=r3 k2=true break end
            for _,a2 in ipairs({"Owner","OwnerUserId","OwnerId","UserId","Player","PlayerName"})do
                local o2=r3:FindFirstChild(a2)
                if o2 and((o2.Value==y2 or tostring(o2.Value)==tostring(y2)or o2.Value==u2 or o2.Value==w2))then j2=r3 k2=true break end
            end
            if j2 then break end
        end
    end
    if not j2 then
        for _,r3 in ipairs(e2:GetChildren())do
            for _,y3 in ipairs(r3:GetDescendants())do
                if y3:IsA("TextLabel")and y3.Text~=""then
                    local e3=string.lower(y3.Text)
                    if string.find(e3,string.lower(u2),1,true)or(w2 and string.find(e3,string.lower(w2),1,true))then j2=r3 k2=true break end
                end
            end
            if j2 then break end
        end
    end
    if not j2 then
        local r3=o.Character
        local y3=r3 and r3:FindFirstChild("HumanoidRootPart")
        if y3 and y3.Position.X<=(E+30)then
            local r4b=nil
            local u3=999999
            for _,w3 in ipairs(e2:GetChildren())do
                local j3=w3:FindFirstChild("CenterPoint")or w3.PrimaryPart or w3:FindFirstChildWhichIsA("BasePart")
                if j3 then
                    local e3=((y3.Position-j3.Position)).Magnitude
                    if e3<u3 then u3=e3 r4b=w3 end
                end
            end
            if r4b and u3<160 then j2=r4b end
        end
    end
    if not j2 then j2=e2:FindFirstChild("2")or e2:FindFirstChild("1")or(e2:GetChildren())[1]end
    if not j2 then return nil,nil,nil end
    h.plot=j2
    h.plotVerified=k2
    h.origin=j2:FindFirstChild("CenterPoint")
    local a2=j2:FindFirstChild("ToUpdate")
    h.pen=(a2 and a2:FindFirstChild("PetArea"))or j2:FindFirstChild("PetArea")
    h.tread=j2:FindFirstChild("TreadmillBottom")
    if not h.pen and a2 then
        for _,r3 in ipairs(a2:GetChildren())do
            if r3:IsA("BasePart")and string.find(string.lower(r3.Name),"pet")then h.pen=r3 break end
        end
    end
    if not h.origin then h.origin=j2:FindFirstChild("CenterPoint")or h.pen or j2.PrimaryPart end
    if not h.pen then h.pen=h.origin end
    return h.plot,h.pen,h.origin
end
s4=function()
    local e2,r2,y2=t4()
    if r2 then return r2.Position+Vector3.new(0,3.5,0)end
    if y2 then return y2.Position+Vector3.new(0,3.5,0)end
    return Vector3.new(464.7,71.7,-304)
end
p4=function(e2)
    local r2,y2,u2=t4()
    if not y2 then return nil end
    local w2=y2.Size
    local j2=math.max(4,w2.X/2-5)
    local k2=math.max(4,w2.Z/2-5)
    for r3=1,60,1 do
        local u3=math.random(-math.floor(j2),math.floor(j2))
        local o2=math.random(-math.floor(k2),math.floor(k2))
        local V2=y2.CFrame*CFrame.new(u3,w2.Y/2+1,o2)
        local H2=true
        for _,r4 in ipairs(e2)do
            if((r4-V2.Position)).Magnitude<5.5 then H2=false break end
        end
        if H2 then return V2 end
    end
    return y2.CFrame*CFrame.new(math.random(-8,8),w2.Y/2+1,math.random(-8,8))
end
B4=function()
    local e2,r2,y2=t4()
    if not y2 or not K then return 0 end
    local u2=0
    local w2={}
    if c then
        local rr,yy=pcall(function()return c:InvokeServer()end)
        if rr and type(yy)=="table"then
            local e3={}
            for r3,y3 in pairs(yy)do
                if type(y3)=="table"and y3.OwnerUserId==o.UserId then
                    for r4,y4 in pairs(y3.Records or{})do e3[r4]=y4 end
                end
            end
            for e4b,r3 in pairs(e3)do
                if r3.Placement and r3.Placement.LocalCFrame then
                    w2[#w2+1]=((y2.CFrame*r3.Placement.LocalCFrame)).Position
                else
                    local r4b=p4(w2)
                    if r4b then
                        local j2=y2.CFrame:ToObjectSpace(r4b)
                        local k3,a2=pcall(function()return K:InvokeServer({Uid=e4b,LocalCFrame=j2})end)
                        if k3 and a2 then u2=u2+1 w2[#w2+1]=r4b.Position end
                    end
                end
            end
        end
    end
    local j2={}
    local k2=o.Character
    if k2 then
        for _,r3 in ipairs(k2:GetChildren())do if m(r3)then table.insert(j2,r3)end end
    end
    local a2=o:FindFirstChild("Backpack")
    if a2 then
        for _,r3 in ipairs(a2:GetChildren())do if m(r3)then table.insert(j2,r3)end end
    end
    for _,r3 in ipairs(j2)do
        if not h.alive then break end
        local j3=r3:GetAttribute("UID")or r3:GetAttribute("EggUid")or r3.Name
        local k3=p4(w2)
        if k3 then
            local e3=y2.CFrame:ToObjectSpace(k3)
            local r4b,a3=pcall(function()return K:InvokeServer({Uid=j3,LocalCFrame=e3})end)
            if r4b and a3~=false then
                u2=u2+1
                w2[#w2+1]=k3.Position
                H(string.format("[PlaceEgg] %s",tostring(j3)))
            end
            task.wait(0.04)
        end
    end
    h.stats.placed=h.stats.placed+u2
    return u2
end
J4=function(e2)
    if(not e2 and not h.autoHatch)or not g or not Q or not c then return 0 end
    if h.isHatching then return 0 end
    h.isHatching=true
    local rr,yy=pcall(function()return c:InvokeServer()end)
    if not rr or type(yy)~="table"then return 0 end
    local w2={}
    for r3,y3 in pairs(yy)do
        if type(y3)=="table"and y3.OwnerUserId==o.UserId then
            for r4,y4 in pairs(y3.Records or{})do w2[r4]=y4 end
        end
    end
    local j2={}
    local k2=r:GetServerTimeNow()
    for e3,r3 in pairs(w2)do
        if not h.alive then break end
        if r3.Placement then
            local y3=nil
            if s then
                local r4=s.IsReadyToHatch or s.IsLocalEggReady
                if r4 then
                    local u3,w3=pcall(r4,e3)
                    if u3 and type(w3)=="boolean"then y3=w3 end
                end
            end
            if y3==nil then
                local e4=r3.Placement.PlacedAt or r3.Placement.Time or 0
                local u3=30
                if p and(p.Assets and p.Assets[r3.AssetCategory])then
                    local e5=p.Assets[r3.AssetCategory]
                    u3=(e5 and(e5.Egg and e5.Egg.GrowthTime))or 30
                end
                local w3=u3/math.max(0.01,r3.GrowthSpeedMultiplier or 1)
                y3=(k2-e4)>=w3
            end
            if y3 then table.insert(j2,{uid=e3,category=r3.AssetCategory or "Egg"})end
        end
    end
    if#j2==0 then h.isHatching=false return 0 end
    H(string.format("[AutoHatch] %d ready",#j2))
    h.statusText=string.format("[Hatch] %d ready",#j2)
    local a2=0
    for _,r3 in ipairs(j2)do
        task.spawn(function()
            local e3,y3=pcall(function()
                if g:IsA("RemoteFunction")then return g:InvokeServer(r3.uid)
                else g:FireServer(r3.uid)return true end
            end)
            if e3 and y3~=false then
                task.wait(0.9)
                local e4,y4=pcall(function()
                    if Q:IsA("RemoteFunction")then return Q:InvokeServer(r3.uid)
                    else Q:FireServer(r3.uid)return true end
                end)
                if e4 and y4~=false then
                    a2=a2+1
                    h.hatched=((h.hatched or 0))+1
                    h.stats.hatched=h.stats.hatched+1
                    H(string.format("[AutoHatch] Hatched %s",r3.category))
                end
            end
        end)
        task.wait(0.04)
    end
    task.wait(0.95)
    h.isHatching=false
    H(string.format("[AutoHatch] Done %d",a2))
    return a2
end
i4=function()
    local e2={}
    local y2=r:FindFirstChild("__DEBRIS")
    if y2 then
        for _,r2 in ipairs(y2:GetChildren())do
            local u2=r2:FindFirstChild("Hitbox")
            if u2 and u2:IsA("BasePart")then table.insert(e2,u2)
            elseif r2:IsA("BasePart")and string.find(r2.Name:lower(),"hitbox")then table.insert(e2,r2)end
        end
    end
    local u2=r:FindFirstChild("BossArenaTeleport")
    if u2 then
        local r2=u2:FindFirstChild("Hitbox")or u2:FindFirstChildWhichIsA("BasePart")or(u2:IsA("BasePart")and u2)
        if r2 and r2:IsA("BasePart")then table.insert(e2,r2)end
    end
    return e2
end
g4=function(e2,r2,u2)
    local w2=o.Character
    local j2=w2 and w2:FindFirstChild("HumanoidRootPart")
    local k2=w2 and w2:FindFirstChildOfClass("Humanoid")
    if not j2 then return false end
    if k2 then k2.AutoRotate=false end
    local a2=s4()
    e2=math.max(100,e2 or h.glideSpeed or 600)
    local V2=h.laneZ or L
    h.isReturning=true
    h.stateTime=os.clock()
    V4(a2,20)
    j2.AssemblyLinearVelocity=Vector3.zero
    j2.AssemblyAngularVelocity=Vector3.zero
    local H2=o4()
    local t2=math.max(e2,H2)
    local s2=os.clock()+25
    while h.alive and(h.isReturning and os.clock()<s2)do
        if r2 and O4~=r2 then
            if k2 then k2.AutoRotate=true end
            h.isReturning=false
            return false
        end
        if not u2 and(not h.pureTweenFarm and not h.autoFarmLoop)then
            if k2 then k2.AutoRotate=true end
            h.isReturning=false
            return false
        end
        local e3=j2.Position
        local w3=((a2-e3)).Magnitude
        if(e3.X<=(a2.X+3)and math.abs(e3.Z-a2.Z)<=8)or w3<=6 then break end
        local o2=y.Heartbeat:Wait()
        e3=j2.Position
        local H3=t2
        if e3.X<=b and e3.X>E then
            local r3=math.clamp(((e3.X-E))/((b-E)),0,1)
            H3=A+(((t2-A))*r3)
        elseif e3.X<=E then H3=A end
        local s3=a2.Z
        if e3.X>540 then s3=V2 end
        local B2=math.sign(a2.X-e3.X)
        local J2=B2*math.min(math.abs(a2.X-e3.X),H3*o2)
        local K2=e3.X+J2
        local c2=math.sign(a2.Y-e3.Y)
        local v2=c2*math.min(math.abs(a2.Y-e3.Y),(H3*o2)*0.5)
        local i2=e3.Y+v2
        local R2=s3-e3.Z
        local gg=math.sign(R2)*math.min(math.abs(R2),H3*o2)
        local Q2=e3.Z+gg
        local P2=i4()
        local N2=false
        if e3.X>E then
            for _,r3 in ipairs(P2)do
                local y3=r3.Position
                local u3=((Vector3.new(K2,i2,Q2)-y3)).Magnitude
                local w4=math.abs(K2-y3.X)
                local j3=math.abs(Q2-y3.Z)
                if u3<22 or(w4<18 and j3<14)then
                    N2=true
                    local e4=y3.Y+16
                    if i2<e4 then i2=math.min(i2+((H3*o2)*1.5),e4)end
                    break
                end
            end
        end
        local U2=Vector3.new(K2,i2,Q2)
        local ll=((U2-e3)).Magnitude>0.05 and((U2-e3)).Unit or j2.CFrame.LookVector
        j2.CFrame=CFrame.lookAt(U2,U2+ll)
        j2.AssemblyLinearVelocity=Vector3.zero
        j2.AssemblyAngularVelocity=Vector3.zero
        if N2 then h.statusText=string.format("Tweening Home Z:%.0f [DODGE]",Q2)
        else h.statusText=string.format("Tweening Home %.0f | Z:%.0f | Spd:%.0f",w3,Q2,H3)end
    end
    j2.CFrame=CFrame.new(a2)
    j2.AssemblyLinearVelocity=Vector3.zero
    j2.AssemblyAngularVelocity=Vector3.zero
    if k2 then k2.AutoRotate=true end
    u4()
    h.isReturning=false
    h.delivering=false
    h.statusText="Arrived at Base"
    return true
end
v4=function(e2,r2,y2)
    local u2=o.Character
    local w2=u2 and u2:FindFirstChild("HumanoidRootPart")
    local j2=u2 and u2:FindFirstChildOfClass("Humanoid")
    if not w2 or not j2 then return end
    local k2=s4()
    local a2=((w2.Position-k2)).Magnitude
    if a2>8 then
        h.statusText="Tweening back to base..."
        g4(e2 or h.glideSpeed or 600,r2,true)
    end
    V4(k2,15)
    w2.CFrame=CFrame.new(k2)
    w2.AssemblyLinearVelocity=Vector3.zero
    h.statusText="Placing All Eggs..."
    local V2=os.clock()+3
    while y4()>0 and(os.clock()<V2 and h.alive)do B4()task.wait(0.06)end
    h.statusText="Hatching ready..."
    J4(true)
    u4()
    h.isReturning=false
    h.delivering=false
    h.currentTargetModel=nil
    h.targetPosition=nil
    local H2=y4()
    h.statusText=string.format("Placed & Hatched (Left:%d)",H2)
end
local uk=5
K4=function(e2)
    if h.isBatchPlacing then return end
    h.isBatchPlacing=true
    H(string.format("[AutoPlace] %d steals done (%s)",uk,tostring(e2)))
    local r2=O4
    h.pureTweenFarm=(e2=="TWEEN")
    h.autoFarmLoop=(e2=="WARP")
    local y2=o.Character
    local u2=y2 and y2:FindFirstChild("HumanoidRootPart")
    local w2=y2 and y2:FindFirstChildOfClass("Humanoid")
    local j2=s4()
    local k2=u2 and((u2.Position-j2)).Magnitude or 999
    if k2>8 then h.statusText="Tweening home..."g4(h.glideSpeed or 600,r2,true)end
    if u2 then
        V4(j2,20)
        u2.CFrame=CFrame.new(j2)
        u2.AssemblyLinearVelocity=Vector3.zero
        u2.AssemblyAngularVelocity=Vector3.zero
        if w2 then w2.AutoRotate=true end
    end
    task.spawn(function()pcall(B4)pcall(J4,true)end)
    u4()
    h.isReturning=false
    h.delivering=false
    h.glidingToTarget=false
    h.securingEgg=false
    h.teleporting=false
    h.currentTargetModel=nil
    h.targetPosition=nil
    for e3=5,1,-1 do
        if not h.alive then break end
        h.statusText=string.format("[AutoPlace] Resuming in %ds...",e3)
        task.wait(1)
    end
    h.isBatchPlacing=false
    if h.alive and O4==r2 then
        H(string.format("[AutoPlace] Done %s",e2))
        h.statusText=string.format("[AutoPlace] Resuming %s",e2)
        if e2=="TWEEN"then h.pureTweenFarm=true h.autoFarmLoop=false
        elseif e2=="WARP"then h.autoFarmLoop=true h.pureTweenFarm=false end
        Y4=e2
    end
end
c4=function(e2)
    if not h.autoPlaceEvery5 then return false end
    h.batchStealCount=((h.batchStealCount or 0))+1
    H(string.format("[AutoPlace] %d/%d",h.batchStealCount,uk))
    if h.batchStealCount>=uk then
        h.batchStealCount=0
        task.spawn(function()K4(e2)end)
        return true
    end
    return false
end
local function wk(e2,r2,u2,w2)
    local j2=o.Character
    local k2=j2 and j2:FindFirstChild("HumanoidRootPart")
    local a2=j2 and j2:FindFirstChildOfClass("Humanoid")
    if not k2 then return false end
    if a2 then a2.AutoRotate=false end
    r2=math.max(60,r2 or h.glideSpeed or 350)
    local V2=e2.Position
    V4(V2,14)
    pcall(function()o:RequestStreamAroundAsync(V2)end)
    k2.AssemblyLinearVelocity=Vector3.zero
    k2.AssemblyAngularVelocity=Vector3.zero
    local H2=h.laneZ or L
    h.glidingToTarget=true
    h.stateTime=os.clock()
    local t2=0
    local s2=os.clock()+15
    while h.alive and(h.glidingToTarget and os.clock()<s2)do
        if w2 and O4~=w2 then
            if a2 then a2.AutoRotate=true end
            h.glidingToTarget=false
            return false
        end
        if not h.pureTweenFarm and(not h.autoFarmLoop and not h.teleporting)then
            if a2 then a2.AutoRotate=true end
            h.glidingToTarget=false
            return false
        end
        local e3=k2.Position
        local j3=((V2-e3)).Magnitude
        local o2=((Vector2.new(e3.X,e3.Z)-Vector2.new(V2.X,V2.Z))).Magnitude
        local s3=math.abs(e3.Y-V2.Y)
        if j3<=6 or(o2<=3.5 and s3<=6)then break end
        local B2=y.Heartbeat:Wait()
        e3=k2.Position
        j3=((V2-e3)).Magnitude
        o2=((Vector2.new(e3.X,e3.Z)-Vector2.new(V2.X,V2.Z))).Magnitude
        local J2=math.abs(e3.X-V2.X)
        if u2 and(os.clock()-t2>0.5)then
            t2=os.clock()
            local e4,r3=k4(u2)
            if not e4 and r3=="CarriedByOther"then
                if a2 then a2.AutoRotate=true end
                h.glidingToTarget=false
                return false
            end
        end
        local K2=V2.Z
        if J2>40 then K2=H2 end
        local c2=math.sign(V2.X-e3.X)
        local v2=c2*math.min(math.abs(V2.X-e3.X),r2*B2)
        local i2=e3.X+v2
        local R2=(o2<=25)and 1.2 or 0.5
        local gg=math.sign(V2.Y-e3.Y)
        local Q2=gg*math.min(math.abs(V2.Y-e3.Y),(r2*B2)*R2)
        local P2=e3.Y+Q2
        local N2=K2-e3.Z
        local U2=math.sign(N2)*math.min(math.abs(N2),r2*B2)
        local ll=e3.Z+U2
        local D2=false
        if o2>25 then
            local e4=i4()
            for _,y3 in ipairs(e4)do
                local u3=y3.Position
                local w3=((Vector3.new(i2,P2,ll)-u3)).Magnitude
                local j4=math.abs(i2-u3.X)
                local k3=math.abs(ll-u3.Z)
                if w3<22 or(j4<18 and k3<14)then
                    D2=true
                    local e5=u3.Y+16
                    if P2<e5 then P2=math.min(P2+((r2*B2)*1.5),e5)end
                    break
                end
            end
        end
        local C2=Vector3.new(i2,P2,ll)
        local q2=((C2-e3)).Magnitude>0.05 and((C2-e3)).Unit or k2.CFrame.LookVector
        k2.CFrame=CFrame.lookAt(C2,C2+q2)
        k2.AssemblyLinearVelocity=Vector3.zero
        k2.AssemblyAngularVelocity=Vector3.zero
        if D2 then h.statusText=string.format("Gliding Out Z:%.0f [DODGE]",ll)
        else h.statusText=string.format("Gliding -> Egg %.0f | H:%.0f",j3,o2)end
    end
    k2.CFrame=e2*CFrame.new(0,0.4,0)
    k2.AssemblyLinearVelocity=Vector3.zero
    k2.AssemblyAngularVelocity=Vector3.zero
    if a2 then a2.AutoRotate=true end
    h.glidingToTarget=false
    return true
end
R4=function(e2,r2,y2,u2)
    local w2=o.Character
    local j2=w2 and w2:FindFirstChild("HumanoidRootPart")
    if j2 then
        local w3=j2.Position.X
        local a2=e2.Position.X
        if w3<=535 and a2>510 then
            local e3=CFrame.new(500,70,-364)
            local a3=((j2.Position-e3.Position)).Magnitude
            if a3>5 then
                h.statusText="Exiting Base -> Waypoint..."
                H(string.format("[AutoSteal] Leaving base X=%.1f -> waypoint dist=%.1f",w3,a3))
                local j3=wk(e3,r2,y2,u2)
                if not j3 then return false end
                task.wait(0.04)
            end
        end
    end
    return wk(e2,r2,y2,u2)
end
Q4=function(e2,r2)
    local u2=o.Character
    local w2=u2 and u2:FindFirstChild("HumanoidRootPart")
    local j2=u2 and u2:FindFirstChildOfClass("Humanoid")
    if not w2 then return false end
    if j2 then j2.AutoRotate=false end
    local k2=h.laneZ or L
    local a2=Vector3.new(E-10,70,k2)
    e2=math.max(100,e2 or h.glideSpeed or 350)
    h.isReturning=true
    h.stateTime=os.clock()
    V4(Vector3.new(E,70,k2),20)
    pcall(u4)
    w2.AssemblyLinearVelocity=Vector3.zero
    w2.AssemblyAngularVelocity=Vector3.zero
    local V2=o4()
    local H2=math.max(e2,V2)
    local s2=os.clock()+15
    while h.alive and(h.isReturning and os.clock()<s2)do
        if r2 and O4~=r2 then
            t("[Return] Aborted session switch")
            if j2 then j2.AutoRotate=true end
            h.isReturning=false
            return false
        end
        if not h.pureTweenFarm and not h.autoFarmLoop then
            t("[Return] Aborted farms disabled")
            if j2 then j2.AutoRotate=true end
            h.isReturning=false
            return false
        end
        local e3=w2.Position
        local o2=((a2-e3)).Magnitude
        if e3.X<=(E+10)or o2<=6 then u4()break end
        if u2 then
            for _,r3 in ipairs(u2:GetChildren())do
                if r3:IsA("Tool")then pcall(u4)break end
            end
        end
        local V3=y.Heartbeat:Wait()
        e3=w2.Position
        local s3=H2
        if e3.X<=b and e3.X>E then
            local r3=math.clamp(((e3.X-E))/((b-E)),0,1)
            s3=A+(((H2-A))*r3)
        elseif e3.X<=E then s3=A end
        local B2=math.sign(a2.X-e3.X)
        local J2=B2*math.min(math.abs(a2.X-e3.X),s3*V3)
        local K2=e3.X+J2
        local c2=math.sign(a2.Y-e3.Y)
        local v2=c2*math.min(math.abs(a2.Y-e3.Y),(s3*V3)*0.5)
        local i2=e3.Y+v2
        local R2=k2-e3.Z
        local gg=math.sign(R2)*math.min(math.abs(R2),s3*V3)
        local Q2=e3.Z+gg
        local P2=i4()
        local N2=false
        for _,r3 in ipairs(P2)do
            local y3=r3.Position
            local u3=((Vector3.new(K2,i2,Q2)-y3)).Magnitude
            local w3=math.abs(K2-y3.X)
            local j3=math.abs(Q2-y3.Z)
            if u3<22 or(w3<18 and j3<14)then
                N2=true
                local e4=y3.Y+16
                if i2<e4 then i2=math.min(i2+((s3*V3)*1.5),e4)end
                break
            end
        end
        local U2=Vector3.new(K2,i2,Q2)
        local ll=((U2-e3)).Magnitude>0.05 and((U2-e3)).Unit or w2.CFrame.LookVector
        w2.CFrame=CFrame.lookAt(U2,U2+ll)
        w2.AssemblyLinearVelocity=Vector3.zero
        w2.AssemblyAngularVelocity=Vector3.zero
        if N2 then h.statusText=string.format("Safe Line Z:%.0f [DODGE]",Q2)
        else h.statusText=string.format("Safe Line %.0f | X:%.0f",o2,e3.X)end
    end
    w2.CFrame=CFrame.new(E,math.max(68,w2.Position.Y),k2)
    w2.AssemblyLinearVelocity=Vector3.zero
    w2.AssemblyAngularVelocity=Vector3.zero
    if j2 then j2.AutoRotate=true end
    u4()
    h.isReturning=false
    h.delivering=false
    if h then h.onTreadmill=false end
    h.statusText="Arrived at Safe Line"
    return true
end
local function jk(e2)
    if not e2 then return nil end
    local r2=e2:FindFirstChild("TreadmillBottom")
    if r2 and r2:IsA("BasePart")then return r2 end
    r2=e2:FindFirstChild("TreadmillBottom",true)
    if r2 and r2:IsA("BasePart")then return r2 end
    local y2=e2:FindFirstChild("TreadmillUpgrade",true)
    if y2 then
        for _,r3 in ipairs({"TreadmillBottom","Belt","RunArea","Run","Platform","Pad","Floor","Base"})do
            local w2=y2:FindFirstChild(r3,true)
            if w2 and w2:IsA("BasePart")then return w2 end
        end
        local e3=nil
        local r4b=999999
        for _,w2 in ipairs(y2:GetDescendants())do
            if w2:IsA("BasePart")and(w2.Size.X>=1.2 and w2.Size.Z>=1.2)then
                if w2.Position.Y<r4b then r4b=w2.Position.Y e3=w2 end
            end
        end
        if e3 then return e3 end
        if y2.PrimaryPart then return y2.PrimaryPart end
        local w2=y2:FindFirstChildWhichIsA("BasePart",true)
        if w2 then return w2 end
    end
    for _,r3 in ipairs(e2:GetDescendants())do
        if r3:IsA("BasePart")and string.find(string.lower(r3.Name),"treadmill")then return r3 end
    end
    return nil
end
I4=function()
    local e2=t4()
    if h.tread and h.tread.Parent then return h.tread end
    local y2=nil
    if e2 then y2=jk(e2)end
    if not y2 then
        local w2=r:FindFirstChild("Plots")
        if w2 then
            local r2=string.lower(o.Name)
            local j2=o.DisplayName and string.lower(o.DisplayName)
            for _,w3 in ipairs(w2:GetChildren())do
                local k2=jk(w3)
                if k2 then
                    local e3=false
                    for _,y3 in ipairs(w3:GetDescendants())do
                        if y3:IsA("TextLabel")and y3.Text~=""then
                            local y4=string.lower(y3.Text)
                            if string.find(y4,r2,1,true)or(j2 and string.find(y4,j2,1,true))then e3=true break end
                        end
                    end
                    if e3 then h.plot=w3 h.plotVerified=true y2=k2 break end
                end
            end
            if not y2 and e2 then y2=jk(e2)end
        end
    end
    h.tread=y2
    return y2
end
f4=function(e2)
    local r2=o.Character
    local u2=r2 and r2:FindFirstChild("HumanoidRootPart")
    local w2=r2 and r2:FindFirstChildOfClass("Humanoid")
    if not u2 or not w2 then return false end
    if w2.PlatformStand then w2.PlatformStand=false end
    if w2.Sit then w2.Sit=false end
    w2:ChangeState(Enum.HumanoidStateType.Running)
    local j2=t4()
    local k2=I4()
    if not k2 then t("[AutoTreadmill] Treadmill part not found")return false end
    pcall(function()
        for _,r3 in ipairs(r2:GetChildren())do
            if r3:IsA("BasePart")and r3.Name~="HumanoidRootPart"then r3.CanCollide=false end
        end
    end)
    pcall(function()
        k2.CanTouch=true
        k2.CanCollide=true
        local e3=j2 and j2:FindFirstChild("TreadmillUpgrade",true)
        if e3 then
            for _,y3 in ipairs(e3:GetDescendants())do
                if y3:IsA("BasePart")then y3.CanTouch=true y3.CanCollide=true end
            end
        end
        if k2.Parent and k2.Parent:IsA("Model")then
            for _,y3 in ipairs(k2.Parent:GetDescendants())do
                if y3:IsA("BasePart")then y3.CanTouch=true y3.CanCollide=true end
            end
        end
    end)
    local a2=k2.Position+Vector3.new(0,1.8,0)
    if u2.Position.X>535 then
        h.statusText="[AutoTreadmill] Returning along highway..."
        Q4(h.glideSpeed,e2)
        if e2 and O4~=e2 then return false end
        if u2.Position.X>535 then
            if u2.Position.X<=560 then u2.CFrame=CFrame.new(E,70,h.laneZ or L)
            else return false end
        end
    end
    if e2 and O4~=e2 then return false end
    local V2=((Vector2.new(u2.Position.X,u2.Position.Z)-Vector2.new(a2.X,a2.Z))).Magnitude
    if V2>4 then
        h.statusText="[AutoTreadmill] Elevated flyover..."
        local r3=math.max(250,h.glideSpeed or 400)
        local j3=os.clock()
        while h.alive and(((Vector2.new(u2.Position.X,u2.Position.Z)-Vector2.new(a2.X,a2.Z))).Magnitude>4 and(os.clock()-j3<4))do
            if e2 and O4~=e2 then return false end
            local j4=y.Heartbeat:Wait()
            local k3=u2.Position
            local o2=Vector3.new(a2.X,70,a2.Z)
            local V3=(o2-k3)
            local H2=V3.Unit*math.min(V3.Magnitude,r3*j4)
            local t2=k3+H2
            u2.CFrame=CFrame.lookAt(t2,t2+((V3.Magnitude>0.05 and V3.Unit or u2.CFrame.LookVector)))
            u2.AssemblyLinearVelocity=Vector3.zero
            u2.AssemblyAngularVelocity=Vector3.zero
            if w2 then
                if w2.PlatformStand then w2.PlatformStand=false end
                if w2.Sit then w2.Sit=false end
                w2:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
    if e2 and O4~=e2 then return false end
    local H2=os.clock()
    while h.alive and(math.abs(u2.Position.Y-a2.Y)>2 and(os.clock()-H2<1.5))do
        if e2 and O4~=e2 then return false end
        local r3=y.Heartbeat:Wait()
        local w3=u2.Position
        local j3=a2
        local k3=(j3-w3)
        local o2=k3.Unit*math.min(k3.Magnitude,150*r3)
        local V3=w3+o2
        u2.CFrame=CFrame.new(V3)
        u2.AssemblyLinearVelocity=Vector3.zero
        u2.AssemblyAngularVelocity=Vector3.zero
    end
    u2.CFrame=CFrame.new(a2)
    u2.AssemblyLinearVelocity=Vector3.zero
    u2.AssemblyAngularVelocity=Vector3.zero
    local s2=((u2.Position-a2)).Magnitude
    if s2<=6 then
        pcall(function()if typeof(firetouchinterest)=="function"then firetouchinterest(u2,k2,0)task.wait(0.02)firetouchinterest(u2,k2,1)end end)
        pcall(function()
            for _,r3 in ipairs(k2:GetDescendants())do
                if r3:IsA("ProximityPrompt")and r3.Enabled then
                    if typeof(fireproximityprompt)=="function"then fireproximityprompt(r3)end
                end
            end
            if k2.Parent then
                for _,r3 in ipairs(k2.Parent:GetDescendants())do
                    if r3:IsA("ProximityPrompt")and r3.Enabled then
                        if typeof(fireproximityprompt)=="function"then fireproximityprompt(r3)end
                    end
                end
            end
        end)
        if l then pcall(function()l:InvokeServer()end)end
        h.onTreadmill=true
        h.lastTreadmillMount=os.clock()
        h.statusText="[AutoTreadmill] Running..."
        return true
    else
        h.onTreadmill=false
        t(string.format("[AutoTreadmill] dist=%.1f retry",s2))
        return false
    end
end
local function kk()
    if not h or not h.hideNotEnoughMoney then return end
    local e2=o:FindFirstChild("PlayerGui")
    if not e2 then return end
    pcall(function()
        for _,y2 in ipairs(e2:GetDescendants())do
            if y2:IsA("TextLabel")and y2.Visible then
                local e3=(tostring(y2.Text or"")):lower()
                if e3:find("not enough money")or e3:find("not enough cash")or(e3:find("not enough")and((e3:find("money")or e3:find("cash")or e3:find("coin")or e3:find("fund"))))then
                    y2.Visible=false
                    y2.TextTransparency=1
                    y2.TextStrokeTransparency=1
                    local e4=y2.Parent
                    if e4 and(((e4:IsA("Frame")or e4:IsA("CanvasGroup")))and#e4:GetChildren()<=3)then e4.Visible=false end
                end
            end
        end
    end)
end
local function ak()
    local e2=o:FindFirstChild("PlayerGui")
    if not e2 then return end
    local function r2(e3)
        if e3:IsA("TextLabel")then
            local function y2()
                if not h or not h.hideNotEnoughMoney then return end
                local y3=(tostring(e3.Text or"")):lower()
                if y3:find("not enough money")or y3:find("not enough cash")or(y3:find("not enough")and((y3:find("money")or y3:find("cash")or y3:find("coin")or y3:find("fund"))))then
                    e3.Visible=false
                    e3.TextTransparency=1
                    e3.TextStrokeTransparency=1
                    local r3=e3.Parent
                    if r3 and(((r3:IsA("Frame")or r3:IsA("CanvasGroup")))and#r3:GetChildren()<=3)then r3.Visible=false end
                end
            end
            y2()
            (e3:GetPropertyChangedSignal("Text")):Connect(y2)
            (e3:GetPropertyChangedSignal("Visible")):Connect(function()if e3.Visible then y2()end end)
        end
    end
    pcall(function()
        for _,y2 in ipairs(e2:GetDescendants())do task.spawn(r2,y2)end
        e2.DescendantAdded:Connect(r2)
    end)
    task.spawn(function()
        while h and h.alive do
            if h.hideNotEnoughMoney then kk()end
            task.wait(0.25)
        end
    end)
end
task.spawn(ak)
local function ok(e2)
    if not e2 then return 0 end
    local r2=(((tostring(e2)):gsub("[$,]","")):gsub("%s+","")):lower()
    local y2=r2:match("[%d%.]+")
    if not y2 then return 0 end
    local u2=tonumber(y2)
    if not u2 then return 0 end
    if r2:find("sp")then return u2*999999999999999983222784
    elseif r2:find("sx")then return u2*1000000000000000000000
    elseif r2:find("qi")then return u2*1000000000000000000
    elseif r2:find("qa")or r2:find("q")then return u2*1000000000000000
    elseif r2:find("t")then return u2*1000000000000
    elseif r2:find("b")then return u2*1000000000
    elseif r2:find("m")then return u2*1000000
    elseif r2:find("k")then return u2*1000 end
    return u2
end
local function Vk()
    local e2=o:FindFirstChild("leaderstats")
    if e2 then
        for _,r2 in ipairs({"Money","Cash","Coins","Currency"})do
            local u2=e2:FindFirstChild(r2)
            if u2 then
                local e3=tonumber(u2.Value)or ok(u2.Value)
                if e3 and e3>0 then return e3 end
            end
        end
    end
    local r2=o:FindFirstChild("PlayerGui")
    if r2 then
        local e3=r2:FindFirstChild("HUD")or r2:FindFirstChild("GameHUD")or r2:FindFirstChild("MainHUD")or r2:FindFirstChild("Main")
        if e3 then
            for _,r3 in ipairs(e3:GetDescendants())do
                if r3:IsA("TextLabel")and r3.Visible then
                    local e4=r3.Name:lower()
                    if e4=="money"or e4=="cash"or e4=="coins"or e4=="currency"or e4=="value"then
                        local e5=ok(r3.Text)
                        if e5 and e5>0 then return e5 end
                    end
                end
            end
        end
    end
    return 0
end
local function Hk()
    local e2=h.plot or(t4 and t4())
    if not e2 then return nil end
    local r2=e2:FindFirstChild("TreadmillUpgrade",true)
    if not r2 then return nil end
    local y2=nil
    for _,r3 in ipairs(r2:GetDescendants())do
        if r3:IsA("TextLabel")or r3:IsA("TextButton")then
            local e3=tostring(r3.Text or"")
            local w2=e3:match("%$([%d%.,]+%s*[kKmMbBtTqQ]?[aA]?)")
            if w2 then
                local e4=ok(w2)
                if e4 and e4>0 then if not y2 or e4>y2 then y2=e4 end end
            end
        end
    end
    return y2
end
local tk=0
local sk=10
local function pk()
    if not h.autoUpgradeTreadmill then return end
    if os.clock()-tk<sk then return end
    local e2=h.plot or(t4 and t4())
    if not e2 then return end
    local r2=e2:FindFirstChild("TreadmillUpgrade",true)
    if not r2 then return end
    local y2=Vk()
    local u2=Hk()
    if u2 and(u2>0 and y2<u2)then return end
    tk=os.clock()
    if D then pcall(function()D:InvokeServer()end)end
    local w2=o.Character
    local j2=w2 and w2:FindFirstChild("HumanoidRootPart")
    pcall(function()
        for _,r3 in ipairs(r2:GetDescendants())do
            if r3:IsA("ProximityPrompt")and r3.Enabled then
                if typeof(fireproximityprompt)=="function"then fireproximityprompt(r3,0)fireproximityprompt(r3)end
            end
            if r3:IsA("GuiButton")and r3.Visible then
                local r4b=(r3:IsA("TextButton")and r3.Text)or r3.Name
                local u3=string.lower(r4b)
                if not string.find(u3,"robux")and(not string.find(u3,"r%$")and((string.find(u3,"%$")or string.find(u3,"upgrade")or string.find(u3,"cash")or(r3.BackgroundColor3 and r3.BackgroundColor3.G>r3.BackgroundColor3.R))))then
                    if typeof(firesignal)=="function"and r3.Activated then firesignal(r3.Activated)
                    elseif typeof(firesignal)=="function"and r3.MouseButton1Click then firesignal(r3.MouseButton1Click)end
                end
            end
            if r3:IsA("BasePart")and(r3.Name:find("Pad")and j2)then
                if((j2.Position-r3.Position)).Magnitude<10 then
                    if typeof(firetouchinterest)=="function"then firetouchinterest(j2,r3,0)task.wait(0.02)firetouchinterest(j2,r3,1)end
                end
            end
        end
    end)
end
local Bk={{id="GreyTrail",base="Grey",name="Grey Trail",price=100,mult=1.5},{id="GreenTrail",base="Green",name="Green Trail",price=5000,mult=2},{id="BlueTrail",base="Blue",name="Blue Trail",price=75000,mult=2.5},{id="PurpleTrail",base="Purple",name="Purple Trail",price=1500000,mult=3},{id="GoldenTrail",base="Golden",name="Golden Trail",price=1500000,mult=3.5},{id="RedTrail",base="Red",name="Red Trail",price=750000000,mult=4},{id="GalaxyTrail",base="Galaxy",name="Galaxy Trail",price=20000000000,mult=5},{id="SecretTrail",base="Secret",name="Secret Trail",price=500000000000,mult=6},{id="EternalTrail",base="Eternal",name="Eternal Trail",price=12500000000000,mult=10},{id="DivineTrail",base="Divine",name="Divine Trail",price=300000000000000,mult=14},{id="MoonbloomTrail",base="Moonbloom",name="Moonbloom Trail",price=5000000000000000,mult=20}}
local function Jk()return Bk end
local function Kk()
    local e2={}
    local r2=o:FindFirstChild("PlayerGui")
    local y2=r2 and((r2:FindFirstChild("TrailShop")or r2:FindFirstChild("TrailShop",true)))
    local u2=y2 and y2:FindFirstChild("ScrollingFrame",true)
    if u2 then
        pcall(function()
            for _,y3 in ipairs(u2:GetChildren())do
                if y3:IsA("GuiObject")and(not y3:IsA("UIListLayout")and not y3:IsA("UIPadding"))then
                    local y4=y3.Name
                    for _,w2 in ipairs(y3:GetDescendants())do
                        if w2:IsA("GuiButton")or w2:IsA("TextButton")then
                            local w3=(w2:IsA("TextButton")and w2.Text:lower())or w2.Name:lower()
                            if w3:find("unequip")or(w3:find("equip")and not w3:find("unequip"))then
                                e2[y4]=true
                                e2[y4:lower()]=true
                                local u3=y4:gsub("Trail","")
                                e2[u3]=true
                                e2[u3:lower()]=true
                            end
                        end
                    end
                end
            end
        end)
    end
    return e2
end
local function ck(e2)
    if not e2 then return false end
    pcall(function()
        if typeof(firebutton1click)=="function"then firebutton1click(e2)
        elseif typeof(firesignal)=="function"and e2.Activated then firesignal(e2.Activated)
        elseif typeof(firesignal)=="function"and e2.MouseButton1Click then firesignal(e2.MouseButton1Click)end
    end)
    return true
end
local function vk()
    local e2=Jk()
    local r2=Kk()
    local y2=o:FindFirstChild("PlayerGui")
    local u2=y2 and((y2:FindFirstChild("TrailShop")or y2:FindFirstChild("TrailShop",true)))
    local w2=u2 and u2:FindFirstChild("ScrollingFrame",true)
    if w2 then
        for r3=#e2,1,-1 do
            local y3=e2[r3]
            local u3=w2:FindFirstChild(y3.id)or w2:FindFirstChild(y3.base)or w2:FindFirstChild(y3.name)
            if not u3 then
                for _,r4 in ipairs(w2:GetChildren())do
                    if r4:IsA("GuiObject")and((r4.Name:lower()==y3.id:lower()or r4.Name:lower()==y3.base:lower()or r4.Name:lower()==y3.name:lower()))then u3=r4 break end
                end
            end
            if u3 then
                local e3=false
                local r4b=nil
                for _,y4 in ipairs(u3:GetDescendants())do
                    if y4:IsA("GuiButton")or y4:IsA("TextButton")then
                        local y5=(y4:IsA("TextButton")and y4.Text:lower())or y4.Name:lower()
                        if y5:find("unequip")then e3=true break
                        elseif y5:find("equip")and not y5:find("unequip")then r4b=y4 end
                    end
                end
                if e3 then return true end
                if r4b then
                    ck(r4b)
                    if q then pcall(function()q:InvokeServer(y3.id)end)end
                    task.wait(0.2)
                    return true
                end
            end
        end
    end
    if q then
        for y3=#e2,1,-1 do
            local u3=e2[y3]
            local w3=r2[u3.id]or r2[u3.id:lower()]or r2[u3.base]or r2[u3.base:lower()]or r2[u3.name]or r2[u3.name:lower()]
            if w3 then pcall(function()q:InvokeServer(u3.id)end)return true end
        end
    end
    return false
end
local ik=0
local Rk=8
local function gk()
    if not h.autoBuyTrails then return end
    vk()
    if os.clock()-ik<Rk then return end
    local e2=Vk()
    if e2<=0 then return end
    local r2=Jk()
    local y2=Kk()
    local u2=o:FindFirstChild("PlayerGui")
    local w2=u2 and((u2:FindFirstChild("TrailShop")or u2:FindFirstChild("TrailShop",true)))
    local j2=w2 and w2:FindFirstChild("ScrollingFrame",true)
    for u3=#r2,1,-1 do
        local w3=r2[u3]
        local a2=y2[w3.id]or y2[w3.id:lower()]or y2[w3.base]or y2[w3.base:lower()]or y2[w3.name]or y2[w3.name:lower()]
        if not a2 and(w3.price>0 and e2>=w3.price)then
            ik=os.clock()
            local e3=false
            if j2 then
                local r3=j2:FindFirstChild(w3.id)or j2:FindFirstChild(w3.base)or j2:FindFirstChild(w3.name)
                if not r3 then
                    for _,y3 in ipairs(j2:GetChildren())do
                        if y3:IsA("GuiObject")and((y3.Name:lower()==w3.id:lower()or y3.Name:lower()==w3.base:lower()or y3.Name:lower()==w3.name:lower()))then r3=y3 break end
                    end
                end
                if r3 then
                    for _,r4 in ipairs(r3:GetDescendants())do
                        if r4:IsA("GuiButton")or r4:IsA("TextButton")then
                            local r5=(r4:IsA("TextButton")and r4.Text:lower())or r4.Name:lower()
                            if not r5:find("robux")and(not r5:find("r%$")and(not r5:find("unequip")and not r5:find("equip")))then
                                if r5:find("%$")or r5:find("buy")then ck(r4)e3=true break end
                            end
                        end
                    end
                end
            end
            if C then pcall(function()C:InvokeServer(w3.id)end)e3=true end
            if e3 then task.wait(0.3)vk()break end
        end
    end
end
P4=function()
    local e2=o.Character
    local y2=e2 and e2:FindFirstChild("HumanoidRootPart")
    if not y2 then return nil end
    local u2={}
    local w2=r:FindFirstChild("AreaEggSlotsClient")
    local j2=h4(false)
    if j2 and#j2>0 then
        for _,r2 in ipairs(j2)do
            local w3=(r2.State=="Slot"or r2.State=="Dropped"or r2.State==1)
            local j3=(r2.AreaId=="Lake")or(string.find(string.lower(tostring(r2.AreaId)),"lake")~=nil)or(string.find(string.lower(tostring(r2.Uid)),"lake")~=nil)
            local k2=X4[r2.Uid]and(os.clock()<X4[r2.Uid])
            if w3 and(j3 and(r2.BoundsCFrame and not k2))then
                local e3=r2.BoundsCFrame.Position
                local w4=((y2.Position-e3)).Magnitude
                table.insert(u2,{Uid=r2.Uid,Model=nil,Hitbox=nil,CFrame=r2.BoundsCFrame,Position=e3,Distance=w4,Area="Lake"})
            end
        end
    end
    if#u2==0 and(j2 and#j2>0)then
        for _,r2 in ipairs(j2)do
            local w3=(r2.State=="Slot"or r2.State=="Dropped"or r2.State==1)
            local j3=r2.BoundsCFrame and r2.BoundsCFrame.Position
            local k2=j3 and((j3.X>=545 and j3.X<850))
            local o2=X4[r2.Uid]and(os.clock()<X4[r2.Uid])
            if w3 and(k2 and not o2)then
                table.insert(u2,{Uid=r2.Uid,Model=nil,Hitbox=nil,CFrame=r2.BoundsCFrame,Position=j3,Distance=((y2.Position-j3)).Magnitude,Area=r2.AreaId or "Field"})
            end
        end
    end
    if#u2==0 then return nil end
    table.sort(u2,function(e3,r2)return e3.Distance<r2.Distance end)
    local k2=u2[1]
    if k2 and w2 then
        for _,r2 in ipairs(w2:GetChildren())do
            local y3=r2:FindFirstChildWhichIsA("BasePart")or r2.PrimaryPart
            if y3 and((y3.Position-k2.Position)).Magnitude<=8 then k2.Model=r2 break end
        end
    end
    return k2
end
local Qk=nil
local Pk=nil
local Nk=350
local function Uk()
    local e2=r:FindFirstChild("__OBJECTS")or r:FindFirstChild("Objects")
    local y2=e2 and((e2:FindFirstChild("Areas")or e2:FindFirstChild("Area")))
    local u2=y2 and((y2:FindFirstChild("GuardAreas")or y2:FindFirstChild("Guards")))
    if u2 then
        local e3=u2:FindFirstChild("Light Dark")or u2:FindFirstChild("LightDark")or u2:FindFirstChild("Light_Dark")or u2:FindFirstChild("Light-Dark")
        if e3 then return e3 end
        for _,r2 in ipairs(u2:GetChildren())do
            local y3=string.lower(r2.Name)
            if string.find(y3,"light")and string.find(y3,"dark")then return r2 end
        end
    end
    if y2 then
        local e3=y2:FindFirstChild("Light Dark")or y2:FindFirstChild("LightDark")or y2:FindFirstChild("Light_Dark")
        if e3 then return e3 end
        for _,r2 in ipairs(y2:GetChildren())do
            local y3=string.lower(r2.Name)
            if string.find(y3,"light")and string.find(y3,"dark")then return r2 end
        end
    end
    for _,r2 in ipairs(r:GetChildren())do
        local y3=r2.Name
        if y3=="__OBJECTS"or y3=="Objects"or y3=="Areas"or y3=="Map"then
            for _,r3 in ipairs(r2:GetDescendants())do
                local y4=string.lower(r3.Name)
                if(y4=="light dark"or y4=="lightdark"or(string.find(y4,"light")and string.find(y4,"dark")))then
                    if r3:IsA("BasePart")or r3:IsA("Model")or r3:IsA("Folder")then return r3 end
                end
            end
        end
    end
    return nil
end
local function lk(e2)
    if not e2 then return false end
    if Qk then
        local r2=((Vector3.new(e2.X,0,e2.Z)-Vector3.new(Qk.X,0,Qk.Z))).Magnitude
        if r2<=Nk then return true end
    end
    local r2=Uk()
    if not r2 then
        if e2.X>=5200 then return true end
        return false
    end
    local y2=false
    pcall(function()
        local u2,w2=nil,nil
        if r2:IsA("BasePart")then u2=r2.CFrame w2=r2.Size
        elseif r2:IsA("Model")then u2,w2=r2:GetBoundingBox()
        else
            local e3,y3=nil,nil
            for _,r3 in ipairs(r2:GetChildren())do
                if r3:IsA("BasePart")then
                    local r4=r3.CFrame
                    local w3=r3.Size/2
                    local k2=r4.Position-w3
                    local a2=r4.Position+w3
                    if not e3 then e3=k2 y3=a2
                    else e3=Vector3.new(math.min(e3.X,k2.X),math.min(e3.Y,k2.Y),math.min(e3.Z,k2.Z))y3=Vector3.new(math.max(y3.X,a2.X),math.max(y3.Y,a2.Y),math.max(y3.Z,a2.Z))end
                end
            end
            if e3 and y3 then u2=CFrame.new(((e3+y3))/2)w2=y3-e3 end
        end
        if u2 and w2 then
            Qk=u2.Position
            Pk=u2
            Nk=math.max(350,math.max(w2.X,w2.Z)/2+150)
            local r3=((Vector3.new(e2.X,0,e2.Z)-Vector3.new(u2.Position.X,0,u2.Position.Z))).Magnitude
            if r3<=Nk then y2=true return end
            local k2=u2:PointToObjectSpace(e2)
            local a2=w2/2
            if math.abs(k2.X)<=(a2.X+200)and math.abs(k2.Z)<=(a2.Z+200)then y2=true return end
        end
        for _,r3 in ipairs(r2:GetDescendants())do
            if r3:IsA("BasePart")then
                if((e2-r3.Position)).Magnitude<=250 then
                    y2=true
                    if not Qk then Qk=r3.Position end
                    return
                end
            end
        end
    end)
    return y2
end
local function Dk(e2,r2,y2)
    local u2=r2 and r2.X or 0
    local w2=string.lower(tostring(e2 or""))
    local j2=string.lower(tostring(y2 or""))
    if j2~=""and j2~="egg"then
        if string.find(j2,"spideron")or string.find(j2,"crustacia")or string.find(j2,"bladehide")or string.find(j2,"mantaris")or string.find(j2,"rhinotaur")or string.find(j2,"mutantshark")or string.find(j2,"mutant shark")or string.find(j2,"gorillaking")or string.find(j2,"gorilla king")or string.find(j2,"nightflame")then return "Titan Temple"end
        if string.find(j2,"crane")or string.find(j2,"salamander")or string.find(j2,"redpanda")or string.find(j2,"red panda")or string.find(j2,"snowyowl")or string.find(j2,"snowy owl")or string.find(j2,"koiegg")or string.find(j2,"koi egg")or string.find(j2,"stagegg")or string.find(j2,"stag egg")or string.find(j2,"onitiger")or string.find(j2,"oni tiger")or string.find(j2,"kitsune")then return "Cherry Blossom"end
        if string.find(j2,"centapede")or string.find(j2,"cosmicgecko")or string.find(j2,"cosmic gecko")or string.find(j2,"cosmicgorilla")or string.find(j2,"cosmic gorilla")or string.find(j2,"saturno")or string.find(j2,"saturnita")or string.find(j2,"vacca")or string.find(j2,"cosmic skeleton")or string.find(j2,"skeletonboss")or string.find(j2,"skeleton boss")or string.find(j2,"cosmicdragon")or string.find(j2,"cosmic dragon")or string.find(j2,"lunardragon")or string.find(j2,"lunar dragon")or string.find(j2,"unicornegg")or string.find(j2,"unicorn egg")then return "Cosmic"end
        if string.find(j2,"dodo")or string.find(j2,"pterodactyl")or string.find(j2,"ankylosaurus")or string.find(j2,"triceratops")or string.find(j2,"bronto")or string.find(j2,"trex")or string.find(j2,"t-rex")or string.find(j2,"tralaledon")or string.find(j2,"mosasaurus")then return "Prehistoric"end
        if string.find(j2,"parrotfish")or string.find(j2,"swordfish")or string.find(j2,"whaleshark")or string.find(j2,"whale shark")or string.find(j2,"belugawhale")or string.find(j2,"beluga whale")or string.find(j2,"kraken")or string.find(j2,"elmaja")or string.find(j2,"el maja")then return "Abyss Ocean"end
        if string.find(j2,"lava gecko")or string.find(j2,"lava frog")or string.find(j2,"flaming bull")or string.find(j2,"lava iguana")or string.find(j2,"chillin chilli")or string.find(j2,"cerberus")or string.find(j2,"phoenix")or string.find(j2,"lava dragon")then return "Volcano"end
        if string.find(j2,"penguin")or string.find(j2,"walrus")or string.find(j2,"polar bear")or string.find(j2,"polarbear")or string.find(j2,"sabertooth")or string.find(j2,"mammoth")or string.find(j2,"yeti")or string.find(j2,"ice dragon")or string.find(j2,"icedragon")then return "Snow"end
        if string.find(j2,"sand spider")or string.find(j2,"sandspider")or string.find(j2,"royal sphinx")or string.find(j2,"sphinx")or string.find(j2,"tob tobi")or string.find(j2,"tobtobi")or string.find(j2,"jerboa")or string.find(j2,"fennec")or string.find(j2,"camel")then return "Desert"end
        if string.find(j2,"chimpanzee")or string.find(j2,"toucan")or string.find(j2,"crocodile")or string.find(j2,"orangutini")or string.find(j2,"ananassini")or string.find(j2,"king snake")or string.find(j2,"kingsnake")then return "Jungle"end
        if string.find(j2,"duckling")or string.find(j2,"catfish")or string.find(j2,"turtle")or string.find(j2,"trulimero")or string.find(j2,"trulicina")or string.find(j2,"swan")or string.find(j2,"axolotl")or string.find(j2,"leviathan")then return "Lake"end
        if string.find(j2,"burrowing owl")or string.find(j2,"burrowingowl")or string.find(j2,"brr brr")or string.find(j2,"patapim")or string.find(j2,"chicken")or string.find(j2,"dog")or string.find(j2,"bird")or string.find(j2,"raccoon")or string.find(j2,"fox")then return "Forest"end
        if string.find(j2,"shark")then return "Abyss Ocean"end
        if string.find(j2,"snake")then return "Desert"end
        if string.find(j2,"spider")then return "Jungle"end
        if string.find(j2,"gorilla")then return "Jungle"end
        if string.find(j2,"tiger")then return "Jungle"end
        if string.find(j2,"frog")then return "Lake"end
        if string.find(j2,"bear")then return "Forest"end
    end
    if(string.find(w2,"light")and string.find(w2,"dark"))or w2=="lightdark"then return "Light Dark"
    elseif string.find(w2,"titan")then return "Titan Temple"
    elseif string.find(w2,"cherry")then return "Cherry Blossom"
    elseif string.find(w2,"cosmic")then return "Cosmic"
    elseif string.find(w2,"prehistoric")or string.find(w2,"dino")then return "Prehistoric"
    elseif string.find(w2,"abyss")or string.find(w2,"ocean")then return "Abyss Ocean"
    elseif string.find(w2,"volcano")or string.find(w2,"lava")then return "Volcano"
    elseif string.find(w2,"snow")or string.find(w2,"ice")or string.find(w2,"winter")then return "Snow"
    elseif string.find(w2,"jungle")then return "Jungle"
    elseif string.find(w2,"desert")or string.find(w2,"sand")then return "Desert"
    elseif string.find(w2,"lake")or string.find(w2,"water")then return "Lake"
    elseif string.find(w2,"forest")then return "Forest"end
    if u2>0 then
        if u2>=5200 then return "Light Dark"
        elseif u2>=4750 then return "Titan Temple"
        elseif u2>=4000 then return "Cherry Blossom"
        elseif u2>=3350 then return "Cosmic"
        elseif u2>=2780 then return "Prehistoric"
        elseif u2>=2250 then return "Abyss Ocean"
        elseif u2>=1850 then return "Volcano"
        elseif u2>=1450 then return "Snow"
        elseif u2>=1150 then return "Jungle"
        elseif u2>=920 then return "Desert"
        elseif u2>=720 then return "Lake"
        else return "Forest"end
    end
    return "Forest"
end
N4=function()
    local e2=h4(false)
    if not e2 or#e2==0 then e2=h4(true)end
    if not e2 or#e2==0 then return nil end
    local y2=o.Character
    local u2=y2 and y2:FindFirstChild("HumanoidRootPart")
    local w2=u2 and u2.Position or Vector3.new(525,70,-360)
    local function j2(e3)
        e3=tonumber(e3)or 0
        if e3>=1000000000000 then return string.format("%.1fT",e3/1000000000000)end
        if e3>=1000000000 then return string.format("%.1fB",e3/1000000000)end
        if e3>=1000000 then return string.format("%.1fM",e3/1000000)end
        if e3>=1000 then return string.format("%.1fK",e3/1000)end
        return string.format("%.0f",e3)
    end
    local function k2(e3,r2,y3,u3)
        if e3 and e3.PhysicalModel then
            local u4=e3.PhysicalModel
            local w3=u4:GetAttribute("Rarity")or u4:GetAttribute("RarityTier")or u4:GetAttribute("Tier")
            if w3 and(tostring(w3)~=""and tostring(w3)~="Unknown")then y3=tostring(w3)end
            if not r2 or r2=="Egg"or r2==""then r2=u4:GetAttribute("Category")or u4:GetAttribute("AssetCategory")or u4.Name end
        end
        local w3=string.lower(tostring(e3.Rarity or""))
        local j3=string.lower(tostring(y3 or""))
        for _,r3 in ipairs({w3,j3})do
            if r3~=""and(r3~="unknown"and r3~="nil")then
                if string.find(r3,"divine")then return 6,"Divine"end
                if string.find(r3,"eternal")then return 5,"Eternal"end
                if string.find(r3,"secret")then return 4,"Secret"end
                if string.find(r3,"cosmic")then return 3,"Cosmic"end
                if string.find(r3,"mythic")then return 2,"Mythic"end
                if string.find(r3,"legendary")then return 1,"Legendary"end
                if string.find(r3,"epic")then return 0.5,"Epic"end
                if string.find(r3,"rare")then return 0.3,"Rare"end
                if string.find(r3,"uncommon")then return 0.1,"Uncommon"end
                if string.find(r3,"common")then return 0,"Common"end
            end
        end
        if u3 and u3>=10 then return 6,"Divine"
        elseif u3 and u3>=9 then return 5,"Eternal"
        elseif u3 and u3>=8 then return 4,"Secret"
        elseif u3 and u3>=7 then return 3,"Cosmic"
        elseif u3 and u3>=6 then return 2,"Mythic"
        elseif u3 and u3>=5 then return 1,"Legendary"
        elseif u3 and u3>=4 then return 0.5,"Epic"
        elseif u3 and u3>=3 then return 0.3,"Rare"
        elseif u3 and u3>=2 then return 0.1,"Uncommon"
        elseif u3 and u3>=1 then return 0,"Common"end
        local k3=string.lower(string.format("%s %s %s %s %s",tostring(r2 or""),tostring(e3.Uid or""),tostring(e3.Name or""),tostring(e3.DisplayName or""),tostring(e3.EggName or"")))
        if string.find(k3,"nightflame")or string.find(k3,"unicornegg")or string.find(k3,"unicorn egg")or string.find(k3,"shatteredcolossus")or string.find(k3,"kitsune")or string.find(k3,"elmaja")or string.find(k3,"el maja")then return 6,"Divine"end
        if string.find(k3,"gorillaking")or string.find(k3,"gorilla king")or string.find(k3,"lunardragon")or string.find(k3,"lunar dragon")or string.find(k3,"onitiger")or string.find(k3,"oni tiger")or string.find(k3,"mosasaurus")then return 5,"Eternal"end
        if string.find(k3,"mutantshark")or string.find(k3,"mutant shark")or string.find(k3,"skeletonboss")or string.find(k3,"skeleton boss")or string.find(k3,"stagegg")or string.find(k3,"stag egg")or string.find(k3,"cosmicdragon")or string.find(k3,"cosmic dragon")or string.find(k3,"trex")or string.find(k3,"t-rex")or string.find(k3,"tralaledon")or string.find(k3,"kraken")then return 4,"Secret"end
        if string.find(k3,"saturnita")or string.find(k3,"saturno")or string.find(k3,"mantaris")or string.find(k3,"rhinotaur")or string.find(k3,"snowyowl")or string.find(k3,"snowy owl")or string.find(k3,"koiegg")or string.find(k3,"koi egg")or string.find(k3,"triceratops")or string.find(k3,"bronto")or string.find(k3,"whaleshark")or string.find(k3,"whale shark")or string.find(k3,"belugawhale")or string.find(k3,"beluga whale")then return 3,"Cosmic"end
        if string.find(k3,"bladehide")or string.find(k3,"redpanda")or string.find(k3,"red panda")or string.find(k3,"cosmicgorilla")or string.find(k3,"cosmic gorilla")or string.find(k3,"ankylosaurus")or string.find(k3,"orca")then return 2,"Mythic"end
        if string.find(k3,"spideron")or string.find(k3,"crustacia")or string.find(k3,"salamander")or string.find(k3,"cosmicgecko")or string.find(k3,"cosmic gecko")or string.find(k3,"pterodactyl")or string.find(k3,"sharkegg")or string.find(k3,"shark egg")then return 1,"Legendary"end
        if string.find(k3,"crane")or string.find(k3,"centapede")or string.find(k3,"swordfish")then return 0.5,"Epic"end
        if string.find(k3,"dodo")or string.find(k3,"parrotfish")then return 0.3,"Rare"end
        local a2=tonumber(e3.EarningRate or e3.Income or 0)
        if a2 and a2>=150000000 then return 4,"Secret"end
        local o2=(y3 and(y3~="Unknown"and y3))or "Common"
        local V2=F[o2]or 0
        return V2,o2
    end
    local function a2(r2,y3)
        local u3={}
        for _,r3 in ipairs(e2)do
            local j3=(r3.State=="Slot"or r3.State=="Dropped"or r3.State=="GuardCarried"or r3.State==1)
            local a3=(r3.BoundsCFrame and r3.BoundsCFrame.Position.X<530)or string.find(tostring(r3.Uid),"FirstArea")
            local o3=X4[r3.Uid]and(os.clock()<X4[r3.Uid])
            if j3 and(not a3 and(((y3 or not o3))and r3.BoundsCFrame))then
                local e3=r3.AssetCategory or "Egg"
                local y4=0
                local j4=0
                local a4=0
                local o4="Unknown"
                if p then
                    pcall(function()
                        if p.RarityRankForCategory then y4=p.RarityRankForCategory(e3)or 0 end
                        if p.ProfileIncomePerSecond then j4=p.ProfileIncomePerSecond(e3)or 0 end
                        if p.SalePrice then a4=p.SalePrice(e3)or 0 end
                        if p.Assets and p.Assets[e3]then
                            local y5=p.Assets[e3]
                            o4=y5.Rarity or(y5.Egg and y5.Egg.Rarity)or "Unknown"
                            if not j4 or j4==0 then j4=y5.EarningRate or(y5.Egg and y5.Egg.EarningRate)or 0 end
                        end
                    end)
                end
                local V2=r3.BoundsCFrame.Position.X
                local H2=r3.BoundsCFrame.Position
                local t2=r3.AreaId
                if((not t2 or t2==""or t2=="Unknown"))and r3.PhysicalModel then t2=r3.PhysicalModel:GetAttribute("AreaId")or r3.PhysicalModel:GetAttribute("Area")end
                local B2=string.format("%s %s %s %s",tostring(e3 or""),tostring(r3.Uid or""),tostring(r3.Name or""),(r3.PhysicalModel and r3.PhysicalModel.Name)or"")
                local J2=Dk(t2,H2,B2)
                local K2,c2=k2(r3,e3,o4,y4)
                local v2=(K2>=4 or c2=="Secret"or c2=="Eternal"or c2=="Divine")
                local i2=(h.selectedZones and h.selectedZones[J2]==true)
                local R2=(h.selectedRarities and h.selectedRarities[c2]==true)
                local gg=false
                if v2 then gg=true
                else if i2 and R2 then gg=true end end
                if gg then
                    local k3=tonumber(r3.AssetScale or r3.Scale)or 1
                    local a5=1
                    if r3.Mutations and type(r3.Mutations)=="table"then
                        for _,r4 in pairs(r3.Mutations)do
                            local y5=(type(r4)=="table"and tonumber(r4.Multiplier or r4.Value))or tonumber(r4)or 1.5
                            a5=a5*y5
                        end
                    elseif r3.Mutation then a5=1.5 end
                    local o5=(j4*k3)*a5
                    local V3=f[J2]or 50
                    if o5<=0 then o5=(((V3^2)*k3)*a5)*10 end
                    local H3=((w2-r3.BoundsCFrame.Position)).Magnitude
                    table.insert(u3,{Uid=r3.Uid,Category=tostring(e3),Area=tostring(J2),ZoneWeight=V3,Rarity=tostring(c2),RarityTier=K2,Rank=y4,Income=j4,RealIncome=o5,Scale=k3,MutMultiplier=a5,CFrame=r3.BoundsCFrame,Position=r3.BoundsCFrame.Position,Distance=H3,Model=r3.PhysicalModel})
                end
            end
        end
        if#u3==0 then return nil end
        local function a3(e3)
            local r3=e3.RarityTier or 0
            local y4=e3.ZoneWeight or 50
            if r3>=4 then return(400000+(r3*10000))+y4
            else return(y4*11)+(r3*1000)end
        end
        table.sort(u3,function(e3,r3)
            local y4=a3(e3)
            local u4=a3(r3)
            if y4~=u4 then return y4>u4 end
            if e3.ZoneWeight~=r3.ZoneWeight then return e3.ZoneWeight>r3.ZoneWeight end
            if math.abs(e3.RealIncome-r3.RealIncome)>1 then return e3.RealIncome>r3.RealIncome end
            if math.abs(e3.Scale-r3.Scale)>0.05 then return e3.Scale>r3.Scale end
            return e3.Distance<r3.Distance
        end)
        local o3=u3[1]
        local V3={}
        for e3=1,math.min(3,#u3),1 do
            local r3=u3[e3]
            table.insert(V3,string.format("#%d %s[%s|%s] Score:%d $%s/s (%.1fx) dist=%dm",e3,tostring(r3.Category),tostring(r3.Rarity),tostring(r3.Area),a3(r3),j2(r3.RealIncome),tonumber(r3.Scale)or 1,math.floor(tonumber(r3.Distance)or 0)))
        end
        if#V3>0 then H("[Antraxdevz "..BRAND_VER.."] "..table.concat(V3," | "))end
        return o3
    end
    local V2=a2(false,false)
    if not V2 then X4={}V2=a2(false,true)end
    if not V2 then e2=h4(true)V2=a2(false,true)end
    if V2 and r:FindFirstChild("AreaEggSlotsClient")then
        for _,r2 in ipairs(r.AreaEggSlotsClient:GetChildren())do
            local y3=r2:FindFirstChildWhichIsA("BasePart")or r2.PrimaryPart
            if y3 and((y3.Position-V2.Position)).Magnitude<=12 then V2.Model=r2 break end
        end
    end
    return V2
end
U4=function(e2,u2,w2,j2)
    local k2=o.Character
    local a2=k2 and k2:FindFirstChild("HumanoidRootPart")
    local V2=k2 and k2:FindFirstChildOfClass("Humanoid")
    if not a2 or not V2 then return false end
    h.securingEgg=true
    h.isReturning=false
    h.stateTime=os.clock()
    h.holdingEggForGuard=true
    local s2=u2.Position
    V4(s2,14)
    h.currentTargetModel=w2
    h.targetPosition=s2
    a2.AssemblyLinearVelocity=Vector3.zero
    a2.AssemblyAngularVelocity=Vector3.zero
    Z4(k2)
    pcall(function()o:RequestStreamAroundAsync(s2)end)
    if not w2 and r:FindFirstChild("AreaEggSlotsClient")then
        for _,r2 in ipairs(r.AreaEggSlotsClient:GetChildren())do
            local y3=r2:FindFirstChildWhichIsA("BasePart")or r2.PrimaryPart
            if y3 and((y3.Position-s2)).Magnitude<=16 then w2=r2 h.currentTargetModel=r2 break end
        end
    end
    if w2 then
        pcall(function()
            for _,r2 in ipairs(w2:GetDescendants())do
                if r2:IsA("BasePart")and(r2.Transparency>0.8 and(r2.Name~="Hitbox"and(r2.Name~="Root"and not r2.Name:find("Pad"))))then r2.Transparency=0 end
            end
        end)
    end
    h.statusText="[1/4] Lifting Egg..."
    H(string.format("[GuardStrike] Step 1: Lifting %s",tostring(e2)))
    local pp=os.clock()+3.5
    local B2=0
    while not w4()and(os.clock()<pp and(h.alive and h.securingEgg))do
        if j2 and O4~=j2 then t("[GuardStrike] Cancelled Step 1")break end
        if not h.pureTweenFarm and(not h.autoFarmLoop and not h.teleporting)then break end
        if e2 and(os.clock()-B2>0.4)then
            B2=os.clock()
            local r2,y3=k4(e2)
            if not r2 and y3=="CarriedByOther"then
                t(string.format("[GuardStrike] Egg %s stolen",tostring(e2)))
                break
            end
        end
        k2:PivotTo(u2*CFrame.new(0,0.4,0))
        d4(w2,s2)
        if e2 and i then
            task.spawn(function()
                pcall(function()
                    if i:IsA("RemoteFunction")then i:InvokeServer({Uid=e2})i:InvokeServer(e2)
                    else i:FireServer({Uid=e2})i:FireServer(e2)end
                end)
            end)
        end
        y.Heartbeat:Wait()
    end
    if not w4()then
        t("[GuardStrike] Step 1 timeout")
        if e2 then X4[e2]=os.clock()+2 end
        h.currentTargetModel=nil
        h.targetPosition=nil
        h.securingEgg=false
        h.holdingEggForGuard=false
        return false
    end
    h.statusText="[2/4] Waiting Strike..."
    H("[GuardStrike] Step 2: triggering")
    local J2=os.clock()
    local K2=J2+4.5
    local c2=false
    while w4()and(os.clock()<K2 and(h.alive and h.securingEgg))do
        if j2 and O4~=j2 then t("[GuardStrike] Cancelled Step 2")break end
        if not h.pureTweenFarm and(not h.autoFarmLoop and not h.teleporting)then break end
        k2:PivotTo(u2*CFrame.new(0,0.4,0))
        V4(s2,14)
        if P and not c2 then
            task.spawn(function()
                pcall(function()
                    if P:IsA("RemoteFunction")then P:InvokeServer()
                    else P:FireServer()end
                end)
            end)
            c2=true
        end
        y.Heartbeat:Wait()
    end
    h.statusText="[3/4] Re-grabbing..."
    H("[GuardStrike] Step 3")
    local v2=os.clock()+3
    while not w4()and(os.clock()<v2 and(h.alive and h.securingEgg))do
        if j2 and O4~=j2 then t("[GuardStrike] Cancelled Step 3")break end
        if not h.pureTweenFarm and(not h.autoFarmLoop and not h.teleporting)then break end
        k2:PivotTo(u2*CFrame.new(0,0.4,0))
        d4(w2,s2)
        if e2 and i then
            task.spawn(function()
                pcall(function()
                    if i:IsA("RemoteFunction")then i:InvokeServer({Uid=e2})i:InvokeServer(e2)
                    else i:FireServer({Uid=e2})i:FireServer(e2)end
                end)
            end)
        end
        y.Heartbeat:Wait()
    end
    local R2=j4(e2)
    if not R2 then task.wait(0.12)R2=j4(e2)end
    h.currentTargetModel=nil
    h.targetPosition=nil
    h.securingEgg=false
    h.holdingEggForGuard=false
    if j2 and O4~=j2 then return false end
    if R2 then
        pcall(u4)
        H("[GuardStrike] Secured")
        h.statusText="Egg Secured!"
        h.stats.stolen=h.stats.stolen+1
    else
        t("[-] Failed to re-grab")
        h.statusText="[-] Failed"
        if e2 then X4[e2]=os.clock()+2 end
    end
    return R2
end
l4=function(e2,u2)
    if h.teleporting or h.glidingToTarget or h.delivering or h.securingEgg then return false end
    h.teleporting=true
    h.isReturning=false
    h.stateTime=os.clock()
    local w2=o.Character
    local j2=w2 and w2:FindFirstChild("HumanoidRootPart")
    local k2=w2 and w2:FindFirstChildOfClass("Humanoid")
    if not j2 or not k2 then D4()return false end
    if k2 then k2:UnequipTools()end
    h.statusText="[1/7] Pre-Flight..."
    if not h.swapped then A4()end
    if not h.godmode then b4(true)end
    Z4(w2)
    if not e2 then e2=N4()end
    local a2=e2 and e2.CFrame or S
    local V2=e2 and e2.Uid
    local H2=a2.Position
    if V2 then
        local e3,r2=k4(V2)
        if not e3 and r2~="CarriedBySelf"then
            t(string.format("[Snipe] %s taken (%s)",tostring(V2),tostring(r2)))
            h.statusText="Target taken!"
            X4[V2]=os.clock()+5
            D4()
            return false
        end
    end
    local s2=select(2,e4())
    if not s2 then
        local e3=P4()
        if not e3 then
            t("[-] Lake egg not found")
            h.statusText="[-] No Lake"
            D4()
            return false
        end
        h.currentTargetModel=e3.Model
        h.targetPosition=e3.Position
        local r2=((j2.Position-e3.Position)).Magnitude
        local w3=e3.CFrame*CFrame.new(0,0.4,0)
        pcall(function()o:RequestStreamAroundAsync(e3.Position)end)
        V4(e3.Position,8)
        if r2>60 then
            h.statusText=string.format("[2/7] Gliding Lake %.0f",r2)
            h.glidingToTarget=true
            local y3=R4(w3,h.glideSpeed,e3.Uid,u2)
            h.glidingToTarget=false
            if not y3 then
                t("[-] Lake taken")
                X4[e3.Uid]=os.clock()+5
                D4()
                return false
            end
        else
            h.statusText="[2/7] Aligning..."
            j2.CFrame=w3
            j2.AssemblyLinearVelocity=Vector3.zero
            task.wait(0.04)
        end
        j2.Anchored=true
        task.wait(0.06)
        j2.Anchored=false
        h.holdingEggForGuard=true
        local k3=os.clock()+3
        while not w4()and(os.clock()<k3 and(h.alive and h.teleporting))do
            if u2 and O4~=u2 then t("[Snipe] Cancelled")D4()return false end
            if not h.autoFarmLoop and not h.teleporting then D4()return false end
            d4(e3.Model,e3.Position)
            if e3.Uid and i then
                task.spawn(function()
                    pcall(function()
                        if i:IsA("RemoteFunction")then i:InvokeServer({Uid=e3.Uid})
                        else i:FireServer({Uid=e3.Uid})end
                    end)
                end)
            end
            y.Heartbeat:Wait()
        end
        s2=select(2,e4())
        if not w4()then
            t("[-] Lake pickup failed")
            h.statusText="[-] Failed"
            D4()
            return false
        end
    end
    h.statusText="[3/7] Pre-stream..."
    pcall(function()o:RequestStreamAroundAsync(H2)end)
    V4(H2,12)
    h.statusText="[4/7] Waiting bounce..."
    j2.Anchored=false
    k2:ChangeState(Enum.HumanoidStateType.Running)
    local pp=(k2.WalkSpeed>0)and k2.WalkSpeed or 16
    k2.WalkSpeed=0
    k2:Move(Vector3.zero,false)
    j2.AssemblyLinearVelocity=Vector3.zero
    j2.AssemblyAngularVelocity=Vector3.zero
    task.wait(0.04)
    local B2=j2.Position
    local J2=B2.Y
    local K2=select(2,e4())or s2
    local c2=false
    local v2=nil
    if N and N:IsA("RemoteEvent")then
        v2=N.OnClientEvent:Connect(function()c2=true if v2 then v2:Disconnect()end end)
    end
    h.holdingEggForGuard=true
    H4(K2)
    local R2=os.clock()
    local gg=false
    local Q2=os.clock()+2.5
    local P2=false
    while os.clock()<Q2 and(h.alive and h.teleporting)do
        if u2 and O4~=u2 then
            t("[Snipe] Cancelled")
            if v2 then v2:Disconnect()end
            k2.WalkSpeed=pp
            D4()
            return false
        end
        local e3=os.clock()-R2
        local r2=j2.AssemblyLinearVelocity
        local w3=j2.Position
        local a3=w3.Y-J2
        local o2=((w3-B2)).Magnitude
        if e3>=0.08 then
            local e4=c2 or(r2.Y>=10)or(a3>=1.5 and r2.Magnitude>=16)or(o2>=2)or(r2.Magnitude>=20)
            if e4 then gg=true break end
        end
        if e3>=0.5 and not P2 then P2=true H4(K2)end
        y.Heartbeat:Wait()
    end
    if v2 then v2:Disconnect()end
    k2.WalkSpeed=pp
    h.holdingEggForGuard=false
    if not gg then
        t("[-] No bounce")
        h.statusText="[-] No bounce"
        D4()
        pcall(u4)
        return false
    end
    task.wait(0.05)
    if V2 then
        local e3,r2=k4(V2)
        if not e3 and r2=="CarriedByOther"then
            t(string.format("[Snipe] %s snatched",tostring(V2)))
            h.statusText="Target taken!"
            X4[V2]=os.clock()+5
            D4()
            return false
        end
    end
    h.currentTargetModel=e2 and e2.Model
    h.targetPosition=H2
    h.statusText="[5/7] Warping..."
    V4(H2,8)
    w2:PivotTo(a2*CFrame.new(0,0.4,0))
    j2.Anchored=true
    for _,r2 in ipairs(w2:GetDescendants())do
        if r2:IsA("BasePart")then r2.AssemblyLinearVelocity=Vector3.zero r2.AssemblyAngularVelocity=Vector3.zero end
    end
    h.statusText="[6/7] Pickup..."
    local U2=o:FindFirstChild("Backpack")
    for _,y3 in ipairs(w2:GetChildren())do
        if y3:IsA("Tool")then
            pcall(function()if U2 then y3.Parent=U2 else y3.Parent=r end)
        end
    end
    task.wait(0.06)
    j2.Anchored=false
    k2:ChangeState(Enum.HumanoidStateType.Running)
    local ll=U4(V2,a2,e2 and e2.Model,u2)
    j2.Anchored=false
    k2:ChangeState(Enum.HumanoidStateType.Running)
    for _,r2 in ipairs(w2:GetDescendants())do
        if r2:IsA("BasePart")then r2.AssemblyLinearVelocity=Vector3.zero r2.AssemblyAngularVelocity=Vector3.zero end
    end
    if not ll then
        t("[-] Strike failed")
        h.statusText="[-] Failed"
        D4()
        return false
    else
        h.statusText="[7/7] Secured!"
        h.teleporting=false
        pcall(u4)
        return true
    end
end
T4=function(e2)
    if Y4==e2 then return end
    O4=O4+1
    local r2=O4
    Y4="SWITCHING"
    h.pureTweenFarm=false
    h.autoFarmLoop=false
    pcall(D4)
    pcall(u4)
    if e2=="TWEEN"then
        if W4 then W4(false,true)end
        if x4 then x4(true,true)end
    elseif e2=="WARP"then
        if x4 then x4(false,true)end
        if W4 then W4(true,true)end
    else
        if x4 then x4(false,true)end
        if W4 then W4(false,true)end
    end
    task.delay(0.06,function()
        if O4==r2 then
            Y4=e2
            if e2=="TWEEN"then
                h.pureTweenFarm=true
                h.autoFarmLoop=false
                pcall(u4)
                H("[Farm] TWEEN ON")
            elseif e2=="WARP"then
                h.autoFarmLoop=true
                h.pureTweenFarm=false
                pcall(u4)
                H("[Farm] WARP ON")
            else
                h.pureTweenFarm=false
                h.autoFarmLoop=false
                if not h.isBatchPlacing then h.batchStealCount=0 end
                H("[Farm] OFF")
            end
        end
    end)
end
local Ck=os.clock()
task.spawn(function()
    while h.alive do
        local rr,yy=pcall(function()
            if h.pureTweenFarm and(not h.autoFarmLoop and(Y4=="TWEEN"and(not h.isBatchPlacing and(not h.teleporting and(not h.glidingToTarget and(not h.securingEgg and(not h.delivering and not h.isReturning)))))))then
                local r2=o.Character
                local y2=r2 and r2:FindFirstChild("HumanoidRootPart")
                local u2=r2 and r2:FindFirstChildOfClass("Humanoid")
                if y2 and u2 then
                    pcall(u4)
                    local u3=w4()
                    if not u3 then
                        local u4=O4
                        local w2=N4()
                        if w2 and(h.pureTweenFarm and(Y4=="TWEEN"and O4==u4))then
                            if h.onTreadmill or L4()then h.statusText="[AutoSteal] Target! Off treadmill..."M4()task.wait(0.08)end
                            local j2,k2=k4(w2.Uid)
                            if not j2 and k2~="CarriedBySelf"then
                                H(string.format("[AutoSteal] %s taken",tostring(w2.Uid)))
                                X4[w2.Uid]=os.clock()+5
                                task.wait(0.12)
                                return
                            end
                            h.currentTargetModel=w2.Model
                            h.targetPosition=w2.Position
                            h.glidingToTarget=true
                            h.stateTime=os.clock()
                            local a2=((w2.Scale and w2.Scale>1.05))and string.format(" | %.1fx",w2.Scale)or""
                            h.statusText=string.format("[AutoSteal] Flying %s (%s%s)",tostring(w2.Category or "Egg"),tostring(w2.Area or "Field"),a2)
                            H(string.format("[AutoSteal] Fly %s Zone:%s%s Rk:%d",tostring(w2.Category or "Egg"),tostring(w2.Area or "Field"),a2,tonumber(w2.Rank)or 1))
                            if not h.swapped then A4()end
                            if not h.godmode then b4(true)end
                            Z4(r2)
                            pcall(function()o:RequestStreamAroundAsync(w2.Position)end)
                            local V3=w2.CFrame*CFrame.new(0,0.4,0)
                            local s2=R4(V3,h.glideSpeed,w2.Uid,u2)
                            h.glidingToTarget=false
                            if O4~=u4 or not h.pureTweenFarm or Y4~="TWEEN"then return end
                            if not s2 then
                                t("[AutoSteal] Taken en route")
                                X4[w2.Uid]=os.clock()+5
                                D4()
                                return
                            end
                            if h.pureTweenFarm and(Y4=="TWEEN"and((y2.Position-w2.Position)).Magnitude<=22)then
                                local r3=U4(w2.Uid,V3,w2.Model,u2)
                                if not r3 and w4()then r3=true end
                                if O4~=u4 or not h.pureTweenFarm or Y4~="TWEEN"then return end
                                if r3 then
                                    pcall(u4)
                                    if h.autoGlide then
                                        h.statusText="[AutoSteal] Secured! Tweening Safe Line..."
                                        H("[AutoSteal] Secured! Return Safe Line")
                                        Q4(h.glideSpeed,u2)
                                        pcall(u4)
                                        local r4=y4()
                                        h.statusText=string.format("Bag %d Eggs",r4)
                                        H(string.format("[AutoSteal] Bag %d",r4))
                                    else
                                        h.statusText="[AutoSteal] Secured (No Return)"
                                        H("[AutoSteal] Secured!")
                                    end
                                    pcall(u4)
                                    h.isReturning=false
                                    h.delivering=false
                                    h.glidingToTarget=false
                                    h.securingEgg=false
                                    h.currentTargetModel=nil
                                    h.targetPosition=nil
                                    if c4("TWEEN")then return end
                                else
                                    if O4==u4 and(h.pureTweenFarm and Y4=="TWEEN")then
                                        t("[AutoSteal] Strike failed retry")
                                        X4[w2.Uid]=os.clock()+5
                                        D4()
                                    end
                                end
                            else
                                h.currentTargetModel=nil
                                h.targetPosition=nil
                                h.glidingToTarget=false
                            end
                        else
                            if os.clock()-Ck>5 then X4={}Ck=os.clock()end
                            if h.autoTreadmill and(not h.isBatchPlacing and not h.isHatching)then
                                if not h.onTreadmill and not L4()then h.statusText="[AutoTreadmill] Idle mounting..."f4(u2)
                                else h.statusText="[AutoTreadmill] Running..."end
                            else
                                h.statusText="[AutoSteal] Scanning..."
                            end
                        end
                    end
                end
            end
        end)
        if not rr then t("[AutoSteal] Recovered:",tostring(yy))pcall(D4)end
        task.wait(0.08)
    end
end)
local qk=os.clock()
task.spawn(function()
    while h.alive do
        local rr,yy=pcall(function()
            if h.autoFarmLoop and(not h.pureTweenFarm and(Y4=="WARP"and(not h.isBatchPlacing and(not h.teleporting and(not h.glidingToTarget and(not h.securingEgg and(not h.delivering and not h.isReturning)))))))then
                local r2=o.Character
                local y2=r2 and r2:FindFirstChild("HumanoidRootPart")
                local u2=r2 and r2:FindFirstChildOfClass("Humanoid")
                if y2 and u2 then
                    pcall(u4)
                    local r3=w4()
                    if not r3 then
                        local r4=O4
                        local y3=N4()
                        if y3 and(h.autoFarmLoop and(Y4=="WARP"and O4==r4))then
                            if h.onTreadmill or L4()then h.statusText="[SnipeLoop] Target! Off treadmill..."M4()task.wait(0.08)end
                            local u3=((y3.Scale and y3.Scale>1.05))and string.format(" | %.1fx",y3.Scale)or""
                            H(string.format("[SnipeLoop] Start %s Zone:%s%s Rk:%d",tostring(y3.Category or "Egg"),tostring(y3.Area or "Field"),u3,tonumber(y3.Rank)or 1))
                            h.statusText=string.format("[SnipeLoop] Warp %s%s",tostring(y3.Category or "Egg"),u3)
                            local w2=l4(y3,r4)
                            if O4~=r4 or not h.autoFarmLoop or Y4~="WARP"then return end
                            if w2 then
                                pcall(u4)
                                if h.autoGlide then
                                    h.statusText="[SnipeLoop] Secured! Tweening..."
                                    Q4(h.glideSpeed,r4)
                                    pcall(u4)
                                    local y4=y4()
                                    h.statusText=string.format("Bag %d Eggs",y4)
                                    H(string.format("[SnipeLoop] Bag %d",y4))
                                else
                                    h.statusText="[SnipeLoop] Secured (No Return)"
                                    H("[SnipeLoop] Secured!")
                                end
                                pcall(u4)
                                h.isReturning=false
                                h.delivering=false
                                if c4("WARP")then return end
                            else
                                if O4==r4 and(h.autoFarmLoop and Y4=="WARP")then
                                    t("[SnipeLoop] Failed resetting")
                                    if y3 and y3.Uid then X4[y3.Uid]=os.clock()+5 end
                                    pcall(D4)
                                end
                            end
                        else
                            if os.clock()-qk>5 then X4={}qk=os.clock()end
                            if h.autoTreadmill and(not h.isBatchPlacing and not h.isHatching)then
                                if not h.onTreadmill and not L4()then h.statusText="[AutoTreadmill] Idle mounting..."f4(r2)
                                else h.statusText="[AutoTreadmill] Running..."end
                            else
                                h.statusText="[SnipeLoop] Scanning..."
                            end
                        end
                    end
                end
            end
        end)
        if not rr then t("[SnipeLoop] Recovered:",tostring(yy))pcall(D4)end
        task.wait(0.08)
    end
end)
task.spawn(function()
    while h.alive do
        local rr=pcall(function()
            if h.autoTreadmill and(not h.pureTweenFarm and(not h.autoFarmLoop and(not h.isBatchPlacing and(not h.isHatching and(not h.teleporting and(not h.glidingToTarget and(not h.securingEgg and(not h.delivering and not h.isReturning))))))))then
                local e2=o.Character
                local y2=e2 and e2:FindFirstChild("HumanoidRootPart")
                if y2 and not w4()then
                    if not h.onTreadmill and not L4()then h.statusText="[AutoTreadmill] Idle mounting..."f4()end
                end
            end
        end)
        task.wait(0.5)
    end
end)
task.spawn(function()
    while h.alive do
        pcall(function()if h.autoUpgradeTreadmill then pk()end end)
        task.wait(5)
        pcall(function()if h.autoBuyTrails then gk()end end)
        task.wait(5)
    end
end)
task.spawn(function()
    while h.alive do
        if h.autoHatch and(not h.securingEgg and(not h.teleporting and not h.isHatching))then
            pcall(function()J4(false)end)
        end
        task.wait(4)
    end
end)
local nk=nil
local function fk(e2)
    pcall(function()
        if e2:IsA("BasePart")then
            e2.Material=Enum.Material.SmoothPlastic
            e2.Reflectance=0
            e2.CastShadow=false
            if e2:IsA("MeshPart")then
                e2.TextureID=""
                pcall(function()e2.RenderFidelity=Enum.RenderFidelity.Performance end)
                pcall(function()e2.CollisionFidelity=Enum.CollisionFidelity.Box end)
            end
        elseif e2:IsA("SpecialMesh")then e2.TextureId=""
        elseif e2:IsA("Decal")or e2:IsA("Texture")or e2:IsA("SurfaceAppearance")then e2.Transparency=1
        elseif e2:IsA("ParticleEmitter")or e2:IsA("Trail")or e2:IsA("Smoke")or e2:IsA("Fire")or e2:IsA("Sparkles")then e2.Enabled=false
        elseif e2:IsA("Beam")then e2.Enabled=false
        elseif e2:IsA("Explosion")then e2.Visible=false
        elseif e2:IsA("Light")or e2:IsA("PointLight")or e2:IsA("SpotLight")or e2:IsA("SurfaceLight")then e2.Enabled=false
        elseif e2:IsA("Highlight")and e2.Name~="AntraxESP_Highlight"then e2.Enabled=false end
    end)
end
local function Mk()
    h.performanceMode=true
    pcall(function()
        local e2=r:FindFirstChild("Antraxdevz_EggESP")
        if e2 then e2:Destroy()end
        local y2=Lighting
        y2.GlobalShadows=false
        y2.FogEnd=9000000000
        y2.Brightness=1
        y2.ClockTime=14
        y2.OutdoorAmbient=Color3.fromRGB(128,128,128)
        for _,r2 in ipairs(y2:GetChildren())do
            if r2:IsA("PostEffect")or r2:IsA("BloomEffect")or r2:IsA("BlurEffect")or r2:IsA("ColorCorrectionEffect")or r2:IsA("SunRaysEffect")or r2:IsA("DepthOfFieldEffect")or r2:IsA("Atmosphere")then
                pcall(function()r2.Enabled=false end)
            elseif r2:IsA("Sky")then pcall(function()r2.Parent=nil end)end
        end
        local u2=workspace:FindFirstChildOfClass("Terrain")
        if u2 then pcall(function()u2.Decoration=false u2.WaterWaveSize=0 u2.WaterWaveSpeed=0 u2.WaterReflectance=0 u2.WaterTransparency=0 end)end
        for _,r2 in ipairs(workspace:GetDescendants())do fk(r2)end
        if not nk then nk=workspace.DescendantAdded:Connect(function(e3)if h.performanceMode then fk(e3)end end)end
        pcall(function()if settings and(settings()).Rendering then(settings()).Rendering.QualityLevel=1 end end)
    end)
end
local function Ik()
    h.performanceMode=false
    if nk then pcall(function()nk:Disconnect()end)nk=nil end
    pcall(function()
        local e2=Lighting
        e2.GlobalShadows=true
        for _,r2 in ipairs(e2:GetChildren())do
            if r2:IsA("PostEffect")or r2:IsA("BloomEffect")or r2:IsA("BlurEffect")or r2:IsA("ColorCorrectionEffect")or r2:IsA("SunRaysEffect")or r2:IsA("DepthOfFieldEffect")or r2:IsA("Atmosphere")then
                pcall(function()r2.Enabled=true end)
            end
        end
        local r2=workspace:FindFirstChildOfClass("Terrain")
        if r2 then pcall(function()r2.Decoration=true end)end
    end)
end
local Lk=false
local function Ek()
    pcall(function()
        local e2=game:GetService("VirtualInputManager")
        if e2 then
            e2:SendKeyEvent(true,Enum.KeyCode.Escape,false,game)
            task.wait(0.12)
            e2:SendKeyEvent(false,Enum.KeyCode.Escape,false,game)
            task.wait(0.35)
            e2:SendKeyEvent(true,Enum.KeyCode.Escape,false,game)
            task.wait(0.12)
            e2:SendKeyEvent(false,Enum.KeyCode.Escape,false,game)
            pcall(function()if typeof(e2.SendTouchEvent)=="function"then e2:SendTouchEvent(99999,0,15,15)task.wait(0.04)e2:SendTouchEvent(99999,2,15,15)end end)
        end
    end)
    pcall(function()if typeof(mousemoverel)=="function"then mousemoverel(1,0)task.wait(0.05)mousemoverel(-1,0)end end)
end
local function bk()
    if Lk then return end
    Lk=true
    task.spawn(function()
        while h and(h.alive and h.antiAFK)do
            local r2=0
            while r2<600 and(h and(h.alive and(h.antiAFK and Lk)))do
                task.wait(5)
                r2=r2+5
            end
            if not h.antiAFK or not Lk then break end
            Ek()
        end
        Lk=false
    end)
end
local function Ak()Lk=false end
y.Heartbeat:Connect(function()
    local e2=o.Character
    local r2=e2 and e2:FindFirstChild("HumanoidRootPart")
    local y2=e2 and e2:FindFirstChildOfClass("Humanoid")
    if not r2 then return end
    if y2 and not((h and h.onTreadmill))then
        if y2.PlatformStand then y2.PlatformStand=false y2:ChangeState(Enum.HumanoidStateType.Running)end
        if y2.Sit and((h.pureTweenFarm or h.autoFarmLoop or h.isReturning or h.glidingToTarget))then y2.Sit=false y2:ChangeState(Enum.HumanoidStateType.Running)end
    end
    local u2=r2.Position
    local w2=w4()
    if u2.Y<45 then r2.CFrame=CFrame.new(u2.X,72,u2.Z)r2.AssemblyLinearVelocity=Vector3.zero return end
    if((h.pureTweenFarm or h.autoFarmLoop))and not h.holdingEggForGuard then
        local r3=false
        for _,y3 in ipairs(e2:GetChildren())do if y3:IsA("Tool")then r3=true break end end
        if r3 then u4()end
    end
    if h.pureTweenFarm or h.autoFarmLoop or h.teleporting or h.glidingToTarget or h.delivering or h.securingEgg or h.isReturning then return end
    if h.alive and(h.autoGlide and(w2 and(not a4()and u2.X>E)))then
        task.spawn(function()Q4(h.glideSpeed)u4()h.isReturning=false h.delivering=false end)
    end
end)
y.Heartbeat:Connect(function()
    local e2=o.Character
    local r2=e2 and e2:FindFirstChildOfClass("Humanoid")
    if not r2 then return end
    if h.walkSpeed and h.walkSpeed~=16 then r2.WalkSpeed=h.walkSpeed else r2.WalkSpeed=16 end
    if h.jumpPower and h.jumpPower~=50 then r2.UseJumpPower=true r2.JumpPower=h.jumpPower else r2.JumpPower=50 end
    if h.noclip then
        for _,y2 in ipairs(e2:GetDescendants())do
            if y2:IsA("BasePart")and y2.CanCollide then y2.CanCollide=false end
        end
    end
end)
w.JumpRequest:Connect(function()
    if h.infiniteJump then
        local e2=o.Character
        local r2=e2 and e2:FindFirstChildOfClass("Humanoid")
        if r2 then r2:ChangeState(Enum.HumanoidStateType.Jumping)end
    end
end)
task.spawn(function()
    while h.alive do
        if h.autoSell and(os.clock()-h.lastSell>h.autoSellEvery)then
            pcall(function()
                local e2=o:FindFirstChild("Backpack")
                if e2 then
                    local count=0
                    for _,r2 in ipairs(e2:GetChildren())do if m(r2)then count=count+1 end end
                    if count>=20 then
                        for _,r2 in ipairs(e2:GetChildren())do
                            if m(r2)then pcall(function()r2.Parent=game:GetService("ReplicatedStorage")end)end
                        end
                    end
                end
            end)
            h.lastSell=os.clock()
        end
        task.wait(2)
    end
end)
e.PlayerAdded:Connect(function(plr)
    if not h.antiStaff then return end
    local n=string.lower(plr.Name)or""
    local dn=string.lower(plr.DisplayName)or""
    if n:find("mod")or n:find("admin")or n:find("staff")or n:find("owner")or dn:find("mod")or dn:find("admin")then
        h.statusText="[AntiStaff] Watch detected: "..plr.Name
        if h.pureTweenFarm or h.autoFarmLoop then T4("NONE")end
    end
end)
GuiService.ErrorMessageChanged:Connect(function()
    if h.autoRejoin then
        h.stats.rejoins=h.stats.rejoins+1
        task.wait(2)
        pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,o)end)
    end
end)
e.PlayerRemoving:Connect(function(plr)
    if plr==o and h.autoRejoin then
        pcall(function()TeleportService:Teleport(game.PlaceId,o)end)
    end
end)
local wmGui=nil
local wmLabel=nil
local function buildWatermark()
    if wmGui then return end
    wmGui=Instance.new("ScreenGui")
    wmGui.Name="Antraxdevz_WM"
    wmGui.ResetOnSpawn=false
    wmGui.DisplayOrder=9999998
    wmGui.AutoLocalize=false
    pcall(function()if syn and syn.protect_gui then syn.protect_gui(wmGui)wmGui.Parent=game:GetService("CoreGui")else wmGui.Parent=o:FindFirstChild("PlayerGui")or game:GetService("CoreGui")end end)
    if not wmGui.Parent then wmGui.Parent=game:GetService("CoreGui")end
    local fr=Instance.new("Frame",wmGui)
    fr.Size=UDim2.fromOffset(260,26)
    fr.Position=UDim2.new(1,-276,0,20)
    fr.BackgroundColor3=PAL.bg
    fr.BorderSizePixel=0
    Instance.new("UICorner",fr).CornerRadius=UDim.new(1,0)
    local st=Instance.new("UIStroke",fr)
    st.Color=PAL.orange
    st.Thickness=1.4
    wmLabel=Instance.new("TextLabel",fr)
    wmLabel.Size=UDim2.fromScale(1,1)
    wmLabel.BackgroundTransparency=1
    wmLabel.Text="ANTRAXDEVZ "..BRAND_VER
    wmLabel.TextColor3=PAL.orange
    wmLabel.TextSize=11
    wmLabel.Font=Enum.Font.GothamBold
    wmLabel.AutoLocalize=false
    grad(wmLabel,PAL.orange,PAL.amber,0)
end
local function destroyWatermark()
    if wmGui then wmGui:Destroy()wmGui=nil wmLabel=nil end
end
task.spawn(function()
    while h.alive do
        if h.watermark then
            if not wmGui then buildWatermark()end
            if wmLabel then
                local fps=math.floor(1/math.max(0.001,y.RenderStepped:Wait()))
                local ping=0
                pcall(function()ping=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())end)
                local mem=math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb())
                wmLabel.Text=string.format("ANTRAXDEVZ %s | %s | %dfps | %dms | %dMB",BRAND_VER,o.Name,fps,ping,mem)
            end
        else
            if wmGui then destroyWatermark()end
        end
        task.wait(1)
    end
end)
local toastGui=nil
local toastList=nil
local function buildToast()
    if toastGui then return end
    toastGui=Instance.new("ScreenGui")
    toastGui.Name="Antraxdevz_Toasts"
    toastGui.ResetOnSpawn=false
    toastGui.DisplayOrder=9999997
    toastGui.AutoLocalize=false
    pcall(function()if syn and syn.protect_gui then syn.protect_gui(toastGui)toastGui.Parent=game:GetService("CoreGui")else toastGui.Parent=o:FindFirstChild("PlayerGui")or game:GetService("CoreGui")end end)
    if not toastGui.Parent then toastGui.Parent=game:GetService("CoreGui")end
    toastList=Instance.new("Frame",toastGui)
    toastList.Size=UDim2.fromOffset(280,300)
    toastList.Position=UDim2.new(1,-300,1,-320)
    toastList.BackgroundTransparency=1
    local lay=Instance.new("UIListLayout",toastList)
    lay.SortOrder=Enum.SortOrder.LayoutOrder
    lay.Padding=UDim.new(0,6)
    lay.VerticalAlignment=Enum.VerticalAlignment.Bottom
    lay.HorizontalAlignment=Enum.HorizontalAlignment.Right
end
local function toast(title,msg,dur)
    if not h.toasts then return end
    if not toastGui then buildToast()end
    local fr=Instance.new("Frame",toastList)
    fr.Size=UDim2.fromOffset(280,52)
    fr.BackgroundColor3=PAL.surface2
    fr.BorderSizePixel=0
    fr.BackgroundTransparency=0.05
    Instance.new("UICorner",fr).CornerRadius=UDim.new(0,10)
    local st=Instance.new("UIStroke",fr)
    st.Color=PAL.orange
    st.Thickness=1.4
    local ac=Instance.new("Frame",fr)
    ac.Size=UDim2.fromOffset(3,52)
    ac.Position=UDim2.new(0,0,0,0)
    ac.BackgroundColor3=PAL.orange
    ac.BorderSizePixel=0
    Instance.new("UICorner",ac).CornerRadius=UDim.new(0,2)
    local ti=Instance.new("TextLabel",fr)
    ti.Size=UDim2.new(1,-24,0,18)
    ti.Position=UDim2.new(0,16,0,6)
    ti.BackgroundTransparency=1
    ti.Text=tostring(title)
    ti.TextColor3=PAL.orange
    ti.TextSize=13
    ti.Font=Enum.Font.GothamBold
    ti.TextXAlignment=Enum.TextXAlignment.Left
    ti.AutoLocalize=false
    local tx=Instance.new("TextLabel",fr)
    tx.Size=UDim2.new(1,-24,0,22)
    tx.Position=UDim2.new(0,16,0,24)
    tx.BackgroundTransparency=1
    tx.Text=tostring(msg)
    tx.TextColor3=PAL.text
    tx.TextSize=11
    tx.Font=Enum.Font.GothamMedium
    tx.TextXAlignment=Enum.TextXAlignment.Left
    tx.TextWrapped=true
    tx.AutoLocalize=false
    fr.Position=UDim2.new(1,0,0,0)
    u:Create(fr,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{Position=UDim2.new(0,0,0,0)}):Play()
    task.delay(dur or 3,function()
        pcall(function()
            local tw=u:Create(fr,TweenInfo.new(0.25),{Position=UDim2.new(1,0,0,0),BackgroundTransparency=1})
            tw:Play()
            tw.Completed:Wait()
            fr:Destroy()
        end)
    end)
end
local espFolder=nil
local function espClear()
    if espFolder then espFolder:Destroy()end
    espFolder=Instance.new("Folder")
    espFolder.Name="Antraxdevz_EggESP"
    espFolder.Parent=r
end
local function espMake(part,tier,rarity,cat,zone)
    if not part or not part:IsA("BasePart")then return end
    if tier<h.espMinRarity then return end
    local col=G[rarity]or PAL.orange
    if h.espHighlight then
        local hl=Instance.new("Highlight")
        hl.Name="AntraxESP_Highlight"
        hl.Adornee=part
        hl.FillColor=col
        hl.FillTransparency=0.65
        hl.OutlineColor=col
        hl.OutlineTransparency=0
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent=espFolder
    end
    if h.espBillboard then
        local bb=Instance.new("BillboardGui")
        bb.Name="AntraxESP_BB"
        bb.Adornee=part
        bb.Size=UDim2.fromOffset(160,36)
        bb.StudsOffsetWorldSpace=Vector3.new(0,3.5,0)
        bb.AlwaysOnTop=true
        bb.Parent=espFolder
        local bg=Instance.new("Frame",bb)
        bg.Size=UDim2.fromScale(1,1)
        bg.BackgroundColor3=PAL.bg
        bg.BackgroundTransparency=0.15
        bg.BorderSizePixel=0
        Instance.new("UICorner",bg).CornerRadius=UDim.new(0,6)
        local st=Instance.new("UIStroke",bg)
        st.Color=col
        st.Thickness=1.2
        local lab=Instance.new("TextLabel",bg)
        lab.Size=UDim2.fromScale(1,0.55)
        lab.Position=UDim2.new(0,0,0,0)
        lab.BackgroundTransparency=1
        lab.Text=string.upper(tostring(rarity)).." | "..tostring(cat)
        lab.TextColor3=col
        lab.TextSize=11
        lab.Font=Enum.Font.GothamBold
        lab.AutoLocalize=false
        local lab2=Instance.new("TextLabel",bg)
        lab2.Size=UDim2.fromScale(1,0.45)
        lab2.Position=UDim2.new(0,0,0.55,0)
        lab2.BackgroundTransparency=1
        lab2.Text=tostring(zone).." | --"
        lab2.TextColor3=PAL.textDim
        lab2.TextSize=9
        lab2.Font=Enum.Font.GothamMedium
        lab2.AutoLocalize=false
        lab2.Name="DistLabel"
    end
end
task.spawn(function()
    while h.alive do
        if h.eggESP then
            if not espFolder or not espFolder.Parent then espClear()end
            local list=h4(true)
            if list then
                local seen={}
                for _,eg in ipairs(list)do
                    if eg.Uid and not seen[eg.Uid]then
                        seen[eg.Uid]=true
                        local tier,rar=0,"Common"
                        pcall(function()
                            if p and p.RarityRankForCategory then tier=p.RarityRankForCategory(eg.AssetCategory or "Egg")or 0 end
                            if p and p.Assets and p.Assets[eg.AssetCategory or "Egg"]then
                                local a2=p.Assets[eg.AssetCategory or "Egg"]
                                rar=a2.Rarity or(a2.Egg and a2.Egg.Rarity)or "Common"
                            end
                        end)
                        if rar=="Unknown"or rar==""then rar="Common"end
                        if tier>=h.espMinRarity then
                            local part=eg.PhysicalModel and(eg.PhysicalModel:FindFirstChildWhichIsA("BasePart")or eg.PhysicalModel.PrimaryPart)
                            if part then
                                local zone=eg.AreaId or "Field"
                                espMake(part,tier,rar,eg.AssetCategory or "Egg",zone)
                            end
                        end
                    end
                end
            end
            local hrp=o.Character and o.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _,bb in ipairs(espFolder:GetChildren())do
                    if bb:IsA("BillboardGui")and bb.Adornee then
                        local dist=math.floor((hrp.Position-bb.Adornee.Position).Magnitude)
                        local bg=bb:FindFirstChildWhichIsA("Frame")
                        if bg then
                            local dl=bg:FindFirstChild("DistLabel")
                            if dl then
                                local parts=string.split(dl.Text," | ")
                                dl.Text=(parts[1]or"").." | "..dist.."m"
                            end
                        end
                    end
                end
            end
        else
            if espFolder then espFolder:Destroy()espFolder=nil end
        end
        task.wait(1.5)
    end
end)
w.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if not h.masterKeybinds then return end
    local kc=inp.KeyCode
    local kb=h.keybinds
    if kc==kb.Tween then
        if h.pureTweenFarm then T4("NONE")else T4("TWEEN")end
    elseif kc==kb.Warp then
        if h.autoFarmLoop then T4("NONE")else T4("WARP")end
    elseif kc==kb.Place then
        task.spawn(function()g4(h.glideSpeed)v4()end)
    elseif kc==kb.Unstuck then
        pcall(M4)pcall(C4)pcall(D4)
    elseif kc==kb.ESP then
        h.eggESP=not h.eggESP
        if h.eggESP and(not espFolder or not espFolder.Parent)then espClear()end
    elseif kc==kb.Watermark then
        h.watermark=not h.watermark
    elseif kc==kb.Hop then
        pcall(function()
            local servers=useReqFn and useReqFn({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
            if servers and servers.Body then
                local list=a:JSONDecode(servers.Body)
                if list and list.data then
                    for _,srv in ipairs(list.data)do
                        if srv.id~=game.JobId and srv.playing<srv.maxPlayers then
                            h.stats.hops=h.stats.hops+1
                            TeleportService:TeleportToPlaceInstance(game.PlaceId,srv.id,o)
                            return
                        end
                    end
                end
            end
        end)
    elseif kc==kb.Panic then
        aM()
    end
end)
local Sk="iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAedEVYdFNvZnR3YXJlAFBhaW50Lk5FVCB2My41LjEw/7R3GwAAA6BJREFUeN7tW01oE1EQnk0qih4sevCiF/Wg4kEPgqeCHsSDhyIeVIoHDx48KIKHIh48ePAgePBiPRQ8eBA8COJBD4L4B8WD4kHxov7cm2yT3WzeZjdps7t58CG72bebzPfevPlmdg3DMFwul8vlcv13qampWSKi82S2kxgiVpLZZ2T2G5lDZHaRmU9mDxEViOgqEZ1Np9N3V1ZWLlutFh1vNJvN5+12+4bf77+s/p5zIuKCiAgiGhcRLkRkCRkH+rYikYjlOE7G87w/wWBwLxKJbIeDk8mky3q31xG/37/FwR1Fq9V6Q0SX1N9tIuKNiKgiIo/bbrfb+zwez44qchRzHMcioh2Xy6Xb7fYDIsrqu5WIeBDRoohwJ2VlZaWRSCS2VNEdzZTL5ctEdF1V5Yj4QUQ8EXG73e51j8ejiojOa/V6/ZaI7tDfvUS0SUQJEXFeRNRUVVW5mZmZe/R7kZ2cTCZ1vV4/yXfO/4eQeC4iWqpQKJRkZWWl9XrdISJDRMKIyKqqqjIjI2Pj4uLiGef8lMvlYg4eE9E1VVVP9ff/c5z4n04Gg0F3PB7/TkR5dF6k4/F4v9frdc3NzbV1XW/R/2lEVBER91RVVV1TU8OHr1gsVpP198lkct5xnM/q73kiOq+O37G6uvrVdV2u1+vv6XkRkS8UCr3xeDybyuVydWVlZZlOp9v0/y/O+X41538j1b+/qKurW1bVjYg4b0xMTKyqPZ8gIs7pYx7e1/V6/bKa1xEi6k9OTnZVVVW/IqI7RLRJRHkikVhyHGdBVff9+/cf6LpOU1NTD/T3NBFxRkR00Xm1Xq/fV0U+JqK/RETJ7OzsM7vdzhw81nW9RURDRHSpWCze13Wd6/X6bVV0u6qq6mUkEtnSdV3S10z9vUtE3InpdPrB8vLybSLiTk5OTg1tQ7eP8+jo6Jqqwscikcj2wsLCGuf8FBFxJycnJ7sNDQ1rV1dXWzQ4JCKHqnK6XC5bVfS06rp+k6ry8ZWVFR4eHl4jIs4jIyN9hmF81HX9B1Xl9MTERD8RcfN4PDupVOq+67pP1H1bJpPpvb6+7hPRfVVVV0ZGRtiVlRWWSCReZ7PZX36//6Cvr48PDQ09y2azVzwez7Kqqk8556fdbvdnItpVVdUaGRmZoKqaoP6sUjKZ3B8YGGBd122qyu3j/Ojo6F1N034MDAyw6elpW1VVLhQKzH1HRkZ6m4qKiicikajlOI7ler3e9y6X643L5dqi/+NyuZ6rqvpOVdV/Kysr51wu17fW3w8AAAD//wMAe7/lQy8mR0AAAAAElFTkSuQmCC"
local function Zk(e2)
    if crypt and crypt.base64decode then return crypt.base64decode(e2)end
    if base64_decode then return base64_decode(e2)end
    if syn and(syn.crypt and(syn.crypt.base64 and syn.crypt.base64.decode))then return syn.crypt.base64.decode(e2)end
    local r2="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local y2={}
    for e3=1,#r2,1 do y2[r2:sub(e3,e3)]=e3-1 end
    e2=(e2:gsub("[^"..(r2.."=]"),"")):gsub("=","")
    local u2={}
    for r3=1,#e2,4 do
        local j2=y2[e2:sub(r3,r3)]or 0
        local k2=y2[e2:sub(r3+1,r3+1)]or 0
        local a2=y2[e2:sub(r3+2,r3+2)]
        local o2=y2[e2:sub(r3+3,r3+3)]
        table.insert(u2,string.char(bit32.bor(bit32.lshift(j2,2),bit32.rshift(k2,4))))
        if a2 then
            table.insert(u2,string.char(bit32.bor(bit32.lshift(bit32.band(k2,15),4),bit32.rshift(a2,2))))
            if o2 then table.insert(u2,string.char(bit32.bor(bit32.lshift(bit32.band(a2,3),6),o2)))end
        end
    end
    return table.concat(u2)
end
local zk="Antraxdevz_Hub_Icon.png"
local dk="rbxassetid://10734950309"
pcall(function()
    if writefile and((getcustomasset or getsynasset))then
        local e2=getcustomasset or getsynasset
        if not((isfile and isfile(zk)))then writefile(zk,Zk(Sk))end
        dk=e2(zk)
    end
end)
local Xk=currentLang or "EN"
local Gk={
    EN={
        StatusTagReady="Status: Ready",
        Tabs={Farm="Auto Farm",EggSelect="Egg Selection",Character="Character",Settings="Settings"},
        EggSelect={SecZones="Target Zones",SecZonesDesc="Select zones to steal regular eggs from",DropZonesTitle="Selected Zones",DropZonesDesc="Click to choose zones",SecRarities="Target Rarities",SecRaritiesDesc="Select rarities",DropRaritiesTitle="Selected Rarities",DropRaritiesDesc="Click to choose",AlwaysSecretPlus="Always Steal Secret+",AlwaysSecretPlusDesc="Auto collect Secret+"},
        Farm={SecModes="Auto Steal Modes",TweenTitle="Auto Steal (Tween)",TweenDesc="Fly steal eggs on highway corridor",TeleportTitle="Auto Steal (Teleport)",TeleportDesc="Warp steal rapidly",SecPlace="Place & Hatch",PlaceTitle="Place Eggs",PlaceDesc="Fly home place stashed eggs",AutoPlaceTitle="Auto Place (Every 5)",AutoPlaceDesc="Return home every 5 steals",HatchTitle="Auto Hatch",HatchDesc="Hatch ready eggs",ReturnTitle="Auto Return",ReturnDesc="Fly back to safe area",AutoTreadmillTitle="Auto Treadmill",AutoTreadmillDesc="Run when no targets",UpgradeTreadmillTitle="Auto Upgrade Treadmill",UpgradeTreadmillDesc="Upgrade when enough cash",BuyTrailsTitle="Auto Buy & Equip Trails",BuyTrailsDesc="Best speed trail auto"},
        Character={SecSafety="Character & Safety",GodmodeTitle="Godmode",GodmodeDesc="Full immunity",UnstickTitle="Get Unstuck",UnstickDesc="Break free instantly",SecFlight="Flight Settings",SpeedTitle="Flight Speed",SpeedDesc="Cruise speed"},
    },
    TH={
        StatusTagReady="สถานะ: พร้อม",
        Tabs={Farm="ระบบฟาร์ม",EggSelect="เลือกไข่",Character="ตัวละคร",Settings="ตั้งค่า"},
        EggSelect={SecZones="โซนเป้าหมาย",SecZonesDesc="เลือกโซน",DropZonesTitle="โซนที่เลือก",DropZonesDesc="คลิกเลือก",SecRarities="ระดับหายาก",SecRaritiesDesc="เลือกระดับ",DropRaritiesTitle="ที่เลือก",DropRaritiesDesc="คลิกเลือก",AlwaysSecretPlus="Secret+ เสมอ",AlwaysSecretPlusDesc="เก็บ Secret+ อัตโนมัติ"},
        Farm={SecModes="โหมด",TweenTitle="บินเร็ว",TweenDesc="บินขโมยไข่",TeleportTitle="วาร์ป",TeleportDesc="วาร์ปขโมยไข่",SecPlace="วางและฟัก",PlaceTitle="วางไข่",PlaceDesc="บินกลับไปวาง",AutoPlaceTitle="วางทุก 5",AutoPlaceDesc="กลับบ้านทุก 5",HatchTitle="ฟักอัตโนมัติ",HatchDesc="ฟักเมื่อพร้อม",ReturnTitle="บินกลับ",ReturnDesc="กลับพื้นที่ปลอดภัย",AutoTreadmillTitle="วิ่งลู่วิ่ง",AutoTreadmillDesc="วิ่งเมื่อไม่มีเป้า",UpgradeTreadmillTitle="อัปเกรดลู่วิ่ง",UpgradeTreadmillDesc="อัปเกรดเมื่อมีเงิน",BuyTrailsTitle="ซื้อ Trail",BuyTrailsDesc="ซื้อ+ใส่ Trail ดีสุด"},
        Character={SecSafety="ความปลอดภัย",GodmodeTitle="อมตะ",GodmodeDesc="กันดาเมจ 100%",UnstickTitle="แก้ติด",UnstickDesc="หลุดทันที",SecFlight="บิน",SpeedTitle="ความเร็วบิน",SpeedDesc="ปรับความเร็ว"},
    },
}
local Fk={}
local hk,Ok,Yk,Tk
local xk={"Farm","EggSelect","Character","Settings"}
local function Wk(e2)
    local r2=(e2=="TH")
    if h.delivering then return r2 and "กำลังวางไข่"or "Placing Egg"
    elseif h.securingEgg or h.holdingEggForGuard then return r2 and "กำลังหยิบ"or "Securing Egg"
    elseif h.teleporting then return r2 and "วาร์ป"or "Teleporting"
    elseif h.isReturning then return r2 and "บินกลับ"or "Returning"
    elseif h.glidingToTarget then return r2 and "บินไปขโมย"or "Stealing"
    elseif h.onTreadmill or(L4 and L4())then return r2 and "บนลู่วิ่ง"or "On Treadmill"
    elseif Y4=="TWEEN"and not h.isReturning then return r2 and "หาไข่"or "Searching"
    elseif Y4=="WARP"and not h.isReturning then return r2 and "หาไข่"or "Searching"
    else return r2 and "พร้อม"or "Ready"end
end
local function mk(e2)
    pcall(function()
        if e2:IsA("TextLabel")or e2:IsA("TextButton")or e2:IsA("TextBox")then e2.AutoLocalize=false end
        for _,y2 in ipairs(e2:GetDescendants())do
            if y2:IsA("TextLabel")or y2:IsA("TextButton")or y2:IsA("TextBox")then y2.AutoLocalize=false end
        end
    end)
end
local function eM(e2,r2,y2)
    if not e2 then return end
    pcall(function()if r2 and e2.SetTitle then e2:SetTitle(r2)end if y2 and e2.SetDesc then e2:SetDesc(y2)end end)
    pcall(function()
        if e2.UIElements then
            if r2 and(e2.UIElements.Title and e2.UIElements.Title:IsA("TextLabel"))then e2.UIElements.Title.AutoLocalize=false e2.UIElements.Title.Text=r2 end
            if y2 and(e2.UIElements.Desc and e2.UIElements.Desc:IsA("TextLabel"))then e2.UIElements.Desc.AutoLocalize=false e2.UIElements.Desc.Text=y2 end
        end
    end)
end
local function rM(e2,r2,y2)
    pcall(function()
        if not e2 then return end
        if e2.UIElements and(e2.UIElements.Title and e2.UIElements.Title:IsA("TextLabel"))then e2.UIElements.Title.TextColor3=r2 end
        if e2.UIElements and e2.UIElements.ButtonIcon then
            local y3=e2.UIElements.ButtonIcon:FindFirstChildOfClass("ImageLabel")or e2.UIElements.ButtonIcon
            if y3 and y3:IsA("ImageLabel")then y3.ImageColor3=r2 end
        end
        local u2=nil
        if e2.ButtonFrame and(e2.ButtonFrame.UIElements and e2.ButtonFrame.UIElements.Main)then u2=e2.ButtonFrame.UIElements.Main
        elseif e2.ToggleFrame and(e2.ToggleFrame.UIElements and e2.ToggleFrame.UIElements.Main)then u2=e2.ToggleFrame.UIElements.Main
        elseif e2.ElementFrame then u2=e2.ElementFrame
        elseif e2.UIElements and e2.UIElements.Main then u2=e2.UIElements.Main end
        if u2 and u2:IsA("GuiObject")then
            local e3=u2:FindFirstChild("AccentCorner")or u2:FindFirstChildOfClass("UICorner")
            if e3 then e3:Destroy()end
            local j2=u2:FindFirstChild("AntraxAccentStroke")or u2:FindFirstChildOfClass("UIStroke")
            if j2 then j2:Destroy()end
            for _,r3 in ipairs(u2:GetDescendants())do
                if r3:IsA("ImageLabel")and((string.find(tostring(r3.Image),"117817408534198")or string.find(r3.Name:lower(),"outline")))then
                    r3.Visible=false
                    r3.ImageTransparency=1
                end
            end
            local a2=y2
            if not a2 then
                local e4,y3,u3=r2:ToHSV()
                a2=Color3.fromHSV(e4,math.clamp(y3*0.4,0.18,0.45),0.18)
            end
            u2.ThemeTag=nil
            u2.ImageColor3=a2
            u2.ImageTransparency=0.08
        end
    end)
end
local function yM()
    rM(Fk.togTween,PAL.orange,PAL.bg)
    rM(Fk.togTeleport,PAL.amber,PAL.bg)
    rM(Fk.btnPlaceEgg,PAL.success,PAL.bg)
    rM(Fk.togAutoPlaceEvery5,PAL.sky,PAL.bg)
    rM(Fk.togGodmode,PAL.rose,PAL.bg)
    rM(Fk.btnUnstick,PAL.amber,PAL.bg)
    rM(Fk.btnReset,PAL.indigo,PAL.bg)
    rM(Fk.btnLangSettings,PAL.orange,PAL.bg)
    rM(Fk.togAutoHatch,PAL.success,PAL.bg)
    rM(Fk.togAutoReturn,PAL.sky,PAL.bg)
    rM(Fk.togAutoTreadmill,PAL.amber,PAL.bg)
    rM(Fk.togAutoUpgradeTreadmill,PAL.orange,PAL.bg)
    rM(Fk.togAutoBuyTrails,PAL.magenta,PAL.bg)
    rM(Fk.togPerformance,PAL.sky,PAL.bg)
    rM(Fk.togDisable3D,PAL.orange,PAL.bg)
    rM(Fk.togAntiAFK,PAL.success,PAL.bg)
    rM(Fk.btnRejoin,PAL.rose,PAL.bg)
    rM(Fk.btnUnload,PAL.danger,PAL.bg)
end
local function uM(e2)
    local r2=e2 or Xk or "EN"
    local y2=Gk[r2]or Gk.EN
    local u2={hk,Ok,Yk,Tk}
    local w2={"Farm","EggSelect","Character","Settings"}
    for e3,r3 in ipairs(u2)do
        local u3=w2[e3]
        local k2=y2.Tabs[u3]or u3
        if r3 then
            r3.Title=k2
            pcall(function()if r3.SetTitle then r3:SetTitle(k2)end end)
            pcall(function()
                if r3.UIElements and r3.UIElements.Main then
                    for _,r4 in ipairs(r3.UIElements.Main:GetDescendants())do
                        if r4:IsA("TextLabel")then r4.AutoLocalize=false r4.Text=k2 end
                    end
                end
                if r3.UIElements and r3.UIElements.TabItem then
                    for _,r4 in ipairs(r3.UIElements.TabItem:GetDescendants())do
                        if r4:IsA("TextLabel")then r4.AutoLocalize=false r4.Text=k2 end
                    end
                end
            end)
        end
    end
    pcall(function()
        if Window and(Window.TabModule and Window.TabModule.Tabs)then
            for r3=1,#xk,1 do
                local u3=Window.TabModule.Tabs[r3]
                local w3=xk[r3]
                local j2=y2.Tabs[w3]or w3
                if u3 and j2 then
                    u3.Title=j2
                    if u3.UIElements and u3.UIElements.Main then
                        for _,r4 in ipairs(u3.UIElements.Main:GetDescendants())do
                            if r4:IsA("TextLabel")then r4.AutoLocalize=false r4.Text=j2 end
                        end
                    end
                    if u3.UIElements and u3.UIElements.TabItem then
                        for _,r4 in ipairs(u3.UIElements.TabItem:GetDescendants())do
                            if r4:IsA("TextLabel")then r4.AutoLocalize=false r4.Text=j2 end
                        end
                    end
                end
            end
        end
    end)
end
local function wM(e2)
    local r2=Gk[e2]or Gk.EN
    uM(e2)
    eM(Fk.secModes,r2.Farm.SecModes)
    eM(Fk.togTween,r2.Farm.TweenTitle,r2.Farm.TweenDesc)
    eM(Fk.togTeleport,r2.Farm.TeleportTitle,r2.Farm.TeleportDesc)
    eM(Fk.secPlace,r2.Farm.SecPlace)
    eM(Fk.btnPlaceEgg,r2.Farm.PlaceTitle,r2.Farm.PlaceDesc)
    eM(Fk.togAutoPlaceEvery5,r2.Farm.AutoPlaceTitle,r2.Farm.AutoPlaceDesc)
    eM(Fk.togAutoHatch,r2.Farm.HatchTitle,r2.Farm.HatchDesc)
    eM(Fk.togAutoReturn,r2.Farm.ReturnTitle,r2.Farm.ReturnDesc)
    eM(Fk.togAutoTreadmill,r2.Farm.AutoTreadmillTitle,r2.Farm.AutoTreadmillDesc)
    eM(Fk.togAutoUpgradeTreadmill,r2.Farm.UpgradeTreadmillTitle,r2.Farm.UpgradeTreadmillDesc)
    eM(Fk.togAutoBuyTrails,r2.Farm.BuyTrailsTitle,r2.Farm.BuyTrailsDesc)
    if r2.EggSelect then
        eM(Fk.secEggZones,r2.EggSelect.SecZones,r2.EggSelect.SecZonesDesc)
        eM(Fk.dropTargetZones,r2.EggSelect.DropZonesTitle,r2.EggSelect.DropZonesDesc)
        eM(Fk.secEggRarity,r2.EggSelect.SecRarities,r2.EggSelect.SecRaritiesDesc)
        eM(Fk.dropTargetRarities,r2.EggSelect.DropRaritiesTitle,r2.EggSelect.DropRaritiesDesc)
    end
    eM(Fk.secSafety,r2.Character.SecSafety)
    eM(Fk.togGodmode,r2.Character.GodmodeTitle,r2.Character.GodmodeDesc)
    eM(Fk.btnUnstick,r2.Character.UnstickTitle,r2.Character.UnstickDesc)
    eM(Fk.secFlight,r2.Character.SecFlight)
    eM(Fk.sliderSpeed,r2.Character.SpeedTitle,r2.Character.SpeedDesc)
    yM()
end
local function jM()
    local e2=Instance.new("ScreenGui")
    e2.Name="Antraxdevz_LOADER"
    e2.ResetOnSpawn=false
    e2.DisplayOrder=9999999
    e2.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    e2.AutoLocalize=false
    pcall(function()if syn and syn.protect_gui then syn.protect_gui(e2)e2.Parent=game:GetService("CoreGui")else e2.Parent=o:FindFirstChild("PlayerGui")or game:GetService("CoreGui")end end)
    if not e2.Parent then e2.Parent=game:GetService("CoreGui")end
    local r2=Instance.new("Frame")
    r2.Name="Card"
    r2.Size=UDim2.fromOffset(380,210)
    r2.Position=UDim2.new(0.5,-190,0.5,-105)
    r2.BackgroundColor3=PAL.bg
    r2.BorderSizePixel=0
    r2.Parent=e2
    Instance.new("UICorner",r2).CornerRadius=UDim.new(0,18)
    local y2=Instance.new("UIStroke",r2)
    y2.Color=Color3.new(1,1,1)
    y2.Thickness=1.8
    y2.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    grad(y2,PAL.orange,PAL.amber,135)
    local inner=Instance.new("Frame",r2)
    inner.Size=UDim2.fromScale(1,1)
    inner.BackgroundColor3=PAL.orange
    inner.BackgroundTransparency=0.95
    inner.BorderSizePixel=0
    inner.ZIndex=0
    Instance.new("UICorner",inner).CornerRadius=UDim.new(0,18)
    local w2=Instance.new("TextLabel",r2)
    w2.Size=UDim2.new(1,-32,0,30)
    w2.Position=UDim2.new(0,16,0,20)
    w2.BackgroundTransparency=1
    w2.Text="ANTRAXDEVZ"
    w2.TextColor3=PAL.text
    w2.TextSize=24
    w2.Font=Enum.Font.GothamBlack
    w2.TextXAlignment=Enum.TextXAlignment.Left
    w2.AutoLocalize=false
    grad(w2,PAL.orange,PAL.amber,0)
    local j2=Instance.new("TextLabel",r2)
    j2.Size=UDim2.new(1,-32,0,16)
    j2.Position=UDim2.new(0,16,0,52)
    j2.BackgroundTransparency=1
    j2.Text="Steal an Egg Suite  |  "..BRAND_VER
    j2.TextColor3=PAL.textDim
    j2.TextSize=12
    j2.Font=Enum.Font.GothamMedium
    j2.TextXAlignment=Enum.TextXAlignment.Left
    j2.AutoLocalize=false
    local chip=Instance.new("TextButton",r2)
    chip.Size=UDim2.new(1,-32,0,30)
    chip.Position=UDim2.new(0,16,0,80)
    chip.BackgroundColor3=PAL.surface2
    chip.Text=""
    chip.AutoButtonColor=false
    chip.AutoLocalize=false
    Instance.new("UICorner",chip).CornerRadius=UDim.new(0,8)
    local chipS=Instance.new("UIStroke",chip)
    chipS.Color=PAL.orange
    chipS.Thickness=1.2
    local chipL=Instance.new("TextLabel",chip)
    chipL.Size=UDim2.new(1,-16,1,0)
    chipL.Position=UDim2.new(0,12,0,0)
    chipL.BackgroundTransparency=1
    chipL.Text="TELEGRAM  |  "..BRAND_TG_TAG
    chipL.TextColor3=PAL.orange
    chipL.TextSize=12
    chipL.Font=Enum.Font.GothamBold
    chipL.TextXAlignment=Enum.TextXAlignment.Left
    chipL.AutoLocalize=false
    chip.MouseButton1Click:Connect(function()openTelegram()end)
    local k2=Instance.new("TextLabel",r2)
    k2.Size=UDim2.fromOffset(60,26)
    k2.Position=UDim2.new(1,-76,0,22)
    k2.BackgroundTransparency=1
    k2.Text="0%"
    k2.TextColor3=PAL.orange
    k2.TextSize=16
    k2.Font=Enum.Font.GothamBold
    k2.TextXAlignment=Enum.TextXAlignment.Right
    k2.AutoLocalize=false
    local a2=Instance.new("Frame",r2)
    a2.Size=UDim2.new(1,-32,0,10)
    a2.Position=UDim2.new(0,16,0,124)
    a2.BackgroundColor3=PAL.surface2
    a2.BorderSizePixel=0
    Instance.new("UICorner",a2).CornerRadius=UDim.new(1,0)
    local V2=Instance.new("Frame",a2)
    V2.Size=UDim2.new(0,0,1,0)
    V2.BackgroundColor3=PAL.orange
    V2.BorderSizePixel=0
    Instance.new("UICorner",V2).CornerRadius=UDim.new(1,0)
    grad(V2,PAL.orange,PAL.amber,0)
    local shimmer=Instance.new("Frame",V2)
    shimmer.Size=UDim2.new(0.4,0,1,0)
    shimmer.Position=UDim2.new(-0.5,0,0,0)
    shimmer.BackgroundColor3=Color3.new(1,1,1)
    shimmer.BackgroundTransparency=0.85
    shimmer.BorderSizePixel=0
    Instance.new("UICorner",shimmer).CornerRadius=UDim.new(1,0)
    task.spawn(function()
        while shimmer.Parent and shimmer.Parent.Parent do
            u:Create(shimmer,TweenInfo.new(0.9,Enum.EasingStyle.Linear),{Position=UDim2.new(1.1,0,0,0)}):Play()
            task.wait(0.9)
            shimmer.Position=UDim2.new(-0.5,0,0,0)
        end
    end)
    local t2=Instance.new("TextLabel",r2)
    t2.Size=UDim2.new(1,-32,0,16)
    t2.Position=UDim2.new(0,16,0,142)
    t2.BackgroundTransparency=1
    t2.Text="Initializing..."
    t2.TextColor3=PAL.textMute
    t2.TextSize=11
    t2.Font=Enum.Font.GothamMedium
    t2.TextXAlignment=Enum.TextXAlignment.Left
    t2.AutoLocalize=false
    local creds=Instance.new("TextLabel",r2)
    creds.Size=UDim2.new(1,-32,0,14)
    creds.Position=UDim2.new(0,16,0,178)
    creds.BackgroundTransparency=1
    creds.Text="t.me/AntraxdevZ"
    creds.TextColor3=PAL.orange
    creds.TextSize=10
    creds.Font=Enum.Font.GothamBold
    creds.TextXAlignment=Enum.TextXAlignment.Left
    creds.AutoLocalize=false
    task.spawn(function()
        for y3=1,100,1 do
            if not e2.Parent then break end
            k2.Text=tostring(y3).."%"
            V2.Size=UDim2.new(y3/100,0,1,0)
            if y3==25 then t2.Text="Loading interface modules..."
            elseif y3==60 then t2.Text="Setting up auto-steal controllers..."
            elseif y3==85 then t2.Text="Syncing server telemetry..."
            elseif y3==100 then t2.Text="Ready!"end
            task.wait(0.008)
        end
    end)
    local function fin(o2)
        task.spawn(function()
            task.wait(0.9)
            local T2=TweenInfo.new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
            for _,obj in ipairs({r2,y2,inner,w2,j2,k2,a2,V2,shimmer,t2,chip,chipS,chipL,creds})do
                pcall(function()
                    if obj:IsA("GuiObject")then u:Create(obj,T2,{BackgroundTransparency=1}):Play()
                    elseif obj:IsA("TextLabel")or obj:IsA("TextButton")then u:Create(obj,T2,{TextTransparency=1,BackgroundTransparency=1}):Play()end
                end)
            end
            task.wait(0.4)
            pcall(function()e2:Destroy()end)
            if o2 then o2()end
        end)
    end
    return fin
end
local kM={}
kM.Gui=Instance.new("ScreenGui")
kM.Gui.Name="Antraxdevz_RESTORE"
kM.Gui.ResetOnSpawn=false
kM.Gui.DisplayOrder=999999
kM.Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
kM.Gui.AutoLocalize=false
pcall(function()if syn and syn.protect_gui then syn.protect_gui(kM.Gui)kM.Gui.Parent=game:GetService("CoreGui")else kM.Gui.Parent=o:FindFirstChild("PlayerGui")or game:GetService("CoreGui")end end)
if not kM.Gui.Parent then kM.Gui.Parent=game:GetService("CoreGui")end
kM.Btn=Instance.new("ImageButton")
kM.Btn.Name="Antraxdevz_SquareLogoButton"
kM.Btn.Size=UDim2.fromOffset(46,46)
kM.Btn.Position=UDim2.new(0,20,0,20)
kM.Btn.BackgroundColor3=PAL.surface
kM.Btn.Active=true
kM.Btn.Visible=false
kM.Btn.ZIndex=999999
kM.Btn.AutoLocalize=false
kM.Btn.Parent=kM.Gui
Instance.new("UICorner",kM.Btn).CornerRadius=UDim.new(0,12)
kM.Stroke=Instance.new("UIStroke",kM.Btn)
kM.Stroke.Color=Color3.new(1,1,1)
kM.Stroke.Thickness=1.6
kM.Stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
grad(kM.Stroke,PAL.orange,PAL.amber,135)
kM.Logo=Instance.new("ImageLabel",kM.Btn)
kM.Logo.Size=UDim2.fromOffset(36,36)
kM.Logo.Position=UDim2.new(0.5,0,0.5,0)
kM.Logo.AnchorPoint=Vector2.new(0.5,0.5)
kM.Logo.BackgroundTransparency=1
kM.Logo.Image=dk
kM.Logo.ImageColor3=Color3.new(1,1,1)
kM.Logo.ZIndex=1000000
Instance.new("UICorner",kM.Logo).CornerRadius=UDim.new(0,8)
kM.TG=Instance.new("ImageButton")
kM.TG.Name="Antraxdevz_TGButton"
kM.TG.Size=UDim2.fromOffset(46,46)
kM.TG.Position=UDim2.new(0,20,0,80)
kM.TG.BackgroundColor3=PAL.orange
kM.TG.Active=true
kM.TG.Visible=true
kM.TG.ZIndex=999999
kM.TG.AutoLocalize=false
kM.TG.Parent=kM.Gui
Instance.new("UICorner",kM.TG).CornerRadius=UDim.new(0,12)
local tgS=Instance.new("UIStroke",kM.TG)
tgS.Color=PAL.amber
tgS.Thickness=1.8
grad(kM.TG,PAL.orange,PAL.amber,135)
local tgL=Instance.new("TextLabel",kM.TG)
tgL.Size=UDim2.fromScale(1,1)
tgL.BackgroundTransparency=1
tgL.Text="TG"
tgL.TextColor3=Color3.new(1,1,1)
tgL.TextSize=14
tgL.Font=Enum.Font.GothamBlack
tgL.ZIndex=1000000
tgL.AutoLocalize=false
kM.TG.MouseEnter:Connect(function()u:Create(kM.TG,TweenInfo.new(0.15),{Size=UDim2.fromOffset(50,50),Position=UDim2.new(0,18,0,78)}):Play()end)
kM.TG.MouseLeave:Connect(function()u:Create(kM.TG,TweenInfo.new(0.15),{Size=UDim2.fromOffset(46,46),Position=UDim2.new(0,20,0,80)}):Play()end)
kM.TG.MouseButton1Click:Connect(function()openTelegram()end)
kM.isDragging=false
kM.dragStart=nil
kM.startPos=nil
kM.Btn.InputBegan:Connect(function(e2)
    if e2.UserInputType==Enum.UserInputType.MouseButton1 or e2.UserInputType==Enum.UserInputType.Touch then
        kM.isDragging=true
        kM.dragStart=e2.Position
        kM.startPos=kM.Btn.Position
    end
end)
w.InputEnded:Connect(function(e2)
    if e2.UserInputType==Enum.UserInputType.MouseButton1 or e2.UserInputType==Enum.UserInputType.Touch then kM.isDragging=false end
end)
w.InputChanged:Connect(function(e2)
    if kM.isDragging and((e2.UserInputType==Enum.UserInputType.MouseMovement or e2.UserInputType==Enum.UserInputType.Touch))then
        local y2=e2.Position-kM.dragStart
        kM.Btn.Position=UDim2.new(kM.startPos.X.Scale,kM.startPos.X.Offset+y2.X,kM.startPos.Y.Scale,kM.startPos.Y.Offset+y2.Y)
    end
end)
local function aM()
    h.alive=false
    pcall(Ik)
    pcall(Ak)
    pcall(function()y:Set3dRenderingEnabled(true)end)
    pcall(function()local y2=r:FindFirstChild("Antraxdevz_EggESP")if y2 then y2:Destroy()end end)
    pcall(D4)
    pcall(u4)
    if kM and kM.Gui then pcall(function()kM.Gui:Destroy()end)end
    if wmGui then pcall(function()wmGui:Destroy()end)end
    if toastGui then pcall(function()toastGui:Destroy()end)end
    if h.gui then pcall(function()h.gui:Destroy()end)end
    pcall(function()
        for _,y2 in ipairs(game.CoreGui:GetChildren())do
            if y2.Name:find("Antraxdevz_")or y2.Name:find("DesyncSniper")or y2.Name:find("WindUI")then y2:Destroy()end
        end
    end)
end
local function oM()
    local e2=jM()
    local r2=nil
    pcall(function()r2=(loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua")))()end)
    local function notify(e3)
        if not e3 then return end
        local y2=false
        if r2 and r2.Notify then pcall(function()r2:Notify(e3)y2=true end)end
        if not y2 then pcall(function()game:GetService("StarterGui"):SetCore("SendNotification",{Title=tostring(e3.Title or BRAND_NAME),Text=tostring(e3.Content or""),Duration=3})end)end
        toast(e3.Title or BRAND_NAME,e3.Content or"")
    end
    local j2=notify
    if r2 then
        pcall(function()
            local e3=r2.Notify
            if e3 then
                r2.Notify=function(r3,y2)
                    pcall(function()e3(r3,y2)end)
                    toast(y2 and y2.Title or BRAND_NAME,y2 and y2.Content or"")
                end
            end
        end)
        local k2=workspace.CurrentCamera
        local a2=k2 and k2.ViewportSize or Vector2.new(1280,720)
        local V2=w.TouchEnabled and not w.KeyboardEnabled
        local H2=V2 and math.clamp(a2.X*0.7,440,500)or 500
        local t2=V2 and math.clamp(a2.Y*0.72,280,340)or 340
        local s2=UDim2.fromOffset(H2,t2)
        local pp=r2:CreateWindow({Title="ANTRAXDEVZ",Author=BRAND_TG_TAG,Folder="Antraxdevz_StealAnEgg",Icon=dk,Theme="Dark",IconSize=28,Size=s2,MinSize=Vector2.new(400,240),MaxSize=Vector2.new(900,600),Resizable=true,SideBarWidth=V2 and 140 or 160,ToggleKey=Enum.KeyCode.RightShift,IgnoreAlerts=true,Topbar={Height=44,ButtonsType="Default"}})
        Window=pp
        pp.IgnoreAlerts=true
        pcall(function()if pp.UIElements and pp.UIElements.Main then pp.UIElements.Main.Visible=false end end)
        local B2=pp:Tag({Title="Status: Ready",Color=PAL.success,Border=true})
        local J2=44
        local K2=false
        local c2=false
        local v2=t2
        task.spawn(function()
            task.wait(0.1)
            local e3=pp.UIElements and pp.UIElements.Main
            if e3 then
                if e3.AnchorPoint.Y~=0 then
                    local y2=e3.Size.Y.Offset>0 and e3.Size.Y.Offset or t2
                    e3.Position=UDim2.new(e3.Position.X.Scale,e3.Position.X.Offset,e3.Position.Y.Scale,e3.Position.Y.Offset-(y2*e3.AnchorPoint.Y))
                    e3.AnchorPoint=Vector2.new(0.5,0)
                end
                e3.ClipsDescendants=false
                mk(e3)
            end
        end)
        local function minimize()
            local e3=pp.UIElements and pp.UIElements.Main
            if not e3 or c2 then return end
            c2=true
            K2=not K2
            local r3=pp.UIElements.SideBarContainer
            local y2=pp.UIElements.MainBar
            local w2=e3:FindFirstChild("Background")
            local j3=e3:FindFirstChild("Main")
            if e3.AnchorPoint.Y~=0 then
                local r4=e3.Size.Y.Offset>0 and e3.Size.Y.Offset or v2
                e3.Position=UDim2.new(e3.Position.X.Scale,e3.Position.X.Offset,e3.Position.Y.Scale,e3.Position.Y.Offset-(r4*e3.AnchorPoint.Y))
                e3.AnchorPoint=Vector2.new(0.5,0)
            end
            local k3=e3.Size.X.Scale
            local a3=e3.Size.X.Offset
            if K2 then
                if e3.Size.Y.Offset>J2 then v2=e3.Size.Y.Offset end
                e3.ClipsDescendants=true
                if w2 then w2.ClipsDescendants=true end
                if j3 then j3.ClipsDescendants=true end
                if r3 then r3.Visible=false end
                if y2 then y2.Visible=false end
                e3.Visible=true
                if j3 then j3.Visible=true end
                local V3=u:Create(e3,TweenInfo.new(0.24,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(k3,a3,0,J2)})
                V3:Play()
                task.delay(0.25,function()c2=false end)
            else
                e3.Visible=true
                if j3 then j3.Visible=true end
                local V3=v2 or t2
                if r3 then r3.Visible=true end
                if y2 then y2.Visible=true end
                if pp.TabModule and pp.TabModule.SelectedTab then pcall(function()pp.TabModule:SelectTab(pp.TabModule.SelectedTab)end)end
                local H3=u:Create(e3,TweenInfo.new(0.24,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(k3,a3,0,V3)})
                H3:Play()
                task.delay(0.25,function()
                    if not K2 then
                        e3.ClipsDescendants=false
                        if w2 then w2.ClipsDescendants=false end
                        if j3 then j3.ClipsDescendants=false end
                        if r3 then r3.Visible=true end
                        if y2 then y2.Visible=true end
                        if pp.TabModule and pp.TabModule.SelectedTab then pcall(function()pp.TabModule:SelectTab(pp.TabModule.SelectedTab)end)end
                    end
                    c2=false
                end)
            end
        end
        pp.Close=function()
            minimize()
            local r3={}
            function r3.Destroy()aM()end
            return r3
        end
        local function restore()
            if pp.UIElements and pp.UIElements.Main then
                u:Create(kM.Btn,TweenInfo.new(0.12,Enum.EasingStyle.Quart),{Size=UDim2.fromOffset(42,42)}):Play()
                task.wait(0.08)
                kM.Btn.Size=UDim2.fromOffset(46,46)
                pp.UIElements.Main.Visible=true
                kM.Btn.Visible=false
                if pp.TabModule and pp.TabModule.SelectedTab then pcall(function()pp.TabModule:SelectTab(pp.TabModule.SelectedTab)end)end
            end
        end
        local function hide()
            if pp.UIElements and pp.UIElements.Main then
                pp.UIElements.Main.Visible=false
                kM.Btn.Visible=true
            end
        end
        kM.Btn.MouseButton1Click:Connect(restore)
        pp.Destroy=function()hide()end
        w.InputBegan:Connect(function(e3,r3)
            if not r3 and e3.KeyCode==Enum.KeyCode.RightShift then
                if pp.UIElements and pp.UIElements.Main then
                    if pp.UIElements.Main.Visible then hide()else restore()end
                end
            end
        end)
        local function setTransparency(e3)
            local r3=math.clamp(tonumber(e3)or 0,0,90)
            local y2=r3/100
            pcall(function()
                local e4=pp.UIElements and pp.UIElements.Main
                if not e4 then return end
                if pp.AcrylicPaint and pp.AcrylicPaint.Frame then pp.AcrylicPaint.Frame.Visible=(r3==0)end
                local u2=e4:FindFirstChild("Background")
                if u2 then
                    if u2:IsA("ImageLabel")then u2.ImageTransparency=y2
                    elseif u2:IsA("Frame")then u2.BackgroundTransparency=y2 end
                end
            end)
        end
        local P2=Gk[Xk]or Gk.EN
        hk=pp:Tab({Title=P2.Tabs.Farm,Icon="solar:box-minimalistic-bold"})
        Ok=pp:Tab({Title=P2.Tabs.EggSelect or "Egg Selection",Icon="lucide:egg"})
        Yk=pp:Tab({Title=P2.Tabs.Character,Icon="solar:user-bold"})
        Tk=pp:Tab({Title=P2.Tabs.Settings,Icon="solar:settings-bold"})
        Fk.secModes=hk:Section({Title=P2.Farm.SecModes})
        local N2=false
        local U2=nil
        local ll=nil
        Fk.togTween=hk:Toggle({Title=P2.Farm.TweenTitle,Desc=P2.Farm.TweenDesc,Icon="solar:compass-bold",Value=h.pureTweenFarm,Callback=function(e3)
            if N2 then return end
            if e3 then T4("TWEEN")
            else if Y4=="TWEEN"or h.pureTweenFarm then T4("NONE")end end
        end})
        U2=Fk.togTween
        Fk.togTeleport=hk:Toggle({Title=P2.Farm.TeleportTitle,Desc=P2.Farm.TeleportDesc,Icon="solar:magic-stick-3-bold",Value=h.autoFarmLoop,Callback=function(e3)
            if N2 then return end
            if e3 then T4("WARP")
            else if Y4=="WARP"or h.autoFarmLoop then T4("NONE")end end
        end})
        ll=Fk.togTeleport
        x4=function(e3)pcall(function()if U2 and U2.Set then N2=true U2:Set(e3)N2=false end end)end
        W4=function(e3)pcall(function()if ll and ll.Set then N2=true ll:Set(e3)N2=false end end)end
        Fk.secPlace=hk:Section({Title=P2.Farm.SecPlace})
        Fk.btnPlaceEgg=hk:Button({Title=P2.Farm.PlaceTitle,Desc=P2.Farm.PlaceDesc,Icon="solar:box-bold",Callback=function()
            task.spawn(function()
                j2({Title=BRAND_NAME,Content="Tweening to base...",Icon="loader"})
                h.statusText="[Manual] Depositing..."
                g4(h.glideSpeed,nil,true)
                v4()
                j2({Title=BRAND_NAME,Content="Placed & Hatched",Icon="check-circle"})
            end)
        end})
        Fk.togAutoPlaceEvery5=hk:Toggle({Title=P2.Farm.AutoPlaceTitle or "Auto Place (Every 5)",Desc=P2.Farm.AutoPlaceDesc or "Return home every 5 steals",Icon="solar:box-minimalistic-bold",Value=h.autoPlaceEvery5,Callback=function(e3)
            h.autoPlaceEvery5=e3
            if not e3 then h.batchStealCount=0 end
            j2({Title="AutoPlace",Content=e3 and "Enabled"or "Disabled"})
        end})
        Fk.togAutoHatch=hk:Toggle({Title=P2.Farm.HatchTitle,Desc=P2.Farm.HatchDesc,Icon="solar:star-bold",Value=h.autoHatch,Callback=function(e3)
            h.autoHatch=e3
            j2({Title="AutoHatch",Content=e3 and "Enabled"or "Disabled"})
        end})
        Fk.togAutoReturn=hk:Toggle({Title=P2.Farm.ReturnTitle,Desc=P2.Farm.ReturnDesc,Icon="solar:undo-left-round-bold",Value=h.autoGlide,Callback=function(e3)h.autoGlide=e3 end})
        Fk.togAutoTreadmill=hk:Toggle({Title=P2.Farm.AutoTreadmillTitle or "Auto Treadmill",Desc=P2.Farm.AutoTreadmillDesc or "Run when idle",Icon="solar:running-bold",Value=h.autoTreadmill,Callback=function(e3)
            h.autoTreadmill=e3
            x()
            n4()
            if not e3 and((h.onTreadmill or L4()))then M4()end
            j2({Title="Treadmill",Content=e3 and "Enabled"or "Disabled"})
        end})
        Fk.togAutoUpgradeTreadmill=hk:Toggle({Title=P2.Farm.UpgradeTreadmillTitle or "Auto Upgrade Treadmill",Desc=P2.Farm.UpgradeTreadmillDesc or "Upgrade when cash allows",Icon="solar:double-alt-arrow-up-bold",Value=h.autoUpgradeTreadmill,Callback=function(e3)h.autoUpgradeTreadmill=e3 x()end})
        Fk.togAutoBuyTrails=hk:Toggle({Title=P2.Farm.BuyTrailsTitle or "Auto Buy & Equip Trails",Desc=P2.Farm.BuyTrailsDesc or "Best speed trail auto",Icon="solar:fire-bold",Value=h.autoBuyTrails,Callback=function(e3)h.autoBuyTrails=e3 x()end})
        Fk.secEggZones=Ok:Section({Title=(P2.EggSelect and P2.EggSelect.SecZones)or "Target Zones"})
        local D2={"Light Dark","Titan Temple","Cherry Blossom","Cosmic","Prehistoric","Abyss Ocean","Volcano","Snow","Jungle","Desert","Lake","Forest"}
        local C2={["Light Dark"]="Light Dark",["Titan Temple"]="Titan Temple",["Cherry Blossom"]="Cherry Blossom",["Cosmic"]="Cosmic",["Prehistoric"]="Prehistoric",["Abyss Ocean"]="Abyss Ocean",["Volcano"]="Volcano",["Snow"]="Snow",["Jungle"]="Jungle",["Desert"]="Desert",["Lake"]="Lake",["Forest"]="Forest"}
        local q2={["Light Dark"]="Light Dark",["Titan Temple"]="Titan Temple",["Cherry Blossom"]="Cherry Blossom",["Cosmic"]="Cosmic",["Prehistoric"]="Prehistoric",["Abyss Ocean"]="Abyss Ocean",["Volcano"]="Volcano",["Snow"]="Snow",["Jungle"]="Jungle",["Desert"]="Desert",["Lake"]="Lake",["Forest"]="Forest"}
        local n2={}
        for e3,r3 in pairs(h.selectedZones or{})do if r3 and q2[e3]then table.insert(n2,q2[e3])end end
        Fk.dropTargetZones=Ok:Dropdown({Title=(P2.EggSelect and P2.EggSelect.DropZonesTitle)or "Selected Zones",Desc=(P2.EggSelect and P2.EggSelect.DropZonesDesc)or "Click to choose",Values=D2,Value=n2,Multi=true,Callback=function(e3)
            local r3={}
            local function y2(e4)
                if type(e4)=="table"then e4=e4.Title or e4.Name or e4[1]or""end
                local y3=tostring(e4 or"")
                local w2=C2[y3]
                if not w2 and(y3~=""and(y3~="true"and y3~="false"))then
                    for _,r4 in ipairs(M)do if string.find(string.lower(y3),string.lower(r4))then w2=r4 break end end
                end
                if w2 and f[w2]then r3[w2]=true end
            end
            if type(e3)=="table"then
                for e4,r4 in pairs(e3)do
                    if type(r4)=="string"or type(r4)=="table"then y2(r4)
                    elseif type(e4)=="string"and r4==true then y2(e4)end
                end
            elseif type(e3)=="string"then y2(e3)end
            h.selectedZones=r3
            x()
        end})
        Fk.secEggRarity=Ok:Section({Title=(P2.EggSelect and P2.EggSelect.SecRarities)or "Target Rarities"})
        local I2={"Divine (Tier 6)","Eternal (Tier 5)","Secret (Tier 4)","Cosmic (Tier 3)","Mythic (Tier 2)","Legendary (Tier 1)","Epic","Rare","Uncommon","Common"}
        local L2={["Divine (Tier 6)"]="Divine",["Eternal (Tier 5)"]="Eternal",["Secret (Tier 4)"]="Secret",["Cosmic (Tier 3)"]="Cosmic",["Mythic (Tier 2)"]="Mythic",["Legendary (Tier 1)"]="Legendary",["Epic"]="Epic",["Rare"]="Rare",["Uncommon"]="Uncommon",["Common"]="Common"}
        local E2={["Divine"]="Divine (Tier 6)",["Eternal"]="Eternal (Tier 5)",["Secret"]="Secret (Tier 4)",["Cosmic"]="Cosmic (Tier 3)",["Mythic"]="Mythic (Tier 2)",["Legendary"]="Legendary (Tier 1)",["Epic"]="Epic",["Rare"]="Rare",["Uncommon"]="Uncommon",["Common"]="Common"}
        local b2={}
        for e3,r3 in pairs(h.selectedRarities or{})do if r3 and E2[e3]then table.insert(b2,E2[e3])end end
        Fk.dropTargetRarities=Ok:Dropdown({Title=(P2.EggSelect and P2.EggSelect.DropRaritiesTitle)or "Selected Rarities",Desc=(P2.EggSelect and P2.EggSelect.DropRaritiesDesc)or "Click to choose",Values=I2,Value=b2,Multi=true,Callback=function(e3)
            local r3={}
            local function y2(e4)
                if type(e4)=="table"then e4=e4.Title or e4.Name or e4[1]or""end
                local y3=string.lower(tostring(e4 or""))
                for _,u2 in ipairs(X)do if string.find(y3,string.lower(u2))then r3[u2]=true break end end
            end
            if type(e3)=="table"then
                for e4,r4 in pairs(e3)do
                    if type(r4)=="string"or type(r4)=="table"then y2(r4)
                    elseif type(e4)=="string"and r4==true then y2(e4)end
                end
            elseif type(e3)=="string"then y2(e3)end
            h.selectedRarities=r3
            x()
        end})
        Fk.secSafety=Yk:Section({Title=P2.Character.SecSafety})
        Fk.togGodmode=Yk:Toggle({Title=P2.Character.GodmodeTitle,Desc=P2.Character.GodmodeDesc,Icon="solar:shield-check-bold",Value=false,Callback=function(e3)
            if e3 then enableDesyncGodmode()j2({Title="Godmode",Content="ON"})
            else disableDesyncGodmode()j2({Title="Godmode",Content="OFF"})end
        end})
        Fk.btnUnstick=Yk:Button({Title=P2.Character.UnstickTitle,Desc=P2.Character.UnstickDesc,Icon="solar:exit-bold",Callback=function()
            pcall(M4)pcall(C4)pcall(D4)
            j2({Title="Unstick",Content="Done"})
        end})
        Fk.secFlight=Yk:Section({Title=P2.Character.SecFlight})
        Fk.sliderSpeed=Yk:Slider({Title=P2.Character.SpeedTitle,Desc=P2.Character.SpeedDesc,Step=25,Value={Min=100,Max=1000,Default=h.glideSpeed or 600},Callback=function(e3)h.glideSpeed=e3 Y(e3)end})
        Fk.secMovement=Yk:Section({Title="Movement"})
        Fk.togNoclip=Yk:Toggle({Title="Noclip",Desc="Walk through walls",Icon="solar:ghost-bold",Value=h.noclip,Callback=function(e3)h.noclip=e3 j2({Title="Noclip",Content=e3 and "ON"or "OFF"})end})
        Fk.togInfJump=Yk:Toggle({Title="Infinite Jump",Desc="Jump midair forever",Icon="solar:arrow-up-bold",Value=h.infiniteJump,Callback=function(e3)h.infiniteJump=e3 end})
        Fk.sliderWS=Yk:Slider({Title="Walk Speed",Desc="16 default",Step=2,Value={Min=8,Max=200,Default=h.walkSpeed},Callback=function(e3)h.walkSpeed=e3 end})
        Fk.sliderJP=Yk:Slider({Title="Jump Power",Desc="50 default",Step=5,Value={Min=20,Max=500,Default=h.jumpPower},Callback=function(e3)h.jumpPower=e3 end})
        Fk.secESP=Tk:Section({Title="Egg ESP"})
        Fk.togESP=Tk:Toggle({Title="Egg ESP",Desc="Highlight premium eggs with distance",Icon="solar:eye-bold",Value=h.eggESP,Callback=function(e3)
            h.eggESP=e3
            if e3 and(not espFolder or not espFolder.Parent)then espClear()end
        end})
        Fk.sliderESPMin=Tk:Slider({Title="ESP Min Rarity Tier",Desc="0=all, 4=Secret+",Step=1,Value={Min=0,Max=6,Default=h.espMinRarity},Callback=function(e3)h.espMinRarity=e3 end})
        Fk.togESPBB=Tk:Toggle({Title="ESP Billboard",Desc="Show name/distance",Icon="solar:tag-bold",Value=h.espBillboard,Callback=function(e3)h.espBillboard=e3 end})
        Fk.togESPHL=Tk:Toggle({Title="ESP Highlight",Desc="Outline glow",Icon="solar:flash-bold",Value=h.espHighlight,Callback=function(e3)h.espHighlight=e3 end})
        Fk.secOverlay=Tk:Section({Title="Overlay"})
        Fk.togWM=Tk:Toggle({Title="Watermark",Desc="Top-right FPS/ping pill",Icon="solar:monitor-bold",Value=h.watermark,Callback=function(e3)h.watermark=e3 end})
        Fk.togToasts=Tk:Toggle({Title="Custom Toasts",Desc="Bottom-right notifications",Icon="solar:bell-bold",Value=h.toasts,Callback=function(e3)h.toasts=e3 end})
        Fk.secKeys=Tk:Section({Title="Keybinds (Z/Tween, X/Warp, B/Place, U/Unstuck, P/ESP, K/Watermark, H/Hop, Del/Panic)"})
        Fk.togKeys=Tk:Toggle({Title="Enable Keybinds",Desc="Master switch",Icon="solar:keyboard-bold",Value=h.masterKeybinds,Callback=function(e3)h.masterKeybinds=e3 end})
        Fk.secSystem2=Tk:Section({Title="Server & Automation"})
        Fk.togAutoSell=Tk:Toggle({Title="Auto Sell (Drops eggs to ReplicatedStorage)",Desc="Periodic backpack flush",Icon="solar:cart-bold",Value=h.autoSell,Callback=function(e3)h.autoSell=e3 end})
        Fk.sliderSellEvery=Tk:Slider({Title="Auto Sell Interval (s)",Step=5,Value={Min=5,Max=120,Default=h.autoSellEvery},Callback=function(e3)h.autoSellEvery=e3 end})
        Fk.togAutoRejoin=Tk:Toggle({Title="Auto Rejoin",Desc="Rejoin on disconnect",Icon="solar:refresh-bold",Value=h.autoRejoin,Callback=function(e3)h.autoRejoin=e3 end})
        Fk.togAntiStaff=Tk:Toggle({Title="Anti-Staff",Desc="Auto-stop farm if mod/admin joins",Icon="solar:eye-closed-bold",Value=h.antiStaff,Callback=function(e3)h.antiStaff=e3 end})
        Fk.btnHop=Tk:Button({Title="Server Hop",Desc="Jump to another server",Icon="solar:globus-bold",Callback=function()
            pcall(function()
                local e3=useReqFn and useReqFn({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
                if e3 and e3.Body then
                    local list=a:JSONDecode(e3.Body)
                    if list and list.data then
                        for _,srv in ipairs(list.data)do
                            if srv.id~=game.JobId and srv.playing<srv.maxPlayers then
                                h.stats.hops=h.stats.hops+1
                                TeleportService:TeleportToPlaceInstance(game.PlaceId,srv.id,o)
                                return
                            end
                        end
                    end
                end
            end)
        end})
        Fk.secDash=Tk:Section({Title="Live Stats"})
        Fk.paraLiveDash=Tk:Paragraph({Title="Session",Desc="Loading..."})
        Fk.secSystem=Tk:Section({Title="System"})
        Fk.togAntiAFK=Tk:Toggle({Title="Anti-AFK",Desc="Prevent idle kick",Icon="solar:shield-check-bold",Value=h.antiAFK,Callback=function(e3)
            h.antiAFK=e3
            x()
            if e3 then bk()else Ak()end
        end})
        Fk.togPerformance=Tk:Toggle({Title="Potato Mode",Desc="Max FPS, no graphics",Icon="solar:bolt-bold",Value=h.performanceMode,Callback=function(e3)
            h.performanceMode=e3
            x()
            if e3 then Mk()else Ik()end
        end})
        Fk.togDisable3D=Tk:Toggle({Title="Disable 3D Rendering",Desc="Save 95% GPU",Icon="solar:monitor-camera-bold",Value=h.disable3D,Callback=function(e3)
            h.disable3D=e3
            x()
            pcall(function()y:Set3dRenderingEnabled(not e3)end)
        end})
        Fk.btnReset=Tk:Button({Title="Reset Character",Desc="Clear state",Icon="solar:restart-bold",Callback=function()pcall(D4)pcall(u4)end})
        Fk.btnRejoin=Tk:Button({Title="Rejoin Server",Desc="Teleport to same server",Icon="solar:logout-2-bold",Callback=function()pcall(function()TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,o)end)end})
        Fk.btnTG=Tk:Button({Title="Open Telegram",Desc=BRAND_TG_TAG,Icon="solar:plain-bold",Callback=function()openTelegram()end})
        Fk.btnUnload=Tk:Button({Title="Unload Script",Desc="Stop and destroy",Icon="solar:trash-bin-trash-bold",Callback=function()aM()end})
        yM()
        task.spawn(function()
            while h.alive do
                pcall(function()
                    local r3=y4()
                    local y2=(Xk=="TH")
                    local u2=Wk(Xk)
                    if B2 then
                        local e3=PAL.success
                        if h.securingEgg or h.teleporting then e3=PAL.amber
                        elseif h.isReturning or h.glidingToTarget then e3=PAL.sky
                        elseif h.delivering then e3=PAL.success end
                        pcall(function()
                            if B2.SetTitle then B2:SetTitle(((y2 and "สถานะ: "or "Status: "))..u2)end
                            if B2.SetColor then B2:SetColor(e3)end
                        end)
                    end
                    if Fk.paraLiveDash and Fk.paraLiveDash.SetDesc then
                        local runtime=math.floor(os.clock()-h.stats.startedAt)
                        local mins=math.floor(runtime/60)
                        local secs=runtime%60
                        local cash=Vk()
                        h.stats.cashNow=cash
                        local j3=string.format("Stolen: %d  |  Hatched: %d  |  Placed: %d\nRuntime: %dm %ds  |  Cash: %.0f\nBag: %d Eggs  |  Hops: %d  |  Rejoins: %d",h.stats.stolen,h.stats.hatched,h.stats.placed,mins,secs,cash,r3,h.stats.hops,h.stats.rejoins)
                        pcall(function()Fk.paraLiveDash:SetDesc(j3)end)
                    end
                end)
                task.wait(0.75)
            end
        end)
        e2(restore)
        return
    end
    if h.gui then pcall(function()h.gui:Destroy()end)h.gui=nil end
    local k2=Instance.new("ScreenGui")
    k2.Name="Antraxdevz_FallbackUI"
    k2.ResetOnSpawn=false
    k2.DisplayOrder=99999
    k2.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    k2.AutoLocalize=false
    local a2=o:FindFirstChild("PlayerGui")or game:GetService("CoreGui")
    pcall(function()if syn and syn.protect_gui then syn.protect_gui(k2)k2.Parent=game:GetService("CoreGui")else k2.Parent=a2 end end)
    if not k2.Parent then k2.Parent=a2 end
    h.gui=k2
    local Q2=Instance.new("Frame")
    Q2.Size=UDim2.new(0,360,0,560)
    Q2.Position=UDim2.new(0.04,0,0.18,0)
    Q2.BackgroundColor3=PAL.bg
    Q2.BorderSizePixel=0
    Q2.Active=true
    Q2.Draggable=true
    Q2.ClipsDescendants=true
    Q2.Parent=k2
    Instance.new("UICorner",Q2).CornerRadius=UDim.new(0,14)
    local N3=Instance.new("UIStroke",Q2)
    N3.Color=Color3.new(1,1,1)
    N3.Thickness=1.6
    N3.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    grad(N3,PAL.orange,PAL.amber,135)
    local U3=Instance.new("Frame",Q2)
    U3.Size=UDim2.new(1,0,0,52)
    U3.BackgroundColor3=PAL.surface
    U3.BorderSizePixel=0
    Instance.new("UICorner",U3).CornerRadius=UDim.new(0,14)
    local l3=Instance.new("TextLabel",U3)
    l3.Size=UDim2.new(1,-100,0,26)
    l3.Position=UDim2.new(0,14,0,7)
    l3.BackgroundTransparency=1
    l3.Text="ANTRAXDEVZ"
    l3.TextColor3=PAL.orange
    l3.TextSize=17
    l3.Font=Enum.Font.GothamBlack
    l3.TextXAlignment=Enum.TextXAlignment.Left
    l3.AutoLocalize=false
    grad(l3,PAL.orange,PAL.amber,0)
    local D3=Instance.new("TextLabel",U3)
    D3.Size=UDim2.new(1,-100,0,14)
    D3.Position=UDim2.new(0,14,0,30)
    D3.BackgroundTransparency=1
    D3.Text="Steal an Egg  |  "..BRAND_VER
    D3.TextColor3=PAL.amber
    D3.TextSize=10
    D3.Font=Enum.Font.GothamMedium
    D3.TextXAlignment=Enum.TextXAlignment.Left
    D3.AutoLocalize=false
    local tgb=Instance.new("TextButton",U3)
    tgb.Size=UDim2.fromOffset(40,26)
    tgb.Position=UDim2.new(1,-118,0,13)
    tgb.BackgroundColor3=PAL.orange
    tgb.Text="TG"
    tgb.TextColor3=Color3.new(1,1,1)
    tgb.TextSize=11
    tgb.Font=Enum.Font.GothamBlack
    tgb.AutoButtonColor=false
    Instance.new("UICorner",tgb).CornerRadius=UDim.new(0,8)
    grad(tgb,PAL.orange,PAL.amber,135)
    tgb.MouseButton1Click:Connect(function()openTelegram()end)
    local C3=Instance.new("TextButton",U3)
    C3.Size=UDim2.fromOffset(28,28)
    C3.Position=UDim2.new(1,-72,0,12)
    C3.BackgroundColor3=PAL.surface2
    C3.Text="-"
    C3.TextColor3=PAL.text
    C3.TextSize=16
    C3.Font=Enum.Font.GothamBold
    C3.AutoButtonColor=false
    Instance.new("UICorner",C3).CornerRadius=UDim.new(0,8)
    local q3=Instance.new("TextButton",U3)
    q3.Size=UDim2.fromOffset(28,28)
    q3.Position=UDim2.new(1,-38,0,12)
    q3.BackgroundColor3=PAL.danger
    q3.Text="X"
    q3.TextColor3=PAL.text
    q3.TextSize=12
    q3.Font=Enum.Font.GothamBold
    q3.AutoButtonColor=false
    Instance.new("UICorner",q3).CornerRadius=UDim.new(0,8)
    local n3=Instance.new("ScrollingFrame",Q2)
    n3.Size=UDim2.new(1,0,1,-52)
    n3.Position=UDim2.new(0,0,0,52)
    n3.BackgroundTransparency=1
    n3.BorderSizePixel=0
    n3.ScrollBarThickness=3
    n3.ScrollBarImageColor3=PAL.orange
    n3.CanvasSize=UDim2.new(0,0,0,0)
    n3.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local I3=Instance.new("UIListLayout",n3)
    I3.SortOrder=Enum.SortOrder.LayoutOrder
    I3.Padding=UDim.new(0,8)
    local L3=Instance.new("UIPadding",n3)
    L3.PaddingTop=UDim.new(0,10)
    L3.PaddingBottom=UDim.new(0,14)
    L3.PaddingLeft=UDim.new(0,12)
    L3.PaddingRight=UDim.new(0,12)
    local gg=false
    C3.MouseButton1Click:Connect(function()
        gg=not gg
        C3.Text=gg and "+"or "-"
        u:Create(Q2,TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=gg and UDim2.new(0,360,0,46)or UDim2.new(0,360,0,560)}):Play()
    end)
    q3.MouseButton1Click:Connect(function()aM()end)
    local function E3(e3,r3)
        local y2=Instance.new("Frame",n3)
        y2.Size=UDim2.new(1,0,0,22)
        y2.BackgroundTransparency=1
        y2.LayoutOrder=r3
        local u2=Instance.new("TextLabel",y2)
        u2.Size=UDim2.new(1,0,1,0)
        u2.BackgroundTransparency=1
        u2.Text=e3
        u2.TextColor3=PAL.orange
        u2.TextSize=11
        u2.Font=Enum.Font.GothamBold
        u2.TextXAlignment=Enum.TextXAlignment.Left
        u2.AutoLocalize=false
        grad(u2,PAL.orange,PAL.amber,0)
    end
    local function bTog(e3,r3,y2,w2,j3,k3)
        local a3=Instance.new("Frame",n3)
        a3.Size=UDim2.new(1,0,0,54)
        a3.BackgroundColor3=PAL.surface2
        a3.LayoutOrder=j3
        Instance.new("UICorner",a3).CornerRadius=UDim.new(0,10)
        local o3=Instance.new("TextLabel",a3)
        o3.Size=UDim2.new(1,-60,0,18)
        o3.Position=UDim2.new(0,12,0,9)
        o3.BackgroundTransparency=1
        o3.Text=e3
        o3.TextColor3=w2 or PAL.text
        o3.TextSize=13
        o3.Font=Enum.Font.GothamBold
        o3.TextXAlignment=Enum.TextXAlignment.Left
        o3.AutoLocalize=false
        local V3=Instance.new("TextLabel",a3)
        V3.Size=UDim2.new(1,-60,0,16)
        V3.Position=UDim2.new(0,12,0,28)
        V3.BackgroundTransparency=1
        V3.Text=r3
        V3.TextColor3=PAL.textDim
        V3.TextSize=10
        V3.Font=Enum.Font.GothamMedium
        V3.TextXAlignment=Enum.TextXAlignment.Left
        V3.AutoLocalize=false
        local H3=Instance.new("TextButton",a3)
        H3.Size=UDim2.fromOffset(44,24)
        H3.Position=UDim2.new(1,-56,0.5,-12)
        H3.BackgroundColor3=y2 and w2 or PAL.line
        H3.Text=""
        H3.AutoButtonColor=false
        Instance.new("UICorner",H3).CornerRadius=UDim.new(1,0)
        local s3=Instance.new("Frame",H3)
        s3.Size=UDim2.fromOffset(18,18)
        s3.Position=y2 and UDim2.new(1,-21,0.5,-9)or UDim2.new(0,3,0.5,-9)
        s3.BackgroundColor3=y2 and Color3.new(1,1,1)or PAL.textMute
        Instance.new("UICorner",s3).CornerRadius=UDim.new(1,0)
        local pp2=y2
        local function i2(e4)
            pp2=e4
            local r4=TweenInfo.new(0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
            u:Create(H3,r4,{BackgroundColor3=pp2 and w2 or PAL.line}):Play()
            u:Create(s3,r4,{Position=pp2 and UDim2.new(1,-21,0.5,-9)or UDim2.new(0,3,0.5,-9),BackgroundColor3=pp2 and Color3.new(1,1,1)or PAL.textMute}):Play()
        end
        H3.MouseButton1Click:Connect(function()
            local e4=not pp2
            i2(e4)
            k3(e4)
        end)
        return i2
    end
    local function btn(e3,r3,y2,u2,w2)
        local j3=Instance.new("Frame",n3)
        j3.Size=UDim2.new(1,0,0,52)
        j3.BackgroundColor3=PAL.surface2
        j3.LayoutOrder=u2
        Instance.new("UICorner",j3).CornerRadius=UDim.new(0,10)
        local k3=Instance.new("TextLabel",j3)
        k3.Size=UDim2.new(1,-100,0,18)
        k3.Position=UDim2.new(0,12,0,8)
        k3.BackgroundTransparency=1
        k3.Text=e3
        k3.TextColor3=y2 or PAL.text
        k3.TextSize=13
        k3.Font=Enum.Font.GothamBold
        k3.TextXAlignment=Enum.TextXAlignment.Left
        k3.AutoLocalize=false
        local a3=Instance.new("TextLabel",j3)
        a3.Size=UDim2.new(1,-100,0,16)
        a3.Position=UDim2.new(0,12,0,28)
        a3.BackgroundTransparency=1
        a3.Text=r3
        a3.TextColor3=PAL.textDim
        a3.TextSize=10
        a3.Font=Enum.Font.GothamMedium
        a3.TextXAlignment=Enum.TextXAlignment.Left
        a3.AutoLocalize=false
        local o3=Instance.new("TextButton",j3)
        o3.Size=UDim2.fromOffset(80,30)
        o3.Position=UDim2.new(1,-92,0.5,-15)
        o3.BackgroundColor3=y2
        o3.Text="RUN"
        o3.TextColor3=Color3.new(1,1,1)
        o3.TextSize=11
        o3.Font=Enum.Font.GothamBold
        o3.AutoButtonColor=false
        Instance.new("UICorner",o3).CornerRadius=UDim.new(0,8)
        o3.MouseButton1Click:Connect(w2)
    end
    E3("AUTO STEAL MODES",10)
    local S3=false
    local Z3=nil
    local z3=nil
    Z3=bTog("Auto Steal (Tween)","Fly to steal eggs",h.pureTweenFarm,PAL.orange,11,function(e3)
        if S3 then return end
        if e3 then T4("TWEEN")
        else if Y4=="TWEEN"or h.pureTweenFarm then T4("NONE")end end
    end)
    z3=bTog("Auto Steal (Teleport)","Warp steal rapidly",h.autoFarmLoop,PAL.amber,12,function(e3)
        if S3 then return end
        if e3 then T4("WARP")
        else if Y4=="WARP"or h.autoFarmLoop then T4("NONE")end end
    end)
    x4=function(e3)pcall(function()if Z3 then S3=true Z3(e3)S3=false end end)end
    W4=function(e3)pcall(function()if z3 then S3=true z3(e3)S3=false end end)end
    btn("Single Steal","Teleport to 1 target",PAL.indigo,13,function()
        task.spawn(function()
            if Y4~="NONE"then T4("NONE")task.wait(0.2)end
            local e3=N4()
            if e3 then
                local y2=l4(e3,nil)
                if y2 then pcall(u4)if h.autoGlide then Q4(h.glideSpeed)u4()end end
            end
        end)
    end)
    E3("PLACE EGG",20)
    btn("Place Egg","Tween home place all",PAL.success,21,function()
        task.spawn(function()
            h.statusText="[Manual] Depositing..."
            g4(h.glideSpeed)
            v4()
            u4()
        end)
    end)
    bTog("Auto Place (Every 5)","Return home every 5",h.autoPlaceEvery5,PAL.sky,22,function(e3)h.autoPlaceEvery5=e3 if not e3 then h.batchStealCount=0 end end)
    bTog("Auto Hatch","Hatch ready eggs",h.autoHatch,PAL.success,22,function(e3)h.autoHatch=e3 end)
    bTog("Auto Return","Return after steal",h.autoGlide,PAL.amber,23,function(e3)h.autoGlide=e3 end)
    bTog("Auto Treadmill","Run when idle",h.autoTreadmill,PAL.amber,24,function(e3)
        h.autoTreadmill=e3
        x()
        n4()
        if not e3 and((h.onTreadmill or L4()))then M4()end
    end)
    E3("CHARACTER & SAFETY",30)
    bTog("Godmode","Invincible",false,PAL.rose,31,function(e3)if e3 then enableDesyncGodmode()else disableDesyncGodmode()end end)
    btn("Get Out Treadmill","Escape",PAL.amber,32,function()pcall(M4)pcall(C4)pcall(D4)end)
    bTog("Noclip","Walk through walls",h.noclip,PAL.orange,33,function(e3)h.noclip=e3 end)
    bTog("Infinite Jump","Jump midair",h.infiniteJump,PAL.orange,34,function(e3)h.infiniteJump=e3 end)
    E3("OVERLAY & UTILITY",40)
    bTog("Egg ESP","Highlight premium eggs",h.eggESP,PAL.orange,41,function(e3)
        h.eggESP=e3
        if e3 and(not espFolder or not espFolder.Parent)then espClear()end
    end)
    bTog("Watermark","FPS/ping pill",h.watermark,PAL.orange,42,function(e3)h.watermark=e3 end)
    bTog("Keybinds","Enable hotkeys",h.masterKeybinds,PAL.orange,43,function(e3)h.masterKeybinds=e3 end)
    bTog("Auto Rejoin","Rejoin on disconnect",h.autoRejoin,PAL.orange,44,function(e3)h.autoRejoin=e3 end)
    btn("Server Hop","Jump servers",PAL.orange,45,function()
        pcall(function()
            local e3=useReqFn and useReqFn({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
            if e3 and e3.Body then
                local list=a:JSONDecode(e3.Body)
                if list and list.data then
                    for _,srv in ipairs(list.data)do
                        if srv.id~=game.JobId and srv.playing<srv.maxPlayers then
                            h.stats.hops=h.stats.hops+1
                            TeleportService:TeleportToPlaceInstance(game.PlaceId,srv.id,o)
                            return
                        end
                    end
                end
            end
        end)
    end)
    btn("Open Telegram","t.me/AntraxdevZ",PAL.orange,46,function()openTelegram()end)
    E3("CONTROLS & SETTINGS",50)
    btn("Reset State","Clear velocity",PAL.indigo,51,function()pcall(D4)pcall(u4)end)
    btn("Unload Script","Destroy all",PAL.danger,52,function()aM()end)
    e(function()Q2.Visible=true end)
end
H("[+] "..BRAND_NAME.." "..BRAND_VER.." | "..BRAND_TG)
oM()
task.spawn(function()
    task.wait(0.5)
    A4()
    b4(true)
    C4()
    if o.Character then z4(o.Character)end
    u4()
    H("[+] Rig lock active")
end)
o.CharacterAdded:Connect(function(e2)
    task.wait(0.6)
    if h.alive then
        D4()
        n4()
        C4()
        A4()
        b4(true)
        z4(e2)
        u4()
    end
end)
if h.performanceMode then task.spawn(Mk)end
if h.disable3D then pcall(function()y:Set3dRenderingEnabled(false)end)end
if h.antiAFK then task.spawn(bk)end
if h.eggESP then espClear()end
H("[+] Loaded "..BRAND_NAME.." | "..BRAND_TG)
