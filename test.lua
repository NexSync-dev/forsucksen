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

-- local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
-- if queueteleport then
-- 	queueteleport([[
--         if getgenv then getgenv().DiscordWebhook = "]] .. tostring(DCWebhook) .. [[" end
--         loadstring(game:HttpGet('https://raw.githubusercontent.com/ivannetta/ShitScripts/main/PathfindGens.lua'))()
--     ]])
-- end

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

-- Smart position check for teleporting
local function IsPositionClear(fromPosition, toPosition)
	local characterSize = Vector3.new(2, 4, 2) -- Approximate player size (width, height, depth)
	local offsets = {
		Vector3.new(0, 0, 0), -- center
		Vector3.new(characterSize.X/2, 0, 0), -- right
		Vector3.new(-characterSize.X/2, 0, 0), -- left
		Vector3.new(0, 0, characterSize.Z/2), -- front
		Vector3.new(0, 0, -characterSize.Z/2), -- back
	}
	local raycastParams = RaycastParams.new()
	if Players.LocalPlayer.Character then
		raycastParams.FilterDescendantsInstances = {Players.LocalPlayer.Character}
	end
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.IgnoreWater = true

	for _, offset in ipairs(offsets) do
		local start = fromPosition + offset
		local finish = toPosition + offset
		local direction = finish - start
		local result = workspace:Raycast(start, direction, raycastParams)
		if result then
			return false
		end
	end

	-- Check for floor at the target position
	local floorRay = workspace:Raycast(toPosition + Vector3.new(0, 2, 0), Vector3.new(0, -6, 0), raycastParams)
	if not floorRay then
		return false
	end

	-- Check that the position is not below the map (e.g., y > 2)
	if toPosition.Y < 2 then
		return false
	end
	return true
end

local function TeleportNearGenerator(generator)
	if not generator or not generator.Parent then return false end
	if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end

	local rootPart = Players.LocalPlayer.Character.HumanoidRootPart
	local genPivot = generator:GetPivot()
	local directions = {
		genPivot.LookVector,      -- Forward
		-genPivot.LookVector,     -- Backward
		genPivot.RightVector,     -- Right
		-genPivot.RightVector,    -- Left
	}

	-- Shuffle directions for randomness
	for i = #directions, 2, -1 do
		local j = math.random(i)
		directions[i], directions[j] = directions[j], directions[i]
	end

	for _, dir in ipairs(directions) do
		local distance = math.random(2, 5) -- randomize distance from 2 to 5 studs
		local targetPos = genPivot.Position + dir * distance
		if IsPositionClear(genPivot.Position, targetPos) then
			rootPart.CFrame = CFrame.new(targetPos)
			return true
		end
	end

	-- If all positions are blocked, TP to a random spot near the generator
	local randomDir = directions[math.random(1, #directions)]
	local randomDist = math.random(2, 5)
	rootPart.CFrame = CFrame.new(genPivot.Position + randomDir * randomDist)
	return true
end

-- Replace DoAllGenerators pathfinding with smart TP
local function DoAllGenerators()
	for _, g in ipairs(findGenerators()) do
		local pathStarted = false
		for attempt = 1, 3 do
			if (Players.LocalPlayer.Character:GetPivot().Position - g:GetPivot().Position).Magnitude > 500 then
				break
			end

			pathStarted = TeleportNearGenerator(g)
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
				task.wait(1)
			end
		end
		if not pathStarted then
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
