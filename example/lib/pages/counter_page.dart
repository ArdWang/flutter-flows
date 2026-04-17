/// Counter Page - Demonstrates standalone counter with FlowController
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_flows/flows.dart';

import '../utils/pretty_print.dart';

class CounterController extends FlowController {
  final count = 0.obs;

  void increment() => count.value++;
  void decrement() => count.value--;
  void reset() => count.value = 0;

  @override
  void onInit() {
    super.onInit();
    PrettyLogger.info('CounterController initialized');
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    PrettyLogger.debug('CounterPage loaded');

    if (!Flow.isRegistered<CounterController>()) {
      Flow.put(CounterController());
    }
    final controller = Flow.find<CounterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Page - Flows Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.trending_up, size: 64),
            const SizedBox(height: 24),

            Flx(() {
              final currentValue = controller.count.value;
              // Log when count changes
              if (currentValue != 0) {
                PrettyLogger.data('Count updated', currentValue);
              }
              return Text(
                '$currentValue',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),

            const SizedBox(height: 48),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    PrettyLogger.info('Counter decremented');
                    controller.decrement();
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement'),
                  backgroundColor: Colors.red,
                  heroTag: 'counter_decrement',
                ),
                const SizedBox(width: 16),
                FloatingActionButton.extended(
                  onPressed: () {
                    PrettyLogger.info('Counter incremented');
                    controller.increment();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Increment'),
                  backgroundColor: Colors.green,
                  heroTag: 'counter_increment',
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                PrettyLogger.info('Counter reset');
                controller.reset();
              },
              child: const Text('Reset Counter'),
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                PrettyLogger.info('Navigating back from Counter Page');
                Flow.back();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
