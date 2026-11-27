local G={};G.__index=G
local function valid(v)
 if type(v)~='table' then return false end
 for i=1,3 do local n=v[i];if type(n)~='number' or n~=n or math.abs(n)==math.huge then return false end end
 return true
end
local function length(v)return math.sqrt(v[1]^2+v[2]^2+v[3]^2)end
function G.new()return setmetatable({grip=true,trigger=true},G)end
function G:cancel()self.start=nil end
function G:update(f)
 local e={}
 local risingGrip=f.grip and not self.grip
 local risingTrigger=f.trigger and not self.trigger
 if self.key~=f.key then self:cancel();risingGrip=false;risingTrigger=false end
 self.key=f.key;self.grip=f.grip;self.trigger=f.trigger
 if not f.valid or not valid(f.point) or not valid(f.anchor) then self:cancel();return e end
 local p={f.point[1]-f.anchor[1],f.point[2]-f.anchor[2],f.point[3]-f.anchor[3]}
 local near=length(p)<=(f.radius or .15)
 local function pulled()
  if not self.start then return false end
  local delta={p[1]-self.start[1],p[2]-self.start[2],p[3]-self.start[3]}
  if length(p)>.65 then self:cancel();return false end
  if length(delta)>=.085 and length(p)>=length(self.start)+.04 then self:cancel();return true end
  return false
 end
 if f.off then
  self:cancel()
  if risingTrigger and near then e.attach=true end
 elseif f.mode=='trigger' then
  if not f.trigger then self:cancel()
  elseif risingTrigger and near then self.start=p;e.began=true
  elseif pulled() then e.remove=true end
 else
  if not f.grip then self:cancel()
  elseif risingGrip and near then self.start=p;e.began=true
  elseif pulled() then e.remove=true end
 end
 return e
end
return G
