import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

/// A bus that moves on the road.
///
/// Buses are larger vehicles that move on the road, they tend
/// to move slower than cars and are more difficult to avoid.
///
/// See also:
///
/// * [Vehicle], the base class for all vehicles.
class Bus extends Vehicle {
  Bus({required super.roadLane})
      : super(
          children: [
            _BusSpriteComponent(),
          ],
          hitbox: RectangleHitbox(
            isSolid: true,
            size: Vector2(2, 1)..convertToGameSize(),
          ),
        );
}

class _BusSpriteComponent extends SpriteComponent with HasGameReference {
  _BusSpriteComponent() : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(
      Assets.images.bus.path,
      images: game.images,
    );
  }
}
