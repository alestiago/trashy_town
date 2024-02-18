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
            _TrashPlasticShadowSpriteComponent(),
            _TrashPlasticSpriteComponent(),
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
          // eyeballed position
          scale: Vector2.all(0.8),
          position: Vector2(0.35, 0.1)..toGameSize(),
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
          // eyeballed position
          position: Vector2(0.25, -0.1)..toGameSize(),
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load(Assets.images.plasticBottleShadow.path,
        images: game.images);
  }
}
