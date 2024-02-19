import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

class TrashPlastic extends Trash {
  TrashPlastic._({required super.position})
      : super(
          trashType: TrashType.plastic,
          children: [_PlasticBottle()],
        );

  /// Derives a [Trash] from a [TiledObject].
  factory TrashPlastic.fromTiledObject(TiledObject tiledObject) {
    return TrashPlastic._(
      position: Vector2(tiledObject.x, tiledObject.y)..snap(),
    );
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    children.register<_PlasticBottle>();
  }

  @override
  void removeFromParent() {
    children.query<_PlasticBottle>().first.add(
          ScaleEffect.to(
            Vector2.zero(),
            EffectController(
              duration: 0.4,
              curve: Curves.easeInBack,
            ),
            onComplete: super.removeFromParent,
          ),
        );
  }
}

/// A plastic bottle.
///
/// Renders the plastic bottle and its shadow.
class _PlasticBottle extends PositionComponent {
  _PlasticBottle()
      : super(
          // The `position` has been eyeballed to match with the appearance of
          // the map.
          position: Vector2(0.5, 1.2)..toGameSize(),
          // The `scale` has been eyeballed to match with the appearance of the
          // map.
          scale: Vector2.all(1.2),
          anchor: Anchor.center,
          children: [
            _PlasticBottleShadow(),
            _PlasticBottleBody(),
          ],
        );
}

class _PlasticBottleBody extends SpriteComponent with HasGameReference {
  _PlasticBottleBody() : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(
      Assets.images.plasticBottle.path,
      images: game.images,
    );
  }
}

class _PlasticBottleShadow extends SpriteComponent with HasGameReference {
  _PlasticBottleShadow() : super(anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(
      Assets.images.plasticBottleShadow.path,
      images: game.images,
    );
  }
}
