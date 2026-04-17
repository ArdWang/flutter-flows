/// Home List View - View using Logic/State pattern
///
/// This demonstrates how to use the Logic/State pattern:
/// - Logic: Business logic and actions (extends FlowController)
/// - State: Reactive state variables (simple class)
/// - View: UI rendering (StatelessWidget)
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:liteflows/flows.dart';

import '../logic/home_logic.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Register logic if not already registered
    if (!Flow.isRegistered<HomeLogic>()) {
      Flow.put(HomeLogic());
    }
    final logic = Flow.find<HomeLogic>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flows - Logic/State Pattern'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          FlxValue<bool>(
            logic.state.isDarkMode,
            (value) => IconButton(
              icon: Icon(value ? Icons.dark_mode : Icons.light_mode),
              onPressed: logic.toggleTheme,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  color: Colors.deepPurple,
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

            ElevatedButton(
              onPressed: logic.navigateToCounter,
              child: const Text('Go to Counter Page'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: logic.navigateToDetail,
              child: const Text('Go to Detail Page'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Change Name'),
              content: TextField(
                decoration: const InputDecoration(hintText: 'Enter new name'),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    logic.addNewName(value);
                  }
                  Navigator.pop(ctx);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        tooltip: 'Change Name',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
