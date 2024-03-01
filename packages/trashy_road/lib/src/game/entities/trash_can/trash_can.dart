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
class TrashCan extends PositionedEntity with Untraversable, ZIndex {
  TrashCan._({
    required Vector2 position,
    required this.trashType,
    Iterable<Component>? children,
  }) : super(
          anchor: Anchor.bottomLeft,
          size: Vector2(1, 2)..toGameSize(),
          position: position..snap(),
          behaviors: [
            DroppingBehavior(
              drop: Vector2(0, -50),
              minDuration: 0.15,
            ),
            TrashCanDepositingBehavior(),
          ],
          children: [
            _TrashCanShadowSpriteComponent(),
            ...?children,
          ],
        ) {
    zIndex = position.y.floor();
    add(
      PropagatingCollisionBehavior(
        RectangleHitbox(
          isSolid: true,
          anchor: Anchor.topCenter,
          size: Vector2.all(0.8)..toGameSize(),
          position: Vector2(size.x / 2, size.y - GameSettings.gridDimensions.y),
        ),
      ),
    );
  }

  TrashCan._organic({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.organic,
          children: [_TrashCanSpriteAnimationComponent._organic()],
        );

  TrashCan._plastic({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.plastic,
          children: [_TrashCanSpriteAnimationComponent._plastic()],
        );

  TrashCan._paper({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.paper,
          children: [_TrashCanSpriteAnimationComponent._paper()],
        );

  /// Derives a [TrashCan] from a [TiledObject].
  factory TrashCan.fromTiledObject(TiledObject tiledObject) {
    final type = TrashType.tryParse(
      tiledObject.properties.getValue<String>('type') ?? '',
    );
    final position = Vector2(tiledObject.x, tiledObject.y)..snap();

    switch (type) {
      case TrashType.plastic:
        return TrashCan._plastic(position: position);
      case TrashType.organic:
        return TrashCan._organic(position: position);
      case TrashType.paper:
        return TrashCan._paper(position: position);
      case null:
        throw Exception('Invalid trash type: ${tiledObject.properties}');
    }
  }

  /// Animates the [TrashCan] opening.
  void open() {
    children.whereType<_TrashCanSpriteAnimationComponent>().first.open();
    children.whereType<_TrashCanShadowSpriteComponent>().first.open();
  }

  /// The type of trash that the trash can accepts.
  final TrashType trashType;
}

class _TrashCanShadowSpriteComponent extends SpriteAnimationComponent
    with ParentIsA<TrashCan>, HasGameReference {
  _TrashCanShadowSpriteComponent()
      : super(
          scale: Vector2.all(0.7),
          position: Vector2(0.1, -0.6)..toGameSize(),
        ) {
    priority = 0;
  }

  void open() {
    if (playing) return;
    playing = true;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.fetchOrGenerate(
      Assets.images.trashCanOpeningShadow.path,
      () => game.images.load(Assets.images.trashCanOpeningShadow.path),
    );

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 20,
        amountPerRow: 5,
        textureSize: Vector2.all(256),
        stepTime: 1 / 24,
        loop: false,
      ),
    );

    animationTicker!.onComplete = () {
      playing = false;
      animationTicker!.reset();
    };
  }
}

class _TrashCanSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameReference {
  factory _TrashCanSpriteAnimationComponent._paper() {
    return _TrashCanSpriteAnimationComponent._(
      animationPath: Assets.images.trashCanPaperOpening.path,
    );
  }

  factory _TrashCanSpriteAnimationComponent._organic() {
    return _TrashCanSpriteAnimationComponent._(
      animationPath: Assets.images.trashCanOrganicOpening.path,
    );
  }

  factory _TrashCanSpriteAnimationComponent._plastic() {
    return _TrashCanSpriteAnimationComponent._(
      animationPath: Assets.images.trashCanPlasticOpening.path,
    );
  }

  _TrashCanSpriteAnimationComponent._({required this.animationPath})
      : super(
          // The `scale` and `position` have been eyeballed to make the trash
          // can align with the tiles.
          scale: Vector2.all(0.7),
          position: Vector2(0.1, -0.6)..toGameSize(),
          playing: false,
        );
  final String animationPath;

  void open() {
    if (playing) return;
    playing = true;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.fetchOrGenerate(
      animationPath,
      () => game.images.load(animationPath),
    );

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 20,
        amountPerRow: 5,
        textureSize: Vector2.all(256),
        stepTime: 1 / 24,
        loop: false,
      ),
    );

    animationTicker!.onComplete = () {
      playing = false;
      animationTicker!.reset();
    };
  }
}
