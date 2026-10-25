# Illusionary client FX - ill-fx1

新增保存原版 ReplicatedStorage.illusionary_FXModule：113 对象，包含原弹幕、棋子特效回调、粒子和音效。

~~~lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/iwsksownw666/aura-exchange/main/loader.luau?release=ill-fx1"))()
~~~

F 接入原 Bullet、BulletSound、Bezier 轨迹和爆破粒子；本地调度为施放后 2 秒开始、20 发、间隔 0.05 秒。此调度参考现有屏幕回调时间，尚未对照原装备者实测，不宣称原服务端发射时序一致。目标为鼠标指向、默认限制 200 studs；脚本可传 TargetPosition=Vector3。

E/R/V 保留现有原屏幕回调，并触发光环自带 Pawn/Queen/Rook 图标粒子。原 MovePawn/MoveQueen/RookPull/RookExplode 回调与依赖资源已保存；完整技能棋子模型目前未取得，因此本版尚未创建这些召唤物。之后由原装备者释放技能补抓，不以过场模型代替。

八光环、文字和移动修复沿用上一版。Eden 未更改。所有新增表现仅客户端播放，不发送技能远程、不产生服务端伤害。

停止、取消技能或切换光环时清理新增弹幕、音效、任务。编译及运行验证见对应 validation.json；缺少游戏内报告表示未完成本版运行验收。
