import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/game/game.dart';

class VehicleDrivingBehavior extends Behavior<Vehicle> {
  VehicleDrivingBehavior();

  @override
  void update(double dt) {
    super.update(dt);

    // TODO(alestiago): Distance should be based on the vehicle/road speed:
    // https://github.com/alestiago/trashy_road/issues/3
    final distanceCovered =
        parent.roadLane.speed * GameSettings.carSpeedMultiplier;
    final direction =
        parent.roadLane.direction == RoadLaneDirection.leftToRight ? 1 : -1;
    parent.position.x += distanceCovered * direction;
  }
}
