// CyberpunkVRPose -- feed the VR port's tracked head and hands into NightCoop's pose sync, so
// other players in a co-op session see the VR body (head, arms, gun carried by the right hand).
// Driven per-frame by CyberpunkVRPose/init.lua (CET), matching the port's architecture. No
// `module`: the plugin registers its natives at global scope.
@if(ModuleExists("NightCoop"))
import NightCoop.*
public class CyberpunkVRPoseMath {
  public final static func QMul(a: Quaternion, b: Quaternion) -> Quaternion {
    let r: Quaternion;
    r.i = a.r * b.i + a.i * b.r + a.j * b.k - a.k * b.j;
    r.j = a.r * b.j - a.i * b.k + a.j * b.r + a.k * b.i;
    r.k = a.r * b.k + a.i * b.j - a.j * b.i + a.k * b.r;
    r.r = a.r * b.r - a.i * b.i - a.j * b.j - a.k * b.k;
    return r;
  }
}
@addField(PlayerPuppet) private let vrPoseRegistered: Bool;
@addMethod(PlayerPuppet) public func VRPoseRegister() -> Void {
  if this.vrPoseRegistered { return; }
  this.vrPoseRegistered = true;
  let flags: Int32 = EnumInt(NightCoopSdkModFlag.UsesPose) | EnumInt(NightCoopSdkModFlag.LocalOnly);
  NightCoopSdk.RegisterMod("cyberpunkvr.pose", "Cyberpunk VR Pose", "1.0.0", 1, flags);
}
@addMethod(PlayerPuppet) public func VRPoseSend() -> Void {
  if !NightCoopSdk.InSession() { return; }
  let base: Vector4 = this.GetWorldPosition();
  let playerOrient: Quaternion = this.GetWorldOrientation();
  let headPos: Vector4 = VRViewWorldPos();
  let headRot: Quaternion = VRViewWorldRot();
  let palmR: Vector4 = VRPalmModelPos(1);
  let rotR: Quaternion = VRPalmModelRot(1);
  let palmL: Vector4 = VRPalmModelPos(0);
  let rotL: Quaternion = VRPalmModelRot(0);
  let handRPos: Vector4 = base + Quaternion.Transform(playerOrient, Vector4(palmR.X, palmR.Y, palmR.Z, 0.0));
  let handRRot: Quaternion = CyberpunkVRPoseMath.QMul(playerOrient, rotR);
  let handLPos: Vector4 = base + Quaternion.Transform(playerOrient, Vector4(palmL.X, palmL.Y, palmL.Z, 0.0));
  let handLRot: Quaternion = CyberpunkVRPoseMath.QMul(playerOrient, rotL);
  let valid: Int32 = 0;
  if headPos.W >= 0.5 { valid += EnumInt(NightCoopSdkPoseBit.Head); }
  if palmL.W >= 0.5 { valid += EnumInt(NightCoopSdkPoseBit.LeftHand); }
  if palmR.W >= 0.5 { valid += EnumInt(NightCoopSdkPoseBit.RightHand); }
  let aimOrigin: Vector4 = handRPos;
  let aimDir: Vector4 = Quaternion.Transform(handRRot, Vector4(1.0, 0.0, 0.0, 0.0));
  valid += EnumInt(NightCoopSdkPoseBit.Aim);
  let headT: Transform = Transform.Create(headPos, headRot);
  let handRT: Transform = Transform.Create(handRPos, handRRot);
  let handLT: Transform = Transform.Create(handLPos, handLRot);
  NightCoopSdk.SetPose("cyberpunkvr.pose", valid, true, headT, handLT, handRT, aimOrigin, aimDir, 0.0, []);
}
@addMethod(PlayerPuppet) public func VRPoseClear() -> Void {
  if !this.vrPoseRegistered { return; }
  NightCoopSdk.ClearPose("cyberpunkvr.pose");
  NightCoopSdk.UnregisterMod("cyberpunkvr.pose");
  this.vrPoseRegistered = false;
}