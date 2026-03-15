local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

local CHECK_INTERVAL = 0.5
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
            
            -- 최적화: 전체 맵을 뒤지지 않고 주변의 파트만 즉시 검색
            local params = OverlapParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {char}
            
            -- 주변 150스터드 안의 오브젝트만 리스트업 (튕김 방지 핵심)
            local nearby = workspace:GetPartBoundsInRadius(hrp.Position, MAX_DISTANCE, params)
            
            for _, obj in ipairs(nearby) do
                -- 이름이 "_drop"인 아이템만 최소 연산으로 확인
                if obj.Name == "_drop" then
                    local isHealth = obj:FindFirstChild("Health")
                    local isAmmo = obj:FindFirstChild("Ammo")
                    
                    if isAmmo or (isHealth and needsHealth) then
                        firetouchinterest(hrp, obj, 0)
                        task.wait(0.05) -- 실행기가 처리할 시간 제공 (튕김 방지)
                        firetouchinterest(hrp, obj, 1)
                        break -- 한 번의 주기에 딱 하나만 처리 (연산량 급감)
                    end
                end
            end
        end
        task.wait(CHECK_INTERVAL)
    end
end)
