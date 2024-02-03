import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:trashy_road/src/game/components/player/behaviors/behaviors.dart';

class Player extends PositionComponent with KeyboardHandler, HasGameRef {
  Vector2 targetPosition = Vector2.zero();

  Player()
      : super(
          anchor: Anchor.center,
          children: [
            CircleComponent(
              anchor: Anchor.center,
              radius: 10,
              paint: Paint()..color = const Color(0xFFFF0000),
            ),
            PlayerMovingBehavior(),
          ],
        );

  @override
  void update(double dt) {
    position.lerp(targetPosition, 0.1);
    super.update(dt);
  }
}
