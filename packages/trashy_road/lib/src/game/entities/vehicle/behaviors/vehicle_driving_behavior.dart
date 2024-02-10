import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/game_settings.dart';
import 'package:trashy_road/src/game/game.dart';

class VehicleDrivingBehavior extends Behavior<Vehicle> {
  VehicleDrivingBehavior();

  @override
  void update(double dt) {
    super.update(dt);

    final distanceCovered =
        parent.roadLane.speed * GameSettings.carSpeedMultiplier;
    final direction =
        parent.roadLane.direction == RoadLaneDirection.leftToRight ? 1 : -1;
    parent.position.x += distanceCovered * direction;
  }
}
