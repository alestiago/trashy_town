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
abstract class Vehicle extends PositionedEntity with ParentIsA<RoadLane> {
  Vehicle({
    required ShapeHitbox hitbox,
    required this.roadLane,
    required super.children,
  }) : super(
          anchor: Anchor.topLeft,
          behaviors: [
            PropagatingCollisionBehavior(hitbox),
            VehicleRunningOverBehavior(),
            VehicleDrivingBehavior(),
            PausingBehavior<Vehicle>(
              selector: (vehicle) =>
                  vehicle.findBehaviors<VehicleDrivingBehavior>(),
            ),
          ],
        );
  final RoadLane roadLane;
}
