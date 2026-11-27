module ImmersiveAirTraffic

public class ITASettings {

  @runtimeProperty("ModSettings.mod", "Immersive Air Traffic")
  @runtimeProperty("ModSettings.displayName", "Air Traffic Density")
  @runtimeProperty("ModSettings.description", "How many AVs fly the base game routes over Night City and the Biotechnica farms. 1 = base game, 2 to 5 = that many times more. Extra AVs also fly lanes above the route: one lane at 2-3, two lanes at 4-5.")
  @runtimeProperty("ModSettings.step", "1")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "5")
  public let density: Int32 = 3;
}
