local Config       = require("config")
local CarHandling  = require("modules/01_car_handling")
local BikeHandling = require("modules/01_bike_handling")
local Suspension   = require("modules/02_suspension")
local AirControl   = require("modules/03_air_control")
local Climbing     = require("modules/04_climbing")
local Collision    = require("modules/05_collision")

local inputs = { steer = 0.0, throttle = 0.0, brake = 0.0, pitch = 0.0, handbrake = false }
local keyPitchUp = false
local keyPitchDown = false

registerInput("GTAV_AirPitchUp", "Air Control: เชิดหน้ารถขึ้น (Pitch Up)", function(pressed)
    keyPitchUp = pressed
end)

registerInput("GTAV_AirPitchDown", "Air Control: กดหน้ารถลง (Pitch Down)", function(pressed)
    keyPitchDown = pressed
end)

local function applyAllStaticTweaks()
    CarHandling.applyAll(Config)
    BikeHandling.applyAll(Config)
    Suspension.applyAll(Config)
    AirControl.applyTweakDB(Config)
    Climbing.applyTweakDB(Config)
    Collision.applyTweakDB(Config)
end

registerForEvent("onInit", function()
    applyAllStaticTweaks()

    Observe("PlayerPuppet", "OnAction", function(_, action)
        local actionName = Game.NameToString(ListenerAction.GetName(action))
        local actionVal  = ListenerAction.GetValue(action)

        if actionName == "TurnX" or actionName == "MoveX" then
            inputs.steer = actionVal
        elseif actionName == "Accelerate" then
            inputs.throttle = actionVal
        elseif actionName == "Decelerate" then
            inputs.brake = actionVal
        elseif actionName == "MoveY" then
            inputs.pitch = -actionVal
        elseif actionName == "Handbrake" then
            pcall(function()
                if ListenerAction.IsButtonJustPressed(action) then
                    inputs.handbrake = true
                elseif ListenerAction.IsButtonJustReleased(action) then
                    inputs.handbrake = false
                end
            end)
        end
    end)
end)

registerForEvent("onUpdate", function(dt)
    if dt <= 0 or dt > 0.1 then return end

    local player = Game.GetPlayer()
    if not player then return end

    local vehicle = Game.GetMountedVehicle(player)
    if not vehicle then
        inputs.handbrake = false
        Collision.reset()
        return
    end

    local activeInputs = {
        steer     = inputs.steer,
        throttle  = inputs.throttle,
        brake     = inputs.brake,
        pitch     = inputs.pitch,
        handbrake = inputs.handbrake
    }
    if keyPitchUp then
        activeInputs.pitch = 1.0
    elseif keyPitchDown then
        activeInputs.pitch = -1.0
    elseif math.abs(activeInputs.pitch) < 0.05 then
        activeInputs.pitch = (inputs.brake * 0.85) - (inputs.throttle * 0.65)
    end

    local isBurnout = (activeInputs.throttle > 0.25 and activeInputs.brake > 0.25)

    CarHandling.onUpdate(vehicle, dt, activeInputs, Config)
    BikeHandling.onUpdate(vehicle, dt, activeInputs, Config)
    AirControl.onUpdate(vehicle, dt, activeInputs, Config)
    if not isBurnout then
        Climbing.onUpdate(vehicle, dt, activeInputs, Config)
    end
    Collision.onUpdate(vehicle, dt, Config)
end)
