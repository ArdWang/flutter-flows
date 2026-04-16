/// FlowView - Widget base class for views with logic/state separation
///
/// Usage:
/// ```dart
/// class HomePage extends FlowView<HomeLogic, HomePageState> {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Flx(() => Text('Count: ${state.count.value}')),
///       floatingActionButton: FloatingActionButton(
///         onPressed: logic.increment,
///         child: const Icon(Icons.add),
///       ),
///     );
///   }
/// }
/// ```
library;

import 'package:flutter/material.dart' hide Flow;
import '../core/flow.dart';
import 'flow_state.dart';
import 'flow_logic.dart';

/// FlowView with logic and state separation
abstract class FlowView<L extends FlowLogic<S>, S extends FlowState> extends StatelessWidget {
  const FlowView({super.key});

  /// Optional tag for dependency injection
  final String? tag = null;

  /// Get the logic instance
  L get logic => Flow.find<L>(tag: tag);

  /// Get the state instance
  S get state => logic.state!;

  /// Create a new state instance (override if needed)
  S createState() {
    throw 'You must provide a state instance. Use FlowView.withState() or override createState().';
  }

  /// Create a new logic instance (override if needed)
  L createLogic() {
    throw 'You must provide a logic instance. Use FlowView.withLogic() or override createLogic().';
  }

  @override
  Widget build(BuildContext context);
}

/// FlowView that automatically creates logic and state
class FlowViewState<L extends FlowLogic<S>, S extends FlowState> extends StatefulWidget {
  final Widget Function(BuildContext context, L logic, S state) builder;
  final L Function() logicBuilder;
  final S Function() stateBuilder;
  final String? tag;

  const FlowViewState({
    super.key,
    required this.builder,
    required this.logicBuilder,
    required this.stateBuilder,
    this.tag,
  });

  @override
  State<FlowViewState<L, S>> createState() => _FlowViewStateState<L, S>();
}

class _FlowViewStateState<L extends FlowLogic<S>, S extends FlowState> extends State<FlowViewState<L, S>> {
  late L _logic;
  late S _state;

  @override
  void initState() {
    super.initState();
    _state = widget.stateBuilder();
    _logic = widget.logicBuilder();
    _logic.setState(_state);
    _state.init();
    _logic.init();
    _logic.onReady();
    _state.onReady();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _logic, _state);
  }

  @override
  void dispose() {
    _logic.close();
    _state.close();
    super.dispose();
  }
}

/// Simple FlowView for basic usage (renamed to avoid conflict with navigation FlowPage)
abstract class FlowSimpleView<S extends FlowState> extends StatelessWidget {
  const FlowSimpleView({super.key});

  final String? tag = null;

  S get state => Flow.find<S>(tag: tag);

  S createState();

  @override
  Widget build(BuildContext context);
}
