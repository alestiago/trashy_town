import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/game.dart';

class Barrel extends TileBoundSpriteComponent {
  Barrel() : super(collidesWithPlayer: true);
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('barrel.png');
    add(
      RectangleHitbox(
        size: GameSettings.gridDimensions,
        position: Vector2(0, GameSettings.gridDimensions.y),
        isSolid: true,
      ),
    );
    return super.onLoad();
  }
}
