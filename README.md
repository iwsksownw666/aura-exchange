# Aura Exchange - two1

新增保存当前服务器两位其他玩家的光环，排除本地玩家 iwisjdjeeiidj。

| 玩家 | 光环 | 角色对象 | 身体动画 |
|---|---|---:|---|
| joanne_1235469 | Hellborn | 1357 | 93169902919935 |
| 91919191qqqoppoA5 | Tree House | 2386 | 85141240656023 |

~~~lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/iwsksownw666/aura-exchange/main/loader.luau?release=two1"))()
getgenv().exchang_aura('Hellborn')
getgenv().exchang_aura('Tree House')
getgenv().exchang_aura('None')
~~~

共十种光环，原八种继续保留：ASTRAIOS、Monarch、LEVIATHAN、Tomorrow.、Oppression、Lamenthyr、Eden、Illusionary。默认 Hellborn；每种首次使用时按需下载。小入口 loader.luau 校验完整主文件长度，再使用固定 tag 下载资源。完整内嵌版 exchang_aura_final.luau 可单独执行。

新增两份完整角色快照、模型/粒子/Beam/音效/脚本、身体原动画关键帧、10 秒动态记录，Master/Rune 依赖与所有外部引用已解析。原始导出及 XML 位于 other_two_auras_20261025。两个角色均没有 Union。SecurityCapabilities 为不支持的元数据类型，非视觉资源；Reset/PrimarySetter/ReplaceAccessory/ToolModes/Health 的服务器脚本为空字节码，未恢复服务端逻辑。未观测的技能表现不属于本次静态光环保存覆盖。

Hellborn 原 Moving/Rotating 脚本、Tree House 原昼夜变色/表面颜色/旋转/移动脚本接入受管理生命周期；切换后清理任务、连接和 Tween。默认移动时持续光环动画。Eden 功能沿用旧版。Illusionary 维持 ill-fx1 客户端弹幕资源、音效、Bezier 和爆破；发射时序仍是本地安排，兵/后/车技能模型待原装备者释放时补抓，不宣称完整技能复刻。

验证边界：compile_validation.json 为编译；two_runtime_validation.json 为连接客户端测试；public_runtime_validation.json 为公开入口测试。未生成的报告表示对应步骤尚未完成。手机实机及 Studio 导入未验收。
