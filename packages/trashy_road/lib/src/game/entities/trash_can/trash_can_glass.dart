import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

class TrashCanGlass extends TrashCan {
  TrashCanGlass._({
    required super.position,
  }) : super(
          trashType: TrashType.glass,
          children: [
            _TrashGlassSpriteComponent(),
          ],
        );

  /// Derives a [TrashCanGlass] from a [TiledObject].
  factory TrashCanGlass.fromTiledObject(TiledObject tiledObject) {
    return TrashCanGlass._(
      position: Vector2(tiledObject.x, tiledObject.y)..snap(),
    );
  }
}

class _TrashGlassSpriteComponent extends SpriteComponent with HasGameReference {
  _TrashGlassSpriteComponent() : super();

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
    sprite =
        await Sprite.load(Assets.images.trashCan.path, images: game.images);
  }
}
