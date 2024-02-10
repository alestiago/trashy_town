import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:trashy_road/game_settings.dart';
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

    final world = ancestors().whereType<TrashyRoadWorld>().first;

    for (var i = 0; i < parent.traffic; i++) {
      var startPosition = (i / parent.traffic) * world.tiled.size.x;

      startPosition *= GameSettings.minTrafficVariation +
          (world.random.nextDouble() * (1 - GameSettings.minTrafficVariation));

      if (parent.direction == RoadLaneDirection.rightToLeft) {
        startPosition *= -1;
      }

      parent.add(
        Bus(roadLane: parent)..position.x = startPosition,
      );
    }
  }

  @override
  void update(double dt) {
    final world = ancestors().whereType<TrashyRoadWorld>().first;
    final bounds = world.bounds;

    final vehicles = parent.children.whereType<Vehicle>();
    for (final vehicle in vehicles) {
      final isWithinBound =
          bounds.isPointInside(parent.position + vehicle.position);
      if (!isWithinBound) {
        vehicle.position.setAll(0);
      }
    }
  }
}
