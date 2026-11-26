local AirControl = {}
local processedAir = {}
local processedGrav = {}

function AirControl.applyTweakDB(cfg)
    if not cfg.enableAirControl then return 0 end
    local count = 0

    local gravRecords = TweakDB:GetRecords("gamedataInAirGravityModifier_Record")
    if gravRecords then
        for _, gRec in ipairs(gravRecords) do
            pcall(function()
                local gID = gRec:GetID()
                local gPath = gID.value
                if gPath and not processedGrav[gPath] then
                    processedGrav[gPath] = true
                    local addedGrav = TweakDB:GetFlat(gPath .. ".driveSpeedAddedGravity")
                    if type(addedGrav) == "number" then
                        TweakDB:SetFlatNoUpdate(gPath .. ".driveSpeedAddedGravity", addedGrav * cfg.airControl.gravityScale)
                    end
                    local baseGrav = TweakDB:GetFlat(gPath .. ".baseAddedGravity")
                    if type(baseGrav) == "number" then
                        TweakDB:SetFlatNoUpdate(gPath .. ".baseAddedGravity", baseGrav * cfg.airControl.gravityScale)
                    end
                    TweakDB:Update(gID)
                end
            end)
        end
    end

    local vehicles = TweakDB:GetRecords("gamedataVehicle_Record")
    if vehicles then
        for _, veh in ipairs(vehicles) do
            pcall(function()
                local airRec = veh:VehAirControl()
                if not airRec then return end
                local airID = airRec:GetID()
                local airPath = airID.value
                if airPath and airPath ~= "" and not processedAir[airPath] then
                    processedAir[airPath] = true
                    TweakDB:SetFlatNoUpdate(airPath .. ".massReference", 1750.0)
                    TweakDB:SetFlatNoUpdate(airPath .. ".flippedOverRecoveryPID", Vector3.new(-240.0, 0.0, -25.0))
                    TweakDB:Update(airID)
                    count = count + 1
                end
            end)
        end
    end
    return count
end

local function applySmoothTorque(vehicle, pos, offsetAxis, forceDir, magnitude)
    local evPos = PhysicalImpulseEvent.new()
    evPos.bodyIndex = 0
    evPos.worldPosition = Vector3.new(pos.x + offsetAxis.x, pos.y + offsetAxis.y, pos.z + offsetAxis.z)
    evPos.worldImpulse = Vector3.new(forceDir.x * magnitude, forceDir.y * magnitude, forceDir.z * magnitude)
    vehicle:QueueEvent(evPos)

    local evNeg = PhysicalImpulseEvent.new()
    evNeg.bodyIndex = 0
    evNeg.worldPosition = Vector3.new(pos.x - offsetAxis.x, pos.y - offsetAxis.y, pos.z - offsetAxis.z)
    evNeg.worldImpulse = Vector3.new(-forceDir.x * magnitude, -forceDir.y * magnitude, -forceDir.z * magnitude)
    vehicle:QueueEvent(evNeg)
end

function AirControl.onUpdate(vehicle, dt, inputs, cfg)
    if not cfg.enableAirControl then return end

    local pos = vehicle:GetWorldPosition()
    local fwd = vehicle:GetWorldForward()
    local right = vehicle:GetWorldRight()
    local up = vehicle:GetWorldUp()

    local spatial = Game.GetSpatialQueriesSystem()
    if not spatial then return end

    local rayStart = Vector4.new(pos.x, pos.y, pos.z + 0.35, 1.0)
    local rayEnd   = Vector4.new(pos.x, pos.y, pos.z - 0.95, 1.0)
    local hitStatic = spatial:SyncRaycastByCollisionGroup(rayStart, rayEnd, "Static", false, false)
    local hitTerrain = spatial:SyncRaycastByCollisionGroup(rayStart, rayEnd, "Terrain", false, false)
    local isAirborne = (not hitStatic) and (not hitTerrain)

    local mass = 1600.0
    pcall(function()
        local m = vehicle:GetTotalMass()
        if m and m > 100.0 then mass = m end
    end)

    if isAirborne then
        local baseScale = mass * dt * cfg.airControl.angularDamping

        if math.abs(inputs.steer) > 0.05 then
            local rollMag = -inputs.steer * cfg.airControl.rollStrength * baseScale
            applySmoothTorque(vehicle, pos, right, up, rollMag)

            local yawMag = inputs.steer * cfg.airControl.yawStrength * 0.35 * baseScale
            applySmoothTorque(vehicle, pos, fwd, right, yawMag)
        end

        if math.abs(inputs.pitch) > 0.05 then
            local pitchMag = inputs.pitch * cfg.airControl.pitchStrength * baseScale
            applySmoothTorque(vehicle, pos, fwd, up, pitchMag)
        end

    elseif cfg.airControl.autoUprightAssist and up.z < 0.25 and math.abs(inputs.steer) > 0.2 then
        local recoverMag = -inputs.steer * cfg.airControl.rollStrength * 1.45 * mass * dt
        local liftAxis = Vector4.new(right.x, right.y, 0.0, 0.0)
        local worldUp  = Vector4.new(0.0, 0.0, 1.0, 0.0)
        applySmoothTorque(vehicle, pos, liftAxis, worldUp, recoverMag)
    end
end

return AirControl
