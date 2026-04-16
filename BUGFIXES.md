# Bug Fixes - Flows Framework

## 2026-04-16

### 1. Hero Tag 冲突错误

**问题描述**: 页面跳转时报错 `There are multiple heroes that share the same tag within a subtree`

**原因**: 多个页面中的 `FloatingActionButton` 使用了相同的默认 Hero tag

**解决方案**: 
- 为所有 `FloatingActionButton` 指定唯一的 `heroTag`
- `HomePage`: `heroTag: 'home_fab'`
- `CounterPage`: `heroTag: 'counter_increment'` 和 `heroTag: 'counter_decrement'`

**影响文件**:
- `example/lib/pages/home_page.dart`
- `example/lib/pages/counter_page.dart`

---

### 2. Flx 点击按钮无响应问题

**问题描述**: 点击增加/减少按钮，计数显示不更新

**原因**: `Flx` widget 无法自动追踪 `Rx` 变量的变化，缺少监听机制

**解决方案**: 
- 重新实现 `Flx` widget，使用全局 `_currentTrackingState` 追踪当前正在构建的 Flx 状态
- 在 `Rx.value` getter 中自动调用 `flxTrack()` 注册监听器
- 当 Rx 变量变化时，触发 Flx 重建

**影响文件**:
- `lib/src/state_manager/flx.dart` - 新增 `flxTrack()` 函数和全局状态
- `lib/src/rx/rx_types.dart` - 在 `Rx.value` getter 中添加追踪逻辑

**代码变更**:
```dart
// flx.dart
_FlxState? _currentTrackingState;
void flxTrack(ValueListenable<dynamic> listenable) {
  _currentTrackingState?._addListener(listenable);
}

// rx_types.dart
@override
T get value {
  flxTrack(this);  // 自动追踪
  return super.value;
}
```

---

### 3. Flow.put() 调用 onReady 方法报错

**问题描述**: 运行时报错 `Class 'HomeLogic' has no instance method 'onReady'`

**原因**: `FlowLifeCycleMixin` 中缺少 `onReady()` 方法定义，但 `Flow.put()` 中调用了它

**解决方案**: 
- 在 `FlowLifeCycleMixin` 中添加 `onReady()` 方法
- 添加 `ready()` 方法用于触发 `onReady()` 回调
- 更新 `Flow.put()` 和 `Flow.find()` 使用 `ready()` 方法

**影响文件**:
- `lib/src/core/lifecycle.dart` - 添加 `onReady()`, `ready()`, `_isReadyCalled`
- `lib/src/core/flow.dart` - 将 `(dependency as dynamic).onReady()` 改为 `dependency.ready()`

---

## 验证

所有修复已通过以下验证：
```bash
flutter analyze  # 仅 1 个 info 级别警告（deprecated withOpacity）
flutter test     # 所有测试通过
```

**测试用例**:
- ✅ Flx widget builds
- ✅ FlxValue widget builds  
- ✅ Flow dependency injection works
