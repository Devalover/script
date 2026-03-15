local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

local CHECK_INTERVAL = 0.5
local MAX_DISTANCE = 250

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
            
            -- 최적화: GetDescendants 대신 GetChildren을 쓰되 맵 전체를 검사 (가장 확실함)
            local allObjects = workspace:GetDescendants()
            
            for _, obj in ipairs(allObjects) do
                -- 이름이 "_drop"인 파트만 정밀 타격
                if obj.Name == "_drop" and obj:IsA("BasePart") then
                    local dist = (hrp.Position - obj.Position).Magnitude
                    
                    if dist <= MAX_DISTANCE then
                        local isHealth = obj:FindFirstChild("Health")
                        local isAmmo = obj:FindFirstChild("Ammo")
                        
                        if isAmmo or (isHealth and needsHealth) then
                            firetouchinterest(hrp, obj, 0)
                            task.wait(0.02)
                            firetouchinterest(hrp, obj, 1)
                            -- 한 번에 하나만 먹어서 연산량 급증 방지
                            break 
                        end
                    end
                end
            end
        end
        task.wait(CHECK_INTERVAL)
    end
end)
