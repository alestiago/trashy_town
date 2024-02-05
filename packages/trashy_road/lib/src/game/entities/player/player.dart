import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/painting.dart';
import 'package:trashy_road/config.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behaviors/behaviors.dart';

class Player extends PositionedEntity {
  Player({super.position})
      : super(
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox(
                size: Vector2(
                  GameSettings.gridDimensions.x / 2,
                  GameSettings.gridDimensions.y / 2,
                ),
                anchor: Anchor.center,
              ),
            ),
            PlayerKeyboardMovingBehavior.arrows(),
            PlayerCollectingTrashBehavior(),
          ],
          children: [
            CircleComponent(
              anchor: Anchor.center,
              radius: 10,
              paint: Paint()..color = const Color(0xFFFF0000),
            ),
          ],
        );

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
