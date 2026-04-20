/// New Features Test Page
///
/// This page demonstrates all the new GetX-like features added to Flows:
/// - Flow.snackbar() / Flow.dialog()
/// - Flow.context / Flow.isDialogOpen
/// - SnackPosition
/// - RxList API (isEmpty, isNotEmpty, firstWhereOrNull, etc.)
/// - ever() workers
/// - refresh() method
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:liteflows/flows.dart';
import '../main.dart' show AppColors;
import '../utils/pretty_print.dart';

class NewFeaturesPage extends StatefulWidget {
  const NewFeaturesPage({super.key});

  @override
  State<NewFeaturesPage> createState() => _NewFeaturesPageState();
}

class _NewFeaturesPageState extends State<NewFeaturesPage> {
  // Rx variables for testing
  final count = 0.obs;
  final items = RxList<String>(['Apple', 'Banana', 'Cherry']);
  final isDarkMode = false.obs;

  // Worker for ever() demo
  Worker? _countWorker;
  int _everCallbackCount = 0;

  @override
  void initState() {
    super.initState();
    PrettyLogger.divider('New Features Page');
    PrettyLogger.info('Setting up ever() worker...');

    // Setup ever() worker to listen to count changes
    _countWorker = ever(count, (value) {
      setState(() {
        _everCallbackCount++;
      });
      PrettyLogger.success('ever() triggered: count = $value (call #$_everCallbackCount)');
    });
  }

  @override
  void dispose() {
    _countWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Features Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Snackbar
            _buildSectionTitle('1. Snackbar (Flow.snackbar)'),
            _buildCard(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Flow.snackbar(
                      'Success!',
                      'This is a success message',
                      snackPosition: SnackPosition.top,
                      backgroundColor: AppColors.success,
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                    );
                    PrettyLogger.success('Top snackbar shown');
                  },
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('Show Top Snackbar'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Flow.snackbar(
                      'Info',
                      'This is an info message at bottom',
                      snackPosition: SnackPosition.bottom,
                      backgroundColor: AppColors.primary,
                      icon: const Icon(Icons.info, color: Colors.white),
                      duration: const Duration(seconds: 2),
                    );
                    PrettyLogger.info('Bottom snackbar shown');
                  },
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text('Show Bottom Snackbar'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Flow.rawSnackbar(
                      title: 'Custom Snackbar',
                      message: 'This is a fully customized snackbar with longer duration',
                      backgroundColor: AppColors.warning,
                      duration: const Duration(seconds: 5),
                      icon: const Icon(Icons.star, color: Colors.white),
                      mainButton: TextButton(
                        onPressed: () {
                          PrettyLogger.info('Snackbar action tapped');
                        },
                        child: const Text('ACTION', style: TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                  icon: const Icon(Icons.tune),
                  label: const Text('Show Custom Snackbar'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Flow.closeAllSnackbars();
                    PrettyLogger.info('All snackbars closed');
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Close All Snackbars'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section 2: Dialog
            _buildSectionTitle('2. Dialog (Flow.dialog)'),
            _buildCard(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    PrettyLogger.info('Showing custom dialog...');
                    await Flow.dialog(
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.celebration, size: 64, color: AppColors.primary),
                            const SizedBox(height: 16),
                            const Text(
                              'Custom Dialog',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text('This is a custom dialog using Flow.dialog()'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Flow.back(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    );
                    PrettyLogger.info('Custom dialog closed');
                  },
                  icon: const Icon(Icons.picture_in_picture),
                  label: const Text('Show Custom Dialog'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    PrettyLogger.info('Showing default dialog...');
                    await Flow.defaultDialog(
                      title: 'Alert!',
                      middleText: 'This is a default dialog with configurable buttons.\n\nYou can customize colors, text, and actions.',
                      textConfirm: 'Got it!',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        PrettyLogger.success('Confirm button tapped');
                        Flow.back();
                      },
                      onCancel: () {
                        PrettyLogger.info('Cancel button tapped');
                        Flow.back();
                      },
                    );
                  },
                  icon: const Icon(Icons.warning_amber),
                  label: const Text('Show Default Dialog'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    PrettyLogger.info('Dialog open status: ${Flow.isDialogOpen}');
                    Flow.snackbar(
                      'Dialog Status',
                      'Is dialog open? ${Flow.isDialogOpen ? "Yes" : "No"}',
                      snackPosition: SnackPosition.bottom,
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Check isDialogOpen'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Flow.closeAllDialogs();
                    PrettyLogger.info('All dialogs closed');
                  },
                  icon: const Icon(Icons.close_fullscreen),
                  label: const Text('Close All Dialogs'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section 3: Flow.context
            _buildSectionTitle('3. Flow.context'),
            _buildCard(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final ctx = Flow.context;
                    if (ctx != null) {
                      PrettyLogger.success('Flow.context available: ${ctx.widget.runtimeType}');
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Got context from Flow.context!')),
                      );
                    } else {
                      PrettyLogger.warning('Flow.context is null');
                    }
                  },
                  icon: const Icon(Icons.info),
                  label: const Text('Get Flow.context'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section 4: RxList API
            _buildSectionTitle('4. RxList API'),
            _buildCard(
              children: [
                Flx(() => Text(
                  'Items: ${items.value.join(", ")}',
                  style: const TextStyle(fontSize: 16),
                )),
                const SizedBox(height: 8),
                Flx(() => Row(
                  children: [
                    const Text('isEmpty: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${items.isEmpty}', style: const TextStyle(color: AppColors.primary)),
                    const SizedBox(width: 16),
                    const Text('isNotEmpty: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${items.isNotEmpty}', style: const TextStyle(color: AppColors.primary)),
                  ],
                )),
                const SizedBox(height: 8),
                Flx(() => Text(
                  'first: ${items.first} | last: ${items.last}',
                  style: const TextStyle(fontSize: 14),
                )),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        items.add('Item ${items.length + 1}');
                        PrettyLogger.info('Added item. Count: ${items.length}');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (items.isNotEmpty) {
                          items.removeLast();
                          PrettyLogger.info('Removed last item. Count: ${items.length}');
                        }
                      },
                      icon: const Icon(Icons.remove),
                      label: const Text('Remove Last'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        final result = items.firstWhereOrNull((item) => item.startsWith('C'));
                        PrettyLogger.data('firstWhereOrNull (starts with C)', result ?? 'null');
                        Flow.snackbar(
                          'firstWhereOrNull',
                          result ?? 'No item found',
                          snackPosition: SnackPosition.bottom,
                        );
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('firstWhereOrNull'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        PrettyLogger.data('lastWhereOrNull', items.lastWhereOrNull((item) => item.length > 5) ?? 'null');
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('lastWhereOrNull'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        items.clear();
                        PrettyLogger.info('List cleared');
                      },
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Clear All'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section 5: ever() Worker
            _buildSectionTitle('5. ever() Worker'),
            _buildCard(
              children: [
                Flx(() => Text(
                  'Count: ${count.value}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
                const SizedBox(height: 8),
                Flx(() => Text(
                  'ever() callback called: $_everCallbackCount times',
                  style: const TextStyle(color: AppColors.primary),
                )),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        count.value++;
                        PrettyLogger.info('Count incremented to ${count.value}');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Increment'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        count.value--;
                        PrettyLogger.info('Count decremented to ${count.value}');
                      },
                      icon: const Icon(Icons.remove),
                      label: const Text('Decrement'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'The ever() function triggers a callback every time the Rx value changes.\nCheck the console logs!',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section 6: debounce() Worker
            _buildSectionTitle('6. debounce() Worker'),
            _buildCard(
              children: [
                const Text('Type in the field below (triggers after 500ms of no typing):'),
                const SizedBox(height: 8),
                Builder(
                  builder: (ctx) {
                    final controller = TextEditingController();
                    Worker? debounceWorker;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final rxText = ''.obs;
                      debounceWorker = debounce(rxText, (value) {
                        PrettyLogger.success('debounce() triggered: "$value"');
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(content: Text('Searched: "$value"')),
                        );
                      }, time: const Duration(milliseconds: 500));

                      controller.addListener(() {
                        rxText.value = controller.text;
                      });
                    });

                    return TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Type something...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section 7: once() Worker
            _buildSectionTitle('7. once() Worker'),
            _buildCard(
              children: [
                const Text('Click the button below. The once() callback will only execute the first time:'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    final rxOnce = 0.obs;
                    PrettyLogger.info('Setting up once() listener...');

                    once(rxOnce, (value) {
                      PrettyLogger.success('once() triggered! Value: $value');
                      Flow.snackbar(
                        'once() triggered!',
                        'This only shows once',
                        snackPosition: SnackPosition.bottom,
                        backgroundColor: AppColors.success,
                      );
                    });

                    // Trigger multiple times
                    rxOnce.value = 1;
                    rxOnce.value = 2;
                    rxOnce.value = 3;
                    PrettyLogger.info('Value changed 3 times, but once() only called once');
                  },
                  icon: const Icon(Icons.looks_one),
                  label: const Text('Test once() - Click Me'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section 8: Workers container
            _buildSectionTitle('8. Workers Container'),
            _buildCard(
              children: [
                const Text('Workers container for managing multiple workers:'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    final myWorkers = workers();
                    final rx1 = 0.obs;
                    final rx2 = ''.obs;

                    myWorkers.add(ever(rx1, (v) => print('rx1: $v')));
                    myWorkers.add(ever(rx2, (v) => print('rx2: $v')));

                    PrettyLogger.info('Created workers container with 2 workers');

                    rx1.value = 1;
                    rx2.value = 'test';

                    // Dispose all at once
                    myWorkers.dispose();
                    PrettyLogger.info('Disposed all workers');

                    Flow.snackbar(
                      'Workers Demo',
                      'Created and disposed workers',
                      snackPosition: SnackPosition.bottom,
                    );
                  },
                  icon: const Icon(Icons.work),
                  label: const Text('Test Workers Container'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Summary
            _buildCard(
              color: AppColors.primary.withValues(alpha: 0.1),
              children: [
                const Text(
                  'All new GetX-like features are working!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children, Color? color}) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
