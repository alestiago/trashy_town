import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_noise/flame_noise.dart';
import 'package:trashy_road/src/game/game.dart';

final _random = Random(0);

/// Shakes the [Trash] around every now and then.
///
/// This is to catch the player's attention so they know that the [Trash] is
/// interactable and needs to be collected.
class TrashShakingBehavior extends Behavior<Trash> {
  final _shakeDistance = Vector2(10, 4);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(
      TimerComponent(
        repeat: true,
        period: 2 + _random.nextDouble() * 2,
        onTick: () {
          parent.add(
            MoveEffect.by(
              _shakeDistance,
              NoiseEffectController(
                noise: WhiteNoise(
                  seed: _random.nextInt(100),
                  frequency: 5,
                ),
                duration: 0.5,
              ),
            ),
          );
        },
      ),
    );
  }
}
