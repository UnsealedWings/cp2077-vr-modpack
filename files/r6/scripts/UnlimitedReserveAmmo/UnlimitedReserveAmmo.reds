module UnlimitedReserveAmmo

// PC-only redscript version (needs redscript 0.5.32+ on game 2.5) for a manual
// install into <game>\r6\scripts\. Does the same as UnlimitedReserveAmmo.script, which the
// mod.io cloud cook compiles for the in-game mod manager and consoles. Having both
// installed only checks the ammo twice, which does no harm.
// After every shot, and whenever the gun is ready: the gun's ammo type is topped up to the
// game's cap for it (handgun and rifle 899, shotgun 100, sniper 75). V still reloads.

@wrapMethod(ShootEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.UnlimitedReserveAmmo_TopUp(scriptInterface);
}

@wrapMethod(CycleRoundEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.UnlimitedReserveAmmo_TopUp(scriptInterface);
}

// Ready = the gun is drawn and idle (after equipping, reloading or shooting), so an empty
// backpack is filled before the first shot too.
@wrapMethod(ReadyEvents)
protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
  wrappedMethod(stateContext, scriptInterface);
  this.UnlimitedReserveAmmo_TopUp(scriptInterface);
}

@addMethod(WeaponEventsTransition)
protected func UnlimitedReserveAmmo_TopUp(scriptInterface: ref<StateGameScriptInterface>) -> Void {
  let weapon: ref<WeaponObject> = this.GetWeaponObject(scriptInterface);
  let owner: ref<GameObject> = scriptInterface.executionOwner;
  if IsDefined(weapon) && IsDefined(owner) && owner.IsPlayer() {
    let ammo: ItemID = WeaponObject.GetAmmoType(weapon);
    let transactions: ref<TransactionSystem> = GameInstance.GetTransactionSystem(owner.GetGame());
    let tags: array<CName>;
    ArrayPush(tags, n"SkipActivityLog");
    // The cap is a stat on the ammo item, so V needs one round to read it.
    if transactions.GetItemQuantity(owner, ammo) <= 0 {
      transactions.GiveItem(owner, ammo, 1, tags);
    }
    let cap: Int32 = 300;
    let data: wref<gameItemData> = transactions.GetItemData(owner, ammo);
    if IsDefined(data) {
      let itemCap: Int32 = FloorF(data.GetStatValueByType(gamedataStatType.Quantity));
      if itemCap > 0 {
        cap = itemCap;
      }
    }
    let have: Int32 = transactions.GetItemQuantity(owner, ammo);
    if have < cap {
      transactions.GiveItem(owner, ammo, cap - have, tags);
    }
  }
}
