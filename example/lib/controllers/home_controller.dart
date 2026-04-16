/// Home Controller - Example controller with reactive state
///
/// This demonstrates the Controller pattern usage
library;

import 'package:flutter_flows/flows.dart';

class HomeController extends FlowController {
  // Reactive variables
  final name = 'Flows'.obs;
  final count = 0.obs;
  final isDarkMode = false.obs;

  // Reactive list
  final items = RxList<String>(['Item 1', 'Item 2', 'Item 3']);

  // Using regular Map instead of RxMap for simplicity
  final userData = <String, dynamic>{};

  @override
  void onInit() {
    // Initialize user data
    userData['name'] = 'John Doe';
    userData['email'] = 'john@example.com';
    userData['age'] = 30;
    super.onInit();
  }

  void incrementCount() {
    count.value++;
  }

  void decrementCount() {
    count.value--;
  }

  void resetCount() {
    count.value = 0;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  void addNewName(String newName) {
    name.value = newName;
  }

  void addItem(String item) {
    items.add(item);
  }

  void removeItem(int index) {
    items.removeAt(index);
  }
}
