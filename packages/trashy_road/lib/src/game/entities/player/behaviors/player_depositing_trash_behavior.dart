import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:trashy_road/src/game/game.dart';

/// Allows the [Player] to deposit [Trash] into a [TrashCan].
///
/// Depositing [Trash] will give the player points and remove the [Trash] from
/// the game.
class PlayerDepositingTrashBehavior extends CollisionBehavior<TrashCan, Player>
    with FlameBlocReader<GameBloc, GameState> {
  @override
  void onCollisionEnd(TrashCan other) {
    super.onCollisionEnd(other);

    if (other.hasBehavior<TrashCanDepositingBehavior>()) {
      other.findBehavior<TrashCanDepositingBehavior>().deposit();
    }
  }
}
