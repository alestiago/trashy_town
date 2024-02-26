import 'package:basura/basura.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:trashy_road/src/game/game.dart';
import 'package:trashy_road/src/game/widgets/hud_pause_button.dart';

/// {@template Hud}
/// A heads-up display that shows information about the game.
///
/// Precisely it informs the user about:
///
/// * The current level.
/// * The amount of trash in the inventory.
/// * The time left to to complete the level with stars.
///
/// It also has a button to pause the game.
/// {@endtemplate}
class Hud extends StatelessWidget {
  /// {@macro Hud}
  const Hud({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -15),
      child: const BasuraGlossyButton(
        child: Padding(
          padding: EdgeInsets.only(
            top: 15 + 11,
            left: 22,
            right: 22,
          ),
          child: SizedBox(
            height: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HudProgressBar(),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HudLevelIndicator(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: HudInventoryTrashCounters(),
                    ),
                    HudPauseButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HudProgressBar extends StatelessWidget {
  const HudProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BasuraColors.deepCadmiumYellow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 15,
        width: 200,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1, end: 0),
          duration: const Duration(seconds: 10),
          builder: (context, value, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Container(
                  color: BasuraColors.lightCadmiumYellow,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
