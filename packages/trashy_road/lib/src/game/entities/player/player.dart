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

class Player extends PositionedEntity with ZIndex {
  Player({super.position})
      : super(
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox(
                isSolid: true,
                size: Vector2(0.5, 0.8)..toGameSize(),
                anchor: Anchor.center,
              ),
            ),
            PlayerCollectingTrashBehavior(),
            PlayerDepositingTrashBehavior(),
            PlayerObstacleBehavior(),
            PausingBehavior<Player>(
              selector: (player) =>
                  player.findBehaviors<PlayerKeyboardMovingBehavior>(),
            ),
          ],
          children: [
            _PlayerSpriteComponent(),
          ],
        );

  @visibleForTesting
  Player.empty();

  /// Derives a [Player] from a [TiledObject].
  ///
  /// The [TiledObject] must have a `type` of `player`, otherwise an
  /// [ArgumentError] is thrown.
  factory Player.fromTiledObject(TiledObject tiledObject) {
    if (tiledObject.type != 'player') {
      throw ArgumentError.value(
        tiledObject,
        'tiledObject',
        'The type of the TiledObject must be "player".',
      );
    }

    final objectPosition = Vector2(tiledObject.x, tiledObject.y);
    final snappedPosition = snapToGrid(objectPosition);

    return Player(
      position: snappedPosition,
    );
  }

  static Vector2 snapToGrid(Vector2 vector) {
    return vector -
        (vector % GameSettings.gridDimensions) +
        (GameSettings.gridDimensions / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    zIndex = position.y.floor();
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    await addAll(
      [
        PlayerMovingBehavior(),
        PlayerKeyboardMovingBehavior.arrows(),
        PlayerKeyboardMovingBehavior.wasd(),
        PlayerDragMovingBehavior(),
      ],
    );
  }
}

class _PlayerSpriteComponent extends SpriteComponent with HasGameReference {
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
