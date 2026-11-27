local Gesture=require('modules/gesture')
local Backend=require('modules/realparts')
local Sound=require('modules/sound')
local gestures={}
local current=nil
local lastWeapon=nil
local elapsed,reportAt,errorAt=0,0,-10
local status='Waiting for an attachment-equipped pistol'
local lastStatus=nil
local triggerBlocked=false
local sample={}
local function block(on)
 if on~=triggerBlocked and type(SetVRLeftTriggerBlock)=='function' then
  SetVRLeftTriggerBlock(on and 1 or 0);triggerBlocked=on
 end
end
local function vector(p)
 if not p then return nil end
 local v
 if type(p.x)=='number'then v={p.x,p.y,p.z}
 elseif p.x and p.x.Bits then v={p.x.Bits/131072,p.y.Bits/131072,p.z.Bits/131072}
 else return nil end
 for _,x in ipairs(v)do if type(x)~='number'or x~=x or math.abs(x)==math.huge then return nil end end
 return #v==3 and v or nil
end
local function report()
 local changed=status~=lastStatus
 if changed then print('[VR Suppressor] '..status);lastStatus=status end
 if elapsed<reportAt and not changed then return end
 reportAt=elapsed+1
 local data={at=os.time(),status=status,sample=sample}
 if current then data.flags=Backend.flags(current)end
 local f=io.open('status.json','w');if f then f:write(json.encode(data));f:close()end
 if changed then
  local history=io.open('events.jsonl','a')
  if history then history:write(json.encode(data)..'\n');history:close()end
 end
end
local function allowed(player)
 if not player or not player:IsAttached()then return false,'Player not attached'end
 if player:IsDeadNoStatPool()then return false,'Player unavailable'end
 if type(VRHandRawWorld)~='function'or type(GetVRSharedSlot)~='function' then return false,'VR input API unavailable' end
 if (GetVRSharedSlot(31)or 0)~=0 then return false,'VR menu open'end
 if (GetVRSharedSlot(164)or 0)~=0 then return false,'Weapon wheel open'end
 local defs=Game.GetAllBlackboardDefs()
 local ui=Game.GetBlackboardSystem():Get(defs.UI_System)
 if ui and ui:GetBool(defs.UI_System.IsInMenu)then return false,'Game menu open'end
 return true
end
local function stop()
 block(false);current=nil;lastWeapon=nil;gestures={}
end
local function gestureFor(item)
 local g=gestures[item.key]
 if not g then g=Gesture.new();gestures[item.key]=g end
 return g
end
local function tick(dt)
 elapsed=elapsed+math.max(0,math.min(dt or .016,.1))
 local player=Game.GetPlayer()
 local ready,reason=allowed(player)
 if not ready then stop();status='Paused: '..reason;report();return end
 local snapshot,why=Backend.snapshot(player)
 current=snapshot
 if not snapshot then gestures={};lastWeapon=nil;block(false);status=why;report();return end
 if lastWeapon~=snapshot.weaponId then gestures={};lastWeapon=snapshot.weaponId end
 local pose=VRHandRawWorld(0)
 local hand=pose and pose.w and pose.w>.5 and vector(pose)or nil
 local grip=(GetVRSharedSlot(155)or 0)>.5
 local trigger=(GetVRSharedSlot(154)or 0)>.5
 local blockOn=false
 local active=nil
 local offLabel=nil
 sample={hand=hand,grip=grip,trigger=trigger,slots={}}
 for _,item in ipairs(snapshot.slots)do
  local near=false
  if hand and item.anchor then
   local dx,dy,dz=hand[1]-item.anchor[1],hand[2]-item.anchor[2],hand[3]-item.anchor[3]
   near=dx*dx+dy*dy+dz*dz<=(item.mode=='trigger' and .20 or .14)^2
  end
  sample.slots[#sample.slots+1]={slot=item.slotName,off=item.off,near=near}
  -- Trigger-mode sights own the left trigger near them so grip can hold the gun.
  -- Muzzle/other slots only block it near an empty slot (trigger tap to reinstall).
  if near and (item.mode=='trigger' or item.off)then blockOn=true end
  local g=gestureFor(item)
  local event=g:update{key=item.key,point=hand,anchor=item.anchor,valid=hand~=nil,
   grip=grip,trigger=trigger,off=item.off,mode=item.mode,radius=item.mode=='trigger' and .20 or .14}
  if event.began then
   Sound.grab()
   if type(VRHapticEvent)=='function'then VRHapticEvent(20,1)end
  end
  if event.remove then
   local ok,err=Backend.remove(snapshot,item)
   status=ok and (item.label..' removed; trigger at its mount to replace') or ('Unequip rejected: '..tostring(err))
   if ok and type(VRHapticEvent)=='function'then VRHapticEvent(20,1)end
   active=item
  elseif event.attach then
   local ok,err=Backend.attach(snapshot,item);block(false)
   status=ok and (item.label..' re-equipped') or ('Re-equip rejected: '..tostring(err))
   if ok and type(VRHapticEvent)=='function'then VRHapticEvent(20,1)end
   active=item
  elseif g.start then active=item
  elseif item.off then offLabel=offLabel or item.label end
 end
 block(blockOn)
 if not active then
  if not hand then status='Waiting for valid hand tracking'
  elseif offLabel then status='Trigger at the '..offLabel..' mount to replace it'
  else status='Ready: grip+ pull muzzle, trigger+ pull sight' end
 elseif status:find(' removed',1,true) or status:find(' re-equipped',1,true) then
  -- keep the operation result until the next action
 elseif active.mode=='trigger' then status='Trigger pulled at '..active.label..': pull away to remove'
 else status='Grip held at '..active.label..': pull away to remove' end
 report()
end
registerForEvent('onInit',function()
 ObserveBefore('PlayerPuppet','OnDetach',function()stop()end)
 print('[VR Suppressor] loaded; multi-slot attachment detach/re-attach mode')
end)
registerForEvent('onUpdate',function(dt)
 local ok,why=pcall(tick,dt)
 if not ok then
  pcall(stop);status='Error: '..tostring(why)
  if elapsed-errorAt>=5 then print('[VR Suppressor] '..status);errorAt=elapsed end
  pcall(report)
 end
end)
registerForEvent('onShutdown',function()pcall(stop)end)
return {state=function()local s={status=status,slots={}};if current then for _,it in ipairs(current.slots)do s.slots[#s.slots+1]={slot=it.slotName,off=it.off}end end;return s end,
 restore=function()local p=Game.GetPlayer();local s=p and Backend.snapshot(p);if s then for _,it in ipairs(s.slots)do if it.off then Backend.attach(s,it)end end end;return true end}
