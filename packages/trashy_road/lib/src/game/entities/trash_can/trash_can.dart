import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behaviors/behaviors.dart';

/// A trash can.
///
/// Trash cans are placed around the map, they are used to dispose of trash.
class TrashCan extends PositionedEntity with Untraversable {
  TrashCan._({
    required Vector2 position,
    required this.trashType,
    Iterable<Component>? children,
  }) : super(
          anchor: Anchor.bottomLeft,
          size: Vector2(1, 2)..toGameSize(),
          position: position..snap(),
          behaviors: [
            TrashCanDepositingBehavior(),
          ],
          children: [
            _TrashCanShadowSpriteComponent(),
            ...?children,
          ],
        ) {
    add(
      PropagatingCollisionBehavior(
        RectangleHitbox(
          anchor: Anchor.topCenter,
          size: Vector2.all(0.8)..toGameSize(),
          position: Vector2(size.x / 2, size.y - GameSettings.gridDimensions.y),
        ),
      ),
    );
  }

  TrashCan._glass({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.glass,
          children: [_GlassTrashSpriteGroup()],
        );

  TrashCan._plastic({required Vector2 position})
      : this._(
          position: position,
          trashType: TrashType.plastic,
          children: [PlasticTrashCanSpriteAnimationComponent()],
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
      case TrashType.glass:
        return TrashCan._glass(position: position);
      case null:
        throw Exception('Invalid trash type: ${tiledObject.properties}');
    }
  }

  /// The type of trash that the trash can accepts.
  final TrashType trashType;
}

class _TrashCanShadowSpriteComponent extends SpriteComponent
    with ParentIsA<TrashCan>, HasGameReference {
  _TrashCanShadowSpriteComponent()
      : super(position: Vector2(0.27, 0.5)..toGameSize()) {
    priority = 0;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(
      Assets.images.trashCanShadow.path,
      images: game.images,
    );
  }
}

// TODO(OlliePugh): Make it a SpriteGroup with the actual 3D renders of the
// model and its shadow.
class _GlassTrashSpriteGroup extends SpriteComponent with HasGameReference {
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(
      ColorEffect(
        Colors.green,
        EffectController(
          duration: 0,
        ),
        opacityTo: 0.5,
      ),
    );
    sprite = await Sprite.load(
      Assets.images.trashCan.path,
      images: game.images,
    );
  }
}

class PlasticTrashCanSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameReference {
  PlasticTrashCanSpriteAnimationComponent()
      : super(
          // The `scale` and `position` have been eyeballed to make the trash
          // can align with the tiles.
          scale: Vector2.all(1.25),
          position: Vector2(-0.1, -0.5)..toGameSize(),
          playing: false,
        );

  /// Animates the [TrashCan] opening.
  ///
  /// The opening animation is where the lid pops up and then comes backs down.
  ///
  /// Does nothing if already [playing].
  void open() {
    if (playing) return;
    playing = true;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(
      ColorEffect(
        Colors.red,
        EffectController(duration: 0),
        opacityTo: 0.5,
      ),
    );

    final image = await game.images.fetchOrGenerate(
      Assets.images.trashCanOpening.path,
      () => game.images.load(Assets.images.trashCanOpening.path),
    );

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 20,
        amountPerRow: 5,
        textureSize: Vector2.all(128),
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
