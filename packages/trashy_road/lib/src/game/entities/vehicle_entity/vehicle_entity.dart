import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/entities/vehicle_entity/behaviours/vehicle_hitting_player_behavior.dart';
import 'package:trashy_road/src/game/game.dart';

/// Base class for all vehicles
abstract class VehicleEntity extends PositionedEntity {
  VehicleEntity({
    required Vector2 size,
    required this.roadLane,
    required super.children,
  }) : super(
          position: roadLane.position.clone(),
          anchor: Anchor.topLeft,
          behaviors: [
            PropagatingCollisionBehavior(
              RectangleHitbox(
                size: size,
                isSolid: true,
              ),
            ),
            VehicleHittingPlayerBehavior(),
          ],
        );

  @override
  FutureOr<void> onLoad() {
    if (roadLane.direction == RoadLaneDirection.leftToRight) flipHorizontally();
    return super.onLoad();
  }

  final RoadLane roadLane;
}
