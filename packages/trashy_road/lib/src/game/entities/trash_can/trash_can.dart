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

/// The different styles of [TrashCan].
enum TrashCanStyle {
  city._('city'),
  park._('park');

  const TrashCanStyle._(this.name);

  /// The [name] of the trash can variant in the Tiled map.
  final String name;

  @internal
  static TrashCanStyle? tryParse(String value) => _valueToEnumMap[value];

  static final _valueToEnumMap = <String, TrashCanStyle>{
    for (final value in TrashCanStyle.values) value.name: value,
  };
}

/// A trash can.
///
/// Trash cans are placed around the map, they are used to dispose of trash.
class TrashCan extends PositionedEntity with Untraversable, ZIndex {
  TrashCan._({
    required Vector2 position,
    required this.trashType,
    required Iterable<Component> children,
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
          children: children,
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

  TrashCan._organicPark({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.organic,
          children: [
            _TrashCanParkShadowSpriteComponent(),
            _TrashCanParkSpriteAnimationComponent._organic(),
          ],
        );

  TrashCan._plasticPark({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.plastic,
          children: [
            _TrashCanParkShadowSpriteComponent(),
            _TrashCanParkSpriteAnimationComponent._plastic(),
          ],
        );

  TrashCan._paperPark({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.paper,
          children: [
            _TrashCanParkShadowSpriteComponent(),
            _TrashCanParkSpriteAnimationComponent._paper(),
          ],
        );

  TrashCan._organic({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.organic,
          children: [
            _TrashCanShadowSpriteComponent(),
            _TrashCanSpriteAnimationComponent._organic(),
          ],
        );

  TrashCan._plastic({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.plastic,
          children: [
            _TrashCanShadowSpriteComponent(),
            _TrashCanSpriteAnimationComponent._plastic(),
          ],
        );

  TrashCan._paper({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.paper,
          children: [
            _TrashCanShadowSpriteComponent(),
            _TrashCanSpriteAnimationComponent._paper(),
          ],
        );

  /// Derives a [TrashCan] from a [TiledObject].
  factory TrashCan.fromTiledObject(TiledObject tiledObject) {
    final trashType = TrashType.tryParse(
      tiledObject.properties.getValue<String>('type') ?? '',
    );
    final variant = TrashCanStyle.tryParse(
      tiledObject.properties.getValue<String>('variant') ?? '',
    );
    final position = Vector2(tiledObject.x, tiledObject.y)..snap();

    // TODO(OlliePugh): this should probably use a style system instead of this
    switch (variant) {
      case TrashCanStyle.city:
        switch (trashType) {
          case TrashType.plastic:
            return TrashCan._plastic(position: position);
          case TrashType.organic:
            return TrashCan._organic(position: position);
          case TrashType.paper:
            return TrashCan._paper(position: position);
          case null:
            throw Exception('Invalid trash type: ${tiledObject.properties}');
        }

      case TrashCanStyle.park:
        switch (trashType) {
          case TrashType.plastic:
            return TrashCan._plasticPark(position: position);
          case TrashType.organic:
            return TrashCan._organicPark(position: position);
          case TrashType.paper:
            return TrashCan._paperPark(position: position);
          case null:
            throw Exception('Invalid trash type: ${tiledObject.properties}');
        }
      case null:
        throw Exception(
          'Invalid trash can style type: ${tiledObject.properties}',
        );
    }
  }

  /// Animates the [TrashCan] opening.
  void open() {
    children.whereType<Openable>().forEach((element) {
      element.open();
    });
  }

  /// The type of trash that the trash can accepts.
  final TrashType trashType;
}

class _TrashCanShadowSpriteComponent extends SpriteAnimationComponent
    with ParentIsA<TrashCan>, HasGameReference, Openable {
  _TrashCanShadowSpriteComponent()
      : super(
          scale: Vector2.all(0.7),
          position: Vector2(0.1, -0.6)..toGameSize(),
        ) {
    priority = 0;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.fetchOrGenerate(
      Assets.images.sprites.trashCanOpeningShadow.path,
      () => game.images.load(Assets.images.sprites.trashCanOpeningShadow.path),
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
    with HasGameReference, Openable {
  factory _TrashCanSpriteAnimationComponent._paper() {
    return _TrashCanSpriteAnimationComponent._(
      animationPath: Assets.images.sprites.trashCanPaperOpening.path,
    );
  }

  factory _TrashCanSpriteAnimationComponent._organic() {
    return _TrashCanSpriteAnimationComponent._(
      animationPath: Assets.images.sprites.trashCanOrganicOpening.path,
    );
  }

  factory _TrashCanSpriteAnimationComponent._plastic() {
    return _TrashCanSpriteAnimationComponent._(
      animationPath: Assets.images.sprites.trashCanPlasticOpening.path,
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

class _TrashCanParkShadowSpriteComponent extends SpriteAnimationComponent
    with ParentIsA<TrashCan>, HasGameReference, Openable {
  _TrashCanParkShadowSpriteComponent()
      : super(
          scale: Vector2.all(0.68),
          position: Vector2(0, -0.4)..toGameSize(),
          playing: false,
        ) {
    priority = 0;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.fetchOrGenerate(
      Assets.images.sprites.trashParkCanOpeningShadow.path,
      () => game.images
          .load(Assets.images.sprites.trashParkCanOpeningShadow.path),
    );

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 15,
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

class _TrashCanParkSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameReference, Openable {
  factory _TrashCanParkSpriteAnimationComponent._paper() {
    return _TrashCanParkSpriteAnimationComponent._(
      animationPath: Assets.images.sprites.trashParkCanPaperOpening.path,
    );
  }

  factory _TrashCanParkSpriteAnimationComponent._organic() {
    return _TrashCanParkSpriteAnimationComponent._(
      animationPath: Assets.images.sprites.trashParkCanOrganicOpening.path,
    );
  }

  factory _TrashCanParkSpriteAnimationComponent._plastic() {
    return _TrashCanParkSpriteAnimationComponent._(
      animationPath: Assets.images.sprites.trashParkCanPlasticOpening.path,
    );
  }

  _TrashCanParkSpriteAnimationComponent._({required this.animationPath})
      : super(
          // The `scale` and `position` have been eyeballed to make the trash
          // can align with the tiles.
          scale: Vector2.all(0.68),
          position: Vector2(0, -0.4)..toGameSize(),
          playing: false,
        );
  final String animationPath;

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
        amount: 15,
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

mixin Openable {
  bool playing = false;

  void open() {
    if (playing) return;
    playing = true;
  }
}
