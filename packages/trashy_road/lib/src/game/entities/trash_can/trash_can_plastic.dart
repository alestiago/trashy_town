import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/game.dart';

class TrashCanPlastic extends TrashCan {
  TrashCanPlastic._({required super.position})
      : super(
          trashType: TrashType.plastic,
          children: [
            TrashCanPlasticSpriteComponent(),
          ],
        );

  /// Derives a [TrashCanGlass] from a [TiledObject].
  factory TrashCanPlastic.fromTiledObject(TiledObject tiledObject) {
    return TrashCanPlastic._(
      position: Vector2(tiledObject.x, tiledObject.y)..snap(),
    );
  }
}

class TrashCanPlasticSpriteComponent extends SpriteAnimationComponent
    with HasGameReference {
  TrashCanPlasticSpriteComponent()
      : super(
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
