/* TODO
- check perf impact?
*/

native func LogChannel(channel: CName, const text: script_ref<String>) ;


@addField(ReactionManagerComponent)
let m_stalkingCount: Int32 = 0;

@addField(ReactionManagerComponent)
let m_bumpedRecentlyIntoNCPD: Int32 = 0;

@addField(ReactionManagerComponent)
let m_initialDetectionMultiplier: Float = 1.0;

public class StalkEventCustom extends Event {
  public let target: wref<GameObject>;
}

@replaceMethod(ReactionManagerComponent)
protected cb func OnBumpEvent(evt: ref<BumpEvent>) -> Bool {
  let blackboard: ref<IBlackboard>;
  let broadcaster: ref<StimBroadcasterComponent>;
  let distanceBuffer: Float;
  let distanceSquared: Float;
  let speedModifier: Float;
  let triggerDistance: Float;
  let vehicle: ref<VehicleObject>;
  let workspotSystem: ref<WorkspotGameSystem>;
  let owner: ref<GameObject> = this.GetOwner();
  let ownerPuppet: ref<ScriptedPuppet> = this.GetOwnerPuppet();
  let game: GameInstance = owner.GetGame();
  let player: ref<GameObject> = this.GetPlayerSystem().GetLocalPlayerMainGameObject();
  let playerPuppet: ref<PlayerPuppet> = player as PlayerPuppet;
  let npcPuppet: ref<NPCPuppet> = ownerPuppet as NPCPuppet;
  if !IsDefined(ownerPuppet) || !ownerPuppet.IsActive() || !IsDefined(playerPuppet) || !IsDefined(npcPuppet) {
    return false;
  };
  if Equals(this.m_reactionPreset.Type(), gamedataReactionPresetType.NoReaction) {
    return false;
  };
  if !this.m_initCrowd {
    this.InitCrowd();
    this.m_initCrowd = true;
  };

  if evt.isMounted {
    distanceBuffer = this.m_bumpTriggerDistanceBufferMounted;
  } else {
    if GameInstance.GetWorkspotSystem(owner.GetGame()).IsActorInWorkspot(owner) && GameInstance.GetWorkspotSystem(owner.GetGame()).IsActorInWorkspot(this.GetPlayerSystem().GetLocalPlayerControlledGameObject()) && StatusEffectSystem.ObjectHasStatusEffect(this.GetOwner(), t"WorkspotStatus.SyncAnimation") {
      return false;
    };
    if ScriptedPuppet.IsBeingGrappled(ownerPuppet) {
      return false;
    };
    blackboard = GameInstance.GetBlackboardSystem(game).GetLocalInstanced(player.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    if blackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Locomotion) == 1 {
      distanceBuffer = this.m_bumpTriggerDistanceBufferCrouched;
    };
  };
  vehicle = GameInstance.FindEntityByID(game, evt.vehicleEntityID) as VehicleObject;
  if evt.sourceSpeed > 15.00 {
    speedModifier = 3.50;
  } else {
    if evt.sourceSpeed > 10.00 {
      speedModifier = 2.50;
    } else {
      if evt.sourceSpeed > 5.00 {
        speedModifier = 1.50;
      } else {
        if evt.sourceSpeed > 1.50 {
          speedModifier = 0.50;
        };
      };
    };
  };
  distanceSquared = evt.sourceSquaredDistance;
  triggerDistance = evt.sourceRadius + this.m_NPCRadius + distanceBuffer + speedModifier;
  if !evt.isMounted {
    triggerDistance = evt.sourceRadius + this.m_NPCRadius + distanceBuffer;
    if distanceSquared > triggerDistance * triggerDistance {
      return false;
    };
  };
  if !GameObject.IsCooldownActive(ownerPuppet, n"bumpCooldown") {
    if evt.isMounted {
      GameObject.StartCooldown(ownerPuppet, n"bumpCooldown", TDB.GetFloat(t"AIGeneralSettings.vehicleBumpCooldown"));
      if !(ownerPuppet as NPCPuppet).IsRagdolling() {
        if NotEquals(ownerPuppet.GetHighLevelStateFromBlackboard(), gamedataNPCHighLevelState.Combat) || ownerPuppet.IsPrevention() {
          this.TriggerReactionBehaviorForCrowd(vehicle, gamedataOutput.DodgeToSide, false, evt.sourcePosition);
        };
      };
    } else {
      GameObject.StartCooldown(ownerPuppet, n"bumpCooldown", 1.00);
      if this.SourceAttitude(player, EAIAttitude.AIA_Friendly) {
        return false;
      };
      if !NPCPuppet.IsInCombat(ownerPuppet) {
        GameObject.PlayVoiceOver(owner, n"bump", n"Scripts:OnBumpEvent");
      };
      broadcaster = player.GetStimBroadcasterComponent();
      workspotSystem = GameInstance.GetWorkspotSystem(game);
      if workspotSystem.IsActorInWorkspot(ownerPuppet) {
      } else {
        if this.m_inTrafficLane {
        } else {
          if this.m_inCrowd || this.IsReactionAvailableInPreset(gamedataStimType.Bump) {
            this.TriggerReactionBehaviorForCrowd(player, gamedataOutput.Bump, false);
          };
        };
      };
      let affiliationRecord: Int32 = npcPuppet.GetAffiliationInt();

      if this.m_bumpTimestamp >= EngineTime.ToFloat(GameInstance.GetSimTime(game)) {
        this.m_bumpedRecently += 1;
        // check if ncpd

        if affiliationRecord == 13 || affiliationRecord == 4  {
            this.m_bumpedRecentlyIntoNCPD += 1;
            if this.m_bumpedRecentlyIntoNCPD > 2 && IsDefined(broadcaster) {
              // AIActionHelper.TryStartCombatWithTarget(ownerPuppet, player);
              broadcaster.SendDrirectStimuliToTarget(ownerPuppet, gamedataStimType.Provoke, ownerPuppet);
          }
          if this.m_bumpedRecentlyIntoNCPD > 1 && IsDefined(broadcaster)  {
            let player: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetOwner().GetGame()).GetLocalPlayerControlledGameObject();
            if playerPuppet.m_playerClothAffiliation == 69 {
              broadcaster.SendDrirectStimuliToTarget(ownerPuppet, gamedataStimType.Combat, ownerPuppet);
            }
          }
        }
        if this.m_inCrowd {
          if this.m_bumpedRecently > 2 {
            this.TriggerFacialLookAtReaction(true, true);
            if IsDefined(broadcaster) {
              broadcaster.SendDrirectStimuliToTarget(ownerPuppet, gamedataStimType.Bump, ownerPuppet);
            };
          };
        } else {
          if this.m_reactionPreset.IsAggressive() && IsDefined(broadcaster) {
            if this.m_bumpedRecently <= 2 {
              if workspotSystem.IsActorInWorkspot(ownerPuppet) && !ownerPuppet.IsConnectedToSecuritySystem() {
                broadcaster.SendDrirectStimuliToTarget(ownerPuppet, gamedataStimType.Provoke, ownerPuppet);
              } else {
                if IsDefined(this.m_desiredReaction) {
                  this.m_desiredReaction.escalateProvoke = true;
                };
              };
            } else {
              if !this.CanTriggerReprimandOrder() && IsDefined(this.m_activeReaction) && Equals(this.m_activeReaction.reactionBehaviorName, gamedataOutput.Bump) {
                broadcaster.SendDrirectStimuliToTarget(ownerPuppet, gamedataStimType.Combat, ownerPuppet);
              };
            };
          };
        };
      } else {
        this.m_bumpedRecently = 1;
        if affiliationRecord == 13 || affiliationRecord == 4 {
            this.m_bumpedRecentlyIntoNCPD = 1;
        }
        this.m_bumpTimestamp = EngineTime.ToFloat(GameInstance.GetSimTime(game)) + 10.00;
        if this.m_inCrowd {
          this.TriggerFacialLookAtReaction(true);
        } else {
          if this.m_reactionPreset.IsAggressive() {
            if IsDefined(broadcaster) && workspotSystem.IsActorInWorkspot(ownerPuppet) && !ownerPuppet.IsConnectedToSecuritySystem() {
              broadcaster.SendDrirectStimuliToTarget(ownerPuppet, gamedataStimType.Provoke, ownerPuppet);
            };
          };
        };
      };
    };
  };
}

@wrapMethod(ReactionManagerComponent)
protected cb func OnLookedAtEvent(evt: ref<LookedAtEvent>) -> Bool {
  wrappedMethod(evt);
  let sceneSystemInt: ref<SceneSystemInterface>;
  let owner: ref<GameObject> = this.GetOwner();
  let gameInstance: GameInstance = owner.GetGame();
  let player: ref<GameObject> = GameInstance.GetPlayerSystem(owner.GetGame()).GetLocalPlayerControlledGameObject();
  if !IsDefined(player) || !IsDefined(owner) {
    return false;
  }
  // npc is unconscious, defeated, or dead, dont do nothin
  if ScriptedPuppet.IsUnconscious(owner) || ScriptedPuppet.IsDefeated(owner) || owner.IsDead() || ScriptedPuppet.IsBeingGrappled(owner) || ScriptedPuppet.IsBlinded(owner) {
      // LogChannel(n"DEBUG", s"IN scripted puppet checks. Returning FALSE!");
    return false;
  }
  let photoModeSys: ref<PhotoModeSystem> = GameInstance.GetPhotoModeSystem(owner.GetGame());
  if photoModeSys.IsPhotoModeActive() {
    return false;
  }
  let photoModeSysPlayer: ref<PhotoModeSystem> = GameInstance.GetPhotoModeSystem(player.GetGame());
  if photoModeSysPlayer.IsPhotoModeActive() {
    return false;
  }
  sceneSystemInt = GameInstance.GetSceneSystem(owner.GetGame()).GetScriptInterface();
  if IsDefined(sceneSystemInt) {
    // npc AND player in scene, dont do anything
    if (sceneSystemInt.IsEntityInScene(owner.GetEntityID()) && sceneSystemInt.IsEntityInScene(player.GetEntityID())) || sceneSystemInt.IsEntityInDialogue(owner.GetEntityID()) {
      // LogChannel(n"DEBUG", s"IN SCENEE!! RETURNING FALSE");
      return false;
    }
    else {
      // LogChannel(n"DEBUG", s"Responsive NPCs: =====> InLookedAt. Scene check success, doing nothing");
    }
  }

  if evt.isLookedAt {
    let playerPuppet: ref<PlayerPuppet> = player as PlayerPuppet;
    if !IsDefined(playerPuppet) {
      return false;
    }
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(gameInstance);
    let checkWantedFact: Int32 = 0;
    if IsDefined(questsSystem) {
      checkWantedFact = questsSystem.GetFact(n"wanted_level");
    }
    let ownerPuppet: ref<ScriptedPuppet> = this.GetOwnerPuppet();
    if !IsDefined(ownerPuppet) {
      return false;
    }
    if ownerPuppet.IsConnectedToSecuritySystem() {
      return false;
    }
    let npcPuppet: ref<NPCPuppet> = ownerPuppet as NPCPuppet;
    if !IsDefined(npcPuppet) {
      return false;
    }
    let isNpcArmed: Bool = false;
    if IsDefined(ScriptedPuppet.GetActiveWeapon(npcPuppet)) {
      isNpcArmed = true;
    }

    let senseComponent: ref<SenseComponent> = ownerPuppet.GetSensesComponent();
    // LogChannel(n"DEBUG", s" GET DETECTION MULTI!! ====  ==  \(senseComponent.GetDetectionMultiplier(this.GetEntity().GetEntityID()))");

    // playerPuppet.PrintSlotItem();
    // check if player is wanted 4 stars or above, if so, create fear
    if checkWantedFact >= 4 {
      let stimEvent: ref<StimuliEvent> = new StimuliEvent();
      stimEvent.SetStimType(gamedataStimType.SilentAlarm);
      stimEvent.sourceObject = player;
      stimEvent.sourcePosition = stimEvent.sourceObject.GetWorldPosition();
      stimEvent.radius = 20.0;
      NPCPuppet.ChangeHighLevelState(owner, gamedataNPCHighLevelState.Fear);
      let fearPhase: Int32 = 2;
      if fearPhase >= 1 {
          this.CreateFearArea(stimEvent, fearPhase);
      }
      if this.m_inCrowd {
          let crowdMemberComponent: ref<CrowdMemberBaseComponent> = ownerPuppet.GetCrowdMemberComponent();
          crowdMemberComponent.SetThreatLastKnownPosition(player.GetWorldPosition());
          crowdMemberComponent.ChangeFearStage(gameFearStage.Stressed, true);
      }
      if !GameObject.IsCooldownActive(owner, n"bumpCooldown") {
          GameObject.StartCooldown(owner, n"bumpCooldown", 3.0);
          GameObject.PlayVoiceOver(owner, n"fear_foll", n"Scripts:OnBumpEvent");
            this.TriggerFacialLookAtReaction(true, false);
      }
      return true;
    }

    let npcAffiliation: Int32 = npcPuppet.GetAffiliationInt();
    let isSameDirection: Bool = ReactionManagerComponent.IsTargetInFrontOfSource(owner, player);

    // FTLog(s"[Naked Check] Player Cloth aff: \(playerPuppet.m_playerClothAffiliation), Target NPC aff: \(npcAffiliation), Buck Naked: \(playerPuppet.m_playerBuckNaked), Same Direction: \(isSameDirection)");


    if (playerPuppet.m_isModSettingsInstalled && playerPuppet.m_responsiveNPCModSettings.isStalkingEnabled) || !playerPuppet.m_isModSettingsInstalled {
      // start stalk checks
      // LogChannel(n"DEBUG", s"In Lookedat! IN CHECKING STALK! isStalkingEnabled defined"); 
      this.CheckStalk(owner, 7.0);
    }

    // two separate checks for naked and triggering crowd reaction
    if playerPuppet.m_playerClothAffiliation == 69
      &&
      ( isSameDirection )
      &&
      (
        npcAffiliation == 7
          // || Equals(npcPuppet.GetAffiliationInt(), 3)
          // || Equals(npcPuppet.GetAffiliationInt(), 9)
          // || Equals(npcPuppet.GetAffiliationInt(), 35)
          // || Equals(npcPuppet.GetAffiliationInt(), 6)
          || npcPuppet.MatchVisualTag(n"anim_Posh")
          || npcPuppet.MatchVisualTag(n"anim_MidCorp")
          || npcPuppet.MatchVisualTag(n"anim_Worker")
          || npcPuppet.MatchVisualTag(n"anim_Elder")
          || npcPuppet.MatchVisualTag(n"anim_Nightlife")
          || npcPuppet.MatchVisualTag(n"anim_LowCorp")
          )
        && !npcPuppet.MatchVisualTag(n"anim_Homeless")
        && !npcPuppet.MatchVisualTag(n"anim_Lowlife")
        && !npcPuppet.MatchVisualTag(n"anim_Borg")
        && !npcPuppet.MatchVisualTag(n"anim_Drunk")
        && !npcPuppet.MatchVisualTag(n"anim_Freak")
        && !isNpcArmed
        {
        // FTLog(s"naked yes - inside reaction");
        let stimEvent: ref<StimuliEvent> = new StimuliEvent();
        if playerPuppet.m_isAlmostCyberpsycho {
          stimEvent.SetStimType(gamedataStimType.Alarm);
          stimEvent.sourceObject = player;
          stimEvent.sourcePosition = stimEvent.sourceObject.GetWorldPosition();
          stimEvent.radius = 8.0;
        }
        else {
          stimEvent.SetStimType(gamedataStimType.SilentAlarm);
          stimEvent.sourceObject = player;
          stimEvent.sourcePosition = stimEvent.sourceObject.GetWorldPosition();
          stimEvent.radius = 5.0;
        }
        NPCPuppet.ChangeHighLevelState(owner, gamedataNPCHighLevelState.Fear);
        let fearPhase: Int32 = 1;
        if fearPhase >= 1 {
            this.CreateFearArea(stimEvent, fearPhase);
        }

          if this.m_inCrowd {
              let crowdMemberComponent: ref<CrowdMemberBaseComponent> = ownerPuppet.GetCrowdMemberComponent();
              crowdMemberComponent.SetThreatLastKnownPosition(player.GetWorldPosition());
              if playerPuppet.m_isAlmostCyberpsycho {
                crowdMemberComponent.ChangeFearStage(gameFearStage.Alarmed, true);
                this.TriggerFacialLookAtReaction(true, false);
              }
              else {
                crowdMemberComponent.ChangeFearStage(gameFearStage.Stressed, true);
                this.TriggerFacialLookAtReaction(true, false);
              }
          }
          if !GameObject.IsCooldownActive(owner, n"bumpCooldown") {
              GameObject.StartCooldown(owner, n"bumpCooldown", 5.0);
              GameObject.PlayVoiceOver(owner, n"fear_foll", n"Scripts:OnBumpEvent");
              this.TriggerFacialLookAtReaction(true, false);
          }
        
    }

    if playerPuppet.m_playerClothAffiliation == 69 && playerPuppet.m_playerBuckNaked
        &&
        ( isSameDirection )
        &&
        (
          (Equals(npcPuppet.GetAffiliationInt(), 7)
            || Equals(npcPuppet.GetAffiliationInt(), 28)
            || Equals(npcPuppet.GetAffiliationInt(), 3)
            || npcPuppet.MatchVisualTag(n"anim_Posh")
            || npcPuppet.MatchVisualTag(n"anim_MidCorp")
            || npcPuppet.MatchVisualTag(n"anim_LowCorp")
            || npcPuppet.MatchVisualTag(n"anim_Elder")
            || npcPuppet.MatchVisualTag(n"anim_Worker")
            || npcPuppet.MatchVisualTag(n"anim_Nightlife")
            || npcPuppet.MatchVisualTag(n"anim_Monk"))
          && !npcPuppet.MatchVisualTag(n"anim_Homeless")
          && !npcPuppet.MatchVisualTag(n"anim_Lowlife")
          && !npcPuppet.MatchVisualTag(n"anim_Drunk")
          && !npcPuppet.MatchVisualTag(n"anim_Borg")
          && !npcPuppet.MatchVisualTag(n"anim_Freak")
          && !isNpcArmed
        )
          {
          // FTLog(s"buck naked yes - inside reaction");
          let stimEvent: ref<StimuliEvent> = new StimuliEvent();
          stimEvent.SetStimType(gamedataStimType.Alarm);
          stimEvent.sourceObject = player;
          stimEvent.sourcePosition = stimEvent.sourceObject.GetWorldPosition();
          if playerPuppet.m_isAlmostCyberpsycho {
            stimEvent.radius = 7.0;
          }
          else {
            stimEvent.radius = 12.0;
          }
          NPCPuppet.ChangeHighLevelState(owner, gamedataNPCHighLevelState.Fear);
          let fearPhase: Int32 = 2;
          if fearPhase >= 1 {
              this.CreateFearArea(stimEvent, fearPhase);
          }
 
            if this.m_inCrowd {
              let crowdMemberComponent: ref<CrowdMemberBaseComponent> = this.GetOwnerPuppet().GetCrowdMemberComponent();
              crowdMemberComponent.SetThreatLastKnownPosition(player.GetWorldPosition());
              if playerPuppet.m_isAlmostCyberpsycho {
                crowdMemberComponent.ChangeFearStage(gameFearStage.Panic, true);
                this.TriggerFacialLookAtReaction(true, false);
              }
              else {
                crowdMemberComponent.ChangeFearStage(gameFearStage.Alarmed, true);
                this.TriggerFacialLookAtReaction(true, false);
              }
            }
            if !GameObject.IsCooldownActive(owner, n"bumpCooldown") {
                GameObject.StartCooldown(owner, n"bumpCooldown", 3.0);
                GameObject.PlayVoiceOver(owner, n"fear_foll", n"Scripts:TriggerLookAtReaction");
            }
          
      }

      // for facial reaction
      let lookAtData: LookAtData;
      let facialReactionAnimFeature: ref<AnimFeature_FacialReaction> = new AnimFeature_FacialReaction();

      facialReactionAnimFeature.category = 1;
      this.ActivateReactionLookAt(player, true);
      this.m_facialCooldown = 5.00;

      if playerPuppet.m_playerClothAffiliation == 69 {
        if (npcPuppet.MatchVisualTag(n"anim_Lowlife")) {
            facialReactionAnimFeature.idle = 3; // Aggressive
        } else if (npcPuppet.MatchVisualTag(n"anim_Drunk") || npcPuppet.MatchVisualTag(n"anim_DirtGirl")) {
            facialReactionAnimFeature.idle = 5; // Joy
        } else if (npcPuppet.MatchVisualTag(n"anim_Freak")) {
            facialReactionAnimFeature.idle = 1; // Curiosity
        }
      }
      else if playerPuppet.GetActiveWeaponDetectionMultplier() > 0.5 {
        facialReactionAnimFeature.idle = 10; // fear
        AnimationControllerComponent.ApplyFeatureToReplicate(owner, n"FacialReaction", facialReactionAnimFeature);
      }
      // check if player is poor and if we're looking at a posh/rich NPC. If so set disgusted facial reaction.
      else if playerPuppet.m_isPlayerBroke && ( npcPuppet.MatchVisualTag(n"anim_Posh")
              || npcPuppet.MatchVisualTag(n"anim_MidCorp")
              || npcPuppet.MatchVisualTag(n"anim_LowCorp")
              || npcPuppet.MatchVisualTag(n"anim_Nightlife")
              || (npcAffiliation == 3)
              || (npcAffiliation == 12)
              || (npcAffiliation == 9)
              || (npcAffiliation == 5)
              ) {
        // Force Disgust Reaction
        facialReactionAnimFeature.category = 3;
        facialReactionAnimFeature.idle = 7; // Disgusted idle
        this.ActivateReactionLookAt(player, true); 
        AnimationControllerComponent.ApplyFeatureToReplicate(owner, n"FacialReaction", facialReactionAnimFeature);
      }
    

      // LogChannel(n"DEBUG", s" check in looked at,  val  ===\(playerPuppet.m_currentClothingReactionPreset) and \(isSameDirection) and \(this.IsTargetClose(player, 5.0))");

      if ((playerPuppet.m_isModSettingsInstalled && playerPuppet.m_responsiveNPCModSettings.isCustomReactionsEnabled) || !playerPuppet.m_isModSettingsInstalled) {
      // start stalk checks
      // Custom cloth tag reaction
          let vo: CName;
          if playerPuppet.m_currentClothingReactionPreset != 0 && this.IsTargetClose(player, 5.0) && isSameDirection && !npcPuppet.MatchVisualTag(n"anim_Homeless") && !GameObject.IsCooldownActive(owner, n"interestingClothLookat")
          {
            GameObject.StartCooldown(owner, n"interestingClothLookat", 5.0);
            let facialReactionAnimFeature: ref<AnimFeature_FacialReaction> = new AnimFeature_FacialReaction();
            let duration: Float = 4.0;
            switch(playerPuppet.m_currentClothingReactionPreset) {
              case 1:
                vo = n"greeting";
                facialReactionAnimFeature.category = 3;
                facialReactionAnimFeature.idle = 5; // joy i think
                duration = 4.0;
                break;
              case 2:
                vo = n"bump";
                facialReactionAnimFeature.category = 3;
                facialReactionAnimFeature.idle = 7; // Disgusted idle
                duration = 4.0;
                break;
              case 3:
                vo = n"fear_foll";
                facialReactionAnimFeature.category = 3;
                facialReactionAnimFeature.idle = 8; // Disgusted idle
                duration = 2.0;
                break;
            }
            // LogChannel(n"DEBUG", s" m_currentClothingReactionPreset!= 0!!!!!! WOW val vo ===\(playerPuppet.m_currentClothingReactionPreset)");

            GameObject.PlayVoiceOver(owner, vo, n"Scripts:TriggerLookAtReaction");
            this.ActivateReactionLookAt(player, false, false, duration, true); 
            this.m_facialCooldown = 5.00;
            AnimationControllerComponent.ApplyFeatureToReplicate(this.GetOwner(), n"FacialReaction", facialReactionAnimFeature);
          }
        }
    
  }
}

// @wrapMethod(SenseComponent)
// protected cb func OnSenseInitialize(evt: ref<SenseInitializeEvent>) -> Bool {
//   wrappedMethod(evt);
//       LogChannel(n"DEBUG", s" OnSenseInitialize OnSenseInitialize OnSenseInitialize OnSenseInitialize OnSenseInitialize");
// }

@addMethod(ReactionManagerComponent)
private final func UpdateDetectionMultiplier() -> Void {
  let owner: ref<GameObject> = this.GetOwner();
  let ownerPuppet: ref<ScriptedPuppet> = this.GetOwnerPuppet();
  if !IsDefined(ownerPuppet) {
    return;
  }
  let npcPuppetz: ref<NPCPuppet> = ownerPuppet as NPCPuppet;
  let affiliationRecord: Int32 = npcPuppetz.GetAffiliationInt();
  let player: ref<GameObject> = GameInstance.GetPlayerSystem(owner.GetGame()).GetLocalPlayerControlledGameObject();
  if !IsDefined(player) {
    return;
  }
  let playerPuppet: ref<PlayerPuppet> = player as PlayerPuppet;
  if !IsDefined(playerPuppet) {
    return;
  }
  let investigateData: stimInvestigateData;
  let senseComponent: ref<SenseComponent> = ownerPuppet.GetSensesComponent();
  if !IsDefined(senseComponent) {
    return;
  }
  // LogChannel(n"DEBUG", s"Initialiaze . Cloth aff ==== \(playerPuppet.m_playerClothAffiliation)  and target ======== \(affiliationRecord)");

  let factionBehaviorState: Int32 = 0;
  let initialDetectionMultiplier: Float = this.m_initialDetectionMultiplier;

  // quest-based
  if playerPuppet.m_factionBehaviorMap.KeyExist(Cast<Uint64>(affiliationRecord)) {
    factionBehaviorState = playerPuppet.m_factionBehaviorMap.Get(Cast<Uint64>(affiliationRecord));
    if (playerPuppet.m_isModSettingsInstalled && !playerPuppet.m_responsiveNPCModSettings.isQuestRetaliationEnabled) {
      factionBehaviorState = 0;
    }
    // LogChannel(n"DEBUG", s"Initialiaze faction behavior map key exists!!!!!!!!!! NCPD state ==== \(playerPuppet.m_playerRivalAffiliationMap.Get(13u))");

    if factionBehaviorState != 0 {
      // LogChannel(n"DEBUG", s" Initialiaze BEFORE CALCULATION  multiplier GET ==  \(senseComponent.GetDetectionMultiplier(this.GetEntity().GetEntityID()))");
      // LogChannel(n"DEBUG", s" Initialiaze faction behavior state != 0");
      if factionBehaviorState == 3 {
          initialDetectionMultiplier += 0.25;
      }
      else if factionBehaviorState == 2 {
          initialDetectionMultiplier += 0.2;
      }
      else if factionBehaviorState == 1 {
          initialDetectionMultiplier += 0.125;
      }
      else if factionBehaviorState == -1 {
          initialDetectionMultiplier -= 0.1;
      }
    }
  }

  initialDetectionMultiplier += playerPuppet.GetActiveWeaponDetectionMultplier();

  // i dont need a mod setting check here because i already did it while calculating m_currentDetectionMultiplier. Same for above

  // vehicle reaction checks
  initialDetectionMultiplier += playerPuppet.m_currentGeneralDetectionMultiplier;

  // check if this guy is a cop. If not, then we want to minus crystal coat stuff since thats only relevant for preventionsystem for the moment. There arent any other chases anyways maybe except the quest retaliation but that's always 2 vehicles so 
  // if affiliationRecord != 13 || affiliationRecord != 4 || affiliationRecord != 12 || affiliationRecord != 26 {
  //   initialDetectionMultiplier -= playerPuppet.m_currentCrystalCoatDetectionMultiplier;
  // }

  // sanity check because we dont want to divide by zero
  if initialDetectionMultiplier == 0.0 {
    initialDetectionMultiplier = 0.25;
  }

  if (affiliationRecord == playerPuppet.m_playerClothAffiliation) || (affiliationRecord == playerPuppet.m_playerVehicleAffiliation) {
      initialDetectionMultiplier += playerPuppet.m_currentDisguiseDetectionMultiplier;
      initialDetectionMultiplier = 1.0/initialDetectionMultiplier;
      // LogChannel(n"DEBUG", s"detection multiplier set == ALLY \(initialDetectionMultiplier)");
    }
    else if playerPuppet.m_playerRivalAffiliationMap.KeyExist(Cast<Uint64>(affiliationRecord)) {
      // LogChannel(n"DEBUG", s"Initialiaze HELOOOoooooOo IN m_playerRivalAffiliationMap");
      initialDetectionMultiplier += playerPuppet.m_currentDisguiseDetectionMultiplier;
    }
    else if playerPuppet.m_playerAllyAffiliationMap.KeyExist(Cast<Uint64>(affiliationRecord)) {
      initialDetectionMultiplier += playerPuppet.m_currentDisguiseDetectionMultiplier;
      initialDetectionMultiplier = 1.0/initialDetectionMultiplier;
      // LogChannel(n"DEBUG", s"detection multiplier set == ALLY \(initialDetectionMultiplier)");
    }
  
  // LogChannel(n"DEBUG", s"InitialiazeInitialiazeInitialiazeInitialiaze initialDetectionMultiplier   set ==  \(initialDetectionMultiplier)");

  // another sanity check since it could be <= 0. i dont know what happens when this is zero or negative, i assume something bad. just putting a baseline of 0.25 for now. the name "multiplier" is also misleading because it is just adding a multiplier? Todo fix it someday
  if initialDetectionMultiplier <= 0.0 {
    initialDetectionMultiplier = 0.25;
  }

  senseComponent.SetDetectionMultiplier(this.GetEntity().GetEntityID(), initialDetectionMultiplier);
  // LogChannel(n"DEBUG", s" AFTER CALCULATION GET DM ====  ==  \(senseComponent.GetDetectionMultiplier(this.GetEntity().GetEntityID()))");

}

@wrapMethod(ReactionManagerComponent)
private final func Initialiaze() -> Void {
  wrappedMethod();
  let senseComponent: ref<SenseComponent> = this.GetOwnerPuppet().GetSensesComponent();
  if !IsDefined(senseComponent) {
    return;
  }
  this.m_initialDetectionMultiplier = senseComponent.GetDetectionMultiplier(this.GetEntity().GetEntityID());

  this.UpdateDetectionMultiplier();
}

@replaceMethod(ReactionManagerComponent)
protected cb func OnDetectedEvent(evt: ref<OnDetectedEvent>) -> Bool {
  let ownerPuppet: ref<ScriptedPuppet> = this.GetOwnerPuppet();
  let npcPuppetz: ref<NPCPuppet> = ownerPuppet as NPCPuppet;
  let affiliationRecord: Int32 = npcPuppetz.GetAffiliationInt();
  let player: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetOwner().GetGame()).GetLocalPlayerControlledGameObject();
  let playerPuppet: ref<PlayerPuppet>;
  playerPuppet = player as PlayerPuppet;
  let broadcaster: ref<StimBroadcasterComponent>;
  let deviceLink: ref<PuppetDeviceLinkPS>;
  let ignoreListEvent: ref<IgnoreListEvent>;
  let investigateData: stimInvestigateData;
  let scriptedPuppetTarget: ref<ScriptedPuppet>;
  let securitySystem: ref<SecuritySystemControllerPS>;
  let securitySystemInput: ref<SecuritySystemInput>;
  let targetOfSource: wref<GameObject>;
  let owner: ref<GameObject> = this.GetOwner();
  let onlyAlertNoThreat: Bool = true;
  this.LogStart(EReactLogSource.Detected, "handling event");
  if ScriptedPuppet.IsBlinded(ownerPuppet) {
    this.LogFailure("owner is blinded");
    return false;
  };
  if !IsDefined(evt.target) {
    this.LogFailure("no target");
    return false;
  };
  if !evt.isVisible {
    this.LogFailure("target is not visible");
    return false;
  };
  if evt.target.IsPlayer() {
    deviceLink = owner.GetDeviceLink() as PuppetDeviceLinkPS;
    if IsDefined(deviceLink) {
      deviceLink.NotifyAboutSpottingPlayer(true);
    };
    if this.IsPlayerAiming() && this.IsReactionAvailableInPreset(gamedataStimType.AimingAt) || this.DidTargetMakeMeAlerted(evt.target) {
      AIActionHelper.TryStartCombatWithTarget(ownerPuppet, evt.target);
      // LogChannel(n"DEBUG", s"starting combat with target (target aiming at owner)");
      this.LogSuccess("starting combat with target (target aiming at owner)");
      return false;
    };
    broadcaster = evt.target.GetStimBroadcasterComponent();
    securitySystem = ownerPuppet.GetSecuritySystem();
    if Equals(this.m_reactionPreset.Type(), gamedataReactionPresetType.Civilian_Guard) || Equals(this.m_reactionPreset.Type(), gamedataReactionPresetType.Civilian_Grabbable) {
      broadcaster.SendDrirectStimuliToTarget(owner, gamedataStimType.SecurityBreach, owner);
      this.LogSuccess("broadcasted SecurityBreach to owner");
    } else {
      if IsDefined(securitySystem) {
        securitySystemInput = deviceLink.ActionSecurityBreachNotification(evt.target.GetWorldPosition(), evt.target, ESecurityNotificationType.DEFAULT);
        if Equals(securitySystem.DetermineSecuritySystemState(securitySystemInput, true), ESecuritySystemState.COMBAT) {
          AIActionHelper.TryStartCombatWithTarget(ownerPuppet, evt.target);
          this.LogSuccess("starting combat with target (security system in combat)");
        }
        else {
          let senseComponent: ref<SenseComponent> = this.GetOwnerPuppet().GetSensesComponent();
          if !IsDefined(senseComponent) {
            return false;
          }
          // LogChannel(n"DEBUG", s"detected event inside check... just before factionmap key exist. Cloth aff ==== \(playerPuppet.m_playerClothAffiliation)  and target ======== \(affiliationRecord)");

          let factionBehaviorState: Int32 = 0;
          let detectionMultiplier: Float = 1.0;

          if playerPuppet.m_factionBehaviorMap.KeyExist(Cast<Uint64>(affiliationRecord)) {
            factionBehaviorState = playerPuppet.m_factionBehaviorMap.Get(Cast<Uint64>(affiliationRecord));
            // LogChannel(n"DEBUG", s"faction behavior map key exists!!!!!!!!!! NCPD state ==== \(playerPuppet.m_playerRivalAffiliationMap.Get(13u))");

            if (playerPuppet.m_isModSettingsInstalled && !playerPuppet.m_responsiveNPCModSettings.isQuestRetaliationEnabled) {
                // default behavior when disabled from mod settings
                factionBehaviorState = 0;
            }

            if factionBehaviorState != 0 {
              if factionBehaviorState == 1 {
                // hack to get full detection but no escalation
                broadcaster.SendDrirectStimuliToTarget(owner, gamedataStimType.AimingAt, owner, investigateData);
                // broadcaster.TriggerSingleBroadcast(owner, gamedataStimType.Combat, 100.0);
                // LogChannel(n"DEBUG", s"ONDETECTED! triggered security system notification AIMINGAT in === \(factionBehaviorState) AND \(senseComponent.GetDetectionMultiplier(evt.target.GetEntityID()))");
                // let currDM: Float = senseComponent.GetDetectionMultiplier(evt.target.GetEntityID());
                // senseComponent.SetDetectionMultiplier(evt.target.GetEntityID(), playerPuppet.m_currentDetectionMultiplier + 0.15);
                ownerPuppet.TriggerSecuritySystemNotification(evt.target.GetWorldPosition(), evt.target, ESecurityNotificationType.DEFAULT);
              }
              else if factionBehaviorState == 2 {
                ownerPuppet.TriggerSecuritySystemNotification(evt.target.GetWorldPosition(), evt.target, ESecurityNotificationType.REPRIMAND_ESCALATE);
                // LogChannel(n"DEBUG", s"ONDETECTED! triggered security system notification REPRIMAND_ESCALATE in, state=== \(factionBehaviorState)");
                // LogChannel(n"DEBUG", s"ONDETECTED! triggered security system notification PROVOKE!!!!!!!!!! 22222 in === \(factionBehaviorState) AND \(senseComponent.GetDetectionMultiplier(evt.target.GetEntityID()))");
              }
              else if factionBehaviorState == 3 {
                ownerPuppet.TriggerSecuritySystemNotification(evt.target.GetWorldPosition(), evt.target, ESecurityNotificationType.COMBAT);
                // LogChannel(n"DEBUG", s"ONDETECTED!!!!!() => triggered security system notification COMBAT in, state=== \(factionBehaviorState)");
                // LogChannel(n"DEBUG", s"ONDETECTED! triggered security system notification COMBAT!!!!!!!!!! 33333333333 in === \(factionBehaviorState) AND \(senseComponent.GetDetectionMultiplier(evt.target.GetEntityID()))");
              }
              // else if factionBehaviorState == -1 {
              //   // dont trigger anything. edit: this was a bad idea. ALWAYS trigger something
              //   LogChannel(n"DEBUG", s"ONDETECTED triggered security system notification -1 -1 -1 NONE!!!!!!!!!!!! in, state=== \(factionBehaviorState)");
              // }
              else {
                // LogChannel(n"DEBUG", s"triggered security system notification DEFAULT in, state=== \(factionBehaviorState)");
                ownerPuppet.TriggerSecuritySystemNotification(evt.target.GetWorldPosition(), evt.target, ESecurityNotificationType.DEFAULT);
              }
              // senseComponent.RemoveDetectionAttitudeOverwrite(n"player");
              // senseComponent.m_shouldStartDetectingPlayerCached = true;
            }
          }
          else {
            // LogChannel(n"DEBUG", s"--------faction behavior map key DOES NOT exist!!!!!!!!!! triggering default ");
            ownerPuppet.TriggerSecuritySystemNotification(evt.target.GetWorldPosition(), evt.target, ESecurityNotificationType.DEFAULT);
          }
          this.LogSuccess("triggered security system notification");
          // LogChannel(n"DEBUG", s"triggered security system notification in");
        };
      }
      else {
        // LogChannel(n"DEBUG", s"--------SECURITY SYSTEM IS NOT DEFINED!!!!!!!!!!!! WAAAAAAHHHHHHHHHHHHHH ");
        let senseComponent: ref<SenseComponent> = this.GetOwnerPuppet().GetSensesComponent();
        if !IsDefined(senseComponent) {
          return false;
        }
        // LogChannel(n"DEBUG", s"detected event inside check... just before factionmap key exist");

        let factionBehaviorState: Int32 = 0;
        let detectionMultiplier: Float = 1.0;

        if playerPuppet.m_factionBehaviorMap.KeyExist(Cast<Uint64>(affiliationRecord)) {
          factionBehaviorState = playerPuppet.m_factionBehaviorMap.Get(Cast<Uint64>(affiliationRecord));
          // LogChannel(n"DEBUG", s"faction behavior map key exists!!!!!!!!!! state ==== \(factionBehaviorState)");

          if (playerPuppet.m_isModSettingsInstalled && !playerPuppet.m_responsiveNPCModSettings.isQuestRetaliationEnabled) {
              // default behavior when disabled from mod settings
              factionBehaviorState = 0;
          }

          if factionBehaviorState != 0 {
            if factionBehaviorState == 1 {
              // hack to get full detection but no escalation
              broadcaster.SendDrirectStimuliToTarget(owner, gamedataStimType.AimingAt, owner, investigateData);
              // broadcaster.TriggerSingleBroadcast(owner, gamedataStimType.Combat, 100.0);
              // LogChannel(n"DEBUG", s"ONDETECTED! triggered security system notification AIMINGAT in === \(factionBehaviorState) AND \(playerPuppet.m_currentDetectionMultiplier)");
              // let currDM: Float = senseComponent.GetDetectionMultiplier(evt.target.GetEntityID());
              ownerPuppet.TriggerSecuritySystemNotification(evt.target.GetWorldPosition(), evt.target, ESecurityNotificationType.DEFAULT);
            }
            else if factionBehaviorState == 2 {
              broadcaster.SendDrirectStimuliToTarget(owner, gamedataStimType.Provoke, owner, investigateData);

              // ownerPuppet.TriggerSecuritySystemNotification(evt.target.GetWorldPosition(), evt.target, ESecurityNotificationType.REPRIMAND_ESCALATE);
              // LogChannel(n"DEBUG", s"ONDETECTED! triggered security system notification REPRIMAND_ESCALATE in, state=== \(factionBehaviorState)");
            }
            else if factionBehaviorState == 3 {
              broadcaster.SendDrirectStimuliToTarget(owner, gamedataStimType.Combat, owner, investigateData);
              // LogChannel(n"DEBUG", s"ONDETECTED!!!!!() => triggered security system notification COMBAT in, state=== \(factionBehaviorState)");
            }
            else {
              // LogChannel(n"DEBUG", s"triggered security system notification DEFAULT in, state=== \(factionBehaviorState)");
              ownerPuppet.TriggerSecuritySystemNotification(evt.target.GetWorldPosition(), evt.target, ESecurityNotificationType.DEFAULT);
            }
            // else if factionBehaviorState == -1 {
            //   // dont trigger anything. edit: this was a bad idea. ALWAYS trigger something
            //   LogChannel(n"DEBUG", s"ONDETECTED triggered security system notification -1 -1 -1 NONE!!!!!!!!!!!! in, state=== \(factionBehaviorState)");
            // }
          }
        }
        else {
          // LogChannel(n"DEBUG", s"--------faction behavior map key DOES NOT exist!!!!!!!!!! triggering default ");
          ownerPuppet.TriggerSecuritySystemNotification(evt.target.GetWorldPosition(), evt.target, ESecurityNotificationType.DEFAULT);
        }
      }
    };
    if this.IsTargetArmed(evt.target) && IsDefined(broadcaster) {
      broadcaster.SendDrirectStimuliToTarget(owner, gamedataStimType.WeaponDisplayed, owner);
      this.LogSuccess("broadcasted WeaponDisplayed to owner");
    };
    if StatusEffectSystem.ObjectHasStatusEffect(evt.target, t"PreventionStatusEffect.PerformingIllegalAction") && this.IsReactionAvailableInPreset(gamedataStimType.IllegalAction) {
      broadcaster.SendDrirectStimuliToTarget(owner, gamedataStimType.IllegalAction, owner);
      this.LogSuccess("broadcasted IllegalAction to owner");
    };
    return false;
  };
  if Equals(this.m_highLevelState, gamedataNPCHighLevelState.Combat) && ownerPuppet.IsPrevention() && Equals((evt.target as ScriptedPuppet).GetHighLevelStateFromBlackboard(), gamedataNPCHighLevelState.Combat) && this.SourceAttitude(evt.target, EAIAttitude.AIA_Neutral) {
    AIActionHelper.TryStartCombatWithTarget(ownerPuppet, evt.target);
    this.LogSuccess("starting combat with target (already in combat)");
    return false;
  };
  if NotEquals(this.m_highLevelState, gamedataNPCHighLevelState.Combat) && evt.target.IsPuppet() && !evt.target.IsDead() && !ownerPuppet.IsCharacterCivilian() && !ownerPuppet.IsCharacterChildren() && this.SourceAttitude(evt.target, EAIAttitude.AIA_Friendly) {
    targetOfSource = this.GetCombatTarget(evt.target);
    if this.IsTargetSquadAlly(evt.target) || this.IsTargetInSameSecuritySystem(evt.target) || this.ShouldHelpTargetFromSameAttitudeGroup(evt.target, targetOfSource) || this.ShouldHelpCausePlayerGotTooClose(targetOfSource, onlyAlertNoThreat) {
      scriptedPuppetTarget = evt.target as ScriptedPuppet;
      if Equals(scriptedPuppetTarget.GetStimReactionComponent().GetReactionPreset().Type(), gamedataReactionPresetType.Civilian_Guard) || Equals(scriptedPuppetTarget.GetStimReactionComponent().GetReactionPreset().Type(), gamedataReactionPresetType.Civilian_Grabbable) {
        if Equals(scriptedPuppetTarget.GetHighLevelStateFromBlackboard(), gamedataNPCHighLevelState.Fear) && Equals(this.m_highLevelState, gamedataNPCHighLevelState.Relaxed) {
          NPCPuppet.ChangeHighLevelState(owner, gamedataNPCHighLevelState.Alerted);
          this.LogSuccess("entering alerted state (ally in fear)");
        };
      } else {
        this.LogInfo("HelpAlly attempt - friend detected");
        this.HelpAlly(scriptedPuppetTarget, targetOfSource, onlyAlertNoThreat);
      };
    };
  };
  if NotEquals(evt.description, n"Dead_Body") && NotEquals(evt.description, n"Unconscious") && NotEquals(evt.description, n"HeartAttack") {
    return false;
  };
  this.LogInfo("handling dead/defeated body");
  if this.HasCombatTarget() {
    if ArrayContains(this.m_ignoreList, evt.target.GetEntityID()) {
      this.LogSuccess("body already ignored");
    } else {
      ArrayPush(this.m_ignoreList, ignoreListEvent.bodyID);
      ignoreListEvent = new IgnoreListEvent();
      ignoreListEvent.bodyID = evt.target.GetEntityID();
      this.SendIgnoreEventToSquad(ignoreListEvent);
      this.LogSuccess("new body ignored");
    };
    return false;
  };
  broadcaster = evt.target.GetStimBroadcasterComponent();
  if IsDefined(broadcaster) {
    if Equals(evt.description, n"Dead_Body") {
      investigateData.attackInstigator = EntityGameInterface.GetEntity(GameInstance.GetPlayerSystem(owner.GetGame()).GetLocalPlayerControlledGameObject().GetEntity());
    };
    broadcaster.SendDrirectStimuliToTarget(owner, gamedataStimType.DeadBody, owner, investigateData);
    this.LogSuccess("broadcasted DeadBody to owner");
  };
}

// for early detection
@wrapMethod(SenseComponent)
private final func IsTargetInteresting(target: wref<GameObject>) -> Bool {

  // LogChannel(n"DEBUG", s"In IsTargetInteresting() => Target Detection  ========= \(this.GetDetection(target.GetEntityID())) and Multiplier ======= \(this.GetDetectionMultiplier(target.GetEntityID()))");

  // LogChannel(n"DEBUG", s"In IsTargetInteresting() => Owner Detection  ========= \(this.GetDetection(owner.GetEntityID())) and Multiplier ======= \(this.GetDetectionMultiplier(owner.GetEntityID()))");
  // LogChannel(n"DEBUG", s"===================================");
  let ownerPuppet: ref<ScriptedPuppet> = this.GetOwnerPuppet();
  if !IsDefined(ownerPuppet) {
    return false;
  };
  if !IsDefined(target) {
    return false;
  };
  let playerPuppet: ref<PlayerPuppet> = target as PlayerPuppet;
  if playerPuppet.m_playerClothAffiliation == 69 && playerPuppet.m_isAlmostCyberpsycho {
      let currDetectionMultiplier: Float = this.GetDetectionMultiplier(target.GetEntityID());
      this.SetDetectionMultiplier(target.GetEntityID(), currDetectionMultiplier + 0.15);
      return true;
  }

  if playerPuppet.m_playerClothAffiliation == 69 {
      return true;
  }

  let npcPuppet: ref<NPCPuppet> = ownerPuppet as NPCPuppet;
  let affiliationRecord: Int32 = npcPuppet.GetAffiliationInt();

  if playerPuppet.GetActiveWeaponDetectionMultplier() > 0.5 {
    // LogChannel(n"DEBUG", s"YES!!!!!! target itnestsing ");
    return true;
  }
  // check drunk driving
  if (playerPuppet.m_isModSettingsInstalled && playerPuppet.m_responsiveNPCModSettings.isVehicleReactionEnabled || !playerPuppet.m_isModSettingsInstalled) {
    if IsDefined(playerPuppet.m_mountedVehicle) {
      let stackCount: Int32;
      let drunkID: TweakDBID = t"BaseStatusEffect.Drunk";

      stackCount = Cast<Int32>(StatusEffectHelper.GetStatusEffectByID( target, drunkID).GetStackCount());
      if stackCount >= 1 && affiliationRecord == 13 {
        // LogChannel(n"DEBUG", s"DRUNK DRIVING");
        // this.SetDetectionMultiplier(target.GetEntityID(), 0.8);
        // this.RemoveDetectionAttitudeOverwrite(n"player");
        // this.m_shouldStartDetectingPlayerCached = true;
        return true;
      }
    }
  }
  wrappedMethod(target);
}

@addMethod(ReactionManagerComponent)
protected cb func OnStalkEventCustom(evt: ref<StalkEventCustom>) {
  let player: ref<GameObject> = this.GetPlayerSystem().GetLocalPlayerControlledGameObject();
  if !IsDefined(player) {
    return;
  }
  let playerPuppet: ref<PlayerPuppet> = player as PlayerPuppet;
  if !IsDefined(playerPuppet) {
    return;
  }
  if Equals(playerPuppet.lastPos, playerPuppet.GetWorldPosition()) {
    this.m_stalkingCount = 0;
    return;
  }
  let owner: ref<GameObject> = this.GetOwner();
  let ownerPuppet: ref<ScriptedPuppet> = this.GetOwnerPuppet();
  if !IsDefined(ownerPuppet) {
    return;
  }
  let npcPuppet: ref<NPCPuppet> = ownerPuppet as NPCPuppet;
  if !IsDefined(npcPuppet) {
    return;
  }
  if this.IsTargetClose(evt.target, 5.0) {
    // LogChannel(n"DEBUG", s"OnStalkEvent!!!!!!!!!!!!!!! increment done \(this.m_stalkingCount)");

    this.m_stalkingCount += 1;
    playerPuppet.lastPos = playerPuppet.GetWorldPosition();

    if this.m_stalkingCount > 3 && this.m_stalkingCount <= 6 {
      this.TriggerFacialLookAtReaction(true, true);
    }
    
    if this.m_stalkingCount > 6 || (this.m_stalkingCount > 3 && playerPuppet.m_playerClothAffiliation == 69) {
      let broadcaster: ref<StimBroadcasterComponent>;
      let investigateData: stimInvestigateData;
      // LogChannel(n"DEBUG", s"OnStalkEvent!!!!!!!!!!!!!!! STALKER DETRECTED ");

      broadcaster = owner.GetStimBroadcasterComponent();
      if IsDefined(broadcaster) && npcPuppet.GetAffiliationInt() != 13 {
        StimBroadcasterComponent.SendStimDirectly(player as PlayerPuppet, gamedataStimType.SilentAlarm, this.GetOwnerPuppet(), investigateData, 0.0);
      }

      if this.m_stalkingCount > 10 {
        // LogChannel(n"DEBUG", s"OnStalkEvent!!!!!  TryStartCombatWithTarget");
        AIActionHelper.TryStartCombatWithTarget(this.GetOwnerPuppet(), player);
      }
      else if this.m_stalkingCount > 6 && (npcPuppet.GetAffiliationInt() == 13 || npcPuppet.GetAffiliationInt() == 4) && IsDefined(broadcaster) {
        // LogChannel(n"DEBUG", s"OnStalkEvent!!!!!  TryStartCombatWithTarget");
        StimBroadcasterComponent.SendStimDirectly(player as PlayerPuppet, gamedataStimType.Provoke, this.GetOwnerPuppet(), investigateData, 0.0);
      }
    }
  }
  else {
    this.m_stalkingCount = 0;
  }
}

@replaceMethod(ReactionManagerComponent)
private final func CheckStalk(target: ref<GameObject>, timeout: Float) -> Void {
  let stalkEvent: ref<StalkEventCustom>;
  let owner: ref<GameObject> = this.GetOwner();
  let ownerPuppet: ref<ScriptedPuppet> = this.GetOwnerPuppet();
  if !IsDefined(ownerPuppet) {
    return;
  }
  let npcPuppet: ref<NPCPuppet> = ownerPuppet as NPCPuppet;
  if !IsDefined(npcPuppet) {
    return;
  }
  if this.IsTargetClose(target, 5.0) && (Equals(this.m_reactionPreset.Type(), gamedataReactionPresetType.Civilian_Neutral) || Equals(this.m_reactionPreset.Type(), gamedataReactionPresetType.Civilian_Passive) || npcPuppet.GetAffiliationInt() == 13 || npcPuppet.GetAffiliationInt() == 4) {
      // LogChannel(n"DEBUG", s"CheckStalk!!!!!!!!!!!!!!! civilian!!!!");
      stalkEvent = new StalkEventCustom();
      stalkEvent.target = target;
      GameInstance.GetDelaySystem(this.GetOwner().GetGame()).DelayEvent(this.GetOwner(), stalkEvent, timeout);
    };
}

@addMethod(SenseComponent)
private final func IsTargetArmed(target: ref<GameObject>) -> Bool {
  if IsDefined(GameObject.GetActiveWeapon(target)) && !WeaponObject.IsFists(GameObject.GetActiveWeapon(target).GetItemID()) {
    return true;
  };
  return false;
}

@replaceMethod(ReactionManagerComponent)
protected final func HandleStimEvent(stimData: ref<StimEventTaskData>) -> Void {
  let localPlayer: ref<GameObject>;
  let ownerPuppet: ref<ScriptedPuppet>;
  let resetLookatReaction: ref<ResetLookatReactionEvent>;
  let stimEvent: ref<StimuliEvent>;
  let stimParams: StimParams;
  let stimType: gamedataStimType;
  if !IsDefined(stimData) || !IsDefined(stimData.cachedEvt) {
    return;
  };
  stimEvent = stimData.cachedEvt;
  stimType = stimEvent.GetStimType();
  this.m_receivedStimType = stimType;
  this.m_receivedStimPropagation = stimEvent.stimPropagation;
  if !this.IsEnabled() && !StimFilters.IsForTheDead(stimType) {
    this.m_receivedStimType = gamedataStimType.Invalid;
    this.m_receivedStimPropagation = gamedataStimPropagation.Invalid;
    return;
  };
  if !this.m_initialized {
    this.Initialiaze();
    this.m_initialized = true;
  };
  ownerPuppet = this.GetOwnerPuppet();
  if Equals(stimType, gamedataStimType.AudioEnemyPing) {
    if ScriptedPuppet.IsActive(ownerPuppet) && ownerPuppet.IsAggressive() {
      localPlayer = GameInstance.GetPlayerSystem(ownerPuppet.GetGame()).GetLocalPlayerMainGameObject();
      if !this.SourceAttitude(localPlayer, EAIAttitude.AIA_Friendly) {
        GameInstance.GetAudioSystem(ownerPuppet.GetGame()).RegisterEnemyPingStim(ownerPuppet.GetHighLevelStateFromBlackboard(), ownerPuppet.IsPrevention());
      };
    };
    return;
  };
  if stimData.delayed {
    this.LogStart(EReactLogSource.StimEvent, "processing delayed stim event");
  } else {
    this.LogStart(EReactLogSource.StimEvent, "processing stim event");
  };
  if this.ShouldEventBeProcessed(stimEvent) {
    if !ownerPuppet.IsPrevention() && IsDefined(ownerPuppet.GetCrowdMemberComponent()) && (this.m_inCrowd || ownerPuppet.IsCharacterCivilian()) {
      this.LogInfo("processing crowd stim");
      // LogChannel(n"DEBUG", s"IN HANDLESTIM =>>>> STIM!!!! type === \(stimEvent.stimType), check val ====> \(this.ShouldStimBeProcessedByCrowd(stimEvent))");

      if this.ShouldStimBeProcessedByCrowd(stimEvent) || Equals(stimEvent.stimType, gamedataStimType.VehicleHorn) {
        this.LogSuccess("handling crowd reaction");
        this.HandleCrowdReaction(stimEvent);
      };
      if stimEvent.IsTagInStimuli(n"Safe") {
        this.LogInfo("resetting lookat with delay");
        resetLookatReaction = new ResetLookatReactionEvent();
        GameInstance.GetDelaySystem(this.GetOwner().GetGame()).DelayEvent(this.GetOwner(), resetLookatReaction, 1.00);
      };
      this.m_receivedStimType = gamedataStimType.Invalid;
      this.m_receivedStimPropagation = gamedataStimPropagation.Invalid;
      return;
    };
    this.LogInfo("processing stim");
    if this.ShouldStimBeProcessed(stimEvent, stimData.delayed) {
      stimParams = this.ProcessStimParams(stimEvent);
      this.ProcessReactionOutput(stimData, stimParams);
    };
  };
  if (Equals(stimType, gamedataStimType.StopedAiming) || Equals(stimType, gamedataStimType.ReevaluateDetectionOverwrite)) && this.m_reactionPreset.IsAggressive() {
    ownerPuppet.GetSensesComponent().ReevaluateDetectionOverwrite(stimEvent.sourceObject);
    this.LogSuccess("reevaluated detection overwrite");
  };
  if Equals(stimType, gamedataStimType.EnvironmentalHazard) {
    this.ProcessEnvironmentalHazard(stimEvent);
  };
  if StimFilters.IsForTheDead(stimEvent.GetStimType()) {
    this.ProcessStimForTheDead(stimEvent);
  };
  this.m_receivedStimType = gamedataStimType.Invalid;
  this.m_receivedStimPropagation = gamedataStimPropagation.Invalid;
}


@replaceMethod(ReactionManagerComponent)
private final func HandleCrowdReaction(stimEvent: ref<StimuliEvent>) -> Void {
  // wrappedMethod(stimEvent);
  // LogChannel(n"DEBUG", s"HandleCrowdReaction STIM!!!! type === \(stimEvent.stimType)");

    let delayedCrowdReaction: ref<DelayedCrowdReactionEvent>;
    let mountInfo: MountingInfo;
    let stimAttackData: stimInvestigateData;
    let vehicleReactionEvent: ref<HandleReactionEvent>;
    let owner: ref<GameObject> = this.GetOwner();
    let game: GameInstance = owner.GetGame();
    let reactionSystem: ref<ReactionSystem> = GameInstance.GetReactionSystem(game);
    let mounted: Bool = VehicleComponent.IsMountedToVehicle(game, owner);
    if this.m_inCrowd && GameInstance.GetGameFeatureManager(game).AggressiveCrowdsEnabled() && (!mounted || VehicleComponent.IsDriver(game, owner.GetEntityID())) && this.ShouldTriggerAggressiveCrowdNPCCombat(stimEvent) && (owner.IsPrevention() || reactionSystem.TryRegisteringAggressiveNPC(owner, !mounted)) {
      if mounted {
        this.m_driverIsAggressive = true;
      } else {
        this.TriggerAggressiveCrowdBehavior(owner, stimEvent.sourceObject);
      };
    } else {
      if Equals(this.m_reactionPreset.Type(), gamedataReactionPresetType.Child) && stimEvent.IsTagInStimuli(n"ChildDanger") {
        this.m_desiredFearPhase = 3;
        this.DeactiveLookAt();
        stimAttackData = stimEvent.stimInvestigateData;
        if IsDefined(stimAttackData.attackInstigator) {
          stimEvent.sourceObject = stimAttackData.attackInstigator as GameObject;
          stimEvent.sourcePosition = stimEvent.sourceObject.GetWorldPosition();
        };
        this.ActivateReactionLookAt(stimEvent.sourceObject, false);
        delayedCrowdReaction = new DelayedCrowdReactionEvent();
        delayedCrowdReaction.stimEvent = stimEvent;
        owner.QueueEvent(delayedCrowdReaction);
      } else {
        if VehicleComponent.IsMountedToVehicle(game, owner) && NotEquals(stimEvent.GetStimType(), gamedataStimType.HijackVehicle) && NotEquals(stimEvent.GetStimType(), gamedataStimType.Dying) && NotEquals(stimEvent.GetStimType(), gamedataStimType.VehicleHorn) {
          NPCPuppet.ChangeHighLevelState(owner, gamedataNPCHighLevelState.Fear);
          mountInfo = GameInstance.GetMountingFacility(game).GetMountingInfoSingleWithObjects(owner);
          this.m_previousFearPhase = this.ConvertFearStageToFearPhase(this.m_crowdFearStage);
          vehicleReactionEvent = new HandleReactionEvent();
          vehicleReactionEvent.fearPhase = this.GetFearReactionPhase(stimEvent);
          vehicleReactionEvent.stimEvent = stimEvent;
          GameInstance.FindEntityByID(game, mountInfo.parentId).QueueEvent(vehicleReactionEvent);
        } else {
          if this.m_driverIsAggressive && Equals(stimEvent.GetStimType(), gamedataStimType.EnvironmentalHazard) {
            this.TriggerReactionBehaviorForCrowd(stimEvent, gamedataOutput.Panic, true);
          } else {
            // LogChannel(n"DEBUG", s"HandleCrowdReaction IN ELSE STIM handler type === \(stimEvent.stimType)");
            this.m_previousFearPhase = this.ConvertFearStageToFearPhase(this.m_crowdFearStage);
            this.m_desiredFearPhase = this.GetFearReactionPhase(stimEvent);
            if VehicleComponent.IsMountedToVehicle(game, owner) && Equals(stimEvent.GetStimType(), gamedataStimType.HijackVehicle) {
              GameObject.PlayVoiceOver(owner, n"fear_beg", n"Scripts:HandleCrowdReaction", 0.0, owner.GetEntityID(), true);
            };
            this.DeactiveLookAt();
            stimAttackData = stimEvent.stimInvestigateData;
            if IsDefined(stimAttackData.attackInstigator) {
              stimEvent.sourceObject = stimAttackData.attackInstigator as GameObject;
              stimEvent.sourcePosition = stimEvent.sourceObject.GetWorldPosition();
            };
            this.ActivateReactionLookAt(stimEvent.sourceObject, false);
            delayedCrowdReaction = new DelayedCrowdReactionEvent();
            delayedCrowdReaction.stimEvent = stimEvent;
            if this.m_desiredFearPhase == -1 {
              return;
            };
            this.CreateFearArea(stimEvent, this.m_desiredFearPhase);
            if !stimAttackData.skipReactionDelay {
              this.m_delayReactionEventID = GameInstance.GetDelaySystem(game).DelayEvent(owner, delayedCrowdReaction, RandRangeF(this.m_delay.X, this.m_delay.Y));
            } else {
              owner.QueueEvent(delayedCrowdReaction);
            };
          };
        };
      };
    };

  let owner: ref<GameObject> = this.GetOwner();
  let ownerPuppet: ref<GameObject> = this.GetOwnerPuppet();
  let game: GameInstance = owner.GetGame();
  let player: ref<GameObject> = this.GetPlayerSystem().GetLocalPlayerMainGameObject();
  let playerPuppet: ref<PlayerPuppet> = player as PlayerPuppet;
  let playerVehicleObj: wref<VehicleObject>;
  if !IsDefined(player) || !IsDefined(playerPuppet) || !IsDefined(ownerPuppet) {
    return;
  }
  if (playerPuppet.m_isModSettingsInstalled && playerPuppet.m_responsiveNPCModSettings.isVehicleReactionEnabled || !playerPuppet.m_isModSettingsInstalled) {
    VehicleComponent.GetVehicle(player.GetGame(), player, playerVehicleObj);
    if !IsDefined(playerVehicleObj) {
      return;
    }

    if !GameObject.IsCooldownActive(ownerPuppet, n"bumpCooldown") {
        GameObject.StartCooldown(ownerPuppet, n"bumpCooldown", 3.0);
        if playerVehicleObj.IsOnPavement() && VehicleComponent.IsMountedToVehicle(game, player) && Equals(stimEvent.GetStimType(), gamedataStimType.VehicleHorn) {
          let currentSpeed: Float = Vector4.Length(playerVehicleObj.GetLinearVelocity());
          // LogChannel(n"DEBUG", s"HANDLING!!!!!!!! VEHICLE IS ON DA PAVEMENT!!! HONK");

          if currentSpeed > 0.01 {
            // LogChannel(n"DEBUG", s"HandleCrowdReaction: \(currentSpeed)");
            // Check speed to set target proximity check distance
            let proximityCheckDistance: Float;
            if currentSpeed <= 5.0 {
              proximityCheckDistance = 12.0;
            }
            else if currentSpeed <= 10.0 { 
              proximityCheckDistance = 20.0;
            }
            else { 
              proximityCheckDistance = 30.0;
            }

            if this.IsTargetClose(player, proximityCheckDistance) {
              this.TriggerFacialLookAtReaction(false, false);
              GameObject.PlayVoiceOver(owner, n"bump", n"Scripts:OnIDK");

              let reactionSystem: ref<ReactionSystem> = GameInstance.GetReactionSystem(game);

              let stimEvent: ref<StimuliEvent> = new StimuliEvent();
              if currentSpeed <= 10.0 {
                stimEvent.SetStimType(gamedataStimType.SilentAlarm);
              }
              else {
                stimEvent.SetStimType(gamedataStimType.Terror);
              }
              stimEvent.sourceObject = player;
              stimEvent.sourcePosition = player.GetWorldPosition();
              stimEvent.radius = currentSpeed >= 5.0 ? 5.0 : 2.0;
              this.TriggerReactionBehaviorForCrowd(stimEvent.sourceObject, gamedataOutput.DodgeToSide, false, stimEvent.sourcePosition);
            }
          }
          else if VehicleComponent.IsMountedToVehicle(game, player) && Equals(stimEvent.GetStimType(), gamedataStimType.VehicleHorn) && currentSpeed < 0.01 {
            if this.IsTargetClose(player, 5.0) {
              this.TriggerFacialLookAtReaction(false, false);
              GameObject.PlayVoiceOver(owner, n"bump", n"Scripts:OnIDK");
            }
            else if this.IsTargetClose(player, 15.0) {
              this.TriggerFacialLookAtReaction(false, false);
            }
          }
        } else {
            let npcVehicleObj: wref<VehicleObject>;
            VehicleComponent.GetVehicle(owner.GetGame(), owner, npcVehicleObj);
            if IsDefined(npcVehicleObj) && this.IsTargetClose(player, 35.0) {
              let hornEvt: ref<VehicleHornProbsEvent> = new VehicleHornProbsEvent();
              hornEvt.honkMinTime = 1.00;
              hornEvt.honkMaxTime = 2.50;
              hornEvt.probability = 0.4;
              let delayTimer: Float;
              if Vector4.Length(npcVehicleObj.GetLinearVelocity()) > 10.0 {
                delayTimer = 0.6;
              }
              if Vector4.Length(npcVehicleObj.GetLinearVelocity()) > 15.0 {
                delayTimer = 0.3;
                hornEvt.probability = 0.8;
              }
              else {
                delayTimer = RandRangeF(0.8, 1.8);
              }
              GameInstance.GetDelaySystem(npcVehicleObj.GetGame()).DelayEvent(npcVehicleObj, hornEvt, delayTimer);
              // npcVehicleObj.QueueEvent(hornEvt);
            };
        }
    }
  }
}

@replaceMethod(VehicleObject)
  protected cb func OnVehicleBumpEvent(evt: ref<VehicleBumpEvent>) -> Bool {
    let isBike: Bool;
    this.m_vehicleComponent.CheckForDrag(evt.impactVelocityChange);
    let driver: ref<GameObject>;
    isBike = this == (this as BikeObject);
    if evt.impactVelocityChange < 2.3 {
      if !GameObject.IsCooldownActive(this, n"bumpCooldown") {
        GameObject.StartCooldown(this, n"bumpCooldown", 2.50);
        driver = VehicleComponent.GetDriverMounted(this.GetGame(), this.GetEntityID());
        if VehicleComponent.IsMountedToVehicle(this.GetGame(), driver) && IsDefined(driver as NPCPuppet) && ScriptedPuppet.IsActive(driver) {
          GameObject.PlayVoiceOver(driver, n"vehicle_bump", n"Scripts:OnVehicleBumpNone");
        };
        return false;
      }
    }
    if evt.isInTraffic && evt.impactVelocityChange > 0.00 {
      this.HandleTrafficBump(evt.impactVelocityChange);
    } else {
      if IsDefined(evt.hitVehicle) && isBike {
        this.m_vehicleComponent.HandleBikeCollisionReaction(evt.impactVelocityChange, Vector4.Vector3To4(evt.hitNormal));
      };
    };
  }
  