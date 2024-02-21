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
    super.children,
  }) : super(
          anchor: Anchor.bottomLeft,
          priority: position.y.floor(),
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox(
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

  Obstacle.tree({required Vector2 position})
      : this._(
          position: position,
          children: [_TreeSpriteGroup()],
        );

  factory Obstacle.fromTiledObject(TiledObject tiledObject) {
    final type = tiledObject.type;
    final position = Vector2(tiledObject.x, tiledObject.y);

    switch (type) {
      case 'tree':
        return Obstacle.tree(position: position);
      default:
        throw ArgumentError('Unknown obstacle type: $type');
    }
  }
}

class _TreeSpriteGroup extends PositionComponent {
  _TreeSpriteGroup()
      : super(
          size: Vector2.all(0.8)..toGameSize(),
          position: Vector2(-0.1, -0.1)..toGameSize(),
          scale: Vector2.all(0.8),
          children: [
            _TreeBodySpriteComponent(),
            _TreeShadowSpriteComponent(),
          ],
        );
}

class _TreeBodySpriteComponent extends SpriteComponent with HasGameRef {
  _TreeBodySpriteComponent() : super(anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(Assets.images.tree.path, images: game.images);
  }
}

class _TreeShadowSpriteComponent extends SpriteComponent with HasGameRef {
  _TreeShadowSpriteComponent() : super(anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(Assets.images.tree.path, images: game.images);
  }
}
