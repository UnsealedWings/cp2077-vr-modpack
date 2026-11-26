// Infinite Stamina 2.0.0 - by 07Grim07
// Stamina is never spent, so it simply stays full. Max stamina, regen and every perk are untouched.
// Optional on/off toggle in Settings > Mod Settings. Without Mod Settings it is always on.
module InfiniteStamina

public class InfiniteStaminaConfig {
  @runtimeProperty("ModSettings.mod", "Infinite Stamina")
  @runtimeProperty("ModSettings.displayName", "Infinite Stamina")
  @runtimeProperty("ModSettings.description", "ON: actions never use stamina (melee, blocking, dodging, aiming, shooting). OFF: vanilla stamina.")
  public let enabled: Bool = true;

  private let m_player: wref<PlayerPuppet>;

  public func Attach(player: ref<PlayerPuppet>) -> Void {
    this.m_player = player;
    this.Refill();
  }

  public func Detach() -> Void {
    this.m_player = null;
  }

  // Called by Mod Settings whenever the toggle is changed in the menu.
  public func OnModSettingsChange() -> Void {
    this.Refill();
  }

  // Top stamina up to full when the mod is active, so it never starts half empty.
  private func Refill() -> Void {
    let player: ref<PlayerPuppet> = this.m_player;
    if this.enabled && IsDefined(player) {
      GameInstance.GetStatPoolsSystem(player.GetGame()).RequestSettingStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Stamina, 100.0, player, true);
    };
  }
}

@if(ModuleExists("ModSettingsModule"))
public func RegisterInfiniteStaminaListener(config: ref<InfiniteStaminaConfig>) -> Void {
  ModSettings.RegisterListenerToClass(config);
  ModSettings.RegisterListenerToModifications(config);
}

@if(!ModuleExists("ModSettingsModule"))
public func RegisterInfiniteStaminaListener(config: ref<InfiniteStaminaConfig>) -> Void {}

@if(ModuleExists("ModSettingsModule"))
public func UnregisterInfiniteStaminaListener(config: ref<InfiniteStaminaConfig>) -> Void {
  ModSettings.UnregisterListenerToModifications(config);
  ModSettings.UnregisterListenerToClass(config);
}

@if(!ModuleExists("ModSettingsModule"))
public func UnregisterInfiniteStaminaListener(config: ref<InfiniteStaminaConfig>) -> Void {}

@addField(PlayerPuppet)
private let m_infiniteStamina: ref<InfiniteStaminaConfig>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let result: Bool = wrappedMethod();
  if this.IsPlayer() {
    this.m_infiniteStamina = new InfiniteStaminaConfig();
    RegisterInfiniteStaminaListener(this.m_infiniteStamina);
    this.m_infiniteStamina.Attach(this);
  };
  return result;
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  if IsDefined(this.m_infiniteStamina) {
    UnregisterInfiniteStaminaListener(this.m_infiniteStamina);
    this.m_infiniteStamina.Detach();
    this.m_infiniteStamina = null;
  };
  return wrappedMethod();
}

// Every stamina cost in the game (melee, block, dodge, aim, shooting) goes through this one function.
// Costs are skipped; refunds and the tiny regen-nudge the game does internally (perc = true) pass through.
@wrapMethod(PlayerStaminaHelpers)
public final static func ModifyStamina(player: ref<PlayerPuppet>, delta: Float, opt perc: Bool) -> Void {
  if delta < 0.0 && !perc && IsDefined(player) && IsDefined(player.m_infiniteStamina) && player.m_infiniteStamina.enabled {
    return;
  };
  wrappedMethod(player, delta, perc);
}

// The HUD stamina bar only redraws when the stamina value changes. Since stamina never drops anymore,
// it would keep showing its default (empty) look in combat, so we push the real value into it.
@addMethod(StaminabarWidgetGameController)
private final func InfiniteStaminaRefreshBar() -> Void {
  let player: wref<GameObject> = this.m_playerPuppet;
  if !IsDefined(player) {
    return;
  };
  let value: Float = GameInstance.GetStatPoolsSystem(player.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Stamina, true);
  this.UpdateStaminaValue(value, value, 1.0, gamedataStatPoolType.Stamina);
}

@wrapMethod(StaminabarWidgetGameController)
protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
  let result: Bool = wrappedMethod(playerGameObject);
  this.InfiniteStaminaRefreshBar();
  return result;
}

@wrapMethod(StaminabarWidgetGameController)
protected cb func OnCombatStateChanged(value: Int32) -> Bool {
  this.InfiniteStaminaRefreshBar();
  return wrappedMethod(value);
}

@wrapMethod(StaminabarWidgetGameController)
protected cb func OnZoneChange(arg: Int32) -> Bool {
  this.InfiniteStaminaRefreshBar();
  return wrappedMethod(arg);
}
