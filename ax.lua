local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local genv = typeof(getgenv) == "function" and getgenv() or _G

local NeonPurple = Color3.fromHex("#A855F7")
local NeonCyan = Color3.fromHex("#22D3EE")
local NeonPink = Color3.fromHex("#EC4899")
local NeonRed = Color3.fromHex("#F43F5E")
local NeonYellow = Color3.fromHex("#FACC15")
local NeonGreen = Color3.fromHex("#4ADE80")

local function Notify(title, content, ntype, duration)
	local icon = "info"
	local color = NeonCyan

	if ntype == "Success" then
		icon = "check"
		color = NeonGreen
	elseif ntype == "Warning" then
		icon = "triangle-alert"
		color = NeonYellow
	elseif ntype == "Danger" then
		icon = "x"
		color = NeonRed
	end

	pcall(function()
		WindUI:Notify({
			Title = title,
			Content = content,
			Duration = duration or 3,
			Icon = icon,
			IconColor = color
		})
	end)
end

local function ParaSet(para, title, content)
	if not para then
		return
	end

	pcall(function()
		if title then
			para:SetTitle(title)
		end
	end)
	pcall(function()
		if content then
			if para.SetContent then
				para:SetContent(content)
			elseif para.SetDesc then
				para:SetDesc(content)
			end
		end
	end)
end

if game.GameId ~= 66654135 then
	Notify("Wrong game", "This script only works in Murder Mystery 2 (GameId 66654135).", "Danger", 6)

	return
end

if genv.mm2VisualLibraryLoaded then
	Notify("Already loaded", "MM2 is already loaded in this session.", "Warning", 4)

	return
end

genv.mm2VisualLibraryLoaded = true

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local StatsService = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

repeat
	task.wait()
until game:IsLoaded()

LocalPlayer:WaitForChild("PlayerGui")

local IsMobile = UserInputService.TouchEnabled

local function v15()
	return LocalPlayer.Character
end
local function v16()
	local v17 = v15()

	return v17 and v17:FindFirstChildOfClass("Humanoid")
end
local function v18()
	local v19 = v15()

	return v19 and v19:FindFirstChild("HumanoidRootPart")
end

local CoinCollected = ReplicatedStorage.Remotes.Gameplay.CoinCollected
local RoundStart = ReplicatedStorage.Remotes.Gameplay.RoundStart
local t1 = {
	"MouseButton1Click",
	"MouseButton1Down",
	"Activated"
}

local function v24(p1)
	if not p1 then
		return
	end

	local v25 = false

	for _, v in ipairs(t1) do
		local v28 = p1[v]

		if v28 and typeof(getconnections) == "function" then
			local ok, result = pcall(getconnections, v28)

			if ok then
				for _, v2 in pairs(result) do
					if v2 and typeof(v2.Function) == "function" then
						v25 = true
						pcall(v2.Function)
					end
				end
			end
		end

		if v28 and typeof(firesignal) == "function" then
			v25 = true
			pcall(firesignal, v28)
		end
	end

	if not v25 then
		pcall(function()
			if typeof(p1.Activate) == "function" then
				p1:Activate()
			end
		end)
	end
end

repeat
	pcall(function()
		v24(LocalPlayer.PlayerGui.DeviceSelect.Container.Tablet.Button)
	end)
	pcall(function()
		v24(LocalPlayer.PlayerGui.Join.Friends.Play)
	end)
	task.wait(1)
until LocalPlayer.PlayerGui:FindFirstChild("MainGUI")

local t2 = {
	AutoRevealRoles = false,
	CoinFarm2 = {
		State = false,
		Settings = {
			DestroyMap = false,
			DestroyPlayers = false
		}
	},
	ESP = {
		Players = false,
		NameESP = false,
		TracerESP = false,
		Traps = false,
		DroppedGun = false
	},
	Noclip = false,
	Gameplay = {
		AutoPickUpGun = false,
		AutoShooting = false,
		AntiFling = false
	},
	AutoFarm = {
		TeleportSpawn = false,
		KillEveryoneAsAMurderer = false,
		AutoFlingMurderer = false,
		AutoFlingSheriff = false,
		AutoPrestige = false,
		AutoTeleportToRandomServerIfServerIsEmpty = false,
		PlayersToAutoServerHop = 2
	},
	AnnoyingStuff = {
		Fling = {
			PickedPlayer = nil,
			LoopFlingAllPlayers = false
		}
	},
	Sliders = {
		Speed = 16,
		Jump = 50
	},
	AutoOpenCrates = {
		State = false,
		Crate = "MysteryBox1",
		CrateType = "MysteryBox"
	},
	ShuffleWeapons = false,
	Emotes = {
		SelectedEmote = "zen",
		AutoPlayEmotes = false,
		AutoPlaySelectedEmote = false,
		EmoteSpamSpeed = 1
	}
}

local function v34(p2)
	local v35 = table.clone(p2)

	for k, v in pairs(v35) do
		if type(v) == "table" then
			v35[k] = v34(v)
		end
	end

	return v35
end

local v38 = v34(t2)

LocalPlayer.Idled:Connect(function()
	VirtualUser:ClickButton2(Vector2.new())
end)

local CenteredLabelGui = CoreGui:FindFirstChild("CenteredLabelGui") or Instance.new("ScreenGui")

CenteredLabelGui.Name = "CenteredLabelGui"
CenteredLabelGui.Parent = CoreGui

local CenteredTextLabel = CenteredLabelGui:FindFirstChild("CenteredTextLabel") or Instance.new("TextLabel")

CenteredTextLabel.Name = "CenteredTextLabel"
CenteredTextLabel.Visible = false
CenteredTextLabel.Text = ""
CenteredTextLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
CenteredTextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
CenteredTextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
CenteredTextLabel.BackgroundTransparency = 1
CenteredTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CenteredTextLabel.TextStrokeTransparency = 0.35
CenteredTextLabel.Font = Enum.Font.SourceSansBold
CenteredTextLabel.TextSize = 42
CenteredTextLabel.Parent = CenteredLabelGui

local StatsOverlayOn = false
local now = tick()
local n1 = 0
local n2 = 0
local n3 = 40

CoinCollected.OnClientEvent:Connect(function(p3, p4, p5)
	n1 += 1
	n2 = tonumber(p4) or n2
	n3 = tonumber(p5) or n3
end)
RunService.RenderStepped:Connect(function()
	local v45 = math.floor(n1 * 3600 / math.max(tick() - now, 1))

	CenteredTextLabel.Text = ("Coins Collected: %d/%d\nTotal Coins: %d\nCoins Per Hour: %d"):format(n2, n3, n1, v45)
	CenteredTextLabel.Visible = StatsOverlayOn
end)

local u46

local function v47()
	local v48 = v18()

	if not v48 then
		return
	end

	if Workspace:FindFirstChild("safespot") then
		v48.CFrame = CFrame.new(-106, 87.5, 2)
	else
		local Part = Instance.new("Part")

		Part.Name = "safespot"
		Part.Size = Vector3.new(25, 3, 25)
		Part.Position = Vector3.new(-106, 83, 2)
		Part.Parent = Workspace
		Part.Anchored = true
		Part.CanCollide = true
		Part.Transparency = 0
		task.wait()

		for i = 1, 3 do
			local v51 = v18()

			if not v51 then
				return
			end

			v51.CFrame = CFrame.new(-106, 87.5, 2)
			task.wait(0.1)
		end
	end
end

local t3 = {
	"sit",
	"ninja",
	"dab",
	"zen",
	"floss",
	"headless",
	"zombie",
	"wave",
	"cheer",
	"laugh"
}

local function v53(p6)
	ReplicatedStorage.Remotes.Misc.PlayEmote:Fire(p6)
end

task.spawn(function()
	while true do
		task.wait(1 / math.max(v38.Emotes.EmoteSpamSpeed, 1))

		if v38.Emotes.AutoPlayEmotes then
			v53(t3[math.random(1, #t3)])
		end
	end
end)

local function v54()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and Workspace:WaitForChild(player.Name, 0.01) then
			Workspace[player.Name]:Destroy()
		end
	end
end
local function v57()
	for _, child in pairs(Workspace:GetChildren()) do
		if child:IsA("Model") and child:FindFirstChild("CoinContainer") then
			for _, child2 in pairs(child:GetChildren()) do
				if child2.Name ~= "CoinContainer" then
					child2:Destroy()
				end
			end
		end
	end
end
local function v62()
	if not LocalPlayer.Character then
		return
	end

	for _, descendant in pairs(LocalPlayer.Character:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant.CanCollide then
			descendant.CanCollide = false
		end
	end
end

RunService.Stepped:Connect(function()
	local v65 = v16()

	if v38.Noclip and v65 and v65.Health > 0 and v18() then
		v62()
	end
end)

local AntiFlingConn

local function setAntiFling(on)
	if AntiFlingConn then
		AntiFlingConn:Disconnect()
		AntiFlingConn = nil
	end

	if on then
		AntiFlingConn = RunService.Heartbeat:Connect(function()
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					for _, descendant in ipairs(player.Character:GetDescendants()) do
						if descendant:IsA("BasePart") and not descendant.Anchored and descendant.Velocity.Magnitude > 100 then
							descendant.Velocity = Vector3.zero
							descendant.RotVelocity = Vector3.zero
							descendant.Anchored = true
							task.delay(0.5, function()
								if descendant and descendant.Anchored then
									descendant.Anchored = false
								end
							end)
						end
					end
				end
			end
		end)
	end
end

local function v66()
	local t4 = {}
	local ok, result = pcall(function()
		return require(ReplicatedStorage.Modules.InventoryModule).MyInventory.Data.Weapons
	end)

	if not ok or not result then
		return nil
	end

	for _, v in pairs(result) do
		for k in pairs(v) do
			table.insert(t4, k)
		end
	end

	if #t4 == 0 then
		return nil
	end

	return t4[math.random(1, #t4)]
end

RunService.Stepped:Connect(function()
	if v38.Emotes.AutoPlaySelectedEmote then
		v53(v38.Emotes.SelectedEmote)
	end

	if v38.ShuffleWeapons then
		local v73 = v66()

		if v73 then
			pcall(function()
				local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
				local Inventory = Remotes and Remotes:FindFirstChild("Inventory")
				local Equip = Inventory and Inventory:FindFirstChild("Equip")

				if Equip then
					Equip:FireServer(v73, "Weapons")
				end
			end)
		end
	end

	local Character = LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if not Character or not Humanoid or not (Humanoid.Health > 0) or not Character:FindFirstChild("HumanoidRootPart") then
		return
	end

	if v38.Sliders.Speed ~= Humanoid.WalkSpeed then
		Humanoid.WalkSpeed = v38.Sliders.Speed
	end

	if v38.Sliders.Jump ~= Humanoid.JumpPower then
		Humanoid.JumpPower = v38.Sliders.Jump
	end
end)
RunService.Stepped:Connect(function()
	if v38.CoinFarm2.Settings.DestroyPlayers then
		v54()
	end
end)
RunService.Heartbeat:Connect(function()
	if v38.CoinFarm2.Settings.DestroyMap then
		v57()
	end
end)

local function v134()
	for _, player in ipairs(Players:GetPlayers()) do
		if not player:FindFirstChild("Backpack") then
			continue
		end

		if player.Backpack:FindFirstChild("Knife") then
			return player
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if not player.Character then
			continue
		end

		if player.Character:FindFirstChild("Knife") then
			return player
		end
	end

	if u46 then
		for k, v in pairs(u46) do
			if v.Role ~= "Murderer" then
				continue
			end

			if Players:FindFirstChild(k) then
				return Players:FindFirstChild(k)
			end
		end
	end
end
local function v141()
	for _, player in ipairs(Players:GetPlayers()) do
		if not player:FindFirstChild("Backpack") then
			continue
		end

		if player.Backpack:FindFirstChild("Gun") then
			return player
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if not player.Character then
			continue
		end

		if player.Character:FindFirstChild("Gun") then
			return player
		end
	end

	if u46 then
		for k, v in pairs(u46) do
			if v.Role == "Sheriff" and Players:FindFirstChild(k) then
				return Players:FindFirstChild(k)
			end
		end
	end
end

local function v148()
	for _, child in ipairs(Workspace:GetChildren()) do
		if child.Name == "PlayerESP" then
			child:Destroy()
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			if not player.Character:FindFirstChild("PlayerESP") then
				local Highlight = Instance.new("Highlight", Workspace)

				Highlight.Name = "PlayerESP"
				Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				Highlight.Adornee = player.Character
				Highlight.FillColor = Color3.fromRGB(255, 255, 255)
				Highlight.FillTransparency = 0.5
				task.spawn(function()
					if player == v134() then
						Highlight.FillColor = Color3.fromRGB(255, 0, 0)
						Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
					elseif player == v141() then
						Highlight.FillColor = Color3.fromRGB(0, 150, 255)
						Highlight.OutlineColor = Color3.fromRGB(0, 150, 255)
					else
						Highlight.FillColor = Color3.fromRGB(0, 255, 0)
						Highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
					end

					if Highlight and player then
						Highlight.Adornee = player.Character or player.CharacterAdded:Wait()
					end
				end)
			end
		end
	end
end

local nameBillboards = {}

local function clearNameESP()
	for _, b in pairs(nameBillboards) do
		pcall(function()
			b:Destroy()
		end)
	end

	table.clear(nameBillboards)

	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")

			if hrp then
				local bb = hrp:FindFirstChild("ZenithNameESP")

				if bb then
					bb:Destroy()
				end
			end
		end
	end
end

local function updateNameESP()
	if not v38.ESP.NameESP then
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local role = "None"
			local alive = true

			if u46 and u46[player.Name] then
				role = u46[player.Name].Role or "None"
				alive = not u46[player.Name].Dead and not u46[player.Name].Killed
			end

			local color = Color3.fromRGB(0, 255, 0)

			if role == "Murderer" then
				color = Color3.fromRGB(255, 0, 0)
			elseif role == "Sheriff" then
				color = Color3.fromRGB(0, 150, 255)
			elseif role == "Hero" then
				color = Color3.fromRGB(255, 255, 0)
			end

			local hrp = player.Character.HumanoidRootPart

			if alive then
				local bb = hrp:FindFirstChild("ZenithNameESP")

				if not bb then
					bb = Instance.new("BillboardGui")
					bb.Name = "ZenithNameESP"
					bb.Adornee = hrp
					bb.AlwaysOnTop = true
					bb.Size = UDim2.new(0, 140, 0, 32)
					bb.StudsOffset = Vector3.new(0, 2.5, 0)
					bb.ResetOnSpawn = false

					local tl = Instance.new("TextLabel")
					tl.Name = "Label"
					tl.Size = UDim2.new(1, 0, 1, 0)
					tl.BackgroundTransparency = 1
					tl.Font = Enum.Font.GothamBold
					tl.TextSize = 14
					tl.TextStrokeTransparency = 0.4
					tl.TextStrokeColor3 = Color3.new(0, 0, 0)
					tl.Parent = bb
					bb.Parent = hrp
					nameBillboards[player] = bb
				end

				bb.Label.Text = player.Name .. " [" .. role .. "]"
				bb.Label.TextColor3 = color
			else
				local bb = hrp:FindFirstChild("ZenithNameESP")

				if bb then
					bb:Destroy()
				end
			end
		end
	end
end

RunService.Heartbeat:Connect(function()
	if v38.ESP.NameESP then
		updateNameESP()
	end
end)

local TracerLines = {}
local TracerOk = pcall(function()
	local l = Drawing.new("Line")
	l:Remove()
end)

local function updateTracers()
	if not TracerOk then
		return
	end

	local cam = Workspace.CurrentCamera

	if not cam then
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local line = TracerLines[player.Name]
			local show = false
			local toPos = nil
			local color = Color3.fromRGB(0, 255, 0)

			if v38.ESP.TracerESP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				local pos, onScreen = cam:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)

				if onScreen then
					local role = u46 and u46[player.Name] and u46[player.Name].Role or nil

					if role == "Murderer" then
						color = Color3.fromRGB(255, 0, 0)
					elseif role == "Sheriff" then
						color = Color3.fromRGB(0, 150, 255)
					elseif role == "Hero" then
						color = Color3.fromRGB(255, 255, 0)
					end

					toPos = Vector2.new(pos.X, pos.Y)
					show = true
				end
			end

			if show then
				if not line then
					line = Drawing.new("Line")
					line.Thickness = 1.5
					line.Transparency = 0.7
					TracerLines[player.Name] = line
				end

				line.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
				line.To = toPos
				line.Color = color
				line.Visible = true
			elseif line then
				line.Visible = false
			end
		end
	end
end

RunService.RenderStepped:Connect(function()
	if v38.ESP.TracerESP then
		updateTracers()
	elseif next(TracerLines) then
		for _, l in pairs(TracerLines) do
			l.Visible = false
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if TracerLines[player.Name] then
		pcall(function()
			TracerLines[player.Name]:Remove()
		end)
		TracerLines[player.Name] = nil
	end

	if nameBillboards[player] then
		pcall(function()
			nameBillboards[player]:Destroy()
		end)
		nameBillboards[player] = nil
	end
end)

local function v154()
	if not u46 then
		Notify("No data", "playerData has not loaded yet.", "Warning", 3)

		return
	end

	local t7 = {}

	for k, v in pairs(u46) do
		table.insert(t7, ("%s - %s"):format(k, tostring(v.Role)))
	end

	Notify("Roles", table.concat(t7, "\n"), "Info", 6)
end

local Highlight = Instance.new("Highlight")

Highlight.Name = "TrapESP"
Highlight.OutlineTransparency = 1
Highlight.FillColor = Color3.fromRGB(255, 0, 0)
Highlight.FillTransparency = 0.4
Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
Workspace.DescendantAdded:Connect(function(descendant)
	if v38.ESP.Traps and descendant.Name == "Trap" then
		if descendant.Parent:IsDescendantOf(Workspace) then
			descendant.Transparency = 0

			local clone = Highlight:Clone()

			clone.Parent = Workspace
			clone.Adornee = descendant
		end
	end

	if v38.ESP.DroppedGun and descendant.Name == "GunDrop" then
		local GunESP = Workspace:FindFirstChild("GunESP")

		if not GunESP then
			GunESP = Instance.new("Highlight", Workspace)
			GunESP.OutlineTransparency = 1
			GunESP.FillColor = Color3.fromRGB(255, 255, 0)
			GunESP.Name = "GunESP"
			GunESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		end

		GunESP.Adornee = descendant
		GunESP.Enabled = true

		if v38.Gameplay.AutoPickUpGun then
			task.wait(0.5)

			for i = 1, 5 do
				if pickupgun then
					pickupgun()
				end
			end
		end
	end
end)
Workspace.DescendantRemoving:Connect(function(descendant)
	if v38.ESP.DroppedGun and descendant.Name == "GunDrop" then
		local GunESP = Workspace:FindFirstChild("GunESP")

		if GunESP then
			GunESP:Destroy()
		end

		task.wait(0.6)

		if v38.ESP.Players then
			for _, child in ipairs(Workspace:GetChildren()) do
				if child:IsA("Highlight") then
					child:Destroy()
				end
			end

			v148()
		end
	end
end)

local Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 5)
local Gameplay = Remotes and (Remotes:FindFirstChild("Gameplay") or Remotes:WaitForChild("Gameplay", 5))
local PlayerDataChanged = Gameplay and Gameplay:WaitForChild("PlayerDataChanged", 5)

if PlayerDataChanged then
	PlayerDataChanged.OnClientEvent:Connect(function(p16)
		u46 = p16

		if v38.ESP.Players then
			v148()
		end
	end)
end

local function v168()
	local ok = not LocalPlayer.Character

	if not ok then
		ok = not LocalPlayer.Character:FindFirstChild("Knife")
	end

	if ok then
		if not LocalPlayer.Backpack:FindFirstChild("Knife") or not LocalPlayer.Character then
			return
		end

		local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")

		if Humanoid then
			Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Knife"))
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			if player.Character:FindFirstChild("HumanoidRootPart") then
				local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
				local HumanoidRootPart2 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

				HumanoidRootPart.Anchored = true
				HumanoidRootPart.CFrame = HumanoidRootPart2.CFrame + HumanoidRootPart2.CFrame.LookVector * 1
			end
		end
	end

	pcall(function()
		LocalPlayer.Character.Knife.Stab:FireServer("Slash")
	end)
end
local function v175()
	for _, child in ipairs(Workspace:GetChildren()) do
		if not child:FindFirstChild("CoinContainer") then
			continue
		end

		if child:FindFirstChild("Spawns") then
			return child
		end
	end
end

pickupgun = function()
	local v178 = v175()

	if not v178 then
		return
	end

	local GunDrop = v178:FindFirstChild("GunDrop")

	if not GunDrop then
		return
	end

	if v134() == LocalPlayer then
		return
	end

	if not LocalPlayer.Character then
		return
	end

	local pivot = LocalPlayer.Character:GetPivot()

	LocalPlayer.Character:MoveTo(GunDrop.Position)

	local Gun = LocalPlayer.Backpack:FindFirstChild("Gun")
	local now2 = tick()

	while not Gun and tick() - now2 < 2 do
		Gun = LocalPlayer.Backpack:FindFirstChild("Gun")
		task.wait()
	end

	LocalPlayer.Character:PivotTo(pivot)
end
Teleport_to_lobby = function()
	if Workspace:FindFirstChild("Lobby") then
		if LocalPlayer.Character then
			LocalPlayer.Character:MoveTo(Workspace.Lobby.WorldPivot.Position)
		end
	end
end
Teleport_to_map = function()
	if not v175() then
		return
	end

	local Spawns = v175():FindFirstChild("Spawns")

	if not Spawns then
		return
	end

	local children = Spawns:GetChildren()

	if #children > 0 and LocalPlayer.Character then
		LocalPlayer.Character:MoveTo(children[math.random(1, #children)].Position)
	end
end

local function v185()
	local GetSyncData = ReplicatedStorage:FindFirstChild("GetSyncData")

	if not GetSyncData then
		return
	end

	StarterGui:SetCore("SendNotification", {
		Title = "Server IS COOKED",
		Text = "look how ppl freezing mid air lmao",
		Duration = 5
	})

	local n4 = 0

	while true do
		for i = 1, 1 do
			task.spawn(GetSyncData.InvokeServer, GetSyncData)
		end

		n4 += 1

		if n4 ~= 3 then
			continue
		end

		n4 = 0
		task.wait()
	end
end

local function v189(p17)
	local u190 = false

	local function v191(p18)
		local v192 = p18:lower()

		if v192 == "all" or v192 == "others" then
			u190 = true

			return
		end

		if v192 == "random" then
			local players = Players:GetPlayers()
			local v194 = table.find(players, LocalPlayer)

			if v194 then
				table.remove(players, v194)
			end

			if #players == 0 then
				return
			end

			return players[math.random(#players)]
		end

		local players, v196 = Players:GetPlayers()

		for _, v in next, players, v196 do
			if v ~= LocalPlayer then
				if v.Name:lower():match("^" .. v192) then
					return v
				end

				if v.DisplayName:lower():match("^" .. v192) then
					return v
				end
			end
		end
	end
	local function v199(p19)
		local Character = LocalPlayer.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local RootPart = Humanoid and Humanoid.RootPart

		if not Character or not Humanoid or not RootPart then
			return
		end

		local Character2 = p19.Character

		if not Character2 then
			return
		end

		local Humanoid2 = Character2:FindFirstChildOfClass("Humanoid")
		local RootPart2 = Humanoid2 and Humanoid2.RootPart
		local Head = Character2:FindFirstChild("Head")

		if RootPart.Velocity.Magnitude < 50 then
			genv.OldPos = RootPart.CFrame
		end

		if Humanoid2 and Humanoid2.Sit and not u190 then
			return
		end

		if Head then
			Workspace.CurrentCamera.CameraSubject = Head
		elseif Humanoid2 and RootPart2 then
			Workspace.CurrentCamera.CameraSubject = Humanoid2
		end

		if not Character2:FindFirstChildWhichIsA("BasePart") then
			return
		end

		local function v207(p20, p21, p22)
			RootPart.CFrame = CFrame.new(p20.Position) * p21 * p22
			pcall(function()
				Character:SetPrimaryPartCFrame(CFrame.new(p20.Position) * p21 * p22)
			end)
			RootPart.Velocity = Vector3.new(90000000, 900000000, 90000000)
			RootPart.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
		end
		local function v208(p23)
			local now2 = tick()
			local n5 = 0

			while RootPart and Humanoid2 do
				if p23.Velocity.Magnitude < 50 then
					n5 += 100
					v207(p23, CFrame.new(0, 1.5, 0) + Humanoid2.MoveDirection * p23.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n5), 0, 0))
					task.wait()
					v207(p23, CFrame.new(0, -1.5, 0) + Humanoid2.MoveDirection * p23.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n5), 0, 0))
					task.wait()
					v207(p23, CFrame.new(2.25, 1.5, -2.25) + Humanoid2.MoveDirection * p23.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n5), 0, 0))
					task.wait()
					v207(p23, CFrame.new(-2.25, -1.5, 2.25) + Humanoid2.MoveDirection * p23.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n5), 0, 0))
					task.wait()
					v207(p23, CFrame.new(0, 1.5, 0) + Humanoid2.MoveDirection, CFrame.Angles(math.rad(n5), 0, 0))
					task.wait()
					v207(p23, CFrame.new(0, -1.5, 0) + Humanoid2.MoveDirection, CFrame.Angles(math.rad(n5), 0, 0))
					task.wait()
				else
					v207(p23, CFrame.new(0, 1.5, Humanoid2.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()
					v207(p23, CFrame.new(0, -1.5, -Humanoid2.WalkSpeed), CFrame.Angles(0, 0, 0))
					task.wait()
					v207(p23, CFrame.new(0, 1.5, Humanoid2.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					if RootPart2 then
						v207(p23, CFrame.new(0, 1.5, RootPart2.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
						v207(p23, CFrame.new(0, -1.5, -RootPart2.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
						task.wait()
						v207(p23, CFrame.new(0, 1.5, RootPart2.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
					end

					v207(p23, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()
					v207(p23, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
					task.wait()
					v207(p23, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
					task.wait()
					v207(p23, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
					task.wait()
				end

				if p23.Velocity.Magnitude > 500 or p23.Parent ~= p19.Character or p19.Parent ~= Players or Humanoid2.Sit or Humanoid.Health <= 0 or now2 + 2 < tick() then
					break
				end
			end
		end

		Workspace.FallenPartsDestroyHeight = (0/0)

		local BodyVelocity = Instance.new("BodyVelocity")

		BodyVelocity.Name = "EpixVel"
		BodyVelocity.Parent = RootPart
		BodyVelocity.Velocity = Vector3.new(900000000, 900000000, 900000000)
		BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

		if RootPart2 then
			v208(RootPart2)
		end

		if BodyVelocity and BodyVelocity.Parent then
			BodyVelocity:Destroy()
		end

		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

		if genv.OldPos and Humanoid.Health > 0 then
			RootPart.CFrame = genv.OldPos
		end
	end

	for _, v in ipairs(p17) do
		local v214 = v191(v)

		if v214 then
			v199(v214)
		end
	end

	if u190 then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				v199(player)
			end
		end
	end
end

task.spawn(function()
	while true do
		task.wait(2)

		if v38.AnnoyingStuff.Fling.LoopFlingAllPlayers then
			for _, player in ipairs(Players:GetPlayers()) do
				if player == LocalPlayer then
					continue
				end

				pcall(function()
					v189({ player.Name })
				end)
				task.wait(0.1)
			end
		end
	end
end)

local function v239()
	local t9 = {}

	pcall(function()
		local response = game:HttpGet(("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))
		local data = HttpService:JSONDecode(response)
		local data2 = data.data or {}

		for _, v in ipairs(data2) do
			if v.id ~= game.JobId and v.playing < v.maxPlayers then
				table.insert(t9, v.id)
			end
		end
	end)

	if #t9 ~= 0 then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, t9[math.random(1, #t9)])

		return
	end

	Notify("ServerHop", "No available servers found.", "Warning", 3)
end

Players.PlayerRemoving:Connect(function()
	task.defer(function()
		if v38.AutoFarm.AutoTeleportToRandomServerIfServerIsEmpty and v38.AutoFarm.PlayersToAutoServerHop > #Players:GetPlayers() then
			v239()
		end
	end)
end)
task.spawn(function()
	while true do
		task.wait(30)

		if v38.AutoFarm.AutoPrestige then
			pcall(function()
				ReplicatedStorage.Remotes.Inventory.Prestige:FireServer()
			end)
		end
	end
end)

RoundStart.OnClientEvent:Connect(function()
	if v38.AutoRevealRoles then
		v154()
	end

	if v38.AutoFarm.KillEveryoneAsAMurderer then
		task.wait(1)

		repeat
			v168()
			task.wait(1)
		until v134() ~= LocalPlayer
	end

	if v38.AutoFarm.AutoFlingMurderer then
		local v233 = v134()

		if v233 and v233 ~= LocalPlayer then
			v189({ v233.Name })
		end
	end

	if v38.AutoFarm.AutoFlingSheriff then
		local v234 = v141()

		if v234 and v234 ~= LocalPlayer then
			v189({ v234.Name })
		end
	end

	if v38.AutoFarm.TeleportSpawn then
		Teleport_to_lobby()
	end
end)

RunService.RenderStepped:Connect(function()
	if not (v141() == LocalPlayer and v38.Gameplay.AutoShooting) then
		return
	end

	local v219 = v134()

	if not v219 or not v219.Character then
		return
	end

	local HumanoidRootPart = v219.Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	if not LocalPlayer.Character then
		return
	end

	local HumanoidRootPart2 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart2 then
		return
	end

	local v222 = HumanoidRootPart.Position - HumanoidRootPart2.Position
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }

	local hit = Workspace:Raycast(HumanoidRootPart2.Position, v222, raycastParams)

	if not hit or hit.Instance.Parent == v219.Character then
		local Gun = LocalPlayer.Character:FindFirstChild("Gun")

		Gun = Gun or LocalPlayer.Backpack:FindFirstChild("Gun")

		if Gun then
			local v226 = v16()

			if v226 and Gun.Parent == LocalPlayer.Backpack then
				v226:EquipTool(Gun)
			end

			local v227 = v134()

			if not v227 or not v227.Character then
				return
			end

			local UpperTorso = v227.Character:FindFirstChild("UpperTorso")
			local Humanoid = v227.Character:FindFirstChild("Humanoid")

			if not UpperTorso or not Humanoid then
				return
			end

			local MoveDirection = Humanoid.MoveDirection
			local v231 = (UpperTorso.Position + UpperTorso.AssemblyLinearVelocity * Vector3.new(0, 0.5, 0) * 0.14 + MoveDirection * 2.8) * (LocalPlayer:GetNetworkPing() * 1000 * 0 + 1)

			pcall(function()
				local Gun2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")

				if Gun2 then
					Gun2.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, v231, "AH2")
				end
			end)
		end
	end
end)

local function v235()
	pcall(function()
		ReplicatedStorage.Remotes.Extras.GetPlayerData:InvokeServer("GetData")
	end)

	local EmoteModule = ReplicatedStorage.Modules:FindFirstChild("EmoteModule")
	local Emotes = LocalPlayer.PlayerGui.MainGUI.Game:FindFirstChild("Emotes")

	if not EmoteModule or not Emotes then
		return
	end

	local t8 = {
		"headless",
		"zombie",
		"zen",
		"ninja",
		"floss",
		"dab",
		"sit"
	}

	pcall(function()
		require(EmoteModule).GeneratePage(t8, Emotes, "Free Emotes")
	end)
	genv.FreeEmotesOperator = true

	while genv.FreeEmotesOperator do
		if not Emotes.EmotePages:FindFirstChild("Free Emotes") then
			genv.FreeEmotesOperator = false
			v235()
		end

		RunService.RenderStepped:Wait()
	end
end

local WallCheck = false

local function isVisible(targetChar, fromPart)
	if not targetChar or not fromPart then
		return false
	end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { LocalPlayer.Character }
	params.RespectCanCollide = true

	local points = {}

	for _, name in ipairs({ "HumanoidRootPart", "Head", "UpperTorso", "Torso" }) do
		local part = targetChar:FindFirstChild(name)

		if part then
			table.insert(points, part.Position)
		end
	end

	if #points == 0 and targetChar.PrimaryPart then
		table.insert(points, targetChar.PrimaryPart.Position)
	end

	for _, pos in ipairs(points) do
		local hit = Workspace:Raycast(fromPart.Position, pos - fromPart.Position, params)

		if not hit then
			return true
		end

		if hit.Instance:IsDescendantOf(targetChar) then
			return true
		end

		if hit.Instance.Transparency > 0.5 then
			return true
		end

		if hit.Instance.CanCollide == false then
			return true
		end
	end

	return false
end

local velTrack = {}

RunService.Heartbeat:Connect(function()
	local t = os.clock()

	for _, pl in ipairs(Players:GetPlayers()) do
		local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")

		if not hrp then
			velTrack[pl] = nil
		else
			local rec = velTrack[pl]

			if not rec then
				velTrack[pl] = {
					p = hrp.Position,
					t = t
				}
			elseif t - rec.t >= 0.03 then
				rec.v = (hrp.Position - rec.p) / (t - rec.t)
				rec.p = hrp.Position
				rec.t = t
			end
		end
	end
end)

local function leadTime()
	local ok, ping = pcall(function()
		return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
	end)
	local p = (ok and ping and ping > 0 and ping < 1) and ping or 0.04

	return math.clamp(p + 0.16, 0, 0.3)
end

local function aimAt(player, targetHRP)
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	local vel

	if hum and hum.MoveDirection.Magnitude > 0.1 then
		vel = hum.MoveDirection.Unit * hum.WalkSpeed
	else
		vel = targetHRP.AssemblyLinearVelocity

		if vel.Magnitude < 0.5 then
			local rec = velTrack[player]

			if rec and rec.v and rec.v.Magnitude >= 0.5 then
				vel = rec.v
			end
		end
	end

	if vel.Magnitude < 0.5 then
		return targetHRP.Position
	end

	local lt = leadTime()
	local aim = targetHRP.Position + Vector3.new(vel.X, 0, vel.Z) * lt
	local delta = aim - targetHRP.Position

	if delta.Magnitude > 8 then
		aim = targetHRP.Position + delta.Unit * 8
	end

	return aim
end

local function mouseAimPoint()
	local cam = Workspace.CurrentCamera

	if not cam then
		return nil
	end

	local ok, result = pcall(function()
		local loc = UserInputService:GetMouseLocation()
		local ray = cam:ViewportPointToRay(loc.X, loc.Y)
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { LocalPlayer.Character }
		local hit = Workspace:Raycast(ray.Origin, ray.Direction * 300, params)

		return hit and hit.Position or ray.Origin + ray.Direction * 300
	end)

	return ok and result or nil
end

local function nearestPlayer()
	local hrp = v18()

	if not hrp then
		return nil
	end

	local best, dist = nil, math.huge

	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= LocalPlayer and pl.Character then
			local h = pl.Character:FindFirstChild("HumanoidRootPart")

			if h then
				local mag = (hrp.Position - h.Position).Magnitude

				if mag < dist then
					dist = mag
					best = pl
				end
			end
		end
	end

	return best
end

local function equipKnifeFn()
	local char = LocalPlayer.Character

	if not char then
		return nil
	end

	local knife = char:FindFirstChild("Knife")

	if knife then
		return knife, char
	end

	local bp = LocalPlayer:FindFirstChild("Backpack")
	knife = bp and bp:FindFirstChild("Knife")

	local hum = char:FindFirstChildOfClass("Humanoid")

	if knife and hum then
		hum:EquipTool(knife)
		task.wait(0.1)
		char = LocalPlayer.Character

		return char and char:FindFirstChild("Knife"), char
	end

	return nil
end

local function getTargets(radius)
	local myHRP = v18()
	local list = {}

	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= LocalPlayer and pl.Character then
			local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
			local hum = pl.Character:FindFirstChildOfClass("Humanoid")

			if hrp and hum and hum.Health > 0 then
				local okR = true

				if radius and myHRP then
					okR = (hrp.Position - myHRP.Position).Magnitude <= radius
				end

				if okR then
					table.insert(list, pl)
				end
			end
		end
	end

	return list
end

local function stabPlayers(list, alreadyEquipped)
	local knife, char

	if alreadyEquipped then
		char = LocalPlayer.Character
		knife = char and char:FindFirstChild("Knife")
	else
		knife, char = equipKnifeFn()
	end

	if not knife or not char then
		return 0
	end

	local events = knife:FindFirstChild("Events")

	if not events then
		return 0
	end

	local stabbed = events:FindFirstChild("KnifeStabbed")
	local touched = events:FindFirstChild("HandleTouched")

	if not (stabbed and touched) then
		return 0
	end

	pcall(function()
		stabbed:FireServer()
	end)

	local n = 0

	for _, pl in ipairs(list) do
		local hrp = pl.Character and (pl.Character:FindFirstChild("HumanoidRootPart") or pl.Character:FindFirstChildWhichIsA("BasePart"))

		if hrp then
			pcall(function()
				touched:FireServer(hrp)
			end)

			n += 1
		end
	end

	return n
end

local function killAllFn()
	if v134() ~= LocalPlayer then
		Notify("Not Murderer!", "You don't have the knife.", "Warning", 2)

		return
	end

	local n = stabPlayers(getTargets(nil))

	Notify("Kill All", ("Stabbed %d player%s."):format(n, n == 1 and "" or "s"), "Success", 2)
end

local function killTargetFn(name)
	if not name or name == "" then
		Notify("No target", "Pick a player first.", "Warning", 2)

		return
	end

	if v134() ~= LocalPlayer then
		Notify("Not Murderer!", "You don't have the knife.", "Warning", 2)

		return
	end

	local pl = Players:FindFirstChild(name)

	if not pl then
		Notify("Gone", name .. " isn't in the server.", "Warning", 2)

		return
	end

	local n = stabPlayers({ pl })

	Notify(n > 0 and "Stabbed" or "Failed", n > 0 and ("Stabbed %s."):format(name) or ("Couldn't reach %s."):format(name), n > 0 and "Success" or "Danger", 2)
end

local function killSheriffFn()
	local sher = v141()

	if not sher then
		Notify("No Sheriff", "Nobody is holding the gun right now.", "Warning", 2)

		return
	end

	killTargetFn(sher.Name)
end

local shootBusy = false

local function shootMurdererFn()
	if shootBusy then
		Notify("Cooldown", "Shoot is on cooldown.", "Warning", 1.5)

		return 0
	end
	shootBusy = true

	task.spawn(function()
		task.wait(3.2)
		shootBusy = false
	end)

	if v141() ~= LocalPlayer then
		Notify("Not Sheriff!", "You don't have the gun.", "Warning", 2)

		return 3.2
	end

	local murd = v134()

	if not murd or not murd.Character then
		Notify("Error!", "No murderer this round!", "Warning", 2)

		return 3.2
	end

	local myHRP = v18()

	if not myHRP then
		return 3.2
	end

	if WallCheck and not isVisible(murd.Character, LocalPlayer.Character:FindFirstChild("RightHand") or myHRP) then
		Notify("Wall Detected!", "Murderer is behind a wall.", "Warning", 3)

		return 3.2
	end

	local gun = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")

	if not gun then
		local bp = LocalPlayer:FindFirstChild("Backpack")
		local g2 = bp and bp:FindFirstChild("Gun")

		if g2 and LocalPlayer.Character then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

			if hum then
				hum:EquipTool(g2)
				task.wait(0.1)
			end
		end

		gun = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")
	end

	if not gun then
		return 3.2
	end

	local shoot = gun:FindFirstChild("Shoot")

	if not shoot then
		return 3.2
	end

	local targetHRP = murd.Character:FindFirstChild("HumanoidRootPart")

	if not targetHRP then
		return 3.2
	end

	if (myHRP.Position - targetHRP.Position).Magnitude > 300 then
		Notify("Too Far!", "The gun only reaches 300 studs.", "Warning", 2)

		return 3.2
	end

	local attach = myHRP:FindFirstChild("GunRaycastAttachment")

	shoot:FireServer(attach and attach.WorldCFrame or CFrame.new(myHRP.Position), CFrame.new(aimAt(murd, targetHRP)))

	return 3.2
end

local throwBusy = false

local function predictedPos(player, divisor, mult)
	local char = player.Character

	if not char then
		return nil
	end

	local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")

	if not torso then
		return nil
	end

	local pos = torso.Position
	local vel = torso.AssemblyLinearVelocity or Vector3.zero
	local myHRP = v18()

	if not myHRP then
		return pos
	end

	local dist = (pos - myHRP.Position).Magnitude

	if dist < 1 then
		return pos
	end

	return pos + vel * math.min(dist / divisor * (mult or 1), 0.5)
end

local function throwKnifeFn()
	if throwBusy then
		Notify("Cooldown", "Throw is on cooldown.", "Warning", 1.5)

		return 0
	end
	throwBusy = true

	local function release(d)
		task.spawn(function()
			task.wait(d)
			throwBusy = false
		end)
	end

	if v134() ~= LocalPlayer then
		Notify("Not Murderer!", "You don't have the knife.", "Warning", 2)
		release(0.5)

		return 0.5
	end

	local target = nearestPlayer()

	if not target or not target.Character then
		Notify("Error!", "No one nearby to throw at.", "Warning", 2)
		release(0.5)

		return 0.5
	end

	local char = LocalPlayer.Character
	local rightHand = char and (char:FindFirstChild("RightHand") or char:FindFirstChild("HumanoidRootPart"))

	if not rightHand then
		release(0.5)

		return 0.5
	end

	if WallCheck and not isVisible(target.Character, rightHand) then
		Notify("Wall Detected!", target.Name .. " is behind a wall.", "Warning", 2)
		release(0.5)

		return 0.5
	end

	local knife = equipKnifeFn()

	if not knife then
		release(0.5)

		return 0.5
	end

	knife = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife")

	if not knife then
		release(0.5)

		return 0.5
	end

	local tpos = predictedPos(target, 600, 0.95)

	if not tpos then
		release(0.5)

		return 0.5
	end

	local throw = knife:FindFirstChild("Throw") or (knife:FindFirstChild("Events") and knife.Events:FindFirstChild("KnifeThrown"))
	local cd = 2

	if throw and throw:IsA("RemoteEvent") then
		throw:FireServer(CFrame.new(rightHand.Position), CFrame.new(tpos))

		pcall(function()
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			local animator = hum and hum:FindFirstChildOfClass("Animator")
			local anim = knife:FindFirstChild("ThrowKnife", true)

			if animator and anim then
				animator:LoadAnimation(anim):Play(0.1, 6, 1)
			end
		end)

		local speed = knife:GetAttribute("ThrowSpeed")
		cd = (type(speed) == "number" and speed > 0) and 2 * speed or 2
	else
		release(0.5)

		return 0.5
	end

	release(cd)

	return cd
end

local function disableToolActivation(toolName, store)
	for _, c in ipairs(store) do
		pcall(function()
			c:Enable()
		end)
	end

	table.clear(store)

	if not getconnections then
		return false
	end

	return pcall(function()
		local char = LocalPlayer.Character
		local tool = char and char:FindFirstChild(toolName)

		if not tool then
			return
		end

		for _, c in ipairs(getconnections(tool.Activated)) do
			c:Disable()
			table.insert(store, c)
		end
	end)
end

local SilentAim = {
	on = false,
	conn = nil,
	disabled = {},
	conns = {}
}

SilentAim.enable = function()
	if SilentAim.conn then
		return
	end

	disableToolActivation("Gun", SilentAim.disabled)

	if not getconnections then
		Notify("Silent Aim", "Your executor has no getconnections - the normal shot fires too.", "Warning", 4)
	end

	local function watchChar(char)
		if not char then
			return
		end

		table.insert(SilentAim.conns, char.ChildAdded:Connect(function(child)
			if child.Name == "Gun" and child:IsA("Tool") and SilentAim.on then
				task.wait(0.1)
				disableToolActivation("Gun", SilentAim.disabled)
			end
		end))
	end

	watchChar(LocalPlayer.Character)

	table.insert(SilentAim.conns, LocalPlayer.CharacterAdded:Connect(function(char)
		task.wait(1)

		if SilentAim.on then
			disableToolActivation("Gun", SilentAim.disabled)
		end

		watchChar(char)
	end))

	SilentAim.conn = LocalPlayer:GetMouse().Button1Down:Connect(function()
		if not SilentAim.on then
			return
		end

		local char = LocalPlayer.Character
		local gun = char and char:FindFirstChild("Gun")
		local shoot = gun and gun:FindFirstChild("Shoot")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		if not shoot or not hrp then
			return
		end

		local murd = v134()
		local targetPos = nil

		if murd and murd ~= LocalPlayer and murd.Character then
			local mhrp = murd.Character:FindFirstChild("HumanoidRootPart")

			if mhrp and (hrp.Position - mhrp.Position).Magnitude <= 300 then
				if WallCheck and not isVisible(murd.Character, hrp) then
					Notify("Wall Detected!", "Murderer is behind a wall.", "Warning", 2)
				else
					targetPos = aimAt(murd, mhrp)
				end
			end
		end

		targetPos = targetPos or mouseAimPoint()

		if not targetPos then
			return
		end

		local attach = hrp:FindFirstChild("GunRaycastAttachment")

		shoot:FireServer(attach and attach.WorldCFrame or CFrame.new(hrp.Position), CFrame.new(targetPos))
	end)
end

SilentAim.disable = function()
	if SilentAim.conn then
		pcall(function()
			SilentAim.conn:Disconnect()
		end)
		SilentAim.conn = nil
	end

	disableToolActivation("Gun", SilentAim.disabled)

	for _, c in ipairs(SilentAim.conns) do
		pcall(function()
			c:Disconnect()
		end)
	end

	table.clear(SilentAim.conns)
end

local Triggerbot = {
	enabled = false,
	conn = nil,
	delay = 0.18,
	fov = 60,
	last = 0
}

Triggerbot.start = function()
	if Triggerbot.conn then
		return
	end

	Triggerbot.conn = RunService.Heartbeat:Connect(function()
		if not Triggerbot.enabled then
			return
		end

		if tick() - Triggerbot.last < Triggerbot.delay then
			return
		end

		pcall(function()
			if v141() ~= LocalPlayer then
				return
			end

			local char = LocalPlayer.Character
			local gun = char and char:FindFirstChild("Gun")
			local shoot = gun and gun:FindFirstChild("Shoot")

			if not shoot then
				return
			end

			local murd = v134()

			if not murd or murd == LocalPlayer or not murd.Character then
				return
			end

			local mhrp = murd.Character:FindFirstChild("HumanoidRootPart")
			local hrp = char:FindFirstChild("HumanoidRootPart")

			if not mhrp or not hrp then
				return
			end

			local cam = Workspace.CurrentCamera
			local pos, onScreen = cam:WorldToViewportPoint(mhrp.Position)

			if not onScreen then
				return
			end

			local center = cam.ViewportSize / 2

			if (Vector2.new(pos.X, pos.Y) - center).Magnitude > Triggerbot.fov then
				return
			end

			if WallCheck and not isVisible(murd.Character, hrp) then
				return
			end

			if (hrp.Position - mhrp.Position).Magnitude > 300 then
				return
			end

			Triggerbot.last = tick()

			local attach = hrp:FindFirstChild("GunRaycastAttachment")

			shoot:FireServer(attach and attach.WorldCFrame or CFrame.new(hrp.Position), CFrame.new(aimAt(murd, mhrp)))
		end)
	end)
end

Triggerbot.stop = function()
	if Triggerbot.conn then
		pcall(function()
			Triggerbot.conn:Disconnect()
		end)
		Triggerbot.conn = nil
	end
end

local SilentThrow = {
	on = false,
	conn = nil,
	disabled = {},
	conns = {}
}

SilentThrow.enable = function()
	if SilentThrow.conn then
		return
	end

	disableToolActivation("Knife", SilentThrow.disabled)

	local function watchChar(char)
		if not char then
			return
		end

		table.insert(SilentThrow.conns, char.ChildAdded:Connect(function(child)
			if child.Name == "Knife" and child:IsA("Tool") and SilentThrow.on then
				task.wait(0.1)
				disableToolActivation("Knife", SilentThrow.disabled)
			end
		end))
	end

	watchChar(LocalPlayer.Character)

	table.insert(SilentThrow.conns, LocalPlayer.CharacterAdded:Connect(function(char)
		task.wait(1)

		if SilentThrow.on then
			disableToolActivation("Knife", SilentThrow.disabled)
		end

		watchChar(char)
	end))

	SilentThrow.conn = LocalPlayer:GetMouse().Button2Down:Connect(function()
		if not SilentThrow.on then
			return
		end

		if v134() ~= LocalPlayer then
			return
		end

		local target = nearestPlayer()

		if not target then
			return
		end

		local hrp = v18()

		if hrp and WallCheck and not isVisible(target.Character, hrp) then
			Notify("Wall Detected!", target.Name .. " is behind a wall.", "Warning", 2)

			return
		end

		throwKnifeFn()
	end)
end

SilentThrow.disable = function()
	if SilentThrow.conn then
		pcall(function()
			SilentThrow.conn:Disconnect()
		end)
		SilentThrow.conn = nil
	end

	disableToolActivation("Knife", SilentThrow.disabled)

	for _, c in ipairs(SilentThrow.conns) do
		pcall(function()
			c:Disconnect()
		end)
	end

	table.clear(SilentThrow.conns)
end

local Hitbox = {
	on = true,
	mult = 1,
	radius = 1.5,
	show = false,
	ball = nil,
	showConn = nil,
	thrownConn = nil,
	clickConn = nil
}

Hitbox.setMult = function(m)
	Hitbox.mult = m
	Hitbox.radius = 1.5 * (1 + (m - 1) * 0.1)

	if Hitbox.ball then
		Hitbox.ball.Size = Vector3.one * Hitbox.radius * 2
	end
end

Hitbox.hideBall = function()
	if Hitbox.showConn then
		pcall(function()
			Hitbox.showConn:Disconnect()
		end)
	end

	Hitbox.showConn = nil

	if Hitbox.ball then
		pcall(function()
			Hitbox.ball:Destroy()
		end)
	end

	Hitbox.ball = nil
end

Hitbox.showBall = function()
	Hitbox.hideBall()

	local part = Instance.new("Part")
	part.Name = "ZenithHitboxSphere"
	part.Shape = Enum.PartType.Ball
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255, 90, 90)
	part.Transparency = 0.88
	part.Size = Vector3.one * Hitbox.radius * 2
	part.Parent = Workspace.CurrentCamera
	Hitbox.ball = part

	Hitbox.showConn = RunService.RenderStepped:Connect(function()
		if not part.Parent then
			return
		end

		local char = LocalPlayer.Character

		if not char then
			return
		end

		local pos = nil
		local knife = char:FindFirstChild("Knife")
		local handle = knife and knife:FindFirstChild("Handle")

		if handle then
			pos = handle.Position
		end

		if not pos then
			local hrp = char:FindFirstChild("HumanoidRootPart")

			if hrp then
				pos = hrp.Position
			end
		end

		if pos then
			part.Size = Vector3.one * Hitbox.radius * 2
			part.CFrame = CFrame.new(pos)
		end
	end)
end

Hitbox.start = function()
	if Hitbox.clickConn then
		return
	end

	Hitbox.clickConn = LocalPlayer:GetMouse().Button1Down:Connect(function()
		if not Hitbox.on then
			return
		end

		if v134() ~= LocalPlayer then
			return
		end

		stabPlayers(getTargets(Hitbox.radius), true)
	end)

	Hitbox.thrownConn = CollectionService:GetInstanceAddedSignal("ThrowingKnife"):Connect(function(kn)
		task.spawn(function()
			local handleLink = kn:WaitForChild("HandleLink", 3)
			local tool = handleLink and handleLink.Value and handleLink.Value.Parent
			local char = LocalPlayer.Character

			if not (tool and char and tool:IsDescendantOf(char)) then
				return
			end

			local events = tool:FindFirstChild("Events")
			local stabbed = events and events:FindFirstChild("KnifeStabbed")
			local touched = events and events:FindFirstChild("HandleTouched")

			if not (stabbed and touched) then
				return
			end

			local hit = {}

			while kn.Parent and Hitbox.on do
				local pos = kn:IsA("BasePart") and kn.Position or (kn:IsA("Model") and kn:GetPivot().Position)

				if pos then
					for _, pl in ipairs(Players:GetPlayers()) do
						if pl ~= LocalPlayer and not hit[pl] and pl.Character then
							local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
							local hum = pl.Character:FindFirstChildOfClass("Humanoid")

							if hrp and hum and hum.Health > 0 and (hrp.Position - pos).Magnitude <= Hitbox.radius then
								hit[pl] = true

								pcall(function()
									stabbed:FireServer()
								end)

								pcall(function()
									touched:FireServer(hrp)
								end)
							end
						end
					end
				end

				task.wait(0.05)
			end
		end)
	end)
end

Hitbox.start()

local function hasGun()
	local char = LocalPlayer.Character

	return char ~= nil and char:FindFirstChild("Gun") ~= nil
end

local Aimbot = {
	on = false,
	conn = nil,
	smooth = 1
}

Aimbot.start = function()
	if Aimbot.conn then
		return
	end

	Aimbot.conn = RunService.RenderStepped:Connect(function()
		if not Aimbot.on then
			return
		end

		if not hasGun() then
			return
		end

		pcall(function()
			local murd = v134()

			if not murd or murd == LocalPlayer or not murd.Character then
				return
			end

			local part = murd.Character:FindFirstChild("UpperTorso") or murd.Character:FindFirstChild("HumanoidRootPart")

			if not part then
				return
			end

			local cam = Workspace.CurrentCamera

			if not cam then
				return
			end

			local hrp = v18()
			local dist = hrp and (hrp.Position - part.Position).Magnitude or 100
			local predicted = part.Position + (part.AssemblyLinearVelocity or Vector3.zero) * math.clamp(dist / 1200, 0.01, 0.3)

			cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, predicted), math.clamp(Aimbot.smooth, 0.01, 1))
		end)
	end)
end

Aimbot.stop = function()
	if Aimbot.conn then
		pcall(function()
			Aimbot.conn:Disconnect()
		end)
		Aimbot.conn = nil
	end
end

Aimbot.set = function(on)
	Aimbot.on = on

	if on then
		Aimbot.start()
	else
		Aimbot.stop()
	end
end

local XrayWas = {}
local XrayOn = false

local function setXray(on)
	XrayOn = on

	if on then
		for _, descendant in ipairs(Workspace:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.Transparency < 0.5 then
				local model = descendant:FindFirstAncestorWhichIsA("Model")

				if not (model and Players:GetPlayerFromCharacter(model)) then
					if XrayWas[descendant] == nil then
						XrayWas[descendant] = descendant.Transparency
					end

					descendant.Transparency = 0.5
				end
			end
		end
	else
		for part, t in pairs(XrayWas) do
			pcall(function()
				if part.Parent then
					part.Transparency = t
				end
			end)
		end

		XrayWas = {}
	end
end

local Fly = {
	on = false,
	speed = 50
}
local flyConn, flyBV, flyBG

local function flyStart()
	if flyConn then
		return
	end

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	if not hrp or not hum then
		return
	end

	flyBV = Instance.new("BodyVelocity")
	flyBV.Name = "ZenithFlyVel"
	flyBV.Velocity = Vector3.zero
	flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	flyBV.Parent = hrp
	flyBG = Instance.new("BodyGyro")
	flyBG.Name = "ZenithFlyGyro"
	flyBG.P = 90000
	flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyBG.CFrame = hrp.CFrame
	flyBG.Parent = hrp
	hum.PlatformStand = true

	flyConn = RunService.Heartbeat:Connect(function()
		local cam = Workspace.CurrentCamera

		if not cam then
			return
		end

		pcall(function()
			flyBG.CFrame = cam.CFrame
		end)

		local dir = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			dir = dir + cam.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			dir = dir - cam.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			dir = dir - cam.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			dir = dir + cam.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			dir = dir + Vector3.new(0, 1, 0)
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			dir = dir - Vector3.new(0, 1, 0)
		end

		if dir.Magnitude > 0 then
			flyBV.Velocity = dir.Unit * Fly.speed
		else
			flyBV.Velocity = Vector3.zero
		end
	end)
end

local function flyStop()
	if flyConn then
		pcall(function()
			flyConn:Disconnect()
		end)
		flyConn = nil
	end

	if flyBV then
		pcall(function()
			flyBV:Destroy()
		end)
		flyBV = nil
	end

	if flyBG then
		pcall(function()
			flyBG:Destroy()
		end)
		flyBG = nil
	end

	pcall(function()
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

		if hum then
			hum.PlatformStand = false
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)

	if Fly.on then
		flyStart()
	end
end)

local function flySet(on)
	Fly.on = on

	if on then
		flyStart()
	else
		flyStop()
	end
end

local BOMB_CD = 22
local bombLast = 0

local function doBombJump()
	local now = tick()

	if now - bombLast < BOMB_CD then
		return false, BOMB_CD - (now - bombLast)
	end

	local okResult = false

	pcall(function()
		local char = LocalPlayer.Character

		if not char then
			return
		end

		local hum = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")

		if not hum or not hrp then
			return
		end

		local oldTool = char:FindFirstChildOfClass("Tool")
		local bomb = char:FindFirstChild("FakeBomb")

		if not bomb then
			local bp = LocalPlayer:FindFirstChild("Backpack")
			local b2 = bp and bp:FindFirstChild("FakeBomb")

			if b2 then
				hum:EquipTool(b2)
				task.wait(0.1)
				bomb = char:FindFirstChild("FakeBomb")
			end
		end

		if not bomb then
			pcall(function()
				local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
				local Extras = Remotes and Remotes:FindFirstChild("Extras")
				local ReplicateToy = Extras and Extras:FindFirstChild("ReplicateToy")

				if ReplicateToy then
					ReplicateToy:InvokeServer("FakeBomb")
				end
			end)

			task.wait(0.15)
			bomb = char:FindFirstChild("FakeBomb")

			if not bomb then
				local bp = LocalPlayer:FindFirstChild("Backpack")

				if bp and bp:FindFirstChild("FakeBomb") then
					hum:EquipTool(bp.FakeBomb)
					task.wait(0.1)
					bomb = char:FindFirstChild("FakeBomb")
				end
			end
		end

		if not bomb then
			Notify("No Bomb", "Couldn't get the FakeBomb toy.", "Warning", 2)

			return
		end

		hum:ChangeState(Enum.HumanoidStateType.Jumping)
		task.wait(0.05)

		local remote = bomb:FindFirstChild("Remote")

		if remote then
			local pos = hrp.Position

			remote:FireServer(CFrame.new(pos.X, pos.Y - 3, pos.Z), 50)
			bombLast = tick()
			okResult = true
		end

		task.wait(0.1)
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
		task.wait(0.1)
		pcall(function()
			hum:UnequipTools()
		end)

		if oldTool and oldTool.Parent and oldTool ~= bomb then
			task.wait(0.1)
			pcall(function()
				hum:EquipTool(oldTool)
			end)
		end
	end)

	return okResult, 0
end

local wallHopBusy = false

local function doWallHop()
	if wallHopBusy then
		return
	end
	wallHopBusy = true

	task.spawn(function()
		local WALL_DIST = 4
		local PUSH = 14
		local COOLDOWN_T = 0.2

		local function findWall(char, hrp)
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = { char }

			for _, dir in ipairs({ hrp.CFrame.LookVector, hrp.CFrame.RightVector, -hrp.CFrame.RightVector }) do
				local hit = Workspace:Raycast(hrp.Position, dir * WALL_DIST, params)

				if hit and hit.Instance and hit.Instance.CanCollide then
					return hit
				end
			end

			return nil
		end

		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		if not hrp or not findWall(char, hrp) then
			Notify("No wall", "Stand next to a wall first.", "Warning", 1.5)
			wallHopBusy = false

			return
		end

		local char2 = LocalPlayer.Character
		local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
		local hum = char2 and char2:FindFirstChildOfClass("Humanoid")

		if hrp2 and hum then
			local hit = findWall(char2, hrp2)

			if hit then
				local away = hit.Normal
				local flat = Vector3.new(away.X, 0, away.Z)

				if flat.Magnitude >= 0.05 then
					local unit = flat.Unit

					local function push()
						pcall(function()
							hrp2.AssemblyLinearVelocity = Vector3.new(unit.X * PUSH, hrp2.AssemblyLinearVelocity.Y, unit.Z * PUSH)
						end)

						hum.Jump = true
						pcall(function()
							hum:ChangeState(Enum.HumanoidStateType.Jumping)
						end)
					end

					push()
					task.wait(0.12)

					if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
						RunService:BindToRenderStep("ZenithWallFlick", Enum.RenderPriority.Camera.Value + 1, function()
							pcall(function()
								hrp2.CFrame = CFrame.lookAt(hrp2.Position, hrp2.Position + unit) * CFrame.Angles(0, math.rad(60), 0)
							end)
						end)

						task.wait(0.08)
						pcall(function()
							RunService:UnbindFromRenderStep("ZenithWallFlick")
						end)
					else
						pcall(function()
							hrp2.CFrame = CFrame.lookAt(hrp2.Position, hrp2.Position + unit) * CFrame.Angles(0, math.rad(60), 0)
						end)

						task.wait(0.08)
					end

					push()
				end
			end
		end

		task.wait(COOLDOWN_T)
		wallHopBusy = false
	end)
end

local function grabGunOnce()
	local hrp = v18()

	if not hrp then
		return false
	end

	local drop = nil

	for _, d in ipairs(Workspace:GetDescendants()) do
		if d.Name == "GunDrop" and d.Parent then
			drop = d
			break
		end
	end

	if not drop then
		return false
	end

	local part = nil

	if drop:IsA("BasePart") and drop:FindFirstChild("TouchInterest") then
		part = drop
	end

	if not part then
		for _, d in ipairs(drop:GetDescendants()) do
			if d:IsA("BasePart") and d:FindFirstChild("TouchInterest") then
				part = d
				break
			end
		end
	end

	if not part and drop:IsA("BasePart") then
		part = drop
	end

	if not part then
		for _, d in ipairs(drop:GetDescendants()) do
			if d:IsA("BasePart") then
				part = d
				break
			end
		end
	end

	if not part then
		return false
	end

	for i = 1, 5 do
		pcall(function()
			firetouchinterest(hrp, part, 0)
			firetouchinterest(hrp, part, 1)
		end)

		task.wait(0.05)

		local char = LocalPlayer.Character
		local bp = LocalPlayer:FindFirstChildOfClass("Backpack")

		if (char and char:FindFirstChild("Gun")) or (bp and bp:FindFirstChild("Gun")) then
			return true
		end
	end

	local char = LocalPlayer.Character
	local bp = LocalPlayer:FindFirstChildOfClass("Backpack")

	return (char and char:FindFirstChild("Gun") ~= nil) or (bp and bp:FindFirstChild("Gun") ~= nil)
end

local AutoGrabConn

local function setAutoGrab(on)
	if AutoGrabConn then
		pcall(function()
			AutoGrabConn:Disconnect()
		end)
		AutoGrabConn = nil
	end

	if on then
		AutoGrabConn = RunService.Heartbeat:Connect(function()
			if not hasGun() then
				pcall(grabGunOnce)
				task.wait(0.2)
			end
		end)
	end
end

local Farm1 = {
	On = false,
	Speed = 23,
	AutoReset = true,
	KillAllFull = false,
	FlingWhenDone = false
}

local farmMap, farmTweenObj, farmTargetCoin = nil, nil, nil
local farmTargetTime = 0
local farmCoinFails, farmCoinSkips = {}, {}
local farmPhysConns = {}
local farmClipWas = {}
local sawCoins = false
local flingDoneFired = false
local killFired = false
local stuckCoin, stuckTime = nil, 0
local farmLoopRunning = false

local function farmFindMap()
	for _, child in ipairs(Workspace:GetChildren()) do
		if child:FindFirstChild("CoinContainer") or child:FindFirstChild("CoinAreas") then
			return child
		end
	end

	return nil
end

local function farmCoinSkip(coin)
	local t = farmCoinSkips[coin]

	if not t then
		return false
	end

	if t < tick() then
		farmCoinSkips[coin] = nil
		farmCoinFails[coin] = nil

		return false
	end

	return true
end

local function farmCoinFailed(coin)
	local n = (farmCoinFails[coin] or 0) + 1
	farmCoinFails[coin] = n

	if n >= 2 then
		farmCoinSkips[coin] = tick() + 20
	end
end

local function farmFindCoin(hrp)
	if not farmMap then
		return nil
	end

	local container = farmMap:FindFirstChild("CoinContainer")

	if not container then
		return nil
	end

	local best, dist = nil, math.huge

	for _, coin in ipairs(container:GetChildren()) do
		if coin.Name == "Coin_Server" and not coin:GetAttribute("Collected") and not farmCoinSkip(coin) then
			local mag = (hrp.Position - coin.Position).Magnitude

			if mag < dist then
				dist = mag
				best = coin
			end
		end
	end

	return best
end

local function farmRoundTime()
	local part = Workspace:FindFirstChild("RoundTimerPart")

	if part then
		return tonumber(part:GetAttribute("Time")) or 0
	end

	return 0
end

local function farmReadBag()
	local ok, result = pcall(function()
		local gui = LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
		local container = nil

		if gui and gui:FindFirstChild("Game") then
			local bags = gui.Game:FindFirstChild("CoinBags")
			container = bags and bags:FindFirstChild("Container")
		elseif gui and gui:FindFirstChild("Lobby") then
			local dock = gui.Lobby:FindFirstChild("Dock")
			local bags = dock and dock:FindFirstChild("CoinBags")
			container = bags and bags:FindFirstChild("Container")
		end

		if not container then
			return 0
		end

		local frame = nil

		for _, child in ipairs(container:GetChildren()) do
			if child:IsA("GuiObject") and child:FindFirstChild("CurrencyFrame") then
				if child.Visible then
					frame = child
					break
				elseif child.Name == "Coin" and not frame then
					frame = child
				end
			end
		end

		if not frame then
			return 0
		end

		local full = frame:FindFirstChild("Full")

		if full and full.Visible then
			return 999
		end

		local cf2 = frame:FindFirstChild("CurrencyFrame")
		local icon = cf2 and cf2:FindFirstChild("Icon")
		local coins = icon and icon:FindFirstChild("Coins")
		local txt = coins and coins.Text

		if txt then
			local lower = string.lower(txt)

			if lower:find("full") or lower:find("max") then
				return 999
			end

			return tonumber((txt:gsub(",", ""))) or 0
		end

		return 0
	end)

	if ok then
		return result
	end

	return 0
end

local function farmReclip()
	for part in pairs(farmClipWas) do
		pcall(function()
			if part.Parent then
				part.CanCollide = true
			end
		end)
	end

	table.clear(farmClipWas)
end

local function farmStopNoclip()
	for _, c in ipairs(farmPhysConns) do
		pcall(function()
			c:Disconnect()
		end)
	end

	table.clear(farmPhysConns)
	farmReclip()
end

local function farmStartNoclip()
	if #farmPhysConns > 0 then
		return
	end

	table.insert(farmPhysConns, RunService.Stepped:Connect(function()
		local char = LocalPlayer.Character

		if char then
			for _, d in ipairs(char:GetDescendants()) do
				if d:IsA("BasePart") and d.CanCollide then
					farmClipWas[d] = true
					d.CanCollide = false
				end
			end
		end
	end))
end

local function farmSetPhysics(on)
	local char = LocalPlayer.Character
	local torso = char and char:FindFirstChild("UpperTorso")

	if on then
		if not torso then
			return
		end

		if torso:FindFirstChild("ZenithFarmGyro") then
			return
		end

		local hrp = v18()
		local hum = v16()

		if not hrp or not hum then
			return
		end

		farmStartNoclip()

		local gyro = Instance.new("BodyGyro")
		gyro.Name = "ZenithFarmGyro"
		gyro.Parent = torso
		gyro.P = 90000
		gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		gyro.CFrame = CFrame.new(hrp.CFrame.X, hrp.CFrame.Y, hrp.CFrame.Z) * CFrame.Angles(math.rad(90), 0, math.rad(90))

		local vel = Instance.new("BodyVelocity")
		vel.Name = "ZenithFarmVel"
		vel.Parent = torso
		vel.Velocity = Vector3.zero
		vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

		hrp.CFrame = gyro.CFrame
		hum.PlatformStand = true
	else
		pcall(function()
			local c = LocalPlayer.Character
			local t = c and c:FindFirstChild("UpperTorso")

			if t then
				local g = t:FindFirstChild("ZenithFarmGyro")

				if g then
					g:Destroy()
				end

				local v2 = t:FindFirstChild("ZenithFarmVel")

				if v2 then
					v2:Destroy()
				end
			end

			local hum = c and c:FindFirstChildOfClass("Humanoid")

			if hum and hum.PlatformStand then
				hum.PlatformStand = false
			end
		end)

		farmStopNoclip()
	end
end

local function farmStopMove()
	if farmTweenObj then
		pcall(function()
			farmTweenObj:Cancel()
		end)
		farmTweenObj = nil
	end

	farmSetPhysics(false)
end

local function farmTeleportHome()
	local map = farmMap

	if not map then
		return
	end

	local spawns = map:FindFirstChild("Spawns")

	if not spawns then
		return
	end

	local spawnPart = nil

	for _, child in ipairs(spawns:GetChildren()) do
		if child:IsA("BasePart") and (child.Name == "Spawn" or child.Name == "PlayerSpawn" or child.Name == "SpawnLocation") then
			spawnPart = child
			break
		end
	end

	spawnPart = spawnPart or spawns:FindFirstChildWhichIsA("BasePart")

	if not spawnPart then
		return
	end

	local hrp = v18()

	if not hrp then
		return
	end

	pcall(function()
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

		if hum then
			hum.PlatformStand = false
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end)

	local cf = spawnPart.CFrame

	hrp.Velocity = Vector3.zero
	hrp.RotVelocity = Vector3.zero
	hrp.CFrame = CFrame.new(cf.X, cf.Y + spawnPart.Size.Y / 2 + 4, cf.Z)
end

local function farmHideUnderMap(hrp)
	local map = farmMap

	if not map then
		return false
	end

	local pos = nil
	local spawns = map:FindFirstChild("Spawns")

	if spawns then
		for _, child in ipairs(spawns:GetChildren()) do
			if child:IsA("BasePart") then
				pos = child.Position
				break
			end
		end
	end

	if not pos then
		local ok, pivot = pcall(function()
			return map:GetPivot()
		end)

		if ok and pivot then
			pos = pivot.Position
		end
	end

	if not pos then
		return false
	end

	farmSetPhysics(true)
	farmTargetCoin = nil

	if (hrp.Position - Vector3.new(pos.X, pos.Y - 15, pos.Z)).Magnitude > 5 then
		hrp.Velocity = Vector3.zero
		hrp.CFrame = CFrame.new(pos.X, pos.Y - 15, pos.Z)
	end

	return true
end

local function farmFinishFling()
	if not Farm1.FlingWhenDone or flingDoneFired then
		return
	end

	local murd = v134()

	if not murd or murd == LocalPlayer or not murd.Character then
		return
	end

	if farmReadBag() <= 0 then
		return
	end

	flingDoneFired = true

	task.spawn(function()
		if Farm1.AutoReset then
			Notify("Farm Done!", "Bag full. Resetting, then flinging " .. murd.Name .. "...", "Success", 3)

			local hum = v16()

			if hum and hum.Health > 0 then
				hum.Health = 0
			end

			local t0 = tick()

			repeat
				task.wait(0.2)
			until (v18() and v16() and v16().Health > 0) or tick() - t0 > 12

			task.wait(0.6)

			murd = v134()

			if not murd or murd == LocalPlayer or not murd.Character then
				return
			end
		else
			Notify("Farm Done!", "Bag full. Flinging " .. murd.Name .. "...", "Success", 2)
		end

		pcall(function()
			v189({ murd.Name })
		end)
	end)
end

local function farm1Tick()
	local hrp = v18()
	local hum = v16()
	local alive = hrp ~= nil and hum ~= nil and hum.Health > 0
	local map = farmFindMap()

	if map ~= farmMap then
		farmMap = map
		sawCoins = false
		flingDoneFired = false
		killFired = false
		farmCoinFails = {}
		farmCoinSkips = {}
	end

	local coin = (alive and hrp) and farmFindCoin(hrp) or nil

	if alive and map and not sawCoins and not coin then
		if farmHideUnderMap(hrp) then
			return
		end
	end

	local bag = farmReadBag()
	local maxBag = LocalPlayer:GetAttribute("Elite") and 50 or 40

	if farmRoundTime() > 0 then
		if bag >= maxBag then
			farmStopMove()
			farmFinishFling()

			if Farm1.KillAllFull and not killFired and v134() == LocalPlayer then
				killFired = true
				task.spawn(killAllFn)
			end
		elseif alive and LocalPlayer.Character then
			if coin then
				sawCoins = true

				if coin ~= farmTargetCoin or coin:GetAttribute("Collected") then
					farmTargetCoin = coin
					farmTargetTime = tick()

					if farmTweenObj then
						pcall(function()
							farmTweenObj:Cancel()
						end)
						farmTweenObj = nil
					end

					farmSetPhysics(true)

					local cf = coin.CFrame
					local t = (hrp.Position - coin.Position).Magnitude / math.max(Farm1.Speed, 1)

					if t > 15 then
						t = 3
					end

					if t < 0.05 then
						t = 0.05
					end

					hrp.Velocity = Vector3.zero

					farmTweenObj = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {
						CFrame = CFrame.new(cf.X, cf.Y - 3.5, cf.Z) * CFrame.Angles(math.rad(90), 0, math.rad(90))
					})

					farmTweenObj:Play()
					hrp.Velocity = Vector3.zero
				else
					local mag = (hrp.Position - coin.Position).Magnitude

					if mag <= 6 and not coin:GetAttribute("Collected") then
						coin.CFrame = CFrame.new(hrp.Position + Vector3.new(math.random(-80, 80) / 100, math.random(-50, 300) / 100, math.random(-80, 80) / 100))

						if stuckCoin == coin then
							if tick() - stuckTime > 2 then
								stuckCoin = nil
								farmTargetCoin = nil
							end
						else
							stuckCoin = coin
							stuckTime = tick()
						end
					elseif mag > 6 then
						if tick() - farmTargetTime > 4 then
							farmCoinFailed(coin)
							farmTargetCoin = nil
							stuckCoin = nil
						end
					end
				end
			elseif hrp then
				if sawCoins then
					farmStopMove()
					farmFinishFling()
				end
			end
		else
			farmStopMove()
		end
	else
		farmStopMove()
	end
end

local function farm1Start()
	if farmLoopRunning then
		return
	end

	farmLoopRunning = true

	task.spawn(function()
		while Farm1.On do
			task.wait(0.1)
			pcall(farm1Tick)
		end

		farmLoopRunning = false
		farmStopMove()
	end)
end

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)

	if not Farm1.On then
		farmStopMove()
	end
end)

local vector3 = Vector3.new(1, -100, 1)
local Part = Instance.new("Part", Workspace)

Part.Anchored = true
Part.Position = vector3
Part.Size = Vector3.new(100, 1.2, 100)

local u115 = false

local function v116()
	local v117 = v18()

	if v117 then
		v117.CFrame = CFrame.new(Part.Position + Vector3.new(math.random(-10, 5), 5, math.random(-10, 5)))
	end
end
local function v118(p12)
	local v119 = v18()

	if p12 and v119 then
		v119.CFrame = CFrame.new(p12.Position + Vector3.new(0, -6, 0))
	end
end
local function v120()
	for _, child in ipairs(Workspace:GetChildren()) do
		if child:FindFirstChild("CoinContainer") then
			return child
		end
	end
end

local u123

local function v124()
	if u123 then
		return
	end

	u123 = true
	u115 = false

	if v38.CoinFarm2.State then
		v116()
	end

	while not u115 do
		local v125 = v120()

		if not v125 then
			task.wait(1)

			if v38.CoinFarm2.State then
				continue
			end
		elseif v38.CoinFarm2.State then
			task.spawn(function()
				pcall(v57)
			end)

			local v126
			local huge = math.huge

			for _, child in ipairs(v125.CoinContainer:GetChildren()) do
				if child:FindFirstChild("TouchInterest") and child.Position.Y < huge then
					huge = child.Position.Y
					v126 = child
				end
			end

			local v130 = v126

			if not v130 then
				task.wait(0.1)

				continue
			end

			local u131 = false

			v118(v130)

			local connection2 = CoinCollected.OnClientEvent:Connect(function(p13, p14, p15)
				u131 = true

				if p14 == p15 then
					u115 = true
				end
			end)

			if u115 then
				connection2:Disconnect()

				break
			end

			while true do
				task.wait()
				task.spawn(function()
					local v133 = v18()

					if v133 then
						pcall(firetouchinterest, v133, v130, 0)
						pcall(firetouchinterest, v133, v130, 1)
					end
				end)
				task.wait()
				v62()
				v118(v130)

				if u131 then
					break
				elseif not v130:FindFirstChild("TouchInterest") then
					break
				end
			end

			connection2:Disconnect()
			v116()
			task.wait(2)

			continue
		end

		break
	end

	u123 = false
end

ReplicatedStorage.Remotes.Gameplay.RoundStart.OnClientEvent:Connect(function()
	task.spawn(v124)
end)
LocalPlayer.CharacterAdded:Connect(function()
	if v38.CoinFarm2.State then
		v116()
	end
end)

local u251
local u252
local u253
local s1 = "Supreme"
local u255 = false
local n6 = 6
local u257 = false

local function v258()
	pcall(function()
		if not isfolder("ValueData") then
			makefolder("ValueData")
		end
	end)

	if isfile and isfile("ValueData/mm2_values.json") then
		local ok, result = pcall(readfile, "ValueData/mm2_values.json")

		if ok and result ~= "" then
			local ok2, result2 = pcall(HttpService.JSONDecode, HttpService, result)

			if ok2 and result2 then
				if tick() - (result2._time or 0) < 3600 then
					return result2.data
				end
			end
		end
	end

	local ok, result = pcall(game.HttpGet, game, "https://api.project-reverse.org/valuables/get-game-valuables?game=mm2")

	if ok then
		local data = HttpService:JSONDecode(result)

		pcall(function()
			writefile("ValueData/mm2_values.json", HttpService:JSONEncode({
				data = data.data,
				_time = tick()
			}))
		end)

		return data.data
	end

	local ok2, result2 = pcall(function()
		return HttpService:JSONDecode(readfile("ValueData/mm2_values.json"))
	end)

	return ok2 and result2 and result2.data or {}
end
local function v268()
	local t10 = {}
	local v270 = v258() or {}

	for _, v in pairs(v270) do
		t10[v.name] = v.price
	end

	return t10
end
local function v273()
	local n7 = 0

	local function v275(p27, p28, p29)
		n7 += 1
		task.spawn(function()
			if not genv[p27] then
				local ok, result = pcall(game.HttpGet, game, p28)

				if not ok then
					result = ""
				end

				if p29 then
					result = result:split(p29)[1]
				end

				genv[p27] = result
			end

			n7 -= 1
		end)
	end

	n7 += 1
	task.spawn(function()
		if not genv.htmlparser then
			local ok, htmlparser = pcall(function()
				return loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/RBXL-HTML-Parser/refs/heads/master/html/init.lua"))()
			end)

			if ok then
				genv.htmlparser = htmlparser
			end
		end

		n7 -= 1
	end)
	v275("SupremeAncients", "https://supremevaluelist.com/mm2/ancients.html")
	v275("SupremeChromas", "https://supremevaluelist.com/mm2/chromas.html", "<div class=\"tierheading\" id=\"pets\">Pets</div>")
	v275("SupremeGodlies", "https://supremevaluelist.com/mm2/godlies.html")
	v275("SupremeUniques", "https://supremevaluelist.com/mm2/uniques.html", "<div class=\"tierheading\" id=\"special\">Special Tier</div>")
	v275("SupremeVintages", "https://supremevaluelist.com/mm2/vintages.html")
	v275("SupremeLegendarys", "https://supremevaluelist.com/mm2/legendaries.html", "<div class=\"tierheading\" id=\"tier2\">Tier 2</div>")

	local now2 = tick()

	while n7 > 0 do
		task.wait()

		if tick() - now2 > 30 then
			break
		end
	end

	if not genv.htmlparser then
		return {}
	end

	local v281 = (genv.SupremeAncients or "") .. (genv.SupremeChromas or "") .. (genv.SupremeGodlies or "") .. (genv.SupremeUniques or "") .. (genv.SupremeLegendarys or "") .. (genv.SupremeVintages or "")
	local ok, result = pcall(function()
		return genv.htmlparser.parse(v281)
	end)

	if not ok or not result then
		return {}
	end

	local t11 = {}
	local itemhead = result:select(".itemhead")
	local itembody = result:select(".itembody")

	for i = 1, math.min(#itemhead, #itembody) do
		local name = itemhead[i]:content():gsub("%s<img.+$", "")

		if string.find(name, "https://www.youtube.com/jdrbx") then
			name = "JD"
		end

		local t12 = {
			name = name
		}
		local itemvalue = itembody[i]:select(".itemvalue")

		if #itemvalue > 0 then
			t12.value = itemvalue[1]:content():gsub(",", "")
		end

		if not string.find(t12.name, "Nik's Scythe") then
			table.insert(t11, t12)
		end
	end

	local t13 = {}

	for _, v in pairs(t11) do
		t13[v.name] = {
			value = tonumber(v.value)
		}
	end

	local Item = require(ReplicatedStorage.Database.Sync.Item)
	local t14 = {}
	local t15 = {}

	for k, v in pairs(Item) do
		if v.Rarity == "Unique" or v.Rarity == "Godly" or v.Rarity == "Ancient" or v.Rarity == "Classic" or v.Rarity == "Legendary" then
			table.insert(t14, {
				name = k,
				rarity = v.Rarity,
				chroma = v.Chroma or false
			})
		end
	end

	for _, v in pairs(t14) do
		if not v.name then
			v.name = "???"
		end

		t15[v.name] = {
			rarity = v.rarity,
			chroma = v.chroma
		}
	end

	local t16 = {
		["Red Luger"] = "RedLuger",
		["Hallow's Blade"] = "HallowsBlade",
		["Flowerwood Gun"] = "FlowerwoodGun",
		["Battleaxe II"] = "BattleAxe2",
		["Rainbow Gun"] = "Rainbow_G",
		Waves = "Waves_K",
		["Orange Seer"] = "OrangeSeer",
		Icecracker = "Icecracker_K_2020",
		Soul = "WraithGun",
		["Arctic (Gun)"] = "Arctic_G_2022",
		["C. Elderwood Blade"] = "ElderwoodKnifeChroma",
		["Chroma Heat"] = "HeatChroma",
		["Santa's Spirit"] = "SantasSpirit",
		Spirit = "WraithKnife",
		["Vampire's Edge"] = "VampiresEdge",
		["Vampire's Axe"] = "VampireAxe",
		Evergun = "TreeGun2023",
		["Eternal III"] = "Eternal3",
		["Cotton Candy"] = "CottonCandy",
		["Chroma Gingerblade"] = "GingerbladeChroma",
		["Elderwood Revolver"] = "ElderwoodGun",
		["Chroma Tides"] = "TidesChroma",
		["Spectral (Knife)"] = "Spectral_K_2021",
		["Latte (Gun)"] = "Latte_G_2023",
		["Ginger (Gun)"] = "Ginger_G_2018",
		["Elderwood Blade"] = "ElderwoodKnife",
		["Chroma Seer"] = "SeerChroma",
		["Red Seer"] = "RedSeer",
		Ocean = "Ocean_G",
		["Chroma Evergreen"] = "TreeKnife2023Chroma",
		["Chroma Evergun"] = "TreeGun2023Chroma",
		["Chroma Bauble"] = "BaubleChroma",
		["Green Luger"] = "GreenLuger",
		Gingermint = "Gingermint_G",
		Phantom = "Phantom2022",
		["Chroma Boneblade"] = "BonebladeChroma",
		["Blue Seer"] = "BlueSeer",
		["Winter's Edge"] = "WintersEdge",
		["Chroma Lightbringer"] = "ChromaLightbringer",
		["Cavern (Gun)"] = "Cavern_G_2019",
		["Tree (Knife)"] = "Tree",
		["Tree (Gun)"] = "TreeGun",
		Rupture = "Bleed",
		Evergreen = "TreeKnife2023",
		["Ghost (Gun)"] = "GhostG2018",
		["Red Fire"] = "RedFire",
		["Blue Scratch"] = "ScratchBlue",
		Broken = "Broken_K_2023",
		["Chroma Deathshard"] = "DeathshardChroma",
		["Red Scratch"] = "Scratch",
		["Blue Elite"] = "EliteBlue",
		["Vampire (Knife)"] = "Vampire_K_2022",
		["Traveler (Gun)"] = "Traveler_G_2023",
		["Eternal II"] = "Eternal2",
		["C. Vampire's Gun"] = "VampireGunChroma",
		["Vampire (Gun)"] = "VampireGun",
		["Ice Dragon"] = "IceDragon",
		Icedriller = "Icedriller_G_2020",
		["Green Elite"] = "EliteGreen",
		["Swirly Gun"] = "SwirlyGun",
		["Cavern (Knife)"] = "Cavern_K_2019",
		Turkey = "Turkey2023",
		["C. Traveler's Gun"] = "TravelerGunChroma",
		["Santa's Magic"] = "SantasMagic",
		Sakura = "Sakura_K",
		["Chroma Saw"] = "SawChroma",
		["Traveler's Gun"] = "TravelerGun",
		["Latte (Knife)"] = "Latte_K_2023",
		Australis = "AuroraKnife",
		["Chroma Swirly Gun"] = "SwirlyGunChroma",
		["Chroma Gemstone"] = "GemstoneChroma",
		Corrupt = "Sorry",
		["Old Glory"] = "AmericaSword",
		["Chroma Fang"] = "FangChroma",
		Pearl = "Pearl_K",
		["Ginger Luger"] = "GingerLuger",
		["Eternal IV"] = "Eternal4",
		["Ghost (Knife)"] = "GhostK2018",
		["Chroma Darkbringer"] = "ChromaDarkbringer",
		["Traveler's Axe"] = "TravelerAxe",
		["Chroma Luger"] = "LugerChroma",
		["Ice Shard"] = "IceShard",
		Battleaxe = "BattleAxe",
		Borealis = "AuroraGun",
		Flowerwood = "FlowerwoodKnife",
		Cookiecane = "Gingermint_K",
		["Hallow's Edge"] = "Hallow",
		["Aurora (Gun)"] = "Aurora_G_2021",
		["Frostfade (Knife)"] = "Frostfade_K_2023",
		Batwing = "Scythe",
		Blossom = "Blossom_G",
		["Chroma Shark"] = "SharkChroma",
		["Chroma Candleflame"] = "CandleflameChroma",
		["Yellow Seer"] = "YellowSeer",
		Bat = "ZombieBat",
		["C. Constellation"] = "ConstellationChroma",
		["Purple Seer"] = "PurpleSeer",
		["Chroma Slasher"] = "SlasherChroma",
		Beach = "Beach_K_2023",
		["Elderwood Scythe"] = "ElderwoodScythe",
		Eternalcane = "EternalCane",
		["Chroma Laser"] = "LaserChroma",
		Pearlshine = "Pearl_G",
		["Chroma Cookiecane"] = "Gingermint_KChroma",
		["Swirly Blade"] = "SwirlyBlade",
		Spectre = "Spectre2022",
		["Vampire's Gun"] = "VampireGun",
		Rainbow = "Rainbow_K",
		["Chroma Watergun"] = "WatergunChroma",
		["Swirly Axe"] = "SwirlyAxe",
		Splitter = "Knife1",
		Ghost = "GhostKnife",
		Blood = "BloodKnife",
		Shadow = "ShadowKnife"
	}
	local t17 = {}

	for k, v in pairs(t13) do
		if t15[k] then
			t17[k] = v
		elseif t15[t16[k] or ""] then
			t17[t16[k]] = v
		end
	end

	local t18 = {}

	for k, v in pairs(t17) do
		t18[k] = v.value
	end

	return t18
end

task.spawn(function()
	u252 = v273() or {}
	u253 = v268()
	u251 = u252
end)

local function v308()
	u251 = s1 == "USD" and (u253 or {}) or u252 or {}
end

local MainGUI = LocalPlayer.PlayerGui:WaitForChild("MainGUI", 9e9)
local v310 = false

if MainGUI:FindFirstChild("Lobby") then
	if MainGUI.Lobby:FindFirstChild("LeaderBar") then
		v310 = true
	end
end

local function createTextLabel(p30)
	local TextLabel = Instance.new("TextLabel")

	TextLabel.Position = UDim2.new(0, 0, 0, 0)
	TextLabel.Size = UDim2.new(1, 0, 0.3, 0)
	TextLabel.TextScaled = true
	TextLabel.TextWrapped = true
	TextLabel.TextSize = 14
	TextLabel.TextStrokeTransparency = 0.7
	TextLabel.ZIndex = 10
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Name = "Value"
	TextLabel.Parent = p30

	return TextLabel
end
local function v313(p31)
	pcall(function()
		local Trade = ReplicatedStorage:FindFirstChild("Trade")
		local OfferItem = Trade and Trade:FindFirstChild("OfferItem")

		if OfferItem then
			OfferItem:FireServer(p31, "Weapons")
		end
	end)
end
local function v316(p32)
	pcall(function()
		local Trade = ReplicatedStorage:FindFirstChild("Trade")
		local RemoveOffer = Trade and Trade:FindFirstChild("RemoveOffer")

		if RemoveOffer then
			RemoveOffer:FireServer(p32, "Weapons")
		end
	end)
end
local function v319(p33)
	for _, v in pairs(p33) do
		local n8 = 1
		local v323 = v[2] or 1

		for i = n8, v323 do
			v316(v[1])
		end
	end
end
local function v325(p34)
	v308()

	local t19 = {}
	local ok, result = pcall(function()
		return ReplicatedStorage.Remotes.Extras.GetFullInventory:InvokeServer(p34).Weapons.Owned
	end)

	if not ok or not result then
		return t19
	end

	for k, v in pairs(result) do
		if u251[k] and u251[k] > 0 then
			t19[k] = {
				value = u251[k],
				quantity = v
			}
		end
	end

	return t19
end
local function v331(p35, p36, p37)
	if not p35 or p35 <= 0 then
		return {}, 0
	end

	local v332 = p35 * (1 - p37 / 100)
	local t20 = {}

	for k, v in pairs(p36) do
		for i = 1, v.quantity do
			table.insert(t20, {
				name = k,
				value = v.value
			})
		end
	end

	table.sort(t20, function(p38, p39)
		return p38.value > p39.value
	end)

	return (function(p40, p41, p42)
		local t21 = {}

		for i = 0, #p40 do
			t21[i] = {}

			for i2 = 0, p41 do
				t21[i][i2] = 0
			end
		end

		for i = 1, #p40 do
			for i2 = 0, p41 do
				t21[i][i2] = t21[i - 1][i2]

				if i2 > 0 and t21[i - 1][i2 - 1] + p40[i].value <= p42 then
					t21[i][i2] = math.max(t21[i][i2], t21[i - 1][i2 - 1] + p40[i].value)
				end
			end
		end

		local t22 = {}
		local v343 = p41

		for i = #p40, 1, -1 do
			if t21[i][v343] ~= t21[i - 1][v343] then
				table.insert(t22, p40[i].name)
				v343 -= 1
			end
		end

		return t22, t21[#p40][p41]
	end)(t20, 4, v332)
end

local u345
local Title
local Title2
local Offer
local u349
local n9
local n10
local Player2
local u353
local connection2
local u355

local function v356()
	local v357 = v310 and "TradeGUI_Phone" or "TradeGUI"
	local v358 = LocalPlayer.PlayerGui:FindFirstChild(v357) or LocalPlayer.PlayerGui:WaitForChild(v357, 5)
	local Container = v358 and v358:FindFirstChild("Container")

	return Container and Container:FindFirstChild("Trade")
end
local function v360(p43, p44)
	v308()

	if not p44 or not p43 then
		return
	end

	n9 = 0
	n10 = 0

	for k, v in pairs(p43) do
		local v363 = v[1]
		local v364 = v[2]
		local Container = u345.TheirOffer.Container["NewItem" .. k].Container

		if Container:FindFirstChild("Value") then
			Container.Value:Destroy()
		end

		createTextLabel(Container).Text = "Value: " .. (u251[v363] or 0) * v364

		if u251[v363] then
			n9 += (u251[v363] or 0) * v364
		end
	end

	for k, v in pairs(p44) do
		local v368 = v[1]
		local v369 = v[2]
		local Container = u345.YourOffer.Container["NewItem" .. k].Container

		if Container:FindFirstChild("Value") then
			Container.Value:Destroy()
		end

		createTextLabel(Container).Text = "Value: " .. (u251[v368] or 0) * v369

		if Container:FindFirstChild("Amount") then
			Container.Amount.Position = UDim2.new(0.23, -4, 0.76, 0)
		end

		if u251[v368] then
			n10 += (u251[v368] or 0) * v369
		end
	end

	Title.Text = "YOUR OFFER | TOTAL:" .. n10
	Title2.Text = "THEIR OFFER | TOTAL:" .. n9
end
local function v371()
	n9 = 0
	n10 = 0
	pcall(function()
		u345 = v356()
	end)

	if not u345 then
		return
	end

	for _, v in ipairs({
		u345.TheirOffer.Container,
		u345.YourOffer.Container
	}) do
		for _, child in pairs(v:GetChildren()) do
			if child.ClassName == "Frame" and child:FindFirstChild("Container") then
				if child.Container:FindFirstChild("Value") then
					child.Container.Value:Destroy()
				end
			end
		end
	end

	if Title then
		Title.Text = "YOUR OFFER"
	end

	if Title2 then
		Title2.Text = "THEIR OFFER"
	end
end

ReplicatedStorage.Trade.UpdateTrade.OnClientEvent:Connect(function(p45)
	if p45.Player2.Player == LocalPlayer then
		local Player1 = p45.Player1

		Player2 = p45.Player2
		u353 = Player1
	end

	if p45.Player1.Player == LocalPlayer then
		local Player22 = p45.Player2

		Player2 = p45.Player1
		u353 = Player22
	end

	if not Player2 or not u353 then
		return
	end

	local Offer2 = Player2.Offer

	Offer = u353.Offer
	u349 = Offer2
	pcall(function()
		u345 = v356()
	end)

	if not u345 then
		return
	end

	Title = u345.YourOffer.Title
	Title2 = u345.TheirOffer.Title
	n9 = 0
	n10 = 0

	if u255 then
		pcall(v360, Offer, u349)
	end
end)

local function v379()
	u355 = v325(LocalPlayer.Name)

	if connection2 then
		return connection2
	end

	connection2 = ReplicatedStorage.Trade.UpdateTrade.OnClientEvent:Connect(function(p46)
		if p46.Player2.Player == LocalPlayer then
			local Player1 = p46.Player1

			Player2 = p46.Player2
			u353 = Player1
		end

		if p46.Player1.Player == LocalPlayer then
			local Player22 = p46.Player2

			Player2 = p46.Player1
			u353 = Player22
		end

		if not Player2 or not u353 then
			return
		end

		local Offer2 = Player2.Offer

		Offer = u353.Offer
		u349 = Offer2
		pcall(function()
			u345 = v356()
		end)

		if not u345 then
			return
		end

		local Title3 = u345.TheirOffer.Title

		Title = u345.YourOffer.Title
		Title2 = Title3
		n9 = 0
		n10 = 0

		for _, v in pairs(Offer) do
			if u251[v[1]] then
				n9 += (u251[v[1]] or 0) * v[2]
			end
		end

		for _, v in pairs(u349) do
			if u251[v[1]] then
				n10 += (u251[v[1]] or 0) * v[2]
			end
		end

		if u257 then
			if #Offer == 0 then
				v319(u349)

				return
			end

			local v388, v389 = v331(n9, u355, n6)

			if v389 ~= n10 then
				connection2:Disconnect()
				connection2 = nil
				v319(u349)

				for _, v in pairs(v388) do
					v313(v)
				end

				connection2 = v379()
			end
		end
	end)

	return connection2
end

ReplicatedStorage.Trade.StartTrade.OnClientEvent:Connect(function()
	pcall(function()
		u345 = v356()
	end)

	if not u345 then
		return
	end

	local Title3 = u345.TheirOffer.Title

	Title = u345.YourOffer.Title
	Title2 = Title3

	if u255 then
		Title.Text = "YOUR OFFER | TOTAL: 0"
		Title2.Text = "THEIR OFFER | TOTAL: 0"
	end

	connection2 = v379()
end)
ReplicatedStorage.Trade.EndTrade.OnClientEvent:Connect(function()
	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end
end)
ReplicatedStorage.Trade.AcceptTrade.OnClientEvent:Connect(function()
	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if u257 and n9 then
		local v393, v394 = v331(n9, u355 or {}, n6)

		if v394 ~= n10 and u349 then
			for _, v in pairs(u349) do
				for i = 1, v[2] do
					v316(v[1])
				end
			end

			for _, v in pairs(v393) do
				v313(v)
			end

			connection2 = v379()
		end
	end
end)

local function v400()
	local v401, v402 = v331(n9 or 0, u355 or {}, n6)

	if v402 ~= n10 and u349 then
		for _, v in pairs(u349) do
			for i = 1, v[2] do
				v316(v[1])
			end
		end

		for _, v in pairs(v401) do
			v313(v)
		end
	end
end
local function v408()
	if not u349 then
		return
	end

	for _, v in pairs(u349) do
		for i = 1, v[2] do
			v316(v[1])
		end
	end
end
local function v412(p47)
	local response = ReplicatedStorage.Remotes.Extras.GetFullInventory:InvokeServer(p47)
	local t23 = {}
	local Owned = (response.Weapons or {}).Owned or {}

	for k, v in pairs(Owned) do
		t23[k] = (t23[k] or 0) + v
	end

	local Owned2 = (response.Pets or {}).Owned or {}

	for k, v in pairs(Owned2) do
		t23[k] = (t23[k] or 0) + v
	end

	return t23
end
local function v421(p48)
	local v422 = v412(p48)
	local v423 = v268()
	local t24 = {}
	local n11 = 0
	local n12 = 0

	for k, v in pairs(v422) do
		local v429 = v423[k] or 0

		if v429 > 0 then
			local v430 = v429 * v

			table.insert(t24, {
				name = k,
				count = v,
				price = v429,
				total = v430
			})
			n11 += v430
			n12 += v
		end
	end

	table.sort(t24, function(p49, p50)
		return p49.total > p50.total
	end)

	local t25 = {
		"Inventory Analysis:",
		string.rep("-", 40)
	}

	for _, v in ipairs(t24) do
		table.insert(t25, string.format("%-20s x%-4d | $%8.2f | $%10.2f", v.name, v.count, v.price, v.total))
	end

	table.insert(t25, string.rep("-", 40))
	table.insert(t25, string.format("Total Items: %d", n12))
	table.insert(t25, string.format("Total Value: $%d", math.floor(n11)))

	return table.concat(t25, "\n")
end

local v434 = ReplicatedStorage
local ChangeInventoryItem = v434.Remotes.Inventory.ChangeInventoryItem
local ItemGift = v434:FindFirstChild("ItemGift")

local function v437(p51, p52)
	local ok, result = pcall(require, p51)

	if ok then
		if result ~= nil then
			return result
		end
	end

	return p52
end

local v440 = v437(v434.Modules:FindFirstChild("BoxModule"), {})
local v441 = v437(v434.Database.Sync:FindFirstChild("Item"), {})
local v442 = v437(v434.Modules:FindFirstChild("ProfileData"), {
	Weapons = {
		Owned = {}
	}
})

_G.Cache = _G.Cache or {}
_G.SmallCache = _G.SmallCache or {}

local ItemModule

pcall(function()
	ItemModule = require(v434.Modules.ItemModule)
end)

local t26 = {}
local Owned = (v442.Weapons or {}).Owned or {}

for k, v in pairs(Owned) do
	t26[k] = v
end

local function v448(p53)
	return t26[p53] or 0
end
local function v449(p54, p55)
	if not p54 or p54 == "" then
		return
	end

	local v450 = v448(p54) + p55

	t26[p54] = v450
	pcall(function()
		firesignal(ChangeInventoryItem.OnClientEvent, "Weapons", p54, v450)
	end)

	if ItemGift then
		pcall(function()
			firesignal(ItemGift.OnClientEvent, p54, "Weapons", p55)
		end)
	end
end

local t27 = {
	Common = Color3.fromRGB(134, 142, 150),
	Uncommon = Color3.fromRGB(64, 192, 87),
	Rare = Color3.fromRGB(51, 154, 240),
	Legendary = Color3.fromRGB(250, 176, 5),
	Godly = Color3.fromRGB(190, 75, 219),
	Ancient = Color3.fromRGB(255, 107, 107),
	Unique = Color3.fromRGB(255, 212, 59),
	Classic = Color3.fromRGB(255, 146, 43),
	Vintage = Color3.fromRGB(173, 181, 189),
	Christmas = Color3.fromRGB(32, 201, 151),
	Halloween = Color3.fromRGB(252, 126, 20)
}
local t28 = {
	Unique = 1,
	Ancient = 2,
	Godly = 3,
	Classic = 4,
	Vintage = 5,
	Legendary = 6,
	Rare = 7,
	Uncommon = 8,
	Common = 9
}

local function v453(p56, p57)
	if (p56 == nil or p56 == "") and p57 then
		p56 = tostring(p57)
	end

	if p56 ~= nil then
		if p56 ~= "" then
			if type(p56) == "string" and (string.find(p56, "rbxassetid://", 1, true) == 1 or string.find(p56, "rbxthumb://", 1, true) == 1) then
				return p56
			end

			if ItemModule and type(ItemModule.GetImage) == "function" then
				local ok, result = pcall(function()
					return ItemModule.GetImage(p56)
				end)

				if ok and type(result) == "string" and result ~= "" then
					return result
				end
			end

			if tonumber(p56) then
				return "http://www.roblox.com/Thumbs/Asset.ashx?format=png&width=250&height=250&assetId=" .. tostring(p56) .. "&bust=" .. tostring(math.random(1, 10000))
			end

			if type(p56) ~= "string" then
				return nil
			end

			if not string.find(p56, "roblox.com/Thumbs/Asset.ashx", 1, true) or string.find(p56, "&bust=", 1, true) then
				return p56
			end

			return p56 .. "&bust=" .. tostring(math.random(1, 10000))
		end
	end

	return nil
end
local function v456(p58)
	local ItemType = p58 and p58.ItemType

	return ItemType == nil or ItemType == "Knife" or ItemType == "Gun"
end
local function v458()
	local t29 = {}

	for k, v in pairs(v441) do
		if type(v) == "table" then
			if v456(v) then
				local ItemName = v.ItemName or k
				local Rarity = v.Rarity or "Unknown"

				table.insert(t29, {
					Id = k,
					Name = ItemName,
					Subtitle = (v.ItemType or "Weapon") .. " / " .. k,
					Badge = Rarity,
					BadgeColor = t27[Rarity],
					Image = v453(v.Image, v.ItemID),
					_SortName = string.lower(ItemName),
					_SortRarity = t28[Rarity] or 99
				})
			end
		end
	end

	table.sort(t29, function(p59, p60)
		if p59._SortRarity == p60._SortRarity then
			return p59._SortName < p60._SortName
		end

		return p59._SortRarity < p60._SortRarity
	end)

	return t29
end

local v464 = v458()
local tItemNames = {}
local tNameToId = {}

for _, v in ipairs(v464) do
	table.insert(tItemNames, v.Name)
	tNameToId[v.Name] = v.Id
end

local function v465()
	local v466 = v437(v434.Database.Sync:FindFirstChild("MysteryBox"), {})

	if not v466 or next(v466) == nil then
		return nil
	end

	local t30 = {}

	for k in pairs(v466) do
		table.insert(t30, k)
	end

	return t30[math.random(1, #t30)]
end
local function v469(p61)
	if not p61 or p61 == "" then
		return
	end

	pcall(function()
		v440.OpenBox(v465(), p61)
	end)
	v449(p61, 1)
end

task.spawn(function()
	while true do
		task.wait(0.5)

		if v38.AutoOpenCrates.State then
			if not v38.AutoOpenCrates.Crate then
				continue
			end

			pcall(function()
				ReplicatedStorage.Remotes.MysteryBox.OpenBox:FireServer(unpack({
					"OpenBox",
					v38.AutoOpenCrates.Crate,
					v38.AutoOpenCrates.CrateType
				}))
			end)
		end
	end
end)
game:GetService("Lighting").ChildAdded:Connect(function(child)
	if child.Name == "DepthOfField" then
		child.InFocusRadius = 500
		child:Destroy()
	end
end)

local function v471(p62, p63, p64)
	return math.max(p63, math.min(p64, p62))
end

local PerfOverlay

local function setPerfOverlay(on)
	if on and not PerfOverlay then
		local gui = Instance.new("ScreenGui")
		gui.Name = "ZenithPerf"
		gui.ResetOnSpawn = false
		gui.DisplayOrder = 95
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
		gui.Parent = CoreGui

		local frame = Instance.new("Frame")
		frame.Name = "PerfFrame"
		frame.Size = UDim2.new(0, 120, 0, 48)
		frame.Position = UDim2.new(0, 16, 0.5, -24)
		frame.BackgroundColor3 = Color3.fromRGB(12, 10, 22)
		frame.BackgroundTransparency = 0.25
		frame.BorderSizePixel = 0
		frame.Active = true
		frame.Parent = gui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = frame

		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 1.5
		stroke.Color = NeonPurple
		stroke.Transparency = 0.4
		stroke.Parent = frame

		local pingL = Instance.new("TextLabel")
		pingL.Name = "Ping"
		pingL.Size = UDim2.new(1, 0, 0.5, 0)
		pingL.BackgroundTransparency = 1
		pingL.TextColor3 = Color3.fromRGB(230, 230, 240)
		pingL.Font = Enum.Font.GothamBold
		pingL.TextSize = 12
		pingL.Text = "Ping: ..."
		pingL.Parent = frame

		local fpsL = Instance.new("TextLabel")
		fpsL.Name = "FPS"
		fpsL.Size = UDim2.new(1, 0, 0.5, 0)
		fpsL.Position = UDim2.new(0, 0, 0.5, 0)
		fpsL.BackgroundTransparency = 1
		fpsL.TextColor3 = Color3.fromRGB(230, 230, 240)
		fpsL.Font = Enum.Font.GothamBold
		fpsL.TextSize = 12
		fpsL.Text = "FPS: ..."
		fpsL.Parent = frame

		local dragging = false
		local startInputPos, startPos

		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				startInputPos = input.Position
				startPos = frame.Position
			end
		end)
		frame.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and startInputPos then
				local delta = Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(startInputPos.X, startInputPos.Y)

				frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
		frame.InputEnded:Connect(function()
			dragging = false
		end)

		local frames = 0
		local lastTick = tick()
		local conn = RunService.RenderStepped:Connect(function()
			frames += 1

			if tick() - lastTick >= 1 then
				local ping = 0
				local ok, result = pcall(function()
					return math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
				end)

				if ok then
					ping = result
				end

				pingL.Text = string.format("Ping: %dms", ping)
				pingL.TextColor3 = ping >= 200 and Color3.fromRGB(255, 100, 100) or (ping >= 100 and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(100, 255, 100))
				fpsL.Text = string.format("FPS: %d", frames)
				fpsL.TextColor3 = frames >= 50 and Color3.fromRGB(100, 255, 100) or (frames >= 28 and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(255, 100, 100))

				frames = 0
				lastTick = tick()
			end
		end)

		PerfOverlay = {
			gui = gui,
			conn = conn
		}
	elseif not on and PerfOverlay then
		pcall(function()
			PerfOverlay.conn:Disconnect()
			PerfOverlay.gui:Destroy()
		end)
		PerfOverlay = nil
	end
end

local TILE = IsMobile and 72 or 84
local HUD_SCALE = IsMobile and 0.7 or 1
local HUD = {
	parts = {},
	guis = {},
	locked = false
}

local HUD_ORDER_1 = {
	"Shoot",
	"Grab",
	"Aimbot",
	"Bomb",
	"Throw",
	"WallHop"
}
local HUD_ORDER_2 = {
	"KillAll",
	"KillSheriff",
	"Fly",
	"Noclip",
	"Xray"
}

local HUD_ICONS = {
	Shoot = "rbxassetid://134242818164054",
	Grab = "rbxassetid://130703864968637",
	Throw = "rbxassetid://124448418211665",
	Bomb = "http://www.roblox.com/Thumbs/Asset.ashx?format=png&width=250&height=250&assetId=342187115",
	Aimbot = "rbxassetid://87563802520297",
	WallHop = "rbxassetid://100467452364672",
	KillAll = "rbxassetid://116620312917084",
	Fly = "rbxassetid://126985561580989",
	Noclip = "rbxassetid://113822048130017",
	KillSheriff = "rbxassetid://137726256442333",
	Xray = "rbxassetid://340313896"
}

local HUD_ACCENTS = {
	Shoot = Color3.fromHex("#257AF7"),
	Grab = Color3.fromHex("#10C550"),
	Throw = Color3.fromHex("#EF4444"),
	Bomb = Color3.fromHex("#F97316"),
	Aimbot = Color3.fromHex("#2DD4BF"),
	WallHop = Color3.fromHex("#A855F7"),
	KillAll = Color3.fromHex("#DC2626"),
	Fly = Color3.fromHex("#38BDF8"),
	Noclip = Color3.fromHex("#94A3B8"),
	KillSheriff = Color3.fromHex("#DC2626"),
	Xray = Color3.fromHex("#FACC15")
}

local function hudTween(obj, info, props)
	pcall(function()
		TweenService:Create(obj, info, props):Play()
	end)
end

local function hudDefaultPos(name)
	local idx1 = table.find(HUD_ORDER_1, name)

	if idx1 then
		return UDim2.new(0.5, (idx1 - (#HUD_ORDER_1 + 1) / 2) * (TILE + 10) * HUD_SCALE, 0.25, 0)
	end

	local idx2 = table.find(HUD_ORDER_2, name)

	if idx2 then
		return UDim2.new(0.5, (idx2 - (#HUD_ORDER_2 + 1) / 2) * (TILE + 10) * HUD_SCALE, 0.25, (TILE + 10) * HUD_SCALE)
	end

	return UDim2.new(0.5, 0, 0.25, 0)
end

local function hudSetActive(name, on)
	local part = HUD.parts[name]

	if not part then
		return
	end

	part.active = on
	local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	if part.cdUntil then
		return
	end

	hudTween(part.stroke, ti, {
		Transparency = on and 0 or 0.15
	})
	hudTween(part.plate, ti, {
		BackgroundTransparency = on and 0.3 or 0.35
	})
	hudTween(part.icon, ti, {
		ImageColor3 = on and Color3.new(1, 1, 1) or Color3.fromRGB(190, 190, 200)
	})
	hudTween(part.label, ti, {
		TextColor3 = on and Color3.fromRGB(240, 240, 246) or Color3.fromRGB(146, 146, 158)
	})
end

local function hudCreate(name, label, callback)
	if HUD.guis[name] then
		return
	end

	local accent = HUD_ACCENTS[name] or NeonPurple

	local gui = Instance.new("ScreenGui")
	gui.Name = "Zenith" .. name .. "Button"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 90
	gui.Parent = CoreGui

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, TILE, 0, TILE)
	btn.Position = hudDefaultPos(name)
	btn.AnchorPoint = Vector2.new(0.5, 0.5)
	btn.Text = ""
	btn.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
	btn.BackgroundTransparency = 0.18
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = btn

	local scale = Instance.new("UIScale")
	scale.Scale = HUD_SCALE
	scale.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1.5
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = accent
	stroke.Transparency = 0.15
	stroke.Parent = btn

	local plate = Instance.new("Frame")
	plate.Name = "Plate"
	plate.Size = UDim2.new(0, 34, 0, 34)
	plate.Position = UDim2.new(0.5, 0, 0, math.floor(TILE * 0.36))
	plate.AnchorPoint = Vector2.new(0.5, 0.5)
	plate.BackgroundColor3 = accent
	plate.BackgroundTransparency = 0.35
	plate.BorderSizePixel = 0
	plate.Parent = btn

	local pCorner = Instance.new("UICorner")
	pCorner.CornerRadius = UDim.new(0, 11)
	pCorner.Parent = plate

	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Size = UDim2.new(0, 23, 0, 23)
	icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	icon.AnchorPoint = Vector2.new(0.5, 0.5)
	icon.BackgroundTransparency = 1
	icon.Image = HUD_ICONS[name] or ""
	icon.ImageColor3 = Color3.fromRGB(190, 190, 200)
	icon.Parent = plate

	local lbl = Instance.new("TextLabel")
	lbl.Name = "Label"
	lbl.Size = UDim2.new(1, -10, 0, 24)
	lbl.Position = UDim2.new(0.5, 0, 1, -7)
	lbl.AnchorPoint = Vector2.new(0.5, 1)
	lbl.BackgroundTransparency = 1
	lbl.Text = label
	lbl.TextSize = IsMobile and 9 or 10
	lbl.Font = Enum.Font.GothamBold
	lbl.TextColor3 = Color3.fromRGB(146, 146, 158)
	lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
	lbl.TextStrokeTransparency = 1
	lbl.TextWrapped = true
	lbl.LineHeight = 1.1
	lbl.Parent = btn

	local lines = select(2, label:gsub("\n", "")) + 1

	if lines >= 3 then
		plate.Size = UDim2.new(0, 28, 0, 28)
		icon.Size = UDim2.new(0, 20, 0, 20)
		lbl.TextSize = IsMobile and 8 or 9
		lbl.LineHeight = 1
	end

	HUD.parts[name] = {
		btn = btn,
		stroke = stroke,
		plate = plate,
		icon = icon,
		label = lbl,
		accent = accent,
		active = false,
		scale = scale,
		cdUntil = nil,
		baseLabel = label
	}

	btn.MouseEnter:Connect(function()
		hudTween(btn, TweenInfo.new(0.12), {
			BackgroundTransparency = 0.06
		})
	end)
	btn.MouseLeave:Connect(function()
		hudTween(btn, TweenInfo.new(0.12), {
			BackgroundTransparency = 0.18
		})
	end)

	local held = false
	local dragged = false
	local holdInput = nil
	local startPos, startInputPos = nil, nil
	local lastTap = 0

	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			held = true
			dragged = false
			holdInput = input
			startPos = btn.Position
			startInputPos = input.Position
		end
	end)

	local moveConn = UserInputService.InputChanged:Connect(function(input)
		if not held or HUD.locked or not btn.Parent then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input ~= holdInput then
			return
		end

		local delta = input.Position - startInputPos

		if not dragged then
			if math.abs(delta.X) + math.abs(delta.Y) < 6 then
				return
			end
			dragged = true
		end

		btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end)

	local endConn = UserInputService.InputEnded:Connect(function(input)
		if not held or input ~= holdInput then
			return
		end

		held = false
		holdInput = nil

		if not dragged then
			local nowTap = os.clock()

			if nowTap - lastTap < 0.2 then
				return
			end
			lastTap = nowTap

			hudTween(scale, TweenInfo.new(0.06), {
				Scale = HUD_SCALE * 0.93
			})
			task.delay(0.08, function()
				if scale.Parent then
					hudTween(scale, TweenInfo.new(0.16), {
						Scale = HUD_SCALE
					})
				end
			end)

			task.spawn(callback)
		end

		task.delay(0.05, function()
			dragged = false
		end)
	end)

	HUD.parts[name].dragConn = moveConn
	HUD.parts[name].endConn = endConn
	HUD.guis[name] = gui
end

local function hudDestroy(name)
	local part = HUD.parts[name]

	if part then
		if part.dragConn then
			pcall(function()
				part.dragConn:Disconnect()
			end)
		end

		if part.endConn then
			pcall(function()
				part.endConn:Disconnect()
			end)
		end
	end

	local gui = HUD.guis[name]

	if gui then
		pcall(function()
			gui:Destroy()
		end)
		HUD.guis[name] = nil
	end

	HUD.parts[name] = nil
end

local function hudStartCooldown(name, total, labelText)
	local part = HUD.parts[name]

	if not part or not part.label then
		return
	end

	part.cdUntil = os.clock() + total
	local firstLine = string.match(labelText, "^[^\n]+") or labelText
	local grey = Color3.fromRGB(72, 72, 80)

	part.stroke.Color = grey
	part.label.TextColor3 = Color3.fromRGB(112, 112, 124)

	task.spawn(function()
		while part.cdUntil and os.clock() < part.cdUntil do
			part.label.Text = firstLine .. "\n" .. string.format("%.1fs", part.cdUntil - os.clock())
			task.wait(0.05)
		end

		if HUD.parts[name] then
			HUD.parts[name].cdUntil = nil
			part.stroke.Color = part.accent
			part.label.Text = part.baseLabel
			hudSetActive(name, part.active)
		end
	end)
end

local Skins = {
	viz = nil,
	loading = false,
	baseline = nil,
	baselineEq = nil,
	conns = {},
	overlays = {},
	displayOverlays = {},
	displayKeys = {},
	toolOverlays = {},
	chromaTex = "rbxassetid://18363392181"
}

local SKIN_WELD = {
	WeldConstraint = true,
	Weld = true,
	Motor6D = true,
	RigidConstraint = true,
	Bone = true,
	Snap = true,
	ManualWeld = true
}

local SKIN_AXES = {
	Gun = {
		Vector3.new(0, 0, 1),
		Vector3.new(0, 1, 0),
		Vector3.new(-1, 0, 0)
	},
	Knife = {
		Vector3.new(0, 1, 0),
		Vector3.new(0, 0, 1),
		Vector3.new(1, 0, 0)
	}
}

local SKIN_SIG = {
	Gun_ZYX = CFrame.new(0.12991, -3e-05, 0.075, 1, 0, 0, 0, 0.70713, 0.70708, 0, -0.70708, 0.70713),
	Gun_ZXY = CFrame.new(0.12991, 0, 0.07501, 2e-05, -0.5, -0.86603, 1, -4e-05, 5e-05, -6e-05, -0.86603, 0.5),
	Gun_XYZ = CFrame.new(-0.22989, 0.09821, 0.1, 1e-05, 0.98481, -0.17362, -1e-05, 0.17362, 0.98481, 1, -1e-05, 1e-05),
	Knife_YXZ = CFrame.new(0, 0, 0, -0.0446, -0.00031, -0.99901, 0.03549, 0.99937, -0.00189, 0.99837, -0.03553, -0.04456),
	Knife_ZYX = CFrame.new(0.00151, -0.12701, -0.15448, -0.99867, 0.03727, 0.03568, -0.04098, -0.15276, -0.98741, -0.03135, -0.98756, 0.15409),
	Knife_ZXY = CFrame.new(0.00151, -0.12701, -0.15448, -0.99867, 0.03727, 0.03568, -0.04098, -0.15276, -0.98741, -0.03135, -0.98756, 0.15409)
}

local function skinTrim(s)
	if type(s) == "string" then
		return (s:gsub("^%s+", ""):gsub("%s+$", ""))
	end

	return s
end

local function skinApplyProps(inst, props, skip)
	for k, v in pairs(props or {}) do
		if not (skip and skip[k]) then
			if k == "MeshId" or k == "TextureId" or k == "TextureID" then
				v = skinTrim(v)
			end

			pcall(function()
				inst[k] = v
			end)
		end
	end
end

local function skinCreatePart(props)
	local meshId = skinTrim(props.MeshId or "")
	local inst = nil

	if meshId ~= "" then
		pcall(function()
			inst = game:GetService("InsertService"):CreateMeshPartAsync(meshId, Enum.CollisionFidelity.Box, Enum.RenderFidelity.Precise)
		end)
	end

	if inst then
		pcall(function()
			inst.Size = props.Size or Vector3.one
		end)

		return inst
	end

	local part = Instance.new("Part")
	part.Size = props.Size or Vector3.one
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.FileMesh

	pcall(function()
		mesh.MeshId = meshId
	end)

	pcall(function()
		mesh.TextureId = skinTrim(props.TextureID or "")
	end)

	mesh.Parent = part

	return part
end

local function skinBuildNode(node)
	if SKIN_WELD[node.Class] then
		return nil
	end

	local inst = nil

	if node.Class == "MeshPart" then
		inst = skinCreatePart(node.Props or {})
		skinApplyProps(inst, node.Props, {
			MeshId = true,
			Size = true,
			RelCF = true,
			CanCollide = true
		})
	else
		local ok, r = pcall(Instance.new, node.Class)

		if not ok or not r then
			return nil
		end

		inst = r
		skinApplyProps(inst, node.Props, {
			RelCF = true
		})
	end

	return inst
end

local function skinBuildTree(node, parent, rootParent, idMap, parts, deferred)
	for _, child in ipairs(node.Children or {}) do
		local inst = skinBuildNode(child)

		if inst then
			idMap[child.Id] = inst

			if inst:IsA("BasePart") then
				inst.Anchored = false
				inst.CanCollide = false
				inst.CanQuery = false
				inst.CanTouch = false
				inst.Massless = true
				table.insert(parts, {
					inst = inst,
					relcf = child.Props and child.Props.RelCF
				})
				inst.Parent = rootParent
				skinBuildTree(child, inst, rootParent, idMap, parts, deferred)
			elseif inst:IsA("Attachment") then
				if child.Props and child.Props.RelCF then
					pcall(function()
						inst.CFrame = child.Props.RelCF
					end)
				end

				inst.Parent = rootParent
				skinBuildTree(child, inst, rootParent, idMap, parts, deferred)
			elseif inst:IsA("Beam") or inst:IsA("Trail") then
				inst.Parent = parent
				table.insert(deferred, {
					inst = inst,
					a0 = child.Att0,
					a1 = child.Att1
				})
				skinBuildTree(child, inst, rootParent, idMap, parts, deferred)
			else
				inst.Parent = parent
				skinBuildTree(child, inst, rootParent, idMap, parts, deferred)
			end
		else
			skinBuildTree(child, parent, rootParent, idMap, parts, deferred)
		end
	end
end

local function skinBuildEntry(entry)
	local model = entry.Model

	if not model then
		return nil
	end

	local root = nil

	if model.Class == "MeshPart" then
		root = skinCreatePart(model.Props or {})
		skinApplyProps(root, model.Props, {
			MeshId = true,
			Size = true,
			RelCF = true,
			CanCollide = true
		})
	else
		root = Instance.new("Part")
		skinApplyProps(root, model.Props, {
			RelCF = true,
			CanCollide = true
		})
	end

	root.Anchored = false
	root.CanCollide = false
	root.CanQuery = false
	root.CanTouch = false
	root.Massless = true

	local idMap = {
		[model.Id] = root
	}
	local parts = {}
	local deferred = {}

	skinBuildTree(model, root, root, idMap, parts, deferred)

	for _, d in ipairs(deferred) do
		if d.a0 and idMap[d.a0] then
			pcall(function()
				d.inst.Attachment0 = idMap[d.a0]
			end)
		end

		if d.a1 and idMap[d.a1] then
			pcall(function()
				d.inst.Attachment1 = idMap[d.a1]
			end)
		end
	end

	return {
		root = root,
		parts = parts
	}
end

local function skinPlace(built, cf)
	pcall(function()
		built.root.CFrame = cf
	end)

	for _, p in ipairs(built.parts) do
		if p.relcf then
			pcall(function()
				p.inst.CFrame = cf * p.relcf
			end)
		end

		local w = Instance.new("WeldConstraint")
		w.Part0 = p.inst
		w.Part1 = built.root
		w.Parent = p.inst
	end

	return built.root
end

local function skinModelSize(entry)
	if entry.Model and entry.Model.Props then
		return entry.Model.Props.Size
	end

	return nil
end

local function skinMeshIdOfInst(inst)
	if not inst then
		return ""
	end

	if inst:IsA("MeshPart") then
		return skinTrim(inst.MeshId or "")
	end

	local mesh = inst:FindFirstChildWhichIsA("SpecialMesh", true)

	return mesh and skinTrim(mesh.MeshId or "") or ""
end

local LearnedCF = {}

local function skinAttachmentOf(inst)
	if not inst then
		return nil
	end

	return inst:FindFirstChild("CustomAttachment") or inst:FindFirstChildWhichIsA("Attachment")
end

local function skinSizeSig(size)
	local axes = {
		{
			size.X,
			"X"
		},
		{
			size.Y,
			"Y"
		},
		{
			size.Z,
			"Z"
		}
	}

	table.sort(axes, function(a, b)
		return a[1] > b[1]
	end)

	return axes[1][2] .. axes[2][2] .. axes[3][2]
end

local function skinEntryMeshId(entry)
	if not entry.Model then
		return ""
	end

	if entry.Model.Class == "MeshPart" then
		return skinTrim((entry.Model.Props or {}).MeshId or "")
	end

	for _, child in ipairs(entry.Model.Children or {}) do
		if child.Class == "SpecialMesh" then
			return skinTrim((child.Props or {}).MeshId or "")
		end
	end

	return ""
end

local function skinFindRelCF(node)
	for _, child in ipairs(node.Children or {}) do
		if child.Class == "Attachment" and child.Name == "CustomAttachment" and child.Props and child.Props.RelCF then
			return child.Props.RelCF
		end

		local found = skinFindRelCF(child)

		if found then
			return found
		end
	end

	return nil
end

local function skinAttachCF(key, entry, slot)
	local meshId = skinEntryMeshId(entry)

	if meshId ~= "" and LearnedCF[meshId] then
		return LearnedCF[meshId]
	end

	if entry.Model then
		local rel = skinFindRelCF(entry.Model)

		if rel then
			return rel
		end
	end

	local size = skinModelSize(entry)

	if size then
		local sig = SKIN_SIG[slot .. "_" .. skinSizeSig(size)]

		if sig then
			return sig
		end
	end

	return CFrame.identity
end

local function skinHideRecursive(list, inst)
	if inst:IsA("BasePart") or inst:IsA("Decal") then
		table.insert(list, {
			inst = inst,
			prop = "Transparency",
			val = inst.Transparency
		})

		pcall(function()
			inst.Transparency = 1
		end)
	elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("Fire") or inst:IsA("Smoke") or inst:IsA("Sparkles") then
		table.insert(list, {
			inst = inst,
			prop = "Enabled",
			val = inst.Enabled
		})

		pcall(function()
			inst.Enabled = false
		end)
	end
end

local function skinRestore(list)
	for _, item in ipairs(list) do
		pcall(function()
			item.inst[item.prop] = item.val
		end)
	end
end

local function skinGuards(list)
	local conns = {}

	for _, item in ipairs(list) do
		local inst = item.inst
		local prop = item.prop

		pcall(function()
			table.insert(conns, inst:GetPropertyChangedSignal(prop):Connect(function()
				if prop == "Enabled" then
					if inst.Enabled then
						inst.Enabled = false
					end
				elseif inst.Transparency ~= 1 then
					inst.Transparency = 1
				end
			end))
		end)
	end

	return conns
end

local function skinDropGuards(conns)
	for _, c in ipairs(conns or {}) do
		pcall(function()
			c:Disconnect()
		end)
	end
end

local function skinChroma(root)
	local parts, decals, fires = {}, {}, {}

	for _, d in ipairs(root:GetDescendants()) do
		local attr = d:GetAttribute("MM2Chroma")

		if attr == "part" then
			table.insert(parts, d)
		elseif attr == "decal" and d:IsA("Decal") then
			pcall(function()
				d.Texture = Skins.chromaTex
			end)
			table.insert(decals, d)
		elseif attr == "fire" then
			table.insert(fires, d)
		end
	end

	if #parts == 0 and #decals == 0 and #fires == 0 then
		for _, d in ipairs(root:GetDescendants()) do
			if d:IsA("BasePart") and d.Material == Enum.Material.Neon then
				table.insert(parts, d)
			elseif d:IsA("Fire") then
				table.insert(fires, d)
			end
		end
	end

	if #parts == 0 and #decals == 0 and #fires == 0 then
		return nil
	end

	return RunService.Heartbeat:Connect(function()
		local t = os.clock()
		local c = Color3.fromHSV((t * 0.35) % 1, 0.85, 1)

		for _, d in ipairs(decals) do
			pcall(function()
				d.Color3 = c
			end)
		end

		for _, d in ipairs(fires) do
			pcall(function()
				d.Color = c
			end)
		end

		for i, p in ipairs(parts) do
			pcall(function()
				p.Color = Color3.fromHSV((t * 0.35 + i / math.max(#parts, 1)) % 1, 0.85, 1)
			end)
		end
	end)
end

local function skinIsChroma(key, entry)
	if entry.Meta and entry.Meta.Chroma == true then
		return true
	end

	return string.sub(key, -6) == "Chroma"
end

local function skinClearDisplay(slot)
	local o = Skins.displayOverlays[slot]

	if not o then
		return
	end

	Skins.displayOverlays[slot] = nil

	if o.chroma then
		pcall(function()
			o.chroma:Disconnect()
		end)
	end

	skinDropGuards(o.guards)

	if o.overlay then
		pcall(function()
			o.overlay:Destroy()
		end)
	end

	skinRestore(o.hidden)
end

local function skinApplyDisplay(slot, key)
	if Skins.displayKeys[slot] == key and Skins.displayOverlays[slot] then
		return
	end

	skinClearDisplay(slot)

	if not key or not Skins.viz or not Skins.viz.meshes[key] then
		Skins.displayKeys[slot] = key

		return
	end

	Skins.displayKeys[slot] = key

	local char = LocalPlayer.Character
	local ref = char and char:FindFirstChild("DisplayRef" .. slot)
	local t0 = tick()

	while not ref and tick() - t0 < 1.5 do
		task.wait(0.05)
		char = LocalPlayer.Character
		ref = char and char:FindFirstChild("DisplayRef" .. slot)
	end

	if not ref then
		return
	end

	local entry = Skins.viz.meshes[key]

	if skinMeshIdOfInst(ref) ~= "" then
		local att = skinAttachmentOf(ref)

		if att then
			LearnedCF[skinMeshIdOfInst(ref)] = att.CFrame
		end
	end

	if skinMeshIdOfInst(ref) == skinEntryMeshId(entry) and skinMeshIdOfInst(ref) ~= "" then
		return
	end

	local built = skinBuildEntry(entry)

	if not built then
		return
	end

	local hidden = {}

	skinHideRecursive(hidden, ref)

	for _, d in ipairs(ref:GetDescendants()) do
		skinHideRecursive(hidden, d)
	end

	local guards = skinGuards(hidden)
	local cf = ref.CFrame * skinAttachCF(key, entry, slot) * skinAttachCF(key, entry, slot):Inverse()

	skinPlace(built, ref.CFrame * skinAttachCF(key, entry, slot))

	built.root:SetAttribute("ZenithVizOverlay", true)
	built.root.Parent = ref.Parent or ref

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = built.root
	weld.Part1 = ref
	weld.Parent = built.root

	Skins.displayOverlays[slot] = {
		overlay = built.root,
		hidden = hidden,
		guards = guards,
		chroma = skinIsChroma(key, entry) and skinChroma(built.root) or nil
	}
end

local function skinClearTool(tool)
	local o = Skins.toolOverlays[tool]

	if not o then
		return
	end

	Skins.toolOverlays[tool] = nil

	if o.chroma then
		pcall(function()
			o.chroma:Disconnect()
		end)
	end

	skinDropGuards(o.guards)

	if o.overlay then
		pcall(function()
			o.overlay:Destroy()
		end)
	end

	skinRestore(o.hidden)
end

local function skinGripCF(tool, key, entry, slot)
	local gripAxes = SKIN_AXES[slot]

	if not gripAxes then
		return CFrame.identity
	end

	local size = skinModelSize(entry)

	if not size then
		return CFrame.identity
	end

	local axes = {
		{
			size.X,
			"X",
			Vector3.new(1, 0, 0)
		},
		{
			size.Y,
			"Y",
			Vector3.new(0, 1, 0)
		},
		{
			size.Z,
			"Z",
			Vector3.new(0, 0, 1)
		}
	}

	table.sort(axes, function(a, b)
		return a[1] > b[1]
	end)

	local a1, a2, a3 = axes[1][2], axes[2][2], axes[3][2]
	local map = {
		[a1] = gripAxes[1],
		[a2] = gripAxes[2],
		[a3] = gripAxes[3]
	}

	if axes[1][3]:Cross(axes[2][3]):Dot(axes[3][3]) < 0 then
		map[a3] = -map[a3]
	end

	local cf = tool.Grip.Rotation * CFrame.fromMatrix(Vector3.zero, map.X, map.Y, map.Z)

	if key == "Harvester" or key == "Icepiercer" then
		cf = cf * CFrame.Angles(0, 0, -math.rad(90))
	end

	return cf
end

local function skinApplyTool(tool, slot)
	if Skins.toolOverlays[tool] then
		return
	end

	local key = nil

	pcall(function()
		key = require(ReplicatedStorage.Modules.ProfileData).Weapons.Equipped[slot]
	end)

	if not key or not Skins.viz or not Skins.viz.meshes[key] then
		return
	end

	local handle = tool:FindFirstChild("Handle") or tool:WaitForChild("Handle", 5)

	if not handle then
		return
	end

	local entry = Skins.viz.meshes[key]
	local built = skinBuildEntry(entry)

	if not built then
		return
	end

	local hidden = {}

	skinHideRecursive(hidden, handle)

	for _, d in ipairs(handle:GetDescendants()) do
		skinHideRecursive(hidden, d)
	end

	skinPlace(built, handle.CFrame * skinGripCF(tool, key, entry, slot))

	built.root:SetAttribute("ZenithVizOverlay", true)
	built.root.Parent = handle

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = built.root
	weld.Part1 = handle
	weld.Parent = built.root

	Skins.toolOverlays[tool] = {
		overlay = built.root,
		hidden = hidden,
		guards = skinGuards(hidden),
		chroma = skinIsChroma(key, entry) and skinChroma(built.root) or nil
	}
end

local function skinSpawn(key, amount)
	local ok, ProfileData = pcall(require, ReplicatedStorage.Modules.ProfileData)

	if not ok or type(ProfileData) ~= "table" or not ProfileData.Weapons then
		return false
	end

	local owned = ProfileData.Weapons.Owned
	owned[key] = (owned[key] or 0) + (amount or 1)

	pcall(function()
		local remote = ReplicatedStorage.Remotes.Inventory:FindFirstChild("InventoryDataChanged")

		if remote then
			firesignal(remote.OnClientEvent, "Weapons", key, owned[key])
		end
	end)

	return true
end

local function skinDespawnAll()
	local ok, ProfileData = pcall(require, ReplicatedStorage.Modules.ProfileData)

	if not ok or type(ProfileData) ~= "table" or not ProfileData.Weapons then
		return 0
	end

	local owned = ProfileData.Weapons.Owned
	local n = 0

	for key in pairs(Skins.viz.meshes) do
		local base = Skins.baseline[key]

		if owned[key] ~= base then
			owned[key] = base

			pcall(function()
				local remote = ReplicatedStorage.Remotes.Inventory:FindFirstChild("InventoryDataChanged")

				if remote then
					firesignal(remote.OnClientEvent, "Weapons", key, owned[key] or 0)
				end
			end)

			n += 1
		end
	end

	for _, slot in ipairs({
		"Knife",
		"Gun"
	}) do
		local eq = ProfileData.Weapons.Equipped[slot]

		if eq and owned[eq] == nil then
			local fallback = Skins.baselineEq[slot]

			if not (fallback and owned[fallback]) then
				fallback = nil

				for k in pairs(owned) do
					local item = v441[k]

					if type(item) == "table" and item.ItemType == slot then
						fallback = k
						break
					end
				end
			end

			fallback = fallback or (slot == "Knife" and "DefaultKnife" or "DefaultGun")
			ProfileData.Weapons.Equipped[slot] = fallback

			pcall(function()
				local EquipService = require(ReplicatedStorage.ClientServices.EquipService)
				EquipService.EquippedChanged:Fire(slot, fallback)
			end)
		end
	end

	return n
end

local function skinIcon(key)
	local entry = Skins.viz and Skins.viz.meshes[key]

	if not entry or not entry.Meta then
		return nil
	end

	if entry.Meta.ItemID then
		return ("rbxthumb://type=Asset&w=150&h=150&id=%d"):format(entry.Meta.ItemID)
	end

	return entry.Meta.Image
end

local function skinInit()
	if Skins.viz then
		return Skins.viz
	end

	if Skins.loading then
		return nil
	end

	Skins.loading = true

	local ok, err = pcall(function()
		local data = nil
		local okF, cached = pcall(function()
			if isfile and readfile and isfile("ZenithSkins/weapon.lua") then
				return readfile("ZenithSkins/weapon.lua")
			end
		end)

		if okF and type(cached) == "string" and #cached > 100000 then
			data = cached
		end

		if not data then
			data = game:HttpGet("https://raw.githubusercontent.com/kroxn/visual/refs/heads/main/weapon.lua")
		end

		local chunk, loadErr = loadstring(data .. "\nreturn MESHES_FULL")

		if not chunk then
			error(loadErr or "load failed", 0)
		end

		local full = chunk()

		if type(full) ~= "table" or next(full) == nil then
			error("no MESHES_FULL", 0)
		end

		if not okF and writefile then
			pcall(function()
				if makefolder and isfolder and not isfolder("ZenithSkins") then
					makefolder("ZenithSkins")
				end

				writefile("ZenithSkins/weapon.lua", data)
			end)
		end

		local meshes = {}

		for key, entry in pairs(full) do
			local item = v441[key]

			if type(item) == "table" and (item.ItemType == "Knife" or item.ItemType == "Gun") and (item.Rarity == "Godly" or item.Rarity == "Ancient") and item.ItemName and item.ItemName ~= "" and not item.ItemName:match("^%?+$") then
				meshes[key] = entry
			end
		end

		local list = {}

		for key in pairs(meshes) do
			local item = v441[key]

			table.insert(list, {
				key = key,
				name = item.ItemName or key,
				type = item.ItemType or "",
				rarity = item.Rarity or "",
				chroma = skinIsChroma(key, meshes[key])
			})
		end

		table.sort(list, function(a, b)
			if a.type ~= b.type then
				return a.type < b.type
			end

			if a.rarity ~= b.rarity then
				return a.rarity < b.rarity
			end

			return string.lower(a.name) < string.lower(b.name)
		end)

		local okPD, ProfileData = pcall(require, ReplicatedStorage.Modules.ProfileData)

		if okPD and type(ProfileData) == "table" then
			Skins.baseline = {}

			for k, v in pairs(ProfileData.Weapons.Owned) do
				Skins.baseline[k] = v
			end

			Skins.baselineEq = {
				Knife = ProfileData.Weapons.Equipped.Knife,
				Gun = ProfileData.Weapons.Equipped.Gun
			}
		end

		Skins.viz = {
			meshes = meshes,
			list = list
		}

		local eqKeys = {}

		pcall(function()
			local ProfileData2 = require(ReplicatedStorage.Modules.ProfileData)
			eqKeys.Knife = ProfileData2.Weapons.Equipped.Knife
			eqKeys.Gun = ProfileData2.Weapons.Equipped.Gun
		end)

		task.spawn(function()
			while Skins.viz do
				for _, slot in ipairs({
					"Knife",
					"Gun"
				}) do
					local key = nil

					pcall(function()
						key = require(ReplicatedStorage.Modules.ProfileData).Weapons.Equipped[slot]
					end)

					if key ~= eqKeys[slot] then
						eqKeys[slot] = key
						local saved = key

						task.spawn(function()
							skinApplyDisplay(slot, saved)
						end)
					end
				end

				task.wait(0.1)
			end
		end)

		pcall(function()
			local EquipService = require(ReplicatedStorage.ClientServices.EquipService)
			local conn = EquipService.EquippedChanged.Event:Connect(function(slot, key)
				if slot == "Knife" or slot == "Gun" then
					eqKeys[slot] = key
					task.spawn(function()
						skinApplyDisplay(slot, key)
					end)
				end
			end)
			table.insert(Skins.conns, conn)
		end)

		local function watchTagged(tag, slot)
			for _, inst in ipairs(CollectionService:GetTagged(tag)) do
				if inst:IsDescendantOf(LocalPlayer) then
					task.spawn(function()
						skinApplyTool(inst, slot)
					end)
				end
			end

			table.insert(Skins.conns, CollectionService:GetInstanceAddedSignal(tag):Connect(function(inst)
				if inst:IsDescendantOf(LocalPlayer) then
					task.spawn(function()
						skinApplyTool(inst, slot)
					end)
				end
			end))

			table.insert(Skins.conns, CollectionService:GetInstanceRemovedSignal(tag):Connect(function(inst)
				skinClearTool(inst)
			end))
		end

		watchTagged("Weapon_Knife", "Knife")
		watchTagged("Weapon_Gun", "Gun")

		LocalPlayer.CharacterAdded:Connect(function()
			task.wait(1)

			for slot, key in pairs(eqKeys) do
				if key then
					task.spawn(function()
						skinApplyDisplay(slot, key)
					end)
				end
			end
		end)
	end)

	Skins.loading = false

	if not ok then
		Notify("Skin Changer", "Couldn't load: " .. tostring(err):sub(1, 100), "Danger", 5)

		return nil
	end

	return Skins.viz
end

task.spawn(function()
	task.wait(2)
	skinInit()
end)

local function MakeTheme(name, accent, bg)
	WindUI:AddTheme({
		Name = name,
		Text = Color3.fromHex("#E5E7EB"),
		TextFont = Enum.Font.GothamMedium,
		Background = bg or Color3.fromHex("#08070F"),
		Topbar = Color3.fromHex("#0C0B18"),
		Shadow = Color3.fromHex("#000000"),
		SearchBar = Color3.fromHex("#FFFFFF"),
		Placeholder = Color3.fromHex("#6B7280"),
		Loading = accent,
		Label = accent,
		CloseButton = NeonRed,
		MainButton = {
			Background = accent,
			Text = Color3.fromHex("#08070F")
		},
		ScrollBar = accent
	})
end

MakeTheme("Zenith", NeonPurple)
MakeTheme("Zenith Blood", NeonRed)
MakeTheme("Zenith Frost", NeonCyan)
MakeTheme("Zenith Toxic", NeonGreen)
MakeTheme("Zenith Candy", NeonPink)

local Window = WindUI:CreateWindow({
	Title = "Project Zenith",
	Icon = "zap",
	IconColor = NeonPurple,
	Author = "discord.gg/QuFqd2j3Va",
	Folder = "ProjectZenith",
	Size = UDim2.fromOffset(620, 500),
	MinSize = Vector2.new(540, 380),
	MaxSize = Vector2.new(1100, 850),
	Resizable = true,
	Theme = "Zenith",
	SideBarWidth = 205,
	Transparent = true,
	ScrollBarEnabled = true
})

pcall(function()
	Window:SetToggleKey(Enum.KeyCode.RightControl)
end)
pcall(function()
	Window:Tag({
		Title = "NEON",
		Color = NeonPurple
	})
end)
pcall(function()
	Window.Transparency = 1
	TweenService:Create(Window, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Transparency = 0
	}):Play()
end)
pcall(function()
	Window:SelectTab(1)
end)

local GameplayTab = Window:Tab({
	Title = "Gameplay",
	Icon = "swords",
	IconColor = NeonPurple
})

GameplayTab:Section({ Title = "Tools" })

GameplayTab:Button({
	Title = "Pick Up Gun",
	Desc = "Instant Gun Pick Up",
	Callback = function()
		pickupgun()
	end
})
GameplayTab:Toggle({
	Title = "Auto Pick Up Gun",
	Value = false,
	Callback = function(p65)
		v38.Gameplay.AutoPickUpGun = p65
	end
})

GameplayTab:Section({ Title = "Basic Stuff" })

GameplayTab:Toggle({
	Title = "Noclip",
	Value = false,
	Callback = function(p66)
		v38.Noclip = p66
		hudSetActive("Noclip", p66)
	end
})
GameplayTab:Toggle({
	Title = "Fly",
	Value = false,
	Callback = function(on)
		flySet(on)
		hudSetActive("Fly", on)
	end
})
GameplayTab:Toggle({
	Title = "Anti Fling",
	Value = false,
	Callback = function(on)
		v38.Gameplay.AntiFling = on
		setAntiFling(on)
	end
})
GameplayTab:Button({
	Title = "Fly GUI",
	Desc = "Open the Fly GUI script",
	Callback = function()
		local ok, result = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
		end)

		if not ok then
			Notify("Fly GUI failed", tostring(result), "Danger", 4)
		end
	end
})

GameplayTab:Section({ Title = "More Tools" })

GameplayTab:Button({
	Title = "Kill Everyone as Murderer",
	Desc = "Eliminate all players if you are the murderer",
	Callback = function()
		if v134() ~= LocalPlayer then
			Notify("You are not the murderer", "You do not have the knife.", "Warning", 4)
		end

		v168()
	end
})
GameplayTab:Button({
	Title = "Bring All Players",
	Desc = "Teleport every player to your location (only useful as murderer)",
	Callback = function()
		if v134() ~= LocalPlayer then
			Notify("You are not the murderer", "This is only useful when you are the murderer.", "Warning", 4)

			return
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character then
				if player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
					local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
					local HumanoidRootPart2 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

					HumanoidRootPart.Anchored = true
					HumanoidRootPart.CFrame = HumanoidRootPart2.CFrame + HumanoidRootPart2.CFrame.LookVector * 5
				end
			end
		end

		Notify("Teleported Everyone", "All players moved to your position.", "Success", 3)
	end
})
GameplayTab:Toggle({
	Title = "Auto Shoot Murderer",
	Value = false,
	Callback = function(p67)
		v38.Gameplay.AutoShooting = p67
	end
})
GameplayTab:Button({
	Title = "Shoot Murderer (manual)",
	Callback = function()
		shootMurdererFn()
	end
})
GameplayTab:Button({
	Title = "Fake Bomb Jump",
	Desc = "Bomb jump with 22s cooldown",
	Callback = function()
		local okResult, remain = doBombJump()

		if not okResult and remain > 0 then
			Notify("Cooldown", string.format("Bomb jump on cooldown for %.1fs", remain), "Warning", 2)
		end
	end
})

GameplayTab:Section({ Title = "Annoying Stuff" })

local function v498(p68)
	if not p68 or p68 == "" then
		return
	end

	local v499 = p68:lower()

	for _, player in pairs(Players:GetPlayers()) do
		if string.find(player.Name:lower(), v499, 1, true) then
			return player.Name
		end

		if string.find(player.DisplayName:lower(), v499, 1, true) then
			return player.Name
		end
	end
end

GameplayTab:Input({
	Title = "Pick A Player",
	Placeholder = "Enter player name...",
	Value = "",
	Callback = function(p69)
		v38.AnnoyingStuff.Fling.PickedPlayer = v498(p69)
	end
})
GameplayTab:Button({
	Title = "Fling Chosen Player",
	Callback = function()
		if not v38.AnnoyingStuff.Fling.PickedPlayer then
			return
		end

		v189({ v38.AnnoyingStuff.Fling.PickedPlayer })
	end
})
GameplayTab:Button({
	Title = "Fling Murderer",
	Callback = function()
		local v502 = v134()

		if v502 then
			v189({ v502.Name })
		end
	end
})
GameplayTab:Button({
	Title = "Fling Sheriff",
	Callback = function()
		local v503 = v141()

		if v503 then
			v189({ v503.Name })
		end
	end
})
GameplayTab:Button({
	Title = "Fling All Players",
	Callback = function()
		v189({ "All" })
	end
})
GameplayTab:Button({
	Title = "Fling Random Player",
	Callback = function()
		local players = Players:GetPlayers()
		local v505 = table.find(players, LocalPlayer)

		if v505 then
			table.remove(players, v505)
		end

		if #players ~= 0 then
			v189({ players[math.random(#players)].Name })

			return
		end

		Notify("No target", "There are no other players in the server.", "Warning", 3)
	end
})
GameplayTab:Toggle({
	Title = "Loop Fling All Players",
	Value = false,
	Callback = function(p70)
		v38.AnnoyingStuff.Fling.LoopFlingAllPlayers = p70
	end
})

GameplayTab:Section({ Title = "Other Tools" })

GameplayTab:Button({
	Title = "Teleport to Map",
	Callback = function()
		Teleport_to_map()
	end
})
GameplayTab:Button({
	Title = "Teleport to Lobby",
	Callback = function()
		Teleport_to_lobby()
	end
})
GameplayTab:Button({
	Title = "Notify Murderer Username",
	Callback = function()
		local v507 = v134()

		if not v507 then
			Notify("Murderer", "Not found.", "Warning", 3)

			return
		end

		Notify("Murderer Username", v507.Name, "Info", 5)
	end
})
GameplayTab:Button({
	Title = "Notify Sheriff Username",
	Callback = function()
		local v508 = v141()

		if not v508 then
			Notify("Sheriff", "Not found.", "Warning", 3)

			return
		end

		Notify("Sheriff Username", v508.Name, "Info", 5)
	end
})
GameplayTab:Button({
	Title = "Reveal Roles",
	Callback = function()
		v154()
	end
})
GameplayTab:Toggle({
	Title = "Auto Reveal Roles",
	Value = false,
	Callback = function(p71)
		v38.AutoRevealRoles = p71
	end
})

GameplayTab:Section({ Title = "Speed and Jump" })

GameplayTab:Slider({
	Title = "WalkSpeed",
	Step = 1,
	Value = {
		Min = 1,
		Max = 100,
		Default = 16
	},
	Callback = function(p72)
		v38.Sliders.Speed = p72
	end
})
GameplayTab:Slider({
	Title = "JumpPower",
	Step = 1,
	Value = {
		Min = 1,
		Max = 100,
		Default = 50
	},
	Callback = function(p73)
		v38.Sliders.Jump = p73
	end
})

local CombatTab = Window:Tab({
	Title = "Combat",
	Icon = "shield",
	IconColor = NeonRed
})

CombatTab:Section({ Title = "Sheriff - you have the gun" })

CombatTab:Toggle({
	Title = "Silent Aim",
	Value = false,
	Callback = function(on)
		SilentAim.on = on

		if on then
			SilentAim.enable()
		else
			SilentAim.disable()
		end
	end
})
CombatTab:Toggle({
	Title = "Triggerbot",
	Value = false,
	Callback = function(on)
		Triggerbot.enabled = on

		if on then
			Triggerbot.start()
		else
			Triggerbot.stop()
		end
	end
})

CombatTab:Section({ Title = "Murderer - you have the knife" })

CombatTab:Slider({
	Title = "Change Knife Hitbox (OP!)",
	Step = 1,
	Value = {
		Min = 1,
		Max = 200,
		Default = 1
	},
	Callback = function(v)
		Hitbox.setMult(tonumber(v) or 1)
	end
})
CombatTab:Toggle({
	Title = "Show Hitbox",
	Value = false,
	Callback = function(on)
		Hitbox.show = on

		if on then
			Hitbox.showBall()
		else
			Hitbox.hideBall()
		end
	end
})
CombatTab:Toggle({
	Title = "Silent Throw",
	Desc = "Right click throws the knife at the nearest player",
	Value = false,
	Callback = function(on)
		SilentThrow.on = on

		if on then
			SilentThrow.enable()
		else
			SilentThrow.disable()
		end
	end
})

local selectedKillTarget = nil

local function playerNames()
	local t = {}

	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= LocalPlayer then
			table.insert(t, pl.Name)
		end
	end

	return t
end

CombatTab:Dropdown({
	Title = "Target",
	Values = playerNames(),
	Value = nil,
	Callback = function(v)
		selectedKillTarget = v
	end
})
CombatTab:Button({
	Title = "Kill Target",
	Desc = "Instantly stabs the player picked above",
	Callback = function()
		killTargetFn(selectedKillTarget)
	end
})
CombatTab:Button({
	Title = "Kill All",
	Desc = "Instantly stabs every player in the server",
	Callback = function()
		killAllFn()
	end
})

CombatTab:Section({ Title = "Misc" })

CombatTab:Toggle({
	Title = "Auto Grab Gun",
	Value = false,
	Callback = function(on)
		setAutoGrab(on)
	end
})
CombatTab:Toggle({
	Title = "Wall Check",
	Desc = "Only act when you can see the target",
	Value = false,
	Callback = function(on)
		WallCheck = on
	end
})

local ESPTab = Window:Tab({
	Title = "ESP",
	Icon = "eye",
	IconColor = NeonCyan
})

ESPTab:Section({ Title = "ESP Settings" })

ESPTab:Toggle({
	Title = "Players ESP (Highlight)",
	Value = false,
	Callback = function(p74)
		v38.ESP.Players = p74

		if p74 then
			v148()
		else
			for _, child in ipairs(Workspace:GetChildren()) do
				if child.Name == "PlayerESP" then
					child:Destroy()
				end
			end
		end
	end
})
ESPTab:Toggle({
	Title = "Name ESP",
	Value = false,
	Callback = function(on)
		v38.ESP.NameESP = on

		if not on then
			clearNameESP()
		end
	end
})
ESPTab:Toggle({
	Title = "Tracer ESP",
	Value = false,
	Callback = function(on)
		if on and not TracerOk then
			Notify("Tracer ESP", "Your executor does not support Drawing API.", "Warning", 4)

			return
		end

		v38.ESP.TracerESP = on
	end
})
ESPTab:Toggle({
	Title = "Dropped Gun ESP",
	Value = false,
	Callback = function(p75)
		v38.ESP.DroppedGun = p75
	end
})
ESPTab:Toggle({
	Title = "Trap ESP",
	Value = false,
	Callback = function(p76)
		v38.ESP.Traps = p76
	end
})

local ButtonsTab = Window:Tab({
	Title = "Buttons",
	Icon = "gamepad",
	IconColor = NeonPink
})

ButtonsTab:Section({ Title = "HUD Settings" })

ButtonsTab:Toggle({
	Title = "Lock Buttons In Place",
	Value = false,
	Callback = function(on)
		HUD.locked = on
	end
})
ButtonsTab:Slider({
	Title = "Button Size",
	Step = 1,
	Value = {
		Min = 50,
		Max = 200,
		Default = IsMobile and 70 or 100
	},
	Callback = function(v)
		local num = tonumber(v)
		HUD_SCALE = (num or (IsMobile and 70 or 100)) / 100

		for _, part in pairs(HUD.parts) do
			if part.scale then
				hudTween(part.scale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Scale = HUD_SCALE
				})
			end
		end
	end
})

ButtonsTab:Section({ Title = "On-Screen Buttons" })

local function refreshCombatTargets()
	return playerNames()
end

Players.PlayerAdded:Connect(function()
	task.wait(0.5)
end)
Players.PlayerRemoving:Connect(function()
	task.wait(0.5)
end)

local hudButtonDefs = {
	{
		"Shoot",
		"SHOOT\nMURDERER",
		function()
			local cd = shootMurdererFn()

			if cd and cd > 0 then
				hudStartCooldown("Shoot", cd, "SHOOT\nMURDERER")
			end
		end
	},
	{
		"Grab",
		"GRAB\nGUN",
		function()
			local okG = grabGunOnce()

			if okG then
				Notify("Gun Grabbed!", "Got the gun!", "Success", 1.5)
			else
				Notify("No Gun Found!", "No gun on the ground right now.", "Warning", 1.5)
			end
		end
	},
	{
		"Aimbot",
		"AIMBOT\nOFF",
		function()
			Aimbot.set(not Aimbot.on)
			hudSetActive("Aimbot", Aimbot.on)
		end
	},
	{
		"Bomb",
		"BOMB\nJUMP",
		function()
			local okB, remain = doBombJump()

			if okB then
				hudStartCooldown("Bomb", BOMB_CD, "BOMB\nJUMP")
			elseif remain > 0 then
				Notify("Cooldown", string.format("Bomb jump on cooldown for %.1fs", remain), "Warning", 2)
			end
		end
	},
	{
		"Throw",
		"THROW\nKNIFE",
		function()
			local cd = throwKnifeFn()

			if cd and cd > 0 then
				hudStartCooldown("Throw", cd, "THROW\nKNIFE")
			end
		end
	},
	{
		"WallHop",
		"WALL\nHOP",
		function()
			doWallHop()
		end
	},
	{
		"KillAll",
		"KILL ALL\nMURDER\nONLY",
		function()
			killAllFn()
		end
	},
	{
		"KillSheriff",
		"KILL\nSHERIFF",
		function()
			killSheriffFn()
		end
	},
	{
		"Xray",
		"FREE\nX-RAY",
		function()
			setXray(not XrayOn)
			hudSetActive("Xray", XrayOn)
		end
	},
	{
		"Fly",
		"FLY",
		function()
			flySet(not Fly.on)
			hudSetActive("Fly", Fly.on)
		end
	},
	{
		"Noclip",
		"NOCLIP",
		function()
			v38.Noclip = not v38.Noclip
			hudSetActive("Noclip", v38.Noclip)
		end
	}
}

for _, def in ipairs(hudButtonDefs) do
	ButtonsTab:Toggle({
		Title = def[2]:gsub("\n", " ") .. " Button",
		Value = true,
		Callback = function(on)
			if on then
				hudCreate(def[1], def[2], def[3])
			else
				hudDestroy(def[1])
			end
		end
	})
end

local AutoFarmTab = Window:Tab({
	Title = "Auto Farm",
	Icon = "bot",
	IconColor = NeonPink
})

AutoFarmTab:Section({ Title = "Autofarm Features" })

AutoFarmTab:Toggle({
	Title = "Auto Teleport At Spawn",
	Value = false,
	Callback = function(p77)
		v38.AutoFarm.TeleportSpawn = p77
	end
})
AutoFarmTab:Toggle({
	Title = "Auto Kill Everyone As Murderer",
	Value = false,
	Callback = function(p78)
		v38.AutoFarm.KillEveryoneAsAMurderer = p78
	end
})
AutoFarmTab:Toggle({
	Title = "Auto Prestige",
	Value = false,
	Callback = function(p79)
		v38.AutoFarm.AutoPrestige = p79
	end
})

AutoFarmTab:Section({ Title = "More Features" })

AutoFarmTab:Toggle({
	Title = "Auto Fling Murderer",
	Value = false,
	Callback = function(p80)
		v38.AutoFarm.AutoFlingMurderer = p80
	end
})
AutoFarmTab:Toggle({
	Title = "Auto Fling Sheriff",
	Value = false,
	Callback = function(p81)
		v38.AutoFarm.AutoFlingSheriff = p81
	end
})
AutoFarmTab:Toggle({
	Title = "Server Hop If Server Is Empty",
	Value = false,
	Callback = function(p82)
		v38.AutoFarm.AutoTeleportToRandomServerIfServerIsEmpty = p82
	end
})
AutoFarmTab:Slider({
	Title = "Players Threshold For Server Hop",
	Step = 1,
	Value = {
		Min = 1,
		Max = 12,
		Default = 2
	},
	Callback = function(p83)
		v38.AutoFarm.PlayersToAutoServerHop = p83
	end
})

local CoinFarmTab = Window:Tab({
	Title = "Coin Farm",
	Icon = "coins",
	IconColor = NeonYellow
})

CoinFarmTab:Section({ Title = "Coin Farm 1 [Smart]" })

CoinFarmTab:Toggle({
	Title = "Enable Coin Farm 1",
	Value = false,
	Callback = function(on)
		Farm1.On = on

		if on then
			farm1Start()
			Notify("Autofarm Started!", "Farming coins!", "Success", 2)
		else
			Notify("Autofarm Stopped!", "Stopped farming.", "Info", 2)
		end
	end
})
CoinFarmTab:Slider({
	Title = "Farm Speed",
	Step = 1,
	Value = {
		Min = 5,
		Max = 25,
		Default = 25
	},
	Callback = function(v)
		local num = tonumber(v) or 25
		Farm1.Speed = num >= 25 and 23 or num
	end
})

CoinFarmTab:Section({ Title = "Farm Settings" })

CoinFarmTab:Toggle({
	Title = "Auto-Reset When Bag Full",
	Value = true,
	Callback = function(on)
		Farm1.AutoReset = on
	end
})
CoinFarmTab:Toggle({
	Title = "Kill All When Bag Full (Murderer)",
	Value = false,
	Callback = function(on)
		Farm1.KillAllFull = on
		killFired = false
	end
})
CoinFarmTab:Toggle({
	Title = "Fling Murderer When Done",
	Value = false,
	Callback = function(on)
		Farm1.FlingWhenDone = on
		flingDoneFired = false
	end
})
CoinFarmTab:Toggle({
	Title = "Hop When Server Dies",
	Value = true,
	Callback = function(on)
		v38.AutoFarm.AutoTeleportToRandomServerIfServerIsEmpty = on
	end
})

CoinFarmTab:Section({ Title = "Coin Farm 2 [Safe TP]" })

CoinFarmTab:Toggle({
	Title = "Enable Coin Farm 2",
	Value = false,
	Callback = function(p86)
		v38.CoinFarm2.State = p86

		if p86 then
			task.spawn(v124)
		end
	end
})

CoinFarmTab:Section({ Title = "Coin Settings" })

CoinFarmTab:Toggle({
	Title = "Destroy Player Models",
	Value = false,
	Callback = function(p87)
		v38.CoinFarm2.Settings.DestroyPlayers = p87
	end
})
CoinFarmTab:Toggle({
	Title = "Destroy Map",
	Value = false,
	Callback = function(p88)
		v38.CoinFarm2.Settings.DestroyMap = p88
	end
})
CoinFarmTab:Toggle({
	Title = "Disable 3D Rendering",
	Value = false,
	Callback = function(p92)
		pcall(function()
			RunService:Set3dRenderingEnabled(not p92)
		end)
	end
})
CoinFarmTab:Toggle({
	Title = "Stats Overlay",
	Value = false,
	Callback = function(on)
		StatsOverlayOn = on
	end
})

CoinFarmTab:Section({ Title = "Auto Open Crates" })

local t31 = {}
local ok, result = pcall(function()
	return require(ReplicatedStorage.Database.Sync.Shop).Weapons
end)

if ok and result then
	for k in pairs(result) do
		table.insert(t31, tostring(k))
	end

	table.sort(t31)
end

CoinFarmTab:Toggle({
	Title = "Auto Open Crates",
	Value = false,
	Callback = function(p94)
		v38.AutoOpenCrates.State = p94
	end
})

if #t31 > 0 then
	CoinFarmTab:Dropdown({
		Title = "Choose Box",
		Values = t31,
		Value = t31[1],
		Callback = function(p95)
			v38.AutoOpenCrates.Crate = p95

			local ok2, crateType = pcall(function()
				return require(ReplicatedStorage.Database.Sync.Shop).Weapons[p95].DataType
			end)

			if ok2 and crateType then
				v38.AutoOpenCrates.CrateType = crateType
			end
		end
	})
end

local SkinsTab = Window:Tab({
	Title = "Skin Changer",
	Icon = "palette",
	IconColor = NeonCyan
})

SkinsTab:Paragraph({
	Title = "Visual Skin Changer - ONLY YOU CAN SEE THIS",
	Desc = "Spawns visual godly/ancient skins and overlays them on your equipped Knife/Gun. Equip spawned skins from your inventory.",
	Color = NeonYellow
})

local skinStatus = SkinsTab:Paragraph({
	Title = "Skins",
	Desc = "Loading..."
})

local skinNames = {}
local nameToKey = {}

SkinsTab:Button({
	Title = "Load Skins",
	Callback = function()
		ParaSet(skinStatus, "Skins", "Loading...")

		task.spawn(function()
			local viz = skinInit()

			if not viz then
				ParaSet(skinStatus, "Skins", "Failed to load skins.")

				return
			end

			table.clear(skinNames)
			table.clear(nameToKey)

			for _, item in ipairs(viz.list) do
				local display = item.name .. (item.chroma and " [Chroma]" or "") .. " - " .. item.rarity .. " " .. item.type
				table.insert(skinNames, display)
				nameToKey[display] = item.key
			end

			ParaSet(skinStatus, "Skins", ("%d skins loaded. Select below and spawn, then equip from inventory."):format(#viz.list))
		end)
	end
})
SkinsTab:Dropdown({
	Title = "Select Skins (multi)",
	Values = skinNames,
	MultiSelect = true,
	AllowNone = true,
	Callback = function() end
})
SkinsTab:Button({
	Title = "Spawn Selected",
	Callback = function()
		if not Skins.viz then
			Notify("Skins", "Load skins first.", "Warning", 2)

			return
		end

		local dd = nil

		Notify("Skins", "Use Spawn All to add every skin at once.", "Info", 3)
	end
})
SkinsTab:Button({
	Title = "Spawn All Skins",
	Callback = function()
		if not Skins.viz then
			Notify("Skins", "Load skins first.", "Warning", 2)

			return
		end

		task.spawn(function()
			for _, item in ipairs(Skins.viz.list) do
				pcall(skinSpawn, item.key, 1)
			end

			Notify("Skins", ("Spawned %d skins."):format(#Skins.viz.list), "Success", 2)
		end)
	end
})
SkinsTab:Button({
	Title = "Despawn All Skins",
	Callback = function()
		if not Skins.viz then
			return
		end

		pcall(skinDespawnAll)
		Notify("Skins", "Despawned.", "Success", 2)
	end
})

local TradeTab = Window:Tab({
	Title = "Trade Helper",
	Icon = "arrow-left-right",
	IconColor = NeonPurple
})

TradeTab:Section({ Title = "Trade Info" })

TradeTab:Paragraph({
	Title = "Trade Helper",
	Desc = "Shows item values in trades (USD or Supreme), calculates total value, and helps you choose profitable offers."
})
TradeTab:Dropdown({
	Title = "Item Price Display",
	Values = {
		"USD",
		"Supreme"
	},
	Value = "Supreme",
	Callback = function(p96)
		s1 = p96
		v308()
	end
})
TradeTab:Toggle({
	Title = "Show Values In Trade",
	Value = false,
	Callback = function(p97)
		u255 = p97

		if p97 then
			pcall(v360, Offer, u349)
		else
			pcall(v371)
		end
	end
})

TradeTab:Section({ Title = "Auto Trade [Risky]" })

TradeTab:Paragraph({
	Title = "Warning",
	Desc = "Auto-trade changes your offer automatically. Test it on an alt first.",
	Color = NeonYellow
})
TradeTab:Toggle({
	Title = "Automatically Generate Offers",
	Value = false,
	Callback = function(p98)
		u257 = p98
	end
})
TradeTab:Button({
	Title = "Generate Offer",
	Callback = function()
		pcall(v400)
	end
})
TradeTab:Button({
	Title = "Refresh Offer",
	Callback = function()
		pcall(v408)
	end
})
TradeTab:Slider({
	Title = "Minimum Profit Percentage",
	Step = 1,
	Value = {
		Min = 0,
		Max = 100,
		Default = 6
	},
	Callback = function(p99)
		n6 = p99
	end
})

local InventoryTab = Window:Tab({
	Title = "Inventory",
	Icon = "backpack",
	IconColor = NeonCyan
})

InventoryTab:Section({ Title = "Inventory Analyzer" })

InventoryTab:Paragraph({
	Title = "What is this?",
	Desc = "Analyzes your inventory, sorts items by value, and shows the total USD value."
})

local v533 = InventoryTab:Paragraph({
	Title = "Your Inventory:",
	Desc = "Press the button below."
})
local u534 = false

InventoryTab:Button({
	Title = "Start Analysis",
	Callback = function()
		if u534 then
			return
		end

		u534 = true
		ParaSet(v533, "Please wait...", "Collecting data...")
		task.spawn(function()
			local ok, result = pcall(v421, LocalPlayer.Name)

			ParaSet(v533, "Your Inventory:", ok and result or "Failed to fetch inventory.")
			u534 = false
		end)
	end
})
InventoryTab:Button({
	Title = "Copy To Clipboard",
	Callback = function()
		local ok, result = pcall(v421, LocalPlayer.Name)

		if ok and typeof(setclipboard) == "function" and pcall(setclipboard, result) then
			Notify("Copied", "Copied to clipboard.", "Success", 3)
		end
	end
})

InventoryTab:Section({ Title = "Other Players' Inventories" })

InventoryTab:Paragraph({
	Title = "Players Inventories Analysis",
	Desc = "Start the scanner and wait a minute: it collects all player inventories and sorts them by total value."
})

local t32 = {}
local v541 = InventoryTab:Paragraph({
	Title = "Results:",
	Desc = "(empty)"
})

local function v542(p100)
	local v543 = string.match(type(p100) == "string" and p100 or "", "Total Value:%s*%$?(%-?[%d%.]+)")

	return tonumber(v543) or 0
end
local function v544()
	local t33 = {}

	for k, v in pairs(t32) do
		table.insert(t33, {
			name = k,
			data = v,
			total = v542(v)
		})
	end

	table.sort(t33, function(p101, p102)
		return p101.total > p102.total
	end)

	local t34 = {}

	for _, v in ipairs(t33) do
		table.insert(t34, ("Player %s:\n%s\n"):format(v.name, v.data))
	end

	ParaSet(v541, "Results:", #t34 > 0 and table.concat(t34, "\n") or "(empty)")
end

local u551 = false

InventoryTab:Toggle({
	Title = "Auto-Scan Players Every Minute",
	Value = false,
	Callback = function(p103)
		u551 = p103

		if p103 then
			task.spawn(function()
				while u551 do
					for _, player in ipairs(Players:GetPlayers()) do
						if not u551 then
							break
						end

						local ok, result = pcall(v421, player.Name)
						local Name = player.Name
						local v557 = ok and result

						t32[Name] = v557 or "Failed to fetch."
						v544()
						task.wait(1)
					end

					task.wait(60)
				end
			end)
		end
	end
})
InventoryTab:Button({
	Title = "Scan All Players Now",
	Callback = function()
		task.spawn(function()
			for _, player in ipairs(Players:GetPlayers()) do
				local ok, result = pcall(v421, player.Name)

				t32[player.Name] = ok and result or "Failed to fetch."
				v544()
				task.wait(0.5)
			end
		end)
	end
})

local SpawnerTab = Window:Tab({
	Title = "Spawner",
	Icon = "package",
	IconColor = NeonPink
})

SpawnerTab:Section({ Title = "Item Spawner" })

local n13 = 2
local uSpawnNames = {}
local SpawnStatus

local function v563()
	if SpawnStatus then
		ParaSet(SpawnStatus, "Selection", ("%d selected x %d each = %d items"):format(#uSpawnNames, n13, #uSpawnNames * n13))
	end
end

SpawnerTab:Dropdown({
	Title = "Select Items (multi)",
	Values = tItemNames,
	MultiSelect = true,
	AllowNone = true,
	Callback = function(selected)
		uSpawnNames = type(selected) == "table" and selected or { selected }
		v563()
	end
})

SpawnStatus = SpawnerTab:Paragraph({
	Title = "Selection",
	Desc = "0 selected x 2 each = 0 items"
})

SpawnerTab:Slider({
	Title = "Amount",
	Step = 1,
	Value = {
		Min = 1,
		Max = 100,
		Default = 2
	},
	Callback = function(v)
		n13 = v471(math.floor(v), 1, 100)
		v563()
	end
})
SpawnerTab:Button({
	Title = "Spawn Selected",
	Callback = function()
		if #uSpawnNames == 0 then
			Notify("Nothing selected", "Select items from the dropdown first.", "Warning", 3)

			return
		end

		local ok, result = pcall(function()
			for _, name in ipairs(uSpawnNames) do
				local id = tNameToId[name]

				if id then
					v449(id, n13)
				end
			end
		end)

		if not ok then
			Notify("Spawn failed", tostring(result), "Danger", 4)

			return
		end

		Notify("Spawned", ("%d item(s) x %d each = %d total spawned."):format(#uSpawnNames, n13, #uSpawnNames * n13), "Success", 3)
	end
})

local CratesTab = Window:Tab({
	Title = "Crates",
	Icon = "gift",
	IconColor = NeonYellow
})

CratesTab:Section({ Title = "Crate Opener" })

local uCrateNames = {}

CratesTab:Dropdown({
	Title = "Select Items (multi)",
	Values = tItemNames,
	MultiSelect = true,
	AllowNone = true,
	Callback = function(selected)
		uCrateNames = type(selected) == "table" and selected or { selected }
	end
})
CratesTab:Button({
	Title = "Open Crates",
	Callback = function()
		if #uCrateNames == 0 then
			Notify("Nothing selected", "Select one or more items first.", "Warning", 3)

			return
		end

		task.spawn(function()
			local n14 = 0

			for _, name in ipairs(uCrateNames) do
				local id = tNameToId[name]
				local ok, result = pcall(function()
					if id then
						v469(id)
					end
				end)

				if ok then
					n14 += 1
				else
					Notify("Crate open failed", tostring(result), "Danger", 4)
				end

				task.wait(0.05)
			end

			if n14 > 0 then
				Notify("Crates opened", ("%d item(s)."):format(n14), "Success", 3)
			end
		end)
	end
})

local MiscTab = Window:Tab({
	Title = "Misc",
	Icon = "sparkles",
	IconColor = NeonPurple
})

MiscTab:Section({ Title = "Performance" })

MiscTab:Toggle({
	Title = "Ping & FPS Overlay",
	Value = false,
	Callback = function(on)
		setPerfOverlay(on)
	end
})

MiscTab:Section({ Title = "Server Crasher" })

MiscTab:Paragraph({
	Title = "Locked",
	Desc = "Server crash is locked for most users. Development only (getgenv().dev = true).",
	Color = NeonRed
})
MiscTab:Button({
	Title = "Crash Server",
	Callback = function()
		if genv.dev then
			task.spawn(v185)

			return
		end

		Notify("Feature locked", "You do not have access to this feature.", "Warning", 4)
	end
})

MiscTab:Section({ Title = "Unlock Emotes" })

MiscTab:Button({
	Title = "Unlock All Emotes",
	Callback = function()
		local v589 = v16()

		if LocalPlayer.PlayerGui:FindFirstChild("MainGUI") then
			if not LocalPlayer.PlayerGui.MainGUI.Game:FindFirstChild("Emotes") or not v18() or not v589 or not (v589.Health > 0) then
				Notify("Not ready", "Wait for the game to finish loading.", "Warning", 3)

				return
			end

			v235()
		else
			Notify("Not ready", "Wait for the game to finish loading.", "Warning", 3)
		end
	end
})

MiscTab:Section({ Title = "Server Stuff" })

MiscTab:Button({
	Title = "Rejoin Server",
	Callback = function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
	end
})
MiscTab:Button({
	Title = "Server Hop",
	Callback = function()
		v239()
	end
})

MiscTab:Section({ Title = "Spam Random Emotes" })

MiscTab:Toggle({
	Title = "Spam Random Emotes",
	Value = false,
	Callback = function(p108)
		v38.Emotes.AutoPlayEmotes = p108
	end
})
MiscTab:Slider({
	Title = "Spam Speed",
	Step = 1,
	Value = {
		Min = 1,
		Max = 50,
		Default = 1
	},
	Callback = function(p109)
		v38.Emotes.EmoteSpamSpeed = p109
	end
})

MiscTab:Section({ Title = "Spam Selected Emote" })

MiscTab:Toggle({
	Title = "Spam Selected Emote",
	Value = false,
	Callback = function(p110)
		v38.Emotes.AutoPlaySelectedEmote = p110
	end
})
MiscTab:Dropdown({
	Title = "Pick An Emote",
	Values = t3,
	Value = t3[1],
	Callback = function(p111)
		v38.Emotes.SelectedEmote = p111
	end
})

MiscTab:Section({ Title = "Fast Skin Swapper" })

MiscTab:Toggle({
	Title = "Shuffle Weapons",
	Value = false,
	Callback = function(p112)
		v38.ShuffleWeapons = p112
	end
})

MiscTab:Section({ Title = "Community" })

MiscTab:Button({
	Title = "Join Discord (Copy Link)",
	Callback = function()
		pcall(function()
			setclipboard("https://discord.gg/QuFqd2j3Va")
		end)
		Notify("Project Zenith", "Discord link copied: discord.gg/QuFqd2j3Va", "Success", 4)
	end
})

local SettingsTab = Window:Tab({
	Title = "Settings",
	Icon = "settings",
	IconColor = NeonCyan
})

SettingsTab:Section({ Title = "Theme" })

SettingsTab:Dropdown({
	Title = "Neon Theme",
	Values = {
		"Zenith",
		"Zenith Blood",
		"Zenith Frost",
		"Zenith Toxic",
		"Zenith Candy",
		"Dark",
		"Light"
	},
	Value = "Zenith",
	Callback = function(p136)
		pcall(function()
			WindUI:SetTheme(p136)
		end)
		Notify("Theme", tostring(p136), "Info", 2)
	end
})

SettingsTab:Section({ Title = "About" })

SettingsTab:Paragraph({
	Title = "Project Zenith",
	Desc = "Murder Mystery 2 executor package with a neon WindUI interface. Drag the header to move the window. Toggle: RightControl."
})
SettingsTab:Paragraph({
	Title = "Community",
	Desc = "discord.gg/QuFqd2j3Va",
	Color = NeonPurple
})
SettingsTab:Button({
	Title = "Copy Discord Link",
	Callback = function()
		pcall(function()
			setclipboard("https://discord.gg/QuFqd2j3Va")
		end)
		Notify("Project Zenith", "Discord link copied to clipboard.", "Success", 3)
	end
})
SettingsTab:Paragraph({
	Title = "Note",
	Desc = "Murder Mystery 2 only (GameId 66654135). Works on PC and mobile executors.",
	Color = NeonYellow
})

for _, def in ipairs(hudButtonDefs) do
	hudCreate(def[1], def[2], def[3])
end

hudSetActive("Aimbot", false)
hudSetActive("Xray", false)

local v682 = genv

if v682.MM2LibraryWindow then
	pcall(function()
		v682.MM2LibraryWindow:Destroy()
	end)
end

v682.MM2LibraryWindow = Window

genv.ZenithCleanup = function()
	Farm1.On = false
	flySet(false)
	setXray(false)
	SilentAim.disable()
	SilentThrow.disable()
	Triggerbot.stop()
	Hitbox.hideBall()
	setAutoGrab(false)

	for _, conn in ipairs(Skins.conns) do
		pcall(function()
			conn:Disconnect()
		end)
	end

	for tool in pairs(Skins.toolOverlays) do
		pcall(skinClearTool, tool)
	end

	skinClearDisplay("Knife")
	skinClearDisplay("Gun")

	for name in pairs(HUD.guis) do
		pcall(hudDestroy, name)
	end

	setPerfOverlay(false)
	clearNameESP()

	for _, l in pairs(TracerLines) do
		pcall(function()
			l:Remove()
		end)
	end

	pcall(function()
		RunService:Set3dRenderingEnabled(true)
	end)

	genv.mm2VisualLibraryLoaded = false
end

task.delay(0.4, function()
	Notify("Project Zenith", "Loaded successfully. Toggle UI: RightControl. discord.gg/QuFqd2j3Va", "Success", 5)
end)
print("[Project Zenith] UI ready. Toggle with RightControl.")
