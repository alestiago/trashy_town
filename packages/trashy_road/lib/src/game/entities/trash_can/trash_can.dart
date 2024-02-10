import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behaviors/behaviors.dart';

/// A trash can.
///
/// Trash cans are placed around the map, they are used to dispose of trash.
class TrashCan extends Obstacle {
  TrashCan._({
    required Vector2 position,
  }) : super(
          position: _snapToGrid(position),
          priority: position.y.floor(),
          size: Vector2(1, 2)..multiply(GameSettings.gridDimensions),
          behaviors: [
            TrashCanFocusingBehavior(),
          ],
          children: [
            _TrashCanSpriteComponent(),
          ],
        );

  /// Derives a [TrashCan] from a [TiledObject].
  factory TrashCan.fromTiledObject(TiledObject tiledObject) {
    return TrashCan._(
      position: Vector2(tiledObject.x, tiledObject.y),
    );
  }

  /// Whether the trash can is focused.
  bool focused = false;
}

class _TrashCanSpriteComponent extends SpriteComponent with HasGameReference {
  _TrashCanSpriteComponent() : super();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite =
        await Sprite.load(Assets.images.trashCan.path, images: game.images);
  }
}

Vector2 _snapToGrid(Vector2 vector) {
  return (vector - (vector % GameSettings.gridDimensions))
    ..y -= GameSettings.gridDimensions.y * 2;
}
