import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:meta/meta.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behaviors/behaviors.dart';

class PlayerSprite extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    anchor = const Anchor(0.5, 0.8);
    sprite = await Sprite.load(
      Assets.images.player.path,
      images: game.images,
    );
    return super.onLoad();
  }
}

class Player extends PositionedEntity {
  Player({super.position})
      : super(
          size: Vector2(1, 2)..multiply(GameSettings.gridDimensions),
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox(
                size: Vector2.all(1)
                  ..multiply(GameSettings.gridDimensions)
                  ..multiply(Vector2.all(0.8)), // make slightly smaller
                anchor: Anchor.center,
              ),
            ),
            PlayerKeyboardMovingBehavior.arrows(),
            PlayerCollectingTrashBehavior(),
            PlayerDepositingTrashBehavior(),
          ],
          children: [
            PlayerSprite(),
          ],
        );

  @visibleForTesting
  Player.test({super.behaviors});

  /// Derives a [Player] from a [TiledObject].
  ///
  /// The [TiledObject] must have a `type` of `spawn`, otherwise an
  /// [ArgumentError] is thrown.
  factory Player.fromTiledObject(TiledObject tiledObject) {
    if (tiledObject.type != 'spawn') {
      throw ArgumentError.value(
        tiledObject,
        'tiledObject',
        'The type of the TiledObject must be "spawn".',
      );
    }

    final objectPosition = Vector2(tiledObject.x, tiledObject.y);
    final snappedPosition = TileBoundSpriteComponent.snapToGrid(
      objectPosition,
      center: true,
    );

    return Player(
      position: snappedPosition,
    );
  }
}
