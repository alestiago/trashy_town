import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

/// Allows a [Vehicle] to run over a [Player].
///
/// When the player is hit by the vehicle, it will lose the game.
class VehicleRunningOverBehavior extends CollisionBehavior<Player, Vehicle>
    with FlameBlocReader<GameBloc, GameState> {
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, Player other) {
    super.onCollisionStart(intersectionPoints, other);
    bloc.add(const GameResetEvent(reason: GameResetReason.vehicleRunningOver));
  }
}
