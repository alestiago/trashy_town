import 'package:flutter/widgets.dart';

/// {@template BasuraBlackEaseInOut}
/// A page route that transitions to black and from a black background using
/// the ease-in-out curve.
/// {@endtemplate}
class BasuraBlackEaseInOut<T> extends PageRouteBuilder<T> {
  /// {@macro BasuraBlackEaseInOut}
  BasuraBlackEaseInOut({
    required WidgetBuilder builder,
    super.settings,
  }) : super(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final begin = BoxDecoration(
              color: const Color(0xff000000).withOpacity(0.9),
            );
            final end = BoxDecoration(
              color: const Color(0xff000000).withOpacity(0),
            );
            const curve = Curves.easeInOut;

            final tween = DecorationTween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );
            final animate = tween.animate(curvedAnimation);

            return DecoratedBoxTransition(
              decoration: animate,
              position: DecorationPosition.foreground,
              child: child,
            );
          },
        );
}
