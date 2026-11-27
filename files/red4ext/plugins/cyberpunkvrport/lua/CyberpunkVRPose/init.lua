-- CyberpunkVRPose -- drive the VR -> NightCoop pose bridge every frame.
-- The redscript (CyberpunkVRPose/vrport_pose.reds) does the work; this only calls it.
-- Guarded: if NightCoop is not loaded the redscript methods do not exist, and pcall swallows it.
registerForEvent('onUpdate', function(dt)
  local p = Game.GetPlayer()
  if not p then return end
  pcall(function() p:VRPoseRegister() end)
  pcall(function() p:VRPoseSend() end)
end)
registerForEvent('onShutdown', function()
  local p = Game.GetPlayer()
  if p then pcall(function() p:VRPoseClear() end) end
end)