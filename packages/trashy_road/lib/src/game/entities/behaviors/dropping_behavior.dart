import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

class DroppingBehavior extends Behavior with HasGameReference<TrashyRoadGame> {
  DroppingBehavior({
    required this.drop,
    required this.minDuration,
  });

  final Vector2 drop;

  final double minDuration;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final random = game.random;
    final duration = minDuration + random.nextDouble() * 0.5;
    parent.children.whereType<PositionComponent>().forEach((element) {
      element.add(_DropEffect(drop: drop, duration: duration));
    });
  }
}

class _DropEffect extends SequenceEffect {
  _DropEffect({
    required Vector2 drop,
    required double duration,
  }) : super(
          [
            MoveEffect.by(
              drop.clone(),
              EffectController(duration: 0),
            ),
            MoveEffect.by(
              drop.clone()..negate(),
              EffectController(duration: duration),
            ),
          ],
        );
}
