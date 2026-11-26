local Collision = {}
local processedDrive = {}
local prevVel = nil
local cooldown = 0.0

function Collision.applyTweakDB(cfg)
    if not cfg.enableCollision then return 0 end
    local count = 0
    local vehicles = TweakDB:GetRecords("gamedataVehicle_Record")
    if not vehicles then return 0 end

    for _, veh in ipairs(vehicles) do
        pcall(function()
            local driveRec = veh:VehDriveModelData()
            if not driveRec then return end
            local driveID = driveRec:GetID()
            local drivePath = driveID.value

            if drivePath and drivePath ~= "" and not processedDrive[drivePath] then
                processedDrive[drivePath] = true

                local bf = TweakDB:GetFlat(drivePath .. ".bodyFriction")
                if type(bf) == "number" then
                    TweakDB:SetFlatNoUpdate(drivePath .. ".bodyFriction", bf * cfg.collision.bodyFrictionMul)
                end

                local lowStop = TweakDB:GetFlat(drivePath .. ".lowVelStoppingDeceleration")
                if type(lowStop) == "number" then
                    TweakDB:SetFlatNoUpdate(drivePath .. ".lowVelStoppingDeceleration", lowStop * 0.40)
                end

                TweakDB:Update(driveID)
                count = count + 1
            end
        end)
    end
    return count
end

function Collision.reset()
    prevVel = nil
    cooldown = 0.0
end

function Collision.onUpdate(vehicle, dt, cfg)
    if not cfg.enableCollision then return end
    if cooldown > 0.0 then cooldown = cooldown - dt end

    local curVel = vehicle:GetLinearVelocity()
    if not prevVel then
        prevVel = Vector4.new(curVel.x, curVel.y, curVel.z, 0.0)
        return
    end

    local prevSpeed = math.sqrt(prevVel.x * prevVel.x + prevVel.y * prevVel.y + prevVel.z * prevVel.z)
    local curSpeed  = math.sqrt(curVel.x * curVel.x + curVel.y * curVel.y + curVel.z * curVel.z)
    local speedDrop = prevSpeed - curSpeed

    if cooldown <= 0.0 and prevSpeed > 8.0 and speedDrop > cfg.collision.impactThreshold then
        local mass = 1600.0
        pcall(function()
            local m = vehicle:GetTotalMass()
            if m and m > 100.0 then mass = m end
        end)

        local slideX = curVel.x * 0.7 + prevVel.x * 0.3
        local slideY = curVel.y * 0.7 + prevVel.y * 0.3
        local slideLen = math.sqrt(slideX * slideX + slideY * slideY)

        if slideLen > 0.25 then
            local dirX = slideX / slideLen
            local dirY = slideY / slideLen
            local keepImpulse = mass * speedDrop * cfg.collision.momentumKeepRatio

            local pos = vehicle:GetWorldPosition()
            local right = vehicle:GetWorldRight()

            local ev = PhysicalImpulseEvent.new()
            ev.bodyIndex = 0
            ev.worldPosition = Vector3.new(pos.x + right.x * 0.25, pos.y + right.y * 0.25, pos.z + 0.2)
            ev.worldImpulse  = Vector3.new(dirX * keepImpulse, dirY * keepImpulse, keepImpulse * 0.08)
            vehicle:QueueEvent(ev)

            cooldown = 0.22
        end
    end

    prevVel = Vector4.new(curVel.x, curVel.y, curVel.z, 0.0)
end

return Collision
