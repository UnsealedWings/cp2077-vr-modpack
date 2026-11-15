------------------------------------------------------
-- Nova Optics: Vehicle-aware exposure & visual tweaks
-- 2025-2026 by CyanideX
-- https://next.nexusmods.com/profile/theCyanideX/mods
------------------------------------------------------

local MOD_VERSION = "1.4.2"

local defaults = {
    enable = false,

    -- Exposure Overrides
    exposureOverrideEnabled = false,
    exposureOverrideGlobeEnabled = true,
    exposureOverrideCarEnabled = false,
    exposureVehicleFPPEnterDuration = 0.3,
    exposureFPPVehicleFix = false,
    exposureMinOffset = 0.0,
    exposureMinOffsetEnabled = true,
    exposureMinOffsetVehicle = 0.0,
    exposureMinOffsetVehicleExplicit = false,
    exposureMaxOffset = 0.0,
    exposureMaxOffsetEnabled = true,
    exposureMaxOffsetVehicle = 1.0,
    exposureMaxOffsetVehicleExplicit = false,

    -- Exposure Adaptation
    exposureAdaptGlobeEnabled = true,
    exposureAdaptCarEnabled = false,
    exposureAdaptSpeedEnabled = false,
    exposureAdaptSpeedDownValue = 3.0,
    exposureAdaptSpeedDownEnabled = true,
    exposureAdaptSpeedDownValueVehicle = 3.0,
    exposureAdaptSpeedDownValueVehicleExplicit = false,
    exposureAdaptSpeedUpValue = 1.0,
    exposureAdaptSpeedUpEnabled = true,
    exposureAdaptSpeedUpValueVehicle = 1.0,
    exposureAdaptSpeedUpValueVehicleExplicit = false,

    -- Vignette
    vignetteEnabled = false,
    vignetteGlobeEnabled = true,
    vignetteCarEnabled = false,
    vignetteTransitionDuration = 1.0,
    vignetteExp = 8.0,
    vignetteExpEnabled = true,
    vignetteExpVehicle = 8.0,
    vignetteExpVehicleExplicit = false,
    vignetteColorEnabled = false,
    vignetteColorRed = 0,
    vignetteColorRedVehicle = 0,
    vignetteColorRedVehicleExplicit = false,
    vignetteColorGreen = 0,
    vignetteColorGreenVehicle = 0,
    vignetteColorGreenVehicleExplicit = false,
    vignetteColorBlue = 0,
    vignetteColorBlueVehicle = 0,
    vignetteColorBlueVehicleExplicit = false,
    vignetteColorAlpha = 255,
    vignetteColorAlphaVehicle = 255,
    vignetteColorAlphaVehicleExplicit = false,

    -- Bloom
    bloomEnabled = false,
    bloomGlobeEnabled = true,
    bloomCarEnabled = false,
    bloomVehicleFPPTransitionDuration = 1.0,
    bloomColorScale = 0.15,
    bloomColorScaleEnabled = true,
    bloomColorScaleVehicle = 0.15,
    bloomColorScaleVehicleExplicit = false,
    bloomSize = 0.675,
    bloomSizeEnabled = true,
    bloomSizeVehicle = 0.675,
    bloomSizeVehicleExplicit = false,
    bloomAnamorphic = 0.0,
    bloomAnamorphicEnabled = true,
    bloomAnamorphicVehicle = 0.0,
    bloomAnamorphicVehicleExplicit = false,
    luminanceThresholdMax = 10.0,
    luminanceThresholdMaxEnabled = true,
    luminanceThresholdMaxVehicle = 10.0,
    luminanceThresholdMaxVehicleExplicit = false,
    sceneColorScale = 0.8,
    sceneColorScaleEnabled = true,
    sceneColorScaleVehicle = 0.8,
    sceneColorScaleVehicleExplicit = false,

    -- Lens Flare
    lensFlareEnabled = false,
    lensFlareGlobeEnabled = true,
    lensFlareCarEnabled = false,
    lensFlareTransitionDuration = 1.0,
    lensFlareChromaticEffect = 0.45,
    lensFlareChromaticEffectEnabled = true,
    lensFlareChromaticEffectVehicle = 0.45,
    lensFlareChromaticEffectVehicleExplicit = false,
    lensFlareHaloWidth = 0.56,
    lensFlareHaloWidthEnabled = true,
    lensFlareHaloWidthVehicle = 0.56,
    lensFlareHaloWidthVehicleExplicit = false,
    lensFlareSaturationValue = 1.1,
    lensFlareSaturationValueEnabled = true,
    lensFlareSaturationValueVehicle = 1.1,
    lensFlareSaturationValueVehicleExplicit = false,
    lensFlareScaleValue = 0.45,
    lensFlareScaleValueEnabled = true,
    lensFlareScaleValueVehicle = 0.45,
    lensFlareScaleValueVehicleExplicit = false,

    -- Chromatic Aberration
    chromaticAberrationEnabled = false,
    chromaticAberrationGlobeEnabled = true,
    chromaticAberrationCarEnabled = false,
    chromaticAberrationTransitionDuration = 1.0,
    caExp = 6.0,
    caExpEnabled = true,
    caExpVehicle = 6.0,
    caExpVehicleExplicit = false,
    caMargin = 0.25,
    caMarginEnabled = true,
    caMarginVehicle = 0.25,
    caMarginVehicleExplicit = false,
    caSizeX = 0.8,
    caSizeXEnabled = true,
    caSizeXVehicle = 0.8,
    caSizeXVehicleExplicit = false,
    caSizeY = 0.4,
    caSizeYEnabled = true,
    caSizeYVehicle = 0.4,
    caSizeYVehicleExplicit = false,
    caSubpixelDispersal = 0.0,
    caSubpixelDispersalEnabled = true,
    caSubpixelDispersalVehicle = 0.0,
    caSubpixelDispersalVehicleExplicit = false,

    -- Volumetric Fog
    volFogEnabled = false,
    volFogGlobeEnabled = true,
    volFogCarEnabled = false,
    volFogTransitionDuration = 1.0,
    volFogAbsorptionEnabled = true,
    volFogAbsorption = 0.04,
    volFogAbsorptionVehicle = 0.04,
    volFogAbsorptionVehicleExplicit = false,
    volFogDensityEnabled = true,
    volFogDensity = 0.003,
    volFogDensityVehicle = 0.003,
    volFogDensityVehicleExplicit = false,
    volFogLocalLightScaleEnabled = true,
    volFogLocalLightScale = 1.0,
    volFogLocalLightScaleVehicle = 1.0,
    volFogLocalLightScaleVehicleExplicit = false,
    volFogLocalAmbientScaleEnabled = true,
    volFogLocalAmbientScale = 0.2,
    volFogLocalAmbientScaleVehicle = 0.2,
    volFogLocalAmbientScaleVehicleExplicit = false,

    -- Color Grading
    colorGradingEnabled = false,
    colorGradingGlobeEnabled = true,
    colorGradingCarEnabled = false,
    colorGradingTransitionDuration = 1.0,
    colorGradingBrightness = 1.0,
    colorGradingBrightnessEnabled = true,
    colorGradingBrightnessVehicle = 1.0,
    colorGradingBrightnessVehicleExplicit = false,
    colorGradingContrast = 1.0,
    colorGradingContrastEnabled = true,
    colorGradingContrastVehicle = 1.0,
    colorGradingContrastVehicleExplicit = false,
    colorGradingContrastPivot = 0.5,
    colorGradingContrastPivotEnabled = true,
    colorGradingContrastPivotVehicle = 0.5,
    colorGradingContrastPivotVehicleExplicit = false,
    colorGradingSaturation = 1.0,
    colorGradingSaturationEnabled = true,
    colorGradingSaturationVehicle = 1.0,
    colorGradingSaturationVehicleExplicit = false,

    -- Film Grain
    filmGrainEnabled = false,
    filmGrainApplyAfterUpsampling = true,
    filmGrainGlobeEnabled = true,
    filmGrainGangSliders = true,
    filmGrainGangSlidersScanner = true,
    filmGrainGrainSizeX = 0.58,
    filmGrainGrainSizeY = 0.62,
    filmGrainGrainSizeZ = 0.65,
    filmGrainStrengthX = 0.5,
    filmGrainStrengthY = 0.56,
    filmGrainStrengthZ = 0.65,
    filmGrainStrengthW = 0.0,
    filmGrainScannerEnabled = false,
    filmGrainGrainSizeXScanner = 0.58,
    filmGrainGrainSizeYScanner = 0.62,
    filmGrainGrainSizeZScanner = 0.65,
    filmGrainStrengthXScanner = 0.5,
    filmGrainStrengthYScanner = 0.56,
    filmGrainStrengthZScanner = 0.65,
    filmGrainStrengthWScanner = 0.0,
}

local presetOrder = { "Vehicle FPP" }

local presets = {
    ["Vehicle FPP"] = {
        enable = true,
        exposureOverrideEnabled = true,
        exposureOverrideGlobeEnabled = false,
        exposureOverrideCarEnabled = true,
        exposureFPPVehicleFix = true,
        exposureVehicleFPPEnterDuration = 0.3,
        exposureMinOffset = 0.0,
        exposureMaxOffset = 0.0,
        bloomEnabled = true,
        bloomGlobeEnabled = false,
        bloomCarEnabled = true,
        bloomVehicleFPPTransitionDuration = 1.0,
        bloomColorScale = 0.1,
        sceneColorScale = 1.0,
    },
}

local function copyDefaults()
    local t = {}
    for k, v in pairs(defaults) do t[k] = v end
    return t
end

-- UI state (not pushed to service)
local stateDefaults = {
    autoMode = false,
    activePreset = "",
    masterGlobeEnabled = false,
    masterVehicleOnly = false,
    modVersion = MOD_VERSION,
    envTunerWarningAcknowledged = false,
}

local function copyStateDefaults()
    local t = {}
    for k, v in pairs(stateDefaults) do t[k] = v end
    return t
end

-- Complete authoritative state pushed to service when Auto mode is active.
-- Every effect category and every globe/car pair is listed explicitly.
-- Auto mode is vehicle FPP exposure only - all other categories are forced off.
local autoModeValues = {
    enable = true,

    -- Exposure: vehicle FPP only, metering fix on
    exposureOverrideEnabled          = true,
    exposureOverrideGlobeEnabled     = false,
    exposureOverrideCarEnabled       = true,
    exposureVehicleFPPEnterDuration  = 0.6,
    exposureFPPVehicleFix            = true,
    exposureMinOffset                = 0.0,
    exposureMinOffsetEnabled         = true,
    exposureMaxOffset                = 0.8,
    exposureMaxOffsetEnabled         = true,

    -- Exposure adaptation: off
    exposureAdaptSpeedEnabled        = false,
    exposureAdaptGlobeEnabled        = false,
    exposureAdaptCarEnabled          = false,

    -- Bloom: off
    bloomEnabled                     = false,
    bloomGlobeEnabled                = false,
    bloomCarEnabled                  = false,

    -- Vignette: off
    vignetteEnabled                  = false,
    vignetteGlobeEnabled             = false,
    vignetteCarEnabled               = false,

    -- Lens flare: off
    lensFlareEnabled                 = false,
    lensFlareGlobeEnabled            = false,
    lensFlareCarEnabled              = false,

    -- Chromatic aberration: off
    chromaticAberrationEnabled       = false,
    chromaticAberrationGlobeEnabled  = false,
    chromaticAberrationCarEnabled    = false,

    -- Volumetric fog: off
    volFogEnabled                    = false,
    volFogGlobeEnabled               = false,
    volFogCarEnabled                 = false,

    -- Color grading: off
    colorGradingEnabled              = false,
    colorGradingGlobeEnabled         = false,
    colorGradingCarEnabled           = false,
}

local settings = copyDefaults()
local state = copyStateDefaults()

local service = nil
local cetOpen = false
local savePending = false
local activePreset = nil
local conflictDetected = false
local conflictModName = nil
local warningDetected = false
local warningDismissed = false
local WindowUtils = nil
local uiMode = "global"
local autoSwitched = false
local filmGrainLinkCopiedAt = nil

local uiOnlyKeys = {
    filmGrainGangSliders = true,
    filmGrainGangSlidersScanner = true,
}

local function deriveSetter(key)
    return "Set" .. key:sub(1, 1):upper() .. key:sub(2)
end

local function pushEnabled()
    return service ~= nil and not conflictDetected
end

local function pushToService(key, value)
    if not pushEnabled() then return end
    if defaults[key] == nil then return end
    if uiOnlyKeys[key] then return end
    if state.autoMode and autoModeValues[key] ~= nil then
        value = autoModeValues[key]
    end
    local method = deriveSetter(key)
    service[method](service, value)
end

local function pushAllToService()
    if not pushEnabled() then return end
    local autoOn = state.autoMode
    service:BeginBatchPush()
    for key, _ in pairs(defaults) do
        if uiOnlyKeys[key] then goto continue end
        local value = settings[key]
        if autoOn and autoModeValues[key] ~= nil then
            value = autoModeValues[key]
        end
        local method = deriveSetter(key)
        service[method](service, value)
        ::continue::
    end
    service:EndBatchPush()
end

local function loadSettings()
    local file = io.open("settings.json", "r")
    if not file then
        settings = copyDefaults()
        state = copyStateDefaults()
        return
    end
    local content = file:read("*a")
    file:close()
    local ok, loaded = pcall(json.decode, content)
    if not ok or type(loaded) ~= "table" then
        print("[NovaOptics] Failed to parse settings.json, using defaults")
        settings = copyDefaults()
        state = copyStateDefaults()
        return
    end
    settings = {}
    for k, v in pairs(defaults) do
        if loaded[k] ~= nil and type(loaded[k]) == type(v) then
            settings[k] = loaded[k]
        else
            settings[k] = v
        end
    end
    state = {}
    for k, v in pairs(stateDefaults) do
        if loaded[k] ~= nil and type(loaded[k]) == type(v) then
            state[k] = loaded[k]
        else
            state[k] = v
        end
    end
end

local function saveSettings()
    local file = io.open("settings.json", "w")
    if not file then
        print("[NovaOptics] Failed to open settings.json for writing")
        return
    end
    local merged = {}
    for k, v in pairs(settings) do
        -- Skip non-explicit vehicle values (they use fallthrough from global)
        local explicitKey = k .. "Explicit"
        if defaults[explicitKey] ~= nil and not settings[explicitKey] then
        else
            merged[k] = v
        end
    end
    for k, v in pairs(state) do merged[k] = v end
    file:write(json.encode(merged))
    file:close()
    savePending = false
end

local function set(key, value)
    settings[key] = value
    pushToService(key, value)
    savePending = true
end

local function save(key, value)
    settings[key] = value
    pushToService(key, value)
    saveSettings()
end

local function resetKey(key)
    local def = defaults[key]
    if def == nil then return end
    settings[key] = def
    pushToService(key, def)
    saveSettings()
end

local function resetKeyForMode(key)
    if uiMode == "vehicle" then
        local vehicleKey = key .. "Vehicle"
        local explicitKey = key .. "VehicleExplicit"
        if defaults[vehicleKey] == nil then
            resetKey(key)
            return
        end
        if not settings[explicitKey] then
            return
        end
        settings[explicitKey] = false
        settings[vehicleKey] = settings[key]
        pushToService(explicitKey, false)
        pushToService(vehicleKey, settings[key])
        saveSettings()
    else
        resetKey(key)
    end
end

local function resetToDefaults()
    settings = copyDefaults()
    state.activePreset = ""
    state.autoMode = false
    state.masterGlobeEnabled = false
    state.masterVehicleOnly = false
    activePreset = nil
    uiMode = "global"
    autoSwitched = false
    pushAllToService()
    saveSettings()
end

local function getEffectiveKey(key)
    if uiMode == "vehicle" then
        local vehicleKey = key .. "Vehicle"
        local explicitKey = key .. "VehicleExplicit"
        if defaults[vehicleKey] ~= nil then
            return vehicleKey, explicitKey
        end
    end
    return key, nil
end

local function getDisplayValue(key)
    if uiMode == "vehicle" then
        local vehicleKey = key .. "Vehicle"
        local explicitKey = key .. "VehicleExplicit"
        if defaults[vehicleKey] ~= nil then
            if settings[explicitKey] then
                return settings[vehicleKey]
            else
                return settings[key]
            end
        end
    end
    return settings[key]
end

local function tooltip(text)
    if ImGui.IsItemHovered() and text ~= "" then
        ImGui.SetTooltip(text)
    end
end

-- Renders a colored glyph warning with dimmed descriptive text and a tooltip.
-- Matches the ENVTuner inline warning style.
-- onClick (optional): called when the user clicks the glyph or text.
-- textAlpha (optional, default 1.0): alpha for the descriptive text - used for fade effects.
-- textColor (optional, default {0.6, 0.6, 0.6}): RGB color for the descriptive text.
local function renderWarning(icon, color, text, tooltipText, onClick, textAlpha, textColor)
    textAlpha = textAlpha or 1.0
    textColor = textColor or {0.6, 0.6, 0.6}
    ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetColorU32(color[1], color[2], color[3], color[4]))
    ImGui.Text(IconGlyphs[icon] or IconGlyphs.AlertBox)
    ImGui.PopStyleColor()
    if onClick and ImGui.IsItemClicked(0) then onClick() end
    ImGui.SameLine()
    if tooltipText and ImGui.IsItemHovered() then
        ImGui.SetTooltip(tooltipText)
    end
    ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetColorU32(textColor[1], textColor[2], textColor[3], textAlpha))
    ImGui.Text(text)
    ImGui.PopStyleColor()
    if onClick and ImGui.IsItemClicked(0) then onClick() end
end

local function IconButton(glyph)
    ImGui.PushStyleColor(ImGuiCol.Button, ImGui.GetColorU32(0, 0, 0, 0))
    ImGui.PushStyleColor(ImGuiCol.ButtonActive, ImGui.GetColorU32(0, 0, 0, 0))
    ImGui.PushStyleColor(ImGuiCol.ButtonHovered, ImGui.GetColorU32(0, 0, 0, 0))
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, 0, 4)
    ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, 0, 2)
    ImGui.PushStyleVar(ImGuiStyleVar.ItemInnerSpacing, 0, 0)
    ImGui.PushStyleVar(ImGuiStyleVar.ButtonTextAlign, 0.5, 0.5)
    ImGui.Button(glyph)
    ImGui.PopStyleVar(4)
    ImGui.PopStyleColor(3)
end

local function Slider(iconStr, tip, key, min, max, fmt)
    fmt = fmt or "%.2f"
    IconButton(iconStr)
    tooltip(tip .. "\nRight-click to reset")
    ImGui.SameLine()
    ImGui.SetNextItemWidth(-1)
    local displayVal = getDisplayValue(key)
    local val, changed = ImGui.SliderFloat("##" .. key, displayVal, min, max, fmt)
    if changed then
        local writeKey, explicitKey = getEffectiveKey(key)
        settings[writeKey] = val
        pushToService(writeKey, val)
        if explicitKey then
            settings[explicitKey] = true
            pushToService(explicitKey, true)
        end
        savePending = true
    end
    if ImGui.IsItemDeactivatedAfterEdit() then saveSettings() end
    if ImGui.IsItemClicked(1) then resetKeyForMode(key) end
end

-- Show a structured tooltip for a toggle icon.
-- When disabled, renders the parameter name then the re-enable hint in orange.
-- When enabled, shows the full tip with click-to-disable and right-click-to-reset lines.
local function toggleIconTooltip(tip, enabled)
    if not ImGui.IsItemHovered() then return end
    if not enabled then
        local name = tip:match("^([^\n]+)") or tip
        ImGui.BeginTooltip()
        ImGui.Text(name)
        ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetColorU32(0.9, 0.4, 0.2, 1.0))
        ImGui.Text("Parameter disabled (click to re-enable)")
        ImGui.PopStyleColor()
        ImGui.EndTooltip()
    else
        ImGui.SetTooltip(tip .. "\nClick icon to disable\nRight-click to reset")
    end
end

local function ToggleSlider(iconStr, tip, enableKey, key, min, max, fmt)
    fmt = fmt or "%.2f"
    local enabled = settings[enableKey]
    if not enabled then
        ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetColorU32(0.5, 0.5, 0.5, 1))
    end
    IconButton(iconStr)
    if not enabled then
        ImGui.PopStyleColor()
    end
    if ImGui.IsItemClicked(0) then save(enableKey, not enabled) end
    if ImGui.IsItemClicked(1) then
        settings[enableKey] = defaults[enableKey]
        settings[key] = defaults[key]
        pushToService(enableKey, defaults[enableKey])
        pushToService(key, defaults[key])
        saveSettings()
    end
    toggleIconTooltip(tip, enabled)
    ImGui.SameLine()
    if not enabled then ImGui.BeginDisabled(true) end
    ImGui.SetNextItemWidth(-1)
    local displayVal = getDisplayValue(key)
    local val, changed = ImGui.SliderFloat("##" .. key, displayVal, min, max, fmt)
    if changed then
        local writeKey, explicitKey = getEffectiveKey(key)
        settings[writeKey] = val
        pushToService(writeKey, val)
        if explicitKey then
            settings[explicitKey] = true
            pushToService(explicitKey, true)
        end
        savePending = true
    end
    if ImGui.IsItemDeactivatedAfterEdit() then saveSettings() end
    if ImGui.IsItemClicked(1) then resetKeyForMode(key) end
    if not enabled then ImGui.EndDisabled() end
end

local function ToggleColorPicker(iconStr, tip, enableKey, redKey, greenKey, blueKey)
    local enabled = settings[enableKey]
    if not enabled then
        ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetColorU32(0.5, 0.5, 0.5, 1))
    end
    IconButton(iconStr)
    if not enabled then
        ImGui.PopStyleColor()
    end
    if ImGui.IsItemClicked(0) then save(enableKey, not enabled) end
    if ImGui.IsItemClicked(1) then
        settings[enableKey] = defaults[enableKey]
        settings[redKey] = defaults[redKey]
        settings[greenKey] = defaults[greenKey]
        settings[blueKey] = defaults[blueKey]
        pushToService(enableKey, defaults[enableKey])
        pushToService(redKey, defaults[redKey])
        pushToService(greenKey, defaults[greenKey])
        pushToService(blueKey, defaults[blueKey])
        saveSettings()
    end
    toggleIconTooltip(tip, enabled)
    ImGui.SameLine()
    if not enabled then ImGui.BeginDisabled(true) end
    local r = (getDisplayValue(redKey) or 0) / 255
    local g = (getDisplayValue(greenKey) or 0) / 255
    local b = (getDisplayValue(blueKey) or 0) / 255
    local color, changed = ImGui.ColorEdit3("##" .. enableKey, {r, g, b}, ImGuiColorEditFlags.NoInputs)
    if changed then
        local rKey, rExplicit = getEffectiveKey(redKey)
        local gKey, gExplicit = getEffectiveKey(greenKey)
        local bKey, bExplicit = getEffectiveKey(blueKey)
        settings[rKey] = math.floor(color[1] * 255 + 0.5)
        settings[gKey] = math.floor(color[2] * 255 + 0.5)
        settings[bKey] = math.floor(color[3] * 255 + 0.5)
        pushToService(rKey, settings[rKey])
        pushToService(gKey, settings[gKey])
        pushToService(bKey, settings[bKey])
        if rExplicit then
            settings[rExplicit] = true; pushToService(rExplicit, true)
            settings[gExplicit] = true; pushToService(gExplicit, true)
            settings[bExplicit] = true; pushToService(bExplicit, true)
        end
        savePending = true
        saveSettings()
    end
    if ImGui.IsItemClicked(1) then
        if uiMode == "vehicle" then
            local keys = {redKey, greenKey, blueKey}
            for _, k in ipairs(keys) do
                local vehicleKey = k .. "Vehicle"
                local explicitKey = k .. "VehicleExplicit"
                if defaults[vehicleKey] ~= nil and settings[explicitKey] then
                    settings[explicitKey] = false
                    settings[vehicleKey] = settings[k]
                    pushToService(explicitKey, false)
                    pushToService(vehicleKey, settings[k])
                end
            end
            saveSettings()
        else
            settings[redKey] = defaults[redKey]
            settings[greenKey] = defaults[greenKey]
            settings[blueKey] = defaults[blueKey]
            pushToService(redKey, defaults[redKey])
            pushToService(greenKey, defaults[greenKey])
            pushToService(blueKey, defaults[blueKey])
            saveSettings()
        end
    end
    ImGui.SameLine()
    ImGui.SetNextItemWidth(-1)
    local dragR = getDisplayValue(redKey) or 0
    local dragG = getDisplayValue(greenKey) or 0
    local dragB = getDisplayValue(blueKey) or 0
    local dragColor, dragChanged = ImGui.DragInt3("##drag_" .. enableKey, {dragR, dragG, dragB}, 1, 0, 255)
    if dragChanged then
        local rKey, rExplicit = getEffectiveKey(redKey)
        local gKey, gExplicit = getEffectiveKey(greenKey)
        local bKey, bExplicit = getEffectiveKey(blueKey)
        settings[rKey] = dragColor[1]
        settings[gKey] = dragColor[2]
        settings[bKey] = dragColor[3]
        pushToService(rKey, settings[rKey])
        pushToService(gKey, settings[gKey])
        pushToService(bKey, settings[bKey])
        if rExplicit then
            settings[rExplicit] = true; pushToService(rExplicit, true)
            settings[gExplicit] = true; pushToService(gExplicit, true)
            settings[bExplicit] = true; pushToService(bExplicit, true)
        end
        savePending = true
        saveSettings()
    end
    if ImGui.IsItemClicked(1) then
        if uiMode == "vehicle" then
            local keys = {redKey, greenKey, blueKey}
            for _, k in ipairs(keys) do
                local vehicleKey = k .. "Vehicle"
                local explicitKey = k .. "VehicleExplicit"
                if defaults[vehicleKey] ~= nil and settings[explicitKey] then
                    settings[explicitKey] = false
                    settings[vehicleKey] = settings[k]
                    pushToService(explicitKey, false)
                    pushToService(vehicleKey, settings[k])
                end
            end
            saveSettings()
        else
            settings[redKey] = defaults[redKey]
            settings[greenKey] = defaults[greenKey]
            settings[blueKey] = defaults[blueKey]
            pushToService(redKey, defaults[redKey])
            pushToService(greenKey, defaults[greenKey])
            pushToService(blueKey, defaults[blueKey])
            saveSettings()
        end
    end
    if not enabled then ImGui.EndDisabled() end
end

local function DualToggle(globeKey, carKey)
    local globeVal, globeChanged = ImGui.Checkbox(IconGlyphs.Earth .. "##" .. globeKey, settings[globeKey])
    if globeChanged then save(globeKey, globeVal) end
    tooltip("Apply globally (on foot + everywhere)\nRight-click to reset")
    if ImGui.IsItemClicked(1) then resetKey(globeKey) end
    ImGui.SameLine()
    local carVal, carChanged = ImGui.Checkbox(IconGlyphs.Car .. "##" .. carKey, settings[carKey])
    if carChanged then save(carKey, carVal) end
    tooltip("Apply vehicle-specific values in FPP\nRight-click to reset")
    if ImGui.IsItemClicked(1) then resetKey(carKey) end
end

local function Check(label, key, tip)
    local val, changed = ImGui.Checkbox(label, settings[key])
    if changed then save(key, val) end
    if ImGui.IsItemClicked(1) then resetKey(key) end
    if tip then tooltip(tip .. "\nRight-click to reset") end
end

-- forceDisabled (optional): when true, renders the header greyed out, collapsed, and non-interactive.
local function CategoryHeader(name, overrideKey, forceDisabled)
    if forceDisabled then
        ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetColorU32(0.4, 0.4, 0.4, 1))
        ImGui.PushStyleColor(ImGuiCol.Header, ImGui.GetColorU32(0.4, 0.4, 0.5, 0.15))
        ImGui.PushStyleColor(ImGuiCol.HeaderHovered, ImGui.GetColorU32(0.4, 0.4, 0.5, 0.15))
        ImGui.PushStyleColor(ImGuiCol.HeaderActive, ImGui.GetColorU32(0.4, 0.4, 0.5, 0.15))
        ImGui.BeginDisabled(true)
        ImGui.CollapsingHeader(name)
        ImGui.EndDisabled()
        ImGui.PopStyleColor(4)
        return false
    end
    local enabled = overrideKey and settings[overrideKey]
    local colorCount = 0
    if overrideKey and not enabled then
        ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetColorU32(0.6, 0.6, 0.6, 1))
        ImGui.PushStyleColor(ImGuiCol.Header, ImGui.GetColorU32(0.4, 0.4, 0.5, 0.15))
        ImGui.PushStyleColor(ImGuiCol.HeaderHovered, ImGui.GetColorU32(0.5, 0.5, 0.5, 0.25))
        ImGui.PushStyleColor(ImGuiCol.HeaderActive, ImGui.GetColorU32(0.6, 0.6, 0.6, 0.35))
        colorCount = 4
    end
    local isOpen = ImGui.CollapsingHeader(name)
    if overrideKey and not activePreset and ImGui.IsItemClicked(1) then
        save(overrideKey, not settings[overrideKey])
    end
    if overrideKey and not activePreset then
        tooltip("Right-click to toggle " .. name)
    end
    if colorCount > 0 then ImGui.PopStyleColor(colorCount) end
    return isOpen
end

local categoryKeys = {
    Bloom = {
        "bloomEnabled", "bloomGlobeEnabled", "bloomCarEnabled", "bloomVehicleFPPTransitionDuration",
        "bloomColorScale", "bloomColorScaleEnabled", "bloomColorScaleVehicle", "bloomColorScaleVehicleExplicit",
        "bloomSize", "bloomSizeEnabled", "bloomSizeVehicle", "bloomSizeVehicleExplicit",
        "bloomAnamorphic", "bloomAnamorphicEnabled", "bloomAnamorphicVehicle", "bloomAnamorphicVehicleExplicit",
        "luminanceThresholdMax", "luminanceThresholdMaxEnabled", "luminanceThresholdMaxVehicle", "luminanceThresholdMaxVehicleExplicit",
        "sceneColorScale", "sceneColorScaleEnabled", "sceneColorScaleVehicle", "sceneColorScaleVehicleExplicit"
    },
    ["Chromatic Aberration"] = {
        "chromaticAberrationEnabled", "chromaticAberrationGlobeEnabled", "chromaticAberrationCarEnabled",
        "chromaticAberrationTransitionDuration",
        "caExp", "caExpEnabled", "caExpVehicle", "caExpVehicleExplicit",
        "caMargin", "caMarginEnabled", "caMarginVehicle", "caMarginVehicleExplicit",
        "caSizeX", "caSizeXEnabled", "caSizeXVehicle", "caSizeXVehicleExplicit",
        "caSizeY", "caSizeYEnabled", "caSizeYVehicle", "caSizeYVehicleExplicit",
        "caSubpixelDispersal", "caSubpixelDispersalEnabled", "caSubpixelDispersalVehicle", "caSubpixelDispersalVehicleExplicit"
    },
    ["Color Grading"] = {
        "colorGradingEnabled", "colorGradingGlobeEnabled", "colorGradingCarEnabled",
        "colorGradingTransitionDuration",
        "colorGradingBrightness", "colorGradingBrightnessEnabled", "colorGradingBrightnessVehicle", "colorGradingBrightnessVehicleExplicit",
        "colorGradingContrast", "colorGradingContrastEnabled", "colorGradingContrastVehicle", "colorGradingContrastVehicleExplicit",
        "colorGradingContrastPivot", "colorGradingContrastPivotEnabled", "colorGradingContrastPivotVehicle", "colorGradingContrastPivotVehicleExplicit",
        "colorGradingSaturation", "colorGradingSaturationEnabled", "colorGradingSaturationVehicle", "colorGradingSaturationVehicleExplicit"
    },
    ["Film Grain"] = {
        "filmGrainEnabled", "filmGrainGlobeEnabled", "filmGrainApplyAfterUpsampling",
        "filmGrainGangSliders", "filmGrainGangSlidersScanner",
        "filmGrainGrainSizeX", "filmGrainGrainSizeY", "filmGrainGrainSizeZ",
        "filmGrainStrengthX", "filmGrainStrengthY", "filmGrainStrengthZ", "filmGrainStrengthW",
        "filmGrainScannerEnabled",
        "filmGrainGrainSizeXScanner", "filmGrainGrainSizeYScanner", "filmGrainGrainSizeZScanner",
        "filmGrainStrengthXScanner", "filmGrainStrengthYScanner", "filmGrainStrengthZScanner", "filmGrainStrengthWScanner",
    },
    ["Exposure Adaptation"] = {
        "exposureAdaptSpeedEnabled", "exposureAdaptGlobeEnabled", "exposureAdaptCarEnabled",
        "exposureAdaptSpeedDownValue", "exposureAdaptSpeedDownEnabled", "exposureAdaptSpeedDownValueVehicle", "exposureAdaptSpeedDownValueVehicleExplicit",
        "exposureAdaptSpeedUpValue", "exposureAdaptSpeedUpEnabled", "exposureAdaptSpeedUpValueVehicle", "exposureAdaptSpeedUpValueVehicleExplicit"
    },
    ["Exposure"] = {
        "exposureOverrideEnabled", "exposureOverrideGlobeEnabled", "exposureOverrideCarEnabled",
        "exposureVehicleFPPEnterDuration", "exposureFPPVehicleFix",
        "exposureMinOffset", "exposureMinOffsetEnabled", "exposureMinOffsetVehicle", "exposureMinOffsetVehicleExplicit",
        "exposureMaxOffset", "exposureMaxOffsetEnabled", "exposureMaxOffsetVehicle", "exposureMaxOffsetVehicleExplicit"
    },
    ["Lens Flare"] = {
        "lensFlareEnabled", "lensFlareGlobeEnabled", "lensFlareCarEnabled", "lensFlareTransitionDuration",
        "lensFlareChromaticEffect", "lensFlareChromaticEffectEnabled", "lensFlareChromaticEffectVehicle", "lensFlareChromaticEffectVehicleExplicit",
        "lensFlareHaloWidth", "lensFlareHaloWidthEnabled", "lensFlareHaloWidthVehicle", "lensFlareHaloWidthVehicleExplicit",
        "lensFlareSaturationValue", "lensFlareSaturationValueEnabled", "lensFlareSaturationValueVehicle", "lensFlareSaturationValueVehicleExplicit",
        "lensFlareScaleValue", "lensFlareScaleValueEnabled", "lensFlareScaleValueVehicle", "lensFlareScaleValueVehicleExplicit"
    },
    Vignette = {
        "vignetteEnabled", "vignetteGlobeEnabled", "vignetteCarEnabled", "vignetteTransitionDuration",
        "vignetteExp", "vignetteExpEnabled", "vignetteExpVehicle", "vignetteExpVehicleExplicit",
        "vignetteColorEnabled",
        "vignetteColorRed", "vignetteColorRedVehicle", "vignetteColorRedVehicleExplicit",
        "vignetteColorGreen", "vignetteColorGreenVehicle", "vignetteColorGreenVehicleExplicit",
        "vignetteColorBlue", "vignetteColorBlueVehicle", "vignetteColorBlueVehicleExplicit",
        "vignetteColorAlpha", "vignetteColorAlphaVehicle", "vignetteColorAlphaVehicleExplicit"
    },
    ["Volumetric Fog"] = {
        "volFogEnabled", "volFogGlobeEnabled", "volFogCarEnabled", "volFogTransitionDuration",
        "volFogAbsorption", "volFogAbsorptionEnabled", "volFogAbsorptionVehicle", "volFogAbsorptionVehicleExplicit",
        "volFogDensity", "volFogDensityEnabled", "volFogDensityVehicle", "volFogDensityVehicleExplicit",
        "volFogLocalLightScale", "volFogLocalLightScaleEnabled", "volFogLocalLightScaleVehicle", "volFogLocalLightScaleVehicleExplicit",
        "volFogLocalAmbientScale", "volFogLocalAmbientScaleEnabled", "volFogLocalAmbientScaleVehicle", "volFogLocalAmbientScaleVehicleExplicit"
    },
}

local function resetCategoryToDefaults(categoryName)
    local keys = categoryKeys[categoryName]
    if not keys then return end
    if pushEnabled() then service:BeginBatchPush() end
    for _, key in ipairs(keys) do
        settings[key] = defaults[key]
        pushToService(key, defaults[key])
    end
    if pushEnabled() then service:EndBatchPush() end
    saveSettings()
end

local function CategoryResetButton(categoryName)
    ImGui.SameLine()
    local btnWidth = ImGui.GetFrameHeight()
    ImGui.SetCursorPosX(ImGui.GetCursorPosX() + ImGui.GetContentRegionAvail() - btnWidth)
    if ImGui.Button(IconGlyphs.Reload .. "##Reset" .. categoryName, 0, 0) then
        resetCategoryToDefaults(categoryName)
    end
    tooltip("Reset " .. categoryName .. " to defaults")
end

-- Returns true if auto mode actively configures this category (not just forces it off).
-- Only the two exposure categories are locked - they contain the values auto mode sets.
-- Other categories auto mode forces to off (Bloom, Vignette, etc.) remain accessible
-- since the service-level override already handles them without needing UI lockout.
local AUTO_LOCKED_CATEGORIES = {
    ["Exposure"] = true,
    ["Exposure Adaptation"] = true,
}
local function isCategoryAutoControlled(categoryName)
    return AUTO_LOCKED_CATEGORIES[categoryName] == true
end

local function drawPresetRow()
    for i, name in ipairs(presetOrder) do
        local preset = presets[name]
        local isActive = (activePreset == name)
        local toggled, changed = ImGui.Checkbox(name .. "##preset", isActive)
        if changed then
            if toggled then
                for k, v in pairs(defaults) do
                    settings[k] = v
                end
                for k, v in pairs(preset) do
                    settings[k] = v
                end
                activePreset = name
                state.activePreset = name
                pushAllToService()
                saveSettings()
            else
                activePreset = nil
                state.activePreset = ""
                saveSettings()
            end
        end
        if i < #presetOrder then ImGui.SameLine() end
    end
end

local function drawConflictBanner()
    if conflictDetected then
        ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetColorU32(1, 0.4, 0.4, 1))
        ImGui.TextWrapped("ENV Tuner Lite detected. Nova Optics is a direct replacement and upgrade for ENV Tuner Lite. Please remove ENV Tuner Lite to use Nova Optics.")
        ImGui.PopStyleColor()
        ImGui.Spacing()
    end
end

local function drawEnvTunerWarningModal()
    local centerX, centerY = ImGui.GetWindowPos()
    local winW, winH = ImGui.GetWindowSize()
    ImGui.SetNextWindowPos(centerX + winW * 0.5, centerY + winH * 0.5, ImGuiCond.Appearing, 0.5, 0.5)
    ImGui.SetNextWindowSize(500, 0)
    if ImGui.BeginPopupModal("ENVTuner Detected##novaoptics", ImGuiWindowFlags.NoMove) then
        ImGui.TextWrapped("ENVTuner is installed. Both mods modify the same environment parameters. Using them together may cause visual conflicts.")
        ImGui.Spacing()
        ImGui.TextWrapped("Nova Optics is also a direct replacement and upgrade for ENV Tuner Lite. You can safely remove ENV Tuner Lite in place of this mod if you are using it.")
        ImGui.Separator()
        ImGui.Spacing()
        local spacing = ImGui.GetStyle().ItemSpacing.x
        local halfWidth = (ImGui.GetContentRegionAvail() - spacing) * 0.5
        if ImGui.Button("I Understand", halfWidth, 0) then
            warningDismissed = true
            state.envTunerWarningAcknowledged = true
            pushToService("enable", true)
            saveSettings()
            ImGui.CloseCurrentPopup()
        end
        ImGui.SameLine()
        if ImGui.Button("Cancel", halfWidth, 0) then
            save("enable", false)
            ImGui.CloseCurrentPopup()
        end
        ImGui.EndPopup()
    end
end

local function drawResetModal()
    local centerX, centerY = ImGui.GetWindowPos()
    local winW, winH = ImGui.GetWindowSize()
    ImGui.SetNextWindowPos(centerX + winW * 0.5, centerY + winH * 0.5, ImGuiCond.Appearing, 0.5, 0.5)
    if ImGui.BeginPopupModal("Reset to Defaults?##novaoptics", ImGuiWindowFlags.AlwaysAutoResize + ImGuiWindowFlags.NoMove) then
        ImGui.Text("Reset all settings to their default values?")
        ImGui.Text("This cannot be undone.")
        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()
        if ImGui.Button("Reset", 120, 0) then
            resetToDefaults()
            ImGui.CloseCurrentPopup()
        end
        ImGui.SameLine()
        if ImGui.Button("Cancel", 120, 0) then
            ImGui.CloseCurrentPopup()
        end
        ImGui.EndPopup()
    end
end

local function drawCategory(header, disabled, drawControls)
    if not header then return end
    if disabled then ImGui.BeginDisabled(true) end
    drawControls()
    if disabled then ImGui.EndDisabled() end
end

local WINDOW_NAME = "Nova Optics"

local function drawModeToggle(width)
    local isVehicle = (uiMode == "vehicle")
    local label = isVehicle and "Vehicle" or "Global"
    if ImGui.Button(label .. "##modeToggle", width or 0, 0) then
        if isVehicle then
            uiMode = "global"
        else
            uiMode = "vehicle"
        end
        autoSwitched = false
    end
    tooltip("Slider Mode: " .. label .. "\n\nGlobal: values applied everywhere\nVehicle: values applied in vehicle FPP")
end

local function hasAnyCarToggle()
    return settings.exposureOverrideCarEnabled
        or settings.exposureAdaptCarEnabled
        or settings.bloomCarEnabled
        or settings.volFogCarEnabled
        or settings.vignetteCarEnabled
        or settings.lensFlareCarEnabled
        or settings.chromaticAberrationCarEnabled
        or settings.colorGradingCarEnabled
end

local function checkAutoSwitch()
    if not service then return end
    local inVehicleFPP = service:IsVehicleFPPActive()
    local anyCarToggle = hasAnyCarToggle()

    if inVehicleFPP and anyCarToggle and uiMode == "global" and not autoSwitched then
        uiMode = "vehicle"
        autoSwitched = true
    elseif not inVehicleFPP and autoSwitched then
        uiMode = "global"
        autoSwitched = false
    end
end

local function updateWindowUtils()
    if not WindowUtils then return end
    WindowUtils.Update(WINDOW_NAME)
end

local function drawWindow()
    local autoOn = state.autoMode
    local displayW, displayH = GetDisplayResolution()

    if WindowUtils and WindowUtils.SetConstraintsPct then
        WindowUtils.SetConstraintsPct(17, 30, 100, 100, WINDOW_NAME)
    else
        ImGui.SetNextWindowSizeConstraints(displayW * 0.17, displayH * 0.3, displayW, displayH)
    end
    ImGui.SetNextWindowSize(420, 600, ImGuiCond.FirstUseEver)

    if not ImGui.Begin(WINDOW_NAME) then
        updateWindowUtils()
        ImGui.End()
        return
    end

    drawConflictBanner()
    if conflictDetected then ImGui.BeginDisabled(true) end

    if settings.enable then
        ImGui.PushStyleVar(ImGuiStyleVar.ButtonTextAlign, 0.5, 0.5)
        ImGui.PushStyleColor(ImGuiCol.Button, ImGui.GetColorU32(0.0, 1, 0.7, 1))
        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, ImGui.GetColorU32(0, 0.8, 0.56, 1))
        ImGui.PushStyleColor(ImGuiCol.ButtonActive, ImGui.GetColorU32(0.1, 0.8, 0.6, 1))
        ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetColorU32(0, 0, 0, 1))
        if ImGui.Button("Enabled##enableToggle", ImGui.GetContentRegionAvail(), 0) then
            if warningDetected and not warningDismissed then
                settings.enable = false
                saveSettings()
            else
                save("enable", false)
            end
        end
        ImGui.PopStyleColor(4)
        ImGui.PopStyleVar()
    else
        ImGui.PushStyleVar(ImGuiStyleVar.ButtonTextAlign, 0.5, 0.5)
        ImGui.PushStyleColor(ImGuiCol.Button, ImGui.GetColorU32(1, 0.3, 0.3, 1))
        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, ImGui.GetColorU32(1, 0.45, 0.45, 1))
        ImGui.PushStyleColor(ImGuiCol.ButtonActive, ImGui.GetColorU32(1, 0.45, 0.45, 1))
        ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetColorU32(0, 0, 0, 1))
        if ImGui.Button("Disabled##enableToggle", ImGui.GetContentRegionAvail(), 0) then
            if warningDetected and not warningDismissed then
                settings.enable = true
                saveSettings()
            else
                save("enable", true)
            end
        end
        ImGui.PopStyleColor(4)
        ImGui.PopStyleVar()
    end
    if warningDetected and settings.enable and not warningDismissed then
        ImGui.OpenPopup("ENVTuner Detected##novaoptics")
    end

    if not settings.enable then ImGui.BeginDisabled(true) end
    local autoVal, autoChanged = ImGui.Checkbox("Auto", state.autoMode or false)
    if autoChanged then
        state.autoMode = autoVal
        if autoVal then
            activePreset = nil
            state.activePreset = ""
        end
        pushAllToService()
        saveSettings()
    end
    tooltip("Fixes first-person vehicle exposure automatically\n\nLocks exposure area settings from user edits")
    ImGui.SameLine()
    if state.autoMode then ImGui.BeginDisabled(true) end
    local masterGlobeActive = state.masterGlobeEnabled or false
    local masterGlobeVal, masterGlobeChanged = ImGui.Checkbox(IconGlyphs.Earth .. "##masterGlobe", masterGlobeActive)
    if masterGlobeChanged then
        state.masterGlobeEnabled = masterGlobeVal
        local globeEnabledKeys = {
            "exposureOverrideGlobeEnabled", "exposureAdaptGlobeEnabled",
            "bloomGlobeEnabled", "volFogGlobeEnabled",
            "vignetteGlobeEnabled", "lensFlareGlobeEnabled",
            "chromaticAberrationGlobeEnabled", "colorGradingGlobeEnabled"
        }
        for _, key in ipairs(globeEnabledKeys) do
            settings[key] = masterGlobeVal
            pushToService(key, masterGlobeVal)
        end
        saveSettings()
    end
    tooltip("Master Global Toggle\nSets all categories to global mode\nRight-click to reset")
    ImGui.SameLine()
    local masterActive = state.masterVehicleOnly or false
    local masterVal, masterChanged = ImGui.Checkbox(IconGlyphs.Car .. "##master", masterActive)
    if masterChanged then
        state.masterVehicleOnly = masterVal
        local carEnabledKeys = {
            "exposureOverrideCarEnabled", "exposureAdaptCarEnabled",
            "bloomCarEnabled", "volFogCarEnabled",
            "vignetteCarEnabled", "lensFlareCarEnabled",
            "chromaticAberrationCarEnabled", "colorGradingCarEnabled"
        }
        for _, key in ipairs(carEnabledKeys) do
            settings[key] = masterVal
            pushToService(key, masterVal)
        end
        saveSettings()
    end
    tooltip("Master Vehicle FPP\nSets all categories to vehicle mode\nRight-click to reset")
    if state.autoMode then ImGui.EndDisabled() end
    if not settings.enable then ImGui.EndDisabled() end

    ImGui.SameLine()
    local modeText = (uiMode == "vehicle") and "Vehicle" or "Global"
    local resetText = "Reset"
    local modeWidth = math.max(ImGui.CalcTextSize("Vehicle"), ImGui.CalcTextSize("Global")) * 1.8
    local resetWidth = ImGui.CalcTextSize(resetText) * 1.8
    local spacing = ImGui.GetStyle().ItemSpacing.x
    local totalWidth = modeWidth + spacing + resetWidth
    local availWidth = ImGui.GetContentRegionAvail()
    ImGui.SetCursorPosX(ImGui.GetCursorPosX() + availWidth - totalWidth)
    drawModeToggle(modeWidth)
    ImGui.SameLine()
    if ImGui.Button(resetText, resetWidth, 0) then
        ImGui.OpenPopup("Reset to Defaults?##novaoptics")
    end
    tooltip("Reset all settings to defaults")


    ImGui.PushStyleColor(ImGuiCol.ChildBg, ImGui.GetColorU32(0.75, 0.8, 1, 0.045))
    ImGui.BeginChild("##categories", ImGui.GetContentRegionAvail(), 0, false, ImGuiWindowFlags.AlwaysUseWindowPadding)

        local presetActive = activePreset ~= nil

        drawCategory(CategoryHeader("Bloom", "bloomEnabled", autoOn and isCategoryAutoControlled("Bloom")), presetActive, function()
            Check("Override###Bloom", "bloomEnabled", "Enable bloom overrides")
            ImGui.SameLine()
            DualToggle("bloomGlobeEnabled", "bloomCarEnabled")
            CategoryResetButton("Bloom")
            if settings.bloomCarEnabled then
                Slider(IconGlyphs.TimerOutline, "Vehicle FPP bloom transition duration", "bloomVehicleFPPTransitionDuration", 0.0, 5.0)
            end
            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()
            ToggleSlider(IconGlyphs.Palette, "Bloom strength (color scale)", "bloomColorScaleEnabled", "bloomColorScale", 0.0, 1.0)
            ToggleSlider(IconGlyphs.ArrowExpandHorizontal, "Bloom size", "bloomSizeEnabled", "bloomSize", 0.55, 2.0)
            ToggleSlider(IconGlyphs.ArrowSplitVertical, "Bloom anamorphic", "bloomAnamorphicEnabled", "bloomAnamorphic", -0.99, 0.99)
            ToggleSlider(IconGlyphs.Brightness6, "Luminance threshold max", "luminanceThresholdMaxEnabled", "luminanceThresholdMax", 0.0, 40.0)
            ToggleSlider(IconGlyphs.Checkerboard, "Scene color blend", "sceneColorScaleEnabled", "sceneColorScale", 0.0, 1.0)
        end)

        drawCategory(CategoryHeader("Chromatic Aberration", "chromaticAberrationEnabled", autoOn and isCategoryAutoControlled("Chromatic Aberration")), presetActive, function()
            Check("Override###ChromaticAberration", "chromaticAberrationEnabled", "Enable chromatic aberration overrides")
            ImGui.SameLine()
            DualToggle("chromaticAberrationGlobeEnabled", "chromaticAberrationCarEnabled")
            CategoryResetButton("Chromatic Aberration")
            if settings.chromaticAberrationCarEnabled then
                Slider(IconGlyphs.TimerOutline, "Vehicle FPP transition duration", "chromaticAberrationTransitionDuration", 0.0, 5.0)
            end
            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()
            ToggleSlider(IconGlyphs.Exponent, "Exponent", "caExpEnabled", "caExp", 0.01, 10.0)
            ToggleSlider(IconGlyphs.FormatHorizontalAlignCenter, "Margin", "caMarginEnabled", "caMargin", 0.0, 1.0)
            ToggleSlider(IconGlyphs.ArrowExpandHorizontal, "Size X", "caSizeXEnabled", "caSizeX", 0.0, 20.0)
            ToggleSlider(IconGlyphs.ArrowExpandVertical, "Size Y", "caSizeYEnabled", "caSizeY", 0.0, 20.0)
            ToggleSlider(IconGlyphs.BlurRadial, "Subpixel dispersal", "caSubpixelDispersalEnabled", "caSubpixelDispersal", 0.0, 1.0)
        end)

        drawCategory(CategoryHeader("Color Grading", "colorGradingEnabled", autoOn and isCategoryAutoControlled("Color Grading")), presetActive, function()
            Check("Override###ColorGrading", "colorGradingEnabled", "Enable color grading overrides")
            ImGui.SameLine()
            DualToggle("colorGradingGlobeEnabled", "colorGradingCarEnabled")
            CategoryResetButton("Color Grading")
            if settings.colorGradingCarEnabled then
                Slider(IconGlyphs.TimerOutline, "Vehicle FPP transition duration", "colorGradingTransitionDuration", 0.0, 5.0)
            end
            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()
            ToggleSlider(IconGlyphs.Brightness6, "Brightness", "colorGradingBrightnessEnabled", "colorGradingBrightness", 0.0, 2.0)
            ToggleSlider(IconGlyphs.ContrastBox, "Contrast", "colorGradingContrastEnabled", "colorGradingContrast", 0.0, 2.0)
            ToggleSlider(IconGlyphs.ChartBellCurveCumulative, "Contrast pivot", "colorGradingContrastPivotEnabled", "colorGradingContrastPivot", 0.0, 1.0)
            ToggleSlider(IconGlyphs.Palette, "Saturation", "colorGradingSaturationEnabled", "colorGradingSaturation", 0.0, 2.0)
        end)

        drawCategory(CategoryHeader("Exposure Adaptation", "exposureAdaptSpeedEnabled", autoOn and isCategoryAutoControlled("Exposure Adaptation")), presetActive, function()
            Check("Override###ExposureAdaptation", "exposureAdaptSpeedEnabled", "Enable adaptation speed overrides")
            ImGui.SameLine()
            DualToggle("exposureAdaptGlobeEnabled", "exposureAdaptCarEnabled")
            CategoryResetButton("Exposure Adaptation")
            ToggleSlider(IconGlyphs.SpeedometerSlow, "Adaptation speed down", "exposureAdaptSpeedDownEnabled", "exposureAdaptSpeedDownValue", 1.0, 30.0)
            ToggleSlider(IconGlyphs.Speedometer, "Adaptation speed up", "exposureAdaptSpeedUpEnabled", "exposureAdaptSpeedUpValue", 1.0, 30.0)
        end)

        drawCategory(CategoryHeader("Exposure", "exposureOverrideEnabled", autoOn and isCategoryAutoControlled("Exposure")), presetActive, function()
            Check("Override###ExposureOverrides", "exposureOverrideEnabled", "Enable exposure offset overrides")
            ImGui.SameLine()
            DualToggle("exposureOverrideGlobeEnabled", "exposureOverrideCarEnabled")
            ImGui.SameLine()
            Check(IconGlyphs.CarWrench .. "##exposureFPPVehicleFix", "exposureFPPVehicleFix", "Vehicle Exposure Fix\nFixes auto-exposure metering in first-person vehicles")
            CategoryResetButton("Exposure")
            if settings.exposureOverrideCarEnabled then
                Slider(IconGlyphs.TimerOutline, "Vehicle FPP enter transition duration", "exposureVehicleFPPEnterDuration", 0.0, 1.0)
            end
            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()
            ToggleSlider(IconGlyphs.ArrowDownBoldBox, "Highlight reduction amount (exposure max offset)", "exposureMaxOffsetEnabled", "exposureMaxOffset", 0.0, 10.0)
            ToggleSlider(IconGlyphs.ArrowUpBoldBoxOutline, "Shadow boost amount (exposure min offset)", "exposureMinOffsetEnabled", "exposureMinOffset", 0.0, 5.0)
        end)

        drawCategory(CategoryHeader("Film Grain", "filmGrainEnabled", autoOn and isCategoryAutoControlled("Film Grain")), presetActive, function()
            -- Header row
            Check("Override###FilmGrain", "filmGrainEnabled", "Enable film grain overrides")
            ImGui.SameLine()
            -- Globe toggle
            local globeVal, globeChanged = ImGui.Checkbox(IconGlyphs.Earth .. "##filmGrainGlobeEnabled", settings.filmGrainGlobeEnabled)
            if globeChanged then save("filmGrainGlobeEnabled", globeVal) end
            tooltip("Apply globally (normal gameplay)\nRight-click to reset")
            if ImGui.IsItemClicked(1) then resetKey("filmGrainGlobeEnabled") end
            ImGui.SameLine()
            -- Scanner toggle
            local scannerVal, scannerChanged = ImGui.Checkbox(IconGlyphs.Radar .. "##filmGrainScannerEnabled", settings.filmGrainScannerEnabled)
            if scannerChanged then save("filmGrainScannerEnabled", scannerVal) end
            tooltip("Apply scanner-specific values during scan mode\nRight-click to reset")
            if ImGui.IsItemClicked(1) then resetKey("filmGrainScannerEnabled") end
            CategoryResetButton("Film Grain")

            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()

            -- Film Grain Fix dependency warning
            if settings.filmGrainEnabled then
                local COPY_HOLD = 2.5
                local COPY_FADE = 0.5
                local COPY_TOTAL = COPY_HOLD + COPY_FADE
                local warnText = "Requires Film Grain Fix mod to function"
                local warnAlpha = 1.0
                local warnTextColor = {0.6, 0.6, 0.6}
                if filmGrainLinkCopiedAt then
                    local elapsed = os.clock() - filmGrainLinkCopiedAt
                    if elapsed < COPY_HOLD then
                        warnText = "Link copied to clipboard..."
                        warnAlpha = 1.0
                        warnTextColor = {0.0, 1.0, 0.7}
                    elseif elapsed < COPY_TOTAL then
                        warnText = "Link copied to clipboard..."
                        warnAlpha = 1.0 - (elapsed - COPY_HOLD) / COPY_FADE
                        warnTextColor = {0.0, 1.0, 0.7}
                    else
                        filmGrainLinkCopiedAt = nil
                    end
                end
                renderWarning("AlertBox", {1.0, 0.7, 0.0, 1.0},
                    warnText,
                    "Film grain is broken in vanilla Cyberpunk 2077.\nInstall 'Film Grain Fix' by MisterChedda to use these overrides.\n\n(Click to copy Nexus modpage link)",
                    function()
                        ImGui.SetClipboardText("https://www.nexusmods.com/cyberpunk2077/mods/32899")
                        filmGrainLinkCopiedAt = os.clock()
                    end,
                    warnAlpha,
                    warnTextColor)
            end

            -- Apply After Upsampling
            IconButton(IconGlyphs.ArrowUpBoldBox)
            tooltip("Apply film grain after upsampling\nRight-click to reset")
            if ImGui.IsItemClicked(1) then resetKey("filmGrainApplyAfterUpsampling") end
            ImGui.SameLine()
            local aauVal, aauChanged = ImGui.Checkbox("Apply After Upsampling##filmGrainApplyAfterUpsampling", settings.filmGrainApplyAfterUpsampling)
            if aauChanged then save("filmGrainApplyAfterUpsampling", aauVal) end
            tooltip("Apply film grain after upsampling\nRight-click to reset")
            if ImGui.IsItemClicked(1) then resetKey("filmGrainApplyAfterUpsampling") end

            -- ===== GLOBAL SECTION =====
            if settings.filmGrainGlobeEnabled then
                ImGui.Spacing()
                ImGui.Separator()
                ImGui.Spacing()
                ImGui.Text("Global")
                ImGui.Spacing()

                -- Gang sliders toggle
                IconButton(IconGlyphs.FormatHorizontalAlignCenter)
                tooltip("Group sliders - control all grain size values together\nRight-click to reset")
                if ImGui.IsItemClicked(1) then resetKey("filmGrainGangSliders") end
                ImGui.SameLine()
                local gangVal, gangChanged = ImGui.Checkbox("Group Sliders##filmGrainGangSliders", settings.filmGrainGangSliders)
                if gangChanged then
                    settings.filmGrainGangSliders = gangVal
                    savePending = true
                    saveSettings()
                end
                tooltip("Group sliders - control all values together\nRight-click to reset")
                if ImGui.IsItemClicked(1) then resetKey("filmGrainGangSliders") end

                ImGui.Spacing()

                if settings.filmGrainGangSliders then
                    -- Ganged size: X drives Y and Z
                    local sizeGang = settings.filmGrainGrainSizeX
                    IconButton(IconGlyphs.Grain)
                    tooltip("Grain size (all channels)\nRight-click to reset")
                    if ImGui.IsItemClicked(1) then
                        settings.filmGrainGrainSizeX = defaults.filmGrainGrainSizeX
                        settings.filmGrainGrainSizeY = defaults.filmGrainGrainSizeY
                        settings.filmGrainGrainSizeZ = defaults.filmGrainGrainSizeZ
                        pushToService("filmGrainGrainSizeX", defaults.filmGrainGrainSizeX)
                        pushToService("filmGrainGrainSizeY", defaults.filmGrainGrainSizeY)
                        pushToService("filmGrainGrainSizeZ", defaults.filmGrainGrainSizeZ)
                        saveSettings()
                    end
                    ImGui.SameLine()
                    ImGui.SetNextItemWidth(-1)
                    local sv, sc = ImGui.SliderFloat("##filmGrainSizeGang", sizeGang, 0.0, 2.0)
                    if sc then
                        settings.filmGrainGrainSizeX = sv
                        settings.filmGrainGrainSizeY = sv
                        settings.filmGrainGrainSizeZ = sv
                        pushToService("filmGrainGrainSizeX", sv)
                        pushToService("filmGrainGrainSizeY", sv)
                        pushToService("filmGrainGrainSizeZ", sv)
                        savePending = true
                    end
                    if ImGui.IsItemDeactivatedAfterEdit() then saveSettings() end
                    if ImGui.IsItemClicked(1) then
                        settings.filmGrainGrainSizeX = defaults.filmGrainGrainSizeX
                        settings.filmGrainGrainSizeY = defaults.filmGrainGrainSizeY
                        settings.filmGrainGrainSizeZ = defaults.filmGrainGrainSizeZ
                        pushToService("filmGrainGrainSizeX", defaults.filmGrainGrainSizeX)
                        pushToService("filmGrainGrainSizeY", defaults.filmGrainGrainSizeY)
                        pushToService("filmGrainGrainSizeZ", defaults.filmGrainGrainSizeZ)
                        saveSettings()
                    end

                    -- Ganged strength: X drives Y, Z, W
                    local strGang = settings.filmGrainStrengthX
                    IconButton(IconGlyphs.Blur)
                    tooltip("Grain strength (all channels)\nRight-click to reset")
                    if ImGui.IsItemClicked(1) then
                        settings.filmGrainStrengthX = defaults.filmGrainStrengthX
                        settings.filmGrainStrengthY = defaults.filmGrainStrengthY
                        settings.filmGrainStrengthZ = defaults.filmGrainStrengthZ
                        settings.filmGrainStrengthW = defaults.filmGrainStrengthW
                        pushToService("filmGrainStrengthX", defaults.filmGrainStrengthX)
                        pushToService("filmGrainStrengthY", defaults.filmGrainStrengthY)
                        pushToService("filmGrainStrengthZ", defaults.filmGrainStrengthZ)
                        pushToService("filmGrainStrengthW", defaults.filmGrainStrengthW)
                        saveSettings()
                    end
                    ImGui.SameLine()
                    ImGui.SetNextItemWidth(-1)
                    local stv, stc = ImGui.SliderFloat("##filmGrainStrengthGang", strGang, 0.0, 2.0)
                    if stc then
                        settings.filmGrainStrengthX = stv
                        settings.filmGrainStrengthY = stv
                        settings.filmGrainStrengthZ = stv
                        settings.filmGrainStrengthW = stv
                        pushToService("filmGrainStrengthX", stv)
                        pushToService("filmGrainStrengthY", stv)
                        pushToService("filmGrainStrengthZ", stv)
                        pushToService("filmGrainStrengthW", stv)
                        savePending = true
                    end
                    if ImGui.IsItemDeactivatedAfterEdit() then saveSettings() end
                    if ImGui.IsItemClicked(1) then
                        settings.filmGrainStrengthX = defaults.filmGrainStrengthX
                        settings.filmGrainStrengthY = defaults.filmGrainStrengthY
                        settings.filmGrainStrengthZ = defaults.filmGrainStrengthZ
                        settings.filmGrainStrengthW = defaults.filmGrainStrengthW
                        pushToService("filmGrainStrengthX", defaults.filmGrainStrengthX)
                        pushToService("filmGrainStrengthY", defaults.filmGrainStrengthY)
                        pushToService("filmGrainStrengthZ", defaults.filmGrainStrengthZ)
                        pushToService("filmGrainStrengthW", defaults.filmGrainStrengthW)
                        saveSettings()
                    end
                else
                    Slider(IconGlyphs.Grain, "Grain size X (luma)", "filmGrainGrainSizeX", 0.0, 2.0)
                    Slider(IconGlyphs.Grain, "Grain size Y (chroma R)", "filmGrainGrainSizeY", 0.0, 2.0)
                    Slider(IconGlyphs.Grain, "Grain size Z (chroma B)", "filmGrainGrainSizeZ", 0.0, 2.0)
                    Slider(IconGlyphs.Blur, "Strength X (luma)", "filmGrainStrengthX", 0.0, 2.0)
                    Slider(IconGlyphs.Blur, "Strength Y (chroma R)", "filmGrainStrengthY", 0.0, 2.0)
                    Slider(IconGlyphs.Blur, "Strength Z (chroma B)", "filmGrainStrengthZ", 0.0, 2.0)
                    Slider(IconGlyphs.Blur, "Strength W (temporal)", "filmGrainStrengthW", 0.0, 2.0)
                end
            end

            -- ===== SCANNER SECTION =====
            if settings.filmGrainScannerEnabled then
                ImGui.Spacing()
                ImGui.Separator()
                ImGui.Spacing()
                ImGui.Text("Scanner")
                ImGui.Spacing()

                -- Gang sliders toggle (scanner)
                IconButton(IconGlyphs.FormatHorizontalAlignCenter)
                tooltip("Group sliders - control all scanner grain size values together\nRight-click to reset")
                if ImGui.IsItemClicked(1) then resetKey("filmGrainGangSlidersScanner") end
                ImGui.SameLine()
                local gangSVal, gangSChanged = ImGui.Checkbox("Group Sliders##filmGrainGangSlidersScanner", settings.filmGrainGangSlidersScanner)
                if gangSChanged then
                    settings.filmGrainGangSlidersScanner = gangSVal
                    savePending = true
                    saveSettings()
                end
                tooltip("Group sliders - control all values together\nRight-click to reset")
                if ImGui.IsItemClicked(1) then resetKey("filmGrainGangSlidersScanner") end

                ImGui.Spacing()

                if settings.filmGrainGangSlidersScanner then
                    -- Ganged scanner size
                    local sizeSGang = settings.filmGrainGrainSizeXScanner
                    IconButton(IconGlyphs.Grain)
                    tooltip("Grain size (all channels, scanner)\nRight-click to reset")
                    if ImGui.IsItemClicked(1) then
                        settings.filmGrainGrainSizeXScanner = defaults.filmGrainGrainSizeXScanner
                        settings.filmGrainGrainSizeYScanner = defaults.filmGrainGrainSizeYScanner
                        settings.filmGrainGrainSizeZScanner = defaults.filmGrainGrainSizeZScanner
                        pushToService("filmGrainGrainSizeXScanner", defaults.filmGrainGrainSizeXScanner)
                        pushToService("filmGrainGrainSizeYScanner", defaults.filmGrainGrainSizeYScanner)
                        pushToService("filmGrainGrainSizeZScanner", defaults.filmGrainGrainSizeZScanner)
                        saveSettings()
                    end
                    ImGui.SameLine()
                    ImGui.SetNextItemWidth(-1)
                    local ssv, ssc = ImGui.SliderFloat("##filmGrainSizeGangScanner", sizeSGang, 0.0, 2.0)
                    if ssc then
                        settings.filmGrainGrainSizeXScanner = ssv
                        settings.filmGrainGrainSizeYScanner = ssv
                        settings.filmGrainGrainSizeZScanner = ssv
                        pushToService("filmGrainGrainSizeXScanner", ssv)
                        pushToService("filmGrainGrainSizeYScanner", ssv)
                        pushToService("filmGrainGrainSizeZScanner", ssv)
                        savePending = true
                    end
                    if ImGui.IsItemDeactivatedAfterEdit() then saveSettings() end
                    if ImGui.IsItemClicked(1) then
                        settings.filmGrainGrainSizeXScanner = defaults.filmGrainGrainSizeXScanner
                        settings.filmGrainGrainSizeYScanner = defaults.filmGrainGrainSizeYScanner
                        settings.filmGrainGrainSizeZScanner = defaults.filmGrainGrainSizeZScanner
                        pushToService("filmGrainGrainSizeXScanner", defaults.filmGrainGrainSizeXScanner)
                        pushToService("filmGrainGrainSizeYScanner", defaults.filmGrainGrainSizeYScanner)
                        pushToService("filmGrainGrainSizeZScanner", defaults.filmGrainGrainSizeZScanner)
                        saveSettings()
                    end

                    -- Ganged scanner strength
                    local strSGang = settings.filmGrainStrengthXScanner
                    IconButton(IconGlyphs.Blur)
                    tooltip("Grain strength (all channels, scanner)\nRight-click to reset")
                    if ImGui.IsItemClicked(1) then
                        settings.filmGrainStrengthXScanner = defaults.filmGrainStrengthXScanner
                        settings.filmGrainStrengthYScanner = defaults.filmGrainStrengthYScanner
                        settings.filmGrainStrengthZScanner = defaults.filmGrainStrengthZScanner
                        settings.filmGrainStrengthWScanner = defaults.filmGrainStrengthWScanner
                        pushToService("filmGrainStrengthXScanner", defaults.filmGrainStrengthXScanner)
                        pushToService("filmGrainStrengthYScanner", defaults.filmGrainStrengthYScanner)
                        pushToService("filmGrainStrengthZScanner", defaults.filmGrainStrengthZScanner)
                        pushToService("filmGrainStrengthWScanner", defaults.filmGrainStrengthWScanner)
                        saveSettings()
                    end
                    ImGui.SameLine()
                    ImGui.SetNextItemWidth(-1)
                    local sstv, sstc = ImGui.SliderFloat("##filmGrainStrengthGangScanner", strSGang, 0.0, 2.0)
                    if sstc then
                        settings.filmGrainStrengthXScanner = sstv
                        settings.filmGrainStrengthYScanner = sstv
                        settings.filmGrainStrengthZScanner = sstv
                        settings.filmGrainStrengthWScanner = sstv
                        pushToService("filmGrainStrengthXScanner", sstv)
                        pushToService("filmGrainStrengthYScanner", sstv)
                        pushToService("filmGrainStrengthZScanner", sstv)
                        pushToService("filmGrainStrengthWScanner", sstv)
                        savePending = true
                    end
                    if ImGui.IsItemDeactivatedAfterEdit() then saveSettings() end
                    if ImGui.IsItemClicked(1) then
                        settings.filmGrainStrengthXScanner = defaults.filmGrainStrengthXScanner
                        settings.filmGrainStrengthYScanner = defaults.filmGrainStrengthYScanner
                        settings.filmGrainStrengthZScanner = defaults.filmGrainStrengthZScanner
                        settings.filmGrainStrengthWScanner = defaults.filmGrainStrengthWScanner
                        pushToService("filmGrainStrengthXScanner", defaults.filmGrainStrengthXScanner)
                        pushToService("filmGrainStrengthYScanner", defaults.filmGrainStrengthYScanner)
                        pushToService("filmGrainStrengthZScanner", defaults.filmGrainStrengthZScanner)
                        pushToService("filmGrainStrengthWScanner", defaults.filmGrainStrengthWScanner)
                        saveSettings()
                    end
                else
                    Slider(IconGlyphs.Grain, "Grain size X (scanner)", "filmGrainGrainSizeXScanner", 0.0, 2.0)
                    Slider(IconGlyphs.Grain, "Grain size Y (scanner)", "filmGrainGrainSizeYScanner", 0.0, 2.0)
                    Slider(IconGlyphs.Grain, "Grain size Z (scanner)", "filmGrainGrainSizeZScanner", 0.0, 2.0)
                    Slider(IconGlyphs.Blur, "Strength X (scanner luma)", "filmGrainStrengthXScanner", 0.0, 2.0)
                    Slider(IconGlyphs.Blur, "Strength Y (scanner chroma R)", "filmGrainStrengthYScanner", 0.0, 2.0)
                    Slider(IconGlyphs.Blur, "Strength Z (scanner chroma B)", "filmGrainStrengthZScanner", 0.0, 2.0)
                    Slider(IconGlyphs.Blur, "Strength W (scanner temporal)", "filmGrainStrengthWScanner", 0.0, 2.0)
                end
            end
        end)

        drawCategory(CategoryHeader("Lens Flare", "lensFlareEnabled", autoOn and isCategoryAutoControlled("Lens Flare")), presetActive, function()
            Check("Override###LensFlare", "lensFlareEnabled", "Enable lens flare overrides")
            ImGui.SameLine()
            DualToggle("lensFlareGlobeEnabled", "lensFlareCarEnabled")
            CategoryResetButton("Lens Flare")
            if settings.lensFlareCarEnabled then
                Slider(IconGlyphs.TimerOutline, "Vehicle FPP transition duration", "lensFlareTransitionDuration", 0.0, 5.0)
            end
            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()
            ToggleSlider(IconGlyphs.Palette, "Chromatic effect", "lensFlareChromaticEffectEnabled", "lensFlareChromaticEffect", 0.0, 1.0)
            ToggleSlider(IconGlyphs.CircleExpand, "Halo width", "lensFlareHaloWidthEnabled", "lensFlareHaloWidth", 0.0, 1.0)
            ToggleSlider(IconGlyphs.CircleSlice8, "Saturation", "lensFlareSaturationValueEnabled", "lensFlareSaturationValue", 0.0, 2.0)
            ToggleSlider(IconGlyphs.ArrowExpandAll, "Scale", "lensFlareScaleValueEnabled", "lensFlareScaleValue", 0.0, 1.0)
        end)

        drawCategory(CategoryHeader("Vignette", "vignetteEnabled", autoOn and isCategoryAutoControlled("Vignette")), presetActive, function()
            Check("Override###Vignette", "vignetteEnabled", "Enable vignette overrides")
            ImGui.SameLine()
            DualToggle("vignetteGlobeEnabled", "vignetteCarEnabled")
            CategoryResetButton("Vignette")
            if settings.vignetteCarEnabled then
                Slider(IconGlyphs.TimerOutline, "Vehicle FPP transition duration", "vignetteTransitionDuration", 0.0, 5.0)
            end
            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()
            ToggleSlider(IconGlyphs.CircleSlice8, "Vignette exponent", "vignetteExpEnabled", "vignetteExp", 0.0, 20.0)
            ToggleColorPicker(IconGlyphs.Palette, "Vignette color", "vignetteColorEnabled", "vignetteColorRed", "vignetteColorGreen", "vignetteColorBlue")
        end)

        drawCategory(CategoryHeader("Volumetric Fog", "volFogEnabled", autoOn and isCategoryAutoControlled("Volumetric Fog")), presetActive, function()
            Check("Override###VolumetricFog", "volFogEnabled", "Enable volumetric fog overrides")
            ImGui.SameLine()
            DualToggle("volFogGlobeEnabled", "volFogCarEnabled")
            CategoryResetButton("Volumetric Fog")
            if settings.volFogCarEnabled then
                Slider(IconGlyphs.TimerOutline, "Vehicle FPP fog transition duration", "volFogTransitionDuration", 0.0, 5.0)
            end
            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()
            ToggleSlider(IconGlyphs.WeatherFog, "Fog absorption", "volFogAbsorptionEnabled", "volFogAbsorption", 0.0, 1.0)
            ToggleSlider(IconGlyphs.Blur, "Fog density", "volFogDensityEnabled", "volFogDensity", 0.0, 0.1, "%.4f")
            ToggleSlider(IconGlyphs.Brightness6, "Local light scale", "volFogLocalLightScaleEnabled", "volFogLocalLightScale", 0.0, 5.0)
            ToggleSlider(IconGlyphs.Brightness4, "Local ambient scale", "volFogLocalAmbientScaleEnabled", "volFogLocalAmbientScale", 0.0, 5.0)
        end)

    ImGui.EndChild()
    ImGui.PopStyleColor()

    if conflictDetected then ImGui.EndDisabled() end

    drawResetModal()
    drawEnvTunerWarningModal()

    updateWindowUtils()
    ImGui.End()
end

registerForEvent("onInit", function()
    service = Game.GetScriptableServiceContainer():GetService("NovaOptics")
    if not service then
        print("[NovaOptics] Failed to get NovaOptics service")
    end

    WindowUtils = GetMod("WindowUtils")

    if service ~= nil and service:IsConflictDetected() then
        warningDetected = true
        print("[NovaOptics] ENVTuner detected: warning will be shown on enable")
    end

    local envTunerLiteService = Game.GetScriptableServiceContainer():GetService("ENVTunerLite")
    if envTunerLiteService ~= nil then
        conflictDetected = true
        conflictModName = "ENVTunerLite"
        warningDetected = false
        print("[NovaOptics] Conflict detected: ENVTunerLite is loaded")
    end

    loadSettings()

    if state.modVersion ~= MOD_VERSION then
        state.modVersion = MOD_VERSION
        state.envTunerWarningAcknowledged = false
        saveSettings()
    end

    if state.envTunerWarningAcknowledged then
        warningDismissed = true
    end

    if conflictDetected and service ~= nil then
        service:SetEnable(false)
    end

    if state.activePreset ~= "" and presets[state.activePreset] then
        activePreset = state.activePreset
    else
        activePreset = nil
    end

    pushAllToService()

    ObserveAfter("PlayerPuppet", "OnGameAttached", function()
        if not pushEnabled() then return end
        service:TransitionVehicleState(0)
        pushAllToService()
        service:RegisterVehicleStateListener()
        local player = Game.GetPlayer()
        if not player then return end
        local vehicle = Game.GetMountedVehicle(player)
        if vehicle and not vehicle:IsA("vehicleBikeBaseObject") then
            service:TransitionVehicleState(1)
        end
    end)

    Observe("RadialWheelController", "OnIsInMenuChanged", function(_, isInMenu)
        if type(isInMenu) ~= "boolean" then isInMenu = _ end
        local service = Game.GetScriptableServiceContainer():GetService("NovaOptics")
        if not service then return end
        service:SetMenuState(isInMenu)
    end)

    -- Scanner state is driven from Redscript via wrapMethod(PlayerVisionModeController)
end)

registerForEvent("onDraw", function()
    if not cetOpen then return end
    drawWindow()
end)

registerForEvent("onOverlayOpen", function()
    cetOpen = true
end)

registerForEvent("onOverlayClose", function()
    cetOpen = false
    if savePending then saveSettings() end
end)

registerForEvent("onUpdate", function()
    checkAutoSwitch()
end)
