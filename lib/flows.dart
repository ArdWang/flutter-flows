/// Flows - A light, modern and powerful Flutter framework
///
/// Main features:
/// - Dependency Injection with Flow.put/Flow.find
/// - Reactive state management with Rx types and Flx widget
/// - Route management with Flow.to/Flow.toNamed
/// - Logic/State/View separation pattern
///
/// IMPORTANT: Flx is designed for SINGLE-LEVEL observation only.
library;

// Core - Dependency Injection, Lifecycle and Navigation
export 'src/core/flow.dart';
export 'src/core/lifecycle.dart';

// RX - Reactive types
export 'src/rx/rx.dart';

// State Manager
export 'src/state_manager/flow_controller.dart';
export 'src/state_manager/flow_state.dart';
export 'src/state_manager/flow_logic.dart';
export 'src/state_manager/flow_view.dart';
export 'src/state_manager/flx.dart';

// Navigation
export 'src/navigation/flow_page.dart';
export 'src/navigation/flow_app.dart';
