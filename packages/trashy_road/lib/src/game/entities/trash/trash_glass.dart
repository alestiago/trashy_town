import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

class TrashGlass extends Trash {
  TrashGlass._({required super.position, required super.sprite})
      : super(
          trashType: TrashType.glass,
        );

  /// Derives a [Trash] from a [TiledObject].
  factory TrashGlass.fromTiledObject(TiledObject tiledObject) {
    return TrashGlass._(
      position: Vector2(tiledObject.x, tiledObject.y)..snap(),
      sprite: _TrashGlassSpriteComponent(),
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
    sprite = await Sprite.load(Assets.images.trash.path, images: game.images);
  }
}
