import 'dart:async';

import 'package:flame/components.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

class TrashPlastic extends Trash {
  TrashPlastic._({required super.position})
      : super(
          trashType: TrashType.plastic,
          children: [
            TrashCollectionAnimator(
              // These have been eyeballed to sit correctly in the tiles.
              position: Vector2(0.5, 1.2)..toGameSize(),
              scale: Vector2.all(1.2),
              children: [
                _TrashPlasticShadowSpriteComponent(),
                _TrashPlasticSpriteComponent(),
              ],
            ),
          ],
        );

  /// Derives a [Trash] from a [TiledObject].
  factory TrashPlastic.fromTiledObject(TiledObject tiledObject) {
    return TrashPlastic._(
      position: Vector2(tiledObject.x, tiledObject.y)..snap(),
    );
  }
}

class _TrashPlasticSpriteComponent extends SpriteComponent
    with HasGameReference {
  _TrashPlasticSpriteComponent()
      : super(
          anchor: Anchor.center,
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(
      Assets.images.plasticBottle.path,
      images: game.images,
    );
  }
}

class _TrashPlasticShadowSpriteComponent extends SpriteComponent
    with HasGameReference {
  _TrashPlasticShadowSpriteComponent()
      : super(
          anchor: Anchor.center,
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load(
      Assets.images.plasticBottleShadow.path,
      images: game.images,
    );
  }
}
