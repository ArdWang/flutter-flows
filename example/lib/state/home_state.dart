/// Home State - State for home page
///
/// This demonstrates the Logic/State/View separation pattern
library;

import 'package:flutter_flows/flows.dart';

class HomeState {
  // Reactive variables
  final name = 'Flows'.obs;
  final count = 0.obs;
  final isDarkMode = false.obs;

  // Reactive list
  final items = RxList<String>(['Item 1', 'Item 2', 'Item 3']);

  // Using regular Map for simplicity
  final userData = <String, dynamic>{};

  void init() {
    // Initialize state
    userData['name'] = 'John Doe';
    userData['email'] = 'john@example.com';
    userData['age'] = 30;
  }
}
