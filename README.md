# Aura Exchange

七种光环的本地视觉回放。默认 Eden，资源按光环下载，本次执行期间复用缓存。

执行：

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/iwsksownw666/aura-exchange/main/loader.luau?release=eden4"))()
```

切换：

```lua
getgenv().exchang_aura('Monarch')
getgenv().exchang_aura('Eden')
getgenv().exchang_aura('None')
```

支持 ASTRAIOS、Monarch、LEVIATHAN、Tomorrow.、Oppression、Lamenthyr、Eden。Eden 技能按 Q / E / F / V / R / T；使用游戏原生技能栏、Eden 原动作、游戏通用音效和镜头反馈。技能为本地美化回放，Eden 专用原声未确认。

入口 61.2 KiB，首次 Eden 资源 4.10 MiB；其余光环首次选中时下载。34 项原内嵌资源均保留，逐项无损比对见 manifest.json。录制运动数据仅在显式开启 RecordedMotion 时下载。下载验证字节长度与 JSON 结构，GitHub 下载失败时尝试 jsDelivr。资源仍依赖 Roblox 资产 ID，模型需要 R6 与 executor 文件缓存接口。

入口通过短引导文件校验完整长度，再从固定版本 CDN/GitHub 获取运行代码。

发布文件：main.luau、loader.luau、versions/eden4/；上传时保留目录。更换托管地址时，在执行入口前设置 getgenv().AuraExchangeAssetBaseURL（指向 versions/eden4）。源版本 2026-10-25-eden4。
