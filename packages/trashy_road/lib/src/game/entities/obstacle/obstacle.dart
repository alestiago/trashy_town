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
  // The bush takes up 1x1 tile space and this variation is composed of four
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

  // An Obstacle that is a bench.
  //
  // The bench takes up 2x1 tile space
  Obstacle._bench({required Vector2 position})
      : this._(
          position: position,
          hitbox: RectangleHitbox(
            position: Vector2(0, -0.1)..toGameSize(),
            size: Vector2(1, 0.6)..toGameSize(),
          ),
          children: [_BenchSpriteGroup()],
        );

  // An Obstacle that is a lamp post.
  //
  // The lamp post takes up 1x2 tile space
  Obstacle._lampPost({required Vector2 position})
      : this._(
          position: position,
          hitbox: RectangleHitbox(
            position: Vector2(0.2, -0.1)..toGameSize(),
            size: Vector2(0.6, 0.6)..toGameSize(),
          ),
          children: [_LampPostSpriteGroup()],
        );

  // An Obstacle that is a bus stop.
  //
  // The lamp post takes up 1x2 tile space
  Obstacle._busStop({required Vector2 position})
      : this._(
          position: position,
          hitbox: RectangleHitbox(
            position: Vector2(0.2, -0.1)..toGameSize(),
            size: Vector2(0.6, 0.6)..toGameSize(),
          ),
          children: [_BusStopSpriteGroup()],
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
      case 'bench':
        return Obstacle._bench(position: position);
      case 'lamp_post':
        return Obstacle._lampPost(position: position);
      case 'bus_stop':
        return Obstacle._busStop(position: position);
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
              spritePath: Assets.images.sprites.tree1Shadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.tree1.path,
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
              spritePath: Assets.images.sprites.tree2Shadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.tree2.path,
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
              spritePath: Assets.images.sprites.fireHydrantShadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.fireHydrant.path,
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
              spritePath: Assets.images.sprites.bush1Shadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.bush1.path,
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
              spritePath: Assets.images.sprites.bush2Shadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.bush2.path,
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
              spritePath: Assets.images.sprites.buildingShadow.path,
            ),
            GameSpriteComponent.fromPath(
              scale: Vector2.all(0.5),
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.building2.path,
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
              spritePath: Assets.images.sprites.buildingShadow.path,
            ),
            GameSpriteComponent.fromPath(
              scale: Vector2.all(0.65),
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.building3.path,
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
              spritePath: Assets.images.sprites.buildingShadow.path,
            ),
            GameSpriteComponent.fromPath(
              scale: Vector2(0.35, 0.4),
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.building4.path,
            ),
          ],
        );
}

class _BenchSpriteGroup extends PositionComponent {
  _BenchSpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          position: Vector2(-0.13, -0.1)..toGameSize(),
          scale: Vector2.all(0.38),
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.benchShadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.bench.path,
            ),
          ],
        );
}

class _LampPostSpriteGroup extends PositionComponent {
  _LampPostSpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          position: Vector2(0.3, -0.1)..toGameSize(),
          scale: Vector2.all(0.6),
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.lampPostShadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.lampPost.path,
            ),
          ],
        );
}

class _BusStopSpriteGroup extends PositionComponent {
  _BusStopSpriteGroup()
      : super(
          // The `size`, `position` and `scale` have been eye-balled to fit with
          // the tile size.
          position: Vector2(0.3, -0.1)..toGameSize(),
          scale: Vector2.all(0.6),
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.busStopShadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.bottomLeft,
              spritePath: Assets.images.sprites.busStop.path,
            ),
          ],
        );
}
