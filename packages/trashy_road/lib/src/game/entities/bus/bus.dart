import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:path/path.dart' as path;
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/gen/gen.dart';
import 'package:trashy_road/src/game/entities/bus/behaviours/bus_hitting_player_behavior.dart';

class BusSprite extends SpriteComponent with ParentIsA<Bus> {
  BusSprite();
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(path.basename(Assets.images.bus.path));

    add(
      RectangleHitbox(),
    );
    return super.onLoad();
  }
}

class Bus extends PositionedEntity {
  Bus({required this.leftToRight})
      : super(
          anchor: Anchor.topLeft,
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox(
                size: Vector2(2, 1)..multiply(GameSettings.gridDimensions),
                isSolid: true,
              ),
            ),
            BusHittingPlayerBehavior(),
          ],
          children: [
            BusSprite(),
          ],
        );

  @override
  FutureOr<void> onLoad() {
    if (leftToRight) flipHorizontally();
    return super.onLoad();
  }

  final bool leftToRight;
}
