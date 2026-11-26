/* TODO
- check if companion
*/
native func LogChannel(channel: CName, const text: script_ref<String>) ;

@if(ModuleExists("EquipmentEx"))
@addMethod(PlayerPuppet)
public final static func isEqExInstalled() -> Bool { return true; }

@if(!ModuleExists("EquipmentEx"))
@addMethod(PlayerPuppet)
public final static func isEqExInstalled() -> Bool { return false; }

@if(ModuleExists("ModSettingsModule"))
@addField(PlayerPuppet)
// public final static func isModSettingsInstalled() -> Bool { return true; }
let m_isModSettingsInstalled: Bool = true;

@if(!ModuleExists("ModSettingsModule"))
@addField(PlayerPuppet)
// public final static func isModSettingsInstalled() -> Bool { return false; }
let m_isModSettingsInstalled: Bool = false;

@addField(PlayerPuppet)
let m_responsiveNPCModSettings: ref<ResponsiveNPCsModSettings>;

@addField(VehicleObject)
let m_currentTrafficLightState: worldTrafficLightColor;

@addField(PlayerPuppet)
let m_currentCrystalCoatDetectionMultiplier: Float = 0.0; 

@addField(PlayerPuppet)
let m_vehicleCrystalCoatState: Int32;

@addField(PlayerPuppet)
let m_hasVehicleCrystalDome: Bool = false;

@addField(PlayerPuppet)
let m_currentClothingReactionPreset: Int32 = 0;

@addField(PlayerPuppet)
let m_affiliatedEqExSlotCount: Int32 = 0;

@addField(PlayerPuppet)
let m_isAlmostCyberpsycho: Bool = false;

// @addField(PlayerPuppet)
// let m_cyberwareStatListener: ref<ScriptStatsListener>;

@addField(PlayerPuppet)
let m_currentAllocatedCWCapacity: Float = 1.0;

@addField(PlayerPuppet)
let m_playerBuckNaked: Bool = false;

@addField(PlayerPuppet)
let m_isPlayerBroke: Bool = false;

@addField(PlayerPuppet)
let m_playerClothAffiliation: Int32;

@addField(PlayerPuppet)
let m_playerAllyAffiliationMap: ref<inkIntHashMap>;

@addField(PlayerPuppet)
let m_playerRivalAffiliationMap: ref<inkIntHashMap>;

@addField(PlayerPuppet)
let m_lastHeadItemID: ItemID;

@addField(PlayerPuppet)
let m_lastOuterChestItemID: ItemID;

@addField(PlayerPuppet)
let m_lastInnerChestItemID: ItemID;

@addField(PlayerPuppet)
let m_lastLegsItemID: ItemID;

@addField(PlayerPuppet)
let m_lastVehicleAffiliation: Int32;

@addField(PlayerPuppet)
let m_currentDisguiseDetectionMultiplier: Float = 0.0;

@addField(PlayerPuppet)
let m_currentGeneralDetectionMultiplier: Float = 1.0;

@addField(PlayerPuppet)
let m_playerVehicleAffiliation: Int32;

@addField(PlayerPuppet)
let m_wantedFactsList: array<CName>;

@addField(PlayerPuppet)
let m_wantedFactIDList: array<Uint32>;

@addField(PlayerPuppet)
let m_consequenceFactsList: array<CName>;

@addField(PlayerPuppet)
let m_courierFactsList: array<CName>;

@addField(PlayerPuppet)
let m_retaliationFactsList: array<CName>;

@addField(PlayerPuppet)
let m_consequenceFactIDList: array<Uint32>;

@addField(PlayerPuppet)
let m_retaliationFactIDList: array<Uint32>;

@addField(PlayerPuppet)
let m_courierFactIDList: array<Uint32>;

@addField(PlayerPuppet)
let m_factionBehaviorMap: ref<inkIntHashMap>;

@addField(PlayerPuppet)
let m_factionDetectionMultiplierMap: ref<inkIntHashMap>;

@addField(PlayerPuppet)
let m_legsAttachmentSlotListener: ref<AttachmentSlotsScriptListener>;

@addField(PlayerPuppet)
let m_chestAttachmentSlotListener: ref<AttachmentSlotsScriptListener>;

@addField(PlayerPuppet)
let m_handsAttachmentSlotListener: ref<AttachmentSlotsScriptListener>;

@addField(PlayerPuppet)
let m_feetAttachmentSlotListener: ref<AttachmentSlotsScriptListener>;

@addField(PlayerPuppet)
let m_faceAttachmentSlotListener: ref<AttachmentSlotsScriptListener>;

@addField(PlayerPuppet)
let m_headAttachmentSlotListener: ref<AttachmentSlotsScriptListener>;

@addField(PlayerPuppet)
let m_currentDistrict: String;

@addField(PlayerPuppet)
let m_districtChangeListener: ref<CallbackHandle>;

@addField(PlayerPuppet)
let lastPos: Vector4;

@addMethod(NPCPuppet)
public final func GetAffiliationInt() -> Int32 {
  let affiliation: wref<Affiliation_Record> = TweakDBInterface.GetCharacterRecord(this.GetRecordID()).Affiliation();
  if !IsDefined(affiliation) {
    return -1;
  };
  return EnumInt(affiliation.Type());
}

@addMethod(PlayerPuppet)
protected cb func OnDistrictChange(district: String) -> Bool {
  // LogChannel(n"DEBUG", s"!!!! INSIDE Ondstrict change =====Current Location === \(district)");
  this.m_currentDistrict = district;
  this.UpdateLocationFactionBehavior();
}

@wrapMethod(PlayerPuppet)
private final func EnableUIBlackboardListener(enable: Bool) -> Void {
  wrappedMethod(enable);
  let uiBlackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(GetGameInstance()).Get(GetAllBlackboardDefs().UI_Map);
  if enable {
    this.m_districtChangeListener = uiBlackboard.RegisterListenerString(GetAllBlackboardDefs().UI_Map.currentLocationEnumName, this, n"OnDistrictChange");
  }
  else {
    uiBlackboard.UnregisterListenerString(GetAllBlackboardDefs().UI_Map.currentLocationEnumName, this.m_districtChangeListener);
    this.m_districtChangeListener = null;
  }
}


@addMethod(PlayerPuppet)
protected cb func GetClothReactionPreset(clothingItemID: ItemID) -> Int32 {
    let clothingItemTBID: TweakDBID;
    clothingItemTBID = ItemID.GetTDBID(clothingItemID);
    let clothingItemRecord: ref<Item_Record>;
    clothingItemRecord = TweakDBInterface.GetItemRecord(clothingItemTBID);
    let check: Int32 = 0;
    if (clothingItemRecord.GetTagsCount() > 0) {
        let tags: array<CName>;
        tags = clothingItemRecord.Tags();
        // LogChannel(n"DEBUG", s"YES!!!! TAGS list!!!! ====== \(tags)");

        for tag in tags {
          switch(tag) {
            case n"PositiveReaction":
              return 1;
            case n"AnnoyedReaction":
              return 2;
            case n"FearReaction":
              return 3;
            default:
          }
        }
    }
    return check;
}

@addMethod(PlayerPuppet)
protected cb func GetClothAffiliation(clothingItemID: ItemID) -> Int32 {
    let clothingItemTBID: TweakDBID;
    clothingItemTBID = ItemID.GetTDBID(clothingItemID);
    let clothingItemRecord: ref<Item_Record>;
    clothingItemRecord = TweakDBInterface.GetItemRecord(clothingItemTBID);
    let intermediateAff: Int32 = -1;
    if (clothingItemRecord.GetTagsCount() > 0) {
        let tags: array<CName>;
        tags = clothingItemRecord.Tags();
        // LogChannel(n"DEBUG", s"YES!!!! TAGS list!!!! \(tags)");
         
        for tag in tags {
            // LogChannel(n"DEBUG", s"YES!!!! TAGS!!!! \(this.IsBroke(clothingItemID))");
            if Equals(tag, n"Moxies") {
                // LogChannel(n"DEBUG", s"YES!!!! MOXIE DETECTED!!!! \(tag)");
                return 25;
            } else if Equals(tag, n"Arasaka") {
                // LogChannel(n"DEBUG", s"YES!!!! ARASAKA DETECTED!!!! \(tag)");
                return 3;
            } else if Equals(tag, n"TygerClaws") {
                // LogChannel(n"DEBUG", s"YES!!!! TYGER CLAWS DETECTED!!!! \(tag)");
                return 27;
            } else if Equals(tag, n"Valentinos") {
                // LogChannel(n"DEBUG", s"YES!!!! VALENTINOS DETECTED!!!! \(tag)");
                return 31;
            } else if Equals(tag, n"Maelstrom") {
                // LogChannel(n"DEBUG", s"YES!!!! MAELSTROM DETECTED!!!! \(tag)");
                return 10; // Example return value for Maelstrom
            } else if Equals(tag, n"VoodooBoys") {
                // LogChannel(n"DEBUG", s"YES!!!! VOODOO BOYS DETECTED!!!! \(tag)");
                return 32;
            } else if Equals(tag, n"NCPD") {
                // LogChannel(n"DEBUG", s"YES!!!! VOODOO BOYS DETECTED!!!! \(tag)");
                return 13; 
            } else if Equals(tag, n"Aldecaldos") {
                // LogChannel(n"DEBUG", s"YES!!!! VOODOO BOYS DETECTED!!!! \(tag)");
                return 1; 
            } else if Equals(tag, n"Scavengers") {
                // LogChannel(n"DEBUG", s"YES!!!! VOODOO BOYS DETECTED!!!! \(tag)");
                return 20; 
            } else if Equals(tag, n"KangTao") {
                // LogChannel(n"DEBUG", s"YES!!!! VOODOO BOYS DETECTED!!!! \(tag)");
                return 9; 
            }
            else if Equals(tag, n"Militech") {
                return 12; 
            }
            else if Equals(tag, n"Biotechnica") {
                return 5; 
            }
            else if Equals(tag, n"TraumaTeam") {
                return 26;
            }
            else if Equals(tag, n"Zetatech") {
                return 35;
            }
            else if Equals(tag, n"Military") {
                intermediateAff = 43;
            }
        }
    }
    return intermediateAff; // No affiliation detected
}

@addMethod(PlayerPuppet)
public final func UpdatePlayerVehicleAffiliation() -> Void {
    let vehicleObj: wref<VehicleObject>;
    let vehicleRecord: ref<Vehicle_Record>;
    VehicleComponent.GetVehicle(this.GetGame(), this, vehicleObj);

    let recordID: TweakDBID = vehicleObj.GetRecordID();
    let record: ref<Vehicle_Record> = TweakDBInterface.GetVehicleRecord(recordID);

    if record.VisualTagsContains(n"TheMox") {
      this.m_playerVehicleAffiliation = 25;
    }
    else if record.VisualTagsContains(n"TygerClaws") {
      this.m_playerVehicleAffiliation = 27;
    }
    else if record.VisualTagsContains(n"Valentinos") {
      this.m_playerVehicleAffiliation = 31;
    }
    else if record.VisualTagsContains(n"Maelstrom") {
      this.m_playerVehicleAffiliation = 10;
    }
    else if record.VisualTagsContains(n"NCPD") {
      this.m_playerVehicleAffiliation = 13;
    }
    else if record.VisualTagsContains(n"Aldecaldos") {
      this.m_playerVehicleAffiliation = 1;
    }
    else if record.VisualTagsContains(n"KangTao") {
      this.m_playerVehicleAffiliation = 9;
    }
    else if record.VisualTagsContains(n"Militech") {
      this.m_playerVehicleAffiliation = 12;
    }
    else if record.VisualTagsContains(n"BorderPatrol") {
      this.m_playerVehicleAffiliation = 13;
    }
    else if record.VisualTagsContains(n"KurtzMilitia") {
      this.m_playerVehicleAffiliation = 4;
    }
    else if record.VisualTagsContains(n"Arasaka") {
      this.m_playerVehicleAffiliation = 3;
    }
    else if record.VisualTagsContains(n"SixthStreet") {
      this.m_playerVehicleAffiliation = 4;
    }
    else {
      this.m_playerVehicleAffiliation = -1; // No affiliation detected
    }
}

@addMethod(PlayerPuppet)
protected cb func UpdatePlayerBrokeStatus() -> Void {
    let headItemID: ItemID = EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.Head);
    let outerChestItemID: ItemID = EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.OuterChest);
    let innerChestItemID: ItemID = EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.InnerChest);
    let legsItemID: ItemID = EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.Legs);
    
    let clothingItemIDs: array<ItemID> = [
        headItemID,
        outerChestItemID,
        innerChestItemID,
        legsItemID
    ];

    let isBroke: Bool = false;
    let hasRichTag: Bool = false;

    for clothingItemID in clothingItemIDs {
        let clothingItemTBID: TweakDBID = ItemID.GetTDBID(clothingItemID);
        let clothingItemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(clothingItemTBID);

        if IsDefined(clothingItemRecord) && clothingItemRecord.GetTagsCount() > 0 {
            let tags: array<CName> = clothingItemRecord.Tags();

            for tag in tags {
                if Equals(tag, n"Rich") || Equals(tag, n"Stylish") || Equals(tag, n"Formal") || Equals(tag, n"Corpo") || Equals(tag, n"Military")  {
                    // LogChannel(n"DEBUG", s"Item \(clothingItemID) is considered rich with tag: \(tag)");

                    hasRichTag = true;
                } else if Equals(tag, n"Poor") {
                    // LogChannel(n"DEBUG", s"Item \(clothingItemID) is considered poor with tag: \(tag)");

                    isBroke = true;
                }
            }
        }
    }

    // Player is considered broke only if at least one item has the "Poor" tag or no item has the rich/military/formal tags
    this.m_isPlayerBroke = isBroke || !hasRichTag;

    // LogChannel(n"DEBUG", s"YOU ARE BROKE?????? LETS SEE() ====> \(this.m_isPlayerBroke)");

}

@addMethod(PlayerPuppet)
protected cb func PrintSlotItem() -> Void {
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let slotID: TweakDBID = t"AttachmentSlots.Head";
  let itemIDTest: ItemID = transactionSystem.GetItemInSlot(this, slotID).GetItemID();
  LogChannel(n"DEBUG", s"============================================");
  LogChannel(n"DEBUG", s"HELLOOOOOO!!!!!!!!!! isvalid?====\(ItemID.IsValid(itemIDTest))");
}

@addMethod(PlayerPuppet)
protected cb func UpdatePlayerClothAffiliation() -> Void {
    let detectedAffiliation: Int32 = -1; // Default to no affiliation
    let detectedReactionPreset: Int32 = 0;
    let CWAffiliation: Int32 = -1;
    if StrContains(TDBID.ToStringDEBUG(ItemID.GetTDBID(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.HandsCW))), "Yakuza") {
      CWAffiliation = 27;
      // LogChannel(n"DEBUG", s"======================================== !!!!!! YESSSSS GET CYBERWARE => \(TDBID.ToStringDEBUG(ItemID.GetTDBID(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.HandsCW))))");
    }
    if PlayerPuppet.isEqExInstalled() && ((!this.m_isModSettingsInstalled) || (this.m_responsiveNPCModSettings.isEqExEnabled && this.m_isModSettingsInstalled)) {
      let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());

      // LogChannel(n"DEBUG", s"In UpdatePlayerClothAffiliation! Player Cloth aff === \(this.m_playerClothAffiliation) ANNNDDDDD outfit head?????======= \(ItemID.IsValid(GameInstance.GetTransactionSystem(this.GetGame()).GetActiveItemInSlot(this, t"OutfitSlots.Head"))) and \(ItemID.IsValid(GameInstance.GetTransactionSystem(this.GetGame()).GetActiveItemInSlot(this, t"AttachmentSlots.Feet")))");


      let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
      let itemIDs: array<ItemID> = [];

      // List of all slot names from the OutfitSlots function
      let slotNames: array<String> = [
          "OutfitSlots.Head",
          "OutfitSlots.Balaclava",
          "OutfitSlots.Mask",
          "OutfitSlots.Glasses",
          "OutfitSlots.Eyes",
          "OutfitSlots.EyeLeft",
          "OutfitSlots.EyeRight",
          "OutfitSlots.Wreath",
          "OutfitSlots.EarLeft",
          "OutfitSlots.EarRight",
          "OutfitSlots.Neckwear",
          "OutfitSlots.NecklaceTight",
          "OutfitSlots.NecklaceShort",
          "OutfitSlots.NecklaceLong",
          "OutfitSlots.TorsoUnder",
          "OutfitSlots.TorsoInner",
          "OutfitSlots.TorsoMiddle",
          "OutfitSlots.TorsoOuter",
          "OutfitSlots.TorsoAux",
          "OutfitSlots.Back",
          "OutfitSlots.Waist",
          "OutfitSlots.ShoulderLeft",
          "OutfitSlots.ShoulderRight",
          "OutfitSlots.ElbowLeft",
          "OutfitSlots.ElbowRight",
          "OutfitSlots.WristLeft",
          "OutfitSlots.WristRight",
          "OutfitSlots.Hands",
          "OutfitSlots.HandLeft",
          "OutfitSlots.HandRight",
          "OutfitSlots.HandPropLeft",
          "OutfitSlots.HandPropRight",
          "OutfitSlots.FingersLeft",
          "OutfitSlots.FingersRight",
          "OutfitSlots.FingernailsLeft",
          "OutfitSlots.FingernailsRight",
          "OutfitSlots.LegsInner",
          "OutfitSlots.LegsMiddle",
          "OutfitSlots.LegsOuter",
          "OutfitSlots.ThighLeft",
          "OutfitSlots.ThighRight",
          "OutfitSlots.KneeLeft",
          "OutfitSlots.KneeRight",
          "OutfitSlots.AnkleLeft",
          "OutfitSlots.AnkleRight",
          "OutfitSlots.Feet",
          "OutfitSlots.ToesLeft",
          "OutfitSlots.ToesRight",
          "OutfitSlots.ToenailsLeft",
          "OutfitSlots.ToenailsRight",
          "OutfitSlots.BodyUnder",
          "OutfitSlots.BodyInner",
          "OutfitSlots.BodyMiddle",
          "OutfitSlots.BodyOuter",
          "AttachmentSlots.Torso",
          "AttachmentSlots.Legs"
      ];

      // Retrieve and store all ItemIDs
      let slotID: TweakDBID;
      let itemID: ItemID;
      for slotName in slotNames {
          slotID = TDBID.Create(slotName);
          itemID = transactionSystem.GetItemInSlot(this, slotID).GetItemID();
          if ItemID.IsValid(itemID) {
            ArrayPush(itemIDs, itemID);
          }
      }

      if ArraySize(itemIDs) == 0 {
        detectedAffiliation = 69; // naked
        // LogChannel(n"DEBUG", s" YES - NAKED!!!!!!!!!!!!!!!!!!!!!");

        // check if user has mods to hide underwear
        if EquipmentSystem.GetData(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject()).ShouldUnderwearBeVisibleInSet() { 
        // LogChannel(n"DEBUG", s" YES - underwear NOT visible");
          this.m_playerBuckNaked = true;
        }
      }
      else {
        // Collect affiliations using the itemIDs
        let affiliations: array<Int32>;
        let reactionPresets: array<Int32>;
        for itemID in itemIDs {
            let affiliation: Int32 = this.GetClothAffiliation(itemID);
            if (affiliation != -1) {
              ArrayPush(affiliations, affiliation);
            }
            let reactionPreset: Int32 = this.GetClothReactionPreset(itemID);

            if reactionPreset != 0 {
              // LogChannel(n"DEBUG", s" !!!!!!!!!!!!!!!!!!!!!!!!AHHHHHHHHHHHHHHHHpushing!!! \(reactionPreset)");
              ArrayPush(reactionPresets, reactionPreset);
            }
        }

        let affiliationCounts: array<Int32>;
        ArrayResize(affiliationCounts, 50);

        // Count occurrences of each affiliation
        for affiliation in affiliations {
            affiliationCounts[affiliation] += 1;
        }

        // Determine if there is a dominant affiliation
        let maxCount: Int32 = 0;
        let i: Int32 = 1;
        while( i < ArraySize(affiliationCounts)) {
            if (affiliationCounts[i] > maxCount) {
                maxCount = affiliationCounts[i];
                detectedAffiliation = i;
            } else if (affiliationCounts[i] == maxCount && maxCount != 0) {
                detectedAffiliation = -1; // If there is a tie, reset to no affiliation
            }
            i += 1;
        }
        this.m_affiliatedEqExSlotCount = maxCount;

        // check reaction tags
        // LogChannel(n"DEBUG", s" array size check!!! ==== \(ArraySize(reactionPresets))");

        if ArraySize(reactionPresets) != 0 {
          let reactionPresetCounts: array<Int32>;
          ArrayResize(reactionPresetCounts, 4);

          for reactionPreset in reactionPresets {
              reactionPresetCounts[reactionPreset] += 1;
          }

          i = 0;
          maxCount = 0;

          while( i < ArraySize(reactionPresetCounts)) {
              if (reactionPresetCounts[i] > maxCount) {
                  maxCount = reactionPresetCounts[i];
                  detectedReactionPreset = i;
              } else if (reactionPresetCounts[i] == maxCount && maxCount != 0) {
                  detectedReactionPreset = 0; // If there is a tie, reset to no affiliation
              }
              i += 1;
          }
        // LogChannel(n"DEBUG", s" ===========================FINAL!!!!!!!!!!! check!!! ==== \(detectedReactionPreset))");

          this.m_currentClothingReactionPreset = detectedReactionPreset;
        }
        else {
          this.m_currentClothingReactionPreset = 0;
        }
      }
    }
    else {
      // eq-ex not installed
      if ItemID.IsValid(EquipmentSystem.GetData(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject()).GetActiveItem(gamedataEquipmentArea.Legs)) || ItemID.IsValid(EquipmentSystem.GetData(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject()).GetActiveItem(gamedataEquipmentArea.OuterChest)) || ItemID.IsValid(EquipmentSystem.GetData(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject()).GetActiveItem(gamedataEquipmentArea.InnerChest)) || ItemID.IsValid(EquipmentSystem.GetData(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject()).GetActiveItem(gamedataEquipmentArea.Outfit)) {
        // LogChannel(n"DEBUG", s" YES - NOT NOT NOT NAKED!!!!!!!!!!!!!!!!!!!!!");
        let headAffiliation: Int32 = this.GetClothAffiliation(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.Head));
        let faceAffiliation: Int32 = this.GetClothAffiliation(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.Face));
        let outerChestAffiliation: Int32 = this.GetClothAffiliation(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.OuterChest));
        let innerChestAffiliation: Int32 = this.GetClothAffiliation(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.InnerChest));
        let legsAffiliation: Int32 = this.GetClothAffiliation(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.Legs));

        // Collect affiliations
        let affiliations: array<Int32>;
        ArrayPush(affiliations, headAffiliation);
        ArrayPush(affiliations, faceAffiliation);
        ArrayPush(affiliations, outerChestAffiliation);
        ArrayPush(affiliations, innerChestAffiliation);
        ArrayPush(affiliations, legsAffiliation);
        ArrayPush(affiliations, CWAffiliation);

        // Determine final affiliation
        let affiliationCounts: array<Int32>;
        ArrayResize(affiliationCounts, 50);

        // Initialize counts
        let i = 0;
        while i < ArraySize(affiliationCounts) {
            affiliationCounts[i] = 0;
            i += 1;
        }

        // Count occurrences of each affiliation
        for affiliation in affiliations {
            if affiliation != -1 {
                affiliationCounts[affiliation] += 1;
            }
        }

        // Determine if there is a dominant affiliation
        let maxCount: Int32 = 0;

        i = 1;
        while i < ArraySize(affiliationCounts) {
            if affiliationCounts[i] > maxCount {
                maxCount = affiliationCounts[i];
                detectedAffiliation = i;
            } else if affiliationCounts[i] == maxCount && maxCount != 0 {
                // If there is a tie, reset to no affiliation
                detectedAffiliation = -1;
            }
            i += 1;
        }

        // return final cloth affiliation string
        // LogChannel(n"DEBUG", s"========================================");
        // LogChannel(n"DEBUG", s"in GetPlayerClothAffiliation ---- Cloth affiliation changed! New affiliation: NUMBER =========== \(detectedAffiliation)");
        // LogChannel(n"DEBUG", s"========================================");
      }
      else {
        detectedAffiliation = 69; // naked
        // LogChannel(n"DEBUG", s" YES - NAKED!!!!!!!!!!!!!!!!!!!!!");
        // check if user has mods to hide underwear
        if EquipmentSystem.GetData(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject()).ShouldUnderwearBeVisibleInSet() { 
          // LogChannel(n"DEBUG", s" YES - underwear NOT visible");
          this.m_playerBuckNaked = true;
        }
      }
    }

    // return final cloth affiliation string
    // LogChannel(n"DEBUG", s"========================================");
    // LogChannel(n"DEBUG", s"in GetPlayerClothAffiliation ---- Cloth affiliation changed! New affiliation: NUMBER =========== \(detectedAffiliation)");
    // LogChannel(n"DEBUG", s"========================================");
    this.m_playerClothAffiliation = detectedAffiliation;
    this.UpdateDisguisePlayerDetectionMultiplier();
    this.UpdateGeneralDetectionMultiplier();
    this.UpdatePlayerClothAffiliationMap();
}

// it says cloth but i also do vehicle aff check here... or just rename the method maybe refactor this one day
@addMethod(PlayerPuppet)
protected cb func UpdatePlayerClothAffiliationMap() -> Void {
  this.m_playerAllyAffiliationMap.Clear();
  this.m_playerRivalAffiliationMap.Clear();


  if this.m_playerClothAffiliation == 1 || this.m_playerVehicleAffiliation == 1  {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(33), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(20), 1);
  }
  else if this.m_playerClothAffiliation == 2 || this.m_playerVehicleAffiliation == 2 {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(32), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
  }
  else if this.m_playerClothAffiliation == 3 || this.m_playerVehicleAffiliation == 3 {
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(27), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(5), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(26), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(9), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(12), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(15), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(35), 1);
  }
  else if this.m_playerClothAffiliation == 5 || this.m_playerVehicleAffiliation == 5 {
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(3), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(26), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(9), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(12), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(15), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(35), 1);

  }
  else if this.m_playerClothAffiliation == 9 || this.m_playerVehicleAffiliation == 9 {
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(3), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(26), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(5), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(12), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(15), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(35), 1);

  }
  else if this.m_playerClothAffiliation == 12 || this.m_playerVehicleAffiliation == 12 {
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(3), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(26), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(5), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(9), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(15), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(35), 1);

  }
  else if this.m_playerClothAffiliation == 13 || this.m_playerVehicleAffiliation == 13 {
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(3), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(26), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(5), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(9), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(12), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(15), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(35), 1);

    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(2), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(10), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(4), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(20), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(22), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(25), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(27), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(31), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(32), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(33), 1);
    // LogChannel(n"DEBUG", s"13 INSERRTED NCPD!!!!!!!!!!!!");

  }
  else if this.m_playerClothAffiliation == 15 || this.m_playerVehicleAffiliation == 15 {
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(3), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(26), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(5), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(9), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(12), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(35), 1);
  }
  else if this.m_playerClothAffiliation == 26 || this.m_playerVehicleAffiliation == 26 {
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(3), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(15), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(5), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(9), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(12), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(35), 1);

  }
  else if this.m_playerClothAffiliation == 35 || this.m_playerVehicleAffiliation == 35 {
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(3), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(15), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(5), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(9), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(12), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(26), 1);

  }
  else if this.m_playerClothAffiliation == 4 || this.m_playerVehicleAffiliation == 4 {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(3), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(15), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(5), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(9), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(12), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(26), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(35), 1);
  }
  else if this.m_playerClothAffiliation == 10 || this.m_playerVehicleAffiliation == 10 {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(27), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(25), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
  }
  else if this.m_playerClothAffiliation == 20 || this.m_playerVehicleAffiliation == 20 {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(1), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
  }
  else if this.m_playerClothAffiliation == 22 || this.m_playerVehicleAffiliation == 22 {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(31), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(14), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
  }
  else if this.m_playerClothAffiliation == 25 || this.m_playerVehicleAffiliation == 25 {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(27), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(10), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
  }
  else if this.m_playerClothAffiliation == 27 || this.m_playerVehicleAffiliation == 27 {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(25), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(10), 1);
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(3), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
  }
  else if this.m_playerClothAffiliation == 31 || this.m_playerVehicleAffiliation == 31 {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(22), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(10), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
  }
  else if this.m_playerClothAffiliation == 32 || this.m_playerVehicleAffiliation == 32 {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(15), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(2), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
  }
  else if this.m_playerClothAffiliation == 33 || this.m_playerVehicleAffiliation == 33 {
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(1), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
    this.m_playerRivalAffiliationMap.Insert(Cast<Uint64>(13), 1);
  }
  else if this.m_playerClothAffiliation == 14 || this.m_playerVehicleAffiliation == 14 {
    this.m_playerAllyAffiliationMap.Insert(Cast<Uint64>(22), 1);
  }
}

@addMethod(PlayerPuppet)
protected cb func UpdateGeneralDetectionMultiplier() -> Void {
  let detectionMultiplier: Float = 0.0;
  let questsSystem: ref<QuestsSystem>;
  questsSystem = GameInstance.GetQuestsSystem(this.GetGame());
  let checkWantedFact = 0;
  if IsDefined(questsSystem) {
    checkWantedFact = questsSystem.GetFact(n"wanted_level");
  }

  if ((!this.m_isModSettingsInstalled) || (this.m_responsiveNPCModSettings.isVehicleDisguiseSystemEnabled && this.m_isModSettingsInstalled)) {
    if IsDefined(this.m_mountedVehicle) {
      if this.m_mountedVehicle.GetVehicleComponent().GetIsVehicleVisualCustomizationEnabled() {
        if this.m_vehicleCrystalCoatState == 1 {
          if checkWantedFact > 0 && checkWantedFact <= 3 {
            detectionMultiplier -= 0.75;
          }
          else if checkWantedFact == 4 {
            detectionMultiplier -= 0.50;
            // LogChannel(n"DEBUG", s"in UPDATE detection multiplier == vehicle crystal coat SET 1 m_mountedVehicle!!!!  detection multiplier set == \(detectionMultiplier)");
          }
        }
        else if this.m_vehicleCrystalCoatState == 2 {
          if checkWantedFact > 0 {
            detectionMultiplier += 1.5;
            // LogChannel(n"DEBUG", s"in UPDATE detection multiplier == vehicle crystal coat SET 1 m_mountedVehicle!!!!  detection multiplier set == \(detectionMultiplier)");
          }
          // LogChannel(n"DEBUG", s"in UPDATE detection multiplier == NORMAL DISABLED!!!!!!!!! vehicle m_mountedVehicle!!!!  detection multiplier set == \(detectionMultiplier)");
        }
        else if this.m_vehicleCrystalCoatState == 3 {
          if checkWantedFact > 0 && checkWantedFact <= 3 {
            detectionMultiplier += 3.0;
            // LogChannel(n"DEBUG", s"in UPDATE detection multiplier == vehicle crystal coat SET 1 m_mountedVehicle!!!!  detection multiplier set == \(detectionMultiplier)");
          }
          else if checkWantedFact == 4 {
            detectionMultiplier += 5.0;
          } 
          // LogChannel(n"DEBUG", s"in UPDATE detection multiplier == DAMAGE DISABLED!!!!!!!!! vehicle m_mountedVehicle!!!!  detection multiplier set == \(detectionMultiplier)");
        }
      }
      this.m_currentCrystalCoatDetectionMultiplier = detectionMultiplier;
    }
  }
  if ((!this.m_isModSettingsInstalled) || (this.m_responsiveNPCModSettings.isVehicleReactionEnabled && this.m_isModSettingsInstalled)) {
    if IsDefined(this.m_mountedVehicle) {
        if this.m_hasVehicleCrystalDome {
        detectionMultiplier -= 0.25;
        if checkWantedFact >= 2 {
          detectionMultiplier += 0.1;
          if checkWantedFact >= 4 {
            detectionMultiplier += 0.1;
          }
        }
        // LogChannel(n"DEBUG", s"in UPDATE detection multiplier == vehicle HAS CRYSTAL DOME m_mountedVehicle!!!!  detection multiplier set == \(detectionMultiplier)");
      }
      if this.m_inMountedWeaponVehicle {
        detectionMultiplier += 0.15;
        if checkWantedFact >= 2 {
          detectionMultiplier += 0.1;
          if checkWantedFact >= 4 {
            detectionMultiplier += 0.1;
          }
        }
      }
    }
  }
  if this.m_playerClothAffiliation == 69 {
    detectionMultiplier += 1.5;
    if checkWantedFact > 0 {
      detectionMultiplier += 0.2;
    }
  }
  if this.m_playerClothAffiliation == 43 {
    detectionMultiplier += 0.05;
  }
  // if this.m_playerClothAffiliation == 13 {
  //   detectionMultiplier += 0.15;
  // }

  this.m_currentGeneralDetectionMultiplier = detectionMultiplier;
}


@addMethod(PlayerPuppet)
protected cb func UpdateDisguisePlayerDetectionMultiplier() -> Void {
    let detectionMultiplier: Float = 0.0;

    if ((!this.m_isModSettingsInstalled) || (this.m_responsiveNPCModSettings.isClothingDisguiseSystemEnabled && this.m_isModSettingsInstalled)) {
      if this.m_playerClothAffiliation != -1 {
          if !PlayerPuppet.isEqExInstalled() {
            let headAffiliation: Int32 = this.GetClothAffiliation(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.Head));
            let faceAffiliation: Int32 = this.GetClothAffiliation(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.Face));
            let outerChestAffiliation: Int32 = this.GetClothAffiliation(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.OuterChest));
            let innerChestAffiliation: Int32 = this.GetClothAffiliation(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.InnerChest));
            let legsAffiliation: Int32 = this.GetClothAffiliation(EquipmentSystem.GetData(this).GetActiveItem(gamedataEquipmentArea.Legs));

            if headAffiliation == this.m_playerClothAffiliation {
                detectionMultiplier += 0.15;
            }
            if faceAffiliation == this.m_playerClothAffiliation {
                detectionMultiplier += 0.10;
            }
            if outerChestAffiliation == this.m_playerClothAffiliation {
                detectionMultiplier += 0.125;
            }
            if innerChestAffiliation == this.m_playerClothAffiliation {
                detectionMultiplier += 0.125;
            }
            if legsAffiliation == this.m_playerClothAffiliation {
                detectionMultiplier += 0.10;
            }
          }
          else {
            // eq ex is installed
            // for eq-ex slots, give a flat 10% for each slot for now. We will weight it properly soon

            // todo add modsettings here. Why? idk. nexus users want it
            // todo fix the fact that vanilla slots still wont be considered.....?? if eqex is disabled
            if ((!this.m_isModSettingsInstalled) || (this.m_responsiveNPCModSettings.isEqExEnabled && this.m_isModSettingsInstalled)) {
              if ((this.m_affiliatedEqExSlotCount > 0 && this.m_affiliatedEqExSlotCount <= 6)) && this.m_playerClothAffiliation != -1 {
                  detectionMultiplier += 0.1 * Cast<Float>(this.m_affiliatedEqExSlotCount);
              }
              else if this.m_affiliatedEqExSlotCount == 0 {
                // will this happen? i dont think so
                  detectionMultiplier = 1.0;
              }
              else {
                  detectionMultiplier += 0.6;
              }
            }
          }
        }
    }

    if ((!this.m_isModSettingsInstalled) || (this.m_responsiveNPCModSettings.isVehicleDisguiseSystemEnabled && this.m_isModSettingsInstalled)) {
      if IsDefined(this.m_mountedVehicle) {
        if this.m_playerVehicleAffiliation != -1 {
          detectionMultiplier += 0.30;
        // LogChannel(n"DEBUG", s"in UPDATE detection multiplier == vehicle set!!!! \(detectionMultiplier) for aff == \(this.m_playerVehicleAffiliation)");
      }
    }
    }

    this.m_currentDisguiseDetectionMultiplier = detectionMultiplier;
}

@addMethod(PlayerPuppet)
private final func RegisterToConsequenceFacts() -> Void {
    let i: Int32 = 0;

    while i < ArraySize(this.m_wantedFactsList) {
        let factValue: Int32 = GameInstance.GetQuestsSystem(this.GetGame()).GetFact(this.m_wantedFactsList[i]);
        this.m_wantedFactIDList[i] = GameInstance.GetQuestsSystem(this.GetGame()).RegisterListener(this.m_wantedFactsList[i], this, n"OnWantedStateChanged");
        i += 1;
    }
    i = 0;

    if ((this.m_isModSettingsInstalled && this.m_responsiveNPCModSettings.isQuestRetaliationEnabled) || !this.m_isModSettingsInstalled) {
      while i < ArraySize(this.m_consequenceFactsList) {
          let factValue: Int32 = GameInstance.GetQuestsSystem(this.GetGame()).GetFact(this.m_consequenceFactsList[i]);
          this.m_consequenceFactIDList[i] = GameInstance.GetQuestsSystem(this.GetGame()).RegisterListener(this.m_consequenceFactsList[i], this, n"OnConsequenceFactChanged");
          i += 1;
      }
      i = 0;
      while i < ArraySize(this.m_retaliationFactsList) {
          let factValue: Int32 = GameInstance.GetQuestsSystem(this.GetGame()).GetFact(this.m_retaliationFactsList[i]);
          this.m_retaliationFactIDList[i] = GameInstance.GetQuestsSystem(this.GetGame()).RegisterListener(this.m_retaliationFactsList[i], this, n"OnRetaliationFactChanged");
          i += 1;
      }
      i = 0;
    }

    while i < ArraySize(this.m_courierFactsList) {
        let factValue: Int32 = GameInstance.GetQuestsSystem(this.GetGame()).GetFact(this.m_courierFactsList[i]);
        this.m_courierFactIDList[i] = GameInstance.GetQuestsSystem(this.GetGame()).RegisterListener(this.m_courierFactsList[i], this, n"OnCourierFactChanged");
        i += 1;
    }
    i = 0;

}

@addMethod(PlayerPuppet)
private final func UnRegisterToConsequenceFacts() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_wantedFactsList) {
        let factValue: Int32 = GameInstance.GetQuestsSystem(this.GetGame()).GetFact(this.m_wantedFactsList[i]);
        GameInstance.GetQuestsSystem(this.GetGame()).UnregisterListener(this.m_wantedFactsList[i], this.m_wantedFactIDList[i]);
        i += 1;
    }
    i = 0;

    if ((this.m_isModSettingsInstalled && this.m_responsiveNPCModSettings.isQuestRetaliationEnabled) || !this.m_isModSettingsInstalled) {
      while i < ArraySize(this.m_consequenceFactsList) {
          let factValue: Int32 = GameInstance.GetQuestsSystem(this.GetGame()).GetFact(this.m_consequenceFactsList[i]);
          GameInstance.GetQuestsSystem(this.GetGame()).UnregisterListener(this.m_consequenceFactsList[i], this.m_consequenceFactIDList[i]);
          i += 1;
      }
      i = 0;
      while i < ArraySize(this.m_courierFactsList) {
          let factValue: Int32 = GameInstance.GetQuestsSystem(this.GetGame()).GetFact(this.m_courierFactsList[i]);
          GameInstance.GetQuestsSystem(this.GetGame()).UnregisterListener(this.m_courierFactsList[i], this.m_courierFactIDList[i]);
          i += 1;
      }
      i = 0;
    }

    while i < ArraySize(this.m_retaliationFactsList) {
        let factValue: Int32 = GameInstance.GetQuestsSystem(this.GetGame()).GetFact(this.m_retaliationFactsList[i]);
        GameInstance.GetQuestsSystem(this.GetGame()).UnregisterListener(this.m_retaliationFactsList[i], this.m_retaliationFactIDList[i]);
        i += 1;
    }
}

@wrapMethod(PlayerPuppet)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  wrappedMethod(evt);
  if IsDefined(this.m_mountedVehicle) {
    this.UpdatePlayerVehicleAffiliation();
    this.UpdateFactionBehavior();
    this.UpdateDisguisePlayerDetectionMultiplier();
    this.UpdateGeneralDetectionMultiplier();
    this.UpdatePlayerClothAffiliationMap();
  }
}

@wrapMethod(PlayerPuppet)
protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
  if IsDefined(this.m_mountedVehicle) {
    this.m_playerVehicleAffiliation = -1;
    this.UpdateFactionBehavior();
    this.UpdateDisguisePlayerDetectionMultiplier();
    this.UpdateGeneralDetectionMultiplier();
    this.UpdatePlayerClothAffiliationMap();
  }
  wrappedMethod(evt);
}

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  wrappedMethod();
  this.m_consequenceFactIDList = [];
  this.m_courierFactIDList = [];
  this.m_retaliationFactIDList = [];
  this.m_factionBehaviorMap = new inkIntHashMap();
  this.m_playerRivalAffiliationMap = new inkIntHashMap();
  this.m_playerAllyAffiliationMap = new inkIntHashMap();
  this.m_currentClothingReactionPreset = 0;
  this.m_wantedFactsList = [n"wanted_level"];
  this.m_courierFactsList = [
    n"sa_ep1_courier_enemy_valentinos", n"sa_ep1_courier_enemy_tygers", n"sa_ep1_courier_enemy_animals", n"sa_ep1_courier_enemy_6thstreet", n"sa_ep1_courier_enemy_voodoo",  n"sa_ep1_courier_enemy_dogtownmilitia",  n"sa_ep1_courier_enemy_militech", n"sa_ep1_courier_enemy_kangtao", n"sa_ep1_courier_enemy_animals", n"sa_ep1_courier_enemy_maelstrom", n"sa_ep1_courier_enemy_scavengers",   n"sa_ep1_courier_enemy_tygers"
  ];
  this.m_retaliationFactsList = [
    n"sts_valentinos_retaliation", n"sts_6thstreet_retaliation", n"sts_tygerclaws_retaliation",
    n"sts_animals_retaliation", n"sts_wraiths_retaliation", n"sts_maelstroms_retaliation", n"sts_valentinos_retaliation" 
  ];
  this.m_consequenceFactsList = [
      n"mws_wat_10_retaliation",
      n"ina_02_gang_retaliation", n"ina_03_gang_retaliation", n"dtn_03_gang_retaliation",
      n"gle_04_gang_retaliation", n"rey_02_gang_retaliation", n"rcr_03_gang_retaliation",
      n"rcr_04_gang_retaliation", n"hil_07_gang_retaliation", n"jpn_12_gang_retaliation",
      n"nid_05_gang_retaliation", n"gle_04_finished", n"gle_04_drink_with_bouncer", n"gle_04_data_is_stolen", n"gle_04_gang_retaliation", n"sq006_maelstrom_ambush_player_combat", n"rey_01_gustavo_orta_dead", n"rey_01_finished", 
      n"spr_01_jose_luise_killed", n"rey_08_karubo_dead", n"rey_09_finished", n"rey_08_finished", n"q112_done",
      n"q302_detected", n"sts_ep1_10_dodger_dead", n"mq301_03_frame_jurij", n"sts_ep1_10_kill_count",
      n"sq027_raffen_attack_defeated", n"ina_04_all_guard_dead", n"ina_04_finished", n"ina_05_optional_failed", n"ina_05_militech_killed",
      n"ina_05_finished", n"arr_06_first_wave_kang_tao_killed",
      n"dtn_04_joanne_koch_dead", n"sts_ep1_07_any_agent_dead", n"q005_done", n"ina_02_big_pete_dead", n"ina_02_finished",
      n"ina_03_antenna_sbotaged", n"ina_03_gang_chase", n"ina_06_all_enemies_killed", n"ina_06_finished", n"sq004_rafen_alldead", 
      n"sq004_done", n"q103_ghost_town_detected", n"q103_helped_panam", n"sts_ep1_12_milko_dead", 
      n"sts_ep1_12_finished", n"q110_placide_dead", n"q110_done", n"q110_voodoo_queen_dead", 
      n"kab_06_blake_croyle_dead", n"kab_06_finished", n"wwd_05_logan_dead", n"wwd_05_finished", n"wwd_05_done", n"q110_var_mall_most_animals_killed",
      n"q110_var_mall_many_animals_killed", n"mq303_02_any_scav_dead", n"mq306_combat", n"mq306_scavs_attacked",
      n"sts_ep1_01_nika_alive", n"sts_ep1_01_finished", n"kab_05_player_detected", n"kab_05_finished", n"mq036_done", 
      n"mq036_items_retrieved", n"sts_ep1_04_alarm_raised", n"sts_ep1_04_done", n"sts_ep1_04_finished",
      n"mq008_telem_combat", n"mq008_done", n"rcr_03_6th_street_noticed", n"rcr_03_finished", n"gle_06_kill_all", n"gle_06_alarm", 
      n"gle_06_finished", n"rcr_04_gang_chase", n"rcr_04_finished", n"arr_11_lucius_dead", 
      n"arr_11_finished", n"q003_brick_dead", n"q003_royce_dead", n"q003_dumdum_dead", n"sq011_patricia_dead", n"sq006_maelstrom_ambush_reinforcements",
      n"kab_02_patient_dead", n"kab_02_finished", n"nid_05_gang_retaliation", n"sts_wat_kab_nid_05_combat", n"nid_05_finished", 
      n"kab_106_recording_stolen", n"kab_106_alarm_rised", n"sq026_side_judy", n"sq026_maiko_dead",
      n"sq026_side_maiko", n"lch_03_optional_alarm", n"sts_wat_nid_02_combat_triggered", n"nid_02_finished", n"lch_01_gang_retaliation",
      n"lch_01_finished", n"jpn_03_stealth_fail", n"jpn_02_all_killed", n"kab_07_jotaro_killed", n"kab_07_enemies_alerted",
      n"nid_03_detected", n"nid_03_finished", n"lch_05_blackmaill", n"lch_05_finished", n"hil_07_comabt", 
      n"jpn_12a_finished", n"kab_107_taki_kenmochi_dead", n"lch_06_finished", n"rey_01_kill_gustavo", 
      n"sts_hey_spr_03_combat_triggered", n"rey_08_alarm_on", n"gle_04_gang_chase",
      n"rey_02_gang_chase",
      n"rey_02_finished",
      n"lch_01_gang_chase",
      n"kab_02_gang_chase",
      n"ma_nid_06_finished",
      n"ma_nid_02_finished",
      n"sq011_patricia_combat_path",
      n"sq011_royce_combat_path",
      n"q003_combat_scenario",
      n"v_offends_boss",
      n"arr_11_gang_chase",
      n"ma_pac_cvi_12_finished",
      n"ma_nid_01_finished",
      n"ma_wat_lch_04_finished",
      n"dtn_03_gang_chase",
      n"dtn_03_in_combat",
      n"dtn_03_finished",
      n"ina_02_combat_triggered",
      n"ina_03_finished",
      n"arr_06_combat_kang_tao",
      n"arr_06_second_wave_kang_tao_killed",
      n"arr_06_karl_killed",
      n"ina_04_combat_started",
      n"kab_01_combat_started",
      n"kab_01_done"
  ];
  this.RegisterToConsequenceFacts();
  this.m_playerVehicleAffiliation = -1;
  this.m_isAlmostCyberpsycho = false;
}

@wrapMethod(PlayerPuppet)
private final func PlayerDetachedCallback(playerPuppet: ref<GameObject>) -> Void {
  if playerPuppet == this {
    this.UnRegisterToConsequenceFacts();
    GameInstance.GetTransactionSystem(this.GetGame()).UnregisterAttachmentSlotListener(this, this.m_legsAttachmentSlotListener);
    GameInstance.GetTransactionSystem(this.GetGame()).UnregisterAttachmentSlotListener(this, this.m_chestAttachmentSlotListener);
    GameInstance.GetTransactionSystem(this.GetGame()).UnregisterAttachmentSlotListener(this, this.m_handsAttachmentSlotListener);
    GameInstance.GetTransactionSystem(this.GetGame()).UnregisterAttachmentSlotListener(this, this.m_feetAttachmentSlotListener);
    GameInstance.GetTransactionSystem(this.GetGame()).UnregisterAttachmentSlotListener(this, this.m_faceAttachmentSlotListener);
    GameInstance.GetTransactionSystem(this.GetGame()).UnregisterAttachmentSlotListener(this, this.m_headAttachmentSlotListener);
  }
  wrappedMethod(playerPuppet);
}

@wrapMethod(PlayerPuppet)
protected cb func OnItemAddedToSlot(evt: ref<ItemAddedToSlot>) -> Bool {
  let itemType: gamedataItemCategory;
  let itemID: ItemID = evt.GetItemID();
  let itemTDBID: TweakDBID = ItemID.GetTDBID(itemID);
  let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(itemTDBID);
  let slotID: TweakDBID = evt.GetSlotID();
  if IsDefined(itemRecord) && IsDefined(itemRecord.ItemCategory()) {
    itemType = itemRecord.ItemCategory().Type();
  };

  // LogChannel(n"DEBUG", s"In OnItemAddedToSlot CHANGE! Slot == \(slotID) and itemtype == \(itemType)");
  // Check if the item is clothing and log which slot it is added to
  if Equals(itemType, gamedataItemCategory.Clothing) {
    // switch (slotID) {
    //   case t"AttachmentSlots.Legs":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Legs");
    //     break;
    //   case t"AttachmentSlots.Chest":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Chest");
    //     break;
    //   case t"AttachmentSlots.Torso":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Hands");
    //     break;
    //   case t"AttachmentSlots.Feet":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Feet");
    //     break;
    //   case t"AttachmentSlots.Face":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Face");
    //     break;
    //   case t"AttachmentSlots.Head":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Head");
    //     break;
    //   case t"OutfitSlots.Head":
    //     LogChannel(n"DEBUG", s"!!!!!!!!! OnItemAddedToSlot ====== OutfitSlotsOutfitSlotsOutfitSlotsOutfitSlotsIn OnItemAddedToSlot. Slot ==== OutfitSlots Head and isvalid? \(ItemID.IsValid(itemID))");
    //     break;
    //   case t"OutfitSlots.Glasses":
    //     LogChannel(n"DEBUG", s"!!!!!!!!! OnItemAddedToSlot ====== OutfitSlotsOutfitSlotsOutfitSlotsOutfitSlotsOutfitSlots In OnItemAddedToSlot. Slot ==== OutfitSlots GLASSES  and isvalid? \(ItemID.IsValid(itemID))");
    //     break;
    //   case t"OutfitSlots.Balaclava":
    //     LogChannel(n"DEBUG", s"!!!!!!!!! OnItemAddedToSlot ====== OutfitSlotsOutfitSlotsOutfitSlotsOutfitSlotsOutfitSlots In OnItemAddedToSlot. Slot ==== OutfitSlots Balaclava  and isvalid? \(ItemID.IsValid(itemID))");
    //     break;
    //   case t"OutfitSlots.TorsoMiddle":
    //     LogChannel(n"DEBUG", s"!!!!!!!!! OnItemAddedToSlot ====== OutfitSlotsOutfitSlotsOutfitSlotsOutfitSlotsOutfitSlots In OnItemAddedToSlot. Slot ==== OutfitSlots TorsoMiddle ");
    //     break;
    //   default:
    //     break;

    // }
    this.UpdatePlayerClothAffiliation();
    this.UpdatePlayerBrokeStatus();
    this.UpdateFactionBehavior();
    // LogChannel(n"DEBUG", s"in playerpuppet, UPDATING cloth aff===  \(this.m_playerClothAffiliation) and isbroke == \(this.m_isPlayerBroke)");
  }
  wrappedMethod(evt);
}


@wrapMethod(PlayerPuppet)
protected cb func OnItemRemovedFromSlot(evt: ref<ItemRemovedFromSlot>) -> Bool {
  let itemType: gamedataItemCategory;
  let itemID: ItemID = evt.GetItemID();
  let itemTDBID: TweakDBID = ItemID.GetTDBID(itemID);
  let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(itemTDBID);
  let slotID: TweakDBID = evt.GetSlotID();
  if IsDefined(itemRecord) && IsDefined(itemRecord.ItemCategory()) {
    itemType = itemRecord.ItemCategory().Type();
  };
  // LogChannel(n"DEBUG", s"In OnItemREMOVEDFromSlot CHANGE! Slot == \(TweakDBInterface.GetAttachmentSlotRecord(slotID).EntitySlotName()) and and itemtype == \(itemType)");
  // Check if the item is clothing and log which slot it is added to
  if Equals(itemType, gamedataItemCategory.Clothing) {
    // switch (slotID) {
    //   case t"AttachmentSlots.Legs":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Legs");
    //     break;
    //   case t"AttachmentSlots.Chest":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Chest");
    //     break;
    //   case t"AttachmentSlots.Torso":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Hands");
    //     break;
    //   case t"AttachmentSlots.Feet":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Feet");
    //     break;
    //   case t"AttachmentSlots.Face":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Face");
    //     break;
    //   case t"AttachmentSlots.Head":
    //     LogChannel(n"DEBUG", s"In OnItemAddedToSlot. Slot ==== Head");
    //     break;
    // }
    this.UpdatePlayerClothAffiliation();
    this.UpdatePlayerBrokeStatus();
    this.UpdateFactionBehavior();
    // LogChannel(n"DEBUG", s"in playerpuppet, UPDATING cloth aff===  \(this.m_playerClothAffiliation) and isbroke == \(this.m_isPlayerBroke)");
  }
  wrappedMethod(evt);
}

@wrapMethod(PlayerPuppet)
private final func PlayerAttachedCallback(playerPuppet: ref<GameObject>) -> Void {
  wrappedMethod(playerPuppet);
  let attachmentSlotCallback: ref<PlayerPuppetAttachmentSlotsCallback>;
  // this.m_cyberwareStatListener = new ScriptStatsListener();
  this.m_responsiveNPCModSettings = ResponsiveNPCsModSettings.Get(this.GetGame());
  if playerPuppet == this {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGame());
    let currentCapacity: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatType.HumanityAllocated);
    // LogChannel(n"DEBUG", s"IN PlayerAttachedCallback!!! => CW CAPACITY ALLOCATED!!!! ==================> \(currentCapacity)");

    // GameInstance.GetStatsSystem(this.GetGame()).RegisterListener(Cast<StatsObjectID>(this.GetEntityID()), this.m_cyberwareStatListener)

    this.m_currentAllocatedCWCapacity = currentCapacity;
    // Legs
    attachmentSlotCallback = new PlayerPuppetAttachmentSlotsCallback();
    attachmentSlotCallback.m_player = this;
    attachmentSlotCallback.slotID = t"AttachmentSlots.Legs";
    this.m_legsAttachmentSlotListener = GameInstance.GetTransactionSystem(this.GetGame()).RegisterAttachmentSlotListener(this, attachmentSlotCallback);

    // Chest
    attachmentSlotCallback = new PlayerPuppetAttachmentSlotsCallback();
    attachmentSlotCallback.m_player = this;
    attachmentSlotCallback.slotID = t"AttachmentSlots.Chest";
    this.m_chestAttachmentSlotListener = GameInstance.GetTransactionSystem(this.GetGame()).RegisterAttachmentSlotListener(this, attachmentSlotCallback);

    // Hands
    attachmentSlotCallback = new PlayerPuppetAttachmentSlotsCallback();
    attachmentSlotCallback.m_player = this;
    attachmentSlotCallback.slotID = t"AttachmentSlots.Torso";
    this.m_handsAttachmentSlotListener = GameInstance.GetTransactionSystem(this.GetGame()).RegisterAttachmentSlotListener(this, attachmentSlotCallback);

    // Feet
    attachmentSlotCallback = new PlayerPuppetAttachmentSlotsCallback();
    attachmentSlotCallback.m_player = this;
    attachmentSlotCallback.slotID = t"AttachmentSlots.Feet";
    this.m_feetAttachmentSlotListener = GameInstance.GetTransactionSystem(this.GetGame()).RegisterAttachmentSlotListener(this, attachmentSlotCallback);

    // Face
    attachmentSlotCallback = new PlayerPuppetAttachmentSlotsCallback();
    attachmentSlotCallback.m_player = this;
    attachmentSlotCallback.slotID = t"AttachmentSlots.Face";
    this.m_faceAttachmentSlotListener = GameInstance.GetTransactionSystem(this.GetGame()).RegisterAttachmentSlotListener(this, attachmentSlotCallback);
    
    // Head
    attachmentSlotCallback = new PlayerPuppetAttachmentSlotsCallback();
    attachmentSlotCallback.m_player = this;
    attachmentSlotCallback.slotID = t"AttachmentSlots.Head";
    this.m_headAttachmentSlotListener = GameInstance.GetTransactionSystem(this.GetGame()).RegisterAttachmentSlotListener(this, attachmentSlotCallback);
  }
}

@addMethod(PlayerPuppet)
public final func OnConsequenceFactChanged(val: Int32) -> Void {
  // LogChannel(n"DEBUG", s"OnConsequenceFactChanged changed!!!! ======> \(val))");
  this.UpdateFactionBehavior();
  this.UpdateLocationFactionBehavior();
}

@addMethod(PlayerPuppet)
public final func OnWantedStateChanged(val: Int32) -> Void {
  // LogChannel(n"DEBUG", s"!!!!!!OnWantedStateChanged changed!!!! ======> \(val))");
  this.UpdateGeneralDetectionMultiplier();
}

@addMethod(PlayerPuppet)
public final func OnCourierFactChanged(val: Int32) -> Void {
  // LogChannel(n"DEBUG", s"OnCourierFactChanged changed!!!! ======> \(val))");
  if val == 0 {
    this.UpdateFactionBehavior();
  }
  else {
    this.UpdateCourierFactionBehavior();
  }
}

@addMethod(PlayerPuppet)
public final func OnRetaliationFactChanged(val: Int32) -> Void {
  // LogChannel(n"DEBUG", s"!!!!!!!!!OnRetaliationFactChanged changed!!!! ======> \(val))");
  if val == 0 {
    this.UpdateFactionBehavior();
  }
  else {
    this.UpdateRetaliationFactionBehavior();
  }
}

@addMethod(PlayerPuppet)
private final func UpdateRetaliationFactionBehavior() -> Void {
  // LogChannel(n"DEBUG", s"Running UpdateRetaliationFactionBehavior For STS RETALATION!!!!!! ==================");
  if (this.m_isModSettingsInstalled && !this.m_responsiveNPCModSettings.isQuestRetaliationEnabled) {
    // quest retaliation is disabled in mod settings
    this.m_factionBehaviorMap.Clear();
    return;
  }
  let checkFact1: Int32;
  let checkFact2: Int32;
  let checkFact3: Int32;
  let checkFact4: Int32;
  let factionKey: Uint64;
  let questsSystem: ref<QuestsSystem>;
  questsSystem =  GameInstance.GetQuestsSystem(this.GetGame());

  // Cap retaliation states at 2 to prevent permanent area lockout
  if questsSystem.GetFact(n"sts_valentinos_retaliation") != 0 {
    factionKey = 31u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sts_tygerclaws_retaliation") != 0 {
    factionKey = 27u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sts_6thstreet_retaliation") != 0 {
    factionKey = 22u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sts_maelstroms_retaliation") != 0 {
    factionKey = 10u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sts_animals_retaliation") != 0 {
    factionKey = 2u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }
}

@addMethod(PlayerPuppet)
private final func UpdateCourierFactionBehavior() -> Void {
  // LogChannel(n"DEBUG", s"Running UpdateCourierFactionBehavior For COURIER!!!!!! ==================");
  if (this.m_isModSettingsInstalled && !this.m_responsiveNPCModSettings.isQuestRetaliationEnabled) {
    // quest retaliation is disabled in mod settings
    this.m_factionBehaviorMap.Clear();
    return;
  }
  let checkFact1: Int32;
  let checkFact2: Int32;
  let checkFact3: Int32;
  let checkFact4: Int32;
  let factionKey: Uint64;
  let questsSystem: ref<QuestsSystem>;
  questsSystem =  GameInstance.GetQuestsSystem(this.GetGame());

  // Cap courier states at 2 to prevent permanent area lockout
  if questsSystem.GetFact(n"sa_ep1_courier_enemy_valentinos") != 0 {
    factionKey = 31u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sa_ep1_courier_enemy_tygers") != 0 {
    factionKey = 27u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sa_ep1_courier_enemy_6thstreet") != 0 {
    factionKey = 22u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sa_ep1_courier_enemy_maelstrom") != 0 {
    factionKey = 10u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sa_ep1_courier_enemy_scavengers") != 0 {
    factionKey = 20u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sa_ep1_courier_enemy_animals") != 0 {
    factionKey = 2u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sa_ep1_courier_enemy_voodoo") != 0 {
    factionKey = 32u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sa_ep1_courier_enemy_kangtao") != 0 {
    factionKey = 9u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  if questsSystem.GetFact(n"sa_ep1_courier_enemy_militech") != 0 {
    factionKey = 12u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 2);
    }
    return;
  }

  // some users reporting barghest quests are impossible so setting this to 1
  if (questsSystem.GetFact(n"sa_ep1_courier_enemy_dogtownmilitia") != 0) {
    factionKey = 4u;
    if this.m_factionBehaviorMap.KeyExist(factionKey) {
      this.m_factionBehaviorMap.Set(factionKey, 1);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionKey, 1);
    }
    return;
  }
}

@addMethod(PlayerPuppet)
private final func UpdateLocationFactionBehavior() -> Void {
  // this is a copy of the thing in updatefactionbehavior() for now....
  if (this.m_isModSettingsInstalled && !this.m_responsiveNPCModSettings.isQuestRetaliationEnabled) {
    // quest retaliation is disabled in mod settings
    this.m_factionBehaviorMap.Clear();
    return;
  }
  let questsSystem: ref<QuestsSystem>;
  questsSystem =  GameInstance.GetQuestsSystem(this.GetGame());

    /* ============ Scavs ============ */
  let scavConsequenceCount: Float = 0.0;
  let factionBehaviorState: Int32 = 0;
  let factionBehaviorKey: Uint64 = 20u;

  // are there scavs in westbrook? i dont know anyways: (since q001 happens in westbrook)
  if Equals(this.m_currentDistrict, "Westbrook") {
    scavConsequenceCount += 0.5;
  }
  if ((questsSystem.GetFact(n"mq306_combat") != 0  ||  questsSystem.GetFact(n"mq306_scavs_attacked") != 0)) {
    scavConsequenceCount += 1.0;
  }
  if questsSystem.GetFact(n"sts_ep1_01_nika_alive") == 0 && questsSystem.GetFact(n"sts_ep1_01_finished") != 0 {
    scavConsequenceCount += 1.0;
    if Equals(this.m_currentDistrict, "DogTown") {
      scavConsequenceCount += 1.0;
    }
  }
  if questsSystem.GetFact(n"kab_05_player_detected") != 0 && questsSystem.GetFact(n"kab_05_finished") != 0 {
    scavConsequenceCount += 1.0;
  }
  if (questsSystem.GetFact(n"mq036_done") != 0  && questsSystem.GetFact(n"mq036_items_retrieved") != 0) {
    scavConsequenceCount += 1.0;
  }
  if questsSystem.GetFact(n"mq303_02_any_scav_dead") != 0 {
    scavConsequenceCount += 1.0;
  }
  if questsSystem.GetFact(n"sts_ep1_04_alarm_raised") != 0 && ((questsSystem.GetFact(n"sts_ep1_04_done") != 0) || questsSystem.GetFact(n"sts_ep1_04_finished") != 0) {
    scavConsequenceCount += 1.0;
  }
  if questsSystem.GetFact(n"ma_pac_cvi_12_finished") != 0 {
    scavConsequenceCount += 0.5;
  }
  if questsSystem.GetFact(n"ma_nid_01_finished") != 0 {
    scavConsequenceCount += 0.5;
  }
  if questsSystem.GetFact(n"ma_wat_lch_04_finished") != 0 {
    scavConsequenceCount += 0.5;
  }

  if scavConsequenceCount >= 3.0 {
    factionBehaviorState = 2;
  }
  else if scavConsequenceCount >= 2.0 {
    factionBehaviorState = 2;
  }
  else if scavConsequenceCount >= 1.0 {
    factionBehaviorState = 1;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Set(factionBehaviorKey, factionBehaviorState);
  }
  else {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }

  /* ============ Sixth Street ============ */
  let sixthStConsequenceCount: Int32 = 0;
  factionBehaviorKey = 22u;
  factionBehaviorState = 0;

  if questsSystem.GetFact(n"mq008_telem_combat") != 0 && questsSystem.GetFact(n"mq008_done") != 0 {
    sixthStConsequenceCount += 1;
  }
  if questsSystem.GetFact(n"rcr_03_6th_street_noticed") != 0 && questsSystem.GetFact(n"rcr_03_finished") != 0 {
    sixthStConsequenceCount += 1;
  }
  if ((questsSystem.GetFact(n"gle_06_kill_all") != 0  ||  questsSystem.GetFact(n"gle_06_alarm") != 0 ) && questsSystem.GetFact(n"gle_06_finished") != 0) {
    sixthStConsequenceCount += 1;
  }
  if ((questsSystem.GetFact(n"rcr_04_gang_retaliation") != 0  ||  questsSystem.GetFact(n"rcr_04_gang_chase") != 0 ) && questsSystem.GetFact(n"rcr_04_finished") != 0) {
    sixthStConsequenceCount += 1;
  }
  if (questsSystem.GetFact(n"arr_11_lucius_dead") != 0 || questsSystem.GetFact(n"arr_11_gang_chase") != 0) && questsSystem.GetFact(n"arr_11_finished") != 0 {
    sixthStConsequenceCount += 1;
  }

  
  if sixthStConsequenceCount >= 3 {
    factionBehaviorState = 2;
  }
  else if sixthStConsequenceCount >= 2 {
    factionBehaviorState = 2;
  }
  else if sixthStConsequenceCount >= 1 {
    factionBehaviorState = 1;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Set(factionBehaviorKey, factionBehaviorState);
  }
  else {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  // also if NUSA
  // if this.m_playerClothAffiliation == 22 || this.m_playerVehicleAffiliation == 22 || this.m_playerClothAffiliation == 14 || this.m_playerVehicleAffiliation == 14 {
  //   let currVal = this.m_factionBehaviorMap.Get(Cast<Uint64>(22));
  //   if currVal != 0 && sixthStConsequenceCount <= 5{
  //     currVal -= 1;
  //     this.m_factionBehaviorMap.Set(Cast<Uint64>(22), currVal);
  //   }
  // }
  // // if valentino or tyger claw in charter hill
  if (this.m_playerClothAffiliation == 27 && Equals(this.m_currentDistrict, "CharterHill")) {
    if factionBehaviorState != 0 {

      let currVal = this.m_factionBehaviorMap.Get(factionBehaviorKey);
      if currVal != 2 { // Cap at state 2
        currVal += 1;
        this.m_factionBehaviorMap.Set(factionBehaviorKey, currVal);
      }
    }
    else {
      this.m_factionBehaviorMap.Insert(factionBehaviorKey, 2);
    }
  }

}


@addMethod(PlayerPuppet)
private final func UpdateFactionBehavior() -> Void {
  // LogChannel(n"DEBUG", s"Running UpdateFactionBehavior ==================");
  if (this.m_isModSettingsInstalled && !this.m_responsiveNPCModSettings.isQuestRetaliationEnabled) {
    // quest retaliation is disabled in mod settings
    this.m_factionBehaviorMap.Clear();
    return;
  }
  let factionBehaviorState: Int32 = 0;
  let factionBehaviorKey: Uint64 = 0u;
  let checkFact1: Int32;
  let checkFact2: Int32;
  let checkFact3: Int32;
  let checkFact4: Int32;
  let questsSystem: ref<QuestsSystem>;
  questsSystem = GameInstance.GetQuestsSystem(this.GetGame());
  this.m_factionBehaviorMap.Clear();
  // hash key is mapped to enum gamedataAffiliation
  // can have values: -1 (ally-ish), 0 (default), 1 (early detection), 2 (provocation/max to prevent area lockout)

  // lets start calculating
  /* ============ Valentinos ============ */
  let checkFacts: array<Int32> = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  let valentinoConsequenceCount: Int32 = 0;
  factionBehaviorKey = 31u;

  if questsSystem.GetFact(n"rey_01_kill_gustavo") != 0 || questsSystem.GetFact(n"rey_01_gustavo_orta_dead") != 0 {
    valentinoConsequenceCount += 1;
  }
  if (questsSystem.GetFact(n"gle_04_drink_with_bouncer") !=0 || questsSystem.GetFact(n"gle_04_gang_chase") != 0 || questsSystem.GetFact(n"gle_04_gang_retaliation") != 0) && questsSystem.GetFact(n"gle_04_finished") != 0 {
    valentinoConsequenceCount += 1;
  }
  if questsSystem.GetFact(n"sts_hey_spr_03_combat_triggered") != 0 {
    valentinoConsequenceCount += 1;
  }
  if questsSystem.GetFact(n"spr_01_jose_luise_killed") != 0 {
    valentinoConsequenceCount += 1;
  }
  if questsSystem.GetFact(n"rey_08_alarm_on") != 0 && questsSystem.GetFact(n"rey_08_finished") != 0 {
    valentinoConsequenceCount += 1;
  }

  if (questsSystem.GetFact(n"rey_02_gang_retaliation") != 0 || questsSystem.GetFact(n"rey_02_gang_chase") != 0) && questsSystem.GetFact(n"rey_02_finished") != 0 {
    valentinoConsequenceCount += 1;
  }

  
  if valentinoConsequenceCount >= 3 {
    factionBehaviorState = 2;
  }
  else if valentinoConsequenceCount >= 2 {
    factionBehaviorState = 2;
  }
  else if valentinoConsequenceCount >= 1 {
    factionBehaviorState = 1;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  
  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In Valentino Check. Final state = \(factionBehaviorState) and COnsequence count = \(valentinoConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  /* ============ Tyger Claws ============ */

  let tygerConsequenceCount: Int32 = 0;
  factionBehaviorKey = 27u;
  factionBehaviorState = 0;  
  if questsSystem.GetFact(n"lch_03_optional_alarm") != 0 {
    tygerConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"sts_wat_nid_02_combat_triggered") != 0 && questsSystem.GetFact(n"nid_02_finished") != 0 {
    tygerConsequenceCount += 1;
  }

  if (questsSystem.GetFact(n"lch_01_gang_retaliation") != 0 || questsSystem.GetFact(n"lch_01_gang_chase") != 0) && questsSystem.GetFact(n"lch_01_finished") != 0 {
    tygerConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"jpn_03_stealth_fail") != 0 {
    tygerConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"jpn_02_all_killed") != 0 {
    tygerConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"kab_07_jotaro_killed") != 0 && questsSystem.GetFact(n"kab_07_enemies_alerted") != 0 {
    tygerConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"nid_03_detected") != 0 && questsSystem.GetFact(n"nid_03_finished") != 0 {
    tygerConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"lch_05_blackmaill") != 0 && questsSystem.GetFact(n"lch_05_finished") != 0 {
    tygerConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"hil_07_gang_retaliation") != 0 || questsSystem.GetFact(n"hil_07_comabt") != 0 {
    tygerConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"jpn_12_gang_retaliation") != 0 && questsSystem.GetFact(n"jpn_12a_finished") != 0 {
    tygerConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"kab_107_taki_kenmochi_dead") != 0 {
    tygerConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"lch_06_finished") != 0 {
    tygerConsequenceCount += 1;
  }

  
  if tygerConsequenceCount >= 6 {
    factionBehaviorState = 2;
    // this.m_factionBehaviorMap.Set(Cast<Uint64>(27), 2);
  }
  else if tygerConsequenceCount >= 4 {
    factionBehaviorState = 2;
    // this.m_factionBehaviorMap.Set(Cast<Uint64>(27), 2);
  }
  else if tygerConsequenceCount >= 2 {
    factionBehaviorState = 1;
    // this.m_factionBehaviorMap.Set(Cast<Uint64>(27), 1);
  }
   if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  // LogChannel(n"DEBUG", s"INSERTED!!");

   }

  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In TygerClaw Check. Final state = \(factionBehaviorState) and COnsequence count = \(tygerConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  
  // Player sided against Tygers in Clouds takeover mission - cap at state 2
  if (questsSystem.GetFact(n"sq026_side_judy") != 0 || questsSystem.GetFact(n"sq026_maiko_dead") != 0 || questsSystem.GetFact(n"sq026_side_maiko") == 0)
   {
    if factionBehaviorState != 0 {
      this.m_factionBehaviorMap.Set(factionBehaviorKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionBehaviorKey, 2);
    }
  }
  
  /* ============ Maelstrom ============ */

  let maelstromConsequenceCount: Float = 0;
  factionBehaviorKey = 10u;
  factionBehaviorState = 0;

  if (questsSystem.GetFact(n"kab_02_patient_dead") != 0 || questsSystem.GetFact(n"kab_02_gang_chase") != 0) && questsSystem.GetFact(n"kab_02_finished") != 0 {
    maelstromConsequenceCount += 1.0;
  }
  if questsSystem.GetFact(n"ma_nid_06_finished") != 0 {
    maelstromConsequenceCount += 0.5;
  }
  if questsSystem.GetFact(n"sq006_maelstrom_ambush_reinforcements") != 0 {
    maelstromConsequenceCount += 0.5;
  }
  if questsSystem.GetFact(n"ma_nid_02_finished") != 0 {
    maelstromConsequenceCount += 0.5;
  }
  if ((questsSystem.GetFact(n"nid_05_gang_retaliation") != 0  ||  questsSystem.GetFact(n"sts_wat_kab_nid_05_combat") != 0 ) && questsSystem.GetFact(n"nid_05_finished") != 0) {
    maelstromConsequenceCount += 1.0;
  }

  if questsSystem.GetFact(n"kab_106_recording_stolen") != 0 && questsSystem.GetFact(n"kab_106_alarm_rised") != 0 {
    maelstromConsequenceCount += 1.0;
  }

  if questsSystem.GetFact(n"sq011_patricia_combat_path") != 0 || questsSystem.GetFact(n"sq011_royce_combat_path") != 0 {
    maelstromConsequenceCount += 1.5;
  }

  if questsSystem.GetFact(n"q003_combat_scenario") != 0 && questsSystem.GetFact(n"q003_brick_dead") != 0 {
    maelstromConsequenceCount += 1.5;
  }

  
  if maelstromConsequenceCount >= 4.0 {
    factionBehaviorState = 2;
  }
  else if maelstromConsequenceCount >= 2.0 {
    factionBehaviorState = 2;
  }
  else if maelstromConsequenceCount >= 1.0 {
    factionBehaviorState = 1;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  // Maelstrom - Player killed all leaders - cap at state 2
  if (questsSystem.GetFact(n"q003_brick_dead") != 0 &&
      questsSystem.GetFact(n"q003_royce_dead") != 0 &&
      questsSystem.GetFact(n"q003_dumdum_dead") != 0 &&
      questsSystem.GetFact(n"sq011_patricia_dead") != 0) {
    if factionBehaviorState != 0 {
      this.m_factionBehaviorMap.Set(factionBehaviorKey, 2);
    }
    else {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, 2);
    }
  }

  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In Maelstrom Check. Final state = \(factionBehaviorState) and COnsequence count = \(maelstromConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  /* ============ Sixth Street ============ */
  let sixthStConsequenceCount: Float = 0.0;
  factionBehaviorKey = 22u;
  factionBehaviorState = 0;  

  if (questsSystem.GetFact(n"mq008_telem_combat") != 0 || questsSystem.GetFact(n"v_offends_boss") != 0) && questsSystem.GetFact(n"mq008_done") != 0 {
    sixthStConsequenceCount += 2.0;
  }
  if questsSystem.GetFact(n"rcr_03_6th_street_noticed") != 0 && questsSystem.GetFact(n"rcr_03_finished") != 0 {
    sixthStConsequenceCount += 1.0;
  }
  if ((questsSystem.GetFact(n"gle_06_kill_all") != 0  ||  questsSystem.GetFact(n"gle_06_alarm") != 0 ) && questsSystem.GetFact(n"gle_06_finished") != 0) {
    sixthStConsequenceCount += 1.0;
  }
  if ((questsSystem.GetFact(n"rcr_04_gang_retaliation") != 0  ||  questsSystem.GetFact(n"rcr_04_gang_chase") != 0 ) && questsSystem.GetFact(n"rcr_04_finished") != 0) {
    sixthStConsequenceCount += 1.0;
  }
  if (questsSystem.GetFact(n"arr_11_lucius_dead") != 0 || questsSystem.GetFact(n"arr_11_gang_chase") != 0) && questsSystem.GetFact(n"arr_11_finished") != 0 {
    sixthStConsequenceCount += 1.5;
  }

  
  if sixthStConsequenceCount >= 3.0 {
    factionBehaviorState = 2;
  }
  else if sixthStConsequenceCount >= 2.0 {
    factionBehaviorState = 2;
  }
  else if sixthStConsequenceCount >= 1.0 {
    factionBehaviorState = 1;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  if (this.m_playerClothAffiliation == 27 && Equals(this.m_currentDistrict, "CharterHill")) {
    if factionBehaviorState != 0 {
      let currVal = this.m_factionBehaviorMap.Get(factionBehaviorKey);
      if currVal != 2 { // Cap at state 2
        currVal += 1;
        this.m_factionBehaviorMap.Set(factionBehaviorKey, currVal);
      }
    }
    else {
      this.m_factionBehaviorMap.Insert(factionBehaviorKey, 2);
    }
  }

  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In Sixth Street Check. Final state = \(factionBehaviorState) and COnsequence count = \(sixthStConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");


  /* ============ Scavs ============ */
  let scavConsequenceCount: Float = 0.0;
  factionBehaviorState = 0;  
  factionBehaviorKey = 20u;

  // are there scavs in westbrook? i dont know anyways: (since q001 happens in westbrook)
  if Equals(this.m_currentDistrict, "Westbrook") {
    scavConsequenceCount += 1.0;
  }
  if ((questsSystem.GetFact(n"mq306_combat") != 0  ||  questsSystem.GetFact(n"mq306_scavs_attacked") != 0)) {
    scavConsequenceCount += 1.0;
  }
  if questsSystem.GetFact(n"sts_ep1_01_nika_alive") == 0 && questsSystem.GetFact(n"sts_ep1_01_finished") != 0 {
    scavConsequenceCount += 1.0;
    if Equals(this.m_currentDistrict, "DogTown") {
      scavConsequenceCount += 1.0;
    }
  }
  if questsSystem.GetFact(n"kab_05_player_detected") != 0 && questsSystem.GetFact(n"kab_05_finished") != 0 {
    scavConsequenceCount += 1.0;
  }
  if (questsSystem.GetFact(n"mq036_done") != 0  && questsSystem.GetFact(n"mq036_items_retrieved") != 0) {
    scavConsequenceCount += 1.0;
  }
  if questsSystem.GetFact(n"mq303_02_any_scav_dead") != 0 {
    scavConsequenceCount += 1.0;
  }
  if questsSystem.GetFact(n"sts_ep1_04_alarm_raised") != 0 && ((questsSystem.GetFact(n"sts_ep1_04_done") != 0) || questsSystem.GetFact(n"sts_ep1_04_finished") != 0) {
    scavConsequenceCount += 1.0;
  }
  if questsSystem.GetFact(n"ma_pac_cvi_12_finished") != 0 {
    scavConsequenceCount += 0.5;
  }
  if questsSystem.GetFact(n"ma_nid_01_finished") != 0 {
    scavConsequenceCount += 0.5;
  }
  if questsSystem.GetFact(n"ma_wat_lch_04_finished") != 0 {
    scavConsequenceCount += 0.5;
  }

  if scavConsequenceCount >= 3.0 {
    factionBehaviorState = 2;
  }
  else if scavConsequenceCount >= 2.0 {
    factionBehaviorState = 2;
  }
  else if scavConsequenceCount >= 1.0 {
    factionBehaviorState = 1;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }

  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In Scavengers Check. Final state = \(factionBehaviorState) and COnsequence count = \(scavConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");


  /* ============ Animals ============ */

  let animalsConsequenceCount: Float = 0.0;
  factionBehaviorKey = 2u;
  factionBehaviorState = 0;  

  if (questsSystem.GetFact(n"kab_06_blake_croyle_dead") != 0 && questsSystem.GetFact(n"kab_06_finished") != 0) {
    animalsConsequenceCount += 1.5;
  }

  if questsSystem.GetFact(n"wwd_05_logan_dead") != 0 && (questsSystem.GetFact(n"wwd_05_finished") != 0 || questsSystem.GetFact(n"wwd_05_done") != 0) {
    animalsConsequenceCount += 1.5;
  }

  if questsSystem.GetFact(n"q110_var_mall_most_animals_killed") != 0 && questsSystem.GetFact(n"q110_done") != 0 {
    animalsConsequenceCount += 1.0;
  }

  if questsSystem.GetFact(n"q110_var_mall_many_animals_killed") != 0 && questsSystem.GetFact(n"q110_done") != 0 {
    animalsConsequenceCount += 1.0;
  }

  if (questsSystem.GetFact(n"dtn_03_gang_chase") != 0 || questsSystem.GetFact(n"dtn_03_gang_retaliation") != 0 || questsSystem.GetFact(n"dtn_03_in_combat") != 0) && questsSystem.GetFact(n"dtn_03_finished") != 0 {
    animalsConsequenceCount += 1.0;
  }

  
  if animalsConsequenceCount >= 3.0 {
    factionBehaviorState = 2;
  }
  else if animalsConsequenceCount >= 2.0 {
    factionBehaviorState = 2;
  }
  else if animalsConsequenceCount >= 1.0 {
    factionBehaviorState = 1;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In Animals Check. Final state = \(factionBehaviorState) and COnsequence count = \(animalsConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  /* ============ Voodoo Boys ============ */
  let VDBConsequenceCount: Int32 = 0;
  factionBehaviorKey = 32u;
  factionBehaviorState = 0;  

  if ((questsSystem.GetFact(n"sts_ep1_12_milko_dead") != 0  && questsSystem.GetFact(n"sts_ep1_12_finished") != 0)) {
    VDBConsequenceCount += 1;
  }
  if questsSystem.GetFact(n"q110_placide_dead") != 0 && (questsSystem.GetFact(n"q110_done") != 0) {
    VDBConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"q110_voodoo_queen_dead") != 0 && questsSystem.GetFact(n"q110_done") != 0 {
    VDBConsequenceCount += 1;
  }

  
  if VDBConsequenceCount >= 2 {
    factionBehaviorState = 2;
  }
  else if VDBConsequenceCount >= 1 {
    factionBehaviorState = 2;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In Voodoo Boys Check. Final state = \(factionBehaviorState) and COnsequence count = \(VDBConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  /* ============ Wraiths ============ */

  let wraithConsequenceCount: Int32 = 0;
  factionBehaviorKey = 33u;
  factionBehaviorState = 0;  

  if (((questsSystem.GetFact(n"ina_02_big_pete_dead") != 0 || questsSystem.GetFact(n"ina_02_gang_retaliation") != 0) || questsSystem.GetFact(n"#ina_02_combat_triggered") != 0) && questsSystem.GetFact(n"ina_02_finished") != 0) {
    wraithConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"ina_03_antenna_sbotaged") != 0 && questsSystem.GetFact(n"ina_03_finished") != 0 && (questsSystem.GetFact(n"ina_03_gang_retaliation") != 0 || questsSystem.GetFact(n"ina_03_gang_chase") != 0) {
    wraithConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"ina_06_all_enemies_killed") != 0 && questsSystem.GetFact(n"ina_06_finished") != 0 {
    wraithConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"sq004_rafen_alldead") != 0 && questsSystem.GetFact(n"sq004_done") != 0 {
    wraithConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"q103_ghost_town_detected") != 0 {
    wraithConsequenceCount += 1;
  }

  if questsSystem.GetFact(n"q103_helped_panam") != 0 {
    wraithConsequenceCount += 2;
  }

  
  if wraithConsequenceCount >= 3 {
    factionBehaviorState = 2;
  }
  else if wraithConsequenceCount >= 2 {
    factionBehaviorState = 2;
  }
  else if wraithConsequenceCount >= 1 {
    factionBehaviorState = 1;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In Wraith Check. Final state = \(factionBehaviorState) and COnsequence count = \(wraithConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  /* ============ Arasaka ============ */
  let arasakaConsequenceCount: Int32 = 0;
  factionBehaviorState = 0;  

  factionBehaviorKey = 3u;
  if (questsSystem.GetFact(n"q005_done") != 0) {
    arasakaConsequenceCount += 1;
  }
  if questsSystem.GetFact(n"q112_done") != 0 {
    arasakaConsequenceCount += 1;
  }

  
  if arasakaConsequenceCount >= 1 {
    factionBehaviorState = 2;
  }
  else if arasakaConsequenceCount >= 0 {
    factionBehaviorState = 2;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In Arasaka Check. Final state = \(factionBehaviorState) and COnsequence count = \(arasakaConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  /* ============ Biotechnica ============ */
  factionBehaviorKey = 5u;
  factionBehaviorState = 0;  
  let biotechnicaConsequenceCount: Int32 = 0;

  if (questsSystem.GetFact(n"dtn_04_joanne_koch_dead") != 0) {
    biotechnicaConsequenceCount += 1;
  }
  if questsSystem.GetFact(n"sts_ep1_07_any_agent_dead") != 0 {
    biotechnicaConsequenceCount += 1;
  }

  
  if biotechnicaConsequenceCount >= 1 {
    factionBehaviorState = 2;
  }
  else if biotechnicaConsequenceCount >= 0 {
    factionBehaviorState = 2;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In Biotechnica Check. Final state = \(factionBehaviorState) and COnsequence count = \(biotechnicaConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  /* ============ Kang Tao ============ */
  let kangtaoConsequenceCount: Int32 = 0;
  factionBehaviorKey = 9u;
  factionBehaviorState = 0;  

  if (questsSystem.GetFact(n"arr_06_first_wave_kang_tao_killed") != 0 || questsSystem.GetFact(n"arr_06_combat_kang_tao")!= 0) {
    kangtaoConsequenceCount += 1;
  }
  if (questsSystem.GetFact(n"arr_06_second_wave_kang_tao_killed") != 0) {
    kangtaoConsequenceCount += 1;
  }
  if questsSystem.GetFact(n"arr_06_karl_killed") == 0 {
    kangtaoConsequenceCount += 1;
  }

  
  if kangtaoConsequenceCount >= 2 {
    factionBehaviorState = 2;
  }
  else if kangtaoConsequenceCount >= 1 {
    factionBehaviorState = 2;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In Kang TAo Check. Final state = \(factionBehaviorState) and COnsequence count = \(kangtaoConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  /* ============ Militech  ============ */
  let militechConsequenceCount: Int32 = 0;
  factionBehaviorKey = 12u;
  factionBehaviorState = 0;  

  if (questsSystem.GetFact(n"#ina_04_all_guard_dead") != 0 && questsSystem.GetFact(n"ina_04_finished") != 0) {
    militechConsequenceCount += 2;
  }
  if questsSystem.GetFact(n"ina_04_combat_started") != 0 && questsSystem.GetFact(n"ina_04_finished") != 0 {
    militechConsequenceCount += 1;
  }
  if (questsSystem.GetFact(n"ina_05_optional_failed") != 0 || questsSystem.GetFact(n"ina_05_militech_killed") != 0)  && questsSystem.GetFact(n"ina_05_finished") != 0 {
    militechConsequenceCount += 1;
  }
  if questsSystem.GetFact(n"kab_01_combat_started") != 0 && questsSystem.GetFact(n"kab_01_done") != 0 {
    militechConsequenceCount += 1;
  }

  
  if militechConsequenceCount >= 3 {
    factionBehaviorState = 2;
  }
  else if militechConsequenceCount >= 2 {
    factionBehaviorState = 2;
  }
  else if militechConsequenceCount >= 1 {
    factionBehaviorState = 1;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In MILITECH Check. Final state = \(factionBehaviorState) and COnsequence count = \(militechConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  // if you are wraith after sq027 (queen of the highway)
  if (this.m_playerClothAffiliation == 33 || this.m_playerVehicleAffiliation == 33) &&  questsSystem.GetFact(n"sq027_raffen_attack_defeated") != 0 {
    let currVal = this.m_factionBehaviorMap.Get(Cast<Uint64>(12));
    if currVal != 2 { // Cap at state 2
      currVal += 1;
      this.m_factionBehaviorMap.Set(Cast<Uint64>(12), currVal);
    }
  }

  /* ============ NCPD  ============ */
  // if (questsSystem.GetFact(n"#ina_04_all_guard_dead") != 0 && questsSystem.GetFact(n"ina_04_finished")) {
  //   checkFacts[0] = 1;
  // }
  // if (questsSystem.GetFact(n"ina_05_optional_failed") != 0 || questsSystem.GetFact(n"ina_05_militech_killed"))  && questsSystem.GetFact(n"ina_05_finished") {
  //   checkFacts[1] = 1;
  // }
  // if questsSystem.GetFact(n"sa_ep1_courier_enemy_militech") != 0 {
  //   checkFacts[1] = 1;
  // }
  // let militechConsequenceCount: Int32 = 0;

  // for checkFact in checkFacts {
  //   if checkFact != 0 {
  //     militechConsequenceCount += 1;
  //   }
  // }

  // if militechConsequenceCount >= 1 {
  //   this.m_factionBehaviorMap.Set(Cast<Uint64>(12), 3);
  // }
  // else if militechConsequenceCount >= 0 {
  //   this.m_factionBehaviorMap.Set(Cast<Uint64>(12), 2);
  // }

  // Barghest
  factionBehaviorState = 0;  
  let barghestConsequenceCount: Int32 = 0;
  factionBehaviorKey = 4u;

  if (questsSystem.GetFact(n"q302_detected") != 0) {
    barghestConsequenceCount += 1;
  }

  if (questsSystem.GetFact(n"sts_ep1_10_dodger_dead") != 0) {
    barghestConsequenceCount += 1;
  }

  if (questsSystem.GetFact(n"mq301_03_frame_jurij") != 0) {
    barghestConsequenceCount += 1;
  }

  if (questsSystem.GetFact(n"sts_ep1_10_kill_count") != 0) {
    barghestConsequenceCount += 1;
  }

  if barghestConsequenceCount >= 4 {
    factionBehaviorState = 2;
  }
  else if barghestConsequenceCount >= 1 {
    factionBehaviorState = 1;
  }
  if factionBehaviorState != 0 {
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, factionBehaviorState);
  }
  // LogChannel(n"DEBUG", s"======================================");
  // LogChannel(n"DEBUG", s"In BARGHEST Check. Final state = \(factionBehaviorState) and COnsequence count = \(barghestConsequenceCount) ==================== and factionmap === CHECK VAL ???? =====> \(IntToString(this.m_factionBehaviorMap.Get(factionBehaviorKey)))");

  // Naked - special case of cloth affiliation

  // if this.m_playerClothAffiliation == 69 {
    
  //   this.m_factionBehaviorMap.S
  // }
  // NetWatch
  // LogChannel(n"DEBUG", s"IN UPDATE FACTION!!!!!! CHECKING IF COP??? ==================\(this.m_playerClothAffiliation)");

  // NCPD/Military clothing increases Barghest detection but doesn't force combat
  if this.m_playerClothAffiliation == 13 || this.m_playerVehicleAffiliation == 13 || this.m_playerVehicleAffiliation == 26 || this.m_playerClothAffiliation == 43 {
    factionBehaviorKey = 13u;
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, -1);
    factionBehaviorKey = 26u;
    this.m_factionBehaviorMap.Insert(factionBehaviorKey, -1);
    factionBehaviorKey = 4u;
    // Cap Barghest at state 2 to prevent Dogtown lockout
    if factionBehaviorState != 0 {
      this.m_factionBehaviorMap.Set(factionBehaviorKey, 2);
    }
    else {
      this.m_factionBehaviorMap.Insert(factionBehaviorKey, 2);
    }
    // LogChannel(n"DEBUG", s"IN UPDATE FACTION!!!!!! COP detected ==================");
    // if this.m_playerClothAffiliation == 13 {
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(2), 1);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(4), 3);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(10), 2);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(10), 2);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(20), 2);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(20), 2);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(22), 2);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(23), 2);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(27), 2);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(31), 2);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(33), 2);
    //   this.m_factionBehaviorMap.Set(Cast<Uint64>(34), 2);
    // }
  }
}


@wrapMethod(NPCPuppet)
protected cb func OnScanningLookedAt(evt: ref<ScanningLookAtEvent>) -> Bool {
  wrappedMethod(evt);
  if evt.state {
    let player: wref<GameObject> = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject();
    let playerPuppet: ref<PlayerPuppet> = GetPlayer(this.GetGame());
    let affiliationRecord: Int32 = this.GetAffiliationInt();
    let senseComponent: ref<SenseComponent> = this.GetSensesComponent();
    if !IsDefined(senseComponent) {
      return false;
    }
    let factionBehaviorState: Int32 = 0;
    let detectionMultiplier: Float = senseComponent.GetDetectionMultiplier(evt.ownerID);
    let isSameDirection: Bool = ReactionManagerComponent.IsTargetInFrontOfSource(this, player, 140.0, true);
    if playerPuppet.m_factionBehaviorMap.KeyExist(Cast<Uint64>(affiliationRecord)) && isSameDirection {
      factionBehaviorState = playerPuppet.m_factionBehaviorMap.Get(Cast<Uint64>(affiliationRecord));
      if factionBehaviorState != 0 {
        if factionBehaviorState == 1 {
          senseComponent.SetDetectionMultiplier(evt.ownerID, detectionMultiplier + 0.05);
        }
        else if factionBehaviorState == 2 {
          senseComponent.SetDetectionMultiplier(evt.ownerID, detectionMultiplier + 0.15); // Increased for max state
        }
        // State 3 removed - max is now 2 to prevent area lockout
      }
    }
  }
}

@wrapMethod(PlayerPuppet)
public final func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
  if Equals(statType, gamedataStatType.HumanityAllocated) {
    this.m_currentAllocatedCWCapacity = total;
    if total > 340.0 {
      this.m_isAlmostCyberpsycho = true;
    }
  }
  wrappedMethod(ownerID, statType, diff, total);
}

@addMethod(PlayerPuppet)
private final func GetActiveWeaponDetectionMultplier() -> Float {
  let dm: Float = 0.0;
  if IsDefined(GameObject.GetActiveWeapon(this)) && !WeaponObject.IsFists(GameObject.GetActiveWeapon(this).GetItemID()) {
    dm += 0.1;
    let activeWeaponObject: ref<WeaponObject> = GameObject.GetActiveWeapon(this);

    let isRevolver: Bool = activeWeaponObject.m_weaponRecord.TagsContains(n"Revolver");
    let isHandgun: Bool = activeWeaponObject.m_weaponRecord.TagsContains(n"Handgun");

    if activeWeaponObject.IsHeavyWeapon() || activeWeaponObject.IsThrowable() || activeWeaponObject.IsRanged() && !isRevolver && !isHandgun {
      dm += 0.15;
      if StrContains(this.m_currentDistrict, "Corpo") || StrContains(this.m_currentDistrict, "CityCenter") || StrContains(this.m_currentDistrict, "Arasaka") && !StrContains(this.m_currentDistrict, "q201") {
        dm += 0.5;
      }
    }
      // LogChannel(n"DEBUG", s"in GetActiveWeaponDetectionMultplier === ret => \(dm) and == \(isHandgun)");

  };
  return dm;
}

/* vehicle stuff here */

@wrapMethod(VehicleComponentPS)
public final func SetVehicleVisualCustomizationActive(set: Bool) -> Void {
  wrappedMethod(set);
  let playerPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
  if set {
    playerPuppet.m_vehicleCrystalCoatState = 1;
    playerPuppet.UpdateGeneralDetectionMultiplier();
  }
  else {
    playerPuppet.m_vehicleCrystalCoatState = 2;
    playerPuppet.UpdateGeneralDetectionMultiplier();
  }
}

@replaceMethod(VehicleComponent)
private final func SignalDamageToVehicleVisualCustomization() -> Void {
  this.m_vehicleBlackboard.SetBool(GetAllBlackboardDefs().Vehicle.VehicleCustomizationBlockedByDamage, true, true);
  if this.GetVehicle().GetVehicleComponent().GetIsVehicleVisualCustomizationEnabled() && this.GetVehicle().IsPlayerMounted() && !this.GetVehicle().GetVehicleComponent().GetIsVehicleVisualCustomizationTeaser() && !this.GetPS().GetIsVehicleVisualCustomizationBlockedByDamage() {
    StatusEffectHelper.ApplyStatusEffect(this.m_mountedPlayer, t"BaseStatusEffect.VehicleVisualModCooldown");
    this.VisualCustomizationBlockedNotification(GetLocalizedText("LocKey#96051"), SimpleMessageType.Negative);
    let playerPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetVehicle().GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    playerPuppet.m_vehicleCrystalCoatState = 3;
    playerPuppet.UpdateGeneralDetectionMultiplier();
  };
  this.GetPS().SetVehicleVisualCustomizationnBlockedByDamage(true);
}

@wrapMethod(VehicleComponent)
private final func ToggleCrystalDome(toggle: Bool, opt force: Bool, opt instant: Bool, opt instantDelay: Float, opt meshVisibilityDelay: Float, opt fastStop: Bool) -> Void {
  wrappedMethod(toggle, force, instant, instantDelay, meshVisibilityDelay, fastStop);
  let playerPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetVehicle().GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
  if this.GetVehicle().IsPlayerMounted() {
    if toggle {
      playerPuppet.m_hasVehicleCrystalDome = true;
    } else {
      playerPuppet.m_hasVehicleCrystalDome = false;
    }
    playerPuppet.UpdateGeneralDetectionMultiplier();
  }
}

@wrapMethod(VehicleComponent)
protected cb func OnVehicleHornProbEvent(evt: ref<VehicleHornProbsEvent>) -> Bool {
  let delayTimer: Float;
  let hornOffDelayEvent: ref<VehicleHornOffDelayEvent>;
  let vehicleObject: wref<VehicleObject>;
  let randomDraw: Float = RandRangeF(0.00, 1.00);
  if randomDraw <= evt.probability {
    vehicleObject = this.GetVehicle();
    this.ToggleVehicleHorn(true);
    this.m_hornOn = true;
    GameObject.PlayVoiceOver(VehicleComponent.GetDriverMounted(this.GetVehicle().GetGame(), this.GetVehicle().GetEntityID()), n"bump", n"Scripts:OnIDK", 0.0, this.GetVehicle().GetEntityID(), true);
    delayTimer = RandRangeF(evt.honkMinTime, evt.honkMaxTime);
    if delayTimer == 0.00 {
      delayTimer = 3.00;
    };
    hornOffDelayEvent = new VehicleHornOffDelayEvent();
    GameInstance.GetDelaySystem(vehicleObject.GetGame()).DelayEvent(vehicleObject, hornOffDelayEvent, delayTimer);
  };
}


@replaceMethod(VehicleObject)
protected cb func OnHandleReactionEvent(evt: ref<HandleReactionEvent>) -> Bool {
  let isMaxTacOnScene: Bool;
  let prevention: ref<PreventionSystem>;
  let randomDraw: Float;

  if this.IsPerformingPanicDriving() || this.IsExecutingAnyCommand() {
    return IsDefined(null);
  };
  if EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame())) <= this.m_hitTimestamp + 2.00 && evt.stimEvent.sourceObject.IsPlayer() {
    this.EnableHighPriorityPanicDriving();
  };
  if !GameObject.IsCooldownActive(this, n"vehicleReactionCooldown") && !this.m_driverUnconscious {
    this.m_reactionTriggerEvent = evt;
    GameObject.StartCooldown(this, n"vehicleReactionCooldown", 1.00);
    randomDraw = RandRangeF(0.00, 1.00);
    prevention = GameInstance.GetScriptableSystemsContainer(this.GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    isMaxTacOnScene = !prevention.IsMaxTacDefeated();


    if this.m_gotStuckIncrement < 2 && !this.m_abandoned && this.CanStartPanicDriving() && !isMaxTacOnScene && NotEquals(evt.stimEvent.stimType, gamedataStimType.VehicleHorn) {
      this.TriggerDrivingPanicBehavior(evt.stimEvent.sourcePosition);
      this.m_fearInside = false;
    } else {
      if isMaxTacOnScene || (randomDraw <= 0.30 || this.m_gotStuckIncrement > 2) && evt.stimEvent.sourceObject.IsPlayer() && this.CanNPCsLeaveVehicle() {
        this.TriggerExitBehavior();
        this.m_fearInside = false;
      } else {
        if !this.m_fearInside {
          this.TriggerFearInsideVehicleBehavior();
          this.m_fearInside = true;
        };
        this.ResendHandleReactionEvent();
      };
    };
  };
}

@replaceMethod(VehicleObject)
private final func PanicDrivingBehavior() -> Void {
  if this.IsPlayerMounted() && this.GetVehicleComponent().m_hornOn {
    return;
  }
  if !this.m_abandoned && !this.IsPlayerMounted() {
    if Equals(this.m_drivingTrafficPattern, n"stop") {
      this.ResetReactionSequenceOfAllPassengers();
    };
    GameObject.PlayVoiceOver(VehicleComponent.GetDriverMounted(this.GetGame(), this.GetEntityID()), n"fear_run", n"Scripts:PanicDrivingBehavior", 0.0, this.GetEntityID(), true);
    this.m_drivingTrafficPattern = n"panic";
    this.m_crowdMemberComponent.ChangeMoveType(this.m_drivingTrafficPattern);
    this.ResetTimesSentReactionEvent();
  };
}

