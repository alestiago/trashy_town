import 'package:flutter/widgets.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

class TopHud extends StatelessWidget {
  const TopHud({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayingHudTransition(
      slideTween: Tween<Offset>(
        begin: const Offset(0, -1.2),
        end: Offset.zero,
      ),
      child: const _PaperBackground(
        child: Padding(
          padding: EdgeInsets.only(
            top: 24,
            bottom: 24,
            left: 32,
            right: 22,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GameStopwatch(),
              SizedBox(width: 24),
              PauseButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaperBackground extends StatelessWidget {
  const _PaperBackground({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Assets.images.display.paperBackgroundRectThin.provider(),
          fit: BoxFit.fill,
        ),
      ),
      child: child,
    );
  }
}
