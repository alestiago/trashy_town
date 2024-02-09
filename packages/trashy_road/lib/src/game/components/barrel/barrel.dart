import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

class Barrel extends TileBoundSpriteComponent
    with HasGameReference<TrashyRoadGame> {
  Barrel() : super(collidesWithPlayer: true);
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(
      Assets.images.barrel.path,
      images: game.images,
    );
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
