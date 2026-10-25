# Aura Exchange - Illusionary and movement repair

版本：2026-10-25-ill-walk1。八种光环按需下载，默认 Illusionary。

~~~lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/iwsksownw666/aura-exchange/main/loader.luau?release=ill-walk1"))()
~~~

~~~lua
getgenv().exchang_aura('Illusionary')
getgenv().exchang_illusionary_skill('F')
getgenv().exchang_aura('Eden')
getgenv().exchang_aura('None')
~~~

支持 ASTRAIOS、Monarch、LEVIATHAN、Tomorrow.、Oppression、Lamenthyr、Eden、Illusionary。默认移动时持续播放光环动作，不再主动切换普通走路；Eden 继续使用已保存的专用走路动作。其他光环持续使用其保存的光环姿势/动作，不宣称存在未取得的专用走路资源。模块选项 PreserveLocomotion=true 可恢复旧的让出移动动画行为。Eden 手机按钮未修改。

Illusionary 来源：Spike1145141919810；1108 个角色对象、两份动画、10 秒动态记录、效果脚本与依赖均已保存。31 个标题文字使用保存的原内容、字体、尺寸和 OriginalPosition；修复抓到闪烁中途造成的字母隐藏、临时字位被作为原始字位的问题，动态仍由原 MainScript 执行。随机闪烁的瞬时结果不会与另一个角色同步。人物原动画 109536481760521，物体原动画 135387970626232。

四技能使用原 AuraSkillClient 的 Activate/Cancel 回调和原生 SkillUI：F - you belong here.；E - wake up.；R - no, not yet.；V - you are a puppet.。原客户端回调提供闪屏、震动和对应时间序列。技能栏冷却是本地回放防重叠时长。未取得的服务端召唤物、技能独立动画/粒子调度、伤害、状态绑定与原版冷却不在本版覆盖范围内；不声称技能完整一比一。按用户要求先修已取得内容。

Eden 六技能与此前一样，Q/E/F/V/R/T。Eden 音效为游戏通用资源，专用原声未确认。

发布入口约 70 KB；默认 Illusionary 资源约 4.21 MB。38 项内嵌资源均无损提取，manifest.json 记录逐项比对与 SHA256。读取固定版本 GitHub 或 jsDelivr，校验完整长度和 JSON。更换光环时按需下载、本次执行期间缓存；需要 R6 与 executor 的 writefile/getcustomasset 等缓存接口。

验证：illusionary_walk_validation.json 包含八光环实际移动、31 文字对象比对、四技能客户端回调、取消与切换清理。原装备者离服后的文字比对使用提前保留的原快照。compile_validation.json 仅代表语法编译。手机实机及 Studio 导入未验证。
