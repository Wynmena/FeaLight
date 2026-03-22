# FeaLight开发文档

## 项目简介
这是一个基于 Godot 4.6 开发的 2D RPG 游戏项目。目前项目处于早期开发阶段，已完成核心框架搭建、地图切换、物品清单及存档界面等基础功能。

## 当前开发进度

### 1. 核心系统 (Core Systems)
- **管理器架构**: 实现了 `Manager` (Autoload) 作为全局访问点，集成 `GameManager` (游戏流程控制) 和 data manager (数据管理)。
- **地图系统**: 支持多地图切换功能 (`change_map`)，包含传送点 (`TeleportationPoint`) 逻辑。目前已有 `map_forest_1` 和 `map_forest_2` 两个测试场景。
- **寻路辅助**: `PathUtil` 工具类用于处理路径相关逻辑。

### 2. 玩法机制 (Gameplay)
- **角色控制**: 基础的角色移动控制 (WASD)。
- **交互系统**: 基于 `Area2D` 的交互对象基类 `InteractiveObject`，支持玩家进入/离开区域触发反应。
  - 已实现交互对象: 公告板 (`NoticeBoard`)、传送点。
- **摄像机**: 自定义摄像机 `MyCamera` 跟随逻辑。

### 3. 用户界面 (UI)
- **物品栏 (Inventory)**: 
  - 网格化显示物品 (`GridContainer`)。
  - 动态响应窗口大小调整布局。
  - 物品详情展示（图标、名称、描述）。
  - 数据来源：JSON (`items.json`)。
- **存档界面 (Saves)**:
  - 滚动列表显示存档槽位。
  - 读取测试存档数据 (`saves_test.json`)。
  - 支持动态添加存档槽组件 (`SaveSlot`)。
- **系统菜单**: 包含系统设置页 (`SystemPage`) 和主菜单框架。
- **主题管理**: 统一的 UI 主题样式控制 (`Theme.gd`)。

### 4. 数据管理 (Data)
- **JSON 数据驱动**: 使用 JSON 文件存储物品数据 (`items.json`) 和存档数据 (`saves_test.json`)。
- **资源管理**: 简单的资源加载机制。

## 项目结构说明

```
FeaLight_v0/
├── art/                    # 美术资源与数据文件
│   ├── data/               # JSON 数据配置 (items.json, saves, etc.)
│   └── img/                # 图片素材 (UI, character, tile_map)
├── resources/              # Godot 资源文件 (TileSets 等)
├── script/                 # GDScript 脚本代码
│   ├── main_game.gd        # 游戏主入口逻辑
│   ├── Manager/            # 全局管理器 (GameManager, BugManager 等)
│   ├── UI/                 # 界面逻辑 (Inventory, Saves, Pages)
│   ├── character/          # 角色控制脚本
│   ├── interactive_object/ # 交互物体脚本
│   └── ...
├── tscn/                   # 场景文件 (.tscn)
│   ├── map/                # 游戏地图场景
│   ├── UI/                 # 界面预制体
│   └── ...
└── project.godot           # 项目配置文件
```

## 技术栈
- **引擎版本**: Godot 4.6 (Forward Plus)
- **语言**: GDScript
- **渲染**: 2D TileMap

## 下一步计划
- [ ] 完善物品使用与交互逻辑。
- [ ] 实现真实的存档读写功能（目前为读取测试数据）。
- [ ] 丰富地图内容与美术资源。
- [ ] 完善角色动画与状态机。

