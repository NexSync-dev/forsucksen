if getgenv and tonumber(getgenv().LoadTime) then
	task.wait(tonumber(getgenv().LoadTime))
else
	repeat
		task.wait()
	until game:IsLoaded()
end
local VIMVIM = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local DCWebhook = (getgenv and getgenv().DiscordWebhook) or false
local GenTime = tonumber(getgenv and getgenv().GeneratorTime) or 2.5

local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
if queueteleport then
	queueteleport([[
        if getgenv then getgenv().DiscordWebhook = "]] .. tostring(DCWebhook) .. [[" end
        loadstring(game:HttpGet('https://raw.githubusercontent.com/NexSync-dev/forsucksen/refs/heads/main/test.lua'))()
    ]])
end

local Nnnnnnotificvationui
local AliveNotificaiotna = {}
local ProfilePicture = ""

if DCWebhook == "" then
	DCWebhook = false
end

local function CreateNotificationUI()
	if Nnnnnnotificvationui then
		return Nnnnnnotificvationui
	end

	Nnnnnnotificvationui = Instance.new("ScreenGui")
	Nnnnnnotificvationui.Name = "NotificationUI"
	Nnnnnnotificvationui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Nnnnnnotificvationui.Parent = game:GetService("CoreGui")

	return Nnnnnnotificvationui
end

local function MakeNotif(title, message, duration, color)
	local ui = CreateNotificationUI()

	title = title or "Notification"
	message = message or ""
	duration = duration or 5
	color = color or Color3.fromRGB(255, 200, 0)

	local notification = Instance.new("Frame")
	notification.Name = "Notification"
	notification.Size = UDim2.new(0, 250, 0, 80)
	notification.Position = UDim2.new(1, 50, 1, 10)
	notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	notification.BorderSizePixel = 0
	notification.Parent = ui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = notification

	local SIGMABERFIOENEW = Instance.new("TextLabel")
	SIGMABERFIOENEW.Name = "Title"
	SIGMABERFIOENEW.Size = UDim2.new(1, -25, 0, 25)
	SIGMABERFIOENEW.Position = UDim2.new(0, 15, 0, 5)
	SIGMABERFIOENEW.Font = Enum.Font.SourceSansBold
	SIGMABERFIOENEW.Text = title
	SIGMABERFIOENEW.TextSize = 18
	SIGMABERFIOENEW.TextColor3 = color
	SIGMABERFIOENEW.BackgroundTransparency = 1
	SIGMABERFIOENEW.TextXAlignment = Enum.TextXAlignment.Left
	SIGMABERFIOENEW.Parent = notification

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Size = UDim2.new(1, -25, 0, 50)
	messageLabel.Position = UDim2.new(0, 15, 0, 30)
	messageLabel.Font = Enum.Font.SourceSans
	messageLabel.Text = message
	messageLabel.TextSize = 16
	messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	messageLabel.BackgroundTransparency = 1
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextWrapped = true
	messageLabel.Parent = notification

	local colorBar = Instance.new("Frame")
	colorBar.Name = "ColorBar"
	colorBar.Size = UDim2.new(0, 5, 1, 0)
	colorBar.Position = UDim2.new(0, 0, 0, 0)
	colorBar.BackgroundColor3 = color
	colorBar.BorderSizePixel = 0
	colorBar.Parent = notification

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 8)
	barCorner.Parent = colorBar

	local offsit = 0
	for _, notif in pairs(AliveNotificaiotna) do
		if notif.Instance and notif.Instance.Parent then
			offsit = offsit + notif.Instance.Size.Y.Offset + 10
		end
	end

	local tagit = UDim2.new(1, -270, 1, -90 - offsit)

	table.insert(AliveNotificaiotna, {
		Instance = notification,
		ExpireTime = os.time() + duration,
	})

	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local ok = game:GetService("TweenService"):Create(notification, tweenInfo, { Position = tagit })
	ok:Play()

	task.spawn(function()
		task.wait(duration)

		local tweenOut = game:GetService("TweenService"):Create(
			notification,
			TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
			{ Position = UDim2.new(1, 50, notification.Position.Y.Scale, notification.Position.Y.Offset) }
		)

		tweenOut:Play()
		tweenOut.Completed:Wait()

		for i, notif in pairs(AliveNotificaiotna) do
			if notif.Instance == notification then
				table.remove(AliveNotificaiotna, i)
				break
			end
		end

		notification:Destroy()

		task.wait()
		local currentOffset = 0
		for _, notif in pairs(AliveNotificaiotna) do
			if notif.Instance and notif.Instance.Parent then
				game:GetService("TweenService")
					:Create(
						notif.Instance,
						TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ Position = UDim2.new(1, -270, 1, -90 - currentOffset) }
					)
					:Play()

				currentOffset = currentOffset + notif.Instance.Size.Y.Offset + 10
			end
		end
	end)

	return notification
end

task.spawn(function()
	while task.wait(1) do
		local currentTime = os.time()
		local reposition = false

		for i = #AliveNotificaiotna, 1, -1 do
			local notif = AliveNotificaiotna[i]
			if currentTime > notif.ExpireTime and notif.Instance and notif.Instance.Parent then
				notif.Instance:Destroy()
				table.remove(AliveNotificaiotna, i)
				reposition = true
			end
		end

		if reposition then
			local currentOffset = 0
			for _, notif in pairs(AliveNotificaiotna) do
				if notif.Instance and notif.Instance.Parent then
					notif.Instance.Position = UDim2.new(1, -270, 1, -90 - currentOffset)
					currentOffset = currentOffset + notif.Instance.Size.Y.Offset + 10
				end
			end
		end
	end
end)

MakeNotif("Gen Pathfinding Shit", "It Loaded!", 5, Color3.fromRGB(115, 194, 89))

local function GetProfilePicture()
	local PlayerID = game:GetService("Players").LocalPlayer.UserId
	local request = request or http_request or syn.request
	local response = request({
		Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
			.. PlayerID
			.. "&size=180x180&format=png",
		Method = "GET",
		Headers = {
			["User-Agent"] = "Mozilla/5.0",
		},
	})
	local urlStart, urlEnd = string.find(response.Body, "https://[%w-_%.%?%.:/%+=&]+")
	if urlStart and urlEnd then
		ProfilePicture = string.sub(response.Body, urlStart, urlEnd)
	else
		ProfilePicture = "https://cdn.sussy.dev/bleh.jpg"
	end
end

if DCWebhook then
	GetProfilePicture()
end

local function SendWebhook(Title, Description, Color, ProfilePicture, Footer)
	if not DCWebhook then
		return
	end
	local request = request or http_request or syn.request
	if not request then
		return
	end

	local success, errorMessage = pcall(function()
		local response = request({
			Url = DCWebhook,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = game:GetService("HttpService"):JSONEncode({
				username = game:GetService("Players").LocalPlayer.DisplayName,
				avatar_url = ProfilePicture,
				embeds = {
					{
						title = Title,
						description = Description,
						color = Color,
						footer = { text = Footer },
					},
				},
			}),
		})
		if response and response.Body then
			print(response.Body)
		end
	end)

	MakeNotif("PathfindGens", "Sent webhook: " .. Title .. "\n" .. Description, 5, Color3.fromRGB(115, 194, 89))
	if not success then
		print("Error: " .. errorMessage)
	end
end

task.spawn(function()
	pcall(function()
		game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent:FireServer(
			"UpdateSettings",
			game:GetService("Players").LocalPlayer.PlayerData.Settings.Game.MaliceDisabled,
			true
		)
	end)
end)

if _G.CancelPathEvent then
	_G.CancelPathEvent:Fire()
end

_G.CancelPathEvent = Instance.new("BindableEvent")

pcall(function()
	local Controller =
		require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
	Controller:Disable()
end)

local function teleportToRandomServer()
	local Counter = 0
	local MaxRetry = 10
	local RetryingDelays = 10

	local Request = http_request or syn.request or request
	if Request then
		local url = "https://games.roblox.com/v1/games/18687417158/servers/Public?sortOrder=Asc&limit=100"

		while Counter < MaxRetry do
			local success, response = pcall(function()
				return Request({
					Url = url,
					Method = "GET",
					Headers = { ["Content-Type"] = "application/json" },
				})
			end)

			if success and response and response.Body then
				local data = HttpService:JSONDecode(response.Body)
				if data and data.data and #data.data > 0 then
					local server = data.data[math.random(1, #data.data)]
					if server.id then
						MakeNotif(
							"Teleporting...",
							"Attempting to teleport to server: " .. server.id,
							5,
							Color3.fromRGB(115, 194, 89)
						)
						task.wait(0.25)
						TeleportService:TeleportToPlaceInstance(18687417158, server.id, Players.LocalPlayer)
						return
					end
				end
			end

			Counter = Counter + 1
			MakeNotif(
				"PathfindGens",
				"Retrying to get a server... Attempt " .. Counter .. "/" .. MaxRetry,
				5,
				Color3.fromRGB(255, 0, 0)
			)
			task.wait(RetryingDelays)
		end
	end
end

task.delay(2.5, function()
	pcall(function()
		local timer = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("RoundTimer").Main.Time.ContentText
		local minutes, seconds = timer:match("(%d+):(%d+)")
		local totalSeconds = tonumber(minutes) * 60 + tonumber(seconds)
		print(totalSeconds .. " Left till round end.")
		MakeNotif("PathfindGens", "Round ends in " .. totalSeconds .. " seconds.", 5, Color3.fromRGB(115, 194, 89))
		if totalSeconds > 90 then
			teleportToRandomServer()
		end
	end)
end)

local function findGenerators()
	local folder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
	local map = folder and folder:FindFirstChild("Map")
	local generators = {}
	if map then
		for _, g in ipairs(map:GetChildren()) do
			if g.Name == "Generator" and g.Progress.Value < 100 then
				local playersNearby = false
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= Players.LocalPlayer and player:DistanceFromCharacter(g:GetPivot().Position) <= 25 then
						playersNearby = true
					end
				end
				if not playersNearby then
					table.insert(generators, g)
				end
			end
		end
	end

	table.sort(generators, function(a, b)
		local player = Players.LocalPlayer
		local character = player.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then
			return false
		end
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		local aPosition = a:IsA("Model") and a:GetPivot().Position or a.Position
		local bPosition = b:IsA("Model") and b:GetPivot().Position or b.Position
		return (aPosition - rootPart.Position).Magnitude < (bPosition - rootPart.Position).Magnitude
	end)

	return generators
end

local function VisualizePivot(model)
	local pivot = model:GetPivot()

	for i, dir in ipairs({
		{ pivot.LookVector, Color3.fromRGB(0, 255, 0), "Front" },
		{ -pivot.LookVector, Color3.fromRGB(255, 0, 0), "Back" },
		{ pivot.RightVector, Color3.fromRGB(255, 255, 0), "Right" },
		{ -pivot.RightVector, Color3.fromRGB(0, 0, 255), "Left" },
	}) do
		local part = Instance.new("Part")
		part.Size = Vector3.new(1, 1, 1)
		part.Anchored = true
		part.CanCollide = false
		part.Color = dir[2]
		part.Name = dir[3]
		part.Position = pivot.Position + dir[1] * 5
		part.Parent = workspace
	end
end


local function InGenerator()
	for i, v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.TemporaryUI:GetChildren()) do
		print(v.Name)
		if string.sub(v.Name, 1, 3) == "Gen" then
			print("not in generator")
			return false
		end
	end
	print("didnt find frame")
	return true
end

local function PathFinding(generator)
	local success, SkibidiSprinting = pcall(function()
		local a = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
		a.StaminaLossDisabled = true
	end)

	local activeNodes = {}

	local function createNode(position)
		local part = Instance.new("Part")
		part.Size = Vector3.new(0.6, 0.6, 0.6)
		part.Shape = Enum.PartType.Ball
		part.Material = Enum.Material.Neon
		part.Color = Color3.fromRGB(248, 255, 150)
		part.Transparency = 0.5
		part.Anchored = true
		part.CanCollide = false
		part.Position = position + Vector3.new(0, 1.5, 0)
		part.Parent = workspace
		table.insert(activeNodes, part)
		game:GetService("Debris"):AddItem(part, 15)
	end

	local acidContainer = workspace:FindFirstChild("Map")
		and workspace.Map:FindFirstChild("Ingame")
		and workspace.Map.Ingame:FindFirstChild("Map")
		and workspace.Map.Ingame.Map:FindFirstChild("AcidContainer")
		and workspace.Map.Ingame.Map.AcidContainer:FindFirstChild("AcidDirt")
	if acidContainer then
		for _, part in ipairs(acidContainer:GetChildren()) do
			if part.Name == "Dirt" and part.Size.Y < 12 then
				part.Size = Vector3.new(part.Size.X, 13, part.Size.Z)
			end
		end
	end

	if not generator or not generator.Parent then
		return false
	end
	if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return false
	end

	local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local rootPart = Players.LocalPlayer.Character.HumanoidRootPart
	if not humanoid then
		return false
	end

	local targetPosition = generator:GetPivot().Position + generator:GetPivot().LookVector * 3
	if not targetPosition then
		return false
	end

	VisualizePivot(generator)

	local path = game:GetService("PathfindingService"):CreatePath({
		AgentRadius = 2.5,
		AgentHeight = 6,
		AgentCanJump = false,
		AgentJumpHeight = 0,
		AgentStepHeight = 2,
	})

	local success, errorMessage = pcall(function()
		path:ComputeAsync(rootPart.Position, targetPosition)
	end)

	if not success or path.Status ~= Enum.PathStatus.Success then
		print("Path computation failed:", errorMessage)
		return false
	end

	local waypoints = path:GetWaypoints()

	if #waypoints <= 1 then
		return false
	end

	for i, waypoint in ipairs(waypoints) do
		createNode(waypoint.Position)
		humanoid:MoveTo(waypoint.Position)

		local reachedWaypoint = false
		local startTime = tick()
		while not reachedWaypoint and tick() - startTime < 5 do
			local distance = (rootPart.Position - waypoint.Position).Magnitude
			if distance < 5 then
				reachedWaypoint = true
				break
			end
			RunService.Heartbeat:Wait()
		end

		if not reachedWaypoint then
			if game:GetService("Players").LocalPlayer.Character:FindFirstChild("SpeedMultipliers"):FindFirstChild("Sprinting").Value < 1.1 then
				VIMVIM:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, nil)
			end
			return false
		end
	end

	for _, node in ipairs(activeNodes) do
		node:Destroy()
	end

	return true
end

local function DoAllGenerators()
	for _, g in ipairs(findGenerators()) do
		local pathStarted = false
		for attempt = 1, 3 do
			-- dont need cuz im sigma mafiza boy
			-- local playersNearby = false
			-- for _, player in ipairs(Players:GetPlayers()) do
			-- 	if player ~= Players.LocalPlayer and player:DistanceFromCharacter(g:GetPivot().Position) <= 25 then
			-- 		playersNearby = true
			-- 		break
			-- 	end
			-- end

			if (Players.LocalPlayer.Character:GetPivot().Position - g:GetPivot().Position).Magnitude > 500 then
				break
			end

			-- if not playersNearby and g:FindFirstChild("Progress") and g.Progress.Value < 100 then
			-- g:GetPivot()
			-- end

			pathStarted = PathFinding(g)
			if pathStarted then
				break
			else
				task.wait(1)
			end
		end
		if pathStarted then
			task.wait(0.5)
			local prompt = g:FindFirstChild("Main") and g.Main:FindFirstChild("Prompt")
			if prompt then
				fireproximityprompt(prompt)
				task.wait(0.5)
				if not InGenerator() then
					local positions = {
						g:GetPivot().Position - g:GetPivot().RightVector * 3,
						g:GetPivot().Position + g:GetPivot().RightVector * 3,
					}
					for i, pos in ipairs(positions) do
						print("Trying position", i)
						Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
						task.wait(0.25)
						fireproximityprompt(prompt)
						if InGenerator() then
							break
						end
					end
				end
			end
			for i = 1, 6 do
				if g.Progress.Value < 100 and g:FindFirstChild("Remotes") and g.Remotes:FindFirstChild("RE") then
					g.Remotes.RE:FireServer()
				end
				if i < 6 and g.Progress.Value < 100 then
					task.wait(GenTime)
				end
			end
		else
			return
		end
	end
	SendWebhook(
		"Generator Autofarm thing",
		"Finished all generators, Current Balance: "
			.. game:GetService("Players").LocalPlayer.PlayerData.Stats.Currency.Money.Value
			.. "\nTime Played: "
			.. (function()
				local seconds = game:GetService("Players").LocalPlayer.PlayerData.Stats.General.TimePlayed.Value
				local days = math.floor(seconds / (60 * 60 * 24))
				seconds = seconds % (60 * 60 * 24)
				local hours = math.floor(seconds / (60 * 60))
				seconds = seconds % (60 * 60)
				local minutes = math.floor(seconds / 60)
				seconds = seconds % 60
				return string.format("%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
			end)(),
		0x00FF00,
		ProfilePicture,
		".gg/fartsaken | <3"
	)
	task.wait(1)
	teleportToRandomServer()
end

local function AmIInGameYet()
	workspace.Players.Survivors.ChildAdded:Connect(function(child)
		task.wait(1)
		if child == game:GetService("Players").LocalPlayer.Character then
			task.wait(4)
			DoAllGenerators()
		end
	end)
end

local function DidiDie()
	while task.wait(0.5) do
		if Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
			if Players.LocalPlayer.Character.Humanoid.Health == 0 then
				SendWebhook(
					"Generator Autofarm",
					"THIS STUPID KILLER KILLED ME IM SO ANGRY OMG \nCurrent Balance: "
						.. game:GetService("Players").LocalPlayer.PlayerData.Stats.Currency.Money.Value
						.. "\nTime Played: "
						.. (function()
							local seconds =
								game:GetService("Players").LocalPlayer.PlayerData.Stats.General.TimePlayed.Value
							local days = math.floor(seconds / (60 * 60 * 24))
							seconds = seconds % (60 * 60 * 24)
							local hours = math.floor(seconds / (60 * 60))
							seconds = seconds % (60 * 60)
							local minutes = math.floor(seconds / 60)
							seconds = seconds % 60
							return string.format("%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
						end)(),
					0xFF0000,
					ProfilePicture,
					".gg/fartsaken | <3"
				)
				task.wait(0.5)
				teleportToRandomServer()
				break
			end
		end
	end
end

pcall(task.spawn(DidiDie))
AmIInGameYet()

local function SetSpeed(multiplier)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
    if humanoid then
        local baseSpeed = humanoid.WalkSpeed or 16
        humanoid.WalkSpeed = baseSpeed * multiplier
    end
    if char:FindFirstChild("SpeedMultipliers") then
        local sprinting = char.SpeedMultipliers:FindFirstChild("Sprinting")
        if sprinting then
            sprinting.Value = multiplier
        end
    end
end

local desiredSprintMultiplier = 4

local function AutoSprint()
    while true do
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("SpeedMultipliers") then
            local sprinting = char.SpeedMultipliers:FindFirstChild("Sprinting")
            if sprinting and sprinting.Value ~= desiredSprintMultiplier then
                sprinting.Value = desiredSprintMultiplier
            end
        end
        task.wait(0.1)
    end
end

pcall(function()
    task.spawn(AutoSprint)
end)

SetSpeed(desiredSprintMultiplier)

local function GetKillerPosition()
    local killersGroup = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if killersGroup then
        for _, killerModel in ipairs(killersGroup:GetChildren()) do
            local hrp = killerModel:FindFirstChild("HumanoidRootPart")
            if hrp then
                return hrp.Position, killerModel
            end
        end
    end
    return nil, nil
end

local invisRunning = false
local IsInvis = false
local IsRunning = true
local InvisibleCharacter, Character, Player, invisFix, invisDied, Void, CF
local lastPosition = nil

function GoInvisible(speaker)
    if invisRunning then return end
    invisRunning = true
    Player = speaker
    repeat wait(.1) until Player.Character
    Character = Player.Character
    Character.Archivable = true
    IsInvis = false
    IsRunning = true
    InvisibleCharacter = Character:Clone()
    InvisibleCharacter.Parent = game:GetService("Lighting")
    Void = workspace.FallenPartsDestroyHeight
    InvisibleCharacter.Name = ""
    local CF

    invisFix = game:GetService("RunService").Stepped:Connect(function()
        pcall(function()
            local IsInteger
            if tostring(Void):find'-' then
                IsInteger = true
            else
                IsInteger = false
            end
            local Pos = Player.Character.HumanoidRootPart.Position
            local Pos_String = tostring(Pos)
            local Pos_Seperate = Pos_String:split(', ')
            local X = tonumber(Pos_Seperate[1])
            local Y = tonumber(Pos_Seperate[2])
            local Z = tonumber(Pos_Seperate[3])
            if IsInteger == true then
                if Y <= Void then
                    Respawn()
                end
            elseif IsInteger == false then
                if Y >= Void then
                    Respawn()
                end
            end
        end)
    end)

    for i,v in pairs(InvisibleCharacter:GetDescendants())do
        if v:IsA("BasePart") then
            if v.Name == "HumanoidRootPart" then
                v.Transparency = 1
            else
                v.Transparency = .5
            end
        end
    end

    function Respawn()
        IsRunning = false
        if IsInvis == true then
            pcall(function()
                Player.Character = Character
                wait()
                Character.Parent = workspace
                Character:FindFirstChildWhichIsA'Humanoid':Destroy()
                IsInvis = false
                InvisibleCharacter.Parent = nil
                invisRunning = false
            end)
        elseif IsInvis == false then
            pcall(function()
                Player.Character = Character
                wait()
                Character.Parent = workspace
                Character:FindFirstChildWhichIsA'Humanoid':Destroy()
                TurnVisible()
            end)
        end
    end

    invisDied = InvisibleCharacter:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
        Respawn()
        invisDied:Disconnect()
    end)

    if IsInvis == true then return end
    IsInvis = true
    CF = workspace.CurrentCamera.CFrame
    local CF_1 = Player.Character.HumanoidRootPart.CFrame
    lastPosition = Player.Character.HumanoidRootPart.CFrame
    Character:MoveTo(Vector3.new(0, math.pi*1000000, 0))
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    wait(.2)
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    InvisibleCharacter = InvisibleCharacter
    Character.Parent = game:GetService("Lighting")
    InvisibleCharacter.Parent = workspace
    InvisibleCharacter.HumanoidRootPart.CFrame = CF_1
    Player.Character = InvisibleCharacter
    -- execCmd('fixcam') -- If you want to keep this, make sure fixcam is defined
    Player.Character.Animate.Disabled = true
    Player.Character.Animate.Disabled = false

    notify('Invisible','You now appear invisible to other players')
end

function TurnVisible()
    print("TurnVisible called")
    if IsInvis == false then return end
    if invisFix then invisFix:Disconnect() end
    if invisDied then invisDied:Disconnect() end
    CF = workspace.CurrentCamera.CFrame
    Character = Character
    local CF_1 = Player.Character.HumanoidRootPart.CFrame
    if lastPosition then
        Character.HumanoidRootPart.CFrame = lastPosition
    end
    if InvisibleCharacter then InvisibleCharacter:Destroy() end
    Player.Character = Character
    Character.Parent = workspace
    IsInvis = false
    Player.Character.Animate.Disabled = true
    Player.Character.Animate.Disabled = false
    invisDied = Character:FindFirstChildOfClass'Humanoid'.Died:Connect(function()
        Respawn()
        invisDied:Disconnect()
    end)
    invisRunning = false
    print("TurnVisible finished, invisRunning:", invisRunning, "IsInvis:", IsInvis)
end

task.spawn(function()
    while true do
        local killersGroup = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
        local myChar = game.Players.LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local killerClose = false

        if killersGroup and myRoot then
            for _, killerModel in ipairs(killersGroup:GetChildren()) do
                local hrp = killerModel:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (myRoot.Position - hrp.Position).Magnitude
                    -- Debug print
                    print("Killer", killerModel.Name, "distance:", dist)
                    if dist <= 10 then
                        killerClose = true
                        break
                    end
                end
            end
        end

        if killerClose then
            if not invisRunning then
                print("Turning invisible: killer is close")
                GoInvisible(game.Players.LocalPlayer)
            end
        else
            if invisRunning then
                print("Turning visible: killer is far")
                TurnVisible()
            end
        end

        task.wait(0.1)
    end
end)
