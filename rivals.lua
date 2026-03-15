local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

local CHECK_INTERVAL = 1.0
local MAX_DISTANCE = 150

task.spawn(function()
    while task.wait(1.0) do
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        
        if not char or not hum or hum.Health <= 0 then
            VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end
end)

task.spawn(function()
    while true do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hrp and hum and hum.Health > 0 then
            local needsHealth = hum.Health < hum.MaxHealth
            
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj.Name == "_drop" and obj:IsA("BasePart") then
                    local dist = (hrp.Position - obj.Position).Magnitude
                    
                    if dist <= MAX_DISTANCE then
                        local isHealth = obj:FindFirstChild("Health")
                        local isAmmo = obj:FindFirstChild("Ammo")
                        
                        if isAmmo or (isHealth and needsHealth) then
                            firetouchinterest(hrp, obj, 0)
                            task.wait(0.05)
                            firetouchinterest(hrp, obj, 1)
                            break
                        end
                    end
                end
            end
        end
        task.wait(CHECK_INTERVAL)
    end
end)
