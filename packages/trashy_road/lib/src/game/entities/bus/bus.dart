import 'dart:async';

import 'package:flame/components.dart';
import 'package:path/path.dart' as path;
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/game.dart';

class BusSprite extends SpriteComponent with ParentIsA<VehicleEntity> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(path.basename(Assets.images.bus.path));
    return super.onLoad();
  }
}

class Bus extends VehicleEntity {
  Bus({required super.roadLane})
      : super(
          children: [
            BusSprite(),
          ],
          size: Vector2(2, 1)..multiply(GameSettings.gridDimensions),
        );
}
