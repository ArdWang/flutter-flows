/// Flow - Core dependency injection and navigation
library;

import 'package:flutter/material.dart' hide Flow;
import 'lifecycle.dart';
import '../navigation/snackbar.dart';
import '../navigation/dialog.dart';

/// FlowBinding for route-specific dependency injection
abstract class FlowBinding {
  void dependencies();
}

/// Flow - Dependency Injection and Navigation
///
/// Main features:
/// - Dependency Injection with Flow.put/Flow.find
/// - Route management with Flow.to/Flow.toNamed
/// - Snackbar and Dialog utilities
/// - Context access
class Flow {
  static final Map<Type, Map<String?, _InstanceBuilder>> _dependencies = {};
  static final _navigatorKey = GlobalKey<NavigatorState>();
  static bool _isDialogOpen = false;

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  static NavigatorState? get navigator => _navigatorKey.currentState;

  /// Get current context from navigator
  static BuildContext? get context => _navigatorKey.currentContext;

  /// Check if a dialog is currently open
  static bool get isDialogOpen => _isDialogOpen;

  /// Get current arguments from route settings
  static dynamic get arguments {
    final route = ModalRoute.of(navigator!.context);
    return route?.settings.arguments;
  }

  /// Check if a dependency is registered
  static bool isRegistered<T>({String? tag}) {
    return _dependencies.containsKey(T) && _dependencies[T]!.containsKey(tag);
  }

  /// Register a dependency
  static S put<S>(S dependency, {String? tag, bool permanent = false}) {
    final type = S;
    if (!_dependencies.containsKey(type)) {
      _dependencies[type] = {};
    }
    _dependencies[type]![tag] = _InstanceBuilder(
      instance: dependency,
      permanent: permanent,
    );

    // Call onInit and onReady if it's a controller with lifecycle
    if (dependency is FlowLifeCycleMixin) {
      dependency.init();
      dependency.ready();
    }

    return dependency;
  }

  /// Lazy registration
  static S lazyPut<S>(S Function() builder, {String? tag, bool permanent = false}) {
    final type = S;
    if (!_dependencies.containsKey(type)) {
      _dependencies[type] = {};
    }
    _dependencies[type]![tag] = _InstanceBuilder(
      builder: builder,
      permanent: permanent,
    );
    return find<S>(tag: tag);
  }

  /// Find a dependency
  static S find<S>({String? tag}) {
    final type = S;
    if (!_dependencies.containsKey(type)) {
      throw 'Dependency of type $type not found. Did you forget to call Flow.put()?';
    }
    final builder = _dependencies[type]![tag];
    if (builder == null) {
      throw 'Dependency of type $type with tag $tag not found.';
    }

    if (builder.instance != null) {
      return builder.instance as S;
    }

    if (builder.builder != null) {
      final instance = builder.builder!() as S;
      builder.instance = instance;

      // Call onInit and onReady if it's a controller with lifecycle
      if (instance is FlowLifeCycleMixin) {
        instance.init();
        instance.ready();
      }

      return instance;
    }

    throw 'Dependency of type $type not properly initialized.';
  }

  /// Delete a dependency
  static bool delete<S>({String? tag, bool force = false}) {
    final type = S;
    if (!_dependencies.containsKey(type)) {
      return false;
    }

    final builder = _dependencies[type]![tag];
    if (builder == null) {
      return false;
    }

    if (builder.permanent && !force) {
      return false;
    }

    // Call onClose if it's a controller with lifecycle
    if (builder.instance is FlowLifeCycleMixin) {
      (builder.instance as FlowLifeCycleMixin).close();
    }

    _dependencies[type]!.remove(tag);
    if (_dependencies[type]!.isEmpty) {
      _dependencies.remove(type);
    }
    return true;
  }

  /// Navigate to a page
  static Future<T?> to<T>(Widget page, {FlowBinding? binding}) async {
    if (binding != null) {
      binding.dependencies();
    }
    return navigator?.push<T>(
      MaterialPageRoute<T>(builder: (_) => page),
    );
  }

  /// Navigate to a named route
  static Future<T?> toNamed<T>(String routeName, {Object? arguments}) async {
    return navigator?.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replace current route
  static Future<T?> off<T>(Widget page, {FlowBinding? binding}) async {
    if (binding != null) {
      binding.dependencies();
    }
    return navigator?.pushReplacement<T, dynamic>(
      MaterialPageRoute<T>(builder: (_) => page),
    );
  }

  /// Replace current route with named route
  static Future<T?> offNamed<T>(String routeName, {Object? arguments}) async {
    return navigator?.pushReplacementNamed<T, dynamic>(routeName, arguments: arguments);
  }

  /// Go back
  static void back<T>([T? result]) {
    navigator?.pop(result);
  }

  /// Go back until a route
  static void backUntil(String routeName) {
    navigator?.popUntil(ModalRoute.withName(routeName));
  }

  /// Remove all routes until the first one
  static void offAll(Widget page, {FlowBinding? binding}) {
    if (binding != null) {
      binding.dependencies();
    }
    navigator?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Remove all routes until the first one with named route
  static void offAllNamed(String routeName, {Object? arguments}) {
    navigator?.pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }

  /// Show a snackbar
  static SnackbarController snackbar(
    String title,
    String message, {
    Color? colorText,
    Duration? duration = const Duration(seconds: 3),
    bool instantInit = true,
    SnackPosition? snackPosition = SnackPosition.top,
    Widget? titleText,
    Widget? messageText,
    Widget? icon,
    bool? shouldIconPulse,
    double? maxWidth,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? backgroundColor,
    Color? leftBarIndicatorColor,
    List<BoxShadow>? boxShadows,
    Gradient? backgroundGradient,
    Widget? mainButton,
    OnTap? onTap,
    OnHover? onHover,
    bool? isDismissible,
    bool? showProgressIndicator,
    AnimationController? progressIndicatorController,
    Color? progressIndicatorBackgroundColor,
    Animation<Color>? progressIndicatorValueColor,
    SnackStyle? snackStyle,
    Curve? forwardAnimationCurve,
    Curve? reverseAnimationCurve,
    Duration? animationDuration,
    double? barBlur,
    double? overlayBlur,
    SnackbarStatusCallback? snackbarStatus,
    Color? overlayColor,
    Form? userInputForm,
  }) {
    final flowSnackBar = FlowSnackBar(
      snackbarStatus: snackbarStatus,
      titleText: titleText ??
          Text(
            title,
            style: TextStyle(
              color: colorText ?? Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
      messageText: messageText ??
          Text(
            message,
            style: TextStyle(
              color: colorText ?? Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 14,
            ),
          ),
      snackPosition: snackPosition ?? SnackPosition.top,
      borderRadius: borderRadius ?? 15,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 10),
      duration: duration,
      barBlur: barBlur ?? 7.0,
      backgroundColor: backgroundColor ?? const Color(0xFF303030),
      icon: icon,
      shouldIconPulse: shouldIconPulse ?? true,
      maxWidth: maxWidth,
      padding: padding ?? const EdgeInsets.all(16),
      borderColor: borderColor,
      borderWidth: borderWidth,
      leftBarIndicatorColor: leftBarIndicatorColor,
      boxShadows: boxShadows,
      backgroundGradient: backgroundGradient,
      mainButton: mainButton,
      onTap: onTap,
      onHover: onHover,
      isDismissible: isDismissible ?? true,
      showProgressIndicator: showProgressIndicator ?? false,
      progressIndicatorController: progressIndicatorController,
      progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
      progressIndicatorValueColor: progressIndicatorValueColor,
      snackStyle: snackStyle ?? SnackStyle.floating,
      forwardAnimationCurve: forwardAnimationCurve ?? Curves.easeOutCirc,
      reverseAnimationCurve: reverseAnimationCurve ?? Curves.easeOutCirc,
      animationDuration: animationDuration ?? const Duration(seconds: 1),
      overlayBlur: overlayBlur ?? 0.0,
      overlayColor: overlayColor ?? Colors.transparent,
      userInputForm: userInputForm,
    );

    final controller = SnackbarController(flowSnackBar);

    if (instantInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.show();
      });
    } else {
      controller.show();
    }
    return controller;
  }

  /// Show a raw snackbar
  static SnackbarController rawSnackbar({
    String? title,
    String? message,
    Widget? titleText,
    Widget? messageText,
    Widget? icon,
    bool shouldIconPulse = true,
    double? maxWidth,
    EdgeInsets margin = const EdgeInsets.all(0.0),
    EdgeInsets padding = const EdgeInsets.all(16),
    double borderRadius = 0.0,
    Color? borderColor,
    double borderWidth = 1.0,
    Color backgroundColor = const Color(0xFF303030),
    Color? leftBarIndicatorColor,
    List<BoxShadow>? boxShadows,
    Gradient? backgroundGradient,
    Widget? mainButton,
    OnTap? onTap,
    Duration? duration = const Duration(seconds: 3),
    bool isDismissible = true,
    bool showProgressIndicator = false,
    AnimationController? progressIndicatorController,
    Color? progressIndicatorBackgroundColor,
    Animation<Color>? progressIndicatorValueColor,
    SnackPosition snackPosition = SnackPosition.bottom,
    SnackStyle snackStyle = SnackStyle.floating,
    Curve forwardAnimationCurve = Curves.easeOutCirc,
    Curve reverseAnimationCurve = Curves.easeOutCirc,
    Duration animationDuration = const Duration(seconds: 1),
    SnackbarStatusCallback? snackbarStatus,
    double barBlur = 0.0,
    double overlayBlur = 0.0,
    Color? overlayColor,
    Form? userInputForm,
  }) {
    final flowSnackBar = FlowSnackBar(
      snackbarStatus: snackbarStatus,
      title: title,
      message: message,
      titleText: titleText,
      messageText: messageText,
      snackPosition: snackPosition,
      borderRadius: borderRadius,
      margin: margin,
      duration: duration,
      barBlur: barBlur,
      backgroundColor: backgroundColor,
      icon: icon,
      shouldIconPulse: shouldIconPulse,
      maxWidth: maxWidth,
      padding: padding,
      borderColor: borderColor,
      borderWidth: borderWidth,
      leftBarIndicatorColor: leftBarIndicatorColor,
      boxShadows: boxShadows,
      backgroundGradient: backgroundGradient,
      mainButton: mainButton,
      onTap: onTap,
      isDismissible: isDismissible,
      showProgressIndicator: showProgressIndicator,
      progressIndicatorController: progressIndicatorController,
      progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
      progressIndicatorValueColor: progressIndicatorValueColor,
      snackStyle: snackStyle,
      forwardAnimationCurve: forwardAnimationCurve,
      reverseAnimationCurve: reverseAnimationCurve,
      animationDuration: animationDuration,
      overlayBlur: overlayBlur,
      overlayColor: overlayColor,
      userInputForm: userInputForm,
    );

    final controller = SnackbarController(flowSnackBar);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.show();
    });
    return controller;
  }

  /// Show a dialog
  static Future<T?> dialog<T>(
    Widget widget, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    Object? arguments,
    Duration? transitionDuration,
    Curve? transitionCurve,
    String? name,
  }) async {
    assert(debugCheckHasMaterialLocalizations(navigator!.context));

    final theme = Theme.of(navigator!.context);
    return navigator?.push<T>(
      FlowDialogRoute<T>(
        pageBuilder: (buildContext, animation, secondaryAnimation) {
          final pageChild = widget;
          Widget dialog = Builder(builder: (context) {
            return Theme(data: theme, child: pageChild);
          });
          if (useSafeArea) {
            dialog = SafeArea(child: dialog);
          }
          return dialog;
        },
        barrierDismissible: barrierDismissible,
        barrierLabel: MaterialLocalizations.of(navigator!.context).modalBarrierDismissLabel,
        barrierColor: barrierColor ?? Colors.black54,
        transitionDuration: transitionDuration ?? const Duration(milliseconds: 200),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: transitionCurve ?? Curves.easeOut,
            ),
            child: child,
          );
        },
        settings: RouteSettings(arguments: arguments, name: name),
      ),
    ).whenComplete(() {
      _isDialogOpen = false;
    }).then((value) {
      return value;
    });
  }

  /// Show a default dialog
  static Future<T?> defaultDialog<T>({
    String title = "Alert",
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleStyle,
    Widget? content,
    EdgeInsetsGeometry? contentPadding,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    VoidCallback? onCustom,
    Color? cancelTextColor,
    Color? confirmTextColor,
    String? textConfirm,
    String? textCancel,
    String? textCustom,
    Widget? confirm,
    Widget? cancel,
    Widget? custom,
    Color? backgroundColor,
    bool barrierDismissible = true,
    Color? buttonColor,
    String middleText = "\n",
    TextStyle? middleTextStyle,
    double radius = 20.0,
    List<Widget>? actions,
  }) async {
    var leanCancel = onCancel != null || textCancel != null;
    var leanConfirm = onConfirm != null || textConfirm != null;
    actions ??= [];

    if (cancel != null) {
      actions.add(cancel);
    } else {
      if (leanCancel) {
        actions.add(TextButton(
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: buttonColor ?? Theme.of(navigator!.context).colorScheme.secondary,
                    width: 2,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(radius)),
          ),
          onPressed: () {
            if (onCancel == null) {
              back();
            } else {
              onCancel.call();
            }
          },
          child: Text(
            textCancel ?? "Cancel",
            style: TextStyle(
                color: cancelTextColor ?? Theme.of(navigator!.context).colorScheme.secondary),
          ),
        ));
      }
    }
    if (confirm != null) {
      actions.add(confirm);
    } else {
      if (leanConfirm) {
        actions.add(TextButton(
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: buttonColor ?? Theme.of(navigator!.context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius)),
            ),
            child: Text(
              textConfirm ?? "Ok",
              style: TextStyle(
                  color: confirmTextColor ?? Theme.of(navigator!.context).colorScheme.surface),
            ),
            onPressed: () {
              onConfirm?.call();
            }));
      }
    }

    Widget alertDialog = AlertDialog(
      titlePadding: titlePadding ?? const EdgeInsets.all(8),
      contentPadding: contentPadding ?? const EdgeInsets.all(8),
      backgroundColor: backgroundColor ?? DialogTheme.of(navigator!.context).backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      title: Text(title, textAlign: TextAlign.center, style: titleStyle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          content ??
              Text(middleText,
                  textAlign: TextAlign.center, style: middleTextStyle),
          const SizedBox(height: 16),
          ButtonTheme(
            minWidth: 78.0,
            height: 34.0,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: actions,
            ),
          )
        ],
      ),
      buttonPadding: EdgeInsets.zero,
    );

    _isDialogOpen = true;
    return dialog<T>(alertDialog, barrierDismissible: barrierDismissible).whenComplete(() {
      _isDialogOpen = false;
    });
  }

  /// Close all open dialogs
  static void closeAllDialogs() {
    while (_isDialogOpen) {
      back();
    }
  }

  /// Close all open snackbars
  static void closeAllSnackbars() {
    SnackbarController.cancelAllSnackbars();
  }

  /// Close all overlays (dialogs and snackbars)
  static void closeAllOverlays() {
    closeAllDialogs();
    closeAllSnackbars();
  }

  /// Trigger a rebuild of reactive widgets
  /// This is useful when you need to force a UI update
  static void refresh() {
    // Notify all active Rx objects to rebuild
    // This is a simplified implementation
    // In a full implementation, this would notify all listeners
  }
}

/// Internal class for dependency registration
class _InstanceBuilder {
  dynamic instance;
  dynamic Function()? builder;
  final bool permanent;

  _InstanceBuilder({
    this.instance,
    this.builder,
    this.permanent = false,
  });
}
