// V's own left hand hidden while the launcher is lent (Launcher.reds): the holstered arms add their pieces to V and the
// launcher adds its own arm, hand lowered, so both hands showed (capture 69, 31 October 2026). The holstered arms'
// left-arm pieces are switched off, found by the rendering plane the game draws V's left arm with, and switched back on
// when the launcher is taken back.
// The plane alone finds them, whatever the arm implant (lists of 1 November): bare hands, Monowire, Mantis Blades,
// Gorilla Arms, the launcher's holstered pieces, the personal link; none of the lent launcher's skinned pieces is drawn
// on that plane. Holstered arms put away with a drawn arm implant come back during the loan, half a second after the
// shot: the pieces are looked for again each frame.
// The nails are morph target pieces, another class: looking only at skinned meshes left V's nails on, floating where
// the hidden hand was (reported by a player and seen on the Nexus image, 24 November 2026). Two are on that plane:
// V's own (a0_000_pwa_fpp__nails_l) and the launcher's (a0_006_wa__launcher_nails_l), which the lent launcher also
// brings (list of 1 November with Gorilla Arms). Both are switched off: the lent hand's fingertips are never seen
// during a shot (Kevin, 24 November), so its nails are not missed, and which of the two floated was not told apart.

// Without Codeware V's hand cannot be hidden, and the rope is not drawn (Pieces.reds): the launcher would show over V's
// own hand for nothing, so it is not lent (Launcher.reds).
@if(ModuleExists("Codeware"))
public func ApexGrappleLauncherCanShow() -> Bool {
  return true;
}

@if(!ModuleExists("Codeware"))
public func ApexGrappleLauncherCanShow() -> Bool {
  return false;
}

@if(ModuleExists("Codeware"))
public func ApexGrappleLauncherIsOwnLeftArm(component: ref<IComponent>) -> Bool {
  let skinned: ref<entSkinnedMeshComponent> = component as entSkinnedMeshComponent;
  if IsDefined(skinned) {
    return Equals(skinned.renderingPlaneAnimationParam, n"renderPlaneLeftArm");
  }
  let morph: ref<entMorphTargetSkinnedMeshComponent> = component as entMorphTargetSkinnedMeshComponent;
  return IsDefined(morph) && Equals(morph.renderingPlaneAnimationParam, n"renderPlaneLeftArm");
}

// `first`: as the launcher comes into the hand, written even when nothing is found; afterwards only what came back.
// The plane is read before asking the engine whether the piece is on: a field against a call for each of V's pieces,
// of which up to five are on that plane, nails included (audit of 10 November 2026, A4; log of 24 November). A piece that comes back is switched off
// again but listed once (A17).
@if(ModuleExists("Codeware"))
public func ApexGrappleLauncherHideHand(loan: ref<ApexGrappleLauncherLoan>, first: Bool, now: Float, player: ref<GameObject>) -> Void {
  let found: array<wref<IComponent>>;
  let names: String = "";
  let components: array<ref<IComponent>> = player.GetComponents();
  for component in components {
    if ApexGrappleLauncherIsOwnLeftArm(component) && component.IsEnabled() {
      ArrayPush(found, component);
      names += " " + NameToString(component.GetName());
    }
  }
  if ArraySize(found) == 0 && !first {
    return;
  }
  ApexGrappleLog((first ? "launcher in the left hand " + ToString(now - loan.shotAt) + " s after the shot, " : "") + ToString(ArraySize(found)) + " left-arm pieces switched off" + (first ? "" : ", come back during the loan") + ":" + names);
  for held in found {
    let component: ref<IComponent> = held;
    if IsDefined(component) {
      component.Toggle(false);
      if !ArrayContains(loan.hiddenHand, held) {
        ArrayPush(loan.hiddenHand, held);
      }
    }
  }
}

@if(!ModuleExists("Codeware"))
public func ApexGrappleLauncherHideHand(loan: ref<ApexGrappleLauncherLoan>, first: Bool, now: Float, player: ref<GameObject>) -> Void {}

// How many pieces were switched back on.
public func ApexGrappleLauncherShowHand(loan: ref<ApexGrappleLauncherLoan>) -> Int32 {
  let back: Int32 = 0;
  for held in loan.hiddenHand {
    let component: ref<IComponent> = held;
    if IsDefined(component) {
      component.Toggle(true);
      back += 1;
    }
  }
  ArrayClear(loan.hiddenHand);
  return back;
}
