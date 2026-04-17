/// Home Page - Demonstrates basic Flows features
///
/// Shows how to pass parameters to routes:
/// 1. Simple String parameter
/// 2. Complex Object parameter (UserData) - Editable!
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:liteflows/flows.dart';

import '../logic/home_logic.dart';
import '../main.dart' show AppColors;
import '../utils/pretty_print.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Register logic if not already registered
    if (!Flow.isRegistered<HomeLogic>()) {
      Flow.put(HomeLogic());
    }
    final logic = Flow.find<HomeLogic>();

    // Print current theme state
    PrettyLogger.divider('Home Page Loaded');
    PrettyLogger.data('Current Theme', logic.state.isDarkMode.value ? 'Dark' : 'Light');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flows Example - Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          FlxValue<bool>(
            logic.state.isDarkMode,
            (value) => IconButton(
              icon: Icon(value ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                PrettyLogger.info('Theme toggled: ${value ? 'Light' : 'Dark'} mode');
                logic.toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Welcome to', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),

            FlxValue<String>(
              logic.state.name,
              (value) => Text(
                value,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            Flx(() => Text(
              'Count: ${logic.state.count.value}',
              style: const TextStyle(fontSize: 32),
            )),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: logic.decrementCount,
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 32,
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: logic.incrementCount,
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 32,
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: logic.resetCount,
                  icon: const Icon(Icons.refresh),
                  iconSize: 32,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Display UserData card - reactive to changes with edit button
            Flx(() {
              final userData = logic.state.userData.value;
              if (userData == null) return const SizedBox();
              return Card(
                color: AppColors.primary.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, size: 20),
                          const SizedBox(width: 8),
                          const Text('User Data:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          // Edit button next to UserData card
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _showEditUserDataDialog(context, logic),
                            tooltip: 'Edit User Data',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildDataRow('Name:', userData.name),
                      _buildDataRow('Age:', '${userData.age}'),
                      _buildDataRow('Email:', userData.email),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Button 1: Navigate with String parameter
            ElevatedButton(
              onPressed: () {
                final currentName = logic.state.name.value;
                PrettyLogger.info('Navigate to Detail with name: $currentName');
                Flow.toNamed(
                  '/detail',
                  arguments: {'name': currentName},
                );
              },
              child: const Text('Go to Detail (String)'),
            ),

            const SizedBox(height: 8),

            // Button 2: Navigate with UserData object parameter
            ElevatedButton(
              onPressed: () {
                final userData = logic.state.userData.value;
                PrettyLogger.info('Navigate to Detail with UserData: $userData');
                Flow.toNamed(
                  '/detail',
                  arguments: {'userData': userData},
                );
              },
              child: const Text('Go to Detail (Object)'),
            ),

            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Flow.toNamed('/counter'),
              child: const Text('Go to Counter Page'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Flow.toNamed('/perf-test'),
              child: const Text('Performance Test'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final controller = TextEditingController();
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Change Name'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Enter new name'),
                autofocus: true,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newName = controller.text.trim();
                    if (newName.isNotEmpty) {
                      PrettyLogger.info('Name changed to: $newName');
                      logic.addNewName(newName);
                      PrettyLogger.data('New name displayed', logic.state.name.value);
                    }
                    Navigator.pop(ctx);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        heroTag: 'home_fab',
        tooltip: 'Change Name',
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showEditUserDataDialog(BuildContext context, HomeLogic logic) {
    final currentData = logic.state.userData.value;
    if (currentData == null) return;

    final nameController = TextEditingController(text: currentData.name);
    final ageController = TextEditingController(text: currentData.age.toString());
    final emailController = TextEditingController(text: currentData.email);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit User Data'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameController.text.trim();
              final newAge = int.tryParse(ageController.text.trim());
              final newEmail = emailController.text.trim();

              if (newName.isEmpty || newAge == null || newEmail.isEmpty) {
                PrettyLogger.warning('Please fill all fields correctly');
                return;
              }

              logic.updateUserData(
                name: newName,
                age: newAge,
                email: newEmail,
              );

              PrettyLogger.success('UserData updated successfully');
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
