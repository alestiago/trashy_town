import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

class Obstacle extends PositionedEntity with Untraversable {
  Obstacle._({
    required Vector2 super.position,
    required String spritePath,
    required String shadowSpritePath,
    Vector2? spritePosition,
    Vector2? spriteScale,
  }) : super(
          anchor: Anchor.bottomLeft,
          priority: position.y.floor(),
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox(
                anchor: Anchor.topCenter,
                size: Vector2.all(0.8)..toGameSize(),
                position: Vector2(
                  // designed for 1x1 tiles, if we need to support other sizes
                  // we need to adjust this to take the size into account.
                  GameSettings.gridDimensions.x / 2,
                  -GameSettings.gridDimensions.y,
                ),
              ),
            ),
          ],
          children: [
            ObstacleSprite(
              scale: spriteScale ?? Vector2.all(1),
              position: spritePosition ?? Vector2.zero(),
              spritePath: shadowSpritePath,
            ),
            ObstacleSprite(
              scale: spriteScale ?? Vector2.all(1),
              position: spritePosition ?? Vector2.zero(),
              spritePath: spritePath,
            ),
          ],
        );

  factory Obstacle.treeFromTiledObject(TiledObject tiledObject) {
    return Obstacle._(
      position: Vector2(tiledObject.x, tiledObject.y),
      spritePath: Assets.images.tree.path,
      shadowSpritePath: Assets.images.treeShadow.path,
      spritePosition: Vector2(-0.1, -0.1)..toGameSize(),
      spriteScale: Vector2.all(0.8),
    );
  }
}

class ObstacleSprite extends SpriteComponent with HasGameRef {
  ObstacleSprite({
    required Vector2 super.scale,
    required Vector2 super.position,
    required this.spritePath,
  }) : super(anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(
      spritePath,
      images: game.images,
    );
  }

  final String spritePath;
}
