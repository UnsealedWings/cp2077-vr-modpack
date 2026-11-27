local S={}
function S.grab()
 if type(VRMenuPlayWav)~='function'then return end
 local volume=1
 pcall(function()
  local group=Game.GetSettingsSystem():GetGroup(CName.new('/audio/volume'))
  volume=group:GetVar(CName.new('MasterVolume')):GetValue()*group:GetVar(CName.new('SfxVolume')):GetValue()/10000
 end)
 pcall(VRMenuPlayWav,'CyberpunkVRPort_SamuraiSuppressor/sounds/grab.wav',math.max(0,math.min(1,volume))*.6)
end
return S
