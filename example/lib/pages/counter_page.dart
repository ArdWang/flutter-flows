/// Counter Page - Demonstrates standalone counter with FlowController
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_flows/flows.dart';

class CounterController extends FlowController {
  final count = 0.obs;

  void increment() => count.value++;
  void decrement() => count.value--;
  void reset() => count.value = 0;
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Flow.isRegistered<CounterController>()) {
      Flow.put(CounterController());
    }
    final controller = Flow.find<CounterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.trending_up, size: 64),
            const SizedBox(height: 24),

            Flx(() => Text(
              '${controller.count.value}',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            )),

            const SizedBox(height: 48),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: controller.decrement,
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement'),
                  backgroundColor: Colors.red,
                  heroTag: 'counter_decrement',
                ),
                const SizedBox(width: 16),
                FloatingActionButton.extended(
                  onPressed: controller.increment,
                  icon: const Icon(Icons.add),
                  label: const Text('Increment'),
                  backgroundColor: Colors.green,
                  heroTag: 'counter_increment',
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: controller.reset,
              child: const Text('Reset Counter'),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Flow.back(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
