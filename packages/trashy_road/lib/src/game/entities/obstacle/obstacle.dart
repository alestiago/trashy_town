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
    super.children,
  }) : super(
          anchor: Anchor.bottomLeft,
          priority: position.y.floor(),
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox(
                isSolid: true,
                anchor: Anchor.topCenter,
                size: Vector2.all(0.8)..toGameSize(),
                position: Vector2(
                  // Designed for 1x1 tiles, if we need to support other sizes
                  // we need to adjust this to take the size into account.
                  GameSettings.gridDimensions.x / 2,
                  -GameSettings.gridDimensions.y,
                ),
              ),
            ),
          ],
        );

  // An Obstacle that is a tree.
  //
  // The tree takes up 1x1 tile space.
  Obstacle.tree({required Vector2 position})
      : this._(
          position: position,
          children: [_TreeSpriteGroup()],
        );

  // An Obstacle that is a fire hydrant.
  //
  // The fire hydrant takes up 1x1 tile space.
  Obstacle.fireHydrant({required Vector2 position})
      : this._(
          position: position,
          children: [_FireHydrantGroup()],
        );

  factory Obstacle.fromTiledObject(TiledObject tiledObject) {
    final type = tiledObject.type;
    final position = Vector2(tiledObject.x, tiledObject.y);

    switch (type) {
      case 'tree':
        return Obstacle.tree(position: position);
      case 'fire_hydrant':
        return Obstacle.fireHydrant(position: position);
      default:
        throw ArgumentError('Unknown obstacle type: $type');
    }
  }
}

class _TreeSpriteGroup extends PositionComponent {
  _TreeSpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          size: Vector2.all(0.8)..toGameSize(),
          position: Vector2(-0.1, -0.1)..toGameSize(),
          scale: Vector2.all(0.8),
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.treeShadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.tree.path,
            ),
          ],
        );
}

class _FireHydrantGroup extends PositionComponent {
  _FireHydrantGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          size: Vector2.all(1)..toGameSize(),
          position: Vector2(0.2, 0)..toGameSize(),
          scale: Vector2.all(1),
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.fireHydrantShadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.fireHydrant.path,
            ),
          ],
        );
}
