import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:meta/meta.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behaviors/behaviors.dart';

/// The different types of [Vehicle].
enum VehicleType {
  redCar._('car_red'),
  blueCar._('car_blue'),
  yellowCar._('car_yellow');

  const VehicleType._(this.name);

  /// The [name] of the vehicle type in the Tiled map.
  final String name;

  @internal
  static VehicleType? tryParse(String value) => _valueToEnumMap[value];

  static final _valueToEnumMap = <String, VehicleType>{
    for (final value in VehicleType.values) value.name: value,
  };
}

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
            DroppingBehavior(
              drop: Vector2(0, -75),
              minDuration: 0.2,
            ),
          ],
        );
  final RoadLane roadLane;
}
