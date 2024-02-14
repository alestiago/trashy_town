import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

class TrashCanPlastic extends TrashCan {
  TrashCanPlastic._({required super.position, required super.sprite})
      : super(
          trashType: TrashType.plastic,
        );

  /// Derives a [TrashCanGlass] from a [TiledObject].
  factory TrashCanPlastic.fromTiledObject(TiledObject tiledObject) {
    return TrashCanPlastic._(
      position: Vector2(tiledObject.x, tiledObject.y)..snap(),
      sprite: _TrashPlasticSpriteComponent(),
    );
  }
}

class _TrashPlasticSpriteComponent extends SpriteComponent
    with HasGameReference {
  _TrashPlasticSpriteComponent() : super();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(
      ColorEffect(
        Colors.red,
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
