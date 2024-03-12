import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/widgets.dart';
import 'package:tiled/tiled.dart';
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
                size: Vector2(0.3, 0.6)..toGameSize(),
                anchor: Anchor.center,
              ),
            ),
            PlayerCollectingTrashBehavior(),
            PlayerDepositingTrashBehavior(),
            PlayerObstacleBehavior(),
            PlayerHintingBehavior(),
            PausingBehavior<Player>(
              selector: (player) => {
                ...player.findBehaviors<PlayerKeyboardMovingBehavior>(),
                ...player.findBehaviors<PlayerHintingBehavior>(),
              },
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
    with HasGameReference {
  _PlayerSpriteComponent()
      : super(
          position: Vector2(-0.4, -2.5)..toGameSize(),
          scale: Vector2.all(0.9),
        );

  final Map<Direction, Map<Direction, SpriteAnimation>> _animations = {};

  static final Map<(Direction, Direction), AssetGenImage> _animationSpriteMap =
      {
    (Direction.right, Direction.right): Assets.images.sprites.playerRightRight,
    (Direction.right, Direction.up): Assets.images.sprites.playerUpUp,
    (Direction.right, Direction.down): Assets.images.sprites.playerRightDown,
    (Direction.right, Direction.left): Assets.images.sprites.playerRightLeft,
    (Direction.up, Direction.right): Assets.images.sprites.playerUpRight,
    (Direction.up, Direction.up): Assets.images.sprites.playerUpUp,
    (Direction.up, Direction.down): Assets.images.sprites.playerUpDown,
    (Direction.up, Direction.left): Assets.images.sprites.playerUpLeft,
    (Direction.down, Direction.right): Assets.images.sprites.playerDownRight,
    (Direction.down, Direction.up): Assets.images.sprites.playerDownUp,
    (Direction.down, Direction.down): Assets.images.sprites.playerDownDown,
    (Direction.down, Direction.left): Assets.images.sprites.playerDownLeft,
    (Direction.left, Direction.right): Assets.images.sprites.playerLeftRight,
    (Direction.left, Direction.up): Assets.images.sprites.playerLeftUp,
    (Direction.left, Direction.down): Assets.images.sprites.playerLeftDown,
    (Direction.left, Direction.left): Assets.images.sprites.playerLeftLeft,
  };

  Direction _previousDirection = Direction.up;

  Future<SpriteAnimation> _createAnimation(AssetGenImage image) async {
    final spriteSheet = await game.images.load(image.path);
    const frameCount = 7;

    return SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: frameCount,
        stepTime:
            (PlayerMovingBehavior.moveDelay.inMilliseconds / 1000) / frameCount,
        textureSize: Vector2.all(256),
        loop: false,
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    for (final entry in _animationSpriteMap.entries) {
      final (startingDirection, endDirection) = entry.key;
      final image = entry.value;
      final spriteSheet = await _createAnimation(image);
      _animations[startingDirection] ??= {};
      _animations[startingDirection]![endDirection] = spriteSheet;
    }

    playing = false;
    animation = _animations[Direction.up]![Direction.up];
  }

  void hop(Direction direction) {
    animationTicker!.reset();
    animation = _animations[_previousDirection]![direction];
    _previousDirection = direction;
    playing = true;
  }
}

class _PlayerShadowSpriteComponent extends SpriteAnimationComponent
    with HasGameReference {
  _PlayerShadowSpriteComponent()
      : super(
          position: Vector2(-0.4, -2.5)..toGameSize(),
          scale: Vector2.all(1.8),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.fetchOrGenerate(
      Assets.images.sprites.playerHopShadow.path,
      () => game.images.load(Assets.images.sprites.playerHopShadow.path),
    );

    const frameCount = 7;

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: frameCount,
        amountPerRow: 3,
        textureSize: Vector2.all(128),
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
