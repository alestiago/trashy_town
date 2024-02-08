import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:path/path.dart' as path;
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
            _BusSprite(),
          ],
          hitbox: RectangleHitbox(
            isSolid: true,
            size: Vector2(2, 1)..multiply(GameSettings.gridDimensions),
          ),
        );
}

class _BusSprite extends SpriteComponent {
  _BusSprite() : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(path.basename(Assets.images.bus.path));
  }
}
