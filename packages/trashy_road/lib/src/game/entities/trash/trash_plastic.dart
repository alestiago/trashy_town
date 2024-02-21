import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:tiled/tiled.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/assets.gen.dart';
import 'package:trashy_road/src/game/components/components.dart';
import 'package:trashy_road/src/game/game.dart';

class TrashPlastic extends Trash with HasGameReference<TrashyRoadGame> {
  TrashPlastic._({required super.position})
      : super(
          trashType: TrashType.plastic,
          children: [_PlasticBottleSpriteGroup()],
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
    children.register<_PlasticBottleSpriteGroup>();
  }

  @override
  void removeFromParent() {
    game.effectPlayer.play(AssetSource(Assets.audio.plasticBottle));
    children.query<_PlasticBottleSpriteGroup>().first.add(
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
class _PlasticBottleSpriteGroup extends PositionComponent {
  _PlasticBottleSpriteGroup()
      : super(
          // The `position` and `scale` have been eyeballed to match with the
          // appearance of the map.
          position: Vector2(0.5, 1.2)..toGameSize(),
          scale: Vector2.all(1.2),
          anchor: Anchor.center,
          children: [
            GameSpriteComponent.fromPath(
              anchor: Anchor.center,
              spritePath: Assets.images.plasticBottleShadow.path,
            ),
            GameSpriteComponent.fromPath(
              anchor: Anchor.center,
              spritePath: Assets.images.plasticBottle.path,
            ),
          ],
        );
}
