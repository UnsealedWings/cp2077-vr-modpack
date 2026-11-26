local Climbing = {}
local processedDrive = {}
local processedWheel = {}

function Climbing.applyTweakDB(cfg)
    if not cfg.enableClimbing then return 0 end
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
                TweakDB:SetFlatNoUpdate(drivePath .. ".slopeTractionReductionBegin", 80.0)
                TweakDB:SetFlatNoUpdate(drivePath .. ".slopeTractionReductionFactor", 0.20)

                local wsID = TweakDB:GetFlat(drivePath .. ".wheelSetup")
                if wsID and wsID.value ~= "" then
                    local fID = TweakDB:GetFlat(wsID.value .. ".frontPreset")
                    local bID = TweakDB:GetFlat(wsID.value .. ".backPreset") or TweakDB:GetFlat(wsID.value .. ".rearPreset")
                    for _, pID in ipairs({ fID, bID }) do
                        if pID and pID.value ~= "" and not processedWheel[pID.value] then
                            processedWheel[pID.value] = true
                            TweakDB:SetFlatNoUpdate(pID.value .. ".extremeCompressionEventScalor", 0.18)
                            TweakDB:Update(pID)
                        end
                    end
                end

                TweakDB:Update(driveID)
                count = count + 1
            end
        end)
    end
    return count
end

local function probeClimbRay(spatial, origin, dirVec, dist, maxH)
    local lowStart = Vector4.new(origin.x, origin.y, origin.z + 0.30, 1.0)
    local lowEnd   = Vector4.new(
        lowStart.x + dirVec.x * dist,
        lowStart.y + dirVec.y * dist,
        lowStart.z + dirVec.z * dist,
        1.0
    )

    local hitLow = spatial:SyncRaycastByCollisionGroup(lowStart, lowEnd, "Static", false, false)
                or spatial:SyncRaycastByCollisionGroup(lowStart, lowEnd, "Terrain", false, false)

    if not hitLow then
        return false, false
    end

    local highStart = Vector4.new(origin.x, origin.y, origin.z + maxH + 0.45, 1.0)
    local highEnd   = Vector4.new(
        highStart.x + dirVec.x * (dist + 0.35),
        highStart.y + dirVec.y * (dist + 0.35),
        highStart.z + dirVec.z * (dist + 0.35),
        1.0
    )

    local hitHigh = spatial:SyncRaycastByCollisionGroup(highStart, highEnd, "Static", false, false)
    return true, hitHigh
end

function Climbing.onUpdate(vehicle, dt, inputs, cfg)
    if not cfg.enableClimbing then return end

    local activeDrive = math.max(inputs.throttle, inputs.brake * 0.6)
    if activeDrive <= 0.10 then return end

    local vel = vehicle:GetLinearVelocity()
    local speed = math.sqrt(vel.x * vel.x + vel.y * vel.y + vel.z * vel.z)
    if speed > 32.0 then return end

    local spatial = Game.GetSpatialQueriesSystem()
    if not spatial then return end

    local pos      = vehicle:GetWorldPosition()
    local rawFwd   = vehicle:GetWorldForward()
    local rawRight = vehicle:GetWorldRight()
    local rawUp    = vehicle:GetWorldUp()

    if rawUp.z < 0.30 then return end

    local isBike = false
    pcall(function()
        if vehicle:IsA("vehicleBikeBaseObject") then
            isBike = true
        elseif vehicle:GetRecord():Type():Type() == gamedataVehicleType.Bike then
            isBike = true
        end
    end)

    local rLen = math.sqrt(rawRight.x * rawRight.x + rawRight.y * rawRight.y)
    if rLen < 0.01 then return end
    local flatRight = { x = rawRight.x / rLen, y = rawRight.y / rLen, z = 0.0 }

    local safeFwdZ = math.max(0.0, rawFwd.z)
    local fLen = math.sqrt(rawFwd.x * rawFwd.x + rawFwd.y * rawFwd.y + safeFwdZ * safeFwdZ)
    if fLen < 0.01 then return end
    local cleanFwd = { x = rawFwd.x / fLen, y = rawFwd.y / fLen, z = safeFwdZ / fLen }

    local mass = 1600.0
    pcall(function()
        local m = vehicle:GetTotalMass()
        if m and m > 80.0 then mass = m end
    end)

    local maxH      = cfg.climbing.maxObstacleHeight or 1.35
    local baseForce = mass * (cfg.climbing.climbForce or 5.80) * activeDrive * dt

    if isBike then
        local bikeDist = 1.25
        local bikeFront = {
            x = pos.x + cleanFwd.x * 0.75,
            y = pos.y + cleanFwd.y * 0.75,
            z = pos.z + cleanFwd.z * 0.75
        }

        local sx = cleanFwd.x + flatRight.x * (inputs.steer * 0.50)
        local sy = cleanFwd.y + flatRight.y * (inputs.steer * 0.50)
        local sz = cleanFwd.z
        local sLen = math.sqrt(sx * sx + sy * sy + sz * sz)
        local bikeSteerDir = { x = sx / sLen, y = sy / sLen, z = sz / sLen }

        local hitSteer, highSteer = probeClimbRay(spatial, bikeFront, bikeSteerDir, bikeDist, maxH)
        local hitMid, highMid     = probeClimbRay(spatial, bikeFront, cleanFwd, bikeDist, maxH)

        if hitSteer or hitMid then
            local isHigh = (hitSteer and highSteer) and (hitMid and highMid)
            local clearance = isHigh and 0.45 or 0.90

            local verticalRatio = (rawFwd.z > 0.25) and 0.05 or 0.48
            local bikeImp = baseForce * clearance * 0.75

            local evB = PhysicalImpulseEvent.new()
            evB.bodyIndex = 0
            evB.worldPosition = Vector3.new(pos.x + cleanFwd.x * 0.20, pos.y + cleanFwd.y * 0.20, pos.z + 0.15)
            evB.worldImpulse = Vector3.new(
                bikeSteerDir.x * bikeImp * 0.72,
                bikeSteerDir.y * bikeImp * 0.72,
                bikeImp * verticalRatio
            )
            vehicle:QueueEvent(evB)
        end
        return
    end

    local dist     = cfg.climbing.detectDistance or 2.40
    local sideDist = cfg.climbing.sideDetectDistance or 1.65
    local sideMul  = cfg.climbing.sideClimbBoost or 1.45

    local wheelOffsetFwd  = 1.25
    local wheelOffsetSide = 0.88

    local frontCenter = {
        x = pos.x + cleanFwd.x * wheelOffsetFwd,
        y = pos.y + cleanFwd.y * wheelOffsetFwd,
        z = pos.z + cleanFwd.z * wheelOffsetFwd
    }
    local frontRightWheel = {
        x = frontCenter.x + flatRight.x * wheelOffsetSide,
        y = frontCenter.y + flatRight.y * wheelOffsetSide,
        z = frontCenter.z
    }
    local frontLeftWheel = {
        x = frontCenter.x - flatRight.x * wheelOffsetSide,
        y = frontCenter.y - flatRight.y * wheelOffsetSide,
        z = frontCenter.z
    }

    local steerRightBias = math.max(0.0, inputs.steer) * 0.55
    local steerLeftBias  = math.max(0.0, -inputs.steer) * 0.55

    local dirDiagRight = {
        x = cleanFwd.x * 0.72 + flatRight.x * (0.68 + steerRightBias),
        y = cleanFwd.y * 0.72 + flatRight.y * (0.68 + steerRightBias),
        z = cleanFwd.z * 0.72
    }
    local dirDiagLeft = {
        x = cleanFwd.x * 0.72 - flatRight.x * (0.68 + steerLeftBias),
        y = cleanFwd.y * 0.72 - flatRight.y * (0.68 + steerLeftBias),
        z = cleanFwd.z * 0.72
    }
    local dirSideRight = {
        x = cleanFwd.x * 0.25 + flatRight.x * 0.95,
        y = cleanFwd.y * 0.25 + flatRight.y * 0.95,
        z = 0.0
    }
    local dirSideLeft = {
        x = cleanFwd.x * 0.25 - flatRight.x * 0.95,
        y = cleanFwd.y * 0.25 - flatRight.y * 0.95,
        z = 0.0
    }

    local hitRightDiag, highRightDiag = probeClimbRay(spatial, frontRightWheel, dirDiagRight, sideDist, maxH)
    local hitRightSide, highRightSide = false, false
    if inputs.steer > 0.12 then
        hitRightSide, highRightSide = probeClimbRay(spatial, frontRightWheel, dirSideRight, 1.15, maxH)
    end

    local hitLeftDiag, highLeftDiag = probeClimbRay(spatial, frontLeftWheel, dirDiagLeft, sideDist, maxH)
    local hitLeftSide, highLeftSide = false, false
    if inputs.steer < -0.12 then
        hitLeftSide, highLeftSide = probeClimbRay(spatial, frontLeftWheel, dirSideLeft, 1.15, maxH)
    end

    local hitCenter, highCenter = probeClimbRay(spatial, pos, cleanFwd, dist, maxH)

    if not (hitRightDiag or hitRightSide or hitLeftDiag or hitLeftSide or hitCenter) then
        return
    end

    if hitRightDiag or hitRightSide then
        local isHighWall = (hitRightDiag and highRightDiag) and (hitRightSide and highRightSide)
        local clearance = isHighWall and 0.55 or 1.0
        local steerBoost = (inputs.steer > 0.1) and (1.0 + inputs.steer * (sideMul - 1.0)) or 0.85
        local imp = baseForce * clearance * steerBoost

        local evR = PhysicalImpulseEvent.new()
        evR.bodyIndex = 0
        evR.worldPosition = Vector3.new(frontRightWheel.x, frontRightWheel.y, frontRightWheel.z + 0.10)
        evR.worldImpulse = Vector3.new(
            (cleanFwd.x * 0.50 + flatRight.x * 0.45) * imp,
            (cleanFwd.y * 0.50 + flatRight.y * 0.45) * imp,
            imp * 0.95
        )
        vehicle:QueueEvent(evR)
    end

    if hitLeftDiag or hitLeftSide then
        local isHighWall = (hitLeftDiag and highLeftDiag) and (hitLeftSide and highLeftSide)
        local clearance = isHighWall and 0.55 or 1.0
        local steerBoost = (inputs.steer < -0.1) and (1.0 + math.abs(inputs.steer) * (sideMul - 1.0)) or 0.85
        local imp = baseForce * clearance * steerBoost

        local evL = PhysicalImpulseEvent.new()
        evL.bodyIndex = 0
        evL.worldPosition = Vector3.new(frontLeftWheel.x, frontLeftWheel.y, frontLeftWheel.z + 0.10)
        evL.worldImpulse = Vector3.new(
            (cleanFwd.x * 0.50 - flatRight.x * 0.45) * imp,
            (cleanFwd.y * 0.50 - flatRight.y * 0.45) * imp,
            imp * 0.95
        )
        vehicle:QueueEvent(evL)
    end

    if hitCenter and not (hitRightSide or hitLeftSide) then
        local clearance = highCenter and 0.50 or 1.0
        local imp = baseForce * clearance * 0.85

        local evC = PhysicalImpulseEvent.new()
        evC.bodyIndex = 0
        evC.worldPosition = Vector3.new(frontCenter.x, frontCenter.y, frontCenter.z + 0.15)
        evC.worldImpulse = Vector3.new(
            cleanFwd.x * imp * 0.55,
            cleanFwd.y * imp * 0.55,
            imp * 0.85
        )
        vehicle:QueueEvent(evC)
    end
end

return Climbing
