module ImmersiveAirTraffic

public class ImmersiveAirTraffic extends ScriptableSystem {

  private let m_tries: Int32;

  private func OnAttach() -> Void {
    ITAListen.Register(this);
  }

  private func OnDetach() -> Void {
    ITAListen.Unregister(this);
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.m_tries = 0;
    this.Apply();
  }

  private final func Schedule(delay: Float) -> Void {
    let cb: ref<ITARetry> = new ITARetry();
    cb.system = this;
    GameInstance.GetDelaySystem(this.GetGameInstance()).DelayCallback(cb, delay);
  }

  public final func Apply() -> Void {
    let ws: ref<WorldStateSystem> = GameInstance.GetWorldStateSystem();
    if !IsDefined(ws) || !ws.IsReady() {
      if this.m_tries < 30 { // max tries, 1 s apart
        this.m_tries += 1;
        this.Schedule(1.0);
      };
      return;
    };

    let density: Int32 = new ITASettings().density;
    this.Show(ws, ITANodes.Level2(), density == 2);
    this.Show(ws, ITANodes.Level3(), density == 3);
    this.Show(ws, ITANodes.Level4(), density == 4);
    this.Show(ws, ITANodes.Level5(), density == 5);
  }

  private final func Show(ws: ref<WorldStateSystem>, ids: array<Uint64>, on: Bool) -> Void {
    for id in ids {
      ws.ToggleNode(HashToNodeRef(id), on);
    }
  }

  @if(ModuleExists("ModSettingsModule"))
  public func OnModSettingsChange() -> Void {
    this.m_tries = 0;
    this.Apply();
  }
}

public class ITARetry extends DelayCallback {

  public let system: wref<ImmersiveAirTraffic>;

  public func Call() -> Void {
    if IsDefined(this.system) {
      this.system.Apply();
    };
  }
}

public class ITAListen {

  @if(ModuleExists("ModSettingsModule"))
  public static func Register(obj: ref<IScriptable>) -> Void {
    ModSettings.RegisterListenerToModifications(obj);
  }

  @if(!ModuleExists("ModSettingsModule"))
  public static func Register(obj: ref<IScriptable>) -> Void {}

  @if(ModuleExists("ModSettingsModule"))
  public static func Unregister(obj: ref<IScriptable>) -> Void {
    ModSettings.UnregisterListenerToModifications(obj);
  }

  @if(!ModuleExists("ModSettingsModule"))
  public static func Unregister(obj: ref<IScriptable>) -> Void {}
}
