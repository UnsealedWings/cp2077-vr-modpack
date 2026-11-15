// Nova Optics - Vehicle-aware environment parameter overrides for Cyberpunk 2077

struct ExposureOriginals {
    let setting: ref<ExposureAreaSettings>;
    let minPoints: array<CurvePointFloat>;
    let maxPoints: array<CurvePointFloat>;
    let adaptSpeedDownPoints: array<CurvePointFloat>;
    let adaptSpeedUpPoints: array<CurvePointFloat>;
    let centerImportancePoints: array<CurvePointFloat>;
    let thresholdHighPoints: array<CurvePointFloat>;
    let thresholdLowPoints: array<CurvePointFloat>;
}

struct VignetteOriginals {
    let setting: ref<VignetteAreaSettings>;
    let enabled: Bool;
    let exp: Float;
    let colorRed: Uint8;
    let colorGreen: Uint8;
    let colorBlue: Uint8;
    let colorAlpha: Uint8;
}

struct BloomOriginals {
    let setting: ref<BloomAreaSettings>;
    let colorScale: Float;
    let blurSizeX: Float;
    let blurSizeY: Float;
    let luminanceThresholdMin: Float;
    let luminanceThresholdMax: Float;
    let sceneColorScale: Float;
}

struct LensFlareOriginals {
    let setting: ref<ImageBasedFlareAreaSettings>;
    let curve: Float;
    let dispersal: Float;
    let distortion: Float;
    let haloWidth: Float;
    let threshold: Float;
    let saturationPoints: array<CurvePointFloat>;
    let scalePoints: array<CurvePointFloat>;
}

struct ChromaticAberrationOriginals {
    let setting: ref<ChromaticAberrationAreaSettings>;
    let enable: Bool;
    let exp: Float;
    let margin: Float;
    let sizeX: Float;
    let sizeY: Float;
    let subpixelDispersal: Float;
}

struct VolumetricFogOriginals {
    let setting: ref<VolumetricFogAreaSettings>;
    let absorptionPoints: array<CurvePointFloat>;
    let densityPoints: array<CurvePointFloat>;
    let localLightScalePoints: array<CurvePointFloat>;
    let localAmbientScalePoints: array<CurvePointFloat>;
    let groundIrradiancePoints: array<CurvePointFloat>;
}

struct ColorGradingOriginals {
    let setting: ref<ColorGradingAreaSettings>;
    let brightness: Float;
    let contrast: Float;
    let contrastPivot: Float;
    let saturation: Float;
}

struct FilmGrainOriginals {
    let setting: ref<FilmGrainAreaSettings>;
    let enabled: Bool;
    let applyAfterUpsampling: Bool;
    let grainSizeX: Float;
    let grainSizeY: Float;
    let grainSizeZ: Float;
    let strengthPoints: array<CurvePointVector4>;
}

public class NovaOptics extends ScriptableService 
{
    public let enable: Bool = false;
    
    // Exposure Override Settings
    public let exposureOverrideEnabled: Bool = false;
    public let exposureOverrideGlobeEnabled: Bool = true;
    public let exposureOverrideCarEnabled: Bool = false;
    public let exposureVehicleFPPEnterDuration: Float = 0.3;
    public let exposureFPPVehicleFix: Bool = true;
    public let exposureMinOffset: Float = 0.0;
    public let exposureMinOffsetEnabled: Bool = true;
    public let exposureMinOffsetVehicle: Float = 0.0;
    public let exposureMinOffsetVehicleExplicit: Bool = false;
    public let exposureMaxOffset: Float = 0.0;
    public let exposureMaxOffsetEnabled: Bool = true;
    public let exposureMaxOffsetVehicle: Float = 0.0;
    public let exposureMaxOffsetVehicleExplicit: Bool = false;
    
    // Exposure Adaptation Settings
    public let exposureAdaptGlobeEnabled: Bool = true;
    public let exposureAdaptCarEnabled: Bool = false;
    public let exposureAdaptSpeedEnabled: Bool = false;
    public let exposureAdaptSpeedDownValue: Float = 3.0;
    public let exposureAdaptSpeedDownEnabled: Bool = true;
    public let exposureAdaptSpeedDownValueVehicle: Float = 3.0;
    public let exposureAdaptSpeedDownValueVehicleExplicit: Bool = false;
    public let exposureAdaptSpeedUpValue: Float = 1.0;
    public let exposureAdaptSpeedUpEnabled: Bool = true;
    public let exposureAdaptSpeedUpValueVehicle: Float = 1.0;
    public let exposureAdaptSpeedUpValueVehicleExplicit: Bool = false;
    
    // Vignette Settings
    public let vignetteEnabled: Bool = false;
    public let vignetteGlobeEnabled: Bool = true;
    public let vignetteCarEnabled: Bool = false;
    public let vignetteTransitionDuration: Float = 1.0;
    public let vignetteExp: Float = 2.0;
    public let vignetteExpEnabled: Bool = true;
    public let vignetteExpVehicle: Float = 2.0;
    public let vignetteExpVehicleExplicit: Bool = false;
    public let vignetteColorEnabled: Bool = false;
    public let vignetteColorRed: Int32 = 0;
    public let vignetteColorRedVehicle: Int32 = 0;
    public let vignetteColorRedVehicleExplicit: Bool = false;
    public let vignetteColorGreen: Int32 = 0;
    public let vignetteColorGreenVehicle: Int32 = 0;
    public let vignetteColorGreenVehicleExplicit: Bool = false;
    public let vignetteColorBlue: Int32 = 0;
    public let vignetteColorBlueVehicle: Int32 = 0;
    public let vignetteColorBlueVehicleExplicit: Bool = false;
    public let vignetteColorAlpha: Int32 = 255;
    public let vignetteColorAlphaVehicle: Int32 = 255;
    public let vignetteColorAlphaVehicleExplicit: Bool = false;
    
    // Bloom Settings
    public let bloomGlobeEnabled: Bool = true;
    public let bloomCarEnabled: Bool = false;
    public let bloomVehicleFPPTransitionDuration: Float = 1.0;
    public let bloomEnabled: Bool = false;
    public let bloomColorScale: Float = 0.15;
    public let bloomColorScaleEnabled: Bool = true;
    public let bloomColorScaleVehicle: Float = 0.15;
    public let bloomColorScaleVehicleExplicit: Bool = false;
    public let bloomSize: Float = 0.675;
    public let bloomSizeEnabled: Bool = true;
    public let bloomSizeVehicle: Float = 0.675;
    public let bloomSizeVehicleExplicit: Bool = false;
    public let bloomAnamorphic: Float = 0.0;
    public let bloomAnamorphicEnabled: Bool = true;
    public let bloomAnamorphicVehicle: Float = 0.0;
    public let bloomAnamorphicVehicleExplicit: Bool = false;
    public let luminanceThresholdMax: Float = 10.0;
    public let luminanceThresholdMaxEnabled: Bool = true;
    public let luminanceThresholdMaxVehicle: Float = 10.0;
    public let luminanceThresholdMaxVehicleExplicit: Bool = false;
    public let sceneColorScale: Float = 0.8;
    public let sceneColorScaleEnabled: Bool = true;
    public let sceneColorScaleVehicle: Float = 0.8;
    public let sceneColorScaleVehicleExplicit: Bool = false;
    
    // Calculated bloom properties (derived from simplified sliders)
    private let blurSizeX: Float = 0.675;
    private let blurSizeY: Float = 0.56;
    private let luminanceThresholdMin: Float = 0.0;

    // Lens Flare Settings
    public let lensFlareEnabled: Bool = false;
    public let lensFlareGlobeEnabled: Bool = true;
    public let lensFlareCarEnabled: Bool = false;
    public let lensFlareTransitionDuration: Float = 1.0;
    public let lensFlareChromaticEffect: Float = 0.45;
    public let lensFlareChromaticEffectEnabled: Bool = true;
    public let lensFlareChromaticEffectVehicle: Float = 0.45;
    public let lensFlareChromaticEffectVehicleExplicit: Bool = false;
    public let lensFlareHaloWidth: Float = 0.56;
    public let lensFlareHaloWidthEnabled: Bool = true;
    public let lensFlareHaloWidthVehicle: Float = 0.56;
    public let lensFlareHaloWidthVehicleExplicit: Bool = false;
    public let lensFlareSaturationValue: Float = 1.1;
    public let lensFlareSaturationValueEnabled: Bool = true;
    public let lensFlareSaturationValueVehicle: Float = 1.1;
    public let lensFlareSaturationValueVehicleExplicit: Bool = false;
    public let lensFlareScaleValue: Float = 0.45;
    public let lensFlareScaleValueEnabled: Bool = true;
    public let lensFlareScaleValueVehicle: Float = 0.45;
    public let lensFlareScaleValueVehicleExplicit: Bool = false;
    
    // Calculated lens flare properties (derived from simplified sliders)
    private let lensFlareCurve: Float = 1.0;
    private let lensFlareDispersal: Float = 0.300000012;
    private let lensFlareDistortion: Float = 1.596452;
    private let lensFlareThreshold: Float = 0.0;

    // Chromatic Aberration Settings
    public let chromaticAberrationEnabled: Bool = false;
    public let chromaticAberrationGlobeEnabled: Bool = true;
    public let chromaticAberrationCarEnabled: Bool = false;
    public let chromaticAberrationTransitionDuration: Float = 1.0;
    public let caExp: Float = 6.0;
    public let caExpEnabled: Bool = true;
    public let caExpVehicle: Float = 6.0;
    public let caExpVehicleExplicit: Bool = false;
    public let caMargin: Float = 0.25;
    public let caMarginEnabled: Bool = true;
    public let caMarginVehicle: Float = 0.25;
    public let caMarginVehicleExplicit: Bool = false;
    public let caSizeX: Float = 0.8;
    public let caSizeXEnabled: Bool = true;
    public let caSizeXVehicle: Float = 0.8;
    public let caSizeXVehicleExplicit: Bool = false;
    public let caSizeY: Float = 0.4;
    public let caSizeYEnabled: Bool = true;
    public let caSizeYVehicle: Float = 0.4;
    public let caSizeYVehicleExplicit: Bool = false;
    public let caSubpixelDispersal: Float = 0.0;
    public let caSubpixelDispersalEnabled: Bool = true;
    public let caSubpixelDispersalVehicle: Float = 0.0;
    public let caSubpixelDispersalVehicleExplicit: Bool = false;

    // Volumetric Fog Settings
    public let volFogEnabled: Bool;
    public let volFogGlobeEnabled: Bool = true;
    public let volFogCarEnabled: Bool = false;
    public let volFogTransitionDuration: Float = 1.0;
    public let volFogAbsorptionEnabled: Bool;
    public let volFogAbsorption: Float = 0.04;
    public let volFogAbsorptionVehicle: Float = 0.04;
    public let volFogAbsorptionVehicleExplicit: Bool = false;
    public let volFogDensityEnabled: Bool;
    public let volFogDensity: Float = 0.003;
    public let volFogDensityVehicle: Float = 0.003;
    public let volFogDensityVehicleExplicit: Bool = false;
    public let volFogLocalLightScaleEnabled: Bool;
    public let volFogLocalLightScale: Float = 1.0;
    public let volFogLocalLightScaleVehicle: Float = 1.0;
    public let volFogLocalLightScaleVehicleExplicit: Bool = false;
    public let volFogLocalAmbientScaleEnabled: Bool;
    public let volFogLocalAmbientScale: Float = 0.2;
    public let volFogLocalAmbientScaleVehicle: Float = 0.2;
    public let volFogLocalAmbientScaleVehicleExplicit: Bool = false;

    // Color Grading Settings
    public let colorGradingEnabled: Bool = false;
    public let colorGradingGlobeEnabled: Bool = true;
    public let colorGradingCarEnabled: Bool = false;
    public let colorGradingTransitionDuration: Float = 1.0;
    public let colorGradingBrightness: Float = 1.0;
    public let colorGradingBrightnessEnabled: Bool = true;
    public let colorGradingBrightnessVehicle: Float = 1.0;
    public let colorGradingBrightnessVehicleExplicit: Bool = false;
    public let colorGradingContrast: Float = 1.0;
    public let colorGradingContrastEnabled: Bool = true;
    public let colorGradingContrastVehicle: Float = 1.0;
    public let colorGradingContrastVehicleExplicit: Bool = false;
    public let colorGradingContrastPivot: Float = 0.5;
    public let colorGradingContrastPivotEnabled: Bool = true;
    public let colorGradingContrastPivotVehicle: Float = 0.5;
    public let colorGradingContrastPivotVehicleExplicit: Bool = false;
    public let colorGradingSaturation: Float = 1.0;
    public let colorGradingSaturationEnabled: Bool = true;
    public let colorGradingSaturationVehicle: Float = 1.0;
    public let colorGradingSaturationVehicleExplicit: Bool = false;

    // Film Grain Settings
    public let filmGrainEnabled: Bool = false;
    public let filmGrainGlobeEnabled: Bool = true;
    public let filmGrainApplyAfterUpsampling: Bool = true;
    public let filmGrainGrainSizeX: Float = 0.58;
    public let filmGrainGrainSizeY: Float = 0.62;
    public let filmGrainGrainSizeZ: Float = 0.65;
    public let filmGrainStrengthX: Float = 0.5;
    public let filmGrainStrengthY: Float = 0.56;
    public let filmGrainStrengthZ: Float = 0.65;
    public let filmGrainStrengthW: Float = 0.0;
    // scanner mode overrides
    public let filmGrainScannerEnabled: Bool = false;
    public let filmGrainGrainSizeXScanner: Float = 0.58;
    public let filmGrainGrainSizeYScanner: Float = 0.62;
    public let filmGrainGrainSizeZScanner: Float = 0.65;
    public let filmGrainStrengthXScanner: Float = 0.5;
    public let filmGrainStrengthYScanner: Float = 0.56;
    public let filmGrainStrengthZScanner: Float = 0.65;
    public let filmGrainStrengthWScanner: Float = 0.0;

    // Per-effect storage (index-aligned with keys arrays for ArrayFindFirst)
    private let exposureKeys: array<ref<ExposureAreaSettings>>;
    private let exposureData: array<ExposureOriginals>;
    private let vignetteKeys: array<ref<VignetteAreaSettings>>;
    private let vignetteData: array<VignetteOriginals>;
    private let bloomKeys: array<ref<BloomAreaSettings>>;
    private let bloomData: array<BloomOriginals>;
    private let lensFlareKeys: array<ref<ImageBasedFlareAreaSettings>>;
    private let lensFlareData: array<LensFlareOriginals>;
    private let chromaticAberrationKeys: array<ref<ChromaticAberrationAreaSettings>>;
    private let chromaticAberrationData: array<ChromaticAberrationOriginals>;
    private let volFogKeys: array<ref<VolumetricFogAreaSettings>>;
    private let volFogData: array<VolumetricFogOriginals>;
    private let colorGradingKeys: array<ref<ColorGradingAreaSettings>>;
    private let colorGradingData: array<ColorGradingOriginals>;
    private let filmGrainKeys: array<ref<FilmGrainAreaSettings>>;
    private let filmGrainData: array<FilmGrainOriginals>;

    // Interpolation state machine
    //   IDLE -> APPLYING -> ACTIVE -> RESTORING -> IDLE
    //   Mid-transition reversals invert progress (1.0 - t)
    private let interpState: array<Int32>;
    private let interpT: array<Float>;

    // Interpolation state constants
    private let INTERP_IDLE: Int32;
    private let INTERP_APPLYING: Int32;
    private let INTERP_ACTIVE: Int32;
    private let INTERP_RESTORING: Int32;

    // Category index constants
    private let CATEGORY_EXPOSURE: Int32;
    private let CATEGORY_ADAPT: Int32;
    private let CATEGORY_BLOOM: Int32;
    private let CATEGORY_VOLFOG: Int32;
    private let CATEGORY_VIGNETTE: Int32;
    private let CATEGORY_LENSFLARE: Int32;
    private let CATEGORY_CA: Int32;
    private let CATEGORY_COLORGRADING: Int32;
    private let CATEGORY_FILMGRAIN: Int32;

    // Metering fix target values
    private let METERING_CENTER_IMPORTANCE: Float;
    private let METERING_THRESHOLD_HIGH: Float;
    private let METERING_THRESHOLD_LOW: Float;

    // Vehicle FPP timer (only active during interpolation)
    private let vehicleFPPTimerId: DelayID;

    private let vehicleFPPCallback: ref<NovaOpticsVehicleFPPCallback>;

    // Vehicle state
    //   0: on foot, 1: FPP, 2: TPP, 3: exiting (camera switches ignored)
    private let vehicleState: Int32;
    private let VSTATE_ON_FOOT: Int32;
    private let VSTATE_FPP: Int32;
    private let VSTATE_TPP: Int32;
    private let VSTATE_EXITING: Int32;

    // BB listener for vehicle mount state
    private let m_hMountedToVehicle: ref<CallbackHandle>;
    private let m_psmBB: wref<IBlackboard>;

    // Scene-tier change (catches teleports that bypass enter/exit hooks)
    private let m_hSceneTier: ref<CallbackHandle>;

    // Vehicle BB for TPP camera detection
    private let m_vehicleBB: wref<IBlackboard>;
    private let m_hIsTPPCameraOn: ref<CallbackHandle>;

    // Deferred validation poll (fires from OnUnmountingEvent and OnSceneTierChanged)
    private let validationPollId: DelayID;

    // Suppresses ForceApply during batch pushes from CET
    private let isBatchPush: Bool;
    private let m_inMenu: Bool = false;
    private let m_inScanner: Bool = false;

    public func SetEnable(value: Bool) -> Void {
        this.enable = value;
        this.SyncInterpToVehicleState();
        if !this.isBatchPush {
            this.ApplyAll();
        }
    }

    public func SetExposureOverrideEnabled(value: Bool) -> Void {
        this.exposureOverrideEnabled = value;
        this.SyncExposureInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureOverrideGlobeEnabled(value: Bool) -> Void {
        this.exposureOverrideGlobeEnabled = value;
        this.SyncExposureInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureOverrideCarEnabled(value: Bool) -> Void {
        this.exposureOverrideCarEnabled = value;
        this.SyncExposureInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureFPPVehicleFix(value: Bool) -> Void {
        this.exposureFPPVehicleFix = value;
        this.SyncExposureInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureVehicleFPPEnterDuration(value: Float) -> Void {
        this.exposureVehicleFPPEnterDuration = value;
    }

    public func SetExposureMinOffset(value: Float) -> Void {
        this.exposureMinOffset = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureMinOffsetEnabled(value: Bool) -> Void {
        this.exposureMinOffsetEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureMinOffsetVehicle(value: Float) -> Void {
        this.exposureMinOffsetVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureMinOffsetVehicleExplicit(value: Bool) -> Void {
        this.exposureMinOffsetVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureMaxOffset(value: Float) -> Void {
        this.exposureMaxOffset = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureMaxOffsetEnabled(value: Bool) -> Void {
        this.exposureMaxOffsetEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureMaxOffsetVehicle(value: Float) -> Void {
        this.exposureMaxOffsetVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureMaxOffsetVehicleExplicit(value: Bool) -> Void {
        this.exposureMaxOffsetVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptGlobeEnabled(value: Bool) -> Void {
        this.exposureAdaptGlobeEnabled = value;
        this.SyncAdaptInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptCarEnabled(value: Bool) -> Void {
        this.exposureAdaptCarEnabled = value;
        this.SyncAdaptInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptSpeedEnabled(value: Bool) -> Void {
        this.exposureAdaptSpeedEnabled = value;
        this.SyncAdaptInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptSpeedDownValue(value: Float) -> Void {
        this.exposureAdaptSpeedDownValue = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptSpeedDownEnabled(value: Bool) -> Void {
        this.exposureAdaptSpeedDownEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptSpeedDownValueVehicle(value: Float) -> Void {
        this.exposureAdaptSpeedDownValueVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptSpeedDownValueVehicleExplicit(value: Bool) -> Void {
        this.exposureAdaptSpeedDownValueVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptSpeedUpValue(value: Float) -> Void {
        this.exposureAdaptSpeedUpValue = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptSpeedUpEnabled(value: Bool) -> Void {
        this.exposureAdaptSpeedUpEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptSpeedUpValueVehicle(value: Float) -> Void {
        this.exposureAdaptSpeedUpValueVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetExposureAdaptSpeedUpValueVehicleExplicit(value: Bool) -> Void {
        this.exposureAdaptSpeedUpValueVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyExposureSettings();
        }
    }

    public func SetVignetteEnabled(value: Bool) -> Void {
        this.vignetteEnabled = value;
        this.SyncVignetteInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteGlobeEnabled(value: Bool) -> Void {
        this.vignetteGlobeEnabled = value;
        this.SyncVignetteInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteCarEnabled(value: Bool) -> Void {
        this.vignetteCarEnabled = value;
        this.SyncVignetteInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteTransitionDuration(value: Float) -> Void {
        this.vignetteTransitionDuration = value;
    }

    public func SetVignetteExp(value: Float) -> Void {
        this.vignetteExp = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteExpEnabled(value: Bool) -> Void {
        this.vignetteExpEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteExpVehicle(value: Float) -> Void {
        this.vignetteExpVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteExpVehicleExplicit(value: Bool) -> Void {
        this.vignetteExpVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorEnabled(value: Bool) -> Void {
        this.vignetteColorEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorRed(value: Int32) -> Void {
        this.vignetteColorRed = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorRedVehicle(value: Int32) -> Void {
        this.vignetteColorRedVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorRedVehicleExplicit(value: Bool) -> Void {
        this.vignetteColorRedVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorGreen(value: Int32) -> Void {
        this.vignetteColorGreen = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorGreenVehicle(value: Int32) -> Void {
        this.vignetteColorGreenVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorGreenVehicleExplicit(value: Bool) -> Void {
        this.vignetteColorGreenVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorBlue(value: Int32) -> Void {
        this.vignetteColorBlue = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorBlueVehicle(value: Int32) -> Void {
        this.vignetteColorBlueVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorBlueVehicleExplicit(value: Bool) -> Void {
        this.vignetteColorBlueVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorAlpha(value: Int32) -> Void {
        this.vignetteColorAlpha = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorAlphaVehicle(value: Int32) -> Void {
        this.vignetteColorAlphaVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetVignetteColorAlphaVehicleExplicit(value: Bool) -> Void {
        this.vignetteColorAlphaVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyVignetteSettings();
        }
    }

    public func SetBloomGlobeEnabled(value: Bool) -> Void {
        this.bloomGlobeEnabled = value;
        this.SyncBloomInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomCarEnabled(value: Bool) -> Void {
        this.bloomCarEnabled = value;
        this.SyncBloomInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomVehicleFPPTransitionDuration(value: Float) -> Void {
        this.bloomVehicleFPPTransitionDuration = value;
    }

    public func SetBloomEnabled(value: Bool) -> Void {
        this.bloomEnabled = value;
        this.SyncBloomInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomColorScale(value: Float) -> Void {
        this.bloomColorScale = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomColorScaleEnabled(value: Bool) -> Void {
        this.bloomColorScaleEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomColorScaleVehicle(value: Float) -> Void {
        this.bloomColorScaleVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomColorScaleVehicleExplicit(value: Bool) -> Void {
        this.bloomColorScaleVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomSize(value: Float) -> Void {
        this.bloomSize = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomSizeEnabled(value: Bool) -> Void {
        this.bloomSizeEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomSizeVehicle(value: Float) -> Void {
        this.bloomSizeVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomSizeVehicleExplicit(value: Bool) -> Void {
        this.bloomSizeVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomAnamorphic(value: Float) -> Void {
        this.bloomAnamorphic = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomAnamorphicEnabled(value: Bool) -> Void {
        this.bloomAnamorphicEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomAnamorphicVehicle(value: Float) -> Void {
        this.bloomAnamorphicVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetBloomAnamorphicVehicleExplicit(value: Bool) -> Void {
        this.bloomAnamorphicVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetLuminanceThresholdMax(value: Float) -> Void {
        this.luminanceThresholdMax = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetLuminanceThresholdMaxEnabled(value: Bool) -> Void {
        this.luminanceThresholdMaxEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetLuminanceThresholdMaxVehicle(value: Float) -> Void {
        this.luminanceThresholdMaxVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetLuminanceThresholdMaxVehicleExplicit(value: Bool) -> Void {
        this.luminanceThresholdMaxVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetSceneColorScale(value: Float) -> Void {
        this.sceneColorScale = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetSceneColorScaleEnabled(value: Bool) -> Void {
        this.sceneColorScaleEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetSceneColorScaleVehicle(value: Float) -> Void {
        this.sceneColorScaleVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetSceneColorScaleVehicleExplicit(value: Bool) -> Void {
        this.sceneColorScaleVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyBloomSettings();
        }
    }

    public func SetLensFlareEnabled(value: Bool) -> Void {
        this.lensFlareEnabled = value;
        this.SyncLensFlareInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareGlobeEnabled(value: Bool) -> Void {
        this.lensFlareGlobeEnabled = value;
        this.SyncLensFlareInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareCarEnabled(value: Bool) -> Void {
        this.lensFlareCarEnabled = value;
        this.SyncLensFlareInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareTransitionDuration(value: Float) -> Void {
        this.lensFlareTransitionDuration = value;
    }

    public func SetLensFlareChromaticEffect(value: Float) -> Void {
        this.lensFlareChromaticEffect = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareChromaticEffectEnabled(value: Bool) -> Void {
        this.lensFlareChromaticEffectEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareChromaticEffectVehicle(value: Float) -> Void {
        this.lensFlareChromaticEffectVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareChromaticEffectVehicleExplicit(value: Bool) -> Void {
        this.lensFlareChromaticEffectVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareHaloWidth(value: Float) -> Void {
        this.lensFlareHaloWidth = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareHaloWidthEnabled(value: Bool) -> Void {
        this.lensFlareHaloWidthEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareHaloWidthVehicle(value: Float) -> Void {
        this.lensFlareHaloWidthVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareHaloWidthVehicleExplicit(value: Bool) -> Void {
        this.lensFlareHaloWidthVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareSaturationValue(value: Float) -> Void {
        this.lensFlareSaturationValue = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareSaturationValueEnabled(value: Bool) -> Void {
        this.lensFlareSaturationValueEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareSaturationValueVehicle(value: Float) -> Void {
        this.lensFlareSaturationValueVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareSaturationValueVehicleExplicit(value: Bool) -> Void {
        this.lensFlareSaturationValueVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareScaleValue(value: Float) -> Void {
        this.lensFlareScaleValue = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareScaleValueEnabled(value: Bool) -> Void {
        this.lensFlareScaleValueEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareScaleValueVehicle(value: Float) -> Void {
        this.lensFlareScaleValueVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetLensFlareScaleValueVehicleExplicit(value: Bool) -> Void {
        this.lensFlareScaleValueVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyLensFlareSettings();
        }
    }

    public func SetChromaticAberrationEnabled(value: Bool) -> Void {
        this.chromaticAberrationEnabled = value;
        this.SyncCAInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetChromaticAberrationGlobeEnabled(value: Bool) -> Void {
        this.chromaticAberrationGlobeEnabled = value;
        this.SyncCAInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetChromaticAberrationCarEnabled(value: Bool) -> Void {
        this.chromaticAberrationCarEnabled = value;
        this.SyncCAInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetChromaticAberrationTransitionDuration(value: Float) -> Void {
        this.chromaticAberrationTransitionDuration = value;
    }

    public func SetCaExp(value: Float) -> Void {
        this.caExp = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaExpEnabled(value: Bool) -> Void {
        this.caExpEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaExpVehicle(value: Float) -> Void {
        this.caExpVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaExpVehicleExplicit(value: Bool) -> Void {
        this.caExpVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaMargin(value: Float) -> Void {
        this.caMargin = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaMarginEnabled(value: Bool) -> Void {
        this.caMarginEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaMarginVehicle(value: Float) -> Void {
        this.caMarginVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaMarginVehicleExplicit(value: Bool) -> Void {
        this.caMarginVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSizeX(value: Float) -> Void {
        this.caSizeX = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSizeXEnabled(value: Bool) -> Void {
        this.caSizeXEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSizeXVehicle(value: Float) -> Void {
        this.caSizeXVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSizeXVehicleExplicit(value: Bool) -> Void {
        this.caSizeXVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSizeY(value: Float) -> Void {
        this.caSizeY = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSizeYEnabled(value: Bool) -> Void {
        this.caSizeYEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSizeYVehicle(value: Float) -> Void {
        this.caSizeYVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSizeYVehicleExplicit(value: Bool) -> Void {
        this.caSizeYVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSubpixelDispersal(value: Float) -> Void {
        this.caSubpixelDispersal = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSubpixelDispersalEnabled(value: Bool) -> Void {
        this.caSubpixelDispersalEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSubpixelDispersalVehicle(value: Float) -> Void {
        this.caSubpixelDispersalVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetCaSubpixelDispersalVehicleExplicit(value: Bool) -> Void {
        this.caSubpixelDispersalVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyChromaticAberrationSettings();
        }
    }

    public func SetVolFogEnabled(value: Bool) -> Void {
        this.volFogEnabled = value;
        this.SyncVolFogInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogGlobeEnabled(value: Bool) -> Void {
        this.volFogGlobeEnabled = value;
        this.SyncVolFogInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogCarEnabled(value: Bool) -> Void {
        this.volFogCarEnabled = value;
        this.SyncVolFogInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogTransitionDuration(value: Float) -> Void {
        this.volFogTransitionDuration = value;
    }

    public func SetVolFogAbsorptionEnabled(value: Bool) -> Void {
        this.volFogAbsorptionEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogAbsorption(value: Float) -> Void {
        this.volFogAbsorption = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogAbsorptionVehicle(value: Float) -> Void {
        this.volFogAbsorptionVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogAbsorptionVehicleExplicit(value: Bool) -> Void {
        this.volFogAbsorptionVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogDensityEnabled(value: Bool) -> Void {
        this.volFogDensityEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogDensity(value: Float) -> Void {
        this.volFogDensity = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogDensityVehicle(value: Float) -> Void {
        this.volFogDensityVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogDensityVehicleExplicit(value: Bool) -> Void {
        this.volFogDensityVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogLocalLightScaleEnabled(value: Bool) -> Void {
        this.volFogLocalLightScaleEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogLocalLightScale(value: Float) -> Void {
        this.volFogLocalLightScale = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogLocalLightScaleVehicle(value: Float) -> Void {
        this.volFogLocalLightScaleVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogLocalLightScaleVehicleExplicit(value: Bool) -> Void {
        this.volFogLocalLightScaleVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogLocalAmbientScaleEnabled(value: Bool) -> Void {
        this.volFogLocalAmbientScaleEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogLocalAmbientScale(value: Float) -> Void {
        this.volFogLocalAmbientScale = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogLocalAmbientScaleVehicle(value: Float) -> Void {
        this.volFogLocalAmbientScaleVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetVolFogLocalAmbientScaleVehicleExplicit(value: Bool) -> Void {
        this.volFogLocalAmbientScaleVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyVolFogSettings();
        }
    }

    public func SetColorGradingEnabled(value: Bool) -> Void {
        this.colorGradingEnabled = value;
        this.SyncColorGradingInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingGlobeEnabled(value: Bool) -> Void {
        this.colorGradingGlobeEnabled = value;
        this.SyncColorGradingInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingCarEnabled(value: Bool) -> Void {
        this.colorGradingCarEnabled = value;
        this.SyncColorGradingInterpToVehicleState();
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingTransitionDuration(value: Float) -> Void {
        this.colorGradingTransitionDuration = value;
    }

    public func SetColorGradingBrightness(value: Float) -> Void {
        this.colorGradingBrightness = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingBrightnessEnabled(value: Bool) -> Void {
        this.colorGradingBrightnessEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingBrightnessVehicle(value: Float) -> Void {
        this.colorGradingBrightnessVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingBrightnessVehicleExplicit(value: Bool) -> Void {
        this.colorGradingBrightnessVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingContrast(value: Float) -> Void {
        this.colorGradingContrast = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingContrastEnabled(value: Bool) -> Void {
        this.colorGradingContrastEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingContrastVehicle(value: Float) -> Void {
        this.colorGradingContrastVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingContrastVehicleExplicit(value: Bool) -> Void {
        this.colorGradingContrastVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingContrastPivot(value: Float) -> Void {
        this.colorGradingContrastPivot = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingContrastPivotEnabled(value: Bool) -> Void {
        this.colorGradingContrastPivotEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingContrastPivotVehicle(value: Float) -> Void {
        this.colorGradingContrastPivotVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingContrastPivotVehicleExplicit(value: Bool) -> Void {
        this.colorGradingContrastPivotVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingSaturation(value: Float) -> Void {
        this.colorGradingSaturation = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingSaturationEnabled(value: Bool) -> Void {
        this.colorGradingSaturationEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingSaturationVehicle(value: Float) -> Void {
        this.colorGradingSaturationVehicle = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func SetColorGradingSaturationVehicleExplicit(value: Bool) -> Void {
        this.colorGradingSaturationVehicleExplicit = value;
        if !this.isBatchPush {
            this.ForceApplyColorGradingSettings();
        }
    }

    public func BeginBatchPush() -> Void {
        this.isBatchPush = true;
    }

    public func EndBatchPush() -> Void {
        this.isBatchPush = false;
        this.ApplyAll();
    }

    public func ApplyAll() -> Void {
        this.ForceApplyExposureSettings();
        this.ForceApplyVignetteSettings();
        this.ForceApplyBloomSettings();
        this.ForceApplyLensFlareSettings();
        this.ForceApplyChromaticAberrationSettings();
        this.ForceApplyVolFogSettings();
        this.ForceApplyColorGradingSettings();
        this.ForceApplyFilmGrainSettings();
    }

    public func SetMenuState(inMenu: Bool) -> Void {
        this.m_inMenu = inMenu;
        this.ApplyAll();
    }

    private cb func OnLoad() 
    {
        this.INTERP_IDLE = 0;
        this.INTERP_APPLYING = 1;
        this.INTERP_ACTIVE = 2;
        this.INTERP_RESTORING = 3;
        this.CATEGORY_EXPOSURE = 0;
        this.CATEGORY_ADAPT = 1;
        this.CATEGORY_BLOOM = 2;
        this.CATEGORY_VOLFOG = 3;
        this.CATEGORY_VIGNETTE = 4;
        this.CATEGORY_LENSFLARE = 5;
        this.CATEGORY_CA = 6;
        this.CATEGORY_COLORGRADING = 7;
        this.CATEGORY_FILMGRAIN = 8;
        this.METERING_CENTER_IMPORTANCE = 0.0;
        this.METERING_THRESHOLD_HIGH = 0.0;
        this.METERING_THRESHOLD_LOW = 0.6;
        this.VSTATE_ON_FOOT = 0;
        this.VSTATE_FPP = 1;
        this.VSTATE_TPP = 2;
        this.VSTATE_EXITING = 3;
        this.interpState = [0, 0, 0, 0, 0, 0, 0, 0, 0];
        this.interpT = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
        GameInstance.GetCallbackSystem().RegisterCallback(n"Session/Ready", this, n"OnSessionReady");
        GameInstance.GetCallbackSystem().RegisterCallback(n"Session/BeforeEnd", this, n"OnSessionEnd");
        GameInstance.GetCallbackSystem().RegisterCallback(n"Resource/PostLoad", this, n"OnArea").AddTarget(ResourceTarget.Type(n"worldEnvironmentAreaParameters"));
        GameInstance.GetCallbackSystem().RegisterCallback(n"Resource/PostLoad", this, n"OnEnv").AddTarget(ResourceTarget.Type(n"worldEnvironmentDefinition"));
        GameInstance.GetCallbackSystem().RegisterCallback(n"Resource/Load", this, n"OnSector").AddTarget(ResourceTarget.Type(n"worldStreamingSector"));
    }

    private cb func OnSessionReady(event: ref<GameSessionEvent>)
    {
        this.ApplyAll();
    }

    private cb func OnSessionEnd(event: ref<GameSessionEvent>)
    {
        if IsDefined(this.m_psmBB) && IsDefined(this.m_hMountedToVehicle) {
            this.m_psmBB.UnregisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.MountedToVehicle, this.m_hMountedToVehicle);
        }
        if IsDefined(this.m_psmBB) && IsDefined(this.m_hSceneTier) {
            this.m_psmBB.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.SceneTier, this.m_hSceneTier);
        }
        this.UnregisterVehicleCameraListener();
        this.m_hMountedToVehicle = null;
        this.m_hSceneTier = null;
        this.m_psmBB = null;

        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        if IsDefined(delaySystem) {
            delaySystem.CancelCallback(this.validationPollId);
        }

        this.vehicleState = this.VSTATE_ON_FOOT;
        this.ResetInterpChannel(this.CATEGORY_EXPOSURE);
        this.ResetInterpChannel(this.CATEGORY_ADAPT);
        this.ResetInterpChannel(this.CATEGORY_BLOOM);
        this.ResetInterpChannel(this.CATEGORY_VOLFOG);
        this.ResetInterpChannel(this.CATEGORY_VIGNETTE);
        this.ResetInterpChannel(this.CATEGORY_LENSFLARE);
        this.ResetInterpChannel(this.CATEGORY_CA);
        this.ResetInterpChannel(this.CATEGORY_COLORGRADING);
        this.ResetInterpChannel(this.CATEGORY_FILMGRAIN);
        // Film grain refs are always invalidated across session transitions.
        ArrayClear(this.filmGrainKeys);
        ArrayClear(this.filmGrainData);
    }

    private func ProcessAreaParameters(params: array<ref<IAreaSettings>>)
    {
        for param in params
        {
            let exposure = param as ExposureAreaSettings;
            if(IsDefined(exposure))
            {
                this.ApplyExposureToSetting(exposure);
            }

            let vignette = param as VignetteAreaSettings;
            if(IsDefined(vignette))
            {
                this.ApplyVignetteToSetting(vignette);
            }

            let bloom = param as BloomAreaSettings;
            if(IsDefined(bloom))
            {
                this.ApplyBloomToSetting(bloom);
            }

            let lensFlare = param as ImageBasedFlareAreaSettings;
            if(IsDefined(lensFlare))
            {
                this.ApplyLensFlareToSetting(lensFlare);
            }

            let ca = param as ChromaticAberrationAreaSettings;
            if(IsDefined(ca))
            {
                this.ApplyChromaticAberrationToSetting(ca);
            }

            let volFog = param as VolumetricFogAreaSettings;
            if(IsDefined(volFog))
            {
                this.ApplyVolFogToSetting(volFog);
            }

            let colorGrading = param as ColorGradingAreaSettings;
            if(IsDefined(colorGrading))
            {
                this.ApplyColorGradingToSetting(colorGrading);
            }

            let filmGrain = param as FilmGrainAreaSettings;
            if(IsDefined(filmGrain))
            {
                this.ApplyFilmGrainToSetting(filmGrain);
            }
        }
    }

    public func HandleTrigger(trigger: ref<worldTriggerAreaNode>)
    {
        for notifier in trigger.notifiers
        {
            let env = notifier as worldEnvAreaNotifier;
            if(IsDefined(env))
            {
                this.ProcessAreaParameters(env.params.areaParameters);
            }
        }
    }

    private cb func OnSector(event: ref<ResourceEvent>) 
    {
        let sector = event.GetResource() as worldStreamingSector;
        if !IsDefined(sector) { return; }
        if(!Equals(sector.category, worldStreamingSectorCategory.Navigation) && !Equals(sector.category, worldStreamingSectorCategory.AlwaysLoaded))
        {
            // ProcessAreaParameters mutates shared array state - not safe from multiple parallel threads
            let count = sector.GetNodeCount();
            let index = 0;
            while index < count {
                let node = sector.GetNode(index);
                let trigger = node as worldTriggerAreaNode;
                if (IsDefined(trigger)) {
                    this.HandleTrigger(trigger);
                }
                index += 1;
            }
        }        
    }    

    private cb func OnArea(event: ref<ResourceEvent>) 
    {
        let env = event.GetResource() as worldEnvironmentAreaParameters;
        if !IsDefined(env) { return; }
        this.ProcessAreaParameters(env.renderAreaSettings.areaParameters);
    }
    
    private cb func OnEnv(event: ref<ResourceEvent>) 
    {
        let env = event.GetResource() as worldEnvironmentDefinition;
        if !IsDefined(env) { return; }
        this.ProcessAreaParameters(env.worldRenderSettings.areaParameters);
    }

    // =========================================================================
    // EXPOSURE
    // =========================================================================

    private func ApplyExposureToSetting(exposure: ref<ExposureAreaSettings>)
    {
        let idx = this.FindExposureIndex(exposure);
        if (idx == -1) {
            idx = this.StoreExposureOriginals(exposure);
        }
        this.SetExposureValues(exposure, idx);
    }

    private func FindExposureIndex(exposure: ref<ExposureAreaSettings>) -> Int32
    {
        return ArrayFindFirst(this.exposureKeys, exposure);
    }

    private func StoreExposureOriginals(exposure: ref<ExposureAreaSettings>) -> Int32
    {
        let data: ExposureOriginals;
        data.setting = exposure;
        data.minPoints = this.StoreCurvePoints(exposure.exposureMin);
        data.maxPoints = this.StoreCurvePoints(exposure.exposureMax);
        data.adaptSpeedDownPoints = this.StoreCurvePoints(exposure.exposureAdaptationSpeedDown);
        data.adaptSpeedUpPoints = this.StoreCurvePoints(exposure.exposureAdaptationSpeedUp);
        data.centerImportancePoints = this.StoreCurvePoints(exposure.exposureCenterImportance);
        data.thresholdHighPoints = this.StoreCurvePoints(exposure.exposurePercentageThresholdHigh);
        data.thresholdLowPoints = this.StoreCurvePoints(exposure.exposurePercentageThresholdLow);
        ArrayPush(this.exposureKeys, exposure);
        ArrayPush(this.exposureData, data);
        return ArraySize(this.exposureData) - 1;
    }

    private func StoreCurvePoints(curve: CurveDataFloat) -> array<CurvePointFloat> {
        let points: array<CurvePointFloat> = [];
        let size = CurveDataFloat.GetSize(curve);
        let i = 0u;
        while (i < size) {
            ArrayPush(points, CurveDataFloat.GetPoint(curve, i));
            i += 1u;
        }
        return points;
    }

    // Min/Max use curve offsets (preserving time-of-day shape), adapt/metering use flat replacement
    private func SetExposureValues(exposure: ref<ExposureAreaSettings>, idx: Int32)
    {
        let d = this.exposureData[idx];

        if(this.enable && this.exposureOverrideEnabled && this.exposureMinOffsetEnabled && !this.m_inMenu) {
            let points = d.minPoints;
            let size = Cast<Uint32>(ArraySize(points));
            CurveDataFloat.SetSize(exposure.exposureMin, size);
            let i = 0u;
            while (i < size) {
                CurveDataFloat.SetPoint(exposure.exposureMin, i, points[Cast<Int32>(i)]);
                let ptTime: Float;
                let ptValue: Float;
                CurveDataFloat.GetPointValue(exposure.exposureMin, i, ptTime, ptValue);
                let globalModified = ptValue - this.exposureMinOffset;
                let vehicleModified = ptValue - this.exposureMinOffsetVehicle;
                let effective = this.GetEffectiveValueDual(ptValue, globalModified, vehicleModified, this.exposureMinOffsetVehicleExplicit, this.exposureOverrideGlobeEnabled, this.exposureOverrideCarEnabled, this.interpState[this.CATEGORY_EXPOSURE], this.interpT[this.CATEGORY_EXPOSURE]);
                CurveDataFloat.SetPointValue(exposure.exposureMin, i, ptTime, effective);
                i += 1u;
            }
        } else {
            this.RestoreExposureMinValues(exposure, d);
        }
        
        if(this.enable && this.exposureOverrideEnabled && this.exposureMaxOffsetEnabled && !this.m_inMenu) {
            let points = d.maxPoints;
            let size = Cast<Uint32>(ArraySize(points));
            CurveDataFloat.SetSize(exposure.exposureMax, size);
            let i = 0u;
            while (i < size) {
                CurveDataFloat.SetPoint(exposure.exposureMax, i, points[Cast<Int32>(i)]);
                let ptTime: Float;
                let ptValue: Float;
                CurveDataFloat.GetPointValue(exposure.exposureMax, i, ptTime, ptValue);
                let globalModified = ptValue + this.exposureMaxOffset;
                let vehicleModified = ptValue + this.exposureMaxOffsetVehicle;
                let effective = this.GetEffectiveValueDual(ptValue, globalModified, vehicleModified, this.exposureMaxOffsetVehicleExplicit, this.exposureOverrideGlobeEnabled, this.exposureOverrideCarEnabled, this.interpState[this.CATEGORY_EXPOSURE], this.interpT[this.CATEGORY_EXPOSURE]);
                CurveDataFloat.SetPointValue(exposure.exposureMax, i, ptTime, effective);
                i += 1u;
            }
        } else {
            this.RestoreExposureMaxValues(exposure, d);
        }
        
        // Metering fix: flatten center importance and threshold curves in vehicle FPP only.
        // The fix is always vehicle-only regardless of globe/car toggles - it must never
        // apply on foot. The interp channel being non-IDLE is the authoritative signal that
        // the player is in (or transitioning out of) vehicle FPP.
        if this.exposureFPPVehicleFix && this.enable && this.exposureOverrideEnabled && !this.m_inMenu
            && this.interpState[this.CATEGORY_EXPOSURE] != this.INTERP_IDLE {
            let t = this.interpT[this.CATEGORY_EXPOSURE];
            let entering = this.interpState[this.CATEGORY_EXPOSURE] == this.INTERP_APPLYING
                || this.interpState[this.CATEGORY_EXPOSURE] == this.INTERP_ACTIVE;
            let origCenter = 1.0;
            if (ArraySize(d.centerImportancePoints) > 0) {
                origCenter = d.centerImportancePoints[0].value;
            }
            let origThreshHigh = 80.0;
            if (ArraySize(d.thresholdHighPoints) > 0) {
                origThreshHigh = d.thresholdHighPoints[0].value;
            }
            let origThreshLow = 20.0;
            if (ArraySize(d.thresholdLowPoints) > 0) {
                origThreshLow = d.thresholdLowPoints[0].value;
            }
            let effectiveCenter: Float;
            let effectiveThreshHigh: Float;
            let effectiveThreshLow: Float;
            if this.interpState[this.CATEGORY_EXPOSURE] == this.INTERP_ACTIVE {
                effectiveCenter    = this.METERING_CENTER_IMPORTANCE;
                effectiveThreshHigh = this.METERING_THRESHOLD_HIGH;
                effectiveThreshLow  = this.METERING_THRESHOLD_LOW;
            } else if this.interpState[this.CATEGORY_EXPOSURE] == this.INTERP_APPLYING {
                effectiveCenter    = origCenter     + (this.METERING_CENTER_IMPORTANCE - origCenter)     * t;
                effectiveThreshHigh = origThreshHigh + (this.METERING_THRESHOLD_HIGH   - origThreshHigh) * t;
                effectiveThreshLow  = origThreshLow  + (this.METERING_THRESHOLD_LOW    - origThreshLow)  * t;
            } else {
                // INTERP_RESTORING
                effectiveCenter    = this.METERING_CENTER_IMPORTANCE + (origCenter     - this.METERING_CENTER_IMPORTANCE) * t;
                effectiveThreshHigh = this.METERING_THRESHOLD_HIGH   + (origThreshHigh - this.METERING_THRESHOLD_HIGH)   * t;
                effectiveThreshLow  = this.METERING_THRESHOLD_LOW    + (origThreshLow  - this.METERING_THRESHOLD_LOW)    * t;
            }
            CurveDataFloat.SetSize(exposure.exposureCenterImportance, 1u);
            CurveDataFloat.SetPointValue(exposure.exposureCenterImportance, 0u, 12.0, effectiveCenter);
            CurveDataFloat.SetSize(exposure.exposurePercentageThresholdHigh, 1u);
            CurveDataFloat.SetPointValue(exposure.exposurePercentageThresholdHigh, 0u, 12.0, effectiveThreshHigh);
            CurveDataFloat.SetSize(exposure.exposurePercentageThresholdLow, 1u);
            CurveDataFloat.SetPointValue(exposure.exposurePercentageThresholdLow, 0u, 12.0, effectiveThreshLow);
        } else {
            this.RestoreExposureCenterImportanceValues(exposure, d);
            this.RestoreExposureThresholdHighValues(exposure, d);
            this.RestoreExposureThresholdLowValues(exposure, d);
        }
        
        if(this.enable && this.exposureAdaptSpeedEnabled && this.exposureAdaptSpeedDownEnabled && !this.m_inMenu) {
            let originalDownValue = 0.0;
            if (ArraySize(d.adaptSpeedDownPoints) > 0) {
                originalDownValue = d.adaptSpeedDownPoints[0].value;
            }
            let effective = this.GetEffectiveValueDual(originalDownValue, this.exposureAdaptSpeedDownValue, this.exposureAdaptSpeedDownValueVehicle, this.exposureAdaptSpeedDownValueVehicleExplicit, this.exposureAdaptGlobeEnabled, this.exposureAdaptCarEnabled, this.interpState[this.CATEGORY_ADAPT], this.interpT[this.CATEGORY_ADAPT]);
            CurveDataFloat.SetSize(exposure.exposureAdaptationSpeedDown, 1u);
            CurveDataFloat.SetPointValue(exposure.exposureAdaptationSpeedDown, 0u, 12.0, effective);
        } else {
            this.RestoreExposureAdaptSpeedDownValues(exposure, d);
        }
        
        if(this.enable && this.exposureAdaptSpeedEnabled && this.exposureAdaptSpeedUpEnabled && !this.m_inMenu) {
            let originalUpValue = 0.0;
            if (ArraySize(d.adaptSpeedUpPoints) > 0) {
                originalUpValue = d.adaptSpeedUpPoints[0].value;
            }
            let effective = this.GetEffectiveValueDual(originalUpValue, this.exposureAdaptSpeedUpValue, this.exposureAdaptSpeedUpValueVehicle, this.exposureAdaptSpeedUpValueVehicleExplicit, this.exposureAdaptGlobeEnabled, this.exposureAdaptCarEnabled, this.interpState[this.CATEGORY_ADAPT], this.interpT[this.CATEGORY_ADAPT]);
            CurveDataFloat.SetSize(exposure.exposureAdaptationSpeedUp, 1u);
            CurveDataFloat.SetPointValue(exposure.exposureAdaptationSpeedUp, 0u, 12.0, effective);
        } else {
            this.RestoreExposureAdaptSpeedUpValues(exposure, d);
        }
    }

    // CurveDataFloat is a value type, so restores write directly to the parent ref
    private func RestoreExposureMinValues(exposure: ref<ExposureAreaSettings>, d: ExposureOriginals)
    {
        let points = d.minPoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(exposure.exposureMin, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(exposure.exposureMin, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }
    
    private func RestoreExposureMaxValues(exposure: ref<ExposureAreaSettings>, d: ExposureOriginals)
    {
        let points = d.maxPoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(exposure.exposureMax, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(exposure.exposureMax, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }
    
    private func RestoreExposureAdaptSpeedDownValues(exposure: ref<ExposureAreaSettings>, d: ExposureOriginals)
    {
        let points = d.adaptSpeedDownPoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(exposure.exposureAdaptationSpeedDown, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(exposure.exposureAdaptationSpeedDown, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }
    
    private func RestoreExposureAdaptSpeedUpValues(exposure: ref<ExposureAreaSettings>, d: ExposureOriginals)
    {
        let points = d.adaptSpeedUpPoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(exposure.exposureAdaptationSpeedUp, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(exposure.exposureAdaptationSpeedUp, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func RestoreExposureCenterImportanceValues(exposure: ref<ExposureAreaSettings>, d: ExposureOriginals)
    {
        let points = d.centerImportancePoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(exposure.exposureCenterImportance, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(exposure.exposureCenterImportance, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func RestoreExposureThresholdHighValues(exposure: ref<ExposureAreaSettings>, d: ExposureOriginals)
    {
        let points = d.thresholdHighPoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(exposure.exposurePercentageThresholdHigh, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(exposure.exposurePercentageThresholdHigh, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func RestoreExposureThresholdLowValues(exposure: ref<ExposureAreaSettings>, d: ExposureOriginals)
    {
        let points = d.thresholdLowPoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(exposure.exposurePercentageThresholdLow, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(exposure.exposurePercentageThresholdLow, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func ForceApplyExposureSettings()
    {
        let i = 0;
        while i < ArraySize(this.exposureData) {
            let d = this.exposureData[i];
            if(IsDefined(d.setting)) {
                this.SetExposureValues(d.setting, i);
            }
            i += 1;
        }
    }

    // =========================================================================
    // VIGNETTE
    // =========================================================================

    private func ApplyVignetteToSetting(vignette: ref<VignetteAreaSettings>)
    {
        let idx = this.FindVignetteIndex(vignette);
        if (idx == -1) {
            idx = this.StoreVignetteOriginals(vignette);
        }
        this.SetVignetteValues(vignette, idx);
    }

    private func FindVignetteIndex(vignette: ref<VignetteAreaSettings>) -> Int32
    {
        return ArrayFindFirst(this.vignetteKeys, vignette);
    }

    private func StoreVignetteOriginals(vignette: ref<VignetteAreaSettings>) -> Int32
    {
        let data: VignetteOriginals;
        data.setting = vignette;
        data.enabled = vignette.vignetteEnabled;
        data.exp = vignette.vignetteExp;
        data.colorRed = vignette.vignetteColor.Red;
        data.colorGreen = vignette.vignetteColor.Green;
        data.colorBlue = vignette.vignetteColor.Blue;
        data.colorAlpha = vignette.vignetteColor.Alpha;
        ArrayPush(this.vignetteKeys, vignette);
        ArrayPush(this.vignetteData, data);
        return ArraySize(this.vignetteData) - 1;
    }

    private func SetVignetteValues(vignette: ref<VignetteAreaSettings>, idx: Int32)
    {
        let d = this.vignetteData[idx];
        if(this.enable && this.vignetteEnabled && !this.m_inMenu) {
            let shouldEnable = this.vignetteGlobeEnabled || (this.vignetteCarEnabled && this.interpState[this.CATEGORY_VIGNETTE] != this.INTERP_IDLE);
            if shouldEnable {
                vignette.enable = true;
                vignette.vignetteEnabled = true;
            } else {
                vignette.enable = d.enabled;
                vignette.vignetteEnabled = d.enabled;
            }
            if this.vignetteExpEnabled {
                vignette.vignetteExp = this.GetEffectiveValueDual(d.exp, this.vignetteExp, this.vignetteExpVehicle, this.vignetteExpVehicleExplicit, this.vignetteGlobeEnabled, this.vignetteCarEnabled, this.interpState[this.CATEGORY_VIGNETTE], this.interpT[this.CATEGORY_VIGNETTE]);
            } else { vignette.vignetteExp = d.exp; }
            if this.vignetteColorEnabled {
                let r = this.GetEffectiveValueDual(Cast<Float>(d.colorRed), Cast<Float>(this.vignetteColorRed), Cast<Float>(this.vignetteColorRedVehicle), this.vignetteColorRedVehicleExplicit, this.vignetteGlobeEnabled, this.vignetteCarEnabled, this.interpState[this.CATEGORY_VIGNETTE], this.interpT[this.CATEGORY_VIGNETTE]);
                let g = this.GetEffectiveValueDual(Cast<Float>(d.colorGreen), Cast<Float>(this.vignetteColorGreen), Cast<Float>(this.vignetteColorGreenVehicle), this.vignetteColorGreenVehicleExplicit, this.vignetteGlobeEnabled, this.vignetteCarEnabled, this.interpState[this.CATEGORY_VIGNETTE], this.interpT[this.CATEGORY_VIGNETTE]);
                let b = this.GetEffectiveValueDual(Cast<Float>(d.colorBlue), Cast<Float>(this.vignetteColorBlue), Cast<Float>(this.vignetteColorBlueVehicle), this.vignetteColorBlueVehicleExplicit, this.vignetteGlobeEnabled, this.vignetteCarEnabled, this.interpState[this.CATEGORY_VIGNETTE], this.interpT[this.CATEGORY_VIGNETTE]);
                let a = this.GetEffectiveValueDual(Cast<Float>(d.colorAlpha), Cast<Float>(this.vignetteColorAlpha), Cast<Float>(this.vignetteColorAlphaVehicle), this.vignetteColorAlphaVehicleExplicit, this.vignetteGlobeEnabled, this.vignetteCarEnabled, this.interpState[this.CATEGORY_VIGNETTE], this.interpT[this.CATEGORY_VIGNETTE]);
                vignette.vignetteColor.Red = Cast<Uint8>(Clamp(RoundF(r), 0, 255));
                vignette.vignetteColor.Green = Cast<Uint8>(Clamp(RoundF(g), 0, 255));
                vignette.vignetteColor.Blue = Cast<Uint8>(Clamp(RoundF(b), 0, 255));
                vignette.vignetteColor.Alpha = Cast<Uint8>(Clamp(RoundF(a), 0, 255));
            } else {
                vignette.vignetteColor.Red = d.colorRed;
                vignette.vignetteColor.Green = d.colorGreen;
                vignette.vignetteColor.Blue = d.colorBlue;
                vignette.vignetteColor.Alpha = d.colorAlpha;
            }
        } else {
            vignette.enable = d.enabled;
            vignette.vignetteEnabled = d.enabled;
            vignette.vignetteExp = d.exp;
            vignette.vignetteColor.Red = d.colorRed;
            vignette.vignetteColor.Green = d.colorGreen;
            vignette.vignetteColor.Blue = d.colorBlue;
            vignette.vignetteColor.Alpha = d.colorAlpha;
        }
    }

    private func ForceApplyVignetteSettings()
    {
        let i = 0;
        while i < ArraySize(this.vignetteData) {
            let d = this.vignetteData[i];
            if(IsDefined(d.setting)) {
                this.SetVignetteValues(d.setting, i);
            }
            i += 1;
        }
    }

    // =========================================================================
    // BLOOM
    // =========================================================================

    private func ApplyBloomToSetting(bloom: ref<BloomAreaSettings>)
    {
        let idx = this.FindBloomIndex(bloom);
        if (idx == -1) {
            idx = this.StoreBloomOriginals(bloom);
        }
        this.SetBloomValues(bloom, idx);
    }

    private func FindBloomIndex(bloom: ref<BloomAreaSettings>) -> Int32
    {
        return ArrayFindFirst(this.bloomKeys, bloom);
    }

    private func StoreBloomOriginals(bloom: ref<BloomAreaSettings>) -> Int32
    {
        let data: BloomOriginals;
        data.setting = bloom;
        data.colorScale = bloom.bloomColorScale;
        data.blurSizeX = bloom.blurSizeX;
        data.blurSizeY = bloom.blurSizeY;
        data.luminanceThresholdMin = bloom.luminanceThresholdMin;
        data.luminanceThresholdMax = bloom.luminanceThresholdMax;
        data.sceneColorScale = bloom.sceneColorScale;
        ArrayPush(this.bloomKeys, bloom);
        ArrayPush(this.bloomData, data);
        return ArraySize(this.bloomData) - 1;
    }

    private func SetBloomValues(bloom: ref<BloomAreaSettings>, idx: Int32)
    {
        let d = this.bloomData[idx];
        if(this.enable && this.bloomEnabled && !this.m_inMenu) {
            let baseSize = this.bloomSize;
            if this.bloomAnamorphicEnabled {
                if (this.bloomAnamorphic > 0.0) {
                    let t = this.bloomAnamorphic / 0.99;
                    this.blurSizeX = baseSize + t * (2.0 - baseSize);
                    this.blurSizeY = baseSize + t * (0.55 - baseSize);
                } else if (this.bloomAnamorphic < 0.0) {
                    let t = AbsF(this.bloomAnamorphic) / 0.99;
                    this.blurSizeX = baseSize + t * (0.55 - baseSize);
                    this.blurSizeY = baseSize + t * (2.0 - baseSize);
                } else {
                    this.blurSizeX = baseSize;
                    this.blurSizeY = baseSize;
                }
            } else {
                this.blurSizeX = baseSize;
                this.blurSizeY = baseSize;
            }

            let baseSizeVehicle = this.bloomSizeVehicle;
            let blurSizeXVehicle: Float;
            let blurSizeYVehicle: Float;
            if this.bloomAnamorphicEnabled {
                let anamorphicVehicle = this.bloomAnamorphicVehicle;
                if anamorphicVehicle > 0.0 {
                    let tv = anamorphicVehicle / 0.99;
                    blurSizeXVehicle = baseSizeVehicle + tv * (2.0 - baseSizeVehicle);
                    blurSizeYVehicle = baseSizeVehicle + tv * (0.55 - baseSizeVehicle);
                } else if anamorphicVehicle < 0.0 {
                    let tv = AbsF(anamorphicVehicle) / 0.99;
                    blurSizeXVehicle = baseSizeVehicle + tv * (0.55 - baseSizeVehicle);
                    blurSizeYVehicle = baseSizeVehicle + tv * (2.0 - baseSizeVehicle);
                } else {
                    blurSizeXVehicle = baseSizeVehicle;
                    blurSizeYVehicle = baseSizeVehicle;
                }
            } else {
                blurSizeXVehicle = baseSizeVehicle;
                blurSizeYVehicle = baseSizeVehicle;
            }

            let sizeVehicleExplicit = this.bloomSizeVehicleExplicit || this.bloomAnamorphicVehicleExplicit;

            if this.bloomColorScaleEnabled {
                bloom.bloomColorScale = this.GetEffectiveValueDual(d.colorScale, this.bloomColorScale, this.bloomColorScaleVehicle, this.bloomColorScaleVehicleExplicit, this.bloomGlobeEnabled, this.bloomCarEnabled, this.interpState[this.CATEGORY_BLOOM], this.interpT[this.CATEGORY_BLOOM]);
            } else { bloom.bloomColorScale = d.colorScale; }
            if this.bloomSizeEnabled {
                bloom.blurSizeX = this.GetEffectiveValueDual(d.blurSizeX, this.blurSizeX, blurSizeXVehicle, sizeVehicleExplicit, this.bloomGlobeEnabled, this.bloomCarEnabled, this.interpState[this.CATEGORY_BLOOM], this.interpT[this.CATEGORY_BLOOM]);
                bloom.blurSizeY = this.GetEffectiveValueDual(d.blurSizeY, this.blurSizeY, blurSizeYVehicle, sizeVehicleExplicit, this.bloomGlobeEnabled, this.bloomCarEnabled, this.interpState[this.CATEGORY_BLOOM], this.interpT[this.CATEGORY_BLOOM]);
            } else { bloom.blurSizeX = d.blurSizeX; bloom.blurSizeY = d.blurSizeY; }
            bloom.luminanceThresholdMin = this.GetEffectiveValueDual(d.luminanceThresholdMin, this.luminanceThresholdMin, this.luminanceThresholdMin, false, this.bloomGlobeEnabled, this.bloomCarEnabled, this.interpState[this.CATEGORY_BLOOM], this.interpT[this.CATEGORY_BLOOM]);
            if this.luminanceThresholdMaxEnabled {
                bloom.luminanceThresholdMax = this.GetEffectiveValueDual(d.luminanceThresholdMax, this.luminanceThresholdMax, this.luminanceThresholdMaxVehicle, this.luminanceThresholdMaxVehicleExplicit, this.bloomGlobeEnabled, this.bloomCarEnabled, this.interpState[this.CATEGORY_BLOOM], this.interpT[this.CATEGORY_BLOOM]);
            } else { bloom.luminanceThresholdMax = d.luminanceThresholdMax; }
            if this.sceneColorScaleEnabled {
                bloom.sceneColorScale = this.GetEffectiveValueDual(d.sceneColorScale, this.sceneColorScale, this.sceneColorScaleVehicle, this.sceneColorScaleVehicleExplicit, this.bloomGlobeEnabled, this.bloomCarEnabled, this.interpState[this.CATEGORY_BLOOM], this.interpT[this.CATEGORY_BLOOM]);
            } else { bloom.sceneColorScale = d.sceneColorScale; }
        } else {
            this.RestoreBloomValues(bloom, d);
        }
    }

    private func RestoreBloomValues(bloom: ref<BloomAreaSettings>, d: BloomOriginals)
    {
        bloom.bloomColorScale = d.colorScale;
        bloom.blurSizeX = d.blurSizeX;
        bloom.blurSizeY = d.blurSizeY;
        bloom.luminanceThresholdMin = d.luminanceThresholdMin;
        bloom.luminanceThresholdMax = d.luminanceThresholdMax;
        bloom.sceneColorScale = d.sceneColorScale;
    }

    private func ForceApplyBloomSettings()
    {
        let i = 0;
        while i < ArraySize(this.bloomData) {
            let d = this.bloomData[i];
            if(IsDefined(d.setting)) {
                this.SetBloomValues(d.setting, i);
            }
            i += 1;
        }
    }

    // =========================================================================
    // LENS FLARE
    // =========================================================================

    private func ApplyLensFlareToSetting(lensFlare: ref<ImageBasedFlareAreaSettings>)
    {
        let idx = this.FindLensFlareIndex(lensFlare);
        if (idx == -1) {
            idx = this.StoreLensFlareOriginals(lensFlare);
        }
        this.SetLensFlareValues(lensFlare, idx);
    }

    private func FindLensFlareIndex(lensFlare: ref<ImageBasedFlareAreaSettings>) -> Int32
    {
        return ArrayFindFirst(this.lensFlareKeys, lensFlare);
    }

    private func StoreLensFlareOriginals(lensFlare: ref<ImageBasedFlareAreaSettings>) -> Int32
    {
        let data: LensFlareOriginals;
        data.setting = lensFlare;
        data.curve = lensFlare.curve;
        data.dispersal = lensFlare.dispersal;
        data.distortion = lensFlare.distortion;
        data.haloWidth = lensFlare.haloWidth;
        data.threshold = lensFlare.treshold;
        data.saturationPoints = this.StoreCurvePoints(lensFlare.saturation);
        data.scalePoints = this.StoreCurvePoints(lensFlare.scale);
        ArrayPush(this.lensFlareKeys, lensFlare);
        ArrayPush(this.lensFlareData, data);
        return ArraySize(this.lensFlareData) - 1;
    }

    private func SetLensFlareValues(lensFlare: ref<ImageBasedFlareAreaSettings>, idx: Int32)
    {
        let d = this.lensFlareData[idx];
        if(this.enable && this.lensFlareEnabled && !this.m_inMenu) {
            this.lensFlareDispersal = this.lensFlareChromaticEffect * 0.5;
            this.lensFlareDistortion = this.lensFlareChromaticEffect * 5.0;

            let lensFlareDispersalVehicle = this.lensFlareChromaticEffectVehicle * 0.5;
            let lensFlareDistortionVehicle = this.lensFlareChromaticEffectVehicle * 5.0;

            if this.lensFlareChromaticEffectEnabled {
                lensFlare.curve = this.GetEffectiveValueDual(d.curve, this.lensFlareCurve, this.lensFlareCurve, false, this.lensFlareGlobeEnabled, this.lensFlareCarEnabled, this.interpState[this.CATEGORY_LENSFLARE], this.interpT[this.CATEGORY_LENSFLARE]);
                lensFlare.dispersal = this.GetEffectiveValueDual(d.dispersal, this.lensFlareDispersal, lensFlareDispersalVehicle, this.lensFlareChromaticEffectVehicleExplicit, this.lensFlareGlobeEnabled, this.lensFlareCarEnabled, this.interpState[this.CATEGORY_LENSFLARE], this.interpT[this.CATEGORY_LENSFLARE]);
                lensFlare.distortion = this.GetEffectiveValueDual(d.distortion, this.lensFlareDistortion, lensFlareDistortionVehicle, this.lensFlareChromaticEffectVehicleExplicit, this.lensFlareGlobeEnabled, this.lensFlareCarEnabled, this.interpState[this.CATEGORY_LENSFLARE], this.interpT[this.CATEGORY_LENSFLARE]);
            } else {
                lensFlare.curve = d.curve;
                lensFlare.dispersal = d.dispersal;
                lensFlare.distortion = d.distortion;
            }
            if this.lensFlareHaloWidthEnabled {
                lensFlare.haloWidth = this.GetEffectiveValueDual(d.haloWidth, this.lensFlareHaloWidth, this.lensFlareHaloWidthVehicle, this.lensFlareHaloWidthVehicleExplicit, this.lensFlareGlobeEnabled, this.lensFlareCarEnabled, this.interpState[this.CATEGORY_LENSFLARE], this.interpT[this.CATEGORY_LENSFLARE]);
            } else {
                lensFlare.haloWidth = d.haloWidth;
            }
            lensFlare.treshold = this.GetEffectiveValueDual(d.threshold, this.lensFlareThreshold, this.lensFlareThreshold, false, this.lensFlareGlobeEnabled, this.lensFlareCarEnabled, this.interpState[this.CATEGORY_LENSFLARE], this.interpT[this.CATEGORY_LENSFLARE]);
            if this.lensFlareSaturationValueEnabled {
                let origSatValue = 0.0;
                if (ArraySize(d.saturationPoints) > 0) { origSatValue = d.saturationPoints[0].value; }
                let effectiveSat = this.GetEffectiveValueDual(origSatValue, this.lensFlareSaturationValue, this.lensFlareSaturationValueVehicle, this.lensFlareSaturationValueVehicleExplicit, this.lensFlareGlobeEnabled, this.lensFlareCarEnabled, this.interpState[this.CATEGORY_LENSFLARE], this.interpT[this.CATEGORY_LENSFLARE]);
                CurveDataFloat.SetSize(lensFlare.saturation, 1u);
                CurveDataFloat.SetPointValue(lensFlare.saturation, 0u, 12.0, effectiveSat);
            } else {
                this.RestoreLensFlareSaturationValues(lensFlare, d);
            }
            if this.lensFlareScaleValueEnabled {
                let origScaleValue = 0.0;
                if (ArraySize(d.scalePoints) > 0) { origScaleValue = d.scalePoints[0].value; }
                let effectiveScale = this.GetEffectiveValueDual(origScaleValue, this.lensFlareScaleValue, this.lensFlareScaleValueVehicle, this.lensFlareScaleValueVehicleExplicit, this.lensFlareGlobeEnabled, this.lensFlareCarEnabled, this.interpState[this.CATEGORY_LENSFLARE], this.interpT[this.CATEGORY_LENSFLARE]);
                CurveDataFloat.SetSize(lensFlare.scale, 1u);
                CurveDataFloat.SetPointValue(lensFlare.scale, 0u, 4.0, effectiveScale);
            } else {
                this.RestoreLensFlareScaleValues(lensFlare, d);
            }
        } else {
            this.RestoreLensFlareValues(lensFlare, d);
        }
    }

    private func RestoreLensFlareValues(lensFlare: ref<ImageBasedFlareAreaSettings>, d: LensFlareOriginals)
    {
        lensFlare.curve = d.curve;
        lensFlare.dispersal = d.dispersal;
        lensFlare.distortion = d.distortion;
        lensFlare.haloWidth = d.haloWidth;
        lensFlare.treshold = d.threshold;
        this.RestoreLensFlareSaturationValues(lensFlare, d);
        this.RestoreLensFlareScaleValues(lensFlare, d);
    }

    private func RestoreLensFlareSaturationValues(lensFlare: ref<ImageBasedFlareAreaSettings>, d: LensFlareOriginals)
    {
        let satPoints = d.saturationPoints;
        let satSize = Cast<Uint32>(ArraySize(satPoints));
        CurveDataFloat.SetSize(lensFlare.saturation, satSize);
        let i = 0u;
        while (i < satSize) {
            CurveDataFloat.SetPoint(lensFlare.saturation, i, satPoints[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func RestoreLensFlareScaleValues(lensFlare: ref<ImageBasedFlareAreaSettings>, d: LensFlareOriginals)
    {
        let scalePoints = d.scalePoints;
        let scaleSize = Cast<Uint32>(ArraySize(scalePoints));
        CurveDataFloat.SetSize(lensFlare.scale, scaleSize);
        let i = 0u;
        while (i < scaleSize) {
            CurveDataFloat.SetPoint(lensFlare.scale, i, scalePoints[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func ForceApplyLensFlareSettings()
    {
        let i = 0;
        while i < ArraySize(this.lensFlareData) {
            let d = this.lensFlareData[i];
            if(IsDefined(d.setting)) {
                this.SetLensFlareValues(d.setting, i);
            }
            i += 1;
        }
    }

    // =========================================================================
    // CHROMATIC ABERRATION
    // =========================================================================

    private func ApplyChromaticAberrationToSetting(ca: ref<ChromaticAberrationAreaSettings>)
    {
        let idx = this.FindChromaticAberrationIndex(ca);
        if (idx == -1) {
            idx = this.StoreChromaticAberrationOriginals(ca);
        }
        this.SetChromaticAberrationValues(ca, idx);
    }

    private func FindChromaticAberrationIndex(ca: ref<ChromaticAberrationAreaSettings>) -> Int32
    {
        return ArrayFindFirst(this.chromaticAberrationKeys, ca);
    }

    private func StoreChromaticAberrationOriginals(ca: ref<ChromaticAberrationAreaSettings>) -> Int32
    {
        let data: ChromaticAberrationOriginals;
        data.setting = ca;
        data.enable = ca.enable;
        data.exp = ca.chromaticAberrationExp;
        data.margin = ca.chromaticAberrationMargin;
        data.sizeX = ca.chromaticAberrationSize.X;
        data.sizeY = ca.chromaticAberrationSize.Y;
        data.subpixelDispersal = ca.subpixelDispersal;
        ArrayPush(this.chromaticAberrationKeys, ca);
        ArrayPush(this.chromaticAberrationData, data);
        return ArraySize(this.chromaticAberrationData) - 1;
    }

    private func SetChromaticAberrationValues(ca: ref<ChromaticAberrationAreaSettings>, idx: Int32)
    {
        let d = this.chromaticAberrationData[idx];
        if(this.enable && this.chromaticAberrationEnabled && !this.m_inMenu) {
            let shouldEnable = this.chromaticAberrationGlobeEnabled || (this.chromaticAberrationCarEnabled && this.interpState[this.CATEGORY_CA] != this.INTERP_IDLE);
            if shouldEnable { ca.enable = true; } else { ca.enable = d.enable; }
            if this.caExpEnabled {
                ca.chromaticAberrationExp = this.GetEffectiveValueDual(d.exp, this.caExp, this.caExpVehicle, this.caExpVehicleExplicit, this.chromaticAberrationGlobeEnabled, this.chromaticAberrationCarEnabled, this.interpState[this.CATEGORY_CA], this.interpT[this.CATEGORY_CA]);
            } else { ca.chromaticAberrationExp = d.exp; }
            if this.caMarginEnabled {
                ca.chromaticAberrationMargin = this.GetEffectiveValueDual(d.margin, this.caMargin, this.caMarginVehicle, this.caMarginVehicleExplicit, this.chromaticAberrationGlobeEnabled, this.chromaticAberrationCarEnabled, this.interpState[this.CATEGORY_CA], this.interpT[this.CATEGORY_CA]);
            } else { ca.chromaticAberrationMargin = d.margin; }
            if this.caSubpixelDispersalEnabled {
                ca.subpixelDispersal = this.GetEffectiveValueDual(d.subpixelDispersal, this.caSubpixelDispersal, this.caSubpixelDispersalVehicle, this.caSubpixelDispersalVehicleExplicit, this.chromaticAberrationGlobeEnabled, this.chromaticAberrationCarEnabled, this.interpState[this.CATEGORY_CA], this.interpT[this.CATEGORY_CA]);
            } else { ca.subpixelDispersal = d.subpixelDispersal; }
            if this.caSizeXEnabled {
                ca.chromaticAberrationSize.X = this.GetEffectiveValueDual(d.sizeX, this.caSizeX, this.caSizeXVehicle, this.caSizeXVehicleExplicit, this.chromaticAberrationGlobeEnabled, this.chromaticAberrationCarEnabled, this.interpState[this.CATEGORY_CA], this.interpT[this.CATEGORY_CA]);
            } else { ca.chromaticAberrationSize.X = d.sizeX; }
            if this.caSizeYEnabled {
                ca.chromaticAberrationSize.Y = this.GetEffectiveValueDual(d.sizeY, this.caSizeY, this.caSizeYVehicle, this.caSizeYVehicleExplicit, this.chromaticAberrationGlobeEnabled, this.chromaticAberrationCarEnabled, this.interpState[this.CATEGORY_CA], this.interpT[this.CATEGORY_CA]);
            } else { ca.chromaticAberrationSize.Y = d.sizeY; }
        } else {
            ca.enable = d.enable;
            ca.chromaticAberrationExp = d.exp;
            ca.chromaticAberrationMargin = d.margin;
            ca.subpixelDispersal = d.subpixelDispersal;
            ca.chromaticAberrationSize.X = d.sizeX;
            ca.chromaticAberrationSize.Y = d.sizeY;
        }
    }

    private func ForceApplyChromaticAberrationSettings()
    {
        let i = 0;
        while i < ArraySize(this.chromaticAberrationData) {
            let d = this.chromaticAberrationData[i];
            if(IsDefined(d.setting)) {
                this.SetChromaticAberrationValues(d.setting, i);
            }
            i += 1;
        }
    }

    // =========================================================================
    // VOLUMETRIC FOG
    // =========================================================================

    private func FindVolFogIndex(setting: ref<VolumetricFogAreaSettings>) -> Int32
    {
        return ArrayFindFirst(this.volFogKeys, setting);
    }

    private func StoreVolFogOriginals(setting: ref<VolumetricFogAreaSettings>) -> Int32
    {
        let data: VolumetricFogOriginals;
        data.setting = setting;
        data.absorptionPoints = this.StoreCurvePoints(setting.absorption);
        data.densityPoints = this.StoreCurvePoints(setting.density);
        data.localLightScalePoints = this.StoreCurvePoints(setting.localLightScale);
        data.localAmbientScalePoints = this.StoreCurvePoints(setting.localAmbientScale);
        data.groundIrradiancePoints = this.StoreCurvePoints(setting.distantGroundIrradiance);
        ArrayPush(this.volFogKeys, setting);
        ArrayPush(this.volFogData, data);
        return ArraySize(this.volFogData) - 1;
    }

    private func ApplyVolFogToSetting(setting: ref<VolumetricFogAreaSettings>)
    {
        let idx = this.FindVolFogIndex(setting);
        if (idx == -1) {
            idx = this.StoreVolFogOriginals(setting);
        }
        this.SetVolFogValues(setting, idx);
    }

    private func SoftClamp(value: Float, ceiling: Float) -> Float {
        if value <= ceiling {
            return value;
        }
        return ceiling + (value - ceiling) * 0.1;
    }

    private func SetVolFogValues(setting: ref<VolumetricFogAreaSettings>, idx: Int32)
    {
        let d = this.volFogData[idx];

        if(this.enable && this.volFogEnabled && this.volFogAbsorptionEnabled && !this.m_inMenu) {
            let points = d.absorptionPoints;
            let size = Cast<Uint32>(ArraySize(points));
            CurveDataFloat.SetSize(setting.absorption, size);
            let i = 0u;
            while (i < size) {
                CurveDataFloat.SetPoint(setting.absorption, i, points[Cast<Int32>(i)]);
                let ptTime: Float;
                let ptValue: Float;
                CurveDataFloat.GetPointValue(setting.absorption, i, ptTime, ptValue);
                let globalClamped = this.SoftClamp(ptValue, this.volFogAbsorption);
                let vehicleClamped = this.SoftClamp(ptValue, this.volFogAbsorptionVehicle);
                let effective = this.GetEffectiveValueDual(ptValue, globalClamped, vehicleClamped, this.volFogAbsorptionVehicleExplicit, this.volFogGlobeEnabled, this.volFogCarEnabled, this.interpState[this.CATEGORY_VOLFOG], this.interpT[this.CATEGORY_VOLFOG]);
                CurveDataFloat.SetPointValue(setting.absorption, i, ptTime, effective);
                i += 1u;
            }
        } else {
            this.RestoreVolFogAbsorptionValues(setting, d);
        }

        if(this.enable && this.volFogEnabled && this.volFogDensityEnabled && !this.m_inMenu) {
            let points = d.densityPoints;
            let size = Cast<Uint32>(ArraySize(points));
            CurveDataFloat.SetSize(setting.density, size);
            let i = 0u;
            while (i < size) {
                CurveDataFloat.SetPoint(setting.density, i, points[Cast<Int32>(i)]);
                let ptTime: Float;
                let ptValue: Float;
                CurveDataFloat.GetPointValue(setting.density, i, ptTime, ptValue);
                let globalClamped = this.SoftClamp(ptValue, this.volFogDensity);
                let vehicleClamped = this.SoftClamp(ptValue, this.volFogDensityVehicle);
                let effective = this.GetEffectiveValueDual(ptValue, globalClamped, vehicleClamped, this.volFogDensityVehicleExplicit, this.volFogGlobeEnabled, this.volFogCarEnabled, this.interpState[this.CATEGORY_VOLFOG], this.interpT[this.CATEGORY_VOLFOG]);
                CurveDataFloat.SetPointValue(setting.density, i, ptTime, effective);
                i += 1u;
            }
        } else {
            this.RestoreVolFogDensityValues(setting, d);
        }

        if(this.enable && this.volFogEnabled && this.volFogLocalLightScaleEnabled && !this.m_inMenu) {
            let points = d.localLightScalePoints;
            let size = Cast<Uint32>(ArraySize(points));
            CurveDataFloat.SetSize(setting.localLightScale, size);
            let i = 0u;
            while (i < size) {
                CurveDataFloat.SetPoint(setting.localLightScale, i, points[Cast<Int32>(i)]);
                let ptTime: Float;
                let ptValue: Float;
                CurveDataFloat.GetPointValue(setting.localLightScale, i, ptTime, ptValue);
                let globalClamped = this.SoftClamp(ptValue, this.volFogLocalLightScale);
                let vehicleClamped = this.SoftClamp(ptValue, this.volFogLocalLightScaleVehicle);
                let effective = this.GetEffectiveValueDual(ptValue, globalClamped, vehicleClamped, this.volFogLocalLightScaleVehicleExplicit, this.volFogGlobeEnabled, this.volFogCarEnabled, this.interpState[this.CATEGORY_VOLFOG], this.interpT[this.CATEGORY_VOLFOG]);
                CurveDataFloat.SetPointValue(setting.localLightScale, i, ptTime, effective);
                i += 1u;
            }
        } else {
            this.RestoreVolFogLocalLightScaleValues(setting, d);
        }

        if(this.enable && this.volFogEnabled && this.volFogLocalAmbientScaleEnabled && !this.m_inMenu) {
            let points = d.localAmbientScalePoints;
            let size = Cast<Uint32>(ArraySize(points));
            CurveDataFloat.SetSize(setting.localAmbientScale, size);
            let i = 0u;
            while (i < size) {
                CurveDataFloat.SetPoint(setting.localAmbientScale, i, points[Cast<Int32>(i)]);
                let ptTime: Float;
                let ptValue: Float;
                CurveDataFloat.GetPointValue(setting.localAmbientScale, i, ptTime, ptValue);
                let globalClamped = this.SoftClamp(ptValue, this.volFogLocalAmbientScale);
                let vehicleClamped = this.SoftClamp(ptValue, this.volFogLocalAmbientScaleVehicle);
                let effective = this.GetEffectiveValueDual(ptValue, globalClamped, vehicleClamped, this.volFogLocalAmbientScaleVehicleExplicit, this.volFogGlobeEnabled, this.volFogCarEnabled, this.interpState[this.CATEGORY_VOLFOG], this.interpT[this.CATEGORY_VOLFOG]);
                CurveDataFloat.SetPointValue(setting.localAmbientScale, i, ptTime, effective);
                i += 1u;
            }
        } else {
            this.RestoreVolFogLocalAmbientScaleValues(setting, d);
        }

        // Ground irradiance: zero when overrides active, restore when idle/disabled
        if(this.enable && this.volFogEnabled && !this.m_inMenu) {
            let shouldZeroGround = this.volFogGlobeEnabled || (this.volFogCarEnabled && this.interpState[this.CATEGORY_VOLFOG] != this.INTERP_IDLE);
            if shouldZeroGround {
                CurveDataFloat.SetSize(setting.distantGroundIrradiance, 1u);
                CurveDataFloat.SetPointValue(setting.distantGroundIrradiance, 0u, 12.0, 0.0);
            } else {
                this.RestoreVolFogGroundIrradianceValues(setting, d);
            }
        } else {
            this.RestoreVolFogGroundIrradianceValues(setting, d);
        }
    }

    private func RestoreVolFogAbsorptionValues(setting: ref<VolumetricFogAreaSettings>, d: VolumetricFogOriginals)
    {
        let points = d.absorptionPoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(setting.absorption, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(setting.absorption, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func RestoreVolFogDensityValues(setting: ref<VolumetricFogAreaSettings>, d: VolumetricFogOriginals)
    {
        let points = d.densityPoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(setting.density, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(setting.density, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func RestoreVolFogLocalLightScaleValues(setting: ref<VolumetricFogAreaSettings>, d: VolumetricFogOriginals)
    {
        let points = d.localLightScalePoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(setting.localLightScale, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(setting.localLightScale, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func RestoreVolFogLocalAmbientScaleValues(setting: ref<VolumetricFogAreaSettings>, d: VolumetricFogOriginals)
    {
        let points = d.localAmbientScalePoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(setting.localAmbientScale, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(setting.localAmbientScale, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func RestoreVolFogGroundIrradianceValues(setting: ref<VolumetricFogAreaSettings>, d: VolumetricFogOriginals)
    {
        let points = d.groundIrradiancePoints;
        let size = Cast<Uint32>(ArraySize(points));
        CurveDataFloat.SetSize(setting.distantGroundIrradiance, size);
        let i = 0u;
        while (i < size) {
            CurveDataFloat.SetPoint(setting.distantGroundIrradiance, i, points[Cast<Int32>(i)]);
            i += 1u;
        }
    }

    private func ForceApplyVolFogSettings()
    {
        let i = 0;
        while i < ArraySize(this.volFogData) {
            let d = this.volFogData[i];
            if(IsDefined(d.setting)) {
                this.SetVolFogValues(d.setting, i);
            }
            i += 1;
        }
    }

    // =========================================================================
    // COLOR GRADING
    // =========================================================================

    private func ApplyColorGradingToSetting(setting: ref<ColorGradingAreaSettings>)
    {
        let idx = this.FindColorGradingIndex(setting);
        if (idx == -1) {
            idx = this.StoreColorGradingOriginals(setting);
        }
        this.SetColorGradingValues(setting, idx);
    }

    private func FindColorGradingIndex(setting: ref<ColorGradingAreaSettings>) -> Int32
    {
        return ArrayFindFirst(this.colorGradingKeys, setting);
    }

    private func StoreColorGradingOriginals(setting: ref<ColorGradingAreaSettings>) -> Int32
    {
        let data: ColorGradingOriginals;
        data.setting = setting;
        data.brightness = setting.brightness;
        data.contrast = setting.contrast;
        data.contrastPivot = setting.contrastPivot;
        data.saturation = setting.saturation;
        ArrayPush(this.colorGradingKeys, setting);
        ArrayPush(this.colorGradingData, data);
        return ArraySize(this.colorGradingData) - 1;
    }

    private func SetColorGradingValues(setting: ref<ColorGradingAreaSettings>, idx: Int32)
    {
        let d = this.colorGradingData[idx];
        if(this.enable && this.colorGradingEnabled && !this.m_inMenu) {
            if this.colorGradingBrightnessEnabled {
                setting.brightness = this.GetEffectiveValueDual(d.brightness, this.colorGradingBrightness, this.colorGradingBrightnessVehicle, this.colorGradingBrightnessVehicleExplicit, this.colorGradingGlobeEnabled, this.colorGradingCarEnabled, this.interpState[this.CATEGORY_COLORGRADING], this.interpT[this.CATEGORY_COLORGRADING]);
            } else { setting.brightness = d.brightness; }
            if this.colorGradingContrastEnabled {
                setting.contrast = this.GetEffectiveValueDual(d.contrast, this.colorGradingContrast, this.colorGradingContrastVehicle, this.colorGradingContrastVehicleExplicit, this.colorGradingGlobeEnabled, this.colorGradingCarEnabled, this.interpState[this.CATEGORY_COLORGRADING], this.interpT[this.CATEGORY_COLORGRADING]);
            } else { setting.contrast = d.contrast; }
            if this.colorGradingContrastPivotEnabled {
                setting.contrastPivot = this.GetEffectiveValueDual(d.contrastPivot, this.colorGradingContrastPivot, this.colorGradingContrastPivotVehicle, this.colorGradingContrastPivotVehicleExplicit, this.colorGradingGlobeEnabled, this.colorGradingCarEnabled, this.interpState[this.CATEGORY_COLORGRADING], this.interpT[this.CATEGORY_COLORGRADING]);
            } else { setting.contrastPivot = d.contrastPivot; }
            if this.colorGradingSaturationEnabled {
                setting.saturation = this.GetEffectiveValueDual(d.saturation, this.colorGradingSaturation, this.colorGradingSaturationVehicle, this.colorGradingSaturationVehicleExplicit, this.colorGradingGlobeEnabled, this.colorGradingCarEnabled, this.interpState[this.CATEGORY_COLORGRADING], this.interpT[this.CATEGORY_COLORGRADING]);
            } else { setting.saturation = d.saturation; }
        } else {
            setting.brightness = d.brightness;
            setting.contrast = d.contrast;
            setting.contrastPivot = d.contrastPivot;
            setting.saturation = d.saturation;
        }
    }

    private func ForceApplyColorGradingSettings()
    {
        let i = 0;
        while i < ArraySize(this.colorGradingData) {
            let d = this.colorGradingData[i];
            if(IsDefined(d.setting)) {
                this.SetColorGradingValues(d.setting, i);
            }
            i += 1;
        }
    }

    // =========================================================================
    // FILM GRAIN
    // =========================================================================

    private func ApplyFilmGrainToSetting(filmGrain: ref<FilmGrainAreaSettings>)
    {
        let idx = this.FindFilmGrainIndex(filmGrain);
        if (idx == -1) {
            idx = this.StoreFilmGrainOriginals(filmGrain);
        }
        this.SetFilmGrainValues(filmGrain, idx);
    }

    private func FindFilmGrainIndex(filmGrain: ref<FilmGrainAreaSettings>) -> Int32
    {
        return ArrayFindFirst(this.filmGrainKeys, filmGrain);
    }

    private func StoreFilmGrainOriginals(filmGrain: ref<FilmGrainAreaSettings>) -> Int32
    {
        let data: FilmGrainOriginals;
        data.setting = filmGrain;
        data.enabled = filmGrain.enable;
        data.applyAfterUpsampling = filmGrain.applyAfterUpsampling;
        data.grainSizeX = filmGrain.grainSize.X;
        data.grainSizeY = filmGrain.grainSize.Y;
        data.grainSizeZ = filmGrain.grainSize.Z;
        let strengthSize = CurveDataVector4.GetSize(filmGrain.strength);
        let i = 0u;
        while (i < strengthSize) {
            let pt: Float;
            let pv: Vector4;
            CurveDataVector4.GetPointValue(filmGrain.strength, i, pt, pv);
            let cp: CurvePointVector4;
            cp.point = pt;
            cp.value = pv;
            ArrayPush(data.strengthPoints, cp);
            i += 1u;
        }
        ArrayPush(this.filmGrainKeys, filmGrain);
        ArrayPush(this.filmGrainData, data);
        return ArraySize(this.filmGrainData) - 1;
    }

    private func SetFilmGrainValues(filmGrain: ref<FilmGrainAreaSettings>, idx: Int32)
    {
        let d = this.filmGrainData[idx];
        let useScanner = this.m_inScanner && this.filmGrainScannerEnabled;
        let activeContext = this.filmGrainGlobeEnabled || useScanner;

        if(this.enable && this.filmGrainEnabled && !this.m_inMenu && activeContext) {
            filmGrain.enable = true;
            filmGrain.applyAfterUpsampling = this.filmGrainApplyAfterUpsampling;

            if useScanner {
                filmGrain.grainSize.X = this.filmGrainGrainSizeXScanner;
                filmGrain.grainSize.Y = this.filmGrainGrainSizeYScanner;
                filmGrain.grainSize.Z = this.filmGrainGrainSizeZScanner;
            } else {
                filmGrain.grainSize.X = this.filmGrainGrainSizeX;
                filmGrain.grainSize.Y = this.filmGrainGrainSizeY;
                filmGrain.grainSize.Z = this.filmGrainGrainSizeZ;
            }

            let sx: Float;
            let sy: Float;
            let sz: Float;
            let sw: Float;
            if useScanner {
                sx = this.filmGrainStrengthXScanner;
                sy = this.filmGrainStrengthYScanner;
                sz = this.filmGrainStrengthZScanner;
                sw = this.filmGrainStrengthWScanner;
            } else {
                sx = this.filmGrainStrengthX;
                sy = this.filmGrainStrengthY;
                sz = this.filmGrainStrengthZ;
                sw = this.filmGrainStrengthW;
            }
            let strengthVec = new Vector4(sx, sy, sz, sw);
            let strengthSize = CurveDataVector4.GetSize(filmGrain.strength);
            if (strengthSize > 0u) {
                let i = 0u;
                while (i < strengthSize) {
                    let ep: Float;
                    let ev: Vector4;
                    CurveDataVector4.GetPointValue(filmGrain.strength, i, ep, ev);
                    CurveDataVector4.SetPointValue(filmGrain.strength, i, ep, strengthVec);
                    i += 1u;
                }
            } else {
                CurveDataVector4.SetSize(filmGrain.strength, 1u);
                CurveDataVector4.SetPointValue(filmGrain.strength, 0u, 12.0, strengthVec);
            }
        } else {
            this.RestoreFilmGrainValues(filmGrain, d);
        }
    }

    private func RestoreFilmGrainValues(filmGrain: ref<FilmGrainAreaSettings>, d: FilmGrainOriginals)
    {
        filmGrain.enable = d.enabled;
        filmGrain.applyAfterUpsampling = d.applyAfterUpsampling;
        filmGrain.grainSize.X = d.grainSizeX;
        filmGrain.grainSize.Y = d.grainSizeY;
        filmGrain.grainSize.Z = d.grainSizeZ;
        let pts = d.strengthPoints;
        let ptsSize = Cast<Uint32>(ArraySize(pts));
        if (ptsSize > 0u) {
            CurveDataVector4.SetSize(filmGrain.strength, ptsSize);
            let i = 0u;
            while (i < ptsSize) {
                CurveDataVector4.SetPointValue(filmGrain.strength, i, pts[Cast<Int32>(i)].point, pts[Cast<Int32>(i)].value);
                i += 1u;
            }
        }
    }

    private func ForceApplyFilmGrainSettings()
    {
        let i = 0;
        while i < ArraySize(this.filmGrainData) {
            let d = this.filmGrainData[i];
            if(IsDefined(d.setting)) {
                this.SetFilmGrainValues(d.setting, i);
            }
            i += 1;
        }
    }

    public func SetFilmGrainEnabled(value: Bool) -> Void {
        this.filmGrainEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainGlobeEnabled(value: Bool) -> Void {
        this.filmGrainGlobeEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainApplyAfterUpsampling(value: Bool) -> Void {
        this.filmGrainApplyAfterUpsampling = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainGrainSizeX(value: Float) -> Void {
        this.filmGrainGrainSizeX = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainGrainSizeY(value: Float) -> Void {
        this.filmGrainGrainSizeY = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainGrainSizeZ(value: Float) -> Void {
        this.filmGrainGrainSizeZ = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainStrengthX(value: Float) -> Void {
        this.filmGrainStrengthX = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainStrengthY(value: Float) -> Void {
        this.filmGrainStrengthY = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainStrengthZ(value: Float) -> Void {
        this.filmGrainStrengthZ = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainStrengthW(value: Float) -> Void {
        this.filmGrainStrengthW = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainScannerEnabled(value: Bool) -> Void {
        this.filmGrainScannerEnabled = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainGrainSizeXScanner(value: Float) -> Void {
        this.filmGrainGrainSizeXScanner = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainGrainSizeYScanner(value: Float) -> Void {
        this.filmGrainGrainSizeYScanner = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainGrainSizeZScanner(value: Float) -> Void {
        this.filmGrainGrainSizeZScanner = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainStrengthXScanner(value: Float) -> Void {
        this.filmGrainStrengthXScanner = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainStrengthYScanner(value: Float) -> Void {
        this.filmGrainStrengthYScanner = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainStrengthZScanner(value: Float) -> Void {
        this.filmGrainStrengthZScanner = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetFilmGrainStrengthWScanner(value: Float) -> Void {
        this.filmGrainStrengthWScanner = value;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    public func SetScannerState(inScanner: Bool) -> Void {
        this.m_inScanner = inScanner;
        if !this.isBatchPush {
            this.ForceApplyFilmGrainSettings();
        }
    }

    // =========================================================================
    // VEHICLE FPP STATE
    // =========================================================================

    public func RegisterVehicleStateListener() -> Void
    {
        let player = GetPlayer(GetGameInstance());
        if !IsDefined(player) { return; }
        if IsDefined(this.m_hMountedToVehicle) { return; }
        let bb = player.GetPlayerStateMachineBlackboard();
        if !IsDefined(bb) { return; }
        this.m_psmBB = bb;
        this.m_hMountedToVehicle = bb.RegisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.MountedToVehicle, this, n"OnMountedToVehicleChanged");
        this.m_hSceneTier = bb.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.SceneTier, this, n"OnSceneTierChanged");
        this.RegisterVehicleCameraListener();
    }

    protected cb func OnMountedToVehicleChanged(value: Bool) -> Bool
    {
        let player = GetPlayer(GetGameInstance());
        if !IsDefined(player) { return false; }
        let vehicle: wref<VehicleObject>;
        VehicleComponent.GetVehicle(GetGameInstance(), player.GetEntityID(), vehicle);
        let isInVehicle = IsDefined(vehicle) && !vehicle.IsA(n"vehicleBikeBaseObject");

        if value {
            if !isInVehicle { return false; }
            this.TransitionVehicleState(this.VSTATE_FPP);
        } else {
            this.TransitionVehicleState(this.VSTATE_ON_FOOT);
        }
        return true;
    }

    // Scene-tier transitions can teleport the player, bypassing enter/exit hooks
    protected cb func OnSceneTierChanged(value: Int32) -> Bool
    {
        this.ScheduleValidationPoll(0.40);
        return true;
    }

    // UI_ActiveVehicleData fires for all vehicle types regardless of HUD controller
    public func RegisterVehicleCameraListener() -> Void {
        this.UnregisterVehicleCameraListener();
        let bbSys = GameInstance.GetBlackboardSystem(GetGameInstance());
        if !IsDefined(bbSys) { return; }
        let vehBB = bbSys.Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
        if !IsDefined(vehBB) { return; }
        this.m_vehicleBB = vehBB;
        this.m_hIsTPPCameraOn = vehBB.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this, n"OnTPPCameraChanged");
    }

    private func UnregisterVehicleCameraListener() -> Void {
        if IsDefined(this.m_vehicleBB) && IsDefined(this.m_hIsTPPCameraOn) {
            this.m_vehicleBB.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this.m_hIsTPPCameraOn);
        }
        this.m_hIsTPPCameraOn = null;
        this.m_vehicleBB = null;
    }

    protected cb func OnTPPCameraChanged(isTPP: Bool) -> Bool
    {
        if isTPP {
            this.TransitionVehicleState(this.VSTATE_TPP);
        } else {
            if this.vehicleState != this.VSTATE_EXITING {
                this.TransitionVehicleState(this.VSTATE_FPP);
            }
        }
        return true;
    }

    public func IsVehicleFPPActive() -> Bool {
        return this.vehicleState == this.VSTATE_FPP;
    }

    public func GetVehicleState() -> Int32 {
        return this.vehicleState;
    }

    public func ScheduleValidationPoll(delay: Float) -> Void {
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        if !IsDefined(delaySystem) { return; }
        delaySystem.CancelCallback(this.validationPollId);
        let cb = NovaOpticsValidationCallback.Create(this);
        this.validationPollId = delaySystem.DelayCallback(cb, delay, false);
    }

    // Corrects stale vehicleState after teleports or forced dismounts
    public func ValidateVehicleState() -> Void {
        let player = GetPlayer(GetGameInstance());
        if !IsDefined(player) { return; }

        let vehicle: wref<VehicleObject>;
        VehicleComponent.GetVehicle(GetGameInstance(), player.GetEntityID(), vehicle);
        let isInVehicle = IsDefined(vehicle) && !vehicle.IsA(n"vehicleBikeBaseObject");

        if isInVehicle && this.vehicleState == this.VSTATE_FPP { return; }
        if !isInVehicle && this.vehicleState == this.VSTATE_ON_FOOT { return; }

        if isInVehicle && this.vehicleState == this.VSTATE_ON_FOOT {
            this.TransitionVehicleState(this.VSTATE_FPP);
        } else if !isInVehicle && (this.vehicleState == this.VSTATE_FPP || this.vehicleState == this.VSTATE_TPP || this.vehicleState == this.VSTATE_EXITING) {
            this.vehicleState = this.VSTATE_ON_FOOT;
            this.ApplyVehicleFPPRestoreSmooth();
        }
    }

    private func ApplyVehicleFPPRestoreSmooth() -> Void {
        if !this.AnyVehicleFPPToggleEnabled() { return; }
        let dur: Float = 0.40;
        if this.exposureOverrideCarEnabled && (this.exposureOverrideEnabled || this.exposureFPPVehicleFix) {
            this.StartTransition(this.CATEGORY_EXPOSURE, false, dur);
        }
        if this.exposureFPPVehicleFix && !this.exposureOverrideCarEnabled {
            this.StartTransition(this.CATEGORY_EXPOSURE, false, dur);
        }
        if this.exposureAdaptCarEnabled && this.exposureAdaptSpeedEnabled {
            this.StartTransition(this.CATEGORY_ADAPT, false, dur);
        }
        if this.bloomCarEnabled && this.bloomEnabled {
            this.StartTransition(this.CATEGORY_BLOOM, false, dur);
        }
        if this.volFogCarEnabled && this.volFogEnabled {
            this.StartTransition(this.CATEGORY_VOLFOG, false, dur);
        }
        if this.vignetteCarEnabled && this.vignetteEnabled {
            this.StartTransition(this.CATEGORY_VIGNETTE, false, dur);
        }
        if this.lensFlareCarEnabled && this.lensFlareEnabled {
            this.StartTransition(this.CATEGORY_LENSFLARE, false, dur);
        }
        if this.chromaticAberrationCarEnabled && this.chromaticAberrationEnabled {
            this.StartTransition(this.CATEGORY_CA, false, dur);
        }
        if this.colorGradingCarEnabled && this.colorGradingEnabled {
            this.StartTransition(this.CATEGORY_COLORGRADING, false, dur);
        }
        if this.AnyInterpActive() {
            this.ScheduleInterpTick();
        }
    }

    // All vehicle state changes flow through here. Invalid transitions are
    // rejected to prevent the race where a forced FPP camera switch during
    // exit would re-apply FPP settings.
    //
    // Valid transitions:
    //   ON_FOOT  -> FPP      (entering)
    //   FPP      -> TPP      (camera switch)
    //   FPP      -> EXITING  (exit initiated)
    //   TPP      -> FPP      (camera switch back)
    //   TPP      -> EXITING  (exit from TPP)
    //   EXITING  -> FPP      (re-enter after stale exit)
    //   EXITING  -> ON_FOOT  (exit complete)
    //   Any      -> ON_FOOT  (blackboard safety net)
    public func TransitionVehicleState(newState: Int32) -> Void
    {
        let oldState = this.vehicleState;
        if oldState == newState { return; }

        if newState == this.VSTATE_FPP {
            if oldState == this.VSTATE_FPP { return; }
        } else if newState == this.VSTATE_TPP {
            if oldState != this.VSTATE_FPP { return; }
        } else if newState == this.VSTATE_EXITING {
            if oldState != this.VSTATE_FPP && oldState != this.VSTATE_TPP { return; }
        }
        // ON_FOOT is always allowed (safety net)

        this.vehicleState = newState;

        if newState == this.VSTATE_FPP {
            this.ApplyVehicleFPPTransitions(true);
        } else if newState == this.VSTATE_TPP {
            this.ApplyVehicleFPPTransitions(false);
        } else if newState == this.VSTATE_EXITING {
            this.ApplyVehicleFPPTransitions(false);
        } else if newState == this.VSTATE_ON_FOOT {
            // Restore settings on any transition to ON_FOOT.
            this.ApplyVehicleFPPTransitions(false);
        }
    }

    private func ApplyVehicleFPPTransitions(entering: Bool) -> Void
    {
        if !this.AnyVehicleFPPToggleEnabled() { return; }

        let exposureEnterDuration = this.exposureVehicleFPPEnterDuration;
        let bloomDuration = this.bloomVehicleFPPTransitionDuration;
        let volFogDur = this.volFogTransitionDuration;

        if this.exposureOverrideCarEnabled && (this.exposureOverrideEnabled || this.exposureFPPVehicleFix) {
            if entering { this.StartTransition(this.CATEGORY_EXPOSURE, true, exposureEnterDuration); }
            else { this.StartTransition(this.CATEGORY_EXPOSURE, false, 0.0); }
        }
        if this.exposureFPPVehicleFix && !this.exposureOverrideCarEnabled {
            if entering { this.StartTransition(this.CATEGORY_EXPOSURE, true, exposureEnterDuration); }
            else { this.StartTransition(this.CATEGORY_EXPOSURE, false, 0.0); }
        }
        if this.exposureAdaptCarEnabled && this.exposureAdaptSpeedEnabled {
            if entering { this.StartTransition(this.CATEGORY_ADAPT, true, exposureEnterDuration); }
            else { this.StartTransition(this.CATEGORY_ADAPT, false, 0.0); }
        }
        if this.bloomCarEnabled && this.bloomEnabled {
            this.StartTransition(this.CATEGORY_BLOOM, entering, bloomDuration);
        }
        if this.volFogCarEnabled && this.volFogEnabled {
            this.StartTransition(this.CATEGORY_VOLFOG, entering, volFogDur);
        }
        let vignetteDur = this.vignetteTransitionDuration;
        if this.vignetteCarEnabled && this.vignetteEnabled {
            this.StartTransition(this.CATEGORY_VIGNETTE, entering, vignetteDur);
        }
        let lensFlareDur = this.lensFlareTransitionDuration;
        if this.lensFlareCarEnabled && this.lensFlareEnabled {
            this.StartTransition(this.CATEGORY_LENSFLARE, entering, lensFlareDur);
        }
        let caDur = this.chromaticAberrationTransitionDuration;
        if this.chromaticAberrationCarEnabled && this.chromaticAberrationEnabled {
            this.StartTransition(this.CATEGORY_CA, entering, caDur);
        }
        let colorGradingDur = this.colorGradingTransitionDuration;
        if this.colorGradingCarEnabled && this.colorGradingEnabled {
            this.StartTransition(this.CATEGORY_COLORGRADING, entering, colorGradingDur);
        }

        if this.AnyInterpActive() {
            this.ScheduleInterpTick();
        }
    }

    public func OnVehicleFPPTick() -> Void
    {
        if this.m_inMenu { return; }
        if !this.AnyInterpActive() { return; }

        let needExposure = false;
        let needBloom = false;
        let needVolFog = false;
        let needVignette = false;
        let needLensFlare = false;
        let needCA = false;
        let needColorGrading = false;

        let i = 0;
        while i < 8 {
            if this.interpState[i] == this.INTERP_APPLYING || this.interpState[i] == this.INTERP_RESTORING {
                let dur: Float;
                if i == this.CATEGORY_EXPOSURE || i == this.CATEGORY_ADAPT { dur = this.exposureVehicleFPPEnterDuration; }
                else if i == this.CATEGORY_VOLFOG { dur = this.volFogTransitionDuration; }
                else if i == this.CATEGORY_VIGNETTE { dur = this.vignetteTransitionDuration; }
                else if i == this.CATEGORY_LENSFLARE { dur = this.lensFlareTransitionDuration; }
                else if i == this.CATEGORY_CA { dur = this.chromaticAberrationTransitionDuration; }
                else if i == this.CATEGORY_COLORGRADING { dur = this.colorGradingTransitionDuration; }
                else { dur = this.bloomVehicleFPPTransitionDuration; }
                if dur <= 0.0 { dur = 0.001; }
                let step = 0.05 / dur;
                this.interpT[i] = MinF(this.interpT[i] + step, 1.0);
                if this.interpT[i] >= 1.0 { this.FinalizeInterp(i); }
                if i == this.CATEGORY_EXPOSURE || i == this.CATEGORY_ADAPT { needExposure = true; }
                if i == this.CATEGORY_BLOOM { needBloom = true; }
                if i == this.CATEGORY_VOLFOG { needVolFog = true; }
                if i == this.CATEGORY_VIGNETTE { needVignette = true; }
                if i == this.CATEGORY_LENSFLARE { needLensFlare = true; }
                if i == this.CATEGORY_CA { needCA = true; }
                if i == this.CATEGORY_COLORGRADING { needColorGrading = true; }
            }
            i += 1;
        }

        if needExposure { this.ForceApplyExposureSettings(); }
        if needBloom { this.ForceApplyBloomSettings(); }
        if needVolFog { this.ForceApplyVolFogSettings(); }
        if needVignette { this.ForceApplyVignetteSettings(); }
        if needLensFlare { this.ForceApplyLensFlareSettings(); }
        if needCA { this.ForceApplyChromaticAberrationSettings(); }
        if needColorGrading { this.ForceApplyColorGradingSettings(); }

        if this.AnyInterpActive() {
            this.ScheduleInterpTick();
        }
    }

    private func ScheduleInterpTick() -> Void
    {
        let delaySystem = GameInstance.GetDelaySystem(GetGameInstance());
        if IsDefined(delaySystem) {
            if !IsDefined(this.vehicleFPPCallback) {
                this.vehicleFPPCallback = NovaOpticsVehicleFPPCallback.Create(this);
            }
            this.vehicleFPPTimerId = delaySystem.DelayCallback(this.vehicleFPPCallback, 0.05, false);
        }
    }


    private func GetEffectiveValueDual(originalValue: Float, globalValue: Float, vehicleValue: Float, vehicleExplicit: Bool, globeEnabled: Bool, carEnabled: Bool, interpState: Int32, interpT: Float) -> Float
    {
        // Both off: no overrides
        if !globeEnabled && !carEnabled {
            return originalValue;
        }

        // Globe only: global value applies everywhere
        if globeEnabled && !carEnabled {
            return globalValue;
        }

        let vehicleEffective: Float;
        if vehicleExplicit {
            vehicleEffective = vehicleValue;
        } else {
            vehicleEffective = globalValue;
        }

        // Car only: interpolate between original and vehicle effective
        if !globeEnabled && carEnabled {
            if interpState == this.INTERP_IDLE { return originalValue; }
            if interpState == this.INTERP_ACTIVE { return vehicleEffective; }
            if interpState == this.INTERP_APPLYING { return originalValue + (vehicleEffective - originalValue) * interpT; }
            if interpState == this.INTERP_RESTORING { return vehicleEffective + (originalValue - vehicleEffective) * interpT; }
            return originalValue;
        }

        // Both on: interpolate between global and vehicle effective
        if interpState == this.INTERP_IDLE { return globalValue; }
        if interpState == this.INTERP_ACTIVE { return vehicleEffective; }
        if interpState == this.INTERP_APPLYING { return globalValue + (vehicleEffective - globalValue) * interpT; }
        if interpState == this.INTERP_RESTORING { return vehicleEffective + (globalValue - vehicleEffective) * interpT; }
        return globalValue;
    }

    private func AnyVehicleFPPToggleEnabled() -> Bool
    {
        return this.exposureOverrideCarEnabled || this.exposureAdaptCarEnabled || this.bloomCarEnabled || this.volFogCarEnabled || this.vignetteCarEnabled || this.lensFlareCarEnabled || this.chromaticAberrationCarEnabled || this.colorGradingCarEnabled || this.exposureFPPVehicleFix;
    }

    private func ResetInterpChannel(category: Int32) -> Void
    {
        this.interpState[category] = this.INTERP_IDLE;
        this.interpT[category] = 0.0;
    }

    private func ActivateInterpChannel(category: Int32) -> Void
    {
        this.interpState[category] = this.INTERP_ACTIVE;
        this.interpT[category] = 0.0;
    }

    private func SyncExposureInterpToVehicleState() -> Void
    {
        // Also activates for metering fix alone - it uses interpState as its vehicle gate regardless of carEnabled
        let needsActive = this.IsVehicleFPPActive() && this.enable
            && ((this.exposureOverrideCarEnabled && this.exposureOverrideEnabled)
                || (this.exposureFPPVehicleFix && this.exposureOverrideEnabled));
        if needsActive {
            this.ActivateInterpChannel(this.CATEGORY_EXPOSURE);
        } else {
            this.ResetInterpChannel(this.CATEGORY_EXPOSURE);
        }
    }

    private func SyncAdaptInterpToVehicleState() -> Void
    {
        let needsActive = this.IsVehicleFPPActive() && this.enable
            && this.exposureAdaptCarEnabled && this.exposureAdaptSpeedEnabled;
        if needsActive {
            this.ActivateInterpChannel(this.CATEGORY_ADAPT);
        } else {
            this.ResetInterpChannel(this.CATEGORY_ADAPT);
        }
    }

    private func SyncBloomInterpToVehicleState() -> Void
    {
        let needsActive = this.IsVehicleFPPActive() && this.enable
            && this.bloomCarEnabled && this.bloomEnabled;
        if needsActive {
            this.ActivateInterpChannel(this.CATEGORY_BLOOM);
        } else {
            this.ResetInterpChannel(this.CATEGORY_BLOOM);
        }
    }

    private func SyncVolFogInterpToVehicleState() -> Void
    {
        let needsActive = this.IsVehicleFPPActive() && this.enable
            && this.volFogCarEnabled && this.volFogEnabled;
        if needsActive {
            this.ActivateInterpChannel(this.CATEGORY_VOLFOG);
        } else {
            this.ResetInterpChannel(this.CATEGORY_VOLFOG);
        }
    }

    private func SyncVignetteInterpToVehicleState() -> Void
    {
        let needsActive = this.IsVehicleFPPActive() && this.enable
            && this.vignetteCarEnabled && this.vignetteEnabled;
        if needsActive {
            this.ActivateInterpChannel(this.CATEGORY_VIGNETTE);
        } else {
            this.ResetInterpChannel(this.CATEGORY_VIGNETTE);
        }
    }

    private func SyncLensFlareInterpToVehicleState() -> Void
    {
        let needsActive = this.IsVehicleFPPActive() && this.enable
            && this.lensFlareCarEnabled && this.lensFlareEnabled;
        if needsActive {
            this.ActivateInterpChannel(this.CATEGORY_LENSFLARE);
        } else {
            this.ResetInterpChannel(this.CATEGORY_LENSFLARE);
        }
    }

    private func SyncCAInterpToVehicleState() -> Void
    {
        let needsActive = this.IsVehicleFPPActive() && this.enable
            && this.chromaticAberrationCarEnabled && this.chromaticAberrationEnabled;
        if needsActive {
            this.ActivateInterpChannel(this.CATEGORY_CA);
        } else {
            this.ResetInterpChannel(this.CATEGORY_CA);
        }
    }

    private func SyncColorGradingInterpToVehicleState() -> Void
    {
        let needsActive = this.IsVehicleFPPActive() && this.enable
            && this.colorGradingCarEnabled && this.colorGradingEnabled;
        if needsActive {
            this.ActivateInterpChannel(this.CATEGORY_COLORGRADING);
        } else {
            this.ResetInterpChannel(this.CATEGORY_COLORGRADING);
        }
    }

    private func SyncInterpToVehicleState() -> Void
    {
        this.SyncExposureInterpToVehicleState();
        this.SyncAdaptInterpToVehicleState();
        this.SyncBloomInterpToVehicleState();
        this.SyncVolFogInterpToVehicleState();
        this.SyncVignetteInterpToVehicleState();
        this.SyncLensFlareInterpToVehicleState();
        this.SyncCAInterpToVehicleState();
        this.SyncColorGradingInterpToVehicleState();
    }

    // CATEGORY_FILMGRAIN (index 8) has no vehicle transition - excluded
    private func AnyInterpActive() -> Bool
    {
        let i = 0;
        while i < 8 {
            if this.interpState[i] == this.INTERP_APPLYING || this.interpState[i] == this.INTERP_RESTORING {
                return true;
            }
            i += 1;
        }
        return false;
    }

    private func StartTransition(category: Int32, entering: Bool, duration: Float) -> Void
    {
        let state = this.interpState[category];
        let t = this.interpT[category];

        if duration <= 0.0 {
            if entering {
                state = this.INTERP_ACTIVE; t = 0.0;
            } else {
                state = this.INTERP_IDLE; t = 0.0;
            }
        } else if entering {
            if state == this.INTERP_IDLE { state = this.INTERP_APPLYING; t = 0.0; }
            else if state == this.INTERP_RESTORING { state = this.INTERP_APPLYING; t = 1.0 - t; }
        } else {
            if state == this.INTERP_ACTIVE { state = this.INTERP_RESTORING; t = 0.0; }
            else if state == this.INTERP_APPLYING { state = this.INTERP_RESTORING; t = 1.0 - t; }
        }

        this.interpState[category] = state;
        this.interpT[category] = t;

        if duration <= 0.0 {
            this.ForceApplyCategory(category);
        }
    }

    private func FinalizeInterp(category: Int32) -> Void
    {
        if this.interpState[category] == this.INTERP_APPLYING {
            this.interpState[category] = this.INTERP_ACTIVE;
            this.interpT[category] = 0.0;
        } else if this.interpState[category] == this.INTERP_RESTORING {
            this.interpState[category] = this.INTERP_IDLE;
            this.interpT[category] = 0.0;
            this.ForceApplyCategory(category);
        }
    }

    private func ForceApplyCategory(category: Int32) -> Void
    {
        if category == this.CATEGORY_EXPOSURE || category == this.CATEGORY_ADAPT {
            this.ForceApplyExposureSettings();
        }
        if category == this.CATEGORY_BLOOM {
            this.ForceApplyBloomSettings();
        }
        if category == this.CATEGORY_VOLFOG {
            this.ForceApplyVolFogSettings();
        }
        if category == this.CATEGORY_VIGNETTE {
            this.ForceApplyVignetteSettings();
        }
        if category == this.CATEGORY_LENSFLARE {
            this.ForceApplyLensFlareSettings();
        }
        if category == this.CATEGORY_CA {
            this.ForceApplyChromaticAberrationSettings();
        }
        if category == this.CATEGORY_COLORGRADING {
            this.ForceApplyColorGradingSettings();
        }
    }

    @if(ModuleExists("CyanideX.ENVTuner"))
    public func IsConflictDetected() -> Bool {
        return true;
    }

    @if(!ModuleExists("CyanideX.ENVTuner"))
    public func IsConflictDetected() -> Bool {
        return false;
    }
}


public class NovaOpticsVehicleFPPCallback extends DelayCallback {
    private let m_service: wref<NovaOptics>;

    public static func Create(service: ref<NovaOptics>) -> ref<NovaOpticsVehicleFPPCallback> {
        let cb = new NovaOpticsVehicleFPPCallback();
        cb.m_service = service;
        return cb;
    }

    public func Call() -> Void {
        if IsDefined(this.m_service) {
            this.m_service.OnVehicleFPPTick();
        }
    }
}

// Deferred validation: lets teleportation finalize before checking vehicle presence
public class NovaOpticsValidationCallback extends DelayCallback {
    private let m_service: wref<NovaOptics>;

    public static func Create(service: ref<NovaOptics>) -> ref<NovaOpticsValidationCallback> {
        let cb = new NovaOpticsValidationCallback();
        cb.m_service = service;
        return cb;
    }

    public func Call() -> Void {
        if IsDefined(this.m_service) {
            this.m_service.ValidateVehicleState();
        }
    }
}

// Vehicle enter/exit hooks (bikes excluded)
@wrapMethod(EnteringEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    wrappedMethod(stateContext, scriptInterface);
    let service = GameInstance.GetScriptableServiceContainer().GetService(n"NovaOptics") as NovaOptics;
    if IsDefined(service) {
        let player = scriptInterface.executionOwner as PlayerPuppet;
        if IsDefined(player) {
            let vehicle: wref<VehicleObject>;
            VehicleComponent.GetVehicle(scriptInterface.GetGame(), player.GetEntityID(), vehicle);
            if IsDefined(vehicle) && vehicle.IsA(n"vehicleBikeBaseObject") { return; }
        }
        service.TransitionVehicleState(1);
        service.RegisterVehicleCameraListener();
    }
}

@wrapMethod(ExitingEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    wrappedMethod(stateContext, scriptInterface);
    let service = GameInstance.GetScriptableServiceContainer().GetService(n"NovaOptics") as NovaOptics;
    if IsDefined(service) {
        let player = scriptInterface.executionOwner as PlayerPuppet;
        if IsDefined(player) {
            let vehicle: wref<VehicleObject>;
            VehicleComponent.GetVehicle(scriptInterface.GetGame(), player.GetEntityID(), vehicle);
            if IsDefined(vehicle) && vehicle.IsA(n"vehicleBikeBaseObject") { return; }
        }
        service.TransitionVehicleState(3);
    }
}

// Safety net for forced dismounts (blocked-door exits that bypass ExitingEvents)
@wrapMethod(VehicleComponent)
protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
    let result = wrappedMethod(evt);
    let service = GameInstance.GetScriptableServiceContainer().GetService(n"NovaOptics") as NovaOptics;
    if IsDefined(service) {
        service.ScheduleValidationPoll(0.30);
    }
    return result;
}

// scanner state - drives film grain context in SetFilmGrainValues
@wrapMethod(PlayerVisionModeController)
private func ActivateVisionMode() -> Void {
    wrappedMethod();
    let service = GameInstance.GetScriptableServiceContainer().GetService(n"NovaOptics") as NovaOptics;
    if IsDefined(service) {
        service.SetScannerState(true);
    }
}

@wrapMethod(PlayerVisionModeController)
private func DeactivateVisionMode() -> Void {
    wrappedMethod();
    let service = GameInstance.GetScriptableServiceContainer().GetService(n"NovaOptics") as NovaOptics;
    if IsDefined(service) {
        service.SetScannerState(false);
    }
}

