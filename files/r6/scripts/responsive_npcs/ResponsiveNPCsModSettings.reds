public class ResponsiveNPCsModSettings extends ScriptableSystem {
    public static func Get(gi: GameInstance) -> ref<ResponsiveNPCsModSettings> {
        return GameInstance.GetScriptableSystemsContainer(gi).Get(n"ResponsiveNPCsModSettings") as ResponsiveNPCsModSettings;
    }

    @if(ModuleExists("EquipmentEx"))
    public final static func isEqExInstalled() -> Bool { return true; }

    @if(!ModuleExists("EquipmentEx"))
    public final static func isEqExInstalled() -> Bool { return false; }

    @runtimeProperty("ModSettings.mod", "UI-ResponsiveNPCs-title")
    @runtimeProperty("ModSettings.displayName", "Enabled")
    @runtimeProperty("ModSettings.description", "UI-ResponsiveNPCs-rootenable-description")
    let enabled: Bool = true;

    // @runtimeProperty("ModSettings.mod", "UI-ResponsiveNPCs-title")
    // @runtimeProperty("ModSettings.category", "UI-ResponsiveNPCs-modsetting-category1")
    // @runtimeProperty("ModSettings.category.order", "1")
    // @runtimeProperty("ModSettings.description", "UI-ResponsiveNPCs-modsetting1-description")
    // @runtimeProperty("ModSettings.displayName", "UI-ResponsiveNPCs-modsetting1")
    // @runtimeProperty("ModSettings.dependency", "enabled")
    // public let isCrowdTweaksEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "UI-ResponsiveNPCs-title")
    @runtimeProperty("ModSettings.category", "UI-ResponsiveNPCs-modsetting-category1")
    @runtimeProperty("ModSettings.category.order", "2")
    @runtimeProperty("ModSettings.description", "UI-ResponsiveNPCs-modsetting2-description")
    @runtimeProperty("ModSettings.displayName", "UI-ResponsiveNPCs-modsetting2")
    @runtimeProperty("ModSettings.dependency", "enabled")
    public let isStalkingEnabled: Bool = false;

    @runtimeProperty("ModSettings.mod", "UI-ResponsiveNPCs-title")
    @runtimeProperty("ModSettings.category", "UI-ResponsiveNPCs-modsetting-category1")
    @runtimeProperty("ModSettings.category.order", "2")
    @runtimeProperty("ModSettings.description", "UI-ResponsiveNPCs-modsetting7-description")
    @runtimeProperty("ModSettings.displayName", "UI-ResponsiveNPCs-modsetting7")
    @runtimeProperty("ModSettings.dependency", "enabled")
    public let isVehicleReactionEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "UI-ResponsiveNPCs-title")
    @runtimeProperty("ModSettings.category", "UI-ResponsiveNPCs-modsetting-category2")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.description", "UI-ResponsiveNPCs-modsetting3-description")
    @runtimeProperty("ModSettings.displayName", "UI-ResponsiveNPCs-modsetting3")
    @runtimeProperty("ModSettings.dependency", "enabled")
    public let isClothingDisguiseSystemEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "UI-ResponsiveNPCs-title")
    @runtimeProperty("ModSettings.category", "UI-ResponsiveNPCs-modsetting-category2")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.description", "UI-ResponsiveNPCs-modsetting8-description")
    @runtimeProperty("ModSettings.displayName", "UI-ResponsiveNPCs-modsetting8")
    @runtimeProperty("ModSettings.dependency", "enabled")
    public let isVehicleDisguiseSystemEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "UI-ResponsiveNPCs-title")
    @runtimeProperty("ModSettings.category", "UI-ResponsiveNPCs-modsetting-category2")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.description", "UI-ResponsiveNPCs-modsetting4-description")
    @runtimeProperty("ModSettings.displayName", "UI-ResponsiveNPCs-modsetting4")
    @runtimeProperty("ModSettings.dependency", "enabled")
    public let isEqExEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "UI-ResponsiveNPCs-title")
    @runtimeProperty("ModSettings.category", "UI-ResponsiveNPCs-modsetting-category2")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.description", "UI-ResponsiveNPCs-modsetting5-description")
    @runtimeProperty("ModSettings.displayName", "UI-ResponsiveNPCs-modsetting5")
    @runtimeProperty("ModSettings.dependency", "enabled")
    public let isCustomReactionsEnabled: Bool = true;

    @runtimeProperty("ModSettings.mod", "UI-ResponsiveNPCs-title")
    @runtimeProperty("ModSettings.category", "UI-ResponsiveNPCs-modsetting-category3")
    @runtimeProperty("ModSettings.category.order", "4")
    @runtimeProperty("ModSettings.description", "UI-ResponsiveNPCs-modsetting6-description")
    @runtimeProperty("ModSettings.displayName", "UI-ResponsiveNPCs-modsetting6")
    @runtimeProperty("ModSettings.dependency", "enabled")
    public let isQuestRetaliationEnabled: Bool = false;


    @if(ModuleExists("ModSettingsModule"))
    private func OnAttach() -> Void {
        ModSettings.RegisterListenerToClass(this);
        ModSettings.RegisterListenerToModifications(this);
        this.RefreshEqExButton();
    }

    @if(ModuleExists("ModSettingsModule"))
    private func RefreshEqExButton() -> Void {
        if !ResponsiveNPCsModSettings.isEqExInstalled() {
            // hide Eq ex button if not installed
            let cats:  array<CName> = ModSettings.GetCategories(n"UI-ResponsiveNPCs-title");
            let configVars : array<ref<ConfigVar>> = ModSettings.GetVars(n"UI-ResponsiveNPCs-title", n"UI-ResponsiveNPCs-modsetting-category2");

            let eqExWidget : ref<ModConfigVarBool>;
            let i: Int32 = 0;
            while i < ArraySize(configVars) {
                let displayName: CName = configVars[i].GetDisplayName();
                    if Equals(displayName, n"UI-ResponsiveNPCs-modsetting4") {
                        eqExWidget = configVars[i] as ModConfigVarBool;
                    }
                    i += 1;
            }
            eqExWidget.SetVisible(false);
            this.isEqExEnabled = false;
        }
    } 


    @if(!ModuleExists("ModSettingsModule"))
    private func OnAttach() -> Void {
    }

    @if(ModuleExists("ModSettingsModule"))
    private func OnDetach() -> Void {
        ModSettings.UnregisterListenerToClass(this);
        ModSettings.UnregisterListenerToModifications(this);
    }

    @if(!ModuleExists("ModSettingsModule"))
    private func OnDetach() -> Void {
    }
}
