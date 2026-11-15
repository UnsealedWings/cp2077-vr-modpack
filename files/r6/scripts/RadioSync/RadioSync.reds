// RadioSync -- keep every player in the host's world on the host's radio station AND song.
// Requires NightCoop. Once a second, the host publishes its current vehicle radio station
// and track into NightCoop shared state; guests read it, switch their vehicle radio to the
// same station and request the same song, so everyone hears the same track (the game picks
// a different song per player on its own, so station-only sync is not enough).
module RadioSync

public class RadioSyncSystem extends ScriptableSystem {

  private let m_lastStation: CName;
  private let m_lastTrack: CName;
  private let m_timer: Float;

  private func OnAttach() -> Void {
    NightCoopSdk.RegisterMod("radiosync", "Radio Sync", "1.0.0", 1, 512); // 512 = UsesSharedState flag (SetState/GetState)
    NightCoopSdk.ListenFrame("radiosync", this, n"OnFrame");
    this.m_lastStation = n"";
    this.m_lastTrack = n"";
    this.m_timer = 0.0;
  }

  private func OnDetach() -> Void {
    NightCoopSdk.UnregisterMod("radiosync");
  }

  // NightCoop calls this every frame on the game thread while the player is in a world.
  // The sync itself runs once a second, not every frame.
  public func OnFrame(dt: Float) -> Void {
    this.m_timer += dt;
    if this.m_timer < 1.0 {
      return;
    }
    this.m_timer = 0.0;

    if !NightCoopSdk.InSession() || !NightCoopSdk.InWorld() {
      return;
    }
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance()) as PlayerPuppet;
    if !IsDefined(player) {
      return;
    }
    let vehicle: wref<VehicleObject>;
    VehicleComponent.GetVehicle(GetGameInstance(), player.GetEntityID(), vehicle);
    if !IsDefined(vehicle) {
      return;
    }

    if NightCoopSdk.IsHost() {
      let station: CName = vehicle.GetBlackboard().GetName(GetAllBlackboardDefs().Vehicle.VehRadioStationName);
      let track: CName = vehicle.GetRadioReceiverTrackName();
      if NotEquals(station, this.m_lastStation) || NotEquals(track, this.m_lastTrack) {
        this.m_lastStation = station;
        this.m_lastTrack = track;
        NightCoopSdk.SetState("radiosync", "station", NameToString(station));
        NightCoopSdk.SetState("radiosync", "track", NameToString(track));
      }
    } else {
      let stationStr: String = NightCoopSdk.GetState("radiosync", "station");
      let trackStr: String = NightCoopSdk.GetState("radiosync", "track");
      let station: CName = StringToName(stationStr);
      let track: CName = StringToName(trackStr);
      if Equals(station, n"") {
        return;
      }
      if Equals(station, this.m_lastStation) && Equals(track, this.m_lastTrack) {
        return;
      }
      this.m_lastStation = station;
      this.m_lastTrack = track;
      // Force the station AND the song -- the game picks a different song per player on its
      // own, so tuning to the same station is not enough. The station is set through the
      // vehicle blackboard (the same way the game's own radio UI does it).
      vehicle.GetBlackboard().SetName(GetAllBlackboardDefs().Vehicle.VehRadioStationName, station);
      vehicle.GetBlackboard().SetBool(GetAllBlackboardDefs().Vehicle.VehRadioState, true);
      if NotEquals(track, n"") {
        let audio: ref<AudioSystem> = GameInstance.GetAudioSystem(GetGameInstance()) as AudioSystem;
        if IsDefined(audio) {
          audio.RequestSongOnRadioStation(station, track);
        }
      }
    }
  }
}
