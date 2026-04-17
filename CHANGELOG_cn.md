# 更新日志

本项目的所有重要更改都将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)，
本项目遵循 [语义化版本](https://semver.org/spec/v2.0.0.html)。

## [0.0.2] - 2026-04-17

### 新增
- LiteFlows 框架首次发布
- **依赖注入** 系统，支持 `Flow.put`、`Flow.find`、`Flow.isRegistered` 和 `Flow.remove`
- **响应式状态管理**，支持 Rx 类型：
  - `Rx<T>`、`Rxn<T>` 通用响应式包装器
  - `RxBool`、`RxInt`、`RxDouble`、`RxString` 原始类型
  - `RxList<T>`、`RxMap<K,V>`、`RxSet<T>` 集合类型
  - `.obs` 扩展用于轻松创建响应式类型
- **路由管理**，支持 `Flow.to`、`Flow.toNamed`、`Flow.back`、`Flow.off`、`Flow.offAll`
- **FlowMaterialApp** 小组件，支持应用配置和主题
- **FlowPage** 用于命名路由定义
- **FlowController** 基类，提供生命周期方法（`onInit`、`onClose`）
- **Flx** 响应式小组件构建器
- **FlxValue** 优化的单值响应式小组件
- **Logic/State/View** 架构模式支持
- 示例应用展示所有功能：
  - 带响应式状态的计数器页面
  - 带 UserData 编辑的主页面
  - 带路由参数接收的详情页面
  - 性能测试页面
  - 浅色/深色主题切换
  - 自定义应用图标配置
- 全面的文档：
  - README.md（英文）
  - README_cn.md（中文）
  - CHANGELOG.md
  - CHANGELOG_cn.md

### 更改
- 优化路由参数传递，保留 `settings.arguments`
- 更新默认主题颜色为青蓝色（0xFF26C6DA）以保持品牌一致性
- 改进 AppBar 颜色，使用更深的色调以获得更好的对比度
- 增强示例应用，支持可编辑的 UserData 模型
- 基于 GetX 的灵感优化 API 设计，语法更简洁

### 修复
- 使用 `FlowMaterialApp` 时路由参数无法正确传递的问题
- 主题切换在 UI 中不生效的问题
- 示例页面中的 RenderFlex 溢出问题
- 可空 UserData 参数的类型转换问题

### 性能
- 单层观察设计，实现最优性能
- 零模板代码 - 不需要 StreamControllers、ChangeNotifiers 或 InheritedWidgets
- 使用 FlxValue 进行单值观察，高效的小组件重建

## [未发布]

### 计划
- 更多 Rx 运算符和工具函数
- 路由导航中间件支持
- 增强的 DevTools 集成
- 更全面的测试覆盖
- 更多示例模板

---

**致谢：**

本项目受到 [GetX](https://pub.dev/packages/get) 出色工作的启发。
我们感谢 Jonny Borges 和 GetX 社区在 Flutter 响应式状态管理和依赖注入方面的开创性工作。
