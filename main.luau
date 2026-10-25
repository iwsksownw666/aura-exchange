-- Aura Exchange: download only the selected aura. Release ill-fx1.
local env=getgenv()
local ASSET_BASE_URL=(env.AuraExchangeAssetBaseURL or "https://raw.githubusercontent.com/iwsksownw666/aura-exchange/ill-fx1-publish-v2/versions/ill-fx1"):gsub('/+$','')
local ownerByKey={["ASTRAIOS.json"]="ASTRAIOS",["animations/animation_98572784316773.json"]="ASTRAIOS",["ASTRAIOS_motion.json"]=false,["Monarch.json"]="Monarch",["animations/animation_118289001826286.json"]="Monarch",["Monarch_motion.json"]=false,["LEVIATHAN.json"]="LEVIATHAN",["animations/animation_132979577139811.json"]="LEVIATHAN",["LEVIATHAN_motion.json"]=false,["Tomorrow.json"]="Tomorrow",["animations/animation_113180536437121.json"]="Tomorrow",["Tomorrow_motion.json"]=false,["Oppression.json"]="Oppression",["animations/animation_101709109117549.json"]="Oppression",["Oppression_motion.json"]=false,["Lamenthyr.json"]="Lamenthyr",["animations/animation_86458494810549.json"]="Lamenthyr",["Lamenthyr_motion.json"]=false,["Eden.json"]="Eden",["animations/animation_130650435171934.json"]="Eden",["animations/animation_123533160693559.json"]="Eden",["animations/animation_79203569562321.json"]="Eden",["animations/animation_112827361961722.json"]="Eden",["animations/animation_93827508197083.json"]="Eden",["animations/animation_104263600793152.json"]="Eden",["animations/animation_110001831807332.json"]="Eden",["animations/animation_88049392229031.json"]="Eden",["animations/animation_97363310076806.json"]="Eden",["animations/animation_97526758956302.json"]="Eden",["animations/animation_128165251424306.json"]="Eden",["animations/animation_104862778157563.json"]="Eden",["animations/animation_76984492261316.json"]="Eden",["animations/animation_95569306173367.json"]="Eden",["Eden_motion.json"]=false,["Illusionary.json"]="Illusionary",["animations/animation_109536481760521.json"]="Illusionary",["animations/animation_135387970626232.json"]="Illusionary",["Illusionary_motion.json"]=false}
local bundles={["ASTRAIOS"]={["path"]="auras/ASTRAIOS.json",["bytes"]=6000083},["Monarch"]={["path"]="auras/Monarch.json",["bytes"]=2325312},["LEVIATHAN"]={["path"]="auras/LEVIATHAN.json",["bytes"]=4734103},["Tomorrow"]={["path"]="auras/Tomorrow.json",["bytes"]=3043789},["Oppression"]={["path"]="auras/Oppression.json",["bytes"]=1341775},["Lamenthyr"]={["path"]="auras/Lamenthyr.json",["bytes"]=4811517},["Eden"]={["path"]="auras/Eden.json",["bytes"]=4297522},["Illusionary"]={["path"]="auras/Illusionary.json",["bytes"]=4500381}}
local decoded,loaded,loading={},{},{}
local stats={version="ill-fx1",downloads=0,bytes=0,cacheHits=0,attempts=0,fallbacks=0,packages={}}
local Http=game:GetService('HttpService')
local function fetch(relative,expectedBytes)
 local urls={ASSET_BASE_URL..'/'..relative}
 if not env.AuraExchangeAssetBaseURL then
  urls[1]..='?download=1'
  table.insert(urls,"https://cdn.jsdelivr.net/gh/iwsksownw666/aura-exchange@ill-fx1-publish-v2/versions/ill-fx1/"..relative)
 end
 local lastError
 for index,url in ipairs(urls)do
  stats.attempts+=1
  local ok,data,bytes=pcall(function()
   local body=game:HttpGet(url)
   assert(type(body)=='string'and #body>0,'Empty aura resource: '..relative)
   if expectedBytes then assert(#body==expectedBytes,'Incomplete aura resource: '..relative)end
   return Http:JSONDecode(body),#body
  end)
  if ok then
   stats.downloads+=1;stats.bytes+=bytes
   if index>1 then stats.fallbacks+=1 end
   return data
  end
  lastError=data
 end
 error('Aura download failed: '..relative..' / '..tostring(lastError),0)
end
local function ensureBundle(owner)
 if loaded[owner]then stats.cacheHits+=1;return end
 while loading[owner]do task.wait(.03)end
 if loaded[owner]then stats.cacheHits+=1;return end
 loading[owner]=true
 local ok,err=pcall(function()
  local info=assert(bundles[owner],'Unknown aura bundle: '..tostring(owner))
  local package=fetch(info.path,info.bytes)
  assert(package.format=='AuraExchangeBundle/1'and package.version=="ill-fx1"and package.name==owner and type(package.files)=='table','Aura bundle version mismatch: '..owner)
  local pending={}
  for key,expectedOwner in pairs(ownerByKey)do if expectedOwner==owner then
   local value=package.files[key]
   assert(type(value)=='table'and (type(value.nodes)=='table'or value.format=='AuraPoseClip/1'),'Missing aura asset: '..key)
   pending[key]=value
  end end
  for key,value in pairs(pending)do decoded[key]=value end
  loaded[owner]=true;stats.packages[owner]=true
 end)
 loading[owner]=nil
 if not ok then error(err,0)end
end
local function readData(directory,name,suffix)
 local key=(directory:match('/animations$')and 'animations/'or '')..name..(suffix or '')..'.json'
 if decoded[key]then return decoded[key]end
 local owner=ownerByKey[key]
 assert(owner~=nil,'Unknown aura asset: '..key)
 if owner==false then decoded[key]=fetch('motions/'..key)
 else ensureBundle(owner)end
 return assert(decoded[key],'Aura asset missing: '..key)
end
local Module=(function()
-- Local visual replay of seven captured auras. No equip/ownership remotes.
local Http=game:GetService('HttpService')
local RunService=game:GetService('RunService')
-- BEGIN_EDEN_CONTROLLER
local EdenController=(function()
-- Local Eden playback. Original client animations/timings are captured in evidence/.
local Controller={}
Controller.Animations={idle='130650435171934',walk='88049392229031',jump='97363310076806',fall='79203569562321',tool='76984492261316',Taunt='112827361961722',Impale='104862778157563',Slash='128165251424306',Burst='110001831807332',In='93827508197083',During='95569306173367',Out='104263600793152',Shoot='97526758956302'}
Controller.Skills={
 {name='Impale',key='Q',pose='Impale',weapon=125,duration=1.1},
 {name='Cut Into Nothing',key='E',pose='Slash',weapon=116,duration=1.35},
 {name='Darkmatter Barrage',key='F',pose='Burst',duration=2.6},
 {name='Voidrush',key='V',pose='In',duration=4.25},
 {name='Deadeye',key='R',pose='Shoot',weapon=130,duration=3.85},
 {name='Taunt',key='T',pose='Taunt',duration=0.9},
}
function Controller.install(h,config,nativeUI)
 if h.EdenSkills then return end
 local Players=game:GetService('Players')
 local TweenService=game:GetService('TweenService')
 local RunService=game:GetService('RunService')
 local CAS=game:GetService('ContextActionService')
 local UIS=game:GetService('UserInputService')
 local Lighting=game:GetService('Lighting')
 local player=Players.LocalPlayer
 local camera=workspace.CurrentCamera
 local root=h.Objects[184]
 local skillRoot=h.Objects[h.Data.edenSkillRoot]
 local audioRoot=h.Objects[h.Data.edenAudioRoot]
 local localCharacter=h.Root==player.Character
 local token=0
 local active
 local cooldowns={}
 h.EdenSkills=Controller.Skills
 h.EdenSkillStats={casts={},emitCalls=0,emittedParticles=0,weaponShows=0,cameraChanges=0,audioPlays=0,audioLoaded=0,hitStops=0}
 local strength=math.clamp(tonumber(config.ImpactStrength)or 1.15,.5,2)
 local shaker
 if localCharacter then
  shaker=require(game.ReplicatedStorage.Modules.CameraShaker).new(Enum.RenderPriority.Camera.Value+1,function(offset)if h.Alive then camera.CFrame*=offset end end)
  shaker:Start();h.EdenCameraShaker=shaker;h.RenderBindings[shaker._renderName]=true
  table.insert(h.Cleanups,function()shaker:Stop()end)
 end
 local function own(obj)table.insert(h.Created,obj);return obj end
 local function connect(signal,callback)
  local connection=signal:Connect(function(...)
   if not h.Alive then return end
   local ok,err=pcall(callback,...)
   if not ok then table.insert(h.Errors,{property='EdenSkillCallback',error=tostring(err)})end
  end)
  table.insert(h.Connections,connection);return connection
 end
 local function valid(a)return h.Alive and active==a and a.token==token end
 local function later(a,delay,fn)
  local thread=task.delay(delay,function()
   if not valid(a)then return end
   local ok,err=pcall(fn)
   if not ok then table.insert(h.Errors,{property='EdenSkill:'..a.name,error=tostring(err)});h:CancelEdenSkill()end
  end)
  table.insert(h.Threads,thread);table.insert(a.threads,thread)
 end
 local function set(a,obj,key,value)
  if not obj then return end
  local saved=a.properties[obj];if not saved then saved={};a.properties[obj]=saved end
  if saved[key]==nil then saved[key]={value=obj[key]}end
  obj[key]=value
 end
 local function tween(a,obj,seconds,properties)
  for key in pairs(properties)do set(a,obj,key,obj[key])end
  local t=TweenService:Create(obj,TweenInfo.new(seconds,Enum.EasingStyle.Quart),properties)
  table.insert(a.tweens,t);t:Play()
 end
 local function sound(a,name,volume,speed,looped)
  local template=audioRoot and audioRoot:FindFirstChild(name);if not template then return end
  local obj=own(template:Clone());obj.Name='EdenSkillAudio_'..name;obj.Looped=looped==true
  obj.Volume=math.clamp((volume or .65)*(tonumber(config.SkillVolume)or 1),0,2)
  obj.PlaybackSpeed=speed or 1;obj.TimePosition=0;obj.RollOffMinDistance=8;obj.RollOffMaxDistance=100;obj.Parent=root
  obj:Play();h.EdenSkillStats.audioPlays+=1
  if obj.IsLoaded then h.EdenSkillStats.audioLoaded+=1 end
  table.insert(a.sounds,obj)
  if looped then table.insert(a.owned,obj)
  else
   local thread=task.delay(math.min(1.6,math.max(.4,obj.TimeLength/obj.PlaybackSpeed)),function()
    if not h.Alive or not obj.Parent then return end
    local fade=TweenService:Create(obj,TweenInfo.new(.12),{Volume=0});fade:Play()
    local destroy=task.delay(.13,function()obj:Destroy()end);table.insert(h.Threads,destroy)
   end)
   table.insert(h.Threads,thread)
  end
  return obj
 end
 local function emit(a,obj,continuous)
  if not obj then return end
  local items=obj:GetDescendants();table.insert(items,1,obj)
  for _,x in ipairs(items)do if x:IsA('ParticleEmitter')then
   local count=x:GetAttribute('EmitCount')
   if continuous then set(a,x,'Enabled',true)
   else count=count==nil and 3 or count;if count>0 then count=math.max(1,math.floor(count*strength+.5));x:Emit(count);h.EdenSkillStats.emitCalls+=1;h.EdenSkillStats.emittedParticles+=count end end
  end end
 end
 local function pose(a,name,looped)
  h.EdenSkillPose={name=name,id=Controller.Animations[name],started=os.clock(),looped=looped==true}
  table.insert(a.poses,name)
 end
 local function flash(a,opacity,white)
  if not localCharacter then return end
  local template=skillRoot and skillRoot:FindFirstChild('Voidrushing')
  if not template then return end
  local gui=h.EdenSkillUI
  local image=own(template:Clone());image.Name='EdenSkillFlash';image.Size=UDim2.fromScale(1,1);image.Position=UDim2.fromScale(0,0);image.AnchorPoint=Vector2.zero
  image.ZIndex=1;image.ImageTransparency=opacity or 0;image.Visible=true
  if white then image.ImageColor3=Color3.new(1,1,1)end
  image.Parent=gui;table.insert(a.owned,image)
  tween(a,image,.5,{ImageTransparency=1})
  later(a,.55,function()image:Destroy()end)
 end
 local function shake(a,power,seconds)
  if not localCharacter then return end
  if shaker then shaker:ShakeOnce(power*strength,14,0,seconds)end
  h.EdenSkillStats.cameraChanges+=1
 end
 local function hit(a,power,seconds)
  shake(a,power,seconds);sound(a,'DeepImpact',.8*strength,.95)
  h.EdenHitStopUntil=os.clock()+math.clamp(tonumber(config.HitStop)or .035,0,.06)
  h.EdenSkillStats.hitStops+=1
 end
 local function zoom(a,value,seconds)
  if localCharacter then tween(a,camera,seconds or .5,{FieldOfView=value});h.EdenSkillStats.cameraChanges+=1 end
 end
 local function showWeapon(a,id)
  local obj=h.Objects[id];if not obj then return end
  set(a,obj,'Transparency',0);h.EdenSkillStats.weaponShows+=1
  if id==130 then set(a,h.Objects[131],'Transparency',0);set(a,h.Objects[138],'Transparency',0)end
  emit(a,obj,false);emit(a,h.Objects[111],false)
 end
 function h:CancelEdenSkill(naturalEnd)
  local a=active;if not a then return end
  active=nil;token+=1;self.EdenSkillPose=nil;self.ActiveEdenSkill=nil;self.EdenHitStopUntil=nil
  for _,thread in ipairs(a.threads)do if thread~=coroutine.running()then pcall(task.cancel,thread)end end
  for _,t in ipairs(a.tweens)do pcall(function()t:Cancel()end)end
  for obj,properties in pairs(a.properties)do for key,entry in pairs(properties)do pcall(function()obj[key]=entry.value end)end end
  for _,obj in ipairs(a.owned)do pcall(function()obj:Destroy()end)end
  if not naturalEnd then for _,obj in ipairs(a.sounds)do pcall(function()obj:Destroy()end)end end
  if shaker then for _,instance in ipairs(shaker._camShakeInstances)do instance:StartFadeOut(.06)end end
  self.LastEdenSkill={name=a.name,poses=a.poses,finished=true}
 end
 function h:CastEdenSkill(name,settings)
  settings=settings or {}
  if not self.Alive then return false,'stopped'end
  if not self.EdenClips then return false,'loading'end
  local selected
  for _,entry in ipairs(Controller.Skills)do if entry.name==name or entry.key==name then selected=entry;break end end
  if not selected then return false,'unknown skill'end
  if active then return false,'busy'end
  if not settings.IgnoreCooldown and (cooldowns[selected.name]or 0)>os.clock()then return false,'cooldown'end
  local stack=self.Objects[246]
  if config.SkillRequirements==true and not settings.IgnoreRequirements then
   if selected.name=='Voidrush'and stack.Value<30 then return false,'30 stack required'end
   if selected.name=='Deadeye'and(stack:GetAttribute('Combo')or 0)<50 then return false,'50 combo required'end
  end
  token+=1
  local a={token=token,name=selected.name,properties={},threads={},tweens={},owned={},poses={},sounds={}}
  active=a;self.ActiveEdenSkill=selected.name
  cooldowns[selected.name]=os.clock()+selected.duration+.2
  if nativeUI then nativeUI:UpdateItem(selected.name,workspace:GetServerTimeNow()+selected.duration+.2,selected.duration+.2)end
  self.EdenSkillStats.casts[selected.name]=(self.EdenSkillStats.casts[selected.name]or 0)+1
  pose(a,selected.pose)
  if selected.weapon then showWeapon(a,selected.weapon)end
  if selected.name~='Taunt'then sound(a,'Whoosh',.65,selected.name=='Impale'and 1.1 or 1)else sound(a,'Enhanced',.3,1)end
  if selected.name=='Impale'then
   later(a,.5,function()
    emit(a,self.Objects[266],false);hit(a,4,.2)
    if localCharacter and settings.Movement~=false and config.SkillMovement~=false then
     local velocity=own(Instance.new('BodyVelocity'));velocity.Name='EdenImpaleVelocity';velocity.MaxForce=Vector3.new(30000,0,30000);velocity.Velocity=root.CFrame.LookVector*120;velocity.Parent=root;table.insert(a.owned,velocity)
     for i=1,5 do later(a,i*.05,function()if velocity.Parent then velocity.Velocity*=.85 end end)end
     later(a,.25,function()velocity:Destroy()end)
    end
   end)
  elseif selected.name=='Cut Into Nothing'then
   later(a,.55,function()emit(a,self.Objects[248],false);flash(a,.25);hit(a,6,.4);sound(a,'GlassBreak',.45,1.1)end)
  elseif selected.name=='Darkmatter Barrage'then
   sound(a,'DarkRoll',.4,1)
   later(a,.5,function()flash(a,.5);emit(a,self.Objects[221],true)end)
   for i=0,14 do later(a,.5+i*.1,function()emit(a,self.Objects[244],false);shake(a,1,.2);if i%3==0 then sound(a,'RodFire',.22,1.25)end end)end
   later(a,2,function()
    for obj,properties in pairs(a.properties)do if obj:IsA('ParticleEmitter')and properties.Enabled then obj.Enabled=properties.Enabled.value end end
    emit(a,self.Objects[221],false);flash(a,.2);hit(a,7,.5)
   end)
  elseif selected.name=='Voidrush'then
   flash(a,.5);emit(a,self.Objects[221],true);sound(a,'DarkRoll',.45,.85,true)
   later(a,.57,function()
    pose(a,'During',true);shake(a,3,.5)
    if localCharacter then set(a,Lighting,'ExposureCompensation',Lighting.ExposureCompensation);Lighting.ExposureCompensation=-2;tween(a,Lighting,1,{ExposureCompensation=a.properties[Lighting].ExposureCompensation.value})end
   end)
   later(a,1.07,function()zoom(a,50);flash(a,.5)end)
   for i=0,19 do later(a,1.07+i*.1,function()shake(a,1,.2)end)end
   later(a,3.19,function()pose(a,'Out');zoom(a,65);flash(a,.2,true);emit(a,self.Objects[221],false);hit(a,7,.7);sound(a,'Enhanced',.6,.9)end)
   later(a,3.69,function()zoom(a,90);if localCharacter then Lighting.ExposureCompensation=3;tween(a,Lighting,.5,{ExposureCompensation=a.properties[Lighting].ExposureCompensation.value})end end)
  elseif selected.name=='Deadeye'then
   emit(a,self.Objects[130],true);emit(a,self.Objects[293],true)
   local charge=sound(a,'DarkRoll',.4,1.05,true)
   for i=0,2 do later(a,1.4+i*.5,function()emit(a,self.Objects[299],false);shake(a,1,.2);zoom(a,65-i*5)end)end
   later(a,2.9,function()
    local point=settings.Target
    if typeof(point)=='CFrame'then point=point.Position end
    if typeof(point)~='Vector3' then point=localCharacter and player:GetMouse().Hit.Position or root.Position+root.CFrame.LookVector*100 end
    local offset=point-root.Position;if offset.Magnitude>500 then point=root.Position+offset.Unit*500 end
    set(a,self.Objects[281],'CFrame',self.Objects[281].Parent.WorldCFrame:ToObjectSpace(CFrame.new(point)))
    for _,id in ipairs({282,283,284})do set(a,self.Objects[id],'Enabled',true)end
    if charge then charge:Destroy()end
    emit(a,self.Objects[274],false);flash(a,.15,true);hit(a,9,.8);sound(a,'RodFire',.95,.9);sound(a,'GlassBreak',.5,.8);zoom(a,a.properties[camera]and a.properties[camera].FieldOfView.value or 70,1)
    later(a,.2,function()for _,id in ipairs({282,283,284})do self.Objects[id].Enabled=false end end)
   end)
  end
  if selected.name~='Taunt'then self:SetEdenStack(math.min(100,stack.Value+15),math.min(50,(stack:GetAttribute('Combo')or 0)+10))end
  later(a,selected.duration,function()self:CancelEdenSkill(true)end)
  return true
 end
 if localCharacter then
  local gui=own(Instance.new('ScreenGui'));gui.Name='EdenSkillOverlay';gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.DisplayOrder=25;gui:SetAttribute('AuraExchangeUI',true);gui.Parent=player.PlayerGui;h.EdenSkillUI=gui
  assert(nativeUI and nativeUI._AuraRoot,'Native skill UI missing')
  h.EdenNativeSkillUI=nativeUI
  local uiRoot=own(nativeUI._AuraRoot);uiRoot.Name='AuraExchange_EdenNativeSkills';uiRoot:SetAttribute('AuraExchangeUI',true);h.EdenNativeSkillRoot=uiRoot
  for _,other in ipairs(uiRoot.Parent:GetChildren())do
   if other~=uiRoot and other:IsA('Frame')and other.Position==UDim2.fromScale(.99,.9)and other.Size==UDim2.fromScale(.2,.03)then
    local aspect=other:FindFirstChildOfClass('UIAspectRatioConstraint')
    if aspect and math.abs(aspect.AspectRatio-13.476)<.01 then local visible=other.Visible;other.Visible=false;table.insert(h.Cleanups,function()if other.Parent then other.Visible=visible end end)end
   end
  end
  table.insert(h.Cleanups,function()nativeUI:ClearItems()end)
  for index,entry in ipairs(Controller.Skills)do
   local action='AuraExchange_Eden_'..entry.key
   CAS:BindActionAtPriority(action,function(_,state)
    if UIS:GetFocusedTextBox()then return Enum.ContextActionResult.Pass end
    if state==Enum.UserInputState.Begin then h:CastEdenSkill(entry.name)end
    return Enum.ContextActionResult.Sink
   end,UIS.TouchEnabled,3000,Enum.KeyCode[entry.key])
   table.insert(h.Cleanups,function()CAS:UnbindAction(action)end)
   nativeUI:AddItem(Enum.KeyCode[entry.key],entry.name,0,0)
  end
  local displayedDisabled={}
  connect(RunService.Heartbeat,function()
   for _,entry in ipairs(Controller.Skills)do
    local disabled=active~=nil or (cooldowns[entry.name]or 0)>os.clock()
    if displayedDisabled[entry.name]~=disabled then
     displayedDisabled[entry.name]=disabled
     if disabled then nativeUI:SetDisabled(entry.name)else nativeUI:SetEnabled(entry.name)end
    end
   end
  end)
 end
 table.insert(h.Cleanups,function()h:CancelEdenSkill()end)
end
return Controller

end)()
-- END_EDEN_CONTROLLER
-- BEGIN_ILLUSIONARY_CONTROLLER
local IllusionaryController=(function()
-- Original captured skill callbacks; no server-owned damage or skill remotes.
local Controller={}
Controller.Skills={
 {name='you belong here.',key='F',duration=3.3},
 {name='wake up.',key='E',duration=2},
 {name='no, not yet.',key='R',duration=2.5},
 {name='you are a puppet.',key='V',duration=3.5},
}
function Controller.install(h,skills,ui,fx)
 local CAS=game:GetService('ContextActionService')
 local UIS=game:GetService('UserInputService')
 local token=0
 local active,thread
 local cooldowns={}
 local fxThreads,fxObjects={},{}
 h.IllusionaryFXThreads=fxThreads;h.IllusionaryFXObjects=fxObjects
 h.IllusionaryFXStats={projectiles=0,callbacks={}}
 h.IllusionaryFXCoverage={Projectile='original resource and callback; local schedule',Pawn='callback saved; skill model missing',Queen='callback saved; skill model missing',Rook='callbacks saved; skill model missing'}
 local function fxTask(fn,...)
  local args=table.pack(...)
  local t=task.defer(function()
   local ok,err=pcall(fn,table.unpack(args,1,args.n))
   if not ok and h.Alive then table.insert(h.Errors,{property='IllusionaryFX',error=tostring(err)})end
  end)
  table.insert(h.Threads,t);table.insert(fxThreads,t);return t
 end
 local function clearFX()
  for _,t in ipairs(fxThreads)do if t~=coroutine.running()then pcall(task.cancel,t)end end
  for _,x in ipairs(fxObjects)do pcall(function()x:Destroy()end)end
  table.clear(fxThreads);table.clear(fxObjects)
 end
 h.CancelIllusionaryFX=clearFX
 function h:PlayIllusionaryProjectile(origin,destination)
  if not self.Alive then return false,'stopped'end
  if typeof(origin)~='CFrame'or typeof(destination)~='Vector3'then return false,'CFrame and Vector3 required'end
  fxTask(function()
   fx.Projectile(origin,destination)
   self.IllusionaryFXStats.projectiles+=1
  end)
  return true
 end
 local function skillVisual(entry,settings)
  local char=h.Root;local hrp=char:FindFirstChild('HumanoidRootPart')
  if not hrp then return end
  local emit=hrp:FindFirstChild('SkillUseEmit')
  local icon=({F='Projectiles',E='Pawn',R='Queen',V='Rook'})[entry.key]
  local attachment=emit and emit:FindFirstChild(icon,true)
  if attachment then for _,x in ipairs(attachment:GetDescendants())do if x:IsA('ParticleEmitter')then x:Emit(x:GetAttribute('EmitCount')or 1)end end end
  if entry.key~='F'then return end
  local origin=hrp.CFrame
  local destination=settings.TargetPosition
  if typeof(destination)~='Vector3'then
   local mouse=game.Players.LocalPlayer:GetMouse()
   destination=mouse.Hit.Position
   local delta=destination-origin.Position
   if delta.Magnitude<3 then destination=origin.Position+origin.LookVector*60
   elseif delta.Magnitude>200 then destination=origin.Position+delta.Unit*200 end
  end
  fxTask(function()
   task.wait(2)
   for _=1,20 do
    if not h.Alive then return end
    h:PlayIllusionaryProjectile(origin,destination)
    task.wait(.05)
   end
  end)
 end
 h.IllusionarySkills=Controller.Skills
 h.IllusionarySkillStats={casts={},completed=0}
 local root=ui._AuraRoot
 root.Name='AuraExchange_IllusionaryNativeSkills';root:SetAttribute('AuraExchangeUI',true)
 h.IllusionaryNativeSkillRoot=root;h.IllusionaryNativeSkillUI=ui
 table.insert(h.Created,root)
 for _,other in ipairs(root.Parent:GetChildren())do
  if other~=root and other:IsA('Frame')and other.Position==UDim2.fromScale(.99,.9)and other.Size==UDim2.fromScale(.2,.03)then
   local aspect=other:FindFirstChildOfClass('UIAspectRatioConstraint')
   if aspect and math.abs(aspect.AspectRatio-13.476)<.01 then
    local visible=other.Visible;other.Visible=false
    table.insert(h.Cleanups,function()if other.Parent then other.Visible=visible end end)
   end
  end
 end
 local function update()
  for _,entry in ipairs(Controller.Skills)do
   if active or(cooldowns[entry.name]or 0)>os.clock()then ui:SetDisabled(entry.name)else ui:SetEnabled(entry.name)end
  end
 end
 function h:CancelIllusionarySkill()
  clearFX()
  token+=1
  if thread and thread~=coroutine.running()then pcall(task.cancel,thread)end
  if active then pcall(skills[active].Cancel)end
  thread=nil;active=nil;self.ActiveIllusionarySkill=nil
  for _,x in ipairs(self.Created)do if x:IsA('ImageLabel')and x.Name=='ScreenFX'and x.Parent then x:Destroy()end end
  if self.Alive then update()end
 end
 function h:CastIllusionarySkill(name,settings)
  settings=settings or {}
  if not self.Alive then return false,'stopped'end
  local entry
  for _,candidate in ipairs(Controller.Skills)do if candidate.name==name or candidate.key==name then entry=candidate;break end end
  if not entry then return false,'unknown skill'end
  if active then return false,'busy'end
  if not settings.IgnoreCooldown and(cooldowns[entry.name]or 0)>os.clock()then return false,'cooldown'end
  clearFX()
  token+=1;local castToken=token
  active=entry.name;self.ActiveIllusionarySkill=active
  cooldowns[active]=os.clock()+entry.duration+.2
  ui:UpdateItem(active,workspace:GetServerTimeNow()+entry.duration+.2,entry.duration+.2)
  self.IllusionarySkillStats.casts[active]=(self.IllusionarySkillStats.casts[active]or 0)+1
  update()
  skillVisual(entry,settings)
  thread=task.defer(function()
   local ok,err=pcall(skills[entry.name].Activate)
   pcall(skills[entry.name].Cancel)
   if not ok then table.insert(self.Errors,{property='IllusionarySkill:'..entry.name,error=tostring(err)})end
   if self.Alive and token==castToken then
    active=nil;thread=nil;self.ActiveIllusionarySkill=nil
    self.IllusionarySkillStats.completed+=1;update()
   end
  end)
  table.insert(self.Threads,thread)
  return true
 end
 for index,entry in ipairs(Controller.Skills)do
  local action='AuraExchange_Illusionary_'..entry.key
  CAS:BindActionAtPriority(action,function(_,state)
   if UIS:GetFocusedTextBox()then return Enum.ContextActionResult.Pass end
   if state==Enum.UserInputState.Begin then h:CastIllusionarySkill(entry.name)end
   return Enum.ContextActionResult.Sink
  end,UIS.TouchEnabled,3000,Enum.KeyCode[entry.key],skills[entry.name].ConsoleKeyCode)
  table.insert(h.Cleanups,function()CAS:UnbindAction(action)end)
  if UIS.TouchEnabled then
   CAS:SetPosition(action,UDim2.new(1,-220+(index-1)%2*98,1,-245-math.floor((index-1)/2)*58))
   CAS:SetTitle(action,entry.name)
  end
  ui:AddItem(Enum.KeyCode[entry.key],entry.name,0,0)
 end
 local heartbeat=game:GetService('RunService').Heartbeat:Connect(function()if h.Alive then update()end end)
 table.insert(h.Connections,heartbeat)
 table.insert(h.Cleanups,function()h:CancelIllusionarySkill();ui:ClearItems()end)
end
return Controller

end)()
-- END_ILLUSIONARY_CONTROLLER



local Module={Names={'ASTRAIOS','Monarch','LEVIATHAN','Tomorrow.','Oppression','Lamenthyr','Eden','Illusionary'},Version='2026-10-25-ill-fx1'}
local environment=getgenv()
environment.__AuraExchangeOwnership=environment.__AuraExchangeOwnership or setmetatable({},{__mode='k'})
local ownership=environment.__AuraExchangeOwnership
local bodyAnimations={ASTRAIOS='98572784316773',Monarch='118289001826286',LEVIATHAN='132979577139811',['Tomorrow.']='113180536437121',Oppression='101709109117549',Lamenthyr='86458494810549',Eden='130650435171934',Illusionary='109536481760521'}
local bodyJoints={Torso={'HumanoidRootPart','RootJoint'},Head={'Torso','Neck'},['Left Arm']={'Torso','Left Shoulder'},['Right Arm']={'Torso','Right Shoulder'},['Left Leg']={'Torso','Left Hip'},['Right Leg']={'Torso','Right Hip'}}
local function enum(s)
 local group,name=s:match('^Enum%.([^%.]+)%.(.+)$')
 return group and Enum[group][name]
end
local function decode(p,objects)
 local t,v=p.t,p.v
 if t=='nil' then return nil
 elseif t=='string' or t=='boolean' then return v
 elseif t=='number' then return tonumber(v)
 elseif t=='binary' then return crypt.base64decode(v)
 elseif t=='ref' then return objects[v]
 elseif t=='enum' then return enum(v)
 elseif t=='CFrame' then return CFrame.new(table.unpack(v))
 elseif t=='Vector3' then return Vector3.new(table.unpack(v))
 elseif t=='Vector2' then return Vector2.new(table.unpack(v))
 elseif t=='Vector3int16' then return Vector3int16.new(table.unpack(v))
 elseif t=='Vector2int16' then return Vector2int16.new(table.unpack(v))
 elseif t=='Color3' then return Color3.new(table.unpack(v))
 elseif t=='BrickColor' then return BrickColor.new(v)
 elseif t=='UDim' then return UDim.new(table.unpack(v))
 elseif t=='UDim2' then return UDim2.new(table.unpack(v))
 elseif t=='Rect' then return Rect.new(table.unpack(v))
 elseif t=='NumberRange' then return NumberRange.new(table.unpack(v))
 elseif t=='NumberSequence' then local a={};for _,k in ipairs(v) do table.insert(a,NumberSequenceKeypoint.new(table.unpack(k))) end;return NumberSequence.new(a)
 elseif t=='ColorSequence' then local a={};for _,k in ipairs(v) do table.insert(a,ColorSequenceKeypoint.new(k[1],Color3.new(k[2],k[3],k[4]))) end;return ColorSequence.new(a)
 elseif t=='PhysicalProperties' then return PhysicalProperties.new(table.unpack(v))
 elseif t=='Font' then return Font.new(v[1],enum(v[2]),enum(v[3]))
 elseif t=='Content' then return Content.fromUri(v)
 elseif t=='Axes' then local a={};if v[1] then table.insert(a,Enum.Axis.X) end;if v[2] then table.insert(a,Enum.Axis.Y) end;if v[3] then table.insert(a,Enum.Axis.Z) end;return Axes.new(table.unpack(a))
 elseif t=='Faces' then local a={};for i,n in ipairs({'Top','Bottom','Left','Right','Back','Front'}) do if v[i] then table.insert(a,Enum.NormalId[n]) end end;return Faces.new(table.unpack(a))
 end
 error('unsupported type '..t)
end
local skip={Parent=true,Source=true,Disabled=true,Enabled=true,RunContext=true,ScriptGuid=true,UniqueId=true,HistoryId=true,Capabilities=true,AssetId=true,MeshId=true,MeshContent=true,PhysicsData=true,PhysicalConfigData=true,MeshSize=true,Color3uint8=true,MaterialVariantSerialized=true,CollisionGroupId=true,formFactorRaw=true,size=true,shape=true,Position=true,Orientation=true,Rotation=true,Velocity=true,RotVelocity=true,TextureContent=true,AudioContent=true,InitialSize=true,WorldPivotData=true,SourceAssetId=true}
for _,k in ipairs({'AttributesSerialize','Tags','DefinesCapabilities','NeedsPivotMigration','EquippedEmotesDataInternal','TexturePackMetadata','EmotesDataInternal','RootPart','InertiaMigrated','ModelMeshCFrame','ScaleFactor','SlimHash','ModelMeshData','Health_XML','InternalBodyScale','LocalizedText','GuiState','OpenTypeFeaturesError','ModelMeshSize','FluidFidelityInternal','VertexCount','InternalHeadScale','AeroMeshData','CameraCFrame','CameraFieldOfView','ViewportSize','NearPlaneZ'}) do skip[k]=true end
skip.Position=nil;skip.Orientation=nil;skip.Rotation=nil
local partAliases={Position=true,Orientation=true,Rotation=true}
for _,key in ipairs({'IsReady','TimeLength','Connected','RmsLevel','PeakLevel'})do skip[key]=true end
local mappedBodies={Head=true,Torso=true,HumanoidRootPart=true,['Left Arm']=true,['Right Arm']=true,['Left Leg']=true,['Right Leg']=true}
local normalAttachments={RootAttachment=true,NeckAttachment=true,BodyFrontAttachment=true,BodyBackAttachment=true,LeftCollarAttachment=true,RightCollarAttachment=true,WaistBackAttachment=true,WaistCenterAttachment=true,WaistFrontAttachment=true,FaceCenterAttachment=true,FaceFrontAttachment=true,HairAttachment=true,HatAttachment=true,LeftFootAttachment=true,RightFootAttachment=true,LeftGripAttachment=true,LeftShoulderAttachment=true,RightGripAttachment=true,RightShoulderAttachment=true}
local normalMotors={RootJoint=true,Neck=true,['Left Shoulder']=true,['Right Shoulder']=true,['Left Hip']=true,['Right Hip']=true}
local rootSkip={Accessory=true,Shirt=true,Pants=true,ShirtGraphic=true,BodyColors=true,CharacterMesh=true,HumanoidDescription=true}
local function load(base,name,suffix)
 assert(type(readfile)=='function','executor readfile is required')
 return Http:JSONDecode(readfile(base..'/'..name..(suffix or '')..'.json'))
end
function Module.new(base,readData)
 base=base or 'aura_capture_20261025'
 local function load(directory,name,suffix)
  if name=='Tomorrow.' then name='Tomorrow' end
  if readData then return readData(directory,name,suffix) end
  assert(type(readfile)=='function','executor readfile is required')
  return Http:JSONDecode(readfile(directory..'/'..name..(suffix or '')..'.json'))
 end
 local api={BaseDirectory=base,Names=Module.Names,Active=nil,Version=Module.Version,_request=0}
 local poseCache={}
 local function bodyClip(name,asset)
  local cacheKey=name..(asset or '')
  if poseCache[cacheKey] then return poseCache[cacheKey] end
  local data=load(base..'/animations','animation_'..(asset or bodyAnimations[name]))
  if data.format=='AuraPoseClip/1' then
   local channels={}
   for body,frames in pairs(data.channels) do
    local list={};channels[body]=list
    for _,frame in ipairs(frames) do table.insert(list,{time=frame.time,cf=CFrame.new(table.unpack(frame.cf)),style=frame.style,direction=frame.direction}) end
   end
   local clip={channels=channels,duration=data.duration,byPath=data.channelMode=='paths'};poseCache[cacheKey]=clip;return clip
  end
  local channels={};local duration=0
  for _,node in ipairs(data.nodes) do
   if node.class=='Keyframe' then duration=math.max(duration,node.props.Time.v) end
   if node.class=='Pose' and node.name~='HumanoidRootPart' and (not node.props.Weight or node.props.Weight.v>0) then
    local frame=data.nodes[node.parent or 0]
    while frame and frame.class~='Keyframe' do frame=data.nodes[frame.parent or 0] end
    if frame then
     local key=node.name
     if name=='Lamenthyr' then
      local ancestors={node.name};local ancestor=data.nodes[node.parent or 0]
      while ancestor and ancestor.class=='Pose' do table.insert(ancestors,1,ancestor.name);ancestor=data.nodes[ancestor.parent or 0] end
      key=table.concat(ancestors,'/')
     end
     local list=channels[key] or {};channels[key]=list
     table.insert(list,{time=frame.props.Time.v,cf=CFrame.new(table.unpack(node.props.CFrame.v)),style=node.props.EasingStyle and node.props.EasingStyle.v:match('%.([^%.]+)$') or 'Linear',direction=node.props.EasingDirection and node.props.EasingDirection.v:match('%.([^%.]+)$') or 'In'})
    end
   end
  end
  for _,list in pairs(channels) do table.sort(list,function(a,b)return a.time<b.time end) end
  assert(asset or channels.Torso or channels['HumanoidRootPart/Torso'],'body keyframes missing')
  local clip={channels=channels,duration=math.max(duration,0.001),byPath=name=='Lamenthyr'};poseCache[cacheKey]=clip;return clip
 end
 local registered={}
 function api:RegisterAnimation(id)
  assert(RunService:IsStudio(),'RegisterAnimation requires Studio; runtime playback uses the captured asset IDs')
  id=tostring(id):match('%d+')
  assert(id,'animation id missing')
  if registered[id] then return registered[id].url end
  local data=load(base..'/animations','animation_'..id)
  assert(data.nodes,'RegisterAnimation needs the full animation JSON from the resource package')
  local objects={}
  for _,n in ipairs(data.nodes) do local x=Instance.new(n.class);x.Name=n.name;objects[n.id]=x end
  for _,n in ipairs(data.nodes) do
   local x=objects[n.id]
   for k,p in pairs(n.props) do x[k]=decode(p,objects) end
   for k,p in pairs(n.attributes or {}) do x:SetAttribute(k,decode(p,objects)) end
   if n.parent then x.Parent=objects[n.parent] end
  end
  local seq=objects[1]
  local url=game:GetService('KeyframeSequenceProvider'):RegisterKeyframeSequence(seq)
  registered[id]={url=url,sequence=seq}
  return url
 end
 local function build(name,target,options)
  options=options or {}
  assert(table.find(Module.Names,name),'unknown aura: '..tostring(name))
  local data=load(base,name)
  local objects,existing,omitted={},{},{}
  local handle={Name=name,Data=data,Objects=objects,Errors={},Created={},Connections={},Threads={},Tracks={},BodyOriginals={},Cleanups={},RenderBindings={},Alive=true}
  function handle:Stop()
   if not self.Alive then return end;self.Alive=false
   for _,c in ipairs(self.Connections) do pcall(function()c:Disconnect() end) end
   for _,t in ipairs(self.Tracks) do pcall(function()t:Stop(0);t:Destroy() end) end
   for _,t in ipairs(self.Threads) do pcall(task.cancel,t) end
   for _,cleanup in ipairs(self.Cleanups) do pcall(cleanup) end
   for binding in pairs(self.RenderBindings) do pcall(function()RunService:UnbindFromRenderStep(binding)end) end
   for joint,value in pairs(self.BodyOriginals) do pcall(function()joint.Transform=value end) end
   for i=#self.Created,1,-1 do pcall(function()self.Created[i]:Destroy() end) end
   if api.Active==self then api.Active=nil end
   if api.Pending==self then api.Pending=nil end
   local slot=target and ownership[target]
   if slot and slot.handle==self then slot.handle=nil end
   if slot and slot.pending==self then slot.pending=nil end
  end
  local function cancelled()
   if not handle.Alive or options._IsCurrent and not options._IsCurrent() then handle:Stop();return true end
   return false
  end
  if options._OnHandle then options._OnHandle(handle) end
  local function errorItem(node,property,err) table.insert(handle.Errors,{id=node,property=property,error=tostring(err)}) end
  for _,n in ipairs(data.nodes) do
   if cancelled() then return nil end
   local parent=data.nodes[n.parent or 0]
   local obj
   if target then
    if n.id==1 then obj=target
    elseif parent and parent.id==1 and mappedBodies[n.name] and n.class=='Part' then obj=target:FindFirstChild(n.name)
    elseif parent and parent.id==1 and n.class=='Humanoid' then obj=target:FindFirstChildOfClass('Humanoid')
    elseif parent and existing[parent.id] and ((n.class=='Animator') or (n.class=='Motor6D' and normalMotors[n.name]) or (n.class=='Attachment' and normalAttachments[n.name])) then obj=objects[parent.id] and objects[parent.id]:FindFirstChild(n.name)
    elseif parent and parent.id==1 and (rootSkip[n.class] or n.class=='Script' or n.class=='LocalScript') then omitted[n.id]=true
    end
    if parent and omitted[parent.id] then omitted[n.id]=true end
   end
   if obj then objects[n.id]=obj;existing[n.id]=true
   elseif not omitted[n.id] then
    if n.class=='UnionOperation' and n.geometryXML then
     assert(type(writefile)=='function' and type(getcustomasset)=='function','Eden union geometry needs writefile and getcustomasset')
     local directory='AuraExchangeAssets';if not isfolder(directory) then makefolder(directory) end
     local file=directory..'/eden_union_'..tostring(n.id)..'.rbxmx';writefile(file,n.geometryXML)
     local ok,list=pcall(function()return game:GetObjects(getcustomasset(file))end)
     if ok then
      for _,item in ipairs(list) do if not obj and item:IsA('UnionOperation')then obj=item;obj:ClearAllChildren()else item:Destroy()end end
     end
     if cancelled() then if obj then obj:Destroy()end;return nil end
     assert(obj,'Eden union geometry failed: '..tostring(ok and n.name or list))
     handle.UnionsLoaded=(handle.UnionsLoaded or 0)+1
    end
    if n.class=='MeshPart' and n.props.MeshId and #n.props.MeshId.v>0 then
     local ok,value=pcall(function()return game:GetService('AssetService'):CreateMeshPartAsync(Content.fromUri(n.props.MeshId.v),{CollisionFidelity=Enum.CollisionFidelity.Box,RenderFidelity=Enum.RenderFidelity.Automatic}) end)
     if cancelled() then if ok then value:Destroy() end;return nil end
     if ok then obj=value;obj:ClearAllChildren() else errorItem(n.id,'MeshId',value) end
    end
    if not obj then local ok,value=pcall(Instance.new,n.class);if ok then obj=value else errorItem(n.id,'Instance.new',value) end end
    if obj then
     obj.Name=n.name;objects[n.id]=obj;table.insert(handle.Created,obj)
     if obj:IsA('BaseScript') then obj.Disabled=true end
     if obj:IsA('BasePart') then obj.Anchored=false;obj.CanCollide=false;obj.CanTouch=false;obj.Massless=true end
    end
   end
   if n.id%75==0 then task.wait() end
  end
  local targetCF=target and target:FindFirstChild('HumanoidRootPart') and target.HumanoidRootPart.CFrame or options.CFrame
  if cancelled() then return nil end
  local origin=data.origin and CFrame.new(table.unpack(data.origin))
  for _,n in ipairs(data.nodes) do
   local obj=objects[n.id]
   if obj and not existing[n.id] then
    for k,p in pairs(n.props) do
     if not skip[k] and not (obj:IsA('BasePart') and partAliases[k]) and not (n.geometryXML and (k=='MeshData' or k=='ChildData' or k=='MeshData2' or k=='ChildData2' or k=='ComponentIndex' or k=='OffCentered' or k=='FormFactor' or k=='TriangleCount')) and not k:match('Content$') and p.t~='ref' and (options.Physics==true or (k~='CanCollide' and k~='CanTouch' and k~='Anchored' and k~='Massless' and k~='CanQuery')) then
      local ok,err=pcall(function()
       local v=decode(p,objects)
       if k=='CFrame' and obj:IsA('BasePart') and targetCF and origin and not (data.dependencyNodes and data.dependencyNodes[tostring(n.id)]) then v=targetCF*origin:ToObjectSpace(v) end
       obj[k]=v
      end)
      if not ok then errorItem(n.id,k,err) end
     end
    end
    for k,p in pairs(n.attributes or {}) do pcall(function()obj:SetAttribute(k,decode(p,objects)) end) end
    if name=='Illusionary'and obj:IsA('TextLabel')and obj:GetAttribute('OriginalPosition')then
     obj.Position=obj:GetAttribute('OriginalPosition');obj.TextTransparency=0;obj.TextColor3=Color3.new(1,1,1)
    end
    for _,tag in ipairs(n.tags or {}) do pcall(function()game:GetService('CollectionService'):AddTag(obj,tag) end) end
    if obj:IsA('GuiBase2d') then obj.AutoLocalize=false end
    if obj:IsA('TextLabel')or obj:IsA('TextButton')or obj:IsA('TextBox')then
     local font=n.props.FontFace;if font then obj.FontFace=decode(font,objects)end
    end
   end
  end
  local dependencyFolders={}
  for _,n in ipairs(data.nodes) do
   local obj=objects[n.id]
   if obj and not existing[n.id] then
    for k,p in pairs(n.props) do if p.t=='ref' and not skip[k] then local ok,err=pcall(function()obj[k]=decode(p,objects) end);if not ok then errorItem(n.id,k,err) end end end
    if n.parent and objects[n.parent] then obj.Parent=objects[n.parent]
    elseif data.dependencies and data.dependencies[tostring(n.id)] then
     local dependency=data.dependencies[tostring(n.id)]
     if dependency.install~='PlayerGui' then
      local service=dependency.install=='SoundService' and game:GetService('SoundService') or game:GetService('ReplicatedStorage')
      local folder=dependencyFolders[service]
      if not folder then folder=Instance.new('Folder');folder.Name='AuraExchange_'..Http:GenerateGUID(false);folder.Parent=service;dependencyFolders[service]=folder;table.insert(handle.Created,folder) end
      obj.Parent=folder
     end
    end
    for _,k in ipairs({'Enabled','RunContext'}) do local p=n.props[k];if p and not obj:IsA('BaseScript') then pcall(function()obj[k]=decode(p,objects) end) end end
   end
  end
  handle.Root=objects[1];handle.Existing=existing
  if name=='Eden' then
   local monster=objects[313];if monster then monster.Primary.Anchored=true;handle.EdenMonster=monster end
  end
  if name=='Tomorrow.' then
   local portal
   for _,obj in pairs(objects) do if obj:IsA('Folder') and obj.Name=='ParallaxPortal' then portal=obj;break end end
   for id,dependency in pairs(data.dependencies or {}) do
    if dependency.install=='PlayerGui' and portal then
     local surface=objects[tonumber(id)];surface.Parent=portal;handle.PortalRoot=portal;handle.PortalGui=surface
     portal:SetAttribute('InstanceId','AuraExchange_'..Http:GenerateGUID(false))
    end
   end
  end
  -- The Monarch snapshot contains two different titles at the same position.
  -- Keep all label instances, with a separate subtitle row and aligned shadow.
  if name=='Monarch' and options.FixLabels~=false then
   for _,gui in ipairs(handle.Created) do
    if gui:IsA('BillboardGui') then
     local title=gui:FindFirstChild('Title');local subtitle=gui:FindFirstChild('Tyrant')
     local rarity=gui:FindFirstChild('Rarity');local shadow=gui:FindFirstChild('BehindRarity')
     if title and subtitle and title:IsA('TextLabel') and subtitle:IsA('TextLabel') then
      subtitle.Position=UDim2.fromScale(0.5,0.245);subtitle.Size=UDim2.fromScale(0.9,0.055)
      subtitle:SetAttribute('AuraExchangeLabelLayout','MonarchSubtitleRow')
     end
     if rarity and shadow and rarity:IsA('TextLabel') and shadow:IsA('TextLabel') then
      shadow.Position=rarity.Position;shadow.Size=rarity.Size;shadow.AnchorPoint=rarity.AnchorPoint;shadow.Text=rarity.Text
      shadow:SetAttribute('AuraExchangeLabelLayout','MonarchRarityShadow')
     end
    end
   end
  end
  function handle:Play()
   if not self.Alive or self.Playing then return self end;self.Playing=true
   local humanoid=self.Root:FindFirstChildOfClass('Humanoid')
   self.BodyTracks={}
   if options.Animations~=false then
    local animator=humanoid and humanoid:FindFirstChildOfClass('Animator')
    if animator then
     for _,t in ipairs(data.tracks or {}) do
      local ok,err=pcall(function()
       local anim=Instance.new('Animation');anim.AnimationId=options.LocalAnimations and api:RegisterAnimation(t.id) or t.id
       local trackAnimator=t.animatorNode and objects[t.animatorNode] or animator
       local track=trackAnimator:LoadAnimation(anim);anim:Destroy();track.Looped=t.looped;track.Priority=options.AnimationPriority or Enum.AnimationPriority.Action;track:Play(0.1,t.weight or 1,t.speed or 1)
       table.insert(self.Tracks,track)
       if trackAnimator==animator then table.insert(self.BodyTracks,{track=track,weight=t.weight or 1,speed=t.speed or 1}) end
      end)
      if not ok then errorItem(0,'Animation:'..tostring(t.id),err) end
     end
    end
   end
   if options.Animations~=false and options.BodyPose~=false then
    local ok,clip=pcall(bodyClip,name)
    if cancelled() then return self end
    local bindings={}
    for body,location in pairs(bodyJoints) do
     local parent=self.Root:FindFirstChild(location[1]);local joint=parent and parent:FindFirstChild(location[2])
     local source
     for _,node in ipairs(data.nodes) do if node.class=='Motor6D' and node.name==location[2] then source=node;break end end
     if joint and joint:IsA('Motor6D') and source then
      self.BodyOriginals[joint]=joint.Transform
      local c0=CFrame.new(table.unpack(source.props.C0.v));local c1=CFrame.new(table.unpack(source.props.C1.v))
      local b={joint=joint,prefix=joint.C0:Inverse()*c0,suffix=c1:Inverse()*joint.C1,index=1,body=true,edenChannel=body}
      if ok then b.frames=clip.channels[clip.byPath and ('HumanoidRootPart/'..(body=='Torso' and 'Torso' or 'Torso/'..body)) or body] end
      if not b.frames then
       local p0=data.nodes[source.props.Part0.v];local p1=data.nodes[source.props.Part1.v]
       b.constant=c0:Inverse()*CFrame.new(table.unpack(p0.props.CFrame.v)):Inverse()*CFrame.new(table.unpack(p1.props.CFrame.v))*c1
      end
      table.insert(bindings,b)
     end
    end
    if ok then
     local posePaths={}
     if clip.byPath then
      for _,node in ipairs(data.nodes) do if node.name=='HumanoidRootPart' and node.parent==1 then posePaths[node.id]='HumanoidRootPart' end end
      local changed=true
      while changed do
       changed=false
       for _,node in ipairs(data.nodes) do
        if node.class=='Motor6D' then
         local p0=node.props.Part0 and node.props.Part0.v;local p1=node.props.Part1 and node.props.Part1.v
         if p0 and p1 and posePaths[p0] and not posePaths[p1] then posePaths[p1]=posePaths[p0]..'/'..data.nodes[p1].name;changed=true end
        elseif node.class=='Bone' and posePaths[node.parent] and not posePaths[node.id] then
         posePaths[node.id]=posePaths[node.parent]..'/'..node.name;changed=true
        end
       end
      end
     end
     for _,node in ipairs(data.nodes) do
      local joint=objects[node.id]
      local part=node.props.Part1 and data.nodes[node.props.Part1.v or 0]
      local key=part and (clip.byPath and posePaths[part.id] or part.name)
      local frames=key and clip.channels[key]
      if node.class=='Motor6D' and joint and not existing[node.id] and frames and not bodyJoints[part.name] then
       self.BodyOriginals[joint]=joint.Transform
       table.insert(bindings,{joint=joint,prefix=CFrame.identity,suffix=CFrame.identity,index=1,frames=frames})
      end
      if node.class=='Bone' and joint and not existing[node.id] and clip.byPath then
       local frames=posePaths[node.id] and clip.channels[posePaths[node.id]]
       if frames then
        self.BodyOriginals[joint]=joint.Transform
        table.insert(bindings,{joint=joint,prefix=CFrame.identity,suffix=CFrame.identity,index=1,frames=frames})
        self.BoneBindings=(self.BoneBindings or 0)+1
       end
      end
     end
    end
    self.PoseBindings=#bindings
    if name=='Eden' then
     self.EdenClips={}
     for role,id in pairs(EdenController.Animations)do self.EdenClips[role]=bodyClip(name,id) end
     self.EdenAnimationTracks={};self.EdenRigCompatible=true
     for _,b in ipairs(bindings)do if b.body and (not b.prefix:FuzzyEq(CFrame.identity,.0001)or not b.suffix:FuzzyEq(CFrame.identity,.0001))then self.EdenRigCompatible=false end end
     if humanoid and humanoid:FindFirstChildOfClass('Animator')then
      local animator=humanoid:FindFirstChildOfClass('Animator')
      for role,id in pairs(EdenController.Animations)do
       local anim=Instance.new('Animation');anim.AnimationId='rbxassetid://'..id
       local track=animator:LoadAnimation(anim);anim:Destroy();track.Priority=(role=='idle'or role=='walk'or role=='jump'or role=='fall'or role=='tool')and Enum.AnimationPriority.Movement or Enum.AnimationPriority.Action
       self.EdenAnimationTracks[id]=track;table.insert(self.Tracks,track)
      end
      for _,entry in ipairs(self.BodyTracks)do entry.track:Stop(0)end
     end
     for _,id in ipairs({113,114,115})do
      local joint=objects[id];local part=data.nodes[data.nodes[id].props.Part1.v]
      self.BodyOriginals[joint]=joint.Transform
      table.insert(bindings,{joint=joint,prefix=CFrame.identity,suffix=CFrame.identity,index=1,edenChannel=part.name,constant=CFrame.identity})
     end
     self.EdenWeaponBindings=3
     local monsterClip=bodyClip(name,'123533160693559')
     for _,node in ipairs(data.nodes)do
      local joint=objects[node.id];local p1=node.props.Part1 and data.nodes[node.props.Part1.v or 0]
      local p0=node.props.Part0 and data.nodes[node.props.Part0.v or 0]
      if node.class=='Motor6D' and p0 and p0.id==314 and p1 and joint then
       local frames=monsterClip.channels[p1.name]
       if frames then
        self.BodyOriginals[joint]=joint.Transform
        table.insert(bindings,{joint=joint,prefix=CFrame.identity,suffix=CFrame.identity,index=1,frames=frames,clip=monsterClip,lastTime=-1})
        self.MonsterBindings=(self.MonsterBindings or 0)+1
       end
      end
     end
    end
    self.PoseSource=ok and 'original-keyframes' or 'captured-pose'
    local start=os.clock();local lastTime=-1
    local connection=RunService.PreSimulation:Connect(function()
     if not self.Alive then return end
     local state=humanoid and humanoid:GetState()
     local moving=name~='Eden' and options.PreserveLocomotion==true and humanoid~=nil and (humanoid.MoveDirection.Magnitude>0.05 or state==Enum.HumanoidStateType.Jumping or state==Enum.HumanoidStateType.Freefall or state==Enum.HumanoidStateType.Climbing or state==Enum.HumanoidStateType.Swimming or state==Enum.HumanoidStateType.Seated)
     if self.BodyPoseSuspended~=moving then
      self.BodyPoseSuspended=moving
      for _,entry in ipairs(name=='Eden' and {} or self.BodyTracks)do
       if moving then entry.track:AdjustWeight(0,0.12)
       elseif not entry.track.IsPlaying then entry.track:Play(0.12,entry.weight,entry.speed)
       else entry.track:AdjustWeight(entry.weight,0.12)end
      end
     end
     local edenClip,edenTime
     if name=='Eden' then
      local skill=self.EdenSkillPose
      local locomotionRole=state==Enum.HumanoidStateType.Jumping and 'jump' or state==Enum.HumanoidStateType.Freefall and 'fall' or humanoid and humanoid.MoveDirection.Magnitude>.05 and 'walk' or 'idle'
      local locoSpeed=locomotionRole=='walk' and math.max(.1,humanoid.WalkSpeed/14.5)or 1
      if self._EdenLocomotionRole~=locomotionRole then
       if self._EdenLocomotionTrack then self._EdenLocomotionTrack:Stop(.1)end
       self._EdenLocomotionRole=locomotionRole
       local track=self.EdenAnimationTracks[EdenController.Animations[locomotionRole]]
       if track then track.Looped=true;track:Play(.1,1,locoSpeed)end
       self._EdenLocomotionTrack=track
      elseif self._EdenLocomotionTrack then self._EdenLocomotionTrack:AdjustSpeed(locoSpeed)end
      if self._EdenSkillKey~=skill then
       if self._EdenSkillTrack then self._EdenSkillTrack:Stop(.1)end
       self._EdenSkillKey=skill;self._EdenSkillTrack=nil
       if skill then
        local track=self.EdenAnimationTracks[skill.id]
        if track then track.Looped=skill.looped;track:Play(.1,1,1)end
        self._EdenSkillTrack=track
       end
      end
      if self._EdenSkillTrack then self._EdenSkillTrack:AdjustSpeed(self.EdenHitStopUntil and os.clock()<self.EdenHitStopUntil and 0 or 1)end
      self._EdenTrack=self._EdenSkillTrack or self._EdenLocomotionTrack
      self.EdenNativePlayback=self.EdenRigCompatible and self._EdenTrack~=nil and self._EdenTrack.IsPlaying and self._EdenTrack.Length>0
      self.EdenPlaybackMode=self.EdenNativePlayback and 'native-animation' or 'captured-keyframes'
      local role=skill and skill.name or locomotionRole
      edenClip=self.EdenClips[role]
      local key=skill or role
      local speed=not skill and role=='walk' and math.max(.1,humanoid.WalkSpeed/14.5)or 1
      if self._EdenPoseKey~=key then
       self._EdenPoseKey=key;self._EdenPoseStart=os.clock()
       for _,b in ipairs(bindings)do if b.edenChannel then b.index=1;b.blendFrom=b.joint.Transform end end
       local id=EdenController.Animations[role]
       self.EdenAnimationId=id
      end
      self.EdenMotionState=role
      local elapsed=(os.clock()-(skill and skill.started or self._EdenPoseStart))*speed
      local duration=math.max(edenClip.duration,.001)
      edenTime=(not skill and role~='jump' or skill and skill.looped)and elapsed%duration or math.min(elapsed,duration)
      if self._EdenLastTime and edenTime<self._EdenLastTime then for _,b in ipairs(bindings)do if b.edenChannel then b.index=1 end end end
      self._EdenLastTime=edenTime
     end
     local time=ok and (os.clock()-start)%clip.duration or 0
     if time<lastTime then for _,b in ipairs(bindings) do b.index=1 end end;lastTime=time
     for _,b in ipairs(bindings) do
      local cf=b.constant
      local frames=b.frames
      local frameTime=time
      if edenClip and b.edenChannel then
       frames=edenClip.channels[b.edenChannel]or self.EdenClips.idle.channels[b.edenChannel]
       frameTime=edenTime
       if frames and b.index>#frames then b.index=1 end
      end
      if frames then
       if b.clip then frameTime=(os.clock()-start)%b.clip.duration;if frameTime<b.lastTime then b.index=1 end;b.lastTime=frameTime end
       while frames[b.index+1] and frames[b.index+1].time<=frameTime do b.index+=1 end
       local a=frames[b.index];local nextFrame=frames[b.index+1]
       cf=a.cf
       if nextFrame and nextFrame.time>a.time then
        local alpha=math.clamp((frameTime-a.time)/(nextFrame.time-a.time),0,1)
        if a.style=='Constant' or a.style=='ConstantV2' then alpha=0
        elseif a.style~='Linear' then
         local yes,value=pcall(function()return game:GetService('TweenService'):GetValue(alpha,Enum.EasingStyle[a.style],Enum.EasingDirection[a.direction]) end)
         if yes then alpha=value end
        end
        cf=a.cf:Lerp(nextFrame.cf,alpha)
       end
      end
      if cf and (not b.body or not moving) and not (name=='Eden' and b.edenChannel and self.EdenNativePlayback) then
       local value=b.prefix*cf*b.suffix
       if name=='Eden' and b.edenChannel and b.blendFrom then value=b.blendFrom:Lerp(value,math.clamp((os.clock()-self._EdenPoseStart)/.1,0,1))end
       b.joint.Transform=value
      end
     end
    end)
    table.insert(self.Connections,connection)
   end
   if options.RecordedMotion==true then
    local ok,motion=pcall(load,base,name,'_motion')
    if ok then
     local start=os.clock();local index=1;local lastLoop=-1
     local c=RunService.PreSimulation:Connect(function()
      if not self.Alive then return end
      local elapsed=os.clock()-start;local loop=math.floor(elapsed/motion.duration);local time=elapsed%motion.duration
      if loop~=lastLoop then index=1;lastLoop=loop end
      while motion.frames[index] and motion.frames[index].time<=time do
       for key,components in pairs(motion.frames[index].values) do
        local channel=motion.channels[tonumber(key)];local obj=objects[channel.node]
        if obj and not existing[channel.node] then
         local cf=CFrame.new(table.unpack(components))
         if channel.relativeToRoot then local hrp=self.Root:FindFirstChild('HumanoidRootPart');if hrp then cf=hrp.CFrame*cf end end
         pcall(function()obj[channel.property]=cf end)
        end
       end
       index+=1
      end
     end)
     table.insert(self.Connections,c)
    else errorItem(0,'RecordedMotion',motion) end
   end
   for id,obj in pairs(objects) do if obj:IsA('Sound') and not existing[id] then pcall(function()if obj.SoundId~='' and (obj.Name=='BGM' or table.find(data.nodes[id].tags or {},'AuraBGM')) then obj:Play() end end) end end
   return self
  end
  function handle:RunEffectScripts()
   if not self.Alive or self.EffectsStarted then return self end;self.EffectsStarted=true
   -- Opt-in: execute only scripts nested under the captured aura body parts.
   local realGame=game
   local taskProxy=setmetatable({}, {__index=task})
   for _,method in ipairs({'spawn','defer','delay'}) do
    taskProxy[method]=function(...)
     if not self.Alive then return nil end
     local thread=task[method](...);table.insert(self.Threads,thread);return thread
    end
   end
   local function connect(signal,fn,once)
    local connection
    local callback=function(...)
     if not self.Alive then return end
     local ok,err=pcall(fn,...)
     if not ok then errorItem(0,'EffectCallback',err);if connection then connection:Disconnect() end end
    end
    connection=once and signal:Once(callback) or signal:Connect(callback)
    table.insert(self.Connections,connection);return connection
   end
   local rsProxy=setmetatable({}, {__index=function(_,key)
    if key=='BindToRenderStep' then return function(_,binding,priority,callback)
     self.RenderBindings[binding]=true
     RunService:BindToRenderStep(binding,priority,function(...)
      if not self.Alive then return end
      local ok,err=pcall(callback,...)
      if not ok then errorItem(0,'RenderStep:'..binding,err);RunService:UnbindFromRenderStep(binding);self.RenderBindings[binding]=nil end
     end)
    end end
    if key=='UnbindFromRenderStep' then return function(_,binding)self.RenderBindings[binding]=nil;RunService:UnbindFromRenderStep(binding)end end
    local v=RunService[key]
    if typeof(v)=='RBXScriptSignal' then return {
     Connect=function(_,fn)return connect(v,fn,false) end,
     Once=function(_,fn)return connect(v,fn,true) end,
     Wait=function()return v:Wait() end,
    } end
    if type(v)=='function' then return function(_,...)return v(RunService,...) end end
    return v
   end})
   local sourceByObject,moduleCache,loading={},{},{}
   local nativeRootId=data.edenNativeUIRoot or data.illusionaryNativeUIRoot
   for _,node in ipairs(data.nodes) do if objects[node.id] and node.source then sourceByObject[objects[node.id]]=node end end
   local managedRequire,makeEnvironment
   local function compileSource(node)
    local executable=node.source:gsub('game:GetService%("RunService"%)','__AuraRunService')
    executable=executable:gsub("game%[%s*['\"]Run Service['\"]%s*%]",'__AuraRunService')
    local parent=data.nodes[node.parent or 0]
    if name=='Oppression' and parent and parent.class=='Attachment' and parent.name=='Floor' and executable:find('workspace:Blockcast',1,true) then
     -- The captured floor script sits under the attachment; raycasts need its root part.
     local changes
     executable,changes=executable:gsub('local script_Parent = script%.Parent;','local script_Parent = script.Parent.Parent;',1)
     assert(changes==1,'Oppression floor source anchor missing')
     self.FloorScriptAdapted=true
    end
    if name=='Illusionary' and node.name=='MainScript' then
     executable=executable:gsub('coroutine%.wrap%(','__AuraWrap(')
     executable=executable:gsub('script%.AncestryChanged:Once%(','__AuraOnce(script.AncestryChanged, ')
     local anchor='Parent:WaitForChild("Humanoid"):WaitForChild("Animator"):LoadAnimation(script:WaitForChild("ObjectAnimation"))'
     local a,b=executable:find(anchor,1,true)
     assert(a,'Illusionary animation anchor missing')
     executable=executable:sub(1,a-1)..'__AuraObjectTrack()'..executable:sub(b+1)
    end
    if name=='Illusionary' and node.id==data.illusionaryFXRoot then
     local ending=assert(executable:find('FXRemote.OnClientEvent:Connect',1,true),'FX dispatcher anchor missing')
     executable=executable:sub(1,ending-1)..'return {Projectile=ProjectileBarrage,Pawn=MovePawn,Queen=MoveQueen,RookPull=RookPull,RookExplode=RookExplode}'
     executable=executable:gsub('task%.','__AuraFXTask.')
     executable=executable:gsub('Bullet:Clone%(%)','__AuraClone(Bullet)')
     executable=executable:gsub('script:WaitForChild%("([^"]+)"%):Clone%(%)','__AuraClone(script:WaitForChild("%1"))')
     executable=executable:gsub('script%.Explode:Clone%(%)','__AuraClone(script.Explode)')
     executable=executable:gsub('p19:Clone%(%)','__AuraClone(p19)')
     executable=executable:gsub('child:Clone%(%)','__AuraClone(child)')
    end
    if name=='Illusionary' and node.id==data.illusionarySkillRoot then
     executable=executable:gsub('require%(Modules:WaitForChild%("CameraShaker"%)%)','__AuraCameraShaker')
     executable=executable:gsub('script:WaitForChild%("ScreenFX"%):Clone%(%)','__AuraClone(script:WaitForChild("ScreenFX"))')
    end
    if name=='Eden' or name=='Illusionary' then
     if node.id==nativeRootId then
      executable=executable:gsub('Class%(script:WaitForChild%("Item"%)%)','Class(__AuraNativeSkillItem)')
      executable=executable:gsub('return v1;','v1._AuraRoot=u7;v1._AuraItems=u2;return v1;')
     elseif parent and parent.id==nativeRootId then
      executable=executable:gsub('ContextActionService:GetButton%(u28.SkillName%)','__AuraTouchButton(u28.KeyCode)')
      executable=executable:gsub('Class%(Components:WaitForChild%("Corner"%)%)','Class(__AuraNativeCorner)')
      executable=executable:gsub('Class%(Components:WaitForChild%("Shadow"%)%)','Class(__AuraNativeShadow)')
     end
     if node.name=='Dynamics' then
      executable=executable:gsub('p3: function%?','p3')
     elseif node.name=='Floating' then
      executable=executable:gsub('u3:destroy%(%)%s*;','')
     elseif node.name=='System' then
      executable=executable:gsub('ResetCombo:FireServer%(%)','Stack:SetAttribute("Combo", 0)')
      executable=executable:gsub('Stack%.Changed:Connect%(','__AuraConnect(Stack.Changed, ')
      executable=executable:gsub('Stack%.AttributeChanged:Connect%(','__AuraConnect(Stack.AttributeChanged, ')
      executable=executable:gsub('script%.AncestryChanged:Once%(','__AuraOnce(script.AncestryChanged, ')
     elseif node.name=='Client' then
      executable=executable:gsub('ChatRemote%.OnClientEvent:Connect%(','__AuraChatConnect(')
      executable=executable:gsub('coroutine%.wrap%(','__AuraWrap(')
      executable=executable:gsub('p1:Clone%(%)','__AuraClone(p1)')
      executable=executable:gsub('LetterContainer:Clone%(%)','__AuraClone(LetterContainer)')
      executable=executable:gsub('HolderFrame:Clone%(%)','__AuraClone(HolderFrame)')
      executable=executable:gsub('local u12 = (.-):Clone%(%)','local u12 = __AuraClone(%1)')
     end
    end
    return loadstring(executable,'AuraExchange/'..name..'/'..node.id)
   end
   makeEnvironment=function(obj)
    local fxTaskProxy={wait=task.wait}
    for _,method in ipairs({'spawn','defer','delay'})do
     fxTaskProxy[method]=function(...)
      local args=table.pack(...);local delay=method=='delay'and args[1]or nil
      local fn=args[delay and 2 or 1];local first=delay and 3 or 2
      local runner=function()
       if not self.Alive then return end
       local ok,err=pcall(fn,table.unpack(args,first,args.n))
       if not ok and self.Alive then errorItem(0,'IllusionaryFXTask',err)end
      end
      local thread=delay and task.delay(delay,runner)or task[method](runner)
      table.insert(self.Threads,thread)
      if self.IllusionaryFXThreads then table.insert(self.IllusionaryFXThreads,thread)end
      return thread
     end
    end
    return setmetatable({script=obj,game=realGame,task=taskProxy,wait=task.wait,spawn=taskProxy.spawn,delay=taskProxy.delay,require=managedRequire,__AuraRunService=rsProxy,__AuraFXTask=fxTaskProxy,
     __AuraObjectTrack=function()
      for index,t in ipairs(data.tracks or {})do if t.id:match('%d+')=='135387970626232'then
       local deadline=os.clock()+10
       while self.Alive and not(self.Tracks and self.Tracks[index])and os.clock()<deadline do task.wait()end
       return assert(self.Tracks and self.Tracks[index],'Illusionary object track missing')
      end end
      error('Illusionary object track was not captured')
     end,
     __AuraTouchButton=function(key)
      local cas=game:GetService('ContextActionService');local action='AuraExchange_'..(name=='Illusionary'and 'Illusionary'or 'Eden')..'_'..key.Name
      local button=cas:GetButton(action);local deadline=os.clock()+3
      while self.Alive and not button and os.clock()<deadline do task.wait();button=cas:GetButton(action)end
      return assert(button,'Touch skill button missing: '..action)
     end,
     __AuraCameraShaker={new=function(...)
      local shaker=require(game.ReplicatedStorage.Modules.CameraShaker).new(...)
      self.RenderBindings[shaker._renderName]=true
      table.insert(self.Cleanups,function()shaker:Stop()end)
      return shaker
     end},
     __AuraConnect=function(signal,fn)return connect(signal,fn,false)end,
     __AuraOnce=function(signal,fn)return connect(signal,fn,true)end,
     __AuraWrap=function(fn)return function(...)return taskProxy.spawn(fn,...)end end,
     __AuraClone=function(source)local clone=source:Clone();table.insert(self.Created,clone);if obj==objects[data.illusionaryFXRoot]and self.IllusionaryFXObjects then table.insert(self.IllusionaryFXObjects,clone)end;return clone end,
     __AuraChatConnect=function(fn)
      self.SayEden=function(_,text,monster)
       if not self.Alive then return end
       local thread=task.spawn(fn,tostring(text),monster==true);table.insert(self.Threads,thread)
      end
     end,
    },{__index=getfenv()})
   end
   managedRequire=function(obj)
    local node=sourceByObject[obj]
    if not node or node.class~='ModuleScript' then return require(obj) end
    if moduleCache[obj]~=nil then return moduleCache[obj] end
    assert(not loading[obj],'circular captured module: '..obj.Name);loading[obj]=true
    local fn,err=compileSource(node);assert(fn,err)
    local env=makeEnvironment(obj)
    if node.parent==nativeRootId then
     env.__AuraNativeCorner=require(game.ReplicatedStorage.Modules.UI.Components.Corner)
     env.__AuraNativeShadow=require(game.ReplicatedStorage.Modules.UI.Components.Shadow)
    end
    if node.id==nativeRootId then env.__AuraNativeSkillItem=managedRequire(obj:FindFirstChild('Item'))end
    setfenv(fn,env)
    local result=fn();assert(result~=nil,'captured module returned nil: '..obj.Name)
    moduleCache[obj]=result;loading[obj]=nil;return result
   end
   if name=='Tomorrow.' then
    if self.PortalRoot and self.PortalGui then
     local ok,err=pcall(function()
      local boot=self.PortalRoot:FindFirstChild('ClientBoot')
      local controllerModule=boot and boot:FindFirstChild('Portal') and boot.Portal:FindFirstChild('Controller')
      assert(controllerModule,'portal controller missing')
      local controller=managedRequire(controllerModule).new(self.PortalRoot)
      table.insert(self.Cleanups,function()controller:Destroy()end)
      self.PortalController=controller;controller:Start()
     end)
     if not ok then errorItem(0,'Portal',err) end
    end
    for _,node in ipairs(data.nodes) do
     local obj=objects[node.id]
     if obj and node.class=='ModuleScript' and node.name=='LensFlare' then
      local ok,err=pcall(function()
       local flareModule=managedRequire(obj)
       local auraPart=obj.Parent.Parent.Parent
       for _,part in ipairs(auraPart.Parent:GetDescendants()) do
        if (part:IsA('BasePart') or part:IsA('Attachment')) and game:GetService('CollectionService'):HasTag(part,'LensFlare') then
         local flare=flareModule.new(workspace.CurrentCamera,part:GetAttribute('LensFlareStyle') or 'SmallLight',part)
         table.insert(self.Cleanups,function()if getmetatable(flare) then flare:Destroy()end end)
         self.FlareCount=(self.FlareCount or 0)+1
        end
       end
      end)
      if not ok then errorItem(node.id,'LensFlare',err) end
     end
    end
   end
   for _,n in ipairs(data.nodes) do
    local parent=data.nodes[n.parent or 0];local obj=objects[n.id]
    local managedTomorrow=name=='Tomorrow.' and (n.name=='ClientBoot' or n.name=='InitLensFlare' or data.dependencyNodes[tostring(n.id)])
    local managedEden=name=='Eden' and (n.name=='AnimationPlayer' or data.dependencyNodes[tostring(n.id)])
    local managedIllusionary=name=='Illusionary' and data.dependencyNodes[tostring(n.id)]
    if obj and obj:IsA('BaseScript') and not managedTomorrow and not managedEden and not managedIllusionary and n.source and #n.source>30 and parent and parent.id~=1 and parent.class~='LocalScript' and n.name~='Animator' then
     local fn,err=compileSource(n)
     if fn then
      setfenv(fn,makeEnvironment(obj))
      table.insert(self.Threads,task.spawn(function()local ok,e=pcall(fn);if not ok then errorItem(n.id,'EffectScript',e) end end))
     else errorItem(n.id,'EffectCompile',err) end
    end
   end
   if name=='Illusionary' and target==game.Players.LocalPlayer.Character then
    local skills=managedRequire(objects[data.illusionarySkillRoot])
    local ui=managedRequire(objects[data.illusionaryNativeUIRoot])
    IllusionaryController.install(self,skills,ui,managedRequire(objects[data.illusionaryFXRoot]))
   end
   if name=='Eden' then
    local ui=objects[205]
    if ui then ui:SetAttribute('AuraExchangeUI',true);self.EdenUI=ui end
    function self:SetEdenStack(value,combo)
     if not self.Alive then return end
     local stack=objects[246];stack.Value=math.clamp(tonumber(value)or 0,0,100)
     if combo~=nil then stack:SetAttribute('Combo',math.max(0,tonumber(combo)or 0))end
    end
    if data.edenSkillRoot then
     local nativeUI=target==game.Players.LocalPlayer.Character and data.edenNativeUIRoot and managedRequire(objects[data.edenNativeUIRoot])or nil
     EdenController.install(self,options,nativeUI)
    end
   end
   return self
  end
  if not target then
   local hrp=handle.Root and handle.Root:FindFirstChild('HumanoidRootPart');if hrp then hrp.Anchored=true end
   if options.Parent then handle.Root.Parent=options.Parent end
  end
  if options.AutoPlay then handle:Play() end
  if options.EffectScripts then handle:RunEffectScripts() end
  return handle
 end
 function api:Preview(name,options) return build(name=='Tomorrow' and 'Tomorrow.' or name,nil,options) end
 function api:Exchange(name,character,options)
  if name=='Tomorrow' then name='Tomorrow.' end
  character=character or game:GetService('Players').LocalPlayer.Character
  assert(character,'character missing')
  assert(character:FindFirstChild('Torso'),'captured models require an R6 character')
  assert(table.find(Module.Names,name),'unknown aura: '..tostring(name))
  self._request+=1;local request=self._request
  if self.Active then self.Active:Stop() end
  if self.Pending then self.Pending:Stop() end
  local slot=ownership[character] or {serial=0};ownership[character]=slot
  slot.serial+=1;local serial=slot.serial
  if slot.handle then slot.handle:Stop() end
  if slot.pending then slot.pending:Stop() end
  local settings=table.clone(options or {});local building
  settings._IsCurrent=function()return self._request==request and slot.serial==serial and character.Parent~=nil end
  settings._OnHandle=function(h)building=h;self.Pending=h;slot.pending=h end
  local ok,nextHandle=xpcall(function()return build(name,character,settings)end,debug.traceback)
  if not ok then if building then building:Stop() end;error(nextHandle,0) end
  if not nextHandle or not settings._IsCurrent() then if nextHandle then nextHandle:Stop() end;return nil,'superseded' end
  self.Pending=nil;slot.pending=nil;self.Active=nextHandle;slot.handle=nextHandle
  local played,err=xpcall(function()nextHandle:Play()end,debug.traceback)
  if not played then nextHandle:Stop();error(err,0) end
  if not settings._IsCurrent() then nextHandle:Stop();return nil,'superseded' end
  return nextHandle
 end
 function api:Clear()
  self._request+=1
  if self.Pending then self.Pending:Stop() end
  if self.Active then self.Active:Stop() end
 end
 return api
end
return Module

end)()
-- Fetch first; a failed initial download leaves the previous running manager intact.
ensureBundle('Illusionary')
if type(env.exchang_aura)=='function'then pcall(env.exchang_aura,'None')end
if env.AuraExchangeManager then pcall(function()env.AuraExchangeManager:Clear()end)end
local manager=Module.new('remote',readData)
env.AuraExchangeManager=manager
env.AuraExchangeReleaseStats=stats
env.ExchangeAuraNames={'None','ASTRAIOS','Monarch','LEVIATHAN','Tomorrow.','Oppression','Lamenthyr','Eden','Illusionary'}
local requestSerial=0
env.exchang_aura=function(name)
 requestSerial+=1;local serial=requestSerial
 if not name or name=='None'then manager:Clear();return end
 if name=='Tomorrow'then name='Tomorrow.'end
 assert(table.find(env.ExchangeAuraNames,name),'Unknown aura: '..tostring(name))
 ensureBundle(name=='Tomorrow.'and 'Tomorrow'or name)
 if serial~=requestSerial then return nil,'superseded'end
 return manager:Exchange(name,game.Players.LocalPlayer.Character,{Animations=true,BodyPose=true,EffectScripts=true,RecordedMotion=false})
end
env.exchang_eden_skill=function(name,settings)
 local h=manager.Active
 if not h or h.Name~='Eden'then return false,'Eden is not active'end
 return h:CastEdenSkill(name,settings)
end
env.exchang_illusionary_skill=function(name,settings)
 local h=manager.Active
 if not h or h.Name~='Illusionary'then return false,'Illusionary is not active'end
 return h:CastIllusionarySkill(name,settings)
end
env.exchang_aura('Illusionary')
return manager
-- AURA_EXCHANGE_COMPLETE_ill_fx1
