-- Kill All Script: Killer AI
-- When the local player is the killer, pathfind to each survivor, use all abilities on them until they are dead, then move to the next

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

local Event = ReplicatedStorage.Modules.Network.RemoteEvent
local LocalPlayer = Players.LocalPlayer

-- Try to find ability names from the killer's character
local function getAbilityNames()
    local abilities = {}
    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if killersFolder then
        for _, char in ipairs(killersFolder:GetChildren()) do
            if char:IsA("Model") and char.Name == LocalPlayer.Name then
                -- Example: Look for StringValues or RemoteEvents named after abilities
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("StringValue") or child:IsA("RemoteEvent") then
                        table.insert(abilities, child.Name)
                    end
                end
            end
        end
    end
    return abilities
end

local abilities = getAbilityNames()

-- Helper: Get all survivors (not the killer)
local function getSurvivors()
    local survivors = {}
    local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    if survivorsFolder then
        for _, char in ipairs(survivorsFolder:GetChildren()) do
            if char:IsA("Model") and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                table.insert(survivors, char)
            end
        end
    end
    return survivors
end

-- Helper: Pathfind and walk to a position
local function walkTo(targetPos)
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChildOfClass("Humanoid") then return false end
    local path = PathfindingService:CreatePath({
        AgentRadius = 2.5,
        AgentHeight = 6,
        AgentCanJump = true,
        AgentJumpHeight = 7,
        AgentStepHeight = 2,
    })
    path:ComputeAsync(myChar.HumanoidRootPart.Position, targetPos)
    if path.Status ~= Enum.PathStatus.Success then return false end
    local waypoints = path:GetWaypoints()
    for _, wp in ipairs(waypoints) do
        myChar:FindFirstChildOfClass("Humanoid"):MoveTo(wp.Position)
        local reached = false
        local startTime = tick()
        while not reached and tick() - startTime < 5 do
            if (myChar.HumanoidRootPart.Position - wp.Position).Magnitude < 4 then
                reached = true
            end
            RunService.Heartbeat:Wait()
        end
        if not reached then return false end
    end
    return true
end

-- Helper: Use all abilities on a target
local function useAllAbilitiesOn(target)
    for _, ability in ipairs(abilities) do
        Event:FireServer("UseActorAbility", ability)
        task.wait(0.2)
    end
end

-- Main loop
local function killAllSurvivors()
    while true do
        local survivors = getSurvivors()
        if #survivors == 0 then
            print("No survivors left!")
            break
        end
        -- Pick a random survivor
        local target = survivors[math.random(1, #survivors)]
        print("Targeting survivor:", target.Name)
        -- Pathfind to them
        local hrp = target:FindFirstChild("HumanoidRootPart")
        if hrp then
            walkTo(hrp.Position)
            -- Use all abilities until they're dead
            while target.Parent and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 do
                useAllAbilitiesOn(target)
                task.wait(0.5)
            end
            print("Survivor down:", target.Name)
        end
        task.wait(0.5)
    end
    print("All survivors eliminated!")
end

-- Only run if we are the killer
local function isKiller()
    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if killersFolder then
        for _, char in ipairs(killersFolder:GetChildren()) do
            if char:IsA("Model") and char.Name == LocalPlayer.Name then
                return true
            end
        end
    end
    return false
end

-- Start the loop if we are the killer
if isKiller() then
    task.spawn(killAllSurvivors)
else
    print("Not the killer. Script will not run.")
end
