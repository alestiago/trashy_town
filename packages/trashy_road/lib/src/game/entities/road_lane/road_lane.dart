import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

export 'behavior/behavior.dart';

/// {@template RoadLaneDirection}
/// The direction of the road lane.
/// {@endtemplate}
enum RoadLaneDirection {
  /// The road lane direction is horizontal, from west to east.
  leftToRight,

  /// The road lane direction is horizontal, from east to west.
  rightToLeft;

  /// Derives a direction from a boolean value.
  ///
  /// Used to decode a [RoadLaneDirection] from a Tiled extension property.
  factory RoadLaneDirection.fromBool({required bool isLeftToRight}) {
    if (isLeftToRight) {
      return RoadLaneDirection.leftToRight;
    } else {
      return RoadLaneDirection.rightToLeft;
    }
  }
}

/// {@template RoadLane}
/// A lane in the road.
///
/// Road lanes dictate how vehicles move and spawn in the game.
/// {@endtemplate}
class RoadLane extends PositionedEntity {
  RoadLane({
    required this.speed,
    required this.direction,
    required this.traffic,
  }) : super(
          behaviors: [VehicleSpawningBehavior()],
        );

  /// The speed of the vehicles in the lane.
  final double speed;

  /// {@macro RoadLaneDirection}
  final RoadLaneDirection direction;

  /// The amount of traffic in the lane.
  final double traffic;
}
