/// Detail Page - Demonstrates route parameters and data passing
///
/// Receives UserData from Home page (edited there)
/// This page demonstrates receiving parameters in View layer
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_flows/flows.dart';

import '../state/home_state.dart' show UserData;
import '../main.dart' show AppColors;
import '../utils/pretty_print.dart';

class DetailController extends FlowController {
  // Reactive state
  final selectedItem = ''.obs;
  final notes = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    PrettyLogger.debug('DetailController initialized');
  }

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

/// DetailPage - Receives parameters from Home page
///
/// Demonstrates receiving parameters in View layer:
/// - String parameter (name)
/// - Object parameter (UserData) - Edited in Home page
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments from current route settings
    final args = ModalRoute.of(context)?.settings.arguments;
    final nameParam = args is Map ? args['name'] as String? : null;
    final userDataParam = args is Map ? args['userData'] as UserData? : null;

    PrettyLogger.divider('Received Parameters');
    PrettyLogger.data('name', nameParam ?? 'null');
    PrettyLogger.data('userData', userDataParam?.toString() ?? 'null');

    // Register controller if not already registered
    if (!Flow.isRegistered<DetailController>()) {
      Flow.put(DetailController());
    }
    final controller = Flow.find<DetailController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page - Flows Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display name from parameter
            Text(
              'Hello, ${nameParam ?? 'Guest'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Display userData if passed
            if (userDataParam != null) ...[
              const SizedBox(height: 16),
              Card(
                color: AppColors.primary.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, size: 20),
                          const SizedBox(width: 8),
                          const Text('User Data (from Home):', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildDataRow('Name:', userDataParam.name),
                      _buildDataRow('Age:', '${userDataParam.age}'),
                      _buildDataRow('Email:', userDataParam.email),
                      const SizedBox(height: 8),
                      const Text(
                        '✏️ Edit this in Home page and navigate again',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ],

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
                            ? const Icon(Icons.check, color: AppColors.primary)
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
                color: AppColors.primary.withValues(alpha: 0.1),
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
              onPressed: () {
                PrettyLogger.info('Navigating back from Detail Page');
                Flow.back();
              },
              child: const Text('Go Back Home'),
            ),
          ],
        ),
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
}
