local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

task.spawn(function()
    while true do
        local c = LP.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if not c or not h or h.Health <= 0 then
            VIM:SendKeyEvent(true, 32, false, game)
            task.wait()
            VIM:SendKeyEvent(false, 32, false, game)
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local h = c and c:FindFirstChildOfClass("Humanoid")
        
        if hrp and h and h.Health > 0 then
            local needsHp = h.Health < h.MaxHealth
            local world = workspace:GetChildren()
            
            for i = 1, #world do
                local o = world[i]
                if o.Name == "_drop" then
                    if o:FindFirstChild("Ammo") or (needsHp and o:FindFirstChild("Health")) then
                        firetouchinterest(hrp, o, 0)
                        firetouchinterest(hrp, o, 1)
                    end
                end
            end
        end
        task.wait()
    end
end)
