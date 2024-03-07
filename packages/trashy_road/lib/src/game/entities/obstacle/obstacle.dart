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
    required RectangleHitbox hitbox,
    super.children,
  }) : super(
          anchor: Anchor.bottomLeft,
          priority: position.y.floor(),
          behaviors: [
            DroppingBehavior(
              drop: Vector2(0, -50),
              minDuration: 0.15,
            ),
            PropagatingCollisionBehavior(
              hitbox
                ..isSolid = true
                ..anchor = Anchor.bottomLeft,
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
          hitbox: RectangleHitbox(
            position: Vector2(0.1, 0)..toGameSize(),
            size: Vector2(0.8, 0.8)..toGameSize(),
          ),
          children: [_Tree1SpriteGroup()],
        );

  // An Obstacle that is a tree with three balls as the leaves.
  //
  // The tree takes up 1x1 tile space.
  Obstacle._tree2({required Vector2 position})
      : this._(
          position: position,
          hitbox: RectangleHitbox(
            position: Vector2(0.1, 0)..toGameSize(),
            size: Vector2(0.8, 0.8)..toGameSize(),
          ),
          children: [_Tree2SpriteGroup()],
        );

  // An Obstacle that is a fire hydrant.
  //
  // The fire hydrant takes up 1x1 tile space.
  Obstacle._fireHydrant({required Vector2 position})
      : this._(
          position: position,
          hitbox: RectangleHitbox(
            position: Vector2(0.25, 0)..toGameSize(),
            size: Vector2(0.5, 0.8)..toGameSize(),
          ),
          children: [_FireHydrantSpriteGroup()],
        );

  // An Obstacle that is a bush.
  //
  // The bush takes up 1x1 tile space.
  Obstacle._bush1({required Vector2 position})
      : this._(
          position: position,
          hitbox: RectangleHitbox(
            position: Vector2(0.1, 0)..toGameSize(),
            size: Vector2(0.8, 0.8)..toGameSize(),
          ),
          children: [_Bush1SpriteGroup()],
        );

  // An Obstacle that is a bush.
  //
  // The bush takes up 1x1 tile space and this variation is composed if four
  // small bushes.
  Obstacle._bush2({required Vector2 position})
      : this._(
          position: position,
          hitbox: RectangleHitbox(
            position: Vector2(0.1, 0)..toGameSize(),
            size: Vector2(0.8, 0.8)..toGameSize(),
          ),
          children: [_Bush2SpriteGroup()],
        );

  // An Obstacle that is a building.
  //
  // The building takes up a 2x3 tile space.
  Obstacle._building2({required Vector2 position})
      : this._(
          position: position,
          hitbox: RectangleHitbox(
            position: Vector2(0.1, -0.1)..toGameSize(),
            size: Vector2(1.8, 2.7)..toGameSize(),
          ),
          children: [_Building2SpriteGroup()],
        );

  // An Obstacle that is a building.
  //
  // The building takes up a 3x3 tile space.
  Obstacle._building3({required Vector2 position})
      : this._(
          position: position,
          hitbox: RectangleHitbox(
            position: Vector2(0.1, 0)..toGameSize(),
            size: Vector2(2.8, 2.8)..toGameSize(),
          ),
          children: [_Building3SpriteGroup()],
        );

  // An Obstacle that is a building.
  //
  // The building takes up a 3x3 tile space.
  Obstacle._building4({required Vector2 position})
      : this._(
          position: position,
          hitbox: RectangleHitbox(
            position: Vector2(0.25, -0.5)..toGameSize(),
            size: Vector2(1.5, 1.8)..toGameSize(),
          ),
          children: [_Building4SpriteGroup()],
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
      case 'bush_1':
        return Obstacle._bush1(position: position);
      case 'bush_2':
        return Obstacle._bush2(position: position);
      case 'building_2':
        return Obstacle._building2(position: position);
      case 'building_3':
        return Obstacle._building3(position: position);
      case 'building_4':
        return Obstacle._building4(position: position);
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
          position: Vector2(-0.2, 0.5)..toGameSize(),
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
          position: Vector2(-0.2, 0.5)..toGameSize(),
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

class _Bush1SpriteGroup extends PositionComponent {
  _Bush1SpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          size: Vector2.all(0.5)..toGameSize(),
          position: Vector2(0.12, -0.1)..toGameSize(),
          scale: Vector2.all(0.5),
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.bush1Shadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.bush1.path,
            ),
          ],
        );
}

class _Bush2SpriteGroup extends PositionComponent {
  _Bush2SpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          size: Vector2.all(0.5)..toGameSize(),
          position: Vector2(0.12, -0.1)..toGameSize(),
          scale: Vector2.all(0.5),
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.bush2Shadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.bush2.path,
            ),
          ],
        );
}

class _Building2SpriteGroup extends PositionedEntity {
  _Building2SpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          position: Vector2(-0.05, -0.1)..toGameSize(),
          behaviors: [
            PropagatingCollisionBehavior(
              /// This hitbox is for determining if the player is behind the
              /// sprite.
              RectangleHitbox(
                isSolid: true,
                size: Vector2(1, 5.45)..toGameSize(),
                position: Vector2(0.5, -0.3)..toGameSize(),
                anchor: Anchor.bottomLeft,
              ),
            ),
            HidingWhenPlayerBehind(),
          ],
          children: [
            GameSpriteComponent.fromPath(
              scale: Vector2(0.5, 0.65),
              position: Vector2(0, 0)..toGameSize(),
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.buildingShadow.path,
            ),
            GameSpriteComponent.fromPath(
              scale: Vector2.all(0.5),
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.building2.path,
            ),
          ],
        );
}

class _Building3SpriteGroup extends PositionedEntity {
  _Building3SpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          position: Vector2(-0.05, -0.1)..toGameSize(),
          behaviors: [
            PropagatingCollisionBehavior(
              /// This hitbox is for determining if the player is behind the
              /// sprite.
              RectangleHitbox(
                isSolid: true,
                size: Vector2(2.1, 8)..toGameSize(),
                position: Vector2(0.5, -0.4)..toGameSize(),
                anchor: Anchor.bottomLeft,
              ),
            ),
            HidingWhenPlayerBehind(),
          ],
          children: [
            GameSpriteComponent.fromPath(
              scale: Vector2.all(0.8),
              position: Vector2(-0.05, 0.12)..toGameSize(),
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.buildingShadow.path,
            ),
            GameSpriteComponent.fromPath(
              scale: Vector2.all(0.65),
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.building3.path,
            ),
          ],
        );
}

class _Building4SpriteGroup extends PositionedEntity {
  _Building4SpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          position: Vector2(-0.05, -0.1)..toGameSize(),
          behaviors: [
            PropagatingCollisionBehavior(
              /// This hitbox is for determining if the player is behind the
              /// sprite.
              RectangleHitbox(
                isSolid: true,
                size: Vector2(1.1, 5.6)..toGameSize(),
                position: Vector2(0.5, -0.7)..toGameSize(),
                anchor: Anchor.bottomLeft,
              ),
            ),
            HidingWhenPlayerBehind(),
          ],
          children: [
            GameSpriteComponent.fromPath(
              scale: Vector2.all(0.5),
              position: Vector2(0, 0.12)..toGameSize(),
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.buildingShadow.path,
            ),
            GameSpriteComponent.fromPath(
              scale: Vector2(0.35, 0.4),
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.building4.path,
            ),
          ],
        );
}
