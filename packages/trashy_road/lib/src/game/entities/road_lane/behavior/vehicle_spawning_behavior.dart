import 'dart:async';

import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// {@template VehicleSpawningBehavior}
/// Spawns vehicles in the road lane.
/// {@endtemplate}
class VehicleSpawningBehavior extends Behavior<RoadLane> {
  /// {@macro VehicleSpawningBehavior}
  VehicleSpawningBehavior();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    // TODO(alestiago): Intead of adding once, add vehicles at intervals.
    final vehicle = Bus(roadLane: parent);
    parent.add(vehicle);
  }
}
