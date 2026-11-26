local CarHandling = {}
local processedDrive   = {}
local processedWheel   = {}
local processedHelpers = {}
local processedBurnout = {}

local function safeMulFlat(flatPath, mul, minVal, maxVal)
    local ok, val = pcall(function() return TweakDB:GetFlat(flatPath) end)
    if ok and type(val) == "number" then
        local newVal = val * mul
        if minVal and newVal < minVal then newVal = minVal end
        if maxVal and newVal > maxVal then newVal = maxVal end
        TweakDB:SetFlatNoUpdate(flatPath, newVal)
        return true
    end
    return false
end

function CarHandling.applyAll(cfg)
    if cfg.enableHandling == false or cfg.enableCarHandling == false then return 0 end
    local count = 0
    local vehicles = TweakDB:GetRecords("gamedataVehicle_Record")
    if not vehicles then return 0 end

    local spinGrip = (cfg.handling and cfg.handling.wheelspinGripMul) or 0.93
    local hbTorque = (cfg.handling and cfg.handling.handbrakeTorqueMul) or 1.65

    for _, veh in ipairs(vehicles) do
        pcall(function()
            local driveRec = veh:VehDriveModelData()
            if not driveRec then return end
            local driveID = driveRec:GetID()
            local drivePath = driveID.value

            if drivePath and drivePath ~= "" and not processedDrive[drivePath] then
                local okBike, bikeTilt = pcall(function() return TweakDB:GetFlat(drivePath .. ".bikeMaxTilt") end)
                if okBike and type(bikeTilt) == "number" then return end

                processedDrive[drivePath] = true

                pcall(function()
                    local helpers = TweakDB:GetFlat(drivePath .. ".driveHelpers")
                    if type(helpers) == "table" and #helpers > 0 then
                        for _, hID in ipairs(helpers) do
                            if hID and hID.value ~= "" and not processedHelpers[hID.value] then
                                local hRec = TweakDB:GetRecord(hID)
                                if hRec then
                                    if hRec:IsA("gamedataRearWheelsFrictionModifier_Record") then
                                        processedHelpers[hID.value] = true
                                        local hPath = hID.value
                                        safeMulFlat(hPath .. ".minLatFrictionCoef", 1.26, 0.76, 0.92)
                                        safeMulFlat(hPath .. ".maxSpeed", 0.70, 7.5, 13.5)
                                        TweakDB:Update(hID)
                                    elseif hRec:IsA("gamedataHandbrakeFrictionModifier_Record") then
                                        processedHelpers[hID.value] = true
                                        local hPath = hID.value
                                        safeMulFlat(hPath .. ".rearWheelsLatFrictionCoef", 0.86, 0.52, 0.78)
                                        safeMulFlat(hPath .. ".rearWheelsLongFrictionCoef", 0.88, 0.55, 0.82)
                                        TweakDB:Update(hID)
                                    end
                                end
                            end
                        end
                    end
                end)

                pcall(function()
                    local burnID = TweakDB:GetFlat(drivePath .. ".burnOut")
                    if burnID and burnID.value ~= "" and not processedBurnout[burnID.value] then
                        processedBurnout[burnID.value] = true
                        local bPath = burnID.value
                        safeMulFlat(bPath .. ".lateralForceMaxAcceleration", 0.80, 1.5, 8.0)
                        safeMulFlat(bPath .. ".lateralAccelForwardSpeedMaxDecimation", 0.85, 0.2, 1.5)
                        safeMulFlat(bPath .. ".maxDriveWheelSlipRatio", 0.85, 8.0, 22.0)
                        TweakDB:Update(burnID)
                    end
                end)

                safeMulFlat(drivePath .. ".handbrakeBrakingTorque", hbTorque, 1500.0, 3200.0)
                safeMulFlat(drivePath .. ".turnUpdateBaseSpeed", cfg.handling.steeringSpeedMul * 1.25, 65.0, 195.0)
                safeMulFlat(drivePath .. ".turnUpdateMaxSpeed", cfg.handling.steeringSpeedMul * 1.30, 90.0, 230.0)
                safeMulFlat(drivePath .. ".wheelTurnMaxAddPerSecond", 1.35, 120.0, 240.0)
                safeMulFlat(drivePath .. ".wheelTurnMaxSubPerSecond", 1.55, 155.0, 300.0)
                safeMulFlat(drivePath .. ".maxWheelTurnDeg", 1.15, 38.0, 50.0)

                safeMulFlat(drivePath .. ".forwardWeightTransferFactor", 0.82, 0.15, 0.78)
                safeMulFlat(drivePath .. ".sideWeightTransferFactor", 0.78, 0.15, 0.74)
                safeMulFlat(drivePath .. ".turningRollFactor", 0.72, 0.20, 0.95)

                local okMoi, moi = pcall(function() return TweakDB:GetFlat(drivePath .. ".momentOfInertia") end)
                if okMoi and moi and moi.x then
                    local rollMul = cfg.handling.rollInertiaBoost or 1.35
                    TweakDB:SetFlatNoUpdate(
                        drivePath .. ".momentOfInertia",
                        Vector3.new(moi.x * 1.05, moi.y * rollMul, moi.z * 1.02)
                    )
                end

                local wheelSetupID = TweakDB:GetFlat(drivePath .. ".wheelSetup")
                if wheelSetupID and wheelSetupID.value ~= "" then
                    local wsPath = wheelSetupID.value
                    local frontID = TweakDB:GetFlat(wsPath .. ".frontPreset")
                    local backID  = TweakDB:GetFlat(wsPath .. ".backPreset") or TweakDB:GetFlat(wsPath .. ".rearPreset")

                    for idx, presetID in ipairs({ frontID, backID }) do
                        if presetID and presetID.value ~= "" and not processedWheel[presetID.value] then
                            processedWheel[presetID.value] = true
                            local pPath = presetID.value

                            if idx == 1 then
                                safeMulFlat(pPath .. ".frictionMulLateral", cfg.handling.tireGripMul * 1.24, 1.05, 2.8)
                                safeMulFlat(pPath .. ".frictionMulLongitudinal", spinGrip * 1.00, 0.82, 1.65)
                                safeMulFlat(pPath .. ".tireLateralSlipEffectsMul", 0.70, 0.50, 1.05)
                            else
                                safeMulFlat(pPath .. ".frictionMulLateral", cfg.handling.tireGripMul * 1.20, 1.04, 2.7)
                                safeMulFlat(pPath .. ".frictionMulLongitudinal", spinGrip * 0.95, 0.78, 1.50)
                                safeMulFlat(pPath .. ".tireLateralSlipEffectsMul", 0.80, 0.58, 1.15)
                                safeMulFlat(pPath .. ".swaybarStiffness", 0.90, 5.0, 46.0)
                            end

                            TweakDB:Update(presetID)
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

function CarHandling.onUpdate(vehicle, dt, inputs, cfg)
    if cfg.enableHandling == false or cfg.enableCarHandling == false then return end

    local isBike = false
    pcall(function()
        if vehicle:IsA("vehicleBikeBaseObject") then
            isBike = true
        elseif vehicle:GetRecord():Type():Type() == gamedataVehicleType.Bike then
            isBike = true
        end
    end)
    if isBike then return end

    local isBurnout = (inputs.throttle > 0.25 and inputs.brake > 0.25)
    local hbSlide   = (cfg.handling and cfg.handling.handbrakeSlideBoost) or 2.50

    local pos      = vehicle:GetWorldPosition()
    local rawFwd   = vehicle:GetWorldForward()
    local rawRight = vehicle:GetWorldRight()
    local rawUp    = vehicle:GetWorldUp()

    if rawUp.z < 0.50 then return end

    local spatial = Game.GetSpatialQueriesSystem()
    if not spatial then return end
    local rStart = Vector4.new(pos.x, pos.y, pos.z + 0.30, 1.0)
    local rEnd   = Vector4.new(pos.x, pos.y, pos.z - 0.85, 1.0)
    local onGround = spatial:SyncRaycastByCollisionGroup(rStart, rEnd, "Static", false, false)
                  or spatial:SyncRaycastByCollisionGroup(rStart, rEnd, "Terrain", false, false)
    if not onGround then return end

    local fLen = math.sqrt(rawFwd.x * rawFwd.x + rawFwd.y * rawFwd.y)
    local rLen = math.sqrt(rawRight.x * rawRight.x + rawRight.y * rawRight.y)
    if fLen < 0.01 or rLen < 0.01 then return end

    local cleanFwd  = { x = rawFwd.x / fLen, y = rawFwd.y / fLen }
    local flatRight = { x = rawRight.x / rLen, y = rawRight.y / rLen }

    local vel = vehicle:GetLinearVelocity()
    local fwdSpeed = vel.x * cleanFwd.x + vel.y * cleanFwd.y
    local latSpeed = vel.x * flatRight.x + vel.y * flatRight.y

    local mass = 1650.0
    pcall(function()
        local m = vehicle:GetTotalMass()
        if m and m > 100.0 then mass = m end
    end)

    if inputs.handbrake and not isBurnout then
        if fwdSpeed > 3.8 then
            local targetCarSlide = 4.60
            local maxCarSlide    = 6.40

            if math.abs(inputs.steer) > 0.10 and math.abs(latSpeed) < targetCarSlide then
                local slideRatio = 1.0 - (math.abs(latSpeed) / targetCarSlide)
                local kickImp = mass * inputs.steer * hbSlide * 0.62 * slideRatio * dt

                local evFrontHB = PhysicalImpulseEvent.new()
                evFrontHB.bodyIndex = 0
                evFrontHB.worldPosition = Vector3.new(pos.x + cleanFwd.x * 1.10, pos.y + cleanFwd.y * 1.10, pos.z + 0.05)
                evFrontHB.worldImpulse  = Vector3.new(flatRight.x * kickImp * 0.45, flatRight.y * kickImp * 0.45, 0.0)
                vehicle:QueueEvent(evFrontHB)

                local evRearHB = PhysicalImpulseEvent.new()
                evRearHB.bodyIndex = 0
                evRearHB.worldPosition = Vector3.new(pos.x - cleanFwd.x * 1.05, pos.y - cleanFwd.y * 1.05, pos.z + 0.05)
                evRearHB.worldImpulse  = Vector3.new(-flatRight.x * kickImp * 0.85, -flatRight.y * kickImp * 0.85, 0.0)
                vehicle:QueueEvent(evRearHB)

            elseif math.abs(latSpeed) > maxCarSlide then
                local overSlip = latSpeed - ((latSpeed > 0) and maxCarSlide or -maxCarSlide)
                local holdImp  = -overSlip * mass * math.min(0.24, 2.40 * dt)

                local evHoldCar = PhysicalImpulseEvent.new()
                evHoldCar.bodyIndex = 0
                evHoldCar.worldPosition = Vector3.new(pos.x - cleanFwd.x * 1.05, pos.y - cleanFwd.y * 1.05, pos.z + 0.05)
                evHoldCar.worldImpulse  = Vector3.new(flatRight.x * holdImp, flatRight.y * holdImp, 0.0)
                vehicle:QueueEvent(evHoldCar)
            end
        end
        return
    end

    if not isBurnout and math.abs(inputs.steer) > 0.05 and fwdSpeed > 1.2 then
        local carTurn     = (cfg.handling and cfg.handling.carTurnBoost) or 3.45
        local speedFactor = math.min(1.45, math.max(0.50, fwdSpeed / 16.0))
        local yawScale    = math.max(0.42, 1.30 - (fwdSpeed / 50.0))

        local frontTurnImp = mass * inputs.steer * carTurn * 0.45 * yawScale * dt
        local evCarFront = PhysicalImpulseEvent.new()
        evCarFront.bodyIndex = 0
        evCarFront.worldPosition = Vector3.new(pos.x + cleanFwd.x * 1.15, pos.y + cleanFwd.y * 1.15, pos.z + 0.05)
        evCarFront.worldImpulse  = Vector3.new(
            flatRight.x * frontTurnImp,
            flatRight.y * frontTurnImp,
            -math.abs(frontTurnImp) * 0.12
        )
        vehicle:QueueEvent(evCarFront)

        local carCarveImp = mass * inputs.steer * carTurn * 0.78 * speedFactor * dt
        local evCarCarve = PhysicalImpulseEvent.new()
        evCarCarve.bodyIndex = 0
        evCarCarve.worldPosition = Vector3.new(pos.x, pos.y, pos.z + 0.05)
        evCarCarve.worldImpulse  = Vector3.new(flatRight.x * carCarveImp, flatRight.y * carCarveImp, 0.0)
        vehicle:QueueEvent(evCarCarve)
    end

    if isBurnout then return end

    local slipDeadzone = 2.55
    if fwdSpeed > 5.5 and math.abs(latSpeed) > slipDeadzone then
        local launchRamp = math.min(1.0, math.max(0.40, (fwdSpeed - 4.5) / 8.0))
        local antiDrift = ((cfg.handling and cfg.handling.antiDriftStrength) or 3.00) * launchRamp
        local dampFactor = math.min(0.26, antiDrift * dt)
        local excessSlip = latSpeed - ((latSpeed > 0) and slipDeadzone or -slipDeadzone)
        local corrImpulse = -excessSlip * mass * dampFactor

        local ev = PhysicalImpulseEvent.new()
        ev.bodyIndex = 0
        ev.worldPosition = Vector3.new(
            pos.x - cleanFwd.x * 1.05,
            pos.y - cleanFwd.y * 1.05,
            pos.z + 0.05
        )
        ev.worldImpulse = Vector3.new(
            flatRight.x * corrImpulse,
            flatRight.y * corrImpulse,
            0.0
        )
        vehicle:QueueEvent(ev)
    end
end

return CarHandling
