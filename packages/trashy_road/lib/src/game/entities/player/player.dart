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
    final snappedPosition = _snapToGrid(objectPosition);

    return Player(
      position: snappedPosition,
    );
  }

  static Vector2 _snapToGrid(Vector2 vector) {
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
    with HasGameReference, ParentIsA<Player> {
  _PlayerSpriteComponent()
      : super(
          position: Vector2(-0.4, -2.5)..toGameSize(),
          scale: Vector2.all(0.45),
        );

  final Map<Direction, Map<Direction, SpriteAnimation>> _animations = {};

  static final List<List<Direction>> _animationDirectionOrder =
      List.unmodifiable([
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
  ]);

  Direction _previousDirection = Direction.up;

  /// The amount of frames in the player sprite sheet.
  static const _frameCount = 7;

  SpriteAnimation _createAnimation(ui.Image image, int row) {
    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.range(
        amount: _frameCount * _animationDirectionOrder.length,
        amountPerRow: _frameCount,
        textureSize: Vector2.all(512),
        start: row * _frameCount,
        end: row * _frameCount + _frameCount - 1,
        stepTimes: List.filled(
          7,
          (PlayerMovingBehavior.baseMoveTime.inMilliseconds / 1000) /
              _frameCount,
        ),
        loop: false,
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.fetchOrGenerate(
      Assets.images.sprites.playerHop.path,
      () => game.images.load(Assets.images.sprites.playerHop.path),
    );

    for (var i = 0; i < _animationDirectionOrder.length; i++) {
      final [startingDirection, endDirection] = _animationDirectionOrder[i];
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
    animation = _animations[_previousDirection]![direction];
    animation!.stepTime = parent.children
            .whereType<PlayerMovingBehavior>()
            .first
            .moveDelay
            .inMilliseconds /
        1000 /
        _frameCount;
    _previousDirection = direction;
    playing = true;
  }
}

class _PlayerShadowSpriteComponent extends SpriteAnimationComponent
    with HasGameReference, ParentIsA<Player> {
  _PlayerShadowSpriteComponent()
      : super(
          position: Vector2(-0.4, -2.5)..toGameSize(),
          scale: Vector2.all(0.45),
        );

  /// The amount of frames in the player shadow sprite sheet.
  static const _frameCount = 7;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.fetchOrGenerate(
      Assets.images.sprites.playerHopShadow.path,
      () => game.images.load(Assets.images.sprites.playerHopShadow.path),
    );

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: _frameCount,
        amountPerRow: 3,
        textureSize: Vector2.all(512),
        stepTime: (PlayerMovingBehavior.baseMoveTime.inMilliseconds / 1000) /
            _frameCount,
        loop: false,
      ),
    );

    animationTicker!.onComplete = () {
      playing = false;
      animationTicker!.reset();
    };
  }

  void hop() {
    animation!.stepTime = parent.children
            .whereType<PlayerMovingBehavior>()
            .first
            .moveDelay
            .inMilliseconds /
        1000 /
        _frameCount;
    playing = true;
  }
}
