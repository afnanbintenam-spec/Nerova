import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Page transition animations for 2026 app design standards
/// Duration: 220–320ms (main nav), 180–240ms (small overlays)
/// Curve: easeOutCubic / fastOutSlowIn
class AppPageTransitions {
  /// Native platform transitions (default)
  /// Android: Material slide + fade
  /// iOS: Cupertino push (right-to-left)
  static Route<T> nativeTransition<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoPageRoute<T>(builder: builder);
    }
    return MaterialPageRoute<T>(builder: builder);
  }

  /// Fade + slight scale transition (premium feel)
  /// Page fades in while scaling from 0.98 → 1.0
  /// Best for: Splash → Home, Login → Home, Modal-like pages
  static Route<T> fadeScaleTransition<T>({
    required WidgetBuilder builder,
    Duration duration = const Duration(milliseconds: 280),
  }) {
    return _FadeScalePageRoute<T>(builder: builder, duration: duration);
  }

  /// Shared axis transition (left-right)
  /// Best for: moving between related screens (List → Details, Auth flows)
  static Route<T> sharedAxisHorizontal<T>({
    required WidgetBuilder builder,
    bool isForward = true,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _SharedAxisPageRoute<T>(
      builder: builder,
      axis: _SharedAxisAxis.horizontal,
      isForward: isForward,
      duration: duration,
    );
  }

  /// Shared axis transition (up-down)
  /// Best for: switching contexts or modal-like navigation
  static Route<T> sharedAxisVertical<T>({
    required WidgetBuilder builder,
    bool isForward = true,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _SharedAxisPageRoute<T>(
      builder: builder,
      axis: _SharedAxisAxis.vertical,
      isForward: isForward,
      duration: duration,
    );
  }

  /// Bottom sheet slide-up with blur
  /// Best for: filters, quick actions, small forms
  static Future<T?> showBottomSheetTransition<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    Duration duration = const Duration(milliseconds: 240),
    bool isDismissible = true,
    bool enableBlur = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      isDismissible: isDismissible,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: Colors.black.withValues(alpha: enableBlur ? 0.4 : 0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }
}

/// Fade + Scale Page Route
class _FadeScalePageRoute<T> extends PageRoute<T> {
  _FadeScalePageRoute({required this.builder, required this.duration});

  final WidgetBuilder builder;
  final Duration duration;

  @override
  Color? get barrierColor => null;

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = 0.98;
    const end = 1.0;
    const curve = Curves.easeOutCubic;

    final scaleTween = Tween(begin: begin, end: end);
    final opacityTween = Tween(begin: 0.0, end: 1.0);

    return FadeTransition(
      opacity: opacityTween.animate(
        CurvedAnimation(parent: animation, curve: curve),
      ),
      child: ScaleTransition(
        scale: scaleTween.animate(
          CurvedAnimation(parent: animation, curve: curve),
        ),
        child: child,
      ),
    );
  }
}

/// Shared Axis Page Route
enum _SharedAxisAxis { horizontal, vertical }

class _SharedAxisPageRoute<T> extends PageRoute<T> {
  _SharedAxisPageRoute({
    required this.builder,
    required this.axis,
    required this.isForward,
    required this.duration,
  });

  final WidgetBuilder builder;
  final _SharedAxisAxis axis;
  final bool isForward;
  final Duration duration;

  @override
  Color? get barrierColor => null;

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const curve = Curves.fastOutSlowIn;

    if (axis == _SharedAxisAxis.horizontal) {
      final beginX = isForward ? 1.0 : -1.0;
      final translateTween = Tween(begin: Offset(beginX, 0), end: Offset.zero);
      final opacityTween = Tween(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: translateTween.animate(
          CurvedAnimation(parent: animation, curve: curve),
        ),
        child: FadeTransition(
          opacity: opacityTween.animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: child,
        ),
      );
    } else {
      // Vertical axis
      final beginY = isForward ? 1.0 : -1.0;
      final translateTween = Tween(begin: Offset(0, beginY), end: Offset.zero);
      final opacityTween = Tween(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: translateTween.animate(
          CurvedAnimation(parent: animation, curve: curve),
        ),
        child: FadeTransition(
          opacity: opacityTween.animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: child,
        ),
      );
    }
  }
}
