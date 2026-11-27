local B={}
-- Resolve game globals inside calls, never at module load: the Lua VM can require
-- this module before TweakDBID/ItemID exist (old backend.lua failed exactly there).
local function key(id)return tostring(ItemID.GetCombinedHash(id))end
local SLOTS={
 {name='AttachmentSlots.PowerModule',mode='grip',label='muzzle'},
 {name='AttachmentSlots.Scope',mode='trigger',label='sight'},
 {name='AttachmentSlots.ScopeRail',mode='trigger',label='sight rail'},
}
local function fitted(player,weaponId,slot)
 if player and player.SamuraiSuppressorFittedID then return player:SamuraiSuppressorFittedID(weaponId,slot)end
 return ItemID.None()
end
local function weaponPoint(weapon)
 local p=weapon:GetWorldPosition()
 if p then return {p.x,p.y,p.z+0.12}end
 return nil
end
local function anchor(weapon,name,ts)
 if name=='AttachmentSlots.PowerModule'then
  local xf=weapon:GetMuzzleSlotWorldTransform()
  local o=xf and (xf.position or (xf.GetPosition and xf:GetPosition()))
  return o and {o.x,o.y,o.z}or nil
 end
 local part=ts:GetItemInSlot(weapon,TweakDBID.new(name))
 if part then local p=part:GetWorldPosition();if p then return {p.x,p.y,p.z}end end
 return weaponPoint(weapon)
end
function B.snapshot(player)
 local ts=Game.GetTransactionSystem()
 local weapon=ts:GetItemInSlot(player,TweakDBID.new('AttachmentSlots.WeaponRight'))
 if not weapon or (GetVRSharedSlot(165)or 0)>0 then return nil,'Draw one pistol in your right hand'end
 if not WeaponObject.IsOfType(weapon:GetItemID(),gamedataItemType.Wea_Handgun)then return nil,'Draw a pistol'end
 if not player.SamuraiSuppressorStored or not player.SamuraiSuppressorFittedID then return nil,'Real attachment bridge not loaded'end
 local weaponId=weapon:GetItemID()
 local out={}
 for _,cfg in ipairs(SLOTS)do
  local slot=TweakDBID.new(cfg.name)
  local fittedId=fitted(player,weaponId,slot)
  local stored=player:SamuraiSuppressorStored(weaponId,slot)
  local off=not ItemID.IsValid(fittedId)
  local part=off and stored or fittedId
  if ItemID.IsValid(part)then
   local point=anchor(weapon,cfg.name,ts)
   if point then
    out[#out+1]={slot=slot,slotName=cfg.name,mode=cfg.mode,label=cfg.label,off=off,
     partId=part,fittedId=fittedId,stored=stored,anchor=point,
     key=key(weaponId)..'/'..cfg.name..'/'..key(part)}
   end
  end
 end
 if #out==0 then return nil,'No fitted or remembered attachments for this pistol'end
 return {player=player,weapon=weapon,weaponId=weaponId,slots=out}
end
function B.flags(s)
 local ok,data=pcall(function()
  local result={silent=s.weapon:SamuraiSuppressorSilentFlag(),nativeSilenced=s.weapon:IsSilenced(),result=s.player:SamuraiSuppressorLastResult(),slots={}}
  for _,it in ipairs(s.slots)do
   result.slots[#result.slots+1]={slot=it.slotName,off=it.off,
    fitted=key(fitted(s.player,s.weaponId,it.slot)),stored=key(s.player:SamuraiSuppressorStored(s.weaponId,it.slot))}
  end
  return result
 end)
 return ok and data or {rebuilding=true,error=tostring(data)}
end
function B.remove(s,item)
 if item.off then return false,'Already unequipped'end
 local ok=s.player:SamuraiSuppressorUnequip(s.weaponId,item.slot)
 print('[VR Suppressor] actual unequip '..item.label..' '..tostring(ok)..' '..tostring(s.player:SamuraiSuppressorLastResult()))
 return ok,s.player:SamuraiSuppressorLastResult()
end
function B.attach(s,item)
 if not item.off then return false,'Slot is already occupied'end
 local ok=s.player:SamuraiSuppressorReequip(s.weaponId,item.slot)
 print('[VR Suppressor] actual re-equip '..item.label..' '..tostring(ok)..' '..tostring(s.player:SamuraiSuppressorLastResult()))
 return ok,s.player:SamuraiSuppressorLastResult()
end
return B
