// Ping Auto-Tag: when V's Ping finishes, enemies it revealed are tagged exactly as if tagged by
// hand in the scanner (right stick click / middle mouse): the persistent outline through walls plus
// the HUD and minimap tag, which outlast the Ping itself.
//
// Default mode (Scale By Tier) scales how many enemies each Ping tier can tag:
//   Tier 1 (Common): 1   |   Tier 2 (Uncommon): 2   |   Tier 3 (Rare): 4
//   Tier 4 (Epic):   8   |   Tier 5 / 5++ (Legendary): all revealed enemies (uncapped)
// When Mod Settings is installed, switch between Scale By Tier, All Tiers Uncapped, or Tier 5 Only
// under Mods > Ping Auto-Tag. Mod Settings is optional; vanilla APIs only.
//
// Only enemies are tagged: civilians, crowd, friendlies, companions, the dead or unconscious, and
// devices (cameras, turrets) never are. Manual untagging in the scanner still works.

module PingAutoTag

public enum PATMode {
  Scaling = 0,
  AllUncapped = 1,
  Tier5Only = 2,
}

public class PATSettings extends IScriptable {
  @runtimeProperty("ModSettings.mod", "Ping Auto-Tag")
  @runtimeProperty("ModSettings.displayName", "Auto-Tag Mode")
  @runtimeProperty("ModSettings.description", "Scale By Tier: Tier 1 tags 1 enemy, Tier 2 tags 2, Tier 3 tags 4, Tier 4 tags 8, Tier 5 / 5++ tags all revealed enemies.\nAll Tiers Uncapped: any Ping tier tags every revealed enemy.\nTier 5 Only (Classic): only Tier 5 / 5++ Ping auto-tags; lower tiers behave as vanilla.")
  @runtimeProperty("ModSettings.displayValues.Scaling", "Scale By Tier (1 / 2 / 4 / 8 / All)")
  @runtimeProperty("ModSettings.displayValues.AllUncapped", "All Tiers Uncapped")
  @runtimeProperty("ModSettings.displayValues.Tier5Only", "Tier 5 Only (Classic)")
  public let mode: PATMode = PATMode.Scaling;
}

@if(ModuleExists("ModSettingsModule"))
func PATRegisterSettings(s: ref<PATSettings>) { ModSettings.RegisterListenerToClass(s); }
@if(!ModuleExists("ModSettingsModule"))
func PATRegisterSettings(s: ref<PATSettings>) {}
@if(ModuleExists("ModSettingsModule"))
func PATUnregisterSettings(s: ref<PATSettings>) { ModSettings.UnregisterListenerToClass(s); }
@if(!ModuleExists("ModSettingsModule"))
func PATUnregisterSettings(s: ref<PATSettings>) {}

public class PATSystem extends ScriptableSystem {
  private let settings: ref<PATSettings>;

  public func OnAttach() {
    this.settings = new PATSettings();
    PATRegisterSettings(this.settings);
  }

  public func OnDetach() {
    if IsDefined(this.settings) {
      PATUnregisterSettings(this.settings);
    }
  }

  public func Mode() -> PATMode {
    return IsDefined(this.settings) ? this.settings.mode : PATMode.Scaling;
  }

  public func SetMode(m: PATMode) {
    if IsDefined(this.settings) {
      this.settings.mode = m;
    }
  }
}

public abstract class PATConfig {
  // Seconds after the Ping upload completes before tagging, so the Ping's own squad marks are on.
  public static func SweepDelay() -> Float = 0.5
}

// Map a Ping quickhack TweakDBID to its tier (1..5), or 0 if not a Ping quickhack.
// Vanilla 2.x uses PingHack (Tier 1/Common), PingLvl2Hack (Tier 3/Rare), PingLvl3Hack (Tier 4/Epic,
// unused in vanilla but present in TweakDB / mods), PingLvl4Hack (Tier 5), PingLvl4PlusPlusHack (5++).
public func PAT_PingTier(id: TweakDBID) -> Int32 {
  if id == t"QuickHack.PingLvl4Hack" || id == t"QuickHack.PingLvl4PlusPlusHack" {
    return 5;
  }
  if id == t"QuickHack.PingLvl3Hack" {
    return 4;
  }
  if id == t"QuickHack.PingLvl2Hack" {
    return 3;
  }
  if id == t"QuickHack.PingHack" || id == t"QuickHack.FreePingHack" || id == t"QuickHack.PingHackTutorial" {
    return 1;
  }
  return 0;
}

// Returns max enemies to tag for this Ping tier and mode:
//   -1 = uncapped, 0 = do not auto-tag, >0 = tag up to N enemies (target first, then nearest squadmates).
public func PAT_CapForTier(tier: Int32, mode: PATMode) -> Int32 {
  if tier <= 0 {
    return 0;
  }
  if Equals(mode, PATMode.AllUncapped) {
    return -1;
  }
  if Equals(mode, PATMode.Tier5Only) {
    return tier >= 5 ? -1 : 0;
  }
  // PATMode.Scaling: T1=1, T2=2, T3=4, T4=8, T5=uncapped.
  if tier >= 5 {
    return -1;
  }
  if tier == 4 {
    return 8;
  }
  if tier == 3 {
    return 4;
  }
  if tier == 2 {
    return 2;
  }
  return 1;
}

// Enemies: hostile NPCs, plus neutral non-civilians such as gang members (vanilla IsEnemy), plus
// anything aggressive. Drones and mechs count; civilians, crowd and friendlies never do.
public func PAT_IsEnemy(npc: ref<ScriptedPuppet>) -> Bool {
  if !IsDefined(npc) || !npc.IsAttached() || npc.IsPlayer() {
    return false;
  }
  if !npc.IsActive() {
    return false;  // dead, defeated, unconscious, switched off
  }
  if npc.IsCrowd() || npc.IsCharacterCivilian() {
    return false;
  }
  if GameObject.IsFriendlyTowardsPlayer(npc) {
    return false;
  }
  return npc.IsEnemy() || npc.IsAggressive();
}

// Squadmates the Ping actually marked.
public func PAT_HasPing(obj: ref<GameObject>) -> Bool {
  return StatusEffectSystem.ObjectHasStatusEffectWithTag(obj, n"Ping")
    || StatusEffectSystem.ObjectHasStatusEffect(obj, t"BaseStatusEffect.PingLvl4PlusPlusMarkStatusEffect")
    || StatusEffectSystem.ObjectHasStatusEffect(obj, t"BaseStatusEffect.PingLvl4MarkStatusEffect")
    || StatusEffectSystem.ObjectHasStatusEffect(obj, t"BaseStatusEffect.PingLvl2MarkStatusEffect")
    || StatusEffectSystem.ObjectHasStatusEffect(obj, t"BaseStatusEffect.PingMarkStatusEffect");
}

// Same path as the manual scanner tag. TagObject queues a request and doesn't dedupe, so skip
// anything already tagged.
public func PAT_TryTag(npc: ref<ScriptedPuppet>) -> Bool {
  if !PAT_IsEnemy(npc) || npc.IsTaggedinFocusMode() || !npc.CanBeTagged() {
    return false;
  }
  GameObject.TagObject(npc);
  return true;
}

public func PAT_AddCandidate(npc: ref<ScriptedPuppet>, seen: script_ref<array<EntityID>>, outList: script_ref<array<ref<ScriptedPuppet>>>) {
  if !PAT_IsEnemy(npc) || !npc.CanBeTagged() {
    return;
  }
  let id: EntityID = npc.GetEntityID();
  let i: Int32 = 0;
  while i < ArraySize(Deref(seen)) {
    if Deref(seen)[i] == id {
      return;
    }
    i += 1;
  }
  ArrayPush(Deref(seen), id);
  ArrayPush(Deref(outList), npc);
}

// squadIDs is the pinged NPC's squad as it was when the Ping completed (Ping reveals that whole
// squad), so downing the target during the delay can't hide its squadmates. Current squadmates
// carrying a Ping mark are added too.
// When cap > 0, the pinged target takes slot 1 and the remaining slots go to the nearest squadmates
// around it (counted across active enemies so repeat casts on the same enemy don't bypass the cap).
public func PAT_Sweep(game: GameInstance, rootID: EntityID, squadIDs: array<EntityID>, cap: Int32) {
  if cap == 0 {
    return;
  }
  let seen: array<EntityID>;
  let candidates: array<ref<ScriptedPuppet>>;
  let root: ref<ScriptedPuppet> = GameInstance.FindEntityByID(game, rootID) as ScriptedPuppet;
  let hasRootOrigin: Bool = false;
  let origin: Vector4;
  if IsDefined(root) {
    origin = root.GetWorldPosition();
    hasRootOrigin = true;
    PAT_AddCandidate(root, seen, candidates);
    let now: array<EntityID>;
    AISquadHelper.GetSquadmatesID(root, now);
    let k: Int32 = 0;
    while k < ArraySize(now) {
      let mate: ref<ScriptedPuppet> = GameInstance.FindEntityByID(game, now[k]) as ScriptedPuppet;
      if IsDefined(mate) && PAT_HasPing(mate) {
        PAT_AddCandidate(mate, seen, candidates);
      }
      k += 1;
    }
  }
  let i: Int32 = 0;
  while i < ArraySize(squadIDs) {
    PAT_AddCandidate(GameInstance.FindEntityByID(game, squadIDs[i]) as ScriptedPuppet, seen, candidates);
    i += 1;
  }
  let total: Int32 = ArraySize(candidates);
  if total == 0 {
    return;
  }
  if cap < 0 || total <= cap {
    let j: Int32 = 0;
    while j < total {
      PAT_TryTag(candidates[j]);
      j += 1;
    }
    return;
  }
  if !hasRootOrigin {
    let player: ref<GameObject> = GameInstance.GetPlayerSystem(game).GetLocalPlayerMainGameObject();
    if IsDefined(player) {
      origin = player.GetWorldPosition();
    }
  }
  // Pick up to `cap` candidates: root first (distance -1), then nearest squadmates.
  let picked: array<Bool>;
  let m: Int32 = 0;
  while m < total {
    ArrayPush(picked, false);
    m += 1;
  }
  let slot: Int32 = 0;
  while slot < cap {
    let bestIdx: Int32 = -1;
    let bestDist: Float = 0.0;
    let c: Int32 = 0;
    while c < total {
      if !picked[c] {
        let d: Float = candidates[c].GetEntityID() == rootID ? -1.0 : Vector4.DistanceSquared(origin, candidates[c].GetWorldPosition());
        if bestIdx < 0 || d < bestDist {
          bestIdx = c;
          bestDist = d;
        }
      }
      c += 1;
    }
    if bestIdx < 0 {
      break;
    }
    picked[bestIdx] = true;
    PAT_TryTag(candidates[bestIdx]);
    slot += 1;
  }
}

public class PATSweepCallback extends DelayCallback {
  public let game: GameInstance;
  public let rootID: EntityID;
  public let squadIDs: array<EntityID>;
  public let cap: Int32;

  public func Call() {
    PAT_Sweep(this.game, this.rootID, this.squadIDs, this.cap);
  }
}

// Fires once per completed quickhack upload. Schedules the tagging sweep according to Ping tier & mode.
@wrapMethod(ScriptableDeviceAction)
public func CompleteAction(gameInstance: GameInstance) {
  wrappedMethod(gameInstance);
  let ping: ref<PingSquad> = this as PingSquad;
  if !IsDefined(ping) {
    return;
  }
  let tier: Int32 = PAT_PingTier(this.GetObjectActionID());
  if tier <= 0 {
    return;
  }
  let exec: wref<GameObject> = this.GetExecutor();
  if !IsDefined(exec) || !exec.IsPlayer() {
    return;
  }
  let sys: ref<PATSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"PingAutoTag.PATSystem") as PATSystem;
  let mode: PATMode = IsDefined(sys) ? sys.Mode() : PATMode.Scaling;
  let cap: Int32 = PAT_CapForTier(tier, mode);
  if cap == 0 {
    return;
  }
  let cb: ref<PATSweepCallback> = new PATSweepCallback();
  cb.game = gameInstance;
  cb.rootID = this.GetRequesterID();
  cb.cap = cap;
  let root: ref<ScriptedPuppet> = GameInstance.FindEntityByID(gameInstance, cb.rootID) as ScriptedPuppet;
  if IsDefined(root) {
    let ids: array<EntityID>;
    AISquadHelper.GetSquadmatesID(root, ids);
    cb.squadIDs = ids;
  }
  GameInstance.GetDelaySystem(gameInstance).DelayCallback(cb, PATConfig.SweepDelay(), false);
}
