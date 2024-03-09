import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trashy_road/src/game/game.dart';

/// {@template GameTimeIsUpPage}
/// A page that displays the game over screen when the time is up.
/// {@endtemplate}
class GameTimeIsUpPage extends StatelessWidget {
  /// {@macro GameTimeIsUpPage}
  const GameTimeIsUpPage({super.key});

  /// The identifier for the route.
  static const identifier = 'game_time_is_up';

  static const heroTag = 'game_time_is_up__stopwatch_icon';

  static Route<void> route() {
    return GameTimeIsUpPageRouteBuilder(
      settings: const RouteSettings(name: identifier),
      builder: (context) => const GameTimeIsUpPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Center(
      child: SizedBox.square(
        dimension: (screenSize.shortestSide * 0.5).clamp(300, 500),
        child: const _AnimatedStopwatchIcon(),
      ),
    );
  }
}

class _AnimatedStopwatchIcon extends StatefulWidget {
  const _AnimatedStopwatchIcon();

  @override
  State<_AnimatedStopwatchIcon> createState() => __AnimatedStopwatchIconState();
}

class __AnimatedStopwatchIconState extends State<_AnimatedStopwatchIcon>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )
    ..value = 0.5
    ..repeat(
      reverse: true,
      period: const Duration(milliseconds: 200),
    );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rotationAnimation =
        Tween<double>(begin: -0.2, end: 0.2).animate(_animationController);

    return Hero(
      tag: GameTimeIsUpPage.heroTag,
      child: AnimatedBuilder(
        animation: rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: rotationAnimation.value,
            child: const StopwatchIcon(),
          );
        },
      ),
    );
  }
}

class GameTimeIsUpPageRouteBuilder<T> extends PageRouteBuilder<T> {
  GameTimeIsUpPageRouteBuilder({
    required WidgetBuilder builder,
    super.settings,
  }) : super(
          opaque: false,
          reverseTransitionDuration: animationDuration,
          transitionDuration: animationDuration,
          pageBuilder: (context, animation, secondaryAnimation) {
            return builder(context);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final begin = BoxDecoration(
              color: const Color(0xff000000).withOpacity(0),
            );
            final end = BoxDecoration(
              color: const Color(0xff000000).withOpacity(0.1),
            );

            final decorationCurvedAnimation =
                CurvedAnimation(parent: animation, curve: Curves.easeIn);
            final decorationTween = DecorationTween(begin: begin, end: end);
            final decorationAnimate =
                decorationTween.animate(decorationCurvedAnimation);

            return DecoratedBoxTransition(
              decoration: decorationAnimate,
              child: child,
            );
          },
        );

  static const animationDuration = Duration(seconds: 1);
}
