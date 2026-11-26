local BikeHandling = {}
local processedLegacyBike = {}
local processedBikeSpin   = {}
local processedWheel      = {}
local processedBikeWheel  = {}
local processedHelpers    = {}
local processedBurnout    = {}
local bikeHbBlend         = 0.0

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

function BikeHandling.applyAll(cfg)
    if cfg.enableHandling == false or cfg.enableBikeHandling == false then return 0 end
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

            if drivePath and drivePath ~= "" and not processedLegacyBike[drivePath] then
                local okBike, bikeTilt = pcall(function() return TweakDB:GetFlat(drivePath .. ".bikeMaxTilt") end)
                if not (okBike and type(bikeTilt) == "number") then return end

                processedLegacyBike[drivePath] = true

                safeMulFlat(drivePath .. ".handbrakeBrakingTorque", hbTorque * 0.88, 700.0, 1900.0)
                safeMulFlat(drivePath .. ".turnUpdateBaseSpeed", cfg.handling.steeringSpeedMul * 1.35, 65.0, 230.0)
                safeMulFlat(drivePath .. ".turnUpdateMaxSpeed", cfg.handling.steeringSpeedMul * 1.38, 100.0, 270.0)
                safeMulFlat(drivePath .. ".wheelTurnMaxAddPerSecond", 1.45, 130.0, 290.0)
                safeMulFlat(drivePath .. ".wheelTurnMaxSubPerSecond", 1.50, 145.0, 310.0)
                safeMulFlat(drivePath .. ".maxWheelTurnDeg", 1.20, 38.0, 58.0)

                safeMulFlat(drivePath .. ".forwardWeightTransferFactor", 0.58, 0.08, 0.52)
                safeMulFlat(drivePath .. ".sideWeightTransferFactor", 0.75, 0.10, 0.68)

                safeMulFlat(drivePath .. ".bikeTiltSpeed", cfg.handling.bikeTiltSpeedMul * 1.38, 105.0, 235.0)
                safeMulFlat(drivePath .. ".bikeTiltReturnSpeed", cfg.handling.bikeTiltSpeedMul * 1.38, 100.0, 230.0)
                safeMulFlat(drivePath .. ".bikeTiltCustomSpeed", 1.45, 130.0, 250.0)
                safeMulFlat(drivePath .. ".bikeMaxTilt", 1.16, 43.0, 57.0)

                local okBikeMoi, bikeMoi = pcall(function() return TweakDB:GetFlat(drivePath .. ".momentOfInertia") end)
                if okBikeMoi and bikeMoi and bikeMoi.x then
                    TweakDB:SetFlatNoUpdate(
                        drivePath .. ".momentOfInertia",
                        Vector3.new(bikeMoi.x * 0.90, bikeMoi.y * 0.70, bikeMoi.z * 0.76)
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
                                safeMulFlat(pPath .. ".frictionMulLateral", cfg.handling.tireGripMul * 1.34, 1.05, 3.1)
                                safeMulFlat(pPath .. ".frictionMulLongitudinal", 1.05, 0.90, 2.5)
                                safeMulFlat(pPath .. ".tireLateralSlipEffectsMul", 0.65, 0.45, 1.2)
                            else
                                safeMulFlat(pPath .. ".frictionMulLateral", cfg.handling.tireGripMul * 1.25, 1.02, 2.9)
                                safeMulFlat(pPath .. ".frictionMulLongitudinal", spinGrip * 0.96, 0.76, 1.45)
                                safeMulFlat(pPath .. ".tireLateralSlipEffectsMul", 0.60, 0.45, 1.0)
                            end
                            TweakDB:Update(presetID)
                        end
                    end
                end

                TweakDB:Update(driveID)
            end
        end)
    end

    local bikeSpinName = "Vehicle.GTAV_BikeLaunchSpinHelper"
    local bikeSpinID   = TweakDBID.new(bikeSpinName)
    local bikeHBName   = "Vehicle.GTAV_BikeHandbrakeSlideHelper"
    local bikeHBID     = TweakDBID.new(bikeHBName)

    pcall(function()
        if not TweakDB:GetRecord(bikeSpinID) then
            local sampleSpin = TweakDB:GetRecords("gamedataRearWheelsFrictionModifier_Record")
            if sampleSpin then
                local _, firstSpin = next(sampleSpin)
                if firstSpin then
                    TweakDB:CloneRecord(bikeSpinName, firstSpin:GetID())
                end
            end
        end
        if TweakDB:GetRecord(bikeSpinID) then
            TweakDB:SetFlatNoUpdate(bikeSpinName .. ".minLongFrictionCoef", 0.42)
            TweakDB:SetFlatNoUpdate(bikeSpinName .. ".minLongSlipRatio", 0.15)
            TweakDB:SetFlatNoUpdate(bikeSpinName .. ".minLatFrictionCoef", 0.90)
            TweakDB:SetFlatNoUpdate(bikeSpinName .. ".minLatSlipRatio", 0.25)
            TweakDB:SetFlatNoUpdate(bikeSpinName .. ".maxSpeed", 10.5)
            TweakDB:Update(bikeSpinID)
        end
    end)

    pcall(function()
        if not TweakDB:GetRecord(bikeHBID) then
            local sampleHB = TweakDB:GetRecords("gamedataHandbrakeFrictionModifier_Record")
            if sampleHB then
                local _, firstHB = next(sampleHB)
                if firstHB then
                    TweakDB:CloneRecord(bikeHBName, firstHB:GetID())
                end
            end
        end
        if TweakDB:GetRecord(bikeHBID) then
            TweakDB:SetFlatNoUpdate(bikeHBName .. ".rearWheelsLatFrictionCoef", 0.57)
            TweakDB:SetFlatNoUpdate(bikeHBName .. ".rearWheelsLongFrictionCoef", 0.42)
            TweakDB:SetFlatNoUpdate(bikeHBName .. ".additionalBrakeForLongUse", 0.85)
            TweakDB:SetFlatNoUpdate(bikeHBName .. ".blendOutTime", 0.45)
            TweakDB:SetFlatNoUpdate(bikeHBName .. ".postHandbrakeTractionBoost", 1.35)
            TweakDB:Update(bikeHBID)
        end
    end)

    local hasSpinHelper = (TweakDB:GetRecord(bikeSpinID) ~= nil)
    local hasHBHelper   = (TweakDB:GetRecord(bikeHBID) ~= nil)

    for _, veh in ipairs(vehicles) do
        pcall(function()
            local vehPath = veh:GetID().value
            local bDriveID = TweakDB:GetFlat(vehPath .. ".bikeDriveModelData")
            if not bDriveID or bDriveID.value == "" then return end

            local bDrivePath = bDriveID.value
            if processedBikeSpin[bDrivePath] then return end
            processedBikeSpin[bDrivePath] = true

            pcall(function()
                local engID = TweakDB:GetFlat(vehPath .. ".vehEngineData")
                if engID and engID.value ~= "" and not processedHelpers[engID.value] then
                    processedHelpers[engID.value] = true
                    safeMulFlat(engID.value .. ".wheelsResistanceRatio", 0.68, 5.5, 10.0)
                    TweakDB:Update(engID)
                end
            end)

            pcall(function()
                local helpers = TweakDB:GetFlat(bDrivePath .. ".driveHelpers") or {}
                if type(helpers) == "table" then
                    local foundRearMod = false
                    local foundHBMod   = false
                    local newHelpers   = {}

                    for _, hID in ipairs(helpers) do
                        table.insert(newHelpers, hID)
                        local hRec = TweakDB:GetRecord(hID)
                        if hRec then
                            if hRec:IsA("gamedataRearWheelsFrictionModifier_Record") then
                                foundRearMod = true
                                if not processedHelpers[hID.value] then
                                    processedHelpers[hID.value] = true
                                    TweakDB:SetFlatNoUpdate(hID.value .. ".minLongFrictionCoef", 0.42)
                                    TweakDB:SetFlatNoUpdate(hID.value .. ".minLatFrictionCoef", 0.90)
                                    TweakDB:SetFlatNoUpdate(hID.value .. ".maxSpeed", 10.5)
                                    TweakDB:Update(hID)
                                end
                            elseif hRec:IsA("gamedataHandbrakeFrictionModifier_Record") then
                                foundHBMod = true
                                if not processedHelpers[hID.value] then
                                    processedHelpers[hID.value] = true
                                    TweakDB:SetFlatNoUpdate(hID.value .. ".rearWheelsLatFrictionCoef", 0.57)
                                    TweakDB:SetFlatNoUpdate(hID.value .. ".rearWheelsLongFrictionCoef", 0.42)
                                    TweakDB:SetFlatNoUpdate(hID.value .. ".blendOutTime", 0.45)
                                    TweakDB:Update(hID)
                                end
                            end
                        end
                    end

                    local listChanged = false
                    if not foundRearMod and hasSpinHelper then
                        table.insert(newHelpers, bikeSpinID)
                        listChanged = true
                    end
                    if not foundHBMod and hasHBHelper then
                        table.insert(newHelpers, bikeHBID)
                        listChanged = true
                    end
                    if listChanged then
                        TweakDB:SetFlatNoUpdate(bDrivePath .. ".driveHelpers", newHelpers)
                    end
                end
            end)

            safeMulFlat(bDrivePath .. ".handbrakeBrakingTorque", hbTorque * 1.30, 1250.0, 2600.0)

            pcall(function()
                local burnID = TweakDB:GetFlat(bDrivePath .. ".burnOut")
                if burnID and burnID.value ~= "" and not processedBurnout[burnID.value] then
                    processedBurnout[burnID.value] = true
                    safeMulFlat(burnID.value .. ".maxDriveWheelSlipRatio", 1.45, 16.0, 32.0)
                    safeMulFlat(burnID.value .. ".burnOutGripBonus", 0.75, 0.30, 1.35)
                    TweakDB:Update(burnID)
                end
            end)

            pcall(function()
                local wsID = TweakDB:GetFlat(bDrivePath .. ".wheelSetup")
                if wsID and wsID.value ~= "" then
                    local backID = TweakDB:GetFlat(wsID.value .. ".backPreset") or TweakDB:GetFlat(wsID.value .. ".rearPreset")
                    if backID and backID.value ~= "" and not processedBikeWheel[backID.value] then
                        processedBikeWheel[backID.value] = true
                        safeMulFlat(backID.value .. ".frictionMulLongitudinal", spinGrip * 0.86, 0.74, 1.08)
                        TweakDB:Update(backID)
                    end
                end
            end)

            TweakDB:Update(bDriveID)
            count = count + 1
        end)
    end

    return count
end

function BikeHandling.onUpdate(vehicle, dt, inputs, cfg)
    if cfg.enableHandling == false or cfg.enableBikeHandling == false then return end

    local isBike = false
    pcall(function()
        if vehicle:IsA("vehicleBikeBaseObject") then
            isBike = true
        elseif vehicle:GetRecord():Type():Type() == gamedataVehicleType.Bike then
            isBike = true
        end
    end)
    if not isBike then return end

    local isBurnout   = (inputs.throttle > 0.25 and inputs.brake > 0.25)
    local targetBlend = (inputs.handbrake and not isBurnout) and 1.0 or 0.0
    bikeHbBlend = bikeHbBlend + (targetBlend - bikeHbBlend) * math.min(1.0, dt * 14.0)

    local bPos   = vehicle:GetWorldPosition()
    local bFwd   = vehicle:GetWorldForward()
    local bRight = vehicle:GetWorldRight()
    local bUp    = vehicle:GetWorldUp()

    if bUp.z > 0.35 then
        local bSpatial = Game.GetSpatialQueriesSystem()
        if bSpatial then
            local gStart = Vector4.new(bPos.x, bPos.y, bPos.z + 0.30, 1.0)
            local gEnd   = Vector4.new(bPos.x, bPos.y, bPos.z - 0.85, 1.0)
            local bikeOnGround = bSpatial:SyncRaycastByCollisionGroup(gStart, gEnd, "Static", false, false)
                              or bSpatial:SyncRaycastByCollisionGroup(gStart, gEnd, "Terrain", false, false)

            if bikeOnGround then
                local bfLen = math.sqrt(bFwd.x * bFwd.x + bFwd.y * bFwd.y)
                local brLen = math.sqrt(bRight.x * bRight.x + bRight.y * bRight.y)
                if bfLen > 0.01 and brLen > 0.01 then
                    local bCleanFwd  = { x = bFwd.x / bfLen, y = bFwd.y / bfLen }
                    local bFlatRight = { x = bRight.x / brLen, y = bRight.y / brLen }

                    local bVel = vehicle:GetLinearVelocity()
                    local bFwdSpeed = bVel.x * bCleanFwd.x + bVel.y * bCleanFwd.y
                    local bLatSpeed = bVel.x * bFlatRight.x + bVel.y * bFlatRight.y

                    local bMass = 320.0
                    pcall(function()
                        local m = vehicle:GetTotalMass()
                        if m and m > 50.0 then bMass = m end
                    end)

                    if not isBurnout then
                        if math.abs(inputs.steer) > 0.05 and bFwdSpeed > 1.0 then
                            local turnBoost   = (cfg.handling and cfg.handling.bikeTurnBoost) or 4.35
                            local speedFactor = math.min(1.65, math.max(0.55, bFwdSpeed / 14.5))
                            local yawScale    = math.max(0.54, 1.48 - (bFwdSpeed / 48.0))

                            local yawMult     = 0.60 - (0.04 * bikeHbBlend)
                            local rearYawMult = 0.68 - (0.03 * bikeHbBlend)
                            local carveMult   = 1.12 * (1.0 - 0.65 * bikeHbBlend)

                            local yawImp = bMass * inputs.steer * turnBoost * yawMult * yawScale * dt

                            local evFront = PhysicalImpulseEvent.new()
                            evFront.bodyIndex = 0
                            evFront.worldPosition = Vector3.new(bPos.x + bCleanFwd.x * 0.85, bPos.y + bCleanFwd.y * 0.85, bPos.z + 0.05)
                            evFront.worldImpulse  = Vector3.new(
                                bFlatRight.x * yawImp,
                                bFlatRight.y * yawImp,
                                -math.abs(yawImp) * 0.10
                            )
                            vehicle:QueueEvent(evFront)

                            local evRearTurn = PhysicalImpulseEvent.new()
                            evRearTurn.bodyIndex = 0
                            evRearTurn.worldPosition = Vector3.new(bPos.x - bCleanFwd.x * 0.80, bPos.y - bCleanFwd.y * 0.80, bPos.z + 0.05)
                            evRearTurn.worldImpulse  = Vector3.new(-bFlatRight.x * yawImp * rearYawMult, -bFlatRight.y * yawImp * rearYawMult, 0.0)
                            vehicle:QueueEvent(evRearTurn)

                            local carveImp = bMass * inputs.steer * turnBoost * carveMult * speedFactor * dt
                            local evCarve = PhysicalImpulseEvent.new()
                            evCarve.bodyIndex = 0
                            evCarve.worldPosition = Vector3.new(bPos.x, bPos.y, bPos.z + 0.05)
                            evCarve.worldImpulse  = Vector3.new(bFlatRight.x * carveImp, bFlatRight.y * carveImp, 0.0)
                            vehicle:QueueEvent(evCarve)

                            local activeLimit = 1.10 + (2.05 * bikeHbBlend)
                            if bFwdSpeed > 3.5 and math.abs(bLatSpeed) > activeLimit then
                                local bikeStab = ((cfg.handling and cfg.handling.bikeStability) or 5.80) * 0.88 * (1.0 - 0.30 * bikeHbBlend)
                                local bDamp = math.min(0.32, bikeStab * dt)
                                local bExcess = bLatSpeed - ((bLatSpeed > 0) and activeLimit or -activeLimit)
                                local bCenterCorr = -bExcess * bMass * bDamp

                                local evCenterGrip = PhysicalImpulseEvent.new()
                                evCenterGrip.bodyIndex = 0
                                evCenterGrip.worldPosition = Vector3.new(bPos.x, bPos.y, bPos.z + 0.05)
                                evCenterGrip.worldImpulse  = Vector3.new(bFlatRight.x * bCenterCorr, bFlatRight.y * bCenterCorr, 0.0)
                                vehicle:QueueEvent(evCenterGrip)
                            end

                        elseif not inputs.handbrake and math.abs(inputs.steer) <= 0.05 and bFwdSpeed > 3.5 and math.abs(bLatSpeed) > 0.30 then
                            local bikeStab = (cfg.handling and cfg.handling.bikeStability) or 5.80
                            local bDamp = math.min(0.40, bikeStab * dt)
                            local bExcess = bLatSpeed - ((bLatSpeed > 0) and 0.30 or -0.30)
                            local bRearCorr = -bExcess * bMass * bDamp

                            local evStraight = PhysicalImpulseEvent.new()
                            evStraight.bodyIndex = 0
                            evStraight.worldPosition = Vector3.new(bPos.x - bCleanFwd.x * 0.75, bPos.y - bCleanFwd.y * 0.75, bPos.z + 0.05)
                            evStraight.worldImpulse  = Vector3.new(bFlatRight.x * bRearCorr, bFlatRight.y * bRearCorr, 0.0)
                            vehicle:QueueEvent(evStraight)
                        end
                    end
                end
            end
        end
    end
end

return BikeHandling
