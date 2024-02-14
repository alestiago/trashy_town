import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

class VehicleDrivingBehavior extends Behavior<Vehicle> {
  VehicleDrivingBehavior();

  /// The speed multiplier for the car.
  static const carSpeedMultiplier = 80;

  @override
  void update(double dt) {
    super.update(dt);

    final distanceCovered = parent.roadLane.speed * carSpeedMultiplier * dt;
    final direction =
        parent.roadLane.direction == RoadLaneDirection.leftToRight ? 1 : -1;
    parent.position.x += distanceCovered * direction;
  }
}
