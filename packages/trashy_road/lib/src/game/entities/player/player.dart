import 'dart:async';
import 'dart:ui' as ui;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';
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
            _PlayerShadowSpriteComponent(),
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

  void hop(Direction direction) {
    final sprite = children.query<_PlayerSpriteComponent>().first;
    final shadow = children.query<_PlayerShadowSpriteComponent>().first;

    sprite.hop(direction);
    shadow.hop();
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

class _PlayerSpriteComponent extends SpriteAnimationComponent
    with HasGameReference {
  _PlayerSpriteComponent()
      : super(
          position: Vector2(-0.4, -2.5)..toGameSize(),
          scale: Vector2.all(0.45),
        );

  final Map<Direction, Map<Direction, SpriteAnimation>> _animations = {};
  Direction previousDirection = Direction.up;

  static final List<List<Direction>> animationDirectionOrder = [
    [Direction.right, Direction.right],
    [Direction.right, Direction.up],
    [Direction.right, Direction.down],
    [Direction.right, Direction.left],
    [Direction.up, Direction.right],
    [Direction.up, Direction.up],
    [Direction.up, Direction.down],
    [Direction.up, Direction.left],
    [Direction.down, Direction.right],
    [Direction.down, Direction.up],
    [Direction.down, Direction.down],
    [Direction.down, Direction.left],
    [Direction.left, Direction.right],
    [Direction.left, Direction.up],
    [Direction.left, Direction.down],
    [Direction.left, Direction.left],
  ];

  SpriteAnimation _createAnimation(ui.Image image, int row) {
    const frameCount = 7;
    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.range(
        amount: frameCount * animationDirectionOrder.length,
        amountPerRow: frameCount,
        textureSize: Vector2.all(512),
        start: row * frameCount,
        end: row * frameCount + frameCount - 1,
        stepTimes: List.filled(
          7,
          (PlayerMovingBehavior.moveDelay.inMilliseconds / 1000) / frameCount,
        ),
        loop: false,
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.fetchOrGenerate(
      Assets.images.playerHop.path,
      () => game.images.load(Assets.images.playerHop.path),
    );

    for (var i = 0; i < animationDirectionOrder.length; i++) {
      final [startingDirection, endDirection] = animationDirectionOrder[i];
      _animations[startingDirection] ??= {};
      _animations[startingDirection]![endDirection] = _createAnimation(
        image,
        i,
      );
    }
    playing = false;
    animation = _animations[Direction.up]![Direction.up];
  }

  void hop(Direction direction) {
    animationTicker!.reset();
    animation = _animations[previousDirection]![direction];
    previousDirection = direction;
    playing = true;
  }
}

class _PlayerShadowSpriteComponent extends SpriteAnimationComponent
    with HasGameReference {
  _PlayerShadowSpriteComponent()
      : super(
          position: Vector2(-0.4, -2.5)..toGameSize(),
          scale: Vector2.all(0.45),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.fetchOrGenerate(
      Assets.images.playerHopShadow.path,
      () => game.images.load(Assets.images.playerHopShadow.path),
    );

    const frameCount = 7;

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: frameCount,
        amountPerRow: 3,
        textureSize: Vector2.all(512),
        stepTime:
            (PlayerMovingBehavior.moveDelay.inMilliseconds / 1000) / frameCount,
        loop: false,
      ),
    );

    animationTicker!.onComplete = () {
      playing = false;
      animationTicker!.reset();
    };
  }

  void hop() {
    playing = true;
  }
}
