# Flows Example - Performance Optimizations

## 对象编辑功能

### UserData 模型

```dart
class UserData {
  final String name;
  final int age;
  final String email;

  const UserData({required this.name, required this.age, required this.email});

  UserData copyWith({String? name, int? age, String? email}) {
    return UserData(
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object other) => ... // 支持值比较

  @override
  int get hashCode => Object.hash(name, age, email);
}
```

### 编辑功能

**Controller 层：**
```dart
class DetailController extends FlowController {
  // 响应式存储 - UI 自动重建
  final _userData = Rxn<UserData>(null);

  ValueListenable<UserData?> get userDataListenable => _userData;

  // 更新方法
  void updateUserName(String newName) {
    final current = _userData.value;
    if (current == null) return;
    _userData.value = current.copyWith(name: newName);
  }

  void updateUserData({String? name, int? age, String? email}) {
    final current = _userData.value;
    if (current == null) return;
    _userData.value = current.copyWith(name: name, age: age, email: email);
  }
}
```

**View 层：**
```dart
// 使用 FlxValue 监听变化 - 只有相关 widget 重建
FlxValue<UserData?>(
  controller.userDataListenable,
  (userData) => userData != null
      ? Text('Name: ${userData.name}')
      : const SizedBox(),
)
```

---

## 参数传递的两种方式

### 方式 1: View 层接收参数（推荐用于简单显示）

```dart
@override
Widget build(BuildContext context) {
  // 直接从路由设置获取参数
  final args = ModalRoute.of(context)?.settings.arguments;
  final name = args is Map ? args['name'] as String? : null;
  
  // 直接用于 UI 显示
  return Text('Hello, $name!');
}
```

**优点：**
- 最快，无额外状态管理开销
- 代码简洁
- 适合一次性使用的参数

**性能特点：**
- ✅ 无额外内存占用
- ✅ 无额外方法调用
- ⚠️ 参数绑定在 UI 层

---

### 方式 2: Logic 层接收参数（推荐用于业务逻辑）

```dart
// View 层
@override
Widget build(BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  final name = args is Map ? args['name'] as String? : null;
  
  // 传递给 controller
  controller.initName(name ?? 'Guest');
  
  // 使用 controller 的数据
  return Text('Hello, ${controller.guestName}!');
}

// Logic 层
class DetailController extends FlowController {
  String _cachedName = 'Guest';
  
  void initName(String name) {
    if (_cachedName == name) return; // 性能优化：跳过不变的值
    _cachedName = name;
  }
  
  String get guestName => _cachedName;
}
```

**优点：**
- 业务逻辑与 UI 分离
- 便于单元测试
- 可在多个方法间共享参数

**性能特点：**
- ✅ 数据缓存，避免重复解析
- ✅ 可在 controller 生命周期内复用
- ⚠️ 少量额外内存占用

---

## 性能优化技术

### 1. 值变化检测

```dart
void initName(String name) {
  if (_cachedName == name) return; // 跳过不变的值
  _cachedName = name;
}
```

### 2. 使用非响应式缓存存储静态数据

```dart
// ❌ 不必要的响应式开销
final guestName = ''.obs;

// ✅ 静态数据使用普通变量
String _cachedName = 'Guest';
String get guestName => _cachedName;
```

### 3. 避免在 build 中创建对象

```dart
// ❌ 每次 build 都创建新对象
Widget build(context) {
  final data = UserData(name: 'test'); // 性能浪费！
  return Text(data.name);
}

// ✅ 使用常量或缓存
const _defaultData = UserData(name: 'test');
Widget build(context) {
  return Text(_defaultData.name);
}
```

### 4. 使用 FlxValue 替代 Flx 用于单个值监听

```dart
// ✅ FlxValue - 更高效，直接监听 ValueListenable
FlxValue<String>(controller.selectedItem, (value) => Text(value))

// ⚠️ Flx - 需要额外的追踪开销
Flx(() => Text(controller.selectedItem.value))
```

---

## 对象传递测试

```dart
// 发送方
final userData = UserData(
  name: logic.state.name.value,
  age: 25,
  email: 'user@example.com',
);
Flow.toNamed('/detail', arguments: {'userData': userData});

// 接收方 (View 层)
final args = ModalRoute.of(context)?.settings.arguments;
final userData = args is Map ? args['userData'] as UserData? : null;

// 接收方 (Logic 层)
void initUserData(UserData data) {
  _cachedUserData = data;
}
```

---

## 基准测试建议

使用 Flutter DevTools 进行性能分析：

1. 打开 Flutter DevTools
2. 进入 Performance 标签
3. 点击按钮导航到 Detail 页面
4. 查看：
   - Build 时间
   - 内存分配
   - 帧率

**预期结果：**
- Detail 页面 build 时间 < 16ms (60fps)
- 无明显内存峰值
