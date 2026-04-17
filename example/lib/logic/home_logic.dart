/// Home Logic - Business logic for home page
///
/// This demonstrates the Logic/State/View separation pattern
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_flows/flows.dart';

import '../state/home_state.dart';
import '../main.dart';

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
    // Update global theme controller
    ThemeController().setThemeMode(
      state.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
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

  // ========== UserData Edit Methods ==========

  void updateUserName(String newName) {
    final current = state.userData.value;
    if (current == null) return;
    state.userData.value = current.copyWith(name: newName);
  }

  void updateUserAge(int newAge) {
    final current = state.userData.value;
    if (current == null) return;
    state.userData.value = current.copyWith(age: newAge);
  }

  void updateUserEmail(String newEmail) {
    final current = state.userData.value;
    if (current == null) return;
    state.userData.value = current.copyWith(email: newEmail);
  }

  void updateUserData({String? name, int? age, String? email}) {
    final current = state.userData.value;
    if (current == null) return;
    state.userData.value = current.copyWith(name: name, age: age, email: email);
  }

  void clearUserData() {
    state.userData.value = null;
  }

  // ==========================================

  void navigateToCounter() {
    Flow.toNamed('/counter');
  }

  void navigateToDetail() {
    Flow.toNamed('/detail', arguments: {'name': state.name.value});
  }

  void navigateToDetailWithUserData() {
    Flow.toNamed('/detail', arguments: {'userData': state.userData.value});
  }
}
