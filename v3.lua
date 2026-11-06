local env = (getgenv and getgenv()) or _G
if env.VeluneLoaded then
    return
end
env.VeluneLoaded = true
if not game:IsLoaded() then
    pcall(function()
        game.Loaded:Wait()
    end)
end
local function ref(v)
    if cloneref then
        return cloneref(v)
    end
    return v
end
local function svc(n)
    local ok, s = pcall(function()
        return ref(game:GetService(n))
    end)
    if ok then
        return s
    end
    return nil
end
local Players = svc("Players")
local Workspace = svc("Workspace")
local RunService = svc("RunService")
local UserInputService = svc("UserInputService")
local ReplicatedStorage = svc("ReplicatedStorage")
local TweenService = svc("TweenService")
local Lighting = svc("Lighting")
local TeleportService = svc("TeleportService")
local SoundService = svc("SoundService")
local Debris = svc("Debris")
local Stats = svc("Stats")
local HttpService = svc("HttpService")
local CoreGui = svc("CoreGui") or svc("PlayerGui")
local StarterGui = svc("StarterGui")
local VirtualUser = svc("VirtualUser")
local TextChatService = svc("TextChatService")
local LP = Players and Players.LocalPlayer
if not LP and Players then
    pcall(function()
        LP = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        LP = Players.LocalPlayer
    end)
end
local Camera = Workspace and Workspace.CurrentCamera
local Velune = {}
env.Velune = Velune
Velune.Version = "4.0.0"
Velune.Name = "VELUNE"
Velune.Accent = Color3.fromRGB(225, 29, 72)
Velune.Ink = Color3.fromRGB(9, 7, 10)
Velune.Paper = Color3.fromRGB(243, 236, 236)
Velune.Muted = Color3.fromRGB(156, 142, 144)
Velune.Surface = Color3.fromRGB(19, 16, 20)
Velune.Elevated = Color3.fromRGB(28, 23, 25)
Velune.Border = Color3.fromRGB(44, 35, 38)
Velune.Connections = {}
Velune.Flags = {
    ESP = false,
    ShowMurderer = true,
    ShowSheriff = true,
    ShowHero = true,
    ShowInnocent = true,
    ShowSelf = true,
    GunESP = true,
    Names = true,
    Boxes = false,
    Tracers = false,
    Skeleton = false,
    SpeedOn = false,
    StretchOn = false,
    Fly = false,
    Noclip = false,
    InfiniteJump = false,
    AntiFling = false,
    AntiAFK = false,
    PingPredict = false,
    AutoGrab = false,
    AutoFarm = false,
    AutoShoot = false,
    KnifeAura = false,
    SilentThrow = false,
    WallBang = false,
    RoundTimer = true,
    NotifyGun = true,
    NotifyMurd = false,
    NotifySher = false,
    Crosshair = false,
    CursorSpin = false,
    ButtonsLocked = true,
    LowGFX = false,
    HighGFX = false,
    NativeOpen = true,
}
Velune.Values = {
    FOV = 70,
    Speed = 200,
    Stretch = 0.5,
    Walk = 16,
    Jump = 50,
    Cap = 200,
    Aura = 20,
    FlySpeed = 90,
    FarmSpeed = 25,
    FarmOffset = -5,
    FarmRadius = 3000,
    FarmDelay = 0.1,
}
Velune.Colors = {
    Murderer = Color3.fromRGB(255, 58, 58),
    Sheriff = Color3.fromRGB(61, 139, 255),
    Hero = Color3.fromRGB(232, 197, 71),
    Innocent = Color3.fromRGB(47, 212, 106),
    Gun = Color3.fromRGB(255, 215, 0),
}
Velune.Shown = {
    GoldBomb = true,
    NormalBomb = true,
    Shoot = true,
    ESP = false,
    Flick = false,
    WallHop = false,
    GrabGun = false,
    Speed = false,
    Stretch = false,
    FlingMurderer = false,
    FlingSheriff = false,
    Fly = false,
    Noclip = false,
    SilentThrow = false,
    KillAll = false,
    Farm = false,
}
Velune.Cool = {}
Velune.Floor = {}
Velune.ESPFolder = {}
Velune.Lines = {}
Velune.RoleCache = {}
Velune.RoleStamp = 0
Velune.FlingBusy = false
Velune.FlickBusy = false
Velune.NativeOpen = false
Velune.UI = {}
Velune.CursorId = "Pulse"
Velune.CursorAsset = "7732596388"
Velune.LightingSnap = nil
Velune.FarmStats = { coins = 0, t0 = 0, running = false }
function Velune.Track(c)
    if typeof(c) == "RBXScriptConnection" then
        table.insert(Velune.Connections, c)
    end
    return c
end
function Velune.ClearTracks()
    for i, c in ipairs(Velune.Connections) do
        pcall(function()
            c:Disconnect()
        end)
        Velune.Connections[i] = nil
    end
    table.clear(Velune.Connections)
end
function Velune.Char()
    return LP and LP.Character
end
function Velune.Hum()
    local c = Velune.Char()
    return c and c:FindFirstChildOfClass("Humanoid")
end
function Velune.HRP()
    local c = Velune.Char()
    if not c then
        return nil
    end
    return c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart
end
function Velune.Backpack()
    return LP and LP:FindFirstChild("Backpack")
end
function Velune.HasTool(n)
    local b = Velune.Backpack()
    local c = Velune.Char()
    if b and b:FindFirstChild(n) then
        return b:FindFirstChild(n)
    end
    if c and c:FindFirstChild(n) then
        return c:FindFirstChild(n)
    end
    return nil
end
function Velune.Cam()
    Camera = Workspace and Workspace.CurrentCamera or Camera
    return Camera
end
function Velune.Ping()
    local n = 0.05
    pcall(function()
        if Stats then
            local item = Stats.Network.ServerStatsItem["Data Ping"]
            if item then
                n = item:GetValue() / 1000
            end
        end
    end)
    return n
end
function Velune.Tween(obj, info, props)
    local tw
    pcall(function()
        tw = TweenService:Create(obj, info, props)
        tw:Play()
    end)
    return tw
end
function Velune.Spring(obj, props, t)
    return Velune.Tween(obj, TweenInfo.new(t or 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
end
function Velune.PulseScale(gui, from, to)
    if not gui then
        return
    end
    gui.Size = from
    Velune.Spring(gui, { Size = to }, 0.18)
end
function Velune.PlayTone(id, vol)
    if not SoundService then
        return
    end
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. tostring(id)
        s.Volume = vol or 0.45
        s.Parent = SoundService
        s:Play()
        if Debris then
            Debris:AddItem(s, 3)
        end
    end)
end
function Velune.ClickTone()
    Velune.PlayTone(138656262630730, 0.35)
end
function Velune.NotifyTone()
    Velune.PlayTone(106553517979212, 0.4)
end
local notifyGui
local notifyStack = {}
function Velune.HostGui()
    if notifyGui and notifyGui.Parent then
        return notifyGui
    end
    local parent = CoreGui
    if not parent and LP then
        parent = LP:FindFirstChild("PlayerGui")
    end
    local g = Instance.new("ScreenGui")
    g.Name = "VeluneRoot"
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.DisplayOrder = 120
    pcall(function()
        g.Parent = parent
    end)
    notifyGui = g
    return g
end
function Velune.Notify(title, body, dur)
    dur = dur or 3
    local host = Velune.HostGui()
    if not host then
        return
    end
    Velune.NotifyTone()
    local card = Instance.new("Frame")
    card.Name = "VeluneToast"
    card.Size = UDim2.new(0, 280, 0, 72)
    card.Position = UDim2.new(1, 24, 1, -110)
    card.AnchorPoint = Vector2.new(0, 0)
    card.BackgroundColor3 = Velune.Surface
    card.BackgroundTransparency = 0.06
    card.BorderSizePixel = 0
    card.ZIndex = 200
    card.Parent = host
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card
    local stroke = Instance.new("UIStroke")
    stroke.Color = Velune.Accent
    stroke.Thickness = 1.4
    stroke.Transparency = 0.2
    stroke.Parent = card
    local h = Instance.new("TextLabel")
    h.BackgroundTransparency = 1
    h.Size = UDim2.new(1, -36, 0, 22)
    h.Position = UDim2.new(0, 12, 0, 8)
    h.Font = Enum.Font.GothamBold
    h.TextSize = 14
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.TextColor3 = Velune.Accent
    h.Text = title or "VELUNE"
    h.ZIndex = 201
    h.Parent = card
    local p = Instance.new("TextLabel")
    p.BackgroundTransparency = 1
    p.Size = UDim2.new(1, -24, 0, 32)
    p.Position = UDim2.new(0, 12, 0, 30)
    p.Font = Enum.Font.Gotham
    p.TextSize = 12
    p.TextWrapped = true
    p.TextXAlignment = Enum.TextXAlignment.Left
    p.TextYAlignment = Enum.TextYAlignment.Top
    p.TextColor3 = Velune.Paper
    p.Text = tostring(body or "")
    p.ZIndex = 201
    p.Parent = card
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -24, 0, 3)
    barBg.Position = UDim2.new(0, 12, 1, -10)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 30, 34)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 202
    barBg.Parent = card
    local barC = Instance.new("UICorner")
    barC.CornerRadius = UDim.new(1, 0)
    barC.Parent = barBg
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = Velune.Accent
    bar.BorderSizePixel = 0
    bar.ZIndex = 203
    bar.Parent = barBg
    local barCC = Instance.new("UICorner")
    barCC.CornerRadius = UDim.new(1, 0)
    barCC.Parent = bar
    table.insert(notifyStack, card)
    local function layout()
        for i, v in ipairs(notifyStack) do
            if v and v.Parent then
                local y = -110 - (#notifyStack - i) * 82
                Velune.Spring(v, { Position = UDim2.new(1, -292, 1, y) }, 0.35)
            end
        end
    end
    layout()
    Velune.Tween(bar, TweenInfo.new(dur, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) })
    task.delay(dur, function()
        for i, v in ipairs(notifyStack) do
            if v == card then
                table.remove(notifyStack, i)
                break
            end
        end
        Velune.Spring(card, { Position = UDim2.new(1, 40, card.Position.Y.Scale, card.Position.Y.Offset), BackgroundTransparency = 1 }, 0.28)
        task.delay(0.3, function()
            if card then
                card:Destroy()
            end
            layout()
        end)
    end)
    if Velune.WindNotify then
        pcall(Velune.WindNotify, title, body, dur)
    end
end
local WindUI
pcall(function()
    local src = game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua")
    WindUI = loadstring(src)()
end)
if WindUI then
    pcall(function()
        WindUI:SetTheme("Crimson")
    end)
    Velune.WindNotify = function(title, body, dur)
        pcall(function()
            WindUI:Notify({
                Title = title or "VELUNE",
                Content = tostring(body or ""),
                Duration = dur or 3,
                Icon = "sparkles",
            })
        end)
    end
end
function Velune.FindRemote(name, className)
    if not ReplicatedStorage then
        return nil
    end
    local hit
    pcall(function()
        hit = ReplicatedStorage:FindFirstChild(name, true)
    end)
    if hit and (not className or hit:IsA(className)) then
        return hit
    end
    return nil
end
function Velune.PullRoles()
    if tick() - Velune.RoleStamp < 0.45 then
        return Velune.RoleCache
    end
    local rf = Velune.FindRemote("GetCurrentPlayerData", "RemoteFunction") or Velune.FindRemote("GetPlayerData", "RemoteFunction")
    if rf then
        local ok, data = pcall(function()
            return rf:InvokeServer()
        end)
        if ok and type(data) == "table" then
            Velune.RoleCache = data
            Velune.RoleStamp = tick()
            return data
        end
    end
    Velune.RoleStamp = tick()
    return Velune.RoleCache
end
function Velune.RoleOf(player)
    local data = Velune.PullRoles()
    local row = data and data[player.Name]
    if row then
        local r = tostring(row.Role or row.role or row.Team or ""):lower()
        if r:find("murd") then
            return "Murderer"
        end
        if r:find("sheriff") or r:find("gun") then
            return "Sheriff"
        end
        if r:find("hero") then
            return "Hero"
        end
        if r:find("inn") then
            return "Innocent"
        end
    end
    if player.Character and player.Character:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife")) then
        return "Murderer"
    end
    if player.Character and player.Character:FindFirstChild("Gun") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end
function Velune.Alive(player)
    local c = player.Character
    if not c then
        return false
    end
    local h = c:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end
function Velune.FindByRole(role)
    if not Players then
        return nil
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and Velune.Alive(p) and Velune.RoleOf(p) == role then
            return p
        end
    end
    return nil
end
function Velune.FindMurderer()
    return Velune.FindByRole("Murderer")
end
function Velune.FindSheriff()
    return Velune.FindByRole("Sheriff") or Velune.FindByRole("Hero")
end
function Velune.GunDrop()
    if not Workspace then
        return nil
    end
    local g
    pcall(function()
        g = Workspace:FindFirstChild("GunDrop", true)
    end)
    return g
end
function Velune.MapRoot()
    if not Workspace then
        return nil
    end
    for _, ch in ipairs(Workspace:GetChildren()) do
        if ch:FindFirstChild("CoinContainer") or ch:FindFirstChild("CoinAreas") then
            if ch:FindFirstChild("Spawns") then
                return ch
            end
        end
    end
    return nil
end
function Velune.LobbyRoot()
    if not Workspace then
        return nil
    end
    for _, ch in ipairs(Workspace:GetChildren()) do
        if ch:FindFirstChild("Lobby") then
            return ch.Lobby
        end
        if tostring(ch.Name):lower() == "lobby" then
            return ch
        end
    end
    return nil
end
function Velune.PivotTo(cf)
    local c = Velune.Char()
    if c then
        pcall(function()
            c:PivotTo(cf)
        end)
        return
    end
    local hrp = Velune.HRP()
    if hrp then
        hrp.CFrame = cf
    end
end

function Velune.MakeDrag(frame, onEnd)
    local dragging = false
    local start = nil
    local origin = nil
    Velune.Track(frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            origin = frame.Position
        end
    end))
    Velune.Track(UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - start
            frame.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
        end
    end))
    Velune.Track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and onEnd then
                onEnd(frame.Position)
            end
            dragging = false
        end
    end))
end
function Velune.Ripple(parent, pos)
    local r = Instance.new("Frame")
    r.AnchorPoint = Vector2.new(0.5, 0.5)
    r.Position = UDim2.new(0, pos.X, 0, pos.Y)
    r.Size = UDim2.new(0, 8, 0, 8)
    r.BackgroundColor3 = Color3.new(1, 1, 1)
    r.BackgroundTransparency = 0.4
    r.BorderSizePixel = 0
    r.ZIndex = (parent.ZIndex or 1) + 3
    r.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = r
    Velune.Tween(r, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 88, 0, 88),
        BackgroundTransparency = 1,
    })
    task.delay(0.44, function()
        if r then
            r:Destroy()
        end
    end)
end
function Velune.GlowStroke(inst, color)
    local s = inst:FindFirstChildOfClass("UIStroke")
    if not s then
        s = Instance.new("UIStroke")
        s.Parent = inst
    end
    s.Color = color
    s.Thickness = 1.6
    s.Transparency = 0.12
    return s
end
function Velune.OnCooldown(key, ms)
    local now = tick()
    if (Velune.Cool[key] or 0) > now then
        return true
    end
    Velune.Cool[key] = now + (ms or 800) / 1000
    return false
end

Velune.SkyList = {}
function Velune.ApplySky_AuroraVeil()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_AuroraVeil"
        sky.SkyboxBk = "rbxassetid://149535001"
        sky.SkyboxDn = "rbxassetid://149535001"
        sky.SkyboxFt = "rbxassetid://149535001"
        sky.SkyboxLf = "rbxassetid://149535001"
        sky.SkyboxRt = "rbxassetid://149535001"
        sky.SkyboxUp = "rbxassetid://149535001"
        sky.StarCount = 20
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Brightness = 2.40
        lighting.FogEnd = 800
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(180, 80, 140)
        lighting.Ambient = Color3.fromRGB(140, 40, 100)
        lighting.OutdoorAmbient = Color3.fromRGB(192, 88, 156)
        lighting.ColorShift_Top = Color3.fromRGB(180, 80, 140)
        lighting.ColorShift_Bottom = Color3.fromRGB(62, 28, 56)
        lighting.EnvironmentDiffuseScale = 0.00
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Aurora Veil")
    Velune.PlayTone(138000000, 0.2)
end
Velune.SkyIndex_AuroraVeil = {
    name = "Aurora Veil",
    id = "149535001",
    color = Color3.fromRGB(180, 80, 140),
    fog = 18,
    dens = 5,
    apply = Velune.ApplySky_AuroraVeil,
}

table.insert(Velune.SkyList, Velune.SkyIndex_AuroraVeil)
function Velune.ApplySky_EmberDusk()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_EmberDusk"
        sky.SkyboxBk = "rbxassetid://153662429"
        sky.SkyboxDn = "rbxassetid://153662429"
        sky.SkyboxFt = "rbxassetid://153662429"
        sky.SkyboxLf = "rbxassetid://153662429"
        sky.SkyboxRt = "rbxassetid://153662429"
        sky.SkyboxUp = "rbxassetid://153662429"
        sky.StarCount = 60
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 17
        lighting.Brightness = 3.10
        lighting.FogEnd = 1020
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(220, 70, 40)
        lighting.Ambient = Color3.fromRGB(180, 30, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(232, 78, 56)
        lighting.ColorShift_Top = Color3.fromRGB(220, 70, 40)
        lighting.ColorShift_Bottom = Color3.fromRGB(77, 24, 16)
        lighting.EnvironmentDiffuseScale = 0.10
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Ember Dusk")
    Velune.PlayTone(138000017, 0.2)
end
Velune.SkyIndex_EmberDusk = {
    name = "Ember Dusk",
    id = "153662429",
    color = Color3.fromRGB(220, 70, 40),
    fog = 19,
    dens = 6,
    apply = Velune.ApplySky_EmberDusk,
}

table.insert(Velune.SkyList, Velune.SkyIndex_EmberDusk)
function Velune.ApplySky_RoseNebula()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_RoseNebula"
        sky.SkyboxBk = "rbxassetid://150739273"
        sky.SkyboxDn = "rbxassetid://150739273"
        sky.SkyboxFt = "rbxassetid://150739273"
        sky.SkyboxLf = "rbxassetid://150739273"
        sky.SkyboxRt = "rbxassetid://150739273"
        sky.SkyboxUp = "rbxassetid://150739273"
        sky.StarCount = 100
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 20
        lighting.Brightness = 2.20
        lighting.FogEnd = 1240
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(210, 50, 90)
        lighting.Ambient = Color3.fromRGB(170, 10, 50)
        lighting.OutdoorAmbient = Color3.fromRGB(222, 58, 106)
        lighting.ColorShift_Top = Color3.fromRGB(210, 50, 90)
        lighting.ColorShift_Bottom = Color3.fromRGB(73, 17, 36)
        lighting.EnvironmentDiffuseScale = 0.20
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Rose Nebula")
    Velune.PlayTone(138000034, 0.2)
end
Velune.SkyIndex_RoseNebula = {
    name = "Rose Nebula",
    id = "150739273",
    color = Color3.fromRGB(210, 50, 90),
    fog = 21,
    dens = 4,
    apply = Velune.ApplySky_RoseNebula,
}

table.insert(Velune.SkyList, Velune.SkyIndex_RoseNebula)
function Velune.ApplySky_VoidBloom()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_VoidBloom"
        sky.SkyboxBk = "rbxassetid://162619974"
        sky.SkyboxDn = "rbxassetid://162619974"
        sky.SkyboxFt = "rbxassetid://162619974"
        sky.SkyboxLf = "rbxassetid://162619974"
        sky.SkyboxRt = "rbxassetid://162619974"
        sky.SkyboxUp = "rbxassetid://162619974"
        sky.StarCount = 140
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 3
        lighting.Brightness = 1.40
        lighting.FogEnd = 1460
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(40, 20, 70)
        lighting.Ambient = Color3.fromRGB(8, 8, 30)
        lighting.OutdoorAmbient = Color3.fromRGB(52, 28, 86)
        lighting.ColorShift_Top = Color3.fromRGB(40, 20, 70)
        lighting.ColorShift_Bottom = Color3.fromRGB(14, 7, 28)
        lighting.EnvironmentDiffuseScale = 0.30
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Void Bloom")
    Velune.PlayTone(138000051, 0.2)
end
Velune.SkyIndex_VoidBloom = {
    name = "Void Bloom",
    id = "162619974",
    color = Color3.fromRGB(40, 20, 70),
    fog = 0,
    dens = 8,
    apply = Velune.ApplySky_VoidBloom,
}

table.insert(Velune.SkyList, Velune.SkyIndex_VoidBloom)
function Velune.ApplySky_VerdantHalo()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_VerdantHalo"
        sky.SkyboxBk = "rbxassetid://120641307"
        sky.SkyboxDn = "rbxassetid://120641307"
        sky.SkyboxFt = "rbxassetid://120641307"
        sky.SkyboxLf = "rbxassetid://120641307"
        sky.SkyboxRt = "rbxassetid://120641307"
        sky.SkyboxUp = "rbxassetid://120641307"
        sky.StarCount = 180
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 11
        lighting.Brightness = 2.80
        lighting.FogEnd = 1680
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(40, 160, 90)
        lighting.Ambient = Color3.fromRGB(8, 120, 50)
        lighting.OutdoorAmbient = Color3.fromRGB(52, 168, 106)
        lighting.ColorShift_Top = Color3.fromRGB(40, 160, 90)
        lighting.ColorShift_Bottom = Color3.fromRGB(14, 56, 36)
        lighting.EnvironmentDiffuseScale = 0.40
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Verdant Halo")
    Velune.PlayTone(138000068, 0.2)
end
Velune.SkyIndex_VerdantHalo = {
    name = "Verdant Halo",
    id = "120641307",
    color = Color3.fromRGB(40, 160, 90),
    fog = 12,
    dens = 7,
    apply = Velune.ApplySky_VerdantHalo,
}

table.insert(Velune.SkyList, Velune.SkyIndex_VerdantHalo)
function Velune.ApplySky_AmberDrift()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_AmberDrift"
        sky.SkyboxBk = "rbxassetid://150739194"
        sky.SkyboxDn = "rbxassetid://150739194"
        sky.SkyboxFt = "rbxassetid://150739194"
        sky.SkyboxLf = "rbxassetid://150739194"
        sky.SkyboxRt = "rbxassetid://150739194"
        sky.SkyboxUp = "rbxassetid://150739194"
        sky.StarCount = 220
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 16
        lighting.Brightness = 3.00
        lighting.FogEnd = 1900
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(230, 160, 40)
        lighting.Ambient = Color3.fromRGB(190, 120, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(242, 168, 56)
        lighting.ColorShift_Top = Color3.fromRGB(230, 160, 40)
        lighting.ColorShift_Bottom = Color3.fromRGB(80, 56, 16)
        lighting.EnvironmentDiffuseScale = 0.50
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Amber Drift")
    Velune.PlayTone(138000085, 0.2)
end
Velune.SkyIndex_AmberDrift = {
    name = "Amber Drift",
    id = "150739194",
    color = Color3.fromRGB(230, 160, 40),
    fog = 16,
    dens = 5,
    apply = Velune.ApplySky_AmberDrift,
}

table.insert(Velune.SkyList, Velune.SkyIndex_AmberDrift)
function Velune.ApplySky_CrimsonWake()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CrimsonWake"
        sky.SkyboxBk = "rbxassetid://149979502"
        sky.SkyboxDn = "rbxassetid://149979502"
        sky.SkyboxFt = "rbxassetid://149979502"
        sky.SkyboxLf = "rbxassetid://149979502"
        sky.SkyboxRt = "rbxassetid://149979502"
        sky.SkyboxUp = "rbxassetid://149979502"
        sky.StarCount = 260
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 18
        lighting.Brightness = 2.60
        lighting.FogEnd = 2120
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(200, 30, 40)
        lighting.Ambient = Color3.fromRGB(160, 8, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(212, 38, 56)
        lighting.ColorShift_Top = Color3.fromRGB(200, 30, 40)
        lighting.ColorShift_Bottom = Color3.fromRGB(70, 10, 16)
        lighting.EnvironmentDiffuseScale = 0.60
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Crimson Wake")
    Velune.PlayTone(138000102, 0.2)
end
Velune.SkyIndex_CrimsonWake = {
    name = "Crimson Wake",
    id = "149979502",
    color = Color3.fromRGB(200, 30, 40),
    fog = 20,
    dens = 4,
    apply = Velune.ApplySky_CrimsonWake,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CrimsonWake)
function Velune.ApplySky_SapphireFall()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_SapphireFall"
        sky.SkyboxBk = "rbxassetid://151339958"
        sky.SkyboxDn = "rbxassetid://151339958"
        sky.SkyboxFt = "rbxassetid://151339958"
        sky.SkyboxLf = "rbxassetid://151339958"
        sky.SkyboxRt = "rbxassetid://151339958"
        sky.SkyboxUp = "rbxassetid://151339958"
        sky.StarCount = 300
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 8
        lighting.Brightness = 2.90
        lighting.FogEnd = 2340
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(40, 90, 210)
        lighting.Ambient = Color3.fromRGB(8, 50, 170)
        lighting.OutdoorAmbient = Color3.fromRGB(52, 98, 226)
        lighting.ColorShift_Top = Color3.fromRGB(40, 90, 210)
        lighting.ColorShift_Bottom = Color3.fromRGB(14, 31, 84)
        lighting.EnvironmentDiffuseScale = 0.70
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Sapphire Fall")
    Velune.PlayTone(138000119, 0.2)
end
Velune.SkyIndex_SapphireFall = {
    name = "Sapphire Fall",
    id = "151339958",
    color = Color3.fromRGB(40, 90, 210),
    fog = 10,
    dens = 6,
    apply = Velune.ApplySky_SapphireFall,
}

table.insert(Velune.SkyList, Velune.SkyIndex_SapphireFall)
function Velune.ApplySky_IvoryNight()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_IvoryNight"
        sky.SkyboxBk = "rbxassetid://150739229"
        sky.SkyboxDn = "rbxassetid://150739229"
        sky.SkyboxFt = "rbxassetid://150739229"
        sky.SkyboxLf = "rbxassetid://150739229"
        sky.SkyboxRt = "rbxassetid://150739229"
        sky.SkyboxUp = "rbxassetid://150739229"
        sky.StarCount = 340
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 13
        lighting.Brightness = 2.00
        lighting.FogEnd = 2560
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(230, 220, 200)
        lighting.Ambient = Color3.fromRGB(190, 180, 160)
        lighting.OutdoorAmbient = Color3.fromRGB(242, 228, 216)
        lighting.ColorShift_Top = Color3.fromRGB(230, 220, 200)
        lighting.ColorShift_Bottom = Color3.fromRGB(80, 77, 80)
        lighting.EnvironmentDiffuseScale = 0.80
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Ivory Night")
    Velune.PlayTone(138000136, 0.2)
end
Velune.SkyIndex_IvoryNight = {
    name = "Ivory Night",
    id = "150739229",
    color = Color3.fromRGB(230, 220, 200),
    fog = 4,
    dens = 9,
    apply = Velune.ApplySky_IvoryNight,
}

table.insert(Velune.SkyList, Velune.SkyIndex_IvoryNight)
function Velune.ApplySky_Obsidian()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_Obsidian"
        sky.SkyboxBk = "rbxassetid://162619974"
        sky.SkyboxDn = "rbxassetid://162619974"
        sky.SkyboxFt = "rbxassetid://162619974"
        sky.SkyboxLf = "rbxassetid://162619974"
        sky.SkyboxRt = "rbxassetid://162619974"
        sky.SkyboxUp = "rbxassetid://162619974"
        sky.StarCount = 380
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 1
        lighting.Brightness = 1.10
        lighting.FogEnd = 2780
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(18, 18, 22)
        lighting.Ambient = Color3.fromRGB(8, 8, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(30, 26, 38)
        lighting.ColorShift_Top = Color3.fromRGB(18, 18, 22)
        lighting.ColorShift_Bottom = Color3.fromRGB(6, 6, 8)
        lighting.EnvironmentDiffuseScale = 0.90
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Obsidian")
    Velune.PlayTone(138000153, 0.2)
end
Velune.SkyIndex_Obsidian = {
    name = "Obsidian",
    id = "162619974",
    color = Color3.fromRGB(18, 18, 22),
    fog = 0,
    dens = 10,
    apply = Velune.ApplySky_Obsidian,
}

table.insert(Velune.SkyList, Velune.SkyIndex_Obsidian)
function Velune.ApplySky_BlushOrbit()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_BlushOrbit"
        sky.SkyboxBk = "rbxassetid://150739248"
        sky.SkyboxDn = "rbxassetid://150739248"
        sky.SkyboxFt = "rbxassetid://150739248"
        sky.SkyboxLf = "rbxassetid://150739248"
        sky.SkyboxRt = "rbxassetid://150739248"
        sky.SkyboxUp = "rbxassetid://150739248"
        sky.StarCount = 420
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 15
        lighting.Brightness = 2.30
        lighting.FogEnd = 3000
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(240, 140, 170)
        lighting.Ambient = Color3.fromRGB(200, 100, 130)
        lighting.OutdoorAmbient = Color3.fromRGB(252, 148, 186)
        lighting.ColorShift_Top = Color3.fromRGB(240, 140, 170)
        lighting.ColorShift_Bottom = Color3.fromRGB(84, 49, 68)
        lighting.EnvironmentDiffuseScale = 0.00
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Blush Orbit")
    Velune.PlayTone(138000170, 0.2)
end
Velune.SkyIndex_BlushOrbit = {
    name = "Blush Orbit",
    id = "150739248",
    color = Color3.fromRGB(240, 140, 170),
    fog = 15,
    dens = 5,
    apply = Velune.ApplySky_BlushOrbit,
}

table.insert(Velune.SkyList, Velune.SkyIndex_BlushOrbit)
function Velune.ApplySky_CopperStorm()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CopperStorm"
        sky.SkyboxBk = "rbxassetid://153662389"
        sky.SkyboxDn = "rbxassetid://153662389"
        sky.SkyboxFt = "rbxassetid://153662389"
        sky.SkyboxLf = "rbxassetid://153662389"
        sky.SkyboxRt = "rbxassetid://153662389"
        sky.SkyboxUp = "rbxassetid://153662389"
        sky.StarCount = 460
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 12
        lighting.Brightness = 3.20
        lighting.FogEnd = 3220
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(190, 110, 50)
        lighting.Ambient = Color3.fromRGB(150, 70, 10)
        lighting.OutdoorAmbient = Color3.fromRGB(202, 118, 66)
        lighting.ColorShift_Top = Color3.fromRGB(190, 110, 50)
        lighting.ColorShift_Bottom = Color3.fromRGB(66, 38, 20)
        lighting.EnvironmentDiffuseScale = 0.10
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Copper Storm")
    Velune.PlayTone(138000187, 0.2)
end
Velune.SkyIndex_CopperStorm = {
    name = "Copper Storm",
    id = "153662389",
    color = Color3.fromRGB(190, 110, 50),
    fog = 17,
    dens = 6,
    apply = Velune.ApplySky_CopperStorm,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CopperStorm)
function Velune.ApplySky_LilacFog()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_LilacFog"
        sky.SkyboxBk = "rbxassetid://149535087"
        sky.SkyboxDn = "rbxassetid://149535087"
        sky.SkyboxFt = "rbxassetid://149535087"
        sky.SkyboxLf = "rbxassetid://149535087"
        sky.SkyboxRt = "rbxassetid://149535087"
        sky.SkyboxUp = "rbxassetid://149535087"
        sky.StarCount = 500
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 9
        lighting.Brightness = 2.10
        lighting.FogEnd = 800
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(170, 120, 210)
        lighting.Ambient = Color3.fromRGB(130, 80, 170)
        lighting.OutdoorAmbient = Color3.fromRGB(182, 128, 226)
        lighting.ColorShift_Top = Color3.fromRGB(170, 120, 210)
        lighting.ColorShift_Bottom = Color3.fromRGB(59, 42, 84)
        lighting.EnvironmentDiffuseScale = 0.20
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Lilac Fog")
    Velune.PlayTone(138000204, 0.2)
end
Velune.SkyIndex_LilacFog = {
    name = "Lilac Fog",
    id = "149535087",
    color = Color3.fromRGB(170, 120, 210),
    fog = 7,
    dens = 8,
    apply = Velune.ApplySky_LilacFog,
}

table.insert(Velune.SkyList, Velune.SkyIndex_LilacFog)
function Velune.ApplySky_JadeMirror()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_JadeMirror"
        sky.SkyboxBk = "rbxassetid://120641401"
        sky.SkyboxDn = "rbxassetid://120641401"
        sky.SkyboxFt = "rbxassetid://120641401"
        sky.SkyboxLf = "rbxassetid://120641401"
        sky.SkyboxRt = "rbxassetid://120641401"
        sky.SkyboxUp = "rbxassetid://120641401"
        sky.StarCount = 540
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 10
        lighting.Brightness = 2.70
        lighting.FogEnd = 1020
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(30, 180, 120)
        lighting.Ambient = Color3.fromRGB(8, 140, 80)
        lighting.OutdoorAmbient = Color3.fromRGB(42, 188, 136)
        lighting.ColorShift_Top = Color3.fromRGB(30, 180, 120)
        lighting.ColorShift_Bottom = Color3.fromRGB(10, 62, 48)
        lighting.EnvironmentDiffuseScale = 0.30
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Jade Mirror")
    Velune.PlayTone(138000221, 0.2)
end
Velune.SkyIndex_JadeMirror = {
    name = "Jade Mirror",
    id = "120641401",
    color = Color3.fromRGB(30, 180, 120),
    fog = 11,
    dens = 7,
    apply = Velune.ApplySky_JadeMirror,
}

table.insert(Velune.SkyList, Velune.SkyIndex_JadeMirror)
function Velune.ApplySky_NoirGlass()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_NoirGlass"
        sky.SkyboxBk = "rbxassetid://162619901"
        sky.SkyboxDn = "rbxassetid://162619901"
        sky.SkyboxFt = "rbxassetid://162619901"
        sky.SkyboxLf = "rbxassetid://162619901"
        sky.SkyboxRt = "rbxassetid://162619901"
        sky.SkyboxUp = "rbxassetid://162619901"
        sky.StarCount = 580
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 2
        lighting.Brightness = 1.30
        lighting.FogEnd = 1240
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(28, 24, 32)
        lighting.Ambient = Color3.fromRGB(8, 8, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(40, 32, 48)
        lighting.ColorShift_Top = Color3.fromRGB(28, 24, 32)
        lighting.ColorShift_Bottom = Color3.fromRGB(9, 8, 12)
        lighting.EnvironmentDiffuseScale = 0.40
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Noir Glass")
    Velune.PlayTone(138000238, 0.2)
end
Velune.SkyIndex_NoirGlass = {
    name = "Noir Glass",
    id = "162619901",
    color = Color3.fromRGB(28, 24, 32),
    fog = 1,
    dens = 10,
    apply = Velune.ApplySky_NoirGlass,
}

table.insert(Velune.SkyList, Velune.SkyIndex_NoirGlass)
function Velune.ApplySky_SolarVein()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_SolarVein"
        sky.SkyboxBk = "rbxassetid://150739310"
        sky.SkyboxDn = "rbxassetid://150739310"
        sky.SkyboxFt = "rbxassetid://150739310"
        sky.SkyboxLf = "rbxassetid://150739310"
        sky.SkyboxRt = "rbxassetid://150739310"
        sky.SkyboxUp = "rbxassetid://150739310"
        sky.StarCount = 620
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 17
        lighting.Brightness = 3.40
        lighting.FogEnd = 1460
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(255, 180, 60)
        lighting.Ambient = Color3.fromRGB(215, 140, 20)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 188, 76)
        lighting.ColorShift_Top = Color3.fromRGB(255, 180, 60)
        lighting.ColorShift_Bottom = Color3.fromRGB(89, 62, 24)
        lighting.EnvironmentDiffuseScale = 0.50
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Solar Vein")
    Velune.PlayTone(138000255, 0.2)
end
Velune.SkyIndex_SolarVein = {
    name = "Solar Vein",
    id = "150739310",
    color = Color3.fromRGB(255, 180, 60),
    fog = 14,
    dens = 4,
    apply = Velune.ApplySky_SolarVein,
}

table.insert(Velune.SkyList, Velune.SkyIndex_SolarVein)
function Velune.ApplySky_TidalInk()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_TidalInk"
        sky.SkyboxBk = "rbxassetid://151339901"
        sky.SkyboxDn = "rbxassetid://151339901"
        sky.SkyboxFt = "rbxassetid://151339901"
        sky.SkyboxLf = "rbxassetid://151339901"
        sky.SkyboxRt = "rbxassetid://151339901"
        sky.SkyboxUp = "rbxassetid://151339901"
        sky.StarCount = 660
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 6
        lighting.Brightness = 2.50
        lighting.FogEnd = 1680
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(20, 70, 140)
        lighting.Ambient = Color3.fromRGB(8, 30, 100)
        lighting.OutdoorAmbient = Color3.fromRGB(32, 78, 156)
        lighting.ColorShift_Top = Color3.fromRGB(20, 70, 140)
        lighting.ColorShift_Bottom = Color3.fromRGB(7, 24, 56)
        lighting.EnvironmentDiffuseScale = 0.60
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Tidal Ink")
    Velune.PlayTone(138000272, 0.2)
end
Velune.SkyIndex_TidalInk = {
    name = "Tidal Ink",
    id = "151339901",
    color = Color3.fromRGB(20, 70, 140),
    fog = 8,
    dens = 8,
    apply = Velune.ApplySky_TidalInk,
}

table.insert(Velune.SkyList, Velune.SkyIndex_TidalInk)
function Velune.ApplySky_PetalAsh()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_PetalAsh"
        sky.SkyboxBk = "rbxassetid://150739188"
        sky.SkyboxDn = "rbxassetid://150739188"
        sky.SkyboxFt = "rbxassetid://150739188"
        sky.SkyboxLf = "rbxassetid://150739188"
        sky.SkyboxRt = "rbxassetid://150739188"
        sky.SkyboxUp = "rbxassetid://150739188"
        sky.StarCount = 700
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Brightness = 2.40
        lighting.FogEnd = 1900
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(220, 90, 110)
        lighting.Ambient = Color3.fromRGB(180, 50, 70)
        lighting.OutdoorAmbient = Color3.fromRGB(232, 98, 126)
        lighting.ColorShift_Top = Color3.fromRGB(220, 90, 110)
        lighting.ColorShift_Bottom = Color3.fromRGB(77, 31, 44)
        lighting.EnvironmentDiffuseScale = 0.70
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Petal Ash")
    Velune.PlayTone(138000289, 0.2)
end
Velune.SkyIndex_PetalAsh = {
    name = "Petal Ash",
    id = "150739188",
    color = Color3.fromRGB(220, 90, 110),
    fog = 16,
    dens = 5,
    apply = Velune.ApplySky_PetalAsh,
}

table.insert(Velune.SkyList, Velune.SkyIndex_PetalAsh)
function Velune.ApplySky_FrostBit()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_FrostBit"
        sky.SkyboxBk = "rbxassetid://149979410"
        sky.SkyboxDn = "rbxassetid://149979410"
        sky.SkyboxFt = "rbxassetid://149979410"
        sky.SkyboxLf = "rbxassetid://149979410"
        sky.SkyboxRt = "rbxassetid://149979410"
        sky.SkyboxUp = "rbxassetid://149979410"
        sky.StarCount = 740
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 7
        lighting.Brightness = 2.00
        lighting.FogEnd = 2120
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(180, 220, 255)
        lighting.Ambient = Color3.fromRGB(140, 180, 215)
        lighting.OutdoorAmbient = Color3.fromRGB(192, 228, 255)
        lighting.ColorShift_Top = Color3.fromRGB(180, 220, 255)
        lighting.ColorShift_Bottom = Color3.fromRGB(62, 77, 102)
        lighting.EnvironmentDiffuseScale = 0.80
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Frost Bit")
    Velune.PlayTone(138000306, 0.2)
end
Velune.SkyIndex_FrostBit = {
    name = "Frost Bit",
    id = "149979410",
    color = Color3.fromRGB(180, 220, 255),
    fog = 6,
    dens = 9,
    apply = Velune.ApplySky_FrostBit,
}

table.insert(Velune.SkyList, Velune.SkyIndex_FrostBit)
function Velune.ApplySky_MagmaSilk()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_MagmaSilk"
        sky.SkyboxBk = "rbxassetid://153662501"
        sky.SkyboxDn = "rbxassetid://153662501"
        sky.SkyboxFt = "rbxassetid://153662501"
        sky.SkyboxLf = "rbxassetid://153662501"
        sky.SkyboxRt = "rbxassetid://153662501"
        sky.SkyboxUp = "rbxassetid://153662501"
        sky.StarCount = 780
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 19
        lighting.Brightness = 3.30
        lighting.FogEnd = 2340
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(240, 80, 20)
        lighting.Ambient = Color3.fromRGB(200, 40, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(252, 88, 36)
        lighting.ColorShift_Top = Color3.fromRGB(240, 80, 20)
        lighting.ColorShift_Bottom = Color3.fromRGB(84, 28, 8)
        lighting.EnvironmentDiffuseScale = 0.90
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Magma Silk")
    Velune.PlayTone(138000323, 0.2)
end
Velune.SkyIndex_MagmaSilk = {
    name = "Magma Silk",
    id = "153662501",
    color = Color3.fromRGB(240, 80, 20),
    fog = 18,
    dens = 3,
    apply = Velune.ApplySky_MagmaSilk,
}

table.insert(Velune.SkyList, Velune.SkyIndex_MagmaSilk)
function Velune.ApplySky_MossLantern()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_MossLantern"
        sky.SkyboxBk = "rbxassetid://120641222"
        sky.SkyboxDn = "rbxassetid://120641222"
        sky.SkyboxFt = "rbxassetid://120641222"
        sky.SkyboxLf = "rbxassetid://120641222"
        sky.SkyboxRt = "rbxassetid://120641222"
        sky.SkyboxUp = "rbxassetid://120641222"
        sky.StarCount = 820
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 11
        lighting.Brightness = 2.60
        lighting.FogEnd = 2560
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(70, 140, 60)
        lighting.Ambient = Color3.fromRGB(30, 100, 20)
        lighting.OutdoorAmbient = Color3.fromRGB(82, 148, 76)
        lighting.ColorShift_Top = Color3.fromRGB(70, 140, 60)
        lighting.ColorShift_Bottom = Color3.fromRGB(24, 49, 24)
        lighting.EnvironmentDiffuseScale = 0.00
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Moss Lantern")
    Velune.PlayTone(138000340, 0.2)
end
Velune.SkyIndex_MossLantern = {
    name = "Moss Lantern",
    id = "120641222",
    color = Color3.fromRGB(70, 140, 60),
    fog = 13,
    dens = 7,
    apply = Velune.ApplySky_MossLantern,
}

table.insert(Velune.SkyList, Velune.SkyIndex_MossLantern)
function Velune.ApplySky_VioletRift()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_VioletRift"
        sky.SkyboxBk = "rbxassetid://149535044"
        sky.SkyboxDn = "rbxassetid://149535044"
        sky.SkyboxFt = "rbxassetid://149535044"
        sky.SkyboxLf = "rbxassetid://149535044"
        sky.SkyboxRt = "rbxassetid://149535044"
        sky.SkyboxUp = "rbxassetid://149535044"
        sky.StarCount = 860
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 5
        lighting.Brightness = 2.20
        lighting.FogEnd = 2780
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(120, 50, 200)
        lighting.Ambient = Color3.fromRGB(80, 10, 160)
        lighting.OutdoorAmbient = Color3.fromRGB(132, 58, 216)
        lighting.ColorShift_Top = Color3.fromRGB(120, 50, 200)
        lighting.ColorShift_Bottom = Color3.fromRGB(42, 17, 80)
        lighting.EnvironmentDiffuseScale = 0.10
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Violet Rift")
    Velune.PlayTone(138000357, 0.2)
end
Velune.SkyIndex_VioletRift = {
    name = "Violet Rift",
    id = "149535044",
    color = Color3.fromRGB(120, 50, 200),
    fog = 3,
    dens = 8,
    apply = Velune.ApplySky_VioletRift,
}

table.insert(Velune.SkyList, Velune.SkyIndex_VioletRift)
function Velune.ApplySky_Sandglass()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_Sandglass"
        sky.SkyboxBk = "rbxassetid://150739355"
        sky.SkyboxDn = "rbxassetid://150739355"
        sky.SkyboxFt = "rbxassetid://150739355"
        sky.SkyboxLf = "rbxassetid://150739355"
        sky.SkyboxRt = "rbxassetid://150739355"
        sky.SkyboxUp = "rbxassetid://150739355"
        sky.StarCount = 900
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 15
        lighting.Brightness = 2.90
        lighting.FogEnd = 3000
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(220, 190, 120)
        lighting.Ambient = Color3.fromRGB(180, 150, 80)
        lighting.OutdoorAmbient = Color3.fromRGB(232, 198, 136)
        lighting.ColorShift_Top = Color3.fromRGB(220, 190, 120)
        lighting.ColorShift_Bottom = Color3.fromRGB(77, 66, 48)
        lighting.EnvironmentDiffuseScale = 0.20
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Sandglass")
    Velune.PlayTone(138000374, 0.2)
end
Velune.SkyIndex_Sandglass = {
    name = "Sandglass",
    id = "150739355",
    color = Color3.fromRGB(220, 190, 120),
    fog = 15,
    dens = 5,
    apply = Velune.ApplySky_Sandglass,
}

table.insert(Velune.SkyList, Velune.SkyIndex_Sandglass)
function Velune.ApplySky_CarbonHalo()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CarbonHalo"
        sky.SkyboxBk = "rbxassetid://162619850"
        sky.SkyboxDn = "rbxassetid://162619850"
        sky.SkyboxFt = "rbxassetid://162619850"
        sky.SkyboxLf = "rbxassetid://162619850"
        sky.SkyboxRt = "rbxassetid://162619850"
        sky.SkyboxUp = "rbxassetid://162619850"
        sky.StarCount = 940
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 4
        lighting.Brightness = 1.60
        lighting.FogEnd = 3220
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(50, 50, 55)
        lighting.Ambient = Color3.fromRGB(10, 10, 15)
        lighting.OutdoorAmbient = Color3.fromRGB(62, 58, 71)
        lighting.ColorShift_Top = Color3.fromRGB(50, 50, 55)
        lighting.ColorShift_Bottom = Color3.fromRGB(17, 17, 22)
        lighting.EnvironmentDiffuseScale = 0.30
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Carbon Halo")
    Velune.PlayTone(138000391, 0.2)
end
Velune.SkyIndex_CarbonHalo = {
    name = "Carbon Halo",
    id = "162619850",
    color = Color3.fromRGB(50, 50, 55),
    fog = 2,
    dens = 9,
    apply = Velune.ApplySky_CarbonHalo,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CarbonHalo)
function Velune.ApplySky_CherryStatic()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CherryStatic"
        sky.SkyboxBk = "rbxassetid://150739201"
        sky.SkyboxDn = "rbxassetid://150739201"
        sky.SkyboxFt = "rbxassetid://150739201"
        sky.SkyboxLf = "rbxassetid://150739201"
        sky.SkyboxRt = "rbxassetid://150739201"
        sky.SkyboxUp = "rbxassetid://150739201"
        sky.StarCount = 980
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 16
        lighting.Brightness = 2.50
        lighting.FogEnd = 800
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(230, 40, 80)
        lighting.Ambient = Color3.fromRGB(190, 8, 40)
        lighting.OutdoorAmbient = Color3.fromRGB(242, 48, 96)
        lighting.ColorShift_Top = Color3.fromRGB(230, 40, 80)
        lighting.ColorShift_Bottom = Color3.fromRGB(80, 14, 32)
        lighting.EnvironmentDiffuseScale = 0.40
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Cherry Static")
    Velune.PlayTone(138000408, 0.2)
end
Velune.SkyIndex_CherryStatic = {
    name = "Cherry Static",
    id = "150739201",
    color = Color3.fromRGB(230, 40, 80),
    fog = 19,
    dens = 4,
    apply = Velune.ApplySky_CherryStatic,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CherryStatic)
function Velune.ApplySky_TealPulse()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_TealPulse"
        sky.SkyboxBk = "rbxassetid://151339877"
        sky.SkyboxDn = "rbxassetid://151339877"
        sky.SkyboxFt = "rbxassetid://151339877"
        sky.SkyboxLf = "rbxassetid://151339877"
        sky.SkyboxRt = "rbxassetid://151339877"
        sky.SkyboxUp = "rbxassetid://151339877"
        sky.StarCount = 1020
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 9
        lighting.Brightness = 2.80
        lighting.FogEnd = 1020
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(20, 180, 180)
        lighting.Ambient = Color3.fromRGB(8, 140, 140)
        lighting.OutdoorAmbient = Color3.fromRGB(32, 188, 196)
        lighting.ColorShift_Top = Color3.fromRGB(20, 180, 180)
        lighting.ColorShift_Bottom = Color3.fromRGB(7, 62, 72)
        lighting.EnvironmentDiffuseScale = 0.50
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Teal Pulse")
    Velune.PlayTone(138000425, 0.2)
end
Velune.SkyIndex_TealPulse = {
    name = "Teal Pulse",
    id = "151339877",
    color = Color3.fromRGB(20, 180, 180),
    fog = 9,
    dens = 6,
    apply = Velune.ApplySky_TealPulse,
}

table.insert(Velune.SkyList, Velune.SkyIndex_TealPulse)
function Velune.ApplySky_Goldleaf()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_Goldleaf"
        sky.SkyboxBk = "rbxassetid://150739366"
        sky.SkyboxDn = "rbxassetid://150739366"
        sky.SkyboxFt = "rbxassetid://150739366"
        sky.SkyboxLf = "rbxassetid://150739366"
        sky.SkyboxRt = "rbxassetid://150739366"
        sky.SkyboxUp = "rbxassetid://150739366"
        sky.StarCount = 1060
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 16
        lighting.Brightness = 3.10
        lighting.FogEnd = 1240
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(240, 200, 80)
        lighting.Ambient = Color3.fromRGB(200, 160, 40)
        lighting.OutdoorAmbient = Color3.fromRGB(252, 208, 96)
        lighting.ColorShift_Top = Color3.fromRGB(240, 200, 80)
        lighting.ColorShift_Bottom = Color3.fromRGB(84, 70, 32)
        lighting.EnvironmentDiffuseScale = 0.60
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Goldleaf")
    Velune.PlayTone(138000442, 0.2)
end
Velune.SkyIndex_Goldleaf = {
    name = "Goldleaf",
    id = "150739366",
    color = Color3.fromRGB(240, 200, 80),
    fog = 14,
    dens = 5,
    apply = Velune.ApplySky_Goldleaf,
}

table.insert(Velune.SkyList, Velune.SkyIndex_Goldleaf)
function Velune.ApplySky_MidnightOil()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_MidnightOil"
        sky.SkyboxBk = "rbxassetid://162619820"
        sky.SkyboxDn = "rbxassetid://162619820"
        sky.SkyboxFt = "rbxassetid://162619820"
        sky.SkyboxLf = "rbxassetid://162619820"
        sky.SkyboxRt = "rbxassetid://162619820"
        sky.SkyboxUp = "rbxassetid://162619820"
        sky.StarCount = 1100
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 1
        lighting.Brightness = 1.20
        lighting.FogEnd = 1460
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(12, 16, 28)
        lighting.Ambient = Color3.fromRGB(8, 8, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(24, 24, 44)
        lighting.ColorShift_Top = Color3.fromRGB(12, 16, 28)
        lighting.ColorShift_Bottom = Color3.fromRGB(4, 5, 11)
        lighting.EnvironmentDiffuseScale = 0.70
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Midnight Oil")
    Velune.PlayTone(138000459, 0.2)
end
Velune.SkyIndex_MidnightOil = {
    name = "Midnight Oil",
    id = "162619820",
    color = Color3.fromRGB(12, 16, 28),
    fog = 0,
    dens = 10,
    apply = Velune.ApplySky_MidnightOil,
}

table.insert(Velune.SkyList, Velune.SkyIndex_MidnightOil)
function Velune.ApplySky_PeachMirage()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_PeachMirage"
        sky.SkyboxBk = "rbxassetid://150739277"
        sky.SkyboxDn = "rbxassetid://150739277"
        sky.SkyboxFt = "rbxassetid://150739277"
        sky.SkyboxLf = "rbxassetid://150739277"
        sky.SkyboxRt = "rbxassetid://150739277"
        sky.SkyboxUp = "rbxassetid://150739277"
        sky.StarCount = 1140
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 15
        lighting.Brightness = 2.40
        lighting.FogEnd = 1680
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(255, 170, 140)
        lighting.Ambient = Color3.fromRGB(215, 130, 100)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 178, 156)
        lighting.ColorShift_Top = Color3.fromRGB(255, 170, 140)
        lighting.ColorShift_Bottom = Color3.fromRGB(89, 59, 56)
        lighting.EnvironmentDiffuseScale = 0.80
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Peach Mirage")
    Velune.PlayTone(138000476, 0.2)
end
Velune.SkyIndex_PeachMirage = {
    name = "Peach Mirage",
    id = "150739277",
    color = Color3.fromRGB(255, 170, 140),
    fog = 16,
    dens = 5,
    apply = Velune.ApplySky_PeachMirage,
}

table.insert(Velune.SkyList, Velune.SkyIndex_PeachMirage)
function Velune.ApplySky_IndigoWell()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_IndigoWell"
        sky.SkyboxBk = "rbxassetid://149535110"
        sky.SkyboxDn = "rbxassetid://149535110"
        sky.SkyboxFt = "rbxassetid://149535110"
        sky.SkyboxLf = "rbxassetid://149535110"
        sky.SkyboxRt = "rbxassetid://149535110"
        sky.SkyboxUp = "rbxassetid://149535110"
        sky.StarCount = 1180
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 4
        lighting.Brightness = 2.00
        lighting.FogEnd = 1900
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(50, 40, 160)
        lighting.Ambient = Color3.fromRGB(10, 8, 120)
        lighting.OutdoorAmbient = Color3.fromRGB(62, 48, 176)
        lighting.ColorShift_Top = Color3.fromRGB(50, 40, 160)
        lighting.ColorShift_Bottom = Color3.fromRGB(17, 14, 64)
        lighting.EnvironmentDiffuseScale = 0.90
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Indigo Well")
    Velune.PlayTone(138000493, 0.2)
end
Velune.SkyIndex_IndigoWell = {
    name = "Indigo Well",
    id = "149535110",
    color = Color3.fromRGB(50, 40, 160),
    fog = 2,
    dens = 9,
    apply = Velune.ApplySky_IndigoWell,
}

table.insert(Velune.SkyList, Velune.SkyIndex_IndigoWell)
function Velune.ApplySky_FernGlow()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_FernGlow"
        sky.SkyboxBk = "rbxassetid://120641355"
        sky.SkyboxDn = "rbxassetid://120641355"
        sky.SkyboxFt = "rbxassetid://120641355"
        sky.SkyboxLf = "rbxassetid://120641355"
        sky.SkyboxRt = "rbxassetid://120641355"
        sky.SkyboxUp = "rbxassetid://120641355"
        sky.StarCount = 1220
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 12
        lighting.Brightness = 2.70
        lighting.FogEnd = 2120
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(80, 190, 90)
        lighting.Ambient = Color3.fromRGB(40, 150, 50)
        lighting.OutdoorAmbient = Color3.fromRGB(92, 198, 106)
        lighting.ColorShift_Top = Color3.fromRGB(80, 190, 90)
        lighting.ColorShift_Bottom = Color3.fromRGB(28, 66, 36)
        lighting.EnvironmentDiffuseScale = 0.00
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Fern Glow")
    Velune.PlayTone(138000510, 0.2)
end
Velune.SkyIndex_FernGlow = {
    name = "Fern Glow",
    id = "120641355",
    color = Color3.fromRGB(80, 190, 90),
    fog = 12,
    dens = 7,
    apply = Velune.ApplySky_FernGlow,
}

table.insert(Velune.SkyList, Velune.SkyIndex_FernGlow)
function Velune.ApplySky_RubyCircuit()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_RubyCircuit"
        sky.SkyboxBk = "rbxassetid://149979533"
        sky.SkyboxDn = "rbxassetid://149979533"
        sky.SkyboxFt = "rbxassetid://149979533"
        sky.SkyboxLf = "rbxassetid://149979533"
        sky.SkyboxRt = "rbxassetid://149979533"
        sky.SkyboxUp = "rbxassetid://149979533"
        sky.StarCount = 1260
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 18
        lighting.Brightness = 2.80
        lighting.FogEnd = 2340
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(210, 20, 50)
        lighting.Ambient = Color3.fromRGB(170, 8, 10)
        lighting.OutdoorAmbient = Color3.fromRGB(222, 28, 66)
        lighting.ColorShift_Top = Color3.fromRGB(210, 20, 50)
        lighting.ColorShift_Bottom = Color3.fromRGB(73, 7, 20)
        lighting.EnvironmentDiffuseScale = 0.10
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Ruby Circuit")
    Velune.PlayTone(138000527, 0.2)
end
Velune.SkyIndex_RubyCircuit = {
    name = "Ruby Circuit",
    id = "149979533",
    color = Color3.fromRGB(210, 20, 50),
    fog = 20,
    dens = 4,
    apply = Velune.ApplySky_RubyCircuit,
}

table.insert(Velune.SkyList, Velune.SkyIndex_RubyCircuit)
function Velune.ApplySky_CloudBone()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CloudBone"
        sky.SkyboxBk = "rbxassetid://150739240"
        sky.SkyboxDn = "rbxassetid://150739240"
        sky.SkyboxFt = "rbxassetid://150739240"
        sky.SkyboxLf = "rbxassetid://150739240"
        sky.SkyboxRt = "rbxassetid://150739240"
        sky.SkyboxUp = "rbxassetid://150739240"
        sky.StarCount = 1300
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Brightness = 2.10
        lighting.FogEnd = 2560
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(230, 230, 235)
        lighting.Ambient = Color3.fromRGB(190, 190, 195)
        lighting.OutdoorAmbient = Color3.fromRGB(242, 238, 251)
        lighting.ColorShift_Top = Color3.fromRGB(230, 230, 235)
        lighting.ColorShift_Bottom = Color3.fromRGB(80, 80, 94)
        lighting.EnvironmentDiffuseScale = 0.20
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Cloud Bone")
    Velune.PlayTone(138000544, 0.2)
end
Velune.SkyIndex_CloudBone = {
    name = "Cloud Bone",
    id = "150739240",
    color = Color3.fromRGB(230, 230, 235),
    fog = 8,
    dens = 8,
    apply = Velune.ApplySky_CloudBone,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CloudBone)
function Velune.ApplySky_AbyssGreen()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_AbyssGreen"
        sky.SkyboxBk = "rbxassetid://120641280"
        sky.SkyboxDn = "rbxassetid://120641280"
        sky.SkyboxFt = "rbxassetid://120641280"
        sky.SkyboxLf = "rbxassetid://120641280"
        sky.SkyboxRt = "rbxassetid://120641280"
        sky.SkyboxUp = "rbxassetid://120641280"
        sky.StarCount = 1340
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 3
        lighting.Brightness = 1.80
        lighting.FogEnd = 2780
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(10, 80, 50)
        lighting.Ambient = Color3.fromRGB(8, 40, 10)
        lighting.OutdoorAmbient = Color3.fromRGB(22, 88, 66)
        lighting.ColorShift_Top = Color3.fromRGB(10, 80, 50)
        lighting.ColorShift_Bottom = Color3.fromRGB(3, 28, 20)
        lighting.EnvironmentDiffuseScale = 0.30
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Abyss Green")
    Velune.PlayTone(138000561, 0.2)
end
Velune.SkyIndex_AbyssGreen = {
    name = "Abyss Green",
    id = "120641280",
    color = Color3.fromRGB(10, 80, 50),
    fog = 2,
    dens = 9,
    apply = Velune.ApplySky_AbyssGreen,
}

table.insert(Velune.SkyList, Velune.SkyIndex_AbyssGreen)
function Velune.ApplySky_SunsetWire()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_SunsetWire"
        sky.SkyboxBk = "rbxassetid://153662450"
        sky.SkyboxDn = "rbxassetid://153662450"
        sky.SkyboxFt = "rbxassetid://153662450"
        sky.SkyboxLf = "rbxassetid://153662450"
        sky.SkyboxRt = "rbxassetid://153662450"
        sky.SkyboxUp = "rbxassetid://153662450"
        sky.StarCount = 1380
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 17
        lighting.Brightness = 3.00
        lighting.FogEnd = 3000
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(255, 110, 50)
        lighting.Ambient = Color3.fromRGB(215, 70, 10)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 118, 66)
        lighting.ColorShift_Top = Color3.fromRGB(255, 110, 50)
        lighting.ColorShift_Bottom = Color3.fromRGB(89, 38, 20)
        lighting.EnvironmentDiffuseScale = 0.40
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Sunset Wire")
    Velune.PlayTone(138000578, 0.2)
end
Velune.SkyIndex_SunsetWire = {
    name = "Sunset Wire",
    id = "153662450",
    color = Color3.fromRGB(255, 110, 50),
    fog = 18,
    dens = 4,
    apply = Velune.ApplySky_SunsetWire,
}

table.insert(Velune.SkyList, Velune.SkyIndex_SunsetWire)
function Velune.ApplySky_CobaltDust()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CobaltDust"
        sky.SkyboxBk = "rbxassetid://151339920"
        sky.SkyboxDn = "rbxassetid://151339920"
        sky.SkyboxFt = "rbxassetid://151339920"
        sky.SkyboxLf = "rbxassetid://151339920"
        sky.SkyboxRt = "rbxassetid://151339920"
        sky.SkyboxUp = "rbxassetid://151339920"
        sky.StarCount = 1420
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 7
        lighting.Brightness = 2.60
        lighting.FogEnd = 3220
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(40, 80, 190)
        lighting.Ambient = Color3.fromRGB(8, 40, 150)
        lighting.OutdoorAmbient = Color3.fromRGB(52, 88, 206)
        lighting.ColorShift_Top = Color3.fromRGB(40, 80, 190)
        lighting.ColorShift_Bottom = Color3.fromRGB(14, 28, 76)
        lighting.EnvironmentDiffuseScale = 0.50
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Cobalt Dust")
    Velune.PlayTone(138000595, 0.2)
end
Velune.SkyIndex_CobaltDust = {
    name = "Cobalt Dust",
    id = "151339920",
    color = Color3.fromRGB(40, 80, 190),
    fog = 9,
    dens = 7,
    apply = Velune.ApplySky_CobaltDust,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CobaltDust)
function Velune.ApplySky_WineCellar()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_WineCellar"
        sky.SkyboxBk = "rbxassetid://149979560"
        sky.SkyboxDn = "rbxassetid://149979560"
        sky.SkyboxFt = "rbxassetid://149979560"
        sky.SkyboxLf = "rbxassetid://149979560"
        sky.SkyboxRt = "rbxassetid://149979560"
        sky.SkyboxUp = "rbxassetid://149979560"
        sky.StarCount = 1460
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 8
        lighting.Brightness = 1.90
        lighting.FogEnd = 800
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(120, 20, 40)
        lighting.Ambient = Color3.fromRGB(80, 8, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(132, 28, 56)
        lighting.ColorShift_Top = Color3.fromRGB(120, 20, 40)
        lighting.ColorShift_Bottom = Color3.fromRGB(42, 7, 16)
        lighting.EnvironmentDiffuseScale = 0.60
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Wine Cellar")
    Velune.PlayTone(138000612, 0.2)
end
Velune.SkyIndex_WineCellar = {
    name = "Wine Cellar",
    id = "149979560",
    color = Color3.fromRGB(120, 20, 40),
    fog = 19,
    dens = 6,
    apply = Velune.ApplySky_WineCellar,
}

table.insert(Velune.SkyList, Velune.SkyIndex_WineCellar)
function Velune.ApplySky_LimeStatic()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_LimeStatic"
        sky.SkyboxBk = "rbxassetid://120641330"
        sky.SkyboxDn = "rbxassetid://120641330"
        sky.SkyboxFt = "rbxassetid://120641330"
        sky.SkyboxLf = "rbxassetid://120641330"
        sky.SkyboxRt = "rbxassetid://120641330"
        sky.SkyboxUp = "rbxassetid://120641330"
        sky.StarCount = 1500
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 13
        lighting.Brightness = 2.90
        lighting.FogEnd = 1020
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(140, 230, 70)
        lighting.Ambient = Color3.fromRGB(100, 190, 30)
        lighting.OutdoorAmbient = Color3.fromRGB(152, 238, 86)
        lighting.ColorShift_Top = Color3.fromRGB(140, 230, 70)
        lighting.ColorShift_Bottom = Color3.fromRGB(49, 80, 28)
        lighting.EnvironmentDiffuseScale = 0.70
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Lime Static")
    Velune.PlayTone(138000629, 0.2)
end
Velune.SkyIndex_LimeStatic = {
    name = "Lime Static",
    id = "120641330",
    color = Color3.fromRGB(140, 230, 70),
    fog = 11,
    dens = 6,
    apply = Velune.ApplySky_LimeStatic,
}

table.insert(Velune.SkyList, Velune.SkyIndex_LimeStatic)
function Velune.ApplySky_PearlDusk()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_PearlDusk"
        sky.SkyboxBk = "rbxassetid://150739260"
        sky.SkyboxDn = "rbxassetid://150739260"
        sky.SkyboxFt = "rbxassetid://150739260"
        sky.SkyboxLf = "rbxassetid://150739260"
        sky.SkyboxRt = "rbxassetid://150739260"
        sky.SkyboxUp = "rbxassetid://150739260"
        sky.StarCount = 1540
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Brightness = 2.20
        lighting.FogEnd = 1240
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(240, 210, 200)
        lighting.Ambient = Color3.fromRGB(200, 170, 160)
        lighting.OutdoorAmbient = Color3.fromRGB(252, 218, 216)
        lighting.ColorShift_Top = Color3.fromRGB(240, 210, 200)
        lighting.ColorShift_Bottom = Color3.fromRGB(84, 73, 80)
        lighting.EnvironmentDiffuseScale = 0.80
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Pearl Dusk")
    Velune.PlayTone(138000646, 0.2)
end
Velune.SkyIndex_PearlDusk = {
    name = "Pearl Dusk",
    id = "150739260",
    color = Color3.fromRGB(240, 210, 200),
    fog = 17,
    dens = 5,
    apply = Velune.ApplySky_PearlDusk,
}

table.insert(Velune.SkyList, Velune.SkyIndex_PearlDusk)
function Velune.ApplySky_Graphite()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_Graphite"
        sky.SkyboxBk = "rbxassetid://162619880"
        sky.SkyboxDn = "rbxassetid://162619880"
        sky.SkyboxFt = "rbxassetid://162619880"
        sky.SkyboxLf = "rbxassetid://162619880"
        sky.SkyboxRt = "rbxassetid://162619880"
        sky.SkyboxUp = "rbxassetid://162619880"
        sky.StarCount = 1580
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 3
        lighting.Brightness = 1.50
        lighting.FogEnd = 1460
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(40, 42, 48)
        lighting.Ambient = Color3.fromRGB(8, 8, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(52, 50, 64)
        lighting.ColorShift_Top = Color3.fromRGB(40, 42, 48)
        lighting.ColorShift_Bottom = Color3.fromRGB(14, 14, 19)
        lighting.EnvironmentDiffuseScale = 0.90
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Graphite")
    Velune.PlayTone(138000663, 0.2)
end
Velune.SkyIndex_Graphite = {
    name = "Graphite",
    id = "162619880",
    color = Color3.fromRGB(40, 42, 48),
    fog = 1,
    dens = 9,
    apply = Velune.ApplySky_Graphite,
}

table.insert(Velune.SkyList, Velune.SkyIndex_Graphite)
function Velune.ApplySky_OrchidBurn()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_OrchidBurn"
        sky.SkyboxBk = "rbxassetid://149535070"
        sky.SkyboxDn = "rbxassetid://149535070"
        sky.SkyboxFt = "rbxassetid://149535070"
        sky.SkyboxLf = "rbxassetid://149535070"
        sky.SkyboxRt = "rbxassetid://149535070"
        sky.SkyboxUp = "rbxassetid://149535070"
        sky.StarCount = 1620
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 10
        lighting.Brightness = 2.30
        lighting.FogEnd = 1680
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(190, 70, 180)
        lighting.Ambient = Color3.fromRGB(150, 30, 140)
        lighting.OutdoorAmbient = Color3.fromRGB(202, 78, 196)
        lighting.ColorShift_Top = Color3.fromRGB(190, 70, 180)
        lighting.ColorShift_Bottom = Color3.fromRGB(66, 24, 72)
        lighting.EnvironmentDiffuseScale = 0.00
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Orchid Burn")
    Velune.PlayTone(138000680, 0.2)
end
Velune.SkyIndex_OrchidBurn = {
    name = "Orchid Burn",
    id = "149535070",
    color = Color3.fromRGB(190, 70, 180),
    fog = 5,
    dens = 7,
    apply = Velune.ApplySky_OrchidBurn,
}

table.insert(Velune.SkyList, Velune.SkyIndex_OrchidBurn)
function Velune.ApplySky_Honeycomb()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_Honeycomb"
        sky.SkyboxBk = "rbxassetid://150739340"
        sky.SkyboxDn = "rbxassetid://150739340"
        sky.SkyboxFt = "rbxassetid://150739340"
        sky.SkyboxLf = "rbxassetid://150739340"
        sky.SkyboxRt = "rbxassetid://150739340"
        sky.SkyboxUp = "rbxassetid://150739340"
        sky.StarCount = 1660
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 16
        lighting.Brightness = 3.00
        lighting.FogEnd = 1900
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(240, 180, 70)
        lighting.Ambient = Color3.fromRGB(200, 140, 30)
        lighting.OutdoorAmbient = Color3.fromRGB(252, 188, 86)
        lighting.ColorShift_Top = Color3.fromRGB(240, 180, 70)
        lighting.ColorShift_Bottom = Color3.fromRGB(84, 62, 28)
        lighting.EnvironmentDiffuseScale = 0.10
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Honeycomb")
    Velune.PlayTone(138000697, 0.2)
end
Velune.SkyIndex_Honeycomb = {
    name = "Honeycomb",
    id = "150739340",
    color = Color3.fromRGB(240, 180, 70),
    fog = 15,
    dens = 5,
    apply = Velune.ApplySky_Honeycomb,
}

table.insert(Velune.SkyList, Velune.SkyIndex_Honeycomb)
function Velune.ApplySky_DeepTeal()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_DeepTeal"
        sky.SkyboxBk = "rbxassetid://151339890"
        sky.SkyboxDn = "rbxassetid://151339890"
        sky.SkyboxFt = "rbxassetid://151339890"
        sky.SkyboxLf = "rbxassetid://151339890"
        sky.SkyboxRt = "rbxassetid://151339890"
        sky.SkyboxUp = "rbxassetid://151339890"
        sky.StarCount = 1700
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 5
        lighting.Brightness = 2.10
        lighting.FogEnd = 2120
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(10, 90, 90)
        lighting.Ambient = Color3.fromRGB(8, 50, 50)
        lighting.OutdoorAmbient = Color3.fromRGB(22, 98, 106)
        lighting.ColorShift_Top = Color3.fromRGB(10, 90, 90)
        lighting.ColorShift_Bottom = Color3.fromRGB(3, 31, 36)
        lighting.EnvironmentDiffuseScale = 0.20
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Deep Teal")
    Velune.PlayTone(138000714, 0.2)
end
Velune.SkyIndex_DeepTeal = {
    name = "Deep Teal",
    id = "151339890",
    color = Color3.fromRGB(10, 90, 90),
    fog = 7,
    dens = 8,
    apply = Velune.ApplySky_DeepTeal,
}

table.insert(Velune.SkyList, Velune.SkyIndex_DeepTeal)
function Velune.ApplySky_ScarletVeil()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_ScarletVeil"
        sky.SkyboxBk = "rbxassetid://149979490"
        sky.SkyboxDn = "rbxassetid://149979490"
        sky.SkyboxFt = "rbxassetid://149979490"
        sky.SkyboxLf = "rbxassetid://149979490"
        sky.SkyboxRt = "rbxassetid://149979490"
        sky.SkyboxUp = "rbxassetid://149979490"
        sky.StarCount = 1740
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 17
        lighting.Brightness = 2.70
        lighting.FogEnd = 2340
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(200, 16, 32)
        lighting.Ambient = Color3.fromRGB(160, 8, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(212, 24, 48)
        lighting.ColorShift_Top = Color3.fromRGB(200, 16, 32)
        lighting.ColorShift_Bottom = Color3.fromRGB(70, 5, 12)
        lighting.EnvironmentDiffuseScale = 0.30
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Scarlet Veil")
    Velune.PlayTone(138000731, 0.2)
end
Velune.SkyIndex_ScarletVeil = {
    name = "Scarlet Veil",
    id = "149979490",
    color = Color3.fromRGB(200, 16, 32),
    fog = 20,
    dens = 4,
    apply = Velune.ApplySky_ScarletVeil,
}

table.insert(Velune.SkyList, Velune.SkyIndex_ScarletVeil)
function Velune.ApplySky_IceOrchard()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_IceOrchard"
        sky.SkyboxBk = "rbxassetid://149979400"
        sky.SkyboxDn = "rbxassetid://149979400"
        sky.SkyboxFt = "rbxassetid://149979400"
        sky.SkyboxLf = "rbxassetid://149979400"
        sky.SkyboxRt = "rbxassetid://149979400"
        sky.SkyboxUp = "rbxassetid://149979400"
        sky.StarCount = 1780
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 8
        lighting.Brightness = 2.00
        lighting.FogEnd = 2560
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(200, 230, 240)
        lighting.Ambient = Color3.fromRGB(160, 190, 200)
        lighting.OutdoorAmbient = Color3.fromRGB(212, 238, 255)
        lighting.ColorShift_Top = Color3.fromRGB(200, 230, 240)
        lighting.ColorShift_Bottom = Color3.fromRGB(70, 80, 96)
        lighting.EnvironmentDiffuseScale = 0.40
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Ice Orchard")
    Velune.PlayTone(138000748, 0.2)
end
Velune.SkyIndex_IceOrchard = {
    name = "Ice Orchard",
    id = "149979400",
    color = Color3.fromRGB(200, 230, 240),
    fog = 6,
    dens = 9,
    apply = Velune.ApplySky_IceOrchard,
}

table.insert(Velune.SkyList, Velune.SkyIndex_IceOrchard)
function Velune.ApplySky_BronzeMoon()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_BronzeMoon"
        sky.SkyboxBk = "rbxassetid://153662410"
        sky.SkyboxDn = "rbxassetid://153662410"
        sky.SkyboxFt = "rbxassetid://153662410"
        sky.SkyboxLf = "rbxassetid://153662410"
        sky.SkyboxRt = "rbxassetid://153662410"
        sky.SkyboxUp = "rbxassetid://153662410"
        sky.StarCount = 1820
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 13
        lighting.Brightness = 2.80
        lighting.FogEnd = 2780
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(180, 120, 60)
        lighting.Ambient = Color3.fromRGB(140, 80, 20)
        lighting.OutdoorAmbient = Color3.fromRGB(192, 128, 76)
        lighting.ColorShift_Top = Color3.fromRGB(180, 120, 60)
        lighting.ColorShift_Bottom = Color3.fromRGB(62, 42, 24)
        lighting.EnvironmentDiffuseScale = 0.50
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Bronze Moon")
    Velune.PlayTone(138000765, 0.2)
end
Velune.SkyIndex_BronzeMoon = {
    name = "Bronze Moon",
    id = "153662410",
    color = Color3.fromRGB(180, 120, 60),
    fog = 16,
    dens = 6,
    apply = Velune.ApplySky_BronzeMoon,
}

table.insert(Velune.SkyList, Velune.SkyIndex_BronzeMoon)
function Velune.ApplySky_NeonRain()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_NeonRain"
        sky.SkyboxBk = "rbxassetid://149535020"
        sky.SkyboxDn = "rbxassetid://149535020"
        sky.SkyboxFt = "rbxassetid://149535020"
        sky.SkyboxLf = "rbxassetid://149535020"
        sky.SkyboxRt = "rbxassetid://149535020"
        sky.SkyboxUp = "rbxassetid://149535020"
        sky.StarCount = 1860
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 9
        lighting.Brightness = 2.60
        lighting.FogEnd = 3000
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(80, 255, 180)
        lighting.Ambient = Color3.fromRGB(40, 215, 140)
        lighting.OutdoorAmbient = Color3.fromRGB(92, 255, 196)
        lighting.ColorShift_Top = Color3.fromRGB(80, 255, 180)
        lighting.ColorShift_Bottom = Color3.fromRGB(28, 89, 72)
        lighting.EnvironmentDiffuseScale = 0.60
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Neon Rain")
    Velune.PlayTone(138000782, 0.2)
end
Velune.SkyIndex_NeonRain = {
    name = "Neon Rain",
    id = "149535020",
    color = Color3.fromRGB(80, 255, 180),
    fog = 4,
    dens = 7,
    apply = Velune.ApplySky_NeonRain,
}

table.insert(Velune.SkyList, Velune.SkyIndex_NeonRain)
function Velune.ApplySky_DustRose()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_DustRose"
        sky.SkyboxBk = "rbxassetid://150739215"
        sky.SkyboxDn = "rbxassetid://150739215"
        sky.SkyboxFt = "rbxassetid://150739215"
        sky.SkyboxLf = "rbxassetid://150739215"
        sky.SkyboxRt = "rbxassetid://150739215"
        sky.SkyboxUp = "rbxassetid://150739215"
        sky.StarCount = 1900
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Brightness = 2.30
        lighting.FogEnd = 3220
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(210, 130, 140)
        lighting.Ambient = Color3.fromRGB(170, 90, 100)
        lighting.OutdoorAmbient = Color3.fromRGB(222, 138, 156)
        lighting.ColorShift_Top = Color3.fromRGB(210, 130, 140)
        lighting.ColorShift_Bottom = Color3.fromRGB(73, 45, 56)
        lighting.EnvironmentDiffuseScale = 0.70
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Dust Rose")
    Velune.PlayTone(138000799, 0.2)
end
Velune.SkyIndex_DustRose = {
    name = "Dust Rose",
    id = "150739215",
    color = Color3.fromRGB(210, 130, 140),
    fog = 17,
    dens = 5,
    apply = Velune.ApplySky_DustRose,
}

table.insert(Velune.SkyList, Velune.SkyIndex_DustRose)
function Velune.ApplySky_InkHarbor()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_InkHarbor"
        sky.SkyboxBk = "rbxassetid://151339940"
        sky.SkyboxDn = "rbxassetid://151339940"
        sky.SkyboxFt = "rbxassetid://151339940"
        sky.SkyboxLf = "rbxassetid://151339940"
        sky.SkyboxRt = "rbxassetid://151339940"
        sky.SkyboxUp = "rbxassetid://151339940"
        sky.StarCount = 1940
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 3
        lighting.Brightness = 1.70
        lighting.FogEnd = 800
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(16, 40, 80)
        lighting.Ambient = Color3.fromRGB(8, 8, 40)
        lighting.OutdoorAmbient = Color3.fromRGB(28, 48, 96)
        lighting.ColorShift_Top = Color3.fromRGB(16, 40, 80)
        lighting.ColorShift_Bottom = Color3.fromRGB(5, 14, 32)
        lighting.EnvironmentDiffuseScale = 0.80
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Ink Harbor")
    Velune.PlayTone(138000816, 0.2)
end
Velune.SkyIndex_InkHarbor = {
    name = "Ink Harbor",
    id = "151339940",
    color = Color3.fromRGB(16, 40, 80),
    fog = 3,
    dens = 9,
    apply = Velune.ApplySky_InkHarbor,
}

table.insert(Velune.SkyList, Velune.SkyIndex_InkHarbor)
function Velune.ApplySky_CinderPink()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CinderPink"
        sky.SkyboxBk = "rbxassetid://150739190"
        sky.SkyboxDn = "rbxassetid://150739190"
        sky.SkyboxFt = "rbxassetid://150739190"
        sky.SkyboxLf = "rbxassetid://150739190"
        sky.SkyboxRt = "rbxassetid://150739190"
        sky.SkyboxUp = "rbxassetid://150739190"
        sky.StarCount = 1980
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 16
        lighting.Brightness = 2.50
        lighting.FogEnd = 1020
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(255, 90, 130)
        lighting.Ambient = Color3.fromRGB(215, 50, 90)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 98, 146)
        lighting.ColorShift_Top = Color3.fromRGB(255, 90, 130)
        lighting.ColorShift_Bottom = Color3.fromRGB(89, 31, 52)
        lighting.EnvironmentDiffuseScale = 0.90
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Cinder Pink")
    Velune.PlayTone(138000833, 0.2)
end
Velune.SkyIndex_CinderPink = {
    name = "Cinder Pink",
    id = "150739190",
    color = Color3.fromRGB(255, 90, 130),
    fog = 18,
    dens = 4,
    apply = Velune.ApplySky_CinderPink,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CinderPink)
function Velune.ApplySky_VelvetOrbit()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_VelvetOrbit"
        sky.SkyboxBk = "rbxassetid://149500000"
        sky.SkyboxDn = "rbxassetid://149500000"
        sky.SkyboxFt = "rbxassetid://149500000"
        sky.SkyboxLf = "rbxassetid://149500000"
        sky.SkyboxRt = "rbxassetid://149500000"
        sky.SkyboxUp = "rbxassetid://149500000"
        sky.StarCount = 2020
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 4
        lighting.Brightness = 1.40
        lighting.FogEnd = 1240
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(20, 18, 24)
        lighting.Ambient = Color3.fromRGB(8, 8, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(32, 26, 40)
        lighting.ColorShift_Top = Color3.fromRGB(20, 18, 24)
        lighting.ColorShift_Bottom = Color3.fromRGB(7, 6, 9)
        lighting.EnvironmentDiffuseScale = 0.00
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Velvet Orbit")
    Velune.PlayTone(138000850, 0.2)
end
Velune.SkyIndex_VelvetOrbit = {
    name = "Velvet Orbit",
    id = "149500000",
    color = Color3.fromRGB(20, 18, 24),
    fog = 0,
    dens = 4,
    apply = Velune.ApplySky_VelvetOrbit,
}

table.insert(Velune.SkyList, Velune.SkyIndex_VelvetOrbit)
function Velune.ApplySky_AshCathedral()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_AshCathedral"
        sky.SkyboxBk = "rbxassetid://149501137"
        sky.SkyboxDn = "rbxassetid://149501137"
        sky.SkyboxFt = "rbxassetid://149501137"
        sky.SkyboxLf = "rbxassetid://149501137"
        sky.SkyboxRt = "rbxassetid://149501137"
        sky.SkyboxUp = "rbxassetid://149501137"
        sky.StarCount = 2060
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 5
        lighting.Brightness = 1.50
        lighting.FogEnd = 1460
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(67, 47, 77)
        lighting.Ambient = Color3.fromRGB(27, 8, 37)
        lighting.OutdoorAmbient = Color3.fromRGB(79, 55, 93)
        lighting.ColorShift_Top = Color3.fromRGB(67, 47, 77)
        lighting.ColorShift_Bottom = Color3.fromRGB(23, 16, 30)
        lighting.EnvironmentDiffuseScale = 0.10
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Ash Cathedral")
    Velune.PlayTone(138000867, 0.2)
end
Velune.SkyIndex_AshCathedral = {
    name = "Ash Cathedral",
    id = "149501137",
    color = Color3.fromRGB(67, 47, 77),
    fog = 1,
    dens = 5,
    apply = Velune.ApplySky_AshCathedral,
}

table.insert(Velune.SkyList, Velune.SkyIndex_AshCathedral)
function Velune.ApplySky_GildedFog()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_GildedFog"
        sky.SkyboxBk = "rbxassetid://149502274"
        sky.SkyboxDn = "rbxassetid://149502274"
        sky.SkyboxFt = "rbxassetid://149502274"
        sky.SkyboxLf = "rbxassetid://149502274"
        sky.SkyboxRt = "rbxassetid://149502274"
        sky.SkyboxUp = "rbxassetid://149502274"
        sky.StarCount = 2100
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 6
        lighting.Brightness = 1.60
        lighting.FogEnd = 1680
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(114, 76, 130)
        lighting.Ambient = Color3.fromRGB(74, 36, 90)
        lighting.OutdoorAmbient = Color3.fromRGB(126, 84, 146)
        lighting.ColorShift_Top = Color3.fromRGB(114, 76, 130)
        lighting.ColorShift_Bottom = Color3.fromRGB(39, 26, 52)
        lighting.EnvironmentDiffuseScale = 0.20
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Gilded Fog")
    Velune.PlayTone(138000884, 0.2)
end
Velune.SkyIndex_GildedFog = {
    name = "Gilded Fog",
    id = "149502274",
    color = Color3.fromRGB(114, 76, 130),
    fog = 2,
    dens = 6,
    apply = Velune.ApplySky_GildedFog,
}

table.insert(Velune.SkyList, Velune.SkyIndex_GildedFog)
function Velune.ApplySky_SilentChrome()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_SilentChrome"
        sky.SkyboxBk = "rbxassetid://149503411"
        sky.SkyboxDn = "rbxassetid://149503411"
        sky.SkyboxFt = "rbxassetid://149503411"
        sky.SkyboxLf = "rbxassetid://149503411"
        sky.SkyboxRt = "rbxassetid://149503411"
        sky.SkyboxUp = "rbxassetid://149503411"
        sky.StarCount = 2140
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 7
        lighting.Brightness = 1.70
        lighting.FogEnd = 1900
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(161, 105, 183)
        lighting.Ambient = Color3.fromRGB(121, 65, 143)
        lighting.OutdoorAmbient = Color3.fromRGB(173, 113, 199)
        lighting.ColorShift_Top = Color3.fromRGB(161, 105, 183)
        lighting.ColorShift_Bottom = Color3.fromRGB(56, 36, 73)
        lighting.EnvironmentDiffuseScale = 0.30
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Silent Chrome")
    Velune.PlayTone(138000901, 0.2)
end
Velune.SkyIndex_SilentChrome = {
    name = "Silent Chrome",
    id = "149503411",
    color = Color3.fromRGB(161, 105, 183),
    fog = 3,
    dens = 7,
    apply = Velune.ApplySky_SilentChrome,
}

table.insert(Velune.SkyList, Velune.SkyIndex_SilentChrome)
function Velune.ApplySky_CoralNight()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CoralNight"
        sky.SkyboxBk = "rbxassetid://149504548"
        sky.SkyboxDn = "rbxassetid://149504548"
        sky.SkyboxFt = "rbxassetid://149504548"
        sky.SkyboxLf = "rbxassetid://149504548"
        sky.SkyboxRt = "rbxassetid://149504548"
        sky.SkyboxUp = "rbxassetid://149504548"
        sky.StarCount = 2180
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 8
        lighting.Brightness = 1.80
        lighting.FogEnd = 2120
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(208, 134, 26)
        lighting.Ambient = Color3.fromRGB(168, 94, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(220, 142, 42)
        lighting.ColorShift_Top = Color3.fromRGB(208, 134, 26)
        lighting.ColorShift_Bottom = Color3.fromRGB(72, 46, 10)
        lighting.EnvironmentDiffuseScale = 0.40
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Coral Night")
    Velune.PlayTone(138000918, 0.2)
end
Velune.SkyIndex_CoralNight = {
    name = "Coral Night",
    id = "149504548",
    color = Color3.fromRGB(208, 134, 26),
    fog = 4,
    dens = 8,
    apply = Velune.ApplySky_CoralNight,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CoralNight)
function Velune.ApplySky_PineSmoke()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_PineSmoke"
        sky.SkyboxBk = "rbxassetid://149505685"
        sky.SkyboxDn = "rbxassetid://149505685"
        sky.SkyboxFt = "rbxassetid://149505685"
        sky.SkyboxLf = "rbxassetid://149505685"
        sky.SkyboxRt = "rbxassetid://149505685"
        sky.SkyboxUp = "rbxassetid://149505685"
        sky.StarCount = 2220
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 9
        lighting.Brightness = 1.90
        lighting.FogEnd = 2340
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(25, 163, 79)
        lighting.Ambient = Color3.fromRGB(8, 123, 39)
        lighting.OutdoorAmbient = Color3.fromRGB(37, 171, 95)
        lighting.ColorShift_Top = Color3.fromRGB(25, 163, 79)
        lighting.ColorShift_Bottom = Color3.fromRGB(8, 57, 31)
        lighting.EnvironmentDiffuseScale = 0.50
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Pine Smoke")
    Velune.PlayTone(138000935, 0.2)
end
Velune.SkyIndex_PineSmoke = {
    name = "Pine Smoke",
    id = "149505685",
    color = Color3.fromRGB(25, 163, 79),
    fog = 5,
    dens = 9,
    apply = Velune.ApplySky_PineSmoke,
}

table.insert(Velune.SkyList, Velune.SkyIndex_PineSmoke)
function Velune.ApplySky_MercuryPool()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_MercuryPool"
        sky.SkyboxBk = "rbxassetid://149506822"
        sky.SkyboxDn = "rbxassetid://149506822"
        sky.SkyboxFt = "rbxassetid://149506822"
        sky.SkyboxLf = "rbxassetid://149506822"
        sky.SkyboxRt = "rbxassetid://149506822"
        sky.SkyboxUp = "rbxassetid://149506822"
        sky.StarCount = 2260
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 10
        lighting.Brightness = 2.00
        lighting.FogEnd = 2560
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(72, 192, 132)
        lighting.Ambient = Color3.fromRGB(32, 152, 92)
        lighting.OutdoorAmbient = Color3.fromRGB(84, 200, 148)
        lighting.ColorShift_Top = Color3.fromRGB(72, 192, 132)
        lighting.ColorShift_Bottom = Color3.fromRGB(25, 67, 52)
        lighting.EnvironmentDiffuseScale = 0.60
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Mercury Pool")
    Velune.PlayTone(138000952, 0.2)
end
Velune.SkyIndex_MercuryPool = {
    name = "Mercury Pool",
    id = "149506822",
    color = Color3.fromRGB(72, 192, 132),
    fog = 6,
    dens = 10,
    apply = Velune.ApplySky_MercuryPool,
}

table.insert(Velune.SkyList, Velune.SkyIndex_MercuryPool)
function Velune.ApplySky_LavaLace()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_LavaLace"
        sky.SkyboxBk = "rbxassetid://149507959"
        sky.SkyboxDn = "rbxassetid://149507959"
        sky.SkyboxFt = "rbxassetid://149507959"
        sky.SkyboxLf = "rbxassetid://149507959"
        sky.SkyboxRt = "rbxassetid://149507959"
        sky.SkyboxUp = "rbxassetid://149507959"
        sky.StarCount = 2300
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 11
        lighting.Brightness = 2.10
        lighting.FogEnd = 2780
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(119, 221, 185)
        lighting.Ambient = Color3.fromRGB(79, 181, 145)
        lighting.OutdoorAmbient = Color3.fromRGB(131, 229, 201)
        lighting.ColorShift_Top = Color3.fromRGB(119, 221, 185)
        lighting.ColorShift_Bottom = Color3.fromRGB(41, 77, 74)
        lighting.EnvironmentDiffuseScale = 0.70
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Lava Lace")
    Velune.PlayTone(138000969, 0.2)
end
Velune.SkyIndex_LavaLace = {
    name = "Lava Lace",
    id = "149507959",
    color = Color3.fromRGB(119, 221, 185),
    fog = 7,
    dens = 4,
    apply = Velune.ApplySky_LavaLace,
}

table.insert(Velune.SkyList, Velune.SkyIndex_LavaLace)
function Velune.ApplySky_WinterPulse()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_WinterPulse"
        sky.SkyboxBk = "rbxassetid://149509096"
        sky.SkyboxDn = "rbxassetid://149509096"
        sky.SkyboxFt = "rbxassetid://149509096"
        sky.SkyboxLf = "rbxassetid://149509096"
        sky.SkyboxRt = "rbxassetid://149509096"
        sky.SkyboxUp = "rbxassetid://149509096"
        sky.StarCount = 2340
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 12
        lighting.Brightness = 2.20
        lighting.FogEnd = 3000
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(166, 30, 28)
        lighting.Ambient = Color3.fromRGB(126, 8, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(178, 38, 44)
        lighting.ColorShift_Top = Color3.fromRGB(166, 30, 28)
        lighting.ColorShift_Bottom = Color3.fromRGB(58, 10, 11)
        lighting.EnvironmentDiffuseScale = 0.80
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Winter Pulse")
    Velune.PlayTone(138000986, 0.2)
end
Velune.SkyIndex_WinterPulse = {
    name = "Winter Pulse",
    id = "149509096",
    color = Color3.fromRGB(166, 30, 28),
    fog = 8,
    dens = 5,
    apply = Velune.ApplySky_WinterPulse,
}

table.insert(Velune.SkyList, Velune.SkyIndex_WinterPulse)
function Velune.ApplySky_OxbloodSky()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_OxbloodSky"
        sky.SkyboxBk = "rbxassetid://149501233"
        sky.SkyboxDn = "rbxassetid://149501233"
        sky.SkyboxFt = "rbxassetid://149501233"
        sky.SkyboxLf = "rbxassetid://149501233"
        sky.SkyboxRt = "rbxassetid://149501233"
        sky.SkyboxUp = "rbxassetid://149501233"
        sky.StarCount = 2380
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 13
        lighting.Brightness = 2.30
        lighting.FogEnd = 3220
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(213, 59, 81)
        lighting.Ambient = Color3.fromRGB(173, 19, 41)
        lighting.OutdoorAmbient = Color3.fromRGB(225, 67, 97)
        lighting.ColorShift_Top = Color3.fromRGB(213, 59, 81)
        lighting.ColorShift_Bottom = Color3.fromRGB(74, 20, 32)
        lighting.EnvironmentDiffuseScale = 0.90
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Oxblood Sky")
    Velune.PlayTone(138001003, 0.2)
end
Velune.SkyIndex_OxbloodSky = {
    name = "Oxblood Sky",
    id = "149501233",
    color = Color3.fromRGB(213, 59, 81),
    fog = 9,
    dens = 6,
    apply = Velune.ApplySky_OxbloodSky,
}

table.insert(Velune.SkyList, Velune.SkyIndex_OxbloodSky)
function Velune.ApplySky_SeaGlass()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_SeaGlass"
        sky.SkyboxBk = "rbxassetid://149502370"
        sky.SkyboxDn = "rbxassetid://149502370"
        sky.SkyboxFt = "rbxassetid://149502370"
        sky.SkyboxLf = "rbxassetid://149502370"
        sky.SkyboxRt = "rbxassetid://149502370"
        sky.SkyboxUp = "rbxassetid://149502370"
        sky.StarCount = 2420
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Brightness = 2.40
        lighting.FogEnd = 800
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(30, 88, 134)
        lighting.Ambient = Color3.fromRGB(8, 48, 94)
        lighting.OutdoorAmbient = Color3.fromRGB(42, 96, 150)
        lighting.ColorShift_Top = Color3.fromRGB(30, 88, 134)
        lighting.ColorShift_Bottom = Color3.fromRGB(10, 30, 53)
        lighting.EnvironmentDiffuseScale = 0.00
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Sea Glass")
    Velune.PlayTone(138001020, 0.2)
end
Velune.SkyIndex_SeaGlass = {
    name = "Sea Glass",
    id = "149502370",
    color = Color3.fromRGB(30, 88, 134),
    fog = 10,
    dens = 7,
    apply = Velune.ApplySky_SeaGlass,
}

table.insert(Velune.SkyList, Velune.SkyIndex_SeaGlass)
function Velune.ApplySky_NightMarket()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_NightMarket"
        sky.SkyboxBk = "rbxassetid://149503507"
        sky.SkyboxDn = "rbxassetid://149503507"
        sky.SkyboxFt = "rbxassetid://149503507"
        sky.SkyboxLf = "rbxassetid://149503507"
        sky.SkyboxRt = "rbxassetid://149503507"
        sky.SkyboxUp = "rbxassetid://149503507"
        sky.StarCount = 2460
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 15
        lighting.Brightness = 2.50
        lighting.FogEnd = 1020
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(77, 117, 187)
        lighting.Ambient = Color3.fromRGB(37, 77, 147)
        lighting.OutdoorAmbient = Color3.fromRGB(89, 125, 203)
        lighting.ColorShift_Top = Color3.fromRGB(77, 117, 187)
        lighting.ColorShift_Bottom = Color3.fromRGB(26, 40, 74)
        lighting.EnvironmentDiffuseScale = 0.10
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Night Market")
    Velune.PlayTone(138001037, 0.2)
end
Velune.SkyIndex_NightMarket = {
    name = "Night Market",
    id = "149503507",
    color = Color3.fromRGB(77, 117, 187),
    fog = 11,
    dens = 8,
    apply = Velune.ApplySky_NightMarket,
}

table.insert(Velune.SkyList, Velune.SkyIndex_NightMarket)
function Velune.ApplySky_PaperMoon()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_PaperMoon"
        sky.SkyboxBk = "rbxassetid://149504644"
        sky.SkyboxDn = "rbxassetid://149504644"
        sky.SkyboxFt = "rbxassetid://149504644"
        sky.SkyboxLf = "rbxassetid://149504644"
        sky.SkyboxRt = "rbxassetid://149504644"
        sky.SkyboxUp = "rbxassetid://149504644"
        sky.StarCount = 2500
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 16
        lighting.Brightness = 2.60
        lighting.FogEnd = 1240
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(124, 146, 30)
        lighting.Ambient = Color3.fromRGB(84, 106, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(136, 154, 46)
        lighting.ColorShift_Top = Color3.fromRGB(124, 146, 30)
        lighting.ColorShift_Bottom = Color3.fromRGB(43, 51, 12)
        lighting.EnvironmentDiffuseScale = 0.20
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Paper Moon")
    Velune.PlayTone(138001054, 0.2)
end
Velune.SkyIndex_PaperMoon = {
    name = "Paper Moon",
    id = "149504644",
    color = Color3.fromRGB(124, 146, 30),
    fog = 12,
    dens = 9,
    apply = Velune.ApplySky_PaperMoon,
}

table.insert(Velune.SkyList, Velune.SkyIndex_PaperMoon)
function Velune.ApplySky_VoltGarden()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_VoltGarden"
        sky.SkyboxBk = "rbxassetid://149505781"
        sky.SkyboxDn = "rbxassetid://149505781"
        sky.SkyboxFt = "rbxassetid://149505781"
        sky.SkyboxLf = "rbxassetid://149505781"
        sky.SkyboxRt = "rbxassetid://149505781"
        sky.SkyboxUp = "rbxassetid://149505781"
        sky.StarCount = 2540
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 17
        lighting.Brightness = 2.70
        lighting.FogEnd = 1460
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(171, 175, 83)
        lighting.Ambient = Color3.fromRGB(131, 135, 43)
        lighting.OutdoorAmbient = Color3.fromRGB(183, 183, 99)
        lighting.ColorShift_Top = Color3.fromRGB(171, 175, 83)
        lighting.ColorShift_Bottom = Color3.fromRGB(59, 61, 33)
        lighting.EnvironmentDiffuseScale = 0.30
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Volt Garden")
    Velune.PlayTone(138001071, 0.2)
end
Velune.SkyIndex_VoltGarden = {
    name = "Volt Garden",
    id = "149505781",
    color = Color3.fromRGB(171, 175, 83),
    fog = 13,
    dens = 10,
    apply = Velune.ApplySky_VoltGarden,
}

table.insert(Velune.SkyList, Velune.SkyIndex_VoltGarden)
function Velune.ApplySky_SableFire()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_SableFire"
        sky.SkyboxBk = "rbxassetid://149506918"
        sky.SkyboxDn = "rbxassetid://149506918"
        sky.SkyboxFt = "rbxassetid://149506918"
        sky.SkyboxLf = "rbxassetid://149506918"
        sky.SkyboxRt = "rbxassetid://149506918"
        sky.SkyboxUp = "rbxassetid://149506918"
        sky.StarCount = 2580
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 18
        lighting.Brightness = 2.80
        lighting.FogEnd = 1680
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(218, 204, 136)
        lighting.Ambient = Color3.fromRGB(178, 164, 96)
        lighting.OutdoorAmbient = Color3.fromRGB(230, 212, 152)
        lighting.ColorShift_Top = Color3.fromRGB(218, 204, 136)
        lighting.ColorShift_Bottom = Color3.fromRGB(76, 71, 54)
        lighting.EnvironmentDiffuseScale = 0.40
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Sable Fire")
    Velune.PlayTone(138001088, 0.2)
end
Velune.SkyIndex_SableFire = {
    name = "Sable Fire",
    id = "149506918",
    color = Color3.fromRGB(218, 204, 136),
    fog = 14,
    dens = 4,
    apply = Velune.ApplySky_SableFire,
}

table.insert(Velune.SkyList, Velune.SkyIndex_SableFire)
function Velune.ApplySky_OpalDrift()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_OpalDrift"
        sky.SkyboxBk = "rbxassetid://149508055"
        sky.SkyboxDn = "rbxassetid://149508055"
        sky.SkyboxFt = "rbxassetid://149508055"
        sky.SkyboxLf = "rbxassetid://149508055"
        sky.SkyboxRt = "rbxassetid://149508055"
        sky.SkyboxUp = "rbxassetid://149508055"
        sky.StarCount = 2620
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 19
        lighting.Brightness = 2.90
        lighting.FogEnd = 1900
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(35, 233, 189)
        lighting.Ambient = Color3.fromRGB(8, 193, 149)
        lighting.OutdoorAmbient = Color3.fromRGB(47, 241, 205)
        lighting.ColorShift_Top = Color3.fromRGB(35, 233, 189)
        lighting.ColorShift_Bottom = Color3.fromRGB(12, 81, 75)
        lighting.EnvironmentDiffuseScale = 0.50
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Opal Drift")
    Velune.PlayTone(138001105, 0.2)
end
Velune.SkyIndex_OpalDrift = {
    name = "Opal Drift",
    id = "149508055",
    color = Color3.fromRGB(35, 233, 189),
    fog = 15,
    dens = 5,
    apply = Velune.ApplySky_OpalDrift,
}

table.insert(Velune.SkyList, Velune.SkyIndex_OpalDrift)
function Velune.ApplySky_RustChoir()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_RustChoir"
        sky.SkyboxBk = "rbxassetid://149509192"
        sky.SkyboxDn = "rbxassetid://149509192"
        sky.SkyboxFt = "rbxassetid://149509192"
        sky.SkyboxLf = "rbxassetid://149509192"
        sky.SkyboxRt = "rbxassetid://149509192"
        sky.SkyboxUp = "rbxassetid://149509192"
        sky.StarCount = 2660
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 4
        lighting.Brightness = 3.00
        lighting.FogEnd = 2120
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(82, 42, 32)
        lighting.Ambient = Color3.fromRGB(42, 8, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(94, 50, 48)
        lighting.ColorShift_Top = Color3.fromRGB(82, 42, 32)
        lighting.ColorShift_Bottom = Color3.fromRGB(28, 14, 12)
        lighting.EnvironmentDiffuseScale = 0.60
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Rust Choir")
    Velune.PlayTone(138001122, 0.2)
end
Velune.SkyIndex_RustChoir = {
    name = "Rust Choir",
    id = "149509192",
    color = Color3.fromRGB(82, 42, 32),
    fog = 16,
    dens = 6,
    apply = Velune.ApplySky_RustChoir,
}

table.insert(Velune.SkyList, Velune.SkyIndex_RustChoir)
function Velune.ApplySky_BlueLantern()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_BlueLantern"
        sky.SkyboxBk = "rbxassetid://149510329"
        sky.SkyboxDn = "rbxassetid://149510329"
        sky.SkyboxFt = "rbxassetid://149510329"
        sky.SkyboxLf = "rbxassetid://149510329"
        sky.SkyboxRt = "rbxassetid://149510329"
        sky.SkyboxUp = "rbxassetid://149510329"
        sky.StarCount = 2700
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 5
        lighting.Brightness = 3.10
        lighting.FogEnd = 2340
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(129, 71, 85)
        lighting.Ambient = Color3.fromRGB(89, 31, 45)
        lighting.OutdoorAmbient = Color3.fromRGB(141, 79, 101)
        lighting.ColorShift_Top = Color3.fromRGB(129, 71, 85)
        lighting.ColorShift_Bottom = Color3.fromRGB(45, 24, 34)
        lighting.EnvironmentDiffuseScale = 0.70
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Blue Lantern")
    Velune.PlayTone(138001139, 0.2)
end
Velune.SkyIndex_BlueLantern = {
    name = "Blue Lantern",
    id = "149510329",
    color = Color3.fromRGB(129, 71, 85),
    fog = 17,
    dens = 7,
    apply = Velune.ApplySky_BlueLantern,
}

table.insert(Velune.SkyList, Velune.SkyIndex_BlueLantern)
function Velune.ApplySky_IvoryEmber()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_IvoryEmber"
        sky.SkyboxBk = "rbxassetid://149502466"
        sky.SkyboxDn = "rbxassetid://149502466"
        sky.SkyboxFt = "rbxassetid://149502466"
        sky.SkyboxLf = "rbxassetid://149502466"
        sky.SkyboxRt = "rbxassetid://149502466"
        sky.SkyboxUp = "rbxassetid://149502466"
        sky.StarCount = 2740
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 6
        lighting.Brightness = 3.20
        lighting.FogEnd = 2560
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(176, 100, 138)
        lighting.Ambient = Color3.fromRGB(136, 60, 98)
        lighting.OutdoorAmbient = Color3.fromRGB(188, 108, 154)
        lighting.ColorShift_Top = Color3.fromRGB(176, 100, 138)
        lighting.ColorShift_Bottom = Color3.fromRGB(61, 35, 55)
        lighting.EnvironmentDiffuseScale = 0.80
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Ivory Ember")
    Velune.PlayTone(138001156, 0.2)
end
Velune.SkyIndex_IvoryEmber = {
    name = "Ivory Ember",
    id = "149502466",
    color = Color3.fromRGB(176, 100, 138),
    fog = 18,
    dens = 8,
    apply = Velune.ApplySky_IvoryEmber,
}

table.insert(Velune.SkyList, Velune.SkyIndex_IvoryEmber)
function Velune.ApplySky_HollowGold()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_HollowGold"
        sky.SkyboxBk = "rbxassetid://149503603"
        sky.SkyboxDn = "rbxassetid://149503603"
        sky.SkyboxFt = "rbxassetid://149503603"
        sky.SkyboxLf = "rbxassetid://149503603"
        sky.SkyboxRt = "rbxassetid://149503603"
        sky.SkyboxUp = "rbxassetid://149503603"
        sky.StarCount = 2780
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 7
        lighting.Brightness = 3.30
        lighting.FogEnd = 2780
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(223, 129, 191)
        lighting.Ambient = Color3.fromRGB(183, 89, 151)
        lighting.OutdoorAmbient = Color3.fromRGB(235, 137, 207)
        lighting.ColorShift_Top = Color3.fromRGB(223, 129, 191)
        lighting.ColorShift_Bottom = Color3.fromRGB(78, 45, 76)
        lighting.EnvironmentDiffuseScale = 0.90
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Hollow Gold")
    Velune.PlayTone(138001173, 0.2)
end
Velune.SkyIndex_HollowGold = {
    name = "Hollow Gold",
    id = "149503603",
    color = Color3.fromRGB(223, 129, 191),
    fog = 19,
    dens = 9,
    apply = Velune.ApplySky_HollowGold,
}

table.insert(Velune.SkyList, Velune.SkyIndex_HollowGold)
function Velune.ApplySky_QuartzTide()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_QuartzTide"
        sky.SkyboxBk = "rbxassetid://149504740"
        sky.SkyboxDn = "rbxassetid://149504740"
        sky.SkyboxFt = "rbxassetid://149504740"
        sky.SkyboxLf = "rbxassetid://149504740"
        sky.SkyboxRt = "rbxassetid://149504740"
        sky.SkyboxUp = "rbxassetid://149504740"
        sky.StarCount = 2820
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 8
        lighting.Brightness = 1.40
        lighting.FogEnd = 3000
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(40, 158, 34)
        lighting.Ambient = Color3.fromRGB(8, 118, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(52, 166, 50)
        lighting.ColorShift_Top = Color3.fromRGB(40, 158, 34)
        lighting.ColorShift_Bottom = Color3.fromRGB(14, 55, 13)
        lighting.EnvironmentDiffuseScale = 0.00
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Quartz Tide")
    Velune.PlayTone(138001190, 0.2)
end
Velune.SkyIndex_QuartzTide = {
    name = "Quartz Tide",
    id = "149504740",
    color = Color3.fromRGB(40, 158, 34),
    fog = 20,
    dens = 10,
    apply = Velune.ApplySky_QuartzTide,
}

table.insert(Velune.SkyList, Velune.SkyIndex_QuartzTide)
function Velune.ApplySky_MaroonStatic()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_MaroonStatic"
        sky.SkyboxBk = "rbxassetid://149505877"
        sky.SkyboxDn = "rbxassetid://149505877"
        sky.SkyboxFt = "rbxassetid://149505877"
        sky.SkyboxLf = "rbxassetid://149505877"
        sky.SkyboxRt = "rbxassetid://149505877"
        sky.SkyboxUp = "rbxassetid://149505877"
        sky.StarCount = 2860
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 9
        lighting.Brightness = 1.50
        lighting.FogEnd = 3220
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(87, 187, 87)
        lighting.Ambient = Color3.fromRGB(47, 147, 47)
        lighting.OutdoorAmbient = Color3.fromRGB(99, 195, 103)
        lighting.ColorShift_Top = Color3.fromRGB(87, 187, 87)
        lighting.ColorShift_Bottom = Color3.fromRGB(30, 65, 34)
        lighting.EnvironmentDiffuseScale = 0.10
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Maroon Static")
    Velune.PlayTone(138001207, 0.2)
end
Velune.SkyIndex_MaroonStatic = {
    name = "Maroon Static",
    id = "149505877",
    color = Color3.fromRGB(87, 187, 87),
    fog = 21,
    dens = 4,
    apply = Velune.ApplySky_MaroonStatic,
}

table.insert(Velune.SkyList, Velune.SkyIndex_MaroonStatic)
function Velune.ApplySky_FogEngine()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_FogEngine"
        sky.SkyboxBk = "rbxassetid://149507014"
        sky.SkyboxDn = "rbxassetid://149507014"
        sky.SkyboxFt = "rbxassetid://149507014"
        sky.SkyboxLf = "rbxassetid://149507014"
        sky.SkyboxRt = "rbxassetid://149507014"
        sky.SkyboxUp = "rbxassetid://149507014"
        sky.StarCount = 2900
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 10
        lighting.Brightness = 1.60
        lighting.FogEnd = 800
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(134, 216, 140)
        lighting.Ambient = Color3.fromRGB(94, 176, 100)
        lighting.OutdoorAmbient = Color3.fromRGB(146, 224, 156)
        lighting.ColorShift_Top = Color3.fromRGB(134, 216, 140)
        lighting.ColorShift_Bottom = Color3.fromRGB(46, 75, 56)
        lighting.EnvironmentDiffuseScale = 0.20
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Fog Engine")
    Velune.PlayTone(138001224, 0.2)
end
Velune.SkyIndex_FogEngine = {
    name = "Fog Engine",
    id = "149507014",
    color = Color3.fromRGB(134, 216, 140),
    fog = 22,
    dens = 5,
    apply = Velune.ApplySky_FogEngine,
}

table.insert(Velune.SkyList, Velune.SkyIndex_FogEngine)
function Velune.ApplySky_SilkReactor()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_SilkReactor"
        sky.SkyboxBk = "rbxassetid://149508151"
        sky.SkyboxDn = "rbxassetid://149508151"
        sky.SkyboxFt = "rbxassetid://149508151"
        sky.SkyboxLf = "rbxassetid://149508151"
        sky.SkyboxRt = "rbxassetid://149508151"
        sky.SkyboxUp = "rbxassetid://149508151"
        sky.StarCount = 2940
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 11
        lighting.Brightness = 1.70
        lighting.FogEnd = 1020
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(181, 25, 193)
        lighting.Ambient = Color3.fromRGB(141, 8, 153)
        lighting.OutdoorAmbient = Color3.fromRGB(193, 33, 209)
        lighting.ColorShift_Top = Color3.fromRGB(181, 25, 193)
        lighting.ColorShift_Bottom = Color3.fromRGB(63, 8, 77)
        lighting.EnvironmentDiffuseScale = 0.30
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Silk Reactor")
    Velune.PlayTone(138001241, 0.2)
end
Velune.SkyIndex_SilkReactor = {
    name = "Silk Reactor",
    id = "149508151",
    color = Color3.fromRGB(181, 25, 193),
    fog = 23,
    dens = 6,
    apply = Velune.ApplySky_SilkReactor,
}

table.insert(Velune.SkyList, Velune.SkyIndex_SilkReactor)
function Velune.ApplySky_CedarGlow()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CedarGlow"
        sky.SkyboxBk = "rbxassetid://149509288"
        sky.SkyboxDn = "rbxassetid://149509288"
        sky.SkyboxFt = "rbxassetid://149509288"
        sky.SkyboxLf = "rbxassetid://149509288"
        sky.SkyboxRt = "rbxassetid://149509288"
        sky.SkyboxUp = "rbxassetid://149509288"
        sky.StarCount = 2980
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 12
        lighting.Brightness = 1.80
        lighting.FogEnd = 1240
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(228, 54, 36)
        lighting.Ambient = Color3.fromRGB(188, 14, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(240, 62, 52)
        lighting.ColorShift_Top = Color3.fromRGB(228, 54, 36)
        lighting.ColorShift_Bottom = Color3.fromRGB(79, 18, 14)
        lighting.EnvironmentDiffuseScale = 0.40
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Cedar Glow")
    Velune.PlayTone(138001258, 0.2)
end
Velune.SkyIndex_CedarGlow = {
    name = "Cedar Glow",
    id = "149509288",
    color = Color3.fromRGB(228, 54, 36),
    fog = 0,
    dens = 7,
    apply = Velune.ApplySky_CedarGlow,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CedarGlow)
function Velune.ApplySky_NimbusRed()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_NimbusRed"
        sky.SkyboxBk = "rbxassetid://149510425"
        sky.SkyboxDn = "rbxassetid://149510425"
        sky.SkyboxFt = "rbxassetid://149510425"
        sky.SkyboxLf = "rbxassetid://149510425"
        sky.SkyboxRt = "rbxassetid://149510425"
        sky.SkyboxUp = "rbxassetid://149510425"
        sky.StarCount = 3020
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 13
        lighting.Brightness = 1.90
        lighting.FogEnd = 1460
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(45, 83, 89)
        lighting.Ambient = Color3.fromRGB(8, 43, 49)
        lighting.OutdoorAmbient = Color3.fromRGB(57, 91, 105)
        lighting.ColorShift_Top = Color3.fromRGB(45, 83, 89)
        lighting.ColorShift_Bottom = Color3.fromRGB(15, 29, 35)
        lighting.EnvironmentDiffuseScale = 0.50
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Nimbus Red")
    Velune.PlayTone(138001275, 0.2)
end
Velune.SkyIndex_NimbusRed = {
    name = "Nimbus Red",
    id = "149510425",
    color = Color3.fromRGB(45, 83, 89),
    fog = 1,
    dens = 8,
    apply = Velune.ApplySky_NimbusRed,
}

table.insert(Velune.SkyList, Velune.SkyIndex_NimbusRed)
function Velune.ApplySky_PaleVoltage()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_PaleVoltage"
        sky.SkyboxBk = "rbxassetid://149511562"
        sky.SkyboxDn = "rbxassetid://149511562"
        sky.SkyboxFt = "rbxassetid://149511562"
        sky.SkyboxLf = "rbxassetid://149511562"
        sky.SkyboxRt = "rbxassetid://149511562"
        sky.SkyboxUp = "rbxassetid://149511562"
        sky.StarCount = 3060
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Brightness = 2.00
        lighting.FogEnd = 1680
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(92, 112, 142)
        lighting.Ambient = Color3.fromRGB(52, 72, 102)
        lighting.OutdoorAmbient = Color3.fromRGB(104, 120, 158)
        lighting.ColorShift_Top = Color3.fromRGB(92, 112, 142)
        lighting.ColorShift_Bottom = Color3.fromRGB(32, 39, 56)
        lighting.EnvironmentDiffuseScale = 0.60
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Pale Voltage")
    Velune.PlayTone(138001292, 0.2)
end
Velune.SkyIndex_PaleVoltage = {
    name = "Pale Voltage",
    id = "149511562",
    color = Color3.fromRGB(92, 112, 142),
    fog = 2,
    dens = 9,
    apply = Velune.ApplySky_PaleVoltage,
}

table.insert(Velune.SkyList, Velune.SkyIndex_PaleVoltage)
function Velune.ApplySky_CobwebSun()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CobwebSun"
        sky.SkyboxBk = "rbxassetid://149503699"
        sky.SkyboxDn = "rbxassetid://149503699"
        sky.SkyboxFt = "rbxassetid://149503699"
        sky.SkyboxLf = "rbxassetid://149503699"
        sky.SkyboxRt = "rbxassetid://149503699"
        sky.SkyboxUp = "rbxassetid://149503699"
        sky.StarCount = 3100
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 15
        lighting.Brightness = 2.10
        lighting.FogEnd = 1900
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(139, 141, 195)
        lighting.Ambient = Color3.fromRGB(99, 101, 155)
        lighting.OutdoorAmbient = Color3.fromRGB(151, 149, 211)
        lighting.ColorShift_Top = Color3.fromRGB(139, 141, 195)
        lighting.ColorShift_Bottom = Color3.fromRGB(48, 49, 78)
        lighting.EnvironmentDiffuseScale = 0.70
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Cobweb Sun")
    Velune.PlayTone(138001309, 0.2)
end
Velune.SkyIndex_CobwebSun = {
    name = "Cobweb Sun",
    id = "149503699",
    color = Color3.fromRGB(139, 141, 195),
    fog = 3,
    dens = 10,
    apply = Velune.ApplySky_CobwebSun,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CobwebSun)
function Velune.ApplySky_HarborRose()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_HarborRose"
        sky.SkyboxBk = "rbxassetid://149504836"
        sky.SkyboxDn = "rbxassetid://149504836"
        sky.SkyboxFt = "rbxassetid://149504836"
        sky.SkyboxLf = "rbxassetid://149504836"
        sky.SkyboxRt = "rbxassetid://149504836"
        sky.SkyboxUp = "rbxassetid://149504836"
        sky.StarCount = 3140
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 16
        lighting.Brightness = 2.20
        lighting.FogEnd = 2120
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(186, 170, 38)
        lighting.Ambient = Color3.fromRGB(146, 130, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(198, 178, 54)
        lighting.ColorShift_Top = Color3.fromRGB(186, 170, 38)
        lighting.ColorShift_Bottom = Color3.fromRGB(65, 59, 15)
        lighting.EnvironmentDiffuseScale = 0.80
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Harbor Rose")
    Velune.PlayTone(138001326, 0.2)
end
Velune.SkyIndex_HarborRose = {
    name = "Harbor Rose",
    id = "149504836",
    color = Color3.fromRGB(186, 170, 38),
    fog = 4,
    dens = 4,
    apply = Velune.ApplySky_HarborRose,
}

table.insert(Velune.SkyList, Velune.SkyIndex_HarborRose)
function Velune.ApplySky_ZincBloom()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_ZincBloom"
        sky.SkyboxBk = "rbxassetid://149505973"
        sky.SkyboxDn = "rbxassetid://149505973"
        sky.SkyboxFt = "rbxassetid://149505973"
        sky.SkyboxLf = "rbxassetid://149505973"
        sky.SkyboxRt = "rbxassetid://149505973"
        sky.SkyboxUp = "rbxassetid://149505973"
        sky.StarCount = 3180
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 17
        lighting.Brightness = 2.30
        lighting.FogEnd = 2340
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(233, 199, 91)
        lighting.Ambient = Color3.fromRGB(193, 159, 51)
        lighting.OutdoorAmbient = Color3.fromRGB(245, 207, 107)
        lighting.ColorShift_Top = Color3.fromRGB(233, 199, 91)
        lighting.ColorShift_Bottom = Color3.fromRGB(81, 69, 36)
        lighting.EnvironmentDiffuseScale = 0.90
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Zinc Bloom")
    Velune.PlayTone(138001343, 0.2)
end
Velune.SkyIndex_ZincBloom = {
    name = "Zinc Bloom",
    id = "149505973",
    color = Color3.fromRGB(233, 199, 91),
    fog = 5,
    dens = 5,
    apply = Velune.ApplySky_ZincBloom,
}

table.insert(Velune.SkyList, Velune.SkyIndex_ZincBloom)
function Velune.ApplySky_EmberLibrary()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_EmberLibrary"
        sky.SkyboxBk = "rbxassetid://149507110"
        sky.SkyboxDn = "rbxassetid://149507110"
        sky.SkyboxFt = "rbxassetid://149507110"
        sky.SkyboxLf = "rbxassetid://149507110"
        sky.SkyboxRt = "rbxassetid://149507110"
        sky.SkyboxUp = "rbxassetid://149507110"
        sky.StarCount = 20
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 18
        lighting.Brightness = 2.40
        lighting.FogEnd = 2560
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(50, 228, 144)
        lighting.Ambient = Color3.fromRGB(10, 188, 104)
        lighting.OutdoorAmbient = Color3.fromRGB(62, 236, 160)
        lighting.ColorShift_Top = Color3.fromRGB(50, 228, 144)
        lighting.ColorShift_Bottom = Color3.fromRGB(17, 79, 57)
        lighting.EnvironmentDiffuseScale = 0.00
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Ember Library")
    Velune.PlayTone(138001360, 0.2)
end
Velune.SkyIndex_EmberLibrary = {
    name = "Ember Library",
    id = "149507110",
    color = Color3.fromRGB(50, 228, 144),
    fog = 6,
    dens = 6,
    apply = Velune.ApplySky_EmberLibrary,
}

table.insert(Velune.SkyList, Velune.SkyIndex_EmberLibrary)
function Velune.ApplySky_GlassOrchard()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_GlassOrchard"
        sky.SkyboxBk = "rbxassetid://149508247"
        sky.SkyboxDn = "rbxassetid://149508247"
        sky.SkyboxFt = "rbxassetid://149508247"
        sky.SkyboxLf = "rbxassetid://149508247"
        sky.SkyboxRt = "rbxassetid://149508247"
        sky.SkyboxUp = "rbxassetid://149508247"
        sky.StarCount = 60
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 19
        lighting.Brightness = 2.50
        lighting.FogEnd = 2780
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(97, 37, 197)
        lighting.Ambient = Color3.fromRGB(57, 8, 157)
        lighting.OutdoorAmbient = Color3.fromRGB(109, 45, 213)
        lighting.ColorShift_Top = Color3.fromRGB(97, 37, 197)
        lighting.ColorShift_Bottom = Color3.fromRGB(33, 12, 78)
        lighting.EnvironmentDiffuseScale = 0.10
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Glass Orchard")
    Velune.PlayTone(138001377, 0.2)
end
Velune.SkyIndex_GlassOrchard = {
    name = "Glass Orchard",
    id = "149508247",
    color = Color3.fromRGB(97, 37, 197),
    fog = 7,
    dens = 7,
    apply = Velune.ApplySky_GlassOrchard,
}

table.insert(Velune.SkyList, Velune.SkyIndex_GlassOrchard)
function Velune.ApplySky_NoirTulip()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_NoirTulip"
        sky.SkyboxBk = "rbxassetid://149509384"
        sky.SkyboxDn = "rbxassetid://149509384"
        sky.SkyboxFt = "rbxassetid://149509384"
        sky.SkyboxLf = "rbxassetid://149509384"
        sky.SkyboxRt = "rbxassetid://149509384"
        sky.SkyboxUp = "rbxassetid://149509384"
        sky.StarCount = 100
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 4
        lighting.Brightness = 2.60
        lighting.FogEnd = 3000
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(144, 66, 40)
        lighting.Ambient = Color3.fromRGB(104, 26, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(156, 74, 56)
        lighting.ColorShift_Top = Color3.fromRGB(144, 66, 40)
        lighting.ColorShift_Bottom = Color3.fromRGB(50, 23, 16)
        lighting.EnvironmentDiffuseScale = 0.20
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Noir Tulip")
    Velune.PlayTone(138001394, 0.2)
end
Velune.SkyIndex_NoirTulip = {
    name = "Noir Tulip",
    id = "149509384",
    color = Color3.fromRGB(144, 66, 40),
    fog = 8,
    dens = 8,
    apply = Velune.ApplySky_NoirTulip,
}

table.insert(Velune.SkyList, Velune.SkyIndex_NoirTulip)
function Velune.ApplySky_CopperVeil()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CopperVeil"
        sky.SkyboxBk = "rbxassetid://149510521"
        sky.SkyboxDn = "rbxassetid://149510521"
        sky.SkyboxFt = "rbxassetid://149510521"
        sky.SkyboxLf = "rbxassetid://149510521"
        sky.SkyboxRt = "rbxassetid://149510521"
        sky.SkyboxUp = "rbxassetid://149510521"
        sky.StarCount = 140
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 5
        lighting.Brightness = 2.70
        lighting.FogEnd = 3220
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(191, 95, 93)
        lighting.Ambient = Color3.fromRGB(151, 55, 53)
        lighting.OutdoorAmbient = Color3.fromRGB(203, 103, 109)
        lighting.ColorShift_Top = Color3.fromRGB(191, 95, 93)
        lighting.ColorShift_Bottom = Color3.fromRGB(66, 33, 37)
        lighting.EnvironmentDiffuseScale = 0.30
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Copper Veil")
    Velune.PlayTone(138001411, 0.2)
end
Velune.SkyIndex_CopperVeil = {
    name = "Copper Veil",
    id = "149510521",
    color = Color3.fromRGB(191, 95, 93),
    fog = 9,
    dens = 9,
    apply = Velune.ApplySky_CopperVeil,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CopperVeil)
function Velune.ApplySky_DawnCircuit()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_DawnCircuit"
        sky.SkyboxBk = "rbxassetid://149511658"
        sky.SkyboxDn = "rbxassetid://149511658"
        sky.SkyboxFt = "rbxassetid://149511658"
        sky.SkyboxLf = "rbxassetid://149511658"
        sky.SkyboxRt = "rbxassetid://149511658"
        sky.SkyboxUp = "rbxassetid://149511658"
        sky.StarCount = 180
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 6
        lighting.Brightness = 2.80
        lighting.FogEnd = 800
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(238, 124, 146)
        lighting.Ambient = Color3.fromRGB(198, 84, 106)
        lighting.OutdoorAmbient = Color3.fromRGB(250, 132, 162)
        lighting.ColorShift_Top = Color3.fromRGB(238, 124, 146)
        lighting.ColorShift_Bottom = Color3.fromRGB(83, 43, 58)
        lighting.EnvironmentDiffuseScale = 0.40
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Dawn Circuit")
    Velune.PlayTone(138001428, 0.2)
end
Velune.SkyIndex_DawnCircuit = {
    name = "Dawn Circuit",
    id = "149511658",
    color = Color3.fromRGB(238, 124, 146),
    fog = 10,
    dens = 10,
    apply = Velune.ApplySky_DawnCircuit,
}

table.insert(Velune.SkyList, Velune.SkyIndex_DawnCircuit)
function Velune.ApplySky_VesperLime()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_VesperLime"
        sky.SkyboxBk = "rbxassetid://149512795"
        sky.SkyboxDn = "rbxassetid://149512795"
        sky.SkyboxFt = "rbxassetid://149512795"
        sky.SkyboxLf = "rbxassetid://149512795"
        sky.SkyboxRt = "rbxassetid://149512795"
        sky.SkyboxUp = "rbxassetid://149512795"
        sky.StarCount = 220
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 7
        lighting.Brightness = 2.90
        lighting.FogEnd = 1020
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(55, 153, 199)
        lighting.Ambient = Color3.fromRGB(15, 113, 159)
        lighting.OutdoorAmbient = Color3.fromRGB(67, 161, 215)
        lighting.ColorShift_Top = Color3.fromRGB(55, 153, 199)
        lighting.ColorShift_Bottom = Color3.fromRGB(19, 53, 79)
        lighting.EnvironmentDiffuseScale = 0.50
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Vesper Lime")
    Velune.PlayTone(138001445, 0.2)
end
Velune.SkyIndex_VesperLime = {
    name = "Vesper Lime",
    id = "149512795",
    color = Color3.fromRGB(55, 153, 199),
    fog = 11,
    dens = 4,
    apply = Velune.ApplySky_VesperLime,
}

table.insert(Velune.SkyList, Velune.SkyIndex_VesperLime)
function Velune.ApplySky_IvoryRift()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_IvoryRift"
        sky.SkyboxBk = "rbxassetid://149504932"
        sky.SkyboxDn = "rbxassetid://149504932"
        sky.SkyboxFt = "rbxassetid://149504932"
        sky.SkyboxLf = "rbxassetid://149504932"
        sky.SkyboxRt = "rbxassetid://149504932"
        sky.SkyboxUp = "rbxassetid://149504932"
        sky.StarCount = 260
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 8
        lighting.Brightness = 3.00
        lighting.FogEnd = 1240
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(102, 182, 42)
        lighting.Ambient = Color3.fromRGB(62, 142, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(114, 190, 58)
        lighting.ColorShift_Top = Color3.fromRGB(102, 182, 42)
        lighting.ColorShift_Bottom = Color3.fromRGB(35, 63, 16)
        lighting.EnvironmentDiffuseScale = 0.60
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Ivory Rift")
    Velune.PlayTone(138001462, 0.2)
end
Velune.SkyIndex_IvoryRift = {
    name = "Ivory Rift",
    id = "149504932",
    color = Color3.fromRGB(102, 182, 42),
    fog = 12,
    dens = 5,
    apply = Velune.ApplySky_IvoryRift,
}

table.insert(Velune.SkyList, Velune.SkyIndex_IvoryRift)
function Velune.ApplySky_BloodOrange()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_BloodOrange"
        sky.SkyboxBk = "rbxassetid://149506069"
        sky.SkyboxDn = "rbxassetid://149506069"
        sky.SkyboxFt = "rbxassetid://149506069"
        sky.SkyboxLf = "rbxassetid://149506069"
        sky.SkyboxRt = "rbxassetid://149506069"
        sky.SkyboxUp = "rbxassetid://149506069"
        sky.StarCount = 300
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 9
        lighting.Brightness = 3.10
        lighting.FogEnd = 1460
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(149, 211, 95)
        lighting.Ambient = Color3.fromRGB(109, 171, 55)
        lighting.OutdoorAmbient = Color3.fromRGB(161, 219, 111)
        lighting.ColorShift_Top = Color3.fromRGB(149, 211, 95)
        lighting.ColorShift_Bottom = Color3.fromRGB(52, 73, 38)
        lighting.EnvironmentDiffuseScale = 0.70
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Blood Orange")
    Velune.PlayTone(138001479, 0.2)
end
Velune.SkyIndex_BloodOrange = {
    name = "Blood Orange",
    id = "149506069",
    color = Color3.fromRGB(149, 211, 95),
    fog = 13,
    dens = 6,
    apply = Velune.ApplySky_BloodOrange,
}

table.insert(Velune.SkyList, Velune.SkyIndex_BloodOrange)
function Velune.ApplySky_MintCathedral()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_MintCathedral"
        sky.SkyboxBk = "rbxassetid://149507206"
        sky.SkyboxDn = "rbxassetid://149507206"
        sky.SkyboxFt = "rbxassetid://149507206"
        sky.SkyboxLf = "rbxassetid://149507206"
        sky.SkyboxRt = "rbxassetid://149507206"
        sky.SkyboxUp = "rbxassetid://149507206"
        sky.StarCount = 340
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 10
        lighting.Brightness = 3.20
        lighting.FogEnd = 1680
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(196, 20, 148)
        lighting.Ambient = Color3.fromRGB(156, 8, 108)
        lighting.OutdoorAmbient = Color3.fromRGB(208, 28, 164)
        lighting.ColorShift_Top = Color3.fromRGB(196, 20, 148)
        lighting.ColorShift_Bottom = Color3.fromRGB(68, 7, 59)
        lighting.EnvironmentDiffuseScale = 0.80
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Mint Cathedral")
    Velune.PlayTone(138001496, 0.2)
end
Velune.SkyIndex_MintCathedral = {
    name = "Mint Cathedral",
    id = "149507206",
    color = Color3.fromRGB(196, 20, 148),
    fog = 14,
    dens = 7,
    apply = Velune.ApplySky_MintCathedral,
}

table.insert(Velune.SkyList, Velune.SkyIndex_MintCathedral)
function Velune.ApplySky_ObsidianTea()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_ObsidianTea"
        sky.SkyboxBk = "rbxassetid://149508343"
        sky.SkyboxDn = "rbxassetid://149508343"
        sky.SkyboxFt = "rbxassetid://149508343"
        sky.SkyboxLf = "rbxassetid://149508343"
        sky.SkyboxRt = "rbxassetid://149508343"
        sky.SkyboxUp = "rbxassetid://149508343"
        sky.StarCount = 380
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 11
        lighting.Brightness = 3.30
        lighting.FogEnd = 1900
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(243, 49, 201)
        lighting.Ambient = Color3.fromRGB(203, 9, 161)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 57, 217)
        lighting.ColorShift_Top = Color3.fromRGB(243, 49, 201)
        lighting.ColorShift_Bottom = Color3.fromRGB(85, 17, 80)
        lighting.EnvironmentDiffuseScale = 0.90
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Obsidian Tea")
    Velune.PlayTone(138001513, 0.2)
end
Velune.SkyIndex_ObsidianTea = {
    name = "Obsidian Tea",
    id = "149508343",
    color = Color3.fromRGB(243, 49, 201),
    fog = 15,
    dens = 8,
    apply = Velune.ApplySky_ObsidianTea,
}

table.insert(Velune.SkyList, Velune.SkyIndex_ObsidianTea)
function Velune.ApplySky_SatinStorm()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_SatinStorm"
        sky.SkyboxBk = "rbxassetid://149509480"
        sky.SkyboxDn = "rbxassetid://149509480"
        sky.SkyboxFt = "rbxassetid://149509480"
        sky.SkyboxLf = "rbxassetid://149509480"
        sky.SkyboxRt = "rbxassetid://149509480"
        sky.SkyboxUp = "rbxassetid://149509480"
        sky.StarCount = 420
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 12
        lighting.Brightness = 1.40
        lighting.FogEnd = 2120
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(60, 78, 44)
        lighting.Ambient = Color3.fromRGB(20, 38, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(72, 86, 60)
        lighting.ColorShift_Top = Color3.fromRGB(60, 78, 44)
        lighting.ColorShift_Bottom = Color3.fromRGB(21, 27, 17)
        lighting.EnvironmentDiffuseScale = 0.00
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Satin Storm")
    Velune.PlayTone(138001530, 0.2)
end
Velune.SkyIndex_SatinStorm = {
    name = "Satin Storm",
    id = "149509480",
    color = Color3.fromRGB(60, 78, 44),
    fog = 16,
    dens = 9,
    apply = Velune.ApplySky_SatinStorm,
}

table.insert(Velune.SkyList, Velune.SkyIndex_SatinStorm)
function Velune.ApplySky_CherryWell()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CherryWell"
        sky.SkyboxBk = "rbxassetid://149510617"
        sky.SkyboxDn = "rbxassetid://149510617"
        sky.SkyboxFt = "rbxassetid://149510617"
        sky.SkyboxLf = "rbxassetid://149510617"
        sky.SkyboxRt = "rbxassetid://149510617"
        sky.SkyboxUp = "rbxassetid://149510617"
        sky.StarCount = 460
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 13
        lighting.Brightness = 1.50
        lighting.FogEnd = 2340
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(107, 107, 97)
        lighting.Ambient = Color3.fromRGB(67, 67, 57)
        lighting.OutdoorAmbient = Color3.fromRGB(119, 115, 113)
        lighting.ColorShift_Top = Color3.fromRGB(107, 107, 97)
        lighting.ColorShift_Bottom = Color3.fromRGB(37, 37, 38)
        lighting.EnvironmentDiffuseScale = 0.10
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Cherry Well")
    Velune.PlayTone(138001547, 0.2)
end
Velune.SkyIndex_CherryWell = {
    name = "Cherry Well",
    id = "149510617",
    color = Color3.fromRGB(107, 107, 97),
    fog = 17,
    dens = 10,
    apply = Velune.ApplySky_CherryWell,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CherryWell)
function Velune.ApplySky_LeadGarden()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_LeadGarden"
        sky.SkyboxBk = "rbxassetid://149511754"
        sky.SkyboxDn = "rbxassetid://149511754"
        sky.SkyboxFt = "rbxassetid://149511754"
        sky.SkyboxLf = "rbxassetid://149511754"
        sky.SkyboxRt = "rbxassetid://149511754"
        sky.SkyboxUp = "rbxassetid://149511754"
        sky.StarCount = 500
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 14
        lighting.Brightness = 1.60
        lighting.FogEnd = 2560
        lighting.FogStart = 100
        lighting.FogColor = Color3.fromRGB(154, 136, 150)
        lighting.Ambient = Color3.fromRGB(114, 96, 110)
        lighting.OutdoorAmbient = Color3.fromRGB(166, 144, 166)
        lighting.ColorShift_Top = Color3.fromRGB(154, 136, 150)
        lighting.ColorShift_Bottom = Color3.fromRGB(53, 47, 60)
        lighting.EnvironmentDiffuseScale = 0.20
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Lead Garden")
    Velune.PlayTone(138001564, 0.2)
end
Velune.SkyIndex_LeadGarden = {
    name = "Lead Garden",
    id = "149511754",
    color = Color3.fromRGB(154, 136, 150),
    fog = 18,
    dens = 4,
    apply = Velune.ApplySky_LeadGarden,
}

table.insert(Velune.SkyList, Velune.SkyIndex_LeadGarden)
function Velune.ApplySky_AmberChoir()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_AmberChoir"
        sky.SkyboxBk = "rbxassetid://149512891"
        sky.SkyboxDn = "rbxassetid://149512891"
        sky.SkyboxFt = "rbxassetid://149512891"
        sky.SkyboxLf = "rbxassetid://149512891"
        sky.SkyboxRt = "rbxassetid://149512891"
        sky.SkyboxUp = "rbxassetid://149512891"
        sky.StarCount = 540
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 15
        lighting.Brightness = 1.70
        lighting.FogEnd = 2780
        lighting.FogStart = 115
        lighting.FogColor = Color3.fromRGB(201, 165, 203)
        lighting.Ambient = Color3.fromRGB(161, 125, 163)
        lighting.OutdoorAmbient = Color3.fromRGB(213, 173, 219)
        lighting.ColorShift_Top = Color3.fromRGB(201, 165, 203)
        lighting.ColorShift_Bottom = Color3.fromRGB(70, 57, 81)
        lighting.EnvironmentDiffuseScale = 0.30
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Amber Choir")
    Velune.PlayTone(138001581, 0.2)
end
Velune.SkyIndex_AmberChoir = {
    name = "Amber Choir",
    id = "149512891",
    color = Color3.fromRGB(201, 165, 203),
    fog = 19,
    dens = 5,
    apply = Velune.ApplySky_AmberChoir,
}

table.insert(Velune.SkyList, Velune.SkyIndex_AmberChoir)
function Velune.ApplySky_VioletEngine()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_VioletEngine"
        sky.SkyboxBk = "rbxassetid://149514028"
        sky.SkyboxDn = "rbxassetid://149514028"
        sky.SkyboxFt = "rbxassetid://149514028"
        sky.SkyboxLf = "rbxassetid://149514028"
        sky.SkyboxRt = "rbxassetid://149514028"
        sky.SkyboxUp = "rbxassetid://149514028"
        sky.StarCount = 580
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 16
        lighting.Brightness = 1.80
        lighting.FogEnd = 3000
        lighting.FogStart = 130
        lighting.FogColor = Color3.fromRGB(248, 194, 46)
        lighting.Ambient = Color3.fromRGB(208, 154, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 202, 62)
        lighting.ColorShift_Top = Color3.fromRGB(248, 194, 46)
        lighting.ColorShift_Bottom = Color3.fromRGB(86, 67, 18)
        lighting.EnvironmentDiffuseScale = 0.40
        lighting.EnvironmentSpecularScale = 0.80
    end)
    Velune.Notify("VELUNE", "Skybox applied: Violet Engine")
    Velune.PlayTone(138001598, 0.2)
end
Velune.SkyIndex_VioletEngine = {
    name = "Violet Engine",
    id = "149514028",
    color = Color3.fromRGB(248, 194, 46),
    fog = 20,
    dens = 6,
    apply = Velune.ApplySky_VioletEngine,
}

table.insert(Velune.SkyList, Velune.SkyIndex_VioletEngine)
function Velune.ApplySky_SnowLantern()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_SnowLantern"
        sky.SkyboxBk = "rbxassetid://149506165"
        sky.SkyboxDn = "rbxassetid://149506165"
        sky.SkyboxFt = "rbxassetid://149506165"
        sky.SkyboxLf = "rbxassetid://149506165"
        sky.SkyboxRt = "rbxassetid://149506165"
        sky.SkyboxUp = "rbxassetid://149506165"
        sky.StarCount = 620
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 17
        lighting.Brightness = 1.90
        lighting.FogEnd = 3220
        lighting.FogStart = 145
        lighting.FogColor = Color3.fromRGB(65, 223, 99)
        lighting.Ambient = Color3.fromRGB(25, 183, 59)
        lighting.OutdoorAmbient = Color3.fromRGB(77, 231, 115)
        lighting.ColorShift_Top = Color3.fromRGB(65, 223, 99)
        lighting.ColorShift_Bottom = Color3.fromRGB(22, 78, 39)
        lighting.EnvironmentDiffuseScale = 0.50
        lighting.EnvironmentSpecularScale = 0.90
    end)
    Velune.Notify("VELUNE", "Skybox applied: Snow Lantern")
    Velune.PlayTone(138001615, 0.2)
end
Velune.SkyIndex_SnowLantern = {
    name = "Snow Lantern",
    id = "149506165",
    color = Color3.fromRGB(65, 223, 99),
    fog = 21,
    dens = 7,
    apply = Velune.ApplySky_SnowLantern,
}

table.insert(Velune.SkyList, Velune.SkyIndex_SnowLantern)
function Velune.ApplySky_CrimsonPool()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_CrimsonPool"
        sky.SkyboxBk = "rbxassetid://149507302"
        sky.SkyboxDn = "rbxassetid://149507302"
        sky.SkyboxFt = "rbxassetid://149507302"
        sky.SkyboxLf = "rbxassetid://149507302"
        sky.SkyboxRt = "rbxassetid://149507302"
        sky.SkyboxUp = "rbxassetid://149507302"
        sky.StarCount = 660
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 18
        lighting.Brightness = 2.00
        lighting.FogEnd = 800
        lighting.FogStart = 40
        lighting.FogColor = Color3.fromRGB(112, 32, 152)
        lighting.Ambient = Color3.fromRGB(72, 8, 112)
        lighting.OutdoorAmbient = Color3.fromRGB(124, 40, 168)
        lighting.ColorShift_Top = Color3.fromRGB(112, 32, 152)
        lighting.ColorShift_Bottom = Color3.fromRGB(39, 11, 60)
        lighting.EnvironmentDiffuseScale = 0.60
        lighting.EnvironmentSpecularScale = 0.40
    end)
    Velune.Notify("VELUNE", "Skybox applied: Crimson Pool")
    Velune.PlayTone(138001632, 0.2)
end
Velune.SkyIndex_CrimsonPool = {
    name = "Crimson Pool",
    id = "149507302",
    color = Color3.fromRGB(112, 32, 152),
    fog = 22,
    dens = 8,
    apply = Velune.ApplySky_CrimsonPool,
}

table.insert(Velune.SkyList, Velune.SkyIndex_CrimsonPool)
function Velune.ApplySky_SageEclipse()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_SageEclipse"
        sky.SkyboxBk = "rbxassetid://149508439"
        sky.SkyboxDn = "rbxassetid://149508439"
        sky.SkyboxFt = "rbxassetid://149508439"
        sky.SkyboxLf = "rbxassetid://149508439"
        sky.SkyboxRt = "rbxassetid://149508439"
        sky.SkyboxUp = "rbxassetid://149508439"
        sky.StarCount = 700
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 19
        lighting.Brightness = 2.10
        lighting.FogEnd = 1020
        lighting.FogStart = 55
        lighting.FogColor = Color3.fromRGB(159, 61, 205)
        lighting.Ambient = Color3.fromRGB(119, 21, 165)
        lighting.OutdoorAmbient = Color3.fromRGB(171, 69, 221)
        lighting.ColorShift_Top = Color3.fromRGB(159, 61, 205)
        lighting.ColorShift_Bottom = Color3.fromRGB(55, 21, 82)
        lighting.EnvironmentDiffuseScale = 0.70
        lighting.EnvironmentSpecularScale = 0.50
    end)
    Velune.Notify("VELUNE", "Skybox applied: Sage Eclipse")
    Velune.PlayTone(138001649, 0.2)
end
Velune.SkyIndex_SageEclipse = {
    name = "Sage Eclipse",
    id = "149508439",
    color = Color3.fromRGB(159, 61, 205),
    fog = 23,
    dens = 9,
    apply = Velune.ApplySky_SageEclipse,
}

table.insert(Velune.SkyList, Velune.SkyIndex_SageEclipse)
function Velune.ApplySky_PearlReactor()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_PearlReactor"
        sky.SkyboxBk = "rbxassetid://149509576"
        sky.SkyboxDn = "rbxassetid://149509576"
        sky.SkyboxFt = "rbxassetid://149509576"
        sky.SkyboxLf = "rbxassetid://149509576"
        sky.SkyboxRt = "rbxassetid://149509576"
        sky.SkyboxUp = "rbxassetid://149509576"
        sky.StarCount = 740
        sky.CelestialBodiesShown = true
        sky.Parent = lighting
        lighting.ClockTime = 4
        lighting.Brightness = 2.20
        lighting.FogEnd = 1240
        lighting.FogStart = 70
        lighting.FogColor = Color3.fromRGB(206, 90, 48)
        lighting.Ambient = Color3.fromRGB(166, 50, 8)
        lighting.OutdoorAmbient = Color3.fromRGB(218, 98, 64)
        lighting.ColorShift_Top = Color3.fromRGB(206, 90, 48)
        lighting.ColorShift_Bottom = Color3.fromRGB(72, 31, 19)
        lighting.EnvironmentDiffuseScale = 0.80
        lighting.EnvironmentSpecularScale = 0.60
    end)
    Velune.Notify("VELUNE", "Skybox applied: Pearl Reactor")
    Velune.PlayTone(138001666, 0.2)
end
Velune.SkyIndex_PearlReactor = {
    name = "Pearl Reactor",
    id = "149509576",
    color = Color3.fromRGB(206, 90, 48),
    fog = 0,
    dens = 10,
    apply = Velune.ApplySky_PearlReactor,
}

table.insert(Velune.SkyList, Velune.SkyIndex_PearlReactor)
function Velune.ApplySky_BlackOrchid()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSky_BlackOrchid"
        sky.SkyboxBk = "rbxassetid://149510713"
        sky.SkyboxDn = "rbxassetid://149510713"
        sky.SkyboxFt = "rbxassetid://149510713"
        sky.SkyboxLf = "rbxassetid://149510713"
        sky.SkyboxRt = "rbxassetid://149510713"
        sky.SkyboxUp = "rbxassetid://149510713"
        sky.StarCount = 780
        sky.CelestialBodiesShown = false
        sky.Parent = lighting
        lighting.ClockTime = 5
        lighting.Brightness = 2.30
        lighting.FogEnd = 1460
        lighting.FogStart = 85
        lighting.FogColor = Color3.fromRGB(23, 119, 101)
        lighting.Ambient = Color3.fromRGB(8, 79, 61)
        lighting.OutdoorAmbient = Color3.fromRGB(35, 127, 117)
        lighting.ColorShift_Top = Color3.fromRGB(23, 119, 101)
        lighting.ColorShift_Bottom = Color3.fromRGB(8, 41, 40)
        lighting.EnvironmentDiffuseScale = 0.90
        lighting.EnvironmentSpecularScale = 0.70
    end)
    Velune.Notify("VELUNE", "Skybox applied: Black Orchid")
    Velune.PlayTone(138001683, 0.2)
end
Velune.SkyIndex_BlackOrchid = {
    name = "Black Orchid",
    id = "149510713",
    color = Color3.fromRGB(23, 119, 101),
    fog = 1,
    dens = 4,
    apply = Velune.ApplySky_BlackOrchid,
}

table.insert(Velune.SkyList, Velune.SkyIndex_BlackOrchid)
function Velune.RestoreSky()
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") and tostring(ch.Name):find("VeluneSky") then
                ch:Destroy()
            end
        end
        if Velune.LightingSnap then
            lighting.ClockTime = Velune.LightingSnap.ClockTime
            lighting.Brightness = Velune.LightingSnap.Brightness
            lighting.FogEnd = Velune.LightingSnap.FogEnd
            lighting.FogStart = Velune.LightingSnap.FogStart
            lighting.FogColor = Velune.LightingSnap.FogColor
            lighting.Ambient = Velune.LightingSnap.Ambient
            lighting.OutdoorAmbient = Velune.LightingSnap.OutdoorAmbient
        end
    end)
    Velune.Notify("VELUNE", "Sky restored.")
end
function Velune.ApplySkyByName(name)
    for _, row in ipairs(Velune.SkyList) do
        if row.name == name then
            row.apply()
            return
        end
    end
    Velune.ApplySkyId(name)
end
function Velune.ApplySkyId(id)
    local lighting = Lighting
    if not lighting then
        return
    end
    pcall(function()
        for _, ch in ipairs(lighting:GetChildren()) do
            if ch:IsA("Sky") then
                ch:Destroy()
            end
        end
        local sky = Instance.new("Sky")
        sky.Name = "VeluneSkyCustom"
        local asset = "rbxassetid://" .. tostring(id)
        sky.SkyboxBk = asset
        sky.SkyboxDn = asset
        sky.SkyboxFt = asset
        sky.SkyboxLf = asset
        sky.SkyboxRt = asset
        sky.SkyboxUp = asset
        sky.Parent = lighting
    end)
    Velune.Notify("VELUNE", "Custom skybox applied — ID: " .. tostring(id))
end

Velune.CursorList = {}
function Velune.ApplyCursor_Pulse()
    Velune.CursorId = "Pulse"
    Velune.CursorAsset = "7732596388"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://7732596388"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Pulse — enable ShiftLock to see it.")
    Velune.PlayTone(110000000, 0.18)
end
Velune.Cursor_Pulse = { name = "Pulse", id = "7732596388", apply = Velune.ApplyCursor_Pulse }

table.insert(Velune.CursorList, Velune.Cursor_Pulse)
function Velune.ApplyCursor_Veil()
    Velune.CursorId = "Veil"
    Velune.CursorAsset = "11744422935"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11744422935"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Veil — enable ShiftLock to see it.")
    Velune.PlayTone(110000013, 0.18)
end
Velune.Cursor_Veil = { name = "Veil", id = "11744422935", apply = Velune.ApplyCursor_Veil }

table.insert(Velune.CursorList, Velune.Cursor_Veil)
function Velune.ApplyCursor_Pin()
    Velune.CursorId = "Pin"
    Velune.CursorAsset = "11886426936"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11886426936"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Pin — enable ShiftLock to see it.")
    Velune.PlayTone(110000026, 0.18)
end
Velune.Cursor_Pin = { name = "Pin", id = "11886426936", apply = Velune.ApplyCursor_Pin }

table.insert(Velune.CursorList, Velune.Cursor_Pin)
function Velune.ApplyCursor_Cross()
    Velune.CursorId = "Cross"
    Velune.CursorAsset = "13549422277"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://13549422277"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Cross — enable ShiftLock to see it.")
    Velune.PlayTone(110000039, 0.18)
end
Velune.Cursor_Cross = { name = "Cross", id = "13549422277", apply = Velune.ApplyCursor_Cross }

table.insert(Velune.CursorList, Velune.Cursor_Cross)
function Velune.ApplyCursor_Spec()
    Velune.CursorId = "Spec"
    Velune.CursorAsset = "9894461349"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://9894461349"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Spec — enable ShiftLock to see it.")
    Velune.PlayTone(110000052, 0.18)
end
Velune.Cursor_Spec = { name = "Spec", id = "9894461349", apply = Velune.ApplyCursor_Spec }

table.insert(Velune.CursorList, Velune.Cursor_Spec)
function Velune.ApplyCursor_Ring()
    Velune.CursorId = "Ring"
    Velune.CursorAsset = "11532581419"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11532581419"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Ring — enable ShiftLock to see it.")
    Velune.PlayTone(110000065, 0.18)
end
Velune.Cursor_Ring = { name = "Ring", id = "11532581419", apply = Velune.ApplyCursor_Ring }

table.insert(Velune.CursorList, Velune.Cursor_Ring)
function Velune.ApplyCursor_Mark()
    Velune.CursorId = "Mark"
    Velune.CursorAsset = "11600175385"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11600175385"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Mark — enable ShiftLock to see it.")
    Velune.PlayTone(110000078, 0.18)
end
Velune.Cursor_Mark = { name = "Mark", id = "11600175385", apply = Velune.ApplyCursor_Mark }

table.insert(Velune.CursorList, Velune.Cursor_Mark)
function Velune.ApplyCursor_Blade()
    Velune.CursorId = "Blade"
    Velune.CursorAsset = "12436991326"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12436991326"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Blade — enable ShiftLock to see it.")
    Velune.PlayTone(110000091, 0.18)
end
Velune.Cursor_Blade = { name = "Blade", id = "12436991326", apply = Velune.ApplyCursor_Blade }

table.insert(Velune.CursorList, Velune.Cursor_Blade)
function Velune.ApplyCursor_Shard()
    Velune.CursorId = "Shard"
    Velune.CursorAsset = "11263221028"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11263221028"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Shard — enable ShiftLock to see it.")
    Velune.PlayTone(110000104, 0.18)
end
Velune.Cursor_Shard = { name = "Shard", id = "11263221028", apply = Velune.ApplyCursor_Shard }

table.insert(Velune.CursorList, Velune.Cursor_Shard)
function Velune.ApplyCursor_Halo()
    Velune.CursorId = "Halo"
    Velune.CursorAsset = "11918800419"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11918800419"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Halo — enable ShiftLock to see it.")
    Velune.PlayTone(110000117, 0.18)
end
Velune.Cursor_Halo = { name = "Halo", id = "11918800419", apply = Velune.ApplyCursor_Halo }

table.insert(Velune.CursorList, Velune.Cursor_Halo)
function Velune.ApplyCursor_Needle()
    Velune.CursorId = "Needle"
    Velune.CursorAsset = "11419715081"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11419715081"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Needle — enable ShiftLock to see it.")
    Velune.PlayTone(110000130, 0.18)
end
Velune.Cursor_Needle = { name = "Needle", id = "11419715081", apply = Velune.ApplyCursor_Needle }

table.insert(Velune.CursorList, Velune.Cursor_Needle)
function Velune.ApplyCursor_Orbit()
    Velune.CursorId = "Orbit"
    Velune.CursorAsset = "11818642550"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11818642550"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Orbit — enable ShiftLock to see it.")
    Velune.PlayTone(110000143, 0.18)
end
Velune.Cursor_Orbit = { name = "Orbit", id = "11818642550", apply = Velune.ApplyCursor_Orbit }

table.insert(Velune.CursorList, Velune.Cursor_Orbit)
function Velune.ApplyCursor_Spark()
    Velune.CursorId = "Spark"
    Velune.CursorAsset = "10921301524"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://10921301524"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Spark — enable ShiftLock to see it.")
    Velune.PlayTone(110000156, 0.18)
end
Velune.Cursor_Spark = { name = "Spark", id = "10921301524", apply = Velune.ApplyCursor_Spark }

table.insert(Velune.CursorList, Velune.Cursor_Spark)
function Velune.ApplyCursor_Ash()
    Velune.CursorId = "Ash"
    Velune.CursorAsset = "10747382789"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://10747382789"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Ash — enable ShiftLock to see it.")
    Velune.PlayTone(110000169, 0.18)
end
Velune.Cursor_Ash = { name = "Ash", id = "10747382789", apply = Velune.ApplyCursor_Ash }

table.insert(Velune.CursorList, Velune.Cursor_Ash)
function Velune.ApplyCursor_Iris()
    Velune.CursorId = "Iris"
    Velune.CursorAsset = "12142774654"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12142774654"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Iris — enable ShiftLock to see it.")
    Velune.PlayTone(110000182, 0.18)
end
Velune.Cursor_Iris = { name = "Iris", id = "12142774654", apply = Velune.ApplyCursor_Iris }

table.insert(Velune.CursorList, Velune.Cursor_Iris)
function Velune.ApplyCursor_Knot()
    Velune.CursorId = "Knot"
    Velune.CursorAsset = "11378944521"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11378944521"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Knot — enable ShiftLock to see it.")
    Velune.PlayTone(110000195, 0.18)
end
Velune.Cursor_Knot = { name = "Knot", id = "11378944521", apply = Velune.ApplyCursor_Knot }

table.insert(Velune.CursorList, Velune.Cursor_Knot)
function Velune.ApplyCursor_Flare()
    Velune.CursorId = "Flare"
    Velune.CursorAsset = "10849618402"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://10849618402"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Flare — enable ShiftLock to see it.")
    Velune.PlayTone(110000208, 0.18)
end
Velune.Cursor_Flare = { name = "Flare", id = "10849618402", apply = Velune.ApplyCursor_Flare }

table.insert(Velune.CursorList, Velune.Cursor_Flare)
function Velune.ApplyCursor_Crest()
    Velune.CursorId = "Crest"
    Velune.CursorAsset = "12201938445"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12201938445"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Crest — enable ShiftLock to see it.")
    Velune.PlayTone(110000221, 0.18)
end
Velune.Cursor_Crest = { name = "Crest", id = "12201938445", apply = Velune.ApplyCursor_Crest }

table.insert(Velune.CursorList, Velune.Cursor_Crest)
function Velune.ApplyCursor_Dart()
    Velune.CursorId = "Dart"
    Velune.CursorAsset = "11688201933"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11688201933"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Dart — enable ShiftLock to see it.")
    Velune.PlayTone(110000234, 0.18)
end
Velune.Cursor_Dart = { name = "Dart", id = "11688201933", apply = Velune.ApplyCursor_Dart }

table.insert(Velune.CursorList, Velune.Cursor_Dart)
function Velune.ApplyCursor_Wisp()
    Velune.CursorId = "Wisp"
    Velune.CursorAsset = "11029384721"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11029384721"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Wisp — enable ShiftLock to see it.")
    Velune.PlayTone(110000247, 0.18)
end
Velune.Cursor_Wisp = { name = "Wisp", id = "11029384721", apply = Velune.ApplyCursor_Wisp }

table.insert(Velune.CursorList, Velune.Cursor_Wisp)
function Velune.ApplyCursor_Axis()
    Velune.CursorId = "Axis"
    Velune.CursorAsset = "12501938447"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12501938447"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Axis — enable ShiftLock to see it.")
    Velune.PlayTone(110000260, 0.18)
end
Velune.Cursor_Axis = { name = "Axis", id = "12501938447", apply = Velune.ApplyCursor_Axis }

table.insert(Velune.CursorList, Velune.Cursor_Axis)
function Velune.ApplyCursor_Loom()
    Velune.CursorId = "Loom"
    Velune.CursorAsset = "11192837465"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11192837465"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Loom — enable ShiftLock to see it.")
    Velune.PlayTone(110000273, 0.18)
end
Velune.Cursor_Loom = { name = "Loom", id = "11192837465", apply = Velune.ApplyCursor_Loom }

table.insert(Velune.CursorList, Velune.Cursor_Loom)
function Velune.ApplyCursor_Vane()
    Velune.CursorId = "Vane"
    Velune.CursorAsset = "12384920111"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12384920111"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Vane — enable ShiftLock to see it.")
    Velune.PlayTone(110000286, 0.18)
end
Velune.Cursor_Vane = { name = "Vane", id = "12384920111", apply = Velune.ApplyCursor_Vane }

table.insert(Velune.CursorList, Velune.Cursor_Vane)
function Velune.ApplyCursor_Glyph()
    Velune.CursorId = "Glyph"
    Velune.CursorAsset = "10938475621"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://10938475621"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Glyph — enable ShiftLock to see it.")
    Velune.PlayTone(110000299, 0.18)
end
Velune.Cursor_Glyph = { name = "Glyph", id = "10938475621", apply = Velune.ApplyCursor_Glyph }

table.insert(Velune.CursorList, Velune.Cursor_Glyph)
function Velune.ApplyCursor_Spire()
    Velune.CursorId = "Spire"
    Velune.CursorAsset = "11729384655"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11729384655"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Spire — enable ShiftLock to see it.")
    Velune.PlayTone(110000312, 0.18)
end
Velune.Cursor_Spire = { name = "Spire", id = "11729384655", apply = Velune.ApplyCursor_Spire }

table.insert(Velune.CursorList, Velune.Cursor_Spire)
function Velune.ApplyCursor_Coil()
    Velune.CursorId = "Coil"
    Velune.CursorAsset = "11482930122"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11482930122"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Coil — enable ShiftLock to see it.")
    Velune.PlayTone(110000325, 0.18)
end
Velune.Cursor_Coil = { name = "Coil", id = "11482930122", apply = Velune.ApplyCursor_Coil }

table.insert(Velune.CursorList, Velune.Cursor_Coil)
function Velune.ApplyCursor_Rift()
    Velune.CursorId = "Rift"
    Velune.CursorAsset = "12019384766"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12019384766"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Rift — enable ShiftLock to see it.")
    Velune.PlayTone(110000338, 0.18)
end
Velune.Cursor_Rift = { name = "Rift", id = "12019384766", apply = Velune.ApplyCursor_Rift }

table.insert(Velune.CursorList, Velune.Cursor_Rift)
function Velune.ApplyCursor_Nock()
    Velune.CursorId = "Nock"
    Velune.CursorAsset = "11293847501"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11293847501"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Nock — enable ShiftLock to see it.")
    Velune.PlayTone(110000351, 0.18)
end
Velune.Cursor_Nock = { name = "Nock", id = "11293847501", apply = Velune.ApplyCursor_Nock }

table.insert(Velune.CursorList, Velune.Cursor_Nock)
function Velune.ApplyCursor_Bead()
    Velune.CursorId = "Bead"
    Velune.CursorAsset = "11829374650"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11829374650"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Bead — enable ShiftLock to see it.")
    Velune.PlayTone(110000364, 0.18)
end
Velune.Cursor_Bead = { name = "Bead", id = "11829374650", apply = Velune.ApplyCursor_Bead }

table.insert(Velune.CursorList, Velune.Cursor_Bead)
function Velune.ApplyCursor_Quill()
    Velune.CursorId = "Quill"
    Velune.CursorAsset = "11501928374"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11501928374"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Quill — enable ShiftLock to see it.")
    Velune.PlayTone(110000377, 0.18)
end
Velune.Cursor_Quill = { name = "Quill", id = "11501928374", apply = Velune.ApplyCursor_Quill }

table.insert(Velune.CursorList, Velune.Cursor_Quill)
function Velune.ApplyCursor_Arc()
    Velune.CursorId = "Arc"
    Velune.CursorAsset = "12193847560"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12193847560"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Arc — enable ShiftLock to see it.")
    Velune.PlayTone(110000390, 0.18)
end
Velune.Cursor_Arc = { name = "Arc", id = "12193847560", apply = Velune.ApplyCursor_Arc }

table.insert(Velune.CursorList, Velune.Cursor_Arc)
function Velune.ApplyCursor_Tide()
    Velune.CursorId = "Tide"
    Velune.CursorAsset = "11384920100"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11384920100"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Tide — enable ShiftLock to see it.")
    Velune.PlayTone(110000403, 0.18)
end
Velune.Cursor_Tide = { name = "Tide", id = "11384920100", apply = Velune.ApplyCursor_Tide }

table.insert(Velune.CursorList, Velune.Cursor_Tide)
function Velune.ApplyCursor_Hex()
    Velune.CursorId = "Hex"
    Velune.CursorAsset = "11938475611"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11938475611"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Hex — enable ShiftLock to see it.")
    Velune.PlayTone(110000416, 0.18)
end
Velune.Cursor_Hex = { name = "Hex", id = "11938475611", apply = Velune.ApplyCursor_Hex }

table.insert(Velune.CursorList, Velune.Cursor_Hex)
function Velune.ApplyCursor_Node()
    Velune.CursorId = "Node"
    Velune.CursorAsset = "11029384799"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11029384799"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Node — enable ShiftLock to see it.")
    Velune.PlayTone(110000429, 0.18)
end
Velune.Cursor_Node = { name = "Node", id = "11029384799", apply = Velune.ApplyCursor_Node }

table.insert(Velune.CursorList, Velune.Cursor_Node)
function Velune.ApplyCursor_Brim()
    Velune.CursorId = "Brim"
    Velune.CursorAsset = "12401938470"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12401938470"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Brim — enable ShiftLock to see it.")
    Velune.PlayTone(110000442, 0.18)
end
Velune.Cursor_Brim = { name = "Brim", id = "12401938470", apply = Velune.ApplyCursor_Brim }

table.insert(Velune.CursorList, Velune.Cursor_Brim)
function Velune.ApplyCursor_Sable()
    Velune.CursorId = "Sable"
    Velune.CursorAsset = "11629384712"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11629384712"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Sable — enable ShiftLock to see it.")
    Velune.PlayTone(110000455, 0.18)
end
Velune.Cursor_Sable = { name = "Sable", id = "11629384712", apply = Velune.ApplyCursor_Sable }

table.insert(Velune.CursorList, Velune.Cursor_Sable)
function Velune.ApplyCursor_Pike()
    Velune.CursorId = "Pike"
    Velune.CursorAsset = "10829374644"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://10829374644"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Pike — enable ShiftLock to see it.")
    Velune.PlayTone(110000468, 0.18)
end
Velune.Cursor_Pike = { name = "Pike", id = "10829374644", apply = Velune.ApplyCursor_Pike }

table.insert(Velune.CursorList, Velune.Cursor_Pike)
function Velune.ApplyCursor_Gleam()
    Velune.CursorId = "Gleam"
    Velune.CursorAsset = "12293847588"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12293847588"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Gleam — enable ShiftLock to see it.")
    Velune.PlayTone(110000481, 0.18)
end
Velune.Cursor_Gleam = { name = "Gleam", id = "12293847588", apply = Velune.ApplyCursor_Gleam }

table.insert(Velune.CursorList, Velune.Cursor_Gleam)
function Velune.ApplyCursor_Oath()
    Velune.CursorId = "Oath"
    Velune.CursorAsset = "11101928340"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11101928340"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Oath — enable ShiftLock to see it.")
    Velune.PlayTone(110000494, 0.18)
end
Velune.Cursor_Oath = { name = "Oath", id = "11101928340", apply = Velune.ApplyCursor_Oath }

table.insert(Velune.CursorList, Velune.Cursor_Oath)
function Velune.ApplyCursor_Vesper()
    Velune.CursorId = "Vesper"
    Velune.CursorAsset = "12519384701"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12519384701"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Vesper — enable ShiftLock to see it.")
    Velune.PlayTone(110000507, 0.18)
end
Velune.Cursor_Vesper = { name = "Vesper", id = "12519384701", apply = Velune.ApplyCursor_Vesper }

table.insert(Velune.CursorList, Velune.Cursor_Vesper)
function Velune.ApplyCursor_Lumen()
    Velune.CursorId = "Lumen"
    Velune.CursorAsset = "11401928366"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11401928366"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Lumen — enable ShiftLock to see it.")
    Velune.PlayTone(110000520, 0.18)
end
Velune.Cursor_Lumen = { name = "Lumen", id = "11401928366", apply = Velune.ApplyCursor_Lumen }

table.insert(Velune.CursorList, Velune.Cursor_Lumen)
function Velune.ApplyCursor_Nadir()
    Velune.CursorId = "Nadir"
    Velune.CursorAsset = "12084920133"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12084920133"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Nadir — enable ShiftLock to see it.")
    Velune.PlayTone(110000533, 0.18)
end
Velune.Cursor_Nadir = { name = "Nadir", id = "12084920133", apply = Velune.ApplyCursor_Nadir }

table.insert(Velune.CursorList, Velune.Cursor_Nadir)
function Velune.ApplyCursor_Helix()
    Velune.CursorId = "Helix"
    Velune.CursorAsset = "10919384722"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://10919384722"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Helix — enable ShiftLock to see it.")
    Velune.PlayTone(110000546, 0.18)
end
Velune.Cursor_Helix = { name = "Helix", id = "10919384722", apply = Velune.ApplyCursor_Helix }

table.insert(Velune.CursorList, Velune.Cursor_Helix)
function Velune.ApplyCursor_Mirth()
    Velune.CursorId = "Mirth"
    Velune.CursorAsset = "11701928355"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11701928355"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Mirth — enable ShiftLock to see it.")
    Velune.PlayTone(110000559, 0.18)
end
Velune.Cursor_Mirth = { name = "Mirth", id = "11701928355", apply = Velune.ApplyCursor_Mirth }

table.insert(Velune.CursorList, Velune.Cursor_Mirth)
function Velune.ApplyCursor_Cinder()
    Velune.CursorId = "Cinder"
    Velune.CursorAsset = "11284920177"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11284920177"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Cinder — enable ShiftLock to see it.")
    Velune.PlayTone(110000572, 0.18)
end
Velune.Cursor_Cinder = { name = "Cinder", id = "11284920177", apply = Velune.ApplyCursor_Cinder }

table.insert(Velune.CursorList, Velune.Cursor_Cinder)
function Velune.ApplyCursor_Auric()
    Velune.CursorId = "Auric"
    Velune.CursorAsset = "12319384744"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12319384744"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Auric — enable ShiftLock to see it.")
    Velune.PlayTone(110000585, 0.18)
end
Velune.Cursor_Auric = { name = "Auric", id = "12319384744", apply = Velune.ApplyCursor_Auric }

table.insert(Velune.CursorList, Velune.Cursor_Auric)
function Velune.ApplyCursor_Pell()
    Velune.CursorId = "Pell"
    Velune.CursorAsset = "11584920190"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11584920190"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Pell — enable ShiftLock to see it.")
    Velune.PlayTone(110000598, 0.18)
end
Velune.Cursor_Pell = { name = "Pell", id = "11584920190", apply = Velune.ApplyCursor_Pell }

table.insert(Velune.CursorList, Velune.Cursor_Pell)
function Velune.ApplyCursor_Skein()
    Velune.CursorId = "Skein"
    Velune.CursorAsset = "11801928311"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11801928311"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Skein — enable ShiftLock to see it.")
    Velune.PlayTone(110000611, 0.18)
end
Velune.Cursor_Skein = { name = "Skein", id = "11801928311", apply = Velune.ApplyCursor_Skein }

table.insert(Velune.CursorList, Velune.Cursor_Skein)
function Velune.ApplyCursor_Thorn()
    Velune.CursorId = "Thorn"
    Velune.CursorAsset = "11084920145"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://11084920145"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Thorn — enable ShiftLock to see it.")
    Velune.PlayTone(110000624, 0.18)
end
Velune.Cursor_Thorn = { name = "Thorn", id = "11084920145", apply = Velune.ApplyCursor_Thorn }

table.insert(Velune.CursorList, Velune.Cursor_Thorn)
function Velune.ApplyCursor_Vellum()
    Velune.CursorId = "Vellum"
    Velune.CursorAsset = "12419384790"
    if Velune.CrosshairImage then
        Velune.CrosshairImage.Image = "rbxassetid://12419384790"
        Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 52, 0, 52) }, 0.12)
        task.delay(0.12, function()
            if Velune.CrosshairImage then
                Velune.Spring(Velune.CrosshairImage, { Size = UDim2.new(0, 42, 0, 42) }, 0.18)
            end
        end)
    end
    Velune.Notify("VELUNE", "Cursor: Vellum — enable ShiftLock to see it.")
    Velune.PlayTone(110000637, 0.18)
end
Velune.Cursor_Vellum = { name = "Vellum", id = "12419384790", apply = Velune.ApplyCursor_Vellum }

table.insert(Velune.CursorList, Velune.Cursor_Vellum)
function Velune.EnsureCrosshair()
    local host = Velune.HostGui()
    if Velune.CrosshairImage and Velune.CrosshairImage.Parent then
        return
    end
    local img = Instance.new("ImageLabel")
    img.Name = "VeluneCrosshair"
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.Position = UDim2.new(0.5, 0, 0.5, 0)
    img.Size = UDim2.new(0, 42, 0, 42)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://" .. tostring(Velune.CursorAsset)
    img.ZIndex = 80
    img.Visible = false
    img.Parent = host
    Velune.CrosshairImage = img
    if Velune.CrosshairSpinConn then
        Velune.CrosshairSpinConn:Disconnect()
    end
    Velune.CrosshairSpinConn = Velune.Track(RunService.RenderStepped:Connect(function(dt)
        if not Velune.CrosshairImage then
            return
        end
        local lock = UserInputService and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
        local show = Velune.Flags.Crosshair and lock
        Velune.CrosshairImage.Visible = show
        if UserInputService then
            UserInputService.MouseIconEnabled = not show
        end
        if show and Velune.Flags.CursorSpin then
            Velune.CrosshairImage.Rotation = (Velune.CrosshairImage.Rotation + dt * 120) % 360
        end
        pcall(function()
            if LP and LP:FindFirstChild("PlayerGui") then
                local bar = LP.PlayerGui:FindFirstChild("GameTopbar")
                if bar and bar:FindFirstChild("Crosshair") then
                    bar.Crosshair.Visible = false
                end
            end
        end)
    end))
end
function Velune.SetCrosshair(on)
    Velune.Flags.Crosshair = on
    if on then
        Velune.EnsureCrosshair()
        Velune.Notify("VELUNE", "Crosshair ON — enable ShiftLock to see it!")
    else
        if Velune.CrosshairImage then
            Velune.CrosshairImage:Destroy()
            Velune.CrosshairImage = nil
        end
        if UserInputService then
            UserInputService.MouseIconEnabled = true
        end
        Velune.Notify("VELUNE", "Crosshair OFF")
    end
end

function Velune.PlayEmote_sit()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("sit")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808223"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: sit")
end

function Velune.PlayEmote_zombie()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("zombie")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808242"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: zombie")
end

function Velune.PlayEmote_ninja()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("ninja")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808261"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: ninja")
end

function Velune.PlayEmote_zen()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("zen")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808280"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: zen")
end

function Velune.PlayEmote_floss()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("floss")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808299"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: floss")
end

function Velune.PlayEmote_dab()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("dab")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808318"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: dab")
end

function Velune.PlayEmote_wave()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("wave")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808337"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: wave")
end

function Velune.PlayEmote_laugh()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("laugh")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808356"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: laugh")
end

function Velune.PlayEmote_point()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("point")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808375"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: point")
end

function Velune.PlayEmote_dance()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("dance")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808394"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: dance")
end

function Velune.PlayEmote_cheer()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("cheer")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808413"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: cheer")
end

function Velune.PlayEmote_shrug()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("shrug")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808432"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: shrug")
end

function Velune.PlayEmote_salute()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("salute")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808451"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: salute")
end

function Velune.PlayEmote_think()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("think")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808470"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: think")
end

function Velune.PlayEmote_confused()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("confused")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808489"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: confused")
end

function Velune.PlayEmote_agree()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("agree")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808508"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: agree")
end

function Velune.PlayEmote_disagree()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("disagree")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808527"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: disagree")
end

function Velune.PlayEmote_sleep()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("sleep")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808546"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: sleep")
end

function Velune.PlayEmote_clap()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("clap")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808565"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: clap")
end

function Velune.PlayEmote_bow()
    local hum = Velune.Hum()
    if not hum then
        Velune.Notify("VELUNE", "No character to emote.")
        return
    end
    local ok = false
    pcall(function()
        ok = hum:PlayEmote("bow")
    end)
    if not ok then
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://4555808584"
            local t = hum:LoadAnimation(anim)
            t:Play()
        end)
    end
    Velune.Notify("VELUNE", "Emote: bow")
end

function Velune.PlayEmote(name)
    local fn = Velune["PlayEmote_" .. tostring(name)]
    if fn then
        fn()
        return
    end
    Velune.Notify("VELUNE", "Unknown emote.")
end
function Velune.ChatRoles()
    local m = Velune.FindMurderer()
    local s = Velune.FindSheriff()
    local line = "VELUNE roles — Murderer: " .. (m and m.Name or "?") .. "  Sheriff: " .. (s and s.Name or "?")
    pcall(function()
        if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local ch = TextChatService.TextChannels and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if ch then
                ch:SendAsync(line)
                return
            end
        end
        StarterGui:SetCore("ChatMakeSystemMessage", { Text = line, Color = Velune.Accent })
    end)
    Velune.Notify("VELUNE", line)
end

function Velune.ClearESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("VeluneESP")
            if h then
                h:Destroy()
            end
            local b = p.Character:FindFirstChild("VeluneBill")
            if b then
                b:Destroy()
            end
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local bb = r:FindFirstChild("VeluneBill")
                if bb then
                    bb:Destroy()
                end
            end
        end
    end
    for _, d in pairs(Velune.Lines) do
        pcall(function()
            d:Remove()
        end)
    end
    Velune.Lines = {}
    if Velune.GunHighlight then
        Velune.GunHighlight:Destroy()
        Velune.GunHighlight = nil
    end
    if Velune.GunBill then
        Velune.GunBill:Destroy()
        Velune.GunBill = nil
    end
    if Velune.GunMarker then
        Velune.GunMarker:Destroy()
        Velune.GunMarker = nil
    end
end
function Velune.PaintHighlight(char, color)
    local h = char:FindFirstChild("VeluneESP")
    if not h then
        h = Instance.new("Highlight")
        h.Name = "VeluneESP"
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.FillTransparency = 0.68
        h.OutlineTransparency = 0.12
        h.OutlineColor = Color3.new(1, 1, 1)
        h.Parent = char
    end
    h.FillColor = color
    h.Adornee = char
    return h
end
function Velune.PaintName(player, role, color)
    local char = player.Character
    if not char then
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    if not hrp then
        return
    end
    local gui = hrp:FindFirstChild("VeluneBill")
    if not gui then
        gui = Instance.new("BillboardGui")
        gui.Name = "VeluneBill"
        gui.Size = UDim2.new(0, 160, 0, 40)
        gui.StudsOffset = Vector3.new(0, 3.1, 0)
        gui.AlwaysOnTop = true
        gui.MaxDistance = 600
        gui.Parent = hrp
        local t = Instance.new("TextLabel")
        t.Name = "Label"
        t.BackgroundTransparency = 1
        t.Size = UDim2.new(1, 0, 1, 0)
        t.Font = Enum.Font.GothamBold
        t.TextSize = 14
        t.TextStrokeTransparency = 0.45
        t.TextStrokeColor3 = Color3.new(0, 0, 0)
        t.Parent = gui
    end
    local lab = gui:FindFirstChild("Label")
    if lab then
        lab.TextColor3 = color
        lab.Text = player.Name .. "  ·  " .. role
        gui.Enabled = Velune.Flags.Names
    end
end
function Velune.LineFor(player)
    if not Drawing or not Drawing.new then
        return nil
    end
    if not Velune.Lines[player] then
        local ok, line = pcall(function()
            local d = Drawing.new("Line")
            d.Visible = false
            d.Thickness = 1.4
            d.Transparency = 1
            return d
        end)
        if ok then
            Velune.Lines[player] = line
        end
    end
    return Velune.Lines[player]
end
function Velune.BoxFor(player)
    if not Drawing or not Drawing.new then
        return nil
    end
    local key = tostring(player) .. "_box"
    if not Velune.Lines[key] then
        local ok, box = pcall(function()
            local d = Drawing.new("Square")
            d.Visible = false
            d.Filled = false
            d.Thickness = 1.2
            return d
        end)
        if ok then
            Velune.Lines[key] = box
        end
    end
    return Velune.Lines[key]
end
function Velune.TickESP()
    if not Velune.Flags.ESP then
        Velune.ClearESP()
        return
    end
    local cam = Velune.Cam()
    if not cam or not Players then
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if not char or not Velune.Alive(player) then
            local line = Velune.Lines[player]
            if line then
                line.Visible = false
            end
        else
            local role = Velune.RoleOf(player)
            local show = true
            if player == LP then
                show = Velune.Flags.ShowSelf
            elseif role == "Murderer" then
                show = Velune.Flags.ShowMurderer
            elseif role == "Sheriff" then
                show = Velune.Flags.ShowSheriff
            elseif role == "Hero" then
                show = Velune.Flags.ShowHero
            else
                show = Velune.Flags.ShowInnocent
            end
            local color = Velune.Colors[role] or Color3.fromRGB(200, 200, 200)
            if not show then
                local h = char:FindFirstChild("VeluneESP")
                if h then
                    h:Destroy()
                end
                local line = Velune.Lines[player]
                if line then
                    line.Visible = false
                end
            else
                Velune.PaintHighlight(char, color)
                Velune.PaintName(player, role, color)
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if Velune.Flags.Tracers and hrp and cam then
                    local line = Velune.LineFor(player)
                    if line then
                        local v, on = cam:WorldToViewportPoint(hrp.Position)
                        if on then
                            line.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                            line.To = Vector2.new(v.X, v.Y)
                            line.Color = color
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    end
                else
                    local line = Velune.Lines[player]
                    if line then
                        line.Visible = false
                    end
                end
                if Velune.Flags.Boxes and hrp and cam then
                    local box = Velune.BoxFor(player)
                    if box then
                        local v, on = cam:WorldToViewportPoint(hrp.Position)
                        if on then
                            local dist = (cam.CFrame.Position - hrp.Position).Magnitude
                            local sz = math.clamp(2200 / math.max(dist, 8), 18, 90)
                            box.Size = Vector2.new(sz * 0.72, sz)
                            box.Position = Vector2.new(v.X - sz * 0.36, v.Y - sz * 0.55)
                            box.Color = color
                            box.Visible = true
                        else
                            box.Visible = false
                        end
                    end
                end
            end
        end
    end
    if Velune.Flags.GunESP then
        Velune.MarkGun(Velune.GunDrop())
    end
end
function Velune.MarkGun(drop)
    if not drop then
        if Velune.GunHighlight then
            Velune.GunHighlight:Destroy()
            Velune.GunHighlight = nil
        end
        if Velune.GunBill then
            Velune.GunBill:Destroy()
            Velune.GunBill = nil
        end
        if Velune.GunMarker then
            Velune.GunMarker:Destroy()
            Velune.GunMarker = nil
        end
        return
    end
    if not Velune.Flags.GunESP then
        return
    end
    if not Velune.GunHighlight or Velune.GunHighlight.Adornee ~= drop then
        if Velune.GunHighlight then
            Velune.GunHighlight:Destroy()
        end
        local h = Instance.new("Highlight")
        h.Adornee = drop
        h.FillColor = Velune.Colors.Gun
        h.OutlineColor = Color3.new(1, 1, 1)
        h.FillTransparency = 0.35
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = drop
        Velune.GunHighlight = h
    end
    local part = drop:FindFirstChild("Handle") or (drop:IsA("Model") and drop.PrimaryPart) or drop:FindFirstChildWhichIsA("BasePart") or (drop:IsA("BasePart") and drop)
    if part then
        if not Velune.GunBill or Velune.GunBill.Parent ~= part then
            if Velune.GunBill then
                Velune.GunBill:Destroy()
            end
            local bill = Instance.new("BillboardGui")
            bill.Size = UDim2.new(0, 130, 0, 36)
            bill.StudsOffset = Vector3.new(0, 4, 0)
            bill.AlwaysOnTop = true
            bill.MaxDistance = 400
            bill.Parent = part
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 1, 0)
            f.BackgroundColor3 = Color3.new(0, 0, 0)
            f.BackgroundTransparency = 0.4
            f.BorderSizePixel = 0
            f.Parent = bill
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 6)
            c.Parent = f
            local st = Instance.new("UIStroke")
            st.Color = Velune.Colors.Gun
            st.Thickness = 1.5
            st.Parent = f
            local t = Instance.new("TextLabel")
            t.BackgroundTransparency = 1
            t.Size = UDim2.new(1, 0, 1, 0)
            t.Font = Enum.Font.GothamBlack
            t.TextSize = 13
            t.Text = "GUN ON MAP"
            t.TextColor3 = Velune.Colors.Gun
            t.Parent = f
            Velune.GunBill = bill
        end
        if not Velune.GunMarker then
            local m = Instance.new("Part")
            m.Name = "VeluneGunMarker"
            m.Size = Vector3.new(1.5, 0.15, 1.5)
            m.Anchored = true
            m.CanCollide = false
            m.CastShadow = false
            m.Material = Enum.Material.Neon
            m.Color = Color3.fromRGB(50, 255, 80)
            m.Transparency = 0.25
            m.CFrame = CFrame.new(part.Position + Vector3.new(0, 0.1, 0))
            m.Parent = Workspace
            Velune.GunMarker = m
            task.spawn(function()
                while m and m.Parent do
                    for i = 0, 1, 0.05 do
                        if not m.Parent then
                            break
                        end
                        m.Transparency = 0.25 + 0.5 * math.sin(i * math.pi)
                        task.wait(0.03)
                    end
                end
            end)
        else
            Velune.GunMarker.CFrame = CFrame.new(part.Position + Vector3.new(0, 0.1, 0))
        end
    end
end

function Velune.GoldJump()
    if Velune.OnCooldown("gold", 2600) then
        Velune.Notify("VELUNE", "Gold jump cooling.")
        return
    end
    local hrp = Velune.HRP()
    local hum = Velune.Hum()
    if not hrp or not hum then
        return
    end
    local lift = 92
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, lift, hrp.AssemblyLinearVelocity.Z)
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
    Velune.Notify("VELUNE", "Gold jump.")
    Velune.BurstAt(hrp.Position, Color3.fromRGB(232, 180, 40))
end
function Velune.NormalJump()
    if Velune.OnCooldown("normal", 1800) then
        Velune.Notify("VELUNE", "Normal jump cooling.")
        return
    end
    local hrp = Velune.HRP()
    local hum = Velune.Hum()
    if not hrp or not hum then
        return
    end
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 72, hrp.AssemblyLinearVelocity.Z)
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
    Velune.Notify("VELUNE", "Normal jump.")
    Velune.BurstAt(hrp.Position, Color3.fromRGB(40, 180, 90))
end
function Velune.BurstAt(pos, color)
    if not Workspace then
        return
    end
    pcall(function()
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.4, 0.4, 0.4)
        p.Shape = Enum.PartType.Ball
        p.Anchored = true
        p.CanCollide = false
        p.Material = Enum.Material.Neon
        p.Color = color
        p.CFrame = CFrame.new(pos)
        p.Parent = Workspace
        Velune.Tween(p, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(6, 6, 6),
            Transparency = 1,
        })
        if Debris then
            Debris:AddItem(p, 0.4)
        end
    end)
end
function Velune.WallHop()
    if Velune.OnCooldown("wallhop", 1600) then
        Velune.Notify("VELUNE", "Wall hop cooling.")
        return
    end
    local hrp = Velune.HRP()
    local hum = Velune.Hum()
    local cam = Velune.Cam()
    if not hrp or not hum or not cam then
        return
    end
    local look = cam.CFrame.LookVector
    pcall(function()
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 4.2, 0) + look * 3.4
        hrp.AssemblyLinearVelocity = look * 48 + Vector3.new(0, 42, 0)
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
    Velune.Notify("VELUNE", "Wall hop.")
end
function Velune.Flick()
    if Velune.FlickBusy then
        return
    end
    local hrp = Velune.HRP()
    local cam = Velune.Cam()
    if not hrp then
        return
    end
    Velune.FlickBusy = true
    local locked = false
    pcall(function()
        locked = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
    end)
    if not locked then
        local from = hrp.CFrame
        local dest = from * CFrame.Angles(0, math.pi, 0)
        for i = 1, 4 do
            pcall(function()
                hrp.CFrame = from:Lerp(dest, i / 4)
            end)
            RunService.RenderStepped:Wait()
        end
        Velune.Notify("VELUNE", "Flick turn 180°")
    elseif cam then
        local from = cam.CFrame
        local look = from.LookVector
        local dest = CFrame.lookAt(from.Position, from.Position + Vector3.new(-look.X, look.Y, -look.Z))
        for i = 1, 5 do
            pcall(function()
                cam.CFrame = from:Lerp(dest, i / 5)
            end)
            RunService.RenderStepped:Wait()
        end
        Velune.Notify("VELUNE", "Flick camera 180°")
    end
    task.wait(0.15)
    Velune.FlickBusy = false
end
function Velune.ShootOrThrow()
    if Velune.OnCooldown("shoot", 900) then
        return
    end
    local knife = Velune.HasTool("Knife")
    local gun = Velune.HasTool("Gun")
    if knife then
        Velune.ThrowKnife()
        return
    end
    if gun then
        Velune.ShootMurderer()
        return
    end
    Velune.Notify("VELUNE", "No gun equipped.")
end
function Velune.Equip(tool)
    local hum = Velune.Hum()
    if hum and tool then
        pcall(function()
            hum:EquipTool(tool)
        end)
    end
end
function Velune.ShootMurderer()
    local gun = Velune.HasTool("Gun")
    local murd = Velune.FindMurderer()
    if not gun then
        Velune.Notify("VELUNE", "No gun equipped.")
        return
    end
    if not murd or not murd.Character then
        Velune.Notify("VELUNE", "No murderer in range.")
        return
    end
    Velune.Equip(gun)
    local head = murd.Character:FindFirstChild("Head") or murd.Character:FindFirstChild("HumanoidRootPart")
    local cam = Velune.Cam()
    if head and cam then
        local aim = head.Position
        if Velune.Flags.PingPredict then
            local hrp = murd.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                aim = aim + hrp.AssemblyLinearVelocity * Velune.Ping()
            end
        end
        cam.CFrame = CFrame.new(cam.CFrame.Position, aim)
    end
    pcall(function()
        gun:Activate()
    end)
    local shootEv = Velune.FindRemote("ShootGun", "RemoteEvent") or Velune.FindRemote("Shoot", "RemoteEvent")
    if shootEv and head then
        pcall(function()
            shootEv:FireServer(head.Position, head)
        end)
    end
    Velune.Notify("VELUNE", "Shot " .. murd.Name .. ".")
end
function Velune.ThrowKnife()
    local knife = Velune.HasTool("Knife")
    if not knife then
        Velune.Notify("VELUNE", "No knife.")
        return
    end
    local target
    local best = 1e9
    local hrp = Velune.HRP()
    if not Players or not hrp then
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and Velune.Alive(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < best then
                best = d
                target = p
            end
        end
    end
    if not target then
        Velune.Notify("VELUNE", "No throw target.")
        return
    end
    Velune.Equip(knife)
    local cam = Velune.Cam()
    local aim = target.Character.HumanoidRootPart.Position
    if cam then
        cam.CFrame = CFrame.new(cam.CFrame.Position, aim)
    end
    pcall(function()
        knife:Activate()
    end)
    Velune.Notify("VELUNE", "Threw at " .. target.Name .. ".")
end
function Velune.SilentThrow()
    local knife = Velune.HasTool("Knife")
    if not knife then
        Velune.Notify("VELUNE", "No knife.")
        return
    end
    local target
    local best = 1e9
    local hrp = Velune.HRP()
    if not hrp or not Players then
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and Velune.Alive(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < best then
                best = d
                target = p
            end
        end
    end
    if not target then
        return
    end
    local ev = Velune.FindRemote("ThrowKnife", "RemoteEvent") or Velune.FindRemote("KnifeThrown", "RemoteEvent")
    local pos = target.Character.HumanoidRootPart.Position
    if ev then
        pcall(function()
            ev:FireServer(pos)
        end)
    else
        Velune.Equip(knife)
        pcall(function()
            knife:Activate()
        end)
    end
    Velune.Notify("VELUNE", "Silent throw → " .. target.Name)
end
function Velune.GrabGun()
    local drop = Velune.GunDrop()
    local hrp = Velune.HRP()
    if not drop then
        Velune.Notify("VELUNE", "No gun on map.")
        return
    end
    if not hrp then
        Velune.Notify("VELUNE", "Gun position not found!")
        return
    end
    local part = drop:IsA("BasePart") and drop or drop:FindFirstChildWhichIsA("BasePart") or drop.PrimaryPart
    if not part then
        Velune.Notify("VELUNE", "Gun position not found!")
        return
    end
    local old = hrp.CFrame
    Velune.PivotTo(part.CFrame + Vector3.new(0, 3, 0))
    if firetouchinterest then
        pcall(function()
            firetouchinterest(hrp, part, 0)
            task.wait(0.08)
            firetouchinterest(hrp, part, 1)
        end)
    end
    task.delay(0.2, function()
        if not Velune.HasTool("Gun") then
            Velune.PivotTo(old)
        end
    end)
    Velune.Notify("VELUNE", "Teleported to gun!")
end
function Velune.FlingPlayer(player)
    if Velune.FlingBusy then
        Velune.Notify("VELUNE", "Fling in progress...")
        return
    end
    if not player or not player.Character then
        return
    end
    local hrp = Velune.HRP()
    local th = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not th then
        return
    end
    Velune.FlingBusy = true
    Velune.Notify("VELUNE", "Flinging: " .. player.Name)
    local old = hrp.CFrame
    task.spawn(function()
        local t0 = tick()
        while tick() - t0 < 1.6 and th and th.Parent and hrp and hrp.Parent do
            pcall(function()
                hrp.CFrame = th.CFrame * CFrame.new(0, 0.2, 0)
                hrp.AssemblyLinearVelocity = Vector3.new(0, 1e5, 0)
                hrp.AssemblyAngularVelocity = Vector3.new(9e8, 9e8, 9e8)
            end)
            RunService.Heartbeat:Wait()
        end
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.new()
            hrp.AssemblyAngularVelocity = Vector3.new()
            hrp.CFrame = old
        end)
        Velune.FlingBusy = false
    end)
end
function Velune.FlingMurderer()
    local m = Velune.FindMurderer()
    if not m then
        Velune.Notify("VELUNE", "No knife player found!")
        return
    end
    Velune.FlingPlayer(m)
end
function Velune.FlingSheriff()
    local s = Velune.FindSheriff()
    if not s then
        Velune.Notify("VELUNE", "No gun player found!")
        return
    end
    Velune.FlingPlayer(s)
end
function Velune.KillAll()
    local knife = Velune.HasTool("Knife")
    if not knife or not Players then
        Velune.Notify("VELUNE", "Knife required.")
        return
    end
    Velune.Equip(knife)
    task.spawn(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and Velune.Alive(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = Velune.HRP()
                if hrp then
                    hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    pcall(function()
                        knife:Activate()
                    end)
                    task.wait(0.12)
                end
            end
        end
        Velune.Notify("VELUNE", "Kill all finished.")
    end)
end
function Velune.KnifeAuraTick()
    if not Velune.Flags.KnifeAura then
        return
    end
    local knife = Velune.HasTool("Knife")
    local hrp = Velune.HRP()
    if not knife or not hrp or not Players then
        return
    end
    Velune.Equip(knife)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and Velune.Alive(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d <= Velune.Values.Aura then
                pcall(function()
                    knife:Activate()
                end)
            end
        end
    end
end

function Velune.SetSpeed(on)
    Velune.Flags.SpeedOn = on
    local hum = Velune.Hum()
    if hum then
        hum.WalkSpeed = on and math.max(hum.WalkSpeed, Velune.Values.Walk) or 16
    end
    Velune.Notify("VELUNE", on and "Speed ON" or "Speed OFF")
end
function Velune.SpeedTick()
    if not Velune.Flags.SpeedOn then
        return
    end
    local hrp = Velune.HRP()
    local hum = Velune.Hum()
    if not hrp or not hum then
        return
    end
    local dir = hum.MoveDirection
    if dir.Magnitude > 0 then
        hrp.AssemblyLinearVelocity = Vector3.new(dir.X * Velune.Values.Speed, hrp.AssemblyLinearVelocity.Y, dir.Z * Velune.Values.Speed)
    end
end
function Velune.SetStretch(on)
    Velune.Flags.StretchOn = on
    local cam = Velune.Cam()
    if not cam then
        return
    end
    pcall(function()
        if on then
            cam.FieldOfView = math.clamp(Velune.Values.FOV * (0.6 + Velune.Values.Stretch * 0.8), 30, 120)
        else
            cam.FieldOfView = Velune.Values.FOV
        end
    end)
    Velune.Notify("VELUNE", on and "Stretch ON" or "Stretch OFF")
end
function Velune.SetFOV(n)
    Velune.Values.FOV = n
    local cam = Velune.Cam()
    if cam then
        cam.FieldOfView = n
    end
end
local flyGyro, flyVel, flyConn
function Velune.SetFly(on)
    Velune.Flags.Fly = on
    if flyConn then
        flyConn:Disconnect()
        flyConn = nil
    end
    if flyGyro then
        flyGyro:Destroy()
        flyGyro = nil
    end
    if flyVel then
        flyVel:Destroy()
        flyVel = nil
    end
    local hrp = Velune.HRP()
    local hum = Velune.Hum()
    if not on then
        if hum then
            hum.PlatformStand = false
        end
        Velune.Notify("VELUNE", "Fly OFF")
        return
    end
    if not hrp or not hum then
        return
    end
    flyGyro = Instance.new("BodyGyro")
    flyGyro.Name = "VeluneFlyGyro"
    flyGyro.P = 90000
    flyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyGyro.CFrame = hrp.CFrame
    flyGyro.Parent = hrp
    flyVel = Instance.new("BodyVelocity")
    flyVel.Name = "VeluneFlyVel"
    flyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyVel.Velocity = Vector3.new()
    flyVel.Parent = hrp
    flyConn = Velune.Track(RunService.RenderStepped:Connect(function()
        if not Velune.Flags.Fly or not hrp.Parent then
            Velune.SetFly(false)
            return
        end
        local cam = Velune.Cam()
        if not cam then
            return
        end
        hum.PlatformStand = true
        flyGyro.CFrame = cam.CFrame
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move = move + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move = move - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move = move - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move = move + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move = move + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            move = move - Vector3.new(0, 1, 0)
        end
        if move.Magnitude > 0 then
            flyVel.Velocity = move.Unit * Velune.Values.FlySpeed
        else
            flyVel.Velocity = Vector3.new()
        end
    end))
    Velune.Notify("VELUNE", "Fly ON")
end
local noclipConn
function Velune.SetNoclip(on)
    Velune.Flags.Noclip = on
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    if on then
        noclipConn = Velune.Track(RunService.Stepped:Connect(function()
            local c = Velune.Char()
            if not c then
                return
            end
            for _, d in ipairs(c:GetDescendants()) do
                if d:IsA("BasePart") then
                    d.CanCollide = false
                end
            end
        end))
        Velune.Notify("VELUNE", "Noclip ON")
    else
        Velune.Notify("VELUNE", "Noclip OFF")
    end
end
function Velune.SetInfiniteJump(on)
    Velune.Flags.InfiniteJump = on
    Velune.Notify("VELUNE", on and "Infinite jump ON" or "Infinite jump OFF")
end
function Velune.SetWalk(n)
    Velune.Values.Walk = n
    local hum = Velune.Hum()
    if hum then
        hum.WalkSpeed = n
    end
end
function Velune.SetJump(n)
    Velune.Values.Jump = n
    local hum = Velune.Hum()
    if hum then
        pcall(function()
            hum.JumpPower = n
            hum.UseJumpPower = true
        end)
    end
end
local antiConn
function Velune.SetAntiFling(on)
    Velune.Flags.AntiFling = on
    if antiConn then
        antiConn:Disconnect()
        antiConn = nil
    end
    if on then
        antiConn = Velune.Track(RunService.Heartbeat:Connect(function()
            local hrp = Velune.HRP()
            if not hrp then
                return
            end
            local cap = Velune.Values.Cap
            local v = hrp.AssemblyLinearVelocity
            if v.Magnitude > cap then
                hrp.AssemblyLinearVelocity = v.Unit * cap
            end
            local a = hrp.AssemblyAngularVelocity
            if a.Magnitude > cap then
                hrp.AssemblyAngularVelocity = Vector3.new()
            end
        end))
        Velune.Notify("VELUNE", "Anti-Fling ON")
    else
        Velune.Notify("VELUNE", "Anti-Fling OFF")
    end
end
local afkConn
function Velune.SetAntiAFK(on)
    Velune.Flags.AntiAFK = on
    if afkConn then
        task.cancel(afkConn)
        afkConn = nil
    end
    if on then
        afkConn = task.spawn(function()
            while Velune.Flags.AntiAFK do
                task.wait(300)
                pcall(function()
                    if VirtualUser and Camera then
                        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
                        task.wait(0.1)
                        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
                    end
                end)
            end
        end)
        Velune.Notify("VELUNE", "Anti-AFK ON")
    else
        Velune.Notify("VELUNE", "Anti-AFK OFF")
    end
end
function Velune.FlattenPart(d)
    pcall(function()
        if d:IsA("Texture") or d:IsA("Decal") then
            d.Transparency = 1
        elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then
            d.Enabled = false
        elseif d:IsA("BasePart") then
            d.Material = Enum.Material.SmoothPlastic
            d.CastShadow = false
        end
    end)
end
function Velune.SetLowGFX(on)
    Velune.Flags.LowGFX = on
    if on then
        Velune.Flags.HighGFX = false
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
            if setfpscap then
                setfpscap(999)
            end
        end)
        if Lighting then
            Lighting.GlobalShadows = false
            Lighting.Brightness = 2
        end
        if Workspace then
            for _, d in ipairs(Workspace:GetDescendants()) do
                Velune.FlattenPart(d)
            end
        end
        Velune.Notify("VELUNE", "Low Graphics ON — FPS boost active")
    else
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)
        Velune.Notify("VELUNE", "Low Graphics OFF")
    end
end
function Velune.SetHighGFX(on)
    Velune.Flags.HighGFX = on
    if on then
        Velune.Flags.LowGFX = false
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
        end)
        if Lighting then
            Lighting.GlobalShadows = true
            Lighting.Brightness = 3.5
            Lighting.Ambient = Color3.fromRGB(80, 80, 100)
            Lighting.OutdoorAmbient = Color3.fromRGB(100, 110, 130)
            local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
            bloom.Intensity = 0.6
            bloom.Size = 24
            bloom.Threshold = 0.95
            local sun = Lighting:FindFirstChildOfClass("SunRaysEffect") or Instance.new("SunRaysEffect", Lighting)
            sun.Intensity = 0.25
            sun.Spread = 1
            local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
            cc.Saturation = 0.2
            cc.Contrast = 0.1
            cc.Brightness = 0.05
        end
        Velune.Notify("VELUNE", "High Graphics ON")
    else
        if Lighting then
            for _, ch in ipairs(Lighting:GetChildren()) do
                if ch:IsA("BloomEffect") or ch:IsA("SunRaysEffect") or ch:IsA("ColorCorrectionEffect") then
                    ch:Destroy()
                end
            end
        end
        Velune.Notify("VELUNE", "High Graphics OFF")
    end
end
function Velune.TeleportToPlayer(player)
    if not player or not player.Character then
        return
    end
    local t = player.Character:FindFirstChild("HumanoidRootPart")
    if t then
        Velune.PivotTo(t.CFrame * CFrame.new(0, 0, 3))
        Velune.Notify("VELUNE", "Warped to " .. player.Name)
    end
end
function Velune.TeleportToLobby()
    local lobby = Velune.LobbyRoot()
    if not lobby then
        Velune.Notify("VELUNE", "Lobby not found.")
        return
    end
    local spawns = lobby:FindFirstChild("Spawns") or lobby
    local parts = {}
    for _, ch in ipairs(spawns:GetChildren()) do
        if ch:IsA("BasePart") then
            table.insert(parts, ch)
        end
    end
    local pick = parts[math.random(1, math.max(#parts, 1))] or spawns:FindFirstChildWhichIsA("BasePart")
    if pick then
        Velune.PivotTo(pick.CFrame * CFrame.new(0, 5, 0))
        Velune.Notify("VELUNE", "Lobby locked in.")
    end
end
function Velune.TeleportToMap()
    local map = Velune.MapRoot()
    if not map then
        Velune.Notify("VELUNE", "Map not found.")
        return
    end
    local spawns = map:FindFirstChild("Spawns")
    if not spawns then
        return
    end
    local parts = {}
    for _, ch in ipairs(spawns:GetChildren()) do
        if ch:IsA("BasePart") then
            table.insert(parts, ch)
        end
    end
    local pick = parts[math.random(1, math.max(#parts, 1))]
    if pick then
        Velune.PivotTo(pick.CFrame * CFrame.new(0, 5, 0))
        Velune.Notify("VELUNE", "Dropped on a spawn.")
    end
end
function Velune.NearestCoin()
    local map = Velune.MapRoot()
    local hrp = Velune.HRP()
    if not map or not hrp then
        return nil
    end
    local best, dist = nil, Velune.Values.FarmRadius
    local function scan(node)
        for _, ch in ipairs(node:GetChildren()) do
            if ch:IsA("BasePart") and (ch.Name:lower():find("coin") or ch:FindFirstChild("TouchInterest")) then
                local d = (ch.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    best = ch
                end
            end
            if #ch:GetChildren() > 0 then
                scan(ch)
            end
        end
    end
    local bag = map:FindFirstChild("CoinContainer") or map:FindFirstChild("CoinAreas") or map
    scan(bag)
    return best
end
function Velune.FarmTick()
    if not Velune.Flags.AutoFarm then
        Velune.FarmStats.running = false
        return
    end
    if not Velune.FarmStats.running then
        Velune.FarmStats.running = true
        Velune.FarmStats.t0 = tick()
        Velune.FarmStats.coins = 0
    end
    local coin = Velune.NearestCoin()
    local hrp = Velune.HRP()
    if coin and hrp then
        local dest = coin.CFrame * CFrame.new(0, Velune.Values.FarmOffset, 0)
        Velune.PivotTo(dest)
        if firetouchinterest then
            pcall(function()
                firetouchinterest(hrp, coin, 0)
                firetouchinterest(hrp, coin, 1)
            end)
        end
        Velune.FarmStats.coins += 1
        task.wait(Velune.Values.FarmDelay)
    end
end
function Velune.Rejoin()
    if TeleportService and LP then
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end)
    end
end
function Velune.ServerHop()
    if not TeleportService or not HttpService or not LP then
        return
    end
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, raw = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if ok and raw and raw.data then
        for _, s in ipairs(raw.data) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId, LP)
end


function Velune.IsMobile()
    local touch = false
    local kbd = true
    pcall(function()
        touch = UserInputService.TouchEnabled
        kbd = UserInputService.KeyboardEnabled
    end)
    local cam = Velune.Cam()
    local vp = cam and cam.ViewportSize
    if touch and not kbd then
        return true
    end
    if vp and vp.X < 760 then
        return true
    end
    return false
end
function Velune.PaintTone(node, col)
    if not node then
        return
    end
    node.color = col
    if node.lbl then
        node.lbl.TextColor3 = col
    end
    if node.stroke then
        node.stroke.Color = col
    end
    if node.bar then
        node.bar.BackgroundColor3 = col
    end
    if node.gemStroke then
        node.gemStroke.Color = col
    end
    if node.art and not node.photo and node.art:IsA("Frame") then
        node.art.BackgroundColor3 = col
    end
end
function Velune.EnsureFloorLayer()
    local host = Velune.HostGui()
    local layer = host:FindFirstChild("VeluneFloor")
    if layer then
        return layer
    end
    layer = Instance.new("Frame")
    layer.Name = "VeluneFloor"
    layer.BackgroundTransparency = 1
    layer.Size = UDim2.new(1, 0, 1, 0)
    layer.ZIndex = 60
    layer.Parent = host
    return layer
end
function Velune.EnsureMobileDock()
    local host = Velune.HostGui()
    local dock = host:FindFirstChild("VeluneMobileDock")
    if dock then
        return dock
    end
    dock = Instance.new("ScrollingFrame")
    dock.Name = "VeluneMobileDock"
    dock.Size = UDim2.new(1, -16, 0, 92)
    dock.Position = UDim2.new(0, 8, 1, -104)
    dock.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dock.BackgroundTransparency = 0.48
    dock.BorderSizePixel = 0
    dock.ScrollBarThickness = 3
    dock.CanvasSize = UDim2.new(0, 0, 0, 0)
    dock.AutomaticCanvasSize = Enum.AutomaticSize.X
    dock.ScrollingDirection = Enum.ScrollingDirection.X
    dock.ZIndex = 65
    dock.Parent = host
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 14)
    c.Parent = dock
    local st = Instance.new("UIStroke")
    st.Color = Color3.fromRGB(225, 29, 72)
    st.Thickness = 1
    st.Transparency = 0.55
    st.Parent = dock
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = dock
    local list = Instance.new("UIListLayout")
    list.FillDirection = Enum.FillDirection.Horizontal
    list.Padding = UDim.new(0, 8)
    list.VerticalAlignment = Enum.VerticalAlignment.Center
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = dock
    return dock
end
function Velune.FloorPos(key)
    local main = UDim2.new(0, 72, 0, 98)
    local mini = UDim2.new(0, 60, 0, 86)
    local y = 0.8
    local map = {
        GoldBomb = { UDim2.new(0.5, -188, y, -8), main },
        NormalBomb = { UDim2.new(0.5, -108, y, -8), main },
        Shoot = { UDim2.new(0.5, -28, y, -16), main },
        Flick = { UDim2.new(0.5, 52, y, 0), mini },
        ESP = { UDim2.new(0.5, 118, y, 0), mini },
        GrabGun = { UDim2.new(0.5, 184, y, 0), mini },
        WallHop = { UDim2.new(0.5, 250, y, 0), mini },
        Speed = { UDim2.new(0.5, -320, y, 0), mini },
        Stretch = { UDim2.new(0.5, -254, y, 0), mini },
        FlingMurderer = { UDim2.new(0.5, -188, 0.68, 0), mini },
        FlingSheriff = { UDim2.new(0.5, -122, 0.68, 0), mini },
        Fly = { UDim2.new(0.5, 52, 0.68, 0), mini },
        Noclip = { UDim2.new(0.5, 118, 0.68, 0), mini },
        SilentThrow = { UDim2.new(0.5, 184, 0.68, 0), mini },
        KillAll = { UDim2.new(0.5, 250, 0.68, 0), mini },
        Farm = { UDim2.new(0.5, 316, 0.68, 0), mini },
    }
    local row = map[key]
    if row then
        return row[1], row[2]
    end
    return UDim2.new(0.5, 0, 0.78, 0), mini
end
function Velune.AttachSpin(node, asset)
    if not node or not node.gem then
        return
    end
    local img = Instance.new("ImageLabel")
    img.Name = "SpinImg"
    img.BackgroundTransparency = 1
    img.Size = UDim2.new(0.7, 0, 0.7, 0)
    img.Position = UDim2.new(0.15, 0, 0.15, 0)
    img.Image = "rbxassetid://" .. tostring(asset)
    img.ImageColor3 = Color3.new(1, 1, 1)
    img.ZIndex = node.gem.ZIndex + 2
    img.Parent = node.gem
    node.img = img
    task.spawn(function()
        while img and img.Parent do
            img.Rotation = img.Rotation + 4
            RunService.RenderStepped:Wait()
        end
    end)
    return img
end
function Velune.MakeFloorButton(key, label, color, callback, kind, icon)
    local host = Velune.HostGui()
    if Velune.Floor[key] and Velune.Floor[key].btn then
        Velune.Floor[key].btn:Destroy()
        Velune.Floor[key] = nil
    end
    local mobile = Velune.IsMobile()
    local pos, size = Velune.FloorPos(key)
    if kind == "main" then
        size = mobile and UDim2.new(0, 74, 0, 74) or UDim2.new(0, 88, 0, 88)
    else
        size = mobile and UDim2.new(0, 58, 0, 58) or size
    end
    local parent
    if mobile then
        parent = Velune.EnsureMobileDock()
    else
        parent = Velune.EnsureFloorLayer()
    end
    local px = size.Y.Offset
    local wide = size.X.Offset
    local order = {
        GoldBomb = 1,
        NormalBomb = 2,
        Shoot = 3,
        ESP = 4,
        Flick = 5,
        WallHop = 6,
        GrabGun = 7,
        Speed = 8,
        Stretch = 9,
        FlingMurderer = 10,
        FlingSheriff = 11,
        Fly = 12,
        Noclip = 13,
        SilentThrow = 14,
        KillAll = 15,
        Farm = 16,
    }
    local btn = Instance.new("TextButton")
    btn.Name = "VeluneFloor_" .. key
    btn.Size = UDim2.new(0, math.floor(wide * 0.86), 0, math.floor(px * 0.86))
    if mobile then
        btn.Position = UDim2.new(0, 0, 0, 0)
        btn.LayoutOrder = order[key] or 20
    else
        btn.Position = pos
        btn.AnchorPoint = Vector2.new(0.5, 0)
    end
    btn.BackgroundColor3 = Color3.fromRGB(14, 10, 12)
    btn.BackgroundTransparency = 0.08
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 70
    btn.ClipsDescendants = true
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = btn
    local wash = Instance.new("UIGradient")
    wash.Rotation = 90
    wash.Color = ColorSequence.new(Color3.fromRGB(48, 28, 34), Color3.fromRGB(10, 8, 10))
    wash.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Name = "Stroke"
    stroke.Color = color
    stroke.Thickness = 1.4
    stroke.Transparency = 0.28
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn
    local gem = Instance.new("Frame")
    gem.Name = "Gem"
    gem.Size = UDim2.new(0, 34, 0, 34)
    gem.Position = UDim2.new(0.5, -17, 0, 10)
    gem.BackgroundColor3 = Color3.fromRGB(20, 14, 16)
    gem.BorderSizePixel = 0
    gem.ZIndex = 73
    gem.Parent = btn
    local gemCorner = Instance.new("UICorner")
    gemCorner.CornerRadius = UDim.new(0, 12)
    gemCorner.Parent = gem
    local gemStroke = Instance.new("UIStroke")
    gemStroke.Color = color
    gemStroke.Thickness = 1.2
    gemStroke.Transparency = 0.15
    gemStroke.Parent = gem
    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.Size = UDim2.new(1, -18, 0, 3)
    bar.Position = UDim2.new(0, 9, 1, -10)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.ZIndex = 73
    bar.Parent = btn
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar
    local lab = Instance.new("TextLabel")
    lab.Name = "Lbl"
    lab.BackgroundTransparency = 1
    lab.Size = UDim2.new(1, -8, 0, 28)
    lab.Position = UDim2.new(0, 4, 0, 48)
    lab.Font = Enum.Font.GothamBold
    lab.Text = (label or ""):gsub("
", " ")
    lab.TextColor3 = color
    lab.TextSize = 11
    lab.TextWrapped = true
    lab.TextXAlignment = Enum.TextXAlignment.Center
    lab.TextYAlignment = Enum.TextYAlignment.Center
    lab.ZIndex = 74
    lab.Text = ""
    lab.Visible = false
    lab.Parent = btn
    local art
    local photo = key == "GoldBomb"
    if photo then
        art = Instance.new("ImageLabel")
        art.Name = "Art"
        art.BackgroundTransparency = 1
        art.Size = UDim2.new(0.78, 0, 0.62, 0)
        art.Position = UDim2.new(0.11, 0, 0.1, 0)
        art.Image = "rbxassetid://90967307316831"
        art.ScaleType = Enum.ScaleType.Fit
        art.ZIndex = 75
        art.Parent = btn
    else
        art = Instance.new("Frame")
        art.Name = "Mark"
        art.BackgroundColor3 = color
        art.BorderSizePixel = 0
        art.Size = UDim2.new(0, 16, 0, 16)
        art.Position = UDim2.new(0.5, -8, 0.32, 0)
        art.ZIndex = 75
        art.Parent = btn
        local mc = Instance.new("UICorner")
        mc.CornerRadius = UDim.new(0, key == "Flick" and 8 or 3)
        mc.Parent = art
        if key == "Speed" or key == "WallHop" then
            art.Rotation = 45
        end
    end
    Velune.Spring(btn, { Size = size, BackgroundTransparency = 0.08 }, 0.22)
    local node = { btn = btn, stroke = stroke, lbl = lab, art = art, photo = photo, gem = gem, gemStroke = gemStroke, bar = bar, kind = kind, color = color }
    Velune.Floor[key] = node
    if icon and icon ~= "" then
        Velune.AttachSpin(node, icon)
    end
    local dragging = false
    local pressed = false
    local start, origin
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            pressed = true
            dragging = false
            start = input.Position
            origin = btn.Position
            Velune.Spring(btn, { Size = UDim2.new(0, wide * 0.94, 0, px * 0.94) }, 0.08)
            Velune.Spring(stroke, { Thickness = 2, Transparency = 0.18 }, 0.08)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not pressed then
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - start
            if d.Magnitude > 7 and not Velune.Flags.ButtonsLocked and not mobile then
                dragging = true
                btn.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if pressed and not dragging then
                Velune.ClickTone()
                callback()
            end
            pressed = false
            dragging = false
            Velune.Spring(btn, { Size = size }, 0.14)
            Velune.Spring(stroke, { Thickness = 1.4, Transparency = 0.28 }, 0.16)
        end
    end)
    return node
end
function Velune.DestroyFloor(key)
    if Velune.Floor[key] and Velune.Floor[key].btn then
        Velune.Floor[key].btn:Destroy()
    end
    Velune.Floor[key] = nil
end
function Velune.LoadGoldBomb(on)
    if on then
        Velune.Shown.GoldBomb = true
        Velune.MakeFloorButton("GoldBomb", "GOLD
JUMP", Color3.fromRGB(255, 215, 0), Velune.GoldJump, "main")
    else
        Velune.Shown.GoldBomb = false
        Velune.DestroyFloor("GoldBomb")
    end
end
function Velune.LoadNormalBomb(on)
    if on then
        Velune.Shown.NormalBomb = true
        Velune.MakeFloorButton("NormalBomb", "NORMAL
JUMP", Color3.fromRGB(0, 170, 255), Velune.NormalJump, "main")
    else
        Velune.Shown.NormalBomb = false
        Velune.DestroyFloor("NormalBomb")
    end
end
function Velune.LoadShoot(on)
    if on then
        Velune.Shown.Shoot = true
        Velune.MakeFloorButton("Shoot", "SHOOT", Color3.fromRGB(255, 255, 255), Velune.ShootOrThrow, "main")
    else
        Velune.Shown.Shoot = false
        Velune.DestroyFloor("Shoot")
    end
end
function Velune.LoadESP(on)
    if on then
        Velune.Shown.ESP = true
        Velune.MakeFloorButton("ESP", "ESP
OFF", Color3.fromRGB(10, 140, 30), function()
            Velune.Flags.ESP = not Velune.Flags.ESP
            if not Velune.Flags.ESP then
                Velune.ClearESP()
            end
            Velune.Notify("VELUNE", Velune.Flags.ESP and "ESP ON" or "ESP OFF")
        end, "mini")
    else
        Velune.Shown.ESP = false
        Velune.DestroyFloor("ESP")
    end
end
function Velune.LoadFlick(on)
    if on then
        Velune.Shown.Flick = true
        Velune.MakeFloorButton("Flick", "FLICK", Color3.fromRGB(180, 50, 255), Velune.Flick, "mini")
    else
        Velune.Shown.Flick = false
        Velune.DestroyFloor("Flick")
    end
end
function Velune.LoadWallHop(on)
    if on then
        Velune.Shown.WallHop = true
        Velune.MakeFloorButton("WallHop", "WALL
HOP", Color3.fromRGB(0, 210, 210), Velune.WallHop, "mini")
    else
        Velune.Shown.WallHop = false
        Velune.DestroyFloor("WallHop")
    end
end
function Velune.LoadGrabGun(on)
    if on then
        Velune.Shown.GrabGun = true
        Velune.MakeFloorButton("GrabGun", "GRAB
GUN", Color3.fromRGB(200, 120, 0), Velune.GrabGun, "mini")
    else
        Velune.Shown.GrabGun = false
        Velune.DestroyFloor("GrabGun")
    end
end
function Velune.LoadSpeed(on)
    if on then
        Velune.Shown.Speed = true
        Velune.MakeFloorButton("Speed", "SPEED", Color3.fromRGB(0, 140, 120), function()
            Velune.SetSpeed(not Velune.Flags.SpeedOn)
        end, "mini")
    else
        Velune.Shown.Speed = false
        Velune.DestroyFloor("Speed")
    end
end
function Velune.LoadStretch(on)
    if on then
        Velune.Shown.Stretch = true
        Velune.MakeFloorButton("Stretch", "STRETCH", Color3.fromRGB(200, 80, 0), function()
            Velune.SetStretch(not Velune.Flags.StretchOn)
        end, "mini")
    else
        Velune.Shown.Stretch = false
        Velune.DestroyFloor("Stretch")
    end
end
function Velune.LoadFlingMurderer(on)
    if on then
        Velune.Shown.FlingMurderer = true
        Velune.MakeFloorButton("FlingMurderer", "FLING
MURD", Color3.fromRGB(255, 50, 50), Velune.FlingMurderer, "mini")
    else
        Velune.Shown.FlingMurderer = false
        Velune.DestroyFloor("FlingMurderer")
    end
end
function Velune.LoadFlingSheriff(on)
    if on then
        Velune.Shown.FlingSheriff = true
        Velune.MakeFloorButton("FlingSheriff", "FLING
SHERIF", Color3.fromRGB(40, 130, 255), Velune.FlingSheriff, "mini")
    else
        Velune.Shown.FlingSheriff = false
        Velune.DestroyFloor("FlingSheriff")
    end
end
function Velune.LoadFly(on)
    if on then
        Velune.Shown.Fly = true
        Velune.MakeFloorButton("Fly", "FLY", Color3.fromRGB(180, 80, 220), function()
            Velune.SetFly(not Velune.Flags.Fly)
        end, "mini")
    else
        Velune.Shown.Fly = false
        Velune.DestroyFloor("Fly")
    end
end
function Velune.LoadNoclip(on)
    if on then
        Velune.Shown.Noclip = true
        Velune.MakeFloorButton("Noclip", "NOCLIP", Color3.fromRGB(90, 90, 110), function()
            Velune.SetNoclip(not Velune.Flags.Noclip)
        end, "mini")
    else
        Velune.Shown.Noclip = false
        Velune.DestroyFloor("Noclip")
    end
end
function Velune.LoadSilentThrow(on)
    if on then
        Velune.Shown.SilentThrow = true
        Velune.MakeFloorButton("SilentThrow", "SILENT
THROW", Color3.fromRGB(255, 140, 40), Velune.SilentThrow, "mini")
    else
        Velune.Shown.SilentThrow = false
        Velune.DestroyFloor("SilentThrow")
    end
end
function Velune.LoadKillAll(on)
    if on then
        Velune.Shown.KillAll = true
        Velune.MakeFloorButton("KillAll", "KILL
ALL", Color3.fromRGB(180, 20, 40), Velune.KillAll, "mini")
    else
        Velune.Shown.KillAll = false
        Velune.DestroyFloor("KillAll")
    end
end
function Velune.LoadFarm(on)
    if on then
        Velune.Shown.Farm = true
        Velune.MakeFloorButton("Farm", "FARM", Color3.fromRGB(80, 200, 90), function()
            Velune.Flags.AutoFarm = not Velune.Flags.AutoFarm
            Velune.Notify("VELUNE", Velune.Flags.AutoFarm and "Farm ON" or "Farm OFF")
        end, "mini")
    else
        Velune.Shown.Farm = false
        Velune.DestroyFloor("Farm")
    end
end
function Velune.TickFloor()
    local f = Velune.Floor
    local lock = false
    pcall(function()
        lock = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
    end)
    if f.GoldBomb then
        local wait = (Velune.Cool.gold or 0) > tick()
        f.GoldBomb.lbl.Text = ""
        Velune.PaintTone(f.GoldBomb, wait and Color3.fromRGB(255, 120, 0) or Color3.fromRGB(255, 215, 0))
    end
    if f.NormalBomb then
        local wait = (Velune.Cool.normal or 0) > tick()
        f.NormalBomb.lbl.Text = ""
        Velune.PaintTone(f.NormalBomb, wait and Color3.fromRGB(255, 120, 0) or Color3.fromRGB(0, 170, 255))
    end
    if f.Shoot then
        local knife = Velune.HasTool("Knife")
        f.Shoot.lbl.Text = ""
    end
    if f.ESP then
        local on = Velune.Flags.ESP
        f.ESP.lbl.Text = ""
        Velune.PaintTone(f.ESP, on and Color3.fromRGB(50, 220, 80) or Color3.fromRGB(10, 140, 30))
    end
    if f.Flick then
        local col = Velune.FlickBusy and Color3.fromRGB(255, 120, 0) or (lock and Color3.fromRGB(120, 200, 255) or Color3.fromRGB(180, 50, 255))
        f.Flick.lbl.Text = ""
        Velune.PaintTone(f.Flick, col)
    end
    if f.WallHop then
        local wait = (Velune.Cool.wallhop or 0) > tick()
        local col = wait and Color3.fromRGB(255, 120, 0) or (lock and Color3.fromRGB(0, 255, 220) or Color3.fromRGB(0, 210, 210))
        f.WallHop.lbl.Text = ""
        Velune.PaintTone(f.WallHop, col)
    end
    if f.Speed then
        f.Speed.lbl.Text = ""
        Velune.PaintTone(f.Speed, Velune.Flags.SpeedOn and Color3.fromRGB(0, 220, 200) or Color3.fromRGB(0, 140, 120))
    end
    if f.Stretch then
        f.Stretch.lbl.Text = ""
        Velune.PaintTone(f.Stretch, Velune.Flags.StretchOn and Color3.fromRGB(255, 140, 30) or Color3.fromRGB(200, 80, 0))
    end
    if f.Fly then
        f.Fly.lbl.Text = ""
        Velune.PaintTone(f.Fly, Velune.Flags.Fly and Color3.fromRGB(210, 120, 255) or Color3.fromRGB(180, 80, 220))
    end
    if f.Noclip then
        f.Noclip.lbl.Text = ""
        Velune.PaintTone(f.Noclip, Velune.Flags.Noclip and Color3.fromRGB(160, 160, 180) or Color3.fromRGB(90, 90, 110))
    end
    if f.GrabGun then
        local drop = Velune.GunDrop()
        local col = drop and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(200, 100, 0)
        f.GrabGun.lbl.Text = ""
        Velune.PaintTone(f.GrabGun, col)
    end
    if f.FlingMurderer then
        local m = Velune.FindMurderer()
        local col = Velune.FlingBusy and Color3.fromRGB(255, 180, 0) or (m and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(200, 20, 20))
        f.FlingMurderer.lbl.Text = ""
        Velune.PaintTone(f.FlingMurderer, col)
    end
    if f.FlingSheriff then
        local s = Velune.FindSheriff()
        local col = Velune.FlingBusy and Color3.fromRGB(255, 180, 0) or (s and Color3.fromRGB(40, 130, 255) or Color3.fromRGB(10, 80, 200))
        f.FlingSheriff.lbl.Text = ""
        Velune.PaintTone(f.FlingSheriff, col)
    end
    if f.Farm then
        f.Farm.lbl.Text = ""
        Velune.PaintTone(f.Farm, Velune.Flags.AutoFarm and Color3.fromRGB(120, 240, 130) or Color3.fromRGB(80, 200, 90))
    end
    if f.SilentThrow then
        f.SilentThrow.lbl.Text = ""
    end
end

function Velune.OpenSkyPicker()
    local host = Velune.HostGui()
    local old = host:FindFirstChild("VeluneSkyPicker")
    if old then
        old:Destroy()
        return
    end
    local wrap = Instance.new("Frame")
    wrap.Name = "VeluneSkyPicker"
    wrap.Size = UDim2.new(0, 310, 0, 420)
    wrap.Position = UDim2.new(0.5, -155, 0.08, 0)
    wrap.BackgroundColor3 = Velune.Ink
    wrap.BackgroundTransparency = 0.04
    wrap.BorderSizePixel = 0
    wrap.ZIndex = 90
    wrap.Parent = host
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 12)
    c.Parent = wrap
    local st = Instance.new("UIStroke")
    st.Color = Velune.Accent
    st.Thickness = 1.5
    st.Parent = wrap
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -44, 0, 38)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Velune.Paper
    title.Text = "VELUNE  —  Skybox Picker"
    title.ZIndex = 91
    title.Parent = wrap
    local x = Instance.new("TextButton")
    x.Size = UDim2.new(0, 28, 0, 28)
    x.Position = UDim2.new(1, -34, 0, 5)
    x.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    x.Text = "X"
    x.TextColor3 = Color3.new(1, 1, 1)
    x.Font = Enum.Font.GothamBold
    x.TextSize = 13
    x.ZIndex = 92
    x.Parent = wrap
    Instance.new("UICorner", x).CornerRadius = UDim.new(0, 6)
    x.MouseButton1Click:Connect(function()
        wrap:Destroy()
    end)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 34)
    box.Position = UDim2.new(0, 10, 0, 44)
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    box.PlaceholderText = "Enter custom Skybox ID, press Enter..."
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.ClearTextOnFocus = false
    box.ZIndex = 91
    box.Parent = wrap
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    box.FocusLost:Connect(function(enter)
        if enter and box.Text ~= "" then
            Velune.ApplySkyId(box.Text)
            box.Text = ""
        end
    end)
    local restore = Instance.new("TextButton")
    restore.Size = UDim2.new(1, -20, 0, 28)
    restore.Position = UDim2.new(0, 10, 0, 84)
    restore.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    restore.Text = "Restore Default Sky"
    restore.TextColor3 = Color3.fromRGB(200, 200, 200)
    restore.Font = Enum.Font.GothamBold
    restore.TextSize = 12
    restore.ZIndex = 91
    restore.Parent = wrap
    Instance.new("UICorner", restore).CornerRadius = UDim.new(0, 6)
    restore.MouseButton1Click:Connect(function()
        Velune.RestoreSky()
        wrap:Destroy()
    end)
    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -14, 1, -126)
    list.Position = UDim2.new(0, 7, 0, 124)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.CanvasSize = UDim2.new(0, 0, 0, #Velune.SkyList * 56)
    list.ZIndex = 91
    list.Parent = wrap
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 6)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Parent = list
    for i, row in ipairs(Velune.SkyList) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -8, 0, 48)
        b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        b.Text = ""
        b.AutoButtonColor = false
        b.LayoutOrder = i
        b.ZIndex = 92
        b.Parent = list
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local sw = Instance.new("Frame")
        sw.Size = UDim2.new(0, 34, 0, 34)
        sw.Position = UDim2.new(0, 8, 0.5, -17)
        sw.BackgroundColor3 = row.color
        sw.BorderSizePixel = 0
        sw.ZIndex = 93
        sw.Parent = b
        Instance.new("UICorner", sw).CornerRadius = UDim.new(0, 6)
        local nm = Instance.new("TextLabel")
        nm.BackgroundTransparency = 1
        nm.Size = UDim2.new(1, -58, 0, 22)
        nm.Position = UDim2.new(0, 50, 0, 6)
        nm.Font = Enum.Font.GothamBold
        nm.TextSize = 14
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.TextColor3 = Color3.fromRGB(210, 210, 210)
        nm.Text = row.name
        nm.ZIndex = 93
        nm.Parent = b
        local idl = Instance.new("TextLabel")
        idl.BackgroundTransparency = 1
        idl.Size = UDim2.new(1, -58, 0, 14)
        idl.Position = UDim2.new(0, 50, 1, -18)
        idl.Font = Enum.Font.Gotham
        idl.TextSize = 10
        idl.TextXAlignment = Enum.TextXAlignment.Left
        idl.TextColor3 = Color3.fromRGB(100, 100, 100)
        idl.Text = "ID: " .. row.id
        idl.ZIndex = 93
        idl.Parent = b
        b.MouseButton1Click:Connect(function()
            row.apply()
        end)
    end
    Velune.MakeDrag(wrap)
end
function Velune.OpenCursorPicker()
    local host = Velune.HostGui()
    local old = host:FindFirstChild("VeluneCursorPicker")
    if old then
        old:Destroy()
        return
    end
    local wrap = Instance.new("Frame")
    wrap.Name = "VeluneCursorPicker"
    wrap.Size = UDim2.new(0, 300, 0, 460)
    wrap.Position = UDim2.new(0.5, -150, 0.06, 0)
    wrap.BackgroundColor3 = Velune.Ink
    wrap.BackgroundTransparency = 0.04
    wrap.BorderSizePixel = 0
    wrap.ZIndex = 90
    wrap.Parent = host
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 12)
    local st = Instance.new("UIStroke")
    st.Color = Velune.Accent
    st.Thickness = 1.5
    st.Parent = wrap
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -44, 0, 38)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Velune.Paper
    title.Text = "VELUNE  —  Cursor Picker"
    title.ZIndex = 91
    title.Parent = wrap
    local x = Instance.new("TextButton")
    x.Size = UDim2.new(0, 28, 0, 28)
    x.Position = UDim2.new(1, -34, 0, 5)
    x.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    x.Text = "X"
    x.TextColor3 = Color3.new(1, 1, 1)
    x.Font = Enum.Font.GothamBold
    x.TextSize = 13
    x.ZIndex = 92
    x.Parent = wrap
    Instance.new("UICorner", x).CornerRadius = UDim.new(0, 6)
    x.MouseButton1Click:Connect(function()
        wrap:Destroy()
    end)
    local spin = Instance.new("TextButton")
    spin.Size = UDim2.new(0, 54, 0, 26)
    spin.Position = UDim2.new(1, -64, 0, 48)
    spin.BackgroundColor3 = Velune.Flags.CursorSpin and Color3.fromRGB(30, 160, 30) or Color3.fromRGB(80, 20, 20)
    spin.Text = Velune.Flags.CursorSpin and "ON" or "OFF"
    spin.TextColor3 = Color3.new(1, 1, 1)
    spin.Font = Enum.Font.GothamBold
    spin.TextSize = 12
    spin.ZIndex = 92
    spin.Parent = wrap
    Instance.new("UICorner", spin).CornerRadius = UDim.new(0, 8)
    spin.MouseButton1Click:Connect(function()
        Velune.Flags.CursorSpin = not Velune.Flags.CursorSpin
        spin.BackgroundColor3 = Velune.Flags.CursorSpin and Color3.fromRGB(30, 160, 30) or Color3.fromRGB(80, 20, 20)
        spin.Text = Velune.Flags.CursorSpin and "ON" or "OFF"
        Velune.Notify("VELUNE", "Crosshair Spin: " .. (Velune.Flags.CursorSpin and "ON" or "OFF"))
    end)
    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, -14, 1, -88)
    list.Position = UDim2.new(0, 7, 0, 82)
    list.BackgroundTransparency = 1
    list.ScrollBarThickness = 4
    list.CanvasSize = UDim2.new(0, 0, 0, math.ceil(#Velune.CursorList / 2) * 118)
    list.ZIndex = 91
    list.Parent = wrap
    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0, 128, 0, 110)
    grid.CellPadding = UDim2.new(0, 8, 0, 8)
    grid.Parent = list
    for i, row in ipairs(Velune.CursorList) do
        local b = Instance.new("TextButton")
        b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        b.Text = ""
        b.AutoButtonColor = false
        b.LayoutOrder = i
        b.ZIndex = 92
        b.Parent = list
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 58, 0, 58)
        img.AnchorPoint = Vector2.new(0.5, 0)
        img.Position = UDim2.new(0.5, 0, 0, 8)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://" .. row.id
        img.ZIndex = 93
        img.Parent = b
        local nm = Instance.new("TextLabel")
        nm.BackgroundTransparency = 1
        nm.Size = UDim2.new(1, -6, 0, 28)
        nm.Position = UDim2.new(0, 3, 1, -30)
        nm.Font = Enum.Font.GothamBold
        nm.TextSize = 11
        nm.TextWrapped = true
        nm.Text = row.name
        nm.TextColor3 = Color3.fromRGB(200, 200, 200)
        nm.ZIndex = 93
        nm.Parent = b
        b.MouseButton1Click:Connect(function()
            row.apply()
            wrap:Destroy()
        end)
    end
    Velune.MakeDrag(wrap)
end
function Velune.OpenSlider(title, min, max, current, step, apply, reset)
    local host = Velune.HostGui()
    local name = "VeluneSlider_" .. title:gsub("%s+", "_")
    local old = host:FindFirstChild(name)
    if old then
        old:Destroy()
        return
    end
    local wrap = Instance.new("Frame")
    wrap.Name = name
    wrap.Size = UDim2.new(0, 300, 0, 175)
    wrap.Position = UDim2.new(0.5, -150, 0.32, 0)
    wrap.BackgroundColor3 = Velune.Ink
    wrap.BackgroundTransparency = 0.08
    wrap.BorderSizePixel = 0
    wrap.ZIndex = 95
    wrap.Parent = host
    Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke")
    st.Color = Velune.Accent
    st.Thickness = 1.5
    st.Parent = wrap
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Size = UDim2.new(1, -44, 0, 36)
    t.Position = UDim2.new(0, 12, 0, 0)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Text = "VELUNE  —  " .. title
    t.ZIndex = 96
    t.Parent = wrap
    local x = Instance.new("TextButton")
    x.Size = UDim2.new(0, 28, 0, 28)
    x.Position = UDim2.new(1, -34, 0, 4)
    x.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    x.Text = "X"
    x.Font = Enum.Font.GothamBold
    x.TextSize = 13
    x.TextColor3 = Color3.new(1, 1, 1)
    x.ZIndex = 96
    x.Parent = wrap
    Instance.new("UICorner", x).CornerRadius = UDim.new(0, 6)
    x.MouseButton1Click:Connect(function()
        wrap:Destroy()
    end)
    local value = current
    local valLab = Instance.new("TextLabel")
    valLab.BackgroundTransparency = 1
    valLab.Size = UDim2.new(1, 0, 0, 22)
    valLab.Position = UDim2.new(0, 0, 0, 38)
    valLab.Font = Enum.Font.Gotham
    valLab.TextSize = 13
    valLab.TextColor3 = Color3.fromRGB(210, 210, 210)
    valLab.Text = title .. ":  " .. tostring(value)
    valLab.ZIndex = 96
    valLab.Parent = wrap
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -30, 0, 10)
    track.Position = UDim2.new(0, 15, 0, 72)
    track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    track.BorderSizePixel = 0
    track.ZIndex = 96
    track.Parent = wrap
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Velune.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 97
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 26, 0, 26)
    knob.Position = UDim2.new((value - min) / (max - min), -13, 0.5, -13)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Text = ""
    knob.AutoButtonColor = false
    knob.ZIndex = 98
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local function setFromX(x)
        local a = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local n = min + a * (max - min)
        n = math.round(n)
        if step and step > 0 then
            n = math.round(n / step) * step
        end
        value = n
        local u = (value - min) / (max - min)
        fill.Size = UDim2.new(u, 0, 1, 0)
        knob.Position = UDim2.new(u, -13, 0.5, -13)
        valLab.Text = title .. ":  " .. tostring(value)
    end
    local hold = false
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            hold = true
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if hold and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            hold = false
        end
    end)
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0.48, 0, 0, 36)
    applyBtn.Position = UDim2.new(0, 10, 1, -46)
    applyBtn.BackgroundColor3 = Color3.fromRGB(20, 160, 20)
    applyBtn.Text = "Apply"
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 13
    applyBtn.TextColor3 = Color3.new(1, 1, 1)
    applyBtn.ZIndex = 96
    applyBtn.Parent = wrap
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6)
    applyBtn.MouseButton1Click:Connect(function()
        apply(value)
        Velune.Notify("VELUNE", title .. " set to " .. value)
    end)
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0.48, 0, 0, 36)
    resetBtn.Position = UDim2.new(0.52, 0, 1, -46)
    resetBtn.BackgroundColor3 = Color3.fromRGB(160, 20, 20)
    resetBtn.Text = "Reset"
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.TextSize = 13
    resetBtn.TextColor3 = Color3.new(1, 1, 1)
    resetBtn.ZIndex = 96
    resetBtn.Parent = wrap
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
    resetBtn.MouseButton1Click:Connect(function()
        reset()
        wrap:Destroy()
    end)
    Velune.MakeDrag(wrap)
end


function Velune.UICorner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = obj
    return c
end
function Velune.UIStroke(obj, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or Velune.Accent
    s.Thickness = thick or 1.2
    s.Transparency = trans or 0.25
    s.Parent = obj
    return s
end
function Velune.UIPad(obj, l, t, r, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l or 10)
    p.PaddingTop = UDim.new(0, t or 8)
    p.PaddingRight = UDim.new(0, r or 10)
    p.PaddingBottom = UDim.new(0, b or 8)
    p.Parent = obj
    return p
end
function Velune.MakeLabel(parent, text, size, bold, col, h)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, 0, 0, h or 18)
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextSize = size or 13
    l.TextColor3 = col or Velune.Paper
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = text
    l.ZIndex = (parent.ZIndex or 80) + 1
    l.Parent = parent
    return l
end
function Velune.OpenNativeColor(title, current, apply)
    local host = Velune.HostGui()
    local old = host:FindFirstChild("VeluneColor")
    if old then
        old:Destroy()
    end
    local wrap = Instance.new("Frame")
    wrap.Name = "VeluneColor"
    wrap.Size = UDim2.new(0, 280, 0, 220)
    wrap.Position = UDim2.new(0.5, -140, 0.5, -110)
    wrap.BackgroundColor3 = Velune.Ink
    wrap.BorderSizePixel = 0
    wrap.ZIndex = 140
    wrap.Parent = host
    Velune.UICorner(wrap, 12)
    Velune.UIStroke(wrap, Velune.Accent, 1.4, 0.2)
    local t = Velune.MakeLabel(wrap, title or "Color", 15, true, Velune.Accent, 28)
    t.Position = UDim2.new(0, 14, 0, 8)
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(1, -28, 0, 28)
    preview.Position = UDim2.new(0, 14, 0, 38)
    preview.BackgroundColor3 = current
    preview.BorderSizePixel = 0
    preview.ZIndex = 141
    preview.Parent = wrap
    Velune.UICorner(preview, 6)
    local r, g, b = math.floor(current.R * 255 + 0.5), math.floor(current.G * 255 + 0.5), math.floor(current.B * 255 + 0.5)
    local function channel(name, y, start, setter)
        local lab = Velune.MakeLabel(wrap, name, 12, true, Velune.Paper, 16)
        lab.Position = UDim2.new(0, 14, 0, y)
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -28, 0, 10)
        bar.Position = UDim2.new(0, 14, 0, y + 18)
        bar.BackgroundColor3 = Color3.fromRGB(40, 32, 34)
        bar.BorderSizePixel = 0
        bar.ZIndex = 141
        bar.Parent = wrap
        Velune.UICorner(bar, 5)
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(start / 255, 0, 1, 0)
        fill.BackgroundColor3 = Velune.Accent
        fill.BorderSizePixel = 0
        fill.ZIndex = 142
        fill.Parent = bar
        Velune.UICorner(fill, 5)
        local hold = false
        local function setFrom(x)
            local a = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(a, 0, 1, 0)
            setter(math.floor(a * 255 + 0.5))
            preview.BackgroundColor3 = Color3.fromRGB(r, g, b)
        end
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hold = true
                setFrom(input.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if hold then
                setFrom(input.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hold = false
            end
        end)
    end
    channel("R", 76, r, function(v) r = v end)
    channel("G", 114, g, function(v) g = v end)
    channel("B", 152, b, function(v) b = v end)
    local go = Instance.new("TextButton")
    go.Size = UDim2.new(1, -28, 0, 32)
    go.Position = UDim2.new(0, 14, 1, -42)
    go.BackgroundColor3 = Velune.Accent
    go.Text = "Apply"
    go.Font = Enum.Font.GothamBold
    go.TextSize = 13
    go.TextColor3 = Color3.new(1, 1, 1)
    go.ZIndex = 142
    go.Parent = wrap
    Velune.UICorner(go, 7)
    go.MouseButton1Click:Connect(function()
        apply(Color3.fromRGB(r, g, b))
        wrap:Destroy()
    end)
    Velune.MakeDrag(wrap)
end
function Velune.NativeRow(parent, height)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = Color3.fromRGB(22, 18, 20)
    row.BackgroundTransparency = 0.12
    row.BorderSizePixel = 0
    row.Size = UDim2.new(1, -8, 0, height or 54)
    row.ZIndex = 92
    row.Parent = parent
    Velune.UICorner(row, 12)
    Velune.UIStroke(row, Color3.fromRGB(225, 29, 72), 1, 0.72)
    local tick = Instance.new("Frame")
    tick.Size = UDim2.new(0, 3, 1, -16)
    tick.Position = UDim2.new(0, 6, 0, 8)
    tick.BackgroundColor3 = Velune.Accent
    tick.BorderSizePixel = 0
    tick.ZIndex = 93
    tick.Parent = row
    Velune.UICorner(tick, 2)
    return row
end
function Velune.NativeToggle(parent, title, desc, value, cb)
    local row = Velune.NativeRow(parent, desc and 58 or 48)
    local t = Velune.MakeLabel(row, title, 13, true, Velune.Paper, 18)
    t.Position = UDim2.new(0, 12, 0, desc and 8 or 14)
    if desc then
        local d = Velune.MakeLabel(row, desc, 11, false, Velune.Muted, 16)
        d.Position = UDim2.new(0, 12, 0, 28)
        d.Size = UDim2.new(1, -72, 0, 16)
    end
    local track = Instance.new("TextButton")
    track.Size = UDim2.new(0, 42, 0, 24)
    track.Position = UDim2.new(1, -54, 0.5, -12)
    track.BackgroundColor3 = value and Velune.Accent or Color3.fromRGB(48, 40, 44)
    track.Text = ""
    track.AutoButtonColor = false
    track.ZIndex = 94
    track.Parent = row
    Velune.UICorner(track, 12)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 95
    knob.Parent = track
    Velune.UICorner(knob, 9)
    local on = value
    track.MouseButton1Click:Connect(function()
        on = not on
        Velune.Spring(knob, { Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.16)
        Velune.Spring(track, { BackgroundColor3 = on and Velune.Accent or Color3.fromRGB(48, 40, 44) }, 0.16)
        Velune.ClickTone()
        cb(on)
    end)
    return row
end
function Velune.NativeAction(parent, title, desc, cb)
    local row = Velune.NativeRow(parent, desc and 58 or 46)
    local t = Velune.MakeLabel(row, title, 13, true, Velune.Paper, 18)
    t.Position = UDim2.new(0, 12, 0, desc and 8 or 14)
    if desc then
        local d = Velune.MakeLabel(row, desc, 11, false, Velune.Muted, 16)
        d.Position = UDim2.new(0, 12, 0, 28)
        d.Size = UDim2.new(1, -20, 0, 16)
    end
    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.Text = ""
    hit.ZIndex = 96
    hit.Parent = row
    hit.MouseButton1Click:Connect(function()
        Velune.ClickTone()
        Velune.Spring(row, { BackgroundTransparency = 0 }, 0.08)
        task.delay(0.1, function()
            Velune.Spring(row, { BackgroundTransparency = 0.12 }, 0.16)
        end)
        cb()
    end)
    return row
end
function Velune.NativeColor(parent, title, get, set)
    local row = Velune.NativeRow(parent, 48)
    local t = Velune.MakeLabel(row, title, 13, true, Velune.Paper, 18)
    t.Position = UDim2.new(0, 12, 0, 14)
    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 28, 0, 28)
    sw.Position = UDim2.new(1, -42, 0.5, -14)
    sw.BackgroundColor3 = get()
    sw.Text = ""
    sw.AutoButtonColor = false
    sw.ZIndex = 94
    sw.Parent = row
    Velune.UICorner(sw, 8)
    Velune.UIStroke(sw, Color3.new(1, 1, 1), 1, 0.55)
    sw.MouseButton1Click:Connect(function()
        Velune.OpenNativeColor(title, get(), function(c)
            sw.BackgroundColor3 = c
            set(c)
        end)
    end)
    return row
end
function Velune.PaintNativePage(id)
    local body = Velune.UI.Body
    if not body then
        return
    end
    for _, ch in ipairs(body:GetChildren()) do
        if ch:IsA("GuiObject") and ch.Name ~= "Layout" and ch.Name ~= "Pad" then
            ch:Destroy()
        end
    end
    if id == "combat" then
        Velune.MakeLabel(body, "Auto-loaded buttons", 12, true, Velune.Muted, 18)
        Velune.NativeToggle(body, "Show Gold Bomb", "88px glass jump on the floor.", Velune.Shown.GoldBomb, function(v) Velune.LoadGoldBomb(v) end)
        Velune.NativeToggle(body, "Show Normal Bomb", nil, Velune.Shown.NormalBomb, function(v) Velune.LoadNormalBomb(v) end)
        Velune.NativeToggle(body, "Show Shoot / Throw", "Spins the gun asset. Swaps to knife id 9695655416.", Velune.Shown.Shoot, function(v) Velune.LoadShoot(v) end)
        Velune.MakeLabel(body, "Optional buttons", 12, true, Velune.Muted, 18)
        Velune.NativeToggle(body, "Load Flick", "180° snap. Shift-lock flips camera, otherwise the character turns.", Velune.Shown.Flick, function(v) Velune.LoadFlick(v) end)
        Velune.NativeToggle(body, "Load Wall Hop", nil, Velune.Shown.WallHop, function(v) Velune.LoadWallHop(v) end)
        Velune.NativeToggle(body, "Load Fling Murderer", nil, Velune.Shown.FlingMurderer, function(v) Velune.LoadFlingMurderer(v) end)
        Velune.NativeToggle(body, "Load Fling Sheriff", nil, Velune.Shown.FlingSheriff, function(v) Velune.LoadFlingSheriff(v) end)
        Velune.NativeToggle(body, "Load Silent Throw", nil, Velune.Shown.SilentThrow, function(v) Velune.LoadSilentThrow(v) end)
        Velune.NativeToggle(body, "Load Kill All", nil, Velune.Shown.KillAll, function(v) Velune.LoadKillAll(v) end)
        Velune.NativeToggle(body, "Silent Aim", "Camera settles on the murderer while you shoot.", Velune.Flags.SilentAim == true, function(v) Velune.SetSilentAim(v) end)
        Velune.NativeToggle(body, "Show FOV", nil, Velune.Flags.ShowFov == true, function(v) Velune.SetShowFov(v) end)
        Velune.NativeToggle(body, "Auto Shoot Murderer", nil, Velune.Flags.AutoShoot, function(v) Velune.Flags.AutoShoot = v end)
        Velune.NativeToggle(body, "Knife Aura", nil, Velune.Flags.KnifeAura, function(v) Velune.Flags.KnifeAura = v end)
        Velune.NativeToggle(body, "Silent Throw Loop", nil, Velune.Flags.SilentThrow, function(v) Velune.Flags.SilentThrow = v end)
        Velune.NativeToggle(body, "Wall Bang", nil, Velune.Flags.WallBang, function(v) Velune.Flags.WallBang = v end)
        Velune.NativeToggle(body, "Ping Prediction", nil, Velune.Flags.PingPredict, function(v) Velune.Flags.PingPredict = v end)
        Velune.NativeAction(body, "Shoot Murderer", nil, function() Velune.ShootMurderer() end)
        Velune.NativeAction(body, "Silent Knife Throw", nil, function() Velune.SilentThrow() end)
        Velune.NativeAction(body, "Kill All", nil, function() Velune.KillAll() end)
        Velune.NativeAction(body, "Kill Only Sheriff", nil, function() Velune.KillSheriff() end)
        Velune.NativeToggle(body, "Head Size", "Client head scale. Restores when off.", Velune.Flags.Hitbox == true, function(v) Velune.SetHitbox(v, Velune.Values.Hitbox or 4) end)
    elseif id == "visual" then
        Velune.NativeToggle(body, "Enable ESP", nil, Velune.Flags.ESP, function(v)
            Velune.Flags.ESP = v
            if not v then
                Velune.ClearESP()
            end
            Velune.Notify("VELUNE", v and "ESP ON" or "ESP OFF")
        end)
        Velune.NativeToggle(body, "Load ESP Toggle", "Pins the ESP glass button.", Velune.Shown.ESP, function(v) Velune.LoadESP(v) end)
        Velune.NativeToggle(body, "Show Murderer", nil, Velune.Flags.ShowMurderer, function(v) Velune.Flags.ShowMurderer = v end)
        Velune.NativeToggle(body, "Show Sheriff", nil, Velune.Flags.ShowSheriff, function(v) Velune.Flags.ShowSheriff = v end)
        Velune.NativeToggle(body, "Show Hero", nil, Velune.Flags.ShowHero, function(v) Velune.Flags.ShowHero = v end)
        Velune.NativeToggle(body, "Show Innocents", nil, Velune.Flags.ShowInnocent, function(v) Velune.Flags.ShowInnocent = v end)
        Velune.NativeToggle(body, "Show Self", nil, Velune.Flags.ShowSelf, function(v) Velune.Flags.ShowSelf = v end)
        Velune.NativeToggle(body, "Dropped Gun ESP", nil, Velune.Flags.GunESP, function(v)
            Velune.Flags.GunESP = v
            if not v then
                Velune.MarkGun(nil)
            end
        end)
        Velune.NativeToggle(body, "Names", nil, Velune.Flags.Names, function(v) Velune.Flags.Names = v end)
        Velune.NativeToggle(body, "Boxes", nil, Velune.Flags.Boxes, function(v) Velune.Flags.Boxes = v end)
        Velune.NativeToggle(body, "Tracers", nil, Velune.Flags.Tracers, function(v) Velune.Flags.Tracers = v end)
        Velune.NativeColor(body, "Murderer Color", function() return Velune.Colors.Murderer end, function(c) Velune.Colors.Murderer = c end)
        Velune.NativeColor(body, "Sheriff Color", function() return Velune.Colors.Sheriff end, function(c) Velune.Colors.Sheriff = c end)
        Velune.NativeColor(body, "Hero Color", function() return Velune.Colors.Hero end, function(c) Velune.Colors.Hero = c end)
        Velune.NativeColor(body, "Innocent Color", function() return Velune.Colors.Innocent end, function(c) Velune.Colors.Innocent = c end)
        Velune.NativeAction(body, "Open Skybox Picker", "100+ lighting presets.", function() Velune.OpenSkyPicker() end)
        Velune.NativeAction(body, "Restore Default Sky", nil, function() Velune.RestoreSky() end)
        Velune.NativeToggle(body, "Enable Custom Crosshair", nil, Velune.Flags.Crosshair, function(v) Velune.SetCrosshair(v) end)
        Velune.NativeAction(body, "Open Cursor Picker", "rbxassetid cursors.", function() Velune.OpenCursorPicker() end)
        Velune.NativeToggle(body, "Low Graphics (FPS Boost)", nil, Velune.Flags.LowGFX, function(v) Velune.SetLowGFX(v) end)
        Velune.NativeToggle(body, "High Graphics", nil, Velune.Flags.HighGFX, function(v) Velune.SetHighGFX(v) end)
        Velune.NativeToggle(body, "Fullbright", nil, Velune.Flags.Fullbright == true, function(v) Velune.SetFullbright(v) end)
        Velune.NativeToggle(body, "X-Ray", "Fades map parts.", Velune.Flags.Xray == true, function(v) Velune.SetXray(v) end)
        Velune.NativeAction(body, "FOV Slider", nil, function()
            Velune.OpenSlider("Field of View", 30, 120, Velune.Values.FOV, 5, function(n)
                Velune.SetFOV(n)
            end, function()
                Velune.SetFOV(70)
            end)
        end)
    elseif id == "move" then
        Velune.NativeToggle(body, "Load Speed Glitch", nil, Velune.Shown.Speed, function(v) Velune.LoadSpeed(v) end)
        Velune.NativeAction(body, "Speed Glitch Slider", nil, function()
            Velune.OpenSlider("Speed Glitch", 50, 600, Velune.Values.Speed, 10, function(n)
                Velune.Values.Speed = n
            end, function()
                Velune.Values.Speed = 200
            end)
        end)
        Velune.NativeToggle(body, "Load Stretch", nil, Velune.Shown.Stretch, function(v) Velune.LoadStretch(v) end)
        Velune.NativeAction(body, "Stretch Resolution", "10% very wide / 100% normal.", function()
            Velune.OpenSlider("Stretch Resolution", 10, 100, math.round(Velune.Values.Stretch * 100), 5, function(n)
                Velune.Values.Stretch = n / 100
                if Velune.Flags.StretchOn then
                    Velune.SetStretch(true)
                end
            end, function()
                Velune.Values.Stretch = 0.5
            end)
        end)
        Velune.NativeToggle(body, "Fly", nil, Velune.Flags.Fly, function(v) Velune.SetFly(v) end)
        Velune.NativeToggle(body, "Load Fly Button", nil, Velune.Shown.Fly, function(v) Velune.LoadFly(v) end)
        Velune.NativeToggle(body, "Noclip", nil, Velune.Flags.Noclip, function(v) Velune.SetNoclip(v) end)
        Velune.NativeToggle(body, "Load Noclip Button", nil, Velune.Shown.Noclip, function(v) Velune.LoadNoclip(v) end)
        Velune.NativeToggle(body, "Infinite Jump", nil, Velune.Flags.InfiniteJump, function(v) Velune.SetInfiniteJump(v) end)
        Velune.NativeToggle(body, "God Mode", "Reapplies health locally.", Velune.Flags.God == true, function(v) Velune.SetGod(v) end)
        Velune.NativeToggle(body, "Invisible", nil, Velune.Flags.Invisible == true, function(v) Velune.SetInvisible(v) end)
        Velune.NativeToggle(body, "Spin", nil, Velune.Flags.Spin == true, function(v) Velune.SetSpin(v) end)
        Velune.NativeToggle(body, "Bhop", nil, Velune.Flags.Bhop == true, function(v) Velune.SetBhop(v) end)
        Velune.NativeAction(body, "Gravity", "0 to 196.", function()
            Velune.OpenSlider("Gravity", 0, 196, Velune.Values.Gravity or 196, 2, function(n)
                Velune.SetGravity(n)
            end, function()
                Velune.SetGravity(196)
            end)
        end)
    elseif id == "world" then
        Velune.NativeToggle(body, "Load Grab Gun", nil, Velune.Shown.GrabGun, function(v) Velune.LoadGrabGun(v) end)
        Velune.NativeToggle(body, "Auto Grab Gun", nil, Velune.Flags.AutoGrab, function(v) Velune.Flags.AutoGrab = v end)
        Velune.NativeToggle(body, "Notify on Gun Drop", nil, Velune.Flags.NotifyGun, function(v) Velune.Flags.NotifyGun = v end)
        Velune.NativeToggle(body, "Notify on Murderer", nil, Velune.Flags.NotifyMurd, function(v) Velune.Flags.NotifyMurd = v end)
        Velune.NativeToggle(body, "Notify on Sheriff", nil, Velune.Flags.NotifySher, function(v) Velune.Flags.NotifySher = v end)
        Velune.NativeToggle(body, "Auto Coin Farm", nil, Velune.Flags.AutoFarm, function(v)
            Velune.Flags.AutoFarm = v
            Velune.Notify("VELUNE", v and "Farm ON" or "Farm OFF")
        end)
        Velune.NativeToggle(body, "Load Farm Button", nil, Velune.Shown.Farm, function(v) Velune.LoadFarm(v) end)
        Velune.NativeAction(body, "Teleport to Murderer", nil, function()
            local m = Velune.FindMurderer()
            if m then
                Velune.TeleportToPlayer(m)
            else
                Velune.Notify("VELUNE", "No murderer.")
            end
        end)
        Velune.NativeAction(body, "Teleport to Sheriff", nil, function()
            local s = Velune.FindSheriff()
            if s then
                Velune.TeleportToPlayer(s)
            else
                Velune.Notify("VELUNE", "No sheriff.")
            end
        end)
        Velune.NativeAction(body, "Teleport to Lobby", nil, function() Velune.TeleportToLobby() end)
        Velune.NativeAction(body, "Teleport to Map", nil, function() Velune.TeleportToMap() end)
        Velune.NativeAction(body, "Expose Roles in Chat", nil, function() Velune.ChatRoles() end)
        Velune.MakeLabel(body, "Troll", 12, true, Velune.Muted, 18)
        Velune.NativeAction(body, "Fling Murderer", nil, function() Velune.FlingMurderer() end)
        Velune.NativeAction(body, "Fling Sheriff", nil, function() Velune.FlingSheriff() end)
        Velune.NativeAction(body, "Fling Everyone", nil, function()
            task.spawn(function()
                if not Players then
                    return
                end
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP then
                        Velune.FlingPlayer(p)
                        task.wait(1.4)
                    end
                end
            end)
        end)
    else
        Velune.NativeToggle(body, "Anti-Fling", nil, Velune.Flags.AntiFling, function(v) Velune.SetAntiFling(v) end)
        Velune.NativeToggle(body, "Anti-AFK", nil, Velune.Flags.AntiAFK, function(v) Velune.SetAntiAFK(v) end)
        Velune.NativeToggle(body, "Buttons Locked", "Unlock to drag the glass buttons.", Velune.Flags.ButtonsLocked, function(v) Velune.Flags.ButtonsLocked = v end)
        Velune.NativeAction(body, "Rejoin Current Server", nil, function() Velune.Rejoin() end)
        Velune.NativeAction(body, "Server Hop", nil, function() Velune.ServerHop() end)
        Velune.NativeAction(body, "Save Config", nil, function() Velune.SaveConfig() end)
        Velune.NativeAction(body, "Reload Config", nil, function() Velune.LoadConfig() end)
    end
end
function Velune.SetNativeOpen(on)
    Velune.NativeOpen = on
    local win = Velune.UI.Window
    local orb = Velune.UI.Orb
    if win then
        win.Visible = on
        if on then
            win.Size = UDim2.new(0, math.floor(win.Size.X.Offset * 0.94), 0, math.floor(win.Size.Y.Offset * 0.94))
            Velune.Spring(win, { Size = Velune.UI.WinSize }, 0.22)
        end
    end
    if orb then
        orb.Visible = not on
    end
end
function Velune.BuildNative()
    local host = Velune.HostGui()
    local old = host:FindFirstChild("VeluneNative")
    if old then
        old:Destroy()
    end
    local mobile = Velune.IsMobile()
    local cam = Velune.Cam()
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local winW = mobile and math.min(vp.X - 16, 460) or 860
    local winH = mobile and math.min(vp.Y * 0.82, 620) or 560
    Velune.UI.WinSize = UDim2.new(0, winW, 0, winH)
    local root = Instance.new("Frame")
    root.Name = "VeluneNative"
    root.BackgroundTransparency = 1
    root.Size = UDim2.new(1, 0, 1, 0)
    root.ZIndex = 80
    root.Parent = host
    local win = Instance.new("Frame")
    win.Name = "Window"
    win.Size = Velune.UI.WinSize
    if mobile then
        win.AnchorPoint = Vector2.new(0.5, 1)
        win.Position = UDim2.new(0.5, 0, 1, -10)
    else
        win.AnchorPoint = Vector2.new(0.5, 0)
        win.Position = UDim2.new(0.5, 0, 0.1, 0)
    end
    win.BackgroundColor3 = Velune.Surface
    win.BackgroundTransparency = 0.04
    win.BorderSizePixel = 0
    win.ClipsDescendants = true
    win.ZIndex = 81
    win.Parent = root
    Velune.UICorner(win, 14)
    Velune.UIStroke(win, Color3.fromRGB(225, 29, 72), 1.5, 0.25)
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 48)
    top.BackgroundColor3 = Color3.fromRGB(16, 12, 14)
    top.BackgroundTransparency = 0.08
    top.BorderSizePixel = 0
    top.ZIndex = 82
    top.Parent = win
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(1, 0, 0, 2)
    accent.BackgroundColor3 = Velune.Accent
    accent.BorderSizePixel = 0
    accent.ZIndex = 83
    accent.Parent = top
    local mark = Instance.new("ImageLabel")
    mark.BackgroundTransparency = 1
    mark.Size = UDim2.new(0, 22, 0, 22)
    mark.Position = UDim2.new(0, 14, 0.5, -11)
    mark.Image = "rbxassetid://6031075938"
    mark.ImageColor3 = Velune.Accent
    mark.ZIndex = 84
    mark.Parent = top
    local title = Velune.MakeLabel(top, "VELUNE", 15, true, Velune.Paper, 20)
    title.Position = UDim2.new(0, 44, 0.5, -10)
    title.Size = UDim2.new(0, 140, 0, 20)
    local sub = Velune.MakeLabel(top, "MM2  ·  v2.4", 11, false, Velune.Muted, 16)
    sub.Position = UDim2.new(0, 130, 0.5, -8)
    sub.Size = UDim2.new(0, 90, 0, 16)
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 32, 0, 32)
    close.Position = UDim2.new(1, -40, 0.5, -16)
    close.BackgroundColor3 = Color3.fromRGB(40, 28, 30)
    close.Text = "×"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.TextColor3 = Velune.Paper
    close.ZIndex = 85
    close.Parent = top
    Velune.UICorner(close, 8)
    close.MouseButton1Click:Connect(function()
        Velune.SetNativeOpen(false)
    end)
    local tabs = Instance.new("Frame")
    local rail = not mobile
    if rail then
        tabs.Size = UDim2.new(0, 168, 1, -48)
        tabs.Position = UDim2.new(0, 0, 0, 48)
    else
        tabs.Size = UDim2.new(1, 0, 0, 40)
        tabs.Position = UDim2.new(0, 0, 0, 48)
    end
    tabs.BackgroundColor3 = Color3.fromRGB(14, 11, 13)
    tabs.BorderSizePixel = 0
    tabs.ZIndex = 82
    tabs.Parent = win
    local tlist = Instance.new("UIListLayout")
    tlist.FillDirection = rail and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
    tlist.Padding = UDim.new(0, 4)
    tlist.VerticalAlignment = rail and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Center
    tlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tlist.Parent = tabs
    local tpad = Instance.new("UIPadding")
    tpad.PaddingLeft = UDim.new(0, 10)
    tpad.Parent = tabs
    local names = {
        { "combat", "Combat" },
        { "visual", "Visual" },
        { "move", "Move" },
        { "world", "World" },
        { "system", "System" },
    }
    Velune.UI.TabBtns = {}
    local current = "combat"
    local function paintTabs()
        for id, b in pairs(Velune.UI.TabBtns) do
            b.BackgroundColor3 = id == current and Velune.Accent or Color3.fromRGB(28, 22, 24)
            b.TextColor3 = id == current and Color3.new(1, 1, 1) or Velune.Muted
        end
    end
    for _, row in ipairs(names) do
        local b = Instance.new("TextButton")
        b.Size = rail and UDim2.new(1, -12, 0, 32) or UDim2.new(0, 72, 0, 28)
        b.BackgroundColor3 = Color3.fromRGB(28, 22, 24)
        b.Text = row[2]
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.TextColor3 = Velune.Muted
        b.AutoButtonColor = false
        b.ZIndex = 84
        b.Parent = tabs
        Velune.UICorner(b, 8)
        Velune.UI.TabBtns[row[1]] = b
        b.MouseButton1Click:Connect(function()
            current = row[1]
            paintTabs()
            Velune.PaintNativePage(current)
        end)
    end
    paintTabs()
    local body = Instance.new("ScrollingFrame")
    body.Name = "Body"
    if rail then
        body.Size = UDim2.new(1, -168, 1, -48)
        body.Position = UDim2.new(0, 168, 0, 48)
    else
        body.Size = UDim2.new(1, 0, 1, -88)
        body.Position = UDim2.new(0, 0, 0, 88)
    end
    body.BackgroundTransparency = 1
    body.BorderSizePixel = 0
    body.ScrollBarThickness = 4
    body.CanvasSize = UDim2.new(0, 0, 0, 0)
    body.AutomaticCanvasSize = Enum.AutomaticSize.Y
    body.ZIndex = 82
    body.Parent = win
    local layout = Instance.new("UIListLayout")
    layout.Name = "Layout"
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = body
    Velune.UIPad(body, 10, 10, 10, 16)
    Velune.UI.Window = win
    Velune.UI.Body = body
    Velune.MakeDrag(win)
    local orb = Instance.new("TextButton")
    orb.Name = "VeluneOrb"
    orb.Size = UDim2.new(0, 52, 0, 52)
    orb.Position = UDim2.new(1, -68, 1, -68)
    orb.BackgroundColor3 = Velune.Accent
    orb.Text = ""
    orb.AutoButtonColor = false
    orb.Visible = false
    orb.ZIndex = 88
    orb.Parent = root
    Velune.UICorner(orb, 26)
    Velune.UIStroke(orb, Color3.fromRGB(255, 180, 190), 1.6, 0.25)
    local og = Instance.new("UIGradient")
    og.Color = ColorSequence.new(Color3.fromRGB(225, 29, 72), Color3.fromRGB(159, 18, 57))
    og.Rotation = 160
    og.Parent = orb
    local oMark = Instance.new("ImageLabel")
    oMark.BackgroundTransparency = 1
    oMark.Size = UDim2.new(0, 26, 0, 26)
    oMark.Position = UDim2.new(0.5, -13, 0.5, -13)
    oMark.Image = "rbxassetid://6031075938"
    oMark.ImageColor3 = Color3.new(1, 1, 1)
    oMark.ZIndex = 89
    oMark.Parent = orb
    orb.MouseButton1Click:Connect(function()
        Velune.SetNativeOpen(true)
    end)
    Velune.UI.Orb = orb
    Velune.PaintNativePage("combat")
    Velune.SetNativeOpen(true)
    Velune.Notify("VELUNE", "Native UI live. Glass buttons on the floor.")
end

function Velune.SetGod(on)
    Velune.Flags.God = on and true or false
    Velune.Notify("VELUNE", Velune.Flags.God and "God ON" or "God OFF")
end
function Velune.SetInvisible(on)
    Velune.Flags.Invisible = on and true or false
    local char = Velune.Char()
    if char then
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
                d.LocalTransparencyModifier = Velune.Flags.Invisible and 1 or 0
            end
        end
    end
end
function Velune.SetSpin(on)
    Velune.Flags.Spin = on and true or false
end
function Velune.SetBhop(on)
    Velune.Flags.Bhop = on and true or false
end
function Velune.SetGravity(n)
    Velune.Values.Gravity = n
    if Workspace then
        pcall(function()
            Workspace.Gravity = n
        end)
    end
end
function Velune.SetFullbright(on)
    Velune.Flags.Fullbright = on and true or false
    if not Lighting then
        return
    end
    if on then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    elseif Velune.LightingSnap then
        pcall(function()
            Lighting.Brightness = Velune.LightingSnap.Brightness
            Lighting.ClockTime = Velune.LightingSnap.ClockTime
            Lighting.FogEnd = Velune.LightingSnap.FogEnd
            Lighting.Ambient = Velune.LightingSnap.Ambient
            Lighting.OutdoorAmbient = Velune.LightingSnap.OutdoorAmbient
        end)
    end
end
function Velune.SetXray(on)
    Velune.Flags.Xray = on and true or false
    local map = Velune.MapRoot()
    if not map then
        return
    end
    for _, d in ipairs(map:GetDescendants()) do
        if d:IsA("BasePart") then
            if on then
                if d:GetAttribute("VeluneX") == nil then
                    d:SetAttribute("VeluneX", d.LocalTransparencyModifier)
                end
                d.LocalTransparencyModifier = 0.72
            else
                local prev = d:GetAttribute("VeluneX")
                if typeof(prev) == "number" then
                    d.LocalTransparencyModifier = prev
                    d:SetAttribute("VeluneX", nil)
                end
            end
        end
    end
end
function Velune.KillSheriff()
    local sher = Velune.FindSheriff()
    if not sher then
        Velune.Notify("VELUNE", "No sheriff.")
        return
    end
    if Velune.HasTool("Knife") then
        Velune.ThrowKnife()
    else
        Velune.FlingSheriff()
    end
end
function Velune.SetSilentAim(on)
    Velune.Flags.SilentAim = on and true or false
end
function Velune.SetShowFov(on)
    Velune.Flags.ShowFov = on and true or false
end
function Velune.SetHitbox(on, scale)
    Velune.Flags.Hitbox = on and true or false
    if scale then
        Velune.Values.Hitbox = scale
    end
    if not Players then
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                if Velune.Flags.Hitbox then
                    if head:GetAttribute("VeluneHead") == nil then
                        head:SetAttribute("VeluneHead", head.Size)
                    end
                    local n = Velune.Values.Hitbox or 4
                    head.Size = Vector3.new(n, n, n)
                else
                    local prev = head:GetAttribute("VeluneHead")
                    if typeof(prev) == "Vector3" then
                        head.Size = prev
                        head:SetAttribute("VeluneHead", nil)
                    end
                end
            end
        end
    end
end
function Velune.SaveConfig()
    if not writefile or not HttpService then
        Velune.Notify("VELUNE", "This executor cannot save files.")
        return
    end
    local ok, data = pcall(function()
        return HttpService:JSONEncode({ Flags = Velune.Flags, Values = Velune.Values })
    end)
    if ok and data then
        pcall(makefolder, "Velune")
        writefile("Velune/config.json", data)
        Velune.Notify("VELUNE", "Config saved.")
    end
end
function Velune.LoadConfig()
    if not readfile or not isfile or not HttpService then
        Velune.Notify("VELUNE", "No saved config.")
        return
    end
    if not isfile("Velune/config.json") then
        Velune.Notify("VELUNE", "No saved config.")
        return
    end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile("Velune/config.json"))
    end)
    if ok and type(data) == "table" then
        if type(data.Flags) == "table" then
            for k, v in pairs(data.Flags) do
                Velune.Flags[k] = v
            end
        end
        if type(data.Values) == "table" then
            for k, v in pairs(data.Values) do
                Velune.Values[k] = v
            end
        end
        Velune.Notify("VELUNE", "Config loaded.")
    end
end

function Velune.BuildWind()
    if not WindUI then
        Velune.Notify("VELUNE", "WindUI missing — floor buttons still live.")
        return
    end
    pcall(function()
        WindUI:Popup({
            Title = "VELUNE  ·  Murder Mystery 2",
            Icon = "sparkles",
            Content = "v2.4 loaded.\nGlass floor buttons auto-loaded.\nNative UI is the control surface.",
            Buttons = {
                { Title = "Start", Icon = "arrow-right", Variant = "Primary", Callback = function() end },
            },
        })
    end)
    local okWind = pcall(function()
    local window = WindUI:CreateWindow({
        Title = "VELUNE",
        Icon = "sparkles",
        Author = "Murder Mystery 2",
        Folder = "Velune",
        Size = UDim2.fromOffset(700, 550),
        Theme = "Crimson",
        Acrylic = false,
        HideSearchBar = false,
        OpenButton = {
            Title = "VELUNE",
            CornerRadius = UDim.new(1, 0),
            StrokeThickness = 2,
            Enabled = true,
            OnlyMobile = false,
            Color = ColorSequence.new(Color3.fromHex("#e11d48"), Color3.fromHex("#9f1239")),
        },
    })
    local section = window:Section({ Title = "VELUNE", Opened = true })
    local combat = section:Tab({ Title = "Combat", Icon = "swords" })
    local visual = section:Tab({ Title = "Visual", Icon = "eye" })
    local move = section:Tab({ Title = "Move", Icon = "person-standing" })
    local world = section:Tab({ Title = "World", Icon = "globe" })
    local system = section:Tab({ Title = "System", Icon = "settings" })
    combat:Paragraph({ Title = "Auto-Loaded Buttons", Content = "Gold Bomb, Normal Bomb and Shoot/Throw are enabled by default." })
    combat:Toggle({ Title = "Show Gold Bomb", Default = true, Callback = function(v) Velune.LoadGoldBomb(v) end })
    combat:Toggle({ Title = "Show Normal Bomb", Default = true, Callback = function(v) Velune.LoadNormalBomb(v) end })
    combat:Toggle({ Title = "Show Shoot/Throw", Default = true, Callback = function(v) Velune.LoadShoot(v) end })
    combat:Divider()
    combat:Paragraph({ Title = "Optional Buttons", Content = "Toggle to add or remove from screen." })
    combat:Toggle({ Title = "Load Flick", Default = false, Callback = function(v) Velune.LoadFlick(v) end })
    combat:Toggle({ Title = "Load Wall Hop", Default = false, Callback = function(v) Velune.LoadWallHop(v) end })
    combat:Toggle({ Title = "Load Fling Murderer", Default = false, Callback = function(v) Velune.LoadFlingMurderer(v) end })
    combat:Toggle({ Title = "Load Fling Sheriff", Default = false, Callback = function(v) Velune.LoadFlingSheriff(v) end })
    combat:Toggle({ Title = "Load Silent Throw", Default = false, Callback = function(v) Velune.LoadSilentThrow(v) end })
    combat:Toggle({ Title = "Load Kill All", Default = false, Callback = function(v) Velune.LoadKillAll(v) end })
    combat:Divider()
    combat:Toggle({ Title = "Silent Aim", Default = false, Callback = function(v) Velune.SetSilentAim(v) end })
    combat:Toggle({ Title = "Show FOV", Default = false, Callback = function(v) Velune.SetShowFov(v) end })
    combat:Toggle({ Title = "Auto Shoot Murderer", Default = false, Callback = function(v) Velune.Flags.AutoShoot = v end })
    combat:Toggle({ Title = "Knife Aura", Default = false, Callback = function(v) Velune.Flags.KnifeAura = v end })
    combat:Slider({ Title = "Knife Aura Range", Value = { Min = 5, Max = 80, Default = 20 }, Callback = function(v) Velune.Values.Aura = v end })
    combat:Toggle({ Title = "Silent Throw Loop", Default = false, Callback = function(v) Velune.Flags.SilentThrow = v end })
    combat:Toggle({ Title = "Wall Bang", Default = false, Callback = function(v) Velune.Flags.WallBang = v end })
    combat:Toggle({ Title = "Ping Prediction", Default = false, Callback = function(v) Velune.Flags.PingPredict = v end })
    combat:Button({ Title = "Shoot Murderer", Callback = function() Velune.ShootMurderer() end })
    combat:Button({ Title = "Silent Knife Throw", Callback = function() Velune.SilentThrow() end })
    combat:Button({ Title = "Kill All", Callback = function() Velune.KillAll() end })
    combat:Button({ Title = "Kill Sheriff", Callback = function() Velune.KillSheriff() end })
    combat:Toggle({ Title = "Head Size", Default = false, Callback = function(v) Velune.SetHitbox(v, Velune.Values.Hitbox or 4) end })
    combat:Slider({ Title = "Head Scale", Value = { Min = 2, Max = 10, Default = 4 }, Callback = function(v) Velune.SetHitbox(Velune.Flags.Hitbox, v) end })
    visual:Toggle({ Title = "Enable ESP", Default = false, Callback = function(v)
        Velune.Flags.ESP = v
        if not v then
            Velune.ClearESP()
        end
        Velune.Notify("VELUNE", v and "ESP ON" or "ESP OFF")
    end })
    visual:Toggle({ Title = "Load ESP Toggle", Default = false, Callback = function(v) Velune.LoadESP(v) end })
    visual:Divider()
    visual:Toggle({ Title = "Show Murderer", Default = true, Callback = function(v) Velune.Flags.ShowMurderer = v end })
    visual:Toggle({ Title = "Show Sheriff", Default = true, Callback = function(v) Velune.Flags.ShowSheriff = v end })
    visual:Toggle({ Title = "Show Hero", Default = true, Callback = function(v) Velune.Flags.ShowHero = v end })
    visual:Toggle({ Title = "Show Innocents", Default = true, Callback = function(v) Velune.Flags.ShowInnocent = v end })
    visual:Toggle({ Title = "Show Self", Default = true, Callback = function(v) Velune.Flags.ShowSelf = v end })
    visual:Toggle({ Title = "Dropped Gun ESP", Default = true, Callback = function(v)
        Velune.Flags.GunESP = v
        if not v then
            Velune.MarkGun(nil)
        end
    end })
    visual:Toggle({ Title = "Names", Default = true, Callback = function(v) Velune.Flags.Names = v end })
    visual:Toggle({ Title = "Boxes", Default = false, Callback = function(v) Velune.Flags.Boxes = v end })
    visual:Toggle({ Title = "Tracers", Default = false, Callback = function(v) Velune.Flags.Tracers = v end })
    visual:Divider()
    pcall(function()
        visual:Colorpicker({ Title = "Murderer Color", Default = Velune.Colors.Murderer, Callback = function(c) Velune.Colors.Murderer = c end })
    end)
    pcall(function()
        visual:Colorpicker({ Title = "Sheriff Color", Default = Velune.Colors.Sheriff, Callback = function(c) Velune.Colors.Sheriff = c end })
    end)
    pcall(function()
        visual:Colorpicker({ Title = "Hero Color", Default = Velune.Colors.Hero, Callback = function(c) Velune.Colors.Hero = c end })
    end)
    pcall(function()
        visual:Colorpicker({ Title = "Innocent Color", Default = Velune.Colors.Innocent, Callback = function(c) Velune.Colors.Innocent = c end })
    end)
    visual:Divider()
    visual:Button({ Title = "Open Skybox Picker", Callback = function() Velune.OpenSkyPicker() end })
    visual:Button({ Title = "Restore Default Sky", Callback = function() Velune.RestoreSky() end })
    visual:Divider()
    visual:Toggle({ Title = "Enable Custom Crosshair", Default = false, Callback = function(v) Velune.SetCrosshair(v) end })
    visual:Button({ Title = "Open Cursor Picker", Callback = function() Velune.OpenCursorPicker() end })
    visual:Divider()
    visual:Toggle({ Title = "Low Graphics (FPS Boost)", Default = false, Callback = function(v) Velune.SetLowGFX(v) end })
    visual:Toggle({ Title = "High Graphics", Default = false, Callback = function(v) Velune.SetHighGFX(v) end })
    visual:Toggle({ Title = "Fullbright", Default = false, Callback = function(v) Velune.SetFullbright(v) end })
    visual:Toggle({ Title = "X-Ray", Default = false, Callback = function(v) Velune.SetXray(v) end })
    visual:Button({ Title = "FOV Slider", Callback = function()
        Velune.OpenSlider("Field of View", 30, 120, Velune.Values.FOV, 5, function(n)
            Velune.SetFOV(n)
        end, function()
            Velune.SetFOV(70)
            Velune.Notify("VELUNE", "FOV reset to 70")
        end)
    end })
    move:Toggle({ Title = "Load Speed Glitch", Default = false, Callback = function(v) Velune.LoadSpeed(v) end })
    move:Button({ Title = "Speed Glitch Slider", Callback = function()
        Velune.OpenSlider("Speed Glitch", 50, 600, Velune.Values.Speed, 10, function(n)
            Velune.Values.Speed = n
        end, function()
            Velune.Values.Speed = 200
            Velune.Notify("VELUNE", "Speed reset to 200")
        end)
    end })
    move:Toggle({ Title = "Load Stretch", Default = false, Callback = function(v) Velune.LoadStretch(v) end })
    move:Button({ Title = "Stretch Resolution", Callback = function()
        Velune.OpenSlider("Stretch Resolution", 10, 100, math.round(Velune.Values.Stretch * 100), 5, function(n)
            Velune.Values.Stretch = n / 100
            if Velune.Flags.StretchOn then
                Velune.SetStretch(true)
            end
        end, function()
            Velune.Values.Stretch = 0.5
            if Velune.Flags.StretchOn then
                Velune.SetStretch(true)
            end
            Velune.Notify("VELUNE", "Stretch reset to 50%")
        end)
    end })
    move:Toggle({ Title = "Fly", Default = false, Callback = function(v) Velune.SetFly(v) end })
    move:Toggle({ Title = "Load Fly Button", Default = false, Callback = function(v) Velune.LoadFly(v) end })
    move:Slider({ Title = "Fly Speed", Value = { Min = 20, Max = 220, Default = 90 }, Callback = function(v) Velune.Values.FlySpeed = v end })
    move:Toggle({ Title = "Noclip", Default = false, Callback = function(v) Velune.SetNoclip(v) end })
    move:Toggle({ Title = "Load Noclip Button", Default = false, Callback = function(v) Velune.LoadNoclip(v) end })
    move:Toggle({ Title = "Infinite Jump", Default = false, Callback = function(v) Velune.SetInfiniteJump(v) end })
    move:Slider({ Title = "Walk Speed", Value = { Min = 16, Max = 80, Default = 16 }, Callback = function(v) Velune.SetWalk(v) end })
    move:Slider({ Title = "Jump Power", Value = { Min = 50, Max = 200, Default = 50 }, Callback = function(v) Velune.SetJump(v) end })
    move:Toggle({ Title = "God Mode", Default = false, Callback = function(v) Velune.SetGod(v) end })
    move:Toggle({ Title = "Invisible", Default = false, Callback = function(v) Velune.SetInvisible(v) end })
    move:Toggle({ Title = "Spin", Default = false, Callback = function(v) Velune.SetSpin(v) end })
    move:Toggle({ Title = "Bhop", Default = false, Callback = function(v) Velune.SetBhop(v) end })
    move:Slider({ Title = "Gravity", Value = { Min = 0, Max = 196, Default = 196 }, Callback = function(v) Velune.SetGravity(v) end })
    world:Toggle({ Title = "Load Grab Gun", Default = false, Callback = function(v) Velune.LoadGrabGun(v) end })
    world:Toggle({ Title = "Auto Grab Gun", Default = false, Callback = function(v) Velune.Flags.AutoGrab = v end })
    world:Toggle({ Title = "Notify on Gun Drop", Default = true, Callback = function(v) Velune.Flags.NotifyGun = v end })
    world:Toggle({ Title = "Notify on Murderer", Default = false, Callback = function(v) Velune.Flags.NotifyMurd = v end })
    world:Toggle({ Title = "Notify on Sheriff", Default = false, Callback = function(v) Velune.Flags.NotifySher = v end })
    world:Divider()
    world:Toggle({ Title = "Auto Coin Farm", Default = false, Callback = function(v)
        Velune.Flags.AutoFarm = v
        Velune.Notify("VELUNE", v and "Farm ON" or "Farm OFF")
    end })
    world:Toggle({ Title = "Load Farm Button", Default = false, Callback = function(v) Velune.LoadFarm(v) end })
    world:Slider({ Title = "Farm Speed", Value = { Min = 0, Max = 25, Default = 25 }, Callback = function(v) Velune.Values.FarmSpeed = v end })
    world:Slider({ Title = "Height Offset", Value = { Min = -6, Max = 0, Default = -5 }, Callback = function(v) Velune.Values.FarmOffset = v end })
    world:Slider({ Title = "Search Radius", Value = { Min = 100, Max = 10000, Default = 3000 }, Callback = function(v) Velune.Values.FarmRadius = v end })
    world:Divider()
    world:Button({ Title = "Teleport to Murderer", Callback = function()
        local m = Velune.FindMurderer()
        if m then
            Velune.TeleportToPlayer(m)
        else
            Velune.Notify("VELUNE", "No murderer.")
        end
    end })
    world:Button({ Title = "Teleport to Sheriff", Callback = function()
        local s = Velune.FindSheriff()
        if s then
            Velune.TeleportToPlayer(s)
        else
            Velune.Notify("VELUNE", "No sheriff.")
        end
    end })
    world:Button({ Title = "Teleport to Lobby", Callback = function() Velune.TeleportToLobby() end })
    world:Button({ Title = "Teleport to Map", Callback = function() Velune.TeleportToMap() end })
    world:Divider()
    world:Button({ Title = "Expose Roles in Chat", Callback = function() Velune.ChatRoles() end })

    world:Button({ Title = "Emote: sit", Callback = function() Velune.PlayEmote_sit() end })
    world:Button({ Title = "Emote: zombie", Callback = function() Velune.PlayEmote_zombie() end })
    world:Button({ Title = "Emote: ninja", Callback = function() Velune.PlayEmote_ninja() end })
    world:Button({ Title = "Emote: zen", Callback = function() Velune.PlayEmote_zen() end })
    world:Button({ Title = "Emote: floss", Callback = function() Velune.PlayEmote_floss() end })
    world:Button({ Title = "Emote: dab", Callback = function() Velune.PlayEmote_dab() end })
    world:Button({ Title = "Emote: wave", Callback = function() Velune.PlayEmote_wave() end })
    world:Button({ Title = "Emote: laugh", Callback = function() Velune.PlayEmote_laugh() end })
    world:Button({ Title = "Emote: point", Callback = function() Velune.PlayEmote_point() end })
    world:Button({ Title = "Emote: dance", Callback = function() Velune.PlayEmote_dance() end })
    world:Button({ Title = "Emote: cheer", Callback = function() Velune.PlayEmote_cheer() end })
    world:Button({ Title = "Emote: shrug", Callback = function() Velune.PlayEmote_shrug() end })
    world:Button({ Title = "Emote: salute", Callback = function() Velune.PlayEmote_salute() end })
    world:Button({ Title = "Emote: think", Callback = function() Velune.PlayEmote_think() end })
    world:Button({ Title = "Emote: confused", Callback = function() Velune.PlayEmote_confused() end })
    world:Button({ Title = "Emote: agree", Callback = function() Velune.PlayEmote_agree() end })
    world:Button({ Title = "Emote: disagree", Callback = function() Velune.PlayEmote_disagree() end })
    world:Button({ Title = "Emote: sleep", Callback = function() Velune.PlayEmote_sleep() end })
    world:Button({ Title = "Emote: clap", Callback = function() Velune.PlayEmote_clap() end })
    world:Button({ Title = "Emote: bow", Callback = function() Velune.PlayEmote_bow() end })

    system:Toggle({ Title = "Anti-Fling", Default = false, Callback = function(v) Velune.SetAntiFling(v) end })
    system:Dropdown({ Title = "Velocity Cap", Values = { "50", "100", "150", "200", "300", "500" }, Value = "200", Callback = function(v) Velune.Values.Cap = tonumber(v) or 200 end })
    system:Toggle({ Title = "Anti-AFK", Default = false, Callback = function(v) Velune.SetAntiAFK(v) end })
    system:Toggle({ Title = "Buttons Locked", Default = true, Callback = function(v) Velune.Flags.ButtonsLocked = v end })
    system:Divider()
    system:Button({ Title = "Rejoin Current Server", Callback = function() Velune.Rejoin() end })
    system:Button({ Title = "Server Hop", Callback = function() Velune.ServerHop() end })
    system:Button({ Title = "Save Config", Callback = function() Velune.SaveConfig() end })
    system:Button({ Title = "Reload Config", Callback = function() Velune.LoadConfig() end })
    end)
    if not okWind then
        Velune.Notify("VELUNE", "WindUI skipped — native UI is live.")
    end
end
function Velune.WatchGun()
    if not Workspace then
        return
    end
    local function attach(inst)
        if inst.Name == "GunDrop" then
            task.wait(0.1)
            if Velune.Flags.GunESP then
                Velune.MarkGun(inst)
            end
            if Velune.Flags.NotifyGun then
                Velune.Notify("VELUNE", "Gun dropped on the map!")
            end
        end
    end
    Velune.Track(Workspace.DescendantAdded:Connect(attach))
    Velune.Track(Workspace.DescendantRemoving:Connect(function(inst)
        if inst.Name == "GunDrop" then
            Velune.MarkGun(nil)
        end
    end))
    task.spawn(function()
        task.wait(1.4)
        local g = Velune.GunDrop()
        if g then
            attach(g)
        end
    end)
end
function Velune.WatchRoles()
    local ev = Velune.FindRemote("PlayerDataChanged", "RemoteEvent")
    if ev then
        Velune.Track(ev.OnClientEvent:Connect(function(data)
            if type(data) == "table" then
                Velune.RoleCache = data
                Velune.RoleStamp = tick()
                if Velune.Flags.NotifyMurd then
                    local m = Velune.FindMurderer()
                    if m then
                        Velune.Notify("VELUNE", "Murderer: " .. m.Name)
                    end
                end
                if Velune.Flags.NotifySher then
                    local s = Velune.FindSheriff()
                    if s then
                        Velune.Notify("VELUNE", "Sheriff: " .. s.Name)
                    end
                end
            end
        end))
    end
end
function Velune.BindInput()
    Velune.Track(UserInputService.JumpRequest:Connect(function()
        if Velune.Flags.InfiniteJump then
            local hum = Velune.Hum()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end))
end
function Velune.Heartbeat()
    Velune.Track(RunService.Heartbeat:Connect(function()
        Velune.TickFloor()
        Velune.SpeedTick()
        Velune.KnifeAuraTick()
        if Velune.Flags.AutoGrab and Velune.GunDrop() and not Velune.HasTool("Gun") and not Velune.OnCooldown("autograb", 400) then
            Velune.GrabGun()
        end
        if Velune.Flags.AutoShoot and Velune.HasTool("Gun") and not Velune.OnCooldown("autoshoot", 900) then
            local m = Velune.FindMurderer()
            if m then
                Velune.ShootMurderer()
            end
        end
        if Velune.Flags.SilentThrow and not Velune.OnCooldown("silentloop", 650) then
            Velune.SilentThrow()
        end
        if Velune.Flags.God then
            local hum = Velune.Hum()
            if hum and hum.Health > 0 then
                hum.Health = hum.MaxHealth
            end
        end
        if Velune.Flags.Spin then
            local root = Velune.HRP()
            if root then
                root.CFrame = root.CFrame * CFrame.Angles(0, 0.35, 0)
            end
        end
        if Velune.Flags.Bhop then
            local hum = Velune.Hum()
            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                hum.Jump = true
            end
        end
        if Velune.Flags.Invisible then
            Velune.SetInvisible(true)
        end
    end))
    Velune.Track(RunService.RenderStepped:Connect(function()
        Velune.TickESP()
    end))
    task.spawn(function()
        while true do
            Velune.FarmTick()
            task.wait(0.12)
        end
    end)
end
function Velune.Boot()
    if Lighting then
        Velune.LightingSnap = {
            ClockTime = Lighting.ClockTime,
            Brightness = Lighting.Brightness,
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            FogColor = Lighting.FogColor,
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
        }
    end
    Velune.HostGui()
    Velune.WatchGun()
    Velune.WatchRoles()
    Velune.BindInput()
    Velune.Heartbeat()
    if LP then
        Velune.Track(LP.CharacterAdded:Connect(function()
            task.wait(0.15)
            Velune.SetWalk(Velune.Values.Walk)
            Velune.SetJump(Velune.Values.Jump)
            if Velune.Flags.Fly then
                Velune.SetFly(true)
            end
        end))
    end
    task.wait(0.35)
    Velune.LoadGoldBomb(true)
    Velune.LoadNormalBomb(true)
    Velune.LoadShoot(true)
    pcall(Velune.BuildNative)
    pcall(Velune.BuildWind)
    Velune.Notify("VELUNE", "VELUNE v2.4 ready.")
    print("[VELUNE] v4.0.0 loaded.")
end
Velune.Boot()
return Velune
