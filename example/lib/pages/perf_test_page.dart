/// Performance Test Page - Demonstrates reactive performance
///
/// This page shows the performance of Flx reactive system
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:liteflows/flows.dart';

import '../utils/pretty_print.dart';

class PerfTestController extends FlowController {
  // Reactive counter - for demonstrating Flx performance
  final counter = 0.obs;

  // Reactive text - for demonstrating text update performance
  final logText = RxList<String>([]);

  void increment() {
    counter.value++;
    _addLog('Counter incremented to $counter');
  }

  void decrement() {
    counter.value--;
    _addLog('Counter decremented to $counter');
  }

  void reset() {
    counter.value = 0;
    logText.clear();
    _addLog('Counter reset');
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    logText.add('[$timestamp] $message');
    // Keep only last 20 logs for memory efficiency
    while (logText.length > 20) {
      logText.removeAt(0);
    }
  }

  @override
  void onInit() {
    super.onInit();
    PrettyLogger.info('PerfTestController initialized');
  }
}

class PerfTestPage extends StatelessWidget {
  const PerfTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Flow.isRegistered<PerfTestController>()) {
      Flow.put(PerfTestController());
    }
    final controller = Flow.find<PerfTestController>();

    PrettyLogger.debug('PerfTestPage loaded');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Counter display - Uses Flx for targeted rebuild
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tap buttons to test reactive performance',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),

          // Counter value - Only this widget rebuilds, not the entire page
          Flx(() => Text(
            '${controller.counter.value}',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          )),

          const SizedBox(height: 24),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: controller.decrement,
                heroTag: 'decrement',
                child: const Icon(Icons.remove),
              ),
              const SizedBox(width: 16),
              FloatingActionButton(
                onPressed: controller.increment,
                heroTag: 'increment',
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 16),
              FloatingActionButton(
                onPressed: controller.reset,
                heroTag: 'reset',
                backgroundColor: Colors.red,
                child: const Icon(Icons.refresh),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Activity Log (last 20 entries):', style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          // Log display - Uses FlxValue for efficient list updates
          Expanded(
            child: FlxValue(
              controller.logText,
              (_) => ListView.builder(
                reverse: true,
                itemCount: controller.logText.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: Text(
                      controller.logText[controller.logText.length - 1 - index],
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
