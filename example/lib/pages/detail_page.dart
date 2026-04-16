/// Detail Page - Demonstrates route parameters and data passing
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_flows/flows.dart';

class DetailController extends FlowController {
  final selectedItem = ''.obs;
  final notes = RxList<String>([]);

  void selectItem(String item) {
    selectedItem.value = item;
  }

  void addNote(String note) {
    notes.add(note);
  }

  void removeNote(int index) {
    notes.removeAt(index);
  }

  void clearNotes() {
    notes.clear();
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Flow.arguments;
    final name = args is Map ? args['name'] as String? : null;

    // Register controller if not already registered
    if (!Flow.isRegistered<DetailController>()) {
      Flow.put(DetailController());
    }
    final controller = Flow.find<DetailController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${name ?? 'Guest'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This page demonstrates route parameters and data passing.',
              style: TextStyle(fontSize: 16),
            ),

            const Divider(height: 32),
            const Text(
              'Sample Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: FlxValue(
                controller.selectedItem,
                (_) => ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final item = 'Item ${index + 1}';
                    return ListTile(
                      title: Text(item),
                      trailing: FlxValue(
                        controller.selectedItem,
                        (selected) => selected == item
                            ? const Icon(Icons.check)
                            : const SizedBox(),
                      ),
                      onTap: () => controller.selectItem(item),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
            Flx(() => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selected:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    controller.selectedItem.value.isEmpty
                        ? 'No item selected'
                        : controller.selectedItem.value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Flow.back(),
              child: const Text('Go Back Home'),
            ),
          ],
        ),
      ),
    );
  }
}
