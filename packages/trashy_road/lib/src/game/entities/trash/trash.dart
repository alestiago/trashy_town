import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';

/// A piece of trash.
///
/// Trash is usually scattered around the road and the player has to pick it up
/// to keep the map clean.
class Trash extends PositionedEntity {
  Trash._({
    required Vector2 position,
  }) : super(
          anchor: Anchor.bottomLeft,
          size: Vector2(1, 2)..toGameSize(),
          position: position..snap(),
          priority: position.y.floor(),
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox(
                size: GameSettings.gridDimensions,
                position: Vector2(0, GameSettings.gridDimensions.y),
              ),
            ),
          ],
          children: [
            _TrashSpriteComponent(),
          ],
        );

  /// Derives a [Trash] from a [TiledObject].
  factory Trash.fromTiledObject(TiledObject tiledObject) {
    return Trash._(
      position: Vector2(tiledObject.x, tiledObject.y)..snap(),
    );
  }
}

class _TrashSpriteComponent extends SpriteComponent with HasGameReference {
  _TrashSpriteComponent() : super();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load(Assets.images.trash.path, images: game.images);
  }
}
