import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/components/player/behaviors/behaviors.dart';
import 'package:trashy_road/src/game/model/map_bounds.dart';

class Player extends PositionComponent with KeyboardHandler, HasGameRef {
  Player({required Vector2 position, required MapBounds mapBounds})
      : super(
          anchor: Anchor.center,
          children: [
            CircleComponent(
              anchor: Anchor.center,
              radius: 10,
              paint: Paint()..color = const Color(0xFFFF0000),
            ),
            PlayerMovingBehavior(mapBounds: mapBounds),
            RectangleHitbox(
              size: Vector2(
                GameSettings.gridDimensions.x / 2,
                GameSettings.gridDimensions.y / 2,
              ),
              anchor: Anchor.center,
            ),
          ],
        ) {
    targetPosition = position;
  }

  late Vector2 targetPosition;

  @override
  FutureOr<void> onLoad() {
    position = targetPosition;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.lerp(targetPosition, 0.1);
  }
}
