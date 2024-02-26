import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

class Obstacle extends PositionedEntity with Untraversable, ZIndex {
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
        ) {
    zIndex = position.y.floor();
  }

  // An Obstacle that is a tree with a single large ball of leaves.
  //
  // The tree takes up 1x1 tile space.
  Obstacle._tree1({required Vector2 position})
      : this._(
          position: position,
          children: [_Tree1SpriteGroup()],
        );

  // An Obstacle that is a tree with three balls as the leaves.
  //
  // The tree takes up 1x1 tile space.
  Obstacle._tree2({required Vector2 position})
      : this._(
          position: position,
          children: [_Tree2SpriteGroup()],
        );

  // An Obstacle that is a fire hydrant.
  //
  // The fire hydrant takes up 1x1 tile space.
  Obstacle._fireHydrant({required Vector2 position})
      : this._(
          position: position,
          children: [_FireHydrantSpriteGroup()],
        );

  // An Obstacle that is a bush.
  //
  // The bush takes up 1x1 tile space.
  Obstacle._bush({required Vector2 position})
      : this._(
          position: position,
          children: [_BushSpriteGroup()],
        );

  factory Obstacle.fromTiledObject(TiledObject tiledObject) {
    final type = tiledObject.type;
    final position = Vector2(tiledObject.x, tiledObject.y);

    switch (type) {
      case 'tree_1':
        return Obstacle._tree1(position: position);
      case 'tree_2':
        return Obstacle._tree2(position: position);
      case 'fire_hydrant':
        return Obstacle._fireHydrant(position: position);
      case 'bush':
        return Obstacle._bush(position: position);
      default:
        throw ArgumentError('Unknown obstacle type: $type');
    }
  }
}

class _Tree1SpriteGroup extends PositionComponent {
  _Tree1SpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          size: Vector2.all(0.8)..toGameSize(),
          position: Vector2(-0.1, 0.5)..toGameSize(),
          scale: Vector2.all(0.8),
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.tree1Shadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.tree1.path,
            ),
          ],
        );
}

class _Tree2SpriteGroup extends PositionComponent {
  _Tree2SpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          size: Vector2.all(0.8)..toGameSize(),
          position: Vector2(-0.1, 0.5)..toGameSize(),
          scale: Vector2.all(0.8),
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.tree2Shadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.tree2.path,
            ),
          ],
        );
}

class _FireHydrantSpriteGroup extends PositionComponent {
  _FireHydrantSpriteGroup()
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

class _BushSpriteGroup extends PositionComponent {
  _BushSpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          size: Vector2.all(0.5)..toGameSize(),
          position: Vector2(0.12, -0.1)..toGameSize(),
          scale: Vector2.all(0.5),
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.bushShadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.bush.path,
            ),
          ],
        );
}
