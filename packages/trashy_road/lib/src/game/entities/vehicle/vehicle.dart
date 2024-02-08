import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behaviors/behaviors.dart';

/// A vehicle that moves along a [RoadLane].
///
/// See also:
///
/// * [VehicleSpawningBehavior], which is used to spawn vehicles on a
/// [RoadLane].
abstract class Vehicle extends PositionedEntity {
  Vehicle({
    required ShapeHitbox hitbox,
    required this.roadLane,
    required super.children,
  }) : super(
          anchor: Anchor.topLeft,
          position: roadLane.position.clone(),
          behaviors: [
            PropagatingCollisionBehavior(hitbox),
            VehicleRunningOverBehavior(),
            VehicleDrivingBehavior(),
          ],
        );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    if (roadLane.direction == RoadLaneDirection.leftToRight) {
      flipHorizontally();
    }
  }

  final RoadLane roadLane;
}
