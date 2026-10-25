-- Small bootstrap; verify full source before running it.
local urls={"https://cdn.jsdelivr.net/gh/iwsksownw666/aura-exchange@two1-publish-v1/main.luau","https://raw.githubusercontent.com/iwsksownw666/aura-exchange/two1-publish-v1/main.luau?download=1"}
local lastError
for _,url in ipairs(urls)do
 local ok,source=pcall(function()return game:HttpGet(url)end)
 if ok and type(source)=='string'and #source==76400 then
  local fn,err=loadstring(source,'AuraExchangePublic')
  if fn then getgenv().AuraExchangeLoaderInfo={url=url,bytes=#source};return fn()end
  lastError=err
 else lastError=ok and 'Incomplete script download'or source end
end
error('Aura Exchange entry download failed: '..tostring(lastError),0)
