/// Home State - State for home page
///
/// This demonstrates the Logic/State/View separation pattern
library;

import 'package:flutter_flows/flows.dart';

/// User data model for testing object passing and editing
class UserData {
  final String name;
  final int age;
  final String email;

  const UserData({
    required this.name,
    required this.age,
    required this.email,
  });

  UserData copyWith({String? name, int? age, String? email}) {
    return UserData(
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
    );
  }

  @override
  String toString() => 'UserData(name: $name, age: $age, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserData &&
        other.name == name &&
        other.age == age &&
        other.email == email;
  }

  @override
  int get hashCode => Object.hash(name, age, email);
}

class HomeState {
  // Reactive variables
  final name = 'Flows'.obs;
  final count = 0.obs;
  final isDarkMode = false.obs;

  // Reactive list
  final items = RxList<String>(['Item 1', 'Item 2', 'Item 3']);

  // User data - reactive object for editing
  final userData = Rxn<UserData>(null);

  void init() {
    // Initialize state
    userData.value = const UserData(
      name: 'Flows User',
      age: 25,
      email: 'user@flows.dev',
    );
  }
}
