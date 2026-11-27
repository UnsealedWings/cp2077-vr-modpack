public class SamuraiRememberedSuppressor extends IScriptable {
  public persistent let weapon: ItemID;
  public persistent let slot: TweakDBID;
  public persistent let part: ItemID;
}
@addField(PlayerPuppet)
private persistent let samuraiRememberedSuppressors: array<ref<SamuraiRememberedSuppressor>>;
@addField(PlayerPuppet)
private let samuraiSuppressorResult: String;

// Use the same full install/remove routines as the inventory interface.
@addMethod(ItemModificationSystem)
public final func SamuraiSuppressorRemovePart(owner: ref<GameObject>, weapon: ItemID, slot: TweakDBID) -> ItemID {
  return this.RemoveItemPart(owner, weapon, slot, true);
}
@addMethod(ItemModificationSystem)
public final func SamuraiSuppressorInstallPart(owner: ref<GameObject>, weapon: ItemID, part: ItemID, slot: TweakDBID) -> Bool {
  return this.InstallItemPart(owner, weapon, part, slot);
}
@addMethod(PlayerPuppet)
private final func SamuraiSuppressorRemember(weapon: ItemID, slot: TweakDBID, part: ItemID) -> Void {
  let i: Int32 = 0;
  while i < ArraySize(this.samuraiRememberedSuppressors) {
    if this.samuraiRememberedSuppressors[i].weapon == weapon && this.samuraiRememberedSuppressors[i].slot == slot {
      this.samuraiRememberedSuppressors[i].part = part; return;
    };
    // Legacy saves stored the muzzle association without a slot.
    if this.samuraiRememberedSuppressors[i].weapon == weapon
      && !TDBID.IsValid(this.samuraiRememberedSuppressors[i].slot)
      && slot == t"AttachmentSlots.PowerModule" {
      this.samuraiRememberedSuppressors[i].slot = slot;
      this.samuraiRememberedSuppressors[i].part = part; return;
    };
    i += 1;
  };
  let entry = new SamuraiRememberedSuppressor();
  entry.weapon = weapon; entry.slot = slot; entry.part = part;
  ArrayPush(this.samuraiRememberedSuppressors, entry);
}
@addMethod(PlayerPuppet)
public final func SamuraiSuppressorStored(weapon: ItemID, slot: TweakDBID) -> ItemID {
  let i: Int32 = 0;
  while i < ArraySize(this.samuraiRememberedSuppressors) {
    if this.samuraiRememberedSuppressors[i].weapon == weapon
      && (this.samuraiRememberedSuppressors[i].slot == slot
        || (!TDBID.IsValid(this.samuraiRememberedSuppressors[i].slot) && slot == t"AttachmentSlots.PowerModule")) {
      return this.samuraiRememberedSuppressors[i].part;
    };
    i += 1;
  };
  return ItemID.None();
}
@addMethod(PlayerPuppet)
public final func SamuraiSuppressorLastResult() -> String { return this.samuraiSuppressorResult; }

// Read the fitted part from the player's inventory item data, not the drawn weapon entity.
@addMethod(PlayerPuppet)
public final func SamuraiSuppressorFittedID(weapon: ItemID, slot: TweakDBID) -> ItemID {
  let inner: InnerItemData;
  let ts = GameInstance.GetTransactionSystem(this.GetGame());
  let data = ts.GetItemData(this, weapon);
  if !IsDefined(data) || !data.HasPartInSlot(slot) { return ItemID.None(); };
  data.GetItemPart(inner, slot);
  return InnerItemData.GetItemID(inner);
}
@addMethod(PlayerPuppet)
public final func SamuraiSuppressorUnequip(weapon: ItemID, slot: TweakDBID) -> Bool {
  let inner: InnerItemData;
  let ts = GameInstance.GetTransactionSystem(this.GetGame());
  let data = ts.GetItemData(this, weapon);
  if !IsDefined(data) || !data.HasPartInSlot(slot) {
    this.samuraiSuppressorResult = "No attachment fitted"; return false;
  };
  data.GetItemPart(inner, slot);
  let part = InnerItemData.GetItemID(inner);
  let tags = InnerItemData.GetStaticData(inner).Tags();
  if !ItemID.IsValid(part) || ArrayContains(tags, n"parentPart") {
    this.samuraiSuppressorResult = "This is an integral part"; return false;
  };
  let system = GameInstance.GetScriptableSystemsContainer(this.GetGame()).Get(n"ItemModificationSystem") as ItemModificationSystem;
  if !IsDefined(system) { this.samuraiSuppressorResult = "Item modification system unavailable"; return false; };
  // Remember before requesting removal, so an asynchronous rebuild can't lose the association.
  this.SamuraiSuppressorRemember(weapon, slot, part);
  let removed = system.SamuraiSuppressorRemovePart(this, weapon, slot);
  if ItemID.IsValid(removed) { part = removed; this.SamuraiSuppressorRemember(weapon, slot, removed); };
  let after = ts.GetItemData(this, weapon);
  if !ItemID.IsValid(removed) && IsDefined(after) && after.HasPartInSlot(slot) {
    this.samuraiSuppressorResult = "Game has not emptied the attachment slot"; return false;
  };
  // Normal builds return the detached part to the inventory. If it was left owned
  // nowhere, restore that exact instance once; the quantity check prevents a duplicate.
  if ItemID.IsValid(part) && ts.GetItemQuantity(this, part) <= 0 {
    if !ts.GiveItem(this, part, 1) {
      this.samuraiSuppressorResult = "Attachment detached but could not be returned to inventory"; return false;
    };
  };
  this.samuraiSuppressorResult = "Attachment removed; remembered for this weapon";
  return true;
}
@addMethod(PlayerPuppet)
public final func SamuraiSuppressorReequip(weapon: ItemID, slot: TweakDBID) -> Bool {
  let inner: InnerItemData;
  let part = this.SamuraiSuppressorStored(weapon, slot);
  let ts = GameInstance.GetTransactionSystem(this.GetGame());
  let data = ts.GetItemData(this, weapon);
  if !ItemID.IsValid(part) || !IsDefined(data) {
    this.samuraiSuppressorResult = "No remembered attachment for this slot"; return false;
  };
  if data.HasPartInSlot(slot) {
    data.GetItemPart(inner, slot);
    if InnerItemData.GetItemID(inner) == part {
      this.SamuraiSuppressorRemember(weapon, slot, ItemID.None());
      this.samuraiSuppressorResult = "Attachment already equipped"; return true;
    };
    this.samuraiSuppressorResult = "Attachment slot contains another item; leaving it alone"; return false;
  };
  if ts.GetItemQuantity(this, part) <= 0 {
    this.samuraiSuppressorResult = "Remembered attachment is not in your inventory"; return false;
  };
  let system = GameInstance.GetScriptableSystemsContainer(this.GetGame()).Get(n"ItemModificationSystem") as ItemModificationSystem;
  if !IsDefined(system) { this.samuraiSuppressorResult = "Item modification system unavailable"; return false; };
  let installed = system.SamuraiSuppressorInstallPart(this, weapon, part, slot);
  if !installed { this.samuraiSuppressorResult = "Inventory system rejected the attachment"; return false; };
  let after = ts.GetItemData(this, weapon);
  if IsDefined(after) && after.HasPartInSlot(slot) {
    after.GetItemPart(inner, slot);
    if InnerItemData.GetItemID(inner) == part {
      this.SamuraiSuppressorRemember(weapon, slot, ItemID.None());
      this.samuraiSuppressorResult = "Remembered attachment re-equipped through the inventory system";
      return true;
    };
    this.samuraiSuppressorResult = "A different attachment occupies the slot after install"; return false;
  };
  this.samuraiSuppressorResult = "Attachment accepted; awaiting confirmation";
  return true;
}
@addMethod(WeaponObject)
public final func SamuraiSuppressorPartID() -> ItemID {
  let inner: InnerItemData;
  let data = this.GetItemData();
  if !IsDefined(data) || !data.HasPartInSlot(t"AttachmentSlots.PowerModule") { return ItemID.None(); };
  data.GetItemPart(inner, t"AttachmentSlots.PowerModule");
  return InnerItemData.GetItemID(inner);
}
@addMethod(WeaponObject)
public final func SamuraiSuppressorSilentFlag() -> Float {
  return GameInstance.GetStatsSystem(this.GetGame()).GetStatValue(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatType.CanSilentKill);
}
