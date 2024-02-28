import 'package:flame/game.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

/// Allows the [Player] to collect [Trash].
///
/// Collecting [Trash] will add it to the player's inventory and remove it from
/// the game.
class PlayerCollectingTrashBehavior extends CollisionBehavior<Trash, Player>
    with FlameBlocReader<GameBloc, GameState> {
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, Trash other) {
    super.onCollisionStart(intersectionPoints, other);

    if (bloc.state.inventory.isFull) {
      return;
    }

    bloc.add(GameCollectedTrashEvent(item: other.trashType));
    other.removeFromParent();
  }
}
