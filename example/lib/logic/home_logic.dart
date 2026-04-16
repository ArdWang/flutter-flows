/// Home Logic - Business logic for home page
///
/// This demonstrates the Logic/State/View separation pattern
library;

import 'package:flutter_flows/flows.dart';
import '../state/home_state.dart';

class HomeLogic extends FlowController {
  final state = HomeState();

  @override
  void onInit() {
    super.onInit();
    state.init();
  }

  void incrementCount() {
    state.count.value++;
  }

  void decrementCount() {
    state.count.value--;
  }

  void resetCount() {
    state.count.value = 0;
  }

  void toggleTheme() {
    state.isDarkMode.value = !state.isDarkMode.value;
  }

  void addNewName(String newName) {
    state.name.value = newName;
  }

  void addItem(String item) {
    state.items.add(item);
  }

  void removeItem(int index) {
    state.items.removeAt(index);
  }

  void navigateToCounter() {
    Flow.toNamed('/counter');
  }

  void navigateToDetail() {
    Flow.toNamed('/detail', arguments: {'name': state.name.value});
  }
}
