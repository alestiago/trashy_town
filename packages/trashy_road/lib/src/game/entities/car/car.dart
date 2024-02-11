import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

/// A car that moves on the road.
///
/// See also:
///
/// * [Vehicle], the base class for all vehicles.
class Car extends Vehicle {
  Car({required super.roadLane})
      : super(
          children: [
            _CarSpriteComponent(),
          ],
          hitbox: RectangleHitbox(
            isSolid: true,
            size: Vector2(1.3, 1)..toGameSize(),
          ),
        );
}

class _CarSpriteComponent extends SpriteComponent with HasGameReference {
  _CarSpriteComponent()
      : super(
          anchor: const Anchor(0, 0.3),
          paint: Paint()..filterQuality = FilterQuality.high,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(
      Assets.images.car.path,
      images: game.images,
    );
  }
}
