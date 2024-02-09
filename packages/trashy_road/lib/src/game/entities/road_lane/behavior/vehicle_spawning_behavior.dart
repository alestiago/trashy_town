import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/src/game/game.dart';

/// {@template VehicleSpawningBehavior}
/// Spawns vehicles in the road lane.
/// {@endtemplate}
class VehicleSpawningBehavior extends Behavior<RoadLane> with HasGameReference {
  /// {@macro VehicleSpawningBehavior}
  VehicleSpawningBehavior();

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    // TODO(alestiago): Intead of adding once, add vehicles at intervals.
    final vehicle = Bus(roadLane: parent);
    parent.add(vehicle);
  }

  @override
  void update(double dt) {
    final world = ancestors().whereType<TrashyRoadWorld>().first;
    final bounds = world.bounds;

    final vehicles = parent.children.whereType<Vehicle>();
    for (final vehicle in vehicles) {
      final isWithinBound = bounds.isPointInside(vehicle.position);
      if (!isWithinBound) {
        vehicle.position = vehicle.roadLane.position.clone();
      }
    }
  }
}
