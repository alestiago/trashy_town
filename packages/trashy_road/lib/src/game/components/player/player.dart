import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:trashy_road/src/game/components/player/behaviors/behaviors.dart';

class Player extends PositionComponent with KeyboardHandler, HasGameRef {
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
            RectangleHitbox(size: Vector2(50, 50), anchor: Anchor.center),
          ],
        );
  Vector2 targetPosition = Vector2(moveDistance / 2, moveDistance / 2);

  static const moveDistance = 128;

  @override
  void update(double dt) {
    super.update(dt);

    position.lerp(targetPosition, 0.1);
  }
}
