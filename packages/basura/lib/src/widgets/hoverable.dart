import 'package:flutter/widgets.dart';

/// {@template Hoverable}
/// A widget that calls a callback when hovered or pressed.
/// {@endtemplate}
class Hoverable extends StatelessWidget {
  /// {@macro Hoverable}
  const Hoverable({
    required this.child,
    required this.onHoverStart,
    required this.onHoverExit,
    super.key,
  });

  /// The callback to call when the widget is hovered or pressed.
  final void Function(BuildContext context) onHoverStart;

  /// The callback to call when the widget is no longer hovered or pressed.
  final void Function(BuildContext context) onHoverExit;

  /// The child to animate.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHoverStart(context),
      onExit: (_) => onHoverExit(context),
      child: GestureDetector(
        onTapDown: (_) => onHoverStart(context),
        onTapUp: (_) => onHoverExit(context),
        onTapCancel: () => onHoverExit(context),
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}
